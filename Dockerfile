FROM alpine:3.16
LABEL maintainer="Dmitry K. <coder1994@gmail.com>"

# libvips version
ARG VIPS_VERSION=8.12.2
# Only usuful when MAGICK is set
ARG IMAGEMAGIC_VERSION=7.1.0-38
# Only usuful when MATIO is set
ARG MATIO_VERSION=1.5.23
# Only usuful when OPENSLIDE is set
ARG OPENSLIDE_VERSION=3.4.1
# Only usuful when NIFTI is set
ARG NIFTI_VERSION=3.0.0

# JPEG support
ARG JPEG=1
# Open JPEG (JPEG2000) support
ARG JP2=0
# JPEG XL support
ARG JPEGXL=0
# EXIF metadata in JPEG files
ARG EXIF=1
# GIF support
ARG GIF=1
# PNG support
ARG PNG=1
# Write 8-bit palette-ised PNGs support
ARG PNG_QUANT=0
# WEBP support
ARG WEBP=1
# TIFF support
ARG TIFF=1
# PDF support
ARG PDF=0
# SVG support
ARG SVG=0
# OpenEXR images support (only read)
ARG OPENEXR=0
# HEIC and AVIF images support
ARG HEIF=0
# Matlab files support
ARG MATIO=0
# FITS images support
ARG FITS=0
# NIfTI images support
ARG NIFTI=0
# Support OpenSlide virtual slide files
ARG OPENSLIDE=0
# Color profiles (ICC) support
ARG LCMS=1
# Fourier transforms support
ARG FFTW=0
# Creating image pyramids with dzsave support
ARG GSF=0
# Text rendering support
ARG PANGO=0

# Add Imagick support (for formats which are not supported by Libvips)
ARG MAGICK=0
# Imagick OpenEXR support
ARG MAGICK_OPENEXR=0
# Imagick color profiles (ICC) support
ARG MAGICK_LCMS=0
# Imagick High Dynamic Range Imagery support
ARG MAGICK_HDRI=0

RUN set -x -o pipefail \
    && apk update \
    && deps_str='glib zlib expat orc' && dev_deps_str='make gcc g++ libc-dev glib-dev expat-dev zlib-dev orc-dev' \
    && if [ "${JPEG}" -eq 1 ]; then deps_str="${deps_str} libjpeg-turbo" dev_deps_str="${dev_deps_str} libjpeg-turbo-dev"; fi \
    && if [ "${JP2}" -eq 1 ]; then deps_str="${deps_str} openjpeg" dev_deps_str="${dev_deps_str} openjpeg-dev"; fi \
    && if [ "${JPEGXL}" -eq 1 ]; then deps_str="${deps_str} libjxl" dev_deps_str="${dev_deps_str} libjxl-dev"; fi \
    && if [ "${EXIF}" -eq 1 ]; then deps_str="${deps_str} libexif" dev_deps_str="${dev_deps_str} libexif-dev"; fi \
    && if [ "${GIF}" -eq 1 ]; then deps_str="${deps_str} giflib cgif" dev_deps_str="${dev_deps_str} giflib-dev cgif-dev"; fi \
    && if [ "${PNG}" -eq 1 ]; then deps_str="${deps_str} libpng libspng" dev_deps_str="${dev_deps_str} libpng-dev libspng-dev"; fi \
    && if [ "${PNG_QUANT}" -eq 1 ]; then deps_str="${deps_str} libimagequant" dev_deps_str="${dev_deps_str} libimagequant-dev"; fi \
    && if [ "${WEBP}" -eq 1 ]; then deps_str="${deps_str} libwebp" dev_deps_str="${dev_deps_str} libwebp-dev"; fi \
    && if [ "${TIFF}" -eq 1 ]; then deps_str="${deps_str} tiff" dev_deps_str="${dev_deps_str} tiff-dev"; fi \
    && if [ "${PDF}" -eq 1 ]; then deps_str="${deps_str} poppler-glib" dev_deps_str="${dev_deps_str} poppler-dev"; fi \
    && if [ "${SVG}" -eq 1 ]; then deps_str="${deps_str} librsvg" dev_deps_str="${dev_deps_str} librsvg-dev"; fi \
    && if [ "${OPENEXR}" -eq 1 -o "${MAGICK_OPENEXR}" -eq 1 ]; then deps_str="${deps_str} openexr" dev_deps_str="${dev_deps_str} openexr-dev"; fi \
    && if [ "${HEIF}" -eq 1 ]; then deps_str="${deps_str} libheif" dev_deps_str="${dev_deps_str} libheif-dev"; fi \
    && if [ "${MATIO}" -eq 1 ]; then deps_str="${deps_str} hdf5" dev_deps_str="${dev_deps_str} hdf5-dev autoconf automake libtool bsd-compat-headers"; fi \
    && if [ "${FITS}" -eq 1 ]; then deps_str="${deps_str} cfitsio" dev_deps_str="${dev_deps_str} cfitsio-dev"; fi \
    && if [ "${NIFTI}" -eq 1 ]; then deps_str="${deps_str} zlib expat" dev_deps_str="${dev_deps_str} help2man cmake zlib-dev expat-dev"; fi \
    && if [ "${OPENSLIDE}" -eq 1 ]; then deps_str="${deps_str} zlib libpng libjpeg tiff openjpeg gdk-pixbuf libxml2 sqlite cairo glib" dev_deps_str="${dev_deps_str} zlib-dev libpng-dev jpeg-dev tiff-dev openjpeg-dev gdk-pixbuf-dev libxml2-dev sqlite-dev cairo-dev glib-dev"; fi \
    && if [ "${LCMS}" -eq 1 -o "${MAGICK_LCMS}" -eq 1 ]; then deps_str="${deps_str} lcms2" dev_deps_str="${dev_deps_str} lcms2-dev"; fi \
    && if [ "${FFTW}" -eq 1 ]; then deps_str="${deps_str} fftw" dev_deps_str="${dev_deps_str} fftw-dev"; fi \
    && if [ "${GSF}" -eq 1 ]; then deps_str="${deps_str} libgsf" dev_deps_str="${dev_deps_str} libgsf-dev"; fi \
    && if [ "${PANGO}" -eq 1 ]; then deps_str="${deps_str} pango" dev_deps_str="${dev_deps_str} pango-dev"; fi \
    && if [ "${MAGICK}" -eq 1 ]; then deps_str="${deps_str} libltdl" dev_deps_str="${dev_deps_str} libtool"; fi \
    && apk add --no-cache $(echo "${deps_str}" | tr " ") \
    && apk add --no-cache --virtual .vips-deps $(echo "${dev_deps_str}" | tr " ") \
    # ImageMagick build
    && if [ "${MAGICK}" -eq 1 ]; then ( \
        if [ "${MAGICK_OPENEXR}" -eq 1 ]; then magick_openexr_res="yes"; else magick_openexr_res="no" ; fi \
        && if [ "${MAGICK_LCMS}" -eq 1 ]; then magic_lcms_res="yes"; else magic_lcms_res="no"; fi \
        && if [ "${MAGICK_HDRI}" -eq 1 ]; then magick_hdri_res="yes"; else magick_hdri_res="no"; fi \
        && wget -O- https://github.com/ImageMagick/ImageMagick/archive/refs/tags/${IMAGEMAGIC_VERSION}.tar.gz | tar xzC /tmp \
        && cd /tmp/ImageMagick-${IMAGEMAGIC_VERSION} \
        && ./configure \
            --disable-static \
            --disable-dependency-tracking \
            --enable-silent-rules \
            --disable-cipher \
            --disable-openmp \
            --enable-hdri=${magick_hdri_res} \
            --disable-opencl \
            --disable-docs \
            --with-modules \
            --with-utilities=no \
            --without-magick-plus-plus \
            --without-perl \
            --without-bzlib \
            --without-x \
            --without-zip \
            --without-zlib \
            --without-zstd \
            --without-apple-font-dir \
            --without-dps \
            --without-dejavu-font-dir \
            --without-fftw \
            --without-flif \
            --without-fpx \
            --without-djvu \
            --without-fontconfig \
            --without-freetype \
            --without-raqm \
            --without-gdi32 \
            --without-gslib \
            --without-fontpath \
            --without-gs-font-dir \
            --without-gvc \
            --without-heic \
            --without-jbig \
            --without-jpeg \
            --without-jxl \
            --with-lcms=${magic_lcms_res} \
            --without-openjp2 \
            --without-lqr \
            --without-lzma \
            --with-openexr=${magick_openexr_res} \
            --without-pango \
            --without-png \
            --without-raw \
            --without-rsvg \
            --without-tiff \
            --without-webp \
            --without-wmf \
            --without-xml \
        && make -j$(nproc) && make install \
        && cd $OLDPWD \
        && rm -rf /tmp/ImageMagick-${IMAGEMAGIC_VERSION} \
    ) fi \
    # MatIO build
    && if [ "${MATIO}" -eq 1 ]; then ( \
        wget -O- https://github.com/tbeu/matio/releases/download/v${MATIO_VERSION}/matio-${MATIO_VERSION}.tar.gz | tar xzC /tmp \
        && cd /tmp/matio-${MATIO_VERSION} \
        && ./autogen.sh \
        && ./configure \
            --disable-static \
            --enable-silent-rules \
            --enable-debug=no \
            --enable-profile=no \
        && make -j$(nproc) && make install \
        && cd $OLDPWD \
        && rm -rf /tmp/matio-${MATIO_VERSION} \
    ) fi \
    # OpenSlide build
    && if [ "${OPENSLIDE}" -eq 1 ]; then ( \
        wget -O- https://github.com/openslide/openslide/releases/download/v${OPENSLIDE_VERSION}/openslide-${OPENSLIDE_VERSION}.tar.gz | tar xzC /tmp \
        && cd /tmp/openslide-${OPENSLIDE_VERSION} \
        && ./configure \
            --disable-static \
            --disable-dependency-tracking \
            --enable-silent-rules \
        && make -j$(nproc) && make install \
        && cd $OLDPWD \
        && rm -rf /tmp/openslide-${OPENSLIDE_VERSION} \
    ) fi \
    # NIfTI build
    && if [ "${NIFTI}" -eq 1 ]; then ( \
        wget -O- https://github.com/NIFTI-Imaging/nifti_clib/archive/refs/tags/v${NIFTI_VERSION}.tar.gz | tar xzC /tmp \
        && cd /tmp/nifti_clib-${NIFTI_VERSION} \
        && cmake \
            -DBUILD_SHARED_LIBS=ON \
            -DNIFTI_USE_PACKAGING=ON \
            -DUSE_CIFTI_CODE=ON \
            -DUSE_FSL_CODE=ON \
            -DNIFTI_BUILD_APPLICATIONS=OFF \
            -DTEST_INSTALL=OFF \
            -DDOWNLOAD_TEST_DATA=OFF \
        && make install \
        && cd $OLDPWD \
        && rm -rf /tmp/nifti_clib-${NIFTI_VERSION} \
    ) fi \
    && mkdir -p /tmp/vips-${VIPS_VERSION} \
    && wget -O- https://github.com/libvips/libvips/releases/download/v${VIPS_VERSION}/vips-${VIPS_VERSION}.tar.gz | tar xzC /tmp/vips-${VIPS_VERSION} --strip-components=1 \
    && cd /tmp/vips-${VIPS_VERSION} \
    && if [ "${NIFTI}" -eq 1 ]; then with_nifti="yes"; else with_nifti="no" ; fi \
    && ./configure \
        --prefix=/usr \
        --disable-static \
        --disable-dependency-tracking \
        --enable-silent-rules \
        --enable-doxygen=no \
        --enable-gtk-doc=no \
        --enable-gtk-doc-html=no \
        --enable-gtk-doc-pdf=no \
        --with-nifti=${with_nifti} \
        --with-nifti-includes=/usr/local/include/nifti \
        --with-nifti-libraries=/usr/local/lib \
        --without-x \
    && make -j$(nproc) -s install-strip \
    && cd $OLDPWD \
    && rm -rf /tmp/vips-${VIPS_VERSION} \
    && rm -rf /usr/local/share/doc/* \
    && rm -rf /usr/share/gtk-doc/html/* \
    && apk del --no-network --purge .vips-deps \
    && vips --vips-config
