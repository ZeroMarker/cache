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

function Insert_click()
{
	//alert(selectRow+"/"+preSelectRow);return;
	if (selectRow>0) return;
	var ARRPerDR=GetElementByElement('ARRPerDR',"V");              
	var ARRPerDRDesc=GetElementByElement('ARRPerDRDesc',"V");  
	var ARRPostDR=GetElementByElement('ARRPostDR',"V");        
	var ARRPostDRDesc=GetElementByElement('ARRPostDRDesc',"V");
	var ARRDate=GetElementByElement('ARRDate',"V");            
    var ARRRecordUser=GetElementByElement('ARRRecordUser',"V"); 
    var ARRRecDate=GetElementByElement('ARRRecDate',"V");      
    var ARRRecTime=GetElementByElement('ARRRecTime',"V");      
    var ARRMem=GetElementByElement('ARRMem',"V");              
    var ARRDepDR=GetElementByElement('ARRDepDR',"V");          
    var ARRDepDRDesc=GetElementByElement('ARRDepDRDesc',"V");  
    var ARRRelayDR=GetElementByElement('ARRRelayDR',"V");      
    var AuditDr=GetElementByElement('AuditDr',"V");   
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
	var ARRPerDR=GetElementByElement('ARRPerDR',"V");              
    var ARRPerDRDesc=GetElementByElement('ARRPerDRDesc',"V");  
    var ARRPostDR=GetElementByElement('ARRPostDR',"V");        
    var ARRPostDRDesc=GetElementByElement('ARRPostDRDesc',"V");
    var ARRDate=GetElementByElement('ARRDate',"V");            
    var ARRRecordUser=GetElementByElement('ARRRecordUser',"V"); 
    var ARRRecDate=GetElementByElement('ARRRecDate',"V");      
    var ARRRecTime=GetElementByElement('ARRRecTime',"V");      
    var ARRMem=GetElementByElement('ARRMem',"V");              
    var ARRDepDR=GetElementByElement('ARRDepDR',"V");          
    var ARRDepDRDesc=GetElementByElement('ARRDepDRDesc',"V");  
    var ARRRelayDR=GetElementByElement('ARRRelayDR',"V");      
    var AuditDr=GetElementByElement('AuditDr',"V");   
	
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
		SetElementByElement('ARRPerDR',"V",'tARRPerDRz'+selectRow,"I"," ","");
		SetElementByElement('ARRPerDRDesc',"V",'tARRPerDRDescz'+selectRow,"I"," ","");
		SetElementByElement('ARRPostDR',"V",'tARRPostDRz'+selectRow,"I"," ","");
		SetElementByElement('ARRPostDRDesc',"V",'tARRPostDRDescz'+selectRow,"I"," ","");
		SetElementByElement('ARRDate',"V",'tARRDatez'+selectRow,"I"," ","");
		SetElementByElement('ARRRecordUser',"V",'tARRRecordUser'+selectRow,"I"," ","");
		SetElementByElement('ARRRecDate',"V",'tARRRecDatez'+selectRow,"I"," ","");
		SetElementByElement('ARRRecTime',"V",'tARRRecTimez'+selectRow,"I"," ","");
		SetElementByElement('ARRMem',"V",'tARRMemz'+selectRow,"I"," ","");
		SetElementByElement('ARRDepDR',"V",'tARRDepDRz'+selectRow,"I"," ","");
		SetElementByElement('ARRDepDRDesc',"V",'tARRDepDRDescz'+selectRow,"I"," ","");
		SetElementByElement('ARRRelayDR',"V",'tARRRelayDRz'+selectRow,"I"," ","");
		SetElementByElement('AuditDr',"V",'tAuditDrz'+selectRow,"I"," ","");

		preSelectRow=selectRow;
	}
	else
	{
		SetElementByElement('ARRPerDR',"V","");              
		SetElementByElement('ARRPerDRDesc',"V","");  
		SetElementByElement('ARRPostDR',"V","");        
		SetElementByElement('ARRPostDRDesc',"V","");
		SetElementByElement('ARRDate',"V","");            
		SetElementByElement('ARRRecordUser',"V",""); 
		SetElementByElement('ARRRecDate',"V","");      
		SetElementByElement('ARRRecTime',"V","");      
		SetElementByElement('ARRMem',"V","");              
		SetElementByElement('ARRDepDR',"V","");          
		SetElementByElement('ARRDepDRDesc',"V","");  
		SetElementByElement('ARRRelayDR',"V","");      
		SetElementByElement('AuditDr',"V",""); 
		
		preSelectRow=-1
		selectRow=0
	}
}

document.body.onload=BodyLoadHandler;
