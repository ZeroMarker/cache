var SelectedRow = -1;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //ϵͳ����
    initButtonWidth()  //hisui���� add by kdf 2018-10-18
	InitEvent();	
	disabled(true);//�һ�
	KeyUp("SourceType^Hospital^EquipType");	//���ѡ��		//Modify DJ 2015-08-20 DJ0157
	Muilt_LookUp("SourceType^Hospital^EquipType");			//Modify DJ 2015-08-20 DJ0157
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
	var obj=document.getElementById("Rule");
	if (obj) obj.onchange=Rule_Bracket;
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
  	combindata=combindata+"^"+GetElementValue("SourceTypeID") ;
  	combindata=combindata+"^"+GetElementValue("Rule") ;
  	combindata=combindata+"^"+GetChkElementValue("InvalidFlag") ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	combindata=combindata+"^"+GetElementValue("Hold4") ;
  	combindata=combindata+"^"+GetElementValue("Hold5") ;
  	combindata=combindata+"^"+GetElementValue("HospitalDR") ;
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ;
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
	if (!Rule_Bracket()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //��������
	var result=cspRunServerMethod(encmeth,plist,"");
	if(result=="") 
	{
		messageShow("","","",t[-3001]);
		return
	}
	if (result>0) location.reload();
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		messageShow("","","",t[-3001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
///ѡ�����д����˷���
// modified by kdf 2018-10-18 hisui-����
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)	
	{
		Clear();
		disabled(true);//�һ�	
		SelectedRow=-1;
		$('#tDHCEQPriorityRule').datagrid('unselectAll');  //hisui���� add by kdf 2018-10-18
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=index;
		rowid=rowdata.TRowID ;
		SetData(rowid);//���ú���
		disabled(false);//���һ�
	}
}
function Clear()
{
	SetElement("RowID","")
	SetElement("SourceTypeID","");
	SetElement("SourceType","");
	SetElement("Rule","");
	SetElement("InvalidFlag","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
	SetElement("HospitalDR","");
	SetElement("Hospital","");			//Modify DJ 2015-08-20 DJ0157
	SetElement("EquipTypeDR","");
	SetElement("EquipType","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("RowID",list[0])
	SetElement("SourceTypeID",list[1]);
	SetElement("SourceType",list[2]);
	SetElement("Rule",list[3]);
	SetChkElement("InvalidFlag",list[4]);	
	SetElement("Hold1",list[5]);
	SetElement("Hold2",list[6]);
	SetElement("Hold3",list[7]);
	SetElement("Hold4",list[8]);
	SetElement("Hold5",list[9]);
	SetElement("HospitalDR",list[10]);
	SetElement("Hospital",list[11]);		//Modify DJ 2015-08-20 DJ0157
	SetElement("EquipTypeDR",list[12]);
	SetElement("EquipType",list[13]);
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
function GetApproveType(value) 
{
	var obj=document.getElementById("SourceTypeID");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
function GetHospital(value)
{
	var obj=document.getElementById("HospitalDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
function GetEquipType(value) 
{
	var obj=document.getElementById("EquipTypeDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
//add by zx �ж�����ƥ��
function Rule_Bracket()
{
	var str=GetElementValue("Rule");
	var Bracket = [];   
    var str= str ||'';  
    for(var i=0; i<str.length; i++)
    {  
        if(str.charAt(i)=="(") //����Ϊ��ʱ��ջ
        {  
            Bracket.push('(');
        } 
        
        if(str.charAt(i)=="{")
        {  
            Bracket.push('{');  
        }
        
        if(str.charAt(i)==")")
        {   
            if(Bracket.length&&Bracket[Bracket.length-1]=="(") //����Ϊ����ƥ��ʱ��ջ
            {
		        Bracket.pop(); 
            }
            else
	        {
		        alertShow("��ʽ���Ų����!");
		        return false;
		    }
        }
        if(str.charAt(i)=="}")
        {   
            if(Bracket.length&&Bracket[Bracket.length-1]=="{")
            {
		        Bracket.pop(); 
            }
            else
	        {
		        alertShow("��ʽ���Ų����!");
		        return false;
		    }
        }
    }
    if(Bracket.length) //ջ�л���ֵʱ������ȱ��
    {  
        alertShow("��ʽ���Ų���ԣ�ȱ��������!")  
        return false;  
    }  
    return true;   
}
document.body.onload = BodyLoadHandler;
