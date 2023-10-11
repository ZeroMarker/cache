var Columns=getCurColumnsInfo('PLAT.G.DataChangeRequest','','','');

$(function(){
	initDocument();
});

function initDocument()
{
   	defindTitleStyle();
    initButton(); 
    initButtonWidth();
    initBussType();
    initStatusData();
	initDataChangeRequestGrid();
	initPanelHeaderStyle();//cjc 2023-01-17 ��ʼ�����������ʽ
}

function initDataChangeRequestGrid()
{
	$HUI.datagrid("#DHCEQDataChangeRequest",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.Plat.LIBDataChangeRequest",
	        QueryName:"GetDataChangeRequest",
	        BussType:getElementValue("BussType"),
	        BussNo:getElementValue("BussNo"),
			Status:getElementValue("Status")
		},
		rownumbers: true, 
		singleSelect:true,
		fit:true,
		striped : true,
	    cache: false,
		fitColumns:true,
		columns:Columns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,75,100],
		onLoadSuccess:function(){
			//
		},
		onDblClickRow:function(rowIndex, rowData)
		{
			//
		}
	});
}
///modified by ZY0256  20210301
function initBussType()
{
	$HUI.combobox('#BussType',{
		valueField:'busscode',
		textField:'text',
		panelHeight:"auto",
		data:[{
			busscode: '21',
			text: '���'
		},{
			busscode: '11',
			text: '����'
		},{
			busscode: '94',
			text: '��ͬ'
		}]
	});
}

function initStatusData()
{
	var Status = $HUI.combobox('#Status',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '',
				text: 'ȫ��'
			},{
				id: '0',
				text: '����'
			},{
				id: '1',
				text: '�ύ'
			},{
				id: '2',
				text: '���'
			}]
	});
}

function BFind_Clicked()
{
	$HUI.datagrid("#DHCEQDataChangeRequest",{
	    url:$URL, 
	    queryParams:{
		    ClassName:"web.DHCEQ.Plat.LIBDataChangeRequest",
	       	QueryName:"GetDataChangeRequest",
	        BussType:getElementValue("BussType"),
	        BussNo:getElementValue("BussNo"),
			Status:getElementValue("Status")
		}
	});
}

function bussmodifydetail(index)
{
	var curRowObj=$('#DHCEQDataChangeRequest').datagrid('getRows')[index];
	var BussType=curRowObj.TBussType;
	var BussID=curRowObj.TBussID;
	var DCRRowID=curRowObj.TDCRRowID;
	var TableName=curRowObj.TTableName;
	var WaitAD=getElementValue("WaitAD");
	var Type=getElementValue("Type");
	if (BussType==21)
	{
		if (TableName=="DHC_EQInStock")
		{
			var url="dhceq.plat.busmodify.csp?BussType="+BussType+"&BussID="+BussID+"&DCRRowID="+DCRRowID+"&WaitAD="+WaitAD+"&Type="+Type;
			showWindow(url,"��ⵥ�޸�","","12row","icon-w-paper","modal","","","small"); 
		}
		else
		{
			var url="dhceq.plat.businessmodifylist.csp?BussType="+BussType+"&BussID="+BussID+"&DCRRowID="+DCRRowID+"&WaitAD="+WaitAD+"&Type="+Type;
			showWindow(url,"�����ϸ�޸�","","13row","icon-w-paper","modal","","","middle"); 
		}
	}
	///modified by ZY0256  20210301
	else if (BussType==11)
	{
		var url="dhceq.plat.opencheckmodify.csp?BussType="+BussType+"&BussID="+BussID+"&DCRRowID="+DCRRowID+"&WaitAD="+WaitAD+"&Type="+Type;
		showWindow(url,"���յ��޸�","","","icon-w-paper","modal","","","large"); 
	}
	///modified by ZY0256  20210301
	else if (BussType==94)
	{
		if (TableName=="DHC_EQContract")
		{
			var url="dhceq.plat.modifycontract.csp?BussType="+BussType+"&BussID="+BussID+"&DCRRowID="+DCRRowID+"&WaitAD="+WaitAD+"&Type="+Type;
			showWindow(url,"��ͬ�����޸�","","12row","icon-w-paper","modal","","","small"); 
		}
		else
		{
			var url="dhceq.plat.modifycontractlist.csp?BussType="+BussType+"&BussID="+BussID+"&DCRRowID="+DCRRowID+"&WaitAD="+WaitAD+"&Type="+Type;
			showWindow(url,"��ͬ��ϸ�޸�","","13row","icon-w-paper","modal","","","middle"); 
		}
	}
}


