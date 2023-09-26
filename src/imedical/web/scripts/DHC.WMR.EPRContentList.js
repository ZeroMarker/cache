function InitFrom()
{
	var obj=document.getElementById("btnUpdates");
	if (obj){obj.onclick = btnUpdates_click;}
	var objTable=document.getElementById("tDHC_WMR_EPRContentList");
	for (var i=1;i<objTable.rows.length;i++){
		var obj=document.getElementById("btnUpdatez"+i);
		if (obj){
			obj.onclick = btnUpdate_click;
		}
		var obj=document.getElementById("EPRContentz"+i);
		if (obj){
			obj.size=1;
			obj.multiple=false;
		}
	}
}

function btnUpdates_click()
{
	var objTable=document.getElementById("tDHC_WMR_EPRContentList");
	for (var Id=1;Id<objTable.rows.length;Id++){
		if (getElementValue("chkChangez" + Id)==true)
		{
			var Rowid=getElementValue("Rowidz" + Id);
			var TemplateID=getElementValue("TemplateIDz" + Id);
			var EPRContent=getElementValue("EPRContentz" + Id);
			var IsActive="N";
			if (getElementValue("IsActivez" + Id)==true){IsActive="Y";}
			var Resume=getElementValue("Resumez" + Id);
			var Text1=getElementValue("Text1z" + Id);
			var Text2=getElementValue("Text2z" + Id);
			var InPut=Rowid+"^"+TemplateID+"^"+EPRContent+"^"+IsActive+"^"+Resume+"^"+Text1+"^"+Text2
			var strMethod = document.getElementById("MethodUpdateEPRContent").value;
			var ret = cspRunServerMethod(strMethod,InPut);
			if (ret<1) {
				alert("Index=" + Id + ",TemplateID=" + TemplateID + ",Update Data Error!ret="+ret);
				return;
			}
		}
	}
	location.reload();
}

function btnUpdate_click()
{
	var Id=window.event.srcElement.id.replace("btnUpdatez", "")
	var Rowid=getElementValue("Rowidz" + Id);
	var TemplateID=getElementValue("TemplateIDz" + Id);
	var EPRContent=getElementValue("EPRContentz" + Id);
	var IsActive="N";
	if (getElementValue("IsActivez" + Id)==true)
	{
		IsActive="Y";
	}
	var Resume=getElementValue("Resumez" + Id);
	var Text1=getElementValue("Text1z" + Id);
	var Text2=getElementValue("Text2z" + Id);
	var InPut=Rowid+"^"+TemplateID+"^"+EPRContent+"^"+IsActive+"^"+Resume+"^"+Text1+"^"+Text2
	var strMethod = document.getElementById("MethodUpdateEPRContent").value;
	var ret = cspRunServerMethod(strMethod,InPut);
	if (ret<1) {
		alert("Update Data Error!ret="+ret);
	}else{
		alert("Update Data Successful!");
	}
	location.reload();
}

InitFrom();