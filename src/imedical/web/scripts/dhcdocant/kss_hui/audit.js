/**
 * dhcant.kss.audit.js ����ҩ����˽���
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
		yfDrugDisplay = true;
		yesterday = ANT.GetDateStr(-1),
		nowDay = ANT.GetDateStr(),
		auditHeight = document.documentElement.clientHeight,		//document.body.clientHeight;
		consultDepNums = ANT.DHC.getConsultDepNums(session['LOGON.HOSPID']),
		auditType= ANT.DHC.getAuditType(session['LOGON.CTLOCID'],session['LOGON.HOSPID']),
		auditValue = "1,0,0,0",
		enableYFDrug = 0;	//ANT.DHC.ifEnableYFDrug()
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
	//$("#i-audit").css("height", auditHeight);
	/*$('input').iCheck({
        labelHover : false,
        cursor : true,
        checkboxClass : 'icheckbox_square-blue',
        radioClass : 'iradio_square-blue',
        increaseArea : '20%'
    });*/
	//��ʼ���¼�
	InitEvent();
	
	$("#i-audit-condition-sdate").datebox({
		value: yesterday, 	//'2016-10-01',
		required:true  
	});
	
	$("#i-audit-condition-edate").datebox({
		value: nowDay,
		required:true  
	});
	
	$('#i-audit-condition-ksslevel').localcombobox({
		data: [{id: '', text: $g('ȫ��')},{id: 'KSS1', text: $g('�����Ƽ�')}, {id: 'KSS2',text: $g('���Ƽ�')}, {id: 'KSS3',text: $g('���⼶')}],
		onUnselect: function () {
			$(this).simplecombobox('setValue', '');
		}
	});
	$('#i-audit-list-grid').simpledatagrid({
		pagination:true,
		border:false,
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
		toolbar:[{
						text:'���',
						id:'i-audit-condition-btn-audit',
						//iconCls: 'icon-audit',
						iconCls: 'icon-stamp',
						handler: function(){
						}
				}/*,'-',{
						text:'����',
						id:'i-audit-condition-btn-undo',
						iconCls: 'icon-antundo'
				},'-'*/,{
						text:'�ܾ�',
						id:'i-audit-condition-btn-refuse',
						//iconCls: 'icon-antrefuse',
						iconCls: 'icon-audit-x'
		}],
        onClickRow: function(rowIndex, rowData){
			if (websys_getAppScreenIndex()==0){
				var Obj={EpisodeID:"",ApplyId:rowData.id,PageShowFromWay:"ListEntry"};
				websys_emit("onOpenKSSInterface",Obj);
			}
		},
		onDblClickRow: function(rowIndex, rowData) {
			findApplyInfo(rowData);
			return false;
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
			
			if (rowData.Emergency == "��") {
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
				title: '����ҩ��������ϸ��Ϣ',
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
			{field:'PatName',title:'��������',width:80},
			{field:'kssjb',title:'�����ؼ���',width:80},
			{field:'arcimDesc',title:'ҩƷ����',width:150},
			{field:'ApplyLoc',title:'�������',width:100},
			{field:'AppUser',title:'����ҽ��',width:80},
			{field:'Appdate',title:'�ύ��������',width:100},
			{field:'ApplyStatus',title:'״̬����',width:80},
			{field:'ApplyStatusDesc',title:'��ǰ״̬',width:80},
			{field:'UsePurpseDesc',title:'ʹ��Ŀ��',width:150},
			{field:'OPerIndDesc',title:'��ҩָ��',width:200},
			{field:'BodyPartdesc',title:'��Ⱦ��λ',width:100},
			{field:'YFtime',title:'��ҩʱ��',width:80},
			{field:'AuditUserName',title:'�����',width:80},
			{field:'AuditDT',title:'���ʱ��',width:100},
			{field:'Conresult1',title:'������1',width:100,hidden:consultDisplay1},
			{field:'ConSuggestion1',title:'�������1',width:100,hidden:consultDisplay1},
			{field:'Consultdep1',title:'�������1',width:100,hidden:consultDisplay1},
			{field:'Consultdoc1',title:'����ҽ��1',width:100,hidden:consultDisplay1},
			{field:'Conresult2',title:'������2',width:100,hidden:consultDisplay2},
			{field:'ConSuggestion2',title:'�������2',width:100,hidden:consultDisplay2},
			{field:'Consultdep2',title:'�������2',width:100,hidden:consultDisplay2},
			{field:'Consultdoc2',title:'����ҽ��2',width:100,hidden:consultDisplay2},
			{field:'Conresult3',title:'������3',width:100,hidden:consultDisplay3},
			{field:'ConSuggestion3',title:'�������3',width:100,hidden:consultDisplay3},
			{field:'Consultdep3',title:'�������3',width:100,hidden:consultDisplay3},
			{field:'Consultdoc3',title:'����ҽ��3',width:100,hidden:consultDisplay3},
			{field:'Emergency',title:'�Ƿ�Խ��',width:100},
			{field:'EmergecyReason',title:'Խ������',width:100},
			{field:'Predictdays',title:'Ԥ����ҩ����',width:100, hidden:yfDrugDisplay},
			{field:'ExtendEason',title:'�ӳ���ҩԭ��',width:100, hidden:yfDrugDisplay},
			{field:'process',title:'��ǰ����',width:100},
			{field:'id',title:'id',width:100,hidden:false}
		]]
	});
	
	SetDefaultAuthType();
	
	$("#i-audit-condition-btn-find").on('click', function(){
		reloadGrid();
	})
	
	$("#i-audit-condition-btn-audit").on('click', function(){
		var preAudit = $("#i-audit-condition-preaudit").is(':checked');
		var hasAudit = $("#i-audit-condition-hasaudit").is(':checked');
		var ksAudit = $("#i-audit-condition-ksaudit").is(':checked') ? 1 : 0;
		var lastAudit = $("#i-audit-condition-lastaudit").is(':checked')? 1 : 0;
		
		if (hasAudit) {
			//layer.alert($g("�Ѿ������˵������¼��������ˣ�"), {title:$g("��ʾ"),icon: 0,btn: [$g('ȷ��')]}); 
			$.messager.alert("��ʾ","�Ѿ������˵������¼��������ˣ�","warning")
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
			//layer.alert($g("��ѡ��һ����¼��"), {title:$g("��ʾ"),icon: 0,btn: [$g('ȷ��')]}); 
			$.messager.alert("��ʾ","��ѡ��һ����¼��","warning")
			return false;
		};
		var type="KSF";	//Ĭ��Ϊ����Ԥ��
		var ksAudit = $("#i-audit-condition-ksaudit").is(':checked') ? 1 : 0;
		var lastAudit = $("#i-audit-condition-lastaudit").is(':checked')? 1 : 0;
		if (ksAudit == "1") type = "KS";
		if (lastAudit == "1") type = "LAST";
		var result = $.InvokeMethod("DHCAnt.KSS.MainBusiness","VerifyApply",aaRwoid.join('^'),type,'SH');
		if (result == 0) {
			//layer.alert($g("��˳ɹ���"), {title:$g("��ʾ"),icon: 6}); 
			$.messager.alert("��ʾ","��˳ɹ���","warning")
		} else {
			//layer.alert($g("���ʧ�ܣ�"), {title:$g("��ʾ"),icon: 5}); 
			$.messager.alert("��ʾ","���ʧ�ܣ�","warning")
		};
		reloadGrid();
	})
	
	$("#i-audit-condition-btn-undo").on("click", function () {
		///
		var preAudit = $("#i-audit-condition-preaudit").is(':checked');
		var hasAudit = $("#i-audit-condition-hasaudit").is(':checked');
		var ksAudit = $("#i-audit-condition-ksaudit").is(':checked') ? 1 : 0;
		var lastAudit = $("#i-audit-condition-lastaudit").is(':checked')? 1 : 0;
		if (!hasAudit) {
			layer.alert($g("��ѡ������˹���������г�����"), {title:$g("��ʾ"),icon: 0,btn: [$g('ȷ��')]}); 
			return false;
		};
		
		var aaRwoid = [];
		auditSelectedRows = $('#i-audit-list-grid').datagrid('getSelections');
		for (var i = 0; i < auditSelectedRows.length; i++) {
			var applyStatus = auditSelectedRows[i].ApplyStatus;
			var applyProcess = auditSelectedRows[i].process;
			if (preAudit) {
				/*
					1�������������˵ģ���������г�����������һ���ĳ�������������һ����ɡ�
					2��
				
				*/
				
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
			layer.alert($g("��ѡ��һ����¼��"), {title:$g("��ʾ"),icon: 0}); 
			return false;
		};
		
	});
	$("#i-audit-condition-btn-refuse").on('click', function(){
		var preAudit = $("#i-audit-condition-preaudit").is(':checked');
		var hasAudit = $("#i-audit-condition-hasaudit").is(':checked');
		var ksAudit = $("#i-audit-condition-ksaudit").is(':checked') ? 1 : 0;
		var lastAudit = $("#i-audit-condition-lastaudit").is(':checked')? 1 : 0;
		if (hasAudit) {
			//layer.alert($g("�Ѿ������˵������¼�����ܾܾ���"), {title:$g("��ʾ"),icon: 0,btn: [$g('ȷ��')]}); 
			$.messager.alert("��ʾ","�Ѿ������˵������¼�����ܾܾ���","warning")
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
			//layer.alert($g("��ѡ��һ����¼��"), {title:$g("��ʾ"),icon: 0}); 
			$.messager.alert("��ʾ","��ѡ��һ����¼��","warning")
			return false;
		};
		
		var type="KSF";	//Ĭ��Ϊ����Ԥ��ܾ�
		if (ksAudit == "1") type = "KS";
		if (lastAudit == "1") type = "LAST";
		var result = $.InvokeMethod("DHCAnt.KSS.MainBusiness","VerifyApply",aaRwoid.join('^'),type,'RU');
		if (result == 0) {
			//layer.alert($g("�ܾ��ɹ���"), {title:$g("��ʾ"),icon: 6}); 
			$.messager.alert("��ʾ","�ܾ��ɹ���","warning")
		} else {
			//layer.alert($g("�ܾ�ʧ�ܣ�"), {title:'��ʾ',icon: 5}); 
			$.messager.alert("��ʾ","�ܾ�ʧ�ܣ�","warning")
		};
		reloadGrid();
	})
	
	/*
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
	*/
	
	function SetDefaultAuthType () {
		//����Ĭ���������
		if (auditType == "U") {
			auditValue = "0,0,1,0";
			$('#i-audit-condition-lastaudit').radio('check');	//8.20HISUI���²���֧��iCheck
		} else if (auditType == "S") {
			auditValue = "0,1,0,0";
			$('#i-audit-condition-ksaudit').radio('check');
		} else {
			$('#i-audit-condition-preaudit').radio('check');
		};
	}
	
	function InitEvent () {
		$("#i-audit-condition-preaudit").radio({
			onChecked: function () {
				reloadGrid();
			}
		})
		
		$("#i-audit-condition-ksaudit").radio({
			onChecked: function () {
				reloadGrid();
			}
		})
		
		$("#i-audit-condition-lastaudit").radio({
			onChecked: function () {
				reloadGrid();
			}
		})
		
		$("#i-audit-condition-hasaudit").checkbox({
			onChecked: function () {
				$("#i-audit-condition-btn-audit").attr("disabled","disabled");
				$("#i-audit-condition-btn-refuse").attr("disabled","disabled");
				reloadGrid();
			},
			onUnchecked: function () {
				$("#i-audit-condition-btn-audit").removeAttr("disabled");
				$("#i-audit-condition-btn-refuse").removeAttr("disabled");
				reloadGrid();
			}
		})
		
	}
	
	function sendMsgByType(applyType, applyStatus, applyProcess, action) {
		var pU = (applyProcess.indexOf("U") >= 0 ),
			pS = (applyProcess.indexOf("S") >= 0 ),
			pH = (applyProcess.indexOf("H") >= 0 ),
			pF = (applyProcess.indexOf("F") >= 0 ),
			pA = (applyProcess.indexOf("A") >= 0 ),
			acName = "���",
			resultObj = {title:$g("��ʾ"), value:0, msg:"", icon:"info"};	//Ĭ�ϲ�������ʾ	
		if ( action == "RU") acName = "�ܾ�";
		if ( applyType == "KSF" ) {
			if (applyStatus != "A") {
				resultObj.value = 1;
				resultObj.msg = $g("���ã�״̬��Ϊ����ļ�¼������Ԥ���ܽ��У�")
			};
			return resultObj;
		};
		if ( applyType == "KS" ) {
			if (( applyStatus == "U")||(( applyStatus == "R"))) {
				resultObj.value = 1;
				resultObj.msg = "�Ѿ������ɵģ�����" + acName + "��лл��";
				return resultObj;
			};
			if ( pS ) {
				resultObj.msg = "��û�н����ϸ����̵Ĳ��������ܽ��п���" + acName + "��лл��";
				if ( pH ) {
					if (action == "RU" ) {
						//resultObj.value = 1;
						//resultObj.msg = "�����Ѿ�ͨ�������ܽ���" + acName + "������лл��";
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
				resultObj.msg = "���̲���������Ԥ�󣬲��ܽ��п�����ˣ�";
				resultObj.icon = "warning";
			}
			return resultObj;
		};
		
		if ( applyType == "LAST" ) {
			if (( applyStatus == "U")||(( applyStatus == "R"))) {
				resultObj.value = 1;
				resultObj.msg = "�Ѿ������ɵģ�����"+ acName + "��";
				return resultObj;
			};
			if ( pU ) {
				resultObj.msg = "��û������ϸ����̣�����"+ acName + "��";
				if (pS) {
					if ( applyStatus != "S") resultObj.value = 1;
				} else if (pH) {
					if (action == "RU" ) {
						//resultObj.value = 1;
						//resultObj.msg = "�����Ѿ�ͨ�������ܽ���" + acName + "������лл��";
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
				resultObj.msg = "���̲�����������ˣ����ܽ���������˺;ܾ�������";
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
		var preAudit = $("#i-audit-condition-preaudit").is(':checked') ? 1 : 0;
		var ksAudit = $("#i-audit-condition-ksaudit").is(':checked') ? 1 : 0;
		var lastAudit = $("#i-audit-condition-lastaudit").is(':checked')? 1 : 0;
		var hasAudit = $("#i-audit-condition-hasaudit").is(':checked')? 1 : 0;
		if (!stDate||!endDate) {
			//layer.alert($g("�����뿪ʼ���ںͽ������ڣ�"), {title:$g("��ʾ").title,icon: 0}); 
			$.messager.alert("��ʾ","�����뿪ʼ���ںͽ������ڣ�","warning")
			return false;
		};
		if ((preAudit==0)&&(ksAudit==0)&&(lastAudit==0)) {
			//layer.alert($g("����ѡ��һ��������ͣ�"), {title:"��ʾ".title,icon: 0}); 
			$.messager.alert("��ʾ","����ѡ��һ��������ͣ�","warning")
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

function findApplyInfo(rowData) {
	var ShowTabStr = "Apply";
	if (rowData.process.indexOf("H")>=0 ) {
		ShowTabStr = "Apply,Consult"
	}
	var OrderAntibApplyRowid = rowData.id;
	var PAADMRowid = rowData.ApplyAdmDR;
	var ArcimRowid = rowData.arcim;
	var OrderPoisonCode = rowData.KssCode;
	var PAAdmType = rowData.PAAdmType;
	var EmerFlag = "";
	
	var src="dhcant.kss.business.findapply.csp?ShowTabStr="+ShowTabStr+"&PAADMRowid="+PAADMRowid+"&ArcimRowid="+ArcimRowid+"&OrderPoisonCode="+OrderPoisonCode+"&PAAdmType="+PAAdmType+"&OrderAntibApplyRowid="+OrderAntibApplyRowid;
    if ('undefined'!==typeof websys_getMWToken){
        src += "&MWToken="+websys_getMWToken();
    }
	var $code ="<iframe width='100%' height='100%' scrolling='auto' frameborder='0' src='"+src+"'></iframe>" ;
	createModalDialog("findapply",$g("����ҩ�����뵥��Ϣ"), 1200, 600,"icon-w-edit","",$code,"");
}

function createModalDialog(id, _title, _width, _height, _icon,_btntext,_content,_event){
    $("body").append("<div id='"+id+"' style='overflow:hidden;' class='hisui-dialog'></div>");
    if (_width == null)
        _width = 800;
    if (_height == null)
        _height = 500;
    $("#"+id).dialog({
        title: _title,
        width: _width,
        height: _height,
        cache: false,
        iconCls: _icon,
        //href: _url,
        collapsible: false,
        minimizable:false,
        maximizable: false,
        resizable: false,
        modal: true,
        closed: false,
        closable: true,
        content:_content,
        onClose:function(){
	        destroyDialog(id);
	    }
    });
}

function destroyDialog(id){
   //�Ƴ����ڵ�Dialog
   $("body").remove("#"+id); 
   $("#"+id).dialog('destroy');
}


