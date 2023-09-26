/**
 * dhcant.kss.audit.js 抗菌药物审核界面
 * 
 * Copyright (c) 2016-2017 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2016-08-23
 * 
 */
$(function(){
	var consultDisplay1 = true,
		consultDisplay2 = true,
		consultDisplay3 = true,
		yfDrugDisplay = true,
		yesterday = ANT.GetDateStr(-1),
		nowDay = ANT.GetDateStr(),
		auditHeight = document.documentElement.clientHeight,		//document.body.clientHeight;
		consultDepNums = ANT.DHC.getConsultDepNums(),
		auditType= ANT.DHC.getAuditType(session['LOGON.CTLOCID']),
		auditValue = "1,0,0,0",
		enableYFDrug = ANT.DHC.ifEnableYFDrug();
		if ( enableYFDrug == "1") {
			yfDrugDisplay = false;
		}
		if (consultDepNums == "1") {
			consultDisplay1 = false;
		} else if (consultDepNums == "2") {
			consultDisplay1 = false;
			consultDisplay2 = false;
		} else {
			consultDisplay1 = false;
			consultDisplay2 = false;
			consultDisplay3 = false;
		};
	$("#i-audit").css("height", auditHeight);
	$('input').iCheck({
        labelHover : false,
        cursor : true,
        checkboxClass : 'icheckbox_square-blue',
        radioClass : 'iradio_square-blue',
        increaseArea : '20%'
    });
	//设置默认审核类型
	if (auditType == "U") {
		auditValue = "0,0,1,0";
		$('#i-audit-condition-lastaudit').iCheck('check');
	} else if (auditType == "S") {
		auditValue = "0,1,0,0";
		$('#i-audit-condition-ksaudit').iCheck('check');
	} else {
		$('#i-audit-condition-preaudit').iCheck('check');
	};
	$("#i-audit-condition-sdate").datebox({
		value: yesterday, 	//'2016-10-01',
		required:true  
	});
	
	$("#i-audit-condition-edate").datebox({
		value: nowDay,
		required:true  
	});
	
	$('#i-audit-condition-ksslevel').localcombobox({
		data: [{id: '', text: '全部'},{id: 'KSS1', text: '非限制级'}, {id: 'KSS2',text: '限制级'}, {id: 'KSS3',text: '特殊级'}],
		onUnselect: function () {
			$(this).simplecombobox('setValue', '');
		}
	});
	
	$('#i-audit-list-grid').simpledatagrid({
		pagination:true,
		fitColumns:false,
		queryParams: {
			ClassName:"DHCAnt.KSS.MainBusiness",
			QueryName:"QryAntApplyInfor",
			ModuleName:"datagrid",
			Arg1:yesterday,
			Arg2:nowDay,
			Arg3:"",
			Arg4:"",
			Arg5:"",
			Arg6:auditValue,
			ArgCnt:6
		},
		onDblClickRow: function(rowIndex, rowData) {
			if (rowData.process.indexOf("H")>=0 ) {
				$("#i-diag-con").removeClass('c-hidden');
				if ( consultDepNums == "1") {
					$("#i-diag-con-base1").removeClass('c-hidden');
					$("#i-diag-con-sugession1").removeClass('c-hidden');
					$("#i-diag-conloc1").html(rowData.Consultdep1);
					$("#i-diag-condoc1").html(rowData.Consultdoc1);
					$("#i-diag-conresult1").html(rowData.Conresult1);
					$("#i-diag-connote1").html(rowData.ConSuggestion1);
					
				} else if ( consultDepNums == "2" ) {
					$("#i-diag-con-base1").removeClass('c-hidden');
					$("#i-diag-con-sugession1").removeClass('c-hidden');
					$("#i-diag-con-base2").removeClass('c-hidden');
					$("#i-diag-con-sugession2").removeClass('c-hidden');
					
					$("#i-diag-conloc1").html(rowData.Consultdep1);
					$("#i-diag-condoc1").html(rowData.Consultdoc1);
					$("#i-diag-conresult1").html(rowData.Conresult1);
					$("#i-diag-connote1").html(rowData.ConSuggestion1);
					
					$("#i-diag-conloc2").html(rowData.Consultdep2);
					$("#i-diag-condoc2").html(rowData.Consultdoc2);
					$("#i-diag-conresult2").html(rowData.Conresult2);
					$("#i-diag-connote2").html(rowData.ConSuggestion2);
				} else {
					$("#i-diag-con-base1").removeClass('c-hidden');
					$("#i-diag-con-sugession1").removeClass('c-hidden');
					$("#i-diag-con-base2").removeClass('c-hidden');
					$("#i-diag-con-sugession2").removeClass('c-hidden');
					$("#i-diag-con-base3").removeClass('c-hidden');
					$("#i-diag-con-sugession3").removeClass('c-hidden');
					
					$("#i-diag-conloc1").html(rowData.Consultdep1);
					$("#i-diag-condoc1").html(rowData.Consultdoc1);
					$("#i-diag-conresult1").html(rowData.Conresult1);
					$("#i-diag-connote1").html(rowData.ConSuggestion1);
					
					$("#i-diag-conloc2").html(rowData.Consultdep2);
					$("#i-diag-condoc2").html(rowData.Consultdoc2);
					$("#i-diag-conresult2").html(rowData.Conresult2);
					$("#i-diag-connote2").html(rowData.ConSuggestion2);
					
					$("#i-diag-conloc3").html(rowData.Consultdep3);
					$("#i-diag-condoc3").html(rowData.Consultdoc3);
					$("#i-diag-conresult3").html(rowData.Conresult3);
					$("#i-diag-connote3").html(rowData.ConSuggestion3);
				};
			};
			
			if (rowData.Emergency == "是") {
				$("#i-diag-emre").removeClass('c-hidden');
				$("#i-diag-emreason").html(rowData.EmergecyReason);
			};
			$("#i-diag-patname").html(rowData.PatName);
			$("#i-diag-ksslevel").html(rowData.kssjb);
			$("#i-diag-arcim").html(rowData.arcimDesc);
			
			$("#i-diag-apploc").html(rowData.ApplyLoc);
			$("#i-diag-appdoc").html(rowData.AppUser);
			$("#i-diag-appdate").html(rowData.Appdate);
			$("#i-diag-emgency").html(rowData.Emergency);
			
			$("#i-diag-useaim").html(rowData.UsePurpseDesc);
			$("#i-diag-durgind").html(rowData.OPerIndDesc);
			$("#i-diag-injectpart").html(rowData.BodyPartdesc);
			$("#i-diag-drugtime").html(rowData.YFtime);
			
			$('#i-diag').removeClass("c-hidden");
			$('#i-diag').window({
				title: '抗菌药物申请详细信息',
				modal: true,
				iconCls:'fa fa-user',
				minimizable:false,
				collapsible:false,
				maximizable:false,
				onClose: function () {
					$('#i-diag').addClass("c-hidden");
					$('#i-diag-emre').addClass("c-hidden");
					$('#i-diag-con').addClass("c-hidden");
					$('#i-diag-con-base1').addClass("c-hidden");
					$('#i-diag-con-sugession1').addClass("c-hidden");
					$('#i-diag-con-base2').addClass("c-hidden");
					$('#i-diag-con-sugession2').addClass("c-hidden");
					$('#i-diag-con-base3').addClass("c-hidden");
					$('#i-diag-con-sugession3').addClass("c-hidden");
				}
			});
		
		},
		columns:[[
			{field:'PatName',title:'病人姓名',width:80},
			{field:'kssjb',title:'抗生素级别',width:80},
			{field:'arcimDesc',title:'药品名称',width:150},
			{field:'ApplyLoc',title:'申请科室',width:100},
			{field:'AppUser',title:'申请医生',width:80},
			{field:'Appdate',title:'提交申请日期',width:100},
			{field:'ApplyStatus',title:'状态代码',width:80},
			{field:'ApplyStatusDesc',title:'当前状态',width:80},
			{field:'UsePurpseDesc',title:'使用目的',width:150},
			{field:'OPerIndDesc',title:'用药指征',width:200},
			{field:'BodyPartdesc',title:'感染部位',width:100},
			{field:'YFtime',title:'用药时机',width:80},
			{field:'AuditUserName',title:'审核人',width:80},
			{field:'AuditDT',title:'审核时间',width:100},
			{field:'Conresult1',title:'会诊结果1',width:100,hidden:consultDisplay1},
			{field:'ConSuggestion1',title:'会诊意见1',width:100,hidden:consultDisplay1},
			{field:'Consultdep1',title:'会诊科室1',width:100,hidden:consultDisplay1},
			{field:'Consultdoc1',title:'会诊医生1',width:100,hidden:consultDisplay1},
			{field:'Conresult2',title:'会诊结果2',width:100,hidden:consultDisplay2},
			{field:'ConSuggestion2',title:'会诊意见2',width:100,hidden:consultDisplay2},
			{field:'Consultdep2',title:'会诊科室2',width:100,hidden:consultDisplay2},
			{field:'Consultdoc2',title:'会诊医生2',width:100,hidden:consultDisplay2},
			{field:'Conresult3',title:'会诊结果3',width:100,hidden:consultDisplay3},
			{field:'ConSuggestion3',title:'会诊意见3',width:100,hidden:consultDisplay3},
			{field:'Consultdep3',title:'会诊科室3',width:100,hidden:consultDisplay3},
			{field:'Consultdoc3',title:'会诊医生3',width:100,hidden:consultDisplay3},
			{field:'Emergency',title:'是否越级',width:100},
			{field:'EmergecyReason',title:'越级理由',width:100},
			{field:'Predictdays',title:'预计用药天数',width:100, hidden:yfDrugDisplay},
			{field:'ExtendEason',title:'延长用药原因',width:100, hidden:yfDrugDisplay},
			{field:'process',title:'当前流程',width:100},
			{field:'id',title:'id',width:100,hidden:false}
		]]
	});
	
	$("#i-audit-condition-btn-find").on('click', function(){
		reloadGrid();
	})
	$("#i-audit-condition-btn-audit").on('click', function(){
		var preAudit = $("#i-audit-condition-preaudit").is(':checked');
		var hasAudit = $("#i-audit-condition-hasaudit").is(':checked');
		var ksAudit = $("#i-audit-condition-ksaudit").is(':checked') ? 1 : 0;
		var lastAudit = $("#i-audit-condition-lastaudit").is(':checked')? 1 : 0;
		
		if (hasAudit) {
			layer.alert("您好！已经完成审核的申请记录，不让审核，谢谢！", {title:'提示',icon: 0}); 
			return false;
		};
		
		var aaRwoid = [];
		auditSelectedRows = $('#i-audit-list-grid').datagrid('getSelections');
		for (var i = 0; i < auditSelectedRows.length; i++) {
			var applyStatus = auditSelectedRows[i].ApplyStatus;
			var applyProcess = auditSelectedRows[i].process;
			if (preAudit) {
				var resultObj = sendMsgByType("KSF", applyStatus, applyProcess, "SH");
				if (resultObj.value == "1") {
					layer.alert(resultObj.msg, {title:resultObj.title,icon: 0}); 
					return false;
				};
			};
			if (ksAudit) {
				var resultObj = sendMsgByType("KS", applyStatus, applyProcess, "SH");
				if (resultObj.value == "1") {
					layer.alert(resultObj.msg, {title:resultObj.title,icon: 0}); 
					return false;
				};
			};
			if (lastAudit) {
				var resultObj = sendMsgByType("LAST", applyStatus, applyProcess, "SH");
				if (resultObj.value == "1") {
					layer.alert(resultObj.msg, {title:resultObj.title,icon: 0}); 
					return false;
				};
			};
			aaRwoid.push(auditSelectedRows[i].id);
		};
		if (aaRwoid.length == 0) {
			layer.alert("请选择一条记录...", {title:'提示',icon: 0}); 
			return false;
		};
		var type="KSF";	//默认为科室预审
		var ksAudit = $("#i-audit-condition-ksaudit").is(':checked') ? 1 : 0;
		var lastAudit = $("#i-audit-condition-lastaudit").is(':checked')? 1 : 0;
		if (ksAudit == "1") type = "KS";
		if (lastAudit == "1") type = "LAST";
		var result = $.InvokeMethod("DHCAnt.KSS.MainBusiness","VerifyApply",aaRwoid.join('^'),type,'SH');
		if (result == 0) {
			layer.alert("审核成功...", {title:'提示',icon: 6}); 
		} else {
			layer.alert("审核失败...", {title:'提示',icon: 5}); 
		};
		reloadGrid();
	})
	
	$("#i-audit-condition-btn-refuse").on('click', function(){
		var preAudit = $("#i-audit-condition-preaudit").is(':checked');
		var hasAudit = $("#i-audit-condition-hasaudit").is(':checked');
		var ksAudit = $("#i-audit-condition-ksaudit").is(':checked') ? 1 : 0;
		var lastAudit = $("#i-audit-condition-lastaudit").is(':checked')? 1 : 0;
		if (hasAudit) {
			layer.alert("您好！已经完成审核的申请记录，不让拒绝，谢谢！", {title:'提示',icon: 0}); 
			return false;
		};
		
		var aaRwoid = [];
		auditSelectedRows = $('#i-audit-list-grid').datagrid('getSelections');
		for (var i = 0; i < auditSelectedRows.length; i++) {
			var applyStatus = auditSelectedRows[i].ApplyStatus;
			var applyProcess = auditSelectedRows[i].process;
			if (preAudit) {
				var resultObj = sendMsgByType("KSF", applyStatus, applyProcess, "RU");
				if (resultObj.value == "1") {
					layer.alert(resultObj.msg, {title:resultObj.title,icon: 0}); 
					return false;
				};
			};
			if (ksAudit) {
				var resultObj = sendMsgByType("KS", applyStatus, applyProcess, "RU");
				if (resultObj.value == "1") {
					layer.alert(resultObj.msg, {title:resultObj.title,icon: 0}); 
					return false;
				};
			};
			if (lastAudit) {
				var resultObj = sendMsgByType("LAST", applyStatus, applyProcess, "RU");
				if (resultObj.value == "1") {
					layer.alert(resultObj.msg, {title:resultObj.title,icon: 0}); 
					return false;
				};
			};
			aaRwoid.push(auditSelectedRows[i].id);
		};
		if (aaRwoid.length == 0) {
			layer.alert("您好！请先选择一条申请记录，谢谢...", {title:'提示',icon: 0}); 
			return false;
		};
		
		var type="KSF";	//默认为科室预审拒绝
		if (ksAudit == "1") type = "KS";
		if (lastAudit == "1") type = "LAST";
		var result = $.InvokeMethod("DHCAnt.KSS.MainBusiness","VerifyApply",aaRwoid.join('^'),type,'RU');
		if (result == 0) {
			layer.alert("拒绝成功...", {title:'提示',icon: 6}); 
		} else {
			layer.alert("拒绝失败...", {title:'提示',icon: 5}); 
		};
		reloadGrid();
	})
	
	$("#i-audit-condition-preaudit").on('ifChecked', function(){
		$("#i-audit-condition-ksaudit").iCheck('uncheck'); 
		$("#i-audit-condition-lastaudit").iCheck('uncheck'); 
		reloadGrid();
	});
	
	$("#i-audit-condition-ksaudit").on('ifChecked', function(){
		
		$("#i-audit-condition-preaudit").iCheck('uncheck'); 
		$("#i-audit-condition-lastaudit").iCheck('uncheck');
		reloadGrid();		
	});
	
	$("#i-audit-condition-lastaudit").on('ifChecked', function(){
		$("#i-audit-condition-preaudit").iCheck('uncheck'); 
		$("#i-audit-condition-ksaudit").iCheck('uncheck'); 
		reloadGrid();
	});
	
	$("#i-audit-condition-hasaudit").on('ifChecked', function(){
		$("#i-audit-condition-btn-audit").attr("disabled","disabled");
		$("#i-audit-condition-btn-refuse").attr("disabled","disabled");
		reloadGrid();
	});
	$("#i-audit-condition-hasaudit").on('ifUnchecked', function(){
		$("#i-audit-condition-btn-audit").removeAttr("disabled");
		$("#i-audit-condition-btn-refuse").removeAttr("disabled");
		reloadGrid();
	});
	
	function sendMsgByType(applyType, applyStatus, applyProcess, action) {
		var pU = (applyProcess.indexOf("U") >= 0 ),
			pS = (applyProcess.indexOf("S") >= 0 ),
			pH = (applyProcess.indexOf("H") >= 0 ),
			pF = (applyProcess.indexOf("F") >= 0 ),
			pA = (applyProcess.indexOf("A") >= 0 ),
			acName = "审核",
			resultObj = {title:"提示", value:0, msg:"", icon:"info"};	//默认不给出提示	
		if ( action == "RU") acName = "拒绝";
		if ( applyType == "KSF" ) {
			if (applyStatus != "A") {
				resultObj.value = 1;
				resultObj.msg = "您好！状态不为A（申请）的记录，科室预审不能进行，谢谢！"
			};
			return resultObj;
		};
		if ( applyType == "KS" ) {
			if (( applyStatus == "U")||(( applyStatus == "R"))) {
				resultObj.value = 1;
				resultObj.msg = "已经审核完成的，不能" + acName + "，谢谢！";
				return resultObj;
			};
			if ( pS ) {
				resultObj.msg = "还没有进行上个流程的操作，不能进行科室" + acName + "，谢谢！";
				if ( pH ) {
					if (action == "RU" ) {
						//resultObj.value = 1;
						//resultObj.msg = "会诊已经通过，不能进行" + acName + "操作，谢谢！";
						if ( applyStatus != "H") resultObj.value = 1;
					} else {
						if ( applyStatus != "H") resultObj.value = 1;
					}
				} else if ( pF ) {
					if ( applyStatus != "F" ) resultObj.value = 1;
				} else {
					if ( applyStatus != "A" ) resultObj.value = 1;
				};
			} else {
				resultObj.value = 1;
				resultObj.msg = "流程不包含科室预审，不能进行科室审核，谢谢！";
				resultObj.icon = "warning";
			}
			return resultObj;
		};
		
		if ( applyType == "LAST" ) {
			if (( applyStatus == "U")||(( applyStatus == "R"))) {
				resultObj.value = 1;
				resultObj.msg = "已经审核完成的，不能"+ acName + "，谢谢！";
				return resultObj;
			};
			if ( pU ) {
				resultObj.msg = "还没有完成上个流程，不能"+ acName + "，谢谢！";
				if (pS) {
					if ( applyStatus != "S") resultObj.value = 1;
				} else if (pH) {
					if (action == "RU" ) {
						//resultObj.value = 1;
						//resultObj.msg = "会诊已经通过，不能进行" + acName + "操作，谢谢！";
						if ( applyStatus != "H") resultObj.value = 1;
					} else {	//SH
						if ( applyStatus != "H") resultObj.value = 1;
					}
				} else if (pF) {
					if ( applyStatus != "F") resultObj.value = 1;
				} else {
					if ( applyStatus != "A") resultObj.value = 1;
				}
			} else {
				resultObj.value = 1;
				resultObj.msg = "流程不包含最终审核，不能进行最终审核和拒绝操作，谢谢！";
				resultObj.icon = "warning";
			}
			return resultObj;
		};
		
		return resultObj;
	};
	
	function reloadGrid() {
		var stDate = $("#i-audit-condition-sdate").datetimebox('getValue');
		var endDate = $("#i-audit-condition-edate").datetimebox('getValue');
		var kssLevel = $("#i-audit-condition-ksslevel").ksslevelcombobox('getValue');
		if (!kssLevel) kssLevel="";
		var preAudit = $("#i-audit-condition-preaudit").is(':checked')? 1 : 0;
		var ksAudit = $("#i-audit-condition-ksaudit").is(':checked') ? 1 : 0;
		var lastAudit = $("#i-audit-condition-lastaudit").is(':checked')? 1 : 0;
		var hasAudit = $("#i-audit-condition-hasaudit").is(':checked')? 1 : 0;
		if (!stDate||!endDate) {
			layer.alert("请输入开始日期和结束日期...", {title:"提示".title,icon: 0}); 
			return false;
		};
		var processTypeStr=preAudit + "," + ksAudit + "," + lastAudit + "," + hasAudit;	
		$('#i-audit-list-grid').simpledatagrid("clearSelections");
		$('#i-audit-list-grid').simpledatagrid("reload",{
			ClassName:"DHCAnt.KSS.MainBusiness",
			QueryName:"QryAntApplyInfor",
			ModuleName:"datagrid",
			Arg1:stDate,
			Arg2:endDate,
			Arg3:kssLevel,
			Arg4:"",
			Arg5:"",
			Arg6:processTypeStr,
			ArgCnt:6
		});
	}
	
});