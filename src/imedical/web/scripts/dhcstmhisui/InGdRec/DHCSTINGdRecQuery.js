/*入库综合查询*/
var init = function () {
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			QueryRecDetailInfo();
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			INgrClear();
		}
	});
	var RecLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var RecLocBox = $HUI.combobox('#RecLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+RecLocParams,
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
	var IngrTypeIdParams=JSON.stringify(addSessionParams({Type:"IM"}));
	var IngrTypeIdBox = $HUI.combobox('#IngrTypeId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=array&Params='+IngrTypeIdParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var CreateUserIdParams=JSON.stringify(addSessionParams({LocDr:""}));
	var CreateUserIdBox = $HUI.combobox('#CreateUserId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array&Params='+CreateUserIdParams,
			valueField: 'RowId',
			textField: 'Description'
	});	
	var INFOMTParams=JSON.stringify(addSessionParams());
	var INFOMTBox = $HUI.combobox('#INFOMT', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array&Params='+INFOMTParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var INFOPBLevelParams=JSON.stringify(addSessionParams());
	var INFOPBLevelBox = $HUI.combobox('#INFOPBLevel', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPBLevel&ResultSetType=array&Params='+INFOPBLevelParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var InsuTypeParams=JSON.stringify(addSessionParams());
	var InsuTypeBox = $HUI.combobox('#InsuType', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInsuCat&ResultSetType=array&Params='+InsuTypeParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	/*$('#StkGrpId').stkscgcombotree({
		onSelect:function(node){
			var Params=JSON.stringify(addSessionParams());
			$.cm({
				ClassName:'web.DHCSTMHUI.Common.Dicts',
				QueryName:'GetStkCat',
				ResultSetType:'array',
				StkGrpId:node.id,
				Params:Params
			},function(data){
				StkCatBox.clear();
				StkCatBox.loadData(data);
				})
			}
	})*/
	var StkCatBox = $HUI.combobox('#StkCatBox', {
			valueField: 'RowId',
			textField: 'Description',
			onShowPanel: function () {
				var scg=$("#StkGrpId").combotree('getValue');
				var Params=JSON.stringify(addSessionParams());
				StkCatBox.clear();
				var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + scg+'&Params='+Params;
				StkCatBox.reload(url);
			}
	});
	var HandlerParams = function(){
		var ScgId = $('#StkGrpId').combotree('getValue');
		var Locdr = $('#RecLoc').combo('getValue');
		var Obj = {StkGrpRowId:ScgId, StkGrpType:'M', Locdr:Locdr,BDPHospital:gHospId};
		return Obj;
	}
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#InciRowid'));
	
	
	var InGdRecDetailCm = [[{
			title : "RowId",
			field : 'RowId',
			width : 100,
			hidden : true
		}, {
			title : "入库单号",
			field : 'IngrNo',
			width : 80
		}, {
			title : "制单日期",
			field : 'IngrCreateDate',
			width : 100
		}, {
			title : '物资代码',
			field : 'InciCode',
			width : 80
		}, {
			title : '物资名称',
			field : 'InciDesc',
			width : 230
		}, {
			title : '高值条码',
			field : 'HVBarCode',
			width : 80
		}, {
			title : '自带条码',
			field : 'OrigiBarCode',
			width : 80
		}, {
			title : '规格',
			field : 'Spec',
			width : 80
		}, {
			title : '型号',
			field : 'Model',
			width : 80
		}, {
			title : "单位",
			field : 'PurUom',
			width : 80
		}, {
			title : "数量",
			field : 'Qty',
			width : 100,
	        align : 'right'
		}, {
			title : "进价",
			field : 'Rp',
			width : 100,
	        align : 'right'
		}, {
			title : "售价",
			field : 'Sp',
			width : 100,
	        align : 'right'
		}, {
			title : "进销差价",
			field : 'Margin',
			width : 100,
	        align : 'right'
		}, {
			title : "进价金额",
			field : 'RpAmt',
			width : 100,
	        align : 'right'
		}, {
			title : "售价金额",
			field : 'SpAmt',
			width : 100,
	        align : 'right'
		}, {
			title : "供应商",
			field : 'Vendor',
			width : 180
		}, {
			title : "批号",
			field : 'BatNo',
			width : 90
		}, {
			title : "有效期",
			field : 'ExpDate',
			width : 100
		}, {
			title : "厂商",
			field : 'Manf',
			width : 180
		}, {
			title : "批次id",
			field : 'Inclb',
			width : 70,
			hidden : true
		}, {
			title : "货位",
			field : 'StkBin',
			width : 80
		}, {
			title : "发票号",
			field : 'InvNo',
			width : 80
		}, {
			title : "发票日期",
			field : 'InvDate',
			width : 100
		}, {
			title : "发票金额",
			field : 'InvMoney',
			width : 100,
	        align:'right'
		}, {
			title : "定价类型",
			field : 'SpType',
			width : 180
		}, {
			title : "招标标志",
			field : 'PbFlag',
			width : 180
		}, {
			title : "招标级别",
			field : 'PbLevel',
			width : 180
		}, {
			title : "医保类别",
			field : 'InsuType',
			width : 180
		}, {
			title : "单据状态",
			field : 'Status',
			width : 180
		}, {
			title : "审核日期",
			field : 'IngrDate',
			width : 180
		}, {
			title : "库存分类",
			field : 'StkCatDesc',
			width : 180
		}			
	]];
	
	var InGdRecDetailGrid = $UI.datagrid('#InGdRecDetailGrid', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecStat',
			QueryName: 'QueryRecDetail'
		},
		columns: InGdRecDetailCm,
		showBar:true
	})
	function QueryRecDetailInfo() {
		var ParamsObj=$UI.loopBlock('FindConditions');
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','起始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','截止日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.RecLoc)){
			$UI.msg('alert','入库科室不能为空!');
			return;
		}	
		var Params=JSON.stringify(ParamsObj);
		InGdRecDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecStat',
			QueryName: 'QueryRecDetail',
			Params:Params
		});
	}
	function INgrClear() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InGdRecDetailGrid);
		var Dafult={StartDate: DefaultStDate(),
					EndDate: DefaultEdDate(),
					RecLoc:gLocObj
					}
		$UI.fillBlock('#FindConditions',Dafult);
	}
	INgrClear();
}
$(init);