<#
 .Synopsis
  Checks whether or not Slack is installed on the machine.

  .Description
   Checks whether or not Slack is installed by iterating through each user profile
   folder and checking their appdata.
#>
function Test-SlackInstalled {
    if ($IsWindows) {
        $installs = Get-ChildItem -Path "$($env:SystemPath)\Users\*\AppData\Local\slack";

        if ($installs.Count -gt 0) {
            return $true;
        }
    }

    if ($IsMacOS) {
        $globalInstalls = Get-ChildItem -Path "/Applications/Slack.app";
        $userInstalls = Get-ChildItem -Path "/Users/*/Applications/Slack.app";

        if ($globalInstalls.Count -gt 0 -or $userInstalls -gt 0) {
            return $true;
        }
    }

    return $false;
}

<#
 .Synopsis
  Removes Slack from the machine.

  .Description
   Iterates through each user's AppData folders and removes Slack from their profile.
#>
function Uninstall-Slack {
    if ($IsWindows) {
        $installs = Get-ChildItem -Path "${$env:SystemPath}\Users\*\AppData\Local\slack";

        foreach ($install in $installs) {
            $command = "$($install.FullName)\Update.exe";

            # Run the Slack uninstaller for the indivdual user
            & $command --uninstall -s
        }

        return;
    }

    if ($IsMacOS) {
        $installs = @(Get-ChildItem -Path "/Applications/Slack.app");
        $installs += @(Get-ChildItem -Path "/Users/*/Applications/Slack.app");

        foreach ($install in $installs) {
            Remove-Item $install -Recurse -Force;
        }

        return;
    }

    throw("Unfortunately, your OS is not supported by this function.");
}
