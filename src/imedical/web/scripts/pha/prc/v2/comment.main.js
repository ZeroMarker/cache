/**
 * 名称:	 处方点评-点评处方
 * 编写人:	 dinghongying
 * 编写日期: 2019-05-14
 */
PHA_COM.App.Csp = "pha.prc.v2.comment.main.csp";
PHA_COM.App.Name = "PRC.Comment.Main";
PHA_COM.App.Load = "";

var EpisodeId="";
var logonLocId = session['LOGON.CTLOCID'] ;
var logonUserId = session['LOGON.USERID'] ;
var logonGrpId = session['LOGON.GROUPID'] ;
var longoninfo = logonGrpId + "^" + logonLocId + "^" + logonUserId ;

$(function () {
	PatInfo = {
        pcntItm: 0,
        prescNo: 0,
        patNo: 0,
        patName: 0 ,
        patientID: 0,
		episodeID: 0,
        orditem: 0,
        zcyflag: 0
    };	
	InitSetPatInfo();
	InitGridMain();
	//InitGridDiag();
    InitGridPrescInfo();
    InitGridLog();   
    InitDiagReason("OP");										// 不合理原因窗口
    InitFindNoDialog({type: "OP", callback: LoadCommentNo});	// 查单窗口
    
    $("#btnFind").on("click", function () {
		ShowDiagFindNo();
	});
	$("#btnSearch").on("click", function () {
		SearchComments()
	});
	$("#btnSelect").on("click", function () {
		SelectCommentItms() ;
	});
	$("#btnDelete").on("click", function () {
		DeleteComment() ;
	});
	$("#btnSubmit").on("click", function () {
		SubmitComment() ;
	});
	//点评通过(合理)
	$("#btnPass").on("click", function () {
		CommentOK() ;
	});
	//点评不通过(不合理)
	$("#btnRefuse").on("click", function () {
		ShowDiagUnreason() ;
	});
	$("#btnAnaly").on("click", function () {
		PrescAnalyse() ;
	});
	
	$("#tabsForm").tabs({
        onSelect: function(title) {
		    // 这不常用,每次tk下没事
		    var admData=tkMakeServerCall("web.DHCSTPIVAS.Common","GetAdmInfo",EpisodeId);
		    var patId=admData.toString().split("^")[0]||"";
			
			var gridSelect = $("#gridMain").datagrid("getSelected");
			if (gridSelect==null){
				$.messager.alert('提示',"请先选中需要查看的处方!","info");
				return;
			}
			var prescNo = gridSelect.prescNo ;
			var cyflag = gridSelect.zcyflag ;	
			var EpisodeId = gridSelect.adm ;	
			var patId = gridSelect.papmi ;
			//alert("EpisodeId:"+EpisodeId)
			if (title==="医嘱明细"){
				QueryPrescDetail() ;
				QueryLogDetail() ;				
			}else if (title=="处方预览"){
		        if ($('#ifrmPresc').attr('src')==""||"undefined"){
			        var prescno=prescNo ;
			        var cyflag=cyflag ;
					var phartype="DHCOUTPHA";
					var paramsstr=phartype+"^"+prescno+"^"+cyflag;
		            $("#ifrmPresc").attr("src",'dhcpha/dhcpha.common.prescpreview.csp'+"?paramsstr="+paramsstr+"&PrtType=DISPPREVIEW" + "&MWToken="+websys_getMWToken());
		        } 
		    } else if (title=="病历浏览"){
		        if ($('#ifrmEMR').attr('src')==""||"undefined"){
					var fixUrl = 'websys.chartbook.hisui.csp?ChartBookName=DHC.Doctor.DHCEMRbrowse&SwitchSysPat=N'+ "&MWToken="+websys_getMWToken();
                    $('#ifrmEMR').attr('src', fixUrl + '&EpisodeID=' + EpisodeId);
				} 
		    }
        }
    });
    LoadMsgComment();
    if (gLoadPCntId === ""){
		setTimeout(function(){
			ShowDiagFindNo();
		}, 500);
    }
});


// 表格-点评处方
function InitGridMain() {
    var columns = [
        [
            { field: "analysisResult", index:'analysisResult' , title: '合理用药',width: 90,formatter: druguseFormatter,align:'center' },
            { field: 'passtext', title: '预审', width: 100, hidden: true},
            { field: "patNo", title: '登记号' ,width: 120, hidden: true},
            { field: "patName", title: '姓名', width: 100, hidden: true },
            { field: "sexDesc", title: '性别',width: 120, hidden: true},
            { field: 'patAge', title: '年龄', width: 200, hidden: true},
            { field: "typeDesc", title: '费别' ,width: 120, hidden: true},
            { field: "diag", title: '诊断',width: 100, hidden: true },
            { field: "prescNo", index:'prescNo', title: '处方号',width: 180 },
            { field: 'curret', title: '点评结果', width: 130},
            { field: 'oriCurret', title: '初评结果', width: 80, hidden: true},
			{ field: "docName", title: '医生' ,width: 120, hidden: true},
            { field: "doclocDesc", title: '科室' ,width: 120, hidden: true},
            { field: "adm", title: 'adm',width: 120 , hidden: true},
            { field: 'orditm', index:'orditm', title: 'orditm', width: 200, hidden: true},
            //{ field: "porcess", title: 'porcess' ,width: 120, hidden: true},
            { field: "wayCode", title: 'waycode', width: 100, hidden: true },
            { field: "pcntItm", title: '点评明细id',width: 120, hidden: true},
            { field: 'zcyflag', title: 'zcyflag', width: 200, hidden: true},
            { field: "analyResultRet", index:'分析结果值', title: 'analyResultRet' ,width: 120, hidden: true},
            { field: "analysisData", index:'分析结果', title: 'analysisData' ,width: 120, hidden: true},
            { field: "manLevel", index:'控制等级', title: 'manLevel' ,width: 120, hidden: true},
            { field: "papmi", title: 'papmi',width: 100, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectCommentItms',
            pcntId: gLoadPCntId || "" ,
            comResult: "",
            phaUserId: ""            
        },
        columns: columns,
        toolbar: "#gridMainBar",
        onSelect:function(rowIndex,rowData){
			LoadPatInfo(rowData);
			var tab = $('#tabsForm').tabs('getSelected');
			var index = $('#tabsForm').tabs('getTabIndex',tab);
			if (index==0){			//医嘱明细
				QueryPrescDetail() ;
				QueryLogDetail() ;			
			}else if (index==1){	//处方预览
				var prescno = rowData.prescNo;
				var cyflag = rowData.zcyflag;
				var phartype = "DHCOUTPHA";
				var paramsstr = phartype +"^"+ prescno +"^"+ cyflag;
				$("#ifrmPresc").attr("src",'dhcpha/dhcpha.common.prescpreview.csp'+"?paramsstr="+paramsstr+"&PrtType=DISPPREVIEW" + "&MWToken="+websys_getMWToken());			
			}else if (index==2){	//病历浏览
				var adm = rowData.adm;
				var fixUrl = 'websys.chartbook.hisui.csp?ChartBookName=DHC.Doctor.DHCEMRbrowse&SwitchSysPat=N' + "&MWToken=" + websys_getMWToken();
                $('#ifrmEMR').attr('src', fixUrl + '&EpisodeID=' + adm);
			}
		},
		onRowContextMenu: rightClickCommentFn,
		onClickCell: function (rowIndex, field, value) {
			var rows = $(this).datagrid('getRows');
			var rowData = rows[rowIndex];
            if (field != "analysisResult") {
                return
            }
            var content = rowData.analysisData;
            DHCSTPHCMPASS.HUIAnalysisTips({
                Content: content
            })
        }				
    };
    PHA.Grid("gridMain", dataGridOption);
}

//重新load Tab,并加载数据
var HrefRefresh = function() {
    var adm = PatInfo.adm;
    var patientID = PatInfo.patientID;
    var episodeID = PatInfo.episodeID;
    var prescno = PatInfo.prescno;
    var orditem = PatInfo.orditem;
    var zcyflag = PatInfo.zcyflag;
	
    var p = Ext.getCmp("ToolsTabPanel").getActiveTab();
    var iframe = p.el.dom.getElementsByTagName("iframe")[0];

    if (p.id == "framepaallergy") {
        iframe.src = 'dhcem.allergyenter.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm;
    }

    if (p.id == "framerisquery") {
        iframe.src = ' dhcapp.inspectrs.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm;
    }

    if (p.id == "framelabquery") {
        iframe.src = 'dhcapp.seepatlis.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&NoReaded=' + '1';
    }

    if (p.id == "frameprbrowser") {
        //iframe.src='dhc.epr.public.episodebrowser.csp?EpisodeID='+ adm;
        var LocID = session['LOGON.CTLOCID'];
        //iframe.src = p.src + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + LocID;
        iframe.src = 'emr.browse.manage.csp'+ '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + LocID;
    }


    //明细
    if (p.id == "frameordquery") {
        if (adm == 0) return;
        FindDiagData(adm);
        FindOrdDetailData(prescno);
        FindLogData(orditem);
        CheckArcExist(prescno);
    }

    //处方预览
    if (p.id == "prescriptioninfo") {
        if (zcyflag == 0) {
            iframe.src = 'dhcpha.comment.prescriptioninfo.csp' + '?PrescNo=' + prescno + '&EpisodeID=' + adm;
        } else {
            iframe.src = 'dhcpha.comment.cyprescriptioninfo.csp' + '?PrescNo=' + prescno + '&EpisodeID=' + adm;
        }
    }

    //本次医嘱
    if (p.id == "frameadmordquery") {
        //iframe.src = p.src + '?EpisodeID=' + adm;
        iframe.src = 'oeorder.opbillinfo.csp' + '?EpisodeID=' + adm;
    }
};

function InitGridDiag() {
    var columns = [
        [
            { field: "diag", title: '诊断',width: 620, }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectDiagList',
			adm: ''
        },
        columns: columns,
        pagination: false  
    };
    PHA.Grid("gridDiag", dataGridOption);
}

function InitGridPrescInfo() {
    var columns = [
        [
            { field: "arcitmdesc", title: '医嘱名称',width: 200 },
            { field: "qty", title: '数量',width: 80 },
            { field: "uomdesc", title: '单位',width: 80 },
            { field: "dosage", title: '剂量',width: 120 },
            { field: "freq", title: '频次',width: 120 },
            //{ field: "spec", title: '规格',width: 120 },		医嘱结果改造之后医嘱项不能确定唯一的规格
            { field: "instruc", title: '用法',width: 120 },
            { field: "duration", title: '用药疗程',width: 120 },
            { field: "realdura", title: '实用疗程',width: 80 },
            //{ field: "form", title: '剂型',width: 120 },
            { field: "basflag", title: '基本药物',width: 80 },
            { field: "doctor", title: '医生',width: 120 },
            { field: "orddate", title: '医嘱开单日期',width: 120 },
            { field: "remark", title: '医嘱备注',width: 120 },
            //{ field: "manf", title: '厂家',width: 120 },
            { field: "orditm", title: 'orditm',width: 120,hidden:true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectPrescDetail',
			prescNo: ''
        },
		border: false,
        pagination:false,
        pageSize:100,
        columns: columns,
        toolbar: [], //"#gridPrescInfotableBar",
        onClickRow:function(rowIndex,rowData){
	        if (rowData){
		        
			}   
		},
		onRowContextMenu: rightClickYDTSFn
    };
    PHA.Grid("gridPrescInfo", dataGridOption);
}

function InitGridLog() {
    var columns = [
        [
            { field: "grpNo", title: '组号',width: 50, },
            { field: "reasonDesc", title: '点评原因',width: 300,
            	formatter:function(v){
					return v.replace('└──','<span style="color:#999999">└──</span>')
				} 
			},
            { field: "patName", title: '姓名',width: 120, hidden: true },
            { field: "prescNo", title: '处方号',width: 120, hidden: true },
            { field: "comDate", title: '点评日期',width: 120, },
            { field: "comTime", title: '点评时间',width: 120, },
            { field: "comUserName", title: '点评人',width: 120, },
            { field: "comResult", title: '点评结果',width: 120, },
            { field: "factorDesc", title: '不合理警示值',width: 120, },
            { field: "adviceDesc", title: '药师建议',width: 120, },
            { field: "phaNote", title: '药师备注',width: 120, },
            { field: "docAdvice", title: '医生反馈',width: 120, hidden:true},
            { field: "docNote", title: '医生备注',width: 120, },
            { field: "reSaveFlag", title: '二次点评',width: 70, },
            { field: "active", title: '有效',width: 60, }
            
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.Main',
            QueryName: 'SelectCommentLog' ,
			pcntItm: ''
        },
        columns: columns,
        toolbar:[],
		border: false,
        pagination: false
    };
    PHA.Grid("gridLog", dataGridOption);
}

/// 打开关联不合理原因和医嘱界面
function ShowDiagUnreason() {	
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要点评的处方!","info");
		return;
	}
	var pItmResult = gridSelect.curret ;		//点评结果
	/*
	if (pItmResult.indexOf("接受")>0){
		$.messager.alert('提示',"该处方为已接受状态，不允许再次点评!","info");
		return;
	}
	*/
	var pcntsItmId = gridSelect.pcntItm ;		//点评子表id
	var pcntsAuth = tkMakeServerCall("PHA.PRC.Create.Main","ChkItmComAuth",longoninfo,pcntsItmId)			//获取点评权限
	if (pcntsAuth !== "1"){
		var pcntsAuthData = pcntsAuth.split("^")
		$.messager.alert('提示',pcntsAuthData[1],"info");
		return;
	}
	var prescNo = gridSelect.prescNo;
	showDialogSelectReason(prescNo, pcntsItmId, SaveCommentResult);
}

function LoadCommentNo(param){
	ClearCommentGrid();
	if (param.loadWayCode == "RE"){
		$('#gridMain').datagrid('showColumn', 'oriCurret');
		$('#gridMain').datagrid('getColumnOption', 'analysisResult').width = 80;
		$('#gridMain').datagrid('getColumnOption', 'prescNo').width = 130;	
		$('#gridMain').datagrid('getColumnOption', 'curret').width = 100;
		$('#btnPass').linkbutton({text:'通过'});
		$('#btnRefuse').linkbutton({text:'不通过'});
	}else{
		$('#gridMain').datagrid('hideColumn', 'oriCurret');
		$('#gridMain').datagrid('getColumnOption', 'analysisResult').width = 90;
		$('#gridMain').datagrid('getColumnOption', 'prescNo').width = 150;	
		$('#gridMain').datagrid('getColumnOption', 'curret').width = 130;
		$('#btnPass').linkbutton({text:'合理'});
		$('#btnRefuse').linkbutton({text:'不合理'});
	} 
	$('#gridMain').datagrid('query', param);	
}

function LoadMsgComment(){
	if (gWayCode === "RE"){
		$('#gridMain').datagrid('showColumn', 'oriCurret');
		$('#gridMain').datagrid('getColumnOption', 'analysisResult').width = 80;
		$('#gridMain').datagrid('getColumnOption', 'prescNo').width = 130;	
		$('#gridMain').datagrid('getColumnOption', 'curret').width = 100;
		$('#btnPass').linkbutton({text:'通过'});
		$('#btnRefuse').linkbutton({text:'不通过'});
	}else{
		$('#gridMain').datagrid('hideColumn', 'oriCurret');
		$('#gridMain').datagrid('getColumnOption', 'analysisResult').width = 90;
		$('#gridMain').datagrid('getColumnOption', 'prescNo').width = 150;	
		$('#gridMain').datagrid('getColumnOption', 'curret').width = 130;
		$('#btnPass').linkbutton({text:'合理'});
		$('#btnRefuse').linkbutton({text:'不合理'});
	}
}


// ***********************界面调用方法 Start ************************
function QueryDiag(){
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要查看的处方!","info");
		return;
	}
	var adm=gridSelect.adm;
    $('#gridDiag').datagrid('query', {
        adm: adm
    });	
}

///获取处方明细信息
function QueryPrescDetail() {
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要查看的处方!","info");
		return;
	}
	var prescNo=gridSelect.prescNo;
    $('#gridPrescInfo').datagrid('query', {
        prescNo: prescNo
    });
}

///获取点评日志信息
function QueryLogDetail() {
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要查看的处方!","info");
		return;
	}
	var pcntItm=gridSelect.pcntItm;
    $('#gridLog').datagrid('query', {
        pcntItm: pcntItm
    });
}

function CommentOK(){
	var gridSelect = $("#gridMain").datagrid("getSelected");
	if (gridSelect==null){
		$.messager.alert('提示',"请先选中需要点评的处方!","info");
		return;
	}
	var pItmResult = gridSelect.curret ;		//点评结果
	var pcntItm = gridSelect.pcntItm ;		//点评明细表id
	var result = "Y"
	var reasonstr = ""
	var input = ""	
	SaveCommentResult(pcntItm, result, longoninfo, reasonstr, input) ;
}

// 处方点评保存结果
function SaveCommentResult(pcntItm, result, longoninfo, reasonIdStr, remarkStr){
	var OKRet = $.cm({
			ClassName: 'PHA.PRC.Create.Main',
			MethodName: 'SaveComItmResult',
			pcntItm: pcntItm,
			result: result,
			longoninfo: longoninfo,
			reasonstr: reasonIdStr,
			input: remarkStr ,		
			dataType: 'text'
		}, false);

	var RetArr = OKRet.split('^');
	var RetVal = RetArr[0];
	var RetInfo = RetArr[1];	
	if (RetVal < 0) {
		PHA.Alert('提示', RetInfo, 'warning');
		return;
	} else {
		var gridSelect = $("#gridMain").datagrid("getSelected");
		var seqNo = $('#gridMain').datagrid('getRowIndex',gridSelect);
		if (result=="Y"){
			if (FindNoDialog.loadWayCode == "RE"){
				var ResultDesc = $g("通过")
			}else {
				var ResultDesc = $g("合理")
			}	
		}else if (result=="N"){
			if (FindNoDialog.loadWayCode == "RE"){
				var ResultDesc = $g("不通过")	
			}else {
				var ResultDesc = $g("不合理")
			}	
		}else{
			var ResultDesc = ""			
		}
		$("#gridMain").datagrid('updateRow', {
			index: seqNo,
			row: { curret: ResultDesc }
		})
		$("#gridMain").datagrid('selectRow', seqNo);
	}
}

/// 右键一键点评
function rightClickCommentFn(e, rowIndex, rowData) {
	var menuId = "PHA_GRID_" + "onRowContextMenu";
	var gridId = this.id;
	e.preventDefault(); //阻止向上冒泡
	if ($("#" + menuId).length > 0) {
		$("#" + menuId).remove();
	}
	var menuHtml =
		'<div id=' + menuId + ' class="hisui-menu" style="width: 150px; display: none;">' +
		'<div id=' + menuId + '_comment' + ' data-options="' + "iconCls:'icon-export-all'" + '">'+$g("一键点评")+'</div>' +
		'</div>'
	$("body").append(menuHtml);
	$("#" + menuId).menu()
	$("#" + menuId).menu('show', {
		left: e.pageX,
		top: e.pageY
	});
	$("#" + menuId + "_comment").on("click", function () {
		AllCommontOk();
	})
}

function AllCommontOk(){
	var rows = $("#gridMain").datagrid("getRows");
	for (var i = 0; i < rows.length; i++) {
		var analyResultRet = rows[i].analyResultRet;
		if (analyResultRet==0){
			var pcntItm = rows[i].pcntItm ;		//点评明细表id
			var result = "Y"
			var reasonstr = ""
			var input = ""
            SaveCommentResult(pcntItm, result, longoninfo, reasonstr, input) ;	
		}
	}
	$("#gridMain").datagrid("reload");
}

function ClearCommentGrid(){
	InitSetPatInfo() ;
	$("#gridPrescInfo").datagrid("clear");
	$("#gridLog").datagrid("clear");
}

//处方分析
function PrescAnalyse(){
	var passTypeInfo=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
	if (passTypeInfo==""){
		$.messager.alert('注意',"未设置处方分析接口，请在参数设置-门诊药房-合理用药厂商中添加相应厂商!","info");
		return;
	}
	//alert("passType:"+passType)
	var passTypeData=passTypeInfo.split("^")
	var passType=passTypeData[0]
	if (passType=="DHC"){
		// 东华知识库
		 DHCSTPHCMPASS.PassAnalysis({ 
		 	GridId: "gridMain", 
		 	MOeori: "orditm",
		 	PrescNo:"prescNo", 
		 	GridType: "EasyUI", 
		 	Field: "analysisResult",
		 	ResultField:"analysisData",
		 	manLevelFleld:"analyResultRet",
		 	ManLevel: "manLevel"
		 });
	}else if (passType=="DT"){
		dhcphaMsgBox.alert("接口尚未开放");
		
	}else if (passType=="MK"){
		dhcphaMsgBox.alert("接口尚未开放")
		// 美康
		//MKPrescAnalyse(); 
	}else if (passType=="YY"){
		dhcphaMsgBox.alert("接口尚未开放")
	}
}


// 药典提示
function rightClickYDTSFn(e, rowIndex, rowData) {
	var menuId = "PHA_GRID_" + "onRowContextMenu";
	var gridId = this.id;
	e.preventDefault(); //阻止向上冒泡
	if ($("#" + menuId).length > 0) {
		$("#" + menuId).remove();
	}
	var menuHtml =
		'<div id=' + menuId + ' class="hisui-menu" style="width: 150px; display: none;">' +
		'<div id=' + menuId + '_YDTS' + ' data-options="' + "iconCls:'icon-tip'" + '">'+$g("药典提示")+'</div>' +
		'</div>'
	$("body").append(menuHtml);
	$("#" + menuId).menu()
	$("#" + menuId).menu('show', {
		left: e.pageX,
		top: e.pageY
	});
	$("#" + menuId + "_YDTS").on("click", function () {
		var passType=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
		if (passType==""){
			PHA.Alert("提示","未设置药典接口，请在参数设置-门诊药房-合理用药厂商中添加相应厂商",'warning');
			return;
		}
		if(passType.indexOf("^") > -1){
			passType = passType.split("^")[0];	
		}
		if (passType=="DHC"){
			// 东华知识库
			var ordSelect = $("#gridPrescInfo").datagrid("getSelected");
			if((ordSelect=="")||(ordSelect==null)){
				PHA.Alert("提示","请先选择需要查看药典提示的明细记录!",'warning');
				return;
			}
			var userInfo = logonUserId + "^" + logonLocId + "^" + logonGrpId;
			var incDesc = ordSelect.arcitmdesc;
			var selOrdItm = ordSelect.orditm
			DHCSTPHCMPASS.MedicineTips({
				Oeori: selOrdItm,
				UserInfo: userInfo,
				IncDesc: incDesc
			})
		}else if (passType=="MK"){
			// 美康
			MKPrescYDTS(selOrdItm); 
		}else if (passType=="YY"){
		}		
	})
}

    
/********************** 调用美康合理用药 start   **************************/
//美康处方分析
function MKPrescAnalyse() {
    var rows = $("#gridMain").datagrid("getRows");
    if (rows.length == 0) {
        return;
    }
    for (var i = 0; i < rows.length; i++) {
        var prescno = rows[i].prescNo;
        myrtn = HLYYPreseCheck(prescno,0); 
        var imgname = "warningnull.gif"
        if (myrtn == 0) { var imgname = "warning0.gif"; }	// 合理
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// 黄灯
        if (myrtn == 2) { var imgname = "warning2.gif"; }	// 
        if (myrtn == 3) { var imgname = "warning3.gif"; }	// 
        if (myrtn == 4) { var imgname = "warning4.gif"; }	// 
        if (imgname == "") { var imgname = myrtn }
        var str = "<img id='analysisResult" + i + "'" + " src='../scripts/pharmacy/images/" + imgname + "'>";
		$("#gridMain").datagrid('updateRow', {
			index: i,
			row: {
				analysisResult: str,
				analyResultRet: myrtn
			}
		})
    }
}


function HLYYPreseCheck(prescno,flag){
	var XHZYRetCode=0  //处方检查返回代码
	MKXHZY1(prescno,flag);
	//若为同步处理,取用McPASS.ScreenHighestSlcode
	//若为异步处理,需调用回调函数处理.
	//同步异步为McConfig.js MC_Is_SyncCheck true-同步;false-异步
	XHZYRetCode=McPASS.ScreenHighestSlcode;
	return XHZYRetCode	
}

function MKXHZY1(prescno,flag){
	MCInit1(prescno);
	HisScreenData1(prescno);
	MDC_DoCheck(HIS_dealwithPASSCheck,flag);
}

function MCInit1(prescno) {
	var PrescStr=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
	var prescdetail=PrescStr.split("^")
	var pass = new Params_MC_PASSclient_In();
    pass.HospID = prescdetail[0];  
    pass.UserID = prescdetail[1];
    pass.UserName = prescdetail[2];
    pass.DeptID = prescdetail[3];
    pass.DeptName = prescdetail[4];
    pass.CheckMode ="mzyf"  //MC_global_CheckMode;
    MCPASSclient = pass;
}

function HIS_dealwithPASSCheck(result) {
        if (result > 0) {
        } else {
            //alert("没问题");
        }
	return result ;
}


function HisScreenData1(prescno){
	var Orders="";
	var Para1=""
	
	var PrescMStr=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
	var PrescMInfo=PrescMStr.split("^")
	var Orders=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescDetailInfo", prescno);
	if (Orders==""){return;}
	var DocName=PrescMInfo[2];
	var EpisodeID=PrescMInfo[5];
	if (EpisodeID==""){return}
	var ret=tkMakeServerCall("web.DHCDocHLYYMK","GetPrescInfo",EpisodeID,Orders,DocName);
	var TempArr=ret.split(String.fromCharCode(2));
	var PatInfo=TempArr[0];
	var MedCondInfo=TempArr[1];
	var AllergenInfo=TempArr[2];
	var OrderInfo=TempArr[3];
	var PatArr=PatInfo.split("^");
		
	var ppi = new Params_MC_Patient_In();
	ppi.PatCode = PatArr[0];			// 病人编码
	ppi.InHospNo= PatArr[11]
	ppi.VisitCode =PatArr[7]            // 住院次数
	ppi.Name = PatArr[1];				// 病人姓名
	ppi.Sex = PatArr[2];				// 性别
	ppi.Birthday = PatArr[3];			// 出生年月
	
	ppi.HeightCM = PatArr[5];			// 身高
	ppi.WeighKG = PatArr[6];			// 体重
	ppi.DeptCode  = PatArr[8];			// 住院科室
	ppi.DeptName  =PatArr[12]
	ppi.DoctorCode =PatArr[13] ;		// 医生
	ppi.DoctorName =PatArr[9]
	ppi.PatStatus =1
	ppi.UseTime  = PatArr[4];		   	// 使用时间
	ppi.CheckMode = MC_global_CheckMode
	ppi.IsDoSave = 1
	MCpatientInfo  = ppi;
    var arrayDrug = new Array();
	var pri;
  	var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
  	//alert(OrderInfo)
  	McRecipeCheckLastLightStateArr = new Array();
	for(var i=0; i<OrderInfoArr.length ;i++){    
		var OrderArr=OrderInfoArr[i].split("^");
		//传给core的，并且由core返回变灯的唯一编号，构造的灯div的id也应该和这个相关联
        drug = new Params_Mc_Drugs_In();
        
        drug.Index = OrderArr[0];             			//药品序号
        drug.OrderNo =OrderArr[0]; 		        		//医嘱号
        drug.DrugUniqueCode = OrderArr[1];  	//药品编码
        drug.DrugName =  OrderArr[2]; 			//药品名称
        drug.DosePerTime = OrderArr[3]; 	   //单次用量
		drug.DoseUnit =OrderArr[4];   	        //给药单位      
        drug.Frequency =OrderArr[5]; 	        //用药频次
        drug.RouteCode = OrderArr[8]; 	   		//给药途径编码
        drug.RouteName = OrderArr[8];   		//给药途径名称
		drug.StartTime = OrderArr[6];			//开嘱时间
        drug.EndTime = OrderArr[7]; 			//停嘱时间
        drug.ExecuteTime = ""; 	   				//执行时间
		drug.GroupTag = OrderArr[10]; 	       //成组标记
        drug.IsTempDrug = OrderArr[11];          //是否临时用药 0-长期 1-临时
        drug.OrderType = 0;    //医嘱类别标记 0-在用(默认);1-已作废;2-已停嘱;3-出院带药
        drug.DeptCode = PrescMInfo[7].split("-")[1];     //开嘱科室编码
        drug.DeptName =  PrescMInfo[4]; 	  //开嘱科室名称
        drug.DoctorCode =PrescMInfo[6];   //开嘱医生编码
        drug.DoctorName =PrescMInfo[2];     //开嘱医生姓名
		drug.RecipNo = "";            //处方号
        drug.Num = OrderArr[15];                //药品开出数量
        drug.NumUnit = OrderArr[16];            //药品开出数量单位          
        drug.Purpose = 0;             //用药目的(1预防，2治疗，3预防+治疗, 0默认)  
        drug.OprCode = ""; //手术编号,如对应多手术,用','隔开,表示该药为该编号对应的手术用药
		drug.MediTime = ""; //用药时机(术前,术中,术后)(0-未使用1- 0.5h以内,2-0.5-2h,3-于2h)
		drug.Remark = "";             //医嘱备注 
		arrayDrug[arrayDrug.length] = drug;
    
	}
	McDrugsArray = arrayDrug;
	var arrayAllergen = new Array();
	var pai;
	var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
	for(var i=0; i<AllergenInfoArr.length ;i++){
		var AllergenArr=AllergenInfoArr[i].split("^");
     	var allergen = new Params_Mc_Allergen_In();
     	allergen.Index = i;        //序号  
      	allergen.AllerCode = AllergenArr[0];    //编码
      	allergen.AllerName = AllergenArr[1];    //名称  
      	allergen.AllerSymptom =AllergenArr[3]; //过敏症状     	 
		arrayAllergen[arrayAllergen.length] = allergen;
	}
	McAllergenArray = arrayAllergen;
	//病生状态类数组
	 var arrayMedCond = new Array();
	var pmi;
  	var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
	for(var i=0; i<MedCondInfoArr.length ;i++){			
		var MedCondArr=MedCondInfoArr[i].split("^");
       
      	var medcond;       
      	medcond = new Params_Mc_MedCond_In();
      	medcond.Index = i	;              			//诊断序号
     	medcond.DiseaseCode = MedCondArr[0];        //诊断编码
      	medcond.DiseaseName = MedCondArr[1];     //诊断名称
 		medcond.RecipNo = "";              //处方号
      	arrayMedCond[arrayMedCond.length] = medcond;          
	}
	var arrayoperation = new Array();
	McOperationArray = arrayoperation;
}

/// 美康药典提示
function MKPrescYDTS(orditm){
	//alert("orditm:"+orditm)
	var ordInfoStr = tkMakeServerCall("web.DHCSTPIVADaTongInterface","GetOrderMainInfo",orditm)
	//alert("ordInfoStr:"+ordInfoStr)
	var ordInfo = ordInfoStr.split("^")
	var prescNo = ordInfo[10]
	var incicode = ordInfo[8]
	var incidesc = ordInfo[9]
	var cyFlag =  ordInfo[11]		//草药标志
	
	MCInit1(prescNo);
	HisQueryData(incicode,incidesc);
	if (cyFlag == "Y"){
		MDC_DoRefDrug(24)	
	}else {
		MDC_DoRefDrug(11)
	}	
}

function HisQueryData(incicode,incidesc) {   
    var drug = new Params_MC_queryDrug_In();
    drug.ReferenceCode = incicode; //查询药品的编码
    drug.CodeName =incidesc;  //查询药品的名称           
    MC_global_queryDrug = drug;   //赋值给全局变量
}


//********************** 调用美康合理用药 end   **************************/ 

//格式化列
function druguseFormatter(cellvalue, options, rowdata){
	//alert("cellvalue:"+cellvalue)
	if (cellvalue==undefined){
		cellvalue="";
	}
	/*if (cellvalue!=""){
		var passType=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logonGrpId,logonLocId,logonUserId);
		if(passType.indexOf("^") > -1){
			passType = passType.split("^")[0];	
		}
		if (passType=="DHC"){
			var cellvalue = (cellvalue == 1) ? 0 : 1;
		}
	} */
	var imageid="";
	if (cellvalue=="0"){
		imageid="warning0.gif";
	}else if (cellvalue=="1"){
		imageid="yellowlight.gif";
	}else if (cellvalue=="2"){
		imageid="warning2.gif"
	}
	else if (cellvalue=="3"){
		imageid="warning3.gif"
	}
	else if (cellvalue=="4"){
		imageid="warning4.gif"
	}
	if (imageid==""){
		return cellvalue;
	}
	return '<img src="../scripts/pharmacy/images/'+imageid+'" ></img>'
}

// ***********************界面调用方法 End ************************