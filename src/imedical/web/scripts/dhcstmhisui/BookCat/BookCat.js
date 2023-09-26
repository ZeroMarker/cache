var init = function() {
	var HospId=gHospId;
	var TableName="DHCST_BookCat";
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
		Params=JSON.stringify(addSessionParams({BDPHospital:HospId}));
		BookCatGrid.load({
			ClassName: 'web.DHCSTMHUI.BookCat',
			QueryName: 'SelectAll',
			Params: Params
		});
	}
	$UI.linkbutton('#AddBT', {
		onClick: function(){
			BookCatGrid.commonAddRow();
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function(){
			var Rows=BookCatGrid.getChangesData();
			if (Rows === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			var MainObj=JSON.stringify(addSessionParams({BDPHospital:HospId}));
			$.cm({
				ClassName: 'web.DHCSTMHUI.BookCat',
				MethodName: 'Save',
				Main: MainObj,
				Params: JSON.stringify(Rows)
			},function(jsonData){
				$UI.msg('alert',jsonData.msg);
				if(jsonData.success==0){
					BookCatGrid.commonReload();
				}
			});
		}
	});
	$UI.linkbutton('#DeleteBT', {
		onClick: function(){
			var Rows=BookCatGrid.getSelectedData();
			if(Rows.length==0){
				$UI.msg('alert','没有需要保存的明细!')
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.BookCat',
				MethodName: 'Delete',
				Params: JSON.stringify(Rows)
			},function(jsonData){
				$UI.msg('alert',jsonData.msg);
				if(jsonData.success==0){
					BookCatGrid.commonReload();
				}
			});
		}
	});
	var BookCatCm = [[{
			title: 'RowId',
			field: 'RowId',
			width:100,
			hidden: true
		}, {
			title: '代码',
			field: 'Code',
			fitColumns:true,
			width:300,
			editor:{type:'validatebox',options:{required:true}}
		}, {
			title: '描述',
			field: 'Description',
			width:300,
			fitColumns:true,
			editor:{type:'validatebox',options:{required:true}}
		}
	]];
	
	var BookCatGrid = $UI.datagrid('#BookCatList', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.BookCat',
			QueryName: 'SelectAll'
		},
		columns: BookCatCm,
		toolbar: '#BookCatTB',
		sortName: 'RowId',
		sortOrder: 'Desc',
		lazy:false,
		onClickCell: function(index, filed ,value){
			BookCatGrid.commonClickCell(index,filed)
		}
	})
	InitHosp();
}
$(init);