//页面Event
function InitCtlResultWinEvent(obj){	
    //初始化
	obj.LoadEvent = function(args){ 
	    //查询
		$('#btnQuery').on('click', function(){
	     	obj.btnQuery_click();
     	});
		
		//监控
		$('#btnControl').on('click', function(){
			obj.btnControl_click();
		});	
		
		//标记上报
		$('#btnConfirm').on('click', function(){
	     	obj.btnConfirm_click();
     	});

		//排除
		$('#btnExclude').on('click', function(){
			var RowData = $("#girdCtlResult").datagrid("getSelected")
			if (!RowData) {
				$.messager.alert("提示","请先选中数据行!",'info');
				return true;
			}
			obj.CasesXID=RowData.CasesXID;
			$HUI.dialog('#CasesHandleEdit').open();
		});	
		$('#btnSaveOpinion').on('click', function(){
			obj.btnExclude_click();
		});
		
	}
	
	//窗体初始化
	obj.CasesHandleEdit = $('#CasesHandleEdit').dialog({
		title:'请填写排除原因',
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
		obj.CtlResultLoad();
	}
	
	//加载表格内容
	obj.CtlResultLoad = function(){	
		obj.girdCtlResult.load({
		   ClassName:'DHCMed.SSService.CaseXSrv',
			QueryName:'QryPatInfo',
			aProductCode:ProductCode,
			aHospIDs:$('#cboSSHosp').combobox('getValue'),
			//aDateType:Common_RadioValue('radDateType'),
			aDateFrom:$('#DateFrom').datebox('getValue'),
			aDateTo:$('#DateTo').datebox('getValue'),
			aLoc:$('#cboLoc').combobox('getValue'),
			aAdmType:Common_CheckboxValue('chkAdmType'),
			aStatus:Common_CheckboxValue('chkStatus')
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
				ClassName:"DHCMed.SSService.AutoTask",
				MethodName:"StartTask",
				aProductCode:ProductCode,
				aDateFrom:Common_GetDate(new Date()),
				aDateTo:Common_GetDate(new Date())
			},
			success:function(response){
				var tmpText = response;  //输出内容最前端多了一个字符
				console.log(tmpText)			
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
				console.log(textStatus)	
				if ((XMLHttpRequest.status == 504)||(textStatus == "timeout")) {
					$.messager.alert('提示','任务超时，请重新执行！', "info");	
				} else {
					$.messager.alert('错误','任务发生错误，请检查后重新执行！', "error");	
				}
			}
		});
	}
	
	//诊断提示
	obj.CasesXDtlTip = function(CasesXID) {
		$m({
			ClassName:'DHCMed.SSService.CaseXSrv',
			QueryName:'QryCasesXDtl',
			aCasesXID:CasesXID
		},function(jsonData){
			var json = JSON.parse(jsonData);
			var htmlStr ='<div><span style="line-height:25px;">筛查明细：</span></br>';
			for (var index =0; index< json.total; index++) {
				var TypeDesc = json.rows[index].TypeDesc;
				var ContDesc = json.rows[index].ContDesc;
				var HappenDate = json.rows[index].DHappenDate;
				var HappenTime = json.rows[index].DHappenTime;
				htmlStr +='<span style="line-height:25px;">'+(index+1)+". <span style='color:blue'>("+TypeDesc+")</span> "+ContDesc+" "+HappenDate+" "+HappenTime+'</span></br>';	
			}
			htmlStr +='</div>';

			$("#ActDiagnosDesc"+CasesXID).popover({
				width:'600px',
				content:htmlStr,
				trigger:'hover',
				placement:'right',
				type:'html'
			});
			$("#ActDiagnosDesc"+CasesXID).popover('show');    
		});		
	}
	
	//标记上报
	obj.btnConfirm_click = function(){
		var RowData = $("#girdCtlResult").datagrid("getSelected")
		var LocID = session['LOGON.CTLOCID'];
		var UserID = session['LOGON.USERID'];
	  
		if (!RowData) {
			$.messager.alert("提示","请先选中数据行!",'info');
			return true;
		}else {
			obj.CasesXID=RowData.CasesXID
			var flg = $m({
				ClassName:"DHCMed.SSService.CaseXSrv",
				MethodName:"SetCXStatus",
				aCasesXID:obj.CasesXID, 
				aStatus:1, 
				aOpinion:"", 
				aLocID:LocID,
				aUserID:UserID
			},false);
			
			if (flg>0) {
				$.messager.popover({msg: '标记成功！',type:'success',timeout: 1000});
				obj.CtlResultLoad() ;//刷新当前页
			}else {
				$.messager.alert("错误提示","标记失败!",'error');
				return true;
			}
		}
	}
	
	//排除
	obj.btnExclude_click = function() {
		var Opinion = $.trim($('#txtOpinion').val()); 
		var LocID = session['LOGON.CTLOCID'];
		var UserID = session['LOGON.USERID'];
		
		if (!Opinion) {
			$.messager.alert("提示","“排除”需填写处置意见!",'info');
			$('#txtOpinion').val("");	
			return true;
		}else {
			var flg = $m({
				ClassName:"DHCMed.SSService.CaseXSrv",
				MethodName:"SetCXStatus",
				aCasesXID:obj.CasesXID, 
				aStatus:0, 
				aOpinion:Opinion, 
				aLocID:LocID,
				aUserID:UserID
			},false);
			
			if (flg>0) {
				$HUI.dialog('#CasesHandleEdit').close();
				$('#txtOpinion').val("");	
				$.messager.popover({msg: '排除成功！',type:'success',timeout: 1000});
				obj.CtlResultLoad() ;//刷新当前页
			}else {
				$.messager.alert("错误提示","排除失败!"+flg,'error');
				return true;
			}
		}

	}
	
	//双击上报
	obj.btnReport_Click = function(aProductCode,aEpisodeID,aPatientID,aDiseaseID,aDiseaseType){
		if (aProductCode=="CD"){
			obj.OpenCDReport("",aEpisodeID,aPatientID,aDiseaseID,aDiseaseType)
		}else if(aProductCode=="FBD"){
			obj.OpenFBDReport("",aEpisodeID,aPatientID,aDiseaseID)
		}
	}
	
	//打开历史报告
    obj.btnDetail_Click =function(aProductCode,aReportID,aEpisodeID,aPatientID,DiseaseID,DiseaseType) {
		if (aProductCode=="CD"){
			obj.OpenCDReport(aReportID,aEpisodeID,aPatientID,DiseaseID,DiseaseType)
		}else if(aProductCode=="FBD"){
			obj.OpenFBDReport(aReportID,aEpisodeID,aPatientID,DiseaseID)
		}
	}
	//慢病报告卡
	obj.OpenCDReport=function(aRepID,strEpisodeID,strPatientID,IFRowID,RepType)
	{
		switch(RepType)
			{
				case "ZLK":
				var strUrl="dhcma.cd.reportzlk.csp?1=1&ReportID="+aRepID+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + IFRowID + "&LocFlag=0";
				break;
				case "XNXG":
				var strUrl="dhcma.cd.reportxnxg.csp?1=1&ReportID="+aRepID+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + IFRowID + "&LocFlag=0";
				break;
				case "TNB":
				var strUrl="dhcma.cd.reporttnb.csp?1=1&ReportID="+aRepID+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + IFRowID + "&LocFlag=0";
				break;
				case "NYZD":
				var strUrl="dhcma.cd.reportnyzd.csp?1=1&ReportID="+aRepID+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + IFRowID + "&LocFlag=0";
				break;
				case "SHK":
				var strUrl="dhcma.cd.reportshk.csp?1=1&ReportID="+aRepID+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + IFRowID + "&LocFlag=0";
				break;
				case "YSZYB":
				var strUrl="dhcma.cd.reportyszyb.csp?1=1&ReportID="+aRepID+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + IFRowID + "&LocFlag=0";
				break;
				case "GWZS":
				var strUrl="dhcma.cd.reportgwzs.csp?1=1&ReportID="+aRepID+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + IFRowID + "&LocFlag=0";
				break;
				case "FZYCO":
				var strUrl="dhcma.cd.reportfzyco.csp?1=1&ReportID="+aRepID+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + IFRowID + "&LocFlag=0";
				break;
				case "MBBK":
				var strUrl="dhcma.cd.reportmbbk.csp?1=1&ReportID="+aRepID+"&EpisodeID="+strEpisodeID+"&PatientID="+strPatientID+"&IFRowID=" + IFRowID + "&LocFlag=0";
				case 'CSQX':
				var strUrl= "dhcma.cd.reportcsqx.csp?1=1&ReportID=" + aRepID + "&EpisodeID=" + strEpisodeID + "&PatientID="+strPatientID + "&t=" + t;
				break;		
										
				default:
				var strUrl="";
				break;
			}
			websys_showModal({
				url:strUrl,
				title:'慢性疾病报告',
				iconCls:'icon-w-epr',  
				originWindow:window,
				closable:false,
				width:1320,
				height:'88%',
				onBeforeClose:function(){
					obj.btnQuery_click();
				} 
			});
	}
	//食源性疾病报告
	obj.OpenFBDReport=function(aRepID,EpisodeID,PatientID,DiseaseID)
	{
		var strUrl = "./dhcma.fbd.report.csp?1=1"+ "&ReportID=" + aRepID + "&PatientID=" + PatientID 
				   + "&EpisodeID=" + EpisodeID + "&DiseaseID="+ "&LocFlag=0" ;
		websys_showModal({
			url:strUrl,
			title:'食源性疾病报告',
			iconCls:'icon-w-epr',  
			originWindow:window,
			closable:false,
			width:1320,
			height:'98%',
			onBeforeClose:function(){
				obj.btnQuery_click();
			} 
		});
	}
	//打开病历浏览
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
