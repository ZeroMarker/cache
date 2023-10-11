$(function(){
	initDocument();
	
});

function initDocument()
{
	initUserInfo();
    initMessage("StockMove");
    initButton(); //按钮初始化
}

function BSubmit_Clicked()
{
	//modified by MZY
	if (getElementValue("DisuseType")=="")
	{
		alertShow("请选择报废类型！")
		return;
	}
	var BatchRequestFlag=getElementValue("DisuseType")
	parent.opener.BatchDisuse(BatchRequestFlag)
}
