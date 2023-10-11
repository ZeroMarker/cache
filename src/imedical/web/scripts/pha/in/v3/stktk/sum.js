/*
*Creator		zhaozhiduan
*CreatDate		20222-04-26
*Description 	库存实盘录入汇总
*
*/
var APP_NAME = "DHCSTINSTKTK"
var APP_PROP = PHA_COM.ParamProp(APP_NAME)
var BUIS_CODE = "STKTK";
var BUIS_RANGE = "SUM";
$(function(){
	InitDict();             // 初始化条件字典
    InitBtn();              // 初始化按钮
    InitGridStktkMain();
	InitGridStktkInci();
	InitGridInciFreDetail();
	InitGridInciCountDetail();
    InitDefVal();
    SetRequired();
    setTimeout(function () {
        PHA_COM.ResizePanel({
            layoutId: 'layout-stktk-sum',
            region: 'west',
            width: 0.25
        });
    }, 0);
})
function SetRequired(){
	PHA.SetRequired($('#gridStktkMainBar' + ' [data-pha]'))
}
function InitDict(){
	//药房科室
    PHA_UX.ComboBox.Loc('stktkLocId');
    
}
function InitDefVal(){
    $("#stDate").datebox("setValue",APP_PROP.DefStartDate) ;
    $("#endDate").datebox("setValue",APP_PROP.DefEndDate) ;
}
function InitBtn(){
	PHA_EVENT.Bind('#btnFind', 		'click', 	function () {QueryMain();});
    PHA_EVENT.Bind('#btnComplete', 	'click', 	function () {CompleteSum();});
    PHA_EVENT.Bind('#btnCanCelComp','click', 	function () {CancelCompSum();});
    PHA_EVENT.Bind('#btnExport',	'click', 	function () {Export();});
}
function InitGridStktkMain(){
	    var columns = [
        [
            { field: 'stktkId',		title: '单据id',	align: 'left',	width: 80,	hidden: true  },
            { field: 'stktkNo',		title: '单号',		align: 'left',	width: 160 },
            { field: 'stktkLocId',  title: '科室id',	align: 'left',	width: 100,	hidden: true  },
            { field: 'stktkLocDesc',title: '科室',		align: 'left',	width: 100 },
            { field: 'stktkDate',   title: '制单日期',  align: 'left',	width: 100 },
            { field: 'stktkTime',   title: '制单时间',  align: 'left',	width: 100 },
            //{ field: 'stkGrpId',  	title: '类组',		align: 'left',	width: 100,	hidden: true   },
            //{ field: 'stkGrpDesc',  title: '类组',		align: 'left',	width: 100 },
            { field: 'curStatus',   title: '状态',		align: 'left',	width: 80 },
            { field: 'curPbDate',   title: '状态操作日期',	align: 'left',	width: 100 },
            { field: 'curPbTime',   title: '状态操作时间',	align: 'left',	width: 80 },
            { field: 'curPbUser', 	title: '状态操作人',	align: 'left',	width: 100 },
            { field: 'stkCatDesc',  title: '库存分类',	align: 'left',	width: 100 },
            { field: 'noUseDesc',  	title: '品种',		align: 'left',	width: 100 },
            { field: 'manGrpDesc',  title: '盘点组',	align: 'left',	width: 100 },
            { field: 'selManGrpDesc',title: '是/否盘点组',	align: 'left',	width: 100 },
            { field: 'manDrgDesc',	title: '管理药',	align: 'left',	width: 100 },
            { field: 'stkBinDesc',  title: '货位',  	align: 'right',	width: 100 },
            { field: 'inputType',	title: '盘点方式',  align: 'right',	width: 100 ,
                formatter: function (value, rowData, index) {
                    if(value==1){
                        return $g("按批次");
                    }else if(value==2){
                        return $g("按品种");
                    }else if(value==5){
                        return $g("<font color=blue>移动端:</font>按品种");
                    }else if(value==6){
                        return $g("<font color=blue>移动端:</font>按批次");
                    }else{
                        return "";
                    }		
                }
            },
            { field: 'newStatusInfo',title: '最新流转信息',	align: 'left',	width: 200 }
        ]
    ];
    var dataGridOption = {
        fit: true,
        rownumbers: true,
        pagination: false,
        toolbar: '#gridStktkMainBar',
        exportXls: false,
        columns: columns,
        onSelect: function(rowIndex, rowData) {
	        QueryStktkInci();
        },
        onLoadSuccess: function (data) {
            $('#gridStktkInci').datagrid('clear');
            $('#gridInciFreDetail').datagrid('clear');
            $('#gridInciCountDetail').datagrid('clear');
            if(data.total>0){
                $('#gridStktkMain').datagrid("selectRow",0);
            }
        }
    };
    PHA.Grid('gridStktkMain', dataGridOption);

}
function InitGridStktkInci(){
	var gridId = 'gridStktkInci'
    var columns = [
        [
            { field: 'spec', 		title: '规格', 				align: 'left', 	width: 80 },
            { field: 'stkbinDesc', 	title: '货位', 				align: 'left', 	width: 80 },
            { field: 'freQty', 		title: '账盘数量',			align: 'right',	width: 100 },
            { field: 'countQty', 	title: '实盘数量',			align: 'right',	width: 100 },
            { field: 'difQty',		title: '差异数量', 			align: 'right',	width: 100 ,
                styler:function(value, row, index){
                    var bDifQty = row.bDifQty || "";
                    if (bDifQty > 0){
                        return  {class:'pha-datagrid-difqty-positive'}; 
                    }else if(bDifQty < 0){
                        return  {class:'pha-datagrid-difqty-negative'}; 
                    }else{
                        //return 'background:white;'; 
                    }
                   
                }
            },
            { field: 'freRpAmt', 	title: '账盘进价金额',		align: 'right',	width: 100 },
            { field: 'freSpAmt', 	title: '账盘售价金额',		align: 'right',	width: 100 },
            { field: 'countRpAmt', 	title: '实盘进价金额',		align: 'right',	width: 100 },
            { field: 'countSpAmt', 	title: '实盘售价金额',		align: 'right',	width: 100 },
            { field: 'difRpAmt', 	title: '进价金额差异',		align: 'right',	width: 100 },
            { field: 'difSpAmt', 	title: '售价金额差异',		align: 'right',	width: 100 },
            { field: 'manfDesc', 	title: '生产企业',			align: 'left',	width: 200 },
            { field: 'insuCode', 	title: '国家医保编码', 		align: 'left',	width: 100 },
            { field: 'insuName', 	title: '国家医保名称', 		align: 'left',	width: 100 },
            { field: 'bDifQty',		title: '差异数量(基本)', 	align: 'right',	width: 100 , hidden: true }
        ]
    ];
    var frozenColumns = [
        [
        	{ field: 'stktkId',     title: 'stktkId', 			align: 'left',	width: 100, hidden: true },
        	{ field: 'inci',       	title: 'inci', 				align: 'left',	width: 100, hidden: true },
            { field: 'inciCode',    title: '代码', 				align: 'left',	width: 100, sortable: true},
            { field: 'inciDesc',    title: '名称',  			align: 'left',  width: 200, sortable: true}
        ]
    ];

    var dataGridOption = {
	    bodyCls:'table-splitline',
        fit: true,
        url: PHA.$URL,
        rownumbers: true,
        pageNumber:1,
		pageSize: 100,
        pageList: [100,300, 500, 1000], // 100起
        pagination: true,
        loadFilter:PHA.LocalFilter,
        toolbar: [],  //'#gridStktkDetailBar',
        columns: columns,
        exportXls: false,
        frozenColumns: frozenColumns,        
        onSelect: function(rowIndex, rowData) {
	        QueryInciFreDetail();
	        QueryInciCountDetail();
        },
        onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
            $('#gridInciFreDetail').datagrid('clear');
            $('#gridInciCountDetail').datagrid('clear');
            CalcAmt();
        },
        showFooter: true
        /*,
		rowStyler: function(index,row){
			var bDifQty = row.bDifQty || "";
			if (bDifQty > 0){
				return 'background:#77FFCC;'; 
			}else if(bDifQty < 0){
				return 'background:#FE9EA6;'; 
			}else{
				//return 'background:white;'; 
			}
		}*/
    };
    PHA.Grid(gridId, dataGridOption);
}
function InitGridInciFreDetail(){
	var gridId = 'gridInciFreDetail'
    var columns = [
        [
        	{ field: 'batNo', 		title: '批号', 				align: 'left', 	width: 80 },
            { field: 'expDate', 	title: '效期', 				align: 'left', 	width: 80 },
            { field: 'uomDesc',		title: '单位',				align: 'left',	width: 80 },
            { field: 'freQty',		title: '账盘数量', 			align: 'right',	width: 80 },
            { field: 'countQty',	title: '实盘数量', 			align: 'right',	width: 80 },
            { field: 'difQty',		title: '差异数量', 			align: 'right',	width: 80 , hidden: true},
      ]
    ];
    var dataGridOption = {
        fit: true,
        rownumbers: true,
        pagination: false,
        toolbar: [],  //'#gridStktkDetailBar',
        columns: columns,
        exportXls: false,
        gridSave: false,
		rowStyler: function(index,row){
			var difQty = row.difQty || "";
			if (difQty > 0){
				return {class:'pha-datagrid-difqty-positive'} ;
			}else if(difQty < 0){
				return {class:'pha-datagrid-difqty-negative'} ; 
			}
		}
    };
    PHA.Grid(gridId, dataGridOption);
}
function InitGridInciCountDetail(){
	var gridId = 'gridInciCountDetail'
    var columns = [
        [
            { field: 'batNo', 		title: '批号', 				align: 'left', 	width: 80 },
            { field: 'expDate', 	title: '效期', 				align: 'left', 	width: 80 },
            { field: 'uomDesc',		title: '单位',				align: 'right',	width: 80 },
            { field: 'countQty',	title: '实盘数量', 			align: 'left',	width: 80 },
            { field: 'countDate', 	title: '实盘日期',			align: 'right',	width: 80 },
            { field: 'countTime', 	title: '实盘时间',			align: 'right',	width: 80 },
            { field: 'countUser', 	title: '实盘人',			align: 'right',	width: 80 }
        ]
    ];
    var dataGridOption = {
	    bodyCls:'table-splitline',
        fit: true,
        rownumbers: true,
        pagination: false,
        toolbar: [],  //'#gridStktkDetailBar',
        columns: columns,
        exportXls: false,
       
        gridSave: false
    };
    PHA.Grid(gridId, dataGridOption);
}
function QueryMain(){
    var retJson = PHA.GetVals(["stDate","endDate","stktkLocId"],"Json");
	if(retJson[0] == undefined) {return;}
    var $grid = $("#gridStktkMain");
	var stDate = $("#stDate").datebox("getValue") || ""; 
    var endDate = $("#endDate").datebox("getValue") || "";
    var locId = $("#stktkLocId").combobox("getValue") || "";  
    var stktkStatus = BUIS_RANGE; 
    var execFlag = $("#execFlag").checkbox("getValue") || "" ; 
    if(execFlag == true){execFlag = "Y"}
    else{ execFlag = "N"}
    var pJson = {};
    pJson.stDate = stDate;  
    pJson.endDate = endDate;
    pJson.locId = locId;
    pJson.stktkStatus = stktkStatus;
    pJson.execFlag = execFlag
    $grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.IN.STKTK.Api' ,
        pMethodName:'GetStktkMainList',
        pPlug:'datagrid', 
        pJson: JSON.stringify(pJson)
    }); 
}
function QueryStktkInci(){
    var $grid = $("#gridStktkInci");
	var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info","请选择盘点单据！")
		return
	}
    var stktkId = Selected.stktkId;
    var pJson = {};
    pJson.stktkId = stktkId;  
    PHA.CM({
            pClassName: 'PHA.IN.STKTK.Api',
            pMethodName: 'GetStktkInciData',
            pPlug:'datagrid',
            pJson: JSON.stringify(pJson)
        },function(gridData){
            $grid.datagrid('loadData', gridData);
        }
    );
}
function QueryInciFreDetail(){
    var $grid = $("#gridInciFreDetail");
	var Selected = $("#gridStktkInci").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", "请选择盘点单药品！")
		return
	}
    var stktkId = Selected.stktkId;
    var inci = Selected.inci;
    var pJson = {};
    pJson.stktkId = stktkId;  
    pJson.inci = inci;  
    PHA.CM({
            pClassName: 'PHA.IN.STKTK.Api',
            pMethodName: 'QueryInciFreDetail',
            pPlug:'datagrid',
            pJson: JSON.stringify(pJson)
        },function(gridData){
            $grid.datagrid('loadData', gridData);
        }
    );
}
function QueryInciCountDetail(){
    var $grid = $("#gridInciCountDetail");
	var Selected = $("#gridStktkInci").datagrid("getSelected") || "";
    if(Selected == ""){
		return
	}
    var stktkId = Selected.stktkId;
    var inci = Selected.inci;
    var pJson = {};
    pJson.stktkId = stktkId;  
    pJson.inci = inci;  
    PHA.CM({
        pClassName: 'PHA.IN.STKTK.Api',
        pMethodName: 'QueryInciCountDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    },function(gridData){
        $grid.datagrid('loadData', gridData);
    }
);
}
function CompleteSum(){
	var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", "请选择盘点单据！")
		return
	}
    var stktkId = Selected.stktkId;
    var inputSelFlag =  $('input[name="inputSelFlag"]:checked').val() || '';

    PHA.BizPrompt({ title: '提醒' }, function (promptRet) {
        if (promptRet !== undefined) {
            var pJson = {};
            pJson.stktkId = stktkId;
            pJson.userId = session['LOGON.USERID'];  
            pJson.inputSelFlag = inputSelFlag;
            pJson.remark = promptRet;
            PHA.Loading('Show');
            PHA.CM({
                pClassName: 'PHA.IN.STKTK.Api',
                pMethodName: 'CompleteSum',
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
function CancelCompSum(){
	var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){
		PHA.Msg("info", "请选择盘点单据！")
		return
	}
    var stktkId = Selected.stktkId;

    PHA.BizPrompt({ title: '提醒' }, function (promptRet) {
        if (promptRet !== undefined) {
            var pJson = {
                stktkId : stktkId,
                userId : session['LOGON.USERID'],
                remark : promptRet
            };
            PHA.Loading('Show');
            PHA.CM({
                pClassName: 'PHA.IN.STKTK.Api',
                pMethodName: 'CancelCompSum',
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
function Export(){
    var $grid = $("#gridStktkInci");
    var rows = $grid.datagrid('getRows');
    if (rows.length ==0) {
        PHA_COM._Alert( "明细没有数据！");
        return false;
    }
	PHA_COM.ExportGrid("gridStktkInci")
}
function CalcAmt(){
    PHA_COM.SumGridFooter('#gridStktkInci' , ['freRpAmt', 'freSpAmt','countRpAmt','countSpAmt','difRpAmt','difSpAmt']);
}