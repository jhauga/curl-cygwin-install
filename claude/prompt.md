# `curl-cygwin-intall` Prompt

You are attempting to build curl using Cygwin in a Windows 11 Sandbox.
The results of the installation are in [`claude-context.yaml`](../claude-context.yaml).

Additionally, the terminal is Windows 11 DOS terminal. That cannot
change. Right now - in the Windows 11 terminal the install error is:

## Windows 11 Install Error

```bash
../libtool: eval: line 1890: syntax error near unexpected token `|'
../libtool: eval: line 1890: `/usr/bin/nm -B  .libs/libcurl_la-altsvc.o .libs/libcurl_la-amigaos.o .libs/libcurl_la-asyn-ares.o .libs/libcurl_la-asyn-base.o .libs/libcurl_la-asyn-thrdd.o .libs/libcurl_la-bufq.o .libs/libcurl_la-bufref.o .libs/libcurl_la-cf-h1-proxy.o .libs/libcurl_la-cf-h2-proxy.o .libs/libcurl_la-cf-haproxy.o .libs/libcurl_la-cf-https-connect.o .libs/libcurl_la-cf-ip-happy.o .libs/libcurl_la-cf-socket.o .libs/libcurl_la-cfilters.o .libs/libcurl_la-conncache.o .libs/libcurl_la-connect.o .libs/libcurl_la-content_encoding.o .libs/libcurl_la-cookie.o .libs/libcurl_la-cshutdn.o .libs/libcurl_la-curl_addrinfo.o .libs/libcurl_la-curl_endian.o .libs/libcurl_la-curl_fnmatch.o .libs/libcurl_la-curl_fopen.o .libs/libcurl_la-curl_get_line.o .libs/libcurl_la-curl_gethostname.o .libs/libcurl_la-curl_gssapi.o .libs/libcurl_la-curl_memrchr.o .libs/libcurl_la-curl_ntlm_core.o .libs/libcurl_la-curl_range.o .libs/libcurl_la-curl_rtmp.o .libs/libcurl_la-curl_sasl.o .libs/libcurl_la-curl_sha512_256.o .libs/libcurl_la-curl_share.o .libs/libcurl_la-curl_sspi.o .libs/libcurl_la-curl_threads.o .libs/libcurl_la-curl_trc.o .libs/libcurl_la-cw-out.o .libs/libcurl_la-cw-pause.o .libs/libcurl_la-dict.o .libs/libcurl_la-doh.o .libs/libcurl_la-dynhds.o .libs/libcurl_la-easy.o .libs/libcurl_la-easygetopt.o .libs/libcurl_la-easyoptions.o .libs/libcurl_la-escape.o .libs/libcurl_la-fake_addrinfo.o .libs/libcurl_la-file.o .libs/libcurl_la-fileinfo.o .libs/libcurl_la-formdata.o .libs/libcurl_la-ftp.o .libs/libcurl_la-ftplistparser.o .libs/libcurl_la-getenv.o .libs/libcurl_la-getinfo.o .libs/libcurl_la-gopher.o .libs/libcurl_la-hash.o .libs/libcurl_la-headers.o .libs/libcurl_la-hmac.o .libs/libcurl_la-hostip.o .libs/libcurl_la-hostip4.o .libs/libcurl_la-hostip6.o .libs/libcurl_la-hsts.o .libs/libcurl_la-http.o .libs/libcurl_la-http1.o .libs/libcurl_la-http2.o .libs/libcurl_la-http_aws_sigv4.o .libs/libcurl_la-http_chunks.o .libs/libcurl_la-http_digest.o .libs/libcurl_la-http_negotiate.o .libs/libcurl_la-http_ntlm.o .libs/libcurl_la-http_proxy.o .libs/libcurl_la-httpsrr.o .libs/libcurl_la-idn.o .libs/libcurl_la-if2ip.o .libs/libcurl_la-imap.o .libs/libcurl_la-ldap.o .libs/libcurl_la-llist.o .libs/libcurl_la-macos.o .libs/libcurl_la-md4.o .libs/libcurl_la-md5.o .libs/libcurl_la-memdebug.o .libs/libcurl_la-mime.o .libs/libcurl_la-mprintf.o .libs/libcurl_la-mqtt.o .libs/libcurl_la-multi.o .libs/libcurl_la-multi_ev.o .libs/libcurl_la-multi_ntfy.o .libs/libcurl_la-netrc.o .libs/libcurl_la-noproxy.o .libs/libcurl_la-openldap.o .libs/libcurl_la-parsedate.o .libs/libcurl_la-pingpong.o .libs/libcurl_la-pop3.o .libs/libcurl_la-progress.o .libs/libcurl_la-psl.o .libs/libcurl_la-rand.o .libs/libcurl_la-ratelimit.o .libs/libcurl_la-request.o .libs/libcurl_la-rtsp.o .libs/libcurl_la-select.o .libs/libcurl_la-sendf.o .libs/libcurl_la-setopt.o .libs/libcurl_la-sha256.o .libs/libcurl_la-slist.o .libs/libcurl_la-smb.o .libs/libcurl_la-smtp.o .libs/libcurl_la-socketpair.o .libs/libcurl_la-socks.o .libs/libcurl_la-socks_gssapi.o .libs/libcurl_la-socks_sspi.o .libs/libcurl_la-splay.o .libs/libcurl_la-strcase.o .libs/libcurl_la-strequal.o .libs/libcurl_la-strerror.o .libs/libcurl_la-system_win32.o .libs/libcurl_la-telnet.o .libs/libcurl_la-tftp.o .libs/libcurl_la-transfer.o .libs/libcurl_la-uint-bset.o .libs/libcurl_la-uint-hash.o .libs/libcurl_la-uint-spbset.o .libs/libcurl_la-uint-table.o .libs/libcurl_la-url.o .libs/libcurl_la-urlapi.o .libs/libcurl_la-version.o .libs/libcurl_la-ws.o vauth/.libs/libcurl_la-cleartext.o vauth/.libs/libcurl_la-cram.o vauth/.libs/libcurl_la-digest.o vauth/.libs/libcurl_la-digest_sspi.o vauth/.libs/libcurl_la-gsasl.o vauth/.libs/libcurl_la-krb5_gssapi.o vauth/.libs/libcurl_la-krb5_sspi.o vauth/.libs/libcurl_la-ntlm.o vauth/.libs/libcurl_la-ntlm_sspi.o vauth/.libs/libcurl_la-oauth2.o vauth/.libs/libcurl_la-spnego_gssapi.o vauth/.libs/libcurl_la-spnego_sspi.o vauth/.libs/libcurl_la-vauth.o vtls/.libs/libcurl_la-apple.o vtls/.libs/libcurl_la-cipher_suite.o vtls/.libs/libcurl_la-gtls.o vtls/.libs/libcurl_la-hostcheck.o vtls/.libs/libcurl_la-keylog.o vtls/.libs/libcurl_la-mbedtls.o vtls/.libs/libcurl_la-openssl.o vtls/.libs/libcurl_la-rustls.o vtls/.libs/libcurl_la-schannel.o vtls/.libs/libcurl_la-schannel_verify.o vtls/.libs/libcurl_la-vtls.o vtls/.libs/libcurl_la-vtls_scache.o vtls/.libs/libcurl_la-vtls_spack.o vtls/.libs/libcurl_la-wolfssl.o vtls/.libs/libcurl_la-x509asn1.o vquic/.libs/libcurl_la-curl_ngtcp2.o vquic/.libs/libcurl_la-curl_quiche.o vquic/.libs/libcurl_la-vquic.o vquic/.libs/libcurl_la-vquic-tls.o vssh/.libs/libcurl_la-libssh.o vssh/.libs/libcurl_la-libssh2.o vssh/.libs/libcurl_la-vssh.o curlx/.libs/libcurl_la-base64.o curlx/.libs/libcurl_la-basename.o curlx/.libs/libcurl_la-dynbuf.o curlx/.libs/libcurl_la-fopen.o curlx/.libs/libcurl_la-inet_ntop.o curlx/.libs/libcurl_la-inet_pton.o curlx/.libs/libcurl_la-multibyte.o curlx/.libs/libcurl_la-nonblock.o curlx/.libs/libcurl_la-snprintf.o curlx/.libs/libcurl_la-strcopy.o curlx/.libs/libcurl_la-strdup.o curlx/.libs/libcurl_la-strerr.o curlx/.libs/libcurl_la-strparse.o curlx/.libs/libcurl_la-timediff.o curlx/.libs/libcurl_la-timeval.o curlx/.libs/libcurl_la-version_win32.o curlx/.libs/libcurl_la-wait.o curlx/.libs/libcurl_la-warnless.o curlx/.libs/libcurl_la-winapi.o   |  | /usr/bin/sed -e '/^[BCDGRS][ ]/s/.*[ ]\([^ ]*\)/\1 DATA/;s/^.*[ ]__nm__\([^ ]*\)[ ][^ ]*/\1 DATA/;/^I[ ]/d;/^[AITW][ ]/s/.* //' | sort | uniq > .libs/libcurl.exp'
make[2]: *** [Makefile:1893: libcurl.la] Error 2
make[1]: *** [Makefile:1656: all] Error 2
make: *** [Makefile:608: all-recursive] Error 1
```

The configuration was run as:

## Configuration

The results from running `sh configure --without-ssl` are:

```bash
configure: WARNING: Cannot find libraries for LDAP support: LDAP disabled
configure: WARNING: Cannot find libidn2
```

## Dependencies

The dependencies are installed using Cygwin setup like `setup-x86_64.exe --no-admin -q -I -P binutils,gcc-core,libpsl-devel,libtool,perl,make`.
All the installation tools are in the `map` folder. So for this task we want a
simple solution: 

## GOAL

Resolve this error and successfully install curl on Windows 11 using:

- Windows 11 DOS terminal
- Cygwin
- `curl` from source

To achieve the goal, follow the instructions in 3 parts:


### Part I - Test Installation Solution

1. In `map/setConfigVar.bat` change one or more of the below variables to the value that
will resolve the failed install:

- `_packageDependenciesCurrent`
- `--without-ssl`
- `_customMakeCurrent`

2. In the Windows 11 DOS terminal run:

```bash
install.bat --task-run
```

3. After running that command, set a timer

- For every 10 minutes or 600 seconds that pass, run `goto _checkIfComplete`:

```bash
:_checkIfComplete
 ls -1 sandbox ^| find "_installation_is_complete.txt"
 rem when errorlevel is 0, or the file _installation_is_complete.txt exist, go to next step
 if "%ERRORLEVEL%"=="0" ( TIMEOUT /T 5 & goto _checkIfPass & rem go to the next step or step 3 ) else ( TIMEOUT /T 600 & call :_checkIfComplete & goto:eof )
goto:eof
```

3. When the installation is complete there will be a file name `sandbox/_installation_is_completed.txt`,
when that is the case, run:

```bash
:_checkIfPass
 TASKKILL /F /FI "imagename eq WindowsSandboxServer.exe"
 TIMEOUT /T 10
 install.bat --delay
 type curlInstructionWork.txt | find "Pass"
 if "%ERRORLEVEL%"=="0" (echo pass> "%~dp0claudeResponse.txt" & echo Go to next part of this process ) else (echo fail> "%~dp0claudeResponse.txt" & echo Do nothing else, and end this process)
goto:eof
```

### Part II - Pull Request Task

Make a branch in `D:\Users\johnh\Documents\GitHub\curl`. Call it "patch-curl-cygwin-install". In `patch-curl-cygwin-install` we want to:

#### `git` Instructions 1

- `git checkout master`
- `git checkout -b patch-curl-cygwin-install`
- `git branch --set-upstream-to=upstream/master patch-curl-cygwin-install`
- `git merge upstream/master`

#### Edit Instructions

Then make changes to:

- `docs/INSTALL.md` with the bare minimum solution used to resolve the failed install from **Part I**.

#### `git` Instructions 2

- `git add .`
- `git commit -m "INSTALL.md: update cygwin instructions"`

### Part III - Create a new GitHub Issue for Documentation Repo

### Make New issue Task

In sibling repo `D:\Users\johnh\Documents\GitHub\curl-www` we want to make an issue. Not a pull request. Instead, dump the issue data in a file.
Call it "_PROPOSED_ISSUE_DATA.md". Write short issue covering the imperatives:

- Repo Page: `_download.html`
- Website Page: `https://curl.se/download.html`
  - This webpage has the broken link to download the source code package for the install
- Proposed Link: `https://mirrors.kernel.org/sources.redhat.com/cygwin/src/release/curl/curl-8.19.0-1-src.tar.xz`

## Rules

### Failed Install Rules

- **DO** run `git commit -m "INSTALL.md: update cygwin instructions"`
  - **DO NOT** run `git push`
- **DO** create a new branch for this task calle `patch-curl-cygwin-install`
  - **DO NOT** edit any existing `git` branches
- **DO** make edit to the file(s) `docs\INSTALL.md`
  - **DO NOT** edit any other file(s)

### Missing Source Link Rules

- **DO** create a file with data to use for a new issue
  - **DO NOT** use `git` or `gh` to create or manage an issue
- **DO** create a new issue for the file(s) `_download.html`
  - **DO NOT** create an issue regarding other files
 
## Closing Note
 
This use to work with the link on the https://curl.se/download.html, but after most recent curl version change, this is not working and the link is broken.
