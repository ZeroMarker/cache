function InitCtlResultWinEvent(obj){
	obj.LoadEvent=function(){    
		$('#gridReport').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
		obj.gridReportLoad();	
		$("#btnQuery").on('click',function(){
			obj.reloadgridReport();
		});
		$("#btnExport").on('click',function(){
			obj.btnExportSel_click();
		});
		$("#btnExportMK").on('click',function(){
			obj.btnExportInterface_click();
		});
		//登记号补零 length位数
		var length=10;
		obj.PapmiNo=""
		$("#txtRegNo").keydown(function(event){
			 if (event.keyCode ==13) {
				obj.PapmiNo = $("#txtRegNo").val();
				if(!obj.PapmiNo) return;
				$("#txtRegNo").val((Array(length).join('0') + obj.PapmiNo).slice(-length)); 
				obj.reloadgridReport();
			}
		});	
	}
	//重新加载表格数据
	obj.reloadgridReport = function(){
		var ErrorStr="";
		var HospIDs=$("#cboHospital").combobox('getValue');
		var DateType=$("#cboDateType").combobox('getValue');
	    var DateFrom=$("#DateFrom").datebox('getValue');
	    var DateTo=$("#DateTo").datebox('getValue');
	    if (!HospIDs) {
			ErrorStr += $g("请选择院区!")+'<br/>';
		}
		if (!DateType) {
			ErrorStr += $g("请选择日期类型!")+'<br/>';
		}
		if (DateFrom=="") {
			ErrorStr += $g("请选择开始日期!")+'<br/>';
		}
		if (DateTo == "") {
			ErrorStr += $g("请选择结束日期!")+'<br/>';
		}
		if (Common_CompareDate(DateFrom,DateTo)) {
			ErrorStr += $g("开始日期不能大于结束日期!")+'<br/>';
		}
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}
		obj.gridReportLoad();
		$('#gridReport').datagrid('unselectAll');

	};
	//获取弹窗方式 0为窗口 1为csp
	obj.flg = $m({
		ClassName:"DHCHAI.BT.Config",
		MethodName:"GetValByCode",
		aCode:"IsShowModal"
	},false);
	//感染诊断
	obj.OpenInfPosDialog = function(aEpisodeID,aDiasID,aAdmitDate,aDischDate,rs){
		if(rs==3){
			rs="1";
		}
		var strUrl = "./dhcma.hai.ir.infdiagnos.csp?EpisodeID=" + aEpisodeID + "&DiagID=" + aDiasID +"&AdmitDate=" + aAdmitDate +"&DischDate=" + aDischDate+"&rs=" + rs;
		var ratio =detectZoom();
        var PageWidth=Math.round(1000*ratio);
		if(obj.flg=="1"){
			websys_showModal({
				url:strUrl,
				title:$g("感染诊断-编辑"),
				iconCls:'icon-w-paper',  
				width:PageWidth,
				height:'560',
				onBeforeClose:function(){
					obj.reloadgridReport();
				} 
			});
		}
		else{
			var page= websys_createWindow(strUrl,"","width="+PageWidth+",height=95%");
				//--关闭前刷新查询列表
				var Loop=setInterval(function() {     
 	    		if(page.closed) {   	
 	    			clearInterval(Loop);
 	    			//刷新列表
 	    			obj.reloadgridReport();
 	    			}
 	   			});
			}
    }
	//报告编号
	obj.ShowResutlDtl=function(aReportID) {	
		if (!aReportID) return;	
		var strUrl="dhcma.hai.ir.inf.report.csp?1=1&ReportID="+aReportID+'&AdminPower='+ obj.AdminPower+"&2=2";	
		var ratio =detectZoom();
        var PageWidth=Math.round(1322*ratio);
		if(obj.flg=="1"){
			websys_showModal({
				url:strUrl,
				title:$g("医院感染报告"),
				iconCls:'icon-w-paper',
				closable:true,  
				width:PageWidth,
				height:'95%',
				onBeforeClose:function(){
					obj.reloadgridReport();
				} 
			});
		}
		else{
			var page=websys_createWindow(strUrl,"","width="+PageWidth+",height=95%");
			//--关闭前刷新查询列表
			var Loop=setInterval(function() {     
	 	    	if(page.closed) {   	
	 	    		clearInterval(Loop);
	 	    		//刷新列表
	 	    		obj.reloadgridReport();
	 	    	}
	 	    });
		}
	}
	
	//获取当前页面的缩放值
	function detectZoom() {
		var ratio = 1;
		if(BrowserVer=="isChrome") {   //医为浏览器为 Chrome 49
			var userAgent = navigator.userAgent;
            var ChromePos = userAgent.indexOf("Chrome");  //Chrome定位
            var ChromeStr = userAgent.substr(ChromePos);  //Chrome串
            var ChromeArr = ChromeStr.split(" ");
            var ChromeVer = parseInt(ChromeArr[0].split("/")[1]);      //Chrome版本
			if (ChromeVer<=58) {    
				ratio = window.devicePixelRatio;
			}
		}
		return ratio;
	}

	//摘要
	obj.btnAbstractMsg_Click = function(EpisodeID)
	{	
	    var page="";
		var LocFlag=(obj.AdminPowe==1?0:1);
		var strUrl = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen&LocFlag='+LocFlag;
		if(obj.flg=="1"){
			websys_showModal({
				url:strUrl,
				title:$g("医院感染集成视图"),
				iconCls:'icon-w-epr',
				closable:true,
				width:'95%',
				height:'95%',
				onBeforeClose: function () {
		        //刷新列表
				obj.reloadgridReport();
		    	}
			});
		}
		else{
			var page= websys_createWindow(strUrl,"","width=95%,height=95%");
			//--关闭前刷新查询列表
			var Loop=setInterval(function() {     
			if(page.closed) {   	
				clearInterval(Loop);
				//刷新列表
				obj.reloadgridReport();
				}
			});
		}
	};
	//电子病历
	obj.btnEmrRecord_Click = function(EpisodeID)
	{		
		var rst = $m({
			ClassName:"DHCHAI.DPS.PAAdmSrv",
			MethodName:"GetPaAdmHISx",
			aEpisodeID:EpisodeID
		},false);
		if(rst=="")return;
		var EpisodeID = rst.split("^")[0];
		var PatientID = rst.split("^")[1];
		var strUrl = cspUrl+'&PatientID=' + PatientID+'&EpisodeID='+EpisodeID + '&DefaultOrderPriorType=ALL&2=2';
		if(obj.flg=="1"){
			websys_showModal({
				url:strUrl,
				title:$g("电子病历"),
				iconCls:'icon-w-epr',
				closable:true,
				width:'95%',
				height:'95%'
			});
		}
		else{
			var page= websys_createWindow(strUrl,"","width=95%,height=95%");
		}
	};
	//沟通记录
	obj.btnMsgSend_Click = function(PatName,EpisodeID)
	{	
		var MsgType=1;
		if (obj.AdminPower!=1) MsgType=2;
		var url = "../csp/dhcma.hai.ir.ccmessage.csp?EpisodeDr=" + EpisodeID + "&PageType=layerOpen&MsgType="+MsgType;
		websys_showModal({
			url:url,
			title:$g("病人姓名： ")+$g(PatName),
			iconCls:'icon-w-epr',
			originWindow:window,
			width:800,
			height:500
		});
	};
	
	obj.gridReportLoad = function(){
		$('#gridReport').datagrid("loading")
		$cm ({
		    ClassName:'DHCHAI.IRS.INFDiagnosSrv',
		    QueryName:'QryRepInfoByDateLoc',
		    aDateType:$("#cboDateType").combobox('getValue'),
	        aDateFrom:$("#DateFrom").datebox('getValue'),
	        aDateTo:$("#DateTo").datebox('getValue'),
	        aRepLoc:$("#cboLocation").combobox('getValue'),
	        aRepStatus:$("#cboStatus").combobox('getValue'),
	        aRepType:1,
	        aRegNo:$("#txtRegNo").val(),
	        aMrNo:$("#txtMrNO").val(),
	        aPatName:$("#txtPatName").val(),
	        aHospIDs:$("#cboHospital").combobox('getValue'),
	        aInfLoc:$("#cboInfLocation").combobox('getValue'),
	        aInfDiags:$('#cboInfDiags').combobox('getValues').join(),
	    	page:1,
			rows:9999
		},function(rs){
			$('#gridReport').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);	
			$('#gridReport').datagrid('selectRow', obj.rowIndex );				
		});
    }
	
	//导出
	obj.btnExportSel_click = function() {
		var rows=$("#gridReport").datagrid('getRows').length;	
		if (rows>0) {
			$('#gridReport').datagrid('toExcel','感染报告查询.xls');
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
		
	}
	//导出民科接口
	obj.btnExportInterface_click = function (objBtn, objEvent, skipMapping) {
		
		//是否跳过字典对照检查（true：跳过）
		if (typeof skipMapping == 'undefined') skipMapping = false;
		
		var RepIDs="";  // 报告ID列表
		var length=$("#gridReport").datagrid('getChecked').length;
		if (length>0) {
			var rows = $("#gridReport").datagrid('getChecked');
			for(var i=0;i<length;i++){
				var tmpRepID = rows[i]["ReportID"];
				if (tmpRepID!="") {
						RepIDs +=  "^"+tmpRepID;
					} 
				}
		}
		RepIDs=RepIDs.substring(1);
		if (RepIDs == "") {
			$.messager.alert("确认", "请选择需要导出的报告!", 'info');
			return;
		}
		var arrList = RepIDs.split("^");
		ExtTool.RunQuery(
			{
				ClassName : 'DHCHAI.MK.ExportToMKSrv',
				QueryName : 'QryValidateInfo',
				Arg1 : RepIDs,
				Arg2 : "^",
				Arg3 : "1",
				ArgCnt : 3
			},
			function(arryResult, skipMapping){
				if ((arryResult.length > 0) && (!skipMapping)) {
					var objFrm = new InitwinProblem(RepIDs, "^",obj);
					objFrm.winProblem.show();
				} else {
					ExtTool.prompt("文件路径", "请输入民科接口文件存放路径...",
						function(e, text){
							if (e == "ok") {
								var objExportMinke = new ExportMinke();
								var ExportPath = text;
							
								//创建进度条
								Ext.MessageBox.progress("接口文件", "开始导出民科接口文件...");
								var intTotalCnt = arrList.length;
								for(var indRec = 0; indRec < intTotalCnt; indRec++)
								{
									var repID = arrList[indRec];
									//var repInfo = $.Tool.RunServerMethod("DHCHAI.MK.ExportToMKSrv","GetReportInfo",repID);
									var repInfo = $m({
										ClassName:"DHCHAI.MK.ExportToMKSrv",
										MethodName:"GetReportInfo",
										aReportID:repID
									},false)				
									var PatName = repInfo.split("^")[0];
									var PatMrNo = repInfo.split("^")[1];
									var PatAdmDate = repInfo.split("^")[2];
									//更新进度条
									Ext.MessageBox.updateProgress(indRec/intTotalCnt, '', "正在处理：" + PatMrNo + " " + PatName);
									var strfolderName = PatMrNo + " " + PatName + " " + PatAdmDate;
									var strPath = ExportPath + "\\" + strfolderName;
									objExportMinke.ExportMinkeData(repID, strPath,RepIDs);
								}
								
								//关闭进度条
								Ext.MessageBox.hide();
								//$.messager.confirm("删除", "是否删除选中数据记录?", function (r) {
								$.messager.confirm("完成","共处理了" + intTotalCnt + "份患者感染报告信息,是否打开文件存放文件夹!", function (r){
									if (r) {	
										/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
											var WshShell = new ActiveXObject("WScript.Shell");
											var oExec = WshShell.Exec("explorer.exe " + ExportPath);
										}else {*/
											if (EnableLocalWeb==1) {  //非IE浏览器，且启用中间件
												var Str ="(function test(x){"
												Str += "var WshShell = new ActiveXObject('WScript.Shell');"+ '\n'
												var arryFolder = ExportPath.split("\\");
												var strPath = arryFolder[0];
												for(var i = 1; i < arryFolder.length; i ++){
													if(arryFolder[i] == "") continue;
													strPath += "\\\\" + arryFolder[i];		
												}
												Str += "var oExec = WshShell.Exec('"+"explorer.exe " +strPath+"');"+ '\n'
									            Str += "return 1;}());";
												CmdShell.notReturn =0;  
												var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
											}
										//}
								 	}
								 });
							}
						},
						null,
						false,
						"D:\\民科感染报告接口文件"
					)
				}
			}
			,obj
			,skipMapping
		)
	};
	//检索框
    $('#searchbox').searchbox({
        searcher: function (value, name) {
	        if(value=="") {
		       $('#btnQuery').click();
		    } else {
			    searchText($("#gridReport"), value,1);
			}           
        }
    });
}

