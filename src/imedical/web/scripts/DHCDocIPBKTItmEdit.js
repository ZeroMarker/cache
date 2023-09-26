	/* =========================================================================
	NAME: DHCDocIPBKTItmEdit.js
	AUTHOR: lxf
	DATE  : 2008-10-22
	============================================================================ */
	//RowID^ItemCode^ItemDesc^DateTypeID^DictionaryName^IsActive^ResumeText
	
	//Initialize Form
	function initForm()
	{
		var obj=new Object();
		objDateTypeID = document.getElementById("DateTypeID");
		objDateTypeID.multiple= false;
		objDateTypeID.size = 1;
		var objDicName = document.getElementById("DictionaryName");
		objDicName.multiple= false;
		objDicName.size = 1;
		document.getElementById("IsActive").checked = true;
		DisplayDictionaryList("MethodGetDicList", "DateTypeID", "IPBookingDataType", "Y", false,"RowID");
		DisplayDictionaryList("MethodGetDicList", "DictionaryName", "SYS", "Y", false,"Code");
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
	
	//If RowID!="",display DHCDocIPBKTempItem
	function ProcessRequest()
	{
		var strRowID = document.getElementById("RowID").value;
		var objDic = null;
		if( strRowID == "")
		{
			return ;
		}
		objDic = GetMedIPBKTempItemByID("MethodGetByRowID",strRowID);
		if(objDic == null)
		{
			//window.alert(t['NotReadData']);
			alert("NotReadData");
		}else
		{
			DisplayMedIPBKTempItem(objDic);
		}
		
	}
	//Save information into object.
	function SaveToObject()
	{
		var obj = DHCDocIPBKTempItem();
		obj.RowID = document.getElementById("RowID").value;
		obj.ItemCode = document.getElementById("ItemCode").value;
		obj.ItemDesc = document.getElementById("ItemDesc").value;
		obj.DateTypeID = getElementValue("DateTypeID");  //document.getElementById("DateTypeID").value;
		obj.DictionaryName = getElementValue("DictionaryName");  //document.getElementById("DictionaryName").value;
		obj.IsActive = document.getElementById("IsActive").checked;
		obj.ResumeText = document.getElementById("ResumeText").value;
		return obj;
	}
	
	//Display the dictionary list 
	//methodControl:item in component contained method name; 		controlID:List item in component; 
	//dicName:dictionary Code; 		flag:status of IsActive,""or"Y"or"N"; 		displayRootDic:if "SYS" displays;
	//valueFalg:the value of selected list item
	function DisplayDictionaryList(methodControl, controlID, dicName, flag, displayRootDic,valueType)
	{
		var strMethod = document.getElementById(methodControl).value;
		var ret = cspRunServerMethod(strMethod, dicName , flag);
		var arrayDic = null;
		var objDic = null;
		if((ret != undefined) && (ret != ""))
		{
			arrayDic = GetDHCMedDictionaryArray(ret);
		}
		AddListItem(controlID, t['PleaseChoose'], "");
		for(var i = 0; i < arrayDic.length; i ++)
		{
			objDic = arrayDic[i];
			var value=eval("objDic."+valueType);
			AddListItem(controlID,  objDic.Desc , value);
		}
		if(displayRootDic)
		{
			AddListItem(controlID, t['RootDic'], "SYS");
		}
	}
	
	//Deal the event when "Save" clicked 
	function cmdSaveOnclick()
	{
		if(!validateContents())
		{
			return;
		}
		var ret=SaveMedIPBKTempItem(SaveToObject())
		if(ret=="-1"){
			alert("´úÂëÖØ¸´")
		}else if(ret>0){
			window.alert(t['UpdateTrue']);
			window.close();
		}else{
			window.alert(t['UpdateFalse']);
		}
		
		/*if(SaveMedIPBKTempItem(SaveToObject()))
		{
			window.alert(t['UpdateTrue']);
			window.close();
		}else
		{
			window.alert(t['UpdateFalse']);
		}*/
	}
	
	//If Rowid exits,set exit data to the form
	function DisplayMedIPBKTempItem(objDic)
	{
		
		if(objDic == null)
		{
			document.getElementById("RowID").value = "";
			document.getElementById("ItemCode").value = "";
			document.getElementById("ItemDesc").value = "";
			setElementValue("DateTypeID", "");
			document.getElementById("DictionaryName").value = "";
			document.getElementById("IsActive").checked = true;
			document.getElementById("ResumeText").value = "";
		}
		else
		{
			document.getElementById("RowID").value = objDic.RowID;
			document.getElementById("ItemCode").value = objDic.ItemCode;
			document.getElementById("ItemDesc").value = objDic.ItemDesc;
			setElementValue("DateTypeID", objDic.DateTypeID);
			setElementValue("DictionaryName", objDic.DictionaryName);
			document.getElementById("IsActive").checked = objDic.IsActive;
			document.getElementById("ResumeText").value = objDic.ResumeText;
		}
	}
	
	//When "save" clicked,validate ItemCode,ItemDesc,DateTypeID is not empty
	function validateContents()
	{
		var objItemCode = document.getElementById("ItemCode");
		if (objItemCode.value==""){
			alert(t['InputItemCode']);
			objItemCode.focus();
			return;
		}
		
		var	objItemDesc = document.getElementById("ItemDesc");
		if(objItemDesc.value == "")
		{
			alert(t['InputItemDesc']);
			objItemDesc.focus();
			return;
		}
		
		var	objDateTypeID = document.getElementById("DateTypeID");
		if(objDateTypeID.value == "")
		{
			alert(t['SelectDicType']);
			objDateTypeID.focus();
			return;
		}
		return true;
	}
	window.onload = initForm;