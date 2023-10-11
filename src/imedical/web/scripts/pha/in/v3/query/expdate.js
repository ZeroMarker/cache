/**
 * ����:	 Ч�ڱ�������ѯ
 * ��д��:	 pushuangcai
 * ��д����: 2022-04-26
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v3.query.expdate.csp';
PHA_COM.App.Name = $g('Ч�ڱ���');
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
	
	InitGridIncItmLcBt();
	InitGridIncItmLcBtExpired();
	
	InitDefVal();
	InitEvents();
	PHA_COM.SetPanel($('#gridIncItmLcBt').datagrid('getPanel'), "Ч�ڱ���");

	setTimeout(function(){Query()}, 500);
})

function Query(){
	var pJson = GetParams();
	if (pJson === null){
		return;	
	}
	var selTabIndex = $('#expTabs').tabs('getTabIndex', $('#expTabs').tabs('getSelected'));
	if (selTabIndex == 0){
		var nearlyPJson = _.cloneDeep(pJson);
		// ��Ч��
		nearlyPJson.expRangeType = "DAY";
		nearlyPJson.expRangeSt = 0;
		nearlyPJson.expRangeEd = ParamProp.ExpDateWarnDays;
		$('#gridIncItmLcBtNearlyExp').datagrid('loading');
		PHA.CM({
				pClassName: 'PHA.IN.Query.Api',
				pMethodName: 'ExpDateDetail',
				pJsonStr: JSON.stringify(nearlyPJson)
			},function(data){
				$('#gridIncItmLcBtNearlyExp').datagrid('loadData', data);
			}
		);
	} else if (selTabIndex == 1){
		// �ѹ���
		var expiredPJson = _.cloneDeep(pJson);
		expiredPJson.expiredFlag = "Y";
		$('#gridIncItmLcBtExpired').datagrid('loading');
		PHA.CM({
				pClassName: 'PHA.IN.Query.Api',
				pMethodName: 'ExpDateDetail',
				pJsonStr: JSON.stringify(expiredPJson)
			},function(data){
				$('#gridIncItmLcBtExpired').datagrid('loadData', data);
			}
		);
	} else{
		var expRangeSt = parseInt(pJson.expRangeSt);
		var expRangeEd = parseInt(pJson.expRangeEd);
		if (expRangeSt > expRangeEd){
			PHA.Popover({ 
				showType: 'show', 
				msg: 'Ч�ڿ�ʼ��Χ���ܴ��ڽ�ֹ��Χ', 
				type: 'alert' 
			});
			$('#expRangeSt').focus();
			$('#expRangeSt').select();
			return;
		}
		$('#gridIncItmLcBt').datagrid('loading');
		PHA.CM({
				pClassName: 'PHA.IN.Query.Api',
				pMethodName: 'ExpDateDetail',
				pJsonStr: JSON.stringify(pJson)
			},function(data){
				$('#gridIncItmLcBt').datagrid('loadData', data);
			}
		);	
	}
}

/**
 * ҩƷ����
 */
function AddConserve(){
	var checkedRows = $('#gridIncItmLcBt').datagrid('getChecked');
	if (checkedRows.length === 0){
		PHA.Popover({ 
        	showType: 'show', 
        	msg: '�빴ѡ��Ҫ������ҩƷ���Σ�', 
        	type: 'alert' 
        });
		return;
	}
	PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'DrgMgrSave',
	        pJsonStr: JSON.stringify(pJson),
	        dataType: 'text'
	    },function(data){
		    PHA.Ret(data);
	        window.parent.CloseExpBatDilog();
	    }
	);
}

function InitComponent(){
	PHA.ComboBox('expRangeType', {
		valueField: 'id',
		textField: 'text',
		width: 70,
		data: [
			{text:'��', id: 'DAY', selected: true},
        	{text:'��', id: 'MONTH'}
		]
	}); 
	$('#expTabs').tabs({
		onSelect: function(){
			Query();
		}
	});
}

/**
 * ��ȡ�������
 */
function GetParams(){
	var formData = QUE_FORM.GetFormData();
	if (formData === null){
		return null;	
	}
	var incExpFilterArr = PHA.DomData("#incExpFilter", {
		doType: 'query',
		retType: 'Json'
	});	
	var formData = $.extend({}, formData, incExpFilterArr[0]);
	return formData;
}

/**
 * ��ʼ������Ĭ��ֵ
 */
function InitDefVal(){
	$('#endExpDate').datebox('setValue', PHA_UTIL.SysDate("t"));
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
	$HUI.checkbox('#stkActiveFlag').check();
	$HUI.checkbox('#ordActiveFlag').check();
	$('#expRangeSt').numberbox('setValue', 1);
	$('#expRangeEd').numberbox('setValue', ParamProp.ExpDateWarnDays || "");
	$('#expRangeType').combobox('setValue', 'DAY');
}

/**
 * ���¼�
 */
function InitEvents(){
	PHA_EVENT.Bind('#btnFind', 'click', Query);
	PHA_EVENT.Bind('#btnClear', 'click', Clear);
	PHA_EVENT.Bind('#btbtnAddConservenClear', 'click', AddConserve);
	$('#expRangeSt').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $('#expRangeEd').focus();
        }
    });
	$('#expRangeEd').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            Query();
        }
    });
}

/**
 * ��������ʼ��Ĭ��ֵ
 */
function Clear(){
	QUE_FORM.ClearFormData();
	$('#gridIncItmLcBt').datagrid('clear');
	$('#gridIncItmLcBtNearlyExp').datagrid('clear');
	$('#gridIncItmLcBtExpired').datagrid('clear');
	InitDefVal();
}

/**
 * ���ҿ������
 */
function InitGridIncItmLcBt(){
	var columns = [[
		{
			title: "inci",
			field: "inci",
			width: 100,
			hidden: true
		}, {
			title: "incib",
			field: "incib",
			width: 100,
			hidden: true
		}, {
			title: "inclb",
			field: "inclb",
			width: 100,
			hidden: true
		}, {
			title: "ʣ��Ч��(��)",
			field: "expMonths",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "ʣ��Ч��(��)",
			field: "expDays",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "ҩƷ���",
			field: "inciSpec",
			width: 100
		}, {
			title: "������λ",
			field: "bUomDesc",
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: "��ⵥλ",
			field: "pUomDesc",
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: "pUomId",
			field: "pUomId",
			width: 100,
			hidden: true
		}, {
			title: "���(����)",
			field: "bQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "���(���)",
			field: "pQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "���(��λ)",
			field: "qtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "����������",
			field: "lastMIntrQtyWithUom",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "����������",
			field: "thisMIntrQtyWithUom",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "����������",
			field: "lastDIntrQtyWithUom",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "����������",
			field: "toDIntrQtyWithUom",
			width: 100,
			align: 'right',
			hidden: false
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
			title: "bUomId",
			field: "bUomId",
			width: 100,
			hidden: true
		}, {
			title: "����(���)",
			field: "TPRp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "�ۼ�(���)",
			field: "TPSp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "����(����)",
			field: "TBRp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "�ۼ�(����)",
			field: "TBSp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "���۽��",
			field: "TRpAmt",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "�ۼ۽��",
			field: "TSpAmt",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "��λ",
			field: "stkBin",
			width: 100
		}, { 
			field: 'manfName', 	
			title: '������ҵ',
			align: 'left', 
			width: 150 
		}, { 
			field: 'vendorName', 	
			title: '��Ӫ��ҵ',
			align: 'left', 
			width: 150 
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
		{	field:'ck', title:'sel', checkbox:true
		}, {
			title: "״̬",
			field: "expState",
			width: 80,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.ExpState()
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
			title: "����",
			field: "batNo",
			width: 100
		}, {
			title: "Ч��",
			field: "expDate",
			width: 100,
			align: 'center',
			hidden: false,
			formatter: QUE_COM.Grid.Formatter.ExpDate()
		}
	]]
	var dataGridOption = {
		url: "",	
		fitColumns: false,
		border: false,
		headerCls: 'panel-header-gray',
		toolbar: '#gridIncItmLcBtTool',
		rownumbers: true,
		columns: columns,
		frozenColumns: frozenColumns,
		pagination: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		showFooter: true,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		fixRowNumber: true,
		exportXls: false,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		}
	};
	// Ч�ڲ�ѯ
	PHA.Grid('gridIncItmLcBt', dataGridOption);
    QUE_COM.ComGridEvent("gridIncItmLcBt");
	// ��Ч��
	delete dataGridOption.toolbar;
	PHA.Grid('gridIncItmLcBtNearlyExp', dataGridOption);
    QUE_COM.ComGridEvent("gridIncItmLcBtNearlyExp");
	// ҩƷ������ѡ
	if (conserveFlag){
		$('#gridIncItmLcBt').datagrid('showColumn', "ck");
		$('#gridIncItmLcBtNearlyExp').datagrid('showColumn', "ck")
	} else {
		$('#gridIncItmLcBt').datagrid('hideColumn', "ck");
		$('#gridIncItmLcBtNearlyExp').datagrid('hideColumn', "ck");
	}
	
}

/**
 * ���ҿ������
 */
function InitGridIncItmLcBtExpired(){
	var columns = [[
		{
			title: "inci",
			field: "inci",
			width: 100,
			hidden: true
		}, {
			title: "incib",
			field: "incib",
			width: 100,
			hidden: true
		}, {
			title: "inclb",
			field: "inclb",
			width: 100,
			hidden: true
		}, {
			title: "ҩƷ���",
			field: "inciSpec",
			width: 100
		}, {
			title: "������λ",
			field: "bUomDesc",
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: "��ⵥλ",
			field: "pUomDesc",
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: "pUomId",
			field: "pUomId",
			width: 100,
			hidden: true
		}, {
			title: "���(����)",
			field: "bQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "���(���)",
			field: "pQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "���(��λ)",
			field: "qtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "bUomId",
			field: "bUomId",
			width: 100,
			hidden: true
		}, {
			title: "����(���)",
			field: "TPRp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "�ۼ�(���)",
			field: "TPSp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "����(����)",
			field: "TBRp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "�ۼ�(����)",
			field: "TBSp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "���۽��",
			field: "TRpAmt",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "�ۼ۽��",
			field: "TSpAmt",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "��λ",
			field: "stkBin",
			width: 100
		}, { 
			field: 'manfName', 	
			title: '������ҵ',
			align: 'left', 
			width: 150 
		}, { 
			field: 'vendorName', 	
			title: '��Ӫ��ҵ',
			align: 'left', 
			width: 150 
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
			title: "״̬",
			field: "expState",
			width: 80,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.ExpState()
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
			title: "����",
			field: "batNo",
			width: 100
		}, {
			title: "Ч��",
			field: "expDate",
			width: 100,
			align: 'center',
			hidden: false,
			formatter: QUE_COM.Grid.Formatter.ExpDate()
		}
	]]
	var dataGridOption = {
		url: "",	
		fitColumns: false,
		border: false,
		headerCls: 'panel-header-gray',
		rownumbers: true,
		columns: columns,
		frozenColumns: frozenColumns,
		pagination: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		showFooter: true,
		loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		fixRowNumber: true,
		exportXls: false,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		}
	};
	PHA.Grid('gridIncItmLcBtExpired', dataGridOption);
    QUE_COM.ComGridEvent("gridIncItmLcBtExpired");
}