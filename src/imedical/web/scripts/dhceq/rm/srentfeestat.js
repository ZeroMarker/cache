var columns=getCurColumnsInfo('RM.G.Rent.FeeStat','','','');
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
	initButton(); //��ť��ʼ��
	initLookUp();
	//showBtnIcon('BFind',false); //added by LMH 20230207 ��̬�����Ƿ񼫼���ʾ��ťͼ��
	//initButtonWidth();  //modified by LMH 20230302 UI
	defindTitleStyle();
	$HUI.datagrid("#tDHCEQSRentFeeStat",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSRent",
			QueryName:"GetRentFeeStat",
			LocDR:getElementValue("LocDR"),
			StartDate:getElementValue("StartDate"),
			EndDate:getElementValue("EndDate"),
			Job:getElementValue("Job"),
			CurUser:getElementValue("CurUser")
		},
		toolbar:[{}], 
		fitColumns : true,
	    scrollbarSize:0, 
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  
	    columns:columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75],
		onLoadSuccess:function(){
			creatToolbar();
		}
	});
}

function BFind_Clicked()
{
	$HUI.datagrid("#tDHCEQSRentFeeStat",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSRent",
			QueryName:"GetRentFeeStat",
			LocDR:getElementValue("LocDR"),
			StartDate:getElementValue("StartDate"),
			EndDate:getElementValue("EndDate"),
			Job:getElementValue("Job"),
			CurUser:getElementValue("CurUser")
		}
	});
}
function setSelectValue(elementID,item)
{
	setElement(elementID+"DR",item.TRowID)
}
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
function creatToolbar()
{
	var AllNum=0;
	var AllPay=0;
	var AllCut=0;
	var AllCost=0;
	var AllProfit=0;
	var rows = $('#tDHCEQSRentFeeStat').datagrid('getRows');
	for (var i = 0; i < rows.length; i++) {
		AllNum=AllNum+parseFloat(rows[i].TAllNum);
		AllPay=AllPay+parseFloat(rows[i].TAllPay);
		AllCut=AllCut+parseFloat(rows[i].TAllCut);
		AllCost=AllCost+parseFloat(rows[i].TAllCost);
		AllProfit=AllProfit+parseFloat(rows[i].TAllProfit);
	}
	//modified by ZY0300 20220511
	var lable_innerText='�������:'+AllNum+'&nbsp;&nbsp;&nbsp;��֧��:'+AllPay.toFixed(2)+'&nbsp;&nbsp;&nbsp;�ܼ���:'+AllCut.toFixed(2)+'&nbsp;&nbsp;&nbsp;�ܳɱ�:'+AllCost.toFixed(2)+'&nbsp;&nbsp;&nbsp;������:'+AllProfit.toFixed(2);
	$("#sumTotal").html(lable_innerText);
}
