//页面Event
function InitCtlResultWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
		obj.InfDicTreeShow();
		obj.getChecked();
	    //查询
		$('#btnQuery').on('click', function(){
	     	obj.btnQuery_click();
     	});

		//监控
		$('#btnControl').on('click', function(){
			obj.btnControl_click();
		});	
		
		//确诊
		$('#btnConfirm').on('click', function(){
	     	obj.btnConfirm_click();
     	});

		//排除
		$('#btnExclude').on('click', function(){
			obj.btnExclude_click();
		});	
	}
	
	//窗体初始化
	obj.CasesHandleEdit = $('#CasesHandleEdit').dialog({
		title:'处置操作',
		iconCls:'icon-w-edit',
		closed: true,
		modal: true,
		isTopZindex:true
	});

	//查询
	obj.btnQuery_click = function(){
		var DateFrom = $('#DateFrom').datebox('getValue');
		var DateTo = $('#DateTo').datebox('getValue');
		if ((DateFrom == '')||(DateTo == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!",'info');
			return;
		}
		if (Common_CompareDate(DateFrom,DateTo)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!",'info');
			return;
		}
        var aInfDics = obj.getChecked();
        if (!aInfDics) {
			$.messager.alert("提示","至少选择一条疑似诊断!",'info');
			return;
		}
		obj.CtlResultLoad();
	}
	
	obj.CtlResultLoad = function(){	
		obj.girdCtlResult.load({
		    ClassName:'DHCMed.EPDService.SuspCasesXSrv',
			QueryName:'QryCasesX',
			aHospID:$('#cboSSHosp').combobox('getValue'),
			aDateType:Common_RadioValue('radDateType'),
			aDateFrom:$('#DateFrom').datebox('getValue'),
			aDateTo:$('#DateTo').datebox('getValue'),
			aInfDics:obj.getChecked(),
			aLocID:$('#cboLoc').combobox('getValue'),
			aAdmType:Common_CheckboxValue('chkAdmType'),
			aIsRep:Common_CheckboxValue('chkIsRep'),
			aRstType:Common_CheckboxValue('chkRstType')			
	    });	
	}		
	//监控
	obj.btnControl_click = function(){
		var msg = $.messager.progress({
			title: "提示",
			msg: '日期：'+Common_GetDate(new Date())+' 任务正在执行',
			interval:'30000',
		});
		$.ajax({
			url : $URL,
			type : "POST",
			timeout: 1000000,
			data : {
				ClassName:"DHCMed.EPDService.AutoTask",
				MethodName:"AutoTask",
				aDateFrom:Common_GetDate(new Date()),
				aDateTo:Common_GetDate(new Date())
			},
			success:function(response){
				var tmpText = response;  //输出内容最前端多了一个字符	
				if ((!tmpText)||(tmpText=='Error')) {
					$.messager.progress("close");
					$.messager.alert('提示','任务执行有误，请检查后重新执行！', "info");		
				}
				if (tmpText.indexOf('OK') > -1) {
					//执行完毕
					setTimeout(function() {
						$.messager.progress("close");		
						obj.CtlResultLoad();//执行默认查询
					},2000);
				}
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){
				$.messager.progress("close");
				if ((XMLHttpRequest.status == 504)||(textStatus == "timeout")) {
					$.messager.alert('提示','任务超时，请重新执行！', "info");	
				} else {
					$.messager.alert('错误','任务发生错误，请检查后重新执行！', "error");	
				}
			}
		});
	}
	
	//疑似诊断鼠标提示
	obj.CasesXDtlTip = function(CasesXID) {
		$m({
			ClassName:'DHCMed.EPDService.SuspCasesXSrv',
			QueryName:'QryCasesXDtl',
			aCasesXID:CasesXID
		},function(jsonData){
			//关键词包含伤寒：诊断 131||4 A01.000 伤寒
			var json = JSON.parse(jsonData);
			var htmlStr ='<div><span style="line-height:25px;">筛查明细：</span></br>';
			for (var index =0; index< json.total; index++) {
				var Condition = json.rows[index].Condition;
				var ContDesc = json.rows[index].ContDesc;
				var HappenDate = json.rows[index].DHappenDate;
				var HappenTime = json.rows[index].DHappenTime;
				htmlStr +='<span style="line-height:25px;">'+(index+1)+". <span style='color:blue'>("+Condition+")</span> "+ContDesc+" "+HappenDate+" "+HappenTime+'</span></br>';	
			}
			htmlStr +='</div>';
		 
			$("#ActDiagnos"+CasesXID).popover({
				width:'600px',
				content:htmlStr,
				trigger:'hover',
				placement:'left',
				type:'html'
			});
			$("#ActDiagnos"+CasesXID).popover('show');    
		});		
	}
    //处置显示
	objScreen.CasesHandleEdit = function(aCasesXID,aInfectID,aOpinion){
		var ret = $m({
			ClassName:"DHCMed.EPDService.SuspCasesXSrv",
			MethodName:"CheckCasesStatus",
			aSubjectCode:'EPDCC', 
			aCasesXID:aCasesXID
		},false);
		if (ret<1) {
			$.messager.alert("提示","已经“确诊”或“排除”的处置不允许再操作!",'info');
			return true;
		}else{			
			$HUI.dialog('#CasesHandleEdit').open();
		}
		
		obj.CasesXID = aCasesXID;
		$('#cboInfect').combobox('setValue',aInfectID);
	    $('#txtOpinion').val(aOpinion);	
		$HUI.dialog('#CasesHandleEdit').open();
	}
	
	//确诊
	obj.btnConfirm_click = function(){
		var InfectID = $.trim($('#cboInfect').combobox('getValue')); 
		var Opinion = $.trim($('#txtOpinion').val()); 
		var LocID = session['LOGON.CTLOCID'];
		var UserID = session['LOGON.USERID'];
	  
		if (!InfectID) {
			$.messager.alert("提示","“确诊”需选择标准传染病诊断!",'info');
			return true;
		}else {
			var flg = $m({
				ClassName:"DHCMed.EPDService.SuspCasesXSrv",
				MethodName:"ProcCasesHandle",
				aSubjectCode:'EPDCC', 
				aCasesXID:obj.CasesXID, 
				aOperation:1, 
				aDiagnosID:InfectID, 
				aOpinion:Opinion, 
				aLocID:LocID,
				aUserID:UserID
			},false);
			
			if (flg>0) {
				$HUI.dialog('#CasesHandleEdit').close();
				$.messager.popover({msg: '确诊处置成功！',type:'success',timeout: 1000});
				obj.CtlResultLoad() ;//刷新当前页
			}else {
				$.messager.alert("错误提示","“确诊”处置失败!",'error');
				return true;
			}
		}
	}
	//排除
	obj.btnExclude_click = function() {
		var InfectID = $.trim($('#cboInfect').combobox('getValue')); 
		var Opinion = $.trim($('#txtOpinion').val()); 
		var LocID = session['LOGON.CTLOCID'];
		var UserID = session['LOGON.USERID'];
	  
		if (!Opinion) {
			$.messager.alert("提示","“排除”需填写处置意见!",'info');
			return true;
		}else {
			var flg = $m({
				ClassName:"DHCMed.EPDService.SuspCasesXSrv",
				MethodName:"ProcCasesHandle",
				aSubjectCode:'EPDCC', 
				aCasesXID:obj.CasesXID, 
				aOperation:0, 
				aDiagnosID:InfectID, 
				aOpinion:Opinion, 
				aLocID:LocID,
				aUserID:UserID
			},false);
			
			if (flg>0) {
				$HUI.dialog('#CasesHandleEdit').close();
				$.messager.popover({msg: '排除处置成功！',type:'success',timeout: 1000});
				obj.CtlResultLoad() ;//刷新当前页
			}else {
				$.messager.alert("错误提示","“排除”处置失败!",'error');
				return true;
			}
		}

	}
	//未报
	obj.btnReport_Click = function(aEpisodeID,aPatientID,aInfectID){
		var strUrl = "./dhcma.epd.report.csp?1=1"+
			"&PatientID=" + aPatientID + 
			"&EpisodeID=" + aEpisodeID + 
			"&IFRowID=" + aInfectID +
			"&LocFlag=" + 1;
        
	    websys_showModal({
			url:strUrl,
			title:'传染病报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1340,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.CtlResultLoad();  //刷新当前页
			} 
		});
	}
	
	//打开报告
    obj.btnDetail_Click =function(aReportID,aEpisodeID,aPatientID) {
		var strUrl = "./dhcma.epd.report.csp?1=1"+
			"&PatientID=" + aPatientID + 
			"&EpisodeID=" + aEpisodeID + 
			"&ReportID=" + aReportID +
			"&LocFlag=" + 1;	
	
	    websys_showModal({
			url:strUrl,
			title:'传染病报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:1340,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.CtlResultLoad();  //刷新当前页
			} 
		});
	}
	
	 obj.OpenEMR =function(aEpisodeID,aPatientID) {

		 
		var strUrl = cspUrl+"&PatientID=" + aPatientID+"&EpisodeID="+aEpisodeID + "&2=2";
		//var strUrl = "./emr.record.browse.csp?PatientID=" + aPatientID+"&EpisodeID="+aEpisodeID + "&2=2";
	    websys_showModal({
			url:strUrl,
			title:'病历浏览',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			width:'98%',
			height:'98%'
		});
		
	}
}