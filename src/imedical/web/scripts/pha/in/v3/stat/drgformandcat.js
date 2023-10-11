/**
 * ����:   	 ҩ��ҩ��-ҩ����ҩ����ͳ��
 * ��д��:   liubeibei
 * ��д����: 2022-08-16
 */
$(function() {	
	$("#report").keywords({
		singleSelect:true,
		 items:[
        {
				  text: $g('��ҩ��ͳ��'), 
				  id: "PHAIN_DrgFormAndCat_DrgCat" , 
				  reportName: 'PHAIN_DrgFormAndCat_DrgCat.rpx', 
				  selected:true
			  }, {
				  text: $g('������ͳ��'), 
				  id: "PHAIN_DrgFormAndCat_DrgForm" , 
				  reportName: 'PHAIN_DrgFormAndCat_DrgForm.rpx'
			  }
		  ]
	})
  InitDict();
  InitEvents();
});

// ��ʼ�� - �¼���
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

// ��ȡ��
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

// ��ȡ��
function ClearCondition(){
  PHA.DomData("#div-conditions", {
	  doType: 'clear'
  });
  $('#report').keywords('clearAllSelected');
}