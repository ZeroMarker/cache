//HCPEGroupCollect.Condition.js

var CurrentSel=0;
var TFORM='tDHCPEGroupCollect_GList';
function BodyLoadHandler() 
{
	var obj
	obj=document.getElementById("GBIDesc");
	if (obj) {
	obj.onkeydown=CardNo_KeyDown;}
	
	obj=document.getElementById("Query");
	if (obj){ obj.onclick=btnQuery_click; }
	var obj=document.getElementById("Contract");
	if (obj) obj.onchange=Contract_change;
}
function Contract_change()
{
	var obj=document.getElementById("ContractID");
	if (obj) obj.value="";
}

function CardNo_KeyDown(e)
{
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		
		btnQuery_click();
		return false;
	}
}

function btnQuery_click()
{
	var obj
	obj=document.getElementById("GBIDesc");
	if (obj) {var GBDesc=obj.value;}
	var obj=document.getElementById("ContractID");
	if (obj) {var ContractID=obj.value;}
	var obj=document.getElementById("Contract");
	if (obj) {var Contract=obj.value;}
	lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEGroupCollect.GList"
		+"&GBIDesc="+GBDesc+"&ContractID="+ContractID+"&Contract="+Contract;
	
	location.href=lnk;
	
	}


function SelectRecord(RowVal) 
{
	try{
	var RowVals=RowVal.split('^');
	var iGid=0,iSelect=0;
	if (RowVals[0]) { iGid=RowVals[0]; }
	else { return false;}
	if (RowVals[1]) { iSelect=RowVals[1]; }
	else { return false;}
	
	var objtbl=document.getElementById(TFORM);
	if (objtbl) { var rows=objtbl.rows.length; }
	else { return false; }
	

	var GList='';
	for (var iLoop=1;iLoop<=rows-1;iLoop++) {
		SelRowObj=document.getElementById('T_Select'+'z'+iLoop);
		if (SelRowObj && SelRowObj.checked) {
			SelRowObj=document.getElementById('TGRowId'+'z'+iLoop);
			if (SelRowObj && ""!=SelRowObj.value) { GList=GList+SelRowObj.value+"^"; }		
		}
	}
	
	//parent.SetGroupList(GList);
	parent.frames['GList'].GList.value=GList;
	var obj=parent.frames["right"].document.getElementById('GList');
	if (obj){ obj.value=GList }
	}catch(e){}
}

function ShowCurRecord(CurrentSel) 
{
	var Gid=-1;
	var iSelect=0;
	var RowVal='';
	
	var SelRowObj;
	
	SelRowObj=document.getElementById('T_Select'+'z'+CurrentSel);
	if (SelRowObj && SelRowObj.checked) {  iSelect=1; }	
	
	SelRowObj=document.getElementById('TGRowId'+'z'+CurrentSel);
	if (SelRowObj && ""!=SelRowObj.value) { Gid=SelRowObj.value; }
	
	RowVal=Gid+'^'+iSelect;
	
	SelectRecord(RowVal);

}

function SelectRowHandler() 
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById(TFORM);
	if (objtbl) { var rows=objtbl.rows.length; }
	else { return false; }
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	CurrentSel=selectrow;
	ShowCurRecord(CurrentSel);

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
function GetSelectGroupIDs()
{
	var objtbl=document.getElementById(TFORM);
	if (objtbl) { var rows=objtbl.rows.length; }
	var SelRowObj,GroupIDs="",OneID="";
	for (var i=1;i<rows;i++)
	{
		SelRowObj=document.getElementById('T_Select'+'z'+i);
		if (SelRowObj && SelRowObj.checked){
			var IDObj=document.getElementById('TGRowId'+'z'+i);
			if (IDObj) OneID=IDObj.value;
			if (GroupIDs==""){
				GroupIDs=OneID;
			}else{
				GroupIDs=GroupIDs+"$"+OneID;
			}
		}
	}
	return GroupIDs;
}
document.body.onload = BodyLoadHandler;
