//"&MainStatusRowid=&VolStatusRowid=&WorkItemRowid=10&IsEdit=&StatusFrom=&StatusTo=12&ValidateUser=&MainRowid=8478&VolRowid="


///by wuqk 2007-03
var MainStatusRowid
var VolStatusRowid
var WorkItemRowid
var IsEdit
var StatusFrom
var StatusTo
var ValidateUser
var MainRowid
var VolRowid

var rows
var UpdateFlag

var objTable = document.getElementById("tDHC_WMR_WorkDetail");


function BodyLoadHandler() {
	SelectRowHandler();
	iniForm();
	var obj=document.getElementById("cmdOK");
	if (obj){ obj.onclick=OK_click;}
	}
	
function iniForm() {
	
	MainRowid=gGetObjValue("MainRowid");
	VolRowid=gGetObjValue("VolRowid");
	
	MainStatusRowid=gGetObjValue("MainStatusRowid");
	VolStatusRowid=gGetObjValue("VolStatusRowid");
	WorkItemRowid=gGetObjValue("WorkItemRowid");
	
	IsEdit=gGetObjValue("IsEdit");
	StatusFrom=gGetObjValue("StatusFrom");
	StatusTo=gGetObjValue("StatusTo");
	ValidateUser=gGetObjValue("ValidateUser");
	
	
	/*
	//noe edit status
	if (IsEdit!="Y"){
		var obj=document.getElementById("cmdOK");
	    //if (obj){obj.disabled=true;}
		for (i=1;i<=rows;i++){
			var RowObj=document.getElementById('ItemValuez'+i);
			RowObj.disabled=true;
			}
		}
	*/
	//no need to validate user
	/*if (ValidateUser!="Y"){	
		var obj=document.getElementById("UserToCode");
	    if (obj){obj.disabled=true;}
		var obj=document.getElementById("UserToPassWord");
	    if (obj){obj.disabled=true;}
	
	    
		gHiddenElement("cUserToCode");
		gHiddenElement("UserToCode");
		gHiddenElement("cUserToPassWord");
		gHiddenElement("UserToPassWord");
		
		}*/	
	}
function Check_Options() {
	
	return true;
	}
	
function OK_click() {
	var flag=false
	if (!flag){
		alert(flag);
		}
	//alert("OK");
	}
	
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHC_WMR_WorkDetail');
	rows=objtbl.rows.length;
	
	//var lastrowindex=rows - 1;
	
	//var rowObj=getRow(eSrc);
	//var selectrow=rowObj.rowIndex;
     
    //alert(selectrow+"/"+rows)
    
	//if (!selectrow) return;
	//alert("iSeldRow="+iSeldRow+"   selectrow="+selectrow);
	//if (iSeldRow==selectrow){

	//	return;
	//	}
	//iSeldRow=selectrow;
	//var SelRowObj
	//var obj
	
	//SelRowObj=document.getElementById('MEARowidz'+selectrow);
	//if (SelRowObj){alert(SelRowObj.value)}
	
}
function TableLostfocus() {
	var EleName=event.srcElement.name
	if (EleName){
		//document.getElementById("UserToCode").value=EleName;
	    if (EleName.indexOf("ItemValue")<0) return;
	    //var rowObj=getRow(event.srcElement)
		//var currRow=rowObj.rowIndex;
		var Temp=EleName.split("ItemValuez")
		var currRow=Temp[1]
		var RowFlag=VerifyTableData(currRow);
	    if (!RowFlag){
		    
		    //event.srcElement.focus();
		    }
		}
}
function VerifyTableData(currRow) {	
		var currValue=getElementValue("ItemValuez"+currRow);
		var txtDataType = getElementValue("DataTypez" + currRow);
		//alert("currValue="+currValue);
	    //null validate
	    var IsNeed=document.getElementById("IsNeedz"+currRow).value
	    if ((IsNeed=="Y")&&(currValue==""))
	    {
		    return getElementValue("WorkDetailDescz" + currRow) + "  is required field!\n";
		}
	
	    //numeric data format validate
	    switch(txtDataType)
	    {
			case "Text":
				break;
			case "Date":
				try
				{
					setElementValue("ItemValuez" + currRow, GetDateFromString(currValue));
				}
				catch(err)
				{
					return (getElementValue("WorkDetailDescz" + currRow) + ": " + t['IllegalDate']);
				}
				break;
			case "Number":
				if(isNaN(currValue))
				{
					return (getElementValue("WorkDetailDescz" + currRow) + ": " + t['IllegalNumber']);
				}
				break;
	    }
	    return "";
}

function ValidateContents()
{
	var strErrMsg = "";
	for(var i = 0; i < objTable.rows.length; i ++)
	{
		strErrMsg += VerifyTableData(i + 1);
	}
	setElementValue("txtErrorMsg", strErrMsg);
	setElementValue("txtIsValidatePassed", (strErrMsg.length == 0 ? "True" : "False"));
	//return strErrMsg.length == 0;
}

function initEvent()
{
	for(var i = 0; i < objTable.rows.length; i ++)
	{
		AddToControlList(document.getElementById("ItemValuez" + (i + 1)));
		document.getElementById("ItemValuez" + (i + 1)).onchange = ValidateContents;
	}
	AddToControlList(parent.frames[1].document.getElementById("cmdOK"));
	ValidateContents();
}


//document.getElementById('tDHC_WMR_WorkDetail').onfocusout = TableLostfocus;
document.body.onload = BodyLoadHandler;
initEvent();