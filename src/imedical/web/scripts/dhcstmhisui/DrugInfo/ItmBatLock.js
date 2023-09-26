var init = function () {
	var HospId="";
	function InitHosp() {
		var hospComp=InitHospCombo("INC_Itm",gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				setStkGrpHospid(HospId);
				$UI.clearBlock('Conditions');
				$HUI.combotree('#StkGrpBox').load(HospId);
				Query();
			};
		}else{
			HospId=gHospId;
		}
		setStkGrpHospid(HospId);
	}
	$('#QueryBT').on('click', Query);
	$('#ClearBT').on('click', Clear);
	/*$('#StkGrpBox').stkscgcombotree({
		onSelect:function(node){
			var Params=JSON.stringify(addSessionParams());
			$.cm({
				ClassName:'web.DHCSTMHUI.Common.Dicts',
				QueryName:'GetStkCat',
				ResultSetType:'array',
				StkGrpId:node.id,
				Params:Params
			},function(data){
				StkCatBox.clear();
				StkCatBox.loadData(data);
				})
			}
	})*/
	var StkCatBox = $HUI.combobox('#StkCatBox', {
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function () {
				var scg=$("#StkGrpBox").combotree('getValue');
				var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
				StkCatBox.clear();
				var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + scg+'&Params='+Params;
				StkCatBox.reload(url);
			}
		});
	var HandlerParams=function(){
		var Scg=$("#StkGrpBox").combotree('getValue');
		var Obj={StkGrpRowId:Scg,StkGrpType:"M",BDPHospital:HospId};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));		
	var DrugInfoCm = [[{
				title: '�����id',
				field: 'RowId',
				align: 'left',
				width:100,
				hidden: true
			}, {
				title: '���ʴ���',
				field: 'InciCode',
				align: 'left',
				width:100,
				sortable: true
			}, {
				title: '��������',
				field: 'InciDesc',
				align: 'left',
				width:100,
				sortable: true
			}, {
				title: '���',
				field: 'Spec',
				width:100,
				align: 'left'
			}, {
				title: '�ͺ�',
				field: 'Model',
				width:100,
				align: 'left'
			}, {
				title: 'Ʒ��',
				field: 'Brand',
				width:100,
				align: 'left'
			}, {
				title: '����',
				field: 'Manf',
				width:100,
				align: 'left'
			}, {
				title: '��ⵥλ',
				field: 'PurUom',
				width:100,
				align: 'left'
			}, {
				title: '�ۼ�(��ⵥλ)',
				field: 'Sp',
				align: 'right',
				width:100,
				sortable: true
			}, {
				title: '����(��ⵥλ)',
				field: 'Rp',
				align: 'right',
				width:100,
				sortable: true
			}, {
				title: '������λ',
				field: 'BUom',
				width:100,
				align: 'left'
			}, {
				title: '�Ƽ۵�λ',
				field: 'BillUom',
				width:100,
				align: 'left'
			}, {
				title: '������',
				field: 'StkCatDesc',
				width:100,
				align: 'left'
			}, {
				title: '��������',
				field: 'InciCreateDate',
				width:100,
				align: 'left'
			}, {
				title: '��������',
				field: 'InciUpdateDate',
				width:100,
				align: 'left'
			}, {
				title: '������',
				field: 'NotUseFlag',
				width:100,
				align: 'center'
			}
		]];

	var DrugInfoGrid = $UI.datagrid('#InciGrid', {
			queryParams: {
				ClassName: "web.DHCSTMHUI.DrugInfoMaintain",
				QueryName: "GetItm"
			},
			columns: DrugInfoCm,
			showBar:true,
			singleSelect: true,
			onClickRow:function(index, row){
				IncibInfoGrid.load({
					ClassName: 'web.DHCSTMHUI.ItmBatLock',
					QueryName: 'GetBatInfo',
					Inci: row.RowId
				});
		}
		});
	function Query() {
		$UI.clear(DrugInfoGrid);
		$UI.clear(IncibInfoGrid);
		var SessionParmas=addSessionParams({BDPHospital:HospId});
		var Paramsobj=$UI.loopBlock('Conditions');
		var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
		DrugInfoGrid.load({
			ClassName: "web.DHCSTMHUI.DrugInfoMaintain",
			QueryName: "GetItm",
			Params:Params
		});
	}	
	var IncibInfoCm = [[{
				title: 'Incib',
				field: 'Incib',
				align: 'left',
				width:100,
				hidden: true
			}, {
				title: '����',
				field: 'IncibNo',
				width:100,
				align: 'left'
			}, {
				title: 'Ч��',
				field: 'IncibExp',
				width:100,
				align: 'left'
			}, {
				title: '������־',
				field: 'RecallFlag',
				width:100,
				editor:{type:'checkbox',options:{on:'Y',off:'N'}},
				align: 'center'
			}, {
				title: '��Ӧ��',
				field: 'Vendor',
				width:100,
				align: 'left'
			}, {
				title: '����',
				field: 'Vendor',
				width:100,
				align: 'left'
			}
		]];

	var IncibInfoGrid = $UI.datagrid('#IncibGrid', {
			queryParams: {
				ClassName: "web.DHCSTMHUI.ItmBatLock",
				QueryName: "GetBatInfo"
			},
			columns: IncibInfoCm,
			showBar:true,
			singleSelect: true,
			toolbar:[{
				text: '����',
				iconCls: 'icon-save',
				handler: function () {
					Save();
			}}],
			onClickCell: function(index, filed ,value){	
				IncibInfoGrid.commonClickCell(index,filed,value);
			}
		});
	function Save(){
		var Detail=IncibInfoGrid.getChangesData();
		if (Detail === false){	//δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Detail)){	//��ϸ����
			$UI.msg("alert", "û����Ҫ�������ϸ!");
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ItmBatLock',
			MethodName: 'Save',
			ListData: JSON.stringify(Detail)
		},function(jsonData){
			hideMask();
			if(jsonData.success==0){
				$UI.msg('success',jsonData.msg);
				IncibInfoGrid.commonReload();
			}else{
				$UI.msg('error',jsonData.msg);		
			}
		});
	}
	function Clear() {
		$UI.clearBlock('Conditions');
		$UI.clear(DrugInfoGrid);
		$UI.clear(IncibInfoGrid);
		InitHosp();
	}
	Clear();
}
$(init);