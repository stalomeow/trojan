git clone https://github.com/Jrohy/trojan-web.git
pushd trojan-web
npm install
npm run build
Copy-Item -Path dist -Destination "../web/templates" -Recurse
popd
Remove-Item -Path trojan-web -Recurse -Force

$version = git describe --tags $(git rev-list --tags --max-count=1)
$now = date -Format "yyyy-MM-dd-HH:mm (UTCK)"
$go_version = go version | % { $_ -replace "go version go", "v" }
$git_version = git --version | % { $_ -replace "git version ", "v" -replace "\.windows\.1", "" }
$ldflags = "-w -s -X 'trojan/trojan.MVersion=$version' -X 'trojan/trojan.BuildDate=$now' -X 'trojan/trojan.GoVersion=$go_version' -X 'trojan/trojan.GitVersion=$git_version'"

echo "Building version $version at $now with Go:$go_version and Git:$git_version"

$env:GOOS="linux"
$env:GOARCH="amd64" && go build -ldflags "$ldflags" -o "result/trojan-linux-amd64"
$env:GOARCH="arm64" && go build -ldflags "$ldflags" -o "result/trojan-linux-arm64"

Remove-Item -Path "web/templates" -Recurse -Force
