/// Modified By HZY 2012-04-27.HZY0030
/// �޸ĺ���:BatchPrint
//Modefied by zc0044 2018-11-22  Ԫ��ȡֵ�����ĵ���
/// ------------------------------------------------------
var BeginEquipID="";

function BodyLoadHandler() {
	//InitUserInfo();
	initUserInfo();  //Modefied by zc0045 2018-11-26  �޸Ľ����ʼ����
	InitEvent();  //hisui���� add by zc0037 2018-09-30
	InitPage();
	initButtonWidth()  //hisui���� add by zc0037 2018-09-30
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
	var obj=document.getElementById("BPrintCard");
	if (obj) obj.onclick=BPrintCard_Click;
	var obj=document.getElementById("BPrintCardVerso");
	if (obj) obj.onclick=BPrintCardVerso_Click;
	//hisui���� add by zc0037 2018-09-30 beginn
	$HUI.checkbox(".hisui-checkbox",{
        onCheckChange:function(e,value){
	        var id=e.target.id;
	        if (id=="Continue")
	        {
		        Continue_change()
		    }
        }
    });
    $("#EquipNo").keydown(EquipNo_KeyDown);
    //hisui���� add by zc0037 2018-09-30 end
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
		//Modefied by zc0044 2018-11-22  �޸�ȡ�豸��Ϣ����  begin
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",BeginEquipID);
		jsonData=jQuery.parseJSON(jsonData);
		if (jsonData.SQLCODE<0) {messageShow('alert','error','��ʾ',jsonData.Data,'','','');return;}
		var objEquip=jsonData.Data;
		if (objEquip.EQRowID=="")
		{
			messageShow('alert','error','��ʾ','û���ҵ��豸��Ϣ!','','','');
			return;
		}
		//Modefied by zc0044 2018-11-22  �޸�ȡ�豸��Ϣ����  begin
		SetElement("EquipName",objEquip.EQName);
	}
}

///Modified By HZY 2012-04-27.HZY0030
function BatchPrint(Type)
{
	var Job=location.search.substr(1).split("&")[1].split("=")[1]	//add by csj 2020-03-01 �����:1206002
	var BaseLoc=GetElementValue("BaseLoc");
	var flag=GetChkElementValue("Continue");
	var EquipNo=GetElementValue("EquipNo");
	var BeginNum=1;
	if (BaseLoc==true)
	{	BaseLoc=1; }
	else
	{	BaseLoc=0; }
	//messageShow("","","",BaseLoc);
	if ((flag==true))
	{
		if (EquipNo=="")
		{
			//Modefied by zc0044 2018-11-22  �޸���Ϣ������ʾ���� 
			messageShow('confirm','','','δ���뿪ʼ��ӡ����!ȷ��ȫ����ӡ?','','','')
		}
		else
		{
			GetEquipInfo();
			if (BeginEquipID=="")
			{
				//Modefied by zc0044 2018-11-22  �޸���Ϣ������ʾ���� 
				messageShow('popover','error','��ʾ',"δ������ȷ�Ŀ�ʼ��ӡ����!")
	    		return;
			}					
		}
	}
	
    var encmeth=GetElementValue("GetNum");
    var TotalFlag=GetElementValue("TotalFlag");
	num=cspRunServerMethod(encmeth,"",Job)-1;	//modified by csj 2020-03-01 ����ţ�1206002
	//hisui���� add by zc0037 2018-09-30
	/*
	if ((TotalFlag=="1")||(TotalFlag==2)) //���̨�˲�ѯʱ�Ƿ���ʾ�ϼ���
	{
		num=num-1
	}*/
	if (num<=0) 
	{
		//Modefied by zc0044 2018-11-22  �޸���Ϣ������ʾ���� 
		messageShow('popover','alert','��ʾ',"�����ݿɴ�ӡ")
		return
	}
	
	if (BaseLoc==1)
	{
		SetCElement("Info","���ڰ�����˳����������!���Ե�...")
		encmeth=GetElementValue("LocCompositor");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth,Job);	//modified by csj 2020-03-01 ����ţ�1206002
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
		BeginNum=cspRunServerMethod(encmeth,BaseLoc,BeginEquipID,Job);		//modified by czf 2020-05-09
	}
	encmeth=GetElementValue("GetList");
	if (BaseLoc==1)  encmeth=GetElementValue("GetLocList");
	
	for (var i=BeginNum; i<=num; i++)
	{
		var EquipID="";
		if (BaseLoc==0)
		{
			var str=cspRunServerMethod(encmeth,'',Job,i); //Modified By HZY 2012-04-27.HZY0030.������������4����Ϊ3��. //modified by czf 2020-05-09
			var List=str.split("^");
			EquipID=List[63]; 
		}
		else
		{
			var str=cspRunServerMethod(encmeth,i);
			if(str=="") continue;		//modified by czf 2020-05-09
			var List=str.split("^");
			EquipID=List[0]; 
		}
		SetCElement("Info","���ڴ�ӡ��......   ��"+i+"��,��"+num+"��");
		if (Type==1)
		{
			printBars(EquipID,"tiaoma")		//Modify DJ 2016-07-19
			//Modefied by zc0044 2018-11-22 �ĵ���plat/printbar.js�﷽��
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
							//messageShow("","","",EquipID+":"+affList[c]); 
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
