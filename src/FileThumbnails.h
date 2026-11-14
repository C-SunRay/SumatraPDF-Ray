/* Copyright 2022 the SumatraPDF project authors (see AUTHORS file).
   License: GPLv3 */

// Portrait cards with a 1 : sqrt(2) aspect ratio; preserve full cover contents.
constexpr int kThumbnailDx = 212;
constexpr int kThumbnailDy = 300;

RenderedBitmap* LoadThumbnail(FileState* fs);
bool HasThumbnail(FileState* fs);
void SetThumbnail(FileState* fs, RenderedBitmap* bmp);
void SaveThumbnail(FileState* fs);
void RemoveThumbnail(FileState* fs);
void InvalidateLoadedThumbnails();

TempStr GetThumbnailCacheDirTemp();
char* GetThumbnailPathTemp(const char* filePath);
void DeleteThumbnailForFile(const char* path);
void DeleteThumbnailCacheDirectory();
