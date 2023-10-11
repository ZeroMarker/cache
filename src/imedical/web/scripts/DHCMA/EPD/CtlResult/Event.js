//页面Event
function InitCtlResultWinEvent(obj){	
    
	obj.LoadEvent = function(args){ 
	obj.CtlResultLoad();
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
		
		//导出
		$('#btnExport').on('click', function(){
			
			obj.btnExportCSV_click();
			/*var rows = obj.girdCtlResult.getRows().length; 		
			if (rows>0) {
				$('#girdCtlResult').datagrid('toExcel','传染病筛查结果.xls');
			}else {
				$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			}	
			*/
		});	
		
		//确诊
		$('#btnConfirm').on('click', function(){
	     	obj.btnConfirm_click();
     	});

		//排除
		$('#btnExclude').on('click', function(){
			obj.btnExclude_click();
		});	
		//复诊右键执行(初诊)
		$('#btnFirstVis').on('click', function(){
			obj.btnCaselete_click(1,"A","");
		});	
		//复诊右键执行(复诊)
		$('#btnReVis').on('click', function(){
			obj.btnCaselete_click(1,"R","");
		});	
		//携带右键执行(携带)
		$('#btnCarry').on('click', function(){
			obj.btnCaselete_click(2,1,"");
		});	
		//携带右键执行(非携带)
		$('#btnNotCarry').on('click', function(){
			obj.btnCaselete_click(2,2,"");
		});	
		//网报右键执行(网报)
		$('#btnDecla').on('click', function(){
			obj.btnCaselete_click(3,1,"");
		});
		//网报右键执行(未网报)
		$('#btnNotDecla').on('click', function(){
			obj.btnCaselete_click(3,2,"");
		});
		//备注编辑
		$('#btnEdit').on('click', function(){
			obj.initDialog();
			//obj.btnCaselete_click(4,2,"nongshalei");
		});
		//登记号补零 length位数
		var length=10;
		$("#txtPapmiNo").blur(function(){
			var PapmiNo	 = $("#txtPapmiNo").val();
			if(!PapmiNo) return;
			$("#txtPapmiNo").val((Array(length).join('0') + PapmiNo).slice(-length)); 
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
		$("#girdCtlResult").datagrid("loading");	
		$cm ({
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
			aRstType:Common_CheckboxValue('chkRstType'),	
			aPapmiNo:$("#txtPapmiNo").val(),	
			aIsDiag:Common_CheckboxLabel('chkIsDiag'),				
			page:1,
			rows:999
		},function(rs){
			$('#girdCtlResult').datagrid({loadFilter:pagerFilter}).datagrid('loadData', rs);				
			
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
				ClassName:"DHCMA.Util.Task.TaskManager",
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
				placement:'right',
				type:'html'
			});
			$("#ActDiagnos"+CasesXID).popover('show');    
		});		
	}
    //处置显示
	objScreen.CasesHandleEdit = function(aCasesXID,aInfectID,aOpinion,aActDiagnosID){
		obj.CasesXID = aCasesXID;
		if (aInfectID==""){
			$('#cboInfect').combobox('setValue',aActDiagnosID);
		}else{
			$('#cboInfect').combobox('setValue',aInfectID);
		}
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
				//$("#girdCtlResult").datagrid('reload'); //刷新当前页
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
				obj.CtlResultLoad() ;
				//$("#girdCtlResult").datagrid('reload'); //刷新当前页
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
				obj.CtlResultLoad();  
				//$("#girdCtlResult").datagrid('reload'); //刷新当前页
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
				obj.CtlResultLoad();  
				//$("#girdCtlResult").datagrid('reload'); //刷新当前页
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
	
	 //右击执行
	obj.btnCaselete_click = function(aTypeId,aTypeDesc,aRemark){
		var rowData = obj.girdCtlResult.getSelected();
		if (rowData){
		  CasesXID = rowData["CasesXID"];
		  IsReAdm = rowData["IsReAdm"];
			var flg = $m({
				ClassName:"DHCMed.EPDService.SuspCasesXSrv",
				MethodName:"ProcCasesEdit",
				aCasesXID:CasesXID, 
				aTypeId:aTypeId, 
				aTypeDesc:aTypeDesc, 
				aRemark:aRemark
			},false);
			
			if (flg>0) {
				//$("#girdCtlResult").datagrid('reload'); //刷新当前页
				obj.CtlResultLoad() ;
			}else {
				$.messager.alert("错误提示","“确诊”设置失败!",'error');
				return true;
			}
		}
	}
	
	//初始化模态框
	obj.initDialog =function(){
		if(arguments.length>0){
			var rowData = arguments[0];
			$("#girdScreen").val(rowData["RowID"]); //container
			$("#txtRemark").val(rowData["Code"]);
		}else{
			$("#girdScreen").val("");
			$("#txtRemark").val("");			
		}
		$HUI.dialog('#dialogRemark').open();
	}
	//隐藏弹窗
	$("#dialogRemark").dialog({
		title:"备注编辑",
		iconCls:"icon-w-edit",
		modal:true,
		isTopZindex:true,
		buttons:[{
			text:'保存',
			handler:function(){
				obj.update(4,2);	
			}},{
			text:'关闭',
			handler:function(){
				$HUI.dialog('#dialogRemark').close();
			}
		}]
	});
	//保存编辑
	obj.update = function(aTypeId,aTypeDesc){
		var rowData = obj.girdCtlResult.getSelected();
		if (rowData){
		  CasesXID = rowData["CasesXID"];
			var errInfo = "";
			var Remark=$("#txtRemark").val();
			var flg = $m({
					ClassName:"DHCMed.EPDService.SuspCasesXSrv",
					MethodName:"ProcCasesEdit",
					aCasesXID:CasesXID, 
					aTypeId:aTypeId, 
					aTypeDesc:aTypeDesc, 
					aRemark:Remark
				},false);
			if (flg>0) {
				obj.CtlResultLoad() ;//刷新当前页
				$.messager.popover({msg:'保存成功',type:'success',timeout:1000});
				$HUI.dialog('#dialogRemark').close();
			}else {
				$.messager.alert("错误提示","“确诊”设置失败!",'error');
				return true;
			}
		}
	}
	 obj.btnExportCSV_click  = function(){
		var rows = obj.girdCtlResult.getRows().length;  
		if (rows>0) {
			
			var rows=$("#girdCtlResult").data('datagrid').data.originalRows;
			var RepLists="";  // 报告ID列表
			for (var ind=0; ind<length;ind++) {
				var tmpRepList = rows[ind].CasesXID;
			   
				if (tmpRepList!="") {
					RepLists +=  "^"+rows[ind].CasesXID+","+rows[ind].PapmiNo+","+rows[ind].EpisodeID+","+rows[ind].PatName;
				} 
			}
			RepLists=RepLists.substring(1);
			var arrList = RepLists.split("^");
			var intCnt = arrList.length;
			
			var ExportPath="";
			$('#ExportPath').val("D:\\\\传染病筛查结果\\\\");	
			$('#ExportPathEdit').show();
			$('#ExportPathEdit').dialog({
				title:'文件路径',
				iconCls:'icon-w-edit',
				modal: true,
				isTopZindex:true,
				buttons:[{
					text:'确定',
					handler:function(){
						ExportPath = $('#ExportPath').val();
						$HUI.dialog('#ExportPathEdit').close();
						listArray = [];  //初始列表文件	 
						fileArray = [];  //初始文件列表
						
						var FileList = JSonToCSV.setDataConver({
							data: rows,
							columns: {
								title: ["登记号",'姓名','性别','年龄','疑似诊断','处置','就诊类型','确诊诊断','同类诊断报告','历史已报','复诊','携带','网报','备注123','入院日期','出院日期','就诊科室','就诊病区','主管医生'],//csv表头   ex. 处置意见Opinion名字冲突，不可导出
								key: ['PapmiNo','PatName','Sex','Age','ActDiagnos','EpdStatusDesc','AdmType','EpdDiagnos','RepList','OldRepList','IsReVisDesc','IsCarryDesc','IsDeclaDesc','Remark','AdmitDate','DisDate','AdmLoc','AdmWard','AdmDoc']
								,formatter: function(n, v) {
								
									if(v === undefined){
										return " ";
									}
									if(n === "IsUpload"){
										if (v === "未上报") {
											return "否";
										}else{
											return "是";
										}
									}
									if (n === "PapmiNo") {
										return String.fromCharCode(2)+v;
									}
								}
							}
						})
						var DateFrom = $('#DateFrom').datebox('getValue');
						var DateTo = $('#DateTo').datebox('getValue');
						var strfolderNameList = "传染病筛查列表（"+DateFrom+"至"+DateTo+"）";
						obj.ExportDataList(ExportPath,strfolderNameList,FileList);
						$.messager.popover({msg: '导出成功！',type:'success',timeout: 1000});
						//obj.BatchZip();
					}
				},{
					text:'关闭',
					handler:function(){
						$HUI.dialog('#ExportPathEdit').close();
					}
				}]
			});
		}else {
			$.messager.alert("确认", "无数据记录,不允许导出", 'info');
			return;
		}	
	}
	
	
	//创建存放目录
	obj.CreatePath = function(Path) {
		if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
			var objFSO = new ActiveXObject("Scripting.FileSystemObject");
			var arryFolder = Path.split("\\");
			var strPath = arryFolder[0];
			var blnReturn = false;
			try {
				for(var i = 1; i < arryFolder.length; i ++)
				{
					if(arryFolder[i] == "") continue;
					strPath += "\\\\" + arryFolder[i];
					if(!objFSO.FolderExists(strPath))
						objFSO.CreateFolder(strPath);
				}
				blnReturn = true;
			}catch(err) {
				blnReturn = false;
			}
			objFSO = null;
			return blnReturn;
		}else{	
			if (EnableLocalWeb==1) {  //非IE浏览器，且启用中间件
				var arryFolder = Path.split("\\");
				var strPath = arryFolder[0];
				var blnReturn = false;		
				
				var Str ="(function test(x){"+ '\n' 
		    	Str +="var objFSO = new ActiveXObject('Scripting.FileSystemObject');"+ '\n'
				for(var i = 1; i < arryFolder.length; i ++)
				{
					if(arryFolder[i] == "") continue;
					strPath += "\\\\" + arryFolder[i];			
					Str +="		if(!objFSO.FolderExists('"+strPath+"')){"+ '\n'  
					Str +="			objFSO.CreateFolder('"+strPath+"');"+ '\n'  //为兼容谷歌下层级正常导出，一定是“\\\\”,标点符号很重要，值都是''引起来才能使用
					Str +="		}"+ '\n'				
				}
			    Str += "return 1;}());";
				CmdShell.notReturn =0;   
				var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序
				if (rtn.status=="200") {
					blnReturn = true;
				}else {
					blnReturn = false;
				}
				
				objFSO = null;
				return blnReturn;
			}
		}
	}	
	
	obj.WriteFile = function(FileName, Contents) {
		if ((BrowserVer=="isLessIE11")||(BrowserVer=="isIE11")) { //IE浏览器
			var objFSO = new ActiveXObject("Scripting.FileSystemObject");
			var objTxt = objFSO.CreateTextFile(FileName);
			objTxt.WriteLine(Contents);
			objTxt.Close();
			objFSO = null;			
		}else {
			if (EnableLocalWeb==1) {  //非IE浏览器，且启用中间件
			    //换行符\r\n影响导出，报错“处理请求异常:未结束的字符串常量”，需替换为\n
			    var reg = new RegExp("\r\n","g")
				var Contents=Contents.replace(reg,"\\n"); 
				var Str ="(function test(x){"
				Str += "var objFSO = new ActiveXObject('Scripting.FileSystemObject');"
				Str += "var objTxt = objFSO.CreateTextFile('"+FileName+"');" //非常容易出错！！！标点符号很重要，值都是''引起来才能使用
				Str += "objTxt.WriteLine('"+Contents+"');"  //不能有换行符！！！标点符号很重要，值都是''引起来才能使用
				Str += "objTxt.Close();"
				Str += "objFSO = null;"
	            Str += "return 1;}());";
				CmdShell.notReturn =0;  
				var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
			}
		}
	}	
	obj.ExportDataList = function(ExportPath,FileName,arrayFile) {
		arrayFile=arrayFile.replace("\,\g","，")    //过滤分割符
		arrayFile=arrayFile.replace(RegExp(CHR_1, "g"),",")   //改成csv特有的分割符（这是建立在CHR_1不重复的前提下）
	    listArray.push({name:FileName,data:arrayFile});  //追加文件列表 	
		if (obj.CreatePath(ExportPath)) {
			obj.WriteFile(ExportPath + "\\\\"+FileName+".csv", arrayFile);  //保存文件
		}
		return true;
	}
 //JSON导出csv数据
	var JSonToCSV = {
	    /*
	     * obj是一个对象，其中包含有：
	     * ## data 是导出的具体数据
	     * ## fileName 是导出时保存的文件名称 是string格式
	     * ## showLabel 表示是否显示表头 默认显示 是布尔格式
	     * ## columns 是表头对象，且title和key必须一一对应，包含有
	          title:[], // 表头展示的文字
	          key:[], // 获取数据的Key
	          formatter: function() // 自定义设置当前数据的 传入(key, value)
	     */
		setDataConver: function(obj) {   
			var data = obj['data'],
			ShowLabel = typeof obj['showLabel'] === 'undefined' ? true : obj['showLabel'],
			columns = obj['columns'] || {
			  title: [],
			  key: [],
			  formatter: undefined
			};
			var ShowLabel = typeof ShowLabel === 'undefined' ? true : ShowLabel;
			var row = "", CSV = '', key;
			// 如果要现实表头文字
			if (ShowLabel) {
			  // 如果有传入自定义的表头文字
			  if (columns.title.length) {
			      columns.title.map(function(n) {
			          row += n + CHR_1;
			      });
			  } else {
			      // 如果没有，就直接取数据第一条的对象的属性
			      for (key in data[0]) row += key + CHR_1;
			  }
			  row = row.slice(0, -1); // 删除最后一个^号，即a^b^ => a^b
			  CSV += row + '\r\n'; // 添加换行符号
			}
			// 具体的数据处理
			data.map(function(n) {
			  row = '';
			  // 如果存在自定义key值
			  if (columns.key.length) {
			      columns.key.map(function(m) {
			          row += '' + (typeof columns.formatter === 'function' ? columns.formatter(m, n[m]) || n[m] : n[m]) + CHR_1;
			      });
			  } else {
			      for (key in n) {
			          row += '' + (typeof columns.formatter === 'function' ? columns.formatter(key, n[key]) || n[key] : n[key]) + CHR_1;
			      }
			  }
			  row.slice(0, row.length - 1); // 删除最后一个^
			  CSV += row + '\r\n'; // 添加换行符号
			});
			if(!CSV) return;
			return CSV;
		}
	}
	obj.BatchZip = function () {  //打包压缩文件
		var zip = new JSZip();
		var ExportTime=obj.GetDateTime();
	
	    zip.file(listArray[0].name+".csv", listArray[0].data) // 患者列表文件
		//文件打包
	    for (var i = 0; i < fileArray.length; i++) {
	        var fileObj = fileArray[i];
	        zip.file(fileObj.name+".txt", fileObj.data) // 逐个添加报告病例文件
	    }
		zip.generateAsync({type:"blob"}).then(function(content) {
		    var filename = "EpdRepToCDC-"+ExportTime+ '.zip'; 
		    saveAs(content, filename);
		       
		}); 	
	}
}