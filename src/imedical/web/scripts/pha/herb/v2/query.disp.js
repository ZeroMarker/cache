/**
 * @模块:     草药处方发药查询
 * @编写日期: 2021-01-07
 * @编写人:   MaYuqiang
 */
var tmpSplit = DHCPHA_CONSTANT.VAR.MSPLIT;
var gLocId = DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID ;
var gHospId = DHCPHA_CONSTANT.SESSION.GHOSP_ROWID ;
var ComPropData		// 公共配置
var AppPropData		// 模块配置
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
$(function () {
	InitDict();
	InitGridPrescList();
	InitSetDefVal();
	InitEvent();            //  按钮事件
	ResizePanel();          //  布局调整
	InitConditionFold();
});

//条件折叠
function InitConditionFold()
{
	PHA.ToggleButton("moreorless", {
        buttonTextArr: [$g('更多'), $g('隐藏')],
        selectedText: $g('更多'),
        onClick: function(oldText, newText){
        }	
    });	

    $("#moreorless").popover({
        trigger: 'click',	
        placement: 'auto',
        content: 'content',
        dismissible: false,
        width: 1050,
        padding: false,
        url: '#js-pha-moreorless'
    });
}

/**
 * 给控件赋初始值
 * @method InitSetDefVal
 */
 function InitSetDefVal() {
	//界面配置
	// 公共设置
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
		}, false)

    $("#conStartDate").datebox("setValue", ComPropData.QueryStartDate);
    $("#conEndDate").datebox("setValue", ComPropData.QueryEndDate);
	$('#conStartTime').timespinner('setValue', ComPropData.QueryStartTime);
	$('#conEndTime').timespinner('setValue', ComPropData.QueryEndTime);
	
}

function InitDict() {
    var combWidth = 160;
    // 发药科室
    PHA.ComboBox('conPhaLoc', {
        url: PHA_HERB_STORE.UserLoc('D').url,
		panelHeight: 'auto',
		width: combWidth,
        onLoadSuccess: function (data) {
            $(this).combobox('selectDefault', gLocId);
        }
    });
    // 就诊类型
    PHA.ComboBox('conAdmType', {
        width: combWidth,
        data: [
            { RowId: 'O,E', Description: $g('门急诊') },
            { RowId: 'I', Description: $g('住院') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
	});
	// 开单科室
    PHA.ComboBox('conDocLoc', {
        url: PHA_STORE.DocLoc().url,
        width: combWidth
    });
	// 当前执行状态
	PHA.ComboBox("conState", {
		url: PHA_HERB_STORE.Process(gLocId,'All',gHospId,'').url,
		width: combWidth,
		onLoadSuccess: function(){
			//$("#cmbPhaLoc").combobox("setValue", gLocId);
		}
	});
	// 煎药方式
    PHA.ComboBox('conCookType', {
        width: combWidth,
        url: PHA_HERB_STORE.CookType('', gLocId).url,
        panelHeight: 'auto'
	});
	// 草药处方剂型
    PHA.ComboBox('conForm', {
        width: combWidth,
        url: PHA_HERB_STORE.HMPreForm(gLocId).url
	});
	// 药品信息
	var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
        width: 238
    });
    PHA.LookUp('conInci', opts);
	// 出院带药
	PHA.ComboBox('conOut', {
        data: [
            { RowId: 'equal', Description: $g('仅有') },
            { RowId: 'not', Description: $g('不含') }
        ],
        width: combWidth,
        panelHeight: 'auto',
        onSelect: function () {}
    });
	// 协定方
    PHA.ComboBox('conAgreePre', {
        width: combWidth,
        data: [
            { RowId: 'equal', Description: $g('仅有') },
            { RowId: 'not', Description: $g('不含') }
        ],
        panelHeight: 'auto',
        onSelect: function () {}
    });
	// 处方费别
    PHA.ComboBox('conBillType', {
        width: combWidth,
        url: PHA_STORE.PACAdmReason(gHospId).url
    });
    // 领药病区
    PHA.ComboBox('conWardLoc', {
        url: PHA_STORE.WardLoc().url,
        width: combWidth
	});
    // 处方疗程
    PHA.ComboBox('conDuration', {
        url: PHA_STORE.PHCDuration().url,
        width: combWidth
	});
    
	
	PrescView("");
}

/* 按钮事件 */
function InitEvent(){
	$('#btnFind').on('click', QueryHandler);
	$('#btnClean').on('click', Clear);
	// 置为可退
	$('#btnSaveAgreeRet').on('click', SaveAgreeRet);
	// 打印配药单
	$('#btnPrintPYD').on('click', PrintPYD);
	// 打印处方
	$('#btnPrintPresc').on('click', PrintPresc);
	//登记号回车事件
	$('#conPatNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var patno=$.trim($("#conPatNo").val());
			if (patno!=""){
				var newpatno=NumZeroPadding(patno,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
				QueryHandler();
			}	
		}
	});
	
	//卡号回车事件
	$('#txtCardNo').on('keypress',function(event){
		if(window.event.keyCode == "13"){
			var cardno=$.trim($("#txtCardNo").val());
			if (cardno!=""){
				BtnReadCardHandler();
			}
			SetFocus();	
		}
	});
	
	//屏蔽所有回车事件
	$("input[type=text]").on("keypress",function(e){
		if(window.event.keyCode == "13"){
			return false;
		}
	});

}

// 布局调整
function ResizePanel(){
    setTimeout(function () {    
        var flag = 0.4;
        if(PHA_COM.Window.Width()<1500 ){flag = 0.5}         
        PHA_COM.ResizePanel({
            layoutId: 'layout-herb—grid',
            region: 'west',
            width: flag
        });
        PHA_COM.ResizePanel({
            layoutId: 'layout-herb—grid-list',
            region: 'south',
            height: 0.6 
        });
    }, 0);
}

/**
 * 初始化处方列表
 * @method InitGridPrescList
 */
function InitGridPrescList() {
	var columns = [
		[	 {
				field: 'TPrescNo',
				title: '处方号',
				align: 'left',
				width: 130,
				formatter: function (value, row, index) {
					return '<a class="pha-grid-a js-grid-oeore">' + value + '</a>';
					//var qOpts = "{prescNo:'" + row.TPrescNo + "'}";
					//return '<a class="pha-grid-a" onclick="PHAHERB_COM.TimeLine({},' + qOpts + ')">' + value + '</a>';
                }
			},{
				field: 'TState',
				title: '当前状态',
				align: 'left',
				width: 90
			}, {
				field: 'TPatName',
				title: '姓名',
				align: 'left',
				showTip: true,
				tipWidth: 100,
				width: 70
			}, {
				field: 'TPmiNo',
				title: '登记号',
				align: 'left',
				width: 100,
				formatter: function (value, row, index) {
                    var qOpts = "{AdmId:'" + row.TAdm + "'}";
                    return '<a class="pha-grid-a" onclick="PHA_UX.AdmDetail({},' + qOpts + ')">' + value + '</a>';
                }
			}, {
				field: 'TPatLoc',
				title: '开单科室/病区(床号)',
				align: 'left',
				showTip: true,
				tipWidth: 200,
				width: 150
			}, {
				field: 'TPrescForm',
				title: '处方剂型',
				align: 'left',
				showTip: true,
				width: 80
			}, {
				field: 'TPreDur',
				title: '疗程(付数)',
				align: 'left',
				width: 80
			}, {
				field: 'TCookType',
				title: '煎药方式',
				align: 'left',
				showTip: true,
				width: 80
			}, {
				field: 'TDispWin',
				title: '发药窗口',
				align: 'left',
				showTip: true,
				width: 80
			},  {
				field: 'TPrescAmt',
				title: '处方金额',
				align: 'left',
				width: 80
			},{
				field: 'TCookCost',
				title: '煎药费/申请状态',
				align: 'left',
				showTip: true,
				width: 180
			}, {
				field: 'TBillType',
				title: '费别',
				align: 'left',
				width: 80
			}, {
				field: 'TMBDiagnos',
				title: '慢病诊断',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TDiag',
				title: '诊断',
				align: 'left',
				showTip: true,
				width: 150
			}, {
				field: 'TAgreeFlag',
				title: '是否可退',
				align: 'left',
				width: 80,
				formatter: function (value, row, index) {
                    var qOpts = "{phbdId:'" + row.TPhbdId + "'}";
                    return '<a class="pha-grid-a" onclick="PHAHERB_COM.AgreeRetReason({},' + qOpts + ')">' + value + '</a>';
					
                }
			}, {
				field: 'TPatSex',
				title: '性别',
				align: 'left',
				width: 50
			}, {
				field: 'TPatAge',
				title: '年龄',
				align: 'left',
				width: 50
			}, {
				field: 'TEmergFlag',
				title: '是否加急',
				align: 'left',
				width: 70
			}, {
				field: 'TAdm',
				title: 'TAdm',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TPapmi',
				title: 'TPapmi',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TOeori',
				title: 'TOeori',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TEncryptLevel',
				title: '病人密级',
				align: 'left',
				width: 80,				
				hidden: true
			}, {
				field: 'TPatLevel',
				title: '病人级别',
				align: 'left',
				width: 80,				
				hidden: true
			}, {
				field: 'TPhbdId',
				title: 'TPhbdId',
				align: 'left',
				width: 80,				
				hidden: true
			}, {
				field: 'TOeore',
				title: 'TOeore',
				align: 'left',
				width: 150,				
				hidden: true
			}, {
				field: 'TPrescFormula',
				title: '协定方',
				align: 'left',
				showTip: true,
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: '',
		fit: true,
		rownumbers: true,
		columns: columns,
		nowrap: true,
		pagination: true,
		singleSelect: true,
        pageNumber: 1,
        pageSize: 100,
		toolbar: "#gridHerbPrescListBar",
		url: $URL,
		queryParams: {
			ClassName: "PHA.HERB.Query.Dispen",
			QueryName: "GetPrescList",
		},
		onClickRow: function (rowIndex, rowData) {
			var prescNo = rowData.TPrescNo;
			PrescView(prescNo);
		}
	};
	PHA.Grid("gridHerbPrescList", dataGridOption);

	PHA.GridEvent('gridHerbPrescList', 'click', ['pha-grid-a js-grid-oeore', 'pha-grid-a js-grid-patNo'], function (rowIndex, rowData, className) {
        var winWidth = $('body').width()*0.8;
        if (className === 'pha-grid-a js-grid-oeore') {
            PHA_UX.TimeLine(
                {
                    modal: true,
                    modalable:true,
                    width: winWidth - 20,
                    top: null,
                    left: null
                },
                { oeore: rowData.TOeori }
            );
        }
    });
}

/**
 * 处方预览
 * @method PrescView
 */
function PrescView(prescNo){
	if (prescNo == ""){
		$("#ifrm-PreViewPresc").attr("src", "");
		return;
	}

	var phbdType = "OP";
	if(prescNo.indexOf("I")>-1){
		phbdType = "IP";
	}
	var cyFlag = "Y";
	var zfFlag = "底方"
	var dispFlag = "OK"
	if (dispFlag !== "OK"){
        var useFlag = "3"       // 未发药
    }
    else {
        var useFlag = "4"       // 已发药
    }

	PHA_HERB.PREVIEW({
        prescNo: prescNo,           
        preAdmType: phbdType,
        zfFlag: zfFlag,
        prtType: 'DISPPREVIEW',
        useFlag: useFlag,
        iframeID: 'ifrm-PreViewPresc',
        cyFlag: cyFlag
    });
}

/**
 * 查询数据
 * @method QueryHandler
 */
function QueryHandler() {
	$('#gridHerbPrescList').datagrid('clear');
	PrescView("") ;
	var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	$('#gridHerbPrescList').datagrid('query', {
		pJsonStr: JSON.stringify(pJson)
	});	 
}

/**
 * 查询条件的JSON
 * @method GetQueryParamsJson
 */
function GetQueryParamsJson() {
    return {
        startDate: $("#conStartDate").datebox('getValue'),
        endDate: $("#conEndDate").datebox('getValue'),
        startTime: $('#conStartTime').timespinner('getValue'),
        endTime: $('#conEndTime').timespinner('getValue'),
		phaLocId: $('#conPhaLoc').combobox('getValue') || '',
		admType: $('#conAdmType').combobox('getValue') || '',
		patNo: $('#conPatNo').val(),
		prescNo: $('#conPrescNo').val(),
		docLocId: $('#conDocLoc').combobox('getValue') || '',
		curState: $('#conState').combobox('getValue') || '',
		cookType: $('#conCookType').combobox('getValue') || '',
		preFormCode: $('#conForm').combobox('getValue') || '',
		inci: $('#conInci').lookup('getValue') || '',
		outFlag: $('#conOut').combobox('getValue') || '',
		agreePre: $('#conAgreePre').combobox('getValue') || '',
		billType: $('#conBillType').combobox('getValue') || '' ,
		wardLocId: "",	//$('#conWardLoc').combobox('getValue') || '',
		durationId: $('#conDuration').combobox('getValue') || '',
		queryMenu: "queryDisp"     
    };
}


/*
 * 清屏
 * @method Clear
 */
function Clear() {
	$('#gridHerbPrescList').datagrid('clear');
	PrescView("");
	InitSetDefVal();
	$('#conPhaLoc').combobox('selectDefault', gLocId);
	$('#conAdmType').combobox('clear');
	$('#conPatNo').val("");
	$('#conPrescNo').val("");
	$('#conDocLoc').combobox('clear');
	$('#conState').combobox('clear');
	$('#conCookType').combobox('clear');
	$('#conForm').combobox('clear');
	$('#conInci').lookup('clear');
	$('#conOut').combobox('clear');
	$('#conAgreePre').combobox('clear');
	$('#conBillType').combobox('clear');
	$('#conDuration').combobox('clear');	
}

/*
 * 置为可退
 * @method SaveAgreeRet
 */
function SaveAgreeRet(){
	var gridSelect = $("#gridHerbPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要置为可退的处方!","info");
		return;
	}
	var phbdId = gridSelect.TPhbdId ;
	var chkRet = tkMakeServerCall("PHA.HERB.Dispen.Save", "ChkAgreeReturnState", phbdId)
	if (chkRet != 0){
		var errMsg = chkRet.split("^")[1];
		$.messager.alert('提示', errMsg , "info");
		return;
	}
	/*
	var dspStatus = gridSelect.TDspStatus ;		//发药状态
	if (dspStatus.indexOf("发药")<0){
		$.messager.alert('提示',"该处方未发药，不能置为可退!","info");
		return;
	}
	*/
	var htmlStr = '<div class="input-group">'
		htmlStr += 		'<div class="pha-col">' 
		htmlStr +=			'<textarea id="agrretremark" style="width:220px;"> </textarea>'
        htmlStr += 		'</div>'
	    htmlStr += '</div>';
	$.messager.confirm("可退原因备注",htmlStr,function(result){
		if(!result) {return};
		var remark = $.trim($("#agrretremark").val()) ;
		var agrRetUserId = gUserID ;	// 当前登录人
		var params = phbdId + tmpSplit + agrRetUserId + tmpSplit + remark ;
		$.m({
			ClassName: "PHA.HERB.Dispen.Save",
			MethodName: "SaveAgreeRet",
			params: params 
		}, function (retData) {
			var retArr = retData.split("^")
			if (retArr[0] < 0) {
				$.messager.alert('提示', retArr[1], 'warning');
				return;
			}
			else {
				$.messager.alert('提示', "置为可退成功", 'success');
			}
			QueryHandler();
		});
		
	});
	
}

/*
 * 打印配药单
 * @method PrintPYD
 */
function PrintPYD(){
	var gridSelect = $("#gridHerbPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert($g('提示'), $g("请先选中需要打印配药单的处方"), "info");
		return;
	}
	var phbdId = gridSelect.TPhbdId;
	HERB_PRINTCOM.PYD(phbdId,"");
}

/*
 * 打印处方
 * @method PrintPYD
 */
function PrintPresc(){
	var gridSelect = $("#gridHerbPrescList").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert($g('提示'), $g("请先选中需要打印的处方"), "info");
		return;
	}

	var prescNo = gridSelect.TPrescNo;
	HERB_PRINTCOM.Presc(prescNo,"");
}

//载入数据
window.onload=function(){
	setTimeout("QueryHandler()",500);
}
