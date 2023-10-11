/**
 * 名称:   	 基药与管制药品统计
 * 编写人:   liubeibei
 * 编写日期: 2022-09-07
 */
$(function() {	
	$("#report").keywords({
		singleSelect:true,
		 items:[
			  {
				  text: $g('逐日消耗(本科室)'), 
				  id: "PHAIN_BasicAndPoison_Poison" , 
				  reportName: 'PHAIN_BasicAndPoison_Poison.rpx', 
				  selected:true
			  }, {
				  text: $g('处方统计(本科室)'), 
				  id: "PHAIN_BasicAndPoison_PoisonDetail" , 
				  reportName: 'PHAIN_BasicAndPoison_PoisonDetail.rpx'
			  }, {
				  text: $g('门诊基本药物占比'), 
				  id: "PHAIN_BasicAndPoison_BasiOut" , 
				  reportName: 'PHAIN_BasicAndPoison_BasiOut.rpx'
			  }, {
				  text: $g('住院基本药物占比'), 
				  id: "PHAIN_BasicAndPoison_BasiIn" , 
				  reportName: 'PHAIN_BasicAndPoison_BasiIn.rpx'
			  }
		  ]
	})
  InitDict();
  InitEvents();
  InitConditionVal();
});

// 初始化 - 事件绑定
function InitEvents(){
  $('#btnFind').on("click", Query);
  $('#btnClear').on("click", Clear);
}

function InitDict(){
  PHA.ComboBox("poisonIdStr", {
	  placeholder: '管制分类...',
	  url: PHA_STORE.PHCPoison().url,
	  multiple: false,
	  selectOnNavigation: false,
	  onLoadSuccess: function(data){
		  var thisOpts = $('#poisonIdStr').combobox('options');
		  thisOpts.isLoaded = true;
	  }
  });
  PHA_UX.ComboGrid.INCItm('inci', {
	  width: 160,
	  qParams: {
		  pJsonStr: {
			  stkType: App_StkType,
			  scgId: '',
			  locId: session['LOGON.CTLOCID']
		  }
	  }
  }); 
}
function InitConditionVal(){
  $('#startDate').datebox('setValue',PHA_UTIL.SysDate('t'));
  $('#endDate').datebox('setValue', PHA_UTIL.SysDate('t'));
  $("#report").keywords('select', 'PHAIN_BasicAndPoison_Poison');
}

function Query(){
  var reportObj = $('#report').keywords('getSelected');
  var title = reportObj[0].text;
  var queryId = reportObj[0].id;
  var poisonDesc = $('#poisonIdStr').combobox('getText');
  var formData = GetCondition();
  if (formData === null){
    return;
  }
  if((queryId === "PHAIN_BasicAndPoison_Poison") || (queryId === "PHAIN_BasicAndPoison_PoisonDetail"))
  {
    if(formData.poisonIdStr === "")
    {
      PHA.Popover({
        msg: '管制分类不能为空',
        type: 'alert',
        style: {
            top: 20,
            left: ''
        }
    });
    return [];
    }

  }
 
  formData.hospId = session['LOGON.HOSPID'];
  formData.locId = session['LOGON.CTLOCID'];
  formData.flag = queryId

  var InputStr = JSON.stringify(formData);
  STAT_COM.QueryRep(title, queryId, {InputStr: InputStr, PoisonDesc: poisonDesc})
}
  
function Clear(){
  ClearCondition();   
  STAT_COM.ClearRep();
  InitConditionVal();
}

// 获取表单
function GetCondition(){
  // 参数
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
}
