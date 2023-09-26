
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
	$UI.linkbutton('#SelOutBT', {
		onClick: function(){
			OutReq(Select);
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
	
	var InitFrLoc = $HUI.combobox('#InitFrLoc',{
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var OperateType = $HUI.combobox('#OperateType',{
		url : $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({Type: 'OM'})),
		valueField: 'RowId',
		textField: 'Description'
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
			title: '���ʴ���',
			field: 'InciCode',
			width: 120
		}, {
			title: '��������',
			field: 'InciDesc',
			jump:false,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			},
			width: 180
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
			editor: {
				type: 'numberbox',
				options: {
					precision: 2
				}
			},
			align: 'right',
			width: 80
		}, {
			title: '��λ',
			field: 'UomId',
			saveCol: true,
			formatter: CommonFormatter(UomCombox, 'UomId','UomDesc'),
			editor: UomCombox,
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
		}, {
			title: '��������',
			field: 'InclbAvaQty',
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
				$UI.msg('alert', '����δѡ��,�������ʵ����!');
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
				if(e.field == "InciDesc"){
					$(e.target).bind("keydown", function(event){
						if(event.keyCode == 13){
							var Input = $(this).val();
							var InitScg = $("#InitScg").combotree('getValue');
							var InitFrLoc = $("#InitFrLoc").combobox('getValue');
							var InitToLoc = $("#InitToLoc").combobox('getValue');
							var HV = 'N'; 
							var ParamsObj = {StkGrpRowId:InitScg, StkGrpType:'M', Locdr:InitFrLoc, NotUseFlag:'N', QtyFlag:'Y',
								ToLoc:InitToLoc, HV:HV};
							IncItmBatWindow(Input, ParamsObj, ReturnInfoFunc);
						}
					});
				}
			}
		}
	});
	
	function ReturnInfoFunc(rows){
		rows = [].concat(rows);
		$.each(rows, function(index, row){
			var RowIndex = DetailGrid.getRowIndex(DetailGrid.getSelected());
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
					inclbDirtyQty: row.DirtyQty,
					inclbAvaQty: row.AvaQty
				}
			});
			$('#DetailGrid').datagrid('refreshRow', RowIndex);
			//var ed = $('#DetailGrid').datagrid('getEditor', {index: RowIndex, field: 'Qty'});
			//$(ed.target).focus();
			if(index< rows.length){
				DetailGrid.commonAddRow();
			}
		});
	}
	
		//����ȱʡֵ
	function SetDefaValues(){
		$('#InitToLoc').combobox('setValue', session['LOGON.CTLOCID']);
	}
	SetDefaValues();
	var BtnEnaleObj = {'#SaveBT':false, '#DeleteBT':false, '#CompleteBT':false, '#CancelCompBT':false};
	ChangeButtonEnable(BtnEnaleObj);
}
$(init);