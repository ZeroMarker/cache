/**
 * ����: ����Ʒ����
 * ����: pushuangcai
 * ����: 2022-05-09
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v3.query.sluggish.csp';
PHA_COM.App.Name = $g('����Ʒ����');
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
	InitComponent();
	QUE_FORM.InitComponents(); 		// ������� component.js
	
	InitGridIncItmLoc();
	
	InitDefVal();
	InitEvents();
	PHA_COM.SetPanel($('#gridIncItmLoc').datagrid('getPanel'), "����Ʒ������ѯ");
	
	setTimeout(function(){Query()}, 500);
})

/**
 * ��ѯ̨�˻���
 */
function Query(){
	var pJson = GetParams();
	/*
	if (pJson.intrTypeArr.length === 0){
		PHA.Popover({ 
        	showType: 'show', 
        	msg: '��ѡ��ҵ�����ͣ�', 
        	type: 'alert' 
        });
        return;
	}
	*/
	if (pJson === null){
		return;	
	}
	$('#gridIncItmLoc').datagrid('loading');
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'SluggishGoods',
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
	var formData = QUE_FORM.GetFormData();
	var intrTypeArr = [];
	$('input[name="intrType"]:checked').each(function(k, e){
		var type = e.value
		intrTypeArr.push({
			type: type,
			qty: $("#qty-"+ type).val()
		});
	});
	formData.intrTypeArr = intrTypeArr;
	return formData;
}

/**
 * ��ʼ������Ĭ��ֵ
 */
function InitDefVal(){
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate("t-30"));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate("t"));
	$('#dspDays').numberbox('setValue', 30);
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
}

/**
 * ���¼�
 */
function InitEvents(){
	PHA_EVENT.Bind('#btnFind', 'click', Query);
	PHA_EVENT.Bind('#btnClear', 'click', Clear);
}

function InitComponent(){
	var content = '<div class="pha-row">';
	   content += '<div class="pha-col">' + $g('1������ѡҵ������ʱĬ�ϼ�������ҵ��') + '</div>';
	   content += '</div>';
	   content += '<div class="pha-row">';
	   content += '<div class="pha-col">' + $g('2��ҵ������Ϊ��ʱĬ��Ϊ0') + '</div>';
	   content += '</div>';

	$('#btnHelp').popover({
		title: '������Ϣ', 
		content: content,
		trigger: 'click',
		multi: true,
		width: 500
	});
}

/**
 * ��������ʼ��Ĭ��ֵ
 */
function Clear(){
	QUE_FORM.ClearFormData();
	$('#gridIncItmLoc').datagrid('clear');	
	$HUI.checkbox('#intr-F').check();
	$HUI.checkbox('#intr-P').check();
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
			hidden: true
		}, {
			title: "����������",
			field: "lastIngrDate",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "���ת������",
			field: "lastTDate",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "���ת������",
			field: "lastKDate",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "������﷢ҩ",
			field: "lastFDate",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "���סԺ��ҩ",
			field: "lastPDate",
			width: 120,
			align: 'right',
			hidden: false
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
			width: 60,
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