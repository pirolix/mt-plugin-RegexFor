@ECHO OFF
ECHO $Id$

REM SubWCRev を用いてキーワード置換を行う
REM http://tortoisesvn.net/docs/release/TortoiseSVN_ja/tsvn-subwcrev-keywords.html

FOR /F "delims=" %%F in ('FINDSTR /S /M "$WC" .\*') do (
    ECHO Processing %%F
    COPY /Y "%%F" "%%F.bak"
    SubWCRev . "%%F" "%%F" -q
)
PAUSE
