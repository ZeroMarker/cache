/*已审核入库单查询与修改*/
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
	$UI.linkbutton('#UpadateBT',{
		onClick:function(){
			UpadateData();
		}
	});
	$UI.linkbutton('#UpVendBT',{
		onClick:function(){
			UpVendData();
		}
	});
	$UI.linkbutton('#CancelAuditBT',{
		onClick:function(){
			CancelAudit();
		}
	});
	function UpadateData(){
		var Row=InGdRecMainGrid.getSelected();
		if(isEmpty(Row)){
			$UI.msg('alert','请选择要处理的单据!');
			return false;
		}
		var LocId=Row.RecLocId;
		var CheckParams = {LocId : LocId};
		var CheckRet = $.m({
			ClassName: 'web.DHCSTMHUI.Common.UtilCommon',
			MethodName: 'CheckBeforeInstk',
			Params: JSON.stringify(CheckParams)
		},false);
		if(!isEmpty(CheckRet)){
			$UI.msg('alert', CheckRet);
			return false;
		}
		var MainObj=$UI.loopBlock('#FindConditions');
		var Main=JSON.stringify(MainObj);
		var DetailObj=InGdRecDetailGrid.getChangesData('RowId');
		if (DetailObj === false){	//未完成编辑或明细为空
			return false;
		}
		if (isEmpty(DetailObj)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return false;
		}
		var Detail=JSON.stringify(DetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecMod',
			MethodName: 'UpdateRecInfo',
			ListData: Detail
		},function(jsonData){
			hideMask();
			$UI.msg('alert',jsonData.msg);
			if(jsonData.success==0){
				QueryIngrInfo();
			}
		});
	}
	function UpVendData(){
		var MainObj=$UI.loopBlock('#FindConditions');
		var newVendorId=MainObj.FVendorBox;
		if(isEmpty(newVendorId)){
			$UI.msg('alert','请选择供应商!');
			return false;
		}
		var Row=InGdRecMainGrid.getSelected();
		if(isEmpty(Row)){
			$UI.msg('alert','请选择要处理的单据!');
			return false;
		}
		var LocId=Row.RecLocId;
		var CheckParams = {LocId : LocId};
		var CheckRet = $.m({
			ClassName: 'web.DHCSTMHUI.Common.UtilCommon',
			MethodName: 'CheckBeforeInstk',
			Params: JSON.stringify(CheckParams)
		},false);
		if(!isEmpty(CheckRet)){
			$UI.msg('alert', CheckRet);
			return false;
		}
		var oldVendorId=Row.Vendor;
		if(newVendorId==oldVendorId){
			return false;
		}
		var IngrId=Row.IngrId;
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecMod',
			MethodName: 'GrUpdateVen',
			IngrId: IngrId,
			VendorId: newVendorId
		},function(jsonData){
			hideMask();
			$UI.msg('alert',jsonData.msg);
			if(jsonData.success==0){
				QueryIngrInfo();
			}
		});
	}
	function CancelAudit(){
		var Row=InGdRecMainGrid.getSelected();
		if(isEmpty(Row)){
			$UI.msg('alert','请选择要取消审核的单据!');
			return false;
		}
		var LocId=Row.RecLocId;
		var CheckParams = {LocId : LocId};
		var CheckRet = $.m({
			ClassName: 'web.DHCSTMHUI.Common.UtilCommon',
			MethodName: 'CheckBeforeInstk',
			Params: JSON.stringify(CheckParams)
		},false);
		if(!isEmpty(CheckRet)){
			$UI.msg('alert', CheckRet);
			return false;
		}
		var IngrId=Row.IngrId;
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRecMod',
			MethodName: 'GrCancelAudit',
			IngrId: IngrId
		},function(jsonData){
			hideMask();
			$UI.msg('alert',jsonData.msg);
			if(jsonData.success==0){
				QueryIngrInfo();
			}
		});
	}
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			var Row=InGdRecMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','请选择需要打印的信息!');
				return false;
			}
			var Rowid=Row.IngrId;
			PrintRec(Rowid);
		}
	});

	$UI.linkbutton('#PrintHVColBT',{
		onClick:function(){
			var Row=InGdRecMainGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert','请选择需要打印的信息!');
				return false;
			}
			var Rowid=Row.IngrId;
			PrintRecHVCol(Rowid);
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
	var PhManufacturerParams=JSON.stringify(addSessionParams({StkType:"M"}));
	var PhManufacturerBox = {
		type:'combobox',
		options:{
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='+PhManufacturerParams,
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad:function(param){
				//var ScgId=GetParamsObj().StkGrpId;
				//param.ScgId =ScgId;
			}
		}
	};
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
			title : "VenId",
			field : 'VenId',
			width : 200,
			hidden : true
		}, {
			title : "供应商",
			field : 'Vendor',
			width : 200
		},{
			title : "RecLocId",
			field : 'RecLocId',
			width : 100,
			hidden : true
		}, {
			title : '入库科室',
			field : 'ReqLocDesc',
			width : 150
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
		showBar:true,
		onSelect:function(index, row){
			var VenId=row.VenId;
			var Vendor=row.Vendor;
			var VenObj = {RowId: VenId, Description: Vendor};
			$('#FVendorBox').combobox('setValue',VenId);
			$UI.setUrl(InGdRecDetailGrid);
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
			width : 180,
			hidden : true
		}, {
			title : "厂商",
			field : 'ManfId',
			width : 180,
			formatter: CommonFormatter(PhManufacturerBox,'ManfId','Manf'),
			editor:PhManufacturerBox
		}, {
			title : "批号",
			field : 'BatchNo',
			width : 90,
			editor:{
				type:'text'
				}
		}, {
			title : "有效期",
			field : 'ExpDate',
			width : 100,
			editor:{
				type:'datebox'
				}
		},{
			title : "批号要求",
			field : 'BatchReq',
			width : 80,
			hidden : true
		},{
			title : "有效期要求",
			field : 'ExpReq',
			width : 80,
			hidden : true
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
			width : 80,
			hidden : true
		}, {
			title : "注册证有效期",
			field : 'AdmExpdate',
			width : 80,
			hidden : true
		}, {
			title : "摘要",
			field : 'Remark',
			width : 60,
			hidden : true
		}, {
			title : "售价",
			field : 'Sp',
			width : 60,
	        align : 'right'
		}, {
			title : "发票号",
			field : 'InvNo',
			width : 80,
			editor:{
				type:'text'
				}
		}, {
			title : "发票日期",
			field : 'InvDate',
			width : 100,
			editor:{
				type:'datebox',
				options:{
					}
				}
		}, {
			title :"发票金额",
			field :'InvMoney',
			width :80,
	        align : 'right',
			editor:{
				type:'numberbox'
				}
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
		},{
			title : "随行单号",
			field : 'SxNo',
			width : 90,
			editor:{
				type:'text'
				}
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
		showBar:true,  
		onClickCell: function(index, field ,value){	
			var Row = InGdRecDetailGrid.getRows()[index];
			if ((field == 'ExpDate')&&(Row.ExpReq=="N")) {
				return false;
			}
			if ((field == 'BatchNo')&&(Row.BatchReq=="N")) {
				return false;
			}
			InGdRecDetailGrid.commonClickCell(index,field,value)
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