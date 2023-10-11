/**
 * ģ��:     ��������(��������)
 * ��д����: 2022-04-15
 * ��д��:   yangsj
 */
 
var cmbWidth = '160';
var gParamReq = PHA_COM.ParamProp('DHCSTINREQ')
var gParamCom = PHA_COM.ParamProp('DHCSTCOMMON')
var GRIDID = 'gridConsume';
var BARID = '#gridConsumeBar'

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
	$('#panelConsume').panel({
		title: PHA_COM.IsTabsMenu() !== true ? '��������(��������)' : '',
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
	/* ������Һ͹�������  */
    compoments.ToFrLoc('recLocId', 'proLocId');
    
    /* ���� */
    compoments.Scg('scg', 'recLocId');
	
	/* ������ */
	compoments.StkCat('stkcatId', 'scg');
	
	/* ����ҵ�� */
	compoments.BizRange('bizRange', true, true, 396);
    
    /* ��ʼ����ֵ�ؼ��� */
	INRQ_COM.SetKW('kw', GRIDID)
    
}

function InitGrid(){
	InitGridConsume();
}

function InitGridConsume(){
	var frozenColumns = [
		[
			{ field: 'inrqiId', 	title: 'inrqiId', 		hidden: true },
        	{ field: 'inci', 		title: 'inci', 			hidden: true },
            { field: 'inciCode',	title: 'ҩƷ����',		width: 200,			align: 'left' },
            { field: 'inciDesc',	title: 'ҩƷ����',		width: 200,			align: 'left' },
		]
    ];
	
	var columns = [
        [
            // OrgId, OrgType, OrgName, CertName, DateToDesc, DifDay
            { field: 'qty', 		title: '������', 			width: 100, 	align: 'right',
            	editor: PHA_GridEditor.NumberBox({
	            	required: true,
					checkValue: function (val, checkRet) {
						if (val == '') {
							checkRet.msg = '����Ϊ�գ�'
								return false;
						}
						var nQty = parseFloat(val);
						if (isNaN(nQty)) {
							checkRet.msg = '���������֣�';
							return false;
						}
						if (nQty < 0) {
							checkRet.msg = '���������0�����֣�';
							return false;
						}
						return true;
					}
				})	
			},
            { field: 'sugQty', 		title: '����������', 		width: 120, 	align: 'right'	},
            { field: 'pUomId', 		title: 'pUomId', 			hidden: true 	},
            { field: 'pUomDesc', 	title: '��λ', 				width: 100, 	align: 'left'	},
            { field: 'stkCatDesc', 	title: '������', 			width: 100, 	align: 'left'	},
            { field: 'inciSpec', 	title: '���', 				width: 100, 	align: 'left'	},
            { field: 'manfName', 	title: '������ҵ', 			width: 200, 	align: 'left'	},
            { field: 'stkQty', 		title: '���󷽿��', 		width: 120, 	align: 'right'	},
            { field: 'proAvaQty', 	title: '��Ӧ�����', 		width: 120, 	align: 'right'	},
            { field: 'avaQty', 		title: '���ÿ�ҽ����', 		width: 120, 	align: 'right'	},
            { field: 'dailyDispQty',title: '��������', 			width: 120, 	align: 'right'	},
            { field: 'reqQtyAll', 	title: '�ο�������������', 	width: 120, 	align: 'right'	},
            { field: 'dispQtyAll', 	title: '���ڷ�Χ����������', 	width: 120, align: 'right'	}
        ]
    ];
    
    var dataGridOption = {
		url: PHA.$URL,
		queryParams: {
            pClassName : INRQ_COM.API,
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
					field: 'reqQty'
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
	mainObj['remarks']  = '��������';
	mainObj = com.AddSession(mainObj);
	
	return mainObj; 
}

function Save()
{
    if (!PHA_GridEditor.EndCheck(GRIDID)) return;
    if (!PHA_GridEditor.CheckValuesMsg(GRIDID)) return;
    
    /* �������� */
    var mainObj = GetCondition()
    
    /* �ӱ����� */
    var gridRows = $('#' + GRIDID).datagrid('getRows');
    var gridRowsLen = gridRows.length;
    if (!gridRowsLen){
	    PHA.Msg('alert', 'û����Ҫ��������ݣ�');
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
		startDate : 't - 30',
		endDate   : 't - 1',
		days : 30
	}])
}

function Clear(){
	compoments.Clear([GRIDID], [BARID]);
	SetDefa();
}


