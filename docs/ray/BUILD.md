# 构建 SumatraPDF-Ray

## 环境

- Windows x64。
- Visual Studio 2022 Build Tools 或 Community，安装“使用 C++ 的桌面开发”、MSVC v143、Windows SDK。
- Git、Bun 和 Rust/Cargo stable（MSVC 工具链）可在 PATH 中找到。
- 可用网络连接，用于 Cargo 获取 `ext/mermaid/Cargo.lock` 锁定的依赖。

源树包含本次构建使用的 C/C++ 第三方源码、字体资源、WebView2 构建依赖和 Rust 锁文件。Release 附件中的完整源码 ZIP 另附 `vendor/` 内的 Rust 依赖源码与许可，以及 `.cargo/config.toml`，构建时可直接使用这些随包依赖；Git 克隆默认从 Cargo 获取锁定版本。运行部分 WebView2 功能可能需要系统安装 Microsoft Edge WebView2 Runtime。

## Release x64

```powershell
git clone --branch v3.7.94-ray.1 https://github.com/C-SunRay/SumatraPDF-Ray.git
cd SumatraPDF-Ray
powershell -NoProfile -ExecutionPolicy Bypass -File .\build-ray.ps1
```

`build-ray.ps1` 先用仓库自带的 MakeLZSA 生成翻译资源，再调用 Visual Studio MSBuild；Mermaid 构建目标通过 Bun 调用 Cargo，使用 `--locked` 和静态 CRT。

输出：`out/rel64/SumatraPDF-Ray.exe`。

单独运行基础测试：

```powershell
.\out\rel64\test_util.exe
```

DeepSeek 请求构造的本地回归检查（无需 API 密钥，不调用服务商）：

```powershell
$env:SUMATRA_TEST_DEEPSEEK = Join-Path $PWD 'out\deepseek-tests.txt'
Start-Process -FilePath .\out\rel64\SumatraPDF-Ray.exe -ArgumentList '-render','1' -Wait
Remove-Item Env:\SUMATRA_TEST_DEEPSEEK
Get-Content .\out\deepseek-tests.txt
```

首次公开发行在 VS 2022/MSVC v143 环境验证。不同工具链和时间戳可能产生不同的二进制哈希；本说明不承诺逐字节可复现。

## 发布

在对应源码提交上创建版本标签，提供 EXE、许可说明、SHA-256 校验值和完整源码归档。不要把本机 `SumatraPDF-settings.txt`、缓存、个人文档、日志或密钥加入发布包。截图应使用测试文档及空白密钥。

自动更新读取 Ray 的 `ray/update-check.txt`，只接受 Ray 仓库内的下载链接。内部基础版本号为 `3.7.94`；后续需要自动推送更新时，应同步递增内部数字版本和更新清单。
