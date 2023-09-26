/// DHCPEQualityManager.js

var CurrentSel=0

function BodyLoadHandler() {
   
	var obj;
	obj=document.getElementById("BSave");
	if (obj){ obj.onclick=BSave_click;}
	obj=document.getElementById("BDelete");
	if (obj){ obj.onclick=BDelete_click;}
	obj=document.getElementById("ErrDetail");
	if (obj){ obj.ondblclick=ErrDetail_dblclick;}
	var obj=document.getElementById("QMType");
	if (obj){ obj.onchange=QMType_change;}
	var obj=document.getElementById("ItemID");
	if (obj){ obj.onchange=ItemID_change;}
	var obj=document.getElementById("ErrUser");
	if (obj) 
	{
		obj.onchange=UserName_Change;
		obj.onkeydown=UserName_keydown;
	}

}
function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
function UserName_keydown(e)
{
	var key=websys_getKey(e);
	if (13==key) {
       return false;
	}
}
function UserName_Change(){
	var obj=document.getElementById("ErrUserID");
	if (obj) obj.value="";
}

function BSave_click() { 
    var encmeth="",ExpStr="",PAADM="",QMType="",ErrDetail="",ErrUserID="",ID="",UserID="",Remark="",ItemID="";
	var obj=document.getElementById("SaveClass");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("PAADM");
	if (obj) PAADM=obj.value;
	var obj=document.getElementById("QMType");
	if (obj){
		QMType=obj.value;
		var Arr=QMType.split("^");
		QMType=Arr[0];
		
		if (QMType==""){
			alert("请选择错误类型");
			return false;
		}
		ExpStr=Arr[1];
	}
	var obj=document.getElementById("ErrDetail");
	if (obj) ErrDetail=obj.value;
	var obj=document.getElementById("ErrUserID");
	if (obj) ErrUserID=obj.value;
	if (ErrUserID==""){
		alert("错误人不能为空");
		return false;
	}
	var obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	UserID=session['LOGON.USERID']
	if (ExpStr=="SR"){
		var obj=document.getElementById("ItemID");
		if (obj) ItemID=obj.value;
		if(ItemID=="") {
	        alert("错误类型为科室录入时,必须选择项目");
	        return false;
        }
	}
	//PAADM^ErrType^ErrDetail^Remark^ErrUserDR^UserDR
	var SaveInfo=PAADM+"^"+QMType+"^"+ErrDetail+"^"+Remark+"^"+ErrUserID+"^"+UserID+"^"+ItemID;

	var Ret=cspRunServerMethod(encmeth,ID,SaveInfo);
	var Arr=Ret.split("^");
	if (Arr[0]>0){
		location.reload();
	}else{
		alert(Arr[1]);
	} 
}
function BDelete_click()
{
	var encmeth="",ID="",UserID="";
	var obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	if(ID==""){
		alert("请先选择要删除的记录");
		return false;
		}
	var obj=document.getElementById("DeleteClass");
	if (obj) encmeth=obj.value;
	UserID=session['LOGON.USERID']
	var Ret=cspRunServerMethod(encmeth,ID,UserID);
	var Arr=Ret.split("^");
	if (Arr[0]>0){
		location.reload();
	}else{
		alert(Arr[1]);
	} 
}
function ShowCurRecord(selectrow) {

	var SelRowObj;
	var obj;
	
	SelRowObj=document.getElementById('TQMTypeID'+'z'+selectrow);
	obj=document.getElementById("QMType");
	if (SelRowObj && obj) {
		var ExpStrObj=document.getElementById('TQMTExpStr'+'z'+selectrow);
		obj.value=trim(SelRowObj.value)+"^"+trim(ExpStrObj.value);
	}

	SelRowObj=document.getElementById('TErrDetail'+'z'+selectrow);
	obj=document.getElementById("ErrDetail");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }

	SelRowObj=document.getElementById('TID'+'z'+selectrow);
	obj=document.getElementById("ID");
	if (SelRowObj && obj) { obj.value=SelRowObj.value; }

	SelRowObj=document.getElementById('TRemark'+'z'+selectrow);
	obj=document.getElementById("Remark");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }
	
	SelRowObj=document.getElementById('TErrUserID'+'z'+selectrow);
	obj=document.getElementById("ErrUserID");
	if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }
	// ----------------------------------------------------------------
	SelRowObj=document.getElementById('TErrUser'+'z'+selectrow);
	obj=document.getElementById("ErrUser");
	if (SelRowObj && obj) { 
		if (SelRowObj && obj) { obj.value=trim(SelRowObj.innerText); }
	}
	SelRowObj=document.getElementById('TItemID'+'z'+selectrow);
	obj=document.getElementById("ItemID");
	if (SelRowObj && obj) { 
		if (SelRowObj && obj) { obj.value=trim(SelRowObj.value); }
	}
}
function ErrDetail_dblclick()
{
	var QMType="",ExpStr="",PAADM="",ItemID="";
	var obj=document.getElementById("QMType");
	if (obj){
		QMType=obj.value;
		var Arr=QMType.split("^");
		QMType=Arr[0];
		ExpStr=Arr[1];
	}
	if (ExpStr=="") return false;
	if (ExpStr=="SR"){
		var obj=document.getElementById("ItemID");
		if (obj) ItemID=obj.value;
		if (ItemID==""){
			alert("请选择错误项目");
			return false;
		}
	}
	var obj=document.getElementById("PAADM");
	if (obj) PAADM=obj.value;
	lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCPEFindErrDetail"
   	+"&PAADM="+PAADM+"&ExpStr="+ExpStr+"&ItemID="+ItemID;
  	var wwidth=600;
  	var wheight=400;
  	var xposition = (screen.width - wwidth) / 2;
  	var yposition = (screen.height - wheight) / 2;
  	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
   	+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition
   	;
 	var cwin=window.open(lnk,"_blank",nwin)
	/*
	
	var url='websys.default.csp';
	url += "?ID=&CONTEXT=K"+"web.DHCPE.QualityManager:FindErrDetail";
	url += "&P1="+websys_escape(PAADM);
	url += "&P2="+websys_escape(ExpStr);
	url += "&TLUJSF=SetErr";
	websys_lu(url,1,'');
	return websys_cancel();*/
}
function QMType_change()
{
	var eSrc=window.event.srcElement;
	var Info=eSrc.value;
	var Arr=Info.split("^");
	var ExpStr=Arr[1];
	var obj=document.getElementById("PAADM");
	if (obj) PAADM=obj.value;
	var encmeth="";
	var obj=document.getElementById("GetGenName");
	if (obj) encmeth=obj.value;
	var Ret=cspRunServerMethod(encmeth,PAADM,ExpStr);
	var Arr=Ret.split("^");
	obj=document.getElementById("ErrUserID");
	if (obj) { 
		obj.value=Arr[0]; 
	}
	obj=document.getElementById("ErrUser");
	if (obj) { 
		obj.value=Arr[1]; 
	}
	obj=document.getElementById("ErrDetail");
	if (obj) { 
		obj.value=""; 
	}
	var obj=document.getElementById("ItemID");
	if (obj) obj.value="";
}
function ItemID_change()
{
	var QMType="",ExpStr="",encmeth="",ItemID="";
	var obj=document.getElementById("QMType");
	if (obj){
		QMType=obj.value;
		var Arr=QMType.split("^");
		QMType=Arr[0];
		ExpStr=Arr[1];
	}
	if (ExpStr==""){
		alert("请先选择错误类型");
		return false;
	}
	if ((ExpStr=="SR")||(ExpStr=="SA")){
		var obj=document.getElementById("ItemID");
		if (obj) ItemID=obj.value;
		if (ItemID==""){
			alert("请选择错误项目");
			return false;
		}
		var obj=document.getElementById("GetUserInfoClass");
		if (obj) encmeth=obj.value;
		var UserInfo=cspRunServerMethod(encmeth,ItemID,ExpStr);
		var Arr=UserInfo.split("^");
		obj=document.getElementById("ErrUserID");
		if (obj) { 
			obj.value=Arr[0]; 
		}
		obj=document.getElementById("ErrUser");
		if (obj) { 
			obj.value=Arr[1]; 
		}
		
	}
}
function FindErrUserAfter(value)
{        
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("ErrUserID");
	if (obj) { 
		obj.value=Arr[2]; 
	}
	var obj=document.getElementById("ErrUser");
	if (obj) { 
		obj.value=Arr[1]; 
	}
}
function SelectRowHandler() {
	
	var eSrc=window.event.srcElement;
	
	var rowObj=getRow(eSrc);

	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel) {
		Clear_click();	    
		CurrentSel=0;
		return;
	}
	CurrentSel=selectrow;
	ShowCurRecord(CurrentSel);
}
function Clear_click() {
	
	var obj;
	
	obj=document.getElementById("ID");
	if (obj) { obj.value=""; }

	obj=document.getElementById("QMType");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("ErrDetail");
	if (obj) { 
		obj.value=""; 
	}
	obj=document.getElementById("ErrUserID");
	if (obj) { 
		obj.value=""; 
	}
	obj=document.getElementById("ErrUser");
	if (obj) { 
		obj.value=""; 
	}
	
	obj=document.getElementById("Remark");
	if (obj) {
		obj.value=""; 
	}
}
document.body.onload = BodyLoadHandler;