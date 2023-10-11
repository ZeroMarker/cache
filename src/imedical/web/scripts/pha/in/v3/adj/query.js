/*
/// Creator     zhaozhiduan
/// CreatDate   2022��03��11��
/// Description ��������ѯ
*/
var APP_NAME = "DHCSTSTOCKADJ";
var APP_PROP  =  PHA_COM.ParamProp(APP_NAME);
var BUIS_CODE = "ADJ";
var BUIS_RANGE = "ALL";
$(function(){
    InitDict();             // ��ʼ�������ֵ�
    InitGridAdjMain()
    InitGridAdjDetail()
    InitBtn();              // ��ʼ����ť
    SetRequired();
    setTimeout(function () {
        InitDefVal();
		PHA_COM.ResizePanel({
		   layoutId: 'layout-adj-query',
		   region: 'north',
		   height: 0.5 
	   });
   }, 0);
   	
})
function SetRequired(){
	PHA.SetRequired($('#gridAdjMainBar' + ' [data-pha]'))
}
function InitBtn()
{
	PHA_EVENT.Bind('#btnFind', 	'click', function () {QueryMain();});
	PHA_EVENT.Bind('#btnClean', 'click', function () {Clean();});
	PHA_EVENT.Bind('#btnPrint', 'click', function () {Print();});
	
}
function InitDefVal()
{
    $("#stDate").datebox("setValue",APP_PROP.DefStartDate) ;
    $("#endDate").datebox("setValue",APP_PROP.DefEndDate) ;
    var comboData=$("#buisProcess").combobox('getData');
	if(comboData.length > 0){
		$("#buisProcess").combobox('setValues', "");
	}
}

function InitDict(){
   
    //ҩ������
    PHA_UX.ComboBox.Loc('adjLoc');
	//����
	PHA_UX.ComboBox.StkCatGrp('stkGroup', {
        panelHeight: 'auto',
        multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		qParams: {
			LocId: PHA_UX.Get('adjLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	
     //������ԭ��
    PHA.ComboBox('adjRea', {
        panelHeight: 'auto',
        url: PHA_IN_STORE.ReasonForAdj().url
    });
     //ҵ������
    PHA.ComboBox('buisProcess', {
        panelHeight: 'auto',
        multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
        url: PHA_IN_STORE.BusiProcess(BUIS_CODE, BUIS_RANGE).url
    });
	
}

function InitGridAdjMain(){
    var columns  =  [
        [
            { field: 'adjId',       title: '����id',	align: 'left',	width: 80,	hidden: true  },
            { field: 'adjNo',       title: '����',		align: 'left',	width: 160 ,
                styler: function(value,row,index){				
                    return {class:"pha-grid-link" };
                }
            },
            { field: 'adjLoc',      title: '����',		align: 'left',	width: 100,	hidden: true  },
            { field: 'adjDate',     title: '�Ƶ�����',  align: 'left',	width: 90 },
            { field: 'adjTime',     title: '�Ƶ�ʱ��',  align: 'left',	width: 80 },
            { field: 'adjUserName', title: '�Ƶ���',  	align: 'left',	width: 100 },
            { field: 'curStatus',   title: '״̬',		align: 'left',	width: 80 },
            { field: 'curPbDate',   title: '״̬��������',	align: 'left',	width: 90 },
            { field: 'curPbTime',   title: '״̬����ʱ��',	align: 'left',	width: 80 },
            { field: 'curPbUser', 	title: '״̬������',	align: 'left',	width: 100 },
            { field: 'rpAmt',       title: '���۽��',  align: 'right',	width: 80 ,
                formatter: function (value, rowData, index) {
                    return PHA_COM.Fmt.Grid.Number(value,"#0,000.00");
                }
            },
            { field: 'spAmt',       title: '�ۼ۽��',  align: 'right',	width: 80 ,
                formatter: function (value, rowData, index) {
                    return PHA_COM.Fmt.Grid.Number(value,"#0,000.00");
                }
            },
            { field: 'reasonId',  	title: '����ԭ��',  align: 'left',	width: 100,	hidden: true   },
            { field: 'reasonDesc',  title: '����ԭ��',  align: 'left',	width: 100 },
            { field: 'remarks',      title: '��ע',		align: 'left',	width: 100 },
            { field: 'newStatusInfo',title: '������ת��Ϣ',	align: 'left',	width: 200 },
            { field: 'copyInfo',    title: '������',	align: 'left',	width: 120 }
        ]
    ];
    var dataGridOption = {
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: '#gridAdjMainBar',
        exportXls: false,
        columns: columns,
        onSelect: function(rowIndex, rowData) {
            
            QueryDetail();           
        },
        onLoadSuccess: function (data) {
            if(data.total>0){
                $('#gridAdjMain').datagrid("selectRow",0);
            }else{
	        	$('#gridAdjDetail').datagrid('clear');
	        }
            PHA_UX.BusiTimeLine({},{},"close")
        },
        onClickCell: function (index, field, value) {            
			if(field=="adjNo"){
                var rowData = $('#gridAdjMain').datagrid('getData').rows[index];
                if (rowData.instkDr !== ""){    // �̵����
                    PHA_UX.BusiTimeLine({},{
                        busiCode:"STKTK",
                        locId:$("#adjLoc").combobox("getValue") || PHA_COM.Session.CTLOCID,
                        pointer:rowData.instkDr,
                        No:value
                    });
                } else {
                    PHA_UX.BusiTimeLine({},{
                        busiCode:BUIS_CODE,
                        locId:$("#adjLoc").combobox("getValue") || PHA_COM.Session.CTLOCID,
                        pointer:rowData.adjId,
                        No:value
                    });
                }
            }else{
                PHA_UX.BusiTimeLine({},{},"close")
            }
        }
    };
    PHA.Grid('gridAdjMain', dataGridOption);
}
function InitGridAdjDetail(){
    var columns = [
        [
            { field: 'spec',        title: '���',			align: 'left',  width: 80 },
            { field: 'stkbinDesc',  title: '��λ',			align: 'left',  width: 80 },
            { field: 'qty',         title: '��������',		align: 'right', width: 100 },
            { field: 'resultQty', 	title: '��������',		align: 'right',	width: 100 },
            { field: 'uomDesc',     title: '��λ',			align: 'left',  width: 100 },
            { field: 'inclbQty',    title: '���ο��',		align: 'right', width: 100 },
            { field: 'batNo',       title: '����',			align: 'left',  width: 100 },
            { field: 'expDate',     title: 'Ч��',			align: 'left',  width: 100 },
            { field: 'rp',          title: '����',			align: 'right', width: 100 },
            { field: 'sp',          title: '�ۼ�',			align: 'right', width: 100 },
            { field: 'rpAmt',       title: '���۽��',		align: 'right', width: 100 },
            { field: 'spAmt',       title: '�ۼ۽��',		align: 'right', width: 100 },
            { field: 'manfDesc',    title: '������ҵ',      align: 'left',  width: 250 },
            { field: 'insuCode',    title: '����ҽ������',	align: 'left',  width: 100 },
            { field: 'insuName',    title: '����ҽ������',	align: 'left',  width: 100 }
        ]
    ];
    var frozenColumns = [
        [
            { field: 'inclb',       title: 'inclb',         align: 'left',  width: 100, hidden: true },
            { field: 'adjItmId',    title: 'adjItmId',      align: 'left',  width: 100, hidden: true },
            { field: 'inciCode',    title: '����',			align: 'left',  width: 100, sortable: true},
            { field: 'inciDesc',    title: '����',			align: 'left',  width: 300, sortable: true}
        ]
    ]
    var dataGridOption = {
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: [],
        exportXls: false,
        frozenColumns: frozenColumns,
        columns: columns,
        showFooter: true,
        onLoadSuccess: function (data) {
            PHA_COM.SumGridFooter('#gridAdjDetail' , ['rpAmt', 'spAmt']);
         }
    };
    PHA.Grid('gridAdjDetail', dataGridOption);

}
function Clean()
{
    PHA.DomData("#qCondition", {
        doType:'clear'
    })
    $('#gridAdjMain').datagrid('clear');
    $('#gridAdjDetail').datagrid('clear');
    $('#adjLoc').combobox('setValue', PHA_COM.Session.CTLOCID);
    InitDefVal();
    
}

function Print(){
	var Selected = $("#gridAdjMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", $g("��ѡ��������ݺ��ӡ��"))
		return
	}
    var adjId = Selected.adjId;
	PrintAdj(adjId);

}
function QueryMain(){
    var $grid = $("#gridAdjMain");
    var retJson = PHA.GetVals(["stDate","endDate","adjLoc"],"Json");
	if(retJson[0] == undefined) {return;}
    var stDate =  $("#stDate").datebox("getValue") || ""; 
    var endDate =  $("#endDate").datebox("getValue") || "";
    var locId =  $("#adjLoc").combobox("getValue") || "";
    var stkGroup = $("#stkGroup").combobox("getValues").join(",") || "";  
    var adjRea =  $("#adjRea").combobox("getValue") || "";  
    var adjStatus = $("#buisProcess").combobox("getValues").join(",");
    if(adjStatus == ""){
		var comboData=$("#buisProcess").combobox('getData');
		for(var i = 0; i < comboData.length; i++){
			if(adjStatus == "") {adjStatus=comboData[i].RowId;}
			else{adjStatus=adjStatus + "," + comboData[i].RowId;}
		}
	}
    var instFlag  =  "";
    var pJson = {};
    pJson.stDate = stDate;  
    pJson.endDate = endDate;
    pJson.locId = locId;
    pJson.stkGroup = stkGroup;
    pJson.adjRea = adjRea;
    pJson.adjStatus = adjStatus;
    pJson.instFlag = instFlag
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.IN.ADJ.Api' ,
        pMethodName:'GetAdjMainList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
function QueryDetail(){
    var $grid = $("#gridAdjDetail");
    var Selected = $("#gridAdjMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var adjId = Selected.adjId;
    var pJson = {};
    pJson.adjId = adjId;    
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.IN.ADJ.Api' ,
        pMethodName:'GetAdjDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    });    
}