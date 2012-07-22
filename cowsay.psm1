
# Max Width of the Speech Bubble
$bubbleWidth = 40

# Public

function cowsay($message) {
  print-messagebubble($message) 
  print-cow
}

# Private

function print-messagebubble($message) {
  $lines = convert-message-to-lines($message)
  $lineWidth = max-width($lines)

  Write-MessageBubbleBoundaryLine $lineWidth

  if($lines.length -eq 1) {
    $delimiters = Determine-MessageBubbleDelimiters $_ $lines.length
    Write-MessageBubbleLine -lineWidth $lineWidth -delimiters $delimiters -text (' ' + $lines[0] + ' ')
  } else {
    0..($lines.length - 1) | foreach {
      $delimiters = Determine-MessageBubbleDelimiters $_ $lines.length
      Write-MessageBubbleLine -lineWidth $lineWidth -delimiters $delimiters -text (' ' + $lines[$_] + ' ')
    }
  }

  Write-MessageBubbleBoundaryLine $lineWidth
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

function Write-MessageBubbleLine($lineWidth, $delimiters, $text) {
    $line = $delimiters[0] + ($text.padRight($lineWidth + 2, ' ')) + $delimiters[1]
    Write-Output $line.trimEnd()
}

function Write-MessageBubbleBoundaryLine($lineWidth) {
  Write-MessageBubbleLine -lineWidth $lineWidth -delimiters '  ' -text ("".padRight($lineWidth + 2, '-'))
}

function print-cow() {
  Write-Output "      \  ^__^             "
  Write-Output "       \ (00)\________    "
  Write-Output "         (__)\        )\/\"
  Write-Output "              ||----w |   "
  Write-Output "              ||     ||   "
}

# Helper Functions

function convert-message-to-lines($message) {
  $words = split-message $message  
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

function split-message($message) {
  $wordsSplitOnSpaces = $message.split(" ")
  
  $words = @()

  foreach($longWord in $wordsSplitOnSpaces) {
    foreach($word in split-word($longWord)) {
      if($word -ne "") {
        $words += ,$word
      }
    }
  }

  return ,$words
}

function split-word($word) {
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

function max-width($lines) {
  $maxLength = 0
  foreach($line in $lines) {
    if($line.length -gt $maxLength) {
      $maxLength = $line.length
    }
  }
  
  return $maxLength
}

# Exports

Export-ModuleMember cowsay
