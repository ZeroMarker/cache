//�豸����	add by wjt 2019-02-19
var SelectedRow = -1;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //ϵͳ����
	InitEvent();	
	disabled(true);//�һ�
	initButtonWidth(); 
	//InitButton();		Mozy003003	1246525		2020-3-27	ע��
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("Code") ;
  	combindata=combindata+"^"+GetElementValue("Desc") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetChkElementValue("InvalidFlag") ;
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,"");
	if(result=="") 
	{
		//alertShow(t[-3001]);
		messageShow("","","",t["-3001"]);
		return
	}
	if (result>0)
	{
		//alertShow("�����ɹ�");    //add by czf 2016-11-01  ����ţ�281632
		messageShow("","","",t["02"]);
		location.reload();	
	}
	// Mozy003008	1266885		2020-04-09 
	if(result==-9000) 
	{
		messageShow("","","","�����ظ�!");
		return
	}
}

//modified by csj 20190912 �޸�Ϊhisuiȷ�Ͽ� ����ţ�1027185
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	messageShow("confirm","","",t[-4003],"",truthBeTold,Cancel);
	function truthBeTold(){
		var encmeth=GetElementValue("GetUpdate");
		if (encmeth=="") 
		{
			//alertShow(t[-3001])
			messageShow("","","",t["-3001"]);
			return;
		}
		var result=cspRunServerMethod(encmeth,rowid,'1');
		result=result.replace(/\\n/g,"\n")
		if (result>0)
		{
			//alertShow("�����ɹ�");     //add by czf 2016-11-01  ����ţ�281632
			messageShow("","","",t["02"]);
			location.reload();	
		}
	}
	function Cancel(){
		return
	}	
}

///ѡ�����д����˷���
function SelectRowHandler(rowIndex,rowData)
{
	/* var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCAccessoryType');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; */
	//if (!index)	 return;
	if (SelectedRow==rowIndex)
	{
		Clear();
		disabled(true);//�һ�
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");	
 	}
	else
	{
		SelectedRow=rowIndex;
		//rowid=GetElementValue("TRowIDz"+SelectedRow);
		rowid=rowData.TRowID;
		SetData(rowid);//���ú���
		disabled(false);//���һ�
	}
}
function Clear()
{
	SetElement("RowID","")
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Remark","");
	SetElement("InvalidFlag","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("RowID",list[0])
	SetElement("Code",list[1]); 
	SetElement("Desc",list[2]);
	SetElement("Remark",list[3]);
	SetElement("InvalidFlag",list[4]);
}
function disabled(value)//�һ�
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}	
function condition()//����
{
	if (CheckMustItemNull()) return true;
	return false;
}
document.body.onload = BodyLoadHandler;
