/**
 * ����: ��涯����ѯ
 * ����: pushuangcai
 * ����: 2022-05-09
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v3.query.buysales.csp';
PHA_COM.App.Name = $g('��涯����ѯ');
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
	InitGridBuySalesDetail();
	
	InitDefVal();
	InitEvents();
	PHA_COM.SetPanel($('#gridIncItmLoc').datagrid('getPanel'), "��涯����ѯ");
})

/**
 * ��ѯ̨�˻���
 */
function Query(){
	var pJson = GetParams();
	if (pJson === null){
		return;	
	}
	$('#gridIncItmLoc').datagrid('loading');
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'LocItmBuyAndSales',
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
	var intrTypeKwArr = $('#intrTypeKw').keywords('getSelected');
	var intrTypeArr = [];
	for(var i = 0; i < intrTypeKwArr.length; i++){
		intrTypeArr.push(intrTypeKwArr[i].id);
	}
	formData.intrTypeStr = intrTypeArr.join("^");
	return formData;
}

/**
 * ��ʼ������Ĭ��ֵ
 */
function InitDefVal(){
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate("t-30"));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate("t"));
	$('#startTime').timespinner('setValue', PHA_UTIL.SysTime("s"));
	$('#endTime').timespinner('setValue', PHA_UTIL.SysTime("l"));
	$('#dspDays').numberbox('setValue', 30);
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
}

/**
 * ���¼�
 */
function InitEvents(){
	PHA_EVENT.Bind('#btnFind', 'click', function () {
        Query();
    });
	PHA_EVENT.Bind('#btnClear', 'click', function () {
        Clear();
    });
}

function InitComponent(){
	$('#operateWin').window({
		title: '��涯����ϸ',
		iconCls: 'icon-w-list',
		closed: true,
		modal: true,
		width: 950,
		height: $(this).height() * 0.65,
		onOpen: function(){
			$(this).window('center');
		},
		onClose: function(){
			PHA_UX.BusiTimeLine({},{}, "close");
		}
	});
}

/**
 * ��������ʼ��Ĭ��ֵ
 */
function Clear(){
	QUE_FORM.ClearFormData();
	$('#gridIncItmLoc').datagrid('clear');	
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
			title: "������",
			field: "inQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false,
			formatter: function(value, rowData){
				if (!value) { return ""; }
				if ($.isEmptyObject(rowData)){ return ""; }
				return '<a class="pha-grid-a js-grid-inQtyWithUom">' + value + '</a>';	
			}
		}, {
			title: "������",
			field: "outQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false,
			formatter: function(value, rowData){
				if (!value) { return ""; }
				if ($.isEmptyObject(rowData)){ return ""; }
				return '<a class="pha-grid-a js-grid-outQtyWithUom">' + value + '</a>';	
			}
		}, {
			title: "����۽��",
			field: "inRpAmt",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "�����۽��",
			field: "outRpAmt",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "���ۼ۽��",
			field: "inSpAmt",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "���ۼ۽��",
			field: "outSpAmt",
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
			hidden: true
		}, {
			title: "�ۼ۽��",
			field: "TSpAmt",
			width: 100,
			align: 'right',
			hidden: true
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

	var eventClassArr = [];
	eventClassArr.push('pha-grid-a js-grid-inQtyWithUom');
	eventClassArr.push('pha-grid-a js-grid-outQtyWithUom');
	
	PHA.GridEvent('gridIncItmLoc', 'click', eventClassArr, function(rowIndex, rowData, className){
		var pJson = GetParams();
		if (className === 'pha-grid-a js-grid-inQtyWithUom'){
			if(rowData.inQtyWithUom == 0){
				return;	
			}
			pJson.intrFlag = "IN";
		} else if (className === 'pha-grid-a js-grid-outQtyWithUom'){
			if(rowData.outQtyWithUom == 0){
				return;	
			}
			pJson.intrFlag = "OUT";
		}
		$('#operateWin').window('setTitle', $g("��涯����ϸ��")+ $g(rowData.inciDesc));
		$('#operateWin').window('open');
		pJson.incil = rowData.incil;
		GetInOutDetail(pJson);
	});	
}

/**
 * ��ѯҵ��������ϸ
 * @params {object} pJson 
 * @params {string} pJson.incil 	���ҿ����id
 * @params {string} pJson.opType 	��ѯ���
 */
function GetInOutDetail(pJson){
	if (pJson === null){
		return;	
	}
	$('#gridBuySalesDetail').datagrid('loading');
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'QueryIntrDetail',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
	        $('#gridBuySalesDetail').datagrid('loadData', data);
	    }
	);
}

/**
 * ��涯����ϸ���
 */
function InitGridBuySalesDetail(){
	var columns = [[
		{ 
    		field: 'intrId',
    		title: 'intrId',
    		align: 'left',
    		width: 100, 
    		hidden: true 
    	}, { 
    		field: 'bizCode',
    		title: 'bizCode', 		
    		hidden: true
		}, { 
    		field: 'typeDesc',
    		title: 'ҵ������', 		
    		align: 'left',	
    		width: 130, 
    		hidden: false
		}, { 
			field: 'date', 		
			title: 'ʱ��', 			
			align: 'left', 	
			width: 160, 
			hidden: false,
            formatter: function(val, row, index){
	            return val +" "+ row.time;
	        }
		}, { 
			field: 'operator', 	
			title: '������', 		
			align: 'left', 	
			width: 120, 
			hidden: false 
		}, { 
			field: 'batNo', 		
			title: '����', 			
			align: 'left', 
			width: 120
		}, { 
			field: 'qtyWithUom', 		
			title: '����(��λ)', 			
			align: 'right', 
			width: 150 
		}, { 
			field: 'pQty', 		
			title: '����(���)', 			
			align: 'right', 
			width: 150,
			hidden: true 
		}, { 
			field: 'pUomDesc', 	
			title: '��ⵥλ', 			
			align: 'left',	
			width: 80,
			hidden: true 
		}, { 
			field: 'bQty', 		
			title: '����(����)', 			
			align: 'right', 
			width: 150,
			hidden: true 
		}, { 
			field: 'bUomDesc', 	
			title: '������λ', 			
			align: 'left',	
			width: 80,
			hidden: true 
		}, { 
			field: 'qty', 		
			title: '����', 			
			align: 'right', 
			width: 150,
			hidden: true 
		}, { 
			field: 'uomDesc', 	
			title: '��λ', 			
			align: 'left',	
			width: 80,
			hidden: true 
		}, { 
			field: 'intrNo', 		
			title: '�����', 		
			align: 'left', 	
			width: 200,
			formatter: QUE_COM.Grid.Formatter.BizNo()
		}
	]];
	var dataGridOption = {
		url: "",	
		nowrap: false,
		fitColumns: false,
		border: true,
		toolbar: null,
		headerCls: 'panel-header-gray',
		bodyCls: 'panel-body-gray',
		rownumbers: true,
		border: true,
		columns: columns,
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
	PHA.Grid('gridBuySalesDetail', dataGridOption);
	QUE_COM.ComGridEvent("gridBuySalesDetail");
}