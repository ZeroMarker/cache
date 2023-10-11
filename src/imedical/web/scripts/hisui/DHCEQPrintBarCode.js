/// Modified By HZY 2012-04-27.HZY0030
/// 修改函数:BatchPrint
//Modefied by zc0044 2018-11-22  元素取值方法改调用
/// ------------------------------------------------------
var BeginEquipID="";
var EndEquipID="";  //Modefied by zc0098 2021-1-29 添加结束条码信息
function BodyLoadHandler() {
	//InitUserInfo();
	initUserInfo();  //Modefied by zc0045 2018-11-26  修改界面初始方法
	InitEvent();  //hisui改造 add by zc0037 2018-09-30
	InitPage();
	initButtonWidth()  //hisui改造 add by zc0037 2018-09-30
	DisableElement("EquipNo",true)
	DisableElement("EndEquipNo",true)   //Modefied by zc0098 2021-1-29 添加结束条码信息
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
		SetChkElement("BaseName",1);//add by csj 2020-07-29
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
    
     $("#EndEquipNo").keydown(EndEquipNo_KeyDown);   //Modefied by zc0098 2021-1-29 添加结束条码信息
}

function Continue_change()
{
	var value=GetChkElementValue("Continue")
	if (value==true)
	{
		DisableElement("EquipNo",false)
		DisableElement("EndEquipNo",false)  //Modefied by zc0098 2021-1-29 添加结束条码信息
	}
	else
	{
		DisableElement("EquipNo",true)
		DisableElement("EndEquipNo",true)  //Modefied by zc0098 2021-1-29 添加结束条码信息
	}
	SetElement("EquipNo","")
	SetElement("EquipName","")
	BeginEquipID="";
	//Modefied by zc0098 2021-1-29 添加结束条码信息 begin
	SetElement("EndEquipNo","")
	SetElement("EndEquipName","")
	EndEquipID="";
	//Modefied by zc0098 2021-1-29 添加结束条码信息 end
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
	var BaseName=GetElementValue("BaseName");	//add by csj 2020-07-27
	var flag=GetChkElementValue("Continue");
	var EquipNo=GetElementValue("EquipNo");
	var BeginNum=1;
	var EndEquipNo=GetElementValue("EndEquipNo");   //Modefied by zc0098 2021-1-29 添加结束条码信息
	var EndNum="";   //Modefied by zc0098 2021-1-29 添加结束条码信息
	
	//add by csj 2020-07-29 SortType 0:根据台帐检索顺序  1:按科室排序后的顺序位置 2、根据设备名称、编号排序后的顺序位置 3、按科室排序、设备名称、设备编号排序后的顺序
	var SortType="3"
	if(BaseLoc==true&&BaseName==false){
		SortType="1"
	}
	else if(BaseLoc==false&&BaseName==true){
		SortType="2"
	}
	else if(BaseLoc==true&&BaseName==true){
		SortType="3"
	}else{
		SortType="0"
	}
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
			//Modefied by zc0098 2021-1-29 添加结束条码信息 begin
			if (EndEquipNo=="")
			{
				messageShow('confirm','','','未输入结束打印条码!确认全部打印?','','','')
			}
			else
			{
				GetEndEquipInfo();
				if (EndEquipID=="")
				{
					messageShow('popover','error','提示',"未输入正确的结束打印条码!")
	    			return;
				}					
			}
			//Modefied by zc0098 2021-1-29 添加结束条码信息 end								
		}
	}
    //modified by ZY20221115 bug:3081274
    //var encmeth=GetElementValue("GetNum");
    //var TotalFlag=GetElementValue("TotalFlag");
    //num=cspRunServerMethod(encmeth,"",Job)-1;   //modified by csj 2020-03-01 需求号：1206002
    num= tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetTempGlobalData",'EquipList','',getElementValue("Job"),'','0'); 
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
    else
    {
        num=num-1   //最后合计行不统计
    }
    //modified by csj 2020-07-29
    if (SortType!="0")
    {
        SetCElement("Info","正在按科室顺序整理数据!请稍等...")
        //encmeth=GetElementValue("LocCompositor");
        //if (encmeth=="") return;
        //var result=cspRunServerMethod(encmeth,Job,SortType);    //modified by csj 2020-07-29  添加排序类型参数 需求号：1206002
        var result= tkMakeServerCall("web.DHCEQ.EM.BUSEquip","LocPrintEquip",Job,'',SortType); 
        if (result==1)
        {
            SetCElement("Info","")
        }
    }
        
    ///获取开始位置
    if (BeginEquipID!="")
    {   
        //encmeth=GetElementValue("GetBeginNum");
        //if (encmeth=="") return;
        //BeginNum=cspRunServerMethod(encmeth,SortType,BeginEquipID,Job);     //modified by czf 2020-05-09 //modified by csj 2020-07-29
        var BeginNum= tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetNextNum",Job,'',SortType,BeginEquipID); 
    }
    //Modefied by zc0098 2021-1-29 添加结束条码信息 begin
    ///获取结束位置
    if (EndEquipID!="")
    {   
        //encmeth=GetElementValue("GetBeginNum");
        //if (encmeth=="") return;
        //EndNum=cspRunServerMethod(encmeth,BaseLoc,EndEquipID,Job);      //modified by czf 2020-05-09
        var BeginNum= tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetNextNum",Job,'',BaseLoc,EndEquipID); 
    }
    //Modefied by zc0098 2021-1-29 添加结束条码信息 end
    //encmeth=GetElementValue("GetList");
    //if (SortType!="0")  encmeth=GetElementValue("GetLocList");  //modified by csj 2020-07-29
    if (EndNum!=="") num=EndNum;   //Modefied by zc0098 2021-1-29 添加结束条码信息
    for (var i=BeginNum; i<=num; i++)
    {
        var EquipID="";
        if (SortType==0) //modified by csj 2020-07-29
        {
            
            //var str=cspRunServerMethod(encmeth,'',Job,i); //Modified By HZY 2012-04-27.HZY0030.将参数个数由4个改为3个. //modified by czf 2020-05-09
            var str= tkMakeServerCall("web.DHCEQ.Plat.LIBCommon","GetTempGlobalData",'EquipList','',getElementValue("Job"),'',i); 
            var List=str.split("^");
            EquipID=List[63]; 
        }
        else
        {
            //var str=cspRunServerMethod(encmeth,i);
            var str= tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetLocPrintList",i); 
            if(str=="") continue;       //modified by czf 2020-05-09
            var List=str.split("^");
            EquipID=List[0]; 
        }
        SetCElement("Info","正在打印中......   第"+i+"个,共"+num+"个");
        if (Type==1)
        {
            printBarStandard(0, EquipID, {}, {}, "");
            
            /// Mozy    2021-8-12   打印附件    改调用plat/printbar.js里方法
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
                            // 附件信息
                            var gbldata=tkMakeServerCall("web.DHCEQAffix","GetAffixByID",'','',affList[c]); 
                            if (gbldata=="") return;
                            var list=gbldata.split("^");
                            var num=parseInt(list[6]);
                            for (var i = 1; i <= num; i++)
                            {
                                var affixData=tkMakeServerCall("web.DHCEQAffix","GetOneAffix",affList[c],i);
                                affixData=jQuery.parseJSON(affixData);
                                if (affixData.SQLCODE<0) {messageShow('alert','error','提示',affixData.Data,'','','');return;}
                                var objAffix=affixData.Data;
                                var BarMark=objAffix.AFNo;  //标签码信息
                                printBarStandard(1, EquipID, {}, objAffix, BarMark);
                            }
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
//Modefied by zc0098 2021-1-29 添加结束条码信息
function EndEquipNo_KeyDown()
{	
	if (event.keyCode==13)
	{
		GetEndEquipInfo();
	}
}
//Modefied by zc0098 2021-1-29 添加结束条码信息
function GetEndEquipInfo()
{
	var EndEquipNo=GetElementValue("EndEquipNo")
		
	var encmeth=GetElementValue("GetRowID");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,EndEquipNo);
	if (result=="")
	{
		EndEquipID="";
	}
	else
	{
		EndEquipID=result;
		var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSEquip","GetOneEquip",EndEquipID);
		jsonData=jQuery.parseJSON(jsonData);
		if (jsonData.SQLCODE<0) {messageShow('alert','error','提示',jsonData.Data,'','','');return;}
		var objEquip=jsonData.Data;
		if (objEquip.EQRowID=="")
		{
			messageShow('alert','error','提示','没有找到设备信息!','','','');
			return;
		}
		SetElement("EndEquipName",objEquip.EQName);
	}
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
