var Columns=getCurColumnsInfo('PLAT.G.CheckResult.List','','','')
$(function(){
	initDocument();	
});
function initDocument()
{
    initDataGrid();	//��ʼ��datagrid
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
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
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
