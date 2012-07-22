
# Max Width of the Speech Bubble
$bubbleWidth = 40

# Public

<# 
.Synopsis
  Prints text to the screen as if a cow had said it.
.Description
  Given a text message a picture of a cow speaking the text
  is pretty printed to the screen.
.Link
  http://github.com/kanej/posh-cowsay

.Example
  # cowsay moo

  Description
  -----------
  Prints out:

   -----
  < moo >
   -----
        \  ^__^
         \ (00)\________
           (__)\        )\/\
                ||----w |
                ||     ||

#>
function Cowsay() {
  $message = [String]::join(" ", $args)
  Print-MessageBubble($message) 
  Print-Cow
}

# Private

function Print-MessageBubble($message) {
  $lines = Convert-MessageToLines($message)
  $lineWidth = Max-Width($lines)

  Write-MessageBubbleBoundaryLine $lineWidth

  foreach ($index in 0..($lines.length - 1)) {
    $delimiters = Determine-MessageBubbleDelimiters $index $lines.length
    $paddedLine = ' ' + $lines[$index] + ' '
    Write-MessageBubbleLine -lineWidth $lineWidth -delimiters $delimiters -text $paddedLine
  }

  Write-MessageBubbleBoundaryLine $lineWidth
}

function Print-Cow() {
  Write-Output "      \  ^__^             "
  Write-Output "       \ (00)\________    "
  Write-Output "         (__)\        )\/\"
  Write-Output "              ||----w |   "
  Write-Output "              ||     ||   "
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

function Write-MessageBubbleBoundaryLine($lineWidth) {
  Write-MessageBubbleLine -lineWidth $lineWidth `
                          -delimiters '  ' `
                          -text ("".padRight($lineWidth + 2, '-'))
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
