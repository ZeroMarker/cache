//add by csj 2020-02-09
var columns=getCurColumnsInfo('RM.G.Rent.MaintMap','','','');
$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

function initDocument()
{
	initUserInfo();
	initLookUp();
	defindTitleStyle();
	initButton(); //按钮初始化
	initButtonWidth();
	$HUI.datagrid("#tRentMaintMap",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSShareResource",
			QueryName:"RentMaintMap",
			LocID:curLocID,
			UserID:curUserID
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
	    columns:columns,
		onLoadSuccess:function(data){
			console.log(data)
		},
		pagination:true,
		pageSize:15,
		pageNumber:1,
		pageList:[15,30,45,60,75],
		onSelect:function(rowIndex,rowData){
			//fillData(rowData);
		}
	});
}


function BFind_Clicked()
{
	$HUI.datagrid("#tRentMaintMap",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.RM.BUSShareResource",
			QueryName:"RentMaintMap",
			LocID:curLocID,
			UserID:curUserID
		},
	});
}


function setSelectValue(elementID,item)
{
	setElement(elementID+"DR",item.TRowID)
}
function clearData(elementID)
{
	setElement(elementID+"DR","")
}

