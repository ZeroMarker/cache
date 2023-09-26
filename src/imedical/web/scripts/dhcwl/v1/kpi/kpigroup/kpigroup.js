var selectedKPIIdList = [],addKey = 0,deleteKey = 0;
var filePathLog = "";
var FILE_PATH_GLOBAL = "";
var KPI_INPUT_FLAG = "";
var grpBodyHeight = getViewportOffset().y;   // 获取屏幕高度
/*--任务组明细检索--*/
function freshKPIRuleTableFun(kpiInforList){
	var kpiCode,kpiName,kpiMea,kpiExeCode,dataNode,kpiCreator,kpiDimCodes,kpiDesc,kpiType,kpiSection,kpiValueType,kpiRemark
	kpiInforArr = kpiInforList.split("@");
	kpiCode = kpiInforArr[0];
	kpiName = kpiInforArr[1];
	kpiMea = kpiInforArr[2];
	kpiExeCode = kpiInforArr[3];
	dataNode = kpiInforArr[4];
	kpiCreator = kpiInforArr[5];
	kpiDimCodes = kpiInforArr[6];
	kpiType = kpiInforArr[7];
	kpiRemark = kpiInforArr[8];
	$("#kpiSelectGrid").datagrid('load',{ClassName:"web.DHCWL.V1.KPI.KPIFunction",QueryName:"GetKPIListQuery",kpiCode:kpiCode, kpiName:kpiName, kpiExcode:kpiExeCode, createUser:kpiCreator, dataNode:dataNode, dimType:kpiDimCodes, category:kpiType,nodeMark:kpiRemark,filterMea:kpiMea,isGroup:'1'});  //重新加载指标信息
}

function test(newVal,oldVal){
	if (newVal=="") return;
	if (newVal==oldVal) return;
	filePathLog=getFieldValue("importRegion","groupInputFilebox");
}

	var kpiGroupObj = $HUI.datagrid("#groupGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.KPI.TaskGroupFunction',
			QueryName:'GetTaskGroupQuery'
		},
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20],
		onClickRow:function(rowIndex,rowData){
			$('#grpKPISearch').searchbox('setValue',"");
			var groupID = rowData.ID;
			$('#kpiGrid').datagrid('clearChecked');
			kpiObj.load({ClassName:'web.DHCWL.V1.KPI.TaskGroupFunction',QueryName:'GetGroupDetailQuery',groupID:groupID});
		},
		toolbar:[{
			text:'新增',
			iconCls:'icon-add',
			handler:function(e){
				groupUpdate('add');
			}
		},{
			text:'修改',
			iconCls:'icon-write-order',
			handler:function(e){
				groupUpdate('edit');
			}
		},{
			text:'删除',
			iconCls:'icon-cancel',
			handler:function(e){
				var row = $("#groupGrid").datagrid("getSelected");
				if (!row){
					myMsg('请先选择一条任务组');
					return;
				}
				var groupID = row.ID;
				$.messager.confirm("警告!!", "删除后将不能恢复,确定删除么", function (r) {
					if (r) {
						$m({
							ClassName:'web.DHCWL.V1.KPI.TaskGroupFunction',
							MethodName:'DeleteGroup',
							groupID:groupID	
						},function(e){
							myMsg(e);
							kpiGroupObj.reload();
							$('#kpiGrid').datagrid('loadData',{total:0,rows:[]});
						})
					}
				})
			}
		},{
			text:'导出',
			iconCls:'icon-export',
			handler:function(){
				/*--加载表格--*/
				$HUI.datagrid("#groupSelectGrid",{
					url:$URL,
					queryParams:{
						ClassName:'web.DHCWL.V1.KPI.TaskGroupFunction',
						QueryName:'GetTaskGroupQuery'
					},
					fitColumns:true,
					toolbar:[{
						text:'导出',
						iconCls:'icon-unload-cloud',
						handler:function(e){
							var rows,len,row,groupID,groupIDs="";
								i = 0;
							rows = $("#groupSelectGrid").datagrid("getChecked");
							len = rows.length; 
							if (len>0){
								for ( ; i < len ; i++){
									row = rows[i];
									groupID = row.ID;
									if(groupIDs){
										groupIDs = groupIDs + "," +groupID;
									}else{
										groupIDs = groupID;
									}
								}
							}
							if (groupIDs == ""){
								myMsg("请先选择需要导出的任务组");
								return;
							}
							$.m({    //导出任务组
								ClassName: "web.DHCWL.V1.KPI.TaskGroupFunction",
								MethodName: "ExportTaskGroup",
								groupID:groupIDs
							},function(responseText){
								var browserStr = myBrowser();
								if (browserStr != "IE"){
									var fileName = "D:\\\\" + nowDateTimeUtil()+'outputKpis.grp'
									responseText = trimLeftUtil(responseText);
									var Str = "(function test(x){"+
										"var fso, f, s;" + 
										'fso = new ActiveXObject("Scripting.FileSystemObject");' +
										'f = fso.OpenTextFile("' + fileName + '", 8, true);' + 
										"f.WriteLine('" + responseText + "');" +
										'f.Close();' +
										'return 1;' +
									"}());";
									//console.log(Str);
									CmdShell.notReturn = 1;   //设置无结果调用，不阻塞调用
									var rtn = CmdShell.EvalJs(Str);   //通过中间件运行打印程序 
									myMsg("导出文件：" + fileName + " ,请根据路径查看导出情况");
									return ;
								}else{
									writeFileUtil(nowDateTimeUtil()+'outputKpis.grp',trimLeftUtil(responseText));
									myMsg("导出成功");
								}
								$HUI.dialog("#groupExportSelectDialog").close();
							})
						}
					}]
				})
				
				/*--弹窗显示--*/
				$("#groupExportSelectDialog").show();
				$HUI.dialog("#groupExportSelectDialog",{
					resizable:true,
					modal:true,
					iconCls:'icon-w-export'
				})
			}
		},{
			text:'导入',
			iconCls:'icon-import',
			handler:function(){
				filePathLog = "";
				$HUI.datagrid("#groupKPIListGrid",{
					fitColumns:true,
					toolbar:[{
						text:'读入文件',
						iconCls:'icon-upload-cloud',
						handler:function(e){
							var browserStr = myBrowser();
							if (browserStr != "IE"){
								if ((!filePathLog)||(filePathLog == "")){
									myMsg("请先选择需要读入的文件");
									return;
								}
								var xmlFile = filePathLog; 
								if(xmlFile.indexOf("C:\\fakepath") != -1){
									xmlFile = xmlFile.replace("C:\\fakepath\\","D:\\\\\\\\");
								}
								console.log(xmlFile);
								$('#groupKPIListGrid').datagrid('loadData',{total:0,rows:[]});
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
										inputType:'taskGroup'
									},function(txtData){
										try{
											$('#groupKPIListGrid').datagrid('loadData',{total:0,rows:[]});
											var jsonObj = JSON.parse(txtData);
											//alert(txtData);
											//return;
											var fileName = jsonObj.tips;
											FILE_PATH_GLOBAL = fileName;
											var rootLen = jsonObj.root.length;
											for (var i = 0;i < rootLen;i++){
												$('#groupKPIListGrid').datagrid('insertRow',{
													row: {
														code: jsonObj.root[i].groupCode,
														desc: jsonObj.root[i].groupDesc,
														flag: jsonObj.root[i].flag
													}
												});
											}
											loadInforShow("end");
										}catch(e){
											loadInforShow("end");
										}
										
									})
								}else{
									myMsg(rtnObj.msg,"注意:谷歌浏览器请放到D盘根目录下");
								}
							}else{
								if ((!filePathLog)||(filePathLog == "")){
									myMsg("请先选择需要读入的文件");
									return;
								}
								$('#groupKPIListGrid').datagrid('loadData',{total:0,rows:[]});
								var xmlObj = new XML();
								var readStr="",theStep=1,sc;
								var inputCont=[];
								do{
									readStr=xmlObj.stepTraverXML(filePathLog,256);  
									inputCont.push(readStr);
									theStep++;
								}while(readStr&&readStr!="");
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
									inputType:'taskGroup'
								},function(txtData){
									try{
										$('#groupKPIListGrid').datagrid('loadData',{total:0,rows:[]});
										var jsonObj = JSON.parse(txtData);
										//alert(txtData);
										//return;
										var fileName = jsonObj.tips;
										FILE_PATH_GLOBAL = fileName;
										var rootLen = jsonObj.root.length;
										for (var i = 0;i < rootLen;i++){
											$('#groupKPIListGrid').datagrid('insertRow',{
												row: {
													code: jsonObj.root[i].groupCode,
													desc: jsonObj.root[i].groupDesc,
													flag: jsonObj.root[i].flag
												}
											});
										}
										loadInforShow("end");
									}catch(e){
										loadInforShow("end");
									}
									
								})
							}
							
							
						}
					},{
						text:'导入任务组',
						iconCls:'icon-ok',
						handler:function(e){
							
							if (KPI_INPUT_FLAG != "read"){
								myMsg("请先读取文件后再操作");
								return;
							}
							var rows = $('#groupKPIListGrid').datagrid('getChecked'),grpCodes = "",grpCode = "";
							var len = rows.length,flag="";
							for (var i = 0;i < len;i++){
								grpCode = rows[i].code;
								if (grpCodes == ""){
									grpCodes = grpCode;
								}else{
									grpCodes = grpCodes + "," +grpCode
								}
							}
							if (grpCodes == ""){
								myMsg("请先选择需要导入的任务组后操作");
								return;
							}
							KPI_INPUT_FLAG = "input";
							var realInputGrpList = grpCodes;
							var fileName = FILE_PATH_GLOBAL;
							loadInforShow("start","","正在进行指标导入");
							try{
								$m({
									ClassName:'web.DHCWL.V1.MKPIIO.DefaultInService',
									MethodName:'inputKpiFile',
									fileName:fileName,
									realInputKpiList:realInputGrpList
								},function(e){
									myMsg(e);
									loadInforShow("end");
									$('#groupGrid').datagrid("reload");
									$('#kpiGrid').datagrid('loadData',{total:0,rows:[]});
									$HUI.dialog("#groupInputDialog").close();
								})
							}catch(e){
								loadInforShow("end");
							}
						}
					}]
				})
				clearInputDialog();
				$("#groupInputDialog").show();
				$HUI.dialog('#groupInputDialog',{
					height:450,
					iconCls:'icon-w-import',
					resizable:true,
					modal:true,
					onClose:function(e){
						KPI_INPUT_FLAG = "";
					}
				})
			}
		}]
	})
	var kpiObj = $HUI.datagrid("#kpiGrid",{
		url:$URL,
		queryParams:{
			ClassName:'web.DHCWL.V1.KPI.TaskGroupFunction',
			QueryName:'GetGroupDetailQuery'
		},
		fitColumns:true,
		pagination:true,
		pageSize:15,
		pageList:[10,15,20],
		toolbar:'#groupDetailToobar'
	})
	
	
	/*--清空导入dialog内容--*/
	function clearInputDialog(){
		$('#groupInputFilebox').filebox('clear');
		$('#groupKPIListGrid').datagrid('loadData',{total:0,rows:[]});
	}

	/*--任务组新增与修改--*/
	function groupUpdate(updateType){
		$("#groupAddCode").attr("disabled",false);
		$("#groupAddForm").form('reset');
		var groupID = "";
		var title = "任务组新增";
		var groupIcon = "icon-w-add";
		if (updateType=='edit'){
			var row = $("#groupGrid").datagrid("getSelected");
			if (row){
				groupID = row.ID,            //将选中的任务组信息填充到表单
				groupCode = row.groupCode;
				groupDesc = row.groupDesc;
				groupCreator = row.creator;
				$('#groupAddCode').val(groupCode);
				$('#groupAddDesc').val(groupDesc);
				$("#groupAddCreator").val(groupCreator);
				$("#groupAddForm").form('validate');    //验证表单信息
				$("#groupAddCode").attr("disabled",true);
				title = "任务组修改";
				groupIcon = "icon-w-edit";
			}else{
				myMsg('请先选择需要修改的任务组');
				return;
			}
		}
		
		$("#groupAddDialog").show();
		$HUI.dialog("#groupAddDialog",{
			title:title,
			iconCls:groupIcon,
			resizable:true,
			modal:true,
			buttons:[{
				text:'保存',
				handler:function(e){
					var flag = $("#groupAddForm").form('validate');
					if (!flag){
						myMsg("请按照提示填写内容");
						return;
					}
					var code,desc,creator;
					code = $("#groupAddCode").val();
					desc = $("#groupAddDesc").val();
					creator = $("#groupAddCreator").val();
					$m({
						ClassName:'web.DHCWL.V1.KPI.TaskGroupFunction',
						MethodName:'UpdateTaskGroup',
						id:groupID,
						code:code,
						desc:desc,
						user:creator,
						type:updateType
					},function(e){
						myMsg(e);
						$HUI.dialog("#groupAddDialog").close();
						kpiGroupObj.reload();
						$('#kpiGrid').datagrid('loadData',{total:0,rows:[]});
					})
					
				}
			},{
				text:'关闭',
				handler:function(e){
					$HUI.dialog("#groupAddDialog").close();
				}
			}]
		})
	}
	
	
	/*--任务明细新增--*/
	$("#groupKPIListAdd").click(function(e){
		if (addKey == 0){
			var passWord = getPassWord();
			$.messager.prompt("提示", "输入密码:", function (r) {
				if (r) {
					
					if (r == passWord){
						addTaskDetail();
						addKey = 1;
					}else{
						myMsg("密码输入有误呦~");
						return;
					}
				} else {
					//alert("点击了【取消】或输入为空");
					if (r != undefined){
						$.messager.popover({msg: '请输入有效密码！',type:'info',timeout: 2000,showType: 'show'});
					}
				}
			});
		}else{
			addTaskDetail();
		}
		//var test = selectedKPIIdList.join();
	})
	
	/*--任务明细删除--*/
	$("#groupKPIListDelete").click(function(e){
		if(deleteKey == 0){
			var passWord = getPassWord() + 10;
			$.messager.prompt("提示", "为保障系统安全,请先输入密码验证:", function (r) {
				if (r) {
					
					if (r == passWord){
						//deleteTaskDetail();
						$.messager.popover({msg: '验证成功,请再次操作~',type:'success',timeout: 1000});
						deleteKey = 1;
					}else{
						myMsg("密码输入有误~");
						return;
					}
				} else {
					//alert("点击了【取消】或输入为空");
					if (r != undefined){
						$.messager.popover({msg: '请输入有效密码！',type:'info',timeout: 2000,showType: 'show'});
					}
				}
			});
		}else{
			deleteTaskDetail();
		}
	})
	
	function addTaskDetail(){
		selectedKPIIdList = [];
		$('#kpiSearchKPIInfor').searchbox('setValue', '');
		var row = $("#groupGrid").datagrid("getSelected");
		if (!row){
			myMsg('请先选择一条任务组');
			return;
		}
		$HUI.datagrid("#kpiSelectGrid",{
			url:$URL,
			queryParams:{
				ClassName:"web.DHCWL.V1.KPI.KPIFunction",  //调用方法或query的路径
				QueryName:"GetKPIListQuery",  //调用query名
				isGroup:'1'
			},
			pagination:true,
			striped:true,
			pageSize:15,
			pageList:[10,15,20],
			toolbar:'#kpiRuleSearchAllBox',
			onLoadSuccess:function(data){
				//$(".datagrid-header-check").html("");
				var rows = data.rows;
				for (var i = 0;i < rows.length;i++){
					if ($.inArray(rows[i].ID,selectedKPIIdList) > -1 ){
						$("#kpiSelectGrid").datagrid("selectRow",i);
					}
				}
			},
			onSelect:function(rowIndex,rowData){  //当选中一条记录时，将选中的记录的id和code记录到数组中
				selectedKPIIdList.unshift(rowData.ID);
			},  
			onUnselect:function(rowIndex,rowData){ //当取消选中一条记录时，将数组中的记录去掉
				for (x in selectedKPIIdList) {
					if (selectedKPIIdList[x] == rowData.ID) {
						selectedKPIIdList.splice(x,1);
					}
				}
			},
			onSelectAll:function(rows) {  //当选中当前页所有的指标时，记录所有指标的ID和code
				for (var i = 0;i < rows.length;i++) {
					if ($.inArray(rows[i].ID,selectedKPIIdList) == -1){
						selectedKPIIdList.unshift(rows[i].ID);
					}
				}
			},
			onUnselectAll:function(rows) { //当取消选中当前所有指标的时候，取消数组中的ID和code
				for (var i = 0;i < rows.length;i++) {
					for (x in selectedKPIIdList) {
						if (rows[i].ID == selectedKPIIdList[x]) {
							selectedKPIIdList.splice(x,1);
						}
					}
				}
			},
		})
		$("#kpiSelectDialog").show();
		$HUI.dialog("#kpiSelectDialog",{
			height:grpBodyHeight-20,
			iconCls:'icon-w-add',
			resizable:true,
			modal:true,
			onClose:function(){
				$('#kpiRuleShowImage').webuiPopover('hide');
			}
		})
	}
	
	function deleteTaskDetail(){
		$.messager.confirm("提示", "删除后将不能恢复,确认删除么？", function (r) {
			if (r){
				var groupRow,groupID,kpiIDList,kpiRows,kpiLen;
				groupRow = $("#groupGrid").datagrid("getSelected");
				if (groupRow){
					kpiRows = $("#kpiGrid").datagrid("getChecked");
					kpiLen = kpiRows.length;
					if (kpiLen < 1){
						myMsg("请先选择需要删除的任务组明细");
						return;
					}
					for (var i = 0;i < kpiLen;i++){
						kpiID = kpiRows[i].ID;
						if (kpiIDList){
							kpiIDList = kpiIDList + "," + kpiID;
						}else{
							kpiIDList = kpiID;
						}
					}
					groupID = groupRow.ID;
					$m({
						ClassName:'web.DHCWL.V1.KPI.TaskGroupFunction',
						MethodName:'DeleteTaskDetail',
						kpis:kpiIDList,
						groupID:groupID
					},function(e){
						myMsg(e);
						$("#kpiGrid").datagrid("reload");
					})
				}else{
					myMsg("获取任务组失败");
				}
			}
		})
	
	
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
	
	/*--获取filebox文件路径--*/
	function getFieldValue(formID,fieldName) {
		return $("div#"+formID+" [name='"+fieldName+"']").val();
	};

	//$("#groupInputFilebox").filebox({
	/*$HUI.filebox("#groupInputFilebox",{
		onChange:function(newVal,oldVal){
			if (newVal=="") return;
			if (newVal==oldVal) return;
			filePathLog=getFieldValue("importRegion","groupInputFilebox");
		}
	});*/
	//$("#groupInputFilebox").change(function(){
	/*--任务明细查询--*/
	//根据查询条件检查
	$('#kpiSearchKPIInfor').searchbox({
		searcher:function(value,name){ 
			$("#kpiSelectGrid").datagrid('load',{ClassName:'web.DHCWL.V1.KPI.KPIFunction',QueryName:'GetKPIListQuery',filterValue:value,isGroup:'1'});
			//重新加载指标信息
		}
	});
	
	/*--已维护指标检索--*/
	$('#grpKPISearch').searchbox({
		searcher:function(value,name){
			var rowData = $("#groupGrid").datagrid("getSelected");
			if (!rowData){
				return;
			}
			var groupID = rowData.ID;
			kpiObj.load({ClassName:'web.DHCWL.V1.KPI.TaskGroupFunction',QueryName:'GetGroupDetailQuery',groupID:groupID,searchValue:value});
		}
	})
	
	
	/*--选择的指标保存--*/
	$("#saveSelectKPIListButton").click(function(e){
		var groupRow,groupID,kpiIDList;
		groupRow = $("#groupGrid").datagrid("getSelected");
		if (groupRow){
			groupID = groupRow.ID;
			kpiIDList = selectedKPIIdList.join();
			$m({
				ClassName:'web.DHCWL.V1.KPI.TaskGroupFunction',
				MethodName:'SaveTaskDetail',
				kpis:kpiIDList,
				groupID:groupID
			},function(e){
				myMsg(e);
				$HUI.dialog("#kpiSelectDialog").close();
				$("#kpiGrid").datagrid("reload");
			})
		}else{
			myMsg("获取任务组失败");
		}
	})
	
	$("#kpiRuleShowImage").click(function(e){
		$('#kpiSearchKPIInfor').searchbox('setValue', '');
	})
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
			placement:'bottom-left',
			closeable:false,
			padding:false,
			type:'iframe',
			url:'dhcwlredirect.csp?url=dhcwl/v1/kpi/kpi/configsimplekpisearch.csp'
		}
		$('#kpiRuleShowImage').webuiPopover('destroy').webuiPopover($.extend({},settings,kpiRuleSettings));
	}
	initPopover();
