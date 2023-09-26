/// Modified By HZY 2012-04-27.HZY0030
/// �޸ĺ���:BatchPrint
/// ------------------------------------------------------
var BeginEquipID="";

function BodyLoadHandler() {
	InitUserInfo();
	InitPage();
	InitEvent();
	DisableElement("EquipNo",true)
}

function InitPage() //��ʼ��
{
	var Type=GetElementValue("Type");
	if (Type=="Card")
	{
		SetElement("cEQTitle","��Ƭ��ӡ");
		HiddenObj("cBaseLoc",1);
		HiddenObj("BaseLoc",1);
		HiddenObj("BPrint",1);
		HiddenObj("PrintAffix",1);
	}
	else
	{
		HiddenObj("cPrintPreview",1);
		HiddenObj("PrintPreview",1);
		HiddenObj("BPrintCard",1);
		HiddenObj("BPrintCardVerso",1);
		SetChkElement("BaseLoc",1);
		SetChkElement("PrintAffix",1);
	}
}

function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("Continue");
	if (obj) obj.onchange=Continue_change;
	var obj=document.getElementById("EquipNo");
	if (obj) obj.onkeydown=EquipNo_KeyDown;
	var obj=document.getElementById("BPrintCard");
	if (obj) obj.onclick=BPrintCard_Click;
	var obj=document.getElementById("BPrintCardVerso");
	if (obj) obj.onclick=BPrintCardVerso_Click;
}

function Continue_change()
{
	var value=GetChkElementValue("Continue")
	if (value==true)
	{
		DisableElement("EquipNo",false)
	}
	else
	{
		DisableElement("EquipNo",true)
	}
	SetElement("EquipNo","")
	SetElement("EquipName","")
	BeginEquipID="";
}

function BPrint_Click()
{
	BatchPrint(1);
}
/// Mozy	2011-3-8
/// ��ӡ��Ƭ����
function BPrintCard_Click()
{
	BatchPrint(2);
}
/// Mozy	2011-3-8
/// ��ӡ��Ƭ����
function BPrintCardVerso_Click()
{
	BatchPrint(3);
}

function EquipNo_KeyDown()
{	
	if (event.keyCode==13)
	{
		GetEquipInfo();
	}
}

function GetEquipInfo()
{
	var No=GetElementValue("EquipNo")
		
	var encmeth=GetElementValue("GetRowID");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,No);
	if (result=="")
	{
		BeginEquipID="";
	}
	else
	{
		BeginEquipID=result;
		var obj=new Equipment(BeginEquipID,"");
		SetElement("EquipName",obj.Name);
	}
}

///Modified By HZY 2012-04-27.HZY0030
function BatchPrint(Type)
{
	var BaseLoc=GetChkElementValue("BaseLoc");
	var flag=GetChkElementValue("Continue");
	var EquipNo=GetElementValue("EquipNo");
	var BeginNum=1;
	if (BaseLoc==true)
	{	BaseLoc=1; }
	else
	{	BaseLoc=0; }
	//alertShow(BaseLoc);
	if ((flag==true))
	{
		if (EquipNo=="")
		{
			var truthBeTold = window.confirm("δ���뿪ʼ��ӡ����!ȷ��ȫ����ӡ?");
	    	if (!truthBeTold) return;
		}
		else
		{
			GetEquipInfo();
			if (BeginEquipID=="")
			{
				alertShow("δ������ȷ�Ŀ�ʼ��ӡ����!");
	    		return;
			}					
		}
	}
	
    var encmeth=GetElementValue("GetNum");
    var TotalFlag=GetElementValue("TotalFlag");
	num=cspRunServerMethod(encmeth,"","");
	if ((TotalFlag=="1")||(TotalFlag==2)) //���̨�˲�ѯʱ�Ƿ���ʾ�ϼ���
	{
		num=num-1
	}
	if (num<=0) 
	{
		alertShow("�����ݿɴ�ӡ")
		return
	}
	
	if (BaseLoc==1)
	{
		SetCElement("Info","���ڰ�����˳����������!���Ե�...")
		encmeth=GetElementValue("LocCompositor");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth);
		if (result==1)
		{
			SetCElement("Info","")
		}
	}
	
	///��ȡ��ʼλ��
	if (BeginEquipID!="")
	{	
		encmeth=GetElementValue("GetBeginNum");
		if (encmeth=="") return;
		BeginNum=cspRunServerMethod(encmeth,BaseLoc,BeginEquipID);
	}

	encmeth=GetElementValue("GetList");
	if (BaseLoc==1)  encmeth=GetElementValue("GetLocList");
	for (var i=BeginNum; i<=num; i++)
	{
		var EquipID="";
		if (BaseLoc==0)
		{
			var str=cspRunServerMethod(encmeth,'','',i); //Modified By HZY 2012-04-27.HZY0030.������������4����Ϊ3��.
			var List=str.split("^");
			EquipID=List[63]; 
		}
		else
		{
			var str=cspRunServerMethod(encmeth,i);
			var List=str.split("^");
			EquipID=List[0]; 
		}
		SetCElement("Info","���ڴ�ӡ��......   ��"+i+"��,��"+num+"��");
		if (Type==1)
		{
			PrintBars(EquipID,"tiaoma","�̶��ʲ�")		//Modify DJ 2016-07-19
			/// ��ӡ����	2016-6-27
			var value=GetChkElementValue("PrintAffix")
			if (value==true)
			{
				var encmethAF=GetElementValue("GetAffixDRsByEquip");
				if (encmethAF!="")
				{
					var affstr=cspRunServerMethod(encmethAF,EquipID);
					if (affstr!="")
					{
						var affList=affstr.split("^");
						for (var c=0;c<affList.length;c++)
						{
							//alertShow(EquipID+":"+affList[c]); 
							DHCEQPrintAFQrcode(EquipID,"tiaoma",affList[c]);
						}
					}
				}
			}
		}
		else if (Type==2)
		{
			PrintEQCard(EquipID);
		}
		else if (Type==3)
		{
			PrintEQCardVerso(EquipID);
		}
	}
	SetCElement("Info","");	
}

//����ҳ����ط���
document.body.onload = BodyLoadHandler;
