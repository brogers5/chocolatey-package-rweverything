Import-Module au

function global:au_BeforeUpdate ($Package)  {
    Set-DescriptionFromReadme -Package $Package -ReadmePath ".\DESCRIPTION.md"
}

function global:au_AfterUpdate ($Package)  {
    
}

function global:au_SearchReplace {
    @{
        "$($Latest.PackageName).nuspec" = @{
            "<packageSourceUrl>[^<]*</packageSourceUrl>" = "<packageSourceUrl>https://github.com/brogers5/chocolatey-package-$($Latest.PackageName)/tree/v$($Latest.Version)</packageSourceUrl>"
            "(\<dependency .+?`"$($Latest.PackageName).install`" version=)`"([^`"]+)`"" = "`$1`"[$($Latest.Version)]`""
        }
    }
}

function global:au_GetLatest {
    $uri = 'http://rweverything.com/changelog/'
    $userAgent = "Update checker of Chocolatey Community Package 'rweverything'"
    $page = Invoke-WebRequest -Uri $uri -UserAgent $userAgent -UseBasicParsing

    return @{ 
        Version = [Version] [Regex]::Matches($page.Content, "<strong>v(.*) \d{1,2}/\d{1,2}/\d{4}?</strong>").Groups[1].Value
    }
}

Update-Package -ChecksumFor None -NoReadme
