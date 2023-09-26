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
	initButtonWidth();
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
	var lable_innerText='借入次数:'+AllNum+'总支出:'+AllPay+'总减免:'+AllCut+'总成本:'+AllCost+'总利润:'+AllProfit;
	$("#sumTotal").html(lable_innerText);
}