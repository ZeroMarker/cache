
var CURR_INIT = '';

var init = function(){
	
	$UI.linkbutton('#SearchBT', {
		onClick: function(){
			FindWin(Select);
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
			if(InitComp == "Y"){
				if(InitState == '21'){
					var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false, '#CancelCompBT':false};
				}else if(InitState == '31'){
					var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false, '#CancelCompBT':false};
				}else{
					var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false, '#CancelCompBT':true};
				}
			}else{
				var BtnEnaleObj = {'#SaveBT':true, '#DeleteBT':true, '#CompleteBT':true, '#CancelCompBT':false};
			}
			ChangeButtonEnable(BtnEnaleObj);
		});
		
		$UI.setUrl(DetailGrid);
		var ParamsObj = {Init: RowId, InitType:'K'};
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			Params: Params
		})
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			var MainObj = $UI.loopBlock('#Conditions');
			if(MainObj['InitComp'] == 'Y'){
				$UI.msg('alert', '该单据已经完成,不可重复保存!');
				return;
			}
			if(isEmpty(MainObj['InitFrLoc'])){
				$UI.msg('alert', '退库科室不可为空!');
				return;
			}
			if(isEmpty(MainObj['InitToLoc'])){
				$UI.msg('alert', '库房不可为空!');
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
					Select(jsonData.rowid);
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
					Select(jsonData.rowid);
					//$('#InitComp').checkbox('setValue', true);
					var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false, '#CancelCompBT':true};
					ChangeButtonEnable(BtnEnaleObj);
					$UI.setUrl(MasterGrid);
					MasterGrid.load({
								ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
								QueryName: 'QueryTrans',
								InitStr: CURR_INIT
					});
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
					Select(jsonData.rowid);
					//$('#InitComp').checkbox('setValue', false);
					var BtnEnaleObj = {'#SaveBT':true, '#DeleteBT':true, '#CompleteBT':true, '#CancelCompBT':false};
					ChangeButtonEnable(BtnEnaleObj);
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
				$UI.clearBlock('#Conditions');
				$UI.clear(DetailGrid);
				var RowIndex = MasterGrid.find('RowId', InitId);
				if(RowIndex != -1){
					MasterGrid.deleteRow(RowIndex);
				}
				SetDefaValues();
			}else{
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function(){
			$UI.clearBlock('#Conditions');
			$UI.clear(MasterGrid);
			$UI.clear(DetailGrid);
			SetDefaValues();
			SetEditEnable();
		}
	});
	function SetEditDisable(){
		$HUI.combobox('#InitToLoc').disable();
		//$HUI.combobox('#InitScg').disable();
	}
	function SetEditEnable(){
		$HUI.combobox('#InitToLoc').enable();
		//$HUI.combobox('#InitScg').enable();
	}
	
	$UI.linkbutton('#PrintBT', {
		onClick: function(){
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if(isEmpty(InitId)){
				$UI.msg('alert', '请选择需要打印的单据!');
				return;
			}
			PrintInIsTrfReturn(InitId);
		}
	});
	$UI.linkbutton('#SelReqBT', {
		onClick: function(){
			SelReq(Select);
		}
	});
	
	var InitFrLoc = $HUI.combobox('#InitFrLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record){
			var LocId = record['RowId'];
//			$('#CreateUser').combobox('clear');  
//			$('#CreateUser').combobox('reload', $URL
//				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=Array&Params='
//				+ JSON.stringify({LocId:LocId})
//			);
		}
	});
	
	var InitToLoc = $HUI.combobox('#InitToLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'Login'})),
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#InitToLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var OperateType = $HUI.combobox('#OperateType',{
		url : $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=Array&Params='
			+ JSON.stringify({Type: 'OM'}),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var MasterCm = [[{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '单号',
			field: 'InitNo',
			align: 'left',
			width: 150,
			sortable: true
		}, {
			title: '退库科室Id',
			field: 'FrLocId',
			width: 100,
			hidden: true
		}, {
			title: '退库科室',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '库房',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '制单时间',
			field: 'InitDateTime',
			width: 150
		}, {
			title: '单据状态',
			field: 'StatusCode',
			width: 70
		}
	]];
	
	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'QueryTrans'
		},
		columns: MasterCm,
		showBar: false,
		pagination: false,
		onSelect: function(index, row){
			var Init = row['RowId'];
			Select(Init);
		}
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
				var Select = DetailGrid.getSelected();
				if(!isEmpty(Select)){
					param.Inci =Select.Inci;
				}
			}
//			,
//			onSelect:function(record){
//				var rows =InRequestGrid.getRows();
//				var row = rows[InRequestGrid.editIndex];
//				row.UomDesc=record.Description;
//				
//			},
//			onShowPanel:function(){
//				$(this).combobox('reload');
//			}
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
			width: 180
		}, {
			title: 'dhcit',
			field: 'dhcit',
			width: 80,
			hidden: true
		}, {
			title: '高值条码',
			field: 'HVBarCode',
			saveCol: true,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			},
			width: 150
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
			align: 'right',
			width: 80
		}, {
			title: '单位Id',
			field: 'UomId',
			saveCol: true,
			width: 50,
			hidden: true
		}, {
			title: '单位',
			field: 'UomDesc',
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
			title: '灭菌批号',
			field: 'SterilizedBat',
			width: 160
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
		}
	]];
	
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD'
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			MethodName: 'jsDelete'
		},
		columns: DetailCm,
		remoteSort: false,
		showBar: true,
		showAddDelItems: true,
		beforeAddFn: function(){
			if(isEmpty($HUI.combobox('#InitToLoc').getValue())){
				$UI.msg('alert', '库房不可为空!');
				return false;
			}
			return true;
		},
		afterAddFn: function(){
			SetEditDisable();
		},
		onClickCell: function(index, field ,value){
			DetailGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field){
			var InitComp = $('#InitComp').val();
			if(InitComp == 'Y'){
				return false;
			}
			var RowData = $(this).datagrid('getRows')[index];
			if(field == 'HVBarCode' && !isEmpty(RowData['RowId'])){
				return false;
			}
			return true;
		},
		onBeginEdit: function(index, row){
			//增加完成情况字数输入限制
			$('#DetailGrid').datagrid('beginEdit', index);
			var ed = $('#DetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++){
				var e = ed[i];
				if(e.field == 'HVBarCode'){
					$(e.target).bind('keydown', function(event){
						if(event.keyCode == 13){
							var BarCode = $(this).val();
							if(isEmpty(BarCode)){
								return;
							}
							var FindIndex = DetailGrid.find('HVBarCode', BarCode);
							if(FindIndex >= 0 && FindIndex != index){
								$UI.msg('alert', '条码不可重复录入!');
								$(this).val('');
								$(this).focus();
								return false;
							}
							var BarCodeData = $.cm({
								ClassName: 'web.DHCSTMHUI.DHCItmTrack',
								MethodName: 'GetItmByBarcode',
								BarCode: BarCode
							},false);
							
							if(!isEmpty(BarCodeData.sucess) && BarCodeData.sucess != 0){
								$UI.msg('alert', BarCodeData.msg)
								$(this).val('');
								$(this).focus();
								return;
							}
							
							var LocId = BarCodeData['LocId'];
							var ScgStk = BarCodeData['ScgStk'];
							var ScgStkDesc = BarCodeData['ScgStkDesc'];
							var Inclb = BarCodeData['Inclb'];
							var IsAudit = BarCodeData['IsAudit'];
							var OperNo = BarCodeData['OperNo'];
							var Type = BarCodeData['Type'];
							var Status = BarCodeData['Status'];
							var RecallFlag = BarCodeData['RecallFlag'];
							var Inci = BarCodeData['Inci'];
							var dhcit = BarCodeData['dhcit'];
							var ReqLocId = $('#InitToLoc').combobox('getValue');
							//var InitScg = $('#InitScg').combobox('getValue');
//							if(!CheckScgRelation(InitScg, ScgStk)){
//								$UI.msg('alert', '条码'+BarCode+'属于'+ScgStkDesc+'类组,与当前不符!');
//								$(this).val('');
//								$(this).focus();
//								return;
//							}else 
							if(Inclb == ''){
								$UI.msg('alert', '该高值材料没有相应库存记录,不能制单!');
								$(this).val('');
								$(this).focus();
								return;
							}else if(IsAudit != 'Y'){
								$UI.msg('alert', '该高值材料有未审核的'+OperNo+',请核实!');
								$(this).val('');
								$(this).focus();
								return;
							}else if(Type=='T'){
								$UI.msg('alert', '该高值材料已经出库,不可制单!');
								$(this).val('');
								$(this).focus();
								return;
							}else if(Status!='Enable'){
								$UI.msg('alert', '该高值条码处于不可用状态,不可制单!');
								$(this).val('');
								$(this).focus();
								return;
							}else if(RecallFlag=='Y'){
								$UI.msg('alert', '该高值条码处于锁定状态,不可制单!');
								$(this).val('');
								$(this).focus();
								return;
							}else if(LocId==ReqLocId){
								$UI.msg('alert', '本科室条码!');
								$(this).val('');
								$(this).focus();
								return;
							}
							
							//判断退库单状态
							var Init = '';
							var FrLocIndex = MasterGrid.find('FrLocId', LocId);
							if(FrLocIndex != -1){
								Init = MasterGrid.getData().rows[FrLocIndex]['RowId'];
								var Status = MasterGrid.getData().rows[FrLocIndex]['Status'];
								var InitNo = MasterGrid.getData().rows[FrLocIndex]['InitNo'];
								if(Status != '10'){
									$UI.msg('alert', '退库单' + InitNo + '已完成!');
									return;
								}
							}
							
							//var ProLocId = $('#InitFrLoc').combobox('getValue');
							var ReqLocId = $('#InitToLoc').combobox('getValue');
							var ParamsObj = {InciDr: Inci, ProLocId: LocId, ReqLocId: ReqLocId, QtyFlag: 1, Inclb: Inclb};
							var Params = JSON.stringify(ParamsObj);
							var InclbData = $.cm({
								ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
								MethodName: 'GetDrugBatInfo',
								page: 1,
								rows: 1,
								Params: Params
							},false);
							
							var InclbInfo = $.extend(InclbData.rows[0], {InciDr:Inci, dhcit: dhcit, HVBarCode: BarCode});
//							row['HVBarCode'] = BarCode;
//							row['dhcit'] = dhcit;
							ReturnInfoFunc(index, InclbInfo);
							
							//保存退库单主表
							var MainObj = {};
							MainObj['RowId'] = Init;
							MainObj['InitFrLoc'] = LocId;
							MainObj['InitToLoc'] = $('#InitToLoc').combobox('getValue');
							MainObj['InitComp'] = 'N';
							MainObj['InitState'] = '10';
							MainObj['InitUser'] = gUserId;
							MainObj['InitRemarks'] = '';
							
							var UomId = InclbInfo['BUomId'];
							var DetailObj = [{Initi: '', Inclb: Inclb, Qty: 1, UomId: UomId, HVBarCode: BarCode}];
							var Detail = JSON.stringify(DetailObj);
							
							var Main = JSON.stringify(addSessionParams(MainObj));
							var InitData = $.cm({
								ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
								MethodName: 'jsSave',
								Main: Main,
								Detail: Detail
							},false);
							var Init = InitData.rowid;
							if(InitData.success < 0){
								$UI.msg('error', Barcode + '保存失败!');
								return false;
							}
							if(CURR_INIT == ''){
								CURR_INIT = Init;
							}else if($.inArray(Init + '', CURR_INIT.split(',')) == -1){
								CURR_INIT = CURR_INIT + ',' + Init;
							}
							$UI.setUrl(MasterGrid);
							MasterGrid.load({
								ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
								QueryName: 'QueryTrans',
								InitStr: CURR_INIT
							});
						}
					});
				}
			}
		}
	});
	
	function ReturnInfoFunc(RowIndex, row){
		if(row.AvaQty < 1){
			$UI.msg('alert', '可用库存不足');
			return;
		}
		DetailGrid.updateRow({
			index: RowIndex,
			row: {
				HVBarCode: row.HVBarCode,
				dhcit: row.dhcit,
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
				RpAmt: row.Rp,
				SpAmt: row.Sp,
				InclbDirtyQty: row.DirtyQty,
				Qty: 1
			}
		});
		$('#DetailGrid').datagrid('refreshRow', RowIndex);
		DetailGrid.commonAddRow();
	}
	
		//设置缺省值
	function SetDefaValues(){
		$('#InitToLoc').combobox('setValue', session['LOGON.CTLOCID']);
	}
	SetDefaValues();
}
$(init);