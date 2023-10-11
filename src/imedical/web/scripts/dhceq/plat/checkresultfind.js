var Columns=getCurColumnsInfo('PLAT.G.CheckResult.Find','','','')
$(function(){
	initDocument();	
});
function initDocument()
{
    initUserInfo();	//��ȡ����sessionֵ
    defindTitleStyle();
    initButton(); //��ť��ʼ��
    initButtonWidth();	//��ʼ����ť���
    initDataGrid();	//��ʼ��datagrid
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
	    rownumbers: true,  //���Ϊtrue������ʾһ���к���
	    
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
				text: 'ȫ��'
			},{
				id: '0',
				text: '������'
			},{
				id: '1',
				text: '������'
			}]
	});
}