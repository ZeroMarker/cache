/**
 * ����:	 ̨�˲�ѯ
 * ��д��:	 pushuangcai
 * ��д����: 2022-04-22
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v3.query.intr.csp';
PHA_COM.App.Name = $g('̨�˲�ѯ');
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
	InitIntrDetailGrid();
	
	InitDefVal();
	InitEvents();
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
			pMethodName: 'StockMoveSum',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
		    $('#gridIntrDetail').datagrid('clear');
	        $('#gridIncItmLoc').datagrid('loadData', data);
	    }
	);
}

/**
 * ��ѯҵ��������ϸ
 * @params {string} incil 	���ҿ����id
 */
function QueryIntrDetail(incil){
	var pJson = GetParams();
	pJson.incil = incil;
	$('#gridIntrDetail').datagrid('loading');
	
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'QueryIntrDetail',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
	        $('#gridIntrDetail').datagrid('loadData', data);
	    }
	);
}

/**
 * ��ȡ�������
 */
function GetParams(){
	var formData = QUE_FORM.GetFormData();
	return formData;
}

/**
 * ��ʼ������Ĭ��ֵ
 */
function InitDefVal(){
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate("t"));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate("t"));
	$('#startTime').timespinner('setValue', PHA_UTIL.SysTime("s"));
	$('#endTime').timespinner('setValue', PHA_UTIL.SysTime("l"));
	PHA.SetComboVal('locId', PHA_COM.VAR.locId);
}

/**
 * ���¼�
 */
function InitEvents(){
	PHA_EVENT.Bind('#btnFind', 'click', Query);
	PHA_EVENT.Bind('#btnClear', 'click', Clear);
	PHA_EVENT.Bind('#consumeFlag', 'click', Query);
	PHA_EVENT.Bind('#aspFlag', 'click', Query);
}

/**
 * ��������ʼ��Ĭ��ֵ
 */
function Clear(){
	QUE_FORM.ClearFormData();
	$('#gridIncItmLoc').datagrid('clear');	
	$('#gridIntrDetail').datagrid('clear');	
	InitDefVal();	
}


/**
 * ��ʼ���������
 */
function InitComponent(){	
	PHA.ComboBox('businessType', {
		multiple: true,
		rowStyle: 'checkbox',
		width: 396,
		url: PHA_STORE.BusinessType().url
	});
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
			title: "�䶯����",
			field: "changeQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "��������",
			field: "plusQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "��������",
			field: "minusQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "�䶯����(����)",
			field: "changeBQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "��������(����)",
			field: "plusBQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "��������(����)",
			field: "minusBQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "������λ",
			field: "bUomDesc",
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: "�䶯����(���)",
			field: "changePQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "��������(���)",
			field: "plusPQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "��������(���)",
			field: "minusPQty",
			width: 120,
			align: 'right',
			hidden: true
		}, {
			title: "��ⵥλ",
			field: "pUomDesc",
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: "�ڳ����",
			field: "begQtyWithUom",
			width: 120,
			align: 'right',
			hidden: false
		}, {
			title: "��ĩ���",
			field: "endQtyWithUom",
			align: 'right',
			width: 120,
			hidden: false
		}, {
			title: "�ڳ����۽��",
			field: "begRpAmt",
			align: 'right',
			width: 120,
			hidden: false
		}, {
			title: "��ĩ���۽��",
			field: "endRpAmt",
			align: 'right',
			width: 120,
			hidden: false
		}, {
			title: "�ڳ��ۼ۽��",
			field: "begSpAmt",
			align: 'right',
			width: 120,
			hidden: false
		}, {
			title: "��ĩ�ۼ۽��",
			field: "endSpAmt",
			align: 'right',
			width: 120,
			hidden: false
		}, {
			title: "pUomId",
			field: "pUomId",
			width: 100,
			hidden: true
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
			title: "��λ",
			field: "stkBin",
			width: 100
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
		fitColumns: false,
		border: false,
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
            if (data.total > 0){
	           $(this).datagrid('selectRow', 0); 
	        }
		},
		onSelect: function(rowIndex, rowData){
			QueryIntrDetail(rowData.incil);
		}
	};
	PHA.Grid('gridIncItmLoc', dataGridOption);
    QUE_COM.ComGridEvent("gridIncItmLoc");
}

function InitIntrDetailGrid(){
	var columns = [[
    	{ 
    		field: 'intrId',
    		title: 'intrId',
    		align: 'left',
    		width: 100, 
    		hidden: true 
    	}, { 
    		field: 'typeDesc',
    		title: 'ҵ������', 		
    		align: 'center',	
    		width: 120, 
    		hidden: false,
            styler: function(value, row, index){
	            if (value.indexOf("����") > 0){
					return 'background-color:#F1C516;color:#fff;';
				} 
	        }
		}, { 
			field: 'date', 		
			title: 'ʱ��', 			
			align: 'center', 	
			width: 160, 
			hidden: false,
            formatter: function(val, row, index){
	            return val +" "+ row.time;
	        }
		}, { 
			field: 'operator', 	
			title: '������', 		
			align: 'left', 	
			width: 100, 
			hidden: false 
		}, { 
			field: 'batNo', 		
			title: '����', 			
			align: 'left', 
			width: 100
		}, { 
			field: 'expDate', 	
			title: 'Ч��', 			
			align: 'left', 	
			width: 100, 
			hidden: true
		}, { 
			field: 'qtyWithUom', 		
			title: '����(��λ)', 			
			align: 'right', 
			width: 100,
			formatter: function(value, rowData, index){
				if (rowData.qty > 0){
					value = "+" + value;
				}
				return value;
			},
			styler: function(value, rowData, index){
				var styleStr = "";
				if (rowData.qty > 0){
					styleStr = "color:#5DB42F;"
				} else if (rowData.qty < 0){
					styleStr = "color:#F25757;"	
				}
	            return 'font-weight:bold;' + styleStr;	
	        }
		}, { 
			field: 'endQtyWithUom', 	
			title: '��������(��λ)', 		
			align: 'right', 
			width: 150 
		}, { 
			field: 'pQty', 		
			title: '����(���)', 			
			align: 'right', 
			width: 100,
			hidden: true 
		}, { 
			field: 'endPQty', 	
			title: '��������(���)', 		
			align: 'right', 
			width: 150,
			hidden: true 
		}, { 
			field: 'pUomDesc', 	
			title: '��ⵥλ', 			
			align: 'center',	
			width: 80,
			hidden: false 
		}, { 
			field: 'bQty', 		
			title: '����(����)', 			
			align: 'right', 
			width: 100,
			hidden: true 
		}, { 
			field: 'endBQty', 	
			title: '��������(����)', 		
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
			width: 100,
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
			align: 'center', 	
			width: 150,
			formatter: function(value, rowData, index){
				if (!value){
					return value;	
				}
				return '<a class="pha-grid-a js-grid-intrNo" id="intrNo-'+ index +'">' + value + '</a>';
			}
		}, { 
			field: 'TBRp', 			
			title: '����(����)', 			
			align: 'right', 
			width: 80,
			hidden: true
		}, { 
			field: 'TBSp', 			
			title: '�ۼ�(����)', 			
			align: 'right', 
			width: 80,
			hidden: true
		}, { 
			field: 'TPRp', 			
			title: '����(���)', 			
			align: 'right', 
			width: 80 
		}, { 
			field: 'TPSp', 			
			title: '�ۼ�(���)', 			
			align: 'right', 
			width: 80 
		}, { 
			field: 'rp', 			
			title: '����', 			
			align: 'right', 
			width: 80,
			hidden: true
		}, { 
			field: 'sp', 			
			title: '�ۼ�', 			
			align: 'right', 
			width: 80,
			hidden: true
		}, { 
			field: 'rpAmt', 		
			title: '���۽��', 		
			align: 'right', 
			width: 120 
		}, { 
			field: 'spAmt', 		
			title: '�ۼ۽��', 		
			align: 'right', 
			width: 120 
		}, { 
			field: 'type', 		
			title: 'ҵ������Code', 	
			align: 'center',
			width: 100, 
			hidden: true 
		}, { 
			field: 'endRpAmt', 	
			title: '������(����)',
			align: 'right', 
			width: 120 
		}, { 
			field: 'endSpAmt', 	
			title: '������(�ۼ�)',
			align: 'right', 
			width: 120 
		}, { 
			field: 'manfName', 	
			title: '������ҵ',
			align: 'left', 
			width: 120 
		}, { 
			field: 'vendorName', 	
			title: '��Ӫ��ҵ',
			align: 'left', 
			width: 120 
		}           
	]];
	
    var dataGridOption = {
        url: "",
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
        fit: true,
		fixRowNumber: true,
		border: false,
		onLoadSuccess: function(){
			$(this).datagrid('loaded');
		}
    };
    PHA.Grid('gridIntrDetail', dataGridOption);
    QUE_COM.ComGridEvent("gridIntrDetail");

    var eventClassArr = [];
	eventClassArr.push('pha-grid-a js-grid-intrNo');
	PHA.GridEvent('gridIntrDetail', 'click', eventClassArr, function(rowIndex, rowData, className){
		if (className === 'pha-grid-a js-grid-intrNo') {
			var pJson = {
                intrId: rowData.intrId
            }
            PHA.CM({
				    pClassName: 'PHA.IN.Query.Api',
					pMethodName: 'IntrNoInfo',
			        pJsonStr: JSON.stringify(pJson)
			    },function(retData){
					if ((retData.items) && ((retData.items.length === 0) && (retData.oeori == ""))){
					    PHA.Popover({ 
				        	showType: 'show', 
				        	msg: 'û���ҵ�������Ϣ��', 
				        	type: 'alert' 
				        });
						return;
					} else if (retData.oeori != ""){
						PHA_UX.OrderView(retData.oeori);
						return;
					}
					var $intrNoWin = $('#js-grid-intrNo');
					if ($intrNoWin.length === 0){
						$intrNoWin = $('<div class="pha-panel-body-content" style="padding-top:0;"></div>').appendTo('body');
					}
				    if (retData.msgArr.length === 0){
						retData.msgArr = ["<div></div>"];
					}
				    var $content = $('<div>' + retData.msgArr.join("") + '</div>').appendTo('body');
				    $hstep = $("<div class='pha-row'></div>").appendTo($content);
				    $hstep.hstep({
				        showNumber: false,
				        stepWidth: 170,
				        currentInd: retData.currentInd,
				        items: retData.items
					});

				    $intrNoWin.window({
					    title: $g('������Ϣ'),
						content: $content,
						width: (retData.items.length * 175),
						height: ($content.height() + 80),
						iconCls: 'icon-w-paper',
						modal: true,
						collapsible: false,
						minimizable: false,
						maximizable: false,
						onShow: function(e, value){
						}
					}); 
					$intrNoWin.window('open');
			    }
			);
		}
	});
}