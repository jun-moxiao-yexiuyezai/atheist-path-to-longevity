<#
.SYNOPSIS
  Create an initial project folder with standard files and produce a zip package.

.PARAMETER BaseName
  Name for the generated directory and (by default) the zip file base.

.PARAMETER Author
  Author name used in the MIT license.

.PARAMETER Year
  Copyright year used in the MIT license (defaults to current year).

.PARAMETER OutputZip
  Path/name of the generated zip. Defaults to "<BaseName>.zip".

.PARAMETER Force
  Overwrite existing output (directory or zip) when supplied.

.EXAMPLE
  .\create_package_with_mit_Version2.ps1 -Force
#>
[CmdletBinding()]
param(
    [string]$BaseName = "atheist-path-to-longevity-initial",
    [string]$Author = "jun-moxiao-yexiuyezai",
    [int]$Year = (Get-Date).Year,
    [string]$OutputZip = "",
    [switch]$Force
)

if (-not $OutputZip) { $OutputZip = "$BaseName.zip" }

$root = Join-Path -Path (Get-Location).Path -ChildPath $BaseName

function Write-File([string]$relativePath, [string]$content) {
    $fullPath = Join-Path $root $relativePath
    $dir = Split-Path $fullPath -Parent
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }
    # Write UTF-8 without BOM in a cross-version-safe way
    $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($fullPath, $content, $utf8NoBom)
    Write-Verbose "Wrote $fullPath"
}

try {
    # Clean existing output directory if requested
    if (Test-Path $root) {
        if ($Force) {
            Remove-Item -Recurse -Force -Path $root
            Write-Verbose "Removed existing directory $root"
        } else {
            Write-Host "Directory '$root' already exists. Rerun with -Force to overwrite."
            exit 1
        }
    }

    New-Item -ItemType Directory -Path $root | Out-Null

    # README.md
    $readme = @'
# 无神论者的长生路

项目目标
- 搭建一个面向“无神论者”群体的技术讨论与协作平台，围绕“通过电子信息与科技手段探索延长/改善生命/健康”的思想、技术与伦理展开讨论。
- 汇聚不同专业（计算机、电子工程、生物信息、医学、伦理学等）道友，形成可复用的开源资源与研究/工程项目。

我们讨论的主题（示例）
- 可穿戴/植入式健康监测与反馈系统
- 生物数据采集、隐私与安全
- 人工智能在健康/诊断/个性化干预中的应用
- 仿生/生物工程（原则性讨论，遵守法律与伦理）
- 社区驱动的研究议题与开源工具

如何参与
- 使用 Issue 提交问题、建议或求助（请选合适的模板）。
- 在 Discussions 发起更宽泛的话题与征求合作者。
- 提交 PR 改进文档、工具或样例代码。

行为准则
- 本项目鼓励理性讨论与学术/工程求真，但禁止发布或协助任何违法、有害的实验或可被滥用的“危险指导”。详见 CODE_OF_CONDUCT 与安全政策文件。

许可与免责声明
- 本仓库内容以开源许可（待选）发布。所有建议仅供讨论与研究参考，不构成医疗/法律/伦理上的可执行指令。任何涉及人体/临床实验的方案须遵守相应的法规和伦理流程。
'@
    Write-File "README.md" $readme

    # features/copilot/plans.md (add .md extension)
    $plans = @'
# features/copilot/plans

项目定位
- 建立一个多学科协作社区与知识库，专注于信息技术在延展生命质量/寿命方面的理论、软件和硬件工具探索（以合规与安全为前提）。

短期目标（0–3 个月）
- 建立仓库与初始文档（README、CONTRIBUTING、Code of Conduct）
- 开启 GitHub Discussions，吸引首批成员并征集主题与擅长领域
- 设计并发布第一个“研究/工程征集” issue（例如：可穿戴长期心率监测原型）

中期目标（3–12 个月）
- 搭建示范性开源项目（例如：低功耗生理数据采集板 + 数据管线 + 可视化）
- 发起跨学科小组（软件、硬件、生物信息、伦理）并建立贡献流程
- 研发基础的数据隐私与匿名化工具集

长期目标（12 个月以上）
- 形成可复用的“工具链”与若干成熟模块，支持社区用户在合规范围内做小规模试验
- 与学术/临床/伦理审核机构建立联系，推动可合规的研究合作

需要协助的地方（征集）
- 硬件工程：低功耗传感方案、原型设计
- 软件工程：后端数据管线、隐私保护、模型部署
- 生物/医学：数据解释、生理信号处理、临床合规建议
- 法律/伦理：研究与数据使用的伦理边界与合规流程

沟通与协作规范
- 在 Discussions 发布意向贴并 @相关标签与人员
- 提交 Issue 时选择合适的 labels：help-wanted, research-proposal, design, ethics
- 所有涉及人体数据/实验的提案必须包含风险评估与伦理合规计划
'@
    Write-File "features/copilot/plans.md" $plans

    # CONTRIBUTING.md
    $contrib = @'
# Contributing

欢迎贡献！本项目欢迎各类形式的贡献：问题反馈、讨论主题、文档改进、代码与硬件设计、以及伦理/法律建议。

贡献流程（推荐）
1. Fork 本仓库（若你没有仓库写权限）。
2. 新建分支：git checkout -b feat/描述-你的改动。
3. 提交并 push 到你的 fork。
4. 发起 Pull Request，选择合适的模板并在 PR 描述中说明变更目的与测试方法。

沟通渠道
- 使用 Discussions 发起宽泛话题或征集合作者。使用 Issue 提交具体问题或研究提案（请选择对应模板）。

标签与优先级
- 请使用仓库现有 labels：help-wanted, good-first-issue, research-proposal, design, ethics。

代码风格与审查
- 请保持文档/代码可读性，提交前通过基本静态检查（若有）。
- PR 将由维护者或指定审查者进行 review；通过后合并。

关于风险与伦理
- 所有涉及人体数据或实验的提案在提交 Issue/PR 时必须包含明确的伦理合规说明与风险评估；未经审查不得开展任何人体实验。

许可与贡献者署名
- 本项目将采用仓库根目录的 LICENSE（如选择），贡献者通过提交即表示同意该许可下贡献代码/文档。
'@
    Write-File "CONTRIBUTING.md" $contrib

    # CODE_OF_CONDUCT.md
    $code = @'
# Contributor Covenant Code of Conduct

本项目遵循 Contributor Covenant 行为准则（简要版）。我们期待所有参与者保持尊重、专业与包容。任何形式的骚扰、歧视或恶意行为都不被容忍。

主要要点：
- 尊重他人：尊重不同观点，避免人身攻击与贬低性言论。
- 积极沟通：在讨论中以建设性为导向，给出明确、有依据的反馈。
- 报告机制：若遇到违反行为准则的行为，请通过 Issues 联系维护者或发送电子邮件给仓库管理员（在 Issue 中私信联系方式或使用 repository settings 中的联系方式）。
'@
    Write-File "CODE_OF_CONDUCT.md" $code

    # ISSUE template and PR template
    $issue = @'
---
name: Research proposal
about: Submit a research or project proposal for community review
title: "[Proposal] "
labels: research-proposal
assignees: ''
---

<!-- 请在下面填写你的研究/工程提案 -->

## 标题

## 背景与目的

## 方法与实现计划
- 数据来源（若涉及）：
- 预期的数据处理/分析方法：
- 硬件/软件需求：

## 伦理与风险评估
- 是否涉及人体数据或人体实验：是/否
- 若是，请说明伦理审查、匿名化策略、知情同意等措施：

## 测试与验证
- 你将如何验证/测试该方案？

## 预期产出
- 论文/报告/代码/硬件原型等

## 合作者与分工（可选）

'@
    Write-File ".github/ISSUE_TEMPLATE/research_proposal.md" $issue

    $pr = @'
<!-- Pull request template -->

## 目的
简要说明本次 PR 的目的和要解决的问题。

## 变更摘要
- 列出主要变更点

## 测试
- 说明如何在本地/CI 中复现测试

## 检查清单
- [ ] 我已遵循 Contributing 指南
- [ ] 我已对修改内容进行自测/文档更新
- [ ] 若涉及数据/实验，包含必要的伦理说明

'@
    Write-File ".github/PULL_REQUEST_TEMPLATE.md" $pr

    # CI workflow
    $ci = @'
name: CI
on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  markdown-lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Markdown lint
        uses: igorshubovych/markdownlint-action@v2
'@
    Write-File ".github/workflows/ci.yml" $ci

    # LICENSE (MIT) - use double-quoted here-string so $Year and $Author are interpolated
    $mit = @"
MIT License

Copyright (c) $Year $Author

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the ""Software""), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ""AS IS"", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@
    Write-File "LICENSE" $mit

    # Create zip package
    if (Test-Path $OutputZip) {
        if ($Force) {
            Remove-Item -Force $OutputZip
            Write-Verbose "Removed existing zip $OutputZip"
        } else {
            Write-Host "Output zip '$OutputZip' already exists. Rerun with -Force to overwrite."
            exit 1
        }
    }

    Compress-Archive -Path (Join-Path $root '*') -DestinationPath $OutputZip -Force
    Write-Host "Created package: $OutputZip"

} catch {
    Write-Error "Failed: $_"
    exit 1
}
