/**
 * ����:   	 ҩ��ҩ��-ȫԺ����ͳ�Ʊ���
 * ��д��:   liubeibei
 * ��д����: 2022-06-23
 */
$(function() {	
  	$("#report").keywords({
	  	singleSelect:true,
       	items:[
				{
					text: $g('��ҩƷ'), 
					id: "PHAIN_AllDisp_DispStat_Inci" , 
					reportName: 'PHAIN_AllDisp_DispStat_Inci.rpx', 
					selected:true
				}, {
					text: $g('��ҽ������'), 
					id: "PHAIN_AllDisp_DispStat_DocLoc" , 
					reportName: 'PHAIN_AllDisp_DispStat_DocLoc.rpx'
				}, {
					text: $g('����Ӫ��ҵ'), 
					id: "PHAIN_AllDisp_DispStat_Vendor" , 
					reportName: 'PHAIN_AllDisp_DispStat_Vendor.rpx'
				}, {
					text: $g('������ҩ�����'), 
					id: "PHAIN_AllDisp_BasicStat" , 
					reportName: 'PHAIN_AllDisp_BasicStat.rpx'
				}, {
					text: $g('������ͳ�ƴ���'), 
					id: "PHAIN_AllDisp_Phcform" , 
					reportName: 'PHAIN_AllDisp_Phcform.rpx'
				}
            ]
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
	PHA.ComboBox('admType', {
		placeholder: '����...', 
	    data: [
	        {
	            RowId: '0',
	            Description: $g('ȫ��')
	        },
	        {
	            RowId: $g('O'),
	            Description: $g('����')
	        },
	        {
	            RowId: $g('I'),
	            Description: $g('סԺ')
	        }
	    ],
	    width: 160,
	    panelHeight: 'auto'
	});
	
	PHA_UX.ComboBox.Loc('phaLoc');
	PHA.ComboBox("executeLoc", {
		url: PHA_STORE.DocLoc().url,
		panelWidth: 160
	});
	PHA_UX.ComboGrid.INCItm('inci', {
		width: 160, 
		placeholder: 'ҩƷ...'
	});
	InitConditionVal();
}
function InitConditionVal(){
  $('#startDate').datebox('setValue',PHA_UTIL.SysDate('t'));
  $('#endDate').datebox('setValue', PHA_UTIL.SysDate('t'));
  PHA.SetComboVal('admType', 0);
  PHA.SetComboVal('phaLoc', session['LOGON.CTLOCID']);
  $("#report").keywords('select', 'PHAIN_AllDisp_DispStat_Inci');
}

function Query(){
	var reportObj = $('#report').keywords('getSelected');
	var title = reportObj[0].text;
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
	return formData;
}

// ��ȡ��
function ClearCondition(){
  PHA.DomData("#div-conditions", {
	  doType: 'clear'
  });
  $('#report').keywords('clearAllSelected');
}