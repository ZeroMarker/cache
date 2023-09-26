document.body.onload = BodyLoadHandler;
var SelRow="";
function BodyLoadHandler()
{
	var obj=GetObj("BFind");
	if (obj) obj.onclick=BFind_click;
	var obj=GetObj("GroupDesc");
	if (obj) obj.onchange=GroupDesc_change;
	var obj=document.getElementById("Contract");
	if (obj) obj.onchange=Contract_change;
}
function Contract_change()
{
	SetValue("ContractID","");
}
function GroupDesc_change()
{
	SetValue("GroupID","");
	SetValue("GroupDesc","");
}
function BFind_click()
{
	var StartDate=GetValue("StartDate");
	var EndDate=GetValue("EndDate");
	var GroupID=GetValue("GroupID");
	var Name=GetValue("Name");
	var ResultFlag="N";
	var obj=GetObj("ResultFlag");
	if (obj&&obj.checked) ResultFlag="Y"; 
	var EDIDs="";
	var obj=GetObj('tDHCPEHighRiskNew.Find');	//取表格元素?名称
	var row=tbl.rows.length;
	row=row-1;
	for (var j=1;j<row+1;j++) {
		var obj=GetObj('TSelectz'+j);
		if (obj&&obj.checked){
			var EDID=GetValue("TEDIDz"+j);
			if (EDIDs==""){
				EDIDs=EDID;
			}else{
				EDIDs=EDIDs+"^"+EDID;
			}
		}
	}
	if ((EDIDs=="")&&(ResultFlag=="N"))
	{
		alert("请选择高危信息");
		return false;
	}
	var VIPLevel=GetValue("VIPLevel");
	var IfSolve=GetValue("IfSolve");
	var ContractID=GetValue("ContractID");
	var obj=parent.frames["List"];
	if (obj){
		var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEHighRiskNew.List"
		+"&StartDate="+StartDate+"&EndDate="+EndDate+"&GroupID="+GroupID+"&EDIDs="+EDIDs+"&ResultFlag="+ResultFlag+"&IfSolve="+IfSolve+"&VIPLevel="+VIPLevel+"&Name="+Name+"&ContractID="+ContractID;
		obj.location.href=lnk;
	}
}
function GetGroupID(value)
{
	
	if (value=="") return false;
	var Arr=value.split("^");
	SetValue("GroupID",Arr[0]);
	SetValue("GroupDesc",Arr[1]);
	//Group GroupDR
	
	
}
function GetObj(ElementName)
{
	return document.getElementById(ElementName)
}
function SetValue(ElementName,value)
{
	var obj=GetObj(ElementName)
	if (obj){
		obj.value=value;
	}
}
function GetValue(ElementName)
{
	var obj=GetObj(ElementName)
	if (obj){
		return obj.value;
	}else{
		return "";
	}
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//触发事件的
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	if (SelRow==selectrow){
		
	}else{
		SelRow=selectrow;
		var EDID=GetValue("TEDIDz"+SelRow);
		var obj=parent.frames["Con"];
		if (obj) obj.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEEDConditionNew&ParrefRowId="+EDID;
	}
}
function ContractFindAfter(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	
	var obj=document.getElementById("Contract");
	if (obj) obj.value=Arr[2];
	var obj=document.getElementById("ContractID");
	if (obj) obj.value=Arr[0];
}	