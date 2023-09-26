///ͳ�����������
var init = function() {
	var packageClassDr="";
	var typeDetial="";
	var ReqLocBox = $HUI.combobox('#PackName',{
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial=1,2,7&packageClassDr='+packageClassDr,
		valueField: 'RowId',
		textField: 'Description'
	});
	function getPakcageData(packageClassDr){
		$("#PackName").combobox('clear');
		$("#PackName").combobox('reload',
		$URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackage&ResultSetType=array&typeDetial='+typeDetial+'&packageClassDr='+packageClassDr);
		
	}
	   //����������
	var ReqLocBox = $HUI.combobox('#PackageClass', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onSelect:function(record){
			var packageClassDr= record['RowId'];
			getPakcageData(packageClassDr);
		}
	});
	//�����ʽ
	var ReqLocBox = $HUI.combobox('#SterType', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var ReqLocBox = $HUI.combobox('#SterHum',{
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetUser&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
		var ReqLocBox = $HUI.combobox('#MachineNum',{
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMachineNoComBo&type=sterilizer&ResultSetType=array',
		valueField: 'RowId',
		 textField: 'Description'
	});
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
	///ƴ��url
	function CheckedUrl(Checked,Params,Conditions){
		//���������ͳ��(����)
		if('FlagStatSterWorkLoadByPeople'==Checked){
			p_URL = PmRunQianUrl+'?reportName=CSSD_HUI_StatSterWorkLoadByPeople.raq&Params='+Params+'&Conditions='+Conditions;
		}else if('FlagStatSterWorkLoadDetail'==Checked){//���������ͳ������
			p_URL = PmRunQianUrl+'?reportName=CSSD_HUI_StatSterWorkLoadDetail.raq&Params='+Params+'&Conditions='+Conditions;
		}
		
		return p_URL;
	}
	//��֯��ѯ����
	function GetConditions(ParamsObj){
		//��ȡ��ѯ�����б�
		var Conditions=""
		if(ParamsObj.StartDate!=""){
			Conditions=" ͳ��ʱ��: "+ParamsObj.StartDate+" "+ParamsObj.StartTime;
		}
		if(ParamsObj.EndDate!=""){
			Conditions=Conditions+" ��ֹʱ�䣺"+ParamsObj.EndDate+" "+ParamsObj.EndTime
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
	
	/*--���ó�ʼֵ--*/
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