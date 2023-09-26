var selectrow=0;

var Component="DHCEQMessagesList"

function BodyLoadHandler() 
{
	fillData()	
	InitPage()	
    InitUserInfo(); //系统参数
	InitEvent();
	KeyUp("BussType^EmergencyLevel","N");
	Muilt_LookUp("BussType^EmergencyLevel")
}
function InitPage()
{
	var ReadOnly=GetElementValue("ReadOnly")
	var Status=GetElementValue("Status")
	if (ReadOnly==1)	//接受信息
	{
		//modified by zy 2011-03-03 ZY0064
		if (GetElementValue("ReadFlagDR")!="")
		{
			SetElement("ReadFlag",GetElementValue("ReadFlagDR"))
		}
		if (GetElementValue("DealFlagDR")!="")
		{
			SetElement("DealFlag",GetElementValue("DealFlagDR"))
		}
		//end zy 2011-03-03 ZY0064
		Component="DHCEQMessagesListA"
	}
	else	//发送信息
	{
		if (Status=="0")	//待发信息
		{
			HiddenObj("BussType") 
			HiddenObj("cBussType")
			HiddenObj("ld"+GetElementValue("GetComponentID")+"iBussType")
			HiddenObj("ReadFlag");
			HiddenObj("cReadFlag")
			HiddenObj("SendBeginDate") 
			HiddenObj("cSendBeginDate")
			HiddenObj("ld"+GetElementValue("GetComponentID")+"iSendBeginDate")
			HiddenObj("SendEndDate") 
			HiddenObj("cSendEndDate")
			HiddenObj("ld"+GetElementValue("GetComponentID")+"iSendEndDate")
		}
	}
	var MessageTypeDR=GetElementValue("MessageTypeDR")
	var SendTypeDR=GetElementValue("SendTypeDR")
	if (MessageTypeDR!="")	SetElement("MessageType",MessageTypeDR)
	if (SendTypeDR!="")	SetElement("SendType",SendTypeDR)
}

function InitEvent()
{
	var obj=document.getElementById("BSendMessage");
	if (obj) obj.onclick=BSendMessages_Click;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}

function BSendMessages_Click()
{
	var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMessages";
   	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=990,height=650,left=120,top=0')
}

function BFind_Click()
{
	var val="&vData="+GetElementValue("vData");
	val=val+"&BussTypeDR="+GetElementValue("BussTypeDR");
	val=val+"&BussType="+GetElementValue("BussType");
	val=val+"&SendTypeDR="+GetElementValue("SendType");
	val=val+"&MessageTypeDR="+GetElementValue("MessageType");
	val=val+"&SendBeginDate="+GetElementValue("SendBeginDate");
	val=val+"&SendEndDate="+GetElementValue("SendEndDate");
	val=val+"&ReadBeginDate="+GetElementValue("ReadBeginDate");
	val=val+"&ReadEndDate="+GetElementValue("ReadEndDate");
	val=val+"&EmergencyLevelDR="+GetElementValue("EmergencyLevelDR");
	val=val+"&EmergencyLevel="+GetElementValue("EmergencyLevel");
	val=val+"&ReadFlagDR="+GetElementValue("ReadFlag");
	val=val+"&DealFlagDR="+GetElementValue("DealFlag");  //modified by zy 2011-03-03 ZY0064
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT="+Component+val;
}

function fillData()
{
	var vData=GetElementValue("vData")
	if (vData!="")
	{
		var list=vData.split("^");
		for (var i=1; i<list.length; i++)
		{
			Detail=list[i].split("=");
			switch (Detail[0])
			{
				default :
				SetElement(Detail[0],Detail[1]);
				break;
			}
		}
	}
}
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var objtbl=document.getElementById('t'+Component); //得到表格   t+组件名称
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	selectrow=rowObj.rowIndex;								//当前选择行
}

function GetBussTypeID(value)
{
	GetLookUpID("BussTypeDR",value);
}
function GetEmergencyLevelID(value)
{
	GetLookUpID("EmergencyLevelDR",value);
}
document.body.onload = BodyLoadHandler;