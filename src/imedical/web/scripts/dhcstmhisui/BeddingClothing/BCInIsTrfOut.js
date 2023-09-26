var init = function(){
	
	$UI.linkbutton('#SearchBT', {
		onClick: function(){
			BCInIsTrfFind(0,Select);
		}
	});
	
	function Select(RowId){
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'Select',
			Init: RowId
		}, function(jsonData){
			$UI.fillBlock('#Conditions',jsonData);
			SetEditDisable();
			var InitComp = jsonData['InitComp'];
			var InitState = jsonData['InitState'];
			if(InitComp == 'Y'){
				if(InitState == '21'){
					var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false,
						'#CancelCompBT':false};
				}else if(InitState == '31'){
					var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false,
						'#CancelCompBT':false};
				}else{
					var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false,
						'#CancelCompBT':true};
				}
			}else{
				var BtnEnaleObj = {'#SaveBT':true, '#DeleteBT':true, '#CompleteBT':true,
					'#CancelCompBT':false};
			}
			ChangeButtonEnable(BtnEnaleObj);
		});
		
		var ParamsObj = {Init: RowId};
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			Params: Params,
			rows: 999
		});
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			var MainObj = $UI.loopBlock('#Conditions');
			var IsChange=$UI.isChangeBlock('#Conditions')
			var SelectedRow = DetailGrid.getSelected();
			if (isEmpty(SelectedRow)&&IsChange==false) {
				$UI.msg('alert',"没有需要保存的内容!");
				return;
			}
			if(MainObj['InitComp'] == 'Y'){
				$UI.msg('alert', '该单据已经完成,不可重复保存!');
				return;
			}
			if(isEmpty(MainObj['InitFrLoc'])){
				$UI.msg('alert', '出库科室不可为空!')
				return;
			}
			if(isEmpty(MainObj['InitToLoc'])){
				$UI.msg('alert', '接收科室不可为空!')
				return;
			}
			MainObj['InitState'] = '10';
			var Main = JSON.stringify(MainObj);
			var Detail = DetailGrid.getChangesData('Inclb');
			var ifChangeMain=$UI.isChangeBlock('#Conditions');
			if (Detail === false){	//未完成编辑或明细为空
				return;
			}
			if (!ifChangeMain && (isEmpty(Detail))){	//主单和明细不变
				$UI.msg("alert", "没有需要保存的信息!");
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsSave',
				Main: Main,
				Detail: JSON.stringify(Detail)
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					var InitId = jsonData.rowid;
					Select(InitId);
					if(InitParamObj['AutoPrintAfterSave'] == 'Y'){
						PrintInIsTrfBC(InitId, 'Y');
					}
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#CompleteBT', {
		onClick: function(){
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if(isEmpty(InitId)){
				return;
			}
			var InitComp = ParamsObj['InitComp'];
			if(InitComp == 'Y'){
				$UI.msg('alert', '该单据已完成,不可重复操作!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsSetCompleted',
				Params: Params
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					var InitId = jsonData.rowid;
					Select(InitId);
					//完成后自动打印 或 完成后自动出库审核，出库审核后自动打印
					if((InitParamObj.AutoPrintAfterComp=='Y') || (InitParamObj.AutoAckOutAfterCompleted=='Y' && InitParamObj.AutoPrintAfterAckOut=='Y')){
						PrintInIsTrfBC(InitId, 'Y');
					}
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#CancelCompBT', {
		onClick: function(){
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if(isEmpty(InitId)){
				return;
			}
			var InitComp = ParamsObj['InitComp'];
			if(InitComp != 'Y'){
				$UI.msg('alert', '该单据不是完成状态,不可操作!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
				MethodName: 'jsCancelComplete',
				Params: Params
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					var InitId = jsonData.rowid;
					Select(InitId);
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#DeleteBT', {
		onClick: function(){
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if(isEmpty(InitId)){
				return;
			}
			var InitComp = ParamsObj['InitComp'];
			if(InitComp == 'Y'){
				$UI.msg('alert', '该单据已经完成,不可删除!');
				return;
			}
			$UI.confirm('您将要删除单据,是否继续?', '', '', Delete);
		}
	});
	function Delete(){
		var ParamsObj = $UI.loopBlock('#Conditions');
		var InitId = ParamsObj['RowId'];
		var Params = JSON.stringify(ParamsObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsDelete',
			Params: Params
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				Clear();
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function(){
			Clear();
		}
	});
	function Clear(){
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		SetDefaValues();
		var BtnEnaleObj = {'#SaveBT':true, '#DeleteBT':false, '#CompleteBT':false,'#CancelCompBT': false};
		ChangeButtonEnable(BtnEnaleObj);
		SetEditEnable();
	}
	function SetEditDisable(){
		$HUI.combobox('#InitFrLoc').disable();
		$HUI.combobox('#InitToLoc').disable();
		$HUI.combobox('#InitScg').disable();
	}
	function SetEditEnable(){
		$HUI.combobox('#InitFrLoc').enable();
		$HUI.combobox('#InitToLoc').enable();
		$HUI.combobox('#InitScg').enable();
	}
	
	$UI.linkbutton('#PrintBT', {
		onClick: function(){
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if(isEmpty(InitId)){
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			if(InitParamObj['PrintNoComplete']=='N' && ParamsObj['InitComp'] != 'Y'){
				Msg.info('warning','不允许打印未完成的转移单!');
				return;
			}
			PrintInIsTrfBC(InitId);
		}
	});
	
	$UI.linkbutton('#SelTransBT', {
		onClick: function(){
			SelInIsTrfIn(Select);
		}
	});
	
	var InitFrLoc = $HUI.combobox('#InitFrLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'Login'})),
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#InitFrLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var InitToLoc = $HUI.combobox('#InitToLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var OperateType = $HUI.combobox('#OperateType',{
		url : $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=Array&Params='
			+ JSON.stringify({Type: 'OM'}),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var InitState = $('#InitState').simplecombobox({
		data: [
			{RowId: '10', Description: '未完成'},
			{RowId: '11', Description: '已完成'},
			{RowId: '20', Description: '出库审核不通过'},
			{RowId: '21', Description: '出库审核通过'},
			{RowId: '30', Description: '拒绝接收'},
			{RowId: '31', Description: '已接收'}
		]
	});
	
	var UomCombox = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInciUom&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			required:true,
			mode:'remote',
			onBeforeLoad:function(param){
				var Select = DetailGrid.getRows()[DetailGrid.editIndex];
				if(!isEmpty(Select)){
					var Inci = Select.Inclb.split('||')[0];
					param.Inci = Inci;
				}
			}
		}
	};
	
	var DetailCm = [[{
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			width: 80,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			},
			width: 180
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: 'Inclb',
			field: 'Inclb',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 200
		}, {
			title: '厂商',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '批次库存',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '出库数量',
			field: 'Qty',
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					required: true
				}
			},
			align: 'right',
			width: 80
		}, {
			title: '单位',
			field: 'UomId',
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'UomId','UomDesc'),
			editor: UomCombox,
			width: 50
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '售价',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title : "货位码",
			field : 'StkBin',
			width : 100,
			align : 'left'
		}, {
			title: '请求数量',
			field: 'ReqQty',
			align: 'right',
			width: 80
		}, {
			title: '请求方库存',
			field: 'ReqLocStkQty',
			align: 'right',
			width: 100
		}, {
			title: '占用数量',
			field: 'InclbDirtyQty',
			align: 'right',
			width: 100
		}, {
			title: '本次占用',
			field: 'DirtyQty',
			align: 'right',
			width: 80
		}, {
			title: '可用数量',
			field: 'InclbAvaQty',
			align: 'right',
			width: 100
		}, {
			title : "转换率",
			field : 'ConFac',
			width : 80,
			align : 'left',
			hidden : true
		}, {
			title : "基本单位",
			field : 'BUomId',
			width : 80,
			align : 'left',
			hidden : true
		}, {
			title : "转移请求子表RowId",
			field : 'Inrqi',
			width : 100,
			align : 'left',
			hidden : true
		}
	]];
	
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'QueryInclbDetail'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			MethodName: 'jsDelete'
		},
		columns: DetailCm,
		remoteSort: false,
		showBar: true,
		pagination: false,
		showAddDelItems: true,
		beforeAddFn: function(){
			if(InitParamObj['RequestNeeded'] == 'Y'){
				$UI.msg('alert', '只能根据请求单转移制单,不可新增记录!');
				return;
			}
			if($('#InitComp').val() == 'Y'){
				$UI.msg('alert', '单据已完成, 不可增加');
				return false;
			}
			if(isEmpty($HUI.combobox('#InitToLoc').getValue())){
				$UI.msg('alert', '接收科室不可为空!');
				return false;
			}
			var OperateType = $HUI.combobox('#OperateType').getValue();
			if(InitParamObj.OutTypeNotNull == 'Y' && isEmpty(OperateType)){
				$UI.msg('alert', '请选择出库类型!');
				return false;
			}
			if(isEmpty($HUI.combotree('#InitScg').getValue())){
				$UI.msg('alert', '类组未选择,请谨慎核实数据!');
			}
			return true;
		},
		afterAddFn: function(){
			SetEditDisable();
			var BtnEnaleObj = {'#SaveBT':true, '#DeleteBT':false, '#CompleteBT':true, '#CancelCompBT':false};
			ChangeButtonEnable(BtnEnaleObj);
		},
		onClickCell: function(index, field, value){
			DetailGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field){
			var InitComp = $('#InitComp').val();
			if(InitComp == 'Y'){
				return false;
			}
		},
		onBeginEdit: function(index, row){
			//增加完成情况字数输入限制
			$('#DetailGrid').datagrid('beginEdit', index);
			var ed = $('#DetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++){
				var e = ed[i];
				if(e.field == 'InciDesc'){
					$(e.target).bind('keydown', function(event){
						if(event.keyCode == 13){
							var Input = $(this).val();
							var InitScg = $('#InitScg').combotree('getValue');
							var InitFrLoc = $('#InitFrLoc').combobox('getValue');
							var InitToLoc = $('#InitToLoc').combobox('getValue');
							var HV = '';
							var ParamsObj = {StkGrpRowId:InitScg, StkGrpType:'M', Locdr:InitFrLoc, NotUseFlag:'N', QtyFlag:'1',
								ToLoc:InitToLoc, NoLocReq:'N', HV:HV, QtyFlagBat:'1'};
							IncItmBatWindow(Input, ParamsObj, ReturnInfoFunc);
						}
					});
				}else if(e.field == 'Qty'){
					$(e.target).bind('keyup', function(event){
						if(event.keyCode == 13){
							DetailGrid.commonAddRow();
						}
					});
				}
			}
		},
		onAfterEdit: function(index, row, changes){
			if(changes.hasOwnProperty('Qty')){
				var Qty = Number(changes['Qty']);
				var InclbAvaQty = Number(row['InclbAvaQty']);
				var DirtyQty = Number(row['DirtyQty']);
				if(accSub(Qty, DirtyQty) > InclbAvaQty){
					$UI.msg('alert', '数量不可大于可用库存!');
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							Qty: '',
							RpAmt: 0,
							SpAmt: 0
						}
					});
					return;
				}
				var Rp = Number(row['Rp']), Sp = Number(row['Sp']);
				$(this).datagrid('updateRow', {
					index: index,
					row: {
						RpAmt: accMul(Qty, Rp),
						SpAmt: accMul(Qty, Sp)
					}
				});
			}
		}
	});
	
	function ReturnInfoFunc(rows){
		rows = [].concat(rows);
		$.each(rows, function(index, row){
			var RowIndex = DetailGrid.editIndex;
			var ed = $('#DetailGrid').datagrid('getEditor', {index:RowIndex,field:'UomId'});
			AddComboData(ed.target, row.PurUomId, row.PurUomDesc);
			DetailGrid.updateRow({
				index: RowIndex,
				row: {
					InciId: row.InciDr,
					InciCode: row.InciCode,
					InciDesc: row.InciDesc,
					Spec: row.Spec,
					Inclb: row.Inclb,
					BatExp: row.BatExp,
					Qty: row.OperQty,
					UomId: row.PurUomId,
					UomDesc: row.PurUomDesc,
					Rp: row.Rp,
					Sp: row.Sp,
					RpAmt: accMul(row.OperQty, row.Rp),
					SpAmt: accMul(row.OperQty, row.Sp),
					InclbQty: row.InclbQty,
					InclbDirtyQty: row.DirtyQty,
					InclbAvaQty: row.AvaQty
				}
			});
			$('#DetailGrid').datagrid('refreshRow', RowIndex);
			if(index< rows.length - 1){
				DetailGrid.commonAddRow();
			}
		});
	}
	
		//设置缺省值
	function SetDefaValues(){
		$('#InitFrLoc').combobox('setValue', gLocId);
	}
	
	var BtnEnaleObj = {'#SaveBT':true, '#DeleteBT':false, '#CompleteBT':false,
		'#CancelCompBT':false};
	ChangeButtonEnable(BtnEnaleObj);
	
	function SelectDefa(){
		SetDefaValues();
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'QueryInclbDetail',
			Params: JSON.stringify(addSessionParams({FrLoc:gLocObj.RowId,QtyFlag:"1",NotUseFlag:"N",StkScg:$("#InitScg").combotree('getValue')}))
		});
	}
	window.onload = SelectDefa;
}
$(init);