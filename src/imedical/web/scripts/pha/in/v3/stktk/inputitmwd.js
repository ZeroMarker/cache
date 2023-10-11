var APP_NAME = "DHCSTINSTKINPUT"
var APP_PROP = PHA_COM.ParamProp(APP_NAME)
var BUIS_CODE = "STKTK"

var compoments = STKTK_COMPOMENTS;
$(function(){
    InitDict();             // 初始化条件字典
    InitGridStktkWdDetail();  // 初始化grid
    InitGridStktkInci();  // 初始化grid
    InitBtn();              // 初始化按钮
    //QueryStktkData();
    InitDefVal();           // 初始化事件
	CreatItmWdData();
	setTimeout(function () {
        PHA_COM.ResizePanel({
            layoutId: 'layout-stktk-itmwd',
            region: 'east',
            width: 0.23
        });
    }, 0);
})
function InitDict(){
	var locId = $("#stktkLocId").val();
    // 科室盘点组
    PHA_UX.ComboBox.StkTkGrp('manGrpId', {
	    multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		qParams: {
			Loc: PHA_UX.Get('stktkLocId', session['LOGON.CTLOCID']),
		}
	});
	//类组
	PHA_UX.ComboBox.StkCatGrp('stkGrpId', {
        multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		qParams: {
			LocId: locId,
			UserId: session['LOGON.USERID']
		}
	});
	//库存分类
	PHA_UX.ComboBox.StkCat("stkCatId",{
		qParams: {
			CatGrpId: PHA_UX.Get('stkGrpId')
		}
	});
	 //开始货位
	 /*
    PHA.ComboBox('stkbinId', {
	    multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
        url: PHA_STORE.StkBinRacks(locId).url
    });
    */
    PHA_UX.ComboBox.StkBinRacks('stkbinId', {
        multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
        qParams: {
            LocId: PHA_UX.Get ('stktkLocId',session['LOGON.CTLOCID']) ,
        }
    }) ;
    
    //药房科室
    PHA.ComboBox('inputWinId',{
		url: PHA_IN_STORE.StkTkWindow(locId).url
	});
	// 药品下拉表格
	PHA_UX.ComboGrid.INCItm('inci', {
		width: 160,
		qParams: {
			pJsonStr: {
				stkType: App_StkType,
				locId: locId,
				scgId: PHA_UX.Get('stkGrpId', '')
			}
		},
		onShowPanel:function(){},
		onHidePanel:function( ){
			var grid = $('#inci').combogrid('grid');	// get datagrid object
			var rowData = grid.datagrid('getSelected');	// get the selected row
			if(typeof(rowData) == "object"){
				if(rowData==null) return;
				var inci = rowData.inci;
				var rowsData = $('#gridStktkWdDetail').datagrid('getData').rows;
				var rows = rowsData.length;
				var dataArr = [];
				for (var i = 0; i < rows; i++) {
					var rowData = rowsData[i];
					var inciId = rowData.inci;
					if(inci == inciId){
						PHA_GridEditor.Edit({
							gridID: "gridStktkWdDetail",
							index: i,
							field: "countBQty"
						});
						return ;
					}
				}
			}

			
		},

	});
	
	/* 排序方式 */
    compoments.OrderType('orderType');
}
function InitBtn(){
    PHA_EVENT.Bind('#btnFind', 		'click', 	function () {QueryDetail();});
    PHA_EVENT.Bind('#btnClean', 	'click', 	function () {Clean();});
    PHA_EVENT.Bind('#btnSave', 		'click', 	function () {SaveData();});
    PHA_EVENT.Bind('#btnBack', 		'click', 	function () {BackMain();});
    PHA_EVENT.Bind('#btnCancelSel', 'click', 	function () {CancelSelInci();});
	//表格按钮
    PHA_EVENT.Bind('#btnAddRows', 	'click', 	function () {AddOneRow();});
    PHA_EVENT.Bind('#btnDelRows', 	'click', 	function () {DelChkRows();});
	   
} 
function InitDefVal(){
	$("#inputWinId").combobox("setValue", Com_WinId); 
	$("#orderType").combobox('setValue', "CODE"); 
}
function InitGridStktkWdDetail(){
    var gridId = 'gridStktkWdDetail'
    var columns = [
        [
            { field: 'spec', 		title: '规格', 				align: 'left', 	width: 80 },
            { field: 'freQty', 		title: '账盘数量',			align: 'right',	width: 80 },
            { field: 'uomDesc', 	title: '单位',				align: 'left',	width: 80 },
            { field: 'countBQty', 	title: '实盘数量(基本)',	align: 'right',	width: 80 ,
            	editor: PHA_GridEditor.NumberBox({
	            	checkOnBlur: true,
					checkValue: function (val, checkRet) {
						if(val == "") return true ;
						var nQty = parseFloat(val);
						if (isNaN(nQty)) {
							checkRet.msg = "请输入数字！";
							return false;
						}
						if (nQty < 0) {
							checkRet.msg = "请输入大于0的数字！";
							return false;
						}
						return true;
					},
					onBlur:function(val, rowData, rowIndex){
						if(val == "") val = 0;
						// 计算
						var bQty = parseFloat(val);
						// 联动更新
						var pQty = rowData.countPQty ;  //|| 0
						ChangeRecordInfo(rowIndex, rowData, bQty, pQty);
					}
				})
            },
            { field: 'bUomDesc',	title: '基本单位', 			align: 'left',	width: 80 },
            { field: 'countPQty', 	title: '实盘数量(入库)',	align: 'right',	width: 80 ,
            	editor: PHA_GridEditor.NumberBox({
	            	checkOnBlur: true,
					checkValue: function (val, checkRet) {
						if(val == "") val = 0;
						var nQty = parseFloat(val);
						if (isNaN(nQty)) {
							checkRet.msg = "请输入数字！";
							return false;
						}
						if (nQty < 0) {
							checkRet.msg = "请输入大于0的数字！";
							return false;
						}
						return true;
					},
					onBlur:function(val, rowData, rowIndex){
						if(val == "") val = 0;
						// 计算
						var pQty = parseFloat(val);
						// 联动更新
						var bQty = rowData.countBQty ; //|| 0
						ChangeRecordInfo(rowIndex, rowData, bQty, pQty);
					}
				})
            },
            { field: 'pUomDesc',	title: '入库单位', 			align: 'left',	width: 80 },
            { field: 'countQty', 	title: '实盘数量',			align: 'right',	width: 80 },
            { field: 'difQty',		title: '差异数量', 			align: 'right',	width: 80 },
            { field: 'rp', 			title: '进价',				align: 'right',	width: 100 , hidden: true  },
            { field: 'sp', 			title: '售价',				align: 'right',	width: 100 , hidden: true  },
            { field: 'freRpAmt', 	title: '账盘进价金额',		align: 'right',	width: 100 },
            { field: 'freSpAmt', 	title: '账盘售价金额',		align: 'right',	width: 100 },
            { field: 'countRpAmt', 	title: '实盘进价金额',		align: 'right',	width: 100 },
            { field: 'countSpAmt', 	title: '实盘售价金额',		align: 'right',	width: 100 },
            { field: 'difRpAmt', 	title: '进价金额差异',		align: 'right',	width: 100 },
            { field: 'difSpAmt', 	title: '售价金额差异',		align: 'right',	width: 100 },
            { field: 'manfDesc', 	title: '生产企业',			align: 'left',	width: 250 },
            { field: 'insuCode', 	title: '国家医保编码', 		align: 'left',	width: 100 },
            { field: 'insuName', 	title: '国家医保名称', 		align: 'left',	width: 100 },
            { field: 'bUomId', 		title: '基本单位', 			align: 'left',	width: 100, hidden: true  },
            { field: 'fac', 		title: '单位转换系数', 		align: 'left',	width: 100, hidden: true  }
        ]
    ];
    var frozenColumns = [
        [
        	{ field: 'stktkItmId',	title: 'stktkItmId',		align: 'left',	width: 100, hidden: true },
			{ field: 'inci',		title: 'inci',				align: 'left',	width: 100, hidden: true },
        	{ field: 'inclb',		title: 'inclb',				align: 'left',	width: 100, hidden: true },
            { field: 'stkbinDesc', 	title: '货位', 				align: 'left', 	width: 80 , sortable: true},
            { field: 'stktkWdId',	title: 'stktkWdId',			align: 'left',	width: 100, hidden: true },
            { field: 'inciCode',    title: '代码', 				align: 'left',	width: 100, sortable: true},
            { field: 'inciDesc',    title: '名称',  			align: 'left',  width: 200, sortable: true,
				editor: PHA_UX.Grid.INCItmBatWin({
					onBeforeLoad: function(param, gridRowData){
						param.hospId = session['LOGON.HOSPID'];
						param.pJsonStr = JSON.stringify({
							stkType: App_StkType,
							scgId: "", 
							locId: $("#stktkLocId").val() || "",
							userId: session['LOGON.USERID'],
							notUseFlag: '',
							qtyFlag: '',
							reqLocId: ''
						});
					},
					onBeforeNext: function (winData, gridRowData, gridRowIndex) {
						if (winData.action == 'close') {
							return true;
						}
						var nData = winData.north;
						var cData = winData.center;
						
					},
					onClickSure: function(winData){
						var nData = winData.north;
						var cDataRows = winData.center;
						AddRows(nData, cDataRows);
					}
				})


			},
            { field: 'batNo',   	title: '批号',  			align: 'left',  width: 80, sortable: true},
            { field: 'expDate',    	title: '效期',  			align: 'left',  width: 80, sortable: true}
        ]
    ];

    var dataGridOption = {
	    bodyCls:'table-splitline',
        fit: true,
        rownumbers: true,
        pageNumber:1,
		pageSize: 100,
        pageList: [100,300, 500, 1000], // 100起
        pagination: true,
        toolbar: '#gridStktkWdDetailBar',
        columns: columns,
        exportXls: false,
        frozenColumns: frozenColumns,
		isCellEdit:true,
        editFieldSort: ['countBQty', 'countPQty' ],
		loadFilter:PHA.LocalFilter,
        onClickCell: function (index, field, value) {
			if(field == "inciDesc"){
				var rowData = $('#gridStktkWdDetail').datagrid('getData').rows[index];
				var stktkItmId = rowData.stktkItmId;
				if((stktkItmId != "")&&(stktkItmId != undefined)) {
					return;
				}
			}
            PHA_GridEditor.Edit({
                gridID: gridId,
                index: index,
                field: field
            });
        },
        onLoadSuccess: function (data) {
			$(this).datagrid('loaded');
	        PHA_GridEditor.End(gridId);
            CalcAmt();
        },
        showFooter: true,
		rowStyler: function(index,row){
			var countQty = row.countQty || "";
			if ((countQty == "") || (countQty == null)) {
			    return; //未填项不变色
			}
			if (row.difQty > 0){
				return {class:'pha-datagrid-difqty-positive'} ;
			}else if(row.difQty < 0){
				return {class:'pha-datagrid-difqty-negative'} ;
			}
		}
    };
    PHA.Grid(gridId, dataGridOption);

}
function InitGridStktkInci(){
    var gridId = 'gridStktkInci'
    var columns = [
        [
        	{ field: 'inci',    title: 'inci', 				align: 'left',	width: 100, hidden: true},
            { field: 'inciCode',    title: '代码', 				align: 'left',	width: 100, sortable: true},
            { field: 'inciDesc',    title: '名称',  			align: 'left',  width: 300, sortable: true}
         ]
    ];
    var dataGridOption = {
	    bodyCls:'table-splitline',
        fit: true,
        rownumbers: true,
		pageNumber:1,
		pageSize: 100,
        pageList: [100,300, 500, 1000], // 100起
        pagination: true,
		showPageList:false,
		showRefresh:false,
        toolbar: '#gridStktkInciBar',
        columns: columns,
        exportXls: false,
        url:PHA.$URL,
        queryParams:{
            pClassName:'PHA.IN.STKTK.Api' ,
            pMethodName:'GetItmInciData',
            pPlug:'datagrid',
            pJson:{}
        },
        onSelect: function(rowIndex, rowData) {
	        QueryItmWdDetail();
        },
        onDblClickRow: function (rowIndex, rowData) {
            
        },
        onLoadSuccess: function (data) {
        },
        gridSave: false,
        showFooter: true
    };
    PHA.Grid(gridId, dataGridOption);

}

function QueryStktkData(){
	var stktkId = $("#stktkId").val();
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
			$("#stktkNo").val(data[0].stktkNo);
			QueryDetail()
		}else{
			PHA_COM._Alert(failRet);
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})
}
function GetParams(){
	var stktkId = $("#stktkId").val();
	var manGrpId = $("#manGrpId").combobox("getValue") || "";  
	var stkGrpId = $("#stkGrpId").combobox("getValue") || "";  
	var stkCatId = $("#stkCatId").combobox("getValue") || "";  
	var stkbinId = $("#stkbinId").combobox("getValue") || "";  
	var stkWinId = $("#inputWinId").combobox("getValue") || ""; 
	var orderType =  $("#orderType").combobox("getValue") || ""; 
	var pJson = {};
    pJson.stktkId = stktkId;  
    pJson.manGrpId = manGrpId;
    pJson.stkGrpId = stkGrpId;
	pJson.stkCatId = stkCatId;
	pJson.stkbinId = stkbinId;
	pJson.stkWinId = stkWinId;
	pJson.orderType = orderType;
	return pJson
}
function QueryDetail(){
	$('#gridStktkWdDetail').datagrid('clear');
	$('#gridStktkInci').datagrid('clear');
	QueryInciDetail();
	setTimeout(QueryItmWdDetail(), 500)

}
function QueryItmWdDetail(){
	var $grid = $("#gridStktkWdDetail");
	var pJson = GetParams();
	var Selected = $("#gridStktkInci").datagrid("getSelected") || "";
	
    if(Selected != ""){
		var inci = Selected.inci;
		pJson.inci = inci;
	}
	PHA.CM({
			pClassName: 'PHA.IN.STKTK.Api',
			pMethodName: 'GetStktkWdDetailData',
			pPlug:'datagrid',
			pJson: JSON.stringify(pJson)
		},function(gridData){
			$grid.datagrid('loadData', gridData);
		}
	);
}
function QueryInciDetail(){
	var pJson = GetParams();
	$("#gridStktkInci").datagrid('query',{
		pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    });
}

function SaveData(){
	var gridId = "gridStktkWdDetail"
	PHA_GridEditor.End(gridId);
	var pJson = {};
	pJson.stktkId =  $("#stktkId").val(); ;
	pJson.userId = session['LOGON.USERID'];  
	pJson.winId = $("#inputWinId").combobox("getValue") || ""; 
	var $grid = $('#' + gridId);
    var rowsData = $grid.datagrid('getChanges');
    var rows = rowsData.length;
    var dataArr = [];
    for (var i = 0; i < rows; i++) {
		var rowData = rowsData[i];
		var inclb = rowData.inclb;
		var stktkWdId = rowData.stktkWdId;
		var bQty = rowData.countBQty;
		var pQty = rowData.countPQty;
		var countQty = rowData.countQty;
		var iJson = {
			stktkWdId : stktkWdId,
	  		bQty : bQty,
            pQty : pQty,
            countQty : countQty,
			inclb : inclb
        };
        dataArr.push(iJson);
    }
    if (dataArr.length === 0) {
       PHA.Msg('error', $g("没有需要保存的数据"));
       return;
    }
	pJson.rows = dataArr;
	PHA.Loading("Show");
    PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'SaveItmWd',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			QueryStktkData();
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	}) 

}
function Clean()
{
	PHA.ClearVals(["manGrpId","stkGrpId","stkCatId","stkbinId","inputWinId","inci"])
	$('#gridStktkWdDetail').datagrid('clear');
	$('#gridStktkInci').datagrid('clear');
	InitDefVal()
}
function CancelSelInci(){
	$("#gridStktkInci").datagrid("clearSelections");
	QueryItmWdDetail();
}
function CalcAmt(){
	PHA_COM.SumGridFooter('#gridStktkWdDetail' , ['freRpAmt', 'freSpAmt', 'countRpAmt', 'countSpAmt', 'difRpAmt', 'difSpAmt']);
}

/// 生成盘点数据
function CreatItmWdData(){
	var stktkId = $("#stktkId").val();
	var pJson = {};
    pJson.stktkId = stktkId; 
    pJson.userId =  session['LOGON.USERID']; 
    pJson.winId =  $("#inputWinId").combobox("getValue") || ""; 
    PHA.Loading('Show')
    PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'CreatItmWd',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide")
		if(PHA.Ret(data)){
			QueryStktkData()
		}else{
			PHA_COM._Alert(failRet);
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})
}
function ChangeRecordInfo(rowIndex, rowData, bQty, pQty){
	var $grid = $('#gridStktkWdDetail');
	var stktkWdId = rowData.stktkWdId ;
	var emptyFlag = ((bQty == "")&&(pQty == "")) ? true : false ;
	bQty = bQty || 0;
	pQty = pQty || 0;
	var fac = rowData.fac ; 
	var freQty = rowData.freQty 
	var countQty = _.safecalc('add', bQty, _.safecalc('multiply', pQty, fac));
	var difQty =  _.safecalc('add', countQty,  _.safecalc('multiply', freQty, -1)); 
	var rp = rowData.rp ;
	var sp = rowData.sp ;
	var freSpAmt = rowData.freSpAmt || 0 ; 
	var freRpAmt = rowData.freRpAmt || 0 ;
	var newCountSpAmt =_.safecalc('multiply', countQty, sp);
	var newCountRpAmt =_.safecalc('multiply', countQty, rp);
	var newDifSpAmt =_.safecalc('add', newCountSpAmt, _.safecalc('multiply', freSpAmt, -1));
	var newDifRpAmt =_.safecalc('add', newCountRpAmt, _.safecalc('multiply', freRpAmt, -1));  
	var Data = {};
	Data.countSpAmt = newCountSpAmt;
	Data.countRpAmt = newCountRpAmt;
	Data.difSpAmt = newDifSpAmt;
	Data.difRpAmt = newDifRpAmt;
	Data.countQty = emptyFlag ? '' : countQty;
	Data.difQty =  difQty;
	$grid.datagrid('updateRowData', {
		index: rowIndex,
		row: Data
	});
	
	var pJson = {};
	pJson.stktkId =  $("#stktkId").val(); ;
	pJson.stktkWdId = stktkWdId ;
	pJson.bQty = emptyFlag ? '' : bQty ;
	pJson.pQty = emptyFlag ? '' : pQty ;
	pJson.userId = session['LOGON.USERID']; 
	pJson.winId = $("#inputWinId").combobox("getValue") || ""; 
	pJson.countQty = emptyFlag ? '' : countQty;
	pJson.inclb = rowData.inclb
	PHA.CM({
		pClassName: 'PHA.IN.STKTK.Api',
		pMethodName: 'UpdateItmWd',
		pJson: JSON.stringify(pJson)
	},function(retdata) {
		if((stktkWdId == "")||(stktkWdId == undefined)){
			var updData = {};
			updData.stktkWdId = retdata.data;
			$grid.datagrid('updateRow', {
				index: rowIndex,
				row: updData
			});
		}
		
	},function(failRet){
		PHA_COM._Alert(failRet);
	}) 
	CalcAmt();
}

function BackMain(){
	var url = "pha.in.v3.stktk.input.csp";
	if ('undefined'!==typeof websys_getMWToken){
		url += "?MWToken="+websys_getMWToken();
	}
	window.location.href=url;
}

function AddOneRow(){
    PHA_GridEditor.Add({
        gridID: 'gridStktkWdDetail',
        field: 'inciDesc',
        rowData: {},
        checkRow: true, // 新增行时是否验证上一行数据
        firstRow: false // 新增行放在最后还是最前
    }, 1);
}
function AddRows(nData, rowsData){
	var $grid = $('#gridStktkWdDetail')
	for (var i = 0; i < rowsData.length; i++) {
		var iRowData = rowsData[i];
		var inclb = iRowData.inclb;
		// 检索是否已经存在inclb 
		var gridRowsData = $grid.datagrid('getRows');
		var gridRows = gridRowsData.length;
		for (var j = 0; j < gridRows; j++) {
			var tmpRowData = gridRowsData[j];
			var tmpInclb = tmpRowData.inclb
			if(tmpInclb == inclb){
				PHA.Popover({
					msg: '该批次已经存在，如需输入请按照药品检索',
					type: 'alert',
					timeout: 1000
				});
				return;
			}			
		}
		var iAddData = {};
		iAddData.inci = nData.inci;
		iAddData.inciCode = nData.inciCode;
		iAddData.inciDesc = nData.inciDesc;
		iAddData.spec = nData.inciSpec;
		iAddData.stkbinDesc = nData.stkBin;
		iAddData.insuCode = nData.insuCode;
		iAddData.insuName = nData.insuName;
		
		iAddData.inclb = iRowData.inclb;
		iAddData.freQty = _.multiply(iRowData.inclbQty,  iRowData.pFac);
		iAddData.expDate = iRowData.expDate;
		iAddData.batNo = iRowData.batNo;
		iAddData.uomDesc = iRowData.bUomDesc;
		iAddData.bUomId = iRowData.bUomId;
		iAddData.bUomDesc = iRowData.bUomDesc;
		iAddData.pUomDesc = iRowData.pUomDesc;
		
		iAddData.manfDesc = iRowData.manfName;
		iAddData.fac = iRowData.pFac;

		iAddData.countPQty = iRowData.inputQty;
		iAddData.countQty = _.multiply(iAddData.countPQty,  iRowData.pFac);
		iAddData.difQty = _.add(iAddData.countPQty,  -iAddData.freQty);
		iAddData.rp = _.divide(iRowData.pRp, iRowData.pFac);
		iAddData.sp = _.divide(iRowData.pSp, iRowData.pFac);
		iAddData.freRpAmt = _.multiply(iRowData.inclbQty,  iRowData.pRp);
		iAddData.freSpAmt = _.multiply(iRowData.inclbQty,  iRowData.pSp);
		if (i == 0) {
			var selRow = $grid.datagrid('getSelected');
			if (selRow && (selRow.inclb == '' || typeof selRow.inclb == 'undefined')) {
				var rowIndex = $grid.datagrid('options').editIndex;
				$grid.datagrid('updateRow', {
					index: rowIndex,
					row: iAddData
				});
				ChangeRecordInfo(rowIndex, iAddData, 0, iAddData.countPQty);
				if(rowsData.length == 1){
					setTimeout(function () {
						PHA_GridEditor.Edit({
							gridID: 'gridStktkWdDetail',
							index: rowIndex,
							field: 'countPQty'
						});
				   }, 200);
				}
				continue;
			}
		}
		PHA_GridEditor.Add({
			gridID: 'gridStktkWdDetail',
			field: 'countPQty',
			rowData: iAddData
		});
		var curRowIndex = $grid.datagrid("getRows").length - 1;
		ChangeRecordInfo(curRowIndex, iAddData, 0, iAddData.countPQty);
		
	}
}
function DelChkRows(){
	var $grid = $('#gridStktkWdDetail')
	var gridSelect = $grid.datagrid('getSelected') || '';
    if (gridSelect == '') {
        PHA.Popover({
            msg: '请先选中需要删除的行',
            type: 'alert',
            timeout: 1000
        });
        return;
    }
    var stktkWdId = gridSelect.stktkWdId || '';
    if(stktkWdId!==""){
		PHA.Popover({
            msg: '已保存到盘点记录，不可以删除！',
            type: 'alert',
            timeout: 1000
        });
        return;
	}
   	var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
	$grid.datagrid('deleteRow', rowIndex);
}