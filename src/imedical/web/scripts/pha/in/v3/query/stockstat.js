/**
 * ����:	 ���ͳ��
 * ��д��:	 pushuangcai
 * ��д����: 2022-03-28
 */
 
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v3.query.stockstat.csp';
PHA_COM.App.Name = $g('���ͳ��');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = false;
PHA_COM.VAR = {
	hospId: session['LOGON.HOSPID'],
	groupId: session['LOGON.GROUPID'],
	userId: session['LOGON.USERID'],
	locId: session['LOGON.CTLOCID'],
	batGridType: 'group'
};

$(function(){
	InitComponent();				// ҳ�����
	QUE_FORM.InitComponents(); 		// ������� component.js
		
	InitGridIncItmLoc();
	InitGridIncItmLcBtAll();
	InitGridIncItmLocSimple();
	InitGridIncItmLcBt();
	PHA_COM.SetPanel('#tabMain', "���ͳ��");
	
	InitEvents();
	InitDefVal();
})

/**
 * ��ѯ
 */
function Query(){
	var pJson = GetParams();	
	if (pJson === null){
		return;	
	}
	var $selTabs = $('#mainTabs').tabs('getSelected');
	var selIndex = $('#mainTabs').tabs('getTabIndex', $selTabs);

	if (selIndex === 0){		
		$('#gridIncItmLoc').datagrid('loading');
	    PHA.CM({
			    pClassName: 'PHA.IN.Query.Api',
				pMethodName: 'LocItmStat',
		        pJsonStr: JSON.stringify(pJson)
		    },function(data){
		        $('#gridIncItmLoc').datagrid('loadData', data);
		    }
		);
	} else if (selIndex === 1){
		if ($HUI.checkbox('#NotEmptyFlag').getValue()){
			pJson.batFlag = "NotEmpty";	
		};
		$('#gridIncItmLcBtAll').datagrid('options').url = PHA.$URL;
		$('#gridIncItmLcBtAll').datagrid('query', {
			pJsonStr: JSON.stringify(pJson)
		});
	} else if (selIndex === 2){
		$('#gridIncItmLocSimple').datagrid('loading');
	    PHA.CM({
			    pClassName: 'PHA.IN.Query.Api',
				pMethodName: 'LocItmStat',
		        pJsonStr: JSON.stringify(pJson)
		    },function(data){
		        $('#gridIncItmLocSimple').datagrid('loadData', data);
		    }
		);
	}
}

/**
 * ��ѯ����
 */
function QueryBat(){
	var selectedRow = $('#gridIncItmLocSimple').datagrid('getSelected');
	if (!selectedRow){
		return;	
	}
	var pJson = GetParams();
	if (pJson === null){
		return;	
	}
	pJson.incil = selectedRow.incil;

	var tab = $('#lcBtTabs').tabs('getSelected');
	var index = $('#lcBtTabs').tabs('getTabIndex', tab);
	var $btGrid = "";
	if (index === 1){
		$btGrid = $('#gridIncItmLcBtNotEmpty');
		pJson.batFlag = "NotEmpty";
	} else if (index === 2){
		$btGrid = $('#gridIncItmLcBtEmpty');
		pJson.batFlag = "Empty";
	} else if (index === 3){
		$btGrid = $('#gridIncItmLcBt');
	}
	
	$btGrid.datagrid('loading');
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'IncItmLcBatPorxy',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
	        $btGrid.datagrid('loadData', data);
	    }
	);
}

/**
 * ����
 */
function GetParams(){
	var formData = QUE_FORM.GetFormData();
	var kwArr = $('#btFilterKw').keywords('getSelected');
	for(var i = 0; i < kwArr.length; i++){
		formData[kwArr[i].id] = true;	
	}
	return formData;
}

/**
 * ��������ʼ��Ĭ��ֵ
 */
function Clear(){
	QUE_FORM.ClearFormData();
	$('#gridIncItmLoc').datagrid('clear');
	$('#gridIncItmLcBtAll').datagrid('clear');	
	$('#gridIncItmLocSimple').datagrid('clear');	
	$('#gridIncItmLcBtNotEmpty').datagrid('clear');	
	$('#gridIncItmLcBtEmpty').datagrid('clear');	
	$('#gridIncItmLcBt').datagrid('clear');	
	InitDefVal();	
}

/**
 * ���¼�
 */
function InitEvents(){
	PHA_EVENT.Bind('#btnFind', 'click', Query);
	PHA_EVENT.Bind('#btnClear', 'click', Clear);
	$('#lcBtTabs').tabs({
		onSelect: function(title, index){
			QueryBat();
		}
	});	
}

/**
 * ��ʼ���������
 */
function InitComponent(){
	$('#btFilterKw').keywords({
        onClick:function(v){
	        QueryBat();
	    },
	    singleSelect: false,
        items:[
        	{text: '������', 		id: "stkActiveFlag" , 		selected: false},
        	{text: 'ҽ������', 		id: "ordActiveFlag" , 		selected: false}
        ]
	});	
}

/**
 * ��ʼ������Ĭ��ֵ
 */
function InitDefVal(){
	$('#date').datebox('setValue', PHA_UTIL.SysDate("t"));
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
}

/**
 * ���ҿ������
 */
function InitGridIncItmLoc(){
	var columns = [[
		{
			title: "inci",
			field: "inci",
			width: 100,
			hidden: true
		}, {
			title: "pUomId",
			field: "pUomId",
			width: 100,
			hidden: true
		}, {
			title: "���(���)",
			field: "pQty",
			width: 90,
			align: 'right'
		}, {
			title: "��ⵥλ",
			field: "pUomDesc",
			width: 80,
			align: 'left'
		}, {
			title: "bUomId",
			field: "bUomId",
			width: 100,
			hidden: true
		}, {
			title: "���(����)",
			field: "bQty",
			width: 90,
			align: 'right'
		}, {
			title: "������λ",
			field: "bUomDesc",
			width: 80,
			align: 'left'
		}, {
			field: 'avaQtyWithUom',
			title: '���ÿ��',
			width: 150,
			hidden: false,
			align: 'right'
		}, {
			title: "����(���)",
			field: "TPRp",
			width: 90,
			align: 'right'
		}, {
			title: "�ۼ�(���)",
			field: "TPSp",
			width: 90,
			align: 'right'
		}, {
			title: "����(����)",
			field: "TBRp",
			width: 90,
			align: 'right'
		}, {
			title: "�ۼ�(����)",
			field: "TBSp",
			width: 90,
			align: 'right'
		}, {
			title: "���۽��",
			field: "TRpAmt",
			width: 120,
			align: 'right'
		}, {
			title: "�ۼ۽��",
			field: "TSpAmt",
			width: 120,
			align: 'right'
		}, {
			title: "��λ",
			field: "stkBin",
			width: 100
		}, {
			title: "����",
			field: "phcFormDesc",
			width: 100
		}, {
			title: "��Ʒ��",
			field: "goodName",
			width: 130
		}, {
			title: "����ͨ����",
			field: "geneName",
			width: 130
		}, {
			title: "������",
			field: "notUseFlag",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
		}, {
			title: "����ҩ",
			field: "highPrice",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
		}, {
			title: "����ҽ������",
			field: "insuCode",
			width: 100
		}, {
			title: "����ҽ������",
			field: "insuName",
			width: 100
		}
	]];
	var frozenColumns = [[
		{
			title: "ҩƷ����",
			field: "inciCode",
			width: 120,
			formatter: QUE_COM.Grid.Formatter.InciCode()
		}, {
			title: "ҩƷ����",
			field: "inciDesc",
			width: 200
		}, {
			title: "ҩƷ���",
			field: "inciSpec",
			width: 100
		}
	]]
	var dataGridOption = {
		url: "",	
		nowrap: false,
		fitColumns: false,
		border: false,
		rownumbers: true,
		columns: columns,
		frozenColumns: frozenColumns,
		pagination: true,
		singleSelect: true,
		showFooter: true,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		fixRowNumber: true,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		}
	};
	PHA.Grid('gridIncItmLoc', dataGridOption);
	
    QUE_COM.ComGridEvent("gridIncItmLoc");
}

/**
 * ������ϸ���
 */
function InitGridIncItmLcBtAll(){
	var frozenColumns = [[
		{
			title: "inci",
			field: "inci",
			width: 100,
			hidden: true
		}, {
			title: "inclb",
			field: "inclb",
			width: 100,
			hidden: true
		}, {
			title: "incib",
			field: "incib",
			width: 100,
			hidden: true
		}, {
			title: "ҩƷ����",
			field: "inciCode",
			width: 120,
			formatter: QUE_COM.Grid.Formatter.InciCode(),
			hidden: true
		}, {
			title: "ҩƷ����",
			field: "inciDesc",
			width: 200,
			hidden: true
		}, {
			title: "����",
			field: "batNo",
			width: 110,
		}
	]];
	var columns = [[
		{
			title: "Ч��",
			field: "expDate",
			align: 'center',
			width: 100,
			styler: QUE_COM.Grid.Styler.ExpDate,
			formatter: QUE_COM.Grid.Formatter.ExpDate()
		}, {
			title: "���(���)",
			field: "pQty",
			width: 100,
			align: 'right'
		}, {
			title: "��ⵥλ",
			field: "pUomDesc",
			width: 70,
			align: 'left'
		}, {
			title: "���(����)",
			field: "bQty",
			width: 100,
			align: 'right'
		}, {
			title: "������λ",
			field: "bUomDesc",
			width: 80,
			align: 'left'
		}, {
			field: 'avaQtyWithUom',
			title: '���ÿ��',
			width: 150,
			hidden: false,
			align: 'right'
		}, {
			title: "����(����)",
			field: "TBRp",
			width: 90,
			align: 'right'
		}, {
			title: "�ۼ�(����)",
			field: "TBSp",
			width: 90,
			align: 'right'
		}, {
			title: "����(���)",
			field: "TPRp",
			width: 90,
			align: 'right'
		}, {
			title: "�ۼ�(���)",
			field: "TPSp",
			width: 90,
			align: 'right'
		}, {
			title: "���۽��",
			field: "TRpAmt",
			width: 120,
			align: 'right'
		}, {
			title: "�ۼ۽��",
			field: "TSpAmt",
			width: 120,
			align: 'right'
		}, {
			title: "������ҵ",
			field: "manfName",
			width: 180
		}, {
			title: "��Ӫ��ҵ",
			field: "vendorName",
			width: 180
		}, {
			title: "��λ",
			field: "stkBin",
			width: 120,
			hidden: true
		}, {
			title: "������",
			field: "lastIngrDate",
			width: 100,
			align: 'center'
		}, {
			title: "ҽ������",
			field: "ordActive",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
		}, {
			title: "������",
			field: "stkActive",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
		}
	]]
	var dataGridOption = {
		url: "",
		queryParams: {
			pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'LocItmBatStat'
		},	
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		nowrap: false,
		fitColumns: false,
		border: false,
		toolbar: '#gridIncItmLcBtAllTool',
		rownumbers: true,
		fixRowNumber: true,
		columns: columns,
		showFooter: true,
		frozenColumns: frozenColumns,
        pageNumber: 1,
		pagination: true,
		singleSelect: true,
		groupField: 'inci',
        view: groupview,
        groupFormatter: function(value, rows){
			return '' +rows[0].inciDesc +'</b>'
					+ '<font style="font-weight:100;">&ensp; | &ensp;'+ $g('����') + '��' + rows[0].inciCode
					+ '&ensp;|&ensp;'+ $g('���') + '��' + (rows[0].inciSpec || "")
					+ '&ensp;|&ensp;'+ $g('����ͨ����') + '��' + (rows[0].geneName || "")
					+ '&ensp;|&ensp;'+ $g('����') + '��' + (rows[0].phcFormDesc || "")
					+ '&ensp;|&ensp;'+ $g('��λ') + '��' + (rows[0].stkBin || "")
					+ '</font>';
        }
	};
	PHA.Grid('gridIncItmLcBtAll', dataGridOption);
    QUE_COM.ComGridEvent("gridIncItmLcBtAll");
}


/**
 * ���ҿ������
 */
function InitGridIncItmLocSimple(){
	var columns = [[
		{
			title: "inci",
			field: "inci",
			width: 100,
			hidden: true
		}, {
			title: "ҩƷ����",
			field: "inciCode",
			width: 120,
			formatter: QUE_COM.Grid.Formatter.InciCode()
		}, {
			title: "ҩƷ����",
			field: "inciDesc",
			width: 200
		}, {
			title: "ҩƷ���",
			field: "inciSpec",
			width: 100
		}
	]]
	var dataGridOption = {
		url: "",	
		fitColumns: false,
		border: false,
		rownumbers: true,
		columns: columns,
		pagination: true,
		singleSelect: true,
		showFooter: false,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		fixRowNumber: true,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		},
		onSelect: function(){
			QueryBat();
		}
	};
	PHA.Grid('gridIncItmLocSimple', dataGridOption);
	
    QUE_COM.ComGridEvent("gridIncItmLocSimple");
}

/**
 * ������ϸ���
 */
function InitGridIncItmLcBt(){
	var frozenColumns = [[
		{
			title: "inci",
			field: "inci",
			width: 100,
			hidden: true
		}, {
			title: "inclb",
			field: "inclb",
			width: 100,
			hidden: true
		}, {
			title: "incib",
			field: "incib",
			width: 100,
			hidden: true
		}, {
			title: "����",
			field: "batNo",
			width: 110,
		}
	]];
	var columns = [[
		{
			title: "Ч��",
			field: "expDate",
			align: 'center',
			width: 100,
			styler: QUE_COM.Grid.Styler.ExpDate,
			formatter: QUE_COM.Grid.Formatter.ExpDate()
		}, {
			title: "���(���)",
			field: "pQty",
			width: 100,
			align: 'right'
		}, {
			title: "��ⵥλ",
			field: "pUomDesc",
			width: 70,
			align: 'left'
		}, {
			title: "���(����)",
			field: "bQty",
			width: 100,
			align: 'right'
		}, {
			title: "������λ",
			field: "bUomDesc",
			width: 80,
			align: 'left'
		}, {
			field: 'avaQtyWithUom',
			title: '���ÿ��',
			width: 150,
			hidden: false,
			align: 'right'
		}, {
			title: "����(����)",
			field: "TBRp",
			width: 90,
			align: 'right'
		}, {
			title: "�ۼ�(����)",
			field: "TBSp",
			width: 90,
			align: 'right'
		}, {
			title: "����(���)",
			field: "TPRp",
			width: 90,
			align: 'right'
		}, {
			title: "�ۼ�(���)",
			field: "TPSp",
			width: 90,
			align: 'right'
		}, {
			title: "���۽��",
			field: "TRpAmt",
			width: 120,
			align: 'right'
		}, {
			title: "�ۼ۽��",
			field: "TSpAmt",
			width: 120,
			align: 'right'
		}, {
			title: "������ҵ",
			field: "manfName",
			width: 180
		}, {
			title: "��Ӫ��ҵ",
			field: "vendorName",
			width: 180
		}, {
			title: "��λ",
			field: "stkBin",
			width: 100
		}, {
			title: "������",
			field: "lastIngrDate",
			width: 100,
			align: 'center'
		}, {
			title: "ҽ������",
			field: "ordActive",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
		}, {
			title: "������",
			field: "stkActive",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
		}
	]];
	var dataGridOption = {
		url: "",	
		headerCls: 'panel-header-gray',
		nowrap: false,
		fitColumns: false,
		border: false,
		rownumbers: true,
		fixRowNumber: true,
		columns: columns,
		frozenColumns: frozenColumns,
		showFooter: true,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		pagination: true,
		singleSelect: true,
		isCellEdit: true,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		}
	};
	PHA.Grid('gridIncItmLcBt', dataGridOption);
	PHA.Grid('gridIncItmLcBtEmpty', dataGridOption);
	PHA.Grid('gridIncItmLcBtNotEmpty', dataGridOption);	
	
    QUE_COM.ComGridEvent("gridIncItmLcBt");
    QUE_COM.ComGridEvent("gridIncItmLcBtEmpty");
    QUE_COM.ComGridEvent("gridIncItmLcBtNotEmpty");

}