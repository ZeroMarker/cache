///统计打包工作量
var init = function() {
	
    var SupLocParams=JSON.stringify(addSessionParams({Type:"SupLoc"}));
	var SupLocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var ReqLocParams=JSON.stringify(addSessionParams({Type:"All"}));
	var ReqLocBox = $HUI.combobox('#SedLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	//消毒包分类
	var ReqLocBox = $HUI.combobox('#PackageClass', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
/* 	var PackageClassBox = $HUI.combobox('#PkgClass',{
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	}); */
	/*--按钮事件--*/
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
			
			var Params=JSON.stringify(ParamsObj);
			//alert(Params);
			Params=encodeUrlStr(Params)
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue=CheckedRadioObj.val();
			var CheckedTitle=CheckedRadioObj.attr("label")
			var Conditions=GetConditions(ParamsObj)
			var Url=CheckedUrl(CheckedValue,Params,Conditions)
			AddTab(CheckedTitle,Url);
		}
	});
	///拼接url
	function CheckedUrl(Checked,Params,Conditions){
		//入库单列表
		if('FlagPackage'==Checked){
			p_URL = PmRunQianUrl+'?reportName=CSSD_HUI_CSSDDispByPackage.raq&Params='+Params+'&Conditions='+Conditions;
		}else if('FlagLoc'==Checked){
			//alert(1);
			p_URL = PmRunQianUrl+'?reportName=CSSD_HUI_CSSDDispByLoc.raq&Params='+Params+'&Conditions='+Conditions;
		}
		
		return p_URL;
	}
	//组织查询条件
	function GetConditions(ParamsObj){
		//获取查询条件列表
		var Conditions=""
		if(ParamsObj.StartDate!=""){
			Conditions=ParamsObj.StartDate+" "+ParamsObj.StartTime;
		}
		if(ParamsObj.EndDate!=""){
			Conditions=Conditions+"~"+ParamsObj.EndDate+" "+ParamsObj.EndTime
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
	
	/*--设置初始值--*/
	var Default=function(){
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		var DefaultValue={
			StartDate:DateFormatter(new Date()),
			EndDate:DateFormatter(new Date())
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