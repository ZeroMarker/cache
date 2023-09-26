var preSelectRow=-1;
var selectRow=0;

function BodyLoadHandler()
{
	var objInsert=document.getElementById("Insert");
	if (objInsert) objInsert.onclick=Insert_click;
	var objUpdate=document.getElementById("Update");
	if (objUpdate) objUpdate.onclick=Update_click;
	var objDelete=document.getElementById("Delete");
	if (objDelete) objDelete.onclick=Delete_click;
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCCLCLog');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	selectRow=rowObj.rowIndex;
	if (!selectRow) return;
	
	if (preSelectRow!=selectRow)
	{
		SetElementByElement('clclogCode',"V",'tClclogCodez'+selectRow,"I"," ","");
		SetElementByElement('clclogDesc',"V",'tClclogDescz'+selectRow,"I"," ","");
		SetElementByElement('clclogType',"V",'tClclogTypez'+selectRow,"I"," ","");
		SetElementByElement('clclogValueList',"V",'tClclogValueListz'+selectRow,"I"," ","");
		SetElementByElement('clclogValueListDesc',"V",'tClclogValueListDescz'+selectRow,"I"," ","");
		SetElementByElement('clclogIfAddInfo',"V",'tClclogIfAddInfoz'+selectRow,"I"," ","");
		SetElementByElement('clclogDefault',"V",'tClclogDefaultz'+selectRow,"I"," ","");
		SetElementByElement('clclogSortNo',"V",'tClclogSortNoz'+selectRow,"I"," ","");

		preSelectRow=selectRow;
	}
	else
	{
		SetElementValue('clclogCode',"V","");
		SetElementValue('clclogDesc',"V","");
		SetElementValue('clclogType',"V","");
		SetElementValue('clclogValueList',"V","");
		SetElementValue('clclogValueListDesc',"V","");
		SetElementValue('clclogIfAddInfo',"V","");
		SetElementValue('clclogDefault',"V","");
		SetElementValue('clclogSortNo',"V","");
		preSelectRow=-1
		selectRow=0
	}
}

function Insert_click()
{
	//alert(selectRow+"/"+preSelectRow);return;
	if (selectRow>0) return;
	var clclogCode=GetElementValue('clclogCode',"V");
	var clclogDesc=GetElementValue('clclogDesc',"V");
	var clclogType=GetElementValue('clclogType',"V");
	var clclogValueList=GetElementValue('clclogValueList',"V");
	var clclogValueListDesc=GetElementValue('clclogValueListDesc',"V");
	var clclogIfAddInfo=GetElementValue('clclogIfAddInfo',"V");
	var clclogDefault=GetElementValue('clclogDefault',"V");
	var clclogSortNo=GetElementValue('clclogSortNo',"V");

	var obj=document.getElementById('InsertCLCLog')
	if(obj) 
	{
		var insertCLCLog=obj.value;
		var retStr=cspRunServerMethod(insertCLCLog,clclogCode,clclogDesc,clclogType,clclogValueList,clclogValueListDesc,clclogIfAddInfo,clclogDefault,clclogSortNo);
		if (retStr!=0) alert(retStr);
		else Find_click();
	}
}

function Update_click()
{
	//alert(selectRow+"/"+preSelectRow);return;
	if (selectRow<1) return;
	var clclogId=GetElementValue('tClclogIdz'+selectRow,"I");
	var clclogCode=GetElementValue('clclogCode',"V");
	var clclogDesc=GetElementValue('clclogDesc',"V");
	var clclogType=GetElementValue('clclogType',"V");
	var clclogValueList=GetElementValue('clclogValueList',"V");
	var clclogValueListDesc=GetElementValue('clclogValueListDesc',"V");
	var clclogIfAddInfo=GetElementValue('clclogIfAddInfo',"V");
	var clclogDefault=GetElementValue('clclogDefault',"V");
	var clclogSortNo=GetElementValue('clclogSortNo',"V");
	
	var obj=document.getElementById('UpdateCLCLog');
	if(obj) 
	{
		var updateCLCLog=obj.value;
		retStr=cspRunServerMethod(updateCLCLog,clclogId,clclogCode,clclogDesc,clclogType,clclogValueList,clclogValueListDesc,clclogIfAddInfo,clclogDefault,clclogSortNo);
		if (retStr!=0) alert(retStr);
		else Find_click();
	}
}

function Delete_click()
{
	//alert(selectRow+"/"+preSelectRow);return;
	if (selectRow<1) return;
	var clclogId=GetElementValue('tClclogIdz'+selectRow,"I");
	
	var obj=document.getElementById('DeleteCLCLog')
	if(obj) 
	{
		var deleteCLCLog=obj.value;
		retStr=cspRunServerMethod(deleteCLCLog,clclogId);
		if (retStr!=0) alert(retStr);
		else Find_click();
	}	
}

document.body.onload=BodyLoadHandler;
