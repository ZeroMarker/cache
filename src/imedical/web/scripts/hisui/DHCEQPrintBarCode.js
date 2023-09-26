/// Modified By HZY 2012-04-27.HZY0030
/// 修改函数:BatchPrint
//Modefied by zc0044 2018-11-22  元素取值方法改调用
/// ------------------------------------------------------
var BeginEquipID="";

function BodyLoadHandler() {
	//InitUserInfo();
	initUserInfo();  //Modefied by zc0045 2018-11-26  修改界面初始方法
	InitEvent();  //hisui改造 add by zc0037 2018-09-30
	InitPage();
	initButtonWidth()  //hisui改造 add by zc0037 2018-09-30
	DisableElement("EquipNo",true)
}

function InitPage() //初始化
{
	var Type=GetElementValue("Type");
	if (Type=="Card")
	{
		SetElement("cEQTitle","卡片打印");
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
function InitEvent() //初始化
{
	var obj=document.getElementById("BPrint");
	if (obj) obj.onclick=BPrint_Click;
	var obj=document.getElementById("BPrintCard");
	if (obj) obj.onclick=BPrintCard_Click;
	var obj=document.getElementById("BPrintCardVerso");
	if (obj) obj.onclick=BPrintCardVerso_Click;
	//hisui改造 add by zc0037 2018-09-30 beginn
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
    //hisui改造 add by zc0037 2018-09-30 end
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
/// 打印卡片正面
function BPrintCard_Click()
{
	BatchPrint(2);
}
/// Mozy	2011-3-8
/// 打印卡片背面
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
		//Modefied by zc0044 2018-11-22  修改取设备信息方法  begin
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",BeginEquipID);
		jsonData=jQuery.parseJSON(jsonData);
		if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data,'','','');return;}
		var objEquip=jsonData.Data;
		if (objEquip.EQRowID=="")
		{
			messageShow('alert','error','提示','没有找到设备信息!','','','');
			return;
		}
		//Modefied by zc0044 2018-11-22  修改取设备信息方法  begin
		SetElement("EquipName",objEquip.EQName);
	}
}

///Modified By HZY 2012-04-27.HZY0030
function BatchPrint(Type)
{
	var Job=location.search.substr(1).split("&")[1].split("=")[1]	//add by csj 2020-03-01 需求号:1206002
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
			//Modefied by zc0044 2018-11-22  修改消息弹出提示方法 
			messageShow('confirm','','','未输入开始打印条码!确认全部打印?','','','')
		}
		else
		{
			GetEquipInfo();
			if (BeginEquipID=="")
			{
				//Modefied by zc0044 2018-11-22  修改消息弹出提示方法 
				messageShow('popover','error','提示',"未输入正确的开始打印条码!")
	    		return;
			}					
		}
	}
	
    var encmeth=GetElementValue("GetNum");
    var TotalFlag=GetElementValue("TotalFlag");
	num=cspRunServerMethod(encmeth,"",Job)-1;	//modified by csj 2020-03-01 需求号：1206002
	//hisui改造 add by zc0037 2018-09-30
	/*
	if ((TotalFlag=="1")||(TotalFlag==2)) //检测台账查询时是否显示合计行
	{
		num=num-1
	}*/
	if (num<=0) 
	{
		//Modefied by zc0044 2018-11-22  修改消息弹出提示方法 
		messageShow('popover','alert','提示',"无数据可打印")
		return
	}
	
	if (BaseLoc==1)
	{
		SetCElement("Info","正在按科室顺序整理数据!请稍等...")
		encmeth=GetElementValue("LocCompositor");
		if (encmeth=="") return;
		var result=cspRunServerMethod(encmeth,Job);	//modified by csj 2020-03-01 需求号：1206002
		if (result==1)
		{
			SetCElement("Info","")
		}
	}
	
	///获取开始位置
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
			var str=cspRunServerMethod(encmeth,'',Job,i); //Modified By HZY 2012-04-27.HZY0030.将参数个数由4个改为3个. //modified by czf 2020-05-09
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
		SetCElement("Info","正在打印中......   第"+i+"个,共"+num+"个");
		if (Type==1)
		{
			printBars(EquipID,"tiaoma")		//Modify DJ 2016-07-19
			//Modefied by zc0044 2018-11-22 改调用plat/printbar.js里方法
			/// 打印附件	2016-6-27
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

//定义页面加载方法
document.body.onload = BodyLoadHandler;
