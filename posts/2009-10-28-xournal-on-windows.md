---
title: Xournal on Windows
---

![Screenshot of Xournal running natively on Windows Vista](/images/xournal-on-windows.png "Xournal on Windows")

[Xournal](http://xournal.sourceforge.net/) is a free software
note-taking application similar to Microsoft Windows Journal. It used
to be Linux-only, with MacOS and Windows ports on the TODO list. But
as you can see it is now possible to run it on Windows. Hopefully a
nice installer can be created for it, like the ones for
[Inkscape](http://inkscape.org/) and [Gimp](http://gimp.org/), but for
now the process is rather tricky and involves editing and compiling
Xournal's source code.

<!--more-->

**Update:** Denis Auroux, the author of Xournal, has graciously
incorporated my code changes into Xournal and made an official Windows
release available on the [Xournal
homepage](http://xournal.sourceforge.net/). Go try it out!

Here's what I did:

## Step 1: Setting up the development environment

We'll need to set-up a compiler and install all the libraries that
Xournal uses (directly or indirectly) before we can compile its source
code. Here are the software packages I installed with their version
numbers (newer versions will probably work, significantly older versions
might not), website addresses (I'd provide direct download links, but
they'll probably end up as dead links as soon as version numbers
change), and where I installed them (of course, you'll probably want to
use different paths, unless your name is also Dirk):

MinGW + MSys, a minimalist Unix-like environment for Windows, for the C
compiler and other build tools. These can be gotten from
[MinGW.org](http://sourceforge.net/projects/mingw/files/):

-   MinGW 5.1.4 (into `c:/Users/Dirk/Programming/MinGW`)

-   MSys 1.0.11 (into `c:/Users/Dirk/Programming/msys`)

-   perl 5.6.1\_2-1 (into `c:/Users/Dirk/Programming/msys/1.0`)

-   libcrypt 1.1\_1-2 (into `c:/Users/Dirk/Programming/msys/1.0`)

-   autoconf 2.63-1 (into `c:/Users/Dirk/Programming/msys/1.0`)

-   automake 1.11-1 (into `c:/Users/Dirk/Programming/msys/1.0`)

Some Gtk+ and GNOME libraries that Xournal uses for its GUI. These can
be gotten from [Gtk.org](http://www.gtk.org/download/win32.php):

-   Gtk+ 2.16.5-20090731 development bundle (into `c:/`...`/MinGW`)

-   Cairo 1.8.8-2 binary+dev package (into `c:/`...`/MinGW`, overwriting
    the one from the bundle because the latter is apparently built
    without FreeType support)

-   FreeType 2.3.9-1 binary+dev package (into `c:/`...`/MinGW`)

-   fontconfig 2.7.1-2 binary+dev package (into `c:/`...`/MinGW`)

-   win\_iconv 20080320 binary+dev package (into `c:/`...`/MinGW`)

[GNOME.org](http://ftp.gnome.org/pub/gnome/binaries/win32/):

-   libgnomecanvas 2.20.1 binary+dev package (into `c:/`...`/MinGW`)

-   libgnomeprintui 2.12.1 binary+dev package (into `c:/`...`/MinGW`)

-   libgnomeprint 2.12.1 binary+dev package (into `c:/`...`/MinGW`)

-   libart\_lgpl 2.3.20 binary+dev package (into `c:/`...`/MinGW`)

and more
[GNOME.org](http://ftp.gnome.org/pub/gnome/binaries/win32/dependencies/):

-   libxml 2.7.3 binary+dev package (into `c:/`...`/MinGW`)

-   expat 2.0.1-1 binary package (into `c:/`...`/MinGW`)

We have to make a small change in the file
`C:/Users/Dirk/Programming/MinGW/lib/pkgconfig/libgnomeprint-2.2.pc`,
replacing "pango" by "pangoft2" on the "Requires:" line so that in
now reads:

```
Requires: libart-2.0 glib-2.0 gmodule-2.0 gobject-2.0 libxml-2.0 pangoft2
```

## Step 2: Building libpoppler from source

The above gave us all the libraries Xournal needs, except for
[Poppler](http://poppler.freedesktop.org/). I haven't seen a
pre-compiled binary version for Windows, so we'll have to build it
ourselves. We simply download the [Poppler source
code](http://poppler.freedesktop.org/), start MSys, `cd` into the
directory where we unpacked the source code, and type:

```bash
$ export ACLOCAL_FLAGS=-I/c/Users/Dirk/Programming/MinGW/share/aclocal/
$ ./configure --prefix=/c/Users/Dirk/Programming/MinGW/
$ make
$ make install
```

(Don't type the dollar signs, they just indicate the MSys prompt.)

## Step 3: Removing Xournal's screenshot function

Once we've downloaded Xournal's source code from the [Xournal
website](http://xournal.sourceforge.net/), we can't immediately compile
it for Windows. Xournal has one bit of functionality that's not
implemented with the cross-platform Gtk+ library, but instead is
implemented directly using [X](http://www.x.org/). This will of course
not work on different platforms such as Windows.

The functionality in question is in the menu under "Journal \>
Background screenshot". On Linux, it hides the Xournal window, then when
you click anywhere it'll bring back the Xournal window with an added
screenshot of whatever window you clicked on. There is no way to
implement this "clicking on a window"-mechanic in the Windows API, so a
proper fix would be to change the mechanic to something different, as
the Gimp guys have done. There one *drags* a crosshair onto a window.

I have not taken the effort to actually implement this different
screenshot mechanic, as I don't use it and it's a lot easier to just
remove it:

-   In `src/xo-misc.c` in the function `hide_unimplemented` at the
    bottom of the file add the lines

    ```c
    #ifdef WIN32
      gtk_widget_hide(GET_COMPONENT("journalScreenshot"));  
    #endif
    ```

-   In `src/xo-file.c` at the top of the file, disable the X-specific
    `#include`s under Windows:

    ```c
    #ifndef WIN32
    #  include <gdk/gdkx.h>
    #  include <x11/Xlib.h>
    #endif
    ```

-   In the same file, replace the body of the `attempt_screenshot_bg`
    function to do nothing on Windows:

    ```c
    struct Background *attempt_screenshot_bg(void)
    {
    #ifndef WIN32
      ... old body here ...
    #else /* WIN32 */
      return NULL;
    #endif
    }
    ```

## Step 4: Building Xournal from source

To build Xournal, we just use MSys as before, and inside the `xournal`
directory type the following:

```bash
$ export ACLOCAL_FLAGS=-I/c/Users/Dirk/Programming/MinGW/share/aclocal/
$ ./autogen.sh
$ make
```

## Step 5: Running Xournal

To run Xournal we can type

```bash
$ src/xournal
```

or just double-click `src/xournal.exe` in Windows's explorer.

If all went well, you'll see that Xournal "works", but has some bugs.
I'll describe below how each of these can be fixed by editing
Xournal's source code. Recompiling (that is, repeating Step 4) will
then give you a truly working Xournal. If you don't want to manually
apply all my fixes, you can just download [the resulting source
code](/programming/xournal-fixed-source.zip).

## Bug 1: The cursor is a big black square

![Cursor is a black square and loading/saving doesn't
work.](/images/xournal-bugs.png "Xournal bugs")

For the pen and highlighter tools, you'll notice that the cursor is
always a 16×16 black square, regardless of the selected color. This is a
defect in GDK's Windows backend ([Bug
541377](http://bugzilla.gnome.org/show_bug.cgi?id=541377)). The function
`gdk_cursor_new_from_pixmap`, which Xournal uses, will only give you
monochrome cursors on Windows, and produces strange results when trying
to produce a colored cursor.

While this should be fixed on the GDK end, a workaround is to just use
different functions from GDK to create colored cursors. This can be done
by putting the following code near the top in `src/xo-paint.c`:

```c
#ifdef WIN32
gboolean colors_too_similar(const GdkColor *colora,
                            const GdkColor *colorb)
{
  return (abs(colora->red - colorb->red) < 256 &&
          abs(colora->green - colorb->green) < 256 &&
          abs(colora->blue - colorb->blue) < 256);
}

/* gdk_cursor_new_from_pixmap is broken on Windows.
   this is a workaround using gdk_cursor_new_from_pixbuf. */
GdkCursor* fixed_gdk_cursor_new_from_pixmap(
    GdkPixmap *source, GdkPixmap *mask, const GdkColor *fg,
    const GdkColor *bg, gint x, gint y) 
{
  GdkPixmap *rgb_pixmap;
  GdkGC *gc;
  GdkPixbuf *rgb_pixbuf, *rgba_pixbuf;
  GdkCursor *cursor;
  int width, height;

  /* HACK!  It seems impossible to work with RGBA pixmaps directly in
     GDK-Win32.  Instead we pick some third color, different from fg
     and bg, and use that as the 'transparent color'.  We do this using
     colors_too_similar (see above) because two colors could be
     unequal in GdkColor's 16-bit/sample, but equal in GdkPixbuf's
     8-bit/sample. */
  GdkColor candidates[3] = {{0,65535,0,0}, {0,0,65535,0}, {0,0,0,65535}};
  GdkColor *trans = &candidates[0];
  if (colors_too_similar(trans, fg) || colors_too_similar(trans, bg)) {
    trans = &candidates[1];
    if (colors_too_similar(trans, fg) || colors_too_similar(trans, bg)) {
      trans = &candidates[2]; 
    }
  } /* trans is now guaranteed to be unique from fg and bg */

  /* create an empty pixmap to hold the cursor image */
  gdk_drawable_get_size(source, &width, &height);
  rgb_pixmap = gdk_pixmap_new(NULL, width, height, 24);

  /* blit the bitmaps defining the cursor on a transparent background */
  gc = gdk_gc_new(rgb_pixmap);
  gdk_gc_set_fill(gc, GDK_SOLID);
  gdk_gc_set_rgb_fg_color(gc, trans);
  gdk_draw_rectangle(rgb_pixmap, gc, TRUE, 0, 0, width, height);
  gdk_gc_set_fill(gc, GDK_OPAQUE_STIPPLED);
  gdk_gc_set_stipple(gc, source);
  gdk_gc_set_clip_mask(gc, mask);
  gdk_gc_set_rgb_fg_color(gc, fg);
  gdk_gc_set_rgb_bg_color(gc, bg);
  gdk_draw_rectangle(rgb_pixmap, gc, TRUE, 0, 0, width, height);
  gdk_gc_unref(gc);

  /* create a cursor out of the created pixmap */
  rgb_pixbuf = gdk_pixbuf_get_from_drawable(
    NULL, rgb_pixmap, gdk_colormap_get_system(),
    0, 0, 0, 0, width, height);
  gdk_pixmap_unref(rgb_pixmap);
  rgba_pixbuf = gdk_pixbuf_add_alpha(
    rgb_pixbuf, TRUE, trans->red, trans->green, trans->blue);
  gdk_pixbuf_unref(rgb_pixbuf);
  cursor = gdk_cursor_new_from_pixbuf(
    gdk_display_get_default(), rgba_pixbuf, x, y);
  gdk_pixbuf_unref(rgba_pixbuf);

  return cursor;
}
#define gdk_cursor_new_from_pixmap fixed_gdk_cursor_new_from_pixmap
#endif
```

## Bug 2: Loading and saving doesn't work

Using our Windows version of Xournal to try to load a file saved by
Xournal on Linux gives an error message. What's more, a file saved with
our Windows version of Xournal gives an error message when trying to
load it with Xournal on either platform!

It took me quite a while to figure this out, but the culprit here is
that Xournal uses zlib in the wrong way, namely with text-mode I/O
instead of binary I/O. This bug doesn't show up on Linux because there
text-mode and binary I/O are pretty much the same thing. On Windows,
however, text-mode I/O converts a `'\n'` character into `"\r\n"` on
writing, and vice versa on reading. This is fine for text documents, but
not for binary files such as Xournal's!

The fix is simple: replace text I/O modes (`"r"` and `"w"`) by binary
I/O modes (`"rb"` and `"wb"`) in all the relevant `gzopen`, `popen`, and
`fopen` calls. That is, all the calls in `src/xo-print.c` and all the
calls in `src/xo-file.c` except for

```c
  f = fopen(ui.mrufile, "w");
```

in `save_mru_list`, and

```c
  f = fopen(ui.configfile, "w");
```

in `save_config_to_file`.

## Bug 3: Fullscreen isn't truly fullscreen

When I tried Xournal's fullscreen mode, I could still see the Windows
taskbar. This seems to be a bug in the `gtk_window_fullscreen` function
on Windows. Inkscape's fullscreen functionality does work properly,
however, and that also uses `gtk_window_fullscreen`. It'll take some
more detective work to pin this down properly, but in the meantime it is
fairly easy to work around.

-   In `src/xournal.h`, add two new fields to the `UIData` struct:

    ```c
      gint pre_fullscreen_width, pre_fullscreen_height;
    ```

-   In `src/xo-callbacks.c`, in the `on_viewFullscreen_activate`
    function, replace the two lines

    ```c
      if (ui.fullscreen) gtk_window_fullscreen(GTK_WINDOW(winMain));
      else gtk_window_unfullscreen(GTK_WINDOW(winMain));
    ```

    by the lines

    ```c
      if (ui.fullscreen) {
        gtk_window_get_size(GTK_WINDOW(winMain),
                            &ui.pre_fullscreen_width,
                            &ui.pre_fullscreen_height);
        gtk_window_fullscreen(GTK_WINDOW(winMain));
        gtk_widget_set_size_request(GTK_WIDGET(winMain),
                                    gdk_screen_width(),
                                    gdk_screen_height());
      } else {
        gtk_widget_set_size_request(GTK_WIDGET(winMain), -1, -1);
        gtk_window_unfullscreen(GTK_WINDOW(winMain));
        gtk_window_resize(GTK_WINDOW(winMain),
                          ui.pre_fullscreen_width,
                          ui.pre_fullscreen_height);
      }
    ```

With all of the above fixes, compiling the [resulting source
code](/programming/xournal-fixed-source.zip) gives a working version
of Xournal on Windows (minus the screenshot functionality).
