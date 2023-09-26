//var SelectRow=0;
var preSelectRow=-1;
var selectRow = 0;
/*function BodyLoadHandler(){
	var obj=document.getElementById('BADD')
	if(obj) obj.onclick=BADD_click;
	var obj=document.getElementById('BUpdate')
	if(obj) obj.onclick=BUpdate_click;
	var obj=document.getElementById('BDelete')
	if(obj) obj.onclick=BDelete_click;
	var obj=document.getElementById('BAutoAddRoom')
	if(obj) obj.onclick=BAutoAddRoom_click;
	
}*/
function BodyLoadHandler()
{   
    
	var addObj=document.getElementById('Add')
	if(addObj) addObj.onclick=Add_click;
	var updateObj=document.getElementById('Update')
	if(updateObj) updateObj.onclick=Update_click;
	var deleteObj=document.getElementById('Delete')
	if(deleteObj)deleteObj.onclick=Delete_click;
	//alert(deleteObj+"\n"+updateObj+"\n"+addObj)
	
	//var autoAddRoomObj=document.getElementById('BAutoAddRoom')
	//if(autoAddRoomObj) autoAddRoomObj.onclick=BAutoAddRoom_click;
	
}
 /*function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANCRoom');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('OPRRowid');
	var obj1=document.getElementById('OPRCTLoc');
	var obj2=document.getElementById('OPRCode');
	var obj3=document.getElementById('OPRDesc');
	var obj4=document.getElementById('OPRLocID');
	
	var SelRowObj=document.getElementById('TOPRRowidz'+selectrow);
	var SelRowObj1=document.getElementById('TOPRCTLocz'+selectrow);
	var SelRowObj2=document.getElementById('TOPRCodez'+selectrow);
	var SelRowObj3=document.getElementById('TOPRDescz'+selectrow);
	var SelRowObj4=document.getElementById('LocIDz'+selectrow);

	if (obj) obj.value=SelRowObj.innerText;
	if (obj1) obj1.value=SelRowObj1.innerText;
	obj2.value=SelRowObj2.innerText;
	obj3.value=SelRowObj3.innerText;
	obj4.value=SelRowObj4.innerText;
	SelectedRow=selectrow;
	return;
	}*/
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCANCRoom');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	selectRow=rowObj.rowIndex
	if(!selectRow) return;
	if(preSelectRow!=selectRow)
	{
	  SetElementByElement('oprId',"V",'tOprIdz'+selectRow,"I"," ","")
	  SetElementByElement('oprCtLoc',"V",'tOprCtLocz'+selectRow,"I"," ","")
	  SetElementByElement('oprCode',"V",'tOprCodez'+selectRow,"I"," ","")
	  SetElementByElement('oprDesc',"V",'tOprDescz'+selectRow,"I"," ","")
	  SetElementByElement('oprLocId',"V",'tOprCtLocIdz'+selectRow,"I"," ","")
	  SetElementByElement('oprCtFloor',"V",'tOprCtFloorz'+selectRow,"I"," ","")
	  SetElementByElement('oprCtDefUse',"V",'tOprCtDefUsez'+selectRow,"I"," ","")
	  SetElementByElement('oprAvailable',"V",'tOprAvailablez'+selectRow,"I"," ","")
	  SetElementByElement('oprNotAvailReason',"V",'tOprNotAvailReasonz'+selectRow,"I"," ","")
	  SetElementByElement('oprCtType',"V",'tOprCtTypez'+selectRow,"I"," ","")
	  SetElementByElement('oprCtFloorId',"V",'tOprCtFloorIdz'+selectRow,"I"," ","")
	  SetElementByElement('oprCtDefUseId',"V",'tOprCtDefUseIdz'+selectRow,"I"," ","")
	  SetElementByElement('oprNotAvailReasonId',"V",'tOprNotAvailReasonIdz'+selectRow,"I"," ","")
	  SetElementByElement('oprCtTypeId',"V",'tOprCtTypeIdz'+selectRow,"I"," ","")
	  preSelectRow=selectRow
	}
    else
	{
		SetElementValue('oprCtLoc',"V","")
		SetElementValue('oprCode',"V","")
		SetElementValue('oprDesc',"V","")
		SetElementValue('oprLocId',"V","")
		SetElementValue('oprCtFloor',"V","")
		SetElementValue('oprCtDefUse',"V","")
		SetElementValue('oprAvailable',"V","")
		SetElementValue('oprNotAvailReason',"V","")
		SetElementValue('oprCtType',"V","")
		SetElementValue('oprCtFloorId',"V","")
		SetElementValue('oprCtDefUseId',"V","")
		SetElementValue('oprNotAvailReasonId',"V","")
		preSelectRow=-1
		selectRow=0
	}
}
/*function BADD_click(){
	var obj=document.getElementById('OPRCode')
	if(obj) var OPRCode=obj.value;
	if(OPRCode==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('OPRDesc')
	if(obj) var OPRDesc=obj.value;
	if(OPRDesc==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('RepOperRoom')
	if(obj) var Rerencmeth=obj.value;
	var repflag=cspRunServerMethod(Rerencmeth,OPRCode,OPRDesc)
	if(repflag=="Y"){
		alert(t['03'])
		 return;
		}
	var obj=document.getElementById('OPRLocID')
	if(obj) var LocID=obj.value;
	var obj=document.getElementById('InsertOperRoom')
	if(obj) var encmeth=obj.value;
    if (cspRunServerMethod(encmeth,LocID,OPRCode,OPRDesc)!='0')
		{alert(t['baulk']);
		return;}	
	try {		   
	    alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}*/
function Add_click()
{
	var oprCode=GetElementValue('oprCode',"V")
	if(oprCode==""){
		alert(t['01']) 
		return;
		}
	var oprDesc=GetElementValue('oprDesc',"V")
	if(oprDesc==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('RepOperRoom')
	if(obj) var Rerencmeth=obj.value;
	var repflag=cspRunServerMethod(Rerencmeth,oprCode,oprDesc)
	if(repflag=="Y"){
		alert(t['03'])
		 return;
		}
	var oprLocId=GetElementValue('oprLocId',"V")
	var oprCtFloorId=GetElementValue('oprCtFloorId',"V")
	if(oprCtFloorId==""){
		alert(t['05']) 
		return;
		}
    var oprCtTypeId=GetElementValue('oprCtTypeId',"V")
	var oprCtDefUseId=GetElementValue('oprCtDefUseId',"V")
	var oprAvailable=GetElementValue('oprAvailable',"V")
	var oprNotAvailReasonId=GetElementValue('oprNotAvailReasonId',"V")
	var BedType=GetElementValue('BedType',"V")
	//alert(OPRCodeObj+"/"+OPRDescObj+"/"+OPRLocIDObj+"/"+OPRCTFloorIDObj)
	var obj=document.getElementById('InsertOperRoom')
	if(obj) var encmeth=obj.value;
	if (cspRunServerMethod(encmeth,oprLocId,oprCode,oprDesc,oprCtFloorId,oprCtTypeId,oprCtDefUseId,oprAvailable,oprNotAvailReasonId,BedType)!='0')
		{alert(t['baulk']);
		return;}	
	try {		   
	    alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	
	
}
/*function BUpdate_click(){
	var obj=document.getElementById('OPRRowid')
	if(obj) var OPRRowid=obj.value;
	if(OPRRowid==""){
		alert(t['04']) 
		return;
		}
	var obj=document.getElementById('OPRCode')
	if(obj) var OPRCode=obj.value;
	if(OPRCode==""){
		alert(t['01']) 
		return;
		}
	var obj=document.getElementById('OPRDesc')
	if(obj) var OPRDesc=obj.value;
	if(OPRDesc==""){
		alert(t['02']) 
		return;
		}
	var obj=document.getElementById('RepOperRoom')//判断重复房间可去掉因为可能更新的就是原来的房间
	if(obj) var Rerencmeth=obj.value;
	var repflag=cspRunServerMethod(Rerencmeth,OPRCode,OPRDesc)
	if(repflag=="Y"){
		alert(t['03'])
		 return;
		} 
	var obj=document.getElementById('OPRLocID')
	if(obj) var LocID=obj.value;
	var obj=document.getElementById('UpdateOperRoom')
	if(obj) var encmeth=obj.value;
	if (cspRunServerMethod(encmeth,OPRRowid,LocID,OPRCode,OPRDesc)!='0')
		{alert(t['baulk']);
		return;}	
	try {		   
	    alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}*/

function Update_click()
{   //alert(selectRow+"/"+preSelectRow); return;
   	if(selectRow<1) 
   	{alert("未选中")
   	return;}
   	var oprCtLoc=GetElementValue('oprCtLoc',"V")
	if(oprCtLoc!="")
	{ var oprLocId=GetElementValue('oprLocId',"V")}
	else
	{
		SetElementValue('oprLocId',"V","");
		oprLocId=GetElementValue('oprLocId',"V")
	}
	var oprCtDefUse=GetElementValue('oprCtDefUse',"V")
	if(oprCtDefUse!="")
	{ var oprCtDefUseId=GetElementValue('oprCtDefUseId',"V")}
	else
	{
		SetElementValue('oprCtDefUseId',"V","");
		oprCtDefUseId=GetElementValue('oprCtDefUseId',"V")
	}
	/*if(oprCtLoc!="")
	{ var oprLocId=GetElementValue('oprLocId',"V")}
	else
	{
		SetElementValue('oprLocId',"V","");
		oprLocId=GetElementValue('oprLocId',"V")
	}*/
		var oprCtFloor=GetElementValue('oprCtFloor',"V")
	if(oprCtFloor!="")
	{ 
		var oprCtFloorId=GetElementValue('oprCtFloorId',"V")
	}
	else
	{
		alert("请选择手术楼层");
		return;
	}
	/*
	var oprCtFloor=GetElementValue('oprCtFloor',"V")
	if(oprCtFloor!="")
	{ var oprCtFloorId=GetElementValue('oprCtFloorId',"V")}
	else
	{
		SetElementValue('oprCtFloorId',"V","");
		oprCtFloorId=GetElementValue('oprCtFloorId',"V")
	}
	*/
	var oprCtType=GetElementValue('oprCtType',"V")
	if(oprCtType!="")
	{ var oprCtTypeId=GetElementValue('oprCtTypeId',"V")}
	else
	{
		SetElementValue('oprCtTypeId',"V","");
		oprCtTypeId=GetElementValue('oprCtTypeId',"V")
	}
	var oprNotAvailReason=GetElementValue('oprNotAvailReason',"V")
	if(oprNotAvailReason!="")
	{ var oprNotAvailReasonId=GetElementValue('oprNotAvailReasonId',"V")}
	else
	{
		SetElementValue('oprNotAvailReasonId',"V","");
		oprNotAvailReasonId=GetElementValue('oprNotAvailReasonId',"V")
	}
	var oprId=GetElementValue('tOprIdz'+selectRow,"I")
	var oprCode=GetElementValue('oprCode',"V")
	var oprDesc=GetElementValue('oprDesc',"V")
	//var oprLocId=GetElementValue('oprLocId',"V")
	//var oprCtFloorId=GetElementValue('oprCtFloorId',"V")
	//var oprCtTypeId=GetElementValue('oprCtTypeId',"V")
	//var oprCtDefUseId=GetElementValue('oprCtDefUseId',"V")
	var oprAvailable=GetElementValue('oprAvailable',"V")
	//var oprNotAvailReasonId=GetElementValue('oprNotAvailReasonId',"V")
	var BedType=GetElementValue('BedType',"V")
	//var oprLoc=GetElementValue('oprLoc',"V")
	var obj=document.getElementById('UpdateOperRoom')
	if(obj) var encmeth=obj.value;
	var retStr=cspRunServerMethod(encmeth,oprId,oprLocId,oprCode,oprDesc,oprCtFloorId,oprCtTypeId,oprCtDefUseId,oprAvailable,oprNotAvailReasonId,BedType)
	if(retStr!='0')
	{   alert(retStr);
		return;}	
	try {		   
	    alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	
}
function Delete_click(){
	var obj=document.getElementById('oprId')
	if(obj) var oprId=obj.value;
	if(oprId==""){
		alert("请选中一行后进行删除")  
		return;
		}
	var obj=document.getElementById('DeleteOperRoom')
	if(obj) var encmeth=obj.value;
	if (cspRunServerMethod(encmeth,oprId)!='0')
		{alert(t['baulk']);
		return;}	
	try {alert(t['succeed']);
	    window.location.reload();
		} catch(e) {};
	}
/*	
	function BAutoAddRoom_click(){
	var obj=document.getElementById('CountNum')
	var CountNum=obj.value;
	if(CountNum==""){alert(t['NullCountNum']);return;}
	var obj=document.getElementById('PreCode')
	var PreCode=obj.value;
	if(PreCode==""){alert(t['NullPreCode']);return;}
	var obj=document.getElementById('PreDesc')
	var PreDesc=obj.value;
	if(PreDesc==""){alert(t['NullPreDesc']);return;}
	if (isNaN(CountNum)==false){
		alert(CountNum)
	for (i=0;i<=CountNum;i++){
		
		}
	}
}*/
function getloc(str)
{
	var loc=str.split("^");
	var obj=document.getElementById("oprLocId")
	obj.value=loc[1];
}
function getfloor(str)
{
	var floor=str.split("^");
	var obj=document.getElementById('oprCtFloorId')
	obj.value=floor[1]
}
function getdefuse(str)
{
	var defuse=str.split("^")
	var obj=document.getElementById('oprCtDefUseId')
	obj.value=defuse[1]
}
function GetOPRNotAvailReason(str)
{
    var oprnotavail=str.split("^")
	var obj=document.getElementById('oprNotAvailReasonId')
	obj.value=oprnotavail[1]	
}
function gettype(str)
{
	var type=str.split("^")
	var obj=document.getElementById('oprCtTypeId')
	obj.value=type[1]	
}
document.body.onload=BodyLoadHandler;