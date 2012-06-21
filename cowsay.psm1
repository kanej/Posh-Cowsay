
function cowsay($message) {
  Write-Host " ".padRight($message.length + 3, '-')
  Write-Host "< $message >"
  Write-Host " ".padRight($message.length + 3, '-')
  Write-Host "      \  ^__^"
  Write-Host "       \ (00)\________"
  Write-Host "         (__)\        )\/\"
  Write-Host "              ||----w |"
  Write-Host "              ||     ||"
}

Export-ModuleMember cowsay
