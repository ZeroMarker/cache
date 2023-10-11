/*
/// Creator     zhaozhiduan
/// CreatDate   2022年03月11日
/// Description 库存报损审核
*/
var APP_NAME = "DHCSTINSCRAP"
var APP_PROP  =  PHA_COM.ParamProp(APP_NAME)
var BUIS_CODE = "SCRAP";
var BUIS_RANGE = "ALL";
$(function(){
    InitDict();             // 初始化条件字典
    InitGridScrapMain()
    InitGridScrapDetail()
    InitBtn();              // 初始化按钮
    InitEvent();            // 初始化事件
    SetRequired();
    setTimeout(function () {
        InitDefVal();
         PHA_COM.ResizePanel({
            layoutId: 'layout-scrap-query',
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
	PHA_EVENT.Bind('#btnFind', 	'click', function () {QueryMain();});
	PHA_EVENT.Bind('#btnClean',	'click', function () {Clean();});
	PHA_EVENT.Bind('#btnPrint',	'click', function () {Print();});
}
function InitEvent(){}

function InitDict(){
    $("#stDate").datebox("setValue",APP_PROP.DefStartDate) ;
    $("#endDate").datebox("setValue",APP_PROP.DefEndDate) ;
    //药房科室
    PHA_UX.ComboBox.Loc('scrapLoc');
	//类组
	PHA_UX.ComboBox.StkCatGrp('stkGroup', {
        multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		qParams: {
			LocId: PHA_UX.Get('scrapLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	
     //库存报损原因
    PHA.ComboBox('scrapRea', {
        url: PHA_IN_STORE.ReasonForScrap().url,
       
    });
     //业务流程
     PHA.ComboBox('buisProcess', {
        multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
        url: PHA_IN_STORE.BusiProcess(BUIS_CODE, BUIS_RANGE).url
       
    });
}
function InitDefVal(){
    $("#stDate").datebox("setValue",APP_PROP.DefStartDate) ;
    $("#endDate").datebox("setValue",APP_PROP.DefEndDate) ;
	
    $("#buisProcess").combobox('setValues',"");
	
}
function InitGridScrapMain(){
    var columns  =  [
        [
            { field: 'scrapId',       	title: '单据id',	align: 'left',	width: 80,	hidden: true  },
            { field: 'scrapNo',       	title: '单号',		align: 'left',	width: 160  ,
                styler: function(value,row,index){				
                    return {class:"pha-grid-link" };
                }
            },
            { field: 'scrapLoc',      	title: '科室',		align: 'left',	width: 100,	hidden: true  },
            { field: 'scrapDate',     	title: '制单日期',	align: 'left',	width: 100 },
            { field: 'scrapTime',     	title: '制单时间',	align: 'left',	width: 100 },
            { field: 'scrapUserName',	title: '制单人',	align: 'left',	width: 100 },
            { field: 'curStatus',       title: '状态',		align: 'left',	width: 80},
            { field: 'curPbDate',       title: '状态操作日期',	align: 'left',	width: 100 },
            { field: 'curPbTime',       title: '状态操作时间',	align: 'left',	width: 80 },
            { field: 'curPbUser', 	    title: '状态操作人',	align: 'left',	width: 100 },
            { field: 'rpAmt',       	title: '进价金额',  align: 'right',	width: 100 ,
                formatter: function (value, rowData, index) {
                    return PHA_COM.Fmt.Grid.Number(value,"#0,000.00");
                }
            },
            { field: 'spAmt',       	title: '售价金额',  align: 'right',	width: 100 ,
                formatter: function (value, rowData, index) {
                    return PHA_COM.Fmt.Grid.Number(value,"#0,000.00");
                }
            },
            { field: 'reasonId',  		title: '报损原因',  align: 'left',	width: 100,	hidden: true   },
            { field: 'reasonDesc',  	title: '报损原因',  align: 'left',	width: 100 },
            { field: 'remarks',      	title: '备注',		align: 'left',	width: 100 },
            { field: 'newStatusInfo',title: '最新流转信息',	align: 'left',	width: 200 },
            { field: 'copyInfo',    title: '复制于',	align: 'left',	width: 120 }
        ]
    ];
    var dataGridOption = {
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
            { field: 'spec',        title: '规格',			align: 'left',  width: 80 },
            { field: 'stkbinDesc',  title: '货位',			align: 'left',  width: 80 },
            { field: 'qty',         title: '报损数量',		align: 'right', width: 100 },
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
            { field: 'inclb',       title: 'inclb',         align: 'left',  width: 100, hidden: true },
            { field: 'scrapItmId',  title: 'scrapItmId',    align: 'left',  width: 100, hidden: true },
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

function Print(){
	var Selected = $("#gridScrapMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", $g("请选择报损单据后打印！"))
		return
	}
    var scrapId = Selected.scrapId;
	PrintScrap(scrapId);

}
function QueryMain(){
    var $grid = $("#gridScrapMain");
    var retJson = PHA.GetVals(["stDate","endDate","scrapLoc"],"Json");
	if(retJson[0] == undefined) {return;}
    var stDate =  $("#stDate").datebox("getValue") || ""; 
    var endDate =  $("#endDate").datebox("getValue") || "";
    var locId =  $("#scrapLoc").combobox("getValue") || "";
    var stkGroup = $("#stkGroup").combobox("getValues").join(",") || "";  
    var scrapRea =  $("#scrapRea").combobox("getValue") || "";  
    var scrapStatus = $("#buisProcess").combobox("getValues").join(",");
    if(scrapStatus == ""){
		var comboData=$("#buisProcess").combobox('getData');
		for(var i = 0; i < comboData.length; i++){
			if(scrapStatus == "") {scrapStatus=comboData[i].RowId;}
			else{scrapStatus=scrapStatus + "," + comboData[i].RowId;}
		}
	} 
    var pJson = {};
    pJson.stDate = stDate;  
    pJson.endDate = endDate;
    pJson.locId = locId;
    pJson.stkGroup = stkGroup;
    pJson.scrapRea = scrapRea;
    pJson.scrapStatus = scrapStatus;
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
