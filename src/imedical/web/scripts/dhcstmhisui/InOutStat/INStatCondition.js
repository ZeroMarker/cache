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
				$UI.msg('alert','�����Ҳ���Ϊ��!');
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
		//��ⵥ�б�
		if('FlagImportDetail'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importdetail.raq&Params='+Params+'&Conditions='+Conditions;
		}
		else if('FlagImportGroupDetail'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importgroupdetail.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//��Ʒ����
		else if('FlagItmStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importitmstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//��Ʒ����(������)
		else if('FlagItmBatStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importitmbatstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//��Ӧ�̻���
		else if('FlagVendorStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importvendorstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//��Ӧ����ϸ����
		else if('FlagVendorItmStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importvendoitmrstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//��Ӧ�̿����ཻ�汨��(����)
		else if('FlagVendorStkcatCross'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importvendorstkcatcross.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//��Ӧ�̷�Ʊ����(����)
		else if('FlagVendorInvList'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importVendorInvList.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//��Ӧ�̷�Ʊ���ݻ���
		else if('FlagVendor2InvList'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_VendorRecInvNoDetailStat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//�������
		else if('FlagStkGrpStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importstkgrpstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//���������
		else if('FlagStockStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importstockstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//��ⵥ����
		else if('FlagRecItmSumStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importrecitmsumstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//��Ʒ����(����)
		else if('FlagRpItmSumStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importrpitmsumstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//�ʽ���Դ����
		else if('FlagSourceOfFundStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_sourceoffundstat.raq&Params='+Params+'&Conditions='+Conditions;
		}
		//��ⵥ�б�
		else{
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_importdetail.raq&Params='+Params+'&Conditions='+Conditions;
		}
		return p_URL;
	}
	function GetConditions(ParamsObj){
		//��ȡ��ѯ�����б�
		var Conditions=""
		if(ParamsObj.Loc!=""){
			Conditions="������: "+$("#Loc").combobox('getText');
		}
		if(ParamsObj.StartDate!=""){
			Conditions=Conditions+" ͳ��ʱ��: "+ParamsObj.StartDate+" "+ParamsObj.StartTime;
		}
		if(ParamsObj.EndDate!=""){
			Conditions=Conditions+"~ "+ParamsObj.EndDate+" "+ParamsObj.EndTime
		}
		if(ParamsObj.Vendor!=""){
			Conditions=Conditions+" ��Ӧ��: "+$("#Vendor").combobox('getText');
		}
		if(ParamsObj.ScgStk!=""){
			Conditions=Conditions+" ����: "+$("#ScgStk").combobox('getText');
		}
		if(ParamsObj.StkCat!=""){
			Conditions=Conditions+" ������: "+$("#StkCat").combobox('getText');
		}
		if(ParamsObj.Manf!=""){
			Conditions=Conditions+" ����: "+$("#StkCat").combobox('getText');
		}
		if(ParamsObj.InciDesc!=""){
			Conditions=Conditions+" ����: "+ParamsObj.InciDesc
		}
		if(ParamsObj.OperateType!=""){
			Conditions=Conditions+" �������: "+$("#OperateType").combobox('getText');
		}
		if(ParamsObj.InvNo!=""){
			Conditions=Conditions+" ��Ʊ��: "+ParamsObj.InvNo
		}
		if(ParamsObj.HvFlag=="Y"){
			Conditions=Conditions+" ��ֵ: ��"
		}else if(ParamsObj.HvFlag=="N"){
			Conditions=Conditions+" ��ֵ: ��"
		}else if(ParamsObj.HvFlag==""){
			Conditions=Conditions+" ��ֵ: ȫ��"
		}
		if(ParamsObj.ChargeFlag=="Y"){
			Conditions=Conditions+" �շ�: ��"
		}else if(ParamsObj.ChargeFlag=="N"){
			Conditions=Conditions+" �շ�: ��"
		}else if(ParamsObj.ChargeFlag==""){
			Conditions=Conditions+" �շ�: ȫ��"
		}
		if(Conditions.RetFlag!=""){
			Conditions=Conditions+" ͳ�Ʒ�ʽ: "+$("#RetFlag").combobox('getText');
		}
		if(ParamsObj.SourceOfFund!=""){
			Conditions=Conditions+" �ʽ���Դ: "+$("#SourceOfFund").combobox('getText');
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
			Default();
		}
	});
	
	/*--�󶨿ؼ�--*/
	var LocParams=JSON.stringify(addSessionParams({Type:'All'}));
	var LocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var RetFlagBox = $HUI.combobox('#RetFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'1','Description':'���'},{'RowId':'2','Description':'�˻�'}],
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
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'Y','Description':'��ֵ'},{'RowId':'N','Description':'�Ǹ�ֵ'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ChargeFlagBox = $HUI.combobox('#ChargeFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'Y','Description':'�շ�'},{'RowId':'N','Description':'���շ�'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var AdjChequeBox = $HUI.combobox('#AdjCheque', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'G','Description':'����'},{'RowId':'A','Description':'���ۻ�Ʊ'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var OperateParams=JSON.stringify(addSessionParams({Type:"IM"}));
	var OperateTypeBox = $HUI.combobox('#OperateType', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=array&Params='+OperateParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	
	/*--���ó�ʼֵ--*/
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
				if(Title!='����'){
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