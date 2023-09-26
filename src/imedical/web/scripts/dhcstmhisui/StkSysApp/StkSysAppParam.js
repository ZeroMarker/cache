// ����:�������ù���

var init = function(){
	var ReSetAppParam = {
		text : '��ʼ������',
		iconCls : 'icon-init',
		handler : function(){
			if(!confirm('��һ����ʾ: ���������ò���, ���ɾ��֮ǰ�����в�������, �Ƿ����?')){
				return;
			}
			if(!confirm('�ڶ�����ʾ: ���������ò���, ���ɾ��֮ǰ�����в�������, �Ƿ����?')){
				return;
			}
			if(!confirm('���һ����ʾ: ���������ò���, ���ɾ��֮ǰ�����в�������, �Ƿ����?')){
				return;
			}
			
			var result = tkMakeServerCall('web.DHCSTMHUI.Tools.CreateAppPara', 'ReSetParame');
			if(!isEmpty(result)){
				$UI.msg('error', '����ʧ��:' + result);
			}else{
				$UI.msg('success', '���óɹ�!');
				$UI.clear(AppGrid);
				$UI.clear(AppParamGrid);
				$UI.clear(AppParamValueGrid);
				AppGrid.reload();
			}
		}
	};
	var AppSynBT = {
		text: 'ͬ��Ӧ��',
		iconCls: 'icon-reload',
		handler: function(){
			var synRet = tkMakeServerCall('web.DHCSTMHUI.Tools.CreateApp','App');
			var synRet = tkMakeServerCall('web.DHCSTMHUI.Tools.CreateAppPara','Prop');
			var synRetArr = synRet.split('^');
			$UI.msg('success', '����'+synRetArr[2]+'��, ����'+synRetArr[0]+'��, �޸�'+synRetArr[1]+'��!');
			$UI.clear(AppGrid);
			$UI.clear(AppParamGrid);
			$UI.clear(AppParamValueGrid);
			AppGrid.reload();
		}
	};
	
	var AppGrid = $UI.datagrid('#AppGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkSysApp',
			MethodName: 'SelectAll',
			rows: 999
		},
		remoteSort: false,
		pagination: false,
		toolbar: [ReSetAppParam, AppSynBT],
		showAddDelItems: false,
		fitColumns: true,
		columns: [[
			{
				title: 'RowId',
				field: 'RowId',
				width: 80,
				hidden: true
			},{
				title: '����',
				field: 'Code',
				width: 200
			},{
				title: '����',
				field: 'Desc',
				width: 200
			}
		]],
		onSelect: function(index, row){
			var Parref = row['RowId'];
			$UI.clear(AppParamValueGrid);
			$UI.clear(AppParamGrid);
			AppParamGrid.load({
				ClassName: 'web.DHCSTMHUI.StkSysAppParam',
				MethodName: 'SelectAll',
				Parref: Parref,
				rows: 999
			});
		}
	});

	
	var AppParamSaveBT = {
		text: '����',
		iconCls: 'icon-save',
		handler: function(){
			var AppRow = AppGrid.getSelected();
			if(isEmpty(AppRow)){
				$UI.msg('alert', '��ѡ����Ӧ��Ӧ�ó���!');
				return;
			}
			var Parref = AppRow['RowId'];
			AppParamGrid.endEditing();
			var Detail = AppParamGrid.getChangesData('Code');
			if (Detail === false){	//δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Detail)){	//��ϸ����
				$UI.msg("alert", "û����Ҫ�������ϸ!");
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.StkSysAppParam',
				MethodName: 'Save',
				Parref: Parref,
				Detail: JSON.stringify(Detail)
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					AppParamGrid.reload();
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	}
	
	var AppParamGrid = $UI.datagrid('#AppParamGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.StkSysAppParam',
			MethodName: 'SelectAll',
			rows: 999
		},
		remoteSort: false,
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.StkSysAppParam',
			MethodName: 'Delete'
		},
		pagination: false,
		toolbar: [AppParamSaveBT],
		showAddDelItems: true,
		beforeAddFn: function(){
			var AppRow = AppGrid.getSelected();
			if(isEmpty(AppRow)){
				$UI.msg('alert', '��ѡ����Ӧ�Ĳ���!');
				return false;
			}
		},
		fitColumns: true,
		columns: [[
			{
				title: 'RowId',
				field: 'RowId',
				width: 80,
				hidden: true
			},{
				title: '����',
				field: 'Code',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			},{
				title: '����',
				field: 'Desc',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			},{
				title: '��ע',
				field: 'Memo',
				width: 200,
				editor: 'validatebox'
			},{
				title: 'ȱʡֵ',
				field: 'PropValue',
				width: 250,
				editor: 'validatebox'
			}
		]],
		onClickCell: function(index, field ,value){
			AppParamGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field){
			var RowData = $(this).datagrid('getRows')[index];
			if(field == 'Code' && !isEmpty(RowData['RowId'])){
				return false;
			}
		},
		onSelect: function(index, row){
			var Parref = row['RowId'];
			$UI.clear(AppParamValueGrid);
			if(!isEmpty(Parref)){
				AppParamValueGrid.load({
					ClassName: 'web.DHCSTMHUI.StkSysAppParam',
					MethodName: 'SelectProp',
					Parref: Parref,
					HospId: gHospId,
					rows: 999
				});
			}
		},
		onLoadSuccess: function(data){
			
		}
	});
	
	var TypeField = $HUI.combobox('#TypeField', {
		data: [{RowId: 'G', Description: '��ȫ��'}, {RowId: 'L', Description: '����'},
			{RowId: 'U', Description: '��Ա'}, {RowId: 'D', Description: 'ȫԺ'}
		],
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record){
			var Type = record['RowId'];
			//var RowIndex = AppParamValueGrid.getRowIndex(AppParamValueGrid.getSelected());
			//var PointerTarget = $('#AppParamValueGrid').datagrid('getEditor', {index: RowIndex, field: 'Pointer'}).target;
			var PointerTarget = $('#PointerField')
			PointerTarget.combobox('setValue', '');
			if(Type == 'G'){
				PointerTarget.combobox('reload',
					$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetGroup&ResultSetType=Array'
					+ '&Params=' + JSON.stringify(addSessionParams({ShowAllHospFlag:'Y'})));
			}else if(Type == 'L'){
				PointerTarget.combobox('reload',
					$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array'
					+ '&Params=' + JSON.stringify(addSessionParams({Type:'All',ShowAllHospFlag:'Y'})));
			}else if(Type == 'U'){
				PointerTarget.combobox('reload',
					$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetUser&ResultSetType=Array'
					+ '&Params=' + JSON.stringify(addSessionParams({ShowAllHospFlag:'Y'})));
			}else if(Type == 'D'){
				PointerTarget.combobox('loadData', [{RowId: 'DHC', Description: 'DHC'}]);
				PointerTarget.combobox('setValue', 'DHC');
			}
		}
	});
	$HUI.combobox('#PointerField', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetGroup&ResultSetType=Array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#HospField', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetHosp&ResultSetType=Array',
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var ParamValueAddBtn = {
		text: '����',
		iconCls: 'icon-add',
		handler: function(){
			var ParamRow = AppParamGrid.getSelected();
			if(isEmpty(ParamRow)){
				$UI.msg('alert', '��ѡ����Ӧ�Ĳ���!');
				return;
			}
			$HUI.dialog('#ParamValueWin', {
				width: 250,
				height: 280,
				buttons: [{
					text: '����',
					iconCls: 'icon-w-save',
					handler: function(){
						var ParamRow = AppParamGrid.getSelected();
						var Parref = ParamRow['RowId'];
						var Detail = $UI.loopBlock('#ParamValueForm');
						if(isEmpty(Detail)){
							$UI.msg('alert', 'û����Ҫ���������!');
							return;
						}
						$.cm({
							ClassName: 'web.DHCSTMHUI.StkSysAppParam',
							MethodName: 'SaveProp',
							Parref: Parref,
							Detail: JSON.stringify(Detail)
						},function(jsonData){
							if(jsonData.success === 0){
								$UI.msg('success', jsonData.msg);
								AppParamValueGrid.reload();
								$HUI.dialog('#ParamValueWin').close();
							}else{
								$UI.msg('error', jsonData.msg);
							}
						});
					}
				}],
				onOpen: function(){
					$UI.clearBlock('#ParamValueForm');
				}
			}).open();
		}
	}
	var ParamValueUpdateBtn = {
		text: '�޸�',
		iconCls: 'icon-edit',
		handler: function(){
			var RowData = AppParamValueGrid.getSelected();
			if(isEmpty(RowData)){
				$UI.msg('alert', '��ѡ����Ҫ�޸ĵ���!');
				return;
			}
			var RowId = RowData['RowId'];
			$HUI.dialog('#ParamValueWin', {
				width: 320,
				height: 280,
				buttons: [{
					text: '����',
					iconCls: 'icon-save',
					handler: function(){
						var ParamRow = AppParamGrid.getSelected();
						var Parref = ParamRow['RowId'];
						var Detail = $UI.loopBlock('#ParamValueForm');
						if(isEmpty(Detail)){
							$UI.msg('alert', 'û����Ҫ���������!');
							return;
						}
						$.cm({
							ClassName: 'web.DHCSTMHUI.StkSysAppParam',
							MethodName: 'SaveProp',
							Parref: Parref,
							Detail: JSON.stringify(Detail)
						},function(jsonData){
							if(jsonData.success === 0){
								$UI.msg('success', jsonData.msg);
								AppParamValueGrid.reload();
								$HUI.dialog('#ParamValueWin').close();
							}else{
								$UI.msg('error', jsonData.msg);
							}
						});
					}
				}],
				onOpen: function(){
					$UI.clearBlock('#ParamValueForm');
					$.cm({
						ClassName: 'web.DHCSTMHUI.StkSysAppParam',
						MethodName: 'GetPropDetail',
						RowId: RowId
					},function(jsonData){
						$UI.fillBlock('#ParamValueForm', jsonData);
					});
				}
			}).open();
		}
	}
	var ParamValueDelBtn = {
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function(){
			AppParamValueGrid.commonDeleteRow();
		}
	}
	
	var AppParamValueGrid = $UI.datagrid('#AppParamValueGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.StkSysAppParam',
			MethodName: 'SelectProp',
			rows: 999
		},
		remoteSort: false,
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.StkSysAppParam',
			MethodName: 'DeleteProp'
		},
		singleSelect: true,
		pagination: false,
		toolbar: [ParamValueAddBtn, ParamValueUpdateBtn, ParamValueDelBtn],
		showAddDelItems: false,
		beforeAddFn: function(){
			var ParamRow = AppParamGrid.getSelected();
			if(isEmpty(ParamRow)){
				$UI.msg('alert', '��ѡ����Ӧ�Ĳ���!');
				return false;
			}
		},
		fitColumns: true,
		columns: [[
			{title: 'RowId', field: 'RowId', width: 80, hidden: true},
			{title: '����', field: 'TypeName', width: 60},
			{title: '����ֵ', field: 'PointerName', width: 120},
			{title: '����ֵ', field: 'Value', width: 60},
			{title: 'ҽԺ', field: 'HospName', width: 120}
		]]
	});
}
$(init);