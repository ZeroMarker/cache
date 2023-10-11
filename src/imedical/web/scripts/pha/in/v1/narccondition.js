/**
 * ����:   	 ����ҩƷͳ������
 * ��д��:   Huxt
 * ��д����: 2021-01-15
 * csp:		 pha.in.v1.narccondition.csp
 * js:		 pha/in/v1/narccondition.js
 */

// ��ʼ������
function InitCondition(){
	PHA.ComboBox("dateType", {
		placeholder: '����...',
		data: [
			{RowId: 'RegDate', Description: $g('���Ǽ�����')},
			{RowId: 'DspAddDate', Description: $g('����ҽ������')},
			{RowId: 'DosingDate', Description: $g('��Ԥ����ҩ����')},
			{RowId: 'DispDate', Description: $g('����ҩ����')}
		],
		panelHeight: 'auto',
		editable: false
	});
	PHA.ComboBox("regLocId", {
		placeholder: '�Ǽǿ���...',
		url: PHA_STORE.CTLoc().url
	});
	PHA.ComboBox("recLocId", {
		placeholder: '���տ���...',
		url: PHA_STORE.CTLoc().url
	});
	PHA.ComboBox("phLocId", {
		placeholder: '��ҩ����...',
		url: PHA_STORE.CTLoc().url + "&TypeStr=D"
	});
	PHA.ComboBox("docLocId", {
		placeholder: '��������...',
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboBox("wardLocId", {
		placeholder: '����...',
		url: PHA_STORE.CTLoc().url + "&TypeStr=W"
	});
	PHA.ComboBox("stkCatId", {
		placeholder: '������...',
		url: PHA_STORE.INCStkCat().url
	});
	PHA.ComboBox("poisonIdStr", {
		placeholder: '���Ʒ���...',
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
		placeholder: '��������...',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=AdmType'
	});
	PHA.ComboBox("oeoreState", {
		placeholder: 'ִ�м�¼״̬...',
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=OEOREStatus'
	});
	PHA.ComboBox("dspState", {
		placeholder: '��ҩ״̬...',
		data: [
			{RowId: 'Y', Description: $g('�ѷ�ҩ')},
			{RowId: 'N', Description: $g('δ��ҩ')}
		],
		panelHeight: 'auto'
	});
	// ҩƷ����
	var inciOptions = PHA_STORE.INCItm();
	inciOptions.url = $URL;
	inciOptions.width = 160;
	inciOptions.placeholder = 'ҩƷ����...';
	PHA.ComboGrid("inci", inciOptions);
	// ��ʼֵ
	InitConditionVal();
}
function InitConditionVal(){
	PHA.SetComboVal('dateType', 'RegDate');
	PHA.SetComboVal('recLocId', session['LOGON.CTLOCID']);
}

// ��ȡ��
function GetCondition(){
	// ����
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
	InitConditionVal();
}