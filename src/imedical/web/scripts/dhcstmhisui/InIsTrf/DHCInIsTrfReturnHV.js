
var init = function(){
	
	$UI.linkbutton('#SearchBT', {
		onClick: function(){
			var HvFlag="Y";
			FindWin(Select,"",HvFlag);
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
		
		var ParamsObj = {Init: RowId};
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			Params: Params,
			rows:99999
		});
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			var MainObj = $UI.loopBlock('#Conditions');
			if(MainObj['InitComp'] == 'Y'){
				$UI.msg('alert', '�õ����Ѿ����,�����ظ�����!');
				return;
			}
			if(isEmpty(MainObj['InitFrLoc'])){
				$UI.msg('alert', '������Ҳ���Ϊ��!')
				return;
			}
			if(isEmpty(MainObj['InitToLoc'])){
				$UI.msg('alert', '���տ��Ҳ���Ϊ��!')
				return;
			}
			MainObj['InitState'] = '10';
			var Main = JSON.stringify(MainObj);
			var Detail = DetailGrid.getChangesData('Inclb');
			//�ж�
			var ifChangeMain=$UI.isChangeBlock('#Conditions');
			if (Detail === false){	//δ��ɱ༭����ϸΪ��
				return;
			}
			if (!ifChangeMain && (isEmpty(Detail))){	//��������ϸ����
				$UI.msg("alert", "û����Ҫ�������Ϣ!");
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
						PrintInIsTrfReturn(InitId, 'Y');
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
				$UI.msg('alert', '�õ��������,�����ظ�����!');
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
					//Select(InitId);
					$('#InitComp').checkbox('setValue', true);
					var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false, '#CancelCompBT':true};
					ChangeButtonEnable(BtnEnaleObj);
					//��ɺ��Զ���ӡ �� ��ɺ��Զ�������ˣ�������˺��Զ���ӡ
					if((InitParamObj.AutoPrintAfterComp=='Y') || (InitParamObj.AutoAckOutAfterCompleted=='Y' && InitParamObj.AutoPrintAfterAckOut=='Y')){
						PrintInIsTrfReturn(InitId, 'Y');
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
				$UI.msg('alert', '�õ��ݲ������״̬,���ɲ���!');
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
					//Select(InitId);
					$('#InitComp').checkbox('setValue', false);
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
				$UI.msg('alert', '�õ����Ѿ����,����ɾ��!');
				return;
			}
			$UI.confirm('����Ҫɾ������,�Ƿ����?', '', '', Delete);
		}
	});
	function Delete(){
		var ParamsObj = $UI.loopBlock('#Conditions');
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
				SetDefaValues();
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
		var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false, '#CancelCompBT':false};
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
				$UI.msg('alert', '��ѡ����Ҫ��ӡ�ĵ���!');
				return;
			}
			if(InitParamObj['PrintNoComplete']=="N" && $('#InitComp').checkbox('getValue') == false){
				Msg.info('warning','�������ӡδ��ɵ�ת�Ƶ�!');
				return;
			}
			PrintInIsTrfReturn(InitId);
		}
	});
	$UI.linkbutton('#PrintHVColBT', {
		onClick: function(){
			var ParamsObj = $UI.loopBlock('#Conditions');
			var InitId = ParamsObj['RowId'];
			if(isEmpty(InitId)){
				$UI.msg('alert', '��ѡ����Ҫ��ӡ�ĵ���!');
				return;
			}
			if(InitParamObj['PrintNoComplete']=="N" && $('#InitComp').checkbox('getValue') == false){
				Msg.info('warning','�������ӡδ��ɵ�ת�Ƶ�!');
				return;
			}
			PrintInIsTrfReturnHVCol(InitId);
		}
	});
	
	var InitFrLoc = $HUI.combobox('#InitFrLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description'
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
			+ JSON.stringify(addSessionParams({Type: 'OM'})),
		valueField: 'RowId',
		textField: 'Description'
	});
	var VirtualFlag = $HUI.checkbox('#VirtualFlag',{
		onCheckChange: function(e, value){
			if(value){
				var InitToLoc = $('#InitToLoc').combobox('getValue');
				var Info = tkMakeServerCall('web.DHCSTMHUI.Common.UtilCommon','GetMainLoc',InitToLoc);
				var InfoArr = Info.split("^");
				var VituralLoc = InfoArr[0], VituralLocDesc = InfoArr[1];
				AddComboData($('#InitToLoc'), VituralLoc, VituralLocDesc);
				$('#InitToLoc').combobox('setValue', VituralLoc);
			}else{
				$('#InitToLoc').combobox('setValue', gLocId);
			}
		}
	});
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
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 180
		}, {
			title: 'dhcit',
			field: 'dhcit',
			width: 80,
			hidden: true
		}, {
			title: '��ֵ����',
			field: 'HVBarCode',
			jump:false,
			saveCol: true,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			},
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 80
		}, {
			title: 'Inclb',
			field: 'Inclb',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: '����~Ч��',
			field: 'BatExp',
			width: 200
		}, {
			title: '����',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '���ο��',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '��������',
			field: 'Qty',
			saveCol: true,
			align: 'right',
			width: 80
		}, {
			title: '��λId',
			field: 'UomId',
			saveCol: true,
			width: 50,
			hidden: true
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 50
		}, {
			title: '����',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '�ۼ�',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '���۽��',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '�������',
			field: 'SterilizedBat',
			width: 160
		}, {
			title: '��������',
			field: 'ReqQty',
			align: 'right',
			width: 80
		}, {
			title: '���󷽿��',
			field: 'ReqLocStkQty',
			align: 'right',
			width: 100
		}, {
			title: 'ռ������',
			field: 'InclbDirtyQty',
			align: 'right',
			width: 100
		}
	]];
	
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			rows:99999
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			MethodName: 'jsDelete'
		},
		columns: DetailCm,
		remoteSort: false,
		showBar: true,
		showAddDelItems: true,
		pagination: false,
		beforeAddFn: function(){
			if($HUI.checkbox('#InitComp').getValue()){
				$UI.msg('alert', '���������, ��������');
				return false;
			}
			if(isEmpty($HUI.combobox('#InitFrLoc').getValue())){
				$UI.msg('alert', '�˿���Ҳ���Ϊ��!');
				return false;
			}
			var OperateType = $HUI.combobox('#OperateType').getValue();
			if (InitParamObj.OutTypeNotNull == 'Y' && isEmpty(OperateType)) {
				$UI.msg('alert', '��ѡ���������!');
				return false;
			}
			if(isEmpty($HUI.combotree('#InitScg').getValue())){
				$UI.msg('alert', '���鲻��Ϊ��!');
				return false;
			}
			return true;
		},
		afterAddFn: function(){
			SetEditDisable();
			var BtnEnaleObj = {'#SaveBT':true, '#DeleteBT':false, '#CompleteBT':true, '#CancelCompBT':false};
			ChangeButtonEnable(BtnEnaleObj);
		},
		onClickCell: function(index, field ,value){
			DetailGrid.commonClickCell(index, field);
		},
		onBeginEdit: function(index, row){
			//����������������������
			$('#DetailGrid').datagrid('beginEdit', index);
			var ed = $('#DetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++){
				var e = ed[i];
				if(e.field == 'HVBarCode'){
					$(e.target).bind('keydown', function(event){
						if(event.keyCode == 13){
							var BarCode = $(this).val();
							if(isEmpty(BarCode)){
								DetailGrid.stopJump();
								return;
							}
							var FindIndex = DetailGrid.find('HVBarCode', BarCode);
							if(FindIndex >= 0 && FindIndex != index){
								$UI.msg('alert', '���벻���ظ�¼��!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
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
								DetailGrid.stopJump();
								return;
							}
							
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
							var InitScg = $('#InitScg').combobox('getValue');
							if(!CheckScgRelation(InitScg, ScgStk)){
								$UI.msg('alert', '����'+BarCode+'����'+ScgStkDesc+'����,�뵱ǰ����!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return;
							}else if(Inclb == ''){
								$UI.msg('alert', BarCode + 'û����Ӧ����¼,�����Ƶ�!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return;
							}else if(IsAudit != 'Y'){
								$UI.msg('alert', BarCode + '��δ��˵�'+OperNo+',���ʵ!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return;
							}else if(Type=='T'){
								$UI.msg('alert', BarCode + '�Ѿ�����,�����Ƶ�!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return;
							}else if(Status!='Enable'){
								$UI.msg('alert', BarCode + '���ڲ�����״̬,�����Ƶ�!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return;
							}else if(RecallFlag=='Y'){
								$UI.msg('alert', BarCode + '��������״̬,�����Ƶ�!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return;
							}
							
							var ProLocId = $('#InitFrLoc').combobox('getValue');
							var ReqLocId = $('#InitToLoc').combobox('getValue');
							var ParamsObj = {InciDr: Inci, ProLocId: ProLocId, ReqLocId: ReqLocId, QtyFlag: 1, Inclb: Inclb};
							var Params = JSON.stringify(ParamsObj);
							var InclbData = $.cm({
								ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
								MethodName: 'GetDrugBatInfo',
								page: 1,
								rows: 1,
								Params: Params
							},false);
							if(!InclbData || InclbData.rows.length < 1){
								$UI.msg('alert', BarCode + 'û����Ӧ����¼,�����Ƶ�!');
								$(this).val('');
								$(this).focus();
								DetailGrid.stopJump();
								return;
							}
							var InclbInfo = $.extend(InclbData.rows[0], {InciDr:Inci, dhcit: dhcit, HVBarCode: BarCode});
//							row['HVBarCode'] = BarCode;
//							row['dhcit'] = dhcit;
							ReturnInfoFunc(index, InclbInfo);
						}
					});
				}
			}
		}
	});
	
	function ReturnInfoFunc(RowIndex, row){
		if(row.AvaQty < 1){
			$UI.msg('alert', '���ÿ�治��');
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
	
		//����ȱʡֵ
	function SetDefaValues(){
		$('#InitToLoc').combobox('setValue', session['LOGON.CTLOCID']);
		$('#InitScg').combotree('options')['setDefaultFun']();
	}
	SetDefaValues();
	var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false, '#CancelCompBT':false};
	ChangeButtonEnable(BtnEnaleObj);
}
$(init);