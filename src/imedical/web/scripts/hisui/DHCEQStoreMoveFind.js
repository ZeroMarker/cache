
/// -------------------------------
/// �޸�:ZY  2009-07-06  BugNo.ZY0007
/// �޸�����:���Ӻ���MovType
/// ��������:�޸��豸ת�����͵�ʱ��?���������Һͽ��ܿ��Ҵ��ݲ�ͬ�Ŀ������Ͳ���
/// --------------------------------
///modify by jyp 2018-08-16 Hisui���죺���initButtonWidth()�������ư�ť���ȣ�BFind�󶨵���¼�
function BodyLoadHandler(){
	initButtonWidth(); //add by jyp 2018-08-16
	InitUserInfo();	
	InitPage();	
	SetBEnable();
	SetStatus();
	SetElement("MoveType",GetElementValue("MoveTypeID"))
	var obj=document.getElementById("BFind");
	//add by hyy 2023-02-03 ui����
	initPanelHeaderStyle();
	initButtonColor();
	if (obj) obj.onclick=BFind_Click;
	
	// add by ZX 2018-11-03 hisui����
	var obj=document.getElementById("BAddNew");
	if (obj) obj.onclick=BAdd_Clicked;
	if (jQuery("#BAddNew").length>0)
	{
		if ((typeof(HISUIStyleCode)!='undefined')&&(HISUIStyleCode=="lite")){
			// �����
			if (($("#BAddNew").attr('class')).indexOf("l-btn-disabled")==-1){
				$("#BAddNew").css({"background-color":"#28ba05","color":"#ffffff"})
			}else{
				$("#BAddNew").css({'background-color':'#E5E5E5','color':'#999'})
			}
		}
	}
}
function SetStatus()
{
	SetElement("Status",GetElementValue("GetStatu"))
}
function InitPage()
{
	KeyUp("FromLoc^ToLoc^Hospital");  //���ѡ�� Modied By QW20210629 BUG:QW0131 Ժ��
	Muilt_LookUp("FromLoc^ToLoc^Hospital");  //�س�ѡ�� Modied By QW20210629 BUG:QW0131 Ժ��
	///zy 2009-07-15 BugNo.ZY0007
	var obj=document.getElementById("MoveType");
	if (obj) obj.onchange=MoveType;
	////////////////////
	//Add By QW20210629 BUG:QW0131 Ժ�� begin
	var HosCheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051");
	if(HosCheckFlag=="0")
	{
		hiddenObj("cHospital",1);
		hiddenObj("Hospital",1);
	}
	//Add By QW20210629 BUG:QW0131 Ժ�� end
}
function GetFromLoc(value)
{
	GetLookUpID("FromLocDR",value);
}
function GetToLoc(value)
{
	GetLookUpID("ToLocDR",value);
}
function SetBEnable()
{
	var WaitAD=GetElementValue("WaitAD");
	if (WaitAD!="off")
	{
		DisableBElement("BAddNew",true);
	}
}
/// ����:zy 2009-07-15 BugNo.ZY0007
/// ��������?MoveType
/// ����:�޸��豸ת�����͵�ʱ��?���������Һͽ��ܿ��Ҵ��ݲ�ͬ�Ŀ������Ͳ���
/// -------------------------------
function MoveType()
{
	var value=GetElementValue("MoveType")
	if (value=="0")
	{
		SetElement("FromLocType","0101");
		SetElement("ToLocType","0102");
	}else if (value=="3")
	{
		SetElement("FromLocType","0102");
		SetElement("ToLocType","0101");
	}else
	{
		SetElement("FromLocType","0102");
		SetElement("ToLocType","0102");
	}
}
//////////
// add by JYP 2018-08-09 hisui����
function BFind_Click()
{
	$("#DHCEQStoreMoveFind").datagrid("load");
   return ;	
}

// add by ZX 2018-11-03 hisui����
//modified by csj 2020-03-23 ����ţ�1217727
function BAdd_Clicked()
{
	if (!$(this).linkbutton('options').disabled){	
		var val="&RowID=&QXType=&WaitAD=off";
		url="dhceq.em.storemove.csp?"+val;
		showWindow(url,"ת�����뵥","","","icon-w-paper","modal","","","large");  //modify by lmm 2020-06-04 UI
	}
}

//Add By QW20210629 BUG:QW0131 Ժ��
function GetHospital(value)
{
	GetLookUpID("HospitalDR",value); 			
}
document.body.onload = BodyLoadHandler;
