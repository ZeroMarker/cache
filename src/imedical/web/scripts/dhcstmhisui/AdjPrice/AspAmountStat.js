var init = function() {
	
	/*--��ť�¼�--*/
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#Conditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','��ʼ���ڲ���Ϊ��!');
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','��ֹ���ڲ���Ϊ��!');
				return;
			}
			if(isEmpty(ParamsObj.Loc)){
				$UI.msg('alert','���Ҳ���Ϊ��!');
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
		//��Ʒ����
		if('FlagDetailStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_aspamountstat-inc.raq&Params='+Params;
		}
		//��Ʒ���һ���
		else if('FlagItmLocStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_aspamountstat-incloc.raq&Params='+Params;
		}
		//��Ӧ�̻���
		else if('FlagVendorStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_aspamountstat-vendor.raq&Params='+Params;
		}
		return p_URL;
	}
	function AddTab(title, url) {
		if ($('#tabs').tabs('exists', title)) {
			$('#tabs').tabs('select', title); //ѡ�в�ˢ��
			var currTab = $('#tabs').tabs('getSelected');
			if (url != undefined && currTab.panel('options').title != '����') {
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
	
	/*--�󶨿ؼ�--*/
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
		///���ó�ʼֵ ����ʹ������
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
				if(Title!='����'){
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