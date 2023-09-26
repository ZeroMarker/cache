
var init = function() {
	var gInci="";
	var Clear=function(){
		$UI.clearBlock('#MainConditions');
		$UI.clear(BagMainGrid);
		$UI.clear(InciMainGrid);
	}
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}
	});
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			Query();
		}
	});
	function Query(){
		$UI.clear(InciMainGrid);
		$UI.clear(BagMainGrid);
		var Params = $UI.loopBlock('#MainConditions');
		BagMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
			QueryName: 'GetPack',
			Params: JSON.stringify(Params)
		});
	}
	
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			if (isEmpty(gInci)) {
				$UI.msg('alert', '请选择包!');
				return false;
			}
			var RowsData = InciMainGrid.getChangesData();
			if (RowsData === false){	//未完成编辑或明细为空
				return;
			}
			if (isEmpty(RowsData)){	//明细不变
				$UI.msg("alert", "没有需要保存的明细!");
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
				MethodName: 'Insert',
				Pack: gInci,
				ListData: JSON.stringify(RowsData)
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					var Params = $UI.loopBlock('#MainConditions');
					BagMainGrid.load({
						ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
						QueryName: 'GetPack',
						Params: JSON.stringify(Params)
					});
					InciMainGrid.load({
						ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
						QueryName: 'GetDetail',
						Pack: gInci
					});
				}else{
					$UI.msg('alert', jsonData.msg);
				}
			});
		}
	});
	
	
	var addOneRow = {
		text: '新增包',
		iconCls: 'icon-add',
		handler: function () {
			var DefaData={};
			gInci="";
			BagMainGrid.commonAddRow(DefaData);
		}
	};
	var cancelOneRow = {
		text: '删除包',
		iconCls: 'icon-cancel',
		handler: function () {
			var RowsData=BagMainGrid.getSelections();
			if (RowsData.length <= 0) {
				$UI.msg('alert', '请选择要删除的包!');
				return false;
			}
			var rowid=RowsData[0].PackRowId;
			if((rowid=="undefined")||(rowid=="")||(rowid==null)){
				//alert(1);
				BagMainGrid.commonDeleteRow();
				return ;
				
			}else{
				var RowsData=BagMainGrid.getSelectedData();
			    $.cm({
				     ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
				     MethodName: 'DeletePack',
				     ListData: JSON.stringify(RowsData)
			     },function(jsonData){
				     if(jsonData.success === 0){
					    Query();
					    $UI.msg('success', jsonData.msg);
				      }else{
					    $UI.msg('error', jsonData.msg);
				    }
			     });
			}
		}
	};

	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#FVendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	
	var HandlerParams=function(){
		var Scg=""
		var LocDr=session['LOGON.CTLOCID'];
		var ReqLoc=""
		var HV = 'Y';
		var QtyFlag ='0';
		var PackChargeFlag="Y";
		var Obj={StkGrpRowId:Scg,StkGrpType:"M",Locdr:LocDr,NotUseFlag:"N",QtyFlag:QtyFlag,HV:HV,RequestNoStock:"Y",PackChargeFlag:PackChargeFlag};
		
		return Obj;
	}
	var SelectRow=function(row){
		var Rows =BagMainGrid.getRows();
		var SelectRow = Rows[BagMainGrid.editIndex];
		SelectRow.PackRowId=row.InciDr;
		SelectRow.PackDesc=row.InciDesc;
		gInci=row.InciDr;
		setTimeout(function () {
			BagMainGrid.refreshRow();
		}, 0);
	}
	var HandlerParams2=function(){
		var Scg=""
		var LocDr=session['LOGON.CTLOCID'];
		var ReqLoc=""
		var HV = 'Y';
		var QtyFlag ='0';
		var PackChargeFlag="N";
		var Obj={StkGrpRowId:Scg,StkGrpType:"M",Locdr:LocDr,NotUseFlag:"N",QtyFlag:QtyFlag,HV:HV,RequestNoStock:"Y",PackChargeFlag:PackChargeFlag};
		return Obj;
	}
	var SelectRow2=function(row){
		var Rows =InciMainGrid.getRows();
		var SelectRow = Rows[InciMainGrid.editIndex];
		SelectRow.InciCode=row.InciCode;
		SelectRow.InciDesc=row.InciDesc;
		SelectRow.Spec=row.Spec;
		SelectRow.Inci=row.InciDr;
		setTimeout(function () {
			InciMainGrid.refreshRow();
		}, 0);
	}
	var BagMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'PackRowId',
			field: 'PackRowId',
			width: 100,
			hidden: true
		}, {
			title: '包代码',
			field: 'InciCode',
			width: 100
		}, {
			title: '包名称',
			field: 'PackDesc',
			width: 230,
			editor: InciEditor(HandlerParams,SelectRow)
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 200 
		}
	]];
	
	var BagMainGrid = $UI.datagrid('#BagMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
			QueryName: 'GetPack'
		},
		columns: BagMainCm,
		fitColumns: true,
		singleSelect: false,
		showBar: false,
		toolbar: [addOneRow, cancelOneRow],
		onSelect: function(index, row){
			gInci = row.PackRowId;
			$UI.clear(InciMainGrid);
			if(!isEmpty(gInci)){
				InciMainGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
					QueryName: 'GetDetail',
					Pack: gInci
				});
			}
		}
	});
	
	var addInciRow = {
		text: '新增关联',
		iconCls: 'icon-add',
		handler: function(){
			var DefaData = {};
			InciMainGrid.commonAddRow(DefaData);
		}
	};
	var cancelInciRow = {
		text: '解除关联',
		iconCls: 'icon-no',
		handler: function(){
			
			var RowsData=InciMainGrid.getSelections();
			if (RowsData.length <= 0) {
				$UI.msg('alert', '请选择要解除关联的包!');
				return false;
			}
			
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
				MethodName: 'DeleteLink',
				ListData: JSON.stringify(RowsData)
			},function(jsonData){
				if(jsonData.success === 0){
					$UI.msg('success', jsonData.msg);
					InciMainGrid.load({
						ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
						QueryName: 'GetDetail',
						Pack: gInci
					});
				}else{
					$UI.msg('alert', jsonData.msg);
				}
			});
		}
	};

	var InciMainCm = [[
		{
			field: 'ck',
			checkbox: true
		},{
			title: 'PCL',
			field: 'PCL',
			hidden: true,
			width: 80
		},{
			title: 'Inci',
			field: 'Inci',
			width: 80,
			hidden: true
		},{
			title: '物资代码',
			field: 'InciCode',
			width: 150
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200,
			editor: InciEditor(HandlerParams2,SelectRow2)
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}
	]];
	
	var InciMainGrid = $UI.datagrid('#InciMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPackChargeLink',
			QueryName: 'GetDetail'
		},
		columns: InciMainCm,
		fitColumns: true,
		singleSelect: false,
		showBar: false,
		toolbar: [addInciRow, cancelInciRow]
	});
	Query();
}
$(init);
