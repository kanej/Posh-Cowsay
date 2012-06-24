Import-Module -force .\cowsay.psm1

function main() {
  New-TempDir

  run-alltests

  Remove-TempDir
}

function run-alltests() {
  ls .\tests\*.in | foreach { run-test $_.BaseName }
}

function run-test($test) {
  $message = Get-Content .\tests\$test.in
  cowsay $message > tmp\$test.tmp
  $result = Compare-Object (Get-Content .\tests\$test.out) (Get-Content .\tmp\$test.tmp)
  if($result -eq $null) {
    Write-TestPassed $test
  } else {
    Write-TestFailed $test
    $result
  }
}

# Helper functions

function New-TempDir() {
  if(Test-Path tmp) {
    rm -r tmp | out-null
  }
  mkdir -f tmp | out-null
}

function Remove-TempDir() {
  rm -r tmp
}

function Write-TestPassed($test) {
  Write-ColouredOutput $test "Green"
}

function Write-TestFailed($test) {
  Write-ColouredOutput $test "Red"
}

function Write-ColouredOutput($text, $colour) {
  $original = ((Get-Host).UI.RawUI).ForegroundColor
  ((Get-Host).UI.RawUI).ForegroundColor = $colour
  Write-Output $text
  ((Get-Host).UI.RawUI).ForegroundColor = $original
}

# Run the main function now everything is defined.
main
