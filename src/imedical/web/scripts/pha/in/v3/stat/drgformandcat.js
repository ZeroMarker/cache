/**
 * 名称:   	 药房药库-药理用药分析统计
 * 编写人:   liubeibei
 * 编写日期: 2022-08-16
 */
$(function() {	
	$("#report").keywords({
		singleSelect:true,
		 items:[
        {
				  text: $g('按药理统计'), 
				  id: "PHAIN_DrgFormAndCat_DrgCat" , 
				  reportName: 'PHAIN_DrgFormAndCat_DrgCat.rpx', 
				  selected:true
			  }, {
				  text: $g('按剂型统计'), 
				  id: "PHAIN_DrgFormAndCat_DrgForm" , 
				  reportName: 'PHAIN_DrgFormAndCat_DrgForm.rpx'
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
  InitConditionVal();
}
function InitConditionVal(){
  $('#startDate').datebox('setValue',PHA_UTIL.SysDate('t'));
  $('#endDate').datebox('setValue', PHA_UTIL.SysDate('t'));
  $("#report").keywords('select', 'PHAIN_DrgFormAndCat_DrgCat');
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
  return JSON.stringify(formData);
}

// 获取表单
function ClearCondition(){
  PHA.DomData("#div-conditions", {
	  doType: 'clear'
  });
  $('#report').keywords('clearAllSelected');
}