/*
/// Creator     zhaozhiduan
/// CreatDate   2022��03��11��
/// Description ��汨�����
*/
var APP_NAME = "DHCSTINSCRAP"
var APP_PROP  =  PHA_COM.ParamProp(APP_NAME)
var BUIS_CODE = "SCRAP";
var BUIS_RANGE = "AUDIT";

$(function(){
    InitDict();             // ��ʼ�������ֵ�
    InitGridScrapMain()
    InitGridScrapDetail()
    InitBtn();              // ��ʼ����ť
    InitEvent();            // ��ʼ���¼�
    SetRequired();
    setTimeout(function () {
        InitDefVal();
        PHA_COM.ResizePanel({
            layoutId: 'layout-scrap-audit',
            region: 'north',
            height: 0.5 
        });
    }, 0);
    
})
function SetRequired(){
	PHA.SetRequired($('#gridScrapMainBar' + ' [data-pha]'))
}
function InitBtn()
{
    PHA_EVENT.Bind('#btnFind', 		'click', function () {QueryMain();});
	PHA_EVENT.Bind('#btnClean', 	'click', function () {Clean();});
    PHA_EVENT.Bind('#btnAudit', 	'click', function () {Audit();});
    PHA_EVENT.Bind('#btnCancelAudit','click', function () {CancelAudit();});
    PHA_EVENT.Bind('#btnRefuseAudit','click', function () {RefuseAudit();});
	PHA_EVENT.Bind('#btnPrint', 	'click', function () {Print();});
}
function InitEvent(){}

function InitDict(){
    //ҩ������
    PHA_UX.ComboBox.Loc('scrapLoc');
	//����
	PHA_UX.ComboBox.StkCatGrp('stkGroup', {
        multiple:true,
		rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		qParams: {
			LocId: PHA_UX.Get('scrapLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	
     //��汨��ԭ��
    PHA.ComboBox('scrapRea', {
        url: PHA_IN_STORE.ReasonForScrap().url,
       
    });
    //ҵ������
    PHA.ComboBox('buisProcess', {
        url: PHA_IN_STORE.BusiProcess(BUIS_CODE, BUIS_RANGE).url,
        onLoadSuccess: function(data) {
			if(data.length > 0){
				var iData = data[0];
				$(this).combobox('setValue', iData["RowId"]);
			}
		}
    });
    PHA.ComboBox('statusResult', {
        panelHeight: 'auto',
        url: PHA_IN_STORE.BusiStatusResult().url,
        onLoadSuccess: function(data) {
			if(data.length > 0){
				var iData = data[0];
				$(this).combobox('setValue', iData["RowId"]);
			}
		}
    });
}
function InitDefVal(){
    $("#stDate").datebox("setValue",APP_PROP.DefStartDate) ;
    $("#endDate").datebox("setValue",APP_PROP.DefEndDate) ;
	var comboData=$("#buisProcess").combobox('getData');
	if(comboData.length > 0){
		$("#buisProcess").combobox('setValue', comboData[0].RowId);
	}
    comboData=$("#statusResult").combobox('getData');
	if(comboData.length > 0){
		$("#statusResult").combobox('setValue', comboData[0].RowId);
	}
}
function InitGridScrapMain(){
    var columns  =  [
        [
            { field: 'scrapId',       	title: '����id',	align: 'left',	width: 80,	hidden: true  },
            { field: 'scrapNo',       	title: '����',		align: 'left',	width: 160  ,
                styler: function(value,row,index){				
                    return {class:"pha-grid-link" };
                }
            },
            { field: 'scrapLoc',      	title: '����',		align: 'left',	width: 100,	hidden: true  },
            { field: 'scrapDate',     	title: '�Ƶ�����',	align: 'left',	width: 100 },
            { field: 'scrapTime',     	title: '�Ƶ�ʱ��',	align: 'left',	width: 100 },
            { field: 'scrapUserName',	title: '�Ƶ���',	align: 'left',	width: 100 },
            { field: 'curStatus',       title: '״̬',		align: 'left',	width: 80},
            { field: 'curPbDate',       title: '״̬��������',	align: 'left',	width: 100 },
            { field: 'curPbTime',       title: '״̬����ʱ��',	align: 'left',	width: 80 },
            { field: 'curPbUser', 	    title: '״̬������',	align: 'left',	width: 100 },
            { field: 'rpAmt',       	title: '���۽��',  align: 'right',	width: 100 ,
                formatter: function (value, rowData, index) {
                    return PHA_COM.Fmt.Grid.Number(value,"#0,000.00");
                }
            },
            { field: 'spAmt',       	title: '�ۼ۽��',  align: 'right',	width: 100 ,
                formatter: function (value, rowData, index) {
                    return PHA_COM.Fmt.Grid.Number(value,"#0,000.00");
                }
            },
            { field: 'reasonId',  		title: '����ԭ��',  align: 'left',	width: 100,	hidden: true   },
            { field: 'reasonDesc',  	title: '����ԭ��',  align: 'left',	width: 100 },
            { field: 'remarks',      	title: '��ע',		align: 'left',	width: 100 },
            { field: 'newStatusInfo',title: '������ת��Ϣ',	align: 'left',	width: 200 },
            { field: 'copyInfo',    title: '������',	align: 'left',	width: 120 }
        ]
    ];
    var dataGridOption = {
        gridSave: false,
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: '#gridScrapMainBar',
        exportXls: false,
        columns: columns,
        onSelect: function(rowIndex, rowData) {
            QueryDetail()
        },
        onLoadSuccess: function (data) {
            if(data.total>0){
                $('#gridScrapMain').datagrid("selectRow",0);
            }else{
	        	$('#gridScrapDetail').datagrid('clear');
	        }
            PHA_UX.BusiTimeLine({},{},"close")
        },
        onClickCell: function (index, field, value) {            
			if(field=="scrapNo"){
                var rowData = $('#gridScrapMain').datagrid('getData').rows[index];
                PHA_UX.BusiTimeLine({},{
                    busiCode:BUIS_CODE,
                    locId:$("#scrapLoc").combobox("getValue") || PHA_COM.Session.CTLOCID,
                    pointer:rowData.scrapId,
                    No:value
                });
            }else{
                PHA_UX.BusiTimeLine({},{},"close")
            }
        }
    };
    PHA.Grid('gridScrapMain', dataGridOption);
}
function InitGridScrapDetail(){
    var columns = [
        [
            { field: 'spec',        title: '���',			align: 'left',  width: 80 },
            { field: 'stkbinDesc',  title: '��λ',			align: 'left',  width: 80 },
            { field: 'qty',         title: '��������',		align: 'right', width: 100 },
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
            { field: 'scrapItmId',  title: 'scrapItmId',      align: 'left',  width: 100, hidden: true },
            { field: 'inciCode',    title: '����',			align: 'left',  width: 100, sortable: true},
            { field: 'inciDesc',    title: '����',			align: 'left',  width: 300, sortable: true}
        ]
    ]
    var dataGridOption = {
        gridSave: false,
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: [],
        exportXls: false,
        frozenColumns: frozenColumns,
        columns: columns,
        showFooter: true,
        onLoadSuccess: function (data) {
            PHA_COM.SumGridFooter('#gridScrapDetail' , ['rpAmt', 'spAmt']);
         }
        
    };
    PHA.Grid('gridScrapDetail', dataGridOption);

}
function Clean()
{
    PHA.DomData("#qCondition", {
        doType:'clear'
    })
    $('#gridScrapMain').datagrid('clear');
    $('#gridScrapDetail').datagrid('clear');
    $('#scrapLoc').combobox('setValue', PHA_COM.Session.CTLOCID);
    InitDefVal();
}
function Audit(){
	var Selected = $("#gridScrapMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", "��ѡ���𵥾ݺ���ˣ�")
		return
	}
    var scrapId = Selected.scrapId;
    var scrapStatus = $("#buisProcess").combobox("getValue")
    if(scrapStatus == ""){
		PHA.Msg("info", "��ѡ���𵥾ݵ�Ԥ��״̬��")
		return
	}
    PHA.BizPrompt({ title: '����' }, function (promptRet) {
        if (promptRet !== undefined) {
            var pJson = {}
            pJson.scrapId = scrapId;
            pJson.auditFlag = "Y";
            pJson.scrapStatus = scrapStatus;
            pJson.chkUserId = session['LOGON.USERID'];
            pJson.remark = promptRet;
            PHA.Loading('Show');
            PHA.CM({
                pClassName: 'PHA.IN.SCRAP.Api',
                pMethodName: 'Audit',
                pJson: JSON.stringify(pJson)
            },function(data) {
                PHA.Loading("Hide");
                if(PHA.Ret(data)){
                    QueryMain();;
                }
            },function(failRet){
                PHA_COM._Alert(failRet);
            }) 
        }
    })
}
function CancelAudit(){
	var Selected = $("#gridScrapMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", "��ѡ���𵥾ݺ�ȡ����ˣ�")
		return
	}
    var scrapId = Selected.scrapId;
    var scrapStatus = $("#buisProcess").combobox("getValue")
    if(scrapStatus == ""){
		PHA.Msg("info", "��ѡ���𵥾ݵ�Ԥ��״̬��")
		return
	}
	PHA.BizPrompt({ title: '����' }, function (promptRet) {
        if (promptRet !== undefined) {
	        var pJson = {
	            scrapId : scrapId,
                scrapStatus : scrapStatus,
                operUserId : session['LOGON.USERID'],
                remark : promptRet
            }
            PHA.Loading('Show');
            PHA.CM({
                pClassName: 'PHA.IN.SCRAP.Api',
                pMethodName: 'CancelAudit',
                pJson: JSON.stringify(pJson)
            },function(data) {
                PHA.Loading("Hide");
                if(PHA.Ret(data)){
                    QueryMain();
                }
            },function(failRet){
                PHA_COM._Alert(failRet);
            }) 
        }
    })
}
function RefuseAudit(){
	var Selected = $("#gridScrapMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", "��ѡ���𵥾ݺ���ˣ�")
		return
	}
    var scrapId = Selected.scrapId;
    var scrapStatus = $("#buisProcess").combobox("getValue")
    if(scrapStatus == ""){
		PHA.Msg("info", "��ѡ���𵥾ݵ�Ԥ��״̬��")
		return
	}
	PHA.BizPrompt({ title: '����' }, function (promptRet) {
        if (promptRet !== undefined) {
	        var pJson = {
	            scrapId : scrapId,
                auditFlag : "",
                scrapStatus : scrapStatus,
                operUserId : session['LOGON.USERID'],
                remark : promptRet
            }
            PHA.Loading('Show');
            PHA.CM({
                pClassName: 'PHA.IN.SCRAP.Api',
                pMethodName: 'RefuseAudit',
                pJson: JSON.stringify(pJson)
            },function(data) {
                PHA.Loading("Hide");
                if(PHA.Ret(data)){
                    QueryMain();
                }
            },function(failRet){
                PHA_COM._Alert(failRet);
            }) 
        }
    })
}

function Print(){
	var Selected = $("#gridScrapMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", "��ѡ���𵥾ݺ��ӡ��")
		return
	}
    var scrapId = Selected.scrapId;
	PrintScrap(scrapId);

}
function QueryMain(){
    var $grid = $("#gridScrapMain");
    var retJson = PHA.GetVals(["stDate","endDate","scrapLoc","buisProcess","statusResult"],"Json");
	if(retJson[0] == undefined) {return;}
    var stDate =  $("#stDate").datebox("getValue") || ""; 
    var endDate =  $("#endDate").datebox("getValue") || "";
    var locId =  $("#scrapLoc").combobox("getValue") || "";  
    var stkGroup = $("#stkGroup").combobox("getValues").join(",") || "";  
    var scrapRea =  $("#scrapRea").combobox("getValue") || "";  
    var scrapStatus = "";
    var nextStatus = $("#buisProcess").combobox("getValue");
    var nextStatusResult = $("#statusResult").combobox("getValue") || "";
    var pJson = {};
    pJson.stDate = stDate;  
    pJson.endDate = endDate;
    pJson.locId = locId;
    pJson.stkGroup = stkGroup;
    pJson.scrapRea = scrapRea;
    pJson.scrapStatus = scrapStatus;
    pJson.nextStatus = nextStatus;
    pJson.nextStatusResult = nextStatusResult;
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.IN.SCRAP.Api' ,
        pMethodName:'GetScrapMainList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    }); 
}
function QueryDetail(){
    var $grid = $("#gridScrapDetail");
    var Selected = $("#gridScrapMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var scrapId = Selected.scrapId;
    var pJson = {};
    pJson.scrapId = scrapId;  
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.IN.SCRAP.Api' ,
        pMethodName:'GetScrapDetail',
        pPlug:'datagrid', 
        pJson: JSON.stringify(pJson)
    });  
}