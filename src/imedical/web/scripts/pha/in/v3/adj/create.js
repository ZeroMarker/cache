/*
/// Creator     zhaozhiduan
/// CreatDate   2022年03月11日
/// Description 库存调整建单
*/
var APP_NAME = "DHCSTSTOCKADJ"
var APP_PROP = PHA_COM.ParamProp(APP_NAME)
var APP_PROP_COM = PHA_COM.ParamProp("DHCSTCOMMON");
var BUIS_CODE = "ADJ";
var BUIS_RANGE = "All";
$(function(){
	PHA_COM.SetPanel('#panel');
    InitDict();             // 初始化条件字典
    InitGridMAdjDetail();   // 初始化grid
    InitBtn();              // 初始化按钮
    // dialog 初始化
    InitGridAdjMain();
    InitGridAdjDetail();
    SetDisable();
	SetRequired();
	setTimeout(function () {
		PHA_COM.ResizePanel({
		   layoutId: 'layout-adj-create-diag',
		   region: 'north',
		   height: 0.5 
	   });
   }, 0);
    
})
function InitDefVal(){
	var locId =  $("#adjLocId").combobox("getValue") || PHA_COM.Session.CTLOCID
    $('#phLoc').combobox('setValue', locId);
    $("#stDate").datebox("setValue",APP_PROP.DefStartDate) ;
    $("#endDate").datebox("setValue",APP_PROP.DefEndDate) ;
	$('#buisProcess').combobox('reload');
}
function SetRequired(){
	PHA.SetRequired($('#gridAdjMainBar' + ' [data-pha]'))
	PHA.SetRequired($('#gridMAdjDetailBar' + ' [data-pha]'))
}
function InitBtn(){
	PHA_EVENT.Bind('#btnFind', 'click', function () {
        ShowDiagAdj(this);
    });
    PHA_EVENT.Bind('#btnSave', 'click', function () {
        SaveAdj();
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        Clean();
    });    
    PHA_EVENT.Bind('#btnComplete', 'click', function () {
        Complete();
    }); 
    PHA_EVENT.Bind('#btnCancelComp', 'click', function () {
        CancelComp();
    }); 
    PHA_EVENT.Bind('#btnPrint', 'click', function () {
        Print();
    }); 
    PHA_EVENT.Bind('#btnDelete', 'click', function () {
        Delete();
    }); 
    PHA_EVENT.Bind('#btnCopyAdj', 'click', function () {
        ShowDiagAdj(this);
    });
    //表格按钮
    PHA_EVENT.Bind('#btnAddRows', 'click', function () {
        AddOneRow();
    });
    PHA_EVENT.Bind('#btnDelRows', 'click', function () {
        DelChkRows();
    });
    
    // dialog 按钮
    PHA_EVENT.Bind('#btnSearch', 'click', function () {QueryMain();});
    PHA_EVENT.Bind('#btnClean-q', 'click', function () {CleanQ();});
    PHA_EVENT.Bind('#btnSelAdj', 'click', function () {SelectAdj();});
    PHA_EVENT.Bind('#btnDelAdj', 'click', function () {DelAdj();});
}

function InitDict(){
	//药房科室
    PHA_UX.ComboBox.Loc('adjLocId');
    
	//类组
	PHA_UX.ComboBox.StkCatGrp('stkGrpId', {
		panelHeight: 'auto',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		qParams: {
			LocId: PHA_UX.Get('adjLocId', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	
     //库存调整原因
    PHA.ComboBox('reasonId', {
		panelHeight: 'auto',
        url: PHA_IN_STORE.ReasonForAdj().url
    });
    
    // dialog 药房科室
    //药房科室
    PHA_UX.ComboBox.Loc('phLoc');
	//类组
	PHA_UX.ComboBox.StkCatGrp('inStkGroup', {
		panelHeight: 'auto',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		qParams: {
			LocId: PHA_UX.Get('phLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
    //库存调整原因
    PHA.ComboBox('adjReason', {
		panelHeight: 'auto',
        url: PHA_IN_STORE.ReasonForAdj().url
    });
	/* 信息展示框 */
	$('#infoArea').phabanner({
	    title: $g('选择单据后, 显示详细信息')
	});
}

function InitAdjStatus(flag){
	//业务流程
	PHA.ComboBox('buisProcess', {
		multiple:true,
		editor:false,
		rowStyle:'checkbox', //显示成勾选行形式
		panelHeight:'auto',
		selectOnNavigation:false,
        url: PHA_IN_STORE.BusiProcess(BUIS_CODE, BUIS_RANGE).url,
        onLoadSuccess: function(data) {
			if(data.length > 0){
				var defVals = [];
				for(var i = 0; i <data.length; i++) {
					var iData = data[i];
					var code = iData["RowId"]
					defVals.push(code)
				}
				$(this).combobox('setValues',defVals);
			}
		},
        loadFilter:function(data){
            if(data.length > 0){
                var displayData = []
				for(var i = 0; i <data.length; i++) {
                    var iData = data[i];
                    var desc = iData["Description"]
                    if(flag == 1){
						if((desc.indexOf($g("保存")) < 0)&&(desc.indexOf($g("完成")) < 0 )) continue;
					}else if(flag == 2){	 //复制
						if(desc.indexOf($g("作废")) < 0) continue;
					}
                    displayData.push(iData);
                }
                return displayData;				
			}
        }
    });

}
function InitGridMAdjDetail(){
    var gridId = 'gridMAdjDetail'
    var columns = [
        [
            { field: 'spec', 		title: '规格', 			align: 'left', 	width: 80 },
            { field: 'stkbinDesc', 	title: '货位', 			align: 'left', 	width: 80 },
            { field: 'qty', 		title: '调整数量',		align: 'right',	width: 80,
            	editor: PHA_GridEditor.NumberBox({
					required: true,
					precision: GetDecimals(APP_PROP_COM.FmtSQ),
	            	checkOnBlur: true,
					checkValue: function (val, checkRet) {
						if (val == "") {
							checkRet.msg = "不能为空！"
							return false;
						}
						var nQty = parseFloat(val);
						if (isNaN(nQty)) {
							checkRet.msg = "请输入数字！";
							return false;
						}
						if (nQty == 0) {
							checkRet.msg = "请输入非0的数字！";
							return false;
						}
						return true;
					},
					onBlur:function(val, rowData, rowIndex){
						var qty = parseFloat(val);;
						var inclb = rowData.inclb;
						var uomId = rowData.uomId
						ChangeRecordInfo(rowIndex, inclb, qty, uomId);
					},
					onBeforeNext: function (val, gridRowData, gridRowIndex) {
						// 计算
						var qty = parseFloat(val);
						// 联动更新
						var uomId = gridRowData.uomId;
						var inclb = gridRowData.inclb;
						ChangeRecordInfo(gridRowIndex, inclb, qty, uomId);
					}
				})
            
            },
            { field: 'resultQty', 		title: '调后数量',		align: 'right',	width: 80,
            	editor: PHA_GridEditor.NumberBox({
					checkOnBlur: true,
					precision: GetDecimals(APP_PROP_COM.FmtSQ),
					checkValue: function (val, checkRet) {
						if (val != "") {
							var nQty = parseFloat(val);
							if (nQty < 0) {
								checkRet.msg = "请输大于0的数字！";
								return false;
							}
						}
						return true;
					},
					onBlur:function(val, rowData, rowIndex){
						var resultQty = parseFloat(val);
						var inclbQty = rowData.inclbQty;
						ChangeQtyByResultQty(rowIndex, resultQty, inclbQty);
					},
					onBeforeNext: function (val, gridRowData, gridRowIndex) {
						var resultQty = parseFloat(val);
						var inclbQty = gridRowData.inclbQty;
						ChangeQtyByResultQty(rowIndex, resultQty, inclbQty);
					}
				})
            },
            { field: 'uomId',		title: '单位', 			align: 'left',	width: 80 ,
            	descField: 'uomDesc',
            	formatter: function (value, rowData, index) {
					return rowData['uomDesc'];
				},
				editor: PHA_UX.Grid.INCItmUom({
					onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
						// 联动更新
						var uomId, oldUomId
						if (cmbRowData) {
							uomId = cmbRowData.RowId;
							oldUomId = gridRowData.uomId ;
						}
						if(uomId != oldUomId){
							var qty = gridRowData.qty;
							var inclb = gridRowData.inclb;
							var inci = gridRowData.inci;
							ChangeRecordInfo(gridRowIndex, inclb, qty, uomId);
							
						}
						return true;
					}
				})
            },
            { field: 'inclbQty', 	title: '批次库存',		align: 'right',	width: 100},
            { field: 'avaQty', 		title: '可用库存',		align: 'right',	width: 100},
            { field: 'batNo', 		title: '批号',			align: 'left',	width: 100 },
            { field: 'expDate', 	title: '效期',			align: 'left',	width: 80 },
            { field: 'rp', 			title: '进价',			align: 'right',	width: 100 },
            { field: 'sp', 			title: '售价',			align: 'right',	width: 100 },
            { field: 'rpAmt', 		title: '进价金额',		align: 'right',	width: 100 },
            { field: 'spAmt', 		title: '售价金额',		align: 'right',	width: 100 },
            { field: 'manfDesc', 	title: '生产企业',		align: 'left',	width: 250 },
            { field: 'insuCode', 	title: '国家医保编码', 	align: 'left',	width: 100 },
            { field: 'insuName', 	title: '国家医保名称', 	align: 'left',	width: 100 },
            { field: 'bUomId', 		title: '基本单位', 		align: 'left',	width: 100, hidden: true  },
            { field: 'fac', 		title: '单位转换系数', 	align: 'left',	width: 100, hidden: true  }
        ]
    ];
    var frozenColumns = [
        [
			{ field: 'Select',checkbox: true},
        	{ field: 'inci',       	title: 'inci', 			align: 'left',	width: 100, hidden: true },
        	{ field: 'inclb',       title: 'inclb', 		align: 'left',	width: 100, hidden: true },
            { field: 'adjItmId',    title: 'adjItmId',		align: 'left',	width: 100, hidden: true },
            { field: 'inciCode',    title: '代码', 			align: 'left',	width: 100, sortable: true},
            { field: 'inciDesc',    title: '名称',  align: 'left',    width: 300, sortable: true,
                editor: PHA_UX.Grid.INCItmBatWin({
					onBeforeLoad: function(param, gridRowData){
						param.hospId = session['LOGON.HOSPID'];
						param.pJsonStr = JSON.stringify({
							stkType: App_StkType,
							scgId: $("#stkGrpId").combobox("getValues").join(",") || "", 
							locId: $("#adjLocId").combobox("getValue") || "",
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
				},{
					inputType: 'ADJ'
				})
            }
        ]
    ];

    var dataGridOption = {
        fit: true,
        rownumbers: true,
        pagination: false,
        toolbar: '#gridMAdjDetailBar',
        columns: columns,
        exportXls: false,
        frozenColumns: frozenColumns,
        isAutoShowPanel: false,
		shiftCheck: true,
        singleSelect: true,
        checkOnSelect: false, // 互不干扰, 应保持输入与勾选分开, 但是勾选还需要能分出信息
        selectOnCheck: false,
        editFieldSort: ['inciDesc', 'qty', 'uomId'],
        url:PHA.$URL,
        queryParams:{
            pClassName:'PHA.IN.ADJ.Api' ,
            pMethodName:'GetAdjDetail',
            pPlug:'datagrid',
            pJson:"{}"
        },
        onClickCell: function (index, field, value) {
            PHA_GridEditor.Edit({
                gridID: gridId,
                index: index,
                field: field,
				forceEnd: true	
			});
			var inciCode = $('#' + gridId).datagrid('getRow', index).inciCode
			if( inciCode != "" && inciCode != undefined){
				let target = $('#' + gridId).datagrid('getEditor', { index: index, field: 'inciDesc' }).target;
            	$(target).lookup('disable');
				$(target).unbind();
			}
        },
        onLoadSuccess: function (data) {
           PHA_GridEditor.End(gridId);
           CalcAmt();
        },
        onBeforeEdit:function(){
	    	var compStatus = $("#compFlag").checkbox("getValue");
    		if(compStatus != true){
	    		return true;
	    	}else{
		    	return false;
		    }
	    },
        showFooter: true,
		onNextCell: function(index, field, value, isLastRow, isLastCol) {
			if (isLastRow && isLastCol) {
				AddOneRow();
			}
		}
    };
    PHA.Grid(gridId, dataGridOption);
	
	
}
function InitGridAdjMain(){
    var columns = [
        [
            { field: 'adjId',       title: '单据id',	align: 'left',	width: 80,	hidden: true  },
            { field: 'adjNo',       title: '单号',		align: 'left',	width: 160,
				styler: function(value,row,index){				
					return {class:"pha-grid-link" };
				}
			},
            { field: 'adjLoc',      title: '科室',		align: 'left',	width: 100,	hidden: true  },
            { field: 'adjDate',     title: '制单日期',  align: 'left',	width: 80 },
            { field: 'adjTime',     title: '制单时间',  align: 'left',	width: 80 },
            { field: 'rpAmt',       title: '进价金额',  align: 'right',	width: 80},
            { field: 'spAmt',       title: '售价金额',  align: 'right',	width: 80},
            { field: 'reasonId',  	title: '调整原因',  align: 'left',	width: 100,	hidden: true   },
            { field: 'reasonDesc',  title: '调整原因',  align: 'left',	width: 100 },
            { field: 'remarks',     title: '备注',		align: 'left',	width: 100 },
            { field: 'curStatus',   title: '状态',		align: 'left',	width: 80 },
            { field: 'curPbDate',   title: '状态操作日期',	align: 'left',	width: 100 },
            { field: 'curPbTime',   title: '状态操作时间',	align: 'left',	width: 80 },
            { field: 'curPbUser', 	title: '状态操作人',	align: 'left',	width: 100 },
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
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                SelectAdj()
            }
        },
        onLoadSuccess: function (data) {
            if(data.total>0){
                $('#gridAdjMain').datagrid("selectRow",0);
            }else{
	        	$('#gridAdjDetail').datagrid('clear');
	        }
        },
        onClickCell: function (index, field, value) {      
			if(field=="adjNo"){
                var rowData = $('#gridAdjMain').datagrid('getData').rows[index];
                PHA_UX.BusiTimeLine({},{
                    busiCode:BUIS_CODE,
                    locId:$("#adjLocId").combobox("getValue") || PHA_COM.Session.CTLOCID,
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
            { field: 'inclb',       title: 'inclb',         align: 'left',  width: 100},
            { field: 'adjItmId',    title: 'adjItmId',      align: 'left',  width: 100},
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
        frozenColumns: frozenColumns,
        showFooter: true,
        onLoadSuccess: function (data) {
            PHA_COM.SumGridFooter('#gridAdjDetail' , ['rpAmt', 'spAmt']);
         }
    };
    PHA.Grid('gridAdjDetail', dataGridOption);

}
function ShowDiagAdj(btnOpt){
	var isFind = btnOpt.id.indexOf("Find") >-1 ? true : false;
    $('#diagFindAdj').dialog({
            title: btnOpt.text,
            iconCls: isFind ? 'icon-w-list' : 'icon-w-copy',
            width: PHA_COM.Window.Width(),
            height: PHA_COM.Window.Height(),
            modal: true
    }).dialog('open');
    if(isFind == true){
	 	var htmlStr = $('#btnSelAdj')[0].innerHTML;
	 	$('#btnSelAdj')[0].innerHTML=htmlStr.replace($g("复制"), $g("选取"));
		$('#btnDelAdj').show();
	 	InitAdjStatus(1);
	}else{
		var htmlStr = $('#btnSelAdj')[0].innerHTML;
	 	$('#btnSelAdj')[0].innerHTML=htmlStr.replace($g("选取"), $g("复制"))
		$('#btnDelAdj').hide();
	 	InitAdjStatus(2);
	}
    $('#gridAdjMain').datagrid('clear');
    $('#gridAdjDetail').datagrid('clear');
	InitDefVal();
}
function ValidateEditGrid(){
	var val = true
	var msg = "";
	var gridId = "gridMAdjDetail"
	var $grid = $('#' + gridId);
	PHA_GridEditor.GridFinalDone("#gridMAdjDetail", 'inclb');
	var rows = $grid.datagrid('getRows');
	if (rows.length ==0) {
		PHA.Msg('error', "明细没有数据！");
		return false;
	}
	var editRow = 0
	try{
		msg = PHA_GridEditor.CheckValues(gridId);
		if(msg != ""){
			throw msg;
		}
		msg = PHA_GridEditor.CheckDistinct({ gridID : gridId,	fields : ["inclb"]});
		if(msg != ""){
			throw msg;
		}
		
		var rowsData = $grid.datagrid('getRows');
		var rows = rowsData.length;
		if (rows == 0) {
			throw '没有需要操作的数据';
		}
		for (var i = 0; i < rows; i++) {
			var rowData = rowsData[i];
			var inclb = rowData.inclb;
			if(inclb == ""){
				continue;
			} 
			var qty = rowData.qty;
			var fac = rowData.fac;
			var uomId = rowData.uomId;
			var bUomId = rowData.bUomId;
			var inclbQty = rowData.inclbQty;
			if ((qty=='')||(parseFloat(qty)==0)){
				editRow = i;
				throw $g("第") +"<span>"+ (i + 1)+"</span>" + $g("行,调整数量不可为空!");
					
			} 
			if ((parseFloat(qty) < 0) && (Math.abs(qty) > parseFloat(inclbQty))){
				editRow = i ;
				throw $g("第") +"<span>"+ (i + 1)+"</span>" + $g("行,调整数量为负数时不能超过批次库存!");		
			} 
			var bQty = qty;
			
			if(APP_PROP.StockAllowDecimal != "Y"){
				if(bUomId != uomId)
				{
					bQty =_.multiply(qty, fac);
				}else{
					bQty = qty;
				}
				if (parseInt(bQty, 10) != bQty){	
					editRow = i ;
					throw $g("第") +"<span>"+ (i + 1)+"</span>" + $g("行, 调整数量存在小数，不能调整！请核对库存调整配置：调整数量换算为基本单位是否允许小数!");
				}	
			}
		}
	}catch(error){
		val = false;
        if(typeof msg === 'string') msg = error;
		if(typeof msg === 'object') msg = error.message;
	}finally{
		if (msg !== '' && typeof msg === 'string') {
			PHA.Popover({
                msg: msg,
                type: 'error'
            });
		}
		if (editRow >= 0){
			PHA_GridEditor.Edit({
				gridID : gridId,
				index : editRow,
				field : 'qty'
			});
		}
		return val;
	}
}
function SaveAdj(){
	var gridId = "gridMAdjDetail"
	PHA_GridEditor.End(gridId);
	if( ValidateEditGrid() ===false){return;}
	PHA_GridEditor.End(gridId);
	
	var retJson = PHA.GetVals(["adjId","adjLocId","reasonId","remarks"],"Json");
	if(retJson[0] == undefined) {return;}
	var pJson = {};
	pJson = retJson[0];
	pJson.userId = session['LOGON.USERID'];  
	var $grid = $('#' + gridId);
 	var rowsData = $grid.datagrid('getChanges');
    var rows = rowsData.length;
    var dataArr = [];
    for (var i = 0; i < rows; i++) {
		var rowData = rowsData[i];
		var adjItmId = rowData.adjItmId
		var inclb = rowData.inclb;
		if(inclb == ""){
			continue;
		} 
		var qty = rowData.qty;
		var uomId = rowData.uomId;
		var resultQty = rowData.resultQty;
		
		var iJson = {
			adjItmId :adjItmId,
	  		inclb : inclb,
            uomId : uomId,
            qty   : qty,
            resultQty : resultQty       
        };
        dataArr.push(iJson);
    }
    
	pJson.rows = dataArr;
	PHA.Loading("Show");
    PHA.CM({
		pClassName: 'PHA.IN.ADJ.Api',
		pMethodName: 'SaveData',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetAdjMainInfo(data.data);
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
    $('#gridMAdjDetail').datagrid('clear');
    $('#adjLocId').combobox('setValue', PHA_COM.Session.CTLOCID);
	$('#infoArea').phabanner('loadData', []);
    SetDisable();
}
function CleanQ()
{
    PHA.DomData("#winQCondition", {
        doType:'clear'
    })
    $('#gridAdjMain').datagrid('clear');
	$('#gridAdjDetail').datagrid('clear');
	InitDefVal();
}
function Complete(){
	var gridId = "gridMAdjDetail"
	PHA_GridEditor.End(gridId);
	if( ValidateEditGrid() ===false){return;}
	var retJson = PHA.GetVals(["adjId","adjLocId","reasonId","remarks"],"Json");
	if(retJson[0] == undefined) {return;}
	var pJson = {};
	pJson = retJson[0];
	pJson.userId = session['LOGON.USERID'];  
	var $grid = $('#' + gridId);
    //var rowsData = $grid.datagrid('getRows');
	var rowsData = $grid.datagrid('getChanges');
    var rows = rowsData.length;
    var dataArr = [];
    for (var i = 0; i < rows; i++) {
		var rowData = rowsData[i];
		var adjItmId = rowData.adjItmId
		var inclb = rowData.inclb;
		if(inclb == ""){
			continue;
		} 
		var qty = rowData.qty;
		var uomId = rowData.uomId;
		var iJson = {
			adjItmId :adjItmId,
	  		inclb : inclb,
            uomId : uomId,
            qty : qty         
        };
        dataArr.push(iJson);
    }
	pJson.rows = dataArr;
	pJson.compFlag = "Y";
	PHA.Loading('Show')
	PHA.CM({
		pClassName: 'PHA.IN.ADJ.Api',
		pMethodName: 'SaveComplete',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetAdjMainInfo(data.data);;
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})  	

}
function CancelComp(){
	PHA.Loading('Show')
	var pJson = {}
	var adjId = $('#adjId').val();
	pJson.adjId = adjId;
	pJson.compFlag = "N";
	pJson.userId =  session['LOGON.USERID'];
	PHA.CM({
		pClassName: 'PHA.IN.ADJ.Api',
		pMethodName: 'CancelComplete',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetAdjMainInfo(adjId);;
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	}) 
}
function Print(){
	var adjId = $('#adjId').val();
	if (adjId == ""){
		PHA.Msg("info", "请选择调整单据后打印！")
		return;
	}
	PrintAdj(adjId);
}
function DelAdj(){
	var Selected = $("#gridAdjMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var adjId = Selected.adjId;
	var pJson = {}
	pJson.adjId = adjId
	// 删除确认
	PHA.Confirm("删除提示", "是否确认删除该调整单?", function () {	  
		PHA.Loading('Show')
		PHA.CM({
			pClassName: 'PHA.IN.ADJ.Api',
			pMethodName: 'Delete',
			pJson: JSON.stringify(pJson)
		},function(data) {
			PHA.Loading("Hide");
			if(PHA.Ret(data)){
				QueryMain();
				var adjId = $('#adjId').val();
				if(adjId!=""){Clean();}
			}
		},function(failRet){
			PHA_COM._Alert(failRet);
		}) 
	});
}
function Delete(){
	var adjId = $('#adjId').val() || "";
	var rowsNum = $("#gridMAdjDetail").datagrid("getRows");
	if(rowsNum <= 0){
		Clean();
		return;
	}
	// 删除确认
	PHA.Confirm("删除提示", "是否确认删除该调整单?", function () {	
	    var pJson = {}
		if (adjId == ""){
			$('#gridMAdjDetail').datagrid('clear');
			 $('#reasonId').combobox('setValue', '');
			 return;
		}
		PHA.Loading('Show')
		pJson.adjId = adjId
		PHA.CM({
			pClassName: 'PHA.IN.ADJ.Api',
			pMethodName: 'Delete',
			pJson: JSON.stringify(pJson)
		},function(data) {
			PHA.Loading("Hide");
			if(PHA.Ret(data)){
				Clean();
			}
		},function(failRet){
			PHA_COM._Alert(failRet);
		}) 
	});
}
function AddOneRow(){
	if(APP_PROP_COM.StkCatSet == "N"){
		var stkGroup = $("#stkGrpId").combobox("getValues").join(",") || "";
		if(stkGroup == ""){
			PHA.Popover({
				msg: "类组，不能为空",
				type: "alert"
			});
			return;
		}  
	}
    PHA_GridEditor.Add({
        gridID: 'gridMAdjDetail',
        field: 'inciDesc',
        rowData: {},
        checkRow: true, // 新增行时是否验证上一行数据
        firstRow: false // 新增行放在最后还是最前
    }, 1);
}
function AddRows(nData, rowsData){
	for (var i = 0; i < rowsData.length; i++) {
		var iRowData = rowsData[i];
		var iAddData = {};
		iAddData.inci = nData.inci;
		iAddData.inciCode = nData.inciCode;
		iAddData.inciDesc = nData.inciDesc;
		iAddData.spec = nData.inciSpec;
		iAddData.stkbinDesc = nData.stkBin;
		iAddData.insuCode = nData.insuCode;
		iAddData.insuName = nData.insuName;
		
		iAddData.inclb = iRowData.inclb;
		iAddData.inclbQty = iRowData.inclbQty;  
		iAddData.avaQty = iRowData.avaQty;  
		
		iAddData.expDate = iRowData.expDate;
		iAddData.batNo = iRowData.batNo;
		iAddData.manfDesc = iRowData.manfName;
		iAddData.uomDesc = iRowData.pUomDesc;
		iAddData.uomId = iRowData.pUomId;
		iAddData.rp = iRowData.pRp;
		iAddData.sp = iRowData.pSp;
		iAddData.qty = iRowData.inputQty;
		iAddData.resultQty = iRowData.resultQty;
		if(iRowData.resultQty != ""){
			iAddData.qty = _.safecalc('add', iAddData.resultQty, _.safecalc('multiply', -1, iRowData.inclbQty))
		}
		iAddData.fac = iRowData.pFac;
		iAddData.bUomId = iRowData.bUomId;
		
		if (i == 0) {
			var selRow = $('#gridMAdjDetail').datagrid('getSelected');
			if (selRow && (selRow.inclb == '' || typeof selRow.inclb == 'undefined')) {
				var rowIndex = $('#gridMAdjDetail').datagrid('options').editIndex;
				$('#gridMAdjDetail').datagrid('updateRowData', {
					index: rowIndex,
					row: iAddData
				});
				ChangeRecordInfo(rowIndex, iRowData.inclb, iRowData.inputQty, iRowData.pUomId);
				continue;
			}
		}
		PHA_GridEditor.Add({
			gridID: 'gridMAdjDetail',
			field: '',
			rowData: iAddData
		});
		var curRowIndex = $('#gridMAdjDetail').datagrid("getRows").length - 1;
		ChangeRecordInfo(curRowIndex, iRowData.inclb, iRowData.inputQty, iRowData.pUomId);
	
	}
	setTimeout(function(){AddOneRow()},200)
}
function DelChkRows(){
	// 要删除的ID
	var $grid = $('#gridMAdjDetail');
	var checkedRows = $grid.datagrid('getChecked');
	if (checkedRows.length === 0) {
		PHA.Popover({
			msg: "请选择需要删除的数据!",
			type: "alert"
		});
		return;
	}
	var pJson = {};
	var adjItmArr = [];
	for (const rowData of checkedRows) {
		var adjItmId = rowData.adjItmId || '';
		if (adjItmId !== '') {
			adjItmArr.push({ adjItmId: adjItmId });
		}
	}
	pJson.rows = adjItmArr;
	// 删除确认
	PHA.Confirm("删除提示",$g("是否确认删除") + "<span>" + checkedRows.length + "</span>" + $g("记录吗?"), function () {
		PHA.Loading('Show')
		PHA.CM({
			pClassName: 'PHA.IN.ADJ.Api',
			pMethodName: 'DeleteItms',
			pJson: JSON.stringify(pJson)
		},function(data) {
			PHA.Loading("Hide");
			var rows = $grid.datagrid('getRows');
			for (const chkit of checkedRows) {
				var rowIndex = rows.indexOf(chkit);
				$('#gridMAdjDetail').datagrid('deleteRow', rowIndex);
			}
			
			var adjId = $('#adjId').val();
			var pJson = {adjId :adjId}
			PHA.CM(
		        {
		            pClassName : 'PHA.IN.ADJ.Api',  
		            pMethodName: 'GetAdjMainInfo',
		            pJson	   : JSON.stringify(pJson),
		        },
		        function (retData) {
					if(retData[0]&&retData[0].noItmFlag){
						PHA.Confirm('提示', '明细已经没有记录，您是否同时删除此单据？', function () {
							PHA.Loading('Show')						
								PHA.CM({
									pClassName: 'PHA.IN.ADJ.Api',
									pMethodName: 'Delete',
									pJson: JSON.stringify(pJson)
								},function(data) {
									PHA.Loading("Hide");
									if(PHA.Ret(data)){
										QueryMain();
										var adjId = $('#adjId').val();
										if(adjId!=""){Clean();}
									}
								},function(failRet){
									PHA_COM._Alert(failRet);
								})
					   });   
			       }
			       else{
				       PHA.Msg('success', '删除成功');
				       CalcAmt();
			       }
		        }
		    )
		},function(failRet){
			PHA_COM._Alert(failRet);
		}) 
	});
}
function QueryMain(){
	var $grid =  $("#gridAdjMain");
	$('#gridAdjDetail').datagrid('clear');
    var stDate = $("#stDate").datebox("getValue") || ""; 
    var endDate = $("#endDate").datebox("getValue") || "";
    var locId = $("#phLoc").combobox("getValue") || "";  
    var stkGroup = $("#inStkGroup").combobox("getValues").join(",") || "";  
    var adjRea = $("#adjReason").combobox("getValue") || "";  
    var adjStatus = $("#buisProcess").combobox("getValues").join(",");
    if(adjStatus == ""){
		var comboData=$("#buisProcess").combobox('getData');
		for(var i = 0; i < comboData.length; i++){
			if(adjStatus == "") {adjStatus=comboData[i].RowId;}
			else{adjStatus=adjStatus + "," + comboData[i].RowId;}
		}
	}
    var instFlag = "N";
    var pJson = {};
    pJson.stDate = stDate;  
    pJson.endDate = endDate;
    pJson.locId = locId;
    pJson.stkGroup = stkGroup;
    pJson.adjRea = adjRea;
    pJson.adjStatus = adjStatus;
    pJson.instFlag = instFlag;
	$grid.datagrid('options').url = PHA.$URL;
    $grid.datagrid('query',{
        pClassName:'PHA.IN.ADJ.Api' ,
        pMethodName:'GetAdjMainList',
        pPlug:'datagrid',
        pJson: JSON.stringify(pJson)
    });
}
function QueryDetail(){
	var $grid = $("#gridAdjDetail")
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
function SelectAdj(){
    var Selected = $("#gridAdjMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var adjId = Selected.adjId;
    Close();
    var copyFlag = $('#btnSelAdj')[0].innerText.indexOf($g("复制")) > -1 ? true : false;
    
    if(copyFlag == true){
		CopyAdj(adjId)
	}else{
  		GetAdjMainInfo(adjId);
  		$("#stkGrpId").combobox("setValues","");  
	}
}
// 获取主界面数据
function GetAdjMainInfo(adjId)
{
	var pJson = {};
    pJson.adjId = adjId; 
    PHA.Loading('Show')
    PHA.CM({
		pClassName: 'PHA.IN.ADJ.Api',
		pMethodName: 'GetAdjMainInfo',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide")
		if(PHA.Ret(data)){
			var locId = data[0].adjLocId || '' ;
            var locDesc = data[0].adjLocDesc || '' ;
            data[0].adjLocId = {
                RowId: locId,
                Description:locDesc,
                Select: false
            }
			PHA.SetVals(data, "#qCondition");
			SetDisable();
			SetInfoArea(data);
			$("#gridMAdjDetail").datagrid('query',{
				pPlug:'datagrid',
		        pJson: JSON.stringify(pJson)
		    });
		}else{
			PHA_COM._Alert(failRet);
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})
}


function Close(){
    $('#diagFindAdj').dialog('close');
}

// 按钮不可用
function SetDisable(flag)
{	if(flag == undefined){
		var flag = $("#compFlag").checkbox("getValue");
	}
	var adjId = $('#adjId').val() || "";
	if(adjId == ""){
		$("#adjLocId").combobox('enable'); 
	}else{
		$("#adjLocId").combobox('disable'); 
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
		'#btnAddRows': {
			disabled : flag == true
		},
		'#btnDelRows': {
			disabled : flag == true
		},
		'#btnSave': {
			disabled : flag == true
		},
		'#btnPrint': {
			disabled : adjId == ""
		}
	});
}

function ChangeQtyByResultQty(rowIndex, resultQty, inclbQty){
	if ((resultQty == "")||(isNaN(resultQty))||resultQty==undefined) return;
	var qty = _.safecalc('add', resultQty, _.safecalc('multiply', -1, inclbQty))
	var data = {
		'qty' : qty
	}
	$('#gridMAdjDetail').datagrid('updateRowData', {
		index: rowIndex,
		row: data
	});
	CalcAmt();
}


function ChangeRecordInfo(rowIndex, inclb, qty, uomId){

	var pJson = {};
	pJson.inclb = inclb ;
	pJson.qty = qty ;
	pJson.uomId = uomId ;
	PHA.CM({
		pClassName: 'PHA.IN.ADJ.Api',
		pMethodName: 'ChangeRecordInfo',
		pJson: JSON.stringify(pJson)
	},function(data) {
		$('#gridMAdjDetail').datagrid('updateRowData', {
			index: rowIndex,
			row: data
		});
		CalcAmt();
		
	},function(failRet){
		PHA_COM._Alert(failRet);
	}) 
}

function CalcAmt(){
	PHA_COM.SumGridFooter('#gridMAdjDetail' , ['rpAmt', 'spAmt']);
}
// 获取复制的调整单信息
function CopyAdj(adjId){

	var pJson = {};
    pJson.adjId = adjId; 
    pJson.userId = session['LOGON.USERID'];  
    PHA.Loading('Show')
    PHA.CM({
		pClassName: 'PHA.IN.ADJ.Api',
		pMethodName: 'CopyAdj',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide")
		if(PHA.Ret(data)){
			GetAdjMainInfo(data.data);
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})
}

function SetInfoArea(retData){
	var dataArr = [
	  {
	    info: retData[0].adjNo ,
	    append: '/'
	  },
	  {
	    prepend: $g("制单")+":",
	    info: retData[0].adjUserName + ' ' + retData[0].adjDate+ ' ' + retData[0].adjTime,
	    append: '/'
	  },
	  {
	    info:retData[0].compFlag == "Y" ? $g("完成"): $g("未完成"),
	    labelClass: retData[0].compFlag == "Y" ? 'info' : 'danger'
	  }
	];
	
	$('#infoArea').phabanner('loadData', dataArr);
}

function GetDecimals(fmt){
	var decimals = 2; // 默认两位
	if (fmt.indexOf('.') < 0) return GetDecimals;
	var decimalsStr = fmt.split('.')[1];
	return decimalsStr.length;

}
