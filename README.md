# alpine-vips
Customizable image with libvips for Alpine Linux

## Build args
Set needed argument to 1 to enable feature, 0 to disable feature

* `VIPS_VERSION` - Set version of libvips library
* `IMAGEMAGIC_VERSION` - Set version of ImageMagick library (only used when `MAGICK` is set to `1`)
* `MATIO_VERSION` - Set version of MatIO library (only used when `MATIO` is set to `1`)
* `OPENSLIDE_VERSION` - Set version of OpenSlide library (only used when `OPENSLIDE` is set to `1`)
* `NIFTI_VERSION` - Set version of NIfTI library (only used when `NIFTI` is set to `1`)
* `MAGICK` - Build libvips with ImageMagick (ImageMagick will be built from sources)
* `JPEG` - JPEG support (libjpeg-turbo), enabled by default
* `JP2` - Open JPEG (JPEG2000) support (openjpeg)
* `JPEGXL` - JPEG XL support (libjxl)
* `EXIF` - EXIF metadata in JPEG files support (libexif), enabled by default
* `GIF` - GIF support (giflib, cgif), enabled by default
* `PNG` - PNG support (libpng, libspng), enabled by default
* `PNG_QUANT` - Write 8-bit palette-ised PNGs support (libimagequant)
* `WEBP` - WEBP support (libwebp), enabled by default
* `TIFF` - TIFF support (tiff), enabled by default
* `PDF` - PDF support (poppler-glib)
* `SVG` - SVG support (librsvg)
* `OPENEXR` - OpenEXR images support (only read, openexr)
* `HEIF` - HEIC and AVIF images support (libheif)
* `MATIO` - Matlab files support (matio lib will be built from sources)
* `FITS` - FITS images support (cfitsio)
* `NIFTI` - NIfTI images support (libniftiio will be built from sources)
* `OPENSLIDE` -  OpenSlide virtual slide files support (openslide lib will be built from sources)
* `LCMS` - Color profiles (ICC) support (lcms2), enabled by default
* `FFTW` - Fourier transforms support (fftw)
* `GSF` - Creating image pyramids with `dzsave` support (libgsf)
* `PANGO` - Text rendering support (pango)
* `MAGICK_OPENEXR` - Imagick OpenEXR support
* `MAGICK_LCMS` - Imagick color profiles (ICC) support
* `MAGICK_HDRI` - Imagick High Dynamic Range Imagery support
