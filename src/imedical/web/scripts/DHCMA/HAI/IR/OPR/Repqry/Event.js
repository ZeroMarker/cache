//手术切口调查查询->Event
function InitINFOPSQryWinEvent(obj) {
	//管理员权限
    var CheckFlg = 0;
    if (tDHCMedMenuOper['Admin'] == 1) {
        CheckFlg = 1;
    }
    //院区点击事件
    $HUI.combobox('#cboHospital', {
        onSelect: function (data) {
            obj.cboLoction = obj.RefreshOPRLoc(data.ID);  //初始化病区
        }
    });
    //检索框
    $('#searchbox').searchbox({
        searcher: function (value, name) {
	        if(value==""){
		        $('#btnQuery').click();
	        }
	        else{
		        searchText($("#gridINFOPSQry"), value);
		    }
            
        }
    });
    obj.LoadEvent = function(args){
		//初始查询结果
		obj.refreshOprQry();
	}
    //查询
    $('#btnQuery').click(function (e) {
        obj.refreshOprQry();
    });
    //导出事件
    $('#btnExport').on('click', function () {
		var rows = obj.gridINFOPSQry.getRows();  //返回当前页的所有行
        if(rows.length==0){
	        $.messager.alert("错误","无记录数据,不允许导出!", 'info');
			return;
	    }
        rowList= $('#gridINFOPSQry').datagrid('getChecked');
        if (rowList.length>0) {
			$('#gridINFOPSQry').datagrid('toExcel', {
			    filename: '手术切口调查查询.xls',
			    rows: rowList,
			    worksheet: '手术切口调查查询',
			});		
		}else {
			$('#gridINFOPSQry').datagrid('toExcel', '手术切口调查查询.xls');   //导出
		}		
        
    }); 
    //批量审核
    $('#btnCheck').on('click', function () {
        var RepIDs=""; 
		var length=$("#gridINFOPSQry").datagrid('getChecked').length;
		if (length>0) {
			var rows = $("#gridINFOPSQry").datagrid('getChecked');
			for(var i=0;i<length;i++){
				var tmpRepID = rows[i]["ReportID"];
                var aRepStatus=rows[i]["RepStatus"];
                if((aRepStatus!="提交")&&(aRepStatus!="取消审核")){
                    continue;
                }
				if ((tmpRepID!="")) {
					RepIDs +=  "^"+tmpRepID;
				} 
			}
		}
        RepIDs=RepIDs.substring(1);
        if(RepIDs==""){
            $.messager.popover({
                msg: '请选择"提交"或"取消审核"状态的报告批量审核！',
                type: 'alert',
                timeout: 3000, 		//0不自动关闭。3000s
                showType: 'slide'  //show,fade,slide
            });
        }else{
            var flg = $m({
                ClassName: "DHCHAI.IRS.INFOPSSrv",
                MethodName: "CheckSelected",
                aRepIDs: RepIDs,
                aUpdateUser:$.LOGON.USERID,
                aStatusCode:"3"
            }, false);
            if(flg=="1"){
                obj.refreshOprQry();
                $.messager.popover({
                    msg: '批量审核成功！',
                    type: 'success',
                    timeout: 3000, 		//0不自动关闭。3000s
                    showType: 'slide'  //show,fade,slide
                });
            }else{
                obj.refreshOprQry();
                $.messager.popover({
                    msg: '批量审核失败！',
                    type: 'error',
                    timeout: 3000, 		//0不自动关闭。3000s
                    showType: 'slide'  //show,fade,slide
                });
            }
        }
    }); 
    //导出民科事件
    $('#btnExportMK').on('click', function (objBtn, objEvent, skipMapping) {
	    //是否跳过字典对照检查（true：跳过）
		if (typeof skipMapping == 'undefined') skipMapping = false;
		
	    //1.获取报告ID列表
	    var RepIDs=""; 
	    var length=$("#gridINFOPSQry").datagrid('getChecked').length;
		if (length>0) {
			var rows = $("#gridINFOPSQry").datagrid('getChecked');
			for(var i=0;i<length;i++){
				var tmpRepID = rows[i]["ReportID"];
				if (tmpRepID!="") {
						RepIDs +=  "^"+tmpRepID;
					} 
				}
		}
		RepIDs=RepIDs.substring(1);
		//2.导出报告
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
								var flag = 0;
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
									var strfolderName = PatMrNo + " " + PatName + " " + PatAdmDate;
									var strPath = ExportPath + "\\" + strfolderName;
									//更新进度条
									Ext.MessageBox.updateProgress(indRec/intTotalCnt, '', "正在处理：" + PatMrNo + " " + PatName);
									var ret = objExportMinke.ExportMinkeData(repID, strPath,RepIDs);
									if(ret==false){   //判断是否有未审核的报告
										flag++;
										continue;
									}									
								}
								
								//关闭进度条
								Ext.MessageBox.hide();
								if(flag==intTotalCnt){   //先关闭进度条再提示
									alert('未审核报告');
									return;	
								}
								/*
								ExtTool.confirm("接口文件", "共处理了" + intTotalCnt + "份患者感染报告信息,是否打开文件存放文件夹!", function(btn, txt) {
									if (btn == 'yes') {
										var WshShell = new ActiveXObject("WScript.Shell");
										var oExec = WshShell.Exec("explorer.exe " + ExportPath);
									}
								});
								*/
								$.messager.confirm("完成","共处理了" + intTotalCnt + "份患者感染报告信息,是否打开文件存放文件夹!", function (r){
									if (r) {	
										/*if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
											var WshShell = new ActiveXObject("WScript.Shell");
											var oExec = WshShell.Exec("explorer.exe " + ExportPath);
										}else {*/
											if ((typeof(EnableLocalWeb)!="undefined")&&(EnableLocalWeb==1)) {  //非IE浏览器，且启用中间件
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
											else
											{
												var WshShell = new ActiveXObject("WScript.Shell");
												var oExec = WshShell.Exec("explorer.exe " + ExportPath);
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
    });
    //刷新列表
    obj.refreshOprQry = function () {
        var HospID = $('#cboHospital').combobox('getValue');
        var DateFrom = $('#dtDateFrom').combobox('getValue');
        var DateTo = $('#dtDateTo').combobox('getValue');
        var CuteType = $('#cboIncision').combobox('getValue');
        var OprLocID = $('#cboLoction').combobox('getValue');
		var VisitRst= $('#cboVisitRst').combobox('getValue');	
		var DateType = $('#cboDateType').combobox('getValue');
		var OperCat  = $('#cboOperCat').combobox('getValues').toString(",");   //多选  //var OperCat  = $('#cboOperCat').combobox('getValue');
		var HealDesc = $('#cboHealStat').combobox('getValues').toString(",");
		var SurvStatus = $('#cboSurvStatus').combobox('getValue');	//报告状态
        if (DateType == "") {
            $.messager.alert("提示", "日期类型不能为空!", 'info');
            return;
        }
        if (DateFrom == "") {
            $.messager.alert("提示", "开始日期不能为空!", 'info');
            return;
        }
		
        if (DateTo == "") {
            $.messager.alert("提示", "结束日期不能为空!", 'info');
            return;
        }
        
		if (Common_CompareDate(DateFrom, DateTo) == 1) {
            $.messager.alert("提示", "开始日期不能大于结束日期!", 'info');
            return;
        }
        if (Common_CompareDate(DateFrom, Common_GetDate(new Date())) == 1) {
            $.messager.alert("提示", "开始日期不能大于当前日期!", 'info');
            return;
        }
       $("#gridINFOPSQry").datagrid("loading");
        var Ret = $cm({
			 ClassName: "DHCHAI.IRS.INFOPSSrv",
            QueryName: "QryINFOPS",
            aDateFrom: DateFrom,
            aDateTo: DateTo,
            aOperLocDr: OprLocID,
            aIncisionDr: CuteType,
            aOperTypeDr: $('#cboOperType').combobox('getValue'),
            aInfPosDr: $('#cboInfPos').combobox('getValue'),
            aOperDesc: $('#txtOperDesc').val(),
            aOperHours: $('#txtOperHours').val(),
            aHospInfFlag: $('#chkHospInfFlag').checkbox('getValue') ? '1' : '0',
            aCutInfFlag: $('#chkCutInfFlag').checkbox('getValue') ? '1' : '0',
            aHospID: HospID,
           aVisitRstDr:VisitRst,
            aDateType:DateType,
			aOperCat:OperCat,
            aHealDesc:HealDesc,
            aSurvStatus:SurvStatus,
            page: 1,
            rows: 99999
        }, function (rs) {
            $('#gridINFOPSQry').datagrid({ loadFilter: pagerFilter }).datagrid('loadData', rs);
		});
    }
    //打开手术切口调查表
    obj.OpenReport = function (index) {
        $('#gridINFOPSQry').datagrid('selectRow', index);
        var row = $('#gridINFOPSQry').datagrid('getSelected');		
		var url = "dhcma.hai.ir.opr.report.csp?Admin=1"+ '&OpsID=' + row.INFOPSID + '&ReportID=' + row.ReportID +'&OperAnaesID='+row.AnaesDR+'&EpisodeID=' + row.PAAdmDr+ "&5=5";
		websys_showModal({
            url: url,
            title: '手术切口调查表',
            iconCls: 'icon-w-epr',
            closable: true,
            width: 1320,
            height: '95%',
            onBeforeClose: function () {
                obj.refreshOprQry();
            }
        });
    }
}