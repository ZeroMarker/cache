///DHCPEEDItemDetail.js
///危害因素对应的检查项目的重点检查内容

var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BSave");
	if (obj) obj.onclick=BSave_click;
	//obj=document.getElementById("BDelete");
	//if (obj) obj.onclick=BDelete_click;
}
function BSave_click()
{
    var IDs="";
    var objtbl=document.getElementById('tDHCPEEDItemDetail');	//取表格元素?名称
	var rows=objtbl.rows.length;
	//取选中的ID串
	var ParRef=GetValue("ParRef",1);
	var ParARCIMDR=GetValue("ParARCIMDR",1);
	var encmeth=GetValue("SaveClass",1);
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById("TSelectz"+i);
		if (obj&&obj.checked){ 
		    Active="Y";
		}else{
		    Active="N";
		}
		var ID=GetValue('TID'+'z'+i,1);
		var DetailID=GetValue('ODR_OD_DR'+'z'+i,1);
		var ExpInfo=GetValue('TExpInfo'+'z'+i,1);
		var Remark=GetValue('TRemark'+'z'+i,1);
		var Str=ParRef+"^"+DetailID+"^"+Active+"^"+ExpInfo+"^"+Remark;
		var rtn=cspRunServerMethod(encmeth,ID,Str);
		if (rtn.split("^")[0]=="-1"){
			alert("更新失败"+rtn.split("^")[1])
		}
	}
	window.location.reload();
	
}

function GetObj(Name)
{
	var obj=document.getElementById(Name);
	return obj;	
}
function GetValue(Name,Type)
{
	var Value="";
	var obj=GetObj(Name);
	if (obj){
		if (Type=="2"){
			Value=obj.innerText;
		}else{
			Value=obj.value;
		}
	}
	return Value;
}
function SetValue(Name,Value,Type)
{
	var obj=GetObj(Name);
	if (obj){
		if (Type=="2"){
			obj.innerText=Value;
		}else{
			obj.value=Value;
		}
	}
}
/*
//以便本页面的子页面有正确的传入参数
function ShowCurRecord(selectrow) {
	var ID=GetValue('TID'+'z'+selectrow,1);
	SetValue("ID",ID,1);
	var encmeth=GetValue("GetOneMethod",1);
	var OneStr=cspRunServerMethod(encmeth,ID);
	var StrArr=OneStr.split("^");
	SetValue("DetailDesc",StrArr[0],1);
	SetValue("ExpInfo",StrArr[2],1);
	SetValue("Remark",StrArr[3],1);
	var Active=StrArr[1];
	var obj=document.getElementById("Active");
	if (obj){
		if (Active=="1"){
			obj.checked=true;
		}else{
			obj.checked=false;
		}
	}
}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var objtbl=GetObj('tDHCPEEndanger');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}
*/
document.body.onload = BodyLoadHandler;