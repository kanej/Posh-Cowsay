
# Max Width of the Speech Bubble
$bubbleWidth = 40

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

  if($lines.length -ne 0) {
    $lastLine =  ($line.padRight($bubbleWidth, ' ')) 
  }

  $lines += ,$lastLine
  return ,$lines 
}

function print-messagebubble($message) {
  $lines = convert-message-to-lines($message)
  if($lines.length -eq 1) {
    $line = $lines[0]
    Write-Output " ".padRight($line.length + 3, '-')
    Write-Output "< $line >"
    Write-Output " ".padRight($line.length + 3, '-')
  } else {
    $first = $lines[0]
    $last = $lines[$lines.length - 1]
    Write-Output " ".padRight($bubbleWidth + 3, '-')
    Write-Output "/ $first \"
    if($lines.length -gt 2) {
      1..($lines.length - 2) | foreach {
        $newline = "| " + $lines[$_] + " |"; Write-Output $newline
      }
    }
    Write-Output "\ $last /"
    Write-Output " ".padRight($bubbleWidth + 3, '-')
  }
}

function print-cow() {
  Write-Output "      \  ^__^             "
  Write-Output "       \ (00)\________    "
  Write-Output "         (__)\        )\/\"
  Write-Output "              ||----w |   "
  Write-Output "              ||     ||   "
}

function cowsay($message) {
  print-messagebubble($message) 
  print-cow
}

Export-ModuleMember cowsay
