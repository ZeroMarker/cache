	/* =========================================================================
	NAME: DHCMedIPBKTemp.Edit.js
	AUTHOR: lxf
	DATE  : 2008-10-24
	============================================================================ */
	//RowID^TempCode^TempDesc^IsActive^ResumeText
	
	//Initialize Form
	function initForm()
	{
		document.getElementById("IsActive").checked = true;
		//DisplayDictionaryList("MethodGetDicList", "DateTypeID", "SYS", "", false);
		ProcessRequest();
		initEventHandler();
	}
	//Initialize Event
	function initEventHandler()
	{
		var objcmdSave = null;
		objcmdSave = document.getElementById("cmdSave");
		objcmdSave.onclick = cmdSaveOnclick;
	}
	
	//If RowID!="",display DHCMedIPBKTemplate
	function ProcessRequest()
	{
		var strRowID = document.getElementById("RowID").value;
		var objDic = null;
		if( strRowID == "")
		{
			return ;
		}
		objDic = GetMedIPBKTemplateByID("MethodGetByRowID",strRowID);
		if(objDic == null)
		{
			//window.alert(t['NotReadData']);
			alert("NotReadData");
		}else
		{
			DisplayMedIPBKTemplate(objDic);
		}
		
	}
	//Save information into object.
	function SaveToObject()
	{
		var obj = DHCMedIPBKTemplate();
		obj.RowID = document.getElementById("RowID").value;
		obj.TempCode = document.getElementById("TempCode").value;
		obj.TempDesc = document.getElementById("TempDesc").value;
		obj.IsActive = document.getElementById("IsActive").checked;
		obj.ResumeText = document.getElementById("ResumeText").value;
		return obj;
	}
	

	//Deal the event when "Save" clicked 
	function cmdSaveOnclick()
	{
		
		if(!validateContents())
		{
			return;
		}
		
		if(SaveMedIPBKTemplate(SaveToObject()))
		{
			window.alert(t['UpdateTrue']);
			window.close();
		}else
		{
			window.alert(t['UpdateFalse']);
		}
	}

	//If Rowid exits,set exit data to the form
	function DisplayMedIPBKTemplate(objDic)
	{
		
		if(objDic == null)
		{
			document.getElementById("RowID").value = "";
			document.getElementById("TempCode").value = "";
			document.getElementById("TempDesc").value = "";
			document.getElementById("IsActive").checked = true;
			document.getElementById("ResumeText").value = "";
		}
		else
		{
			document.getElementById("RowID").value = objDic.RowID;
			document.getElementById("TempCode").value = objDic.TempCode;
			document.getElementById("TempDesc").value = objDic.TempDesc;
			document.getElementById("IsActive").checked = objDic.IsActive;
			document.getElementById("ResumeText").value = objDic.ResumeText;
		}
	}
	
	//When "save" clicked,validate TempCode,TempDesc is not empty
	function validateContents()
	{
		var objTempCode = document.getElementById("TempCode");
		if (objTempCode.value==""){
			alert(t['InputTempCode']);
			objTempCode.focus();
			return;
		}
		
		var	objTempDesc = document.getElementById("TempDesc");
		if(objTempDesc.value == "")
		{
			alert(t['InputTempDesc']);
			objTempDesc.focus();
			return;
		}
		
		return true;
	}
	window.onload = initForm;