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
			if(isEmpty(ParamsObj.PhaLoc)){
				$UI.msg('alert','供给科室不能为空!');
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
		//科室/库存分类
		if('FlagTransIn'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_TransferINStat-LocStkcat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		return p_URL;
	}
	function GetConditions(ParamsObj){
		//获取查询条件列表
		var Conditions=""
		if(ParamsObj.PhaLoc!=""){
			Conditions=Conditions+"供给科室: "+$("#PhaLoc").combobox('getText');
		}
		if(ParamsObj.StartDate!=""){
			Conditions=Conditions+" 统计时间: "+ParamsObj.StartDate+" "+ParamsObj.StartTime;
		}
		if(ParamsObj.EndDate!=""){
			Conditions=Conditions+"~ "+ParamsObj.EndDate+" "+ParamsObj.EndTime
		}
		if(ParamsObj.TransferFlag!=""){
			Conditions=Conditions+" 统计方式: "+$("#TransferFlag").combobox('getText');
		}
		if(ParamsObj.TransRange!=""){
			Conditions=Conditions+" 科室范围: "+$("#TransRange").combobox('getText');
		}
		if(ParamsObj.RecLoc!=""){
			Conditions=Conditions+" 接收科室: "+$("#RecLoc").combobox('getText');
		}
		if(ParamsObj.LocGroup!=""){
			Conditions=Conditions+" 科室组: "+$("#LocGroup").combobox('getText');
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
		if(ParamsObj.SourceOfFund!=""){
			Conditions=Conditions+" 资金来源: "+$("#SourceOfFund").combobox('getText');
		}
		if(ParamsObj.Vendor!=""){
			Conditions=Conditions+" 供应商: "+$("#Vendor").combobox('getText');
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
	var PhaLocParams=JSON.stringify(addSessionParams({Type:'Trans'}));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PhaLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function (record) {
			var requestLoc = RecLocBox.getValue();
			var provLoc = PhaLocBox.getValue();
			$HUI.combotree('#ScgStk').setFilterByLoc(requestLoc, provLoc);
		}
	});
	var RecLocParams=JSON.stringify(addSessionParams({Type:INREQUEST_LOCTYPE}));
	var RecLocBox = $HUI.combobox('#RecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+RecLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function (record) {
			var LocId = record['RowId'];
			$('#PhaLoc').combobox('clear');
			$('#PhaLoc').combobox('reload', $URL
				+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
				+ JSON.stringify(addSessionParams({
					Type: "Trans",
					LocId: LocId
				})));
			var DefaInfo = tkMakeServerCall('web.DHCSTMHUI.DHCTransferLocConf', 'GetDefLoc', LocId, gGroupId);
			var SupLocId = DefaInfo.split('^')[0], SupLocDesc = DefaInfo.split('^')[1];
			if (SupLocId && SupLocDesc) {
				$('#PhaLoc').combobox('setValue', SupLocId);
			}
			var requestLoc = RecLocBox.getValue();
			var provLoc = PhaLocBox.getValue();
			$HUI.combotree('#ScgStk').setFilterByLoc(requestLoc, provLoc);
		}
	});
	var TransferFlagBox = $HUI.combobox('#TransferFlag', {
		data:[{'RowId':'0','Description':'转出转入'},{'RowId':'1','Description':'转出'},{'RowId':'2','Description':'转入'},{'RowId':'3','Description':'高值转入补录'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var TransRangeBox = $HUI.combobox('#TransRange', {
		data:[{'RowId':'0','Description':'全部科室'},{'RowId':'1','Description':'科室组内部'},{'RowId':'2','Description':'科室组外部'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var LocGroupBox = $HUI.combobox('#LocGroup', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocGroup&ResultSetType=array',
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
		var Loc=$("#PhaLoc").combo('getValue');
		var Obj={StkGrpRowId:Scg,StkGrpType:"M",Locdr:Loc};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	/*$('#ScgStk').combotree({
		onChange:function(newValue, oldValue){
			StkCatBox.clear();
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId='+newValue;
			StkCatBox.reload(url);
		}
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});*/
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
	var PHCDOfficialTypeBox = $HUI.combobox('#PHCDOfficialType', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInsuCat&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
	});
	var INFOMTBox = $HUI.combobox('#INFOMT', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
	});
	var OperateOutTypeParams=JSON.stringify(addSessionParams({Type:"OM"}));
	var OperateOutTypeBox = $HUI.combobox('#OperateOutType', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=array&Params='+OperateOutTypeParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var INFOPBLevelBox = $HUI.combobox('#INFOPBLevel', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPBLevel&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
	});
	var INFOImportFlagBox = $HUI.combobox('#INFOImportFlag', {
		data:[{'RowId':'国产','Description':'国产'},{'RowId':'进口','Description':'进口'},{'RowId':'合资','Description':'合资'}],
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
			RecLoc:gLocObj,
			TransferFlag:"0",
			TransRange:"0"
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