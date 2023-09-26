var columns=getCurColumnsInfo("RM.G.Queue.Rent","","",""); 
var rentListColumns=getCurColumnsInfo("RM.G.Rent.RentList","","",""); //add by csj 2020-02-10 待提交申请单列定义
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
	$HUI.datagrid("#tRentDoList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.LIBMessages",
		        	QueryName:"GetBussDataByCode",
					BussType:'64',
					GroupID:'',
					UserID:'',
					CurLocDR:'',
					EquipDR:''
		},
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,
	    columns:columns,
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75]
	});
	//点击维修配件也签刷新
	$HUI.tabs("#RentTabs",{
		onSelect:function(title)
		{
			//Modify by zx 2020-05-21 BUG ZX0089
			if (title=="调配待提交")
			{
				initUnSubmitRentList();
			}
			else if (title=="调配待办")
			{
				$('#tRentDoList').datagrid('reload'); 
			}
		}
	});
	
}

function initUnSubmitRentList()
{
	$HUI.datagrid("#tUnSubmitRentList",{
	url:$URL,
	queryParams:{
		ClassName:"web.DHCEQ.RM.BUSRent",
    	QueryName:"GetRentList",
		RequestLocDR:"",
		FromLocDR:"",
		ItemDR:"",
		BeginDate:"",
		EndDate:"",
		RequestNo:"",
		StatusDR:"0",
		CurUser:curUserID
	},
    fit:true,
    singleSelect:false,
    rownumbers: true,
    columns:rentListColumns,	//modified by csj 2020-02-10 待提交申请单输出列
	pagination:true,
	pageSize:15,
	pageNumber:1,
	pageList:[15,30,45,60,75]
});
}

function reloadDataGrid()
{
	$('#tRentDoList').datagrid('reload'); 
}

function reloadUnSubmitDataGrid()
{
	$('#tUnSubmitRentList').datagrid('reload'); 
}