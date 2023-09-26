/*付款月报明细查询*/
var init = function () {
	var growid='';
	function GetParamsObj(){
		var ParamsObj=$UI.loopBlock('#PayMonTabConditions');
		return ParamsObj;
	}
	
	var PayMonLocParams=JSON.stringify(addSessionParams({Type:"Login"}));
	var PayMonLocBox = $HUI.combobox('#HistoryPayMonStatLoc', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params='+PayMonLocParams,
			valueField: 'RowId',
			textField: 'Description'
	});
	var StkCatBox = $HUI.combobox('#StkCatBox', {
			valueField: 'RowId',
			textField: 'Description'
	});
	$('#StkGrpId').stkscgcombotree({
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
	$HUI.tabs("#PayMonTab",{
		onSelect:function(title){
			var row = HistoryPayMonStatGrid.getSelected();
			if (isEmpty(row)){return false;}
			growid=row.pmRowid;
			if (title == "付款月报汇总(供应商)")
			{
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_PayMDetailRp.raq'
					+"&growid="+growid;
				var reportFrame=document.getElementById("frameReportPayMonDetail");
				reportFrame.src=p_URL;
				
			}	
			if (title == "付款月报明细(供应商分类)")
			{
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_PayMLBDetailRp.raq'
					+"&growid="+growid;
				var reportFrame=document.getElementById("frameReportPayMonVenCatDetail");
				reportFrame.src=p_URL;
				
			}		
		}
	});
	var HistoryPayMonStatCm = [[
		{
			title: 'pmRowid',
			field: 'pmRowid',
			width:100,
			hidden: true
		}, {
			title: '科室',
			field: 'locDesc',
			width: 230,
			align : 'left'
		}, {
	        	title: "月份",
	       		field:'MonthDate',
	        	width: 100,
			align : 'left'
		}, {
			title : "月报起始日期",
			field : 'frDate',
			width : 100,
			align : 'left'
		}, {
		        title:"月报截止日期",
		        field:'toDate',
		        width: 100,
			align : 'left'
		}		
	]];
	var HistoryPayMonStatGrid = $UI.datagrid('#HistoryPayMonStatGrid', {
		url:'',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			QueryName: 'DHCPayMon'
		},
		columns: HistoryPayMonStatCm,
		sortName: 'RowId',  
		sortOrder: 'Desc',
		onSelect:function(index, row){
			growid = row.pmRowid;
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_HUI_PayMDetailRp.raq'
				+"&growid="+growid;
			var reportFrame=document.getElementById("frameReportPayMonDetail");
			reportFrame.src=p_URL;
		}
	})
	$UI.linkbutton('#PrintBT',{
		onClick:function(){
			var activeTabtmp=$('#PayMonTab').tabs('getSelected').panel('options').title;
			PrintPayMon(growid,activeTabtmp);
		}
	});
	$UI.linkbutton('#SearchBT',{
		onClick:function(){
			QueryHistoryPayMonStat();
		}
	});
	function QueryHistoryPayMonStat(){
		var ParamsObj=$UI.loopBlock('#HistoryPayMonStatConditions');
		if(isEmpty(ParamsObj.HistoryPayMonStatLoc)){
			$UI.msg('alert','科室不能为空!');
			return false;
		}	
		var StYear=ParamsObj.StYear;
		var StMonth=ParamsObj.StMonth;
		var EdYear=ParamsObj.EdYear;
		var EdMonth=ParamsObj.EdMonth;
		var StartDate="";
		var EndDate="";
		if ((!isEmpty(StYear))&&(!isEmpty(StMonth))&&(!isEmpty(EdYear))&&(!isEmpty(EdMonth)))
		{
			var StartDate=StYear+'-'+StMonth+'-'+'01';
			var EndDate=EdYear+'-'+EdMonth+'-'+'01';
		}
		$UI.setUrl(HistoryPayMonStatGrid);
		HistoryPayMonStatGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			QueryName: 'DHCPayMon',
			loc:ParamsObj.HistoryPayMonStatLoc,
			StartDate:StartDate,
			EndDate:EndDate
		});
	}
	function ClearHistoryPayMonStat(){
		$UI.clearBlock('#HistoryPayMonStatConditions');
		$UI.clear(HistoryPayMonStatGrid);
		///设置初始值 考虑使用配置
		var Dafult={
					HistoryPayMonStatLoc : gLocObj
					}
		$UI.fillBlock('#HistoryPayMonStatConditions',Dafult);
	}
	ClearHistoryPayMonStat();
}
$(init);