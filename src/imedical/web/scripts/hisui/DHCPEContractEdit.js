
//����	DHCPEContractEdit .js
//����	�����ͬά��
//���	DHCPEContractEdit 	
//����	2018.11.8
//������  xy

function BodyLoadHandler()
{
	var obj;
	
	//���� 
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	
	//����
	obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
	
	init();
}
function init()
{
	var ID=getValueById("ID");
	if(ID!=""){
		var Str=tkMakeServerCall("web.DHCPE.Contract","GetInfoByID",ID)
		var DataArr=Str.split("^"); 
		setValueById("ID",DataArr[0]);
		setValueById("No",DataArr[1]);
		setValueById("Name",DataArr[2]);
		setValueById("SignDate",DataArr[3]);
		setValueById("Remark",DataArr[4]);
	}
}
function BUpdate_click()
{
	var obj,No,Name,Remark,SignDate,ID,encmeth,Str;
	var No=getValueById("No");
	if (""==No) {
            obj=document.getElementById("No")
		if (obj) {
			//websys_setfocus(obj.id);
			//obj.className='clsInvalid';
		}
		$.messager.alert("��ʾ","��Ų���Ϊ��","info");
		return false;

	}
	

	var Name=getValueById("Name");
	if (""==Name) {
            obj=document.getElementById("Name")
		if (obj) {
			//websys_setfocus(obj.id);
			//obj.className='clsInvalid';
		}
		$.messager.alert("��ʾ","���ֲ���Ϊ��","info");
		return false;

	}
	var Remark=getValueById("Remark");
	var SignDate=getValueById("SignDate");
	var ID=getValueById("ID");
	obj=document.getElementById("UpdateClass");
	if (obj) encmeth=obj.value;
	var UserID=session['LOGON.USERID'];
	var LocID=session['LOGON.CTLOCID'];
	Str=No+"^"+Name+"^"+SignDate+"^"+Remark+"^"+UserID+"^"+LocID;
	
	if (ID==""){
			var ret=cspRunServerMethod(encmeth,"",Str);
	}else{
			var ret=cspRunServerMethod(encmeth,ID,Str);

	}
	
	var retData=ret.split("^");
	
	if(retData[0]!=-1){
		alert("���³ɹ�");
		opener.location.reload(); 
		//websys_showModal("close"); 
		window.close();
          

	}
	else {
		alert("����ʧ��,��ͬ�����Ѿ�����");
		}
}

function BClear_click()
{
	setValueById("ID","");
	setValueById("No","");
	setValueById("Name","");
	setValueById("SignDate","");
	setValueById("Remark","");
}


document.body.onload = BodyLoadHandler;