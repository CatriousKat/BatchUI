@echo off

REM BatchUI 1.0.2

if "%~1"=="" exit /b
goto %~1

:BatchUI_Init
    set "UI_Title=%~2"
    if "%UI_Title%"=="" set "UI_Title=BatchUI Application"
    set "UI_Width=%~3"
    if "%UI_Width%"=="" set "UI_Width=480"
    set "UI_Height=%~4"
    if "%UI_Height%"=="" set "UI_Height=420"
    
    set "UI_BodyFile=%temp%\batchui_body_%RANDOM%.tmp"
    if exist "%UI_BodyFile%" del "%UI_BodyFile%"
exit /b

:BatchUI_AddHeading
    >> "%UI_BodyFile%" echo ^<h2 style='margin:10px 0; font-family:Segoe UI, sans-serif; color:#222;'^>%~2^</h2^>
exit /b

:BatchUI_AddSubHeading
    >> "%UI_BodyFile%" echo ^<h4 style='margin:5px 0 15px 0; font-family:Segoe UI, sans-serif; color:#666; font-weight:normal;'^>%~2^</h4^>
exit /b

:BatchUI_AddText
    >> "%UI_BodyFile%" echo ^<div style='margin:8px 0; font-family:Segoe UI, sans-serif; font-size:13px; color:#333; text-align:left;'^>%~2^</div^>
exit /b

:BatchUI_AddInput
    >> "%UI_BodyFile%" echo ^<div style='margin:8px 0; text-align:left;'^>^&nbsp;^<label style='font-family:Segoe UI; font-size:12px; font-weight:bold; color:#444;'^>%~2^</label^>^<br^>^&nbsp;^<input type='text' id='%~3' value='%~4' style='padding:5px; width:95%%; font-family:Segoe UI; font-size:13px;' /^>^</div^>
exit /b

:BatchUI_AddTextArea
    >> "%UI_BodyFile%" echo ^<div style='margin:8px 0; text-align:left;'^>^&nbsp;^<label style='font-family:Segoe UI; font-size:12px; font-weight:bold; color:#444;'^>%~2^</label^>^<br^>^&nbsp;^<textarea id='%~3' style='padding:5px; width:95%%; height:60px; font-family:Segoe UI; font-size:13px;'^>%~4^</textarea^>^</div^>
exit /b

:BatchUI_AddCheckbox
    set "chkState="
    if /i "%~4"=="true" set "chkState=checked"
    >> "%UI_BodyFile%" echo ^<div style='margin:10px 0; text-align:left;'^>^&nbsp;^<input type='checkbox' id='%~3' %chkState% /^> ^<label style='font-family:Segoe UI; font-size:13px; color:#333;'^>%~2^</label^>^</div^>
exit /b

:BatchUI_AddSelect
    (
        echo ^<div style='margin:8px 0; text-align:left;'^>^&nbsp;^<label style='font-family:Segoe UI; font-size:12px; font-weight:bold; color:#444;'^>%~2^</label^>^<br^>^&nbsp;^<select id='%~3' style='padding:5px; width:97%%; font-family:Segoe UI; font-size:13px;'^>
        for %%a in (%~4) do (
            echo   ^<option value="%%a"^>%%a^</option^>
        )
        echo ^</select^>^</div^>
    ) >> "%UI_BodyFile%"
exit /b

:BatchUI_AddHR
    >> "%UI_BodyFile%" echo ^<hr style='border:0; border-top:1px solid #ccc; margin:15px 0;'^>
exit /b

:BatchUI_AddButton
    >> "%UI_BodyFile%" echo ^<button onclick="%~3" style='padding:7px 16px; margin:4px; font-family:Segoe UI; font-size:13px; cursor:pointer;'^>%~2^</button^>
exit /b

:BatchUI_Run
    set "UI_TempFile=%temp%\batchui_%RANDOM%.hta"
    set "UI_SafeTemp=%temp:\=/%"
    
    >  "%UI_TempFile%" echo ^<!DOCTYPE HTML^>
    >> "%UI_TempFile%" echo ^<HTML^>
    >> "%UI_TempFile%" echo ^<HEAD^>
    >> "%UI_TempFile%" echo   ^<TITLE^>%UI_Title%^</TITLE^>
    >> "%UI_TempFile%" echo   ^<HTA:APPLICATION APPLICATIONNAME="BatchUI" SCROLL="yes" SINGLEINSTANCE="yes" BORDER="thick" INNERBORDER="no"/^>
    >> "%UI_TempFile%" echo   ^<SCRIPT type="text/javascript"^>
    >> "%UI_TempFile%" echo     window.resizeTo(%UI_Width%, %UI_Height%);
    >> "%UI_TempFile%" echo     window.moveTo((screen.width - %UI_Width%)/2, (screen.height - %UI_Height%)/2);
    >> "%UI_TempFile%" echo     function returnVal(val) {
    >> "%UI_TempFile%" echo       try {
    >> "%UI_TempFile%" echo         var fso = new ActiveXObject("Scripting.FileSystemObject");
    >> "%UI_TempFile%" echo         var file = fso.CreateTextFile("%UI_SafeTemp%/batchui_result.txt", true);
    >> "%UI_TempFile%" echo         file.WriteLine(val);
    >> "%UI_TempFile%" echo         file.Close();
    >> "%UI_TempFile%" echo       } catch(e) {}
    >> "%UI_TempFile%" echo       window.close();
    >> "%UI_TempFile%" echo     }
    >> "%UI_TempFile%" echo     function submitForm() {
    >> "%UI_TempFile%" echo       var data = {};
    >> "%UI_TempFile%" echo       var inputs = document.getElementsByTagName('input');
    >> "%UI_TempFile%" echo       for(var i=0; i^<inputs.length; i++) {
    >> "%UI_TempFile%" echo         if(inputs[i].type == 'checkbox') { data[inputs[i].id] = inputs[i].checked; }
    >> "%UI_TempFile%" echo         else { data[inputs[i].id] = inputs[i].value; }
    >> "%UI_TempFile%" echo       }
    >> "%UI_TempFile%" echo       var textareas = document.getElementsByTagName('textarea');
    >> "%UI_TempFile%" echo       for(var i=0; i^<textareas.length; i++) { data[textareas[i].id] = textareas[i].value; }
    >> "%UI_TempFile%" echo       var selects = document.getElementsByTagName('select');
    >> "%UI_TempFile%" echo       for(var i=0; i^<selects.length; i++) { data[selects[i].id] = selects[i].value; }
    >> "%UI_TempFile%" echo       var arr = [];
    >> "%UI_TempFile%" echo       for(var key in data) { if(data.hasOwnProperty(key)) { arr.push(key + "=" + data[key]); } }
    >> "%UI_TempFile%" echo       returnVal(arr.join("\r\n"));
    >> "%UI_TempFile%" echo     }
    >> "%UI_TempFile%" echo   ^</SCRIPT^>
    >> "%UI_TempFile%" echo ^</HEAD^>
    >> "%UI_TempFile%" echo ^<BODY style="background-color:#f4f4f4; padding:15px; text-align:center;"^>
    
    if exist "%UI_BodyFile%" type "%UI_BodyFile%" >> "%UI_TempFile%"
    
    >> "%UI_TempFile%" echo ^</BODY^>
    >> "%UI_TempFile%" echo ^</HTML^>

    if exist "%temp%\batchui_result.txt" del "%temp%\batchui_result.txt"
    
    start /wait mshta.exe "%UI_TempFile%"
    
    set "BatchUI_Status=OK"
    if not exist "%temp%\batchui_result.txt" set "BatchUI_Status=CANCELLED"
exit /b