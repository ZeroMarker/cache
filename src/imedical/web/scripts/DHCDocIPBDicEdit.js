/* =========================================================================
NAME: DHCMedDic.Edit
AUTHOR: lxf
DATE  : 2008-10-15
============================================================================ */
	//Save information into object.
	function SaveToObject()
	{
		//Rowid,Code,Desc,Type,Active,DateFrom,DateTo,StrA,StrB,StrC,StrD
		var obj = DHCMedDictionaryItem();
		obj.Rowid = document.getElementById("Rowid").value;
		obj.Code = document.getElementById("Code").value;
		obj.Desc = document.getElementById("Desc").value;
		obj.Type = document.getElementById("Type").value;
		obj.Active = document.getElementById("Active").checked;
		obj.DateFrom = document.getElementById("DateFrom").value;
		obj.DateTo = document.getElementById("DateTo").value;
		obj.StrA = document.getElementById("StrA").value;
		obj.StrB = document.getElementById("StrB").value;
		obj.StrC = document.getElementById("StrC").value;
		obj.StrD = document.getElementById("StrD").value;
		return obj;
	}


	//when "save" clicked,validate Type,Code,Desc is not empty
	function validateContents()
	{
		var objType = document.getElementById("Type");
		if (objType.value==""){
			alert(t['SelectDicType']);
			objType.focus();
			return;
		}
		
		var	objCode = document.getElementById("Code");
		if(objCode.value == "")
		{
			alert(t['InputCode']);
			objCode.focus();
			return;
		}
		
		var	objDesc = document.getElementById("Desc");
		if(objDesc.value == "")
		{
			alert(t['InputDesc']);
			objDesc.focus();
			return;
		}
		return true;
	}
	
	//Deal the "Save" clicked event.
	function cmdSaveOnclick()
	{
		if(!validateContents())
		{
			return;
		}

		if(SaveDictionary(SaveToObject()))
		{
			window.alert(t['UpdateTrue']);
			window.opener.location.href=window.opener.location.href
			window.close();
		}else
		{
			window.alert(t['UpdateFalse']);
		}
	}

	//Initialize Event
	function initEventHandler()
	{
		var objcmdSave = null;
		objcmdSave = document.getElementById("cmdSave");
		objcmdSave.onclick = cmdSaveOnclick;
	}
			
	//Initialize Form
	function initForm()
	{
		var obj=new Object();
		obj = document.getElementById("Type");
		obj.multiple= false;
		obj.size = 1;
		document.getElementById("Active").checked = true;
		DisplayDictionaryList("MethodGetDicList", "Type", "SYS", "", true);
		ProcessRequest();
		initEventHandler();
	}
	
	function ProcessRequest()
	{
		var strRowid = document.getElementById("Rowid").value;
		var objDic = null;
		if( strRowid == "")
		{
			return ;
		}
		objDic = GetDHCMedDicByID("MethodGetByRowID",strRowid);//
		if(objDic == null)
		{
			//window.alert(t['NotReadData']);
			alert("NotReadData");
		}else
		{
			DisplayDictionaryInfo(objDic);
		}
		
	}
	
	//Display the dictionary list
	function DisplayDictionaryList(methodControl, controlID, dicName, flag, displayRootDic)
	{
		var strMethod = document.getElementById(methodControl).value;
		var ret = cspRunServerMethod(strMethod, dicName , flag);
		var arrayDic = null;
		var objDic = null;
		if((ret != undefined) && (ret != ""))
		{
			//alert(ret);
			arrayDic = GetDHCMedDictionaryArray(ret);
		}
		AddListItem(controlID, t['PleaseChoose'], "");
		for(var i = 0; i < arrayDic.length; i ++)
		{
			objDic = arrayDic[i];
			AddListItem(controlID, objDic.Code + "--" + objDic.Desc , objDic.Code);
		}
		if(displayRootDic)
		{
			AddListItem(controlID, t['RootDic'], "SYS");
		}
	}

	//If Rowid exits,set exit data to the form
	function DisplayDictionaryInfo(objDic)
	{
		if(objDic == null)
		{
			document.getElementById("Rowid").value = "";
			document.getElementById("Code").value = "";
			document.getElementById("Desc").value = "";
			setElementValue("Type", "");
			document.getElementById("Active").checked = true;
			document.getElementById("DateFrom").value = "";
			document.getElementById("DateTo").value = "";
			document.getElementById("StrA").value = "";
			document.getElementById("StrB").value = "";
			document.getElementById("StrC").value = "";
			document.getElementById("StrD").value = "";
		}
		else
		{
			//Rowid,Code,Desc,Type,Active,DateFrom,DateTo,StrA,StrB,StrC,StrD
			document.getElementById("Rowid").value = objDic.RowID;
			document.getElementById("Code").value = objDic.Code;
			document.getElementById("Desc").value = objDic.Desc;
			setElementValue("Type", objDic.TypeAA,null);
			document.getElementById("Active").checked = objDic.Active;
			document.getElementById("DateFrom").value = objDic.DateFrom;
			document.getElementById("DateTo").value = objDic.DateTo;
			document.getElementById("StrA").value = objDic.StrA;
			document.getElementById("StrB").value = objDic.StrB;
			document.getElementById("StrC").value = objDic.StrC;
			document.getElementById("StrD").value = objDic.StrD;
		}
	}
	
	window.onload = initForm;