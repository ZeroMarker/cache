var SelectedRow = 0;
var rowid=0;
//װ��ҳ��  �������ƹ̶�
function BodyLoadHandler() {
	initButtonWidth();///Add By QW 2018-10-11 HISUI����:�޸İ�ť����
	setButtonText();///Add By QW 2018-10-11 HISUI����:��ť���ֹ淶
	InitUserInfo();
	InitEvent();	//��ʼ��
	KeyUp("Loc^SourceID^ResourceType^Item");
	Muilt_LookUp("Loc^SourceID^ResourceType^Item");
	fillData();
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
	var val="";
	val=val+"equip=SourceID="+GetElementValue("SourceIDDR")+"^";
	val=val+"dept=Loc="+GetElementValue("LocDR")+"^";
	val=val+"masteritem=Item="+GetElementValue("ItemDR")+"^";
	val=val+"resourcetype=ResourceType="+GetElementValue("ResourceTypeDR");  ///����ƴд���� ����ţ�268630  Midify by MWZ 2016-10-17  
	var encmeth=GetElementValue("GetDRDesc");
	var result=cspRunServerMethod(encmeth,val);
	var list=result.split("^");
	for (var i=1; i<list.length; i++)
	{
		var Detail=list[i-1].split("=");
		SetElement(Detail[0],Detail[1]);
	}
}

function InitEvent() //��ʼ��
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}
///Add By QW 2018-10-10 hisui�����������
function BFind_Click()
{
	var StartYearMonth=GetElementValue("StartYearMonth");
	if (StartYearMonth!="")
	{
		var encmeth=GetElementValue("IsMonth");
		var IsMonth=cspRunServerMethod(encmeth,StartYearMonth);
		if (IsMonth=="1")
		{
			messageShow("","","",t["01"]);
			return;
		}
	}
	var EndYearMonth=GetElementValue("EndYearMonth");
	if (EndYearMonth!="")
	{
		var encmeth=GetElementValue("IsMonth");
		var IsMonth=cspRunServerMethod(encmeth,EndYearMonth);
		if (IsMonth=="1")
		{
			messageShow("","","",t["01"]);
			return;
		}
	}
	
	var val="&vData="
	val=val+"^SourceTypeDR="+GetElementValue("SourceType");    //modified by czf ����ţ�353829
	val=val+"^SourceIDDR="+GetElementValue("SourceIDDR");
	val=val+"^ModelDR="+GetElementValue("ModelDR");         //modified by czf 387030
	val=val+"^ResourceTypeDR="+GetElementValue("ResourceTypeDR");
	val=val+"^LocDR="+GetElementValue("LocDR");
	val=val+"^Year="+GetElementValue("Year");       //���Ĵ���Ĳ��� modified by czf ����ţ�353866
	val=val+"^Month="+GetElementValue("Month");
	val=val+"^ItemDR="+GetElementValue("ItemDR");
	val=val+"&StartYearMonth="+GetElementValue("StartYearMonth");
	val=val+"&EndYearMonth="+GetElementValue("EndYearMonth");
	val=val+"&QXType="+GetElementValue("QXType");
	val=val+"&ResourceType="+GetElementValue("ResourceType"); ///���Ӵ���ֵ ����ţ�268630  Midify by MWZ 2016-10-17 
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQUsedResourceFind"+val;
}

function GetResourceType(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ResourceTypeDR");
	obj.value=type[1];
}


function GetSourceID(value)
{
	var type=value.split("^");
	var obj=document.getElementById("SourceIDDR");
	obj.value=type[1];
}

function GetLoc(value)
{
	var type=value.split("^");
	var obj=document.getElementById("LocDR");
	obj.value=type[1];
}

function GetItem(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ItemDR");
	obj.value=type[1];
}

//����ҳ����ط���
document.body.onload = BodyLoadHandler;
