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
				$UI.msg('alert','科室不能为空!');
				return;
			}
			var Params=JSON.stringify(ParamsObj);
			Params=encodeUrlStr(Params)
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue=CheckedRadioObj.val();
			var CheckedTitle=CheckedRadioObj.attr("label")
			var Url=CheckedUrl(CheckedValue,Params)
			AddTab(CheckedTitle,Url);
		}
	});
	
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Default()
		}
	});
	
	function CheckedUrl(Checked,Params){
		//单品汇总
		if('FlagDetailStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_aspamountstat-inc.raq&Params='+Params;
		}
		//单品科室汇总
		else if('FlagItmLocStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_aspamountstat-incloc.raq&Params='+Params;
		}
		//供应商汇总
		else if('FlagVendorStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_aspamountstat-vendor.raq&Params='+Params;
		}
		return p_URL;
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
	
	/*--绑定控件--*/
	var AspLocParams=JSON.stringify(addSessionParams({Type:'All'}));
	var AspLocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+AspLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var HandlerParams=function(){
		var Loc=$("#Loc").combo('getValue');
		var Obj={StkGrpRowId:"",StkGrpType:"M",Locdr:Loc};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	
	var Default=function(){
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		///设置初始值 考虑使用配置
		var DefaultValue={
			StartDate:new Date(),
			EndDate:new Date(),
			Loc:gLocObj
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
	}
	Default()
}
$(init);