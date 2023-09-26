/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMRDictionary.Edit

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-7
============================================================================ */



	
	function DisplayDictionaryInfo(objDic)
	{
		if(objDic == null)
		{
			document.getElementById("RowID").value = "";
			document.getElementById("txtCode").value = "";
			document.getElementById("txtContent").value = "";
			document.getElementById("txtFromDate").value = "";
			document.getElementById("txtToDate").value = "";
			document.getElementById("txtAppendix1").value = "";
			document.getElementById("txtAppendix2").value = "";
			document.getElementById("txtAppendix3").value = "";
			document.getElementById("txtAppendix4").value = "";
			document.getElementById("chkActive").checked = true;
			document.getElementById("txtResume").value = "";
			obj = document.getElementById("cboDictionaryName");
			obj.selectedIndex = 0;
			for(var i = 0; i < obj.options.length; i ++)
			{
				if(obj.options.item(i).value == objDic.DictionaryName)
				{
					obj.selectedIndex = i;
				}
			}
			document.getElmentById("txtResume").value = "";
		}
		else
		{
			document.getElementById("RowID").value = objDic.RowID;
			document.getElementById("txtCode").value = objDic.Code;
			document.getElementById("txtContent").value = objDic.Description;
			document.getElementById("txtFromDate").value = objDic.FromDate;
			document.getElementById("txtToDate").value = objDic.ToDate;
			document.getElementById("txtAppendix1").value = objDic.TextA;
			document.getElementById("txtAppendix2").value = objDic.TextB;
			document.getElementById("txtAppendix3").value = objDic.TextC;
			document.getElementById("txtAppendix4").value = objDic.TextD;
			document.getElementById("chkActive").checked = objDic.IsActive;
			document.getElementById("txtResume").value = objDic.ResumeText;
			setElementValue("cboDicType", objDic.DictionaryName);
		}
	}
	
	//Save information into object.
	function SaveToObject()
	{
		var obj = DHCWMRDictionary();
		obj.RowID = getElementValue("RowID");
		obj.Code = getElementValue("txtCode");
		obj.Description = getElementValue("txtContent");
		obj.FromDate = getElementValue("txtFromDate");
		obj.ToDate = getElementValue("txtToDate");
		obj.TextA = getElementValue("txtAppendix1");
		obj.TextB = getElementValue("txtAppendix2");
		obj.TextC = getElementValue("txtAppendix3");
		obj.TextD = getElementValue("txtAppendix4");
		obj.IsActive = getElementValue("chkActive");
		obj.ResumeText = getElementValue("txtResume");		
		obj.DictionaryName = getElementValue("cboDicType");
		return obj;
	}


	function validateContents()
	{
		var obj = null;
		obj = document.getElementById("cboDicType");
		if(obj.value == "")
		{
			window.alert(t['SelectDicType']);
			obj.focus();
			return;
		}
		obj = document.getElementById("txtCode");
		if(obj.value == "")
		{
 			window.alert(t['DicCode']);
 			obj.focus();
 			return false;
 		}
 		obj = document.getElementById("txtContent");
 		if(obj.value == "")
 		{
 			window.alert(t['DicDesc']);
 			obj.focus();
 			return false;
 		}
		return true;
	}
	
	function SaveDictionary(objDic)
	{
		var encmeth = document.getElementById("MethodSave").value;
		var ret=cspRunServerMethod(encmeth, SerializeDHCWMRDictionary(objDic));
		return (ret != undefined);
	}
	

	function ProcessRequest()
	{
		var strRowID = document.getElementById("RowID").value
		var objDic = null;
		if( strRowID == "")
		{
			return ;
		}
		objDic = GetDHCWMRDictionaryByID("MethodGetByRowID", strRowID);
		if(objDic == null)
		{
			window.alert(t['NotReadData']);
		}else
		{
			DisplayDictionaryInfo(objDic);
		}
		
	}
	
	//Initialize Form
	function initForm()
	{
		obj = document.getElementById("cboDicType");
		obj.multiple= false;
		obj.size = 1;
		document.getElementById("chkActive").checked = true;
		DisplayDictionaryListPrivate("MethodGetDicList", "cboDicType", "SYS", "", true);
		ProcessRequest();
	}
	
	//Initialize Event
	function initEventHandler()
	{
		var obj = null;
		obj = document.getElementById("cmdSave");
		obj.onclick = cmdSaveOnclick;
	}
	
	function cmdSaveOnclick()
	{
		if(!validateContents())
		{
			return;
		}
		if(SaveDictionary(SaveToObject()))
		{
			window.alert(t['UpdateTrue']);
			window.close();
		}else
		{
			window.alert(t['UpdateFalse']);
		}
	}
	
	initForm();	
	initEventHandler();