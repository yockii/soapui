@echo off

set SOAPUI_HOME=%~dp0
set JAVA=%JAVA_HOME%\bin\java

if not "%JAVA_HOME%" == "" goto SET_CLASSPATH

set JAVA=java

echo JAVA_HOME is not set, unexpected results may occur.
echo Set JAVA_HOME to the directory of your local JDK to avoid this message.

:SET_CLASSPATH

rem init classpath

set CLASSPATH=%SOAPUI_HOME%${project.src.artifactId}-${project.version}.jar;%SOAPUI_HOME%..\lib\*
"%JAVA%" -cp "%CLASSPATH%" com.eviware.soapui.tools.JfxrtLocator > %TEMP%\jfxrtpath
set /P JFXRTPATH= < %TEMP%\jfxrtpath
del %TEMP%\jfxrtpath
set CLASSPATH=%CLASSPATH%;%JFXRTPATH%

rem JVM parameters, modify as appropriate
set JAVA_OPTS=-Xms128m -Xmx1024m -Dsoapui.properties=soapui.properties "-Dsoapui.home=%SOAPUI_HOME%\"

rem CVE-2021-44228
set JAVA_OPTS=%JAVA_OPTS% -Dlog4j2.formatMsgNoLookups=true

if "%SOAPUI_HOME%\" == "" goto START
    set JAVA_OPTS=%JAVA_OPTS% -Dsoapui.ext.libraries="%SOAPUI_HOME%ext"
    set JAVA_OPTS=%JAVA_OPTS% -Dsoapui.ext.listeners="%SOAPUI_HOME%listeners"
    set JAVA_OPTS=%JAVA_OPTS% -Dsoapui.ext.actions="%SOAPUI_HOME%actions"

:START

rem ********* run soapui testcase runner ***********

"%JAVA%" %JAVA_OPTS% -cp "%CLASSPATH%" com.eviware.soapui.tools.SoapUISecurityTestRunner %*