Describe 'WinPulse-Optimizer Smoke Test' {

    It 'Script file exists' {
        (Test-Path -Path $PSScriptRoot/../SystemOptimizer_v2.ps1) | Should -BeTrue
    }

    It 'Script returns exit code 0 in -WhatIf mode' {
        pwsh -NoProfile -Command {
            & $PSScriptRoot/../SystemOptimizer_v2.ps1 -WhatIf
            $LASTEXITCODE
        } | Should -Be 0
    }
}
