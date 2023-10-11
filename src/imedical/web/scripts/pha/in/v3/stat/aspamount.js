/**
 * 名称:   	 药房药库-调价损益统计报表
 * 编写人:   liubeibei
 * 编写日期: 2022-04-08
 */
 var App_Name = "DHCSTCOMMON"
 var App_Store = PHA_COM.ParamProp(App_Name)

$(function() {	
  	$("#report").keywords({
	  	singleSelect:true,
        items:[{
			text: '单品汇总', 
			id: "PHAIN_AspAmount_AspDetail_Inc" , 
			reportName: 'PHAIN_AspAmount_AspDetail_Inc.rpx', 
			selected: true
		}, {
			text: '单品科室汇总', 
			id: "PHAIN_AspAmount_AspDetail_IncLoc" , 
			reportName: 'PHAIN_AspAmount_AspDetail_IncLoc.rpx'
		}, {
			text: '经营企业汇总', 
			id: "PHAIN_AspAmount_AspDetail_Vendor" , 
			reportName: 'PHAIN_AspAmount_AspDetail_Vendor.rpx'
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
		url: PHA_STORE.APCVendor().url,
		panelWidth: 200
	});
	
	// 药品下拉表格
	PHA_UX.ComboGrid.INCItm('inci', {
		placeholder: '药品...',
		width: 160
	});
	
	PHA.ComboBox('diffType', {
		placeholder: '损益差额...', 
	    data: [
	        {
	            RowId: "0",
	            Description: $g('全部')
	        },
	        {
	            RowId: "1",
	            Description: $g('差额为正')
	        },
	        {
	            RowId: "-1",
	            Description: $g('差额为负')
	        }
	    ],
	    panelHeight: 'auto'
	});
	// 初始值
	InitConditionVal();
}
function InitConditionVal(){
	$('#startDate').datebox('setValue',PHA_UTIL.SysDate('t'));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate('t'));
	PHA.SetComboVal('phaLoc', '');
	$("#report").keywords('select', 'PHAIN_AspAmount_AspDetail_Inc');
}

function Query(){
	var reportObj = $('#report').keywords('getSelected');
	var title = reportObj[0].text;
	var queryId = reportObj[0].id;
	var formData = GetCondition();
	formData.rpRule = App_Store.RpRule;
	formData.parType = queryId;
	formData.hospId = session['LOGON.HOSPID'];
	var InputStr = JSON.stringify(formData);

	STAT_COM.QueryRep(title, queryId, {InputStr: InputStr});
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