/**
 * ����:   	 ҩ��ҩ��-��������ͳ�Ʊ���
 * ��д��:   liubeibei
 * ��д����: 2022-04-08
 */
 var App_Name = "DHCSTCOMMON"
 var App_Store = PHA_COM.ParamProp(App_Name)

$(function() {	
  	$("#report").keywords({
	  	singleSelect:true,
        items:[{
			text: '��Ʒ����', 
			id: "PHAIN_AspAmount_AspDetail_Inc" , 
			reportName: 'PHAIN_AspAmount_AspDetail_Inc.rpx', 
			selected: true
		}, {
			text: '��Ʒ���һ���', 
			id: "PHAIN_AspAmount_AspDetail_IncLoc" , 
			reportName: 'PHAIN_AspAmount_AspDetail_IncLoc.rpx'
		}, {
			text: '��Ӫ��ҵ����', 
			id: "PHAIN_AspAmount_AspDetail_Vendor" , 
			reportName: 'PHAIN_AspAmount_AspDetail_Vendor.rpx'
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
		url: PHA_STORE.APCVendor().url,
		panelWidth: 200
	});
	
	// ҩƷ�������
	PHA_UX.ComboGrid.INCItm('inci', {
		placeholder: 'ҩƷ...',
		width: 160
	});
	
	PHA.ComboBox('diffType', {
		placeholder: '������...', 
	    data: [
	        {
	            RowId: "0",
	            Description: $g('ȫ��')
	        },
	        {
	            RowId: "1",
	            Description: $g('���Ϊ��')
	        },
	        {
	            RowId: "-1",
	            Description: $g('���Ϊ��')
	        }
	    ],
	    panelHeight: 'auto'
	});
	// ��ʼֵ
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