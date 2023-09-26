var init = function() {
	
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#Conditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg("alert","开始日期不能为空!");
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg("alert","截止日期不能为空!");
				return;
			}
			if(isEmpty(ParamsObj.PhaLoc)){
				$UI.msg("alert","科室不能为空!");
				return;
			}
			//var Params=encodeURI(JSON.stringify(ParamsObj));
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
	var HandlerParams=function(){
		var Obj={StkGrpType:"M"};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));		
	function CheckedUrl(Checked,Params){
		var FindType=""
		//统计列表-按物资
		if('FlagItmlist'==Checked){
			var FindType="1"
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_DispStatAll_INCI_Common.raq&Params='+Params+"&FindType="+FindType;
		}
		//统计列表-按医生科室
		if('FlagDocLoclist'==Checked){
			var FindType="2"
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_DispStatAll_DOCLOC_Common.raq&Params='+Params+"&FindType="+FindType;
		}
		//统计列表-按库存分类
		if('FlagStkCatlist'==Checked){
			var FindType="3"
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_DispStatAll_STKCAT_Common.raq&Params='+Params+"&FindType="+FindType;
		}
		//统计列表-按患者科室
		if('FlagAdmLoclist'==Checked){
			var FindType="4"
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_DispStatAll_AdmLoc.raq&Params='+Params+"&FindType="+FindType;
		}
		//统计列表-按接收科室
		if('FlagRecLoclist'==Checked){
			var FindType="5"
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_DispStatAll_RecLoc.raq&Params='+Params+"&FindType="+FindType;
		}
		//统计列表详情
		else if('FlaglistDetail'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_DispStatAll_INCI_Common_Detail.raq&Params='+Params;
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
	var PhaLocParams=JSON.stringify(addSessionParams({Type:'All'}));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PhaLocParams,
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
			PhaLoc:gLocObj
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