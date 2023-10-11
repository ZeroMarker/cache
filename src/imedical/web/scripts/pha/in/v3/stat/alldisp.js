/**
 * 名称:   	 药房药库-全院消耗统计报表
 * 编写人:   liubeibei
 * 编写日期: 2022-06-23
 */
$(function() {	
  	$("#report").keywords({
	  	singleSelect:true,
       	items:[
				{
					text: $g('按药品'), 
					id: "PHAIN_AllDisp_DispStat_Inci" , 
					reportName: 'PHAIN_AllDisp_DispStat_Inci.rpx', 
					selected:true
				}, {
					text: $g('按医生科室'), 
					id: "PHAIN_AllDisp_DispStat_DocLoc" , 
					reportName: 'PHAIN_AllDisp_DispStat_DocLoc.rpx'
				}, {
					text: $g('按经营企业'), 
					id: "PHAIN_AllDisp_DispStat_Vendor" , 
					reportName: 'PHAIN_AllDisp_DispStat_Vendor.rpx'
				}, {
					text: $g('按基本药物比例'), 
					id: "PHAIN_AllDisp_BasicStat" , 
					reportName: 'PHAIN_AllDisp_BasicStat.rpx'
				}, {
					text: $g('按剂型统计处方'), 
					id: "PHAIN_AllDisp_Phcform" , 
					reportName: 'PHAIN_AllDisp_Phcform.rpx'
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
	PHA.ComboBox('admType', {
		placeholder: '类型...', 
	    data: [
	        {
	            RowId: '0',
	            Description: $g('全部')
	        },
	        {
	            RowId: $g('O'),
	            Description: $g('门诊')
	        },
	        {
	            RowId: $g('I'),
	            Description: $g('住院')
	        }
	    ],
	    width: 160,
	    panelHeight: 'auto'
	});
	
	PHA_UX.ComboBox.Loc('phaLoc');
	PHA.ComboBox("executeLoc", {
		url: PHA_STORE.DocLoc().url,
		panelWidth: 160
	});
	PHA_UX.ComboGrid.INCItm('inci', {
		width: 160, 
		placeholder: '药品...'
	});
	InitConditionVal();
}
function InitConditionVal(){
  $('#startDate').datebox('setValue',PHA_UTIL.SysDate('t'));
  $('#endDate').datebox('setValue', PHA_UTIL.SysDate('t'));
  PHA.SetComboVal('admType', 0);
  PHA.SetComboVal('phaLoc', session['LOGON.CTLOCID']);
  $("#report").keywords('select', 'PHAIN_AllDisp_DispStat_Inci');
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
}