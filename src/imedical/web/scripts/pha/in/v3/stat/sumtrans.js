/**
 * 名称:   	 药房药库-出库统计报表
 * 编写人:   liubeibei
 * 编写日期: 2022-03-23
 */
$(function() {	
  	$("#report").keywords({
	  	singleSelect:true,
		items:[{
			text: '科室/库存分类', 
			id: "PHAIN_SumTrans_TransDetail_LocStkcat" , 
			reportName: 'PHAIN_SumTrans_TransDetail_LocStkcat.rpx', 
			selected: true
		}, {
			text: '科室金额', 
			id: "PHAIN_SumTrans_TransDetail_Loc" , 
			reportName: 'PHAIN_SumTrans_TransDetail_Loc.rpx'
		}, {
			text: '科室金额/科室组', 
			id: "PHAIN_SumTrans_TransDetail_LocGrp" , 
			reportName: 'PHAIN_SumTrans_TransDetail_LocGrp.rpx'
		}, {
			text: '单品汇总', 
			id: "PHAIN_SumTrans_TransDetail_Sum" , 
			reportName: 'PHAIN_SumTrans_TransDetail_Sum.rpx'
		}, {
			text: '科室单品汇总', 
			id: "PHAIN_SumTrans_TransDetail_LocSum" , 
			reportName: 'PHAIN_SumTrans_TransDetail_LocSum.rpx'
		}, {
			text: '出库明细', 
			id: "PHAIN_SumTrans_TransDetail_Itm" , 
			reportName: 'PHAIN_SumTrans_TransDetail_Itm.rpx'
		}, {
			text: '出库单汇总', 
			id: "PHAIN_SumTrans_TransDetail_Trf" , 
			reportName: 'PHAIN_SumTrans_TransDetail_Trf.rpx'
		}, {
			text: '库存分类', 
			id: "PHAIN_SumTrans_TransDetail_Type" , 
			reportName: 'PHAIN_SumTrans_TransDetail_Type.rpx'
		}]
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
	
	PHA.ComboBox("recLoc", {
		placeholder: '接收科室...',
		url: PHA_STORE.GetGroupDept().url
	});
	
	PHA.ComboBox("transFer", {
		placeholder: '统计方式...',
	 	data: [
        {
            RowId: '0',
            Description: $g('转出转入')
        },
        {
            RowId: '1',
            Description: $g('转出')
        },
        {
            RowId: '2',
            Description: $g('转入')
        },
        {
            RowId: '3',
            Description: $g('仅拒绝接收转入')
        }
    ],
    panelHeight: 'auto'
	});
		
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
    
    PHA_UX.ComboBox.Manf("manf", {});
	
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
	
	PHA.ComboBox("operateOutType", {
		placeholder: '出库类型...',  
		url: PHA_IN_STORE.OperateType('O').url
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