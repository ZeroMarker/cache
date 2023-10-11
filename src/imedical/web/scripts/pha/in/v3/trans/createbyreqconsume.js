/**
 * 模块:     辅助转移(依据请求方消耗)
 * 编写日期: 2022-05-11
 * 编写人:   yangsj
 */
 
var cmbWidth = '140';
var GRIDID = 'gridConsume'
var BARID = '#gridConsumeBar'

var com = INIT_COM;
var compoments = INIT_COMPOMENTS;

$(function () {
	SetPanel();
    InitDict();
    InitGrid();
    SetRequired();
    SetDefa();
});

function SetPanel(){
	$('#panelConsume').panel({
		title: PHA_COM.IsTabsMenu() !== true ? '辅助转移(依据请求方消耗)' : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-template',
		bodyCls: 'panel-body-gray',
		fit: true
	});
}

function SetRequired(){
	PHA.SetRequired($(BARID + ' [data-pha]'))
}

function InitDict(){
	
	/* 供给科室和请求科室  */
    compoments.FrToLoc('proLocId', ['recLocId']);
    
    /* 请求状态 */
    PHA.ComboBox('reqStatus', {
        width: cmbWidth,
        multiple: true,
        width: compoments.longCmbWidth,
        url: PHA_IN_STORE.ReqStauts('TRANS').url,
    });
    
    /* 类组 */
    compoments.Scg('scg', 'proLocId');
	
	/* 库存分类 */
	compoments.StkCat('stkcatId', 'scg');

	/* 消耗业务 */
	compoments.BizRange('bizRange', true, true, 300);
    
    /* 初始化赋值关键字 */
	INIT_COM.SetKW('kw', GRIDID)
}

function InitGrid(){
	InitGridConsume();
}

function InitGridConsume(){
	var frozenColumns = [
		[
			{ field: 'inrqiId', 	title: 'inrqiId', 		hidden: true },
        	{ field: 'inci', 		title: 'inci', 			hidden: true },
            { field: 'inciCode',	title: '药品代码',		width: 200,			align: 'left' },
            { field: 'inciDesc',	title: '药品名称',		width: 200,			align: 'left' },
		]
    ];
	
	var columns = [
        [
            // OrgId, OrgType, OrgName, CertName, DateToDesc, DifDay
            { field: 'qty', 		title: '申请量', 				width: 100, 	align: 'right',
            	editor: PHA_GridEditor.NumberBox({
	            	required: true,
					checkValue: function (val, checkRet) {
						if (val == '') {
							checkRet.msg = '不能为空！'
								return false;
						}
						var nQty = parseFloat(val);
						if (isNaN(nQty)) {
							checkRet.msg = '请输入数字！';
							return false;
						}
						if (nQty < 0) {
							checkRet.msg = '请输入大于0的数字！';
							return false;
						}
						return true;
					}
				})	
			},
            { field: 'sugQty', 		title: '建议申请量', 			width: 120, 	align: 'right'	},
            { field: 'pUomId', 		title: 'pUomId', 				hidden: true 					},
            { field: 'pUomDesc', 	title: '单位', 					width: 100, 	align: 'left'	},
            { field: 'stkCatDesc', 	title: '库存分类', 				width: 100, 	align: 'left'	},
            { field: 'inciSpec', 	title: '规格', 					width: 100, 	align: 'left'	},
            { field: 'manfName', 	title: '生产企业', 				width: 200, 	align: 'left'	},
            { field: 'stkQty', 		title: '请求方库存', 			width: 120, 	align: 'right'	},
            { field: 'proAvaQty', 	title: '供应方库存', 			width: 120, 	align: 'right'	},
            { field: 'avaQty', 		title: '可用开医嘱量', 			width: 120, 	align: 'right'	},
            { field: 'dailyDispQty',title: '日发药量', 				width: 120, 	align: 'right'	},
            { field: 'reqQtyAll', 	title: '参考天数内需求量', 		width: 120, 	align: 'right'	},
            { field: 'dispQtyAll', 	title: '日期范围内发药总量', 	width: 120, 	align: 'right'	}
        ]
    ];
    
    var dataGridOption = {
		url: PHA.$URL,
		queryParams: {
            pClassName : 'PHA.IN.REQ.Api',
            pMethodName: 'QueryConsume',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
		singleSelect: true,
		pagination: true,
		columns: columns,
		frozenColumns: frozenColumns,
		toolbar: BARID,
		gridSave: false,
		isCellEdit: false,
		allowEnd: true,
		isAutoShowPanel: true,
		editFieldSort: ['qty'],
		onDblClickRow: function (rowIndex, rowData) {
	        if (rowData) {
		     	PHA_GridEditor.Edit({
					gridID: GRIDID,
					index: rowIndex,
					field: 'qty'
					//forceEnd: true
				});
            }
        },
		onLoadSuccess: function (data) {
			
			PHA_GridEditor.End(GRIDID);
			INIT_COM.SetQty('kw', GRIDID);
		}
	};
	PHA.Grid(GRIDID, dataGridOption);
}

function Query(){
	var pJson = GetCondition();
	$('#' + GRIDID).datagrid('query', {
        pJson : JSON.stringify(pJson),
    });
}

function GetCondition(){
var inrqJsonStr = PHA.DomData(BARID, {
        doType: 'query',
        retType: 'Json'
    });
    if (!inrqJsonStr.length) return {};
	var mainObj = inrqJsonStr[0];
	mainObj['remarks']  = '依据请求科室消耗';
	mainObj = com.AddSession(mainObj);
	
	return mainObj; 
}

function Save()
{
    if (!PHA_GridEditor.EndCheck(GRIDID)) return;
    if (!PHA_GridEditor.CheckValuesMsg(GRIDID)) return;
    
    /* 主表数据 */
    var mainObj = GetCondition();
    
    /* 子表数据 */
    var gridRows = $('#' + GRIDID).datagrid('getRows');
    var gridRowsLen = gridRows.length;
    if (!gridRowsLen){
	    PHA.Msg('alert', '没有需要保存的数据！');
	    return;
    }
    var pJson = {
	    main : mainObj,
	    rows : gridRows
    }
    com.Biz(pJson, 'CreateByConsume', com.SkipLink); 
}

function SetDefa(){
	PHA.SetVals([{ 
		proLocId  : session['LOGON.CTLOCID'],
		startDate : com.GetDateStr(com.ParamTrans.DefaStartDate),
		endDate   : com.GetDateStr(com.ParamTrans.DefaEndDate),
		days : 30
	}])
}

function Clear(){
	compoments.Clear([GRIDID], [BARID]);
	SetDefa();
}



