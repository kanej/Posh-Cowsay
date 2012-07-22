
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
  if($lines.length -eq 1) {
    $line = $lines[0]
    Write-Output " ".padRight($line.length + 3, '-')
    Write-Output "< $line >"
    Write-Output " ".padRight($line.length + 3, '-')
  } else {
    $first = $lines[0]
    $last = $lines[$lines.length - 1]
    Write-Output " ".padRight($lineWidth + 3, '-')
    Write-MessageBubbleLine -lineWidth $lineWidth -leftDelimiter '/' -text (' ' + $first + ' ') -rightDelimiter '\'
    if($lines.length -gt 2) {
      1..($lines.length - 2) | foreach {
        Write-MessageBubbleLine -lineWidth $lineWidth -leftDelimiter '|' -text (' ' + $lines[$_] + ' ') -rightDelimiter '|'
      }
    }
    Write-MessageBubbleLine -lineWidth $lineWidth -leftDelimiter '\' -text (' ' + $last + ' ') -rightDelimiter '/'
    Write-Output " ".padRight($lineWidth + 3, '-')
  }
}

function Write-MessageBubbleLine($lineWidth, $leftDelimiter, $text, $rightDelimiter) {
    $line = $leftDelimiter + ($text.padRight($lineWidth + 2, ' ')) + $rightDelimiter
    Write-Output $line
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
