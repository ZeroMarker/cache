//名称: 台账单品明细统计
var init = function() {
	var Clear=function(){
		$UI.clearBlock('#Conditions');
		var Dafult={
			StartDate: DateFormatter(new Date()),
			EndDate:DateFormatter(new Date()),
			PhaLoc:gLocObj
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
	var PhaLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PhaLocParams,
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
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function(){
		var StkGrpId = $('#ScgStk').combotree('getValue');
		var PhaLoc = $('#PhaLoc').combo('getValue');
		var Obj = {StkGrpRowId:StkGrpId, StkGrpType:'M', Locdr:PhaLoc};
		return Obj;
	}
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	$UI.linkbutton('#QueryBT',{
		onClick:function(){			
			var ParamsObj=$UI.loopBlock('#Conditions')
			if(isEmpty(ParamsObj.PhaLoc)){
			$UI.msg('alert','科室不能为空!');
			return;
			}	
			if(isEmpty(ParamsObj.StartDate)){
				$UI.msg('alert','开始日期不能为空!');
				return;
			}
			if(isEmpty(ParamsObj.EndDate)){
				$UI.msg('alert','截止日期不能为空!');
				return;
			}
			if(isEmpty(ParamsObj.InciDesc)){
				$UI.msg('alert','物资名称不能为空!');
				return;
			}
			
			var Params=JSON.stringify(ParamsObj);
			Params=encodeUrlStr(Params)
			var Conditions=GetConditions(ParamsObj)
			var p_URL= PmRunQianUrl+'?reportName=DHCSTM_HUI_LocItmStkMoveStat.raq&Params='+Params+'&Conditions='+Conditions;
			var reportFrame=document.getElementById("TransDetailIFrame");
			reportFrame.src=p_URL;
		}	
	});
	function GetConditions(ParamsObj){
		//获取查询条件列表
		var Conditions=""
		if(ParamsObj.InciDesc!=""){
			Conditions=Conditions+" 材料名: "+ParamsObj.InciDesc;
		}
		if(ParamsObj.StartDate!=""){
			Conditions=Conditions+"  开始时间 "+ParamsObj.StartDate;
		}
		if(ParamsObj.EndDate!=""){
			Conditions=Conditions+"  截止时间 "+ParamsObj.EndDate;
		} 
		return Conditions;
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