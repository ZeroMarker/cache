// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 2.07.02

function DocumentLoadHandler()
{
  var obj=document.getElementById("WITParamComponentDR");
  var objID=document.getElementById("ID");
  
  if ((objID)&&(objID.value==""))
  {
   if (obj) obj.value="epr.WorklistItemParams.Edit";
  }
  
  return;
}

document.body.onload=DocumentLoadHandler;
