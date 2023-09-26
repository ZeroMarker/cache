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
			if(isEmpty(ParamsObj.PoLoc)){
				$UI.msg('alert','订单科室不能为空!');
				return;
			}
			var Params=JSON.stringify(ParamsObj);
			Params=encodeURIComponent(Params)
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue=CheckedRadioObj.val();
			var CheckedTitle=CheckedRadioObj.attr("label")
			var Conditions=GetConditions(ParamsObj)
			var Url=CheckedUrl(CheckedValue,Params,Conditions)
			AddTab(CheckedTitle,Url);
		}
	});
	function CheckedUrl(Checked,Params,Conditions){
		var p_URL="";
		if('FlagInpo'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_InPoStat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		else{
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_InPoStat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		return p_URL;
	}
	function GetConditions(ParamsObj){
		//获取查询条件列表
		var Conditions=""
		if(ParamsObj.PoLoc!=""){
			Conditions="订单科室: "+$("#PoLoc").combobox('getText');
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
		if(ParamsObj.InciDesc!=""){
			Conditions=Conditions+" 物资: "+ParamsObj.InciDesc
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
	var PoLocParams=JSON.stringify(addSessionParams({Type:"LinkLoc"}));
	var PoLocBox = $HUI.combobox('#PoLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PoLocParams,
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
		var PoLoc=$("#PoLoc").combo('getValue');
		var Obj={StkGrpRowId:"",StkGrpType:"M",Locdr:PoLoc};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	
	/*--设置初始值--*/
	var Default=function(){
		$UI.clearBlock('#Conditions');
		var DefaultValue={
			StartDate:new Date(),
			EndDate:new Date(),
			PoLoc:gLocObj
			}
		$UI.fillBlock('#Conditions',DefaultValue)
		$UI.clearBlock('#ReportConditions');
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