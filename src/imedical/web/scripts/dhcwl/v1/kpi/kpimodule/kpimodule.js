/**
*   Creator   : wk
*   CreatDate : 2018/05/14
*   Desc      : 模块与报表维护界面
**/

var kpiBodyHeight = getViewportOffset().y;
var kpiBodyWidth = getViewportOffset().x;
var FILE_PATH_GLOBAL = "";
var KPI_INPUT_FLAG = "";
var moduleInputListArr = [];

/**************以下是通用功能的实现*********************/
var kpiFirstSecList = "",secCodeS = "",exeCodeS = "";filePathLog = ""


/*--鼠标悬停备注单元格响应方法--*/
 function formatCellTooltip(value){  
	return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
}


/*--获取filebox文件路径--*/
function getFieldValue(formID,fieldName) {
	return $("div#"+formID+" [name='"+fieldName+"']").val();
};
/*$("#textBox").filebox({
	onChange:function(newVal,oldVal){
		if (newVal=="") return;
		if (newVal==oldVal) return;
		filePathLog=getFieldValue("importRegion","textFile");
	}
});*/

/*--响应用户选择文件事件--*/
function getFilePath(newVal,oldVal){
	if (newVal=="") return;
	if (newVal==oldVal) return;
	filePathLog=getFieldValue("importRegion","textFile");
}


function moduleConfigFun(obj){
	var ID = obj.id;
	var title = "",treeCode = "",type = "";
	if ((ID == "addDateButton")||(ID == "viewKPIListButton")|| (ID == "taskConfigButton")){
		var row = $("#moduleCfgTree").treegrid("getSelected");   //获取选中的模块
		if (!row){
			myMsg("请先选择一条需要操作的对象");
			return;
		}
		treeCode = row.ID;   //获取选中的树节点
		moduleCode = row.code;
		title = "模块--"+moduleCode;
		type = "module";
		
		var rpRow = $("#reportTable").datagrid("getSelected");   //获取选中的报表
		if (rpRow){
			rpCode = rpRow.rpCode;
			title = "报表--" + rpCode;
			type = "report";
			treeCode = treeCode + "." + rpCode;
		}
		
		var dsRow = $("#dataSetTable").datagrid("getSelected");    //获取选中的数据集
		if (dsRow){
			dsCode = dsRow.dsCode;
			title = "数据集--" + dsCode;
			type = "dateSet";
			treeCode = treeCode + "." + dsCode;
		}
	}
	if (ID == "addDateButton"){
		title = title + "--数据生成"
		$("#moduleCreateDateDialog").show();
		$HUI.dialog("#moduleCreateDateDialog",{
			resizable:true,
			modal:true,
			title:title,
			iconCls:'icon-w-config',
			buttons:[{
				text:'确定',
				handler:function(e){
					$m({                           //根据树节点获取指标列表
						ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
						MethodName:'GetKPIListByModule',
						treeCode:treeCode,
						type:type
					},function(textData){
						var startDate="",endDate="",actflag=""
						startDate = $("#startDate").datebox("getValue");
						endDate = $("#endDate").datebox('getValue');
						actflag = $("#reCreatDate").checkbox("getValue");
						if (actflag){
							actflag = 1;
						}else{
							actflag = 0;
						}
						if ((startDate == "")||(endDate == "")){
							$.messager.alert("提示","请将日期填写完整");
							return;
						}
						$.cm({         //调用生成数据的方法生成数据
							ClassName:"web.DHCWL.V1.KPI.KPIFunction",
							MethodName:"CreatKPIData",
							kpiIDs:textData,
							startDate:startDate,
							endDate:endDate,
							reFlag:actflag
						},function(jsonData){
							if ((jsonData.tip == "ok")&&(jsonData.dataFlag)){
								$HUI.dialog("#moduleCreateDateDialog").close();
								myDataFlag = jsonData.dataFlag;
								porgressControl("web.DHCWL.V1.KPI.KPIFunction","getCreateDataPlan",myDataFlag,1000);
							}else{
								messageShow("生成过程中出现错误,请刷新浏览器重试");
							}
						});
					});
				}
			},{
				text:'取消',
				handler:function(e){
					$HUI.dialog("#moduleCreateDateDialog").close();
				}
			}]
		})
	}
	
	function handlerImportContent(txtData){
		var moduleArrList = [];
		var jsonObj = JSON.parse(txtData);
		var fileName = jsonObj.tips;
		FILE_PATH_GLOBAL = fileName;
		var rootLen = jsonObj.root.length;
		for (var i = 0;i < rootLen;i++){
			var type = "",desc = "",code = "",ID = "",parentID = "";
			var className = jsonObj.root[i].className;
			if (className == "DHCWL.MKPI.MMgrModuleCfg"){
				type = "模块";
				desc = jsonObj.root[i].ModuleCfgDesc;
				code = jsonObj.root[i].ModuleCfgCode;
				ID = jsonObj.root[i].ModuleCfgTreeCode;
				parentID = jsonObj.root[i].ModuleCfgPTreeCode;
			}else if(className == "DHCWL.MKPI.MMgrRptCfg"){
				type = "报表";
				desc = jsonObj.root[i].RptCfgName;
				code = jsonObj.root[i].RptCfgCode;
				ID = jsonObj.root[i].primaryValue;
				
				var rptIDArr = ID.split("||");
				ID = rptIDArr.join('.');
				
				parentID = PCommond(ID,".",1,-1);
			}else if(className == "DHCWL.MKPI.MMgrDataSetCfg"){
				type = "数据集";
				desc = jsonObj.root[i].DatasetCfgDesc;
				code = jsonObj.root[i].DatasetCfgCode;
				ID = jsonObj.root[i].primaryValue;
				
				var dsIDArr = ID.split("||");
				ID = dsIDArr.join('.');
				
				parentID = PCommond(ID,".",1,-1);
				
			}
			if ($.inArray(parentID,moduleArrList) == -1){
				parentID = "";
			}
			moduleArrList.push(ID);
			$('#moduleInforTree').treegrid('append',{
				parent: parentID,
				data: [{
					ID  : ID,
					desc: desc,
					type: type,
					code: code
				}]
			});
		}
		return;
	}
	
	
	//title="导入";
	if(ID=="importXMLButton"){
		title="XML文件安装";
	}
	if(ID=="importExcelButton"){
		title="EXCEL文件安装"
	}
	if ((ID=="importXMLButton")||(ID=="importExcelButton")){
		if (title == "") {
			title = "导入";
		}
		filePathLog = "";
		$HUI.treegrid("#moduleInforTree",{
			fitColumns:true,
			toolbar:[{
				iconCls:'icon-upload-cloud',
				text:'读入模块文件',
				handler:function(){
					$('#moduleInforTree').treegrid('loadData',{total:0,rows:[]});
					var browserStr = myBrowser();
					if(browserStr != "IE"){
						if ((!filePathLog)||(filePathLog == "")){
							myMsg("请先选择需要读入的文件");
							return;
						}
						var xmlFile = filePathLog; 
						if(xmlFile.indexOf("C:\\fakepath") != -1){
							xmlFile = xmlFile.replace("C:\\fakepath\\","D:\\\\\\\\");
						}
						//var xmlFile = "D:\\\\test.kpi";
						var str = "(function test(x){"
						+"var ts, s ;"
						+"var ForReading = 1;"
						+'fso = new ActiveXObject("Scripting.FileSystemObject");'
						+'ts = fso.OpenTextFile("'+xmlFile+'", ForReading);'
						+'s = ts.ReadAll();ts.Close();ts=null;return s;'
						+'}());'
						CmdShell.notReturn =0 ;
						var rtnObj = CmdShell.EvalJs(str);
						var resultStr = rtnObj.rtn,resultStrLen;
						if ((resultStr.length)&&(resultStr.length > 0)){
							var inputCont=[],tempStr;
							resultStrLen = resultStr.length;
							for (var i = 0; i < resultStrLen / 256; i++){
								tempStr = resultStr.substr(0,256);
								inputCont.push(tempStr);
								resultStr = resultStr.replace(tempStr,'');
							}
							KPI_INPUT_FLAG = "read";
							theStep = 3;
					
							loadInforShow("start","","正在读取数据");

							$m({
								_headers:{
									X_Accept_Tag:1
								},
								ClassName:'web.DHCWL.V1.MKPIIO.DefaultInService',
								MethodName:'UPFILE',
								theStep:theStep,
								inputCont:inputCont,
								inputType:'module'
							},function(txtData){
								loadInforShow("end");
								handlerImportContent(txtData);
							})
						}else{
							myMsg(rtnObj.msg,"注意:谷歌浏览器请放到D盘根目录下");
						}
						
					}else{
						if ((!filePathLog)||(filePathLog == "")){
							myMsg("请先选择需要读入的文件");
							return;
						}
						var xmlObj = new XML();
						var readStr="",theStep=1,sc;
						var inputCont=[];
						do{
							readStr=xmlObj.stepTraverXML(filePathLog,256);  
							inputCont.push(readStr);
							theStep++;
						}while(readStr&&readStr!="");
						KPI_INPUT_FLAG = "read";
						
						var moduleArrList = [];
						
						loadInforShow("start","","正在读取数据");
						$m({
							_headers:{
								X_Accept_Tag:1
							},
							ClassName:'web.DHCWL.V1.MKPIIO.DefaultInService',
							MethodName:'UPFILE',
							theStep:theStep,
							inputCont:inputCont,
							inputType:'module'
						},function(txtData){
							loadInforShow("end");
							handlerImportContent(txtData);
						})
						
					}
				}
			},{
				iconCls:'icon-check-reg',
				text:'导入前检查',
				handler:function(){
					
					if (KPI_INPUT_FLAG == ""){
						myMsg("请先读取模块文件后操作");
						return;
					}else if(KPI_INPUT_FLAG == "check"){
						myMsg("请勿重复操作");
						return;
					}else if (KPI_INPUT_FLAG == "input"){
						myMsg("请重新读取模块文件");
						return;
					}
					KPI_INPUT_FLAG = "check";
					
					loadInforShow("start","","正在进行模块与报表信息检查");
					$('#moduleInforTree').treegrid('loadData', { total: 0, rows: [] }); 
					var moduleArrList = [];
					$m({
						ClassName:'web.DHCWL.V1.MKPIIO.DefaultInService',
						MethodName:'inputModuleInfor'
					},function(txtData){
						loadInforShow("end");
						var jsonObj = JSON.parse(txtData);
						//var fileName = jsonObj.tips;
						//FILE_PATH_GLOBAL = fileName;
						var rootLen = jsonObj.length;
						for (var i = 0;i < rootLen;i++){
							var type = "",desc = "",code = "",ID = "",parentID = "",treeCode = "";
							var className = jsonObj[i].className;
							if (className == "DHCWL.MKPI.MMgrModuleCfg"){
								type = "模块";
								desc = jsonObj[i].ModuleCfgDesc;
								code = jsonObj[i].ModuleCfgCode;
								ID = jsonObj[i].ModuleCfgTreeCode;
								treeCode = jsonObj[i].ModuleCfgTreeCode;
								parentID = jsonObj[i].ModuleCfgPTreeCode;
								flag = jsonObj[i].flag;
							}else if(className == "DHCWL.MKPI.MMgrRptCfg"){
								type = "报表";
								desc = jsonObj[i].RptCfgName;
								code = jsonObj[i].RptCfgCode;
								ID = jsonObj[i].primaryValue;
								treeCode = jsonObj[i].primaryValue;
								flag = jsonObj[i].flag;
								
								var rptIDArr = ID.split("||");
								ID = rptIDArr.join('.');
								
								parentID = PCommond(ID,".",1,-1);
							}else if(className == "DHCWL.MKPI.MMgrDataSetCfg"){
								type = "数据集";
								desc = jsonObj[i].DatasetCfgDesc;
								code = jsonObj[i].DatasetCfgCode;
								ID = jsonObj[i].primaryValue;
								treeCode = jsonObj[i].primaryValue;
								flag = jsonObj[i].flag;
								
								var dsIDArr = ID.split("||");
								ID = dsIDArr.join('.');
								
								parentID = PCommond(ID,".",1,-1);
								
							}
							if ($.inArray(parentID,moduleArrList) == -1){
								parentID = "";
							}
							moduleArrList.push(ID);
							$('#moduleInforTree').treegrid('append',{
								parent: parentID,
								data: [{
									ID  : ID,
									treeCode:treeCode,
									desc: desc,
									type: type,
									code: code,
									flag: flag
								}]
							});
						}
						return;
						
					})
				}
			},{
				iconCls:'icon-ok',
				text:'导入模块',
				handler:function(){
					if (KPI_INPUT_FLAG != "check"){
						myMsg("请先进行导入前检查后再操作");
						return;
					}
					
					var treeRows = $('#moduleInforTree').treegrid("getCheckedNodes");
					var len = treeRows.length;
					var nodeID = "";
					moduleInputListArr = [];
					for (var i = 0;i < len;i++){
						nodeID = treeRows[i].ID;
						treeCode = treeRows[i].treeCode;
						getAllParentNodeList(nodeID);
						if ($.inArray(treeCode,moduleInputListArr) == -1){
							moduleInputListArr.push(treeCode);
						}
					}
					var moduleList = moduleInputListArr.join(",");
					if (moduleList == ""){
						myMsg("请先选择需要导入的条目后操作");
						return;
					}
					KPI_INPUT_FLAG == "input";
					
					loadInforShow("start","","正在进行指标导入");
					$m({
						ClassName:'web.DHCWL.V1.MKPIIO.DefaultInService',
						MethodName:'InputModuleFile',
						fileName:FILE_PATH_GLOBAL,
						realInputModuleList:moduleList
					},function(e){
						loadInforShow("end");
						$('#moduleInforTree').treegrid('loadData',{total:0,rows:[]}); 
						myMsg(e);
						$('#moduleInforTree').treegrid('reload');
						$HUI.dialog("#moduleInputDialog").close();
					})
				}
			}]
		})
		$('#moduleInforTree').treegrid('loadData',{total:0,rows:[]});
		$('#textBox').filebox('clear');
		$("#moduleInputDialog").show();
		$HUI.dialog("#moduleInputDialog",{
			iconCls:'icon-w-import',
			resizable:true,
			height:kpiBodyHeight-40,
			title:title,
			modal:true,
			onClose:function(e){
				KPI_INPUT_FLAG = "";
			}
		})
	}
	if (ID == "exportButton"){                   ///点击了导出按钮
		$HUI.treegrid("#moduleOutputTree",{	     ///用于导出的模块树加载
			url:$URL,
			queryParams:{
				ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
				QueryName:'GetModuleTreeQuery',
				rows:10000,
				page:1
			},
			cascadeCheck:false,
			fitColumns:true,
			toolbar:[{
				text:'导出非维度版',
				iconCls:'icon-unload-cloud',
				handler:function(){
					exportModule(1);
				}
			},{
				text:'导出维度版',
				iconCls:'icon-unload-cloud',
				handler:function(){
					exportModule(0);
				}
			}]
		})
		$("#moduleOutputDialog").show();     ///模块导出弹出框展示
		$HUI.dialog("#moduleOutputDialog",{
			height:kpiBodyHeight-40,
			iconCls:'icon-w-export',
			resizable:true,
			modal:true
		})
	}
	
	if (ID=="viewKPIListButton"){             ///查看指标列表
		title = title + "--指标列表"
		$("#moduleKPIListDialog").show();
		$HUI.dialog("#moduleKPIListDialog",{
			resizable:true,
			modal:true,
			title:title,
			iconCls:'icon-w-list'
		})
		$m({
			ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
			MethodName:'GetKPIListByModule',
			treeCode:treeCode,
			type:type
		},function(textData){
			$("#moduleKPIList").val("");
			$("#moduleKPIList").val(textData);
			//document.getElementById('moduleKPIList').innderHTML = "textData";
			//$("#moduleKPIList").html("tt");
		});
	}
	
	if(ID == "taskConfigButton"){
		title = title + "--任务配置";
		$HUI.datagrid("#taskShowTable",{
			url:$URL,
			queryParams:{
				ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
				QueryName:'GetKPITaskByMRDQuery',
				secInfors:'',
				treeNodes:treeCode,
				sign:type
			},
			fitColumns:true,
			toolbar:[{
				iconCls:'icon-ok',
				text:'激活任务',
				handler:function(){
					var kpiCodes = getKPICode();
					if (kpiCodes == ""){
						myMsg("请先选择需要修改的指标");
						return;
					}
					$m({
						ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
						MethodName:'ActiveKPITask',
						kpiCodes:kpiCodes
					},function(textData){
						$("#taskShowTable").datagrid("reload");
						myMsg(textData);
					})
				}	
			},{
				iconCls:'icon-cancel',
				text:'关闭任务',
				handler:function(){
					var kpiCodes = getKPICode();
					if (kpiCodes == ""){
						myMsg("请先选择需要修改的指标");
						return;
					}
					$m({
						ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
						MethodName:'DisActiveKPITask',
						kpiCodes:kpiCodes
					},function(textData){
						$("#taskShowTable").datagrid("reload");
						myMsg(textData);
					})
				}
			}],
			onLoadSuccess:function(){
				/*var rows = $("#taskShowTable").datagrid("getRows");
				if (rows){*/
					mergeCellTaskByKpiCode("secCode");
				//}
			},
			onCheck:function(rowIndex,rowData){
				//if (rowData.secCode == "D"){
				if (kpiFirstSecList[rowData.kpiCode] == rowIndex){
					//console.log(kpiFirstSecList);
					var rows = $("#taskShowTable").datagrid("getRows");
					if (rows){
						var len = rows.length;
						for (var i = 0;i < len;i++){
							row = rows[i];
							if ((row.kpiCode == rowData.kpiCode)&&(kpiFirstSecList[rowData.kpiCode] != i)){
								$("#taskShowTable").datagrid("selectRow",i);
							}
						}
					}
				}
				//alert(rowData.kpiCode);
			},
			onUncheck:function(rowIndex,rowData){
				if (kpiFirstSecList[rowData.kpiCode] == rowIndex){
					var rows = $("#taskShowTable").datagrid("getRows");
					if (rows){
						var len = rows.length;
						for (var i = 0;i < len;i++){
							row = rows[i];
							if ((row.kpiCode == rowData.kpiCode)&&(kpiFirstSecList[rowData.kpiCode] != i)){
								$("#taskShowTable").datagrid("unselectRow",i);
							}
						}
					}
				}
			}
		})
		
		$HUI.datagrid("#taskConfigTable",{
			fitColumns:true,
			toolbar:[{
				iconCls:'icon-add',
				text:'顺序增加区间任务',
				handler:function(){
					var rows = $("#taskConfigTable").datagrid("getRows"); //捕获所有任务的编码
					var taskCodes = "",i;
					if (rows){
						for (i = 0;i < rows.length;i++){
							if (!taskCodes){
								taskCodes=rows[i].secCode;
							}else{
								taskCodes=taskCodes+","+rows[i].secCode;
							}
						}
					}
					$.cm({
						ClassName:'web.DHCWL.V1.KPI.KPIFunction',
						MethodName:'GetNextKPITask',
						kpiCode:"",
						existCode:taskCodes
					},function(jsonData){
						if (jsonData.sc != "ok") {
							$.messager.alert("提示",jsonData.sc);
						}else {
							if (secCodeS == ""){
								secCodeS = jsonData.code;
								exeCodeS = jsonData.exeCode;
							}else{
								secCodeS = secCodeS + jsonData.code;
								exeCodeS = exeCodeS + jsonData.exeCode;
							}
							$("#taskConfigTable").datagrid("insertRow",{   // 获取到数据之后，将数据插入到表格中
								row:{
									secCode:jsonData.code,
									secName:jsonData.desc,
									exeCode:jsonData.exeCode
								}
							});
							$("#taskShowTable").datagrid("reload");
						}
					});
				}
			},{
				iconCls:'icon-save',
				text:'保存',
				handler:function(){
					var rows = $("#taskShowTable").datagrid("getSelections");
					if (rows.length == 0){
						myMsg("请先选择需要操作的指标");
						return;
					}
					var taskRows = $("#taskConfigTable").datagrid("getRows");
					if (taskRows.length == 0){
						myMsg("请先配置需要保存的任务")
						return;
					}
					$.messager.confirm("保存","您确定按照下面配置的任务列表配置已选中的指标么,保存后将不能修改",function(r){
						if (r){
							var secKPICodes = "",secLen = rows.length,row = "",taskLen = taskRows.length,taskRow = "";
							for (var i = 0;i < secLen;i++){
								row = rows[i];
								secKPICode = row.kpiCode;
								if (secKPICodes == ""){
									secKPICodes = secKPICode;
								}else{
									if (secKPICodes.indexOf(secKPICode) == -1){
										secKPICodes = secKPICodes + "," +secKPICode;
									}
								}
							}
							var secTaskLists = "",secTaskList = "";
							for (var j = 0;j < taskLen;j++){
								taskRow = taskRows[j];
								taskCode = taskRow.secCode;
								taskName = taskRow.secName;
								taskExeCode = taskRow.exeCode;
								secTaskList = taskCode + "," + taskName + "," +taskExeCode + "," + "Y";
								if (!secTaskLists){
									secTaskLists = secTaskList;
								}else{
									secTaskLists = secTaskLists + "@" + secTaskList;
								}
							}
							$m({
								ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
								MethodName:'SetKPITask',
								secTaskList:secTaskLists,
								kpiList:secKPICodes,
								treeCode:treeCode,
								type:type
							},function(text){
								$("#taskShowTable").datagrid("reload");
								myMsg(text);
							})
							//alert(secKPICodes+"^"+treeCode+"^"+type+"^"+secTaskLists);
						}
					})
				}
			}]
		})
		secCodeS = "",exeCodeS = "";
		$("#taskConfigTable").datagrid("loadData",{total:0,rows:[]});
		$("#taskShowTable").datagrid("reload");
		$("#moduleTaskConfigDialog").show();
		$HUI.dialog("#moduleTaskConfigDialog",{
			height:kpiBodyHeight-40,
			resizable:true,
			modal:true,
			iconCls:'icon-w-config',
			title:title
		})
	}
}


/*--根据树节点遍历出所有父节点--*/
function getAllParentNodeList(id)
{
	var parentNode = "";
	for (var i = 1;i < 20;i++){
		parentNode = $('#moduleInforTree').treegrid('getParent', id);
		if ((parentNode == "")||(!parentNode)){
			return;
		}
		id = parentNode.ID;
		treeCode = parentNode.treeCode;
		if ($.inArray(treeCode,moduleInputListArr) == -1){
			moduleInputListArr.push(treeCode);
		}
	}
}

/*--导出模块信息--*/
function exportModule(flag){
	var rows = $("#moduleOutputTree").treegrid("getCheckedNodes");   //获取所有勾选的树节点
	var len = rows.length;
	if (len < 1){
		myMsg("请先选择模块信息之后再进行操作");
		return;
	}
	var treeCodes = "",treeCode="";    
	for (var i = 0;i < len;i++){   //将勾选的树节点将code拼起来
		treeCode = rows[i].ID;
		if (treeCodes == ""){
			treeCodes = treeCode;
		}else{
			treeCodes = treeCodes + "," + treeCode;
		}
	}
	dir = "";
	$m({        //调用后台代码导出模块信息
		ClassName: "web.DHCWL.V1.KPI.ModuleFunction",
		MethodName: "exportModule",
		treeCodes:treeCodes,
		type:'module'
	},function(responseText){
		var browserStr = myBrowser();
		if (browserStr != "IE"){
			var fileName = "D:\\\\" + nowDateTimeUtil()+'outputModule.modu'
			responseText = trimLeftUtil(responseText);
			var Str = "(function test(x){"+
				"var fso, f, s;" + 
				'fso = new ActiveXObject("Scripting.FileSystemObject");' +
				'f = fso.OpenTextFile("' + fileName + '", 8, true);' + 
				"f.WriteLine('" + responseText + "');" +
				'f.Close();' +
				'return 1;' +
			"}());";
			console.log(Str);
			CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
			var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
			//myMsg("导出文件：" + fileName + " ,请根据路径查看导出情况");
			//return ;
		}else{
			writeFileUtil(nowDateTimeUtil()+'outputModule.modu',trimLeftUtil(responseText));
		}
		
		$HUI.dialog("#moduleOutputDialog").close();
		
		$.m({        //调用后台代码导出模块内指标信息
			ClassName: "web.DHCWL.V1.KPI.ModuleFunction",
			MethodName: "exportModuleKPI",
			treeCodes:treeCodes,
			type:'module',
			flag:flag
		},function(responseText){
			
			var browserStr = myBrowser();
			if (browserStr != "IE"){
				var fileName = "D:\\\\" + nowDateTimeUtil()+'outputKpis.kpi'
				responseText = trimLeftUtil(responseText);
				var Str = "(function test(x){"+
					"var fso, f, s;" + 
					'fso = new ActiveXObject("Scripting.FileSystemObject");' +
					'f = fso.OpenTextFile("' + fileName + '", 8, true);' + 
					"f.WriteLine('" + responseText + "');" +
					'f.Close();' +
					'return 1;' +
				"}());";
				console.log(Str);
				CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
				var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
				myMsg("已完成导出文件2个,请在D:\\路径下查看");
				//return ;
			}else{
				writeFileUtil(nowDateTimeUtil()+'outputKpis.kpi',trimLeftUtil(responseText),1);
				myMsg("导出成功");
			}
		})
		
	})
	
	
	/*$m({        //调用后台代码导出模块内指标信息
		ClassName: "web.DHCWL.V1.KPI.ModuleFunction",
		MethodName: "exportModuleKPI",
		treeCodes:treeCodes,
		type:'module',
		flag:flag
	},function(responseText){
		writeFileUtil(nowDateTimeUtil()+'outputKpis.kpi',trimLeftUtil(responseText));
	})*/
}



/*--判断浏览器类型--*/
function myBrowser(){
    var explorer = window.navigator.userAgent,
    compare = function(s) { return (explorer.indexOf(s) >= 0); },
    ie11 = (function() { return ("ActiveXObject" in window) })();
    if (compare("MSIE") || ie11) { return 'IE'; }
    else if (compare("Firefox") && !ie11) { return 'Firefox'; }
    else if (compare("Chrome") && !ie11) { return 'Chrome'; }
    else if (compare("Opera") && !ie11) { return 'Opera'; }
    else if (compare("Safari") && !ie11) { return 'Safari'; }
}



/*--获取模块、报表或者数据集指标列表--*/
function getKPICode(){
	var rows = $("#taskShowTable").datagrid("getSelections");
	var secLen = rows.length,secKPICodes="";
	for (var i = 0;i < secLen;i++){
		row = rows[i];
		secKPICode = row.kpiCode;
		if (secKPICodes == ""){
			secKPICodes = secKPICode;
		}else{
			if (secKPICodes.indexOf(secKPICode) == -1){
				secKPICodes = secKPICodes + "," +secKPICode;
			}
		}
	}
	return secKPICodes
}


/*--单元格按照传入的指标编码重新合并单元格--*/
function mergeCellTaskByKpiCode(){
	var rows = $("#taskShowTable").datagrid("getRows");
	var len = rows.length;
	var code = "",kpiCode = "",startNum = 0,rowspan = 0;
	for (var i = 0;i < len;i++){
		kpiCode = rows[i].kpiCode;
		if ((kpiCode != code)||(i == (len-1))){
			if (i != 0){
				if ((i == (len-1))&&(len != 2)){
					rowspan = i - startNum + 1;
				}else{
					rowspan = i - startNum;
				}
				
				kpiFirstSecList[code]=startNum;
				$('#taskShowTable').datagrid('mergeCells',{
					index:startNum,
					field:'kpiCode',
					rowspan:rowspan
				});
				$('#taskShowTable').datagrid('mergeCells',{
					index:startNum,
					field:'ck',
					rowspan:rowspan
				});
				startNum = i;
			}else{
				kpiFirstSecList = [];
			}
			code = kpiCode;
		}
	}
}


/*--用于修改已经维护区间单元格的背景色--*/
 function cellStyler(value,row,index){
	 flag = row.flag;
	 if ((flag == 1)) {
		 return 'color:#ee4f38;';
		 
	 } 
 	//return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
 }
 function cellExeCodeStyler(value,row,index){
	 secCode = row.secCode;
	 secExeCode = row.exeCode;
	 if ((secCodeS.indexOf(secCode) == -1)&&(secCodeS != "")) {
		 return 'background-color:#ffee00;';	 
	 }
	 if ((secCodeS.indexOf(secCode) != -1)&&(exeCodeS.indexOf(secExeCode)) == -1){
		 return 'background-color:#DE5246;';
	 } 
 }

/********以下是模块与报表的展示以及增删改************/

/*--鼠标悬停备注单元格响应方法--*/
 function formatCellTooltip(value){  
 	return "<span id='verylongText' title='" + value + "'>" + value + "</span>";  
 }


/*--模块表格--*/
var moduleTreeObj = $HUI.treegrid("#moduleCfgTree",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
		QueryName:'GetModuleTreeQuery',
		rows:10000,
		page:1
	},
	cascadeCheck:false,
	fitColumns:true,
	toolbar:"#modToobar"
	/*toolbar:[{
		text:'新增',
		iconCls:'icon-add',
		handler:function(){
			moduleConfig("add");
		}
	},{
		text:'修改',
		iconCls:'icon-write-order',
		handler:function(){
			moduleConfig("modify");
		}
	},{
		text:'删除',
		iconCls:'icon-cancel',
		handler:function(){
			var row = $("#moduleCfgTree").treegrid("getSelected");
			if (!row){
				myMsg("请先选择需要删除的模块");
				return;
			}
			treeCode=row.ID;
			$.messager.confirm("删除","删除后将不能恢复确认删除么",function(r){   //弹出提示框，确认删除么
				if (r){
					moduleTreeObj.unselectAll();
					$m({
						ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
						MethodName:'DeleteModule',
						treeCode:treeCode
					},function(txtData){
						myMsg(txtData);      //弹出删除提示信息
						moduleTreeObj.reload();      //刷新当前页
					})
				}else{
					return;
				}
			})
		}
	}]*/,onClickRow:function(row){
		//console.log(row);
		var value = row;
		if (typeof(row) == "Object"){
			value = row.ID
		}
		reportObj.load({ClassName:'web.DHCWL.V1.KPI.ModuleFunction',QueryName:'GetReportQuery',treeCode:value});
		$("#dataSetTable").datagrid('loadData',{total:0,rows:[]});
	}

})

//模块新增
$("#modAddButton").click(function(e){
	moduleConfig("add");
})

//模块修改
$("#modModifyButton").click(function(e){
	moduleConfig("modify");
})

//模块删除
$("#modDeleteButton").click(function(e){
	var row = $("#moduleCfgTree").treegrid("getSelected");
	if (!row){
		myMsg("请先选择需要删除的模块");
		return;
	}
	treeCode=row.ID;
	$.messager.confirm("删除","删除后将不能恢复确认删除么",function(r){   //弹出提示框，确认删除么
		if (r){
			moduleTreeObj.unselectAll();
			$m({
				ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
				MethodName:'DeleteModule',
				treeCode:treeCode
			},function(txtData){
				myMsg(txtData);      //弹出删除提示信息
				moduleTreeObj.reload();      //刷新当前页
			})
		}else{
			return;
		}
	})
})

//模块检索
$('#searchText').searchbox({
	searcher:function(value,name){
		moduleTreeObj.load({ClassName:"web.DHCWL.V1.KPI.ModuleFunction",QueryName:"GetModuleTreeQuery",filterValue:value,rows:10000,page:1});
	}
})

/*--报表表格--*/
var reportObj = $HUI.datagrid("#reportTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
		QueryName:'GetReportQuery',
		treeCode:''
	},
	fitColumns:true,
	toolbar:[{
		text:'新增',
		iconCls:'icon-add',
		handler:function(){
			reportConfig("add");
		}
	},{
		text:'修改',
		iconCls:'icon-write-order',
		handler:function(){
			reportConfig("modify");
		}
	},{
		text:'删除',
		iconCls:'icon-cancel',
		handler:function(){
			var row=$("#reportTable").datagrid("getSelected");
			if (!row){
				myMsg("请先选择需要删除的报表");
				return;
			}
			//console.log(row);
			//alert(row.rpCode+"^"+row.rpTreeCode);
			$.messager.confirm("删除","删除后将不能恢复确认删除么",function(r){   //弹出提示框，确认删除么
				if (r){
					$m({
						ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
						MethodName:'DeleteRp',
						treeCode:row.rpTreeCode,
						rpCode:row.rpCode
					},function(txtData){
						myMsg(txtData);
						reportObj.reload();
					})
				}else{
					return;
				}
			})
		}
	}],onClickRow:function(rowIndex,rowData){
		var treeCode = rowData.rpTreeCode;
		var rpCode = rowData.rpCode;
		dataSetObj.load({ClassName:'web.DHCWL.V1.KPI.ModuleFunction',QueryName:'GetDateSetQuery',treeCode:treeCode,rpCode:rpCode});
	}
})

/*--数据集表格--*/
var dataSetObj = $HUI.datagrid("#dataSetTable",{
	url:$URL,
	queryParams:{
		ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
		QueryName:'GetDateSetQuery',
		treeCode:'',
		rpCode:''
	},
	fitColumns:true,
	toolbar:[{
		text:'新增',
		iconCls:'icon-add',
		handler:function(){
			dataSetConfig("add");
		}
	},{
		text:'配置取数规则',
		iconCls:'icon-batch-cfg',
		handler:function(){
			var row = $("#dataSetTable").datagrid("getSelected");
			if (!row){
				myMsg("请先选中数据集后再进行操作");
				return;
			}
			var dsRule = row.dsRule;
			showKPIRuleConfig(dsRule);
		}
	},{
		text:'配置过滤规则',
		iconCls:'icon-batch-cfg',
		handler:function(){
			var row = $("#dataSetTable").datagrid("getSelected");
			if (!row){
				myMsg("请先选中数据集后再进行操作");
				return;
			}
			var dsRule = row.dsRule;
			var dsID = row.dsID;
			if ((!dsRule)||(dsRule == "")){
				myMsg("请先配置好取数规则后再进行过滤规则的配置");
				return;
			}
			showKPIFilterConfig(dsRule,"module",dsID);
		}
	},{
		text:'修改',
		iconCls:'icon-write-order',
		handler:function(){
			dataSetConfig("modify");
		}
	},{
		text:'删除',
		iconCls:'icon-cancel',
		handler:function(){
			var dsRow,rpRow,dsCode,rpCode,treeCode;
			dsRow = $("#dataSetTable").datagrid("getSelected");
			if (!dsRow){
				myMsg("请先选中需要删除的数据集");
				return;
			}
			dsCode=dsRow.dsCode;
			rpRow = $("#reportTable").datagrid("getSelected");
			if (!rpRow){
				myMsg("获取模块节点失败");
				return;
			}
			rpCode=rpRow.rpCode;
			treeCode=rpRow.rpTreeCode;
			$.messager.confirm("删除","删除后将不能恢复确认删除么",function(r){   //弹出提示框，确认删除么
				if (r){
						$m({
							ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
							MethodName:'DeleteDs',
							rptCode:rpCode,
							treeCode:treeCode,
							dsCodes:dsCode
						},function(textData){
							dataSetObj.reload();
							myMsg(textData);
						})
				}else{
					return;
				}
			})
		}
	}]
})

/*--数据集取数规则配置--*/
function saveKPIRule(value)
{
	var row = $("#dataSetTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选中数据集后再进行操作");
		return;
	}
	var dsID = row.dsID;
	$m({                  //把取数规则保存到后台
		ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
		MethodName:'SaveDSRule',
		dsID:dsID,
		rulelist:value
	},function(textData){
		myMsg(textData);
		$("#dataSetTable").datagrid("reload");
	})
}


/*--模块更新方法--*/
function moduleConfig(operType){
	$("#moduleForm").form('reset');     //清空表单
	var typeID = "";
	
	var row = $("#moduleCfgTree").treegrid("getSelected");   //获取选中的模块
	if (!row){
		myMsg("请先选择一条模块记录再操作");
		return;
	}
	treeCode = row.ID;   //获取选中的树节点
	if (operType == "modify"){   //当模块修改时
		$("#moduleCode").val(row.code);
		$("#moduleDesc").val(row.name);
		$("#moduleForm").form('validate');
		$("#moduleCode").attr("disabled",true);
		title = "模块修改";
		iconModule = "icon-w-edit";
	}else{   //当模块新增时
		$("#moduleCode").attr("disabled",false);
		$("#moduleForm").form('validate');
		title="模块新增"
		iconModule = "icon-w-add";
	}
	$("#moduleAddDialog").show(); //弹出模块维护弹出框
	$("#moduleCode")[0].focus(); 
	$HUI.dialog("#moduleAddDialog",{
		iconCls:iconModule,
		title:title,
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(){
				var code,desc;
				code = $("#moduleCode").val();
				desc = $("#moduleDesc").val();
				var isValid = $("#moduleForm").form('validate');   //检查表单信息是否符合要求
				if (!isValid){
					myMsg("请按照提示填写内容");
					return;
				}
				//alert(proCode+"^"+proName+"^"+proDesc+"^"+proExeCode+"^"+proActFlag+"^"+dimProDeli);
				//return;
				$m({                                             //将信息保存到后台
					ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
					MethodName:'UpdateModule',
					type:operType,
					code:code,
					desc:desc,
					pTreeCode:treeCode
				},function(txtData){
					myMsg(txtData);		  //弹框显示返回信息
					moduleTreeObj.reload();      //刷新当前页
					$HUI.dialog("#moduleAddDialog").close();  //关闭弹窗
				});
			}
		},{
			text:'关闭',
			handler:function(){
				$HUI.dialog("#moduleAddDialog").close();
			}
		}]
	})
}


/*--报表更新--*/
function reportConfig(operType)
{
	var treeRow,treeCode;
	$("#rpForm").form("reset");   //清空表单信息
	treeRow = $("#moduleCfgTree").treegrid("getSelected");   //判断是否选中了模块
	if (!treeRow){
		myMsg("请先选择所属模块~");
		return;
	}
	treeCode = treeRow.ID;   //获取treeCode
	if (operType == "modify"){                                    //如果是修改给表单赋值
		var rpCode,rpName,rpDesc;
		rpRow = $("#reportTable").datagrid("getSelected");  //判断是否选中了报表
		if (!rpRow){
			myMsg("请先选择需要修改的报表");
			return;
		}
		$("#rpCode").val(rpRow.rpCode);
		$("#rpName").val(rpRow.rpName);
		$("#rpDesc").val(rpRow.rpDesc);
		$("#rpForm").form("validate");   //表单内容合法性检查
		$("#rpCode").attr("disabled",true);
		title = "报表修改";
		iconRpt = "icon-w-edit";
	}else{
		//$("#dimRoleAddDialog").dialog({title:'维度角色新增'});   //修改dialog标题
		$("#rpCode").attr("disabled",false);
		title = "报表新增",
		iconRpt = "icon-w-add";
	}
	$("#rpAddDialog").show();
	$HUI.dialog("#rpAddDialog",{
		title:title,
		iconCls:iconRpt,
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(){
				var code,name,desc;
				if (!treeCode){
					myMsg("获取模块信息失败");
					return;
				}
				code = $("#rpCode").val();
				name = $("#rpName").val();
				desc = $("#rpDesc").val();
				flag = $("#rpForm").form("validate");   //表单内容合法性检查
				if (!flag){
					myMsg("请按照提示填写信息");
					return;
				}
				$m({
					ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
					MethodName:'UpdateRp',
					code:code,
					name:name,
					desc:desc,
					treeCode:treeCode,
					type:operType
				},function(txtData){
					myMsg(txtData);
					reportObj.reload();
					$HUI.dialog("#rpAddDialog").close();  //关闭表单弹框
				})
			}
		},{
			text:'关闭',
			handler:function(){
				$("#rpForm").form("reset");   //清空表单信息
				$HUI.dialog("#rpAddDialog").close();  //关闭表单弹框
			}
		}]
	})
}

/*--数据集更新--*/
function dataSetConfig(operType)
{
	var rpRow,rpCode,treeCode;
	$("#dsForm").form("reset");   //清空表单信息
	rpRow = $("#reportTable").datagrid("getSelected");  //判断是否选中了报表
	if(!rpRow){
		myMsg("请先选择所属报表");
		return;
	}
	rpCode = rpRow.rpCode;
	treeCode = rpRow.rpTreeCode;
	var dsRow,dsID,dsCode,dsDesc;
	if (operType == "modify"){                                    //如果是修改给表单赋值
		dsRow = $("#dataSetTable").datagrid("getSelected");  //判断是否选中了数据集
		if (!dsRow){
			myMsg("请先选择需要修改的数据集");
			return;
		}
		dsID=dsRow.dsID;
		$("#dsCode").val(dsRow.dsCode);
		$("#dsDesc").val(dsRow.dsDesc);
		$("#dsForm").form("validate");   //表单内容合法性检查
		$("#dsCode").attr("disabled",true);
		title = "数据集修改";
		iconDataSet = "icon-w-edit";
	}else{
		//$("#dimRoleAddDialog").dialog({title:'维度角色新增'});   //修改dialog标题
		$("#dsCode").attr("disabled",false);
		title = "数据集新增";
		iconDataSet = "icon-w-add";
	}
	$("#dsAddDialog").show();
	$HUI.dialog("#dsAddDialog",{
		title:title,
		iconCls:iconDataSet,
		resizable:true,
		modal:true,
		buttons:[{
			text:'保存',
			handler:function(){
				var code,name,desc;
				if (!treeCode){
					myMsg("获取模块信息失败");
					return;
				}
				code = $("#dsCode").val();
				desc = $("#dsDesc").val();
				flag = $("#dsForm").form("validate");   //表单内容合法性检查
				if (!flag){
					myMsg("请按照提示填写信息");
					return;
				}
				$m({
					ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
					MethodName:'UpdateDs',
					dsID:dsID,
					dsCode:code,
					dsDesc:desc,
					treeCode:treeCode,
					rpCode:rpCode,
					type:operType
				},function(txtData){
					myMsg(txtData);
					dataSetObj.reload();
					$HUI.dialog("#dsAddDialog").close();  //关闭表单弹框
				})
			}
		},{
			text:'关闭',
			handler:function(){
				$("#dsForm").form("reset");   //清空表单信息
				$HUI.dialog("#dsAddDialog").close();  //关闭表单弹框
			}
		}]
	})
	
}

/*--过滤规则确定按钮--*/
$("#filterDefineModuleButton").click(function(e){
	var kpiFilterRules = changeFilterTableToRule();
	var row = $("#dataSetTable").datagrid("getSelected");
	if (!row){
		myMsg("请先选中数据集后再进行操作");
		return;
	}
	var dsID = row.dsID;
	$m({
		ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
		MethodName:'SaveDSFilterRule',
		dsID:dsID,
		filterList:kpiFilterRules
	},function(e){
		myMsg("保存成功");
		$HUI.dialog("#kpiFilterConfigDialog").close();
		$("#dataSetTable").datagrid("reload");
	})
	//document.getElementById("viewKPIData").contentWindow.setFilterRule(kpiFilterRules);
	//$HUI.dialog("#kpiFilterConfigDialog").close();
})



/*--过滤规则手动数据按钮--*/
$("#filterWriteButton").click(function(e){
	$("#filterWriteTextbox").val("");
	$("#filterWriteDialog").show();
	$HUI.dialog("#filterWriteDialog",{
		resizable:true,
		modal:true,
		iconCls:'icon-w-config',
		buttons:[{
			text:'保存',
			handler:function(e){
				var value = $("#filterWriteTextbox").val();
				var row = $("#dataSetTable").datagrid("getSelected");
				if (!row){
					myMsg("请先选中数据集后再进行操作");
					return;
				}
				var dsID = row.dsID;
				$m({
					ClassName:'web.DHCWL.V1.KPI.ModuleFunction',
					MethodName:'SaveDSFilterRule',
					dsID:dsID,
					filterList:value
				},function(e){
					myMsg("保存成功");
					$HUI.dialog("#filterWriteDialog").close();
					$HUI.dialog("#kpiFilterConfigDialog").close();
					$("#dataSetTable").datagrid("reload");
				})
			}
		},{
			text:'关闭',
			handler:function(e){
				$HUI.dialog("#filterWriteDialog").close();
			}
		}]
	})
})

/************初始化设置*******************/
/*var init = function(){
	function initPopover(){
		
		var settings = {
			trigger:'hover',
			title:'',
			content:'<p>This is webui popover demo.</p><p>just enjoy it and have fun !</p>',
			width:350,						
			multi:true,						
			closeable:false,
			style:'',
			padding:true
		};
		
		var tableContent = $('#importDetailButton').html(),

		
		tableSettings = {
			content:tableContent,
			width:200
		};

		$('#importButton').webuiPopover('destroy').webuiPopover($.extend({},settings,tableSettings));
	};
	initPopover();

}
$(init);﻿*/
$("#kpiRuleShowImage").click(function(e){
	$('#kpiRuleSearchKPIInfor').searchbox('setValue', '');
})
var init = function(){
	function initPopover(){
		var settings = {
			trigger:'click',
			title:'',
			content:'<p>This is webui popover demo.</p><p>just enjoy it and have fun !</p>',
			width:350,						
			multi:true,						
			closeable:false,
			style:'',
			padding:true
		};
		var kpiRuleSettings = {
			width : 760,
			height:163,
			placement:'auto-bottom',
			closeable:false,
			padding:false,
			type:'iframe',
			url:'dhcwlredirect.csp?url=dhcwl/v1/kpi/kpi/configsimplekpisearch.csp'
		}
		$('#kpiRuleShowImage').webuiPopover('destroy').webuiPopover($.extend({},settings,kpiRuleSettings));
	}
	initPopover();
}
$(init);


