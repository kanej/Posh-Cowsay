Posh-Cowsay - Cowsay for Windows Powershell
===========================================
Clearly a shell cannot be called civilised until it has a talking cow.

     _______________________________
    < For POSH users with Unix envy >
     -------------------------------
          \  ^__^             
           \ (oo)\________    
             (__)\        )\/\
                  ||----w |   
                  ||     ||   

Based on Tony Monroe's original Unix terminal program cowsay:

http://www.nog.net/~tony/warez/cowsay-3.03.tar.gz

Usage
=====
Posh-Cowsay exposes a single function *cowsay*. Any non-option args passed to cowsay are treated as the message:

    > cowsay The build is broken

For more examples see the built-in powershell help:

    > get-help cowsay -examples

Install
=======
Posh-Cowsay is a single Powershell Module file with no dependencies. To install it:

1. Copy [cowsay.psm1](https://raw.github.com/kanej/posh-cowsay/master/cowsay.psm1) to your modules folder (C:\Users\<UserName\Documents\WindowsPowerShell\Modules> on Windows 7).
2. Open a new Powershell terminal and import the module

    Import-Module cowsay 

3. cowsay That was easy ... ish

License
=======
Posh-Cowsay is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Posh-Cowsay is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
