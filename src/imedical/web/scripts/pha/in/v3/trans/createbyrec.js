/**
 * ģ��:     ����ת��(������ⵥ)
 * ��д����: 2022-04-41
 * ��д��:   yangsj
 */
var cmbWidth = '150'; 

var RECGRID = 'gridRec';
var RECIGRID = 'gridReci';
var BARID = '#gridRecBar';

var com = INIT_COM;
var compoments = INIT_COMPOMENTS;

$(function () {
    InitDict();
    InitGrid();
    BindBtnEvent();
    SetDefa();
    SetRequired();
    DefultQuery();
});

function SetRequired(){
	PHA.SetRequired($(BARID + ' [data-pha]'));
}

function BindBtnEvent(){
	PHA.BindBtnEvent(BARID);
}

function InitDict(){
	/* ��Ӫ��ҵ */
    PHA.ComboBox('vendorId', {
        width: cmbWidth,
        url: PHA_STORE.APCVendor().url,
    });

	/* �������Һ��������  */
    compoments.FrToLoc('proLocId', ['recLocId']);
}

function InitGrid(){
	InitGridInit();
	InitGridIniti();
}

function SetDefa(){
	PHA.SetVals([{ 
		proLocId  : session['LOGON.CTLOCID'],
		startDate : com.GetDateStr(com.ParamTrans.DefaStartDate),
		endDate   : com.GetDateStr(com.ParamTrans.DefaEndDate)
	}])
	$('#nextStatusCode').combobox('reload')
}

function InitGridInit(){
	var frozenColumns = [
		[
			{ field: 'recId', 		title: 'ingdId', 		hidden: true 						},
        	{ field: 'recNo', 		title: '��ⵥ��', 		width: 180,			align: 'left' 	},
		]
    ];
	
	var columns = [
        [
            { field: 'recLocDesc', 	title: '������', 			width: 100, 	align: 'left'	},
            { field: 'transFlag', 	title: '��ת��', 			width: 60, 		align: 'center'	,formatter: PHA_GridEditor.CheckBoxFormatter},
            { field: 'createDT', 	title: '����ʱ��', 			width: 180, 	align: 'left'	},
            { field: 'creator', 	title: '������', 			width: 100, 	align: 'left'	}
        ]
    ];

    var dataGridOption = {
		url: PHA.$URL,
		singleSelect: true,
		pagination: true,
		columns: columns,
		frozenColumns:frozenColumns,
		toolbar: BARID,
		gridSave: false,
		isCellEdit: false,
		allowEnd: true,
		onClickRow: function (rowIndex, rowData) {
	        if (rowData) {
		      	QueryReci();
            }
        },
		onDblClickRow: function (rowIndex, rowData) {}
	};
	PHA.Grid(RECGRID, dataGridOption);
}

function InitGridIniti(){
	var frozenColumns = [
		[
			{ field: 'recItmID', 	title: 'recItmID', 		hidden: true },
        	{ field: 'inclb', 		title: 'inclb', 		hidden: true },
            { field: 'inciCode',	title: 'ҩƷ����',		width: 200,			align: 'left' },
            { field: 'inciDesc',	title: 'ҩƷ����',		width: 200,			align: 'left' },
		]
    ];
	
	var columns = [
        [
            { field: 'qty', 		title: '�������', 			width: 100, 	align: 'right'	},
            { field: 'uomDesc', 	title: '��λ', 				width: 120, 	align: 'left'	},
            { field: 'rp', 			title: '����', 				width: 120, 	align: 'right'	},
            { field: 'sp', 			title: '�ۼ�', 				width: 120, 	align: 'right'	},
            { field: 'rpAmt', 		title: '���۽��', 			width: 120, 	align: 'right'	},
            { field: 'spAmt', 		title: '�ۼ۽��', 			width: 120, 	align: 'right'	},
            { field: 'batNo', 		title: '����', 				width: 120, 	align: 'left'	},
            { field: 'expDate', 	title: 'Ч��', 				width: 120, 	align: 'left'	}
        ]
    ];
	
    var dataGridOption = {
		url: PHA.$URL,
		queryParams: {},
		singleSelect: false,
		pagination: false,
		columns: columns,
		frozenColumns: frozenColumns,
		gridSave: false,
		idField: 'recItmID',
		isCellEdit: false,
		allowEnd: true,
		loadFilter:PHA.localFilter,
		showFooter: true,
		onLoadSuccess: function (data) {
			PHA_COM.SumGridFooter('#' + RECIGRID, ['rpAmt', 'spAmt']);
		}
	};
	PHA.Grid(RECIGRID, dataGridOption);
}

function Query(){
	QueryRec();	
}

function CreateByRec()
{
    var recId = GetRecId()
    if(!recId){
	    PHA.Msg('alert', '��ѡ��һ����ⵥ��');
	    return;
    }
    var recLocId = $('#recLocId').combobox('getValue')
    if(!recLocId){
	    PHA.Msg('alert', '��ѡ��������ң�');
	    return;
    }
    
    var pJson = {
	    recId : recId,
	    recLocId:recLocId,
    }
    com.Biz(pJson, 'CreateByRec', com.SkipLink); 
}

function GetMainObj(){
	var initJsonStr = PHA.DomData(BARID, {
        doType: 'query',
        retType: 'Json'
    });
    if (!initJsonStr.length) return {};
	var mainObj = initJsonStr[0];
	mainObj = com.AddSession(mainObj);
	
	return mainObj; 
}

function Clear(){
	compoments.Clear([RECGRID, RECIGRID], [BARID]);
	SetDefa();
}

function QueryRec(){
	compoments.Clear([RECIGRID]);
	var pJson = PHA.DomData(BARID, {
        doType: 'query',
        retType: 'Json'
    });
    
	$('#gridRec').datagrid('query', {
        pJson : JSON.stringify(pJson[0]),
        pClassName: com.API,
        pMethodName: 'QueryRec',
        pPlug: 'datagrid'
    });
}

function QueryReci(){
	var recId = GetRecId();
	if (!recId) return;
    
    $('#gridReci').datagrid('query', {
        pJson : JSON.stringify({recID:GetRecId()}),
        pClassName: 'PHA.IN.REC.Api',
        pMethodName: 'GetItmDataRows',
        pPlug: 'datagrid'
    });
    
    /*
    $('#gridReci').datagrid('query', {
        pJson : JSON.stringify({recID:recId}),
    });
            pClassName : 'PHA.IN.REC.Api',
            pMethodName: 'GetItmDataRows',
            pPlug	   : 'datagrid',
            pJson      : '{}',
 */       
}

function GetRecId(){
	var gridSelect = $('#gridRec').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.recId;
    return '';
}

