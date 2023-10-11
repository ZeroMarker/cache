/**
 * ����:       ҩ��ҩ��-���ͳ�Ʊ���
 * ��д��:   liubeibei
 * ��д����: 2022-03-10
 */
$(function() {  
    $("#report").keywords({
        singleSelect: true,
        items: [
            {
                text: '��ⵥ�б�', 
                id: "PHAIN_SumRec_RecDetail_Itm" , 
                reportName: 'PHAIN_SumRec_RecDetail_Itm.rpx', 
                selected:true
            }, {
                text: '��Ʒ����', 
                id: "PHAIN_SumRec_RecDetail_ItmStat" , 
                reportName: 'PHAIN_SumRec_RecDetail_ItmStat.rpx'
            }, {
                text: '��Ӫ��ҵ����', 
                id: "PHAIN_SumRec_RecDetail_Vendor" , 
                reportName: 'PHAIN_SumRec_RecDetail_Vendor.rpx'
            }, {
                text: '��Ӫ��ҵ��ϸ����', 
                id: "PHAIN_SumRec_RecDetail_VendorItm" , 
                reportName: 'PHAIN_SumRec_RecDetail_VendorItm.rpx'
            }, {
                text: '��Ӫ��ҵ�������', 
                id:"PHAIN_SumRec_RecDetail_VendorStkGrp" , 
                reportName:'PHAIN_SumRec_RecDetail_VendorStkGrp.rpx'
            }, {
                text: '�������', 
                id:"PHAIN_SumRec_RecDetail_StkGrp" ,  
                reportName:'PHAIN_SumRec_RecDetail_StkGrp.rpx'
            }, {
                text: '���������', 
                id:"PHAIN_SumRec_RecDetail_Stock" , 
                reportName:'PHAIN_SumRec_RecDetail_Stock.rpx'
            }, {
                text: '��ⵥ����', 
                id:"PHAIN_SumRec_RecDetail_Sum", 
                reportName:'PHAIN_SumRec_RecDetail_Sum.rpx'
            }, {
                text: '��ⵥ(����)����', 
                id:"PHAIN_SumRec_RecDetail_RpSum", 
                reportName:'PHAIN_SumRec_RecDetail_RpSum.rpx'
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
    PHA_UX.ComboBox.Loc('phaLoc');
        
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
        simple: true,
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
    
    PHA.ComboBox("manf", {
        placeholder: '������ҵ...',
        url: PHA_STORE.PHManufacturer().url
    });
    
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
    
    PHA.ComboBox("operateInType", {
        placeholder: '�������...',  
        url: PHA_IN_STORE.OperateType('I').url
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
    $("#report").keywords('select', 'PHAIN_SumRec_RecDetail_Itm');
    $HUI.checkbox('#retFlag').check();
    PHA.SetComboVal('summaryType', 'SUMDATE');
}

function Query(){
    var reportObj = $('#report').keywords('getSelected');
    var title = reportObj[0].text;
    var queryId = reportObj[0].id;
    var LocDesc = $('#phaLoc').combobox('getText');
    var formData = GetCondition();
    var InputStr = JSON.stringify(formData);
    
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