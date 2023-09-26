var init = function (){
	var HospId="";
	function InitHosp() {
		var hospComp=InitHospCombo("CT_Loc",gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				$UI.clearBlock('LocMarTB');
				QueryLocM();
			};
		}else{
			HospId=gHospId;
		}
	}
	function QueryLocM(){
		var SessionParmas=addSessionParams({Hospital:HospId});
		var Paramsobj=$UI.loopBlock('LocMarTB');
		var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
		LocMarGrid.load({
			ClassName: 'web.DHCSTMHUI.CTLOC',
			QueryName: 'QueryLocM',
			StrFilter: Params
		});
	}
	$('#SearchBT').on('click', function(){
		QueryLocM();
	});
	function clear(){
		$UI.clearBlock('LocMarTB');
		$UI.clear(LocMarGrid);
		$UI.clear(LocMarGrpGrid);
		InitHosp();
	}
	$('#ClearBT').on('click', function(){
		clear();
	});
	var LocMarGridCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '����',
			field: 'Code',
			width:300
		}, {
			title: '����',
			field: 'Description',
			width:275
		}
	]];
	var SessionParmas=addSessionParams({Hospital:HospId});
	var Paramsobj=$UI.loopBlock('LocMarTB');
	var Params1=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
	var LocMarGrid = $UI.datagrid('#LocMarList', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CTLOC',
			QueryName: 'QueryLocM',
			StrFilter:Params1
		},
		columns: LocMarGridCm,
		//toolbar: '#LocMarTB',
		sortName: 'RowId',  
		sortOrder: 'Desc', 
		onSelect:function(index, row){
			var LocId = row.RowId;
			$UI.setUrl(LocMarGrpGrid)
			LocMarGrpGrid.load({
				ClassName: 'web.DHCSTMHUI.LocManGrp',
				QueryName: 'QueryLocMar',
				LocId: LocId
			});
		}
	})
	var LocMarGrpBar = [{
			text: '����',
			class:'hisui-linkbutton',
			iconCls: 'icon-add',
			handler: function(){
				var Selected = LocMarGrid.getSelected();
				if(isEmpty(Selected)){
					$UI.msg('alert','��ѡ��Ҫά���Ŀ���!')
					return;
				}
				var PRowId = Selected.RowId;
				if(isEmpty(PRowId)){
					$UI.msg('alert','��ѡ��Ҫά���Ŀ���!');
					return;
				}
				LocMarGrpGrid.commonAddRow();
			}
		}, {
			text: '����',
			iconCls: 'icon-save',
			handler: function () {
				var Rows = LocMarGrpGrid.getChangesData();
				if (Rows === false){	//δ��ɱ༭����ϸΪ��
					return;
				}
				if (isEmpty(Rows)){	//��ϸ����
					$UI.msg("alert", "û����Ҫ�������ϸ!");
					return;
				}
				var Selected = LocMarGrid.getSelected();
				var PRowId = Selected.RowId;
				$.cm({
					ClassName: 'web.DHCSTMHUI.LocManGrp',
					MethodName: 'Save',
					LocId: PRowId,
					Params: JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success', jsonData.msg);
						LocMarGrpGrid.reload()
					} else {
				$UI.msg('error', jsonData.msg);
			}
				});
			}
		}, {
			text: 'ɾ��',
			iconCls: 'icon-cancel',
			handler: function () {
				var Rows = LocMarGrpGrid.getSelections();
				if (Rows.length <= 0) {
					$UI.msg('alert', '��ѡ��Ҫɾ������Ϣ!');
					return;
				}
				$.cm({
					ClassName:'web.DHCSTMHUI.LocManGrp',
					MethodName:'Delete',
					Params:JSON.stringify(Rows)
				},function(jsonData){
					if(jsonData.success==0){
						$UI.msg('success', jsonData.msg);
						LocMarGrpGrid.reload()
					} else {
				$UI.msg('error', jsonData.msg);
			}
				});
			}
		}
	];
	var LocMarGrpGridCm = [[{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			hidden: true
		},{
			title: '����',
			field: 'Code', 
			width:200,
			editor:{type:'validatebox',options:{required:true}}
		},{
			title: '����',
			field: 'Desc',
			width:350,
			editor:{type:'validatebox',options:{required:true}}
		}
	]]; 
	var LocMarGrpGrid = $UI.datagrid('#LocMarGrpGridList', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.LocManGrp',
				MethodName: 'QueryLocMar'
			},
			columns: LocMarGrpGridCm,
			toolbar: LocMarGrpBar,
			singleSelect: false,
			onClickCell: function(index, field ,value){
				var Row=LocMarGrpGrid.getRows()[index]
				LocMarGrpGrid.commonClickCell(index,field)
			}
	});	
	clear();
	}
	$(init);