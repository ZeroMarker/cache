var init = function() {
	
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
				$UI.msg('alert','采购科室不能为空!');
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
		//供应商
		if('FlagVendor'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_PayStat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//供应商明细
		else if('FlagVendorItm'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_PayStat2.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//付款单
		else if('FlagPay'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_PayStat_payno.raq&Params='+Params+'&Conditions='+Conditions;
		}
		return p_URL;
	}
	function GetConditions(ParamsObj){
		//获取查询条件列表
		var Conditions=""
		if(ParamsObj.Loc!=""){
			Conditions="科室: "+$("#Loc").combobox('getText');
		}
		if(ParamsObj.StartDate!=""){
			Conditions=Conditions+" 统计时间: "+ParamsObj.StartDate;
		}
		if(ParamsObj.EndDate!=""){
			Conditions=Conditions+"~ "+ParamsObj.EndDate;
		}
		if(ParamsObj.Vendor!=""){
			Conditions=Conditions+" 供应商: "+$("#Vendor").combobox('getText');
		}
		if(ParamsObj.PayMode!=""){
			Conditions=Conditions+" 支付方式: "+$("#PayMode").combobox('getText');
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
			Default()
		}
	});
	/*--绑定控件--*/
	var LocParams=JSON.stringify(addSessionParams({Type:'All'}));
	var LocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var CompFlagBox = $HUI.combobox('#CompFlag', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'1','Description':'未完成'},{'RowId':'2','Description':'完成'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var PayModeBox = $HUI.combobox('#PayMode', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPayMode&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
	});
	/*--设置初始值--*/
	var Default=function(){
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		var DefaultValue={
			StartDate:new Date(),
			EndDate:new Date(),
			Loc:gLocObj
			}
		$UI.fillBlock('#Conditions',DefaultValue)
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
	
	Default()
}
$(init);