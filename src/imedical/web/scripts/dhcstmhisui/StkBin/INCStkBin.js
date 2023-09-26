///货位维护
///20180726
var init = function () {
	var HospId="";
	function InitHosp() {
		var hospComp=InitHospCombo("CT_Loc",gSessionStr);
		if (typeof hospComp ==='object'){
			HospId=$HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid("options").onSelect=function(index,record){
				HospId=record.HOSPRowId;
				$UI.clearBlock('#MainConditions');
				Query();
			};
		}else{
			HospId=gHospId;
		}
	}
	var StkBinLocBox = $HUI.combobox('#StkBinLoc', {
			//url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + StkBinLocParams,
			valueField: 'RowId',
			textField: 'Description',
			onChange: function (newValue, oldValue) {
				$UI.clear(StkBinGrid);
			},
			onShowPanel:function(){
				StkBinLocBox.clear();
				var StkBinLocParams = JSON.stringify(addSessionParams({
					Type: "Login",
					BDPHospital:HospId
				}));
				var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + StkBinLocParams;
				StkBinLocBox.reload(url);
			}
		});
	function Query(){
		var Params = JSON.stringify($UI.loopBlock('StkBinTB'));
		StkBinGrid.load({
			ClassName: 'web.DHCSTMHUI.INCStkBin',
			QueryName: 'LocINCStkBin',
			Params: Params
		});
	}
	$('#SearchBT').on('click', function () {
		Query();
	});
	$('#AddBT').on('click', function () {
		StkBinGrid.commonAddRow();
	});
	$('#SaveBT').on('click', function () {
		var StkBinloc = $('#StkBinLoc').combobox('getValue');
		var Rows = StkBinGrid.getChangesData();
		if (Rows === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INCStkBin',
			MethodName: 'Save',
			Params: JSON.stringify(Rows),
			Loc: StkBinloc
		}, function (jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				StkBinGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	});
	$UI.linkbutton('#DelBT', {
		onClick: function () {
			var StkBRowId = $('#RowId').val()
				if (isEmpty(StkBRowId)) {
					return;
				}
			function del() {
				$.cm({
					ClassName: 'web.DHCSTMHUI.INCStkBin',
					MethodName: 'Delete',
					StkBRowId: StkBRowId
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						StkBinGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
			$UI.confirm('确定要删除吗?', '', '', del)
		}
	});
	function clear(){
		$UI.clearBlock('StkBinTB');
		$UI.clear(StkBinGrid);
		InitHosp();
		Dafult();
	}
	$('#ClearBT').on('click', function () {
		clear();
	});

	var StkBinCm = [[{
				title: 'RowId',
				field: 'RowId',
				hidden: true
			}, {
				title: '代码',
				field: 'Code',
				align: 'left',
				width: 200,
				sortable: true,
				hidden: true
			}, {
				title: '描述',
				field: 'Description',
				align: 'left',
				width: 300,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				},
				sortable: true
			}
		]];

	var StkBinGrid = $UI.datagrid('#StkBinGrid', {
			url: $URL,
			queryParams: {
				ClassName: 'web.DHCSTMHUI.INCStkBin',
				QueryName: 'LocINCStkBin'
			},
			columns: StkBinCm,
			toolbar: '#StkBinTB',
			onClickCell: function (index, field, value) {
				StkBinGrid.commonClickCell(index, field);
			}
		});
	/*--设置初始值--*/
	var Dafult = function () {
		var DafultValue = {
			RowId: "",
			StkBinLoc: gLocObj
		}
		$UI.fillBlock('#MainConditions', DafultValue)
	}
	clear();
}
$(init);
