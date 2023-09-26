//名称: 物资批次价格变动统计
var init = function() {
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		var Dafult={
			StartDate:DateFormatter(new Date()),
			EndDate:DateFormatter(new Date())
			}
		$UI.fillBlock('#Conditions',Dafult)
		var Tabs=$('#tabs').tabs('tabs')
		var Tiles = new Array();
		var Len =  Tabs.length;
		if(Len>0){
			for(var j=0;j<Len;j++){
				var Title = Tabs[j].panel('options').title;
				if(Title!='报表'){
					Tiles.push(Title);
				}
			}
			for(var i=0;i<Tiles.length;i++){
				$('#tabs').tabs('close', Tiles[i]);
			}
		}
	};
	$('#ScgStk').stkscgcombotree({
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
		var StkGrpId = $('#ScgStk').combotree('getValue');
		var Obj = {StkGrpRowId:StkGrpId, StkGrpType:'M', Locdr:gLocId};
		return Obj;
	}
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var StockTypeBox = $HUI.combobox('#StockType', {
		data:[{'RowId':0,'Description':'全部'},{'RowId':1,'Description':'库存为零'},{'RowId':2,'Description':'库存为正'},{'RowId':3,'Description':'库存为负'},{'RowId':4,'Description':'库存非零'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var ManfParams=JSON.stringify(addSessionParams({StkType:"M"}));
	var ManfBox = $HUI.combobox('#Manf', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='+ManfParams,
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
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#Conditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','起始日期不能为空!');
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','截止日期不能为空!');
				return;
			}
			var Params=JSON.stringify(addSessionParams(ParamsObj));
			Params=encodeUrlStr(Params)
			var Conditions=GetConditions(ParamsObj)
			var p_URL= PmRunQianUrl+'?reportName=DHCSTM_HUI_ItmBatRp.raq&Params='+Params+'&Conditions='+Conditions;
			var reportFrame=document.getElementById("IncDetailIFrame");
			reportFrame.src=p_URL;
		}
	});
	function GetConditions(ParamsObj){
		//获取查询条件列表
		var Conditions=""
		if(ParamsObj.StartDate!=""){
			Conditions=Conditions+" 统计时间: "+ParamsObj.StartDate;
		}
		if(ParamsObj.EndDate!=""){
			Conditions=Conditions+"~ "+ParamsObj.EndDate
		} 
		if(ParamsObj.ScgStk!=""){
			Conditions=Conditions+" 类组: "+$("#ScgStk").combobox('getText');
		}	
		if(ParamsObj.StkCat!=""){
			Conditions=Conditions+" 库存分类: "+$("#StkCat").combobox('getText');
		}
		if(ParamsObj.MinRp!=""){
			Conditions=Conditions+" 最低进价: "+ParamsObj.MinRp
		}
		if(ParamsObj.MaxRp!=""){
			Conditions=Conditions+" 最高进价: "+ParamsObj.MaxRp
		}
		return Conditions;
	}
	
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear()
		}
	});
	Clear()
}
$(init);
