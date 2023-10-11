/// DHCEQIFBFind.js
function BodyLoadHandler()
{
	InitUserInfo();
	InitPage();
	SetBEnable();
	
	initButtonWidth();  //hisui���� add by wy
	///modofied by ZY0197   ���ӹ�����Ҳ�����ͬʱ��hisui������������
	//add by lmm 2023-02-01 ����UI����
	initButtonColor(); 
	initPanelHeaderStyle();
}

function InitPage()
{
	SetElement("Status",GetElementValue("GetStatus"));
	KeyUp("Mode");
	Muilt_LookUp("Mode");
	var obj=document.getElementById("BAdd");   //modify by myl 1796707 20210309
	if (obj) obj.onclick=BAdd_Clicked;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Clicked;
}

function GetModeDR(value)
{
	var list=value.split("^");
	SetElement("Mode",list[0]);
	SetElement("ModeDR",list[1]);
}

function SetBEnable()
{
	var Type=GetElementValue("Type");
	if (Type!=0)
	{
		DisableBElement("BAdd",true);
	}
	else
	{
		EQCommon_HiddenElement("cWaitAD");
		$("#WaitAD").parent().empty()	//Mozy	1012982	2019-9-14
		//HiddenCheckBox("WaitAD");   //hisui���� add wy 2018-11-16 ����750679
	}
}
 //hisui���� add wy 2018-11-16 ����750679
function HiddenCheckBox(name)
{
	$("#"+name).parent(".hischeckbox_square-blue").css("display","none");
}

//add by ZY0197  HISUI ������������
//"&QXType="_%request.Get("QXType")_"&ApproveRole="_%request.Get("ApproveRole")_"&WaitAD="_%request.Get("WaitAD")_"&Status="_%request.Get("Status")
function BFind_Clicked(){
	if (!$(this).linkbutton('options').disabled){
		//modified by ZY0228 2020-05-09
		//modified by csj 2020-03-23 ����ţ�1217138
		$('#tDHCEQIFBFind').datagrid('load',{ComponentID:getValueById("GetComponentID"),PrjName:getValueById("PrjName"),No:getValueById("No"),WaitAD:$('#WaitAD').prop("checked")?'checked':'',Status:getValueById("Status"),ApproveRole:getValueById("ApproveRole"),ModeDR:getValueById("ModeDR"),StartDate:getValueById("StartDate"),EndDate:getValueById("EndDate"),ManageLocDR:getValueById("ManageLocDR")});	
		}
}

//add by ZY0197  HISUI ������������
function BAdd_Clicked()
{
	//modified by ZY0228 2020-05-09
	var url="dhceq.em.ifb.csp?Status=0&Type=0&QXType="+GetElementValue("QXType")+"&ManageLocDR="+GetElementValue("ManageLocDR"); 
	showWindow(url,"�豸�б굥","","","icon-w-paper","modal","","","large",BFind_Clicked)   //modify by lmm 2020-06-04 UI
}
document.body.onload = BodyLoadHandler;
