/*
/// Creator     zhaozhiduan
/// CreatDate   2022年03月11日
/// Description 库存调整审核
*/
var APP_NAME = "DHCSTSTOCKADJ";
var APP_PROP  =  PHA_COM.ParamProp(APP_NAME);
var BUIS_CODE = "ADJ";
var BUIS_RANGE = "AUDIT";
$(function(){
    InitDict();             // 初始化条件字典
    InitGridAdjMain()
    InitGridAdjDetail()
    InitBtn();              // 初始化按钮
    SetRequired();
    setTimeout(function () {
        InitDefVal();
        PHA_COM.ResizePanel({
            layoutId: 'layout-adj-audit',
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
	PHA_EVENT.Bind('#btnFind', 			'click', function () {QueryMain();});
	PHA_EVENT.Bind('#btnClean', 		'click', function () {Clean();});
	PHA_EVENT.Bind('#btnAudit', 		'click', function () {Audit();});
	PHA_EVENT.Bind('#btnCancelAudit',	'click', function () {CancelAudit();});
    PHA_EVENT.Bind('#btnRefuseAudit',	'click', function () {RefuseAudit();});
	PHA_EVENT.Bind('#btnPrint', 		'click', function () {Print();});
}

function InitDict(){
    
    //药房科室
    PHA_UX.ComboBox.Loc('adjLoc');
	//类组
	PHA_UX.ComboBox.StkCatGrp('stkGroup', {
        panelHeight: 'auto',
        multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		qParams: {
			LocId: PHA_UX.Get('adjLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	
     //库存调整原因
    PHA.ComboBox('adjRea', {
        panelHeight: 'auto',
        maxHeight:100,
        url: PHA_IN_STORE.ReasonForAdj().url
    });
     //业务流程
    PHA.ComboBox('buisProcess', {
        panelHeight: 'auto',
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
function InitGridAdjMain(){
    var columns  =  [
        [
            { field: 'adjId',       title: '单据id',	align: 'left',	width: 80,	hidden: true  },
            { field: 'adjNo',       title: '单号',		align: 'left',	width: 160 ,
                styler: function(value,row,index){				
                    return {class:"pha-grid-link" };
                }
            },
            { field: 'adjLoc',      title: '科室',		align: 'left',	width: 100,	hidden: true  },
            { field: 'adjDate',     title: '制单日期',  align: 'left',	width: 80 },
            { field: 'adjTime',     title: '制单时间',  align: 'left',	width: 80 },
            { field: 'adjUserName', title: '制单人',  	align: 'left',	width: 100 },
            { field: 'curStatus',   title: '状态',		align: 'left',	width: 80 },
            { field: 'curPbDate',     title: '状态操作日期',	align: 'left',	width: 80 },
            { field: 'curPbTime',     title: '状态操作时间',	align: 'left',	width: 80 },
            { field: 'curPbUser', 	title: '状态操作人',	align: 'left',	width: 100 },
            { field: 'rpAmt',       title: '进价金额',  align: 'right',	width: 80 ,
                formatter: function (value, rowData, index) {
                    return PHA_COM.Fmt.Grid.Number(value,"#0,000.00");
                }
            },
            { field: 'spAmt',       title: '售价金额',  align: 'right',	width: 80 ,
                formatter: function (value, rowData, index) {
                    return PHA_COM.Fmt.Grid.Number(value,"#0,000.00");
                }
            },
            { field: 'reasonId',  	title: '调整原因',  align: 'left',	width: 100,	hidden: true   },
            { field: 'reasonDesc',  title: '调整原因',  align: 'left',	width: 100 },
            { field: 'remarks',      title: '备注',		align: 'left',	width: 100 },
            { field: 'newStatusInfo',title: '最新流转信息',	align: 'left',	width: 200 },
            { field: 'copyInfo',    title: '复制于',	align: 'left',	width: 120 }
        ]
    ];
    var dataGridOption = {
        gridSave: false,
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: '#gridAdjMainBar',
        exportXls: false,
        columns: columns,
        onSelect: function(rowIndex, rowData) {

            QueryDetail()
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
                PHA_UX.BusiTimeLine({},{
                    busiCode:BUIS_CODE,
                    locId:$("#adjLoc").combobox("getValue") || PHA_COM.Session.CTLOCID,
                    pointer:rowData.adjId,
                    No:value
                });
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
            { field: 'spec',        title: '规格',			align: 'left',  width: 80 },
            { field: 'stkbinDesc',  title: '货位',			align: 'left',  width: 80 },
            { field: 'qty',         title: '调整数量',		align: 'right', width: 100 },
            { field: 'resultQty', 	title: '调后数量',		align: 'right',	width: 100 },
            { field: 'uomDesc',     title: '单位',			align: 'left',  width: 100 },
            { field: 'inclbQty',    title: '批次库存',		align: 'right', width: 100 },
            { field: 'batNo',       title: '批号',			align: 'left',  width: 100 },
            { field: 'expDate',     title: '效期',			align: 'left',  width: 100 },
            { field: 'rp',          title: '进价',			align: 'right', width: 100 },
            { field: 'sp',          title: '售价',			align: 'right', width: 100 },
            { field: 'rpAmt',       title: '进价金额',		align: 'right', width: 100 },
            { field: 'spAmt',       title: '售价金额',		align: 'right', width: 100 },
            { field: 'manfDesc',    title: '生产企业',      align: 'left',  width: 250 },
            { field: 'insuCode',    title: '国家医保编码',	align: 'left',  width: 100 },
            { field: 'insuName',    title: '国家医保名称',	align: 'left',  width: 100 }
        ]
    ];
    var frozenColumns = [
        [
            { field: 'inclb',       title: 'inclb',         align: 'left',  width: 100 },
            { field: 'adjItmId',    title: 'adjItmId',      align: 'left',  width: 100, hidden: true },
            { field: 'inciCode',    title: '代码',			align: 'left',  width: 100, sortable: true},
            { field: 'inciDesc',    title: '名称',			align: 'left',  width: 300, sortable: true}
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
function Audit(){
	var Selected = $("#gridAdjMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", $g("请选择调整单据后审核！"))
		return
	}
    var adjId = Selected.adjId;
    var adjStatus = $("#buisProcess").combobox("getValue")
    if(adjStatus == ""){
		PHA.Msg("info", $g("请选择调整单据的预审状态！"))
		return
	}
    PHA.BizPrompt({ title: '提醒' }, function (promptRet) {
        if (promptRet !== undefined) {
            var pJson = {}
            pJson.adjId = adjId;
            pJson.auditFlag = "Y";
            pJson.adjStatus = adjStatus;
            pJson.chkUserId = session['LOGON.USERID'];
            pJson.remark = promptRet;   
            PHA.Loading('Show');         
            PHA.CM({
                pClassName: 'PHA.IN.ADJ.Api',
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
    });
}
function CancelAudit(){
	var Selected = $("#gridAdjMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", $g("请选择调整单据后取消审核！"))
		return
	}
    var adjId = Selected.adjId;
    var adjStatus = $("#buisProcess").combobox("getValue")
    if(adjStatus == ""){
		PHA.Msg("info", $g("请选择调整单据的预审状态！"))
		return
	}
    PHA.BizPrompt({ title: '提醒' }, function (promptRet) {
        if (promptRet !== undefined) {
            var pJson = {
                adjId :adjId,
                adjStatus : adjStatus,
                operUserId : session['LOGON.USERID'],
                remark: promptRet
            }
            PHA.Loading('Show');
            PHA.CM({
                pClassName: 'PHA.IN.ADJ.Api',
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
    });
}
function RefuseAudit(){
    var Selected = $("#gridAdjMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", $g("请选择调整单据后审核！"))
		return
	}
    var adjId = Selected.adjId;
    var adjStatus = $("#buisProcess").combobox("getValue")
    if(adjStatus == ""){
		PHA.Msg("info", $g("请选择调整单据的预审状态！"))
		return
	}
    PHA.BizPrompt({ title: '提醒' }, function (promptRet) {
        if (promptRet !== undefined) {
            var pJson = {
                adjId: adjId,
                adjStatus: adjStatus,
                userId:session['LOGON.USERID'],
                remark: promptRet
            };
            PHA.Loading('Show');
            PHA.CM({
                pClassName: 'PHA.IN.ADJ.Api',
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
    });
}
function Print(){
	var Selected = $("#gridAdjMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", $g("请选择调整单据后打印！"))
		return
	}
    var adjId = Selected.adjId;
	PrintAdj(adjId);

}
function QueryMain(){
    var $grid = $("#gridAdjMain");
    var retJson = PHA.GetVals(["stDate","endDate","adjLoc","buisProcess","statusResult"],"Json");
	if(retJson[0] == undefined) {return;}

    var stDate =  $("#stDate").datebox("getValue") || ""; 
    var endDate =  $("#endDate").datebox("getValue") || "";
    var locId =  $("#adjLoc").combobox("getValue") || "";  
    var stkGroup = $("#stkGroup").combobox("getValues").join(",") || "";  
    var adjRea =  $("#adjRea").combobox("getValue") || "";  
    var nextStatus = $("#buisProcess").combobox("getValue");
    var nextStatusResult = $("#statusResult").combobox("getValue") || "";
    var instFlag  =  "N";
    var pJson = {};
    pJson.stDate = stDate;  
    pJson.endDate = endDate;
    pJson.locId = locId;
    pJson.stkGroup = stkGroup;
    pJson.adjRea = adjRea;
    pJson.adjStatus = ""
    pJson.nextStatus = nextStatus;
    pJson.nextStatusResult = nextStatusResult;
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