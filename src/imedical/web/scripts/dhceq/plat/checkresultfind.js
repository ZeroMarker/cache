var Columns=getCurColumnsInfo('PLAT.G.CheckResult.Find','','','')
$(function(){
	initDocument();	
});
function initDocument()
{
    initUserInfo();	//获取所有session值
    defindTitleStyle();
    initButton(); //按钮初始化
    initButtonWidth();	//初始化按钮宽度
    initDataGrid();	//初始化datagrid
    initCRSourceTypeData()
}

function initDataGrid()
{
	var BuyReqGrid=$HUI.datagrid("#tDHCEQCheckResultFind",{
		url:$URL,
		queryParams:{
		    	ClassName:"web.DHCEQ.Plat.BUSCheckResult",
	        	QueryName:"CheckResult",
				SourceType:getElementValue("CRSourceType"),
				NameStr:getElementValue("CRSourceName"),
				StrDate:getElementValue("StartDate"),
				EndDate:getElementValue("EndDate"),
		},
	    border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列
	    
        //onClickRow:onClickRow,
	    columns:Columns,
		pagination:true,
		pageSize:12,
		pageNumber:1,
		pageList:[12],
		onLoadSuccess:function(){
			//creatToolbar();
		}
	});
}

function BFind_Clicked()
{
	initDataGrid()
}

function initCRSourceTypeData()
{
	var Status = $HUI.combobox('#CRSourceType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: '全部'
			},{
				id: '0',
				text: '任务结果'
			},{
				id: '1',
				text: '报表结果'
			}]
	});
}