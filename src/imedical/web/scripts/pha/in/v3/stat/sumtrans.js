/**
 * ����:   	 ҩ��ҩ��-����ͳ�Ʊ���
 * ��д��:   liubeibei
 * ��д����: 2022-03-23
 */
$(function() {	
  	$("#report").keywords({
	  	singleSelect:true,
		items:[{
			text: '����/������', 
			id: "PHAIN_SumTrans_TransDetail_LocStkcat" , 
			reportName: 'PHAIN_SumTrans_TransDetail_LocStkcat.rpx', 
			selected: true
		}, {
			text: '���ҽ��', 
			id: "PHAIN_SumTrans_TransDetail_Loc" , 
			reportName: 'PHAIN_SumTrans_TransDetail_Loc.rpx'
		}, {
			text: '���ҽ��/������', 
			id: "PHAIN_SumTrans_TransDetail_LocGrp" , 
			reportName: 'PHAIN_SumTrans_TransDetail_LocGrp.rpx'
		}, {
			text: '��Ʒ����', 
			id: "PHAIN_SumTrans_TransDetail_Sum" , 
			reportName: 'PHAIN_SumTrans_TransDetail_Sum.rpx'
		}, {
			text: '���ҵ�Ʒ����', 
			id: "PHAIN_SumTrans_TransDetail_LocSum" , 
			reportName: 'PHAIN_SumTrans_TransDetail_LocSum.rpx'
		}, {
			text: '������ϸ', 
			id: "PHAIN_SumTrans_TransDetail_Itm" , 
			reportName: 'PHAIN_SumTrans_TransDetail_Itm.rpx'
		}, {
			text: '���ⵥ����', 
			id: "PHAIN_SumTrans_TransDetail_Trf" , 
			reportName: 'PHAIN_SumTrans_TransDetail_Trf.rpx'
		}, {
			text: '������', 
			id: "PHAIN_SumTrans_TransDetail_Type" , 
			reportName: 'PHAIN_SumTrans_TransDetail_Type.rpx'
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
	
	PHA.ComboBox("recLoc", {
		placeholder: '���տ���...',
		url: PHA_STORE.GetGroupDept().url
	});
	
	PHA.ComboBox("transFer", {
		placeholder: 'ͳ�Ʒ�ʽ...',
	 	data: [
        {
            RowId: '0',
            Description: $g('ת��ת��')
        },
        {
            RowId: '1',
            Description: $g('ת��')
        },
        {
            RowId: '2',
            Description: $g('ת��')
        },
        {
            RowId: '3',
            Description: $g('���ܾ�����ת��')
        }
    ],
    panelHeight: 'auto'
	});
		
	PHA.ComboBox("vendor", {
		placeholder: '��Ӫ��ҵ...',
		url: PHA_STORE.APCVendor().url,
	});
	
	// ����
	PHA_UX.ComboBox.StkCatGrp('stkGrpType', {
		multiple: true,
		rowStyle: 'checkbox',
		qParams: {
			LocId: PHA_UX.Get('phaLoc', session['LOGON.CTLOCID']),
			UserId: session['LOGON.USERID']
		}
	});
	
	// ������
	PHA_UX.ComboBox.StkCat('stkCatGroup', {
		multiple: true,
		rowStyle: 'checkbox',
		qParams: {
			CatGrpId: PHA_UX.Get('stkGrpType')
		}
	});
	
	// ҩƷ�������
	PHA_UX.ComboGrid.INCItm('inci', {
		width: 160,
		placeholder: 'ҩƷ...'
	});

	
	 PHA.TriggerBox('phcCatAll', {
        width: 160,
		handler: function (data) {
            PHA_UX.DHCPHCCat('phcCatAll', {}, function (data) {
                $('#phcCatAll').triggerbox('setValue', data.phcCatDescAll);
                $('#phcCatAll').triggerbox('setValueId', data.phcCatId);
            });
        }
    });
    
    PHA_UX.ComboBox.Manf("manf", {});
	
	PHA.ComboBox("phcForm", {
		placeholder: '����...',
		url: PHA_STORE.PHCForm().url
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
	
	PHA.ComboBox("markType", {
		placeholder: '��������...',
		url: PHA_STORE.DHCMarkType().url
	});
	
	PHA.ComboBox("operateOutType", {
		placeholder: '��������...',  
		url: PHA_IN_STORE.OperateType('O').url
	});
	
	PHA.ComboBox('importFlag', {
		placeholder: '���ڱ�־...', 
	    data: [
	        {
	            RowId: $g('����'),
	            Description: $g('����')
	        },
	        {
	            RowId: $g('����'),
	            Description: $g('����')
	        },
	        {
	            RowId: $g('����'),
	            Description: $g('����')
	        }
	    ],
	    panelHeight: 'auto'
	});
	
	PHA.ComboBox("pbFlag", {
		placeholder: '�б�...',
		 data: [
	        {
	            RowId: $g('Y'),
	            Description: $g('��')
	        },
	        {
	            RowId: $g('N'),
	            Description: $g('��')
	        }
	    ],
	    panelHeight: 'auto'
	});
	PHA.ComboBox("pBLevel", {
		placeholder: '�б꼶��...',
		url: PHA_STORE.DHCItmPBLevel().url
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
	$("#report").keywords('select', 'PHAIN_SumTrans_TransDetail_LocStkcat');
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
	$('#report').keywords('clearAllSelected');
}