//名称: 全院库存查询

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
                if(Title!='报表'){
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
		data:[{'RowId':'0','Description':'全部'},{'RowId':'1','Description':'库存为零'},{'RowId':'2','Description':'库存为正'},{'RowId':'3','Description':'库存为负'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var INFOImportFlagBox = $HUI.combobox('#INFOImportFlag', {
		data:[{'RowId':'全部','Description':'全部'},{'RowId':'国产','Description':'国产'},{'RowId':'进口','Description':'进口'},{'RowId':'合资','Description':'合资'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var UseFlagBox = $HUI.combobox('#UseFlag', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'Y','Description':'可用'},{'RowId':'N','Description':'不可用'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var HVFlagBox = $HUI.combobox('#HVFlag', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'Y','Description':'高值'},{'RowId':'N','Description':'非高值'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ChargeFlagBox = $HUI.combobox('#ChargeFlag', {
		data:[{'RowId':'','Description':'全部'},{'RowId':'Y','Description':'收费'},{'RowId':'N','Description':'不收费'}],
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT',{
		onClick:function(){
			var ParamsObj=$UI.loopBlock('#Conditions')
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','日期不能为空!');
				return;
			}
			if(isEmpty(ParamsObj.StockType)){
				$UI.msg('alert','类型不能为空!');
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
		//批次明细
		if('FlagInclb'==Checked){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_LocItmStkAll_Inclb.raq&Params='+Params+'&stkDate='+StartDate;
		}
		//单品汇总
		else if('FlagInci'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_LocItmStkAll_Inci.raq&Params='+Params+'&stkDate='+StartDate;
		}
		//单品科室汇总
		else if('FlagIncil'==Checked){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_LocItmStkAll_Incil.raq&Params='+Params+'&stkDate='+StartDate;
		}
		//科室汇总
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