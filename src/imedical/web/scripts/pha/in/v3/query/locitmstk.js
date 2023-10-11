/**
 * ����:	 ����ѯ
 * ��д��:	 pushuangcai
 * ��д����: 2022-04-07
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v3.query.locitmstk.csp';
PHA_COM.App.Name = $g('����ѯ');
PHA_COM.App.AppName = 'DHCSTLOCITMSTK';
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = false;

var ParamProp = PHA_COM.ParamProp(PHA_COM.App.AppName);
PHA_COM.VAR = {
	hospId: session['LOGON.HOSPID'],
	groupId: session['LOGON.GROUPID'],
	userId: session['LOGON.USERID'],
	locId: session['LOGON.CTLOCID']
};

$(function(){
	InitComponent();				// ҳ�����
	QUE_FORM.InitComponents(); 		// ������� component.js
	
	InitGridIncItmLoc();
	InitGridIncItmLcBt();
	
	InitEvents();
	InitDefVal();

	if (gOnlyResFlag == 'Y'){
		setTimeout(function(){Query()}, 500);
	}
})

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
        	{text: 'ҽ������', 		id: "ordActiveFlag" , 		selected: false},
        ]
	});	
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
 * ��ʼ������Ĭ��ֵ
 */
function InitDefVal(){
	$('#date').datebox('setValue', PHA_UTIL.SysDate("t"));
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
	if (gOnlyResFlag == 'Y'){
		$HUI.checkbox('#onlyResFlag').check();
	}
}

/**
 * ��������ʼ��Ĭ��ֵ
 */
function Clear(){
	QUE_FORM.ClearFormData();
	$('#gridIncItmLcBt').datagrid('clear');
	$('#gridIncItmLcBtEmpty').datagrid('clear');
	$('#gridIncItmLcBtNotEmpty').datagrid('clear');
	$('#gridIncItmLoc').datagrid('clear');	
	InitDefVal();	
}

/**
 * ��ѯ���ҿ����
 */
function Query(){
	var pJson = GetParams();
	if (pJson === null){
		return;	
	}
	$('#gridIncItmLoc').datagrid('loading');
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'IncItmLoc',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
	        $('#gridIncItmLoc').datagrid('loadData', data);
	    }
	);
}

/**
 * ��ѯ����
 */
function QueryBat(){
	var selectedRow = $('#gridIncItmLoc').datagrid('getSelected');
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

function GetParams(){
	var formData = QUE_FORM.GetFormData();
	var btKwArr = $('#btFilterKw').keywords('getSelected');
	for(var i = 0; i < btKwArr.length; i++){
		formData[btKwArr[i].id] = true;	
	}
	return formData;
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
			field: 'dirtyQtyWithUom',
			title: 'ռ�ÿ��',
			width: 100,
			hidden: false,
			align: 'right',
			formatter: function(value, rowData){
				if (!value) { return ""; }
				if ($.isEmptyObject(rowData)){ return ""; }
				if ((rowData.inciDesc) && (rowData.inciDesc.indexOf("�ϼ�") > -1)){
					return "";	
				}
				return '<a class="pha-grid-a js-grid-dirtyQtyUom">' + value + '</a>';	
			}
		}, {
			field: 'resQtyWithUom',
			title: '��;��',
			width: 100,
			hidden: false,
			align: 'right',
			formatter: function(value, rowData){
				if (!value) { return ""; }
				if ($.isEmptyObject(rowData)){ return ""; }
				if (value == 0){
					return value;
				}
				if ((rowData.inciDesc) && (rowData.inciDesc.indexOf("�ϼ�") > -1)){
					return "";	
				}
				return '<a class="pha-grid-a js-grid-resQtyWithUom">' + value + '</a>';	
			}
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
			title: "pFac",
			field: "pFac",
			width: 100,
			hidden: true
		}, {
			title: "�������",
			field: "outLockFlag",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
		}, {
			title: "סԺ����",
			field: "inLockFlag",
			width: 70,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.YesOrNo()
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
		}, {
			title: "ҩƷͼ��",
			field: "inciIcon",
			width: 120,
			formatter: PHA_COM.Drug.Icon
		}
	]];
	var frozenColumns = [[
		{
			title: "����",
			field: "operate",
			width: 120,
			align: 'center',
			ifExport: false,
			formatter: function(val, rowData, rowIndex){
				if ($.isEmptyObject(rowData)){ return ""; }
				if ((rowData.inciDesc) && (rowData.inciDesc.indexOf("�ϼ�") > -1)){
					return "";	
				}
				var retArr = [];
				if (ParamProp.TransShow === 'Y'){
					retArr.push('<span class="pha-grid-a icon icon-paper" title="̨����Ϣ��ѯ">&ensp;</span>');
				}
				if (ParamProp.DayTotalShow === 'Y'){
					retArr.push('<span class="pha-grid-a icon icon-paper-eye-r" title="ȫԺ���ҿ��">&ensp;</span>');
				}
				if(ParamProp.ClrResQtyLocInciShow === 'Y'){
					retArr.push('<span class="pha-grid-a icon icon-uncheckin" title="���ҵ�Ʒ��;�����">&ensp;</span>');
				}
				return retArr.join('');
			}
		}, {
			title: "ҩƷ����",
			field: "inciCode",
			width: 120,
			formatter: QUE_COM.Grid.Formatter.InciCode()
		}, {
			title: "ҩƷ����",
			field: "inciDesc",
			width: 300
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
		exportChkCol: true,
		headerCls: 'panel-header-gray',
		toolbar: '#gridIncItmLocTool',
		rownumbers: true,
		columns: columns,
		frozenColumns: frozenColumns,
		pagination: true,
		singleSelect: true,
		showFooter: true,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
        gridSave: true,
		fixRowNumber: true,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
            if (data.total > 0){
	           $(this).datagrid('selectRow', 0); 
	        }
		},
		onSelect: function(rowIndex, rowData){
			QueryBat();
		}
	};
	PHA.Grid('gridIncItmLoc', dataGridOption);

	var eventClassArr = [];
	eventClassArr.push('pha-grid-a js-grid-resQtyWithUom');
	eventClassArr.push('pha-grid-a js-grid-dirtyQtyUom');
	eventClassArr.push('pha-grid-a icon icon-paper');
	eventClassArr.push('pha-grid-a icon icon-paper-eye-r');
	eventClassArr.push('pha-grid-a icon icon-uncheckin');

	PHA.GridEvent('gridIncItmLoc', 'click', eventClassArr, function(rowIndex, rowData, className){
		var opType = "";
		if (className === 'pha-grid-a js-grid-resQtyWithUom') {
			if (rowData.resQtyWithUom == 0){
				return;	
			}
			opType = "resQty"; 
		} else if (className === 'pha-grid-a js-grid-dirtyQtyUom') {
			if (rowData.dirtyQtyUom == 0){
				return;	
			}
			opType = "dirtyQty"; 
		} else if (className === 'pha-grid-a icon icon-paper') {
			opType = "Intr"; 
		} else if (className === 'pha-grid-a icon icon-paper-eye-r') {
			opType = "HospStk"; 
		} else if (className === 'pha-grid-a icon icon-uncheckin'){
			if ((!rowData.resQtyWithUom) || (rowData.resQtyWithUom == 0) || (rowData.resQtyWithUom == "")){
				PHA.Popover({
					msg: '��;��Ϊ0�����������',
					type: 'alert'
				});
				return;	
			}
			PHA.BizPrompt({
			}, function (r) {
				if (typeof r === "undefined"){
					return;
				}
				ClearIncilResQty({incil: rowData.incil}, function(retJson){
					if (retJson.code == 0){		
						PHA_LOG.Operate({
							operate: 'D',
							logInput: JSON.stringify({incil: rowData.incil}),
							type: 'User.DHCIncReservedQtyDetail',
							pointer: '',
							origData: '',
							remarks: '���ҵ�Ʒ��;�����' + (r == '' ? '' : '��'+ r +'��')
						});
						$('#gridIncItmLoc').datagrid('updateRow',{
						    index: parseInt(rowIndex),
						    row: {
						        resQtyWithUom: retJson.data
						    }
						});
						QueryBat();
					}					
				});
			});
			return;
		}else {
			return;
		}
		OpenOperateWin({
			inci: rowData.incil.split("||")[0],
			incil: rowData.incil,
			opType: opType,
			inciDesc: rowData.inciDesc
		});	
	})
	QUE_COM.ComGridEvent("gridIncItmLoc");
}

/**
 * ������ϸ���
 */
function InitGridIncItmLcBt(){
	var frozenColumns = [[
		{
			title: "ҽ����ʾ",
			field: "btTips",
			width: 65,
			ifExport: false,
			hidden: false,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.BtTips()
		},{
			title: "����",
			field: "operate",
			width: 50,
			ifExport: false,
			align: 'center',
			formatter: function(val, rowData, rowIndex){
				if ($.isEmptyObject(rowData)){ return ""; }
				if ((rowData.inciDesc) && (rowData.inciDesc.indexOf("�ϼ�") > -1)){
					return "";	
				}
				var retArr = [];
				if (ParamProp.TransShow === 'Y'){
					retArr.push('<span class="pha-grid-a icon icon-apply-check" title="����̨�˲�ѯ">&ensp;</span>');
				}
				return retArr.join('');
			}
		},{
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
			}, {
				field: 'dirtyQtyWithUom',
				title: 'ռ�ÿ��',
				width: 100,
				hidden: false,
				align: 'right',
				formatter: function(value, rowData){
					if (!value) { return ""; }
					if ($.isEmptyObject(rowData)){ return ""; }
					if ((rowData.inciDesc) && (rowData.inciDesc.indexOf("�ϼ�") > -1)){
						return "";	
					}
					return '<a class="pha-grid-a js-grid-dirtyQtyUom">' + value + '</a>';	
				}
			}, {
				field: 'resQtyWithUom',
				title: '��;��',
				width: 100,
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
				title: "������ҵ",
				field: "manfName",
				width: 250
			}, {
				title: "��Ӫ��ҵ",
				field: "vendorName",
				width: 250
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
				title: "������",
				field: "lastIngrDate",
				width: 100,
				align: 'center'
			}
		]
	];
	var dataGridOption = {
		url: "",	
		headerCls: 'panel-header-gray',
		//nowrap: false,
		fitColumns: false,
		border: false,
		exportChkCol: true,
		rownumbers: true,
		fixRowNumber: true,
		columns: columns,
		frozenColumns: frozenColumns,
		showFooter: false,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		pagination: true,
		singleSelect: true,
		isCellEdit: true,
		gridSave: true,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		}
	};
	PHA.Grid('gridIncItmLcBt', dataGridOption);
	PHA.Grid('gridIncItmLcBtEmpty', dataGridOption);
	PHA.Grid('gridIncItmLcBtNotEmpty', dataGridOption);
	
	var eventClassArr = [];
	eventClassArr.push('pha-grid-a js-grid-dirtyQtyUom');
	eventClassArr.push('pha-grid-a icon icon-apply-check');
	PHA.GridEvent('gridIncItmLcBt', 'click', eventClassArr, BtGridCellClickEvent);
	PHA.GridEvent('gridIncItmLcBtEmpty', 'click', eventClassArr, BtGridCellClickEvent);
	PHA.GridEvent('gridIncItmLcBtNotEmpty', 'click', eventClassArr, BtGridCellClickEvent);
	
	QUE_COM.ComGridEvent("gridIncItmLcBt");
	QUE_COM.ComGridEvent("gridIncItmLcBtEmpty");
	QUE_COM.ComGridEvent("gridIncItmLcBtNotEmpty");
}

/**
 * ���α���е���¼�
 */
function BtGridCellClickEvent(rowIndex, rowData, className){
	var opType = "";
	if (className === 'pha-grid-a js-grid-dirtyQtyUom') {
		opType = "dirtyQty"; 
		if (rowData.dirtyQtyUom == 0){
			return;	
		}
	} else if (className === 'pha-grid-a icon icon-apply-check') {
		opType = "Intr"; 
	} else {
		return;
	}
	OpenOperateWin({
		inci: rowData.inclb.split("||")[0],
		incil: rowData.inclb.split("||")[0] +"||"+ rowData.inclb.split("||")[1],
		inclb: rowData.inclb,
		opType: opType,
		inciDesc: rowData.inciDesc
	});	
}