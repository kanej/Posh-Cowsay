Import-Module -force .\cowsay.psm1

function main() {
  New-TempDir

  if($args[0] -ne $null) {
    Run-Test $args[0]
  } else {
    Run-AllTests
  }

  Remove-TempDir
}

function Run-AllTests() {
  ls .\tests\*.in | foreach { Run-Test $_.BaseName }
}

function Run-Test($test) {
  $command = Get-Content .\tests\$test.in
  iex $command > tmp\$test.tmp
  $result = Compare-Object (Get-Content .\tests\$test.out) (Get-Content .\tmp\$test.tmp)
  if($result -eq $null) {
    Write-TestPassed $test
  } else {
    Write-TestFailed $test
    cowsay $message
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
main $args
