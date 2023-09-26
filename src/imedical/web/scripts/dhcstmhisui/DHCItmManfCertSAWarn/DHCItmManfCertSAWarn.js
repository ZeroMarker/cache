//����: ��Ӧ�����ʱ���
var init = function() {
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		var Dafult={			
			EndDate:new Date()
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
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var ManfParams=JSON.stringify(addSessionParams({StkType:"M"}));
	var ManfBox = $HUI.combobox('#Manf', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='+ManfParams,
		valueField: 'RowId',
		textField: 'Description'
	});	
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#Conditions')
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','���ʽ�ֹ���ڲ���Ϊ��!');
				return;
			}
			var Params=JSON.stringify(addSessionParams(ParamsObj));
			Params=encodeUrlStr(Params)
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue=CheckedRadioObj.val();
			var CheckedTitle=CheckedRadioObj.attr("label")
			var Url=CheckedUrl(CheckedValue,Params)
			AddTab(CheckedTitle,Url);

		}	
	});	
	function CheckedUrl(Checked,Params){
		//���ʱ�����ϸ
		if('FlagDetail'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ItmManfCertSADetail.raq&Params='+Params;
		}
		//��������
		else if('FlagManf'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ItmManfCertSAManf.raq&Params='+Params;
		}
		//��Ӧ������
		else if('FlagVend'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ItmManfCertSAVend.raq&Params='+Params;
		}
		//��������
		else if('FlagSDetail'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ItmManfCertSASDetail.raq&Params='+Params;
		}
		//������������
		else if('FlagSManf'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ItmManfCertSASManf.raq&Params='+Params;
		}

		//������Ӧ������
		else if('FlagSVend'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ItmManfCertSASVend.raq&Params='+Params;
		}		
		else{
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ItmManfCertSADetail.raq&Params='+Params;
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