/**
 * 名称:   	 药房药库-退货汇总统计报表
 * 编写人:   liubeibei
 * 编写日期: 2022-03-30
 */
$(function() {	
  	$("#report").keywords({
	  	singleSelect: true,
       	items:[{
			text: '退货单明细', 
			id: "PHAIN_SumRet_RetDetail_Itm" , 
			reportName: 'PHAIN_SumRet_RetDetail_Itm.rpx', 
			selected: true
		}, {
			text: '退货单汇总', 
			id: "PHAIN_SumRet_RetDetail_Sum" , 
			reportName: 'PHAIN_SumRet_RetDetail_Sum.rpx'
		}, {
			text: '退货单品汇总', 
			id: "PHAIN_SumRet_RetDetail_Inci" , 
			reportName: 'PHAIN_SumRet_RetDetail_Inci.rpx'
		}, {
			text: '经营企业汇总', 
			id: "PHAIN_SumRet_RetDetail_Vendor" , 
			reportName: 'PHAIN_SumRet_RetDetail_Vendor.rpx'
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
		
	PHA.ComboBox("vendor", {
		placeholder: '经营企业...',
		url: PHA_STORE.APCVendor().url
	});
	
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

	
	PHA.ComboBox('retReason', {
		placeholder: '退货原因...',   
	   	url: PHA_IN_STORE.ReasonForReturn().url
	});

	// 初始值
	InitConditionVal();
}
function InitConditionVal(){
	$('#startDate').datebox('setValue',PHA_UTIL.SysDate('t'));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate('t'));
	PHA.SetComboVal('phaLoc', session['LOGON.CTLOCID']);
	$("#report").keywords('select', 'PHAIN_SumRet_RetDetail_Itm');
}

function Query(){
	var reportObj = $('#report').keywords('getSelected');
	var title = reportObj[0].text;
	var queryId = reportObj[0].id;

	var formData = GetCondition();
	formData.parType = queryId;	
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
	$('#report').keywords('clearAllSelected');
}