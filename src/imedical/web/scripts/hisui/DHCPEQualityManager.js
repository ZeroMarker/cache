
//����	DHCPEQualityManager.js
//����	�����ϱ�
//���	DHCPEQualityManager 	
//����	2018.11.28
//������  xy
var CurrentSel=-1

function BodyLoadHandler() {
   
	var obj;
	obj=document.getElementById("BSave");
	if (obj){ obj.onclick=BSave_click;}
	
	obj=document.getElementById("BDelete");
	if (obj){ obj.onclick=BDelete_click;}
	
	obj=document.getElementById("ErrDetail");
	if (obj){ obj.ondblclick=ErrDetail_dblclick;}
	
	$("#QMType").combobox({
       onSelect:function(){
			QMType_change();
	}
	});
	
	$("#ItemID").combobox({
       onSelect:function(){
			ItemID_change();
	}
	});

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
	
	setValueById("ErrUserID","");
	
}

function BSave_click() { 

    var obj;
    var ExpStr="",PAADM="",QMType="",ErrDetail="",ErrUserID="",ID="",UserID="",Remark="",ItemID="";
	var PAADM=getValueById("PAADM");
	var obj=document.getElementById("QMType");
	if (obj){
		QMType=$("#QMType").combobox("getValue");
		var Arr=QMType.split("^");
		QMType=Arr[0];
		if (QMType==""){
			$.messager.alert("��ʾ","����ѡ���������","info");
			return false;
		}
		ExpStr=Arr[1];
	}
	var ErrDetail=getValueById("ErrDetail");
	var ErrUserID=getValueById("ErrUserID");
	
	if (ErrUserID==""){
		$.messager.alert("��ʾ","�����˲���Ϊ��","info");
		return false;
	}
	var ID=getValueById("ID");

	UserID=session['LOGON.USERID']
	var ItemID=$("#ItemID").combobox("getValue");
	if (ExpStr=="SR"){
		var ItemID=$("#ItemID").combobox("getValue");
		if(ItemID=="") {
			$.messager.alert("��ʾ","��������Ϊ����¼��ʱ,����ѡ����Ŀ","info"); 
	       return false;
        }
	}
	
	var SaveInfo=PAADM+"^"+QMType+"^"+ErrDetail+"^"+Remark+"^"+ErrUserID+"^"+UserID+"^"+ItemID;
	var Ret=tkMakeServerCall("web.DHCPE.QualityManager","Save",ID,SaveInfo);
	var Arr=Ret.split("^");
	if (Arr[0]>0){
		$("#tDHCPEQualityManager").datagrid('load',{ComponentID:56444,PAADM:$("#PAADM").val()});
		//location.reload();
	}else{
		$.messager.alert("��ʾ",Arr[1],"error"); 
		
	} 
}
function BDelete_click()
{
	var encmeth="",ID="",UserID="";
	var obj=document.getElementById("ID");
	if (obj) ID=obj.value;
	if(ID==""){
		$.messager.alert("��ʾ","����ѡ��Ҫɾ���ļ�¼","info");
		return false;
		}
	
	var obj=document.getElementById("DeleteClass");
	if (obj) encmeth=obj.value;
	UserID=session['LOGON.USERID']
	var Ret=cspRunServerMethod(encmeth,ID,UserID);
	var Arr=Ret.split("^");
	if (Arr[0]>0){
		$.messager.alert("��ʾ","ɾ���ɹ�","error"); 
		$("#tDHCPEQualityManager").datagrid('load',{ComponentID:56444,PAADM:$("#PAADM").val()});
		
	}else{
		$.messager.alert("��ʾ",Arr[1],"info");
	} 
}
function ShowCurRecord(rowdata) {

	var SelRowObj;
	var obj;
	
	obj=document.getElementById("QMType");
	if (obj) {
		setValueById("QMType",rowdata.TQMTypeID+"^"+rowdata.TQMTExpStr)
		
	}

	obj=document.getElementById("ErrDetail");
	if (obj) { setValueById("ErrDetail",rowdata.TErrDetail)}

	
	obj=document.getElementById("ID");
	if (obj) { setValueById("ID",rowdata.TID) }

	
	obj=document.getElementById("Remark");
	if (obj) { setValueById("Remark",rowdata.TRemark)  }
	
	
	obj=document.getElementById("ErrUserID");
	if (obj) { setValueById("ErrUserID",rowdata.TErrUserID)}
	
	
	
	obj=document.getElementById("ErrUser");
	if (obj) { 
		setValueById("ErrUser",rowdata.TErrUser)	
		 
	}
	
	obj=document.getElementById("ItemID");
	if (obj) { 
	setValueById("ItemID",rowdata.TItemID)
	}
}


function ErrDetail_dblclick()
{
	
	var QMType="",ExpStr="",PAADM="",ItemID="";
	var QMType=getValueById("QMType");
	if(QMType.indexOf("^")!="-1"){
	var Arr=QMType.split("^");
		QMType=Arr[0];
		ExpStr=Arr[1];
	}
		
	if ((ExpStr=="")||(ExpStr=="undefined")){
		$.messager.alert("��ʾ","����ѡ���������","info");
		return false;
	}
	if (ExpStr=="SR"){
		var ItemID=getValueById("ItemID");
		if (ItemID==""){
			$.messager.alert("��ʾ","��ѡ�������Ŀ","info");
			return false;
		}
	}
	
	var PAADM=getValueById("PAADM");
	lnk="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCPEFindErrDetail"
   	+"&PAADM="+PAADM+"&ExpStr="+ExpStr+"&ItemID="+ItemID;
	var wwidth=600;
  	var wheight=400;
  	var xposition = (screen.width - wwidth) / 2;
  	var yposition = (screen.height - wheight) / 2;
  	var nwin='toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yesheight='
   	+'height='+wheight+',width='+wwidth+',left='+xposition+',top='+yposition;
 	var cwin=window.open(lnk,"_blank",nwin)

   //alert(lnk)
   //websys_lu(lnk,false,'width=600,height=400,hisui=true,title=��������')
   
}


function QMType_change()
{
	var Info="",ExpStr="",PAADM=""
	var Info=getValueById("QMType");
	var Arr=Info.split("^");
	var ExpStr=Arr[1];
	
	var PAADM=getValueById("PAADM");

	var Ret=tkMakeServerCall("web.DHCPE.QualityManager","GetGenName",PAADM,ExpStr);
	var Arr=Ret.split("^");
	
	setValueById("ErrUserID",Arr[0]);
	setValueById("ErrUser",Arr[1]);
	setValueById("ErrDetail","");
	setValueById("ItemID","");

	var QMType=getValueById("QMType");
	if(QMType.indexOf("^")!="-1"){
		var Arr=QMType.split("^");
		QMType=Arr[1];
		
	}
	
	if((QMType=="SR")||(QMType=="SA"))
	{
		$("#ItemID").combobox("enable");
		
	}else{
		$("#ItemID").combobox("disable"); 
	
	}
	

	
}

function ItemID_change()
{	
	var QMType="",ExpStr="",ItemID="";
	
	var QMType=getValueById("QMType");
	if(QMType.indexOf("^")!="-1"){
		var Arr=QMType.split("^");
		QMType=Arr[0];
		ExpStr=Arr[1];
	}
	
	if ((ExpStr=="")||(ExpStr=="undefined")){
		$.messager.alert("��ʾ","����ѡ���������","info");
		return false;
	}
	if ((ExpStr=="SR")||(ExpStr=="SA")){
		var ItemID=getValueById("ItemID");
		if (ItemID==""){
			$.messager.alert("��ʾ","��ѡ�������Ŀ","info");
			return false;
		}
	
	var UserInfo=tkMakeServerCall("web.DHCPE.QualityManager","GetUserInfo",ItemID,ExpStr);
	var Arr=UserInfo.split("^");
	setValueById("ErrUserID",Arr[0]);
	setValueById("ErrUser",Arr[1])
		
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
function SelectRowHandler(index,rowdata) {
	
	var selectrow=index;
	   
	if (selectrow==CurrentSel) {
		Clear_click();	    
		CurrentSel=-1;
		return;
	}
	CurrentSel=selectrow;
	
	ShowCurRecord(rowdata);
}

function Clear_click() {
	
	setValueById("ID","");
	setValueById("QMType","");
	setValueById("ErrDetail","");
	setValueById("ErrUserID","");
	setValueById("ErrUser","");
	setValueById("Remark","");
	
}
document.body.onload = BodyLoadHandler;