/**
 * ����:	 ҩ��V3 - ���ҿ�����ε���
 * ��д��:	 pushuangcai
 * ��д����: 2022-03-15
 * ���ַ�ʽ����1����incib��ѯ����������ʾ���ҿ������
 * 			 ��2����incil��ѯ����������ʾ���ҿ������
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
 * ���ҿ�����α��
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
    		title: '����', 
    		align: 'left', 
    		width: 150 
    	}, { 
    		field: 'batNo', 
    		title: '����', 
    		align: 'left', 
    		width: 150 
    }]]
	var columns = [[{ 
    		field: 'expDate', 
    		title: 'Ч��', 
    		align: 'center', 
    		width: 100,
			styler: QUE_COM.Grid.Styler.ExpDate,
			formatter: QUE_COM.Grid.Formatter.ExpDate()
    	}, { 
    		field: 'qtyWithUom', 
    		title: '���', 
    		align: 'right', 
    		width: 100 
    	}, { 
    		field: 'avaQtyWithUom', 
    		title: '����', 
    		align: 'right', 
    		width: 100 
    	}, { 
    		field: 'TBRp', 
    		title: '����(����)', 
    		align: 'right', 
    		width: 100 
    	}, { 
    		field: 'TBSp', 
    		title: '�ۼ�(����)', 
    		align: 'right', 
    		width: 100 
    	}, { 
    		field: 'TPRp', 
    		title: '����(���)', 
    		align: 'right', 
    		width: 100 
    	}, { 
    		field: 'TPSp', 
    		title: '�ۼ�(���)', 
    		align: 'right', 
    		width: 100 
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
    		field: 'vendorName', 
    		title: '��Ӫ��ҵ', 
    		align: 'left', 
    		width: 300 
    	}, { 
    		field: 'manfName', 
    		title: '������ҵ', 
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