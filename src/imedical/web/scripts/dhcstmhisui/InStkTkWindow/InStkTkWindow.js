var init = function () {
	var HospId="";
	function InitHosp() {
		var hospComp=InitHospCombo("CT_Loc",gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				$UI.clearBlock('InStkTkWinTB');
				Query();
			};
		}else{
			HospId=gHospId;
		}
	}
	$('#SearchBT').on('click', function () {
		Query();
	});
	function Query(){
		$UI.clear(InStkTkWinGrid);
		var LocId = $('#InstktkLoc').combo('getValue');
		var Params=JSON.stringify(addSessionParams({LocId:LocId}));
		InStkTkWinGrid.load({
			ClassName: 'web.DHCSTMHUI.InStkTkWindow',
			QueryName: 'SelectAll',
			Params:Params
		});
	}
	$('#AddBT').on('click', function () {
		InStkTkWinGrid.commonAddRow();
	});
	$('#SaveBT').on('click', function () {
		var Rows = InStkTkWinGrid.getChangesData();
		if (Rows === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		var LocId = $('#InstktkLoc').combo('getValue');
		$.cm({
			ClassName: 'web.DHCSTMHUI.InStkTkWindow',
			MethodName: 'Save',
			LocId: LocId,
			Params: JSON.stringify(Rows)
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success',jsonData.msg);
				InStkTkWinGrid.reload();
			}else{
				$UI.msg('error',jsonData.msg);
			}
		});
	});
	function clear(){
		$UI.clearBlock('InStkTkWinTB');
		$UI.clear(InStkTkWinGrid);
		Default();
		InitHosp();
	}
	$('#ClearBT').on('click', function () {
		clear();
	});
	
	/*--绑定控件--*/
	
	var InstktkLocBox = $HUI.combobox('#InstktkLoc', {
			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
			valueField: 'RowId',
			textField: 'Description',
			onChange: function () {
				Query();
			},
			onShowPanel:function(){
				InstktkLocBox.clear();
				var LocParams=JSON.stringify(addSessionParams({Type:"All",BDPHospital:HospId}));
				var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams;
				InstktkLocBox.reload(url);
			}
		});

	var InStkTkWinCm = [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '代码',
			field: 'Code',
			width: 150,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			title: '描述',
			field: 'Description',
			width: 200,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}
	]];

	var InStkTkWinGrid = $UI.datagrid('#InStkTkWinList', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.InStkTkWindow',
			QueryName: 'SelectAll'
		},
		columns: InStkTkWinCm,
		toolbar: '#InStkTkWinTB',
		sortName: 'RowId',
		sortOrder: 'Desc',
		lazy:false,
		onClickCell: function (index, filed, value) {
			InStkTkWinGrid.commonClickCell(index, filed);
		}
	});
	
	/*--设置初始值--*/
	var Default=function(){
		///设置初始值 考虑使用配置
		var DefaultValue={
			InstktkLoc:gLocObj
		}
		$UI.fillBlock('#InStkTkWinTB',DefaultValue)
	}
	clear();
	Query();
}
$(init);