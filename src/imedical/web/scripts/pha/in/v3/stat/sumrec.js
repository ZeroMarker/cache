/**
 * 名称:       药房药库-入库统计报表
 * 编写人:   liubeibei
 * 编写日期: 2022-03-10
 */
$(function() {  
    $("#report").keywords({
        singleSelect: true,
        items: [
            {
                text: '入库单列表', 
                id: "PHAIN_SumRec_RecDetail_Itm" , 
                reportName: 'PHAIN_SumRec_RecDetail_Itm.rpx', 
                selected:true
            }, {
                text: '单品汇总', 
                id: "PHAIN_SumRec_RecDetail_ItmStat" , 
                reportName: 'PHAIN_SumRec_RecDetail_ItmStat.rpx'
            }, {
                text: '经营企业汇总', 
                id: "PHAIN_SumRec_RecDetail_Vendor" , 
                reportName: 'PHAIN_SumRec_RecDetail_Vendor.rpx'
            }, {
                text: '经营企业明细汇总', 
                id: "PHAIN_SumRec_RecDetail_VendorItm" , 
                reportName: 'PHAIN_SumRec_RecDetail_VendorItm.rpx'
            }, {
                text: '经营企业类组汇总', 
                id:"PHAIN_SumRec_RecDetail_VendorStkGrp" , 
                reportName:'PHAIN_SumRec_RecDetail_VendorStkGrp.rpx'
            }, {
                text: '类组汇总', 
                id:"PHAIN_SumRec_RecDetail_StkGrp" ,  
                reportName:'PHAIN_SumRec_RecDetail_StkGrp.rpx'
            }, {
                text: '库存分类汇总', 
                id:"PHAIN_SumRec_RecDetail_Stock" , 
                reportName:'PHAIN_SumRec_RecDetail_Stock.rpx'
            }, {
                text: '入库单汇总', 
                id:"PHAIN_SumRec_RecDetail_Sum", 
                reportName:'PHAIN_SumRec_RecDetail_Sum.rpx'
            }, {
                text: '入库单(进价)汇总', 
                id:"PHAIN_SumRec_RecDetail_RpSum", 
                reportName:'PHAIN_SumRec_RecDetail_RpSum.rpx'
            }
        ]
    })
    InitDict();
    InitEvents();
});

// 初始化 - 事件绑定
function InitEvents(){
    $('#btnFind').on("click", Query);
    $('#btnClear').on("click", Clear);
}

function InitDict(){
    PHA_UX.ComboBox.Loc('phaLoc');
        
    PHA.ComboBox("vendor", {
        placeholder: '经营企业...',
        url: PHA_STORE.APCVendor().url,
    });
    
    // 类组
    PHA_UX.ComboBox.StkCatGrp('stkGrpType', {
        multiple: true,
        rowStyle: 'checkbox',
        qParams: {
            LocId: PHA_UX.Get('phaLoc', session['LOGON.CTLOCID']),
            UserId: session['LOGON.USERID']
        }
    });

    // 库存分类
    PHA_UX.ComboBox.StkCat('stkCatGroup', {
        multiple: true,
        rowStyle: 'checkbox',
        qParams: {
            CatGrpId: PHA_UX.Get('stkGrpType')
        }
    });
    
    // 药品下拉表格
    PHA_UX.ComboGrid.INCItm('inci', {
        simple: true,
        width: 160,
        placeholder: '药品...'
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
        placeholder: '生产企业...',
        url: PHA_STORE.PHManufacturer().url
    });
    
    PHA.ComboBox("phcForm", {
        placeholder: '剂型...',
        url: PHA_STORE.PHCForm().url
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
    
    PHA.ComboBox("markType", {
        placeholder: '定价类型...',
        url: PHA_STORE.DHCMarkType().url
    });
    
    PHA.ComboBox("operateInType", {
        placeholder: '入库类型...',  
        url: PHA_IN_STORE.OperateType('I').url
    });
    
    PHA.ComboBox('importFlag', {
        placeholder: '进口标志...', 
        data: [
            {
                RowId: $g('进口'),
                Description: $g('进口')
            },
            {
                RowId: $g('国产'),
                Description: $g('国产')
            },
            {
                RowId: $g('合资'),
                Description: $g('合资')
            }
        ],
        panelHeight: 'auto'
    });
    
    PHA.ComboBox("pbFlag", {
        placeholder: '招标...',
         data: [
            {
                RowId: $g('Y'),
                Description: $g('是')
            },
            {
                RowId: $g('N'),
                Description: $g('否')
            }
        ],
        panelHeight: 'auto'
    });
    PHA.ComboBox("pBLevel", {
        placeholder: '招标级别...',
        url: PHA_STORE.DHCItmPBLevel().url
    });
    
    PHA.ComboBox("summaryType", {
        data: [ {
            RowId: $g('SUMDATE'),
            Description: $g('冲抵撤消数据'),
            selected: true
        }, {
            RowId: $g('ALL'),
             Description: $g('显示撤消数据')
        }],
        panelHeight: 'auto'
    });
    // 初始值
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
    $('#report').keywords('clearAllSelected');
}