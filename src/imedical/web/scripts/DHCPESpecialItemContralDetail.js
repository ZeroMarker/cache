////DHCPESpecialItemContralDetail.js
var Flag="1";
function BodyLoadHandler() {
  
	var obj;
	//alert('haha')
	//obj=document.getElementById("BDelete");
	//if (obj) {obj.onclick=BDelete_click;}
	obj=document.getElementById("BSave");
	if (obj) {obj.onclick=BSave_click;}
	//alert('11')
	obj=document.getElementById("SelectAllWrite");
	if (obj) {obj.onclick=SelectAllWrite_click;}
	//alert('1')
	//InitCheckBox();
}
function BSave_click()   
{  
	var eSrc = window.event.srcElement;	
	var objtbl=document.getElementById('tDHCPESpecialItemContralDetail');	
	var rows=objtbl.rows.length;
	var str="";
	var DefaultNum=0
	//alert('sxxaaax')
	for (i = 1; i < rows; i++)
	{
		var obj,chartID="",TContral="0",WriteFlag="N",DefaultFlag="N",WriteWay="";

		obj=document.getElementById("TContralz"+i);
		if (obj&&obj.checked) TContral="Y"
		if (str==""){
			str=TContral
		}else{
			str=str+"^"+TContral;
		} 
	}
	
	var UserID="",GroupID="",LocID="",Method="";  
    var obj=document.getElementById("UserID");
	if (obj) UserID=obj.value;
	if (UserID==""){
		alert("操作员不能为空");
		websys_setfocus("UserName");
		return false;
	}
	
	var Ret=tkMakeServerCall("web.DHCPE.SpecialItemContral","Save",UserID,str);
	if (Ret=="0"){
	alert("操作成功")
	}
	else {alert("更新失败")}
}
/*
function SelectAllWrite_click()
{
	//alert("2")
	var Flags=Flag;
	var eSrc = window.event.srcElement;	
	var objtbl=document.getElementById('tDHCPESpecialItemContralDetail');	
	var rows=objtbl.rows.length;
	for (i = 1; i < rows; i++)
	{
		
		obj=document.getElementById("TContralz"+i);
		if (obj) {obj.checked=1;}
		//alert(Flag)
		if ((obj)&&(Flags!="0")) {obj.checked=1;}
		if ((obj)&&(Flags!="1")) {obj.checked=0;}
		//if (Flag="0") {Flag="1"}
		//if (Flag="1") {Flag="0"}
		
		
	}
	//alert(Flag)
	if (Flag=="0") {Flag="1"}
	if (Flag=="1") {Flag="0"}
	
	
	
}
*/
function SelectAllWrite_click()
{
	var Src=window.event.srcElement;
	var objtbl=document.getElementById("tDHCPESpecialItemContralDetail"); 
	if (objtbl) { var rows=objtbl.rows.length; }
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById("TContralz"+i);
		if (obj) obj.checked=Src.checked;
		
	}
}

function InitCheckBox()
{
	var OpenType="";
	//var obj=document.getElementById("OpenType");
	//if (obj) OpenType=obj.value;
	//if (OpenType=="") return false;
	var objtbl=document.getElementById('tDHCPESpecialItemContralDetail');	
	var rows=objtbl.rows.length;
	var obj;
	for (i = 1; i < rows; i++)
	{
		obj=document.getElementById("TContralz"+i);
		if (obj) obj.disabled=true;
		
		
		
	}
}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[0];
}   


document.body.onload = BodyLoadHandler;