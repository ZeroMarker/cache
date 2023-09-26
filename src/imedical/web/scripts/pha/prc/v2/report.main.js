/** 
 * 模块: 	 处方点评报表汇总
 * 编写日期: 2019-07-27
 * 编写人:   dinghongying
 */
PHA_COM.App.Csp = "pha.prc.v2.report.main.csp";
var EpisodeId="";
var LoadAdmId="";
var logonLocId = session['LOGON.CTLOCID'] ;
var logonUserId = session['LOGON.USERID'] ;
var logonGrpId = session['LOGON.GROUPID'] ;
var loadWayId = ""		//加载点评单对应的点评方式
$(function() {
    InitDict();
    InitGridFindNo();
    $("#btnFindNo").on("click", function () {
		ShowDiagFindNo(this)
	});
	$('#btnFind').on("click", Query);
	$('#btnSearch').on("click", SearchComments);
	$('#btnComfirm').on("click", Comfirm);
    $("iframe").attr("src",PRC_STORE.RunQianBG);
	InitSetDefVal() ;

});

function InitDict() {
    // 初始化-日期
	PHA.DateBox("conStartDate", {width:205});
	PHA.DateBox("conEndDate", {width:205});
	PHA.DateBox("conNoStartDate", {});
	PHA.DateBox("conNoEndDate", {});
	// 初始化-多选下拉框
	PHA.ComboBox("conMultiDocLoc", {
		multiple: true,
		rowStyle: 'checkbox', //显示成勾选行形式,不要勾选框就注释
		url: PHA_STORE.DocLoc().url,
		width:205
	});
	// 初始化点评状态
	PHA.ComboBox("conSubmit", {
		data: [{
			RowId: "1",
			Description: "未点评"
		}, {
			RowId: "2",
			Description: "点评中"
		}, {
			RowId: "3",
			Description: "点评完成"
		}, {
			RowId: "4",
			Description: "已提交"
		}],
		panelHeight: "auto",
		width:140
	});
	// 初始化点评方式
	PHA.ComboBox("conWay", {
		url: PRC_STORE.PCNTSWay("1","UNRECNTS").url,
		width:140
	});
	// 初始化点评结果 1-仅有结果,2-仅无结果,3-仅合理,4-仅不合理,5-仅医生申诉
	PHA.ComboBox("conResult", {
		data: [{
			RowId: "1",
			Description: "仅有结果"
		}, {
			RowId: "2",
			Description: "仅无结果"
		}, {
			RowId: "3",
			Description: "仅合理"
		}, {
			RowId: "4",
			Description: "仅不合理"
		}, {
			RowId: "5",
			Description: "仅医生申诉"
		}],
		panelHeight: "auto",
		width:205
	});
	// 初始化查单界面点评结果 1-仅有结果,2-仅无结果,3-仅合理,4-仅不合理,5-仅医生申诉
	PHA.ComboBox("conNoResult", {
		data: [{
			RowId: "1",
			Description: "仅有结果"
		}, {
			RowId: "2",
			Description: "仅无结果"
		}, {
			RowId: "3",
			Description: "仅合理"
		}, {
			RowId: "4",
			Description: "仅不合理"
		}, {
			RowId: "5",
			Description: "仅医生申诉"
		}],
		panelHeight: "auto",
		width:160
	});
	//初始化点评药师
	PHA.ComboBox("conPharmacist", {
		url: PRC_STORE.PhaUser(),
		width:160
	});
}

/// 界面信息初始化
function InitSetDefVal() {
	//查询日期初始化
	$.cm({
		ClassName: "PHA.PRC.Com.Util",
		MethodName: "GetAppProp",
		UserId: logonUserId ,
		LocId: logonLocId ,
		SsaCode: "PRC.COMMON"
	}, function (jsonColData) {
		$("#conStartDate").datebox("setValue", jsonColData.QueryStartDate);
		$("#conEndDate").datebox("setValue", jsonColData.QueryEndDate);
		$("#conNoStartDate").datebox("setValue", jsonColData.ComStartDate);
		$("#conNoEndDate").datebox("setValue", jsonColData.ComEndDate);
	});

}

/// 查询
function Query() {
	var comNo = $('#conComNo').val() ;
    var params = GetParams();
    
	var StartDate = $('#conStartDate').datebox('getValue') ;
	var EndDate = $('#conEndDate').datebox('getValue') ;
	if ((StartDate == "")||(StartDate == "")){
		PHA.Alert('提示', "日期范围不能为空!", 'warning');
		return ;
	}
	var firstInputStr = GetFirstTextParams() ;
	var secInputStr = GetSecTextParams() ;
	var dateRange="统计日期："+StartDate+" 至 "+EndDate
    var checkedRadioJObj = $("input[name='wantSelect']:checked");
    var radioValue = checkedRadioJObj.val();
	
	if ((radioValue == "")||(radioValue == undefined)){
		PHA.Alert('提示', "请先选择报表类型!", 'warning');
		return ;
	}
    if (radioValue == "点评信息查询(按不合理原因汇总)") {
        var raqObj = {
            raqName: "PHA_PRC_QueryPrescForRea.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        };
		var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } else if (radioValue == "点评信息查询(按开单科室汇总)") {
        var raqObj = {
            raqName: "PHA_PRC_QueryPrescForLoc.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        };
        var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } else if (radioValue == "抗菌处方明细统计") {
        var raqObj = {
            raqName: "PHA_PRC_QueryPrescForAnti.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        }
        var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } else if (radioValue == "科室处方点评合格率统计") {
        var raqObj = {
            raqName: "PHA_PRC_QueryPassRateByLoc.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        }
        var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } else if (radioValue == "科室不合格处方原因统计(仅综合点评)") {
        var raqObj = {
            raqName: "PHA_PRC_QueryUnPassDataByLocRea.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        }
        var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } else if (radioValue == "门诊处方点评明细统计") {
        var raqObj = {
            raqName: "PHA_PRC_QueryComDataDetail.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        }
        var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } else if (radioValue == "药房处方用药基本信息统计") {
        var raqObj = {
            raqName: "PHA_PRC_QueryComDataByPhaLoc.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        }
        var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } else if (radioValue == "点评信息统计(按医生)") {
        var raqObj = {
            raqName: "PHA_PRC_QueryComDataByDoctor.raq",
            raqParams: {
                stDate: StartDate,
                endDate: EndDate,            
                comNo: comNo ,
                parStr: params,
                logonLocId: session['LOGON.CTLOCID'],
				userName: session['LOGON.USERNAME'],
				firstInputStr:firstInputStr,
				secInputStr:secInputStr,
				dateRange:dateRange
            },
            isPreview: 1,
            isPath: 1
        }
        var raqSrc=PRCPRINT.RaqPrint(raqObj)
	    $("iframe").attr("src",raqSrc);
    } 
}

/// 查询点评单
function SearchComments(){
	var stDate = $("#conNoStartDate").datebox('getValue') ;
	var endDate = $("#conNoEndDate").datebox('getValue') ;
	var wayId = $("#conWay").combobox('getValue')||''; 
	var result = $("#conNoResult").combobox('getValue')||'';
	var phaUserId = $("#conPharmacist").combobox('getValue')||'';
	var state = $("#conSubmit").combobox('getValue')||'';
	var parStr = wayId + "^" + result + "^" + phaUserId + "^" + state;
	
	$("#gridFindNo").datagrid("query", {
		findFlag: '1',
		stDate: stDate,
		endDate: endDate,
		parStr: parStr,
		logonLocId: logonLocId,
		searchFlag: ''
	});
		
}

function Comfirm()
{
	var gridSelect = $("#gridFindNo").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中点评单!","info");
		return;
	}
	var selPcntsNo = gridSelect.pcntNo;
	var queryStartDate = $("#conNoStartDate").datebox('getValue') ;
	var queryEndDate = $("#conNoEndDate").datebox('getValue') ;
	$('#diagFindNo').dialog('close');
	$('#conComNo').val(selPcntsNo);
	$("#conStartDate").datebox("setValue", queryStartDate);
	$("#conEndDate").datebox("setValue", queryEndDate);
}

// 获取参数
function GetParams() {
    var ordLocId = $("#conMultiDocLoc").combobox('getValues')||'';
	var result = $("#conResult").combobox('getValue')||'';
	var RetStr = ordLocId + "^" + result
	
    return RetStr
}

// 获取参数显示值
function GetFirstTextParams() {
    var ordLocStr = $("#conMultiDocLoc").combobox('getText')||'';
    var ordLocData = ordLocStr.split(",")
    if (ordLocData.length>3){
		var ordLocStr = ordLocData[0]+","+ordLocData[1]+","+ordLocData[2]+"..."
	}
    if (ordLocStr==""){
	   	var OrdLocText="条件说明：就诊科室：全部"
	}
	else{
		var OrdLocText="条件说明：就诊科室："+ordLocStr	
	}
	
	return OrdLocText ;
}

// 获取参数显示值
function GetSecTextParams() {
    
	var result = $("#conResult").combobox('getText')||'';
	if (result==""){
	   	var ResultText="点评结果：全部"
	}
	else{
		var ResultText="点评结果："+result	
	}
	var comNo = $('#conComNo').val() ;
	var ComNoText="点评单号："+comNo
	
	var RetTextStr = "条件说明："+ ResultText + "  " + ComNoText
	
    return RetTextStr
	
}

// 表格-点评单
function InitGridFindNo() {
    var columns = [
        [
            { field: "pcntId", title: 'rowid', width: 80, hidden:true},
            { field: "pcntNo", title: '单号',width: 150 },
            { field: 'pcntDate', title: '日期', width: 100},
            { field: "pcntTime", title: '时间', width: 80 },
            { field: "pcntUserName", title: '制单人' ,width: 80},
            { field: "typeDesc", title: '类型',width: 120 },
            { field: 'wayDesc', title: '方式', width: 150},
            { field: "pcntText", title: '查询条件' ,width: 400},
            { field: "pcntState", title: '点评状态',width: 80, }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectComments',
			findFlag: '1',
			stDate: $("#conStartDate").datebox('getValue'),
			endDate: $("#conEndDate").datebox('getValue'),
			parStr: '',
			logonLocId: logonLocId,
			searchFlag: ''
        },      
        columns: columns,
        border:true,
        bodyCls:'panel-header-gray',
        toolbar: "#gridFindNoBar",
        onDblClickRow:function(rowIndex,rowData){
	         Comfirm();
		}   
    };
	PHA.Grid("gridFindNo", dataGridOption);
}

/// 打开查单界面
function ShowDiagFindNo(btnOpt) {
	$('#diagFindNo').dialog({
		title: "点评处方" + btnOpt.text,
		iconCls:  'icon-w-find' ,
		modal: true
	})
	$('#diagFindNo').dialog('open');
	
}