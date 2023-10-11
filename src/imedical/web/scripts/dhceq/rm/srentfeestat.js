var columns=getCurColumnsInfo('RM.G.Rent.FeeStat','','','');
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
	initButton(); //按钮初始化
	initLookUp();
	//showBtnIcon('BFind',false); //added by LMH 20230207 动态设置是否极简显示按钮图标
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
	var lable_innerText='借入次数:'+AllNum+'&nbsp;&nbsp;&nbsp;总支出:'+AllPay.toFixed(2)+'&nbsp;&nbsp;&nbsp;总减免:'+AllCut.toFixed(2)+'&nbsp;&nbsp;&nbsp;总成本:'+AllCost.toFixed(2)+'&nbsp;&nbsp;&nbsp;总利润:'+AllProfit.toFixed(2);
	$("#sumTotal").html(lable_innerText);
}
