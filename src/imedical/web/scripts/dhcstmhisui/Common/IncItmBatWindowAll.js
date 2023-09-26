// 名称:		批次调价调用的批次弹窗
// 编写者:	zx
// 编写日期:	2018-07-19
var IncItmBatWindowAll = function(Input, Params, Fn){
	var ProLocId = Params.Locdr, ReqLocId = Params.ToLoc;
	var Str = '<div class="hisui-dialog FindWin" data-options="fit:true">'
					+'<div data-options="region:\'north\'" style="height:220px">'
						+'<table id="IncItmBatMasterGrid"></table>'
					+'</div>'
					+'<div data-options="region:\'center\'" style="height:320px">'
						+'<table id="IncItmBatDetailGrid"></table>'
					+'</div>'
				+'</div>';	
	document.getElementById('IncItmBatWindowAll').innerHTML = Str;
	$('#IncItmBatWindowAll').layout();
	var IncItmBatMasterCm = [[
		//{checkbox: true},
		{title : 'InciDr', field : 'InciDr', width : 80, hidden : true, editor: 'text'},
		{title : '代码', field : 'InciCode', width : 140},
		{title : '名称', field : 'InciDesc', width : 200},
		{title : '规格', field : 'Spec', width : 100},
		{title : '厂商', field : 'ManfName', width : 160},
		{title : '入库单位', field : 'PUomDesc', width : 70},
		{title : '进价(入库单位)', field : 'PRp', width : 100, align : 'right'},
		{title : '售价(入库单位)', field : 'PSp', width : 100, align : 'right'},
		{title : '数量(入库单位)', field : 'PUomQty', width : 100, align : 'right'},
		{title : '基本单位', field : 'BUomDesc', width : 80},
		{title : '进价(基本单位)', field : 'BRp', width : 100, align : 'right'},
		{title : '售价(基本单位)', field : 'BSp', width : 100, align : 'right'},
		{title : '数量(基本单位)', field : 'BUomQty', width : 100, align : 'right'},
		{title : '计价单位', field : 'BillUomDesc', width : 80},
		{title : '进价(计价单位)', field : 'BillRp', width : 100, align : 'right'},
		{title : '售价(计价单位)', field : 'BillSp', width : 100, align : 'right'},
		{title : '数量(计价单位)', field : 'BillUomQty', width : 100, align : 'right'},
		{title : '不可用', field : 'NotUseFlag', width : 45, hidden : true}
	]];
	var Return=function(){
		IncItmBatDetailGrid.endEditing();
		var Rows=IncItmBatDetailGrid.getSelectedData();	
		if(Rows==""){
				$UI.msg('alert','请选择需要调价的批次信息!');
				return false;
		}
		Fn(Rows);
		Close();
	}
	var Close=function (){
		$HUI.window('#IncItmBatWindowAll').close();
	}
	var AdjReasonComData = $.cm({
		ClassName: 'web.DHCSTMHUI.Common.Dicts',
		QueryName: 'GetAdjPriceReason',
		ResultSetType: 'array'
	},false);
	var AdjReasonCombox = {
		type: 'combobox',
		options: {
			data: AdjReasonComData,
			valueField: 'RowId',
			textField: 'Description',
			required:'Y'
		}
	} 
	var IncItmBatMasterGrid = $UI.datagrid('#IncItmBatMasterGrid', {
		lazy:false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetPhaOrderItemInfo',
			StrParam: JSON.stringify(addSessionParams(Params)),
			q: Input
		},
		toolbar:[{
				text: '返回批次数据',
				iconCls: 'icon-ok',
				handler: function () {
					Return();
				}},{
				text: '关闭',
				iconCls: 'icon-cancel',
				handler: function () {
					Close();	
				}},{
				text: '填充进售价',
				iconCls: 'icon-save',
				handler: function () {
					SaveRpSp(SaveRpSps);	
				}}],
		columns: IncItmBatMasterCm,
		onSelect: function(index, row){
			var InciDr = row['InciDr'];
			var ParamsObj = {InciDr:InciDr, ProLocId:ProLocId};
			//$UI.setUrl(IncItmBatDetailGrid);
			IncItmBatDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
				MethodName: 'GetDrugBatInfoAll',
				Params: JSON.stringify(ParamsObj)
			});
		}
	});
	function SaveRpSps(Params) {
		IncItmBatDetailGrid.endEditing();
		var FillFlag = $("input[name='Fill']:checked").val();	//1:不覆盖, 2:覆盖已填
		var ResultRp = Params.Rp;
		var ResultBatSp = Params.Sp;
		var AdjReasonId = Params.AdjReason;
		var Rows = IncItmBatDetailGrid.getRows();
		var len = Rows.length;
		var FillCount = 0;
		for (var index = 0; index < len; index++) {
			var RowData = Rows[index];
			if ((FillFlag == '1') && !(isEmpty(RowData.ResultRp) && isEmpty(RowData.ResultBatSp))) {
				continue;
			}
			$('#IncItmBatDetailGrid').datagrid('endEdit', index);
			$('#IncItmBatDetailGrid').datagrid('selectRow', index);
			//$('#BarCodeGrid').datagrid('endEdit', index).datagrid('beginEdit', index);
			$('#IncItmBatDetailGrid').datagrid('editCell', { index: index, field: 'ResultRp' });
			var ed = $('#IncItmBatDetailGrid').datagrid('getEditor', { index: index, field: 'ResultRp' });
			ed.target.val(ResultRp);
			$('#IncItmBatDetailGrid').datagrid('editCell', { index: index, field: 'ResultBatSp' });
			var ed = $('#IncItmBatDetailGrid').datagrid('getEditor', { index: index, field: 'ResultBatSp' });
			ed.target.val( ResultBatSp);
			$('#IncItmBatDetailGrid').datagrid('editCell', { index: index, field: 'AdjReasonId' });
			var ed = $('#IncItmBatDetailGrid').datagrid('getEditor', { index: index, field: 'AdjReasonId' });
			ed.target.combobox('setValue', AdjReasonId);
			$('#IncItmBatDetailGrid').datagrid('endEdit', index);
			FillCount++;
		}
		if (FillCount > 0) {
			$UI.msg('alert', '已填充' + FillCount + '行, 请注意保存!');
		} else {
			$UI.msg('error', '未进行有效填充!');
		}
	}
	var IncItmBatDetailCm = [[
		{checkbox : true},
		{title : '批次RowID', field : 'Incib', width : 100, hidden : true, editor: 'text'},
		{title : 'InciDr', field : 'InciDr', width : 100, hidden : true},
		{title : '代码', field : 'InciCode', width : 100, hidden : true},
		{title : '名称', field : 'InciDesc', width : 100, hidden : true},
		{title : '批次~效期', field : 'BatExp', width : 150, align : 'left'},
		{title : '入库日期', field : 'IngrDate', width : 100, align : 'left'},
		{title : '单位RowId', field : 'PurUomId', width : 100, hidden : true},
		{title : '单位', field : 'PurUomDesc', width : 80},
		{title : '进价', field : 'Rp', width : 60, align : 'right'},
		{title : '批次售价', field : 'Sp', width : 70, align : 'right'},
		{title : '调后进价', field : 'ResultRp', width : 70, align : 'right',
		editor:{type:'numberbox',options:{required:true,min:0,precision:GetFmtNum('FmtPA')}}},
		{title : '调后售价', field : 'ResultBatSp', width : 70, align : 'right',
		editor:{type:'numberbox',options:{required:true,min:0,precision:GetFmtNum('FmtPA')}}},
		{title : '基本单位RowId', field : 'BUomId', width : 80, hidden : true},
		{title : '基本单位', field : 'BUomDesc', width : 80, hidden : true},
		{title : '调价原因', field : 'AdjReasonId', width : 100, align : 'left',
		formatter: CommonFormatter(AdjReasonCombox,'AdjReasonId','AdjReason'),
	    editor:AdjReasonCombox}
		
	]];
	var IncItmBatDetailGrid = $UI.datagrid('#IncItmBatDetailGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetDrugBatInfoAll'
		},
		idField: 'Incib',
		singleSelect:false,
		columns: IncItmBatDetailCm,
		onClickCell: function(index, field ,value){
			IncItmBatDetailGrid.commonClickCell(index, field);
		},
		onBeginEdit: function(index, row){
			$('#IncItmBatDetailGrid').datagrid('beginEdit', index);
			var ed = $('#IncItmBatDetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++){
				var e = ed[i];
				if(e.field == 'ResultRp'){
					$(e.target).bind('keydown', function(event){
						if(event.keyCode == 13){
							var Input = $(this).val();
							if (AdjSpBatchParamObj.CalSpByMarkType==1){
								var Inci = row.InciDr;
								var AspUomId = row.PurUomId;
								var Sp = tkMakeServerCall("web.DHCSTMHUI.Common.PriceCommon","GetMtSp",Inci,AspUomId,Input)
								if (Sp==0){
									$UI.msg('alert','调后售价为0，请检查该物资定价类型是否正确!');
									IncItmBatDetailGrid.checked=false;
									return false;
								}
								row.ResultBatSp = Sp;
							}
						}
					});
				}
			}
		},
		onDblClickRow: function(index, row){
			var InciRow = IncItmBatMasterGrid.getSelected();
			$.extend(row, InciRow);
			Fn(row);
			Close();
		}
	});
	
	$('#IncItmBatWindowAll').window({
		width: 800,
		height: 580,
		modal: true
	});
	$HUI.window('#IncItmBatWindowAll').open();
}
