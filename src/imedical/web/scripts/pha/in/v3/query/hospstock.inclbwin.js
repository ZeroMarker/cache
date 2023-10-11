/**
 * 名称:	 药库V3 - 科室库存批次弹窗
 * 编写人:	 pushuangcai
 * 编写日期: 2022-03-15
 * 两种方式：（1）按incib查询，按批次显示科室库存批次
 * 			 （2）按incil查询，按科室显示科室库存批次
 */
PHA_COM.VAR.BtWin = {
	incil: '',
	inclb: '',
	opType: '',
};
function OpenInclbWindow(wParam){
	$('#inclbWin').window({
		title: wParam.title
	});
	PHA_COM.VAR.BtWin = wParam;
	$('#inclbWin').window('open');
	$('#inclbWin').window('center');
	QueryInclb();
} 

function InitInclbWin(){
	$('#inclbWin').window({
		width: $(this).width() * 0.9,
		height: $(this).height() * 0.9
	});	
	InitGridIncLocBat();
	$HUI.checkbox('#EmptyFlag', {
		onCheckChange: function(){
			QueryInclb();
		}
	});
}

function QueryInclb(){	
	var formData = QUE_FORM.GetFormData();
	if (formData === null){
		return;	
	}
	formData.queryBy = PHA_COM.VAR.BtWin.queryBy;
	formData.hosp = PHA_COM.VAR.hospId;

	if ($HUI.checkbox('#EmptyFlag').getValue()){
		formData.batFlag = "NotEmpty";	
	};
	
	var $grid = $('#gridIncLocBat');
	if (PHA_COM.VAR.BtWin.queryBy === "Bat"){
		formData.incib = PHA_COM.VAR.BtWin.incib;	
		$grid.datagrid('showColumn', 'locDesc');
		$grid.datagrid('hideColumn', 'batNo');
	} else if (PHA_COM.VAR.BtWin.queryBy === "Loc"){
		formData.incil = PHA_COM.VAR.BtWin.incil;	
		$grid.datagrid('showColumn', 'batNo');
		$grid.datagrid('hideColumn', 'locDesc');
	}
	$grid.datagrid('options').url = PHA.$URL;
	$grid.datagrid('query', {
		pJsonStr: JSON.stringify(formData)
	});
}

/**
 * 科室库存批次表格
 */
function InitGridIncLocBat(){
	var frozenColumns = [[{ 
	    	field: 'inclb', 
	    	title: 'Inclb', 
	    	align: 'center', 
	    	width: 100, 
	    	hidden: true 
    	}, { 
    		field: 'locDesc', 
    		title: '科室', 
    		align: 'left', 
    		width: 150 
    	}, { 
    		field: 'batNo', 
    		title: '批号', 
    		align: 'left', 
    		width: 150 
    }]]
	var columns = [[{ 
    		field: 'expDate', 
    		title: '效期', 
    		align: 'center', 
    		width: 100,
			styler: QUE_COM.Grid.Styler.ExpDate,
			formatter: QUE_COM.Grid.Formatter.ExpDate()
    	}, { 
    		field: 'qtyWithUom', 
    		title: '库存', 
    		align: 'right', 
    		width: 100 
    	}, { 
    		field: 'avaQtyWithUom', 
    		title: '可用', 
    		align: 'right', 
    		width: 100 
    	}, { 
    		field: 'TBRp', 
    		title: '进价(基本)', 
    		align: 'right', 
    		width: 100 
    	}, { 
    		field: 'TBSp', 
    		title: '售价(基本)', 
    		align: 'right', 
    		width: 100 
    	}, { 
    		field: 'TPRp', 
    		title: '进价(入库)', 
    		align: 'right', 
    		width: 100 
    	}, { 
    		field: 'TPSp', 
    		title: '售价(入库)', 
    		align: 'right', 
    		width: 100 
    	}, {
			title: "进价金额",
			field: "TRpAmt",
			width: 120,
			align: 'right'
		}, {
			title: "售价金额",
			field: "TSpAmt",
			width: 120,
			align: 'right'
		}, { 
    		field: 'vendorName', 
    		title: '经营企业', 
    		align: 'left', 
    		width: 300 
    	}, { 
    		field: 'manfName', 
    		title: '生产企业', 
    		align: 'left', 
    		width: 300 
    	}]
    ];
	var dataGridOption = {
		url: "",
		queryParams: {
			pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'LocItmBatStk'
		},
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		bodyCls: 'panel-body-gray',
		exportXls: false,
		nowrap: false,
		fitColumns: false,
		toolbar: '#gridIncLocBatTool',
		border: true,
		rownumbers: false,
		showFooter: true,
		columns: columns,
		frozenColumns: frozenColumns,
		pagination: true,
		singleSelect: true
	};
	PHA.Grid('gridIncLocBat', dataGridOption);
}