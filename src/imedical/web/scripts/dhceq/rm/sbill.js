var columns=getCurColumnsInfo('RM.G.Rent.Bill','','','');
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
	initButton(); //��ť��ʼ��
	jQuery("#BAdd").linkbutton({iconCls: 'icon-w-add'});
	jQuery("#BAdd").on("click", BAdd_Clicked);
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
	showWindow(url,"����������ϸ����","","","icon-w-paper","modal","","","large",reloadGrid);   //modify  by lmm 2020-06-04 UI
}
function reloadGrid()
{
	$("#tDHCEQSBill").datagrid('reload');
}
function creatToolbar()
{
	var rows = $('#tDHCEQSBill').datagrid('getRows');
	var lable_innerText='�˵�����:'+rows.length;
	$("#sumTotal").html(lable_innerText);
}