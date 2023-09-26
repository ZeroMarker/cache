/// /// 对应组件 个人财务审核 
var CurrentSel=0
var SelectedRow=-1
var UserId=session['LOGON.USERID']
function BodyLoadHandler()
{	
	var obj;
	
	obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	
	obj=document.getElementById("ConditionFlag");
	if (obj) obj.onclick=ConditionFlag_click;
	
	obj=document.getElementById("BUpdateExpress");
	if (obj) obj.onclick=BUpdateExpress_click;
}
function BUpdateExpress_click()
{
	var obj,Express,encmeth,EDID;
	var obj=document.getElementById("Express");
	if (obj) Express=obj.value;
	if (Express!=""){
	if (Express.split("[").length==1)
  	{
	  	alert("表达式维护不正确(没有[])")
	  	return false;
  	}
  	if (Express.split("[").length!=Express.split("]").length)
  	{
	  	alert("表达式维护不正确([])");
	  	return false;
  	}
  	if (Express.split("(").length!=Express.split(")").length)
  	{
	  	alert("表达式维护不正确(括号)");
	  	return false;
  	}
	}
	var obj=document.getElementById("ParrefRowId");
	if (obj) EDID=obj.value;
	var ret=tkMakeServerCall("web.DHCPE.ExcuteExpress","SaveExpress",EDID,Express);
	location.reload();
}
//增加
function BAdd_Click()
{	
	//var ParrefRowId;
	var ParrefRowId=""
  	var obj=document.getElementById("ParrefRowId");
    if (obj){
		ParrefRowId=obj.value
	}
	
	var StationRowId=""
  	var obj=document.getElementById("StationRowId");
    if (obj){
		StationRowId=obj.value
	}
	if (""==StationRowId){
		alert("请选择站点");
		return false
  	} 
  	
  	var OrderDetailRowId=""
  	var obj=document.getElementById("OrderDetailRowId");
    if (obj){
		OrderDetailRowId=obj.value
	}
	if (""==OrderDetailRowId){
		alert("请选择细项");
		return false
  	} 

  	var StandardRowId=""
  	var obj=document.getElementById("StandardRowId");
    if (obj){
		StandardRowId=obj.value
	}
	if (""==StandardRowId){
		alert("请选择标准");
		return false
  	} 
  	else{ 
    	var Ins=document.getElementById('AddBox');
        if (Ins) {var encmeth=Ins.value} 
         else {var encmeth=''};
         var flag=cspRunServerMethod(encmeth,ParrefRowId,StandardRowId)
         if ('0'==flag) {}
         else{
	        alert("Update error.ErrNo="+flag)
     	}
     location.reload();
     }
}
//删除
function BDelete_Click()
{	
	var Parref=1;

   	var EDCRowId=""
  	var obj=document.getElementById("EDCRowId");
    if (obj){
		EDCRowId=obj.value
	}
	if (""==EDCRowId){
		alert("请选择");
		return false
  	} 
  	else{ 
    	var Ins=document.getElementById('DelBox');
        if (Ins) {var encmeth=Ins.value} 
         else {var encmeth=''};
         var flag=cspRunServerMethod(encmeth,EDCRowId)
         if ('0'==flag) {}
         else{
	        alert("Update error.ErrNo="+flag)
     	}
     location.reload();
     }
}

// **************************************************************

function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;

	SelRowObj=document.getElementById('TStation'+'z'+selectrow);
	obj=document.getElementById("Station");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }

	SelRowObj=document.getElementById('TOrderDetail'+'z'+selectrow);
	obj=document.getElementById("OrderDetail");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }
	
	SelRowObj=document.getElementById('TStandard'+'z'+selectrow);
	obj=document.getElementById("Standard");
	if (SelRowObj && obj) { obj.value=SelRowObj.innerText; }
	
	SelRowObj=document.getElementById('TODSDR'+'z'+selectrow);
	obj=document.getElementById("StandardRowId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }

	SelRowObj=document.getElementById('TEDCRowId'+'z'+selectrow);
	obj=document.getElementById("EDCRowId");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }
	
	
}
function SelectRowHandler(){  
	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById('tDHCPEEDCondition');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	
	if (!selectrow) return;
	
	if (selectrow!=SelectedRow) {
		ShowCurRecord(selectrow);		
		SelectedRow = selectrow;
	}
	else { SelectedRow=0; }
	
}

function GetStationRowId(value)	{
	//alert("Station:"+value);
	var Station=value.split("^");
	var obj=document.getElementById('StationRowId');
	obj.value=Station[1];
}
function GetOrderDetailRowId(value)	{
	//alert("OrderDetail:"+value);
	var OrderDetail=value.split("^");
	var obj=document.getElementById('OrderDetailRowId');
	obj.value=OrderDetail[9];
}
function GetStandardRowId(value)	{
	var Standard=value.split("^");
	var obj=document.getElementById('StandardRowId');
	obj.value=Standard[5];
}
function ConditionFlag_click()
{
	var ParrefRowId="",obj,ConditionFlag=0;
  	obj=document.getElementById("ParrefRowId");
    	if (obj){
		ParrefRowId=obj.value
	}
	if (ParrefRowId=="") return;
	
	obj=document.getElementById("ConditionFlag");
	if (obj&&obj.checked) ConditionFlag=1;
	tkMakeServerCall("web.DHCPE.DHCPEExpertDiagnosis","SetConditionFlag",ParrefRowId,ConditionFlag) ;
	alert("设置完成");
}
document.body.onload = BodyLoadHandler;