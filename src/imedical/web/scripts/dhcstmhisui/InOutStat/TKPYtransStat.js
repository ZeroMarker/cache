//TKPY̨��ͳ�ƻ���
var init = function() {
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		var Dafult={
			StartDate:new Date(),
			EndDate:new Date(),
			PhaLoc:gLocObj,
			Ways:0
			}
		$UI.fillBlock('#Conditions',Dafult)
		var Tabs=$('#tabs').tabs('tabs')
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
                $('#tabs').tabs('close', Tiles[i]);  
            }  
          } 
	};
	var PhaLocParams=JSON.stringify(addSessionParams({Type:'All'}));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PhaLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});	
	var RecLocParams=JSON.stringify(addSessionParams({Type:'All'}));
	var RecLocBox = $HUI.combobox('#RecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+RecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});	
	var WaysBox = $HUI.combobox('#Ways', {
		data:[{'RowId':'0','Description':'ȫ��'},{'RowId':'1','Description':'ת��ת��̨��'},{'RowId':'2','Description':'ҽ��̨��'},{'RowId':'3','Description':'ȫ��(���ڳ�������)'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var SourceOfFundParams = JSON.stringify(addSessionParams());
	var SourceOfFundBox = $HUI.combobox('#SourceOfFund', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params='+SourceOfFundParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	$('#ScgStk').stkscgcombotree({
	onSelect:function(node){
		$.cm({
			ClassName:'web.DHCSTMHUI.Common.Dicts',
			QueryName:'GetStkCat',
			ResultSetType:'array',
			StkGrpId:node.id
		},function(data){
			StkCatBox.clear();
			StkCatBox.loadData(data);
			})
		}
	})
	var StkCatBox = $HUI.combobox('#StkCat', {
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams=function(){
		var Scg=$("#ScgStk").combotree('getValue');
		var Loc=$("#PhaLoc").combo('getValue');
		var Obj={StkGrpRowId:Scg,StkGrpType:"M",Locdr:Loc};
		return Obj
	}
	$("#InciDesc").lookup(InciLookUpOp(HandlerParams,'#InciDesc','#Inci'));
	$('#ScgStk').combotree({
		onChange:function(newValue, oldValue){
			StkCatBox.clear();
			var url=$URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId='+newValue;
            StkCatBox.reload(url);
		}
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
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
	var INFOImportFlagBox = $HUI.combobox('#INFOImportFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'����','Description':'����'},{'RowId':'����','Description':'����'},{'RowId':'����','Description':'����'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var PublicBiddingBox = $HUI.combobox('#PublicBidding', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'0','Description':'���б�'},{'RowId':'1','Description':'�б�'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var PBLevelParams = JSON.stringify(addSessionParams());
	var INFOPBLevelBox = $HUI.combobox('#INFOPBLevel', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPBLevel&ResultSetType=array&Params='+PBLevelParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var InsuTypeBox = $HUI.combobox('#InsuType', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInsuCat&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
	});
	var INFOMTBox = $HUI.combobox('#INFOMT', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description'
	});
	var OperateOutTypeParams=JSON.stringify(addSessionParams({Type:"OM"}));
	var OperateOutTypeBox = $HUI.combobox('#OperateOutType', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=array&Params='+OperateOutTypeParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#Conditions')
			if(isEmpty(ParamsObj.RecLoc)){
				$UI.msg('alert','��ѡ��ҽ������');
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
	function CheckedUrl(Checked,Params){
		//��Ʒ����
		if('FlagSum'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_TKPYStat_Sum.raq&Params='+Params;
		}
		//�����൥Ʒ����
		else if('FlagStkCatInci'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_TKPYStat_StkCatInci.raq&Params='+Params;
		}
		//��Ʒ��ϸ
		else if('FlagDetail'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_TKPYStat_InciDetail.raq&Params='+Params;
		}
		//���������
		else if('FlagType'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_TKPYStat_StkCat.raq&Params='+Params;
		}		
		else{
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_TKPYStat_Sum.raq&Params='+Params;
		}	
		
		return p_URL;
	}
	function AddTab(title, url) {
		if ($('#tabs').tabs('exists', title)) {
			$('#tabs').tabs('select', title); //ѡ�в�ˢ��
			var currTab = $('#tabs').tabs('getSelected');
//			var url = $(currTab.panel('options').content).attr('src');
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
		var s = '<iframe scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:100%;"></iframe>';
		return s;
	}	
	$UI.linkbutton('#ClearBT',{
		onClick:function(){
			Clear()
		}
	});
	Clear()	
}
$(init);
