/**
 * ����:   	 ҩ��ҩ��-������ͳ�Ʊ���
 * ��д��:   liubeibei
 * ��д����: 2022-04-19
 */
$(function() {	
  	$("#report").keywords({
	  	singleSelect: true,
       	items: [{
			text: '������ͳ��', 
			id: "PHAIN_AdjAmount_AdjDetail" , 
			reportName: 'PHAIN_AdjAmount_AdjDetail.rpx', 
			selected: true
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

	
	PHA.ComboBox('adjReason', {
		placeholder: '����ԭ��...',   
	   	url: PHA_IN_STORE.ReasonForAdj().url
	});

	// ��ʼֵ
	InitConditionVal();
}
function InitConditionVal(){
	$('#startDate').datebox('setValue',PHA_UTIL.SysDate('t'));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate('t'));
	PHA.SetComboVal('phaLoc', session['LOGON.CTLOCID']);
	$("#report").keywords('select', 'PHAIN_AdjAmount_AdjDetail');
}

function Query(){
	var reportObj=$('#report').keywords('getSelected')
	var title = reportObj[0].text
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
	return JSON.stringify(formData);
}

// ��ȡ��
function ClearCondition(){
	PHA.DomData("#div-conditions", {
		doType: 'clear'
	});
	$('#report').keywords('clearAllSelected');
}