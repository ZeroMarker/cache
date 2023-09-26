var SelRow=0;
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BCreate");
	if (obj) obj.onclick=BCreate_click;
	
	Setdblclick()
}
function Setdblclick()
{

	var tbl=document.getElementById("tDHCPEPreTemplate");
	var row=tbl.rows.length;
	for (var j=1;j<row;j++) {
		for (var i=0;i<7;i++){
			var obj=document.getElementById("NUM"+i+"z"+j);
			if (obj) obj.ondblclick=DBLClick;
		}
	}

}
function DBLClick()
{
	var eSrc=window.event.srcElement;
	var IDInfo=eSrc.id;
	var Arr=IDInfo.split("NUM");
	var RCInfo=Arr[1];
	var Arr=RCInfo.split("z");
	var WeekInfo=Arr[0];
	var RowInfo=Arr[1];
	var Obj,VIPID,Type,encmeth;
	var obj=document.getElementById("VIPIDz"+RowInfo);
	if (obj) VIPID=obj.value;
	obj=document.getElementById("Typez"+RowInfo);
	if (obj) Type=obj.value;
	var LocID=session['LOGON.CTLOCID'];
	obj=document.getElementById("GetPreTemplateIDClass");
	if (obj) encmeth=obj.value;
	var ID=cspRunServerMethod(encmeth,LocID,VIPID,WeekInfo,Type)
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreTemplateTime&Type=T&ParRef="+ID; //+"&ShowFlag=#(ShowFlag)#"
	var wwidth=400;
	var wheight=300;
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	window.open(lnk,"_blank",nwin)
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
	if(ret==1) {
		$.messager.alert("提示","保存成功","success");
		}
	else {
		$.messager.alert("提示",ret,"info");
		}

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
		$.messager.alert("提示","日期不能为空","info");
		return false;
	}
	obj=document.getElementById("CreateClass");
	if (obj) encmeth=obj.value;
	//alert(LocID+","+UserID+","+StartDate+","+EndDate)
	var ret=cspRunServerMethod(encmeth,LocID,UserID,StartDate,EndDate);
	if(ret=="OVER") {
		$.messager.alert("提示","创建成功","success");
	}
	else {
		$.messager.alert("提示",ret,"info");
	}

}
document.body.onload = BodyLoadHandler;