var Columns=getCurColumnsInfo('PLAT.G.CheckResult.List','','','')
$(function(){
	initDocument();	
});
function initDocument()
{
    initDataGrid();	//初始化datagrid
}

function initDataGrid()
{
	var BuyReqGrid=$HUI.datagrid("#tDHCEQCheckResultList",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Plat.BUSCheckResult",
	        	QueryName:"CheckResultList",
				CRRowID:getElementValue("CRRowID"),
		},
	    border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
        //onClickRow:onClickRow,
	    columns:Columns,
		pagination:true,
		pageSize:20,
		pageNumber:1,
		pageList:[20],
		onLoadSuccess:function(){
			//creatToolbar();
		}
	});
}
