/**
 * 名称:   	 药房药库-采购计划执行情况统计
 * 编写人:   liubeibei
 * 编写日期: 2022-05-06
 */
$(function() {	
  	$("#report").keywords({
	  	singleSelect:true,
       	items:[{
			text: '计划与入库数量对照报表', 
			id: "PHAIN_PlanExet_PurPlan_IngrCompare" , 
			reportName: 'PHAIN_PlanExet_PurPlan_IngrCompare.rpx', 
			selected: true
		}, {
			text: '计划评估报告单', 
			id: "PHAIN_PlanExet_PurPlan_PlanAssess" , 
			reportName: 'PHAIN_PlanExet_PurPlan_PlanAssess.rpx'
		}]
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
	PHA.ComboBox('queryFlag', {
		placeholder: '统计标志...',   
	   	data: [
	        {
	            RowId: '0',
	            Description: $g("计划>实际")
	        },
	        {
	            RowId: '1',
	            Description: $g("计划=实际")
	        },
	        {
	            RowId: '2',
	            Description: $g("计划<实际")
	        }]
	});

	// 初始值
	InitConditionVal();
}
function InitConditionVal(){
	$('#startDate').datebox('setValue',PHA_UTIL.SysDate('t'));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate('t'));
	PHA.SetComboVal('phaLoc', session['LOGON.CTLOCID']);
	PHA.SetComboVal('queryFlag', 0);
	$("#report").keywords('select', 'PHAIN_PlanExet_PurPlan_IngrCompare');
}

function Query(){
	var reportObj = $('#report').keywords('getSelected');
	var title = reportObj[0].text;
	var queryId = reportObj[0].id;

	var formData = GetCondition();
	var InputStr = JSON.stringify(formData);
	var LocDesc = $('#phaLoc').combobox('getText');

	STAT_COM.QueryRep(title, queryId, {InputStr: InputStr, LocDesc: LocDesc});
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
	// 清空选中报表类型
	$('#report').keywords('clearAllSelected');
}