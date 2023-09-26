' Symantec ScriptBlocking Authenticated File
' F6A2E2E3-8340-4B22-B6EB-B324AA33F985

   Dim fso, f, f1, fc, s
   Set fso = CreateObject("Scripting.FileSystemObject")
   Set f = fso.GetFolder(".")
   Set fc = f.Files
   For Each f1 in fc
      fso.MoveFile f1.name,lcase(f1.name)
   Next
