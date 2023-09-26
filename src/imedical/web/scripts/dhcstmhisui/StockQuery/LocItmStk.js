/*����ѯ*/
var init = function() {
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			QueryStockQty();
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			StockQtyClear();
		}
	});
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			StockQtyPrint();
		}
	});
	var PhaLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PhaLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var PhManufacturerParams=JSON.stringify(addSessionParams({StkType:"M"}));
	var PhManufacturerBox = $HUI.combobox('#PhManufacturer', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='+PhManufacturerParams,
		valueField: 'RowId',
		textField: 'Description'
	});	
	$('#StkGrpId').stkscgcombotree({
		onSelect:function(node){
			$.cm({
				ClassName:'web.DHCSTMHUI.Common.Dicts',
				QueryName:'GetStkCat',
				ResultSetType:'array',
				StkGrpId:node.id
			},function(data){
				StkCatBox.clear();
				StkCatBox.loadData(data);
				})
			}
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function(){
	var StkGrpId = $('#StkGrpId').combotree('getValue');
	var PhaLoc = $('#PhaLoc').combo('getValue');
	var Obj = {StkGrpRowId:StkGrpId, StkGrpType:'M', Locdr:PhaLoc};
	return Obj;
	}
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var InsuTypeParams=JSON.stringify(addSessionParams());
	var InsuTypeBox = $HUI.combobox('#InsuType', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInsuCat&ResultSetType=array&Params='+InsuTypeParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var LocManGrpBox = $HUI.combobox('#LocManGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocManGrp&ResultSetType=array&LocId='+gLocId,
			valueField: 'RowId',
			textField: 'Description'
	});
	var ARCItemCatBox= $HUI.combobox('#ARCItemCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdSubCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var HvFlagBox = $HUI.combobox('#HvFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'Y','Description':'��ֵ'},{'RowId':'N','Description':'�Ǹ�ֵ'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ChargeFlagBox = $HUI.combobox('#ChargeFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'Y','Description':'�շ�'},{'RowId':'N','Description':'���շ�'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var UseFlagBox = $HUI.combobox('#UseFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'Y','Description':'����'},{'RowId':'N','Description':'������'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ManageDrugFlagBox = $HUI.combobox('#ManageDrugFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'1','Description':'�ص��ע'},{'RowId':'0','Description':'���ص��ע'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var INFOImportFlagBox = $HUI.combobox('#INFOImportFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'����','Description':'����'},{'RowId':'����','Description':'����'},{'RowId':'����','Description':'����'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var StockTypeBox = $HUI.combobox('#StockType', {
		data:[{'RowId':0,'Description':'ȫ��'},{'RowId':1,'Description':'���Ϊ��'},{'RowId':2,'Description':'���Ϊ��'},{'RowId':3,'Description':'���Ϊ��'},{'RowId':4,'Description':'������'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var SupervisionBox = $HUI.combobox('#Supervision', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'I','Description':'I'},{'RowId':'II','Description':'II'},{'RowId':'III','Description':'III'},{'RowId':'IV','Description':'IV'},{'RowId':'V','Description':'V'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var StockQtyCm = [[{
					title : "INCILRowID",
					field : 'Incil',
					width : 20,
					hidden : true
				}, {
					title: '���ʴ���',
					field: 'InciCode',
					width: 100
				}, {
					title: "��������",
					field: 'InciDesc',
					width: 200
				}, {
					title: "��λ",
					field: 'StkBin',
					width: 90
				}, {
					title: '���(��װ��λ)',
					field: 'PurStockQty',
					width: 120,
					hidden: true,
					align: 'right'
				}, {
					title: "��װ��λ",
					field: 'PurUomDesc',
					width: 80
				}, {
					title: "���(������λ)",
					field: 'StockQty',
					width: 120,
					align: 'right',
					align: 'right'
				}, {
					title: "������λ",
					field: 'BUomDesc',
					width: 80
				}, {
					title: "���(��λ)",
					field: 'StkQtyUom',
					width: 100,
					align: 'right'
				}, {
					title: "ռ�ÿ��",
					field: 'DirtyQty',
					width: 100,
					align: 'right'
				}, {
					title: "��;���",
					field: 'ReservedQty',
					width: 100,
					align: 'right'
				}, {
					title: "���ÿ��",
					field: 'AvaQty',
					width: 100,
					align: 'right'
				}, {
					title: "���ۼ�",
					field: 'Sp',
					width: 80,
					align: 'right'
				}, {
					title: "���½���",
					field: 'Rp',
					width: 80,
					align: 'right'
				}, {
					title: '�ۼ۽��',
					field: 'SpAmt',
					width: 120,
					align: 'right'
				}, {
					title: '���۽��',
					field: 'RpAmt',
					width: 120,
					align: 'right'
				}, {
					title: "���",
					field: 'Spec',
					width: 100
				}, {
					title: '����',
					field: 'ManfDesc',
					width: 150
				}, {
					title: "ҽ�����",
					field: 'OfficalCode',
					width: 80
				}, {
					title: "�ص��ע��־",
					field: 'ManFlag',
					width: 120,
					formatter: BoolFormatter
				}, {
					title: "��ֵ��־",
					field: 'HVFlag',
					width: 60,
					formatter: BoolFormatter
				}, {
					title: "�б깩Ӧ��",
					field: 'VendorDesc',
					width: 160
				}, {
					title: "�ͺ�",
					field: 'Model',
					width: 100
				}, {
					title: "������⹩Ӧ��",
					field: 'LastVenDesc',
					width: 160
				}
	]];
	
	var StkQtyGrid = $UI.datagrid('#StkQtyGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmStk',
			MethodName: 'LocItmStkDetail'
		},
		idField: 'Incil',
		columns: StockQtyCm,
		showBar: true,
		onSelect:function(index, row){
			var ParamsObj=$UI.loopBlock('#Conditions')
			$UI.setUrl(BatGrid);
			BatGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmStk',
				MethodName: 'Batch',
				StrParam: JSON.stringify(ParamsObj),
				InciParam: row.Incil
			});
		},
        onRowContextMenu: function (e, index, row) { //�Ҽ�ʱ�����¼�  
              e.preventDefault(); 					 //��ֹ����������Ҽ��¼�    
              $(this).datagrid("selectRow", index);  //��������ѡ�и��� 
              var ParamsObj=$UI.loopBlock('#Conditions');
              var Date = ParamsObj.StartDate;
			  var Incil = row.Incil;
			  var IncCode=row.InciCode;		  
			  var IncDesc =row.InciDesc;
              $('#StkQtyRightMenu').menu({
	          	onClick: function(item){
		          switch (item.name) {
						case 'TransMoveInfo' :
						TransQuery(Incil,Date);
						break;
						case 'HVBarcodeInfo' :
						HVBarcodeQuery(Incil);
						break;
						case 'SynIncilData' :						
							$UI.confirm('ȷ��ͬ��"' + IncCode + ' ' + IncDesc + '"��棿','question','', function(){
								$.cm({
									ClassName: 'web.DHCSTMHUI.LocItmStk',
									MethodName: 'SynIncilStkQty',
									incil: Incil
								},function(jsonData){
									if(jsonData.success === 0){
										$UI.msg('success', jsonData.msg);
									}else{
										$UI.msg('error', jsonData.msg);
									}
								});
							});						
						break;	
						case 'ClrResQtyLocInci':ClrLocInciResQty(Incil); break;		
		          }
		        }	          	    
	          }).menu('show', { 					//�����������ʾ�˵�				  
                  left: e.pageX,
                  top: e.pageY  
              });  
              e.preventDefault();
         }
	})
	function ClrLocInciResQty(Incil){
		$.cm({
			ClassName: 'web.DHCSTMHUI.LocItmStk',
			MethodName: 'ClrLocInciResQty',
					Incil: Incil
		},function(jsonData){
			if(jsonData.success === 0){
				$UI.msg('success', jsonData.msg);
				QueryStockQty();
					} else {
				$UI.msg('error', jsonData.msg);
					}
			});
		}

	var BatchCm = [[{
					title: "Inclb",
					field: 'Inclb',
					width: 80,
					hidden: true
				}, {
					title: '����',
					field: 'BatNo',
					width: 180
				}, {
					title: "Ч��",
					field: 'ExpDate',
					width: 100
				}, {
					title: '������',
					field: 'SpecDesc',
					width: 100
				}, {
					title: "���ο��",
					field: 'QtyUom',
					width: 90,
					align: 'right'
				}, {
					title: "����ռ��",
					field: 'DirtyQty',
					width: 70,
					align: 'right'
				}, {
					title: "������;",
					field: 'ReservedQty',
					width: 70,
					align: 'right'
				}, {
					title: "���ο��ÿ��",
					field: 'AvaQty',
					width: 100,
					align: 'right'
				}, {
					title: '����(������λ)',
					field: 'BRp',
					width: 120,
					align: 'right'
				}, {
					title: "����(��װ��λ)",
					field: 'PRp',
					width: 120,
					align: 'right'
				}, {
					title: "�ۼ�(������λ)",
					field: 'BSp',
					width: 120,
					align: 'right'
				}, {
					title: "�ۼ�(��װ��λ)",
					field: 'PSp',
					width: 120,
					align: 'right'
				}, {
					title: "��Ӧ��",
					field: 'Vendor',
					width: 180
				}, {
					title: "����",
					field: 'Manf',
					width: 180
				},{
					title : "�������",
					field : 'IngrDate',
					width : 100
				}, {
					title: '˰��(������λ)',
					field: 'BTax',
					width: 120,
					align: 'right'
				}
	]];
	
	var BatGrid = $UI.datagrid('#BatGrid', {
		lazy:true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmStk',
			MethodName: 'Batch'
		},
		idField: 'Inclb',
		columns: BatchCm,
		showBar: true,
		onClickCell: function(index, filed ,value){
			BatGrid.commonClickCell(index,filed,value);
		},
        onRowContextMenu: function (e, index, row) {
              e.preventDefault();
              $(this).datagrid("selectRow", index);
              var ParamsObj=$UI.loopBlock('#Conditions');
              var Inclb=row.Inclb;
              var Date = ParamsObj.StartDate;
              $('#BatNoRightMenu').menu({  
              	  onClick: function(item){
		          	switch (item.name) {
						case 'DirtyQtyInfo' :
						DirtyQtyQuery(Inclb);
						break;
						case 'InclbHVBarcodeInfo' :
						HVBarcodeQuery(Inclb);
						break;
						case 'InclbTransMoveInfo' :
						TransQuery(Inclb,Date);
						break;	
		          }
		        }
	          }).menu('show', {   
                  left: e.pageX,//�����������ʾ�˵�  
                  top: e.pageY  
              });  
              e.preventDefault(); 
         }
	})
	function QueryStockQty(){
		var ParamsObj=$UI.loopBlock('#Conditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','���ڲ���Ϊ��!');
			return;
		}
		
		if(isEmpty(ParamsObj.StockType)){
			$UI.msg('alert','���Ͳ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.PhaLoc)){
			$UI.msg('alert','���Ҳ���Ϊ��!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		$UI.clear(StkQtyGrid);
		$UI.clear(BatGrid);
		StkQtyGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmStk',
			MethodName: 'LocItmStkDetail',
			Params:Params
		})
	}
	function StockQtyClear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(StkQtyGrid);
		$UI.clear(BatGrid);
		var Dafult={StartDate:DateFormatter(new Date()),
					PhaLoc:gLocObj,
					StockType:0
					}
		$UI.fillBlock('#Conditions',Dafult);
	
	}
	StockQtyClear();
}
function StockQtyPrint(){
		var ParamsObj=$UI.loopBlock('#Conditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','���ڲ���Ϊ��!');
			return;
		}
		
		if(isEmpty(ParamsObj.StockType)){
			$UI.msg('alert','���Ͳ���Ϊ��!');
			return;
		}
		if(isEmpty(ParamsObj.PhaLoc)){
			$UI.msg('alert','���Ҳ���Ϊ��!');
			return;
		}
		var Params=JSON.stringify(ParamsObj);
		Paramstr=encodeUrlStr(Params)
		var RaqName = 'DHCSTM_HUI_LocItmStk_Common.raq';
		var fileName = "{" + RaqName + "(Params=" + Paramstr + ")}";
		transfileName=TranslateRQStr(fileName);
		DHCCPM_RQPrint(transfileName)
	}	
$(init);
