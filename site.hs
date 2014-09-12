--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid ((<>))
import           Control.Monad ((>=>))
import           Hakyll
import           Text.Pandoc.Definition
import           Text.Pandoc.Options
import           Text.Pandoc.Shared (headerShift)
import           Text.Pandoc.Walk (walk)
import           Text.Hyphenation
import           Text.Regex.TDFA (getAllMatches, (=~), MatchOffset, MatchLength)
import           Data.Ord (comparing)
import           Data.List (intercalate, isPrefixOf, isSuffixOf, sort, sortBy, (\\))
import           Data.Char (chr)
import qualified Data.Map.Strict as M
import           System.FilePath (dropExtension, replaceExtension)
import           System.Directory (getDirectoryContents)
import           Control.Applicative (Alternative (..))

--------------------------------------------------------------------------------

-- since we use <h1> for the post title, increment the other headers by one
myPandocPostCompiler = makePandocCompiler (headerShift 1)
myPandocCompiler = makePandocCompiler id

makePandocCompiler extraTransform = pandocCompilerWithTransform
    (defaultHakyllReaderOptions {
        readerSmart = True -- convert "..." to proper ellipsis, etc.
    })
    (defaultHakyllWriterOptions {
        writerHTMLMathMethod = MathJax "",
	writerHtml5 = True,
	writerSectionDivs = True -- wrap sections in HTML5 <section> tags
    })
    (walk insertHyphenation      -- since HTML+CSS still can't hyphenate in 2014
     . walk useAltAsDefaultTitle -- use 'alt' text as 'title' if no 'title' is given
     . extraTransform)

useAltAsDefaultTitle :: Inline -> Inline
useAltAsDefaultTitle original@(Link alt (target, title))
    | title /= "" = original
    | otherwise   = Link alt (target, concatMap plain alt)
useAltAsDefaultTitle original@(Image alt (target, title))
    | title /= "fig:" = original
    | otherwise       = Image alt (target, "fig:" ++ concatMap plain alt)
useAltAsDefaultTitle x = x

plain :: Inline -> String
plain (Str s) = s
plain (Emph ss) = concatMap plain ss
plain (Strong ss) = concatMap plain ss
plain (Strikeout ss) = concatMap plain ss
plain (Superscript ss) = concatMap plain ss
plain (Subscript ss) = concatMap plain ss
plain (SmallCaps ss) = concatMap plain ss
plain (Quoted _ ss) = concatMap plain ss
plain (Cite _ ss) = concatMap plain ss
plain (Code _ s) = s
plain Space = " "
plain LineBreak = " "
plain (Math _ s) = s
plain (RawInline _ s) = s
plain (Link alt _) = concatMap plain alt
plain (Image alt _) = concatMap plain alt
plain (Note _) = ""

insertHyphenation :: Inline -> Inline
insertHyphenation (Str s) = Str $ softHyphenate s
insertHyphenation (Code attr s) = Code attr $ breakIdentifiers s
insertHyphenation x = x

softHyphenate :: String -> String
softHyphenate = intercalate softHyphen . preventDoubleHyphens . hyphenate english_US
  where softHyphen = [chr 173]
        preventDoubleHyphens (s1:s2:ss) | "-" `isSuffixOf` s1 = preventDoubleHyphens ((s1 ++ s2):ss)
        preventDoubleHyphens (s:ss) = s:preventDoubleHyphens ss
        preventDoubleHyphens [] = []

breakIdentifiers :: String -> String
breakIdentifiers s = intercalate zeroWidthSpace $ splitAtAll (map matchEnd matches) s
  where pattern = "[^[:space:]_./]+[_./]+" :: String
        matches = getAllMatches $ s =~ pattern :: [(MatchOffset, MatchLength)]
        matchEnd (offset, length) = offset + length
        zeroWidthSpace = [chr 8203]

splitAtAll :: [Int] -> [a] -> [[a]]
splitAtAll is xs = go 0 is xs
  where go offset []     xs = [xs]
        go offset (i:is) xs = before : go i is after
          where (before, after) = splitAt (i - offset) xs

--------------------------------------------------------------------------------

main :: IO ()
main = do
  adjacentPostLinks <- createAdjacentPostLinks

  let aboutContext = constField "about" "yes" <>
                     defaultContext
  let publicationsContext = constField "publications" "yes" <>
                            defaultContext
  let programmingContext = constField "programming" "yes" <>
                           defaultContext
  let blogContext = constField "blog" "yes" <>
                    dateField "date" "%e %B %Y" <>
                    dateField "isoDate" "%0Y-%m-%d" <>
                    adjacentPostLinks <>
                    defaultContext

  hakyll $ do
    match (anyGlob ["images/*", "publications/*", "programming/*"]) $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match "about.md" $ do
        route   directoryRoute
        compile $ myPandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" aboutContext
            >>= relativizeUrls

    match "publications.md" $ do
        route   directoryRoute
        compile $ myPandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" publicationsContext
            >>= relativizeUrls

    match "projects/*" $ compile myPandocCompiler
    create ["programming.html"] $ do
        route directoryRoute
        compile $ do
            projects <- return . sortBy (comparing itemIdentifier)
                    =<< loadAll "projects/*.md"
            let projectsContext =
                    listField "projects" defaultContext (return projects) <>
                    programmingContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/projects.html" projectsContext
                >>= loadAndApplyTemplate "templates/default.html" projectsContext
                >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ myPandocPostCompiler
            >>= saveSnapshot "postContent"
            >>= loadAndApplyTemplate "templates/post.html" blogContext
            >>= loadAndApplyTemplate "templates/default.html" blogContext
            >>= relativizeUrls
            >>= saveSnapshot "finalizedPost"
  
    create ["rss.xml"] $ do
        route idRoute
        compile $ do
            snapshots <- recentFirst =<< loadAllSnapshots "posts/*" "postContent"
            let teaserContext = teaserField "teaser" "postContent" <> blogContext
            let feedEntry = loadAndApplyTemplate "templates/feed-post.html" teaserContext
                        >=> externalizeUrls
            let feedContext = bodyField "description" <> blogContext
            posts <- mapM feedEntry snapshots
            renderRss myFeedConfiguration feedContext posts

    create ["posts.html"] $ do
        route directoryRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveContext =
                    listField "posts" blogContext (return posts) <>
                    constField "archive" "yes"                   <>
                    blogContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveContext
                >>= loadAndApplyTemplate "templates/default.html" archiveContext
                >>= relativizeUrls

    create ["index.html"] $ do
        route idRoute
        compile $ do
          latestPost <- fmap head . recentFirst =<< loadAllSnapshots "posts/*" "finalizedPost"
          makeItem (itemBody latestPost) :: Compiler (Item String)

    match "templates/*" $ compile templateCompiler
  where
    anyGlob = foldr1 (.||.) . map fromGlob
    directoryRoute = customRoute $
      (++ "/index.html") . dropExtension . toFilePath

--------------------------------------------------------------------------------

myFeedConfiguration :: FeedConfiguration
myFeedConfiguration = FeedConfiguration
    { feedTitle       = "DirkGerrits.com"
    , feedDescription = "Personal blog of Dirk Gerrits"
    , feedAuthorName  = "Dirk Gerrits"
    , feedAuthorEmail = "dirk.gerrits@gmail.com"
    , feedRoot        = "http://dirkgerrits.com"
    }

externalizeUrls :: Item String -> Compiler (Item String)
externalizeUrls = return . fmap (withUrls externalizeUrl)
  where externalizeUrl url = if isExternal url then url
                             else (feedRoot myFeedConfiguration) ++ url

unexternalizeUrls :: Item String -> Compiler (Item String)
unexternalizeUrls = return . fmap (withUrls unexternalizeUrl)
  where unexternalizeUrl url = removePrefix (feedRoot myFeedConfiguration) url
        removePrefix prefix str = if prefix `isPrefixOf` str
                                   then str \\ prefix
                                   else str

createAdjacentPostLinks :: IO (Context String)
createAdjacentPostLinks = do
  postFiles <- return . sort . filter isProper =<< getDirectoryContents "posts"
  let postIdentifiers = map (fromFilePath . ("posts/" ++)) postFiles
  let postUrls = map (\p -> "/posts/" ++ replaceExtension p ".html") postFiles
  let nextMap = M.fromList $ zip postIdentifiers (tail postUrls)
  let previousMap = M.fromList $ zip (tail postIdentifiers) postUrls
  return $ mapField "nextPost" nextMap <>
           mapField "previousPost" previousMap

isProper :: FilePath -> Bool
isProper x = not ("." `isPrefixOf` x || "~" `isSuffixOf` x)

mapField :: String -> M.Map Identifier String -> Context a
mapField key map = field key $ \item -> 
  let value = M.lookup (itemIdentifier item) map
  in maybe empty return value

postCtx :: Context String
postCtx =
    dateField "date" "%e %B %Y" <>
    dateField "isoDate" "%0Y-%m-%d" <>
    defaultContext
