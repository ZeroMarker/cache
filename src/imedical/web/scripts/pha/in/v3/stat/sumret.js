/**
 * ����:   	 ҩ��ҩ��-�˻�����ͳ�Ʊ���
 * ��д��:   liubeibei
 * ��д����: 2022-03-30
 */
$(function() {	
  	$("#report").keywords({
	  	singleSelect: true,
       	items:[{
			text: '�˻�����ϸ', 
			id: "PHAIN_SumRet_RetDetail_Itm" , 
			reportName: 'PHAIN_SumRet_RetDetail_Itm.rpx', 
			selected: true
		}, {
			text: '�˻�������', 
			id: "PHAIN_SumRet_RetDetail_Sum" , 
			reportName: 'PHAIN_SumRet_RetDetail_Sum.rpx'
		}, {
			text: '�˻���Ʒ����', 
			id: "PHAIN_SumRet_RetDetail_Inci" , 
			reportName: 'PHAIN_SumRet_RetDetail_Inci.rpx'
		}, {
			text: '��Ӫ��ҵ����', 
			id: "PHAIN_SumRet_RetDetail_Vendor" , 
			reportName: 'PHAIN_SumRet_RetDetail_Vendor.rpx'
		}]
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
		
	PHA.ComboBox("vendor", {
		placeholder: '��Ӫ��ҵ...',
		url: PHA_STORE.APCVendor().url
	});
	
	//����
	PHA_UX.ComboBox.StkCatGrp('stkGrpType' ,{
		multiple: true,
		rowStyle: 'checkbox',
		qParams: {
			LocId: PHA_UX.Get('phaLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	})

	// ҩƷ�������
	PHA_UX.ComboGrid.INCItm('inci', {
		width: 160, 
		placeholder: 'ҩƷ...'
	});

	
	PHA.ComboBox('retReason', {
		placeholder: '�˻�ԭ��...',   
	   	url: PHA_IN_STORE.ReasonForReturn().url
	});

	// ��ʼֵ
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
	$('#report').keywords('clearAllSelected');
}