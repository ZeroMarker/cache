var SelRow=0;
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BCreate");
	if (obj) obj.onclick=BCreate_click;
}
function BUpdate_click()
{
	var obj,VIPID,Type,Num,OneStr="",Str="",LocID,UserID,rows=0,encmeth="";
	LocID=session['LOGON.CTLOCID'];
	UserID=session['LOGON.USERID'];
	obj=document.getElementById("UpdateClass");
	if (obj) encmeth=obj.value;
	obj=document.getElementById("tDHCPEPreTemplate");	
	if (obj) { rows=obj.rows.length; }
	for (var i=1;i<rows;i++){
		obj=document.getElementById("VIPIDz"+i);
		if (obj) VIPID=obj.value;
		OneStr=VIPID;
		obj=document.getElementById("Typez"+i);
		if (obj) Type=obj.value;
		OneStr=OneStr+"^"+Type;
		obj=document.getElementById("NUM1z"+i);
		if (obj) Num=obj.value;
		OneStr=OneStr+"^"+Num;
		obj=document.getElementById("NUM2z"+i);
		if (obj) Num=obj.value;
		OneStr=OneStr+"^"+Num;
		obj=document.getElementById("NUM3z"+i);
		if (obj) Num=obj.value;
		OneStr=OneStr+"^"+Num;
		obj=document.getElementById("NUM4z"+i);
		if (obj) Num=obj.value;
		OneStr=OneStr+"^"+Num;
		obj=document.getElementById("NUM5z"+i);
		if (obj) Num=obj.value;
		OneStr=OneStr+"^"+Num;
		obj=document.getElementById("NUM6z"+i);
		if (obj) Num=obj.value;
		OneStr=OneStr+"^"+Num;
		obj=document.getElementById("NUM0z"+i);
		if (obj) Num=obj.value;
		OneStr=OneStr+"^"+Num;
		if (Str==""){
			Str=OneStr;
		}else{
			Str=Str+"$"+OneStr;
		}
	}
	var ret=cspRunServerMethod(encmeth,LocID,UserID,Str);
	alert(ret)
}
function BCreate_click()
{
	var obj,LocID="",UserID="",StartDate="",EndDate="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	UserID=session['LOGON.USERID'];
	obj=document.getElementById("StartDate");
	if (obj) StartDate=obj.value;
	obj=document.getElementById("EndDate");
	if (obj) EndDate=obj.value;
	if ((StartDate=="")||(EndDate=="")){
		alert("日期不能为空");
		return false;
	}
	obj=document.getElementById("CreateClass");
	if (obj) encmeth=obj.value;
	//alert(LocID+","+UserID+","+StartDate+","+EndDate)
	var ret=cspRunServerMethod(encmeth,LocID,UserID,StartDate,EndDate);
	alert(ret)
}
document.body.onload = BodyLoadHandler;