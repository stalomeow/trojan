git clone https://github.com/Jrohy/trojan-web.git
pushd trojan-web
npm install
npm run build
Copy-Item -Path dist -Destination "../web/templates" -Recurse
popd
Remove-Item -Path trojan-web -Recurse -Force

$version = git describe --tags $(git rev-list --tags --max-count=1)
$now = date -Format "yyyyMMdd-HHmm (UTCK)"
$go_version = go version | % { $_ -replace "go version ", "" }
$git_version = git --version | % { $_ -replace "git version ", "" }
$ldflags = "-w -s -X 'trojan/trojan.MVersion=$version' -X 'trojan/trojan.BuildDate=$now' -X 'trojan/trojan.GoVersion=$go_version' -X 'trojan/trojan.GitVersion=$git_version'"

echo "Building version $version at $now with Go:$go_version and Git:$git_version"

set GOOS=linux
set GOARCH=amd64 && go build -ldflags "$ldflags" -o "result/trojan-linux-amd64"
set GOARCH=arm64 && go build -ldflags "$ldflags" -o "result/trojan-linux-arm64"

Remove-Item -Path "web/templates" -Recurse -Force
