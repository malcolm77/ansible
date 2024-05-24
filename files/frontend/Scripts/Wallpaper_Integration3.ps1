#Modify Path to the picture accordingly to reflect your infrastructure
$imgPath="C:\tools\Wallpaper\domain_Wallpaper_Integration3.jpg"
$code = @'
using System.Runtime.InteropServices;
namespace Win32{

     public class Wallpaper{
        [DllImport("user32.dll", CharSet=CharSet.Auto)]
         static extern int SystemParametersInfo (int uAction , int uParam , string lpvParam , int fuWinIni) ;

         public static void SetWallpaper(string thePath){
            SystemParametersInfo(20,0,thePath,3);
         }
    }
 }
'@

add-type $code

#Apply the Change on the system
[Win32.Wallpaper]::SetWallpaper($imgPath)

Copy-Item "C:\tools\Scripts\Switch_to_Integration3\*" -Destination "C:\Windows\System32\drivers\etc\" -Force