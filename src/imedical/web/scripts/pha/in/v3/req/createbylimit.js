/**
 * 模块:     辅助请求(依据上下限)
 * 编写日期: 2022-04-18
 * 编写人:   yangsj
 */
 
var gParamReq = PHA_COM.ParamProp('DHCSTINREQ')
var gParamCom = PHA_COM.ParamProp('DHCSTCOMMON')
var GRIDID = 'gridLimit';
var BARID = '#gridLimitBar';

var com = INRQ_COM;
var compoments = INRQ_COMPOMENTS;

$(function () {
	SetPanel();
    InitDict();
    InitGrid();
    SetRequired();
    SetDefa();
});

function SetPanel(){
	$('#panelLimit').panel({
		title: PHA_COM.IsTabsMenu() !== true ? '辅助请求(依据上下限)' : '',
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
	/* 请求科室和供给科室  */
    compoments.ToFrLoc('recLocId', 'proLocId');
    
    /* 类组 */
    compoments.Scg('scg', 'recLocId');
	
	/* 库存分类 */
	compoments.StkCat('stkcatId', 'scg');
    
	/* 初始化赋值关键字 */
	INRQ_COM.SetKW('kw', GRIDID)
}

function InitGrid(){
	InitGridLimit();
}

function InitGridLimit(){
	var frozenColumns = [
		[
			{ field: 'inrqiId', 	title: 'inrqiId', 		hidden: true },
        	{ field: 'inci', 		title: 'inci', 			hidden: true },
            { field: 'inciCode',	title: '药品代码',		width: 100,			align: 'left' },
            { field: 'inciDesc',	title: '药品名称',		width: 250,			align: 'left' }
		]
    ];
	
	var columns = [
        [
            // OrgId, OrgType, OrgName, CertName, DateToDesc, DifDay
            { field: 'qty', 		title: '申请量', 			width: 100, 	align: 'right',
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
            { field: 'sugQty', 		title: '建议申请量', 		width: 120, 	align: 'right'	},
            { field: 'pUomId', 		title: 'pUomId', 			hidden: true 	},
            { field: 'pUomDesc', 	title: '单位', 				width: 100, 	align: 'right'	},
            { field: 'maxQty', 		title: '库存上限', 			width: 100, 	align: 'right'	},
            { field: 'minQty', 		title: '库存下限', 			width: 100, 	align: 'right'	},
            { field: 'standQty', 	title: '标准库存', 			width: 100, 	align: 'right'	},
            { field: 'stkCatDesc', 	title: '库存分类', 			width: 100, 	align: 'left'	},
            { field: 'inciSpec', 	title: '规格', 				width: 100, 	align: 'left'	},
            { field: 'recStkQty', 	title: '请求方库存', 		width: 120, 	align: 'right'	},
            { field: 'proAvaQty', 	title: '供应方库存', 		width: 120, 	align: 'right'	}
        ]
    ];
    
    var dataGridOption = {
		url: PHA.$URL,
		queryParams: {
            pClassName : INRQ_COM.API,
            pMethodName: 'QueryLimit',
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
			INRQ_COM.SetQty('kw', GRIDID);
		}
	};
	PHA.Grid(GRIDID, dataGridOption);
}

function Query(){
	var pJson =  GetCondition();
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
	mainObj['remarks']  = '依据上下限';
	mainObj = com.AddSession(mainObj);
	
	return mainObj; 
}

function Save()
{
    if (!PHA_GridEditor.EndCheck(GRIDID)) return;
    if (!PHA_GridEditor.CheckValuesMsg(GRIDID)) return;
    
    /* 主表数据 */
    var mainObj = GetCondition()
    
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
    com.Biz(pJson, 'SaveInrq', com.SkipLink); 
}

function SetDefa(){
	PHA.SetVals([{ 
		recLocId  : session['LOGON.CTLOCID'],
	}])
}

function Clear(){
	compoments.Clear([GRIDID], [BARID]);
	SetDefa();
}




