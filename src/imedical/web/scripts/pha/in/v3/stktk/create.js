/*
/// Creator     zhaozhiduan
/// CreatDate   2022年03月11日
/// Description 库存盘点账盘
*/
var APP_NAME = "DHCSTINSTKTK"
var APP_PROP = PHA_COM.ParamProp(APP_NAME)
var BUIS_CODE = "STKTK"
var BUIS_RANGE = "CREATE";

var compoments = STKTK_COMPOMENTS;
$(function(){
    PHA_COM.SetPanel('#panel');
    InitDict();             // 初始化条件字典
    InitGridMStktkDetail();   // 初始化grid
    InitBtn();              // 初始化按钮
    // dialog 初始化
    InitGridStktkMain();
    InitGridStktkDetail();
    SetDisable();
    SetRequired();
    setTimeout(function () {
		PHA_COM.ResizePanel({
		   layoutId: 'layout-stktk-create-diag',
		   region: 'north',
		   height: 0.5 
	   });
   }, 0);
   InitConditionFold();
})

//条件折叠
function InitConditionFold()
{
	PHA.ToggleButton("moreorless", {
        buttonTextArr: ['更多', '隐藏'],
        selectedText: '更多',
        onClick: function(oldText, newText){
        }	
    });	

    $("#moreorless").popover({
        trigger: 'click',	
        placement: 'auto',
        content: 'content',
        dismissible: false,
        width: 900,
        padding: false,
        url: '#js-pha-moreorless'
    });
}

function SetRequired(){
	PHA.SetRequired($('#gridMStktkDetailBar' + ' [data-pha]'))
}
function InitBtn(){
	PHA_EVENT.Bind('#btnFind', 		'click', 	function () {ShowDiagStktk(this);});
	PHA_EVENT.Bind('#btnSave', 		'click', 	function () {SaveStktk();});
	PHA_EVENT.Bind('#btnClean', 	'click', 	function () {Clean();});
    PHA_EVENT.Bind('#btnPreStktk', 	'click', 	function () {QueryPreStktk();});
	PHA_EVENT.Bind('#btnComplete', 	'click', 	function () {Complete();});
    PHA_EVENT.Bind('#btnCancelComp','click', 	function () {CancelComplete();});
	PHA_EVENT.Bind('#btnPrint', 	'click', 	function () {Print();});
    PHA_EVENT.Bind('#btnDelete', 	'click', 	function () {Delete();});
    // dialog 按钮
    PHA_EVENT.Bind('#btnSearch', 	'click', 	function () {QueryMain();});
	PHA_EVENT.Bind('#btnClose', 	'click', 	function () {CloseDiag();});
    PHA_EVENT.Bind('#btnSelStktk', 	'click', 	function () {SelectStktk();});

    //打印弹框
    PHA_EVENT.Bind('#btnPrtStktk', 	'click', 	function () {PrtStktk();});
    PHA_EVENT.Bind('#btnCloseDiag', 'click', 	function () {ClosePrtDiag();});
}


function InitDict(){
	//药房科室
    PHA_UX.ComboBox.Loc('stktkLocId',{});
    
	//类组
	PHA_UX.ComboBox.StkCatGrp('stkGrpId', {
        multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		qParams: {
			LocId: PHA_UX.Get('stktkLocId', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	//库存分类
	PHA_UX.ComboBox.StkCat("stkCatId",{
        multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		qParams: {
			CatGrpId: PHA_UX.Get('stkGrpId')
		}
	});
	var locId = $("#stktkLocId").combobox("getValue") || PHA_COM.Session.CTLOCID
   
    // 科室盘点组
    PHA_UX.ComboBox.StkTkGrp('manGrpId', {
	    multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		qParams: {
			Loc: PHA_UX.Get('stktkLocId', session['LOGON.CTLOCID']),
		}
	});
     //开始货位
    PHA_UX.ComboBox.StkBinRacks('stkbinId', {
        multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
        qParams: {
            LocId: PHA_UX.Get('stktkLocId',session['LOGON.CTLOCID']) ,
        }
    });
    //管理药标志
    var comboData=[
    	{RowId:"",Description:$g("全部")},
		{RowId:"Y",Description:$g("仅管理药")},
    	{RowId:"N",Description:$g("非管理药")}
	];
	PHA.ComboBox('manDrgFlag', {
	    valueField:'RowId',
		textField:'Description',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
        data:comboData
    });
    //不可用药品
    var comboData=[
    	{RowId:"0",Description:$g("仅可用品种")},
		{RowId:"1",Description:$g("仅不可用品种")},
		{RowId:"2",Description:$g("包含不可用品种")}

	];
	PHA.ComboBox('noUseFlag', {
	    valueField:'RowId',
		textField:'Description',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
        data:comboData
    });
    //批次库存
    var comboData=[
    	{RowId:"",Description:$g("全部")},
		{RowId:"Y",Description:$g("非零批次")},
    	{RowId:"N",Description:$g("零批次")}
	];
	PHA.ComboBox('inclbQtyFlag', {
	    valueField:'RowId',
		textField:'Description',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
        data:comboData
    });
     //批次库存
    var comboData=[
    	{RowId:"Y",Description:$g("选中盘点组")},
		{RowId:"N",Description:$g("非选中盘点组")}
	];
	PHA.ComboBox('selManGrp', {
	    valueField:'RowId',
		textField:'Description',
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
        data:comboData
    });
    PHA.ComboBox('stktkStatus', {
	    valueField:'RowId',
		textField:'Description',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
        url: PHA_IN_STORE.BusiProcess(BUIS_CODE, BUIS_RANGE).url,
        onLoadSuccess: function(data) {
			if(data.length > 0){
				var iData = data[0];
				$(this).combobox('setValue', iData["RowId"]);
			}
		},

    });
    /* 信息展示框 */
	$('#infoArea').phabanner({
	    title: $g('选择单据后, 显示详细信息')
	});
    // dialog 药房科室
    //药房科室
    PHA_UX.ComboBox.Loc('phLoc');
	InitDefVal();

    //打印弹框
    //开始货位
	PHA_UX.ComboBox.StkBinRacks('prtStkbin', {
        multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
        qParams: {
            LocId: PHA_UX.Get('phLoc',session['LOGON.CTLOCID']) ,
        }
    }) ;
    /* 排序方式 */
    compoments.OrderType('orderType');
        
}
function InitDefVal(){
	$("#manDrgFlag").combobox("setValue", "");
	$("#noUseFlag").combobox("setValue", "0");
	$("#inclbQtyFlag").combobox("setValue", "");  
	$("#selManGrp").combobox("setValue", "Y");    
   
}

function InitGridMStktkDetail(){
    var gridId = 'gridMStktkDetail'
    var columns = [
        [
            { field: 'spec', 		title: '规格', 			align: 'left', 	width: 80 },
            { field: 'stkbinDesc', 	title: '货位', 			align: 'left', 	width: 80 },
            { field: 'pFreQty', 	title: '盘点数量',		align: 'right',	width: 80},
            { field: 'pUomDesc',	title: '单位', 			align: 'left',	width: 80 },
            { field: 'batNo', 		title: '批号',			align: 'left',	width: 100 },
            { field: 'expDate', 	title: '效期',			align: 'left',	width: 80 },
            { field: 'pRp', 		title: '进价(入库)',	align: 'right',	width: 100 },
            { field: 'pSp', 		title: '售价(入库)',	align: 'right',	width: 100 },
            { field: 'freRpAmt', 	title: '进价金额',		align: 'right',	width: 100 },
            { field: 'freSpAmt', 	title: '售价金额',		align: 'right',	width: 100 },
            { field: 'manfDesc', 	title: '生产企业',		align: 'left',	width: 250 },
            { field: 'insuCode', 	title: '国家医保编码', 	align: 'left',	width: 100 },
            { field: 'insuName', 	title: '国家医保名称', 	align: 'left',	width: 100 }
        ]
    ];
    var frozenColumns = [
        [
        	{ field: 'inci',       	title: 'inci', 			align: 'left',	width: 100, hidden: true },
        	{ field: 'inclb',       title: 'inclb', 		align: 'left',	width: 100, hidden: true },
            { field: 'stktkItmId',  title: 'stktkItmId',	align: 'left',	width: 100, hidden: true },
            { field: 'inciCode',    title: '代码', 			align: 'left',	width: 100, sortable: true},
            { field: 'inciDesc',    title: '名称',  		align: 'left',  width: 300, sortable: true}
        ]
    ];

    var dataGridOption = {
        fit: true,
        rownumbers: true,
        pagination: true,
        pageNumber:1,
        pageSize: 100,
        pageList: [100,300, 500, 1000], // 100起
        
        toolbar: '#gridMStktkDetailBar',
        columns: columns,
        exportXls: false,
        frozenColumns: frozenColumns,
        loadFilter:PHA.LocalFilter,
        onLoadSuccess: function (data) {
            $(this).datagrid('loaded');
            CalcAmt();
        },
        showFooter: true,
        
    };
    PHA.Grid(gridId, dataGridOption);
	
	
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
            { field: 'noUseDesc',  title: '品种',		align: 'left',	width: 100 },
            { field: 'manGrpDesc',  title: '盘点组',	align: 'left',	width: 100 },
            { field: 'selManGrpDesc',title: '是/否盘点组',	align: 'left',	width: 100 },
            { field: 'manDrgDesc',	title: '管理药',	align: 'left',	width: 100 },
            { field: 'stkBinDesc',  title: '货位',  	align: 'right',	width: 100 },
            { field: 'newStatusInfo',title: '最新流转信息',	align: 'left',	width: 200 }
        ]
    ];
    var dataGridOption = {
	    gridSave: false,
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: '#gridStktkMainBar',
        exportXls: false,
        columns: columns,
        onSelect: function(rowIndex, rowData) {
            QueryDetail()
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                SelectStktk()
            }
        },
        onLoadSuccess: function (data) {
            if(data.total>0){
                $('#gridStktkMain').datagrid("selectRow",0);
            }else{
                $('#gridStktkDetail').datagrid('clear');
	        }
        }
        
    };
    PHA.Grid('gridStktkMain', dataGridOption);
}
function InitGridStktkDetail(){
    var columns = [
        [
            { field: 'spec',        title: '规格',			align: 'left',  width: 80 },
            { field: 'stkbinDesc',  title: '货位',			align: 'left',  width: 80 },
            { field: 'pFreQty', 	title: '盘点数量',		align: 'right',	width: 80},
            { field: 'pUomDesc',	title: '单位', 			align: 'left',	width: 80 },
            { field: 'batNo',       title: '批号',			align: 'left',  width: 100 },
            { field: 'expDate',     title: '效期',			align: 'left',  width: 100 },
            { field: 'pRp',         title: '进价(入库)',	align: 'right', width: 100 },
            { field: 'pSp',         title: '售价(入库)',	align: 'right', width: 100 },
            { field: 'freRpAmt', 	title: '进价金额',		align: 'right', width: 100 },
            { field: 'freSpAmt',    title: '售价金额',		align: 'right', width: 100 },
            { field: 'manfDesc',    title: '生产企业',      align: 'left',  width: 250 },
            { field: 'insuCode',    title: '国家医保编码',	align: 'left',  width: 100 },
            { field: 'insuName',    title: '国家医保名称',	align: 'left',  width: 100 }
        ]
    ];
    var frozenColumns = [
        [
            { field: 'inclb',       title: 'inclb',         align: 'left',  width: 100, hidden: true },
            { field: 'stktkItmId',  title: 'stktkItmId',    align: 'left',  width: 100, hidden: true },
            { field: 'inciCode',    title: '代码',			align: 'left',  width: 100, sortable: true},
            { field: 'inciDesc',    title: '名称',			align: 'left',  width: 300, sortable: true}
        ]
    ]
    var dataGridOption = {
	    gridSave: false,
        fit: true,
        rownumbers: true,
        pagination: true,
        toolbar: [],
        exportXls: false,
        columns: columns,
        frozenColumns: frozenColumns
    };
    PHA.Grid('gridStktkDetail', dataGridOption);

}
function ShowDiagStktk(btnOpt){
	$('#diagFindStktk').dialog({
            width: PHA_COM.Window.Width(),
            height: PHA_COM.Window.Height(),
            modal: true
    }).dialog('open');
    $('#gridStktkMain').datagrid('clear');
    $('#gridStktkDetail').datagrid('clear');
    
    var locId =  $("#stktkLocId").combobox("getValue") || PHA_COM.Session.CTLOCID
    $('#phLoc').combobox('setValue', locId);
    $("#stDate").datebox("setValue",APP_PROP.DefStartDate) ;
    $("#endDate").datebox("setValue",APP_PROP.DefEndDate) ;
}
function CheckIfCompleted(){
    var tipFlag = APP_PROP.IfCompleted;
    if(tipFlag != "Y" ) return true; 
    var locId = $("#stktkLocId").combobox("getValue") || "";
    var pJson= {
        locId :locId
    }
    var retVal = PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'CheckIfCompleted',
		pJson: JSON.stringify(pJson)
	},false)
    if(retVal.data != ""){
        PHA.Msg("info", $g("存在未完成单据，请查看！")+ "<span>" + retVal.data +"</span>")
        return false;
    }else{
        return true;
    }
    
    
}
function SaveStktk(){
    if(CheckIfCompleted() != true ){return;}
	var retJson = PHA.GetVals(["stktkLocId","stkGrpId","stkbinId","noUseFlag","stkCatId","manDrgFlag","inclbQtyFlag","manGrpId","selManGrp"],"Json")
	var pJson = {};
	pJson = retJson[0];
	pJson.userId = session['LOGON.USERID'];  
	PHA.Loading("Show");
    PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'SaveData',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetStktkMainInfo(data.data);
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	}) 

}
function Clean()
{
    PHA.DomData("#qCondition", {
        doType:'clear'
    })
    PHA.DomData("#js-pha-moreorless", {
        doType:'clear'
    })
    
    $('#gridMStktkDetail').datagrid('clear');
    PHA.SetVals([{ 
		stktkLocId  : session['LOGON.CTLOCID'],
	}]);
    $('#infoArea').phabanner('loadData', []);
    SetDisable();
    InitDefVal();
}
function Complete(){	
	var pJson = {}
	var stktkId = $('#stktkId').val();
	if (stktkId == ""){
		PHA.Msg("info", "请选择盘点单据后完成！")
		return;
	}
	pJson.stktkId = stktkId;
    pJson.compFlag = "Y";
	pJson.userId = session['LOGON.USERID'];  
	PHA.Loading('Show')
	PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'SetComplete',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetStktkMainInfo(stktkId);;
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})  	

}
function CancelComplete(){
    PHA.Loading('Show')
    var pJson = {}
    var stktkId = $('#stktkId').val();
    pJson.stktkId = stktkId;
    pJson.compFlag = "N";
    pJson.userId = session['LOGON.USERID'];
    PHA.CM({
        pClassName: 'PHA.IN.STKTK.Api',
        pMethodName: 'CancelComplete',
        pJson: JSON.stringify(pJson)
    },function(data) {
        PHA.Loading("Hide");
        if(PHA.Ret(data)){
            GetStktkMainInfo(stktkId);;
        }
    },function(failRet){
        PHA_COM._Alert(failRet);
    }) 
    
}
function PrtStktk(){
    var stktkId = $('#stktkId').val();
    var printFlag = $('input[name="printModel"]:checked').val() || '';
    var stkbinIdStr =  $("#prtStkbin").combobox("getValues").join(",");
    var orderType = $("#orderType").combobox("getValue");
    
    var othJson = {}
    othJson.stkbinId = stkbinIdStr; 
    othJson.orderType = orderType;
    $('#diagPrintModel').dialog('close');    
    PrintStktk(stktkId, printFlag, othJson);
}
function ClosePrtDiag(){
    $('#diagPrintModel').dialog('close');
}
function Print(){
	var stktkId = $('#stktkId').val();
	if (stktkId == ""){
		PHA.Msg("info", "请选择盘点单据后打印！")
		return;
	}
	$('#diagPrintModel').dialog('open');
	$("#orderType").combobox('setValue', 'CODE');
}
function Delete(){
	// 删除确认
    var stktkId = $('#stktkId').val();
    if (stktkId == ""){
        $('#gridMStktkDetail').datagrid('clear');
            return;
    }
	PHA.Confirm("删除提示", "是否确认删除该盘点单?", function () {
	    var pJson = {}	
        PHA.Loading('Show')
		pJson.stktkId = stktkId
		PHA.CM({
			pClassName: 'PHA.IN.STKTK.Api',
			pMethodName: 'Delete',
			pJson: JSON.stringify(pJson)
		},function(data) {
			PHA.Loading("Hide");
			if(PHA.Ret(data)){
				Clean();
			}
		},function(failRet){
			PHA_COM._Alert(failRet);
		}) ;
	}); 
}
function QueryMain(){
    var $grid = $("#gridStktkMain");
    $('#gridStktkDetail').datagrid('clear');
    var retJson = PHA.GetVals(["stDate","endDate","phLoc"],"Json");
	if(retJson[0] == undefined) {return;}
    var stDate = $("#stDate").datebox("getValue") || ""; 
    var endDate = $("#endDate").datebox("getValue") || "";
    var locId = $("#phLoc").combobox("getValue") || "";  
    var stktkStatus = $("#stktkStatus").combobox("getValues").join(",");
    if(stktkStatus == ""){
		var comboData=$("#stktkStatus").combobox('getData');
		for(var i = 0; i < comboData.length; i++){
			if(stktkStatus == "") {stktkStatus=comboData[i].RowId;}
			else{stktkStatus=stktkStatus + "," + comboData[i].RowId;}
		}
	}    
    var pJson = {};
    pJson.stDate = stDate;  
    pJson.endDate = endDate;
    pJson.locId = locId;
    pJson.stktkStatus = stktkStatus;
    pJson.execFlag = "Y"
    
    $grid.datagrid('options').url = PHA.$URL;
	$grid.datagrid('query',{
		pClassName:'PHA.IN.STKTK.Api' ,
        pMethodName:'GetStktkMainList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    });  
    
    
}
function QueryDetail(){
    var  $grid = $("#gridStktkDetail");
    var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var stktkId = Selected.stktkId;
    var pJson = {};
    pJson.stktkId = stktkId;    
    $grid.datagrid('options').url = PHA.$URL;
	$grid.datagrid('query',{
		pClassName:'PHA.IN.STKTK.Api' ,
        pMethodName:'GetStktkDetail',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    });  
   
}

function QueryPreStktk(){
    var $grid = $("#gridMStktkDetail");
    $('#stktkId').val("");
	var retJson = PHA.GetVals(["stktkLocId","stkGrpId","stkbinId","noUseFlag","stkCatId","manDrgFlag","inclbQtyFlag","manGrpId","selManGrp"],"Json")

    $grid.datagrid('clear');
    $('#infoArea').phabanner('loadData', []);
	var pJson = {};
	pJson = retJson[0];
	pJson.userId = session['LOGON.USERID']; 
    PHA.CM({
            pClassName: 'PHA.IN.STKTK.Api',
            pMethodName: 'GetPreStktkDetail',
            pPlug:'datagrid',
            pJson: JSON.stringify(pJson)
        },function(data){
            $grid.datagrid('loadData', data);
            SetDisable();
        }
    );

}
function SelectStktk(){
    var Selected = $("#gridStktkMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var stktkId = Selected.stktkId;
    CloseDiag();
	GetStktkMainInfo(stktkId);
	
   
}
// 获取主界面数据
function GetStktkMainInfo(stktkId)
{
    var $grid = $("#gridMStktkDetail");
	var pJson = {};
    pJson.stktkId = stktkId; 
    PHA.Loading('Show')
    PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'GetStktkMainInfo',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide")
		if(PHA.Ret(data)){
            var locId = data[0].locId || '' ;
            var locDesc = data[0].locDesc || '' ;
            data[0].locId = {
                RowId: locId,
                Description:locDesc,
                Select: false
            }
            var stkGrpId = data[0].stkGrpId || '' ;
            var stkGrpDesc = data[0].stkGrpDesc || '' ;
            /*data[0].stkGrpId = {
                RowId: stkGrpId.split(','),
                Description:stkGrpDesc,
                Select: false
            }*/
            data[0].stktkLocId = {
                RowId: data[0].stktkLocId,
                Description:data[0].stktkLocDesc,
                Select: false
            }
			PHA.SetVals(data,"#qCondition");
			SetDisable();
            SetInfoArea(data);
            PHA.CM({
                    pClassName: 'PHA.IN.STKTK.Api',
                    pMethodName: 'GetStktkDetail',
                    pPlug:'datagrid',
                    pJson: JSON.stringify(pJson)
                },function(gridData){
                    $grid.datagrid('loadData', gridData);
                }
            );
		}else{
			PHA_COM._Alert(failRet);
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})
}

function CloseDiag(){
    $('#diagFindStktk').dialog('close');
}

// 按钮不可用
function SetDisable(flag)
{	if(flag == undefined){
		var flag = $("#compFlag").checkbox("getValue");
	}
	var stktkId = $('#stktkId').val() || "";
	if(stktkId == ""){
		$("#stktkLocId").combobox('enable'); 
	}else{
		$("#stktkLocId").combobox('disable'); 
	}
    PHA_COM.ControlOperation({
		'#btnCancelComp': {
			disabled : flag != true,
			hide: flag != true
		},
		'#btnComplete': {
			disabled : flag == true,
			hide: flag == true
		},
		'#btnDelete': {
			disabled : flag == true
		},
		'#btnSave': {
			disabled : (stktkId != "")
		},
		'#btnPrint': {
			disabled : (stktkId == "")
		}
	});

}


function CalcAmt(){
    PHA_COM.SumGridFooter('#gridMStktkDetail' , ['freRpAmt', 'freSpAmt']);
}
function SetInfoArea(retData){
	var dataArr = [
	  {
	    info: retData[0].stktkNo ,
	    append: '/'
	  },
	  {
	    prepend: $g("制单") + ":" ,
	    info: retData[0].userName + ' ' + retData[0].stktkDate+ ' ' + retData[0].stktkTime,
	    append: '/'
	  },
	  {
	    info:retData[0].compFlag == "Y" ? $g("账盘完成"): $g("未账盘完成"),
	    labelClass: retData[0].compFlag == "Y" ? 'info' : 'danger'
	  }
	];
	
	$('#infoArea').phabanner('loadData', dataArr);

}