/**
 * 名称:   	 药房药库-药品使用趋势统计
 * 编写人:   liubeibei
 * 编写日期: 2023-04-12
 */
$(function() {	
	$("#report").keywords({
		singleSelect:true,
		 items:[
		  {
			  text: $g('按日统计'), 
			  id: "PHAIN_DrugTrend_DrugUseByDay" , 
			  reportName: 'PHAIN_DrugTrend_DrugUseByDay.rpx', 
			  selected:true
		  }, {
			  text: $g('按月统计'), 
			  id: "PHAIN_DrugTrend_DrugUseByMonth" , 
			  reportName: 'PHAIN_DrugTrend_DrugUseByMonth.rpx'
		  }
	   ]
	})
  InitDict();
  InitEvents();
});

// 初始化 - 事件绑定
function InitEvents(){
  $('#btnFind').on("click", Query);
  $('#btnClear').on("click", Clear);
}

function InitDict(){
  
  PHA_UX.ComboBox.Loc('phaLoc');

  // 药品下拉表格
   PHA_UX.ComboGrid.INCItm('inci', {
	  width: 160,
	  placeholder: '药品...'
  });

  InitConditionVal();
}
function InitConditionVal(){
  $('#startDate').datebox('setValue',PHA_UTIL.SysDate('t'));
  $('#endDate').datebox('setValue', PHA_UTIL.SysDate('t'));
  PHA.SetComboVal('phaLoc', session['LOGON.CTLOCID']);
  $("#report").keywords('select', 'PHAIN_DrugTrend_DrugUseByDay');
}

function Query(){
  var reportObj = $('#report').keywords('getSelected');
  var title = reportObj[0].text;
  var queryId = reportObj[0].id;
  var InputStr = GetCondition();

  STAT_COM.QueryRep(title, queryId, {InputStr: InputStr});
}

function Clear(){	
  ClearCondition();	
  STAT_COM.ClearRep();
  InitConditionVal();
}

// 获取表单
function GetCondition(){
  var formDataArr = PHA.DomData("#div-conditions", {
	  doType: 'query',
	  retType: 'Json'
  });
  if (formDataArr.length == 0) {
	  return null;
  }
  var formData = formDataArr[0];
  return formData;
}

// 获取表单
function ClearCondition(){
  PHA.DomData("#div-conditions", {
	  doType: 'clear'
  });
  $('#report').keywords('clearAllSelected');
  $('#inci').combogrid('grid').datagrid('clear');
}