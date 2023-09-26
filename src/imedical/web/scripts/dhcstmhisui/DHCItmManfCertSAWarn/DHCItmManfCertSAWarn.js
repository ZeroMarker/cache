//名称: 供应链资质报警
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
                if(Title!='报表'){
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
				$UI.msg('alert','资质截止日期不能为空!');
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
		//资质报警明细
		if('FlagDetail'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ItmManfCertSADetail.raq&Params='+Params;
		}
		//厂商资质
		else if('FlagManf'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ItmManfCertSAManf.raq&Params='+Params;
		}
		//供应商资质
		else if('FlagVend'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ItmManfCertSAVend.raq&Params='+Params;
		}
		//单独物资
		else if('FlagSDetail'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ItmManfCertSASDetail.raq&Params='+Params;
		}
		//单独厂商资质
		else if('FlagSManf'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_ItmManfCertSASManf.raq&Params='+Params;
		}

		//单独供应商资质
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
			$('#tabs').tabs('select', title); //选中并刷新
			var currTab = $('#tabs').tabs('getSelected');
//			var url = $(currTab.panel('options').content).attr('src');
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