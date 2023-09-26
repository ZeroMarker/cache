var init = function() {
	var HospId=gHospId;
	var TableName="DHC_OperateType";
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
		var Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		OptypeGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCOpType',
			QueryName: 'SelectAll',
			Params: Params
		});
	}

	var OpTypeData = [{ "RowId":"OM", "Description":"出库"},{ "RowId":"IM", "Description":"入库"}]
	var OpTypeCombox = {
		type: 'combobox',
		options: {
			data: OpTypeData,
			required: true,
			valueField: 'RowId',
			textField: 'Description'
		}
	} 
	$('#AddBT').on('click', function(){
		OptypeGrid.commonAddRow();
	});
	$('#SaveBT').on('click', function(){
		var Rows=OptypeGrid.getChangesData();
		if (Rows === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		var MainObj=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCOpType',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		},function(jsonData){
			$UI.msg('alert',jsonData.msg);
			if(jsonData.success==0){
				OptypeGrid.reload();
			}
		});
	});
	$('#DeleteBT').on('click', function(){
		var Rows=OptypeGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCOpType',
			MethodName: 'Delete',
			Params: JSON.stringify(Rows)
		},function(jsonData){
			$UI.msg('alert',jsonData.msg);
			if(jsonData.success==0){
				OptypeGrid.reload();
			}
		});
	});
	var OptypeCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '代码',
			field: 'Code',
			width:100,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '描述',
			field: 'Description',
			width:150,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '类型',
			field: 'Type',
			width:150,
			fitColumns:true,
			formatter: CommonFormatter(OpTypeCombox,'Type','TypeDesc'),
			editor:OpTypeCombox
		}
	]];
	var OptypeGrid = $UI.datagrid('#OptypeList', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCOpType',
			QueryName: 'SelectAll'
		},
		columns: OptypeCm,
		toolbar: "#OptypeTB",
		sortName: "RowId",
		sortOrder: 'Desc',
		lazy:false,
		onClickCell: function(index, filed ,value){
			var Row=OptypeGrid.getRows()[index]
			OptypeGrid.commonClickCell(index,filed)
		} 
	})
	InitHosp();
}
$(init);