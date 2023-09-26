var init = function () {
	var HospId=gHospId;
	var TableName="DHC_StkLocGroup";
	function InitHosp() {
		var hospComp=InitHospCombo(TableName,gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			Query();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				Query();
			};
		}
	}
	function Query(){
		var SessionParmas=addSessionParams({BDPHospital:HospId});
		var Paramsobj=$UI.loopBlock('StkLocGrpTB');
		var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
		StkLocGrpGrid.load({
			ClassName: 'web.DHCSTMHUI.StkLocGrp',
			QueryName: 'Query',
			Params: Params
		});
	}
	
	$('#SearchBT').on('click', function(){
		Query();
	});
	$UI.linkbutton('#AddBT', {
		onClick: function(){
			StkLocGrpGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			var Rows = StkLocGrpGrid.getChangesData();
			if (Rows === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			var MainObj=JSON.stringify(addSessionParams({BDPHospital:HospId}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.StkLocGrp',
				MethodName: 'Save',
				Main: MainObj,
				Params: JSON.stringify(Rows)
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					StkLocGrpGrid.reload();
				}else{
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$('#ClearBT').on('click', function(){
		$UI.clearBlock('StkLocGrpTB');
		$UI.clear(StkLocGrpGrid);
	});
	
	var StkLocGrpCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '代码',
			field: 'Code',
			align: 'left',
			width: 200,
			editor:{type:'validatebox',options:{required:true}},
			fitColumns:true,
			sortable: true
		}, {
			title: '描述',
			field: 'Description',
			align: 'left',
			width: 300,
			editor:{type:'validatebox',options:{required:true}},
			fitColumns:true,
			sortable: true
		}, {
			title: '类型',
			field: 'Type',
			align: 'left',
			fitColumns:true,
			hidden: true
		}
	]];

	var StkLocGrpGrid = $UI.datagrid('#StkLocGrpGrid', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.StkLocGrp',
			QueryName: 'Query'
		},
		columns: StkLocGrpCm,
		toolbar: '#StkLocGrpTB',
		lazy:false,
		onClickCell: function(index, field ,value){
			StkLocGrpGrid.commonClickCell(index, field);
		}
	});
	InitHosp();
}
$(init);
