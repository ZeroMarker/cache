$(function(){
	initDocument();
	
});

function initDocument()
{
	initUserInfo();
    initMessage("StockMove");
    initButton(); //��ť��ʼ��
}

function BSubmit_Clicked()
{
	//modified by MZY
	if (getElementValue("DisuseType")=="")
	{
		alertShow("��ѡ�񱨷����ͣ�")
		return;
	}
	var BatchRequestFlag=getElementValue("DisuseType")
	parent.opener.BatchDisuse(BatchRequestFlag)
}
