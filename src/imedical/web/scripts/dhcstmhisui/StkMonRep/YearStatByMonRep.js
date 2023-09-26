//����: �±����ͳ��(�±�����)
//��д����: 20180813
var init = function() {
	function GetParamsObj(){
		var ParamsObj=$UI.loopBlock('#YearConditions');
		return ParamsObj;
	}
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear();
		}	
	});
	var Clear=function(){
		$UI.clearBlock('#YearConditions');
		var Year=new Date().getFullYear();
		var Dafult={
			PhaLoc:gLocObj,
			Year:Year
			}
		$UI.fillBlock('#YearConditions',Dafult)
		var Tabs=$('#Yeartabs').tabs('tabs')
  		var Tiles = new Array();      
        var Len =  Tabs.length;           
        if(Len>0){  
            for(var j=0;j<Len;j++){  
                var Title = Tabs[j].panel('options').title;
                if(Title!='����'){
                	Tiles.push(Title);
                }
            }  
            for(var i=0;i<Tiles.length;i++){               
                $('#Yeartabs').tabs('close', Tiles[i]);  
            }  
          } 
	};
	var LocParams=JSON.stringify(addSessionParams({Type:'All'}));
	var LocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});	
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			QueryYearStkMon();
		}	
	});	
	function CheckedUrl(Checked){
		var ParamsObj=GetParamsObj();
		var PhaLoc =ParamsObj.PhaLoc;
		var Year = ParamsObj.Year;
		var StMonth = ParamsObj.StMonth;
		var EdMonth = ParamsObj.EdMonth;
		// �������(���ת��)
		if('ScgStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_YearStatByMonRep_Scg.raq&PhaLoc='+PhaLoc+'&Year='+Year+'&StMonth='+StMonth+'&EdMonth='+EdMonth;
		}
		// ���������(���ת��)
		else if('StkCatStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_YearStatByMonRep_StkCat.raq&PhaLoc='+PhaLoc+'&Year='+Year+'&StMonth='+StMonth+'&EdMonth='+EdMonth;
		}
		// ����˻���ϸ(��Ʒ��)
		else if('InciRecRetStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_YearStatByMonRep_Inci.raq&PhaLoc='+PhaLoc+'&Year='+Year+'&StMonth='+StMonth+'&EdMonth='+EdMonth;
		}
		// �������(������)
		else if('OutLocStat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_YearStatTKByMonRep_Loc.raq&PhaLoc='+PhaLoc+'&Year='+Year+'&StMonth='+StMonth+'&EdMonth='+EdMonth;
		}
		// ���������(����)
		else if('ScgCatStatCat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_YearStatByMonCatRep.raq&PhaLoc='+PhaLoc+'&Year='+Year+'&StMonth='+StMonth+'&EdMonth='+EdMonth;
		}
		// �������(�����ҷ���)
		else if('OutLocStatCat'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_YearStatTKByMonCatRep_Loc.raq&PhaLoc='+PhaLoc+'&Year='+Year+'&StMonth='+StMonth+'&EdMonth='+EdMonth;
		}	
		return p_URL;
	}
	function createFrame(url) {
		var s = '<iframe scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:100%;"></iframe>';
		return s;
	}
	function AddTab(title, url) {
		if ($('#Yeartabs').tabs('exists', title)) {
			$('#Yeartabs').tabs('select', title); //ѡ�в�ˢ��
			var currTab = $('#Yeartabs').tabs('getSelected');
			if (url != undefined && currTab.panel('options').title != '����') {
				$('#Yeartabs').tabs('update', {
					tab: currTab,
					options: {
						content: createFrame(url)
					}
				})
			}
		} else {
			var content = createFrame(url);
			$('#Yeartabs').tabs('add', {
				title: title,
				content: content,
				closable: true
			});
		}
	}
	function QueryYearStkMon(){
			var ParamsObj=GetParamsObj();
			if(isEmpty(ParamsObj.PhaLoc)){
				$UI.msg('alert','��ѡ�����!');
				return false;
			}
			if(isEmpty(ParamsObj.Year)){
				$UI.msg('alert','����д���!');
				return false;
			}
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue=CheckedRadioObj.val();
			var CheckedTitle=CheckedRadioObj.attr("label")
			var Url=CheckedUrl(CheckedValue)
			AddTab(CheckedTitle,Url);
	}
	Clear();
}
$(init);