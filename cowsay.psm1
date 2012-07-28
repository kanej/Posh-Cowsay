#
#  Posh-Cowsay
#  PowerShell version of the venerable cowsay unix program.
#
#  Copyright (c) 2012 John Kane
#  https://github.com/kanej/posh-cowsay
#  
#  Based on Tony Monroe's cowsay: 
#  http://www.nog.net/~tony/warez/cowsay-3.03.tar.gz
#
#  Licensed under the GNU GPL version 3.0
#

#requires -Version 2.0

# Posh-Cowsay Version
$version = "0.1.1"

# Max Width of the Speech Bubble
$bubbleWidth = 40

# The different modes that are supported
$modes = @{
  "-b"= @("==", ' ') # Borg
  "-d"= @("XX", 'U') # Dead
  "-g"= @('$$', ' ') # Greedy
  "-p"= @("@@", ' ') # Paranoid
  "-s"= @("**", 'U') # Stoned
  "-y"= @("..", ' ') # Youthful
}

# Public

<# 
.Synopsis
  Prints the given text to the console as if a cow had said it.
.Description
  Posh-Cowsay generates an ASCII art picture of a cow saying something
  provided by the user. It word-wraps the message at about 40
  columns, and prints the cow saying the given message on standard
  output.

  The -version or -v option will display the version of Posh-Cowsay.
.Link
  https://github.com/kanej/posh-cowsay

.Example
  cowsay moo

  Description
  -----------
  Takes "moo" to be the message and prints the text within a
  speech bubble, followed by the cow:

   _____
  < moo >
   -----
        \  ^__^
         \ (oo)\________
           (__)\        )\/\
                ||----w |
                ||     ||

.Example
  "moo" | cowsay

  Description
  -----------
  The message can be piped in as well, giving the same result:

   _____
  < moo >
   -----
        \  ^__^
         \ (oo)\________
           (__)\        )\/\
                ||----w |
                ||     ||
  
.Example
  cowsay -b Resistance is Bovine

  Description
  -----------
  The borg mode can be enabled by passing -b option, giving a cow that
  has joined the Collective:

   ______________________
  < Resistance is Bovine >
   ----------------------
        \  ^__^
         \ (==)\________
           (__)\        )\/\
                ||----w |
                ||     ||
#>
function Cowsay() {
  $params

  $messageArgs = @()
  $eyes = "oo"
  $tongue = " "


  foreach($arg in $args) {

    if($arg -eq "-v" -or $arg -eq "-version") {
      Print-Version
      return
    }

    if($modes.keys -contains $arg) {
      $eyes   = $modes[$arg][0]
      $tongue = $modes[$arg][1]
      continue
    }

    $messageArgs += $arg
  }

  $inputList = @($input)
  if ($inputList.Count -eq 0) {
    $params = ,$messageArgs
  } else {
    $params = ,$messageArgs +@($inputList)
  }

  $message = [String]::join(" ", $params)
  Print-MessageBubble($message) 

  Print-Cow $eyes $tongue
}

# Private

function Print-MessageBubble($message) {
  $lines = Convert-MessageToLines($message)
  $lineWidth = Max-Width($lines)

  Write-MessageBubbleBoundaryLine -lineWidth $lineWidth -boundaryChar '_' 

  foreach ($index in 0..($lines.length - 1)) {
    $delimiters = Determine-MessageBubbleDelimiters $index $lines.length
    $paddedLine = ' ' + $lines[$index] + ' '
    Write-MessageBubbleLine -lineWidth $lineWidth -delimiters $delimiters -text $paddedLine
  }

  Write-MessageBubbleBoundaryLine -lineWidth $lineWidth -boundaryChar '-'
}

function Print-Cow($eyes="oo", $tongue=" ") {
  Write-Output "      \  ^__^             "
  Write-Output "       \ ($eyes)\________    "
  Write-Output "         (__)\        )\/\"
  Write-Output "          $tongue   ||----w |   "
  Write-Output "              ||     ||   "
}

function Print-Version() {
 Write-Output "Posh-Cowsay version $version" 
}

# Helper Functions

function Convert-MessageToLines($message) {
  $words = Split-Message $message  
  $lines = @()
  $line = ""

  foreach($word in $words) {
    if(($line.length + $word.length + 1) -gt $bubbleWidth) {
      if($line -ne "") {
        $lines += ,$line
      }
      $line = $word 
    } else {
      if($line -eq "") {
        $line = $word
      } else {
        $line += " " + $word
      }
    }
  }

  $lastLine = $line

  $lines += ,$lastLine
  return ,$lines 
}

function Split-Message($message) {
  $wordsSplitOnSpaces = $message.split(" ")
  
  $words = @()

  foreach($longWord in $wordsSplitOnSpaces) {
    foreach($word in Split-Word($longWord)) {
      if($word -ne "") {
        $words += ,$word
      }
    }
  }

  return ,$words
}

function Split-Word($word) {
  if($word.length -le $bubbleWidth) {
    return ,@($word)
  }

  $splits = @()

  foreach($i in (0..($word.length / $bubbleWidth))) {
    $startPoint = ($i * $bubbleWidth)
    if(($startPoint + $bubbleWidth) -gt $word.length) {
      $splits += $word.substring($startPoint)
    } else {
      $splits += $word.substring($startPoint, $bubbleWidth)
    }
  }

  return ,$splits
}

function Max-Width($lines) {
  $maxLength = 0
  foreach($line in $lines) {
    if($line.length -gt $maxLength) {
      $maxLength = $line.length
    }
  }
  
  return $maxLength
}

function Write-MessageBubbleBoundaryLine($lineWidth, $boundaryChar) {
  Write-MessageBubbleLine -lineWidth $lineWidth `
                          -delimiters '  ' `
                          -text ("".padRight($lineWidth + 2, $boundaryChar))
}

function Write-MessageBubbleLine($lineWidth, $delimiters, $text) {
    $line = $delimiters[0] + ($text.padRight($lineWidth + 2, ' ')) + $delimiters[1]
    Write-Output $line.trimEnd()
}

function Determine-MessageBubbleDelimiters($lineNumber, $totalNumberOfLines) {
  # single line
  if($totalNumberOfLines -eq 1) {
    return '<>'
  }

  # first line
  if($lineNumber -eq 0) {
    return '/\'
  }

  # last line
  if($lineNumber -eq ($totalNumberOfLines -1)) {
    return '\/'
  }

  # middle line
  return '||'
}

# Exports

Export-ModuleMember Cowsay
