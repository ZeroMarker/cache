/**
 * ģ��:     �����걨-�ձ�
 * ��д����: 2022-05-17
 * ��д��:   yangsj
 */
var cmbWidth = '160';
var REPTYPE = 'D'
var SELECTDAY   = ''
$(function () {
    InitDict();				//��ʼ���ֵ�
    InitGrid();				//��ʼ��grid
    BindBtnEvent();
    SetDefault();			//����Ĭ��ֵ
	SetCellEdit();			//���õ�Ԫ��༭
	setTimeout(function () { DifPrompt(); }, 500);
});

function SetCellEdit(){
	$('#gridDay').datagrid('enableCellEditing').datagrid('gotoCell', {
		index: 0,
	});
}

function BindBtnEvent(){
	PHA_EVENT.Bind('#btnCreateDayRepByMon', 'click', function(){CreateDayRepByMon();});
	PHA_EVENT.Bind('#btnCreateDayRepByDay', 'click', function(){CreateDayRepByDay();});
	PHA.BindBtnEvent('#gridRepBar');
}

function InitDict(){
	$('.icon-help').popover({
		title: $g('��ʾ'),
		width: '650',
		content: $g('[��ѡ���������ձ�]������ѡ���·ݵ������������������ձ���')
			+ '<br>'+ $g('[��ѡ���������ձ�]������������ѡ�е��������ɸ����ڵ��ձ���')
			+ '<br>'+ $g(' 1.�ձ���ϵͳ�����Զ����ɣ�ֻ�������յ��ձ���')
			+ '<br>'+ $g(' 2.�����ձ��������ֶ����ɣ�������Ҵ�δ�ձ������񲻻�ִ�С�')
			+ '<br>'+ $g(' 3.ֻ��ǰ���ձ�������ɲ����޲���ʱ����������Զ����������ձ����������ֶ����ɻ��߲���ȷ�ϡ�')
	});

	$('.icon-reload').on('click', function () { QueryDays(); })
	
	
    /* ҩ������  */
    PHA_UX.ComboBox.Loc('locId', {
	    width: cmbWidth,
	    onSelect: function(e,val){
			QueryDays();
	    }
	});
	
	$('#yearMon').phamonthbox({
		width : cmbWidth,
		onSelect: function(val) {
			QueryDays(val);
		}
	});
}

function SetDefault(){
	//����Ĭ�ϵ�½����
	$('#locId').combobox('setValue', session['LOGON.CTLOCID']);
	
	//��ʼ���·�������
	var myDate=new Date();
	var year = myDate.getFullYear();
	var mon = myDate.getMonth() + 1;
	var yearMon = year + '-' + mon;
	$('#yearMon').phamonthbox('setValue', yearMon);
	
	QueryDays();
}
function SetUpDiagDefault(){
}

function InitGrid(){
	InitGridDay();
	InitGridDayRep();
	REP_COM.INITGRID.InitComGrid();
}

function InitGridDay(){
   var columns = [
        [
        	// Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday
            { field: 'Monday', 		title: 'һ', align: 'center', width: 50,	styler:REP_COM.FORMATTER.DayStatusStyler,	formatter:REP_COM.FORMATTER.DayFormatter},  //styler:MStateStyler,
            { field: 'Tuesday', 	title: '��', align: 'center', width: 50,	styler:REP_COM.FORMATTER.DayStatusStyler,	formatter:REP_COM.FORMATTER.DayFormatter},
            { field: 'Wednesday', 	title: '��', align: 'center', width: 50,	styler:REP_COM.FORMATTER.DayStatusStyler,	formatter:REP_COM.FORMATTER.DayFormatter},
            { field: 'Thursday', 	title: '��', align: 'center', width: 50,	styler:REP_COM.FORMATTER.DayStatusStyler,	formatter:REP_COM.FORMATTER.DayFormatter},
            { field: 'Friday', 		title: '��', align: 'center', width: 50,	styler:REP_COM.FORMATTER.DayStatusStyler,	formatter:REP_COM.FORMATTER.DayFormatter},
            { field: 'Saturday', 	title: '��', align: 'center', width: 50,	styler:REP_COM.FORMATTER.DayStatusStyler,	formatter:REP_COM.FORMATTER.DayFormatter},
            { field: 'Sunday', 		title: '��', align: 'center', width: 50,	styler:REP_COM.FORMATTER.DayStatusStyler,	formatter:REP_COM.FORMATTER.DayFormatter},
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : 'PHA.IN.REP.Api',
            pMethodName: 'QueryDays',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        gridSave:false,
        columns: columns,
        exportXls: false,
        pagination: false,
        singleSelect:true,
        clickToEdit: true,
        onClickCell: function (index, field, value) {
	        if (value.indexOf('-') >= 0) value = value.split('-')[0]
	        SELECTDAY = value;
			if(value) QueryDayRep(SELECTDAY);
			else(REP_COM.OPERATE.ClearGrid('gridRep'))
		}
    };
    PHA.Grid('gridDay', dataGridOption);
}

function InitGridDayRep(){
   var columns = [
        [
        	// repId,date,useStatus,difStatus
        	{ field: 'repId', 		title: 'repId', 	align: 'center', width: 80 	,hidden:true},
        	{ field: 'repType', 	title: 'repType', 	align: 'center', width: 80 	,hidden:true},
        	{ field: 'date', 		title: '�ձ�����', 	align: 'center', width: 120 },
            { field: 'useStatus', 	title: 'ʹ��״̬', 	align: 'center', width: 80 	,styler:REP_COM.FORMATTER.AllStateStyler,	formatter:REP_COM.FORMATTER.AllStateFormatter},
            { field: 'difStatus', 	title: '����״̬', 	align: 'center', width: 80 	,styler:REP_COM.FORMATTER.DifStateStyler,	formatter:REP_COM.FORMATTER.DifStateFormatter},
        ],
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : 'PHA.IN.REP.Api',
            pMethodName: 'QueryDayRep',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        gridSave:false,
        columns: columns,
        toolbar: '#gridRepBar',
        exportXls: false,
        pagination: false,
        onClickRow: function (rowIndex, rowData) {
	        if (rowData) {
                REP_COM.FUNCTION.QueryRepDetail();
                REP_COM.FUNCTION.QueryRepOperate();
            }
        },
        onDblClickRow: function (rowIndex, rowData) {
        }
    };
    PHA.Grid('gridRep', dataGridOption);
}

function onSelect(){
	QueryDays();
}

function QueryDays(yearMon, index, field){
	REP_COM.OPERATE.ClearGridAllDetail();
	
	SELECTDAY = '';
	if(!yearMon){
		var yearMon = $('#yearMon').phamonthbox('getValue') || '';
	}
	if(!yearMon) return;
	var locId = $('#locId').combobox('getValue')
	if(!locId) return;
	
    var pJson = {
	    	yearMon : yearMon,
	    	locId : locId
	    }
	$('#gridDay').datagrid('query', {
		pJson : JSON.stringify(pJson)
    });
    if(index && field){
	     /* ˢ��֮�����ϴѡ������ */
		setTimeout(function(){ REP_COM.OPERATE.SelectCell('gridDay', index, field)}, 200)    
    }
}

function QueryDayRep(day){
	REP_COM.OPERATE.ClearGridAllDetail();
	if(!day) return;
	var yearMon = $('#yearMon').phamonthbox('getValue') || '';
	if(!yearMon) return;
	var date = yearMon + '-' +day;
	var locId = $('#locId').combobox('getValue')
	var pJson = {
	    	date  : date,
	    	locId : locId
	    }
	$('#gridRep').datagrid('query', {
        pJson : JSON.stringify(pJson)
    });
}

// �����������ձ�
function CreateDayRepByDay(){
	var selectCell = $('#gridDay').datagrid('getSelectedCells');
	
	if ((selectCell.length == 0) || (!SELECTDAY)){
		PHA.Msg('alert','��ѡ��һ�����ڣ�')
		return;
	}
	var yearMon = $('#yearMon').phamonthbox('getValue') || '';
	if(!yearMon) return;
	var date = yearMon + '-' + SELECTDAY;
	var locId = $('#locId').combobox('getValue'); 
	
    var field = selectCell[0].field
    var index = selectCell[0].index
	
	var	pJson = {
		locId	: locId,
		date 	: date,
		repType : REPTYPE,
		userId 	: session['LOGON.USERID']
	}
	PHA.Loading("Show");
	PHA.CM(
        {
            pClassName : 'PHA.IN.REP.Api',  
            pMethodName: 'CreateDayRepByDay',
            pJson	   : JSON.stringify(pJson),
        },
        function (retData) {
			if (PHA.Ret(retData)) {
				PHA.Loading("Hide");
		        QueryDays("", index, field);
		        QueryDayRep(SELECTDAY);
			}
        }
	)
	PHA.Loading("Hide");
}

// ���·������±�
function CreateDayRepByMon(){
	var yearMon = $('#yearMon').phamonthbox('getValue') || '';
	if(!yearMon) {
		PHA.Msg('alert','��ѡ��һ���·ݣ�')
		return;
	}
	var locId = $('#locId').combobox('getValue'); 
	
	var	pJson = {
		locId	: locId,
		yearMon : yearMon,
		repType : REPTYPE,
		userId 	: session['LOGON.USERID']
	}
	PHA.Loading("Show");
	var retData = PHA.CM(
        {
            pClassName : 'PHA.IN.REP.Api',  
            pMethodName: 'CreateDayRepByMon',
            pJson	   : JSON.stringify(pJson),
        },
        false
    )
	if (PHA.Ret(retData)) {
	}
	QueryDays();
	PHA.Loading("Hide");
    
}

// ����ȷ��
function AuditDif(){
	var ret = REP_COM.FUNCTION.AuditDif();
	if (!ret) return;
	QueryDayRep(SELECTDAY);
	UpdateDay();
	REP_COM.FUNCTION.QueryRepOperate();
	/* ����ȷ�Ϻ��Զ����ɱ���ʣ���±� */
	var yearMon = $('#yearMon').phamonthbox('getValue') || '';
	if(!yearMon) return;
	var date = yearMon + '-' + SELECTDAY;
	var retData = PHA.CM(
		{
			pClassName: 'PHA.IN.REP.Api',
			pMethodName: 'IsMonLastDate',
			pJson: JSON.stringify({ 'date': date }),
		}, false
	);
	if (!retData.isMonLastDate) {
		PHA.Confirm('��ʾ', '�Ƿ����ɱ���ʣ���ձ�', function () {
			CreateDayRepByMon();
	    });
	}
}

// ����
function CancelRep(){
	var ret = REP_COM.FUNCTION.Cancel();
	if (!ret) return;
	QueryDayRep(SELECTDAY);
	UpdateDay();
	REP_COM.FUNCTION.QueryRepOperate();
}

function UpdateDay(){
	var date = GetDate();
	if (!date) return;
	var locId = $('#locId').combobox('getValue')
	var	pJson = {
		locId	: locId,
		date 	: date
	}
	PHA.CM(
        {
            pClassName : 'PHA.IN.REP.Api',  
            pMethodName: 'GetStatusByDate',
            pJson	   : JSON.stringify(pJson),
        },
        function (retData) {
	        UpdateDayStatus(retData);
        }
    )    
}

function UpdateDayStatus(status){
	var selectCell = $('#gridDay').datagrid('getSelectedCells')
    if(selectCell.length == 0) return;
    var field = selectCell[0].field
    var index = selectCell[0].index
    var row = {}
    row[field] = SELECTDAY + '-' + status.data
    $('#gridDay').datagrid('updateRow', {
        index: index,
        row: row
    });	
    REP_COM.OPERATE.SelectCell('gridDay', index, field)
}

function GetDate(){
	var yearMon = $('#yearMon').phamonthbox('getValue') || '';
	if(!yearMon) return '';
	var date = yearMon + '-' + SELECTDAY;
	return date;
}

function Refresh(){
	REP_COM.FUNCTION.QueryRepDetail();
}

/// ����Ƿ��в������ݣ���ת���������
function DifPrompt() {
	var locId = $('#locId').combobox('getValue'); 
	var	pJson = {
		locId	: locId,
	}
	var retData = PHA.CM(
		{
			pClassName: 'PHA.IN.REP.Api',
			pMethodName: 'GetLastDifRep4Day',
			pJson: JSON.stringify(pJson),
		}, false
	);
	if (retData.lastDifDate != "") {
		var lastDifDate = retData.lastDifDate;
		PHA.Msg('info', lastDifDate + ' �ձ�����δȷ��');
		var dateArr = lastDifDate.split('-');
		$('#yearMon').phamonthbox('setValue', dateArr[0] + '-' + dateArr[1]);  
		QueryDays();
	}

}