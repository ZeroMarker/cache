/**
 * 模块:     库存转移制单
 * 编写日期: 2022-04-41
 * 编写人:   yangsj
 */
var InitId = '' 

var BTNARR  = ['btnSave', 'btnComp', 'btnAddi', 'btnDeletei', 'btnDelete'] 	//定义会变化使用状态的按钮集
var COMBARR = ['recLocId', 'proLocId'] 							//定义会变化使用状态的下拉框数据集

var INITIGRID = 'gridIniti';
var INITGRID_F = 'gridInit_f';
var INITIGRID_F = 'gridIniti_f';
var INITBAR = '#gridInitiBar';
var INITBAR_F = '#gridInitBar_f';

var com = INIT_COM;
var com_req = INRQ_COM;
var compoments = INIT_COMPOMENTS;
var compoments_req = INRQ_COMPOMENTS;

$(function () {
	SetPanel();
    InitDict();
    InitGrid();
    SetRequired();
    BindBtnEvent();
    SetBtnAndComb();
    DefultQuery();
});

function SetPanel(){
	$('#panelInit').panel({
		title: PHA_COM.IsTabsMenu() !== true ? '库存请求制单' : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-template',
		bodyCls: 'panel-body-gray',
		fit: true
	});
}

function SetRequired(){
	PHA.SetRequired($(INITBAR + ' [data-pha]'));
	PHA.SetRequired($(INITBAR_F + ' [data-pha]'));
	PHA.SetRequired($('#gridInrqBar_f [data-pha]'));
	PHA.SetRequired($('#diagCopyIntiCondition [data-pha]'));
}

function BindBtnEvent(){
	PHA.BindBtnEvent(INITBAR)
	PHA.BindBtnEvent(INITBAR_F)
	PHA.BindBtnEvent('#gridInrqBar_f')
	PHA_EVENT.Bind('#btnCopyInit', 'click', function(){CopyInit();});
}

function InitDict(){
	/* 转移类型 */
	compoments.OpertId('opertId', true);
	compoments.OpertId('opertId_f');
	
    /* 流程状态 */
    compoments.StatusCode('statusCode_f', 'CREATE', '', true);
    
    /* 供给科室和请求科室  */
    compoments.FrToLoc('proLocId', ['recLocId'], '', SetOpertId);
    compoments.FrToLoc('proLocId_f', ['recLocId_f']);
    compoments.FrToLoc('proLocId_req', ['recLocId_req', 'recLocId_copy']);

    /* 类组 */
    compoments.Scg('scg', 'proLocId');
	
	/* 信息展示框 */
	$('#infoArea').phabanner({ title: $g('选择单据后, 显示详细信息')});
	
	/* 申请单状态 */
	compoments_req.ReqStatus('reqStatus_req', 'TRANS', true);
	
	/* 申请类型 */
	compoments_req.ReqTypeId('reqTypeId_req', true);
}

function InitGrid(){
	InitGridIniti();
}

function InitGridIniti(){
	var frozenColumns = [
		[	
			{ field: 'tSelect',		checkbox: true},
			{ field: 'initiId', 	title: 'initiId', 		hidden: true },
            { field: 'inci', 		title: 'inci', 			hidden: true },
            { field: 'inclb', 		title: 'inclb', 		hidden: true },
            { field: 'inciCode',	title: '药品代码',		width: 100,			align: 'left' },
            { field: 'inciDesc',
				title: '药品名称',
				width: 200,
				align: 'left',
                editor:
					PHA_UX.Grid.INCItmBatWin({
						onBeforeLoad: function(param, gridRowData){
							param.hospId = session['LOGON.HOSPID'];
							param.pJsonStr = JSON.stringify({
								stkType: App_StkType,
								scgId: $('#scg').combobox('getValues').join(",") || '', 
								locId: $('#proLocId').combobox('getValue') || '',
								userId: session['LOGON.USERID'],
								notUseFlag: '',
								qtyFlag: '',
								reqLocId: $('#recLocId').combobox('getValue') || ''
							});
						},
						onBeforeNext: function (winData, gridRowData, gridRowIndex) {
							if (winData.action == 'close') {
								return true;
							}
							var nData = winData.north;
							var cData = winData.center;
							$.extend(gridRowData, nData);
							$.extend(gridRowData, cData);
						},
						onClickSure: function(winData){
							var nData = winData.north;
							var cDataRows = winData.center;
							AddRows(nData, cDataRows);
						}
					})
				
            }
		]
	];	
			
	var columns = [
        [
            { field: 'qty', 		title: '转移数量', 		width: 80, 		align: 'right',
            	editor: PHA_GridEditor.NumberBox({
	            	required: true,
					checkValue: function (val, checkRet) {
						if (val == '') {
							checkRet.msg = '不能为空！'
								return false;
						}
						var nQty = parseFloat(val);
						if (isNaN(nQty)) {
							checkRet.msg = '请输入数字！';
							return false;
						}
						if (nQty < 0) {
							checkRet.msg = '请输入大于0的数字！';
							return false;
						}
						return true;
					},
					onBeforeNext: function (val, gridRowData, gridRowIndex) {
						// 计算
						var qty = parseFloat(val);
						qty = isNaN(qty) ? 0 : qty;
						if(com.ParamTrans.IfRQtyOver != 'Y'){
							var proLocAvaQty = gridRowData.proLocAvaQty;
							var curDirtyQty = gridRowData.curDirtyQty;
							if((qty - curDirtyQty) > proLocAvaQty){
								PHA.Msg('alert', '参数配置:请求数量大于供应科室数量-' + gridRowData.inciDesc);
								gridRowData.qty = 0;
								return false;
							}
						}
						if(com.ParamTrans.StockAllowDecimal != 'Y'){
							var bQty = qty;
							if(gridRowData.uomId == gridRowData.bUomId){
								bQty = _.multiply(bQty, gridRowData.pFac);
								if(bQty.toString().indexOf('.') >= 0) {
									PHA.Msg('alert', '参数配置:禁止转移数量以基本单位计算时出现小数-' + gridRowData.inciDesc );
									gridRowData.qty = parseInt(qty);
									return false;
								}
							}
						}
						
						var sp = parseFloat(gridRowData.sp);
						sp = isNaN(sp) ? 0 : sp;
						var rp = parseFloat(gridRowData.rp);
						rp = isNaN(rp) ? 0 : rp;
						var rpAmt = qty * rp;
						var spAmt = qty * sp;
						// 联动更新
						gridRowData.rpAmt = rpAmt;
						gridRowData.spAmt = spAmt;
						
						// uomId pFac bUomId pUomId
						
					}
				})	
			},{ field: 'uomDesc', 	title: 'uomDesc', 			hidden: true },
            {
				field: 'uomId',
                title: '单位',
                width: 100,
                descField: 'uomDesc',
                editor: PHA_GridEditor.ComboBox({
					required: true,
					tipPosition: 'top',
					loadRemote: true,
					editable:false,
					url: PHA_STORE.CTUOMWithInci().url,
					onBeforeLoad: function (param) {
						var curRowData = PHA_GridEditor.CurRowData(INITIGRID );
						param.InciDr = curRowData. inci || '' ;
					},
					onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
						// 联动更新,建议直接在下拉列表中添加不从后台取
						var uomId  = cmbRowData.RowId
						var inci = gridRowData.inci
						var inclb = gridRowData.inclb
						var inciUomData = GetInciUomData(uomId, inci)
						var inclbUomData = PHA_UX.Util.GetInclbUomData(inclb, uomId)
						var newCurDirtyQty = GetCurDirtyQtyByUomId(gridRowData.initiId, inci, uomId)
						var updateData = {};
						$.extend(updateData, inciUomData);
						$.extend(updateData, inclbUomData);
						updateData.curDirtyQty = newCurDirtyQty;
						$('#' + INITIGRID).datagrid('updateRowData', {
							index: gridRowIndex,
							row: updateData
						});
						return true;
					}
				}),
                formatter: function (value, row, index) {
                    return row.uomDesc;
                }
			},
			{ field: 'proLocAvaQty',title: '供方批次可用库存', 	width: 120, 		align: 'right'	},
			{ field: 'curDirtyQty', title: '本次占用', 			width: 80, 			align: 'right'	},
            { field: 'rp', 			title: '进价', 				width: 100, 		align: 'right'	},
            { field: 'rpAmt', 		title: '进价金额', 			width: 100, 		align: 'right'	},
            { field: 'sp', 			title: '售价', 				width: 100, 		align: 'right'	},
            { field: 'spAmt', 		title: '售价金额', 			width: 100, 		align: 'right'	},
            { field: 'uomFac', 		title: 'uomFac', 			hidden: true },
			{ field: 'proLocQty', 	title: '供应方库存', 		width: 120, 		align: 'right'	},
            { field: 'recLocQty', 	title: '请求方库存', 		width: 120, 		align: 'right'	},
			{ field: 'batNo', 		title: '批号', 				width: 100, 		align: 'left'	},
			{ field: 'expDate', 	title: '效期', 				width: 100, 		align: 'left'	},
			{ field: 'stkbin', 		title: '货位', 				width: 100, 		align: 'left'	},
            { field: 'remark', 		title: '备注', 				width: 100, 		align: 'left'	,
            	editor: PHA_GridEditor.ValidateBox({})
            },
            { field: 'inciSpec', 	title: '规格', 				width: 100, 		align: 'left'	},
            { field: 'geneName', 	title: '处方通用名', 		width: 100, 		align: 'left'	},
            { field: 'phcFormDesc', title: '剂型', 				width: 100, 		align: 'left'	},
            { field: 'reqQty', 		title: '请求数量', 			width: 100, 		align: 'left'	},
            { field: 'manfName', 	title: '生产企业', 			width: 200, 		align: 'left'	},
            { field: 'insuCode', 	title: '国家医保编码', 		width: 100, 		align: 'left'	},
            { field: 'insuName', 	title: '国家医保名称', 		width: 100, 		align: 'left'	}
        ]
    ];
    
    var dataGridOption = {
		url: PHA.$URL,
		queryParams: {},
		singleSelect: true,
		pagination: false,
		columns: columns,
		frozenColumns : frozenColumns,
		toolbar: INITBAR,
		gridSave: true,
		exportXls: false,
		shiftCheck: true,
        singleSelect: true,
        checkOnSelect: false, // 互不干扰, 应保持输入与勾选分开, 但是勾选还需要能分出信息
        selectOnCheck: false,
		
		showFooter: true,
		isCellEdit: false,
		allowEnd: true,
		isAutoShowPanel: true,
		loadFilter:PHA.localFilter,
		editFieldSort: ['inci', 'qty', 'uomId'],
		onClickCell: function (index, field, value) {
			var compFlag = $('#compFlag').val();
			if (compFlag == 'Y') return;
			PHA_GridEditor.Edit({
				gridID: INITIGRID,
				index: index,
				field: field,
				forceEnd: true
			});
			var inciCode = $('#' + INITIGRID).datagrid('getRow', index).inciCode
			if( inciCode != "" && inciCode != undefined){
				let target = $('#' + INITIGRID).datagrid('getEditor', { index: index, field: 'inciDesc' }).target;
            	$(target).lookup('disable');
				$(target).unbind();
			}
		},
		onLoadSuccess: function (data) {
			PHA_GridEditor.End(INITIGRID);
			SetTotalAmt();
		},
		onNextCell: function(index, field, value, isLastRow, isLastCol) {
			if (isLastRow && isLastCol) {
				Addi();
			}
		}
	};
	PHA.Grid(INITIGRID, dataGridOption);
}

function AddRows(drugData, rowsData){
	var curRowsData = $('#' + INITIGRID).datagrid('getRows');
    for (var i = 0; i < rowsData.length; i++) {
        var iRowData = rowsData[i];
        var iAddData ={}
        $.extend(iAddData, drugData);
        $.extend(iAddData, iRowData);
        
        iAddData.uomId = drugData.pUomId;
        iAddData.uomDesc = drugData.pUomDesc;
        iAddData.proLocQty = drugData.pQty;
        iAddData.recLocQty = drugData.reqLocQty;
        iAddData.proLocAvaQty = iRowData.avaQty;
        iAddData.rp = iRowData.pRp;
		iAddData.sp = iRowData.pSp;
		iAddData.qty = iRowData.inputQty;
		iAddData.rpAmt = iAddData.rp * iAddData.qty;
		iAddData.spAmt = iAddData.sp * iAddData.qty;
		if(iRowData.inclbWarnFlag == 1){
			if(com.ParamTrans.ExpLimitFlag == 'Y'){
				PHA.Msg('alert', '参数配置:' + drugData.inciDesc +' 已过期,禁止出库');
				return;
			}
			else{
				PHA.Msg('info', drugData.inciDesc +' 已过期');
			}
		}
		else if(iRowData.inclbWarnFlag == 2){
			PHA.Msg('alert', drugData.inciDesc + '批次不可用,禁止出库');
			return;
		}
		
		// 检查科室库存批次项是否重复
		for (var j = 0; j < curRowsData.length; j++) {
			var curRowData = curRowsData[j];
			var inclb = curRowData.inclb;
			if(!inclb) continue;
			if(iRowData.inclb == inclb){
				PHA.Msg('alert', drugData.inciDesc + '与第' + (j + 1) + '行数据重复');
				return;
			}
			if(parseFloat(iRowData.inputQty) > parseFloat(iRowData.avaQty))
			{
				PHA.Msg('alert', drugData.inciDesc + '可用库存不足');
				return;
			}
		}
		
        if (i == 0) {
            var selRow = $('#' + INITIGRID).datagrid('getSelected');
            if (selRow && (selRow.inclb == '' || typeof selRow.inclb == 'undefined')) {
                var rowIndex = $('#' + INITIGRID).datagrid('options').editIndex;
                $('#' + INITIGRID).datagrid('updateRowData', {
                    index: rowIndex,
                    row: iAddData
                });
                continue;
            }
        }
        PHA_GridEditor.Add({
            gridID: INITIGRID,
            field: '',
            rowData: iAddData
        });
    }
    setTimeout(function(){
	    PHA_GridEditor.Add({
			gridID: INITIGRID,
			field: 'inciDesc'
		});
    },200);
}

function GetInciUomData(uomId, inci){
	var data = {}
	if ((!uomId)||(!inci))  return data;
	var proLocId = $('#proLocId').combobox('getValue');
	var recLocId = $('#recLocId').combobox('getValue');
	
	return PHA_UX.Util.GetInciUomData(inci, uomId, proLocId, recLocId);
}

function GetInclbUomData(uomId, inclb){
	var data = {}
	if ((!uomId)||(!inci))  return data;
	var proLocId = $('#proLocId').combobox('getValue');
	var recLocId = $('#recLocId').combobox('getValue');
	
	return PHA_UX.Util.GetInciUomData(inclb, uomId, proLocId, recLocId);
}

function Addi(){
	if(!CheckEditMain()) return;
	PHA_GridEditor.Add({
		gridID: INITIGRID,
		field: 'inciDesc'
	});
	SetTotalAmt();
	
	compoments.SetDisabled([], ['proLocId'])
}

function CheckEditMain(){
	var recLocId =  $('#recLocId').combobox('getValue') || '';
	if(!recLocId) {
		PHA.Msg('info', '请求科室为空' );
		return false
	}
    var proLocId =  $('#proLocId').datebox('getValue') || '';
    if(!proLocId) {
		PHA.Msg('info', '供给科室为空' );
		return false
	}
	if(com.ParamCom.StkCatSet != 'Y'){
		var scgId =  $('#scg').datebox('getValue') || '';
		if(!scgId){
			PHA.Msg('info', '类组不能为空' );
			return false
		}
	}
	return true;
}

function Delete(){
	if (!InitId){
		PHA.Msg('info', '无有效库存转移单！');
        return;
	}
	var pJson = {
		initId:InitId
	}
	com.BizConfirm(pJson, 'Delete', Clear);
}

function Deletei(){
    var checkedRows = $('#' + INITIGRID).datagrid('getChecked');
    if (checkedRows.length === 0) {
        PHA.Msg('info', '请勾选需要删除的记录！');
        return;
    }
    var initiArr = [];
    for (var i=0;i<checkedRows.length;i++) {
        var rowData = checkedRows[i]
        var initiId = rowData.initiId || '';
        if (initiId !== '') {
            initiArr.push(initiId);
        }
    }
    PHA.Confirm('提示', '您确认删除 ' + checkedRows.length + ' 条明细吗?', function () {
        if (initiArr.length > 0) {
            var retData = PHA.CM(
		        {
		            pClassName : com.API,  
		            pMethodName: 'Deletei',
		            pJson	   : JSON.stringify({rows : initiArr}),
		        },
		        false
		    )
		    if (retData.code < 0) return;
        }
        
        var rows = $('#' + INITIGRID).datagrid('getRows');
	    for (var j=0;j<checkedRows.length;j++) {
	        var rowData = checkedRows[j]
	        var rowIndex = rows.indexOf(rowData);
	        $('#' + INITIGRID).datagrid('deleteRow', rowIndex);
	    }
	    
	    PHA.CM(
	        {
	            pClassName : com.API,  
	            pMethodName: 'GetMainData',
	            pJson	   : JSON.stringify({initId:InitId}),
	        },
	        function (retData) {
		       if(retData.noItmFlag){
			       PHA.Confirm('提示', '明细已经没有记录，您是否同时删除此单据？', function () {
				       com.Biz({initId:InitId}, 'Delete', Clear);
				   });   
		       }
		       else{
			       PHA.Msg('success', '删除成功');
			       UpdateInfoArea();
		       }
	        }
	    )
    });
}

function Query(initId){
	var scgKeepFlag = (!InitId || (InitId == initId)) ? true : false;
	InitId = initId;
	QueryMain(initId, scgKeepFlag);
	QueryDetail(initId);
}

function QueryMain(initId, scgKeepFlag){
	PHA.CM(
        {
            pClassName : com.API,  
            pMethodName: 'GetMainData',
            pJson	   : JSON.stringify({initId:initId}),
        },
        function (retData) {
	        if(scgKeepFlag) {
		        delete retData.scg
	        }
	        retData.proLocId = {
                RowId: retData.proLocId,
                Description:retData.proLocDesc,
                Select: false
            };
	        retData.recLocId = {
                RowId: retData.recLocId,
                Description:retData.recLocDesc,
                Select: false
            };
			PHA.SetVals([retData]);
			setTimeout(function(){PHA.SetVals([{recLocId:retData.recLocId}]);}, 500); //等请求科室下拉框加载完之后再选择请求科室
	        SetBtnAndComb(retData);
	        SetInfoArea(retData);
        }
    )
}

function QueryDetail(initId){
	PHA_COM.LoadData(INITIGRID, {
		pJson : JSON.stringify({initId:initId}),
		pClassName : com.API,
		pMethodName : 'QueryDetail'
	}); 
}

function QueryInit_f(){
	$('#' + INITIGRID_F).datagrid('loadData', []);
	var pJson = PHA.DomData(INITBAR_F, {
        doType: 'query',
        retType: 'Json'
    });
    if(!pJson.length) return;
    com.QueryMain(INITGRID_F, pJson[0]);
}

function QueryIniti_f(){
	com.QueryDetail(INITIGRID_F, {initId:com.GetInitId(INITGRID_F)});
}

function SetBtnAndComb(retData){
	if (!retData) { 
        $('#btnComp').linkbutton({text: '完成'})
        compoments.SetDisabled(['btnSave', 'btnComp', 'btnDelete'], []);
        if(com.ParamTrans.RequestNeeded == 'Y'){
			compoments.SetDisabled(['btnSave', 'btnAddi'], []);
        }
	}
	else {
		/* 如果是依据请求单，则不允许修改请求科 */
		var combArr = ['proLocId'];
		if(retData.reqNoStr != '') combArr.push('recLocId');
		
		if (retData.compFlag != 'Y'){
			$('#btnComp').linkbutton({text: '完成'})
			compoments.SetDisabled([], combArr)
		}
		else{
			$('#btnComp').linkbutton({text: '取消完成'})
			compoments.SetDisabled(['btnSave', 'btnAddi', 'btnDeletei', 'btnDelete'], combArr)
		}
	}
}

function Save(){
	var initId = ExeSave();
	if(!initId) return;
	Query(initId);
}

function ExeSave()
{
	PHA_GridEditor.GridFinalDone('#' + INITIGRID, ['initiId', 'inclb']);
    if (!PHA_GridEditor.EndCheck(INITIGRID)) return '';
    if (!PHA_GridEditor.CheckValuesMsg(INITIGRID)) return '';
    
    /* 主表数据 */
    var mainObj = GetMainObj();
    
    /* 子表数据 */
    var gridChanges =  PHA_GridEditor.GetChangedRows('#' + INITIGRID);
    var gridChangeLen = gridChanges.length;
    if ((!gridChangeLen) && (!InitId)){
	    PHA.Msg('info', '没有需要保存的数据！');
	    return '';
    }
    if(!CheckQty()) return;
    
    var pJson = {
	    main : mainObj,
	    rows : gridChanges
    }
    var retData = com.Biz(pJson, 'SaveInit', '', true);
    PHA.Ret(retData)
    return retData.data || '';
}

function GetMainObj(){
	var initJsonStr = PHA.DomData(INITBAR, {
        doType: 'query',
        retType: 'Json'
    });
    
    if (!initJsonStr.length) return {};
	var mainObj = initJsonStr[0];
	mainObj['initId'] = InitId;
	mainObj = com.AddSession(mainObj);
	
	return mainObj; 
}

function DefultQuery(){
	if(com.ParamTrans.RequestNeeded == 'Y'){
		compoments.SetDisabled(['btnSave', 'btnAddi'], []);
		PHA.Confirm('提示', '参数配置:限制库存转移只能通过请求单生成，本界面不可编辑转移单', function () {
	        return ;
	    });
	}
	
	setTimeout(function(){
		if (skipInitId) {
			InitId = skipInitId
			Query(InitId);
		}
		else{
			if (com.ParamTrans.AutoLoadRequest == 'Y'){
				SelectReq();
			}
		}
	},500)
}

function SetDefa(){
	PHA.SetVals([{ 
		proLocId  : session['LOGON.CTLOCID'],
	}]);
	$('#opertId').combobox('reload')
	$('#infoArea').phabanner('loadData', []);
}

function NewInit(){ 
	Clear();
}

function Clear(){
	compoments.Clear([INITIGRID], [INITBAR]);
	SetDefa();
	SetBtnAndComb();
    SetTotalAmt();
	InitId = '';
	if (skipInitId) location.href='pha.in.v3.trans.create.csp?skipInitId=';
}

function Clear_f(){
	compoments.Clear([INITGRID_F, INITIGRID_F], [INITBAR_F]);
	PHA.SetVals([{ 
		proLocId_f  : $('#proLocId').combobox('getValue') || '',
		startDate_f : com.GetDateStr(com.ParamTrans.DefaStartDate),
		endDate_f   : com.GetDateStr(com.ParamTrans.DefaEndDate),
		statusCode_f : IsCopy() ? 'COMP' : 'SAVE,COMP',
	}])
}

function Comp(){
	/* 如果单据已经完成，则执行取消完成 */
	var compFlag = $('#compFlag').val();
	if (compFlag == 'Y'){
		CancelComp();
		return;
	}
	
	var initId = ExeSave();
	if(!initId) return;
	InitId = initId;
	
    var pJson = {
	    initId : InitId,
	    userId : session['LOGON.USERID']
    }
    
    com.Biz(pJson, 'CompInit', function(){
	    Query(initId);
	    if(com.ParamTrans.AutoAckOutAfterCompleted == 'Y'){
		    // 完成之后 自动审核到'出库审核'
		    com.Biz(pJson, 'AutoOutAuditFrComp')
	    }
	    if(com.ParamTrans.AutoPrintAfterSave == 'Y'){
		    PrintTrans(initId);
	    }
    });      
}

function CancelComp(){
	if(!InitId){
		PHA.Msg('info', '请选择一张库存转移单');
	    return;
	}
	
	if (!PHA_GridEditor.EndCheck(INITIGRID)) return;
    if (!PHA_GridEditor.CheckValuesMsg(INITIGRID)) return;
    
    /* 子表数据 */
    var gridChanges = $('#' + INITIGRID).datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen){
	    PHA.Msg('info', '界面数据已编辑，请保存后再操作！');
	    return;
    }
     var pJson = {
	    initId : InitId,
    }
    
    com.Biz(pJson, 'CancelComp', Query);    
}

// 查询可复制单据
function FindCopy(){
     $('#diagFind')
        .dialog({
	        title: $g('复制库存转移单'),
            iconCls: 'icon-w-copy',
            modal: true,
            width: PHA_COM.Window.Width(),
            height: PHA_COM.Window.Height(),
            onBeforeClose: function () {},
        })
        .dialog('open');
     InitGridInit_f();
     InitGridIniti_f();
     $('#btnSelect_f').linkbutton({text: '复制'})
	 $('#btnDelete_f').hide();
     $('#statusCode_f').combobox('reload', PHA_IN_STORE.BusiProcess(com.BUSICODE, 'COPY').url);
     Clear_f();
     setTimeout(function(){QueryInit_f();}, 500);
}

function Find(){
    $('#diagFind')
        .dialog({
	        title: $g('查询库存转移单'),
            iconCls: 'icon-w-find',
            modal: true,
            width: PHA_COM.Window.Width(),
            height: PHA_COM.Window.Height(),
            onBeforeClose: function () {},
        })
        .dialog('open');
     InitGridInit_f();
     InitGridIniti_f();
     $('#btnSelect_f').linkbutton({text: '选取'})
     $('#btnDelete_f').show();
     $('#statusCode_f').combobox('reload', PHA_IN_STORE.BusiProcess(com.BUSICODE, 'CREATE').url);
     Clear_f();	
     setTimeout(function(){QueryInit_f();}, 500);
}

function InitGridInit_f()
{
	compoments.InitMainGrid(INITGRID_F,INITBAR_F,
		function(){
			QueryIniti_f();
		},
		function(){
			Select_f();
		}
	)
}

function InitGridIniti_f()
{
	compoments.InitDetailGrid(INITIGRID_F);
}

function Select_f(){
	var initId = com.GetInitId(INITGRID_F);
	if (!initId) {
		PHA.Msg('info', '请选择一张库存转移单' );
		return;
	}
	var btnText = $('#btnSelect_f').text();
	if(IsCopy()){ //复制转移单
	     $('#diagCopyInitCondition')
	        .dialog({
		        title: $g('选择复制条件'),
	            iconCls: 'icon-w-copy',
	            modal: true,
	            width: 400,
	            height: 150,
	            onBeforeClose: function () {},
	        })
	        .dialog('open');
	      $('#limitBatFlag').checkbox('setValue', true);  //默认复制批次
	}
	else {
		Query(initId)
		$('#diagFind').dialog('close');
	}
}

function CopyInit()
{
	var initId = com.GetInitId(INITGRID_F);
	var recLocId = $('#recLocId_copy').combobox('getValue');
	var limitBatFlag = $('#limitBatFlag').checkbox('getValue');
	if(!recLocId){
		PHA.Msg('info', '请选择请求科室' );
		return;
	}
	var pJson = {
		initId : initId,
		recLocId : recLocId,
		limitBatFlag : limitBatFlag
	}
	pJson = com.AddSession(pJson);
	
	com.Biz(pJson, 'CopyInit', function(newInitId){
		$('#diagCopyInitCondition').dialog('close');
		$('#diagFind').dialog('close');
		Query(newInitId);
	});
}

function Delete_f(){
	var initId = com.GetInitId(INITGRID_F);
	if (!initId) {
		PHA.Msg('info', '请选择一张库存转移单' );
		return;
	}
	var pJson = {
		initId:initId
	}
	com.BizConfirm(pJson, 'Delete', function(){
		QueryInit_f();
		if(initId = InitId){
			skipInitId = '';
			Clear();
		}
	});
}

function SetInfoArea(retData){
	var dataArr = [
	  {
	    info: retData.transNo ,
	    append: '/'
	  },
	  {
	    prepend: '制单: ',
	    info: retData.creator + ' ' + retData.createDate+ ' ' + retData.createTime,
	    append: '/'
	  },
	  {
	    prepend: '请求单号: ',
	    info: retData.reqNoStr ,
	    append: '/'
	  },{
	    info:retData.compFlag == 'Y' ? '完成': '未完成',
	    labelClass: retData.compFlag == 'Y' ? 'info' : 'danger',
	    append: '/'
	  }
	];
	
	var noItmFlag = retData.noItmFlag;
	if(noItmFlag){
		dataArr.push(
			{
				info: '无明细信息!!!',
	    		labelClass: 'danger',
	    		append: '/'
			}
		)
	}
	
	var newestStatusInfo = retData.newestStatusInfo;
	if(newestStatusInfo.indexOf($g('拒绝')) > 0){
		dataArr.push(
			{
				info: '上级拒绝',
	    		labelClass: 'danger',
	    		append: '/'
			}
		)
	}
	$('#infoArea').phabanner('loadData', dataArr);
}


function Print(){
	if (!InitId) {
		PHA.Msg('info', '请选择一张库存转移单' );
		return;
	}
	PrintTrans(InitId);
}

function SelectReq(){
    $('#diagFindReq')
        .dialog({
            iconCls: 'icon-w-find',
            modal: true,
            width: PHA_COM.Window.Width(),
        	height: PHA_COM.Window.Height(),
            onBeforeClose: function () {},
        })
        .dialog('open');
     InitGridInrq();
     InitGridInrqi();
     Clear_req();	
     setTimeout(function(){QueryInrq_req();}, 500)
}

function InitGridInrq(){
	compoments_req.InitMainGrid('gridInrq', '#gridInrqBar_f',
		function(inrqId){
			QueryInrqi_req(inrqId);
		},
		function(inrqId){
			SaveByInrq(inrqId);
		}
	)
}

function InitGridInrqi(){
	compoments_req.InitDetailGrid('gridInrqi');
}

function Select_req(){
	var inrqId = ''
	var gridSelect = $('#gridInrq').datagrid('getSelected') || '';
    if (gridSelect) inrqId = gridSelect.inrqId;
    if (!inrqId) {
		PHA.Msg('info', '请选择一张库存请求单' );
		return;
	}
	SaveByInrq(inrqId);
}

function SaveByInrq(inrqId)
{
	if (inrqId == ''){
	   PHA.Msg('info' ,'请选择一张库存请求单！');
	   return;
    }
	var	pJson = {inrqIdStr : inrqId};
	com_req.Biz(pJson, 'CreateByInrqIdStr', function(initId){
	    $('#diagFindReq').dialog('close');
		Query(initId);
    }); 
}

function QueryInrq_req(){
	var pJson = PHA.DomData('#gridInrqBar_f', {
        doType: 'query',
        retType: 'Json'
    });
    if(!pJson.length) return;
    com_req.QueryMain('gridInrq', pJson[0]);
}

function QueryInrqi_req(inrqId){
	com_req.QueryDetail('gridInrqi', {inrqId:inrqId});
}

function Clear_req(){
	compoments.Clear(['gridInrq', 'gridInrqi']);
	PHA.SetVals([{ 
		proLocId_req  : $('#proLocId').combobox('getValue') || '',
		startDate_req : com.GetDateStr(com.ParamTrans.DefaStartDate),
		endDate_req   : com.GetDateStr(com.ParamTrans.DefaEndDate),
		reqStatus_req : 'COMP'
	}]);
}

function SetTotalAmt(){
	PHA_COM.SumGridFooter('#' + INITIGRID, ['rpAmt', 'spAmt']);
}

function Refresh(){
	if(!InitId){
		PHA.Msg('info' ,'无有效库存转移单！');
	   return;
	}
	Query(InitId);
}

function SetOpertId(recLocId){
	var pJson = {
		proLocId: $('#proLocId').combobox('getValue'),
		recLocId: recLocId,
	}
	
	var retData = PHA.CM(
        {
            pClassName : com.API,  
            pMethodName: 'GetDefaultOpertId',
            pJson	   : JSON.stringify(pJson),
        },false
    )
    if(retData.data) $('#opertId').combobox('setValue', retData.data);
}

/// 删除明细后更新 单据信息展示框中是否有明细标志
function UpdateInfoArea(){
	if (!InitId) return;
	var rows = $('#' + INITIGRID).datagrid('getRows')
	var rowsLen = rows.length
	if(rowsLen > 0) return;
	PHA.CM(
        {
            pClassName : com.API,  
            pMethodName: 'GetMainData',
            pJson	   : JSON.stringify({initId:InitId}),
        },
        function (retData) {
	        SetInfoArea(retData);
        }
    )
}

function IsCopy(){
	var btnText = $('#btnSelect_f').text();
	if(btnText.indexOf($g('复制')) >= 0) return true;
	return false;
}

function GetCurDirtyQtyByUomId(initiId, inci, uomId){
	if (!initiId) return 0;
	var pJson = {
		initiId :initiId,
		inci :inci,
		uomId :uomId,
	}
	var retData = com.Data(pJson, 'GetCurDirtyQtyByUomId')
	return retData.newDirtyQty;
}


function CheckQty(){
	var rows = $('#' + INITIGRID).datagrid('getRows');
	var rowLen = rows.length;
	var retMsg = '';
	var editRow = 0;
	for (var i = 0; i < rowLen; i++) {
		var rowData = rows[i];
		var inclb = rowData.inclb;
		if(inclb == ""){
			continue;
		} 
		var qty = rowData.qty;
		if(!qty){
			retMsg = '请求数量不能为空或者0' ;
			editRow = i;
			break;
		}
		var fac = rowData.fac;
		var uomId = rowData.uomId;
		var inclbQty = rowData.inclbQty;
		if(com.ParamTrans.IfRQtyOver != 'Y'){
			var proLocAvaQty = rowData.proLocAvaQty;
			var curDirtyQty = rowData.curDirtyQty;
			if((qty - curDirtyQty) > proLocAvaQty){
				retMsg = '参数配置:请求数量大于供应科室数量-' + rowData.inciDesc;
				editRow = i;
				break;
			}
		}
		if(com.ParamTrans.StockAllowDecimal != 'Y'){
			var bQty = qty;
			if(rowData.uomId == rowData.bUomId){
				bQty = _.multiply(bQty, rowData.pFac);
				if(bQty.toString().indexOf('.') >= 0) {
					retMsg = '参数配置:禁止转移数量以基本单位计算时出现小数-' + rowData.inciDesc;
					editRow = i;
					break;
				}
			}
		}
	}
	if (retMsg != ''){
		PHA.Msg('alert', retMsg);
		
		PHA_GridEditor.Edit({
			gridID : INITIGRID,
			index : editRow,
			field : 'qty'
		});
		
		return false;
	}
	return true;
}