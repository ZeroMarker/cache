var SelectedRow = -1;	//hisui���죺�޸Ŀ�ʼ�к�  Add By DJ 2018-10-12
var rowid=0;
function BodyLoadHandler() 
{	
    $("body").parent().css("overflow-y","hidden");  //Add By DJ 2018-10-12 hiui-���� ȥ��y�� ������
	$("#tDHCEQMCFaultType").datagrid({showRefresh:false,showPageList:false,afterPageText:'',beforePageText:''});   //Add By DJ 2018-10-12 hisui���죺���ط�ҳ������
	InitUserInfo(); //ϵͳ����
	InitEvent();
	initButtonWidth();	//hisui���� Add By DJ 2018-10-12	
	disabled(true);//�һ�
	
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
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
function BAdd_Click() //����
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,plist,'2');
	result=result.replace(/\\n/g,"\n")
	//alertShow("result"+result)
	//messageShow("","","",result);
	if(result=="")
	{
		messageShow("","","",t[-3001])
		return
	}
	else
	{
		alertShow("�����ɹ�!")
	   location.reload();
	}	
}	
function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("Code") ;//
  	combindata=combindata+"^"+GetElementValue("Desc") ; //
  	combindata=combindata+"^"+GetElementValue("Remark") ; //
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,'2');
	result=result.replace(/\\n/g,"\n")
	//alertShow("result"+result)
	if(result=="") 
	{
		messageShow("","","",t[-3001]);
		return
	}
	else 
	{
		alertShow("���³ɹ�!")
		location.reload();	
	}
}
function BDelete_Click() 
{
	var rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);//����ţ�269196  add by csy 2016-10-10
    if (!truthBeTold) return;//����ţ�269196  add by csy 2016-10-10
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		messageShow("","","",t[-3001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n");
	if (result==0) 
	{
		alertShow("ɾ���ɹ�!")
		location.reload();	
	}
}
///hisui���죺 Add By DJ 2018-10-12
function SelectRowHandler(index,rowdata){
	if (index==SelectedRow){
		Clear();
		SelectedRow= -1;
		disabled(true); 
		$('#tDHCEQMCFaultType').datagrid('unselectAll'); 
		return;
		}
		
	SetData(rowdata.TRowID); 
	disabled(false)  
    SelectedRow = index;
}
function Clear()
{
	SetElement("RowID","")
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Remark","");
	}
function SetData(rowid)
{
	//alertShow("rowid::::"+rowid)
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	//alertShow("list"+list);
	SetElement("RowID",list[0]); //rowid
	SetElement("Code",list[1]); //
	SetElement("Desc",list[2]); //
	SetElement("Remark",list[3]);//
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


