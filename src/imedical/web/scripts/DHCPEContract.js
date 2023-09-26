var SelRow=0;
function BodyLoadHandler()
{
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
	//按钮 主场设定
	obj=document.getElementById("HomeSet");
	if (obj){obj.onclick=HomeSet_Click; }
}
function BUpdate_click()
{
	var obj,No,Name,Remark,SignDate,ID,encmeth,Str;
	obj=document.getElementById("No");
	if (obj) No=obj.value;
	
	if (""==No) {
            obj=document.getElementById("No")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("编号不能为空");
		return false;

	}
	
	obj=document.getElementById("Name");
	if (obj) Name=obj.value;
	
	if (""==Name) {
            obj=document.getElementById("Name")
		if (obj) {
			websys_setfocus(obj.id);
			obj.className='clsInvalid';
		}
		alert("名字不能为空");
		return false;

	}
	
	obj=document.getElementById("Remark");
	if (obj) Remark=obj.value;
	obj=document.getElementById("SignDate");
	if (obj) SignDate=obj.value;
	obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	obj=document.getElementById("UpdateClass");
	if (obj) encmeth=obj.value;
	var UserID=session['LOGON.USERID'];
	var LocID=session['LOGON.CTLOCID'];
	Str=No+"^"+Name+"^"+SignDate+"^"+Remark+"^"+UserID+"^"+LocID;
	var ret=cspRunServerMethod(encmeth,ID,Str);
	
	var retData=ret.split("^");
	if(retData[0]!=-1){
		alert("更新成功");
		window.location.reload();
	}
	else {
		alert("更新失败,相同编码已经存在");
		}
	
}
function BClear_click()
{
	FillDate("^^^^^^^^^^");
}
function FillDate(Str)
{
	var obj,DataArr;
	DataArr=Str.split("^");
	obj=document.getElementById("No");
	if (obj) obj.value=DataArr[1];
	obj=document.getElementById("Name");
	if (obj) obj.value=DataArr[2];
	obj=document.getElementById("Remark");
	if (obj) obj.value=DataArr[4];
	obj=document.getElementById("SignDate");
	if (obj) obj.value=DataArr[3];
	obj=document.getElementById("ID");
	if (obj) obj.value=DataArr[0];
}
function SelectRowHandler() {
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	if (SelRow==selectrow){
		BClear_click();
		SelRow=0;
	}else{
		var obj,ID,encmeth,Str;
		obj=document.getElementById("TIDz"+selectrow);
		if (obj) ID=obj.value;
		obj=document.getElementById("GetInfoClass");
		if (obj) encmeth=obj.value;
		Str=cspRunServerMethod(encmeth,ID);
		FillDate(Str);
		SelRow=selectrow;
	}
}
function HomeSet_Click()
{
	var obj,encmeth="",ID="";
	
	obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	
	if (ID=="" || ID==undefined){
		return;	
	}
	//var repUrl="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreGADM.Home&PGADMDr="+ID+"&Type=C";
	//window.open(repUrl,"","dialogHeight: 600px; dialogWidth: 800px");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEPreGADM.Home&PGADMDr="+ID+"&Type=C";
	var wwidth=900;
	var wheight=650;
	
	var xposition = (screen.width - wwidth) / 2;
	var yposition = ((screen.height - wheight) / 2)-10;
	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
			+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
			;
	//alert(lnk)
	var cwin=window.open(lnk,"_blank",nwin) 


}
document.body.onload = BodyLoadHandler;