/**
 * ����: ��汨�����������ޣ�
 * ����: pushuangcai
 * ����: 2022-04-29
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v3.query.stkwarnbylimit.csp';
PHA_COM.App.Name = $g('��汨��');
PHA_COM.App.AppName = 'DHCSTLOCSTKMOVE';
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
	QUE_FORM.InitComponents(); 		// ������� component.js

	InitGridIncItmLoc();
	
	InitEvents();
	PHA_COM.SetPanel($('#gridIncItmLoc').datagrid('getPanel'), "��汨��(��������)");
	InitDefVal();
	
	setTimeout(function(){Query()}, 500);
})

/**
 * ��ѯ
 */
function Query(){
	var pJson = GetParams();
	if (pJson === null){
		return;	
	}
	$('#gridIncItmLoc').datagrid('loading');
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'StkWarnByLimit',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
	        $('#gridIncItmLoc').datagrid('loadData', data);
	    }
	);
}

/**
 * ��ȡ�������
 */
function GetParams(){
	return QUE_FORM.GetFormData();
}

/**
 * ��ʼ������Ĭ��ֵ
 */
function InitDefVal(){
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate("t"));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate("t"));
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
	if (gLowStock == "Y"){
		$HUI.checkbox('#lessFlag').check();
	} else{
		$HUI.checkbox('#lessFlag').uncheck();
	}
	if (gHighStock == "Y"){
		$HUI.checkbox('#moreFlag').check();
	} else{
		$HUI.checkbox('#moreFlag').uncheck();
	}	
}

/**
 * ���¼�
 */
function InitEvents(){
	PHA_EVENT.Bind('#btnFind', 'click', Query);
	PHA_EVENT.Bind('#btnClear', 'click', Clear);
}

/**
 * ��������ʼ��Ĭ��ֵ
 */
function Clear(){
	$('#gridIncItmLoc').datagrid('clear');
	QUE_FORM.ClearFormData();	
	InitDefVal();	
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
		},{
			title: "incil",
			field: "incil",
			width: 100,
			hidden: true
		}, {
			title: "bUomId",
			field: "bUomId",
			width: 100,
			hidden: true
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
			title: "�������",
			field: "maxQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "�������",
			field: "minQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "��׼���",
			field: "repQtyWithUom",
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
			title: "����(���)",
			field: "pRp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "�ۼ�(���)",
			field: "pSp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "����(����)",
			field: "bRp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "�ۼ�(����)",
			field: "bSp",
			width: 90,
			align: 'right',
			hidden: true
		}, {
			title: "���۽��",
			field: "rpAmt",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			title: "�ۼ۽��",
			field: "spAmt",
			width: 100,
			align: 'right',
			hidden: false
		}, {
			field: 'avaQtyWithUom',
			title: '���ÿ��',
			width: 150,
			hidden: false,
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
			width: 150
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
			title: "״̬",
			field: "stkState",
			width: 80,
			align: 'center',
			formatter: QUE_COM.Grid.Formatter.StkLimitState()
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
		nowrap: false,
		fitColumns: false,
		border: true,
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
		fixRowNumber: true,
		onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
		}
	};
	PHA.Grid('gridIncItmLoc', dataGridOption);
	
	QUE_COM.ComGridEvent("gridIncItmLoc");
}