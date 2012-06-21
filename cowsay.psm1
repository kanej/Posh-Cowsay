
# Max Width of the Speech Bubble
$bubbleWidth = 40

function print-messagebubble($message) {
  if($message.length -lt $bubbleWidth + 1) {
    Write-Host " ".padRight($message.length + 3, '-')
    Write-Host "< $message >"
    Write-Host " ".padRight($message.length + 3, '-')
  } elseif($message.length -lt (2 * $bubbleWidth) + 1) {
    $first = $message.substring(0, $bubbleWidth)
    $second = $message.substring($bubbleWidth).padRight($bubbleWidth, ' ')
    Write-Host " ".padRight($bubbleWidth + 3, '-')
    Write-Host "/ $first \"
    Write-Host "\ $second /"
    Write-Host " ".padRight($bubbleWidth + 3, '-')
  } else {
    throw "The cow is dead I am afraid."
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
