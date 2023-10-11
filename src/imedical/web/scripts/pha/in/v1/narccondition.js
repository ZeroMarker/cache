/**
 * 名称:   	 毒麻药品统计条件
 * 编写人:   Huxt
 * 编写日期: 2021-01-15
 * csp:		 pha.in.v1.narccondition.csp
 * js:		 pha/in/v1/narccondition.js
 */

// 初始化条件
function InitCondition(){
	PHA.ComboBox("dateType", {
		placeholder: '日期...',
		data: [
			{RowId: 'RegDate', Description: $g('按登记日期')},
			{RowId: 'DspAddDate', Description: $g('按开医嘱日期')},
			{RowId: 'DosingDate', Description: $g('按预计用药日期')},
			{RowId: 'DispDate', Description: $g('按发药日期')}
		],
		panelHeight: 'auto',
		editable: false
	});
	PHA.ComboBox("regLocId", {
		placeholder: '登记科室...',
		url: PHA_STORE.CTLoc().url
	});
	PHA.ComboBox("recLocId", {
		placeholder: '回收科室...',
		url: PHA_STORE.CTLoc().url
	});
	PHA.ComboBox("phLocId", {
		placeholder: '发药科室...',
		url: PHA_STORE.CTLoc().url + "&TypeStr=D"
	});
	PHA.ComboBox("docLocId", {
		placeholder: '开单科室...',
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboBox("wardLocId", {
		placeholder: '病区...',
		url: PHA_STORE.CTLoc().url + "&TypeStr=W"
	});
	PHA.ComboBox("stkCatId", {
		placeholder: '库存分类...',
		url: PHA_STORE.INCStkCat().url
	});
	PHA.ComboBox("poisonIdStr", {
		placeholder: '管制分类...',
		url: PHA_STORE.PHCPoison().url,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false,
		onLoadSuccess: function(data){
			var thisOpts = $('#poisonIdStr').combobox('options');
			thisOpts.isLoaded = true;
		}
	});
	PHA.ComboBox("admType", {
		placeholder: '就诊类型...',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=AdmType'
	});
	PHA.ComboBox("oeoreState", {
		placeholder: '执行记录状态...',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=OEOREStatus'
	});
	PHA.ComboBox("dspState", {
		placeholder: '发药状态...',
		data: [
			{RowId: 'Y', Description: $g('已发药')},
			{RowId: 'N', Description: $g('未发药')}
		],
		panelHeight: 'auto'
	});
	// 药品下拉
	var inciOptions = PHA_STORE.INCItm();
	inciOptions.url = $URL;
	inciOptions.width = 160;
	inciOptions.placeholder = '药品名称...';
	PHA.ComboGrid("inci", inciOptions);
	// 初始值
	InitConditionVal();
}
function InitConditionVal(){
	PHA.SetComboVal('dateType', 'RegDate');
	PHA.SetComboVal('recLocId', session['LOGON.CTLOCID']);
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
	InitConditionVal();
}