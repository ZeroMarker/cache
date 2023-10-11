/*
/// Creator     zhaozhiduan
/// CreatDate   2022年03月11日
/// Description 库存报损建单
*/
var APP_NAME = "DHCSTINSCRAP"
var APP_PROP = PHA_COM.ParamProp(APP_NAME)
var APP_PROP_COM = PHA_COM.ParamProp("DHCSTCOMMON");
var BUIS_CODE = "SCRAP";
var BUIS_RANGE = "All";
$(function(){
	PHA_COM.SetPanel('#panel');
    InitDict();             // 初始化条件字典
    InitGridMScrapDetail();   // 初始化grid
    InitBtn();              // 初始化按钮
    // dialog 初始化
    InitGridScrapMain();
    InitGridScrapDetail();
    SetDisable();
	SetRequired();
	setTimeout(function () {
		PHA_COM.ResizePanel({
		   layoutId: 'layout-scrap-create-diag',
		   region: 'north',
		   height: 0.5 
	   });
   }, 0);
	
})
function InitDefVal(){
	var locId =  $("#scrapLocId").combobox("getValue") || PHA_COM.Session.CTLOCID
    $('#phLoc').combobox('setValue', locId);
    $("#stDate").datebox("setValue",APP_PROP.DefStartDate) ;
    $("#endDate").datebox("setValue",APP_PROP.DefEndDate) ;
	$('#buisProcess').combobox('reload');
}
function SetRequired(){
	PHA.SetRequired($('#gridScrapMainBar' + ' [data-pha]'))
	PHA.SetRequired($('#gridMScrapDetailBar' + ' [data-pha]'))
}
function InitBtn(){
	PHA_EVENT.Bind('#btnFind', 		'click', function () {ShowDiagScrap(this);});
	PHA_EVENT.Bind('#btnSave', 		'click', function () {SaveScrap();});
	PHA_EVENT.Bind('#btnClean', 	'click', function () {Clean();});

	PHA_EVENT.Bind('#btnComplete', 	'click', function () {Complete();});
	PHA_EVENT.Bind('#btnCancelComp','click', function () {CancelComp();});
	PHA_EVENT.Bind('#btnPrint', 	'click', function () {Print();});
    PHA_EVENT.Bind('#btnDelete', 	'click', function () {Delete();});
	PHA_EVENT.Bind('#btnCopyScrap', 'click', function () {ShowDiagScrap(this);});

    //表格按钮
    PHA_EVENT.Bind('#btnAddRows', 	'click', function () {AddOneRow();});
	PHA_EVENT.Bind('#btnDelRows', 	'click', function () {DelChkRows();});
    // dialog 按钮
    PHA_EVENT.Bind('#btnSearch', 	'click', function () {QueryMain();});
	PHA_EVENT.Bind('#btnCleanQ', 	'click', function () {CleanQ();});
    PHA_EVENT.Bind('#btnSelScrap', 	'click', function () {SelectScrap();});
	PHA_EVENT.Bind('#btnDelScrap', 	'click', function () {DelScrap();});
	
}

function InitDict(){
	//药房科室
    PHA_UX.ComboBox.Loc('scrapLocId');
    
	//类组
	PHA_UX.ComboBox.StkCatGrp('stkGrpId', {
		panelHeight:'auto',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		qParams: {
			LocId: PHA_UX.Get('scrapLocId', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	
     //库存报损原因
    PHA.ComboBox('reasonId', {
		panelHeight:'auto',
        url: PHA_IN_STORE.ReasonForScrap().url
    });
    
    // dialog 药房科室
    //药房科室
    PHA_UX.ComboBox.Loc('phLoc');
	//类组
	PHA_UX.ComboBox.StkCatGrp('inStkGroup', {
		panelHeight:'auto',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		qParams: {
			LocId: PHA_UX.Get('phLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
    //库存报损原因
    PHA.ComboBox('scrapReason', {
		panelHeight:'auto',
        url: PHA_IN_STORE.ReasonForScrap().url
    });
	 /* 信息展示框 */
	$('#infoArea').phabanner({
	    title: $g('选择单据后, 显示详细信息')
	});
}
function InitScrapStatus(flag)
{
	//业务流程
	PHA.ComboBox('buisProcess', {
		multiple:true,
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
						if((desc.indexOf("保存") < 0)&&(desc.indexOf("完成") < 0 )) continue;
					}else if(flag == 2){	 //复制
						if(desc.indexOf("作废") < 0) continue;
					}
                    displayData.push(iData);
                }
                return displayData;				
			}
        }
    });
}
function InitGridMScrapDetail(){
    var gridId = 'gridMScrapDetail'
    var columns = [
        [
            { field: 'spec', 		title: '规格', 			align: 'left', 	width: 80 },
            { field: 'stkbinDesc', 	title: '货位', 			align: 'left', 	width: 80 },
            { field: 'qty', 		title: '报损数量',		align: 'right',	width: 80,
            	editor: PHA_GridEditor.NumberBox({
	            	required: true,
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
						if (nQty <= 0) {
							checkRet.msg = "请输入大于0的数字！";
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
            { field: 'scrapItmId',  title: 'scrapItmId',	align: 'left',	width: 100, hidden: true },
            { field: 'inciCode',    title: '代码', 			align: 'left',	width: 100, sortable: true},
            { field: 'inciDesc',    title: '名称',  align: 'left',    width: 300, sortable: true,
                editor: PHA_UX.Grid.INCItmBatWin({
					onBeforeLoad: function(param, gridRowData){
						param.hospId = session['LOGON.HOSPID'];
						param.pJsonStr = JSON.stringify({
							stkType: App_StkType,
							scgId: $("#stkGrpId").combobox("getValues").join(",") || "", 
							locId: $("#scrapLocId").combobox("getValue") || "",
							userId: session['LOGON.USERID'],
							notUseFlag: '',
							qtyFlag: '1',
							reqLocId: ''
						});
					},
					onBeforeNext: function (winData, gridRowData, gridRowIndex) {
						if (winData.action == 'close') {
							return true;
						}
						var nData = winData.north;
						var cData = winData.center;
						return true;
					},
					onClickSure: function(winData){
						var nData = winData.north;
						var cDataRows = winData.center;
						AddRows(nData, cDataRows);
					}
				},{
					inputType: 'SCRAP'
				})
            }
        ]
    ];

    var dataGridOption = {
        fit: true,
        rownumbers: true,
        pagination: false,
        toolbar: '#gridMScrapDetailBar',
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
            pClassName:'PHA.IN.SCRAP.Api' ,
            pMethodName:'GetScrapDetail',
            pPlug:'datagrid',
            pJson:'{}'
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
function InitGridScrapMain(){
    var columns = [
        [
            { field: 'scrapId',		title: '单据id',	align: 'left',	width: 80,	hidden: true  },
            { field: 'scrapNo',		title: '单号',		align: 'left',	width: 160,
				styler: function(value,row,index){				
					return {class:"pha-grid-link" };
				}	
			},
            { field: 'scrapLoc',    title: '科室',		align: 'left',	width: 100,	hidden: true  },
            { field: 'scrapDate',   title: '制单日期',  align: 'left',	width: 80 },
            { field: 'scrapTime',   title: '制单时间',  align: 'left',	width: 80 },
            { field: 'rpAmt',       title: '进价金额',  align: 'right',	width: 80 },
            { field: 'spAmt',       title: '售价金额',  align: 'right',	width: 80 },
            { field: 'reasonId',  	title: '报损原因',  align: 'left',	width: 100,	hidden: true   },
            { field: 'reasonDesc',  title: '报损原因',  align: 'left',	width: 100 },
            { field: 'remarks',		title: '备注',		align: 'left',	width: 100 },
            { field: 'curStatus',   title: '状态',		align: 'left',	width: 80 },
            { field: 'curPbDate',   title: '状态操作日期',	align: 'left',	width: 100 },
            { field: 'curPbTime',   title: '状态操作时间',	align: 'left',	width: 80 },
            { field: 'curPbUser', 	title: '状态操作人',	align: 'left',	width: 100 },
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
        onDblClickRow: function (rowIndex, rowData) {
            if (rowData) {
                SelectScrap()
            }
        },
        onLoadSuccess: function (data) {
            if(data.total>0){
                $('#gridScrapMain').datagrid("selectRow",0);
            }else{
	        	$('#gridScrapDetail').datagrid('clear');
	        }
        },
		onClickCell: function (index, field, value) {            
			if(field=="scrapNo"){
                var rowData = $('#gridScrapMain').datagrid('getData').rows[index];
                PHA_UX.BusiTimeLine({},{
                    busiCode:BUIS_CODE,
                    locId:$("#scrapLocId").combobox("getValue") || PHA_COM.Session.CTLOCID,
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
        columns: columns,
        frozenColumns: frozenColumns,
		showFooter: true,
        onLoadSuccess: function (data) {
            PHA_COM.SumGridFooter('#gridScrapDetail' , ['rpAmt', 'spAmt']);
         }
    };
    PHA.Grid('gridScrapDetail', dataGridOption);

}
function ShowDiagScrap(btnOpt){
	var isFind = btnOpt.id.indexOf('Find') > -1 ? true : false;
    $('#diagFindScrap').dialog({
            title: btnOpt.text,
            iconCls: isFind ? 'icon-w-list' : 'icon-w-copy',
            width: PHA_COM.Window.Width(),
            height: PHA_COM.Window.Height(),
            modal: true
    }).dialog('open');
    if(isFind == true){
		 $('#btnSelScrap').linkbutton({text: '选取'})
		 $('#btnDelScrap').show();
	 	InitScrapStatus(1);
	}else{
		$('#btnSelScrap').linkbutton({text: '复制'})
		$('#btnDelScrap').hide();
		InitScrapStatus(2);
	}
    $('#gridScrapMain').datagrid('clear');
    $('#gridScrapDetail').datagrid('clear');
    InitDefVal();
}
function ValidateEditGrid(){
	var val = true
	var msg = "";
	var gridId = "gridMScrapDetail";
	var $grid = $('#' + gridId);
	PHA_GridEditor.GridFinalDone("#gridMScrapDetail", 'inclb');
	var rows = $grid.datagrid('getRows');
	if (rows.length == 0) {
		PHA.Msg('error', $g("明细没有数据！"));
		return false;
	}
	var editRow = 0;
	try{
		var chkRetStr = PHA_GridEditor.CheckValues(gridId);
		if(chkRetStr != ""){
			throw chkRetStr;
		}
		var chkRetStr = PHA_GridEditor.CheckDistinct({gridID : gridId,fields : ["inclb"]});
		if(chkRetStr != ""){
			throw  chkRetStr;
		}
		
		var rowsData = $grid.datagrid('getRows');
		var rows = rowsData.length;
		for (var i = 0; i < rows; i++) {
			var rowData = rowsData[i];
			var inclb = rowData.inclb;
			if(inclb == ""){
				continue;
			} 
			var qty = rowData.qty;
			var fac = rowData.fac;
			var uomId = rowData.uomId;
			var buomId = rowData.bUomId;
			var inclbQty = rowData.inclbQty;
			if ((qty == '')||(parseFloat(qty) <= 0)){
				editRow =  i + 1;
				throw $g("第" + (i + 1) + "行,报损数量必须大于0!");
			} 
			if (parseFloat(qty) > parseFloat(inclbQty)){
				editRow =  i + 1;
				throw $g("第" + (i + 1) + "行,报损数量不能超过批次库存!!");	
			} 
			var bQty;
			if(APP_PROP.StockAllowDecimal != "Y"){
				if(buomId != uomId)
				{
					bQty = Math.imul(qty, fac);
				}else{
					bQty = qty;
				}
				if (parseInt(bQty, 10) != bQty){
					editRow =  i + 1;
					throw $g("第" + (i + 1) + "行, 报损数量存在小数，不能报损！请核对库存报损配置：报损数量换算为基本单位是否允许小数!");
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
		if (editRow>0){
			PHA_GridEditor.Edit({
				gridID : gridId,
				index : editRow,
				field : 'qty'
			});
		}
		return val;
	}
}
function SaveScrap(){
	var gridId = "gridMScrapDetail"
	PHA_GridEditor.End(gridId);
	if( ValidateEditGrid() ===false){return;}

	var retJson = PHA.GetVals(["scrapId","scrapLocId","reasonId","compFlag","remarks"],"Json")
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
		var scrapItmId = rowData.scrapItmId;
		var inclb = rowData.inclb;
		if(inclb == ""){
			continue;
		} 
		var qty = rowData.qty;
		var uomId = rowData.uomId;
		var iJson = {
			scrapItmId : scrapItmId,
	  		inclb : inclb,
            uomId : uomId,
            qty : qty         
        };
        dataArr.push(iJson);
    }
   
	pJson.rows = dataArr;
	PHA.Loading("Show");
    PHA.CM({
		pClassName: 'PHA.IN.SCRAP.Api',
		pMethodName: 'SaveData',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetScrapMainInfo(data.data);
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
    $('#gridMScrapDetail').datagrid('clear');
    $('#scrapLocId').combobox('setValue', PHA_COM.Session.CTLOCID);
	$('#infoArea').phabanner('loadData', []);
    SetDisable();
}
function CleanQ()
{
    PHA.DomData("#winQCondition", {
        doType:'clear'
    })
    $('#gridScrapMain').datagrid('clear');
	$('#gridScrapDetail').datagrid('clear');
	InitDefVal();
}
function Complete(){
	var gridId = "gridMScrapDetail"
	PHA_GridEditor.End(gridId);
	if( ValidateEditGrid() ===false){return;}
	
	
	var retJson = PHA.GetVals(["scrapId","scrapLocId","reasonId","compFlag","remarks"],"Json")
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
		var scrapItmId = rowData.scrapItmId;
		var inclb = rowData.inclb;
		if(inclb == ""){
			continue;
		} 
		var qty = rowData.qty;
		var uomId = rowData.uomId;
		var iJson = {
			scrapItmId : scrapItmId,
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
		pClassName: 'PHA.IN.SCRAP.Api',
		pMethodName: 'SaveComplete',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetScrapMainInfo(data.data);;
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})  	

}
function CancelComp(){
	PHA.Loading('Show')
	var pJson = {}
	var scrapId = $('#scrapId').val();
	pJson.scrapId = scrapId;
	pJson.compFlag = "N";
	pJson.userId = session['LOGON.USERID'];
	PHA.CM({
		pClassName: 'PHA.IN.SCRAP.Api',
		pMethodName: 'CancelComplete',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide");
		if(PHA.Ret(data)){
			GetScrapMainInfo(scrapId);;
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	}) 
}
function Print(){
	var scrapId = $('#scrapId').val();
	if (scrapId == ""){
		PHA.Msg("info", $g("请选择报损单据后打印！"))
		return;
	}
	PrintScrap(scrapId);
}
function DelScrap(){
	var Selected = $("#gridScrapMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var scrapId = Selected.scrapId;
	var pJson = {}
	pJson.scrapId = scrapId
	PHA.Confirm($g("删除提示"), $g("是否确认删除该报损单?"), function () {
		PHA.Loading('Show')	
		PHA.CM({
			pClassName: 'PHA.IN.SCRAP.Api',
			pMethodName: 'Delete',
			pJson: JSON.stringify(pJson)
		},function(data) {
			PHA.Loading("Hide");
			if(PHA.Ret(data)){
				QueryMain();
				var scrapId = $('#scrapId').val();
				if(scrapId!=""){Clean();}
			}
		},function(failRet){
			PHA_COM._Alert(failRet);
		}) ;
	}); 
}
function Delete(){
	var scrapId = $('#scrapId').val();
	var rowsNum = $("#gridMScrapDetail").datagrid("getRows");
	if(rowsNum <= 0){
		Clean();
		return;
	}
	// 删除确认
	PHA.Confirm("删除提示", "是否确认删除该报损单?", function () {
	    var pJson = {}
		
		if (scrapId == ""){
			$('#gridMScrapDetail').datagrid('clear');
			 $('#reasonId').combobox('setValue', '');
			 return;
		}
		PHA.Loading('Show')
		pJson.scrapId = scrapId
		PHA.CM({
			pClassName: 'PHA.IN.SCRAP.Api',
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
        gridID: 'gridMScrapDetail',
        field: 'inciDesc',
        rowData: {},
        checkRow: true, // 新增行时是否验证上一行数据
        firstRow: false // 新增行放在最后还是最前
    }, 1);
	SetDisable();
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
		iAddData.bUomId = iRowData.bUomId;
		iAddData.fac = iRowData.pFac;

		iAddData.inclb = iRowData.inclb;
		iAddData.inclbQty = iRowData.inclbQty;
		iAddData.expDate = iRowData.expDate;
		iAddData.batNo = iRowData.batNo;
		iAddData.manfDesc = iRowData.manfName;
		iAddData.uomDesc = iRowData.pUomDesc;
		iAddData.uomId = iRowData.pUomId;
		iAddData.rp = iRowData.pRp;
		iAddData.sp = iRowData.pSp;
		iAddData.qty = iRowData.inputQty;

		
		if (i == 0) {
			var selRow = $('#gridMScrapDetail').datagrid('getSelected');
			if (selRow && (selRow.inclb == '' || typeof selRow.inclb == 'undefined')) {
				var rowIndex = $('#gridMScrapDetail').datagrid('options').editIndex;
				$('#gridMScrapDetail').datagrid('updateRow', {
					index: rowIndex,
					row: iAddData
				});
				ChangeRecordInfo(rowIndex, iRowData.inclb, iRowData.inputQty, iRowData.pUomId);
				continue;
			}
		}
		PHA_GridEditor.Add({
			gridID: 'gridMScrapDetail',
			field: '',
			rowData: iAddData
		});
		var curRowIndex = $('#gridMScrapDetail').datagrid("getRows").length - 1;
		ChangeRecordInfo(curRowIndex, iRowData.inclb, iRowData.inputQty, iRowData.pUomId);
	}
	//setTimeout(function(){AddOneRow()},200)
}
function DelChkRows(){
	// 要删除的ID
	var $grid = $('#gridMScrapDetail');
	var checkedRows = $grid.datagrid('getChecked');
	if (checkedRows.length === 0) {
		PHA.Popover({
			msg: "请选择需要删除的数据!",
			type: "alert"
		});
		return;
	}
	var pJson = {};
	var scrapItmArr = [];
	for (const rowData of checkedRows) {
		var scrapItmId = rowData.scrapItmId || '';
		if (scrapItmId !== '') {
			scrapItmArr.push({ scrapItmId: scrapItmId });
		}
	}
	pJson.rows = scrapItmArr;
	// 删除确认
	PHA.Confirm("删除提示",$g("是否确认删除") +"<span>" + checkedRows.length + "</span>" + $g("记录吗?"), function () {
		PHA.Loading('Show')
		PHA.CM({
			pClassName: 'PHA.IN.SCRAP.Api',
			pMethodName: 'DeleteItms',
			pJson: JSON.stringify(pJson)
		},function(data) {
			PHA.Loading("Hide");
			var rows = $grid.datagrid('getRows');
			for (var j=0;j<checkedRows.length;j++) {
				var tmprowData = checkedRows[j]
				var rowIndex = rows.indexOf(tmprowData);
				$grid.datagrid('deleteRow', rowIndex);
			}
			
			var scrapId = $('#scrapId').val();
			var pJson = {scrapId :scrapId}
			PHA.CM(
		        {
		            pClassName : 'PHA.IN.SCRAP.Api',  
		            pMethodName: 'GetScrapMainInfo',
		            pJson	   : JSON.stringify(pJson),
		        },
		        function (retData) {
					if(retData[0]&&retData[0].noItmFlag){
						PHA.Confirm('提示', '明细已经没有记录，您是否同时删除此单据？', function () {
							PHA.Loading('Show')						
								PHA.CM({
									pClassName: 'PHA.IN.SCRAP.Api',
									pMethodName: 'Delete',
									pJson: JSON.stringify(pJson)
								},function(data) {
									PHA.Loading("Hide");
									if(PHA.Ret(data)){
										var scrapId = $('#scrapId').val();
										if(scrapId!=""){Clean();}
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
	SetDisable();

}
function QueryMain(){
    var $grid = $("#gridScrapMain");
	var retJson = PHA.GetVals(["stDate","endDate","phLoc"],"Json");
	if(retJson[0] == undefined) {return;}
	$('#gridScrapDetail').datagrid('clear');
    var stDate = $("#stDate").datebox("getValue") || ""; 
    var endDate = $("#endDate").datebox("getValue") || "";
    var locId = $("#phLoc").combobox("getValue") || "";  
    var stkGroup = $("#inStkGroup").combobox("getValues").join(",") || "";  
    var scrapRea = $("#scrapReason").combobox("getValue") || "";  
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
	var $grid = $("#gridScrapDetail")
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
function SelectScrap(){
    var Selected = $("#gridScrapMain").datagrid("getSelected") || "";
    if(Selected == ""){return}
    var scrapId = Selected.scrapId;
    CloseDiag();
    var copyFlag = $('#btnSelScrap')[0].innerText.indexOf($g("复制")) > -1 ? true : false;
    if(copyFlag == true){
		CopyScrap(scrapId)
	}else{
  		GetScrapMainInfo(scrapId);
  		$("#stkGrpId").combobox("setValues","");  
	}
   
}
// 获取主界面数据
function GetScrapMainInfo(scrapId)
{
	var pJson = {};
    pJson.scrapId = scrapId; 
    PHA.Loading('Show')
    PHA.CM({
		pClassName: 'PHA.IN.SCRAP.Api',
		pMethodName: 'GetScrapMainInfo',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide")
		if(PHA.Ret(data)){
			var locId = data[0].scrapLocId || '' ;
            var locDesc = data[0].scrapLocDesc || '' ;
            data[0].scrapLocId = {
                RowId: locId,
                Description:locDesc,
                Select: false
            }
			PHA.SetVals(data, "#qCondition");
			SetDisable()
			SetInfoArea(data)
			$("#gridMScrapDetail").datagrid('query',{
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

function CloseDiag(){
    $('#diagFindScrap').dialog('close');
}

// 按钮不可用
function SetDisable(flag)
{	if(flag == undefined){
		var flag = $("#compFlag").checkbox("getValue");
	}
	var scrapId = $('#scrapId').val() || "";
	var $grid = $('#gridMScrapDetail' );
	var rowsData = $grid.datagrid('getRows');
	var rows = rowsData.length;
	if((scrapId == "")&&(rows == 0)){
		$("#scrapLocId").combobox('enable'); 
	}else{
		$("#scrapLocId").combobox('disable'); 
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
			disabled : scrapId == ""
		}
	});

	
}
function ChangeRecordInfo(rowIndex, inclb, qty, uomId){

	var pJson = {};
	pJson.inclb = inclb ;
	pJson.qty = qty ;
	pJson.uomId = uomId ;
	PHA.CM({
		pClassName: 'PHA.IN.SCRAP.Api',
		pMethodName: 'ChangeRecordInfo',
		pJson: JSON.stringify(pJson)
	},function(data) {
		$('#gridMScrapDetail').datagrid('updateRowData', {
			index: rowIndex,
			row: data
		});
		CalcAmt();
		
	},function(failRet){
		PHA_COM._Alert(failRet);
	}) 
}

function CalcAmt(){
	PHA_COM.SumGridFooter('#gridMScrapDetail' , ['rpAmt', 'spAmt']);
}

// 获取复制的报损单信息
function CopyScrap(scrapId){

	var pJson = {};
    pJson.scrapId = scrapId; 
    pJson.userId = session['LOGON.USERID'];  
    PHA.Loading('Show')
    PHA.CM({
		pClassName: 'PHA.IN.SCRAP.Api',
		pMethodName: 'CopyScrap',
		pJson: JSON.stringify(pJson)
	},function(data) {
		PHA.Loading("Hide")
		if(PHA.Ret(data)){
			GetScrapMainInfo(data.data);
		}
	},function(failRet){
		PHA_COM._Alert(failRet);
	})
}

function SetInfoArea(retData){
	var dataArr = [
	  {
	    info: retData[0].scrapNo ,
	    append: '/'
	  },
	  {
	    prepend: $g("制单")+":" ,
	    info: retData[0].scrapUserName + ' ' + retData[0].scrapDate+ ' ' + retData[0].scrapTime,
	    append: '/'
	  },
	  {
	    info:retData[0].compFlag == "Y" ? $g("完成"): $g("未完成"),
	    labelClass: retData[0].compFlag == "Y" ? 'info' : 'danger'
	  }
	];
	
	$('#infoArea').phabanner('loadData', dataArr);

}