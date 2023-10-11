/**
 * ����:   	 ҩ��ҩ��-ҵ������ͳ�Ʊ���
 * ��д��:   liubeibei
 * ��д����: 2022-04-21
 */
$(function() {	
  	$("#report").keywords({
	  	singleSelect: true,
       	items: [{
			text: 'ҵ��������ϸ', 
			id: "PHAIN_BusipAmount_BusipDetail" , 
			reportName: 'PHAIN_BusipAmount_BusipDetail.rpx', 
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

	PHA.ComboBox("busipType", {
		placeholder: 'ҵ������...',
		url: PHA_STORE.BusinessType().url
	});

	PHA.ComboBox("summaryType", {
        data: [ {
            RowId: $g('SUMDATE'),
            Description: $g('��ֳ�������'),
            selected: true
        }, {
            RowId: $g('ALL'),
             Description: $g('��ʾ��������')
        }],
        panelHeight: 'auto'
    });

	// ��ʼֵ
	InitConditionVal();
}
function InitConditionVal(){
	$('#startDate').datebox('setValue',PHA_UTIL.SysDate('t'));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate('t'));
	PHA.SetComboVal('phaLoc', session['LOGON.CTLOCID']);
	$("#report").keywords('select', 'PHAIN_BusipAmount_BusipDetail');
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
	// ���ѡ�б�������
	$('#report').keywords('clearAllSelected');
}