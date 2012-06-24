
# Max Width of the Speech Bubble
$bubbleWidth = 40

function convert-message-to-lines($message) {
  $lines = @()
  $numberOfLines = [Math]::Ceiling($message.length / $bubbleWidth)
  
  if($numberOfLines -eq 1) {
    $lines += $message
    return ,$lines
  }
  
  # Get all lines but last
  0..($numberOfLines - 2) | foreach { $lines += $message.substring(($_ * $bubbleWidth), 40) } 
  # Append last line
  $lines += $message.substring(($numberOfLines - 1) * $bubbleWidth).padRight($bubbleWidth) 

  return $lines
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
      1..($lines.length - 2) | foreach { $newline = "| " + $lines[$_] + " |"; Write-Output $newline }
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
