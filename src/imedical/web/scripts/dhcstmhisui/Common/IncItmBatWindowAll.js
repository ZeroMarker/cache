// ����:		���ε��۵��õ����ε���
// ��д��:	zx
// ��д����:	2018-07-19
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
		{title : '����', field : 'InciCode', width : 140},
		{title : '����', field : 'InciDesc', width : 200},
		{title : '���', field : 'Spec', width : 100},
		{title : '����', field : 'ManfName', width : 160},
		{title : '��ⵥλ', field : 'PUomDesc', width : 70},
		{title : '����(��ⵥλ)', field : 'PRp', width : 100, align : 'right'},
		{title : '�ۼ�(��ⵥλ)', field : 'PSp', width : 100, align : 'right'},
		{title : '����(��ⵥλ)', field : 'PUomQty', width : 100, align : 'right'},
		{title : '������λ', field : 'BUomDesc', width : 80},
		{title : '����(������λ)', field : 'BRp', width : 100, align : 'right'},
		{title : '�ۼ�(������λ)', field : 'BSp', width : 100, align : 'right'},
		{title : '����(������λ)', field : 'BUomQty', width : 100, align : 'right'},
		{title : '�Ƽ۵�λ', field : 'BillUomDesc', width : 80},
		{title : '����(�Ƽ۵�λ)', field : 'BillRp', width : 100, align : 'right'},
		{title : '�ۼ�(�Ƽ۵�λ)', field : 'BillSp', width : 100, align : 'right'},
		{title : '����(�Ƽ۵�λ)', field : 'BillUomQty', width : 100, align : 'right'},
		{title : '������', field : 'NotUseFlag', width : 45, hidden : true}
	]];
	var Return=function(){
		IncItmBatDetailGrid.endEditing();
		var Rows=IncItmBatDetailGrid.getSelectedData();	
		if(Rows==""){
				$UI.msg('alert','��ѡ����Ҫ���۵�������Ϣ!');
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
				text: '������������',
				iconCls: 'icon-ok',
				handler: function () {
					Return();
				}},{
				text: '�ر�',
				iconCls: 'icon-cancel',
				handler: function () {
					Close();	
				}},{
				text: '�����ۼ�',
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
		var FillFlag = $("input[name='Fill']:checked").val();	//1:������, 2:��������
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
			$UI.msg('alert', '�����' + FillCount + '��, ��ע�Ᵽ��!');
		} else {
			$UI.msg('error', 'δ������Ч���!');
		}
	}
	var IncItmBatDetailCm = [[
		{checkbox : true},
		{title : '����RowID', field : 'Incib', width : 100, hidden : true, editor: 'text'},
		{title : 'InciDr', field : 'InciDr', width : 100, hidden : true},
		{title : '����', field : 'InciCode', width : 100, hidden : true},
		{title : '����', field : 'InciDesc', width : 100, hidden : true},
		{title : '����~Ч��', field : 'BatExp', width : 150, align : 'left'},
		{title : '�������', field : 'IngrDate', width : 100, align : 'left'},
		{title : '��λRowId', field : 'PurUomId', width : 100, hidden : true},
		{title : '��λ', field : 'PurUomDesc', width : 80},
		{title : '����', field : 'Rp', width : 60, align : 'right'},
		{title : '�����ۼ�', field : 'Sp', width : 70, align : 'right'},
		{title : '�������', field : 'ResultRp', width : 70, align : 'right',
		editor:{type:'numberbox',options:{required:true,min:0,precision:GetFmtNum('FmtPA')}}},
		{title : '�����ۼ�', field : 'ResultBatSp', width : 70, align : 'right',
		editor:{type:'numberbox',options:{required:true,min:0,precision:GetFmtNum('FmtPA')}}},
		{title : '������λRowId', field : 'BUomId', width : 80, hidden : true},
		{title : '������λ', field : 'BUomDesc', width : 80, hidden : true},
		{title : '����ԭ��', field : 'AdjReasonId', width : 100, align : 'left',
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
									$UI.msg('alert','�����ۼ�Ϊ0����������ʶ��������Ƿ���ȷ!');
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
