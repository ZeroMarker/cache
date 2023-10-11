/**
 * 名称:   	 药房药库-库存报损统计报表
 * 编写人:   liubeibei
 * 编写日期: 2022-04-19
 */
$(function() {	
  	$("#report").keywords({
	  	singleSelect:true,
       	items:[{
			text: '库存报损统计', 
			id: "PHAIN_ScrapAmount_ScrapDetail" , 
			reportName: 'PHAIN_ScrapAmount_ScrapDetail.rpx', 
			selected: true
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
			
	//类组
	PHA_UX.ComboBox.StkCatGrp('stkGrpType' ,{
		multiple: true,
		rowStyle: 'checkbox',
		qParams: {
			LocId: PHA_UX.Get('phaLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	})

	// 药品下拉表格
	PHA_UX.ComboGrid.INCItm('inci', {
		width: 160, 
		placeholder: '药品...'
	});
	
	PHA.ComboBox('scrapReason', {
		placeholder: '报损原因...',   
	   	url: PHA_IN_STORE.ReasonForScrap().url
	});

	// 初始值
	InitConditionVal();
}
function InitConditionVal(){
	$('#startDate').datebox('setValue',PHA_UTIL.SysDate('t'));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate('t'));
	PHA.SetComboVal('phaLoc', session['LOGON.CTLOCID']);
	$("#report").keywords('select', 'PHAIN_ScrapAmount_ScrapDetail');
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