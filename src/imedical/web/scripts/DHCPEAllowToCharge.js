///	DHCPEAllowToCharge.js
var gPEIAdmId="", gIAdmId="", gIAdmStatus="";
var TFORM="DHCPEIAdmItemStatusAdms";
var SelectedRow=0

function BodyLoadHandler(){
	var obj;
    
	obj=document.getElementById("Clear");
	if (obj) { obj.onclick=Clear_click; }
	
	obj=document.getElementById("SelectALL");
	if (obj) { obj.onclick=SelectALL_Click; }	
	
	obj=document.getElementById("txtGroupName");
	if (obj) { obj.onchange=GroupName_Change; }
	
	obj=document.getElementById("txtItemName");
	if (obj) { obj.onchange=ItemName_Change; }
	
	obj=document.getElementById("txtAdmNo");
	if (obj) { obj.onkeydown=Reg_No_keydown; }
	obj=document.getElementById("txtPatName");
	if (obj) { obj.onkeydown=Reg_No_keydown; }
	
	//zhouli
	obj=document.getElementById("Save");
	if (obj) { obj.onclick=Save_Click; }
	
	websys_setfocus("txtAdmNo");
	SetSort("tDHCPEAllowToCharge","TSort")
	
	//ColorTblColumn();
}
function GroupName_Change()
{
	var obj=document.getElementById("txtGroupId");
	if (obj) { obj.value=""; }
}
function ItemName_Change()
{
	var obj=document.getElementById("txtItemId");
	if (obj) { obj.value=""; }
}
function Reg_No_keydown(e)
{
	var Key=websys_getKey(e);
	if ((13==Key)) {
		btnQuery_click();
	}
}
//清屏
function Clear_click(){
	
	var obj;
	obj=document.getElementById('txtAdmNo');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('txtGroupName');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('txtGroupId');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('txtItemName');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('txtItemId');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('txtPatName');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('txtAdmDate');
	if (obj) { obj.value=""; }
	
	obj=document.getElementById('EndDate');
	if (obj) { obj.value=""; }
	
	
	
}
 //zl 2008-03-25
function Save_Click()
{ 
	var Strings=GetAllowString();
	//alert(Strings)
	if (Strings=="") 
	{ 
	   alert("请先查询出待设置的记录");
		return false;
		}
	if (Strings=="") return;
	var encmethobj=document.getElementById("AllowToCharge");
	if (encmethobj) var encmeth=encmethobj.value;
	var Type="Person"
	var obj=document.getElementById("TGDescz1");
	if ((obj)&&(obj.innerText=="是")) Type="Group"
	var ReturnStr=cspRunServerMethod(encmeth,Strings,Type);
	alert("修改完成")
}
function GetAllowString()
{
	var retStr=""
	var tbl=document.getElementById('tDHCPEAllowToCharge');	//取表格元素?名称
	var row=tbl.rows.length;
	for (var iLLoop=1;iLLoop<row;iLLoop++) {
		var obj=document.getElementById('TSeclect'+'z'+iLLoop);
		var allowFlag="0"
		if (obj&&obj.checked) {allowFlag="1"}
		var obj=document.getElementById('TPEIAdmId'+'z'+iLLoop);
		if (obj) var pADM=obj.value;
		
		if (retStr=="")
		{
			retStr=pADM+"^"+allowFlag
		}
		else
		{
			retStr=retStr+"&"+pADM+"^"+allowFlag
		}	
	}

	return retStr
}

//去除字符串两端的空格
function Trim(String)
{
	if (""==String) { return ""; }
	var m = String.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function AfterGroupSelected(value){
	//ROWSPEC = "GBI_Desc:%String, GBI_Code:%String, GBI_RowId:%String"	
	if (""==value){return false}
	var aiList=value.split("^");
	SetCtlValueByID("txtGroupId",aiList[0],true);
	SetCtlValueByID("txtGroupName",aiList[1],true);
	
}
function AfterItemSelected(value){
	if (""==value){return false}
	
	var aiList=value.split("^");
	SetCtlValueByID("txtItemId",aiList[1],true);
	SetCtlValueByID("txtItemName",aiList[0],true);
	
}
function SelectALL_Click() 
{
	var tbl=document.getElementById('tDHCPEAllowToCharge');	//取表格元素?名称
	var row=tbl.rows.length;
	
	for (var iLLoop=1;iLLoop<=row;iLLoop++) {
		obj=document.getElementById('TSeclect'+'z'+iLLoop);
		if (obj) { obj.checked=!obj.checked; }
	}
	
}
function SetSort(TableName,ItemName)
{
	var objtbl=document.getElementById(TableName);	
	
	if (objtbl) { var rows=objtbl.rows.length; }
	for (var j=1;j<rows;j++)
	{
		var obj=document.getElementById(ItemName+"z"+j);
		if (obj) obj.innerText=j;	
	}
}

document.body.onload = BodyLoadHandler;
