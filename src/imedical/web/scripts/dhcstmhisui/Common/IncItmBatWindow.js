// ����:		���ε���
// ��д��:	wangjiabin
// ��д����:	2018-05-19

/**
 Input:���ʱ���¼��ֵ
 StkGrpRowId������id
 StkGrpType���������ͣ�G������
 Locdr:����id
 NotUseFlag�������ñ�־
 QtyFlag���Ƿ����0�����Ŀ
 HospID��ҽԺid
 ReqLoc:�������id(�������idΪ��ʱ��������ҿ����ʾΪ��)
 Fn���ص�����
 IntrType : ҵ������(��Ӧ̨��type) 2014-08-31���
 StkCat : ������id 2016-11-29���
 QtyFlagBat:�Ƿ����0�������
 HV:��ֵ��־(Y:����ֵ,N:����ֵ,'':����)
*/
var gSelColor = "#51AD9D";
var IncItmBatWindow = function (Input, Params, Fn) {
	
	var BarCodeInfo=$.cm({
			ClassName: 'web.DHCSTMHUI.DHCUDI',
			MethodName: 'UDIInfo',
			Code:Input
		},false);
	///"OrgBarCode^InciBarCode^Inci^Incib^BatchNo^ExpDate^ProduceDate^SerialNo"	
	$HUI.dialog('#IncItmBatWindow').open();
	var gRowArr = [];
	var ProLocId = Params['Locdr'], ReqLocId = Params['ToLoc'];
	var IntrType = Params['IntrType'] || '';
	var QtyFlagBat = Params['QtyFlagBat'] || '0';
	var BatchNo=BarCodeInfo.BatchNo
	var ExpDate=BarCodeInfo.ExpDate
	var gInciRowIndex, gInciRow;

	$UI.linkbutton('#IncItmBatSelBT', {
		onClick: function () {
			ReturnInclbData();
		}
	});

	var IncItmBatMasterCm = [[
		{ checkbox: true },
		{ title: 'Incil', field: 'Incil', width: 80, hidden: true, editor: 'text' },
		{ title: '����', field: 'InciCode', width: 140,
			formatter:function(value,rec){
				var btn = '<a style="color:black" class="editcls" href="javascript:void(0)">'+value+'</a>';
				return btn;
			}
		},
		{ title: '����', field: 'InciDesc', width: 200 },
		{ title: '���', field: 'Spec', width: 100 },
		{ title: '�ͺ�', field: 'Model', width: 100 },
		{ title: '����', field: 'ManfName', width: 160 },
		{ title: '��ⵥλ', field: 'PUomDesc', width: 70 },
		{ title: '����(��ⵥλ)', field: 'PRp', width: 100, align: 'right' },
		{ title: '�ۼ�(��ⵥλ)', field: 'PSp', width: 100, align: 'right' },
		{ title: '����(��ⵥλ)', field: 'PUomQty', width: 100, align: 'right' },
		{ title: '������λ', field: 'BUomDesc', width: 80 },
		{ title: '����(������λ)', field: 'BRp', width: 100, align: 'right' },
		{ title: '�ۼ�(������λ)', field: 'BSp', width: 100, align: 'right' },
		{ title: '����(������λ)', field: 'BUomQty', width: 100, align: 'right' },
		{ title: '�Ƽ۵�λ', field: 'BillUomDesc', width: 80 },
		{ title: '����(�Ƽ۵�λ)', field: 'BillRp', width: 100, align: 'right' },
		{ title: '�ۼ�(�Ƽ۵�λ)', field: 'BillSp', width: 100, align: 'right' },
		{ title: '����(�Ƽ۵�λ)', field: 'BillUomQty', width: 100, align: 'right' },
		{ title: '������', field: 'NotUseFlag', width: 50, align: 'center', formatter: BoolFormatter }
	]];
	var StrParam;
	if(BarCodeInfo.Inci){
		var _options=jQuery.extend(true,{},{BarCode:BarCodeInfo.InciBarCode},addSessionParams(Params));
		StrParam=JSON.stringify(_options)
		Input=""
	}else{
		StrParam=JSON.stringify(addSessionParams(Params))
	}
	var IncItmBatMasterGrid = $UI.datagrid('#IncItmBatMasterGrid', {
		lazy: false,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetPhaOrderItemInfo',
			StrParam: StrParam,
			q: Input
		},
		columns: IncItmBatMasterCm,
		onSelect: function (index, row) {
			IncItmBatDetailGrid.endEditing();
			gInciRowIndex = index, gInciRow = row;
			var InciDr = row['InciDr'];
			var ParamsObj = { InciDr: InciDr, ProLocId: ProLocId, ReqLocId: ReqLocId, QtyFlag: QtyFlagBat,BatchNo:BatchNo,ExpDate:ExpDate };
			$UI.setUrl(IncItmBatDetailGrid);
			IncItmBatDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
				MethodName: 'GetDrugBatInfo',
				Params: JSON.stringify(ParamsObj)
			});
		},
		onLoadSuccess: function (data) {
			if (data.rows.length > 0) {
				IncItmBatMasterGrid.selectRow(0);
				$(IncItmBatMasterGrid.getPanel().find('div.datagrid-body .editcls')[0]).focus();
			}
			$.each(data.rows, function (index, row) {
				ChangeColor(IncItmBatMasterGrid, index, 'Incil');
			});
		},
		navigateHandler: {
			up: function (targetIndex) { },
			down: function (targetIndex) { },
			enter: function (selectedData) {
				if(IncItmBatDetailGrid.getRows().length > 0) {
					IncItmBatDetailGrid.selectRow(0);
					IncItmBatDetailGrid.beginEdit(0);
					var ed = IncItmBatDetailGrid.getEditor({index:0,field:"OperQty"});
					$(ed.target).focus();
				}
			}
		}
	});

	var IncItmBatDetailCm = [[
		{ title: '����RowID', field: 'Inclb', width: 100, hidden: true, editor: 'text' },
		{ title: '����~Ч��', field: 'BatExp', width: 200, align: 'left' },
		{ title: '������', field: 'SpecDesc', width: 100, align: 'left' },
		{ title: '���ο��', field: 'InclbQty', width: 90, align: 'right' },
		{ title: '���ο��ÿ��', field: 'AvaQty', width: 90, align: 'right' },
		{ title: 'ҵ������', field: 'OperQty', width: 90, align: 'right', editor: 'numberbox' },
		{ title: '��Ӧ��', field: 'VendorName', width: 120 },
		{ title: '����', field: 'Manf', width: 180 },
		{ title: '��λ', field: 'PurUomDesc', width: 80 },
		{ title: '�����ۼ�', field: 'BatSp', width: 60, align: 'right' },
		{ title: '��������', field: 'ReqQty', width: 80, align: 'right' },
		{ title: '������λRowId', field: 'BUomId', width: 80, hidden: true },
		{ title: '������λ', field: 'BUomDesc', width: 80 },
		{ title: '����', field: 'Rp', width: 60, align: 'right' },
		//{title : '��λ��', field : 'StkBin', width : 100},
		{ title: '��Ӧ�����', field: 'SupplyStockQty', width: 100, align: 'right' },
		{ title: '��Ӧ�����ÿ��', field: 'SupplyAvaStockQty', width: 100, align: 'right' },
		{ title: '���󷽿��', field: 'RequrstStockQty', width: 100, align: 'right' },
		//{title : '�������', field : 'IngrDate', width : 80, align : 'center'},
		{ title: 'ת����', field: 'ConFac', width: 60, align: 'center' },
		//{title : '����ռ�ÿ��', field : 'DirtyQty', width : 90, align : 'right'},
		{ title: '��ֵ��־', field: 'HVFlag', width: 60, align: 'center' },
		{ title: '������־', field: 'RecallFlag', width: 60, align: 'center' },
		{ title: '�������', field: 'SterilizedBat', width: 100 }
	]];

	var IncItmBatDetailGrid = $UI.datagrid('#IncItmBatDetailGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Util.DrugUtil',
			MethodName: 'GetDrugBatInfo'
		},
		idField: 'Inclb',
		columns: IncItmBatDetailCm,
		onClickCell: function (index, field, value) {
			IncItmBatDetailGrid.commonClickCell(index, field);
		},
		onDblClickRow: function (index, row) {
			ReturnInclbData();
		},
		onBeginEdit: function (index, row) {
			if(row['RecallFlag']=="Y"){
				$UI.msg('alert', '�������� ������ʹ��!');
				var target = $('#IncItmBatDetailGrid').datagrid('getEditor', { index: index, field: 'OperQty' }).target;
				 $(target).attr('disabled', true);
			}else {
				$(this).datagrid('beginEdit', index);
				IncItmBatDetailGrid.editIndex=index;
				var ed = $(this).datagrid('getEditors', index);
				for (var i = 0; i < ed.length; i++) {
					var e = ed[i];
					if (e.field == 'OperQty') {
						$(e.target).bind("blur", function (event) {
							var OperQty =$(this).val();
							var AvaQty = Number(row['AvaQty']);
							if (IntrType == 'A') {
							//��������¼�븺ֵ, ��ӿ���
							if (accAdd(OperQty, AvaQty) < 0) {
								$UI.msg('alert', '��������Ϊ����ʱ���ܳ������ο��ÿ��!');
								return;
								}
							}else if((IntrType != 'G')&&(OperQty>AvaQty))
								{
									$UI.msg('alert', '�������ɴ������ο�������');
									return;
								}
								else if((IntrType != 'A')&&(OperQty<=0)){
									$UI.msg('alert', '��������С�ڻ������');
									return;
								}
							})
						$(e.target).bind("keydown", function (event) {
							if (event.keyCode == 13) {
								var OperQty =$(this).val();
								var AvaQty = Number(row['AvaQty']);
								if(IntrType != 'G'&&OperQty>AvaQty){
									$UI.msg('alert', '�������ɴ������ο�������');
									return;
								}else if((IntrType != 'A')&&(OperQty<=0)){
									$UI.msg('alert', '��������С�ڻ������');
									return;
								}else if(IntrType == 'A'){
									if (accAdd(OperQty, AvaQty) < 0){
											$UI.msg('alert', '��������Ϊ����ʱ���ܳ������ο��ÿ��!');
											return;
										}
								}
								ReturnInclbData();
							}
						});
					}
				}
			}
		},
		onAfterEdit: function (index, row, changes) {
			if (changes.hasOwnProperty('OperQty')) {
				var OperQty = Number(changes['OperQty']);
				var AvaQty = Number(row['AvaQty']);
				if (IntrType == 'A') {
					//��������¼�븺ֵ, ��ӿ���
					if (accAdd(OperQty, AvaQty) < 0) {
						$UI.msg('alert', '��������Ϊ����ʱ���ܳ������ο��ÿ��!');
						$(this).datagrid('updateRow', {
							index: index,
							row: {
								OperQty: ''
							}
						});
						return;
					}
				} else if (IntrType != 'G' && OperQty > AvaQty) {
					//������ⲻ��������
					$UI.msg('alert', '�������ɴ������ο�������');
					$(this).datagrid('updateRow', {
						index: index,
						row: {
							OperQty: ''
						}
					});
					return;
				}
				var Inclb = row['Inclb'];
				var InclbExistFlag = false;
				$.each(gRowArr, function (Index, Item) {
					if (Item['Inclb'] == Inclb) {
						InclbExistFlag = true;
						if (OperQty != 0) {
							Item['OperQty'] = OperQty;
						} else {
							gRowArr.splice(Index, 1);
						}
						return false;
					}
				});
				if (!InclbExistFlag && OperQty != 0) {
					$.extend(row, gInciRow);
					gRowArr.push(row);
				}
				ChangeColor(IncItmBatMasterGrid, gInciRowIndex, 'Incil');
			}
		},
		onLoadSuccess: function (data) {
			$.each(data.rows, function (Index, Row) {
				$.each(gRowArr, function (ArrIndex, ArrRow) {
					if (ArrRow['Inclb'] == Row['Inclb']) {
						IncItmBatDetailGrid.updateRow({
							index: Index,
							row: {
								OperQty: ArrRow['OperQty']
							}
						});
					}
				});
			});
		}
	});

	function ChangeColor(Grid, RowIndex, Field) {
		var Incil = Grid.getRows()[RowIndex][Field];
		var IncilExist = false;
		var ColorField = 'InciDesc';
		$.each(gRowArr, function (ArrIndex, ArrRow) {
			var RowIncil = ArrRow[Field];
			if (RowIncil == Incil) {
				var OperateCss = '+CellBackGroundColor';
				SetGridCss(Grid, RowIndex, Field, ColorField, OperateCss);
				IncilExist = true;
				return false;
			}
		});
		if (!IncilExist) {
			var OperateCss = '-CellBackGroundColor';
			SetGridCss(Grid, RowIndex, Field, ColorField, OperateCss);
		}
	}

	function ReturnInclbData() {
		IncItmBatDetailGrid.endEditing();
		if (gRowArr.length == 0) {
			$UI.msg('alert', '��ѡ�����Σ�����ҵ��������');
		} else {
			Fn(gRowArr);
			$HUI.dialog('#IncItmBatWindow').close();
		}
	}
}
