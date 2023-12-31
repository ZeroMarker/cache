﻿//页面Event
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args){ 
	
		obj.chkStatus();
	    $('#gridEpdQuery').datagrid('loadData',{ 'total':'0',rows:[] });  //初始加载显示记录为0
	    obj.EpdQueryLoad();
		 //系统时间
		obj.LoadSysDateTime  = function () {  
			var SysDateTimeStr =  $m({                  
				ClassName:"DHCMed.EPDService.CommonSrv",
				MethodName:"GetSysDateTime"
			},false);
			return SysDateTimeStr;
		}
		//查询
		$('#btnQuery').on('click', function(){
			obj.EpdQueryLoad();
		});
		//选择导出
		$('#btnImport').on('click', function(){
	     	obj.btnImport_click();
     	});
     	//批量审核
		$('#btnBatchCheck').on('click', function(){
			obj.btnBatchCheck_click();
		});
		//全部导出
		$('#btnAllImport').on('click', function(){
	     	obj.btnAllImport_click();
     	});
		//导出报告
		$('#btnImpRep').on('click', function(){
	     	obj.btnImpRep_click();
     	});
		//科室选择事件
		$HUI.combobox("#cboLoc", {
			onSelect:function(){
				obj.EpdQueryLoad();
			}
		});
		//疾病类型选择事件
		$HUI.combobox("#cboMIFKind", {
			onSelect:function(){
				obj.EpdQueryLoad();
			}
		});
		//是否上报CDC选择事件
		$HUI.combobox("#cboCDCStatus", {
			onSelect:function(){
				obj.EpdQueryLoad();
			}
		});
		//上报位置选择事件
		$HUI.combobox("#cboRepPlace", {
			onSelect:function(){
				obj.EpdQueryLoad();
			}
		});
			
		$("#schRegNoName").searchbox({
			 searcher:function(value,name){
				 obj.EpdQueryLoad();
	    	}
		});
		
    $('#EPDLogDetail').dialog({
			title: '传染病报告历史操作记录',
			iconCls:'icon-w-paper',
			closed: true,
			modal: true,
			isTopZindex:false
		});
    }
	obj.btnAllImport_click  = function(){
		var rows = obj.gridEpdQuery.getRows().length; 		
		if (rows>0) {
			//$('#gridEpdQuery').datagrid('toExcel','传染病报告查询表.xls');
			grid2excel($("#gridEpdQuery"), {IE11IsLowIE: false,filename:'传染病报告查询表',allPage: true});
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
		}	
	}
	obj.btnImport_click  = function(){
		var rows = obj.gridEpdQuery.getRows().length;  
		if (rows>0) {
			var length = obj.gridEpdQuery.getChecked().length;
			if (length>0) {
				$('#gridEpdQuery').datagrid('toExcel', {
				    filename: '传染病报告查询表.xls',
				    rows: obj.gridEpdQuery.getChecked(),
				    worksheet: 'Worksheet'
				});
			} else {
				$.messager.alert("提示", "先选择查询记录,再进行导出!",'info');
				return;
			} 
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	obj.btnImpRep_click  = function(){
		var rows = obj.gridEpdQuery.getRows().length; 		
		if (rows>0) {
		    var length = obj.gridEpdQuery.getChecked().length;
		    if (length>0) {
			    var objRec = obj.gridEpdQuery.getChecked();
				for(var i = 0; i < length; i ++) {
					var ReportID = objRec[i].RowID;
					var StrName = objRec[i].PatientName;
					var CardType = $m({
						ClassName:"DHCMed.EPDService.AppendixCardSrv",
						MethodName:"GetAppendixCard",
						aDiseaseID:objRec[i].DiseaseDr
					},false);
					var LODOP=getLodop();
					LODOP.PRINT_INIT("PrintDHCMAEPDReport");		//打印任务的名称
					LODOP.ADD_PRINT_HTM(1,600,300,100,"<span tdata='pageNO'>第##页</span>/<span tdata='pageCount'>共##页</span>");
					LODOP.SET_PRINT_STYLEA(0,"ItemType",1);			//每页都打印页码
					LODOP.SET_PRINT_MODE("DOUBLE_SIDED_PRINT", 0);	//人工双面打印(打印机不支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
					LODOP.SET_PRINT_MODE("PRINT_DUPLEX", 0);		//自动双面打印(打印机支持双面打印时，0为单面打印，1为不双面打印，2为双面打印)
					LodopPrintURL(LODOP,"dhcma.epd.lodopprint.csp?ReportID="+ReportID);
					if (CardType) {
						LODOP.NewPage();
						if(CardType=="HIV"){
							LodopPrintURL(LODOP,"dhcma.epd.lodophiv.csp?ReportID="+ReportID);
						}
						if(CardType=="STD"){
							LodopPrintURL(LODOP,"dhcma.epd.lodopstd.csp?ReportID="+ReportID);
						}
						if(CardType=="HBV"){
							LodopPrintURL(LODOP,"dhcma.epd.lodophbv.csp?ReportID="+ReportID);
						}
					}
					//LODOP.PREVIEW();		//预览打印
					LODOP.PRINT();			//直接打印
				}
			} else {
				$.messager.alert("提示", "先选择查询记录,再进行导出!",'info');
				return;
			} 
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出报告", 'info');
		}	
	}
	
	obj.btnBatchCheck_click = function() {
		var record = obj.gridEpdQuery.getChecked();
		var length = obj.gridEpdQuery.getChecked().length; 	
		if (length>0) {
			var Count=0;
			for (var row = 0; row < length; row++) {
				var aReportID =  record[row]["RowID"];
				var StatusDesc = record[row]["Status"];
				var aStatus = 2;
				var aUserID = session['LOGON.USERID'];
				var strSysDateTime=obj.LoadSysDateTime();
				var tmpList=strSysDateTime.split(" ");
				var aDate = tmpList[0];
				var aTime = tmpList[1];
				var aTXT = "";
				if (StatusDesc == '待审') {
					var ret = $m({                  
					ClassName:"DHCMed.EPD.Epidemic",
					MethodName:"UpdateCheckEPD",
					MEPDRowid:aReportID, 
					Status:aStatus, 
					CheckUsr:aUserID, 
					CheckDate: aDate, 
					CheckTime: aTime,
					Demo:aTXT
				},false);
					Count++;
				}
			}
			if (Count < 1) {
				$.messager.alert("提示信息", "请至少选中一行待审记录,再进行审核!",'info');
				return;
			}
			$.messager.popover({
				msg: '批量审核成功',
				type: 'success',
				timeout: 2000, 		//0不自动关闭。3000s
				showType: 'slide'  //show,fade,slide
			});
			obj.EpdQueryLoad();
			obj.gridEpdQuery.clearSelections();  ;  //清除所有选择的行
		} else {
			$.messager.alert("提示信息", "先选择待审记录,再进行审核!",'info');
			return;
		}
		var rows = obj.gridEpdQuery.getRows().length; 
		 
		if(rows<1){
			$.messager.alert("提示","请先查询，再批量审核！",'info');
			return;
		}		
	}
	
	
	obj.openHandler = function(RowData){
		if(RowData.MIFAppendix){var RepHeight = "90%";}else{var RepHeight = "625";}
		var strUrl = "./dhcma.epd.report.csp?1=1"+
						"&PatientID=" + RowData.PatientID + 
						"&EpisodeID=" + RowData.Paadm + 
						"&ReportID=" + RowData.RowID +
						"&IsSecret=" + IsSecret +
						"&LocFlag=" + LocFlag;
        	
	    websys_showModal({
			url:strUrl,
			title:'传染病报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			closable:false,
			width:1340,
			height:RepHeight,  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			dataRow:{RowID:RowData.RowID},  
			onBeforeClose:function(){
				obj.EpdQueryLoad();  //刷新
			} 
		});
		
	}
	obj.OpenEPDReport = function(aReportID,aPatientID,aEpisodeID,aRepHeight) {
		var strUrl = "./dhcma.epd.report.csp?1=1"+"&PatientID=" + aPatientID + "&EpisodeID=" + aEpisodeID + "&ReportID=" + aReportID +"&IsSecret=" + IsSecret +"&LocFlag=" + LocFlag;	
	    websys_showModal({
			url:strUrl,
			title:'传染病报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			closable:false,
			width:1340,
			height:aRepHeight,  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.EpdQueryLoad();  //刷新
			} 
		});
		
	}
   
   obj.OpenRevised = function(aReportID,aPatientID,aEpisodeID) {
		var strUrl = "./dhcma.epd.report.csp?1=1"+"&PatientID=" + aPatientID + "&EpisodeID=" + aEpisodeID + "&ReportID=" + aReportID +"&IsSecret=" + IsSecret +"&LocFlag=" + LocFlag;
        	
	    websys_showModal({
			url:strUrl,
			title:'传染病报告',
			iconCls:'icon-w-epr',  
	        originWindow:window,
			closable:false,
			width:1340,
			height:'90%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.EpdQueryLoad();  //刷新
			} 
		});		
	}
	
	obj.EpdQueryLoad = function(){
		var DateFrom = $('#DateFrom').datebox('getValue');
		var DateTo = $('#DateTo').datebox('getValue');
		var IsInHosp = $("#chkIsInHosp").checkbox('getValue') ? 1:0;
		if ((DateFrom == '')||(DateTo == '')) {
			$.messager.alert("提示","开始日期、结束日期不允许为空!",'info');
			return;
		}
		if (Common_CompareDate(DateFrom,DateTo)>0) {
			$.messager.alert("提示","开始日期不能大于结束日期!",'info');
			return;
		}
		var SearchData=$.trim($("#schRegNoName").searchbox('getValue'));
		var isInt=/^\d+$/.test(SearchData);

		$("#gridEpdQuery").datagrid("loading");	
		$cm ({
			ClassName:"DHCMed.EPDService.EpidemicSrv",
			QueryName:"QueryEpdRepByDate",
			ResultSetType:"array",
			FromDate: $('#DateFrom').datebox('getValue'), 
			ToDate: $('#DateTo').datebox('getValue'),
			Status:obj.GetStatus(),	
			Loc: $('#cboLoc').combobox('getValue'),
			Hospital: $('#cboSSHosp').combobox('getValue'),
			RepPlace:$('#cboRepPlace').combobox('getValue'),
			UploadStatus:$('#cboCDCStatus').combobox('getValue'),
			MIFKind:$('#cboMIFKind').combobox('getValue'),
			aRegNo:(isInt?(Array(10).join(0) + SearchData).slice(-10):""),   //补全10位登记号
			aPatName:(isInt?"":SearchData),
			aIsInHosp:IsInHosp,
			page:1,
			rows:999
		},function(rs){
			$('#gridEpdQuery').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
			
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
	obj.OpenLog = function(aReportID) {
		$HUI.dialog('#EPDLogDetail').open();
		$cm ({
			ClassName:"DHCMed.EPDService.EpidemicSrv",
			QueryName:"QryEpidemicLog",
			aReportID:aReportID,
			aFromDate: "",
			aToDate: "",
			aHospital: "",
			aLoc: "",
			aStatusCode: ""
		},function(rs){
			$("#gridEPDLogInfo").datagrid("loaded");
			$('#gridEPDLogInfo').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
		});
	}
}