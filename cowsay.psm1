
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
    Write-Host " ".padRight($line.length + 3, '-')
    Write-Host "< $line >"
    Write-Host " ".padRight($line.length + 3, '-')
  } elseif($lines.length -eq 2) {
    $first = $lines[0] 
    $second = $lines[1]
    Write-Host " ".padRight($bubbleWidth + 3, '-')
    Write-Host "/ $first \"
    Write-Host "\ $second /"
    Write-Host " ".padRight($bubbleWidth + 3, '-')
  } else {
    $first = $lines[0]
    $second = $lines[1]
    $last = $lines[$lines.length - 1]
    Write-Host " ".padRight($bubbleWidth + 3, '-')
    Write-Host "/ $first \"
    Write-Host "| $second |"
    Write-Host "\ $last /"
    Write-Host " ".padRight($bubbleWidth + 3, '-')
  }
}

function cowsay($message) {
  print-messagebubble($message) 
  Write-Host "      \  ^__^"
  Write-Host "       \ (00)\________"
  Write-Host "         (__)\        )\/\"
  Write-Host "              ||----w |"
  Write-Host "              ||     ||"
}

Export-ModuleMember cowsay
