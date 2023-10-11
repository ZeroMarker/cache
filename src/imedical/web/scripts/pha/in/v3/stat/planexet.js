/**
 * ����:   	 ҩ��ҩ��-�ɹ��ƻ�ִ�����ͳ��
 * ��д��:   liubeibei
 * ��д����: 2022-05-06
 */
$(function() {	
  	$("#report").keywords({
	  	singleSelect:true,
       	items:[{
			text: '�ƻ�������������ձ���', 
			id: "PHAIN_PlanExet_PurPlan_IngrCompare" , 
			reportName: 'PHAIN_PlanExet_PurPlan_IngrCompare.rpx', 
			selected: true
		}, {
			text: '�ƻ��������浥', 
			id: "PHAIN_PlanExet_PurPlan_PlanAssess" , 
			reportName: 'PHAIN_PlanExet_PurPlan_PlanAssess.rpx'
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
	PHA.ComboBox('queryFlag', {
		placeholder: 'ͳ�Ʊ�־...',   
	   	data: [
	        {
	            RowId: '0',
	            Description: $g("�ƻ�>ʵ��")
	        },
	        {
	            RowId: '1',
	            Description: $g("�ƻ�=ʵ��")
	        },
	        {
	            RowId: '2',
	            Description: $g("�ƻ�<ʵ��")
	        }]
	});

	// ��ʼֵ
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