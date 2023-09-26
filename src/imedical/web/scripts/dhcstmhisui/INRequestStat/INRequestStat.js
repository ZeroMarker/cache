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
				$UI.msg('alert','�������Ҳ���Ϊ��!');
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
		//������ϸ
		if('FlagInrequestStatDetail'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_INRequestStat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//����������ϸ
		else if('FlagInrequestStatLoc'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_INRequestStatLoc.raq&Params='+Params+'&Conditions='+Conditions;
		}
		return p_URL;
	}
	function GetConditions(ParamsObj){
		//��ȡ��ѯ�����б�
		var Conditions=""
		if(ParamsObj.Loc!=""){
			Conditions="����: "+$("#Loc").combobox('getText');
		}
		if(ParamsObj.StartDate!=""){
			Conditions=Conditions+" ͳ��ʱ��: "+ParamsObj.StartDate;
		}
		if(ParamsObj.EndDate!=""){
			Conditions=Conditions+"~ "+ParamsObj.EndDate;
		} 
		if(ParamsObj.ScgStk!=""){
			Conditions=Conditions+" ����: "+$("#ScgStk").combobox('getText');
		}	
		if(ParamsObj.InciDesc!=""){
			Conditions=Conditions+" ����: "+ParamsObj.InciDesc
		}
		return Conditions;
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
	
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Default()
		}
	});
	/*--�󶨿ؼ�--*/
	var LocParams=JSON.stringify(addSessionParams({Type:'All'}));
	var LocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
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
	
	/*--���ó�ʼֵ--*/
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