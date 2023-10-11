/**
 * ģ��:     �����걨-�±�
 * ��д����: 2022-05-19
 * ��д��:   yangsj
 */

var REPTYPE = 'M';
var SelectMon   = ""
$(function () {
    InitDict();				//��ʼ���ֵ�
    InitGrid();				//��ʼ��grid
    BindBtnEvent();
    SetDefault();			//����Ĭ��ֵ
});

function BindBtnEvent(){
	PHA_EVENT.Bind('#btnCreateMonRep', 'click', function(){CreateMonRep();});
	PHA.BindBtnEvent('#gridRepBar');
}

function InitDict(){
	$(".icon-help").popover({title:'��ʾ',width:"400",content:"�±����ձ��������뱣֤�ձ�������ȷ�������±���"});
	
	/* ҩ������  */
    PHA_UX.ComboBox.Loc('locId', {
	    width: 140,
	    onSelect: function(e,val){
			QueryMons();
	    }
	});
}

function SetDefault(){
	//����Ĭ�ϵ�½����
	$('#locId').combobox('setValue', session['LOGON.CTLOCID']);
	
	//��ʼ����ݷ�������
	var myDate=new Date();
	var year = myDate.getFullYear();
	$('#year').val(year) ;
	QueryMons();
}

function InitGrid(){
	InitGridMon();
	InitGridMonRep();
	REP_COM.INITGRID.InitComGrid();
}

function InitGridMon(){
   var columns = [
        [
        	// mon,State,Wednesday,Thursday,Friday,Saturday,Sunday
            { field: 'mon', 		title: '�·�', align: 'center', width: 90,	},  
            { field: 'status', 		title: '״̬', align: 'center', width: 100,	styler:REP_COM.FORMATTER.AllStateStyler,	formatter:REP_COM.FORMATTER.AllStateFormatter}
        ]
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : 'PHA.IN.REP.Api',
            pMethodName: 'QueryMons',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        idField: 'mon',
        gridSave:false,
        columns: columns,
        toolbar: '#gridMonBar',
        exportXls: false,
        pagination: false,
        onClickRow: function (rowIndex, rowData) {
	        var mon = rowData.mon
	        var status = rowData.status
	        if(mon){
				QueryMonRep();
				SetDate(mon, status);
			}
			
		},
        onDblClickRow: function (rowIndex, rowData) {},
        onClickCell: function (index, field, value) {},
    };
    PHA.Grid('gridMon', dataGridOption);
}

function InitGridMonRep(){
   var columns = [
        [
        	// SMRID,YearMon,UseState,DifState,FrDate,ToDate
        	{ field: 'repId', 		title: 'repId', 	align: 'center', width: 80 	,hidden:true},
        	{ field: 'repType', 	title: 'repType', 	align: 'center', width: 80 	,hidden:true},
        	{ field: 'yearMon', 	title: '�±��·�', 	align: 'center', width: 80 	},
            { field: 'useStatus', 	title: 'ʹ��״̬', 	align: 'center', width: 80 	,styler:REP_COM.FORMATTER.AllStateStyler,	formatter:REP_COM.FORMATTER.AllStateFormatter},
            { field: 'difStatus', 	title: '����״̬', 	align: 'center', width: 70 	,styler:REP_COM.FORMATTER.DifStateStyler,	formatter:REP_COM.FORMATTER.DifStateFormatter},
            { field: 'startDate', 	title: '��ʼ��', 	align: 'center', width: 100 },
            { field: 'endDate', 	title: '������', 	align: 'center', width: 100 },
        ],
    ];
    var dataGridOption = {
        url: PHA.$URL,
        gridSave: false,
        queryParams: {
            pClassName : 'PHA.IN.REP.Api',
            pMethodName: 'QueryMonRep',
            pPlug	   : 'datagrid',
            pJson      : '{}',
        },
        gridSave:false,
        columns: columns,
        fitColumns: true,
        toolbar: '#gridRepBar',
        exportXls: false,
        pagination: false,
        onClickRow: function (rowIndex, rowData) {
	        if (rowData) {
		        var SMRID = rowData.SMRID
                REP_COM.FUNCTION.QueryRepDetail();
                REP_COM.FUNCTION.QueryRepOperate();
            }
        },
        onDblClickRow: function (rowIndex, rowData) {
        },
    };
    PHA.Grid('gridRep', dataGridOption);
}

function onSelect(){
	QueryMons();
}

function QueryMons(){
	REP_COM.OPERATE.ClearGridAllDetail();
	var year = $('#year').val() || '';
	
	var dataJson = PHA.DomData('#gridMonBar', {
        doType: 'query',
        retType: 'Json'
    });
	var pJson = dataJson[0];
	
	$('#gridMon').datagrid('query', {
        pJson : JSON.stringify(pJson)
    });
}

function QueryMonRep(){
	REP_COM.OPERATE.ClearGridAllDetail();
	var mon = GetMon();
    if (!mon) {
		PHA.Msg("alert","��ѡ��һ���·ݣ�")
		return;
	}
	var year = $('#year').val() || '';
	var locId = $('#locId').combobox('getValue')
   	var pJson = {
	   	year  : year,
    	mon   : mon,
    	locId : locId
    }
	$('#gridRep').datagrid('query', {
        pJson : JSON.stringify(pJson)
    });
}

function GetMon(){
	var gridSelect = $('#gridMon').datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.mon;
    return "";
}

function CreateMonRep(){
	var year = $('#year').val();
	if (!year){
		PHA.Msg("alert","��ѡ��һ����ݣ�")
		return;
	}
	var gridSelect = $('#gridMon').datagrid('getSelected') || '';
    var mon = '';
    if (gridSelect) mon = gridSelect.mon;
    if (!mon){
		PHA.Msg("alert","��ѡ��һ���·ݣ�")
		return;
	}
	var locId = $('#locId').combobox('getValue'); 
	if (!locId){
		PHA.Msg("alert", "��ѡ��һ�����ң�")
		return;
	}
	var startDate = $('#startDate').datebox('getValue') || '';
	var endDate = $('#endDate').datebox('getValue') || '';
	if(!startDate||!endDate){
		PHA.Msg("alert","��ʼ������ղ���Ϊ�գ�")
		return;
	}
	var	pJson = {
		repType   : REPTYPE,
		locId	  : locId,
		year 	  : year,
		mon 	  : mon,
		userId 	  : session['LOGON.USERID'],
		startDate : startDate,
		endDate   : endDate
	}
	PHA.CM(
        {
            pClassName : 'PHA.IN.REP.Api',  
            pMethodName: 'CreateMonRep',
            pJson	   : JSON.stringify(pJson),
        },
        function (retData) {
	        if (PHA.Ret(retData)) {
		        QueryMons();
			}
        }
    )
}

// ����ȷ��
function AuditDif(){
	var ret = REP_COM.FUNCTION.AuditDif();
	if (!ret) return;
	QueryMonRep();
    QueryMons();
    REP_COM.FUNCTION.QueryRepOperate();
}

function CancelRep(){
	var ret = REP_COM.FUNCTION.Cancel();
	if (!ret) return;
	QueryMonRep();
    QueryMons();
    REP_COM.FUNCTION.QueryRepOperate();
}

/// �ϸ���
function YearDown(){
	YearMove(-1)
}

/// �¸���
function YearUp(){
	YearMove(1)
}

function YearMove(num){
	var year = $('#year').val() || '';
	if(!year) {
		//��ʼ���·�������
		var myDate=new Date();
		var year = myDate.getFullYear();
		num = 0
	}
	year = parseInt(year)
	year = year + num
	$('#year').val(year);
	QueryMons();
}

function SetDate(mon,State){
	var year = $('#year').val() || '';
	var locId = $('#locId').combobox('getValue')
	var	pJson = {
		locId : locId,
		year  : year,
		mon   : mon
	}
	PHA.CM(
        {
            pClassName : 'PHA.IN.REP.Api',  
            pMethodName: 'GetMonDateAndStatus',
            pJson	   : JSON.stringify(pJson),
        },
        function (retData) {
	        if(retData.msg != ''){
	            $('#startDate').datebox("clear")
	            $('#endDate').datebox("clear")
	            $('#startDate').datebox('disable')
				$('#endDate').datebox('disable')
            }
            else{
	            $('#endDate').datebox('enable')
	            $('#startDate').datebox('setValue',retData.startDate);
	            $('#endDate').datebox('setValue',retData.endDate);
	            if(retData.lastRepId != "") $('#startDate').datebox('disable')
	            else $('#startDate').datebox('enable')
            }
        }
    )
}

function Refresh(){
	REP_COM.FUNCTION.QueryRepDetail();
}