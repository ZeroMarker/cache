
//����	DHCPEInPatientToHP.InDoc.js
//����  ����סԺ����סԺҽ����������ʹ�����¼����ύ
//���	DHCPEInPatientToHP.InDoc
//����	2018.08.15
//������  xy


function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("BSave");
	if (obj){ obj.onclick=BSave_click; }
	obj=document.getElementById("BDelete");
	if (obj){ obj.onclick=BDelete_click; }
	obj=document.getElementById("UserName");
	if (obj){ obj.onchange=UserName_change; }
	
}
function BSave_click()
{
	
	var obj,LocID="",UserID="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	UserID=getValueById("UserID");
	if (UserID==""){
		$.messager.alert("��ʾ","��ѡ���������Ա");
		return false;
	}
	obj=document.getElementById("SaveClass");
	if (obj) encmeth=obj.value;
	var Ret=cspRunServerMethod(encmeth,LocID,UserID);
	window.location.reload();
}
function BDelete_click()
{
	var obj,LocID="",UserID="",encmeth="";
	LocID=session['LOGON.CTLOCID'];
	obj=document.getElementById("UserID");
	if (obj) UserID=obj.value;
	if (UserID==""){
		$.messager.alert("��ʾ","��ѡ���ɾ������");
		return false;
	}
	obj=document.getElementById("SaveClass");
	if (obj) encmeth=obj.value;
	var Ret=cspRunServerMethod(encmeth,LocID,UserID,"Y");
	window.location.reload();
}
function UserName_change()
{
	var obj=document.getElementById("UserID");
	if (obj) obj.value="";
}

function AfterUserName(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var obj=document.getElementById("UserName");
	if (obj) obj.value=Arr[1];
	var obj=document.getElementById("UserID");
	if (obj) obj.value=Arr[2];
}


var selectrow=-1;
function SelectRowHandler(index,rowdata) {
	selectrow=index;
	if(index==selectrow)
	{
		var iUserID=rowdata.TUserID;
		var iUserName=rowdata.TUserName;
		
	    setValueById("UserID",iUserID)
	    setValueById("UserName",iUserName)
	    
		
	}else
	{
		selectrow=-1;
		
	
	}


}


document.body.onload = BodyLoadHandler;

