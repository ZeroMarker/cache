//����: ȫԺ����ѯ

var init = function() {
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		var Dafult={StartDate:DateFormatter(new Date()),
			//PhaLoc:gLocObj,
			StockType:0
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
	var VendorParams=JSON.stringify(addSessionParams({APCType:"M",RcFlag:"Y"}));
	var VendorBox = $HUI.combobox('#Vendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params='+VendorParams,
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
	var ManfParams=JSON.stringify(addSessionParams({StkType:"M"}));
	var ManfBox = $HUI.combobox('#Manf', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params='+ManfParams,
		valueField: 'RowId',
		textField: 'Description'
	});	
	var ARCItemCatBox= $HUI.combobox('#ARCItemCatBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdSubCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var InsuTypeParams=JSON.stringify(addSessionParams());
	var InsuTypeBox = $HUI.combobox('#InsuType', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInsuCat&ResultSetType=array&Params='+InsuTypeParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var StockTypeBox = $HUI.combobox('#StockType', {
		data:[{'RowId':'0','Description':'ȫ��'},{'RowId':'1','Description':'���Ϊ��'},{'RowId':'2','Description':'���Ϊ��'},{'RowId':'3','Description':'���Ϊ��'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var INFOImportFlagBox = $HUI.combobox('#INFOImportFlag', {
		data:[{'RowId':'ȫ��','Description':'ȫ��'},{'RowId':'����','Description':'����'},{'RowId':'����','Description':'����'},{'RowId':'����','Description':'����'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var UseFlagBox = $HUI.combobox('#UseFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'Y','Description':'����'},{'RowId':'N','Description':'������'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var HVFlagBox = $HUI.combobox('#HVFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'Y','Description':'��ֵ'},{'RowId':'N','Description':'�Ǹ�ֵ'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ChargeFlagBox = $HUI.combobox('#ChargeFlag', {
		data:[{'RowId':'','Description':'ȫ��'},{'RowId':'Y','Description':'�շ�'},{'RowId':'N','Description':'���շ�'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#Conditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','���ڲ���Ϊ��!');
				return;
			}
			if(isEmpty(ParamsObj.StockType)){
				$UI.msg('alert','���Ͳ���Ϊ��!');
				return;
			}
			var Params=JSON.stringify(ParamsObj);
			Params=encodeUrlStr(Params)
			var StartDate=ParamsObj.StartDate;
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue=CheckedRadioObj.val();
			var CheckedTitle=CheckedRadioObj.attr("label")
			var Url=CheckedUrl(CheckedValue,Params,StartDate)
			AddTab(CheckedTitle,Url);

		}	
	});	
	
	function CheckedUrl(Checked,Params,StartDate){
		//������ϸ
		if('FlagInclb'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_LocItmStkAll_Inclb.raq&Params='+Params+'&stkDate='+StartDate;
		}
		//��Ʒ����
		else if('FlagInci'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_LocItmStkAll_Inci.raq&Params='+Params+'&stkDate='+StartDate;
		}
		//��Ʒ���һ���
		else if('FlagIncil'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_LocItmStkAll_Incil.raq&Params='+Params+'&stkDate='+StartDate;
		}
		//���һ���
		else if('FlagLocSum'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_LocItmStkAll_LocSum.raq&Params='+Params+'&stkDate='+StartDate;
		}
		else{
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_LocItmStkAll_Inci.raq&Params='+Params+'&stkDate='+StartDate;
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
		var s = '<iframe scrolling="auto" frameborder="0"  src="' + url + '" style="width:100%;height:98%;"></iframe>';
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