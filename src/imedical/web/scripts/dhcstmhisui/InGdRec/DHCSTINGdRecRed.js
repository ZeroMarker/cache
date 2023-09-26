/*
入库单红冲
描述: 对于已经入库审核且出库而且已经生成月报，没有其他业务操作的情况
*/
var init = function() {
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			QueryIngrInfo();
		}
	});
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			IngrClear();
		}
	});
	$UI.linkbutton('#SaveBT',{
		onClick:function(){
			IngrRedData();
		}
	});
	var FRecLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var FRecLocBox = $HUI.combobox('#FRecLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+FRecLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var FVendorBoxParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var FVendorBox = $HUI.combobox('#FVendorBox', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+FVendorBoxParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var InGdRecMainCm = [[{
			title : "RowId",
			field : 'IngrId',
			width : 100,
			hidden : true
		}, {
			title : "入库单号",
			field : 'IngrNo',
			width : 120
		}, {
			title : "供应商",
			field : 'Vendor',
			width : 200
		}, {
			title : '订购科室',
			field : 'ReqLocDesc',
			width : 150
		}, {
			title : '验收人',
			field : 'AcceptUser',
			width : 70
		}, {
			title : '到货日期',
			field : 'CreateDate',
			width : 90
		}, {
			title : '采购员',
			field : 'PurchUser',
			width : 70
		}, {
			title : "完成标志",
			field : 'Complete',
			width : 70
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
		}	
	]];
	
	var InGdRecMainGrid = $UI.datagrid('#InGdRecMainGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query'
		},
		columns: InGdRecMainCm,
		onSelect:function(index, row){
			$UI.setUrl(InGdRecDetailGrid)
			InGdRecDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				Parref: row.IngrId,
				rows: 99999
			});
		}
	})
	
	var InGdRecDetailCm = [[{
			title : "RowId",
			field : 'RowId',
			width : 100,
			hidden : true
		}, {
			title : '物资代码',
			field : 'IncCode',
			width : 80
		}, {
			title : '物资名称',
			field : 'IncDesc',
			width : 230
		}, {
			title : "规格",
			field : 'Spec',
			width : 180
		}, {
			title : "具体规格",
			field : 'SpecDesc',
			width : 180
		}, {
			title : "厂商",
			field : 'Manf',
			width : 180
		}, {
			title : "批号",
			field : 'BatchNo',
			width : 90
		}, {
			title : "有效期",
			field : 'ExpDate',
			width : 100
		}, {
			title : "单位",
			field : 'IngrUom',
			width : 80
		}, {
			title : "数量",
			field : 'RecQty',
			width : 80,
	        align : 'right'
		}, {
			title : "进价",
			field : 'Rp',
			width : 60,
	        align : 'right',
				editor:{
					type:'numberbox',
					options:{
						required:true
						}
					}
		}, {
			title : "注册证号",
			field : 'AdmNo',
			width : 80
		}, {
			title : "注册证有效期",
			field : 'AdmExpdate',
			width : 80
		}, {
			title : "摘要",
			field : 'Remark',
			width : 60
		}, {
			title : "售价",
			field : 'Sp',
			width : 60,
	        align : 'right'
		}, {
			title : "发票号",
			field : 'InvNo',
			width : 80
		}, {
			title : "发票日期",
			field : 'InvDate',
			width : 100
		}, {
			title :"发票金额",
			field :'InvMoney',
	        align : 'right',
			width :80
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
			title : '高值条码',
			field : 'HVBarCode',
			width : 80
		}, {
			title : '自带条码',
			field : 'OrigiBarCode',
			width : 80
		}			
	]];
	
	var InGdRecDetailGrid = $UI.datagrid('#InGdRecDetailGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			rows: 99999
		},
		pagination:false,
		columns: InGdRecDetailCm,
		onClickCell: function(index, field ,value){
			InGdRecDetailGrid.commonClickCell(index,field,value);
		},
		onEndEdit:function(index, row, changes){
			var Editors = $(this).datagrid('getEditors', index);
		    for(var i=0;i<Editors.length;i++){
				var Editor = Editors[i];
				if(Editor.field=='Rp'){
					var rp = row.Rp;
					if (isEmpty(rp)) {
						$UI.msg('alert',"进价不能为空!");
						InGdRecDetailGrid.checked=false;
						return false;
					}else if (rp < 0) {
						//2016-09-26进价可为0
						$UI.msg('alert',"进价不能小于零!");
						InGdRecDetailGrid.checked=false;
						return false;
					}else if (rp==0) {
						$UI.msg('alert',"进价等于零!");
						InGdRecDetailGrid.checked=false;
						return false;
					}
					// 计算指定行的进货金额
					var RealTotal = accMul(row.RecQty, rp);
					row.RpAmt=RealTotal;
					row.InvMoney=RealTotal;
				}
		    }
		}
	})
	function QueryIngrInfo(){
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		var ParamsObj=$UI.loopBlock('#FindConditions')
		if(isEmpty(ParamsObj.StartDate)){
			$UI.msg('alert','开始日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.EndDate)){
			$UI.msg('alert','截止日期不能为空!');
			return;
		}
		if(isEmpty(ParamsObj.FRecLoc)){
			$UI.msg('alert','科室不能为空!');
			return;
		}	
		var Params=JSON.stringify(ParamsObj);
		$UI.setUrl(InGdRecMainGrid)
		InGdRecMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			Params:Params
		});
	
	}
	function IngrRedData() {
		
	}
	function IngrClear() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		var Dafult={StartDate: DefaultStDate(),
					EndDate: DefaultEdDate(),
					FRecLoc:gLocObj,
					AuditFlag:"Y"
					}
		$UI.fillBlock('#FindConditions',Dafult);
	
	}
	IngrClear();
}
$(init);