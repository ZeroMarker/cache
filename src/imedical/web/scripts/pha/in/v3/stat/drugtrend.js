/**
 * ����:   	 ҩ��ҩ��-ҩƷʹ������ͳ��
 * ��д��:   liubeibei
 * ��д����: 2023-04-12
 */
$(function() {	
	$("#report").keywords({
		singleSelect:true,
		 items:[
		  {
			  text: $g('����ͳ��'), 
			  id: "PHAIN_DrugTrend_DrugUseByDay" , 
			  reportName: 'PHAIN_DrugTrend_DrugUseByDay.rpx', 
			  selected:true
		  }, {
			  text: $g('����ͳ��'), 
			  id: "PHAIN_DrugTrend_DrugUseByMonth" , 
			  reportName: 'PHAIN_DrugTrend_DrugUseByMonth.rpx'
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
  
  PHA_UX.ComboBox.Loc('phaLoc');

  // ҩƷ�������
   PHA_UX.ComboGrid.INCItm('inci', {
	  width: 160,
	  placeholder: 'ҩƷ...'
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
  return formData;
}

// ��ȡ��
function ClearCondition(){
  PHA.DomData("#div-conditions", {
	  doType: 'clear'
  });
  $('#report').keywords('clearAllSelected');
  $('#inci').combogrid('grid').datagrid('clear');
}