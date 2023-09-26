/*库存查询*/
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
		data:[{'RowId':'','Description':'全部'},{'RowId':'Y','Description':'高值'},{'RowId':'N','Description':'非高值'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ChargeFlagBox = $HUI.combobox('#ChargeFlag', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'Y','Description':'收费'},{'RowId':'N','Description':'不收费'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var UseFlagBox = $HUI.combobox('#UseFlag', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'Y','Description':'可用'},{'RowId':'N','Description':'不可用'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ManageDrugFlagBox = $HUI.combobox('#ManageDrugFlag', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'1','Description':'重点关注'},{'RowId':'0','Description':'非重点关注'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var INFOImportFlagBox = $HUI.combobox('#INFOImportFlag', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'国产','Description':'国产'},{'RowId':'进口','Description':'进口'},{'RowId':'合资','Description':'合资'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var StockTypeBox = $HUI.combobox('#StockType', {
		data:[{'RowId':0,'Description':'全部'},{'RowId':1,'Description':'库存为零'},{'RowId':2,'Description':'库存为正'},{'RowId':3,'Description':'库存为负'},{'RowId':4,'Description':'库存非零'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var SupervisionBox = $HUI.combobox('#Supervision', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'I','Description':'I'},{'RowId':'II','Description':'II'},{'RowId':'III','Description':'III'},{'RowId':'IV','Description':'IV'},{'RowId':'V','Description':'V'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var StockQtyCm = [[{
					title : "INCILRowID",
					field : 'Incil',
					width : 20,
					hidden : true
				}, {
					title: '物资代码',
					field: 'InciCode',
					width: 100
				}, {
					title: "物资名称",
					field: 'InciDesc',
					width: 200
				}, {
					title: "货位",
					field: 'StkBin',
					width: 90
				}, {
					title: '库存(包装单位)',
					field: 'PurStockQty',
					width: 120,
					hidden: true,
					align: 'right'
				}, {
					title: "包装单位",
					field: 'PurUomDesc',
					width: 80
				}, {
					title: "库存(基本单位)",
					field: 'StockQty',
					width: 120,
					align: 'right',
					align: 'right'
				}, {
					title: "基本单位",
					field: 'BUomDesc',
					width: 80
				}, {
					title: "库存(单位)",
					field: 'StkQtyUom',
					width: 100,
					align: 'right'
				}, {
					title: "占用库存",
					field: 'DirtyQty',
					width: 100,
					align: 'right'
				}, {
					title: "在途库存",
					field: 'ReservedQty',
					width: 100,
					align: 'right'
				}, {
					title: "可用库存",
					field: 'AvaQty',
					width: 100,
					align: 'right'
				}, {
					title: "零售价",
					field: 'Sp',
					width: 80,
					align: 'right'
				}, {
					title: "最新进价",
					field: 'Rp',
					width: 80,
					align: 'right'
				}, {
					title: '售价金额',
					field: 'SpAmt',
					width: 120,
					align: 'right'
				}, {
					title: '进价金额',
					field: 'RpAmt',
					width: 120,
					align: 'right'
				}, {
					title: "规格",
					field: 'Spec',
					width: 100
				}, {
					title: '厂商',
					field: 'ManfDesc',
					width: 150
				}, {
					title: "医保类别",
					field: 'OfficalCode',
					width: 80
				}, {
					title: "重点关注标志",
					field: 'ManFlag',
					width: 120,
					formatter: BoolFormatter
				}, {
					title: "高值标志",
					field: 'HVFlag',
					width: 60,
					formatter: BoolFormatter
				}, {
					title: "招标供应商",
					field: 'VendorDesc',
					width: 160
				}, {
					title: "型号",
					field: 'Model',
					width: 100
				}, {
					title: "最新入库供应商",
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
        onRowContextMenu: function (e, index, row) { //右键时触发事件  
              e.preventDefault(); 					 //阻止浏览器捕获右键事件    
              $(this).datagrid("selectRow", index);  //根据索引选中该行 
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
							$UI.confirm('确定同步"' + IncCode + ' ' + IncDesc + '"库存？','question','', function(){
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
	          }).menu('show', { 					//在鼠标点击处显示菜单				  
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
					title: '批号',
					field: 'BatNo',
					width: 180
				}, {
					title: "效期",
					field: 'ExpDate',
					width: 100
				}, {
					title: '具体规格',
					field: 'SpecDesc',
					width: 100
				}, {
					title: "批次库存",
					field: 'QtyUom',
					width: 90,
					align: 'right'
				}, {
					title: "批次占用",
					field: 'DirtyQty',
					width: 70,
					align: 'right'
				}, {
					title: "批次在途",
					field: 'ReservedQty',
					width: 70,
					align: 'right'
				}, {
					title: "批次可用库存",
					field: 'AvaQty',
					width: 100,
					align: 'right'
				}, {
					title: '进价(基本单位)',
					field: 'BRp',
					width: 120,
					align: 'right'
				}, {
					title: "进价(包装单位)",
					field: 'PRp',
					width: 120,
					align: 'right'
				}, {
					title: "售价(基本单位)",
					field: 'BSp',
					width: 120,
					align: 'right'
				}, {
					title: "售价(包装单位)",
					field: 'PSp',
					width: 120,
					align: 'right'
				}, {
					title: "供应商",
					field: 'Vendor',
					width: 180
				}, {
					title: "厂商",
					field: 'Manf',
					width: 180
				},{
					title : "入库日期",
					field : 'IngrDate',
					width : 100
				}, {
					title: '税额(基本单位)',
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
                  left: e.pageX,//在鼠标点击处显示菜单  
                  top: e.pageY  
              });  
              e.preventDefault(); 
         }
	})
	function QueryStockQty(){
		var ParamsObj=$UI.loopBlock('#Conditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','日期不能为空!');
			return;
		}
		
		if(isEmpty(ParamsObj.StockType)){
			$UI.msg('alert','类型不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.PhaLoc)){
			$UI.msg('alert','科室不能为空!');
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
			$UI.msg('alert','日期不能为空!');
			return;
		}
		
		if(isEmpty(ParamsObj.StockType)){
			$UI.msg('alert','类型不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.PhaLoc)){
			$UI.msg('alert','科室不能为空!');
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
