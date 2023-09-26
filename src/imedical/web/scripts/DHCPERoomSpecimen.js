var CurrentSel=0;
function BodyLoadHandler() {
	var obj;
	obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_click;
	obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_click;
	obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_click;
	var Type=GetValue("Type",1);
	if (Type=="IP"){
		obj=GetObj("Specimen");
		obj.style.display="none";
		obj=GetObj("cSpecimen");
		obj.style.display="none";
		
	}else if (Type=="RP")
	{
		obj=GetObj("IP");
		obj.style.display="none";
		obj=GetObj("cIP");
		obj.style.display="none";
		if (Type=="RP") SetValue("cSpecimen","����λ��",2);
	}else{
		obj=GetObj("IP");
		obj.style.display="none";
		obj=GetObj("cIP");
		obj.style.display="none";
		if (Type=="SR") SetValue("cSpecimen","ǰ������",2);
	}

}
function BUpdate_click()
{
	var Type=GetValue("Type",1);
	
	if (Type=="IP"){
		var Specimen=GetValue("IP",1);
		if(Specimen==""){
			alert("����IP����Ϊ��");
			return false;
		}
		
	}else if((Type=="SP")||(Type=="RP"))
	{
		var Specimen=GetValue("Specimen",1);
		if(Specimen==""){
			alert("�걾���Ͳ���Ϊ��");
			return false;
		}
	}else if(Type=="SR")
	{
		var Specimen=GetValue("Specimen",1);
		if(Specimen==""){
			alert("ǰ�����Ҳ���Ϊ��");
			return false;
		}
	}
   
	
	var ID=GetValue("ID",1);
	var Parref=GetValue("Parref",1);
	var encmeth=GetValue("UpdateMethod",1);
	if (Parref==Specimen){
		alert("��ǰ���Һ��������Ҳ�����ͬ");
		return false;
	}
	
	var Str=Parref+"^"+Specimen;
	var rtn=cspRunServerMethod(encmeth,ID,Str,Type);
	if (rtn.split("^")[0]=="-1"){
		alert("����ʧ��:"+rtn.split("^")[1])
	}else{
		window.location.reload();
	}
}
function BDelete_click()
{
	var Type=GetValue("Type",1);
	if (Type=="SP"){
		var Specimen=GetValue("Specimen",1);
	}else{
		var Specimen=GetValue("IP",1);
	}
	var ID=GetValue("ID",1);
	if (ID=="")
	{
		alert("����ѡ���ɾ������");
		return false;
	}
	var encmeth=GetValue("DeleteMethod",1);
	var rtn=cspRunServerMethod(encmeth,ID,Type);
	if (rtn.split("^")[0]=="-1"){
		alert("����ʧ��"+rtn.split("^")[1])
	}else{
		window.location.reload();
	}
}
function BClear_click()
{
	SetValue("ID","",1);
	SetValue("Specimen","",1)
	SetValue("IP","",1)
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
//�Ա㱾ҳ�����ҳ������ȷ�Ĵ������
function ShowCurRecord(selectrow) {
	var ID=GetValue('TID'+'z'+selectrow,1);
	SetValue("ID",ID,1);
	var Type=GetValue("Type",1);
	if (Type!="IP"){
		var Specimen=GetValue('TSpecimenDR'+'z'+selectrow,1);
		SetValue("Specimen",Specimen,1)
	}else{
		var Specimen=GetValue('TSpecimenDR'+'z'+selectrow,1);
		SetValue("IP",Specimen,1)
	}
}
			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;
	
	var objtbl=GetObj('tDHCPEArea');
	
	if (objtbl) { var rows=objtbl.rows.length; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;