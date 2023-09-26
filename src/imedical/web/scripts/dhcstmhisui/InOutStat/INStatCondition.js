var init = function() {
	
	/*--按钮事件--*/
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#Conditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','开始日期不能为空!');
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','截止日期不能为空!');
				return;
			}
			if(isEmpty(ParamsObj.Loc)){
				$UI.msg('alert','入库科室不能为空!');
				return;
			}
			var Params=JSON.stringify(ParamsObj);
			Params=encodeUrlStr(Params)
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue=CheckedRadioObj.val();
			var CheckedTitle=CheckedRadioObj.attr("label")
			var Conditions=GetConditions(ParamsObj)
			var Url=CheckedUrl(CheckedValue,Params,Conditions)
			AddTab(CheckedTitle,Url);
		}
	});
	function CheckedUrl(Checked,Params,Conditions){
		//入库单列表
		if('FlagImportDetail'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importdetail.raq&Params='+Params+'&Conditions='+Conditions;
		}
		else if('FlagImportGroupDetail'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importgroupdetail.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//单品汇总
		else if('FlagItmStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importitmstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//单品汇总(按批次)
		else if('FlagItmBatStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importitmbatstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//供应商汇总
		else if('FlagVendorStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importvendorstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//供应商明细汇总
		else if('FlagVendorItmStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importvendoitmrstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//供应商库存分类交叉报表(进价)
		else if('FlagVendorStkcatCross'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importvendorstkcatcross.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//供应商发票汇总(进价)
		else if('FlagVendorInvList'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importVendorInvList.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//供应商发票单据汇总
		else if('FlagVendor2InvList'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_VendorRecInvNoDetailStat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//类组汇总
		else if('FlagStkGrpStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importstkgrpstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//库存分类汇总
		else if('FlagStockStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importstockstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//入库单汇总
		else if('FlagRecItmSumStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importrecitmsumstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//单品汇总(进价)
		else if('FlagRpItmSumStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importrpitmsumstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//资金来源汇总
		else if('FlagSourceOfFundStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_sourceoffundstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//入库单列表
		else{
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importdetail.raq&Params='+Params+'&Conditions='+Conditions;
		}
		return p_URL;
	}
	function GetConditions(ParamsObj){
		//获取查询条件列表
		var Conditions=""
		if(ParamsObj.Loc!=""){
			Conditions="入库科室: "+$("#Loc").combobox('getText');
		}
		if(ParamsObj.StartDate!=""){
			Conditions=Conditions+" 统计时间: "+ParamsObj.StartDate+" "+ParamsObj.StartTime;
		}
		if(ParamsObj.EndDate!=""){
			Conditions=Conditions+"~ "+ParamsObj.EndDate+" "+ParamsObj.EndTime
		}
		if(ParamsObj.Vendor!=""){
			Conditions=Conditions+" 供应商: "+$("#Vendor").combobox('getText');
		}
		if(ParamsObj.ScgStk!=""){
			Conditions=Conditions+" 类组: "+$("#ScgStk").combobox('getText');
		}
		if(ParamsObj.StkCat!=""){
			Conditions=Conditions+" 库存分类: "+$("#StkCat").combobox('getText');
		}
		if(ParamsObj.Manf!=""){
			Conditions=Conditions+" 厂商: "+$("#StkCat").combobox('getText');
		}
		if(ParamsObj.InciDesc!=""){
			Conditions=Conditions+" 物资: "+ParamsObj.InciDesc
		}
		if(ParamsObj.OperateType!=""){
			Conditions=Conditions+" 入库类型: "+$("#OperateType").combobox('getText');
		}
		if(ParamsObj.InvNo!=""){
			Conditions=Conditions+" 发票号: "+ParamsObj.InvNo
		}
		if(ParamsObj.HvFlag=="Y"){
			Conditions=Conditions+" 高值: 是"
		}else if(ParamsObj.HvFlag=="N"){
			Conditions=Conditions+" 高值: 否"
		}else if(ParamsObj.HvFlag==""){
			Conditions=Conditions+" 高值: 全部"
		}
		if(ParamsObj.ChargeFlag=="Y"){
			Conditions=Conditions+" 收费: 是"
		}else if(ParamsObj.ChargeFlag=="N"){
			Conditions=Conditions+" 收费: 否"
		}else if(ParamsObj.ChargeFlag==""){
			Conditions=Conditions+" 收费: 全部"
		}
		if(Conditions.RetFlag!=""){
			Conditions=Conditions+" 统计方式: "+$("#RetFlag").combobox('getText');
		}
		if(ParamsObj.SourceOfFund!=""){
			Conditions=Conditions+" 资金来源: "+$("#SourceOfFund").combobox('getText');
		}
		return Conditions;
	}
	function AddTab(title, url) {
		if ($('#tabs').tabs('exists', title)) {
			$('#tabs').tabs('select', title); //选中并刷新
			var currTab = $('#tabs').tabs('getSelected');
			if (url != undefined && currTab.panel('options').title != '报表') {
				$('#tabs').tabs('update', {
					tab: currTab,
					options: {
						content: createFrame(url)
					}
				})
			}
		} else {
			var content = createFrame(url);
			$('#tabs').tabs('add', {
				title: title,
				content: content,
				closable: true
			});
		}
	}
	function createFrame(url) {
		var s = '<iframe scrolling="auto" frameborder="0" src="' + url + '" style="width:100%;height:98%;"></iframe>';
		return s;
	}
	
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Default();
		}
	});
	
	/*--绑定控件--*/
	var LocParams=JSON.stringify(addSessionParams({Type:'All'}));
	var LocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var RetFlagBox = $HUI.combobox('#RetFlag', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'1','Description':'入库'},{'RowId':'2','Description':'退货'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var SourceOfFundBox = $HUI.combobox('#SourceOfFund', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
	});
	var HandlerParams=function(){
		var Scg=$("#ScgStk").combotree('getValue');
		var Loc=$("#Loc").combo('getValue');
		var Obj={StkGrpRowId:Scg,StkGrpType:"M",Locdr:Loc};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#ScgStk').combotree({
		onChange:function(newValue, oldValue){
			StkCatBox.clear();
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId='+newValue;
			StkCatBox.reload(url);
		}
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
	var AdjChequeBox = $HUI.combobox('#AdjCheque', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'G','Description':'赠送'},{'RowId':'A','Description':'调价换票'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var OperateParams=JSON.stringify(addSessionParams({Type:"IM"}));
	var OperateTypeBox = $HUI.combobox('#OperateType', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=array&Params='+OperateParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	
	/*--设置初始值--*/
	var Default=function(){
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		var DefaultValue={
			StartDate:DefaultStDate(),
			EndDate:DefaultEdDate(),
			Loc:gLocObj,
			RetFlag:''
			}
		$UI.fillBlock('#Conditions',DefaultValue)
		var Tabs=$('#tabs').tabs('tabs')
		var Tiles = new Array();
		var Len = Tabs.length;
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
	Default()
}
$(init);