/**
 * 模块:     库存请求制单
 * 编写日期: 2022-03-07
 * 编写人:   yangsj
 */
var InrqId = '';

var gParamReq = PHA_COM.ParamProp('DHCSTINREQ');
var gParamCom = PHA_COM.ParamProp('DHCSTCOMMON');

var BTNARR  = ['btnSave', 'btnComp', 'btnSelectDurg','btnAddi', 'btnDeletei', 'btnDelete'];		//定义会变化使用状态的按钮集
var COMBARR = ['recLocId', 'proLocId']; 							//定义会变化使用状态的下拉框数据集

var INRQGRID    = 'gridInrq';
var INRQGRID_F  = 'gridInrq_f';
var INRQIGRID_F = 'gridInrqi_f';

var INRQBAR   = '#gridInrqBar';
var INRQBAR_F = '#gridInrqBar_f';

var com = INRQ_COM;
var compoments = INRQ_COMPOMENTS;

$(function () {
	SetPanel();
    InitDict();
    InitGrid();
    BindBtnEvent();
    SetBtnAndComb();
    SetRequired();
    DefultQuery();
});

function SetPanel(){
	$('#panelInrq').panel({
		title: PHA_COM.IsTabsMenu() !== true ? '库存请求制单' : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-template',
		bodyCls: 'panel-body-gray',
		fit: true
	});
}

function SetRequired(){
	PHA.SetRequired($(INRQBAR + ' [data-pha]'))
	PHA.SetRequired($(INRQBAR_F + ' [data-pha]'))
}

function BindBtnEvent(){
	PHA.BindBtnEvent(INRQBAR);
	PHA.BindBtnEvent(INRQBAR_F);
	PHA_EVENT.Bind('#btnCopyInrq', 'click', function(){CopyInrq();});
}

function InitDict(){
	/* 申请类型 */
	compoments.ReqTypeId('reqTypeId', false, true);
	compoments.ReqTypeId('reqTypeId_f', true);
	
	/* 请求科室 */
	/* 请求科室和供给科室  */
    compoments.ToFrLoc('recLocId', 'proLocId');
    compoments.ToFrLoc('recLocId_f', 'proLocId_f');
    compoments.ToFrLoc('recLocId_copy', 'proLocId_copy');
    
    /* 类组 */
    compoments.Scg('scg', 'recLocId');
	
	/* 申请单状态 */
	compoments.ReqStatus('reqStatus_f', 'ALL', true);

    /* 信息展示框 */
    $('#infoArea').phabanner({
	    title: $g('选择单据后, 显示详细信息')
	});
}

function InitGrid(){
	InitGridInrq();
}

function InitGridInrq(){
	var frozenColumns = [
		[
			{ field: 'tSelect',		checkbox: true},
			{ field: 'inrqiId', 	title: 'inrqiId', 	hidden: true },
            { field: 'inciCode',	title: '药品代码',		width: 100,			align: 'left' },
            {
	            field: 'inci',
				title: '药品名称',
				descField: 'inciDesc',
				width: 250,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['inciDesc'];
				},
				editor: PHA_UX.Grid.INCItm({
					type: 'lookup',
					required: true,
					onBeforeLoad: function (param, gridRowData) {
						// 查询参数
						param.hospId = session['LOGON.HOSPID'];
						param.pJsonStr = JSON.stringify({
							stkType: App_StkType,
							scgId: $('#scg').combobox('getValues').join(","),
							locId: $('#proLocId').combobox('getValue') || '',
							userId: session['LOGON.USERID'],
							notUseFlag: '',
							qtyFlag: '',
							reqLocId: $('#recLocId').combobox('getValue') || '',
						});
					},
					onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
						var updData = gridRowData || {};
						$.extend(updData, cmbRowData);						
						updData.uomId = cmbRowData.pUomId;
						updData.uomDesc = cmbRowData.pUomDesc;
						updData.uomFac = cmbRowData.pFac;
						// 此处还是建议直接取 cmbRowData 中的数据，提交效率
						var inciUomData = GetInciUomData(gridRowData.uomId, gridRowData.inci)
						$.extend(updData, inciUomData);
						$('#' + INRQGRID).datagrid('updateRowData', {
							index: gridRowIndex,
							row: updData
						})
					},
					checkValue: function (val, checkRet) {
						
						// 验证值
						var dgOpts = $('#' + INRQGRID).datagrid('options');
						var curEidtCell = dgOpts.curEidtCell || {};
						if (!curEidtCell.index&&curEidtCell.index != 0) return;  //保存的时候会再检查一次，此时编辑框为空，先过滤
						
						var retData = IfDrugCanReq(val)
						if (!retData.data) {
							setTimeout(function(){
								var ed = $('#' + INRQGRID).datagrid('getEditor', {
									index: curEidtCell.index,
									field: curEidtCell.field
								});
								//if (!ed) return true;
								$(ed.target).combogrid('clear');
								$(ed.target).combogrid('setValue', '');
								$(ed.target).combogrid('setText', '');
							}, 300);
							checkRet.msg = '：' + retData.inciDesc + ',请求科室不能申请此药品' ;
							return false;
						}
						var rowsData = $('#' + INRQGRID).datagrid('getRows');
						for (var i = 0; i < rowsData.length; i++) {
							if (i == curEidtCell.index) {
								continue;
							}
							var iData = rowsData[i];
							if (iData.inci == val) {
								setTimeout(function(){
									
									var ed = $('#' + INRQGRID).datagrid('getEditor', {
										index: curEidtCell.index,
										field: curEidtCell.field
									});
									//if (!ed) return true;
									$(ed.target).combogrid('clear');
									$(ed.target).combogrid('setValue', '');
									$(ed.target).combogrid('setText', '');
								}, 300);
								checkRet.msg = '与第' + (i + 1) + '行重复';
								return false;
							}
						}
						return true;
					}
				})
			}
		]
	]
	var columns = [
        [
            { field: 'qty', 		title: '请求数量', 		width: 80, 		align: 'right',
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
						if(gParamReq.IfRQtyOver != 'Y'){
							var proLocQty = gridRowData.proLocQty;
							if(qty > proLocQty){
								PHA.Msg('alert', '请求数量大于供应科室数量' );
								//gridRowData.qty = 0;
								$('#' + INRQGRID).datagrid('updateRowData', {
									index: gridRowIndex,
									row: {qty:0}
								})
								return false;
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
						$('#' + INRQGRID).datagrid('updateRowData', {
							index: gridRowIndex,
							row: {
								rpAmt : rpAmt,
								spAmt : spAmt
							}
						})
					},
				})	
			},
			{ field: 'uomDesc', 	title: 'uomDesc', 		hidden: true },
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
						var curRowData = PHA_GridEditor.CurRowData('gridInrq' );
						param.InciDr = curRowData. inci || '' ;
					},
					onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
						// 联动更新,建议直接在下拉列表中添加不从后台取
						var uom  = cmbRowData.RowId
						var inci = gridRowData.inci
						//var inciUomData = GetInciUomData(uom, inci);
						$('#' + INRQGRID).datagrid('updateRowData', {
							index: gridRowIndex,
							row: GetInciUomData(uom, inci)
						});
						//$.extend(gridRowData, inciUomData);
						return true;
					}
				}),
                formatter: function (value, row, index) {
                    return row.uomDesc;
                }
			},
			{ field: 'proLocQty', 	title: '供应方库存', 	width: 80, 		align: 'right'	},
            { field: 'recLocQty', 	title: '请求方库存', 	width: 80, 		align: 'right'	},
            { field: 'rp', 			title: '进价', 			width: 80, 		align: 'right'	},
            { field: 'rpAmt', 		title: '进价金额', 		width: 100, 	align: 'right'	},
            { field: 'sp', 			title: '售价', 			width: 80, 		align: 'right'	},
            { field: 'spAmt', 		title: '售价金额', 		width: 100, 	align: 'right'	},
            { field: 'uomFac', 		title: 'uomFac', 		hidden: true 	},
            { field: 'remark', 		title: '备注', 			width: 100, 	align: 'left', 	editor: PHA_GridEditor.ValidateBox({}) },
            { field: 'inciSpec', 	title: '规格', 			width: 100, 	align: 'left'	},
            { field: 'geneName', 	title: '处方通用名', 	width: 100, 	align: 'left'	},
            { field: 'phcFormDesc', title: '剂型', 			width: 100, 	align: 'left'	},
            { field: 'sugQty', 		title: '建议请领数量', 	width: 100, 	align: 'left'	},
            { field: 'manfName', 	title: '生产企业', 		width: 200, 	align: 'left'	},
            { field: 'insuCode', 	title: '国家医保编码', 	width: 100, 	align: 'left'	},
            { field: 'insuDesc', 	title: '国家医保名称', 	width: 100, 	align: 'left'	}
        ]
    ];
    
    var dataGridOption = {
		url: PHA.$URL,
		queryParams: {},
		singleSelect: true,
		pagination: false,
		columns: columns,
		frozenColumns: frozenColumns,
		toolbar: INRQBAR,
		showFooter: true,
		gridSave: true,
		exportXls: false,
		isCellEdit: false,
		allowEnd: true,
		isAutoShowPanel: true,
		shiftCheck: true,
        singleSelect: true,
        checkOnSelect: false, // 互不干扰, 应保持输入与勾选分开, 但是勾选还需要能分出信息
        selectOnCheck: false,
		editFieldSort: ['inci', 'qty', 'uomId'],
		onClickCell: function (index, field, value) {
			var compFlag = $('#compFlag').val();
			if (compFlag == 'Y') return;
			PHA_GridEditor.Edit({
				gridID: INRQGRID,
				index: index,
				field: field,
				forceEnd: true
			});
			SetTotalAmt();
		},
		onLoadSuccess: function (data) {
			PHA_GridEditor.End(INRQGRID);
			PHA_COM.SumGridFooter('#' + INRQGRID, ['rpAmt', 'spAmt']);
		},
		onNextCell: function(index, field, value, isLastRow, isLastCol) {
			if (isLastRow && isLastCol) {
				Addi();
			}
		}
	};
	PHA.Grid(INRQGRID, dataGridOption);
}

function GetInciUomData(uomId, inci){
	var data = {}
	if ((!uomId)||(!inci))  return data;
	var proLocId = $('#proLocId').combobox('getValue');
	var recLocId = $('#recLocId').combobox('getValue');
	return PHA_UX.Util.GetInciUomData(inci, uomId, proLocId, recLocId);
}

function Addi(){
	if(!CheckEditMain()) return;
	PHA_GridEditor.Add({
		gridID: INRQGRID,
		field: 'inci',
	}, 1);
	SetTotalAmt();
	SetDisabled([], []);
}

function CheckEditMain(){
	var recLocId =  $('#recLocId').combobox('getValue') || '';
	if(!recLocId) {
		PHA.Msg('alert', '请求科室为空' );
		return false
	}
    var proLocId =  $('#proLocId').datebox('getValue') || '';
    if(!proLocId) {
		PHA.Msg('alert', '供给科室为空' );
		return false
	}
	if(gParamCom.StkCatSet != 'Y'){
		var scgId =  $('#scg').datebox('getValue') || '';
		if(!scgId){
			PHA.Msg('alert', '类组不能为空' );
			return false
		}
	}
	return true;
}

function Delete(){
	if (!InrqId){
		PHA.Msg('alert', '无有效请求单！');
        return;
	}
	var pJson = {inrqId:InrqId};
	com.BizConfirm(pJson, 'Delete', Clear);
}

function Deletei(){
	var checkedRows = $('#' + INRQGRID).datagrid('getChecked');
    if (checkedRows.length === 0) {
        PHA.Msg('alert', '请勾选需要删除的记录！');
        return;
    }
    var inrqiArr = [];
    for (var i=0;i<checkedRows.length;i++) {
        var rowData = checkedRows[i]
        var inrqiId = rowData.inrqiId || '';
        if (inrqiId !== '') {
            inrqiArr.push(inrqiId);
        }
    }
    PHA.Confirm('提示', '您确认删除 ' + checkedRows.length + ' 条明细吗?', function () {
        if (inrqiArr.length > 0) {
            var retData = PHA.CM(
		        {
		            pClassName : com.API,  
		            pMethodName: 'Deletei',
		            pJson	   : JSON.stringify({rows : inrqiArr}),
		        },
		        function (retData) {
			        if (PHA.Ret(retData)) {
					}
					else return;
		        }
		    )
		    if (retData.code < 0) return;
        }
        var rows = $('#' + INRQGRID).datagrid('getRows');
	    for (var j=0;j<checkedRows.length;j++) {
	        var rowData = checkedRows[j]
	        var rowIndex = rows.indexOf(rowData);
	        $('#' + INRQGRID).datagrid('deleteRow', rowIndex);
	    }
	    
	    PHA.CM(
	        {
	            pClassName : com.API,  
	            pMethodName: 'GetMainData',
	            pJson	   : JSON.stringify({inrqId:InrqId}),
	        },
	        function (retData) {
		       if(retData.noItmFlag){
			       PHA.Confirm('提示', '明细已经没有记录，您是否同时删除此单据？', function () {
				       com.Biz({inrqId:InrqId}, 'Delete', Clear);
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

function Query(inrqId){
	var scgKeepFlag = (!InrqId || (InrqId == inrqId)) ? true : false;
	InrqId = inrqId;
	QueryMain(inrqId, scgKeepFlag);
	QueryDetail(inrqId);
}

function QueryMain(inrqId, scgKeepFlag){
	PHA.CM(
        {
            pClassName : com.API,  
            pMethodName: 'GetMainData',
            pJson	   : JSON.stringify({inrqId:inrqId}),
        },
        function (retData) {
	        if(scgKeepFlag) {
		        delete retData.scg
	        }
	        retData.recLocId = {
                RowId: retData.recLocId,
                Description:retData.recLocDesc,
                Select: false
            }
            retData.proLocId = {
                RowId: retData.proLocId,
                Description:retData.proLocDesc,
                Select: false
            }
	        PHA.SetVals([retData]);
	        SetBtnAndComb(retData) 
	        SetInfoArea(retData)
        }
    )
}

function QueryDetail(inrqId){
	PHA_COM.LoadData(INRQGRID, {
		pJson : JSON.stringify({inrqId:inrqId}),
		pClassName : com.API,
		pMethodName : 'QueryDetail'
	}); 
}

function QueryInrq_f(){
	var pJson = PHA.DomData(INRQBAR_F, {
        doType: 'query',
        retType: 'Json'
    });
    
    if(!pJson.length) return;
    com.QueryMain(INRQGRID_F, pJson[0]);
}

function QueryInrqi_f(){
	com.QueryDetail(INRQIGRID_F, {inrqId:GetInrqId_f()});
}

function SetBtnAndComb(retData){
	if (!retData) { 
        $('#btnComp').linkbutton({text: '完成'})
        SetDisabled(['btnSave', 'btnComp', 'btnDelete'], []);
	}
	else {
		if (retData.compFlag != 'Y'){
			$('#btnComp').linkbutton({text: '完成'})
			SetDisabled([], ['recLocId', 'proLocId'])
		}
		else{
			$('#btnComp').linkbutton({text: '取消完成'})
			SetDisabled(['btnSave', 'btnAddi', 'btnDeletei', 'btnDelete', 'btnSelectDurg'], ['recLocId', 'proLocId'])
		}
	}
}

function SetDisabled(btnArr, combArr){
	var btnArr = btnArr || [];
	var combArr = combArr || [];
	var btnLen = BTNARR.length
	for (i=0;i<btnLen;i++){
		btnId = BTNARR[i]
		if(btnArr.indexOf(btnId) >= 0) $('#' + btnId).linkbutton('disable');
		else $('#' + btnId).linkbutton('enable');
	}
	var combLen = COMBARR.length
	for (i=0;i<combLen;i++){
		combId = COMBARR[i]
		if(combArr.indexOf(combId) >= 0) $('#' + combId).combobox('disable')
		else $('#' + combId).combobox('enable')
	}	
}

function Save()
{
	PHA_GridEditor.GridFinalDone('#' + INRQGRID, ['inrqiId', 'inci']);
    if (!PHA_GridEditor.EndCheck(INRQGRID)) return '';
    if (!PHA_GridEditor.CheckValuesMsg(INRQGRID)) return '';
    
    /* 主表数据 */
    var mainObj = GetMainObj();
    
    /* 子表数据 */
    var gridChanges =  PHA_GridEditor.GetChangedRows('#' + INRQGRID); 
    var gridChangeLen = gridChanges.length;
    if ((!gridChangeLen) && (!InrqId)){
	    PHA.Msg('alert', '没有需要保存的数据！');
	    return;
    }
    
    if(!CheckQty()) return;
    var pJson = {
	    main:mainObj,
	    rows:gridChanges
    }
    var retData = com.Biz(pJson, 'SaveInrq', '', true);

    if (PHA.Ret(retData)) {
		Query(retData.data);
	}
	return retData.data || '';
}

function GetMainObj(){
	var inrqJsonStr = PHA.DomData(INRQBAR, {
        doType: 'query',
        retType: 'Json'
    });
    if (!inrqJsonStr.length) return {};
	var mainObj = inrqJsonStr[0];
	mainObj['inrqId'] = InrqId;
	mainObj = com.AddSession(mainObj);
	
	return mainObj; 
}

function DefultQuery(){
	var topInrqId = com.Top.Get('inrqId', true);
    if (topInrqId !== '') {
        InrqId = topInrqId;
		setTimeout(function(){Query(InrqId);}, 1000); 
    }
    if (skipType == "Refuse"){
	    Find();
	    setTimeout(function(){
		    PHA.SetVals([{ 
			reqStatus_f : 'PARTREFUSE,ALLREFUSE',
		}]);
		QueryInrq_f();  
		}, 800);
    }
}

function SetDefa(){
	PHA.SetVals([{ 
		recLocId  : session['LOGON.CTLOCID'],
		reqTypeId : 'O'
	}]);
	$('#infoArea').phabanner('loadData', []);
}


function NewReq(){
	Clear();
}

function Clear(){
	compoments.Clear([INRQGRID], [INRQBAR]);
	SetDefa();
	SetBtnAndComb();
	SetTotalAmt();
	InrqId = '';
	if (skipType) location.href='pha.in.v3.req.create.csp?skipType=';
}

function Clear_f(){
	compoments.Clear([INRQGRID_F, INRQIGRID_F], [INRQBAR_F]);
	PHA.SetVals([{ 
		recLocId_f  : session['LOGON.CTLOCID'],
		startDate_f : 't - 7',
		endDate_f   : 't',
		reqStatus_f : IsCopy() ? 'COMP' : 'SAVE,COMP',
		reqTypeId_f : 'O'
	}])
}

function Comp(){
	/* 如果单据已经完成，则执行取消完成 */
	var compFlag = $('#compFlag').val();
	if (compFlag == 'Y'){
		CancelComp();
		return;
	}
	
	if (!PHA_GridEditor.EndCheck(INRQGRID)) return;
    if (!PHA_GridEditor.CheckValuesMsg(INRQGRID)) return;
	
	 /* 子表数据 */
    var gridChanges = $('#' + INRQGRID).datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
	
	if((!InrqId) || (gridChangeLen) ){
		var inrqId = Save();
		if(!inrqId) return;
		InrqId = inrqId;
	}
	if(!InrqId) {
		PHA.Msg('alert', '无单据信息');
		return;
	}
	var pJson = {
		inrqId : InrqId
	}
	com.Biz(pJson, 'CompInrq', Query); 
}

function CancelComp(){
	if(!InrqId){
		PHA.Msg('alert', '请选择一张库存请求单');
	    return;
	}
	
	if (!PHA_GridEditor.EndCheck(INRQGRID)) return;
    if (!PHA_GridEditor.CheckValuesMsg(INRQGRID)) return;
    
    /* 子表数据 */
    var gridChanges = $('#' + INRQGRID).datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen){
	    PHA.Msg('alert', '界面数据已编辑，请保存后再完成！');
	    return;
    }
    var pJson = {
		inrqId : InrqId
	}
    com.Biz(pJson, 'CancelComp', Query);    
}

// 查单据用来复制
function FindCancel(){
    $('#diagFind')
        .dialog({
	        title: $g('复制库存请求单'),
            iconCls: 'icon-w-copy',
            width: $('body').width() * 0.85,
            height: $('body').height() * 0.85,
            modal: true,
            onBeforeClose: function () {},
        })
        .dialog('open');
     InitGridInrq_f();
     InitGridInrqi_f();
     Clear_f();	
     setTimeout(function(){QueryInrq_f();}, 500);  
}

function Find(){
    $('#diagFind')
        .dialog({
	        title: $g('查询库存请求单'),
            iconCls: 'icon-w-find',
            modal: true,
            width: PHA_COM.Window.Width(),
            height: PHA_COM.Window.Height(),
            onBeforeClose: function () {},
        })
        .dialog('open');
    InitGridInrq_f();
    InitGridInrqi_f();
    $('#btnSelect_f').linkbutton({text: '选取'})
    $('#reqStatus_f').combobox('reload', PHA_IN_STORE.ReqStauts('ALL').url);
	$('#btnDelete_f').linkbutton({ disabled: false });
	$('#btnDelete_f').show();
	$('#btnDelete_f').next(".combo").show();
	
    Clear_f();	 
    setTimeout(function(){QueryInrq_f();}, 500);    
}

function InitGridInrq_f()
{
	compoments.InitMainGrid(INRQGRID_F,INRQBAR_F,
		function(){
			QueryInrqi_f();
		},
		function(inrqId){
			Query(inrqId);
		    $('#diagFind').dialog('close');
		}
	)
}

function InitGridInrqi_f()
{
	compoments.InitDetailGrid(INRQIGRID_F);
}

function GetInrqId_f(){
	var gridSelect = $('#' + INRQGRID_F).datagrid('getSelected') || '';
    if (gridSelect) return gridSelect.inrqId;
    return '';
}

function Select_f(){
	var inrqId = GetInrqId_f();
	if (!inrqId) {
		PHA.Msg('alert', '请选择一张库存请求单' );
		return;
	}
	if(IsCopy()){
		$('#diagCopyInrqCondition')
	        .dialog({
		        title: $g('选择复制条件'),
	            iconCls: 'icon-w-copy',
	            modal: true,
	            width: 500,
	            height: 150,
	            onBeforeClose: function () {},
	        })
	        .dialog('open');
	      $('#limitBatFlag').checkbox('setValue', true);  //默认复制批次
	}
	else{
		Query(inrqId)
		$('#diagFind').dialog('close');
	}
}

function Delete_f(){
	var inrqId = GetInrqId_f();
	if (!inrqId) {
		PHA.Msg('alert', '请选择一张库存请求单' );
		return;
	}
	var pJson = {inrqId:inrqId}
	com.BizConfirm(pJson, 'Delete', function(){
		QueryInrq_f();
		if(inrqId = InrqId){
			Clear();
		}
	});
}

function DeleteRefuse_f(){
	var inrqId = GetInrqId_f();
	if (!inrqId) {
		PHA.Msg('alert', '请选择一张库存请求单' );
		return;
	}
	var pJson = {inrqId:inrqId}
	com.BizConfirm(pJson, 'DeleteRefuse', function(){
		QueryInrq_f();
		compoments.Clear([INRQIGRID_F], []);
	});
}

function SetInfoArea(retData){
	var dataArr = [
	  {
	    info: retData.reqNo ,
	    append: '/'
	  },{
	    prepend: '制单: ',
	    info: retData.creator + ' ' + retData.createDate+ ' ' + retData.createTime,
	    append: '/'
	  },{
	    info: retData.compFlag == 'Y' ? '完成': '未完成',
	    labelClass: retData.compFlag == 'Y' ? 'info' : 'danger',
	    append: '/'
	  },{
	    info: retData.noItmFlag ? $g('无明细信息!!!'): '',
	    labelClass: retData.noItmFlag  ? 'danger' : 'info'
	  }
	];
	
	$('#infoArea').phabanner('loadData', dataArr);
}

function Print(){
	if (!InrqId) {
		PHA.Msg('alert', '请选择一张库存请求单' );
		return;
	}
	PrintReq(InrqId);
}

function SetTotalAmt(){
	PHA_COM.SumGridFooter('#' + INRQGRID, ['rpAmt', 'spAmt']);
}

function Refresh(){
	if(!InrqId){
		PHA.Msg('alert' ,'无有效请求单！');
	   return;
	}
	Query(InrqId);
}

function IfDrugCanReq(inci){
	var pJson = {
		proLocId: $('#proLocId').combobox('getValue'),
		recLocId: $('#recLocId').combobox('getValue'),
		inci    : inci
	}
	return com.Data(pJson, 'CheckDrugCanReq');
}

/// 删除明细后更新 单据信息展示框中是否有明细标志
function UpdateInfoArea(){
	if (!InrqId) return;
	var rows = $('#' + INRQGRID).datagrid('getRows')
	var rowsLen = rows.length
	if(rowsLen > 0) return;
	var pJson = {inrqId:InrqId};
	SetInfoArea(com.Data(pJson, 'GetMainData'));
}

function FindCopy(){
    $('#diagFind')
        .dialog({
	        title: $g('复制库存请求单'),
            iconCls: 'icon-w-copy',
            modal: true,
            width: PHA_COM.Window.Width(),
            height: PHA_COM.Window.Height(),
            onBeforeClose: function () {},
        })
        .dialog('open');
    $('#btnSelect_f').linkbutton({text: '复制'})
	//$('#btnDelete_f').linkbutton({ disabled: true });
	$('#btnDelete_f').hide();
	$('#btnDelete_f').next(".combo").hide();
    $('#reqStatus_f').combobox('reload', PHA_IN_STORE.ReqStauts('TRANS').url);
    InitGridInrq_f();
    InitGridInrqi_f();
    Clear_f();
}

function IsCopy(){
	var btnText = $('#btnSelect_f').text();
	if(btnText.indexOf($g('复制')) >= 0) return true;
	return false;
}

function CopyInrq(){
	var inrqId = GetInrqId_f();
	var recLocId = $('#recLocId_copy').combobox('getValue');
	var proLocId = $('#proLocId_copy').combobox('getValue');
	if(!recLocId){
		PHA.Msg('alert', '请选择请求科室' );
		return;
	}
	if(!proLocId){
		PHA.Msg('alert', '请选择供给科室' );
		return;
	}
	var pJson = {
		inrqId   : inrqId,
		recLocId : recLocId,
		proLocId : proLocId,
	}
	com.Biz(pJson, 'CopyInrq', function(newInitId){
		$('#diagFind').dialog('close');
        $('#diagCopyInrqCondition').dialog('close');
        Query(newInitId)
	});

}

function CheckQty(){
	if (gParamReq.IfRQtyOver == 'Y') return true
	var rows = $('#' + INRQGRID).datagrid('getRows');
	var rowLen = rows.length;
	var retMsg = '';
	var editRow = 0;
	for (var i = 0; i < rowLen; i++) {
		var rowData = rows[i];
		var qty = rowData.qty;
		if(!qty){
			retMsg = '请求数量不能为空或者0' ;
			editRow = i;
			break;
		}
		qty = isNaN(qty) ? 0 : qty;
		if(gParamReq.IfRQtyOver != 'Y'){
			var proLocQty = rowData.proLocQty;
			if(qty > proLocQty){
				retMsg = '请求数量大于供应科室数量' ;
				editRow = i;
				break;
			}
		}
	}
	if (retMsg != ''){
		PHA.Msg('alert', retMsg);
		PHA_GridEditor.Edit({
			gridID : INRQGRID,
			index : editRow,
			field : 'qty'
		});
		return false;
	}
	return true;
}

function SelectDurg(){
	PHA_UX.IncilQtySelect({},{
        proLocId: $('#proLocId').combobox('getValue') || '',
        reqLocId: $('#recLocId').combobox('getValue') || '',
    }, '', SelectDurgReturn
    );
}

function SelectDurgReturn(rowIndex, rowData, className){
	if (!PHA_GridEditor.EndCheck(INRQGRID)) return '';
	
	/* 检查是否有重复药品 */
	var inci = rowData.inci;
	var rows = $('#' + INRQGRID).datagrid('getRows');
	for (var i = 0; i < rows.length; i++) {
		var row = rows[i];
		if (row.inci == inci) {
			PHA.Msg("info", "药品已存在: " + rowData.inciDesc);
			return;
		}
	}
	var pJson = {
		inci : rowData.inci,
        proLocId: $('#proLocId').combobox('getValue') || '',
    	reqLocId: $('#recLocId').combobox('getValue') || '',
	};
	var newRowData =  $.cm(
        {
            ClassName: 'PHA.STORE.Drug',
            MethodName: 'GetInciData',
            pJsonStr : JSON.stringify(pJson)
        },
        false
    )
    
	newRowData.uomId = newRowData.pUomId;
	newRowData.uomDesc = newRowData.pUomDesc;
	newRowData.uomFac = newRowData.pFac;
	// 此处还是建议直接取 cmbRowData 中的数据，提交效率
	var inciUomData = GetInciUomData(newRowData.uomId, newRowData.inci)
	$.extend(newRowData, inciUomData);
	PHA_GridEditor.Add({
        gridID: INRQGRID,
        field: '',
        rowData: newRowData
    });
    $('#PHA_UX_IncilQtySelect_Grid').datagrid('deleteRow', rowIndex);
}