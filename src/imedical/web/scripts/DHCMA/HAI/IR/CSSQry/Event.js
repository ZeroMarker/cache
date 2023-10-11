function InitPatFindWinEvent(obj){

	CheckSpecificKey();
	var CheckFlg = 0; 
	if(tDHCMedMenuOper['Admin']==1) {
		CheckFlg = 1; //审核权限
	}
	obj.LoadEvent = function(args){
		//查询按钮
		$("#btnQuery").on('click',function(){
			obj.reloadgridApply();
		});
		$("#btnExport").on('click',function(){
			obj.btnExport_click();
		});
		//审核结果
		$('#btnChkReps').on('click', function(){
			obj.btnCheckRep_onClick();
		});
		//取消审核结果
		$('#btnUnChkReps').on('click', function(){
			obj.btnUnCheckRep_onClick();
		});
		//导出横断面参数 ,aHospDr: $.LOGON.HOSPID
		var dtCode = $m({
			ClassName: "DHCHAI.BT.Config",
			MethodName: "GetValByCode",
			aCode: "DataCenterCodeHDM"
		},false);
		$("#btnExportXML").on('click',function(){
			if(dtCode=="bjs")
			{
				obj.btnExportInterface_click();
			}
			else if(dtCode=="scs")
			{
				obj.btnExportXML_click();
			}
			else
			{
				//2022版横断面导出，默认方式
				obj.btnExportXML2022_click();
			}
		});	
		
		if ((dtCode=="bjs")||(dtCode=="scs")||(dtCode=="bzb")) {
			$("#btnExportXML").show();	
		}
	}
	$("#txtPatName").keydown(function(event){
		if (event.keyCode ==13)obj.reloadgridApply();	
	});	
	//审核结果
	obj.btnCheckRep_onClick = function(){
		var rows = $("#gridApply").datagrid('getRows').length;
		if (rows>0) {
			var chkRows=$HUI.datagrid('#gridApply').getChecked();
			if (chkRows.length>0) {
				 $.messager.confirm("确认", "是否批量审核报告?", function (r) {
					if (r) {
						var reportIds = '';
						for (var row = 0; row < chkRows.length; row++){
							var rd = chkRows[row];
							if (!rd) continue;
							var repId = rd['RepID'];
							if (reportIds != ''){
								reportIds += ',' + repId;
							} else {
								reportIds = repId;
							}
						}
						
						var flg = $m({
							ClassName   : "DHCHAI.IRS.INFReportSrv",
							MethodName  : "SaveCSSReportStatus",
							aReportIDs  : reportIds,
							aStatusCode : 3
						},false);
						if (parseInt(flg) < 1) {
							$.messager.alert("错误提示","批量审核报告操作错误!Error=" + flg, 'info');
						} else {
							$.messager.popover({msg: '批量审核报告操作成功！',type:'success',timeout: 1000});
							obj.reloadgridApply();  //刷新
						}
					}
				});
			} else {
				$.messager.alert("错误提示", "无选中记录,不可操作!",'info');
				return;
			}
		}else {
			$.messager.alert("错误提示", "无记录,不可操作!", 'info');
			return;
		}
	}
	//取消审核结果
	obj.btnUnCheckRep_onClick = function(){
		var rows = $("#gridApply").datagrid('getRows').length;
		if (rows>0) {
			var chkRows=$HUI.datagrid('#gridApply').getChecked();
			if (chkRows.length>0) {
				 $.messager.confirm("确认", "是否批量取消审核报告?", function (r) {
					if (r) {
						var reportIds = '';
						for (var row = 0; row < chkRows.length; row++){
							var rd = chkRows[row];
							if (!rd) continue;
							var repId = rd['RepID'];
							if (reportIds != ''){
								reportIds += ',' + repId;
							} else {
								reportIds = repId;
							}
						}
						
						var flg = $m({
							ClassName   : "DHCHAI.IRS.INFReportSrv",
							MethodName  : "SaveCSSReportStatus",
							aReportIDs  : reportIds,
							aStatusCode : 6
						},false);
						if (parseInt(flg) < 1) {
							$.messager.alert("错误提示","批量取消审核报告操作错误!Error=" + flg, 'info');
						} else {
							$.messager.popover({msg: '批量取消审核报告操作成功！',type:'success',timeout: 1000});
							obj.reloadgridApply();  //刷新
						}
					}
				});
			} else {
				$.messager.alert("错误提示", "无选中记录,不可操作!",'info');
				return;
			}
		}else {
			$.messager.alert("错误提示", "无记录,不可操作!", 'info');
			return;
		}
	}
	//打开链接
	obj.OpenReport = function(EpisodeID,SurvNumber,ReportID,Index,RepStatus) {
		var strUrl = '../csp/dhcma.hai.ir.cssreport.csp?EpisodeID='+EpisodeID+'&SurvNumber='+$("#cboSurvNumber").combobox("getValue")+'&ReportID='+ReportID+'&AdminPower='+CheckFlg+'&RepStatus='+RepStatus+'&inputParams='+obj.Params+'&1=1';
		websys_showModal({
			url:strUrl,
			title:'横断面调查:'+$("#cboSurvNumber").combobox("getText"),
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:1320,
			height:'95%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.reloadgridApply();
				/*/刷新行
				var CssDataList = $cm({
            		ClassName: "DHCHAI.IRS.INFCSSSrv",
           		 	QueryName: "QryNewCSSByPaadm",
            		aEpisodeID: EpisodeID,
            		aSurNumber:$("#cboSurvNumber").combobox('getValue'),
            		rows:999
       			}, false);
				var CssData = CssDataList.rows[0];
				if(CssData!=""){
					$('#gridApply').datagrid('updateRow', {
            			index: Index,
            			row: {
							"RepID":CssData.RepID,
							"RepStatus": CssData.RepStatus,
							"AllDiag": CssData.AllDiag,
							"OBSCnt": CssData.OBSCnt==1?"是":"否",
							"InfPosDescs": CssData.InfPosDescs,
							"IRAntiFlag": CssData.IRAntiFlag==1?"是":"否",
							"PurposeDesc": CssData.PurposeDesc,
							"CombinDesc": CssData.CombinDesc,
							"IRAntiSenFlag": CssData.IRAntiSenFlag==1?"是":"否",
							"OperFlag": CssData.OperFlag==1?"是":"否",
							"CuteType": CssData.CuteType,
						}
					});
				}*/
			} 
		});
	}
	
	//打开链接
	obj.OpenMainView = function(EpisodeID) {
		var strUrl = '../csp/dhchai.ir.view.main.csp?PaadmID='+EpisodeID+'&PageType=WinOpen';
		websys_showModal({
			url:strUrl,
			title:'医院感染集成视图',
			iconCls:'icon-w-epr',  
	        originWindow:window,
	        closable:true,
			width:1320,
			height:'95%',  //8.2以上版本支持百分比，8.2以下的用具体像素，如height:window.screen.availHeight-80,
			onBeforeClose:function(){
				obj.reloadgridApply();  //刷新
			} 
		});
	}
	setTimeout(function(){obj.reloadgridApply();},1000);
	//重新加载表格数据
	obj.reloadgridApply = function(){
		var HospIDs 	= $("#cboHospital").combobox('getValue');
		var LocationID  = $("#cboLocation").combobox('getValue');
		var SEID	 	= $("#cboSurvNumber").combobox('getValue');
		var PatName 	= $("#txtPatName").val();
		var PapmiNo 	= "";  
		var MrNo 		= "";
		//报告状态
		var Status=Common_CheckboxValue('chkStatunit');
        var CssInfType=$("#cboInfCategoryDr").combobox('getText');
		var Inputs = HospIDs+'^'+LocationID+'^'+""+"^"+SEID+'^'+PatName+'^'+PapmiNo+'^'+MrNo+"^"+Status+"^"+CssInfType;
		
		var ErrorStr="";
		if (HospIDs=="") {
			ErrorStr += '请选择院区!<br/>';
		}
		if (SEID==""){
			ErrorStr += '请选择调查编号！<br/>';
			
		}
		if(LocationID==""){
			//ErrorStr += '请选择科室\病区！<br/>';
		}
		
		if (ErrorStr != '') {
			$.messager.alert("错误提示",ErrorStr, 'info');
			return;
		}else{
			//obj.Params = HospIDs+'^'+LocationID+'^'+""+"^"+SEID+'^'+""+'^'+""+'^'+""+"^"+Status;
			obj.Params = HospIDs+'^'+LocationID+'^'+""+"^"+SEID+'^'+""+'^'+""+'^'+""+"^";
			$("#gridApply").datagrid("loading");
			$cm ({
				ClassName:"DHCHAI.IRS.INFCSSSrv",
				QueryName:"QryAdm",
				ResultSetType:"array",
				aIntputs:Inputs,
				page:1,
				rows:1000
			},function(rs){
				$('#gridApply').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);
				$('#gridApply').datagrid('selectRow', obj.rowIndex );				
			});
		
		};
	}
	obj.btnExport_click = function() {
		var rows=$("#gridApply").datagrid('getRows').length;
		if (rows>0) {
			var length = $("#gridApply").datagrid('getChecked').length;
			if (length>0) {
				$('#gridApply').datagrid('toExcel', {
				    filename: '横断面调查.xls',
				    rows: $("#gridApply").datagrid('getChecked'),
				    worksheet: 'Worksheet',
				});
			} else {
				$('#gridApply').datagrid('toExcel','横断面调查.xls');
			} 
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	
	obj.btnExportXML_click = function(){
		var rows=$("#gridApply").datagrid('getRows').length;
		var Err="",CSSIDs=""
		if (rows>0) {
			var objrow=$("#gridApply").datagrid('getChecked')
			var length = $("#gridApply").datagrid('getChecked').length;
			if (length>0) {
				for (i=0;i<length;i++){
					var row=objrow[i]
					var CSSID=row.CSSID
					var MrNo=row.MrNo
					if (CSSID=='') {
						Err+="病案号："+MrNo+"患者未进行调查<br/>"
						continue
					}
					CSSIDs+=CSSID+"^"
				}
				if(CSSIDs!="")
				{
					obj.ExportXML(CSSIDs)
				}
			} else {
				var objRows=$("#gridApply").datagrid('getRows')
				for (i=0;i<rows;i++){
					var row=objRows[i]
					var CSSID=row.CSSID
					var MrNo=row.MrNo
					if (CSSID=='') {
						Err+="病案号："+MrNo+"患者未进行调查<br/>"
						continue
					}
					CSSIDs+=CSSID+"^"
				}
				if(CSSIDs!="")
				{
					obj.ExportXML(CSSIDs)
				}
			} 
			if (Err!=""){
				$.messager.alert("提示",Err, 'info');
			}
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}
	}
	obj.ExportXML = function(aCSSIDs){
	    var LocDesc=$('#cboLocation').combobox('getText')	//$.form.GetText('cboLocation')
	    if(LocDesc=="")
	    {
			LocDesc="全部调查数据";    
		}
		try {
			var count=0
			/*
			fso = new ActiveXObject("scripting.FileSystemObject");
			path = "D:\\横断面调查\\"+LocDesc+"\\";
			if (!fso.FolderExists("D:\\横断面调查\\")){
				fso.CreateFolder("D:\\横断面调查\\");
			}
			if (!fso.FolderExists(path)){   // 若当前路径不存在，则创建此路径。
				 fso.CreateFolder(path);
			}
			*/
			var CSSInfo=$m({
				ClassName:'DHCHAI.IRX.Output',
				MethodName:'BatExportXML',
				aCSSIDs:aCSSIDs
			},false)	//$.Tool.RunServerMethod("DHCHAI.IRX.Output","BatExportXML",aCSSIDs);
			var CSSStr=CSSInfo.split("^")[0];
			//path +=  LocDesc+".xml";   // 创建文档的路径。
			//tf = fso.CreateTextFile(path, true,true);   // 创建新文件。
			//tf.WriteLine(CSSStr);
			//tf.Close();			
			//path = "D:\\横断面调查\\"+LocDesc+"\\";
			//$.messager.alert("确认",'导出xml完成，文件位于'+path, 'info');
			var zip = new JSZip();			
			zip.file(LocDesc+".xml", CSSStr);
			zip.generateAsync({type:"blob"}).then(function(content) {
			    // content就是blob数据，这里以example.zip名称下载    
			    // 使用了FileSaver.js 
			    var filename = LocDesc + '.zip'; 
			    saveAs(content, filename);
			});
		}catch(e){
			alert(e)
		}
	}
	//导出民科接口
	obj.btnExportInterface_click = function (objBtn, objEvent, skipMapping) {
		
		//是否跳过字典对照检查（true：跳过）
		if (typeof skipMapping == 'undefined') skipMapping = false;
		
		var RepIDs="",Err="";  // 报告ID列表
		var objrow=$("#gridApply").datagrid('getChecked')
		var length = $("#gridApply").datagrid('getChecked').length;
		if (length>0) {
			for (i=0;i<length;i++){
				var row=objrow[i]
				var tmpRepID=row.RepID
				var MrNo=row.MrNo
				if (tmpRepID=='') {
					Err+="病案号："+MrNo+"患者未进行调查<br/>"
					continue
				}
				RepIDs +=  "^"+tmpRepID;
			}
		} else {
			var objRows=$("#gridApply").datagrid('getRows')
			for (i=0;i<objRows.length;i++){
				var row=objRows[i]
				var tmpRepID=row.RepID
				var MrNo=row.MrNo
				if (tmpRepID=='') {
					Err+="病案号："+MrNo+"患者未进行调查<br/>"
					continue
				}
				RepIDs +=  "^"+tmpRepID;
			}
		} 
		/*
		if (Err!=""){
			$.messager.alert("提示",Err, 'info');
		}
		*/
		//alert(RepIDs)
		RepIDs=RepIDs.substring(1);
		if (RepIDs == "") {
			$.messager.alert("提示","没有调查报告导出，请先进行调查！", 'info'); //layer.msg('请选择需要导出的现患率报告!',{icon: 2});
			return;
		}
		var arrList = RepIDs.split("^");
		ExtTool.RunQuery(
			{
				ClassName : 'DHCHAI.MK.ExportToMKSrv',
				QueryName : 'QryValidateInfonew',
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
								
								$.messager.confirm("完成","共处理了" + intTotalCnt + "份患者现患率调查报告信息,是否打开文件存放文件夹!", function (r){
									if (r) {
										var WshShell = new ActiveXObject("WScript.Shell");
										var oExec = WshShell.Exec("explorer.exe " + ExportPath);
										/*	
										if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
											var WshShell = new ActiveXObject("WScript.Shell");
											var oExec = WshShell.Exec("explorer.exe " + ExportPath);
										}else {
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
										}
										*/
								 	}								 	
								 });
		 						/*	
								ExtTool.confirm("接口文件", "共处理了" + intTotalCnt + "份患者感染报告信息,是否打开文件存放文件夹!", function(btn, txt) {
									if (btn == 'yes') {
										var WshShell = new ActiveXObject("WScript.Shell");
										var oExec = WshShell.Exec("explorer.exe " + ExportPath);
									}
								});
								*/
							}
						},
						null,
						false,
						"D:\\现患率调查报告接口文件"
					)
				}
			}
			,obj
			,skipMapping
		)
	};
	//导出2022XML
	obj.btnExportXML2022_click = function() {
		//标准版
		var sNo = $m({
			ClassName: "DHCHAI.MAPS.CssInterfaceSrv",
			MethodName: "CurrTimeNo"
		}, false);
		var ExportPath = "NIOA-"+sNo;
		obj.ExportXMLPath = ExportPath;
		var zip = new JSZip();
		var cntVal =0;
		var aRepIDs="";
		//循环能导出的已调查数量
		var objRows=$("#gridApply").datagrid('getRows')
		for (i=0;i<objRows.length;i++){
			var row=objRows[i]
			var tmpRepID=row.RepID
			if (tmpRepID!='') {
				if(aRepIDs=='')
				{
					aRepIDs=tmpRepID
				}
				else
				{
					aRepIDs=aRepIDs+","+tmpRepID;
				}
				cntVal++;
			}
		}
		if (cntVal>0) {
			var oldOk = $.messager.defaults.ok;
			var oldCancel = $.messager.defaults.cancel;
			//$.messager.defaults.ok = "同意";
			//$.messager.defaults.cancel = "拒绝";
			$.messager.confirm("确认", "确定导出横断面调查数据集吗"+"?", function (r) {
				if (r) {
					//$.messager.popover({ msg: "点击了确定", type: 'info' });					
					$.messager.progress({
						title: "提示",
						msg: '正在导出数据',
						text: '导出中....'
					});
					//生成调查患者主信息
					var strMain = $m({
						ClassName: "DHCHAI.MAPS.CssInterfaceSrv",
						MethodName: "GetEpisodeMain",
						aRepIDs:aRepIDs
					}, false);	
							
					strMain = obj.ReplaceText(strMain, String.fromCharCode(2), "\r\n");
					zip.file("PatientMain.xml", strMain);	
					//生成调查感染信息
					var strInfectInfo = $m({
						ClassName: "DHCHAI.MAPS.CssInterfaceSrv",
						MethodName: "GetEpisodeInfs",
						aRepIDs:aRepIDs
					}, false);					
					strInfectInfo = obj.ReplaceText(strInfectInfo, String.fromCharCode(2), "\r\n");
					zip.file("InfectInfo.xml", strInfectInfo);	
					//生成调查菌信息
					var strPatho = $m({
						ClassName: "DHCHAI.MAPS.CssInterfaceSrv",
						MethodName: "GetEpisodePathos",
						aRepIDs:aRepIDs
					}, false);					
					strPatho = obj.ReplaceText(strPatho, String.fromCharCode(2), "\r\n");
					zip.file("PathoInfo.xml", strPatho);
					//生成调查菌药敏信息
					var strAntibInfo = $m({
						ClassName: "DHCHAI.MAPS.CssInterfaceSrv",
						MethodName: "GetEpisodeAntis",
						aRepIDs:aRepIDs
					}, false);					
					strAntibInfo = obj.ReplaceText(strAntibInfo, String.fromCharCode(2), "\r\n");
					zip.file("AntibInfo.xml", strAntibInfo);							
					//生成最后汇总文件 $.LOGON.USERDESC
					var strSum = $m({
						ClassName: "DHCHAI.MAPS.CssInterfaceSrv",
						MethodName: "ExportReportSum",
						aSurNo:$("#cboSurvNumber").combobox('getValue'),
						aRepIDs:aRepIDs,
						aFileName:obj.ExportXMLPath,
						aUserDesc:''
					}, false);					
					strSum = obj.ReplaceText(strSum, String.fromCharCode(2), "\r\n");
					zip.file("UserInfo.xml", strSum);
					zip.generateAsync({type:"blob"}).then(function(content) {
						// content就是blob数据，这里以example.zip名称下载    
						// 使用了FileSaver.js 
						var filename = obj.ExportXMLPath + '.zip'; 
						saveAs(content, filename);
					});		
					setTimeout('$.messager.progress("close");', 1 * 1000);
				} else {
					$.messager.popover({ msg: "您已取消导出横断面调查数据集" });
				}
				/*要写在回调方法内,否则在旧版下可能不能回调方法*/
				$.messager.defaults.ok = oldOk;
				$.messager.defaults.cancel = oldCancel;
			});			
		}else {
			$.messager.alert("确认", "没有调查数据,不允许导出", 'info');
			return;
		}		
	};
	obj.ReplaceText = function(str, find, repl)
	{
		var strTmp = str;
		while(strTmp.indexOf(find) >=0)
		{
			strTmp = strTmp.replace(find, repl);	
		}	
		return strTmp;
	};
}