///�޸�: ZY 2009-11-17 ZY0017
///�޸ĺ���BPrint_Click
///����:����ʱ����·��������
/// -------------------------------
/// �޸�:ZY  2009-07-06  BugNo.ZY0007
/// �޸�����:���Ӻ���MovType
/// ��������:�޸��豸ת�����͵�ʱ��??���������Һͽ��ܿ��Ҵ��ݲ�ͬ�Ŀ������Ͳ���
/// --------------------------------
function BodyLoadHandler(){	
	InitPage();	
	//SetElement("MoveType",GetElementValue("MoveTypeID"));
}

function InitPage()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
}

function BFind_Click()
{
	var val="&SourceType="+GetElementValue("SourceType")
	val=val+"&NameStr="+GetElementValue("NameStr")
	val=val+"&StrDate="+GetElementValue("StrDate")
	val=val+"&EndDate="+GetElementValue("EndDate")
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCheckResultFind"+val;
}
document.body.onload = BodyLoadHandler;
