/**
 * ����:	 ����ѯ - �������������
 * ��д��:	 pushuangcai
 * ��д����: 2022-04-07
 */
 
PHA_COM.VAR.OPER = {
	incil: '',
	inclb: '',
	opType: '',
	winId: "PHA_Query_LocStk_Win",
	gridId: "PHA_Query_LocStk_Grid"
};
	
/**
 * ��ʼ����ϸ����
 * @params {string} incil ���ҿ����id
 * @params {function} fun ��ʼ����ϸ���ĺ���
 */
function InitOperateWin(opts, fun){
	
	if(opts.opType !== PHA_COM.VAR.OPER.opType){
		var $widow = $('#'+ PHA_COM.VAR.OPER.winId);
		if ($widow.length === 0){
			var $widow = $('<div id="'+ PHA_COM.VAR.OPER.winId +'" class="pha-panel-body-content"></div>').appendTo('body');
		}
		$widow.empty();
		$widow.append('<div id="'+ PHA_COM.VAR.OPER.gridId +'"></div>');
		PHA_COM.VAR.OPER.opType = opts.opType;
	} else {
		return;	
	}
	
	if (typeof opts === "undefined"){
		var opts = {};	
	}
	$widow.window({
		collapsible: false,
		minimizable: false,
		aximizable: false,
		closed: true,
		modal: true,
		title: opts.title || $g("��������"),
		width: opts.width || $(this).width() * 0.65,
		height: opts.height || $(this).height() * 0.65,
		iconCls: 'icon-w-list',
		onOpen: function(){
			$(this).window('center');
		},
		onClose: function(){
			PHA_UX.BusiTimeLine({},{}, "close");
		}
	});
	if (fun) {
		fun();	
	}
}

function OpenOperateWin(pJson){
	PHA_COM.VAR.OPER.incil = pJson.incil || "";
	PHA_COM.VAR.OPER.inclb = pJson.inclb || "";
	
	if (pJson.inciDesc !== ""){
		pJson.inciDesc = "��"+ pJson.inciDesc;	
	}
	var winOpts = {};
	winOpts.opType = pJson.opType;
	if (pJson.opType === "resQty"){
		
		winOpts.title = $g("��;����ϸ") + pJson.inciDesc;
		winOpts.width = $(this).width() * 0.65;
		winOpts.height = $(this).height() * 0.65;	
		InitOperateWin(winOpts, InitResQtyGrid);
		
	} else if (pJson.opType === "dirtyQty"){
		
		winOpts.title = $g("ռ�õ�����ϸ") + pJson.inciDesc;
		winOpts.width = 800;
		winOpts.height = $(this).height() * 0.5;	
		InitOperateWin(winOpts, InitDirtyQtyGrid);

	} else if (pJson.opType === "HospStk"){
		
		winOpts.title = $g("ȫԺ���ҿ��") + pJson.inciDesc;
		winOpts.width = 550;
		winOpts.height = $(this).height() * 0.6;		
		InitOperateWin(winOpts, InitHospStockGrid);

	}  else if (pJson.opType === "Intr"){
		
		winOpts.title = $g("̨����Ϣ") + pJson.inciDesc;
		winOpts.width = $(this).width() * 0.7;
		winOpts.height = $(this).height() * 0.7;	
		InitOperateWin(winOpts, InitIntrGrid);
		
	}

	// ����ҳ��
	var $grid = $('#'+ PHA_COM.VAR.OPER.gridId);
	if ($grid.length > 0){
		var gridOpts = $grid.datagrid('options');
	    gridOpts.pageNumber = 1;
	    var pager = $grid.datagrid('getPager');
	    pager.pagination('refresh', {
		    pageNumber: 1
		});
	} 
	// ��ѯ����
	GetOperateDetail(pJson);
	// �޸Ĵ��ڱ���
	$('#'+ PHA_COM.VAR.OPER.winId).window('setTitle', winOpts.title);
	$('#'+ PHA_COM.VAR.OPER.winId).window('open');
}

/**
 * ��ѯҵ��������ϸ
 * @params {object} pJson 
 * @params {string} pJson.incil 	���ҿ����id
 * @params {string} pJson.inclb 	���ҿ������id
 * @params {string} pJson.opType 	��ѯ���
 */
function GetOperateDetail(pJson){
	if (pJson.opType === "Intr"){
		var trStDate = $('#trStDate').datebox('getValue');
		var trEnDate = $('#trEnDate').datebox('getValue');
		pJson.trStDate = trStDate;
		pJson.trEnDate = trEnDate;
	}
	var $grid = $('#'+ PHA_COM.VAR.OPER.gridId);
	$grid.datagrid('loading');
	
    PHA.CM({
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'GetOperateDetail',
	        pJsonStr: JSON.stringify(pJson)
	    },function(data){
	        $grid.datagrid('loadData', data);
	    }
	);
}

/**
 * ������ҵ�Ʒ��;��
 * @params {string} pJson.incil 	���ҿ����id
 */
function ClearIncilResQty(pJson, callback){
	PHA.CM(
		{
		    pClassName: 'PHA.IN.Query.Api',
			pMethodName: 'ClrReserveByIncil',
	        pJsonStr: JSON.stringify(pJson)
	    },function(retJson){
		    PHA.Ret(retJson);
		    if (callback){
				callback(retJson);    
			}
		}
	);
}

/**
 * ��ʼ����;�����
 */
function InitResQtyGrid() {
    var columns = [[
		{ 
			field: 'gridDetailSelect', 
			checkbox: true 
		}, { 
			field: 'rowId', 
			title: 'rowId', 
			hidden: true 
		}, { 
			field: 'incil', 
			title: 'incil', 
			hidden: true 
		}, { 
			field: 'pointer', 
			title: 'pointer', 
			hidden: true 
		}, { 
			field: 'patNo', 
			title: '�ǼǺ�', 
			align: 'left', 
			width: 150 
		}, { 
			field: 'patName', 
			title: '����', 
			align: 'left', 
			width: 100 
		}, { 
			field: 'ordDeptDesc', 
			title: 'ҽ������', 
			align: 'left', 
			width: 200 
		}, { 
			field: 'prescno', 
			title: '������', 
			align: 'left', 
			width: 150 
		}, { 
			field: 'qtyUom', 
			title: '��;��', 
			align: 'right', 
			width: 100 
		}, { 
			field: 'batNo', 
			title: '����', 
			align: 'right', 
			width: 100,
			hidden: true
		}, { 
			field: 'dateTime', 
			title: 'ʱ��', 
			align: 'left', 
			width: 150 
		}
	]];
    var dataGridOption = {
        url: "",
        singleSelect: false,
        pagination: true,
        columns: columns,
        fitColumns: false,
        toolbar: '',
        rownumbers: true,
		border: true,
        gridSave: false,
        loadFilter: PHA.LocalFilter,
		pageSize: 30,
        pageNumber: 1,
		fixRowNumber: true,
		checkOnSelect: false,
		selectOnCheck: false,
		bodyCls: 'panel-body-gray',
		headerCls: 'panel-header-gray',
		toolbar: [{
			iconCls: 'icon-cancel',
			text: '�����;��',
			handler: function(){
			    var rowsChecked = $('#'+ PHA_COM.VAR.OPER.gridId).datagrid('getChecked');
			    if (rowsChecked.length === 0) {
			        PHA.Popover({ 
			        	showType: 'show', 
			        	msg: '�빴ѡ��Ҫ�������;��ϸ', 
			        	type: 'alert' 
			        });
			        return;
			    }
			    var pJson = [];
			    for (var i = 0; i < rowsChecked.length; i++) {
			        pJson.push(rowsChecked[i].pointer);
			    }
				PHA.BizPrompt({
				}, function (r) {
					if (typeof r === "undefined"){
						return;
					}
					PHA.CM({
							pClassName: 'PHA.IN.Query.Api',
							pMethodName: 'ClrReserveByPointer',
							pJsonStr: JSON.stringify(pJson)
						},function(retJson){
							PHA.Ret(retJson);
							if (retJson.code == 0){
								PHA_LOG.Operate({
									operate: 'D',
									logInput: JSON.stringify(pJson),
									type: 'User.DHCIncReservedQtyDetail',
									pointer: '',
									origData: '',
									remarks: '�����;��'+ (r == '' ? '' : '��'+ r +'��')
								});
								GetOperateDetail(PHA_COM.VAR.OPER);
							}
						}
					);
			    });
			}
		}],
		onLoadSuccess: function(){
			$('#'+ PHA_COM.VAR.OPER.gridId).datagrid('loaded');
		}
    };
    PHA.Grid(PHA_COM.VAR.OPER.gridId, dataGridOption);
}

/**
 * ռ�õ�����ϸ���
 */
function InitDirtyQtyGrid(){
	var columns = [[
		{ 
    		field: 'initck', 
    		title: 'initck',
			checkbox: true
    	}, { 
    		field: 'initItmId', 
    		title: 'initItmId', 
    		align: 'left', 
    		width: 200, 
    		hidden: true 
    	}, { 
        	field: 'trNo', 
        	title: 'ת�Ƶ���', 
        	align: 'left', 
        	width: 220,
			formatter: QUE_COM.Grid.Formatter.TransNo()
        }, { 
        	field: 'batNo', 
        	title: '����', 
        	align: 'left', 
        	width: 100 
        }, { 
        	field: 'qty', 
        	title: 'ռ������', 
        	align: 'right', 
        	width: 100 
        }, { 
        	field: 'uomDesc', 
        	title: '��λ', 
        	align: 'left', 
        	width: 100 
        }, { 
        	field: 'trDate', 
        	title: '��������', 
        	align: 'left', 
        	width: 150, 
        	formatter: function(value, rowData, rowIndex){
	        	return value +" "+ rowData.trTime;
	        }
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
        border: true,
		gridSave: false,
        pageNumber: 1,
		fixRowNumber: true,
		checkOnSelect: false,
		bodyCls: 'panel-body-gray',
		headerCls: 'panel-header-gray',
		selectOnCheck: false,
		onLoadSuccess: function(){
			$('#'+ PHA_COM.VAR.OPER.gridId).datagrid('loaded');
		},
		toolbar: [{
			iconCls: 'icon-cancel',
			text: 'ɾ��ռ��',
			handler: function(){
			    var checkedRows = $('#'+ PHA_COM.VAR.OPER.gridId).datagrid('getChecked');
			    if (checkedRows.length === 0) {
			        PHA.Popover({ 
			        	showType: 'show', 
			        	msg: '�빴ѡ��Ҫɾ��ռ�õĵ���', 
			        	type: 'alert' 
			        });
			        return;
			    }
				var initiArr = [];
				for (var i = 0; i < checkedRows.length; i++){
					initiArr.push(checkedRows[i].initItmId);
				}
			    var pJson = {
					rows: initiArr   
				}
				PHA.BizPrompt({
					info: "�ò�����ɾ����Ӧ�����е�ҩƷ��ϸ"
					}, function (r) {
						if (typeof r === "undefined"){
							return;
						}
						PHA.CM(
							{
								pClassName: 'PHA.IN.Query.Api',
								pMethodName: 'DelDirtyQty',
								pJsonStr: JSON.stringify(pJson)
							},function(retJson){
								PHA.Ret(retJson);
								if (retJson.code == 0){
									GetOperateDetail(PHA_COM.VAR.OPER);		
									PHA_LOG.Operate({
										operate: 'D',
										logInput: JSON.stringify(pJson),
										type: 'User.DHCInIsTrfItm',
										pointer: '',
										origData: JSON.stringify(PHA_COM.VAR.OPER),
										remarks: 'ɾ��ռ��'+ (r == '' ? '' : '��'+ r +'��')
									});	
								}		    
							}
						);
					}
				);
			}
		}],
    };
    PHA.Grid(PHA_COM.VAR.OPER.gridId, dataGridOption);
	QUE_COM.ComGridEvent(PHA_COM.VAR.OPER.gridId);
}

function InitHospStockGrid(){
	var columns = [[
    	{ 
    		field: 'locDesc', 
    		title: '����', 
    		align: 'left', 
    		width: 250 
    	}, { 
    		field: 'qtyWithUom', 
    		title: '���(��λ)', 
    		align: 'right', 
    		width: 250,
    		hidden: false
    	}, {
			title: "���(���)",
			field: "pQty",
			width: 150,
			align: 'right',
			hidden: true
		}, {
			title: "��ⵥλ",
			field: "pUomDesc",
			width: 70,
			align: 'left',
			hidden: true
		}, {
			title: "���(����)",
			field: "bQty",
			width: 150,
			align: 'right',
			hidden: true
		}, {
			title: "������λ",
			field: "bUomDesc",
			width: 80,
			align: 'left',
			hidden: true
		}
    ]];
	var dataGridOption = {
        url: "",
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        border: true,
		toolbar: '',
        gridSave: false,
		loadFilter: PHA.LocalFilter,
		bodyCls: 'panel-body-gray',
		headerCls: 'panel-header-gray',
		pageSize: 30,
        pageNumber: 1,
        showFooter: true,
		fixRowNumber: true,
		onLoadSuccess: function(){
			$('#'+ PHA_COM.VAR.OPER.gridId).datagrid('loaded');
		}
    };
    PHA.Grid(PHA_COM.VAR.OPER.gridId, dataGridOption);
}

function InitIntrGrid(){
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
    		align: 'left',	
    		width: 100, 
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
			align: 'left',	
			width: 80,
			hidden: true 
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
			align: 'left', 	
			width: 150 
		}, { 
			field: 'rp', 			
			title: '����', 			
			align: 'right', 
			width: 100 
		}, { 
			field: 'sp', 			
			title: '�ۼ�', 			
			align: 'right', 
			width: 100 
		}, { 
			field: 'rpAmt', 		
			title: '���۽��', 		
			align: 'right', 
			width: 100 
		}, { 
			field: 'spAmt', 		
			title: '�ۼ۽��', 		
			align: 'right', 
			width: 100 
		}, { 
			field: 'type', 		
			title: 'ҵ������Code', 	
			align: 'left',
			width: 100, 
			hidden: true 
		}, { 
			field: 'endRpAmt', 	
			title: '������(����)',
			align: 'right', 
			width: 100 
		}, { 
			field: 'endSpAmt', 	
			title: '������(�ۼ�)',
			align: 'right', 
			width: 100 
		}            
	]];
    var $toolbar = $('<div><table class="pha-con-table"><tr>'
    	+ '<td>'+ $g('��ʼ����')+ '</td>'
	    + '<td><input id="trStDate"></td>'
	    + '<td>'+ $g('��ֹ����') +'</td>'
	    + '<td><input id="trEnDate"></td>'
	    + '<td><a id="btnFindIntr">'+ $g('��ѯ')+ '</a></td>'
    +'</tr></table></div>').prependTo('#'+ PHA_COM.VAR.OPER.winId);
	$('#trStDate').datebox({value: PHA_UTIL.SysDate("t")});
 	$('#trEnDate').datebox({value: PHA_UTIL.SysDate("t")});
 	
 	$('#btnFindIntr').linkbutton({
		onClick: function(){
			GetOperateDetail(PHA_COM.VAR.OPER);
		}	
	});
	
    var dataGridOption = {
        url: "",
        singleSelect: true,
        pagination: true,
        columns: columns,
        fitColumns: false,
        toolbar: $toolbar,
		bodyCls: 'panel-body-gray',
		headerCls: 'panel-header-gray',
		border: true,
        loadFilter: PHA.LocalFilter,
		pageSize: 30,
		gridSave: false,
        pageNumber: 1,
        fit: true,
		fixRowNumber: true,
		nowrap: false,
		onLoadSuccess: function(){
			$('#'+ PHA_COM.VAR.OPER.gridId).datagrid('loaded');
		}
    };
    PHA.Grid(PHA_COM.VAR.OPER.gridId, dataGridOption);
}