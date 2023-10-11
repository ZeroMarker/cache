var columns=getCurColumnsInfo('RM.G.Rent.Bill','','','');
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
	initButton(); //按钮初始化
	//jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'}); // modifie by LMH 20230206 多余
	//jQuery("#BAdd").on("click", BAdd_Clicked);    //modifie by LMH 20230206 多余
	showBtnIcon('BFind^BAdd',false); // added by LMH 20230206 动态设置是否极简显示按钮图标
	initButtonWidth();
	defindTitleStyle();
	$HUI.datagrid("#tDHCEQSBill",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSSBill",
			QueryName:"GetRentBill",
			BillStartDate:getElementValue("StartDate"),
			BillEndDate:getElementValue("EndDate"),
			FromHospitalDR:'',
			ToHospitalDR:'',
			ShareType:''
		},
		toolbar:[{}], 
		//fitColumns : true, //modified by LMH 20230206 UI 列少默认向左对齐
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
	$HUI.datagrid("#tDHCEQSBill",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSSBill",
			QueryName:"GetRentBill",
			BillStartDate:getElementValue("StartDate"),
			BillEndDate:getElementValue("EndDate"),
			FromHospitalDR:'',
			ToHospitalDR:'',
			ShareType:''
		}
	});
}

function BAdd_Clicked()
{
	var url="dhceq.rm.sbilllist.csp?BillDR=";
	showWindow(url,"调配收入明细报表","","","icon-w-paper","modal","","","large",reloadGrid);   //modify  by lmm 2020-06-04 UI
}
function reloadGrid()
{
	$("#tDHCEQSBill").datagrid('reload');
}
function creatToolbar()
{
	var rows = $('#tDHCEQSBill').datagrid('getRows');
	var lable_innerText='账单总数:'+rows.length;
	$("#sumTotal").html(lable_innerText);
}
