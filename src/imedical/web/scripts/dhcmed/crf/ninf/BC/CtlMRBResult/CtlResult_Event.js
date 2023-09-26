var CHR_13 = String.fromCharCode(13) + String.fromCharCode(10);

function InitWinControlEvent(obj) {
	obj.LoadEvent = function(args) {
		obj.TreeControlsTreeLoader.load(obj.TreeControls.getRootNode());
		obj.TreeControls.getRootNode().expanded = true;
		obj.TreeControls.on("checkchange", obj.TreeControls_CheckChange, obj);
		
		obj.radioDateType.setValue("2");
		obj.btnQuery.on("click", obj.btnQuery_Click, obj);
		obj.btnExport.on("click", obj.btnExport_Click, obj);
		obj.btnControl.on("click", obj.btnControl_Click, obj);
		obj.cboLoc.on("expand", obj.cboLoc_OnExpand, obj);
		obj.cboWard.on("expand", obj.cboWard_OnExpand, obj);
		obj.RowExpander.on("expand",obj.RowExpander_expand,obj);
		
		obj.cboLoc.on("collapse", 
            function(){
                obj.cboWard.clearValue();
            },obj
        );
        obj.cboWard.on("collapse", 
            function(){
                obj.cboLoc.clearValue();
            },obj
        );
		
		var curDate = new Date();
		var preDate = new Date(curDate.getTime() - 24*60*60*1000);
		var timeYesterday = preDate.format("Y") +"-" +preDate.format("m") + "-"+(preDate.format("d"));
		Common_SetValue('dfDateFrom',timeYesterday);
		
		obj.CtlPaadmGrid.on("rowcontextmenu", obj.CtlPaadmGrid_rowcontextmenu, obj);
		Ext.getCmp("mnuBaseInfo").on("click", obj.mnuBaseInfo_click, obj);
	};
	
	obj.MRBReportHeader = function(Paadm,ResultID){
		var objDisplayWin = new InitMRBReport(Paadm,ResultID);
		objDisplayWin.WinMRBReport.show();
	}
	
	obj.RowExpander_expand = function(){
		var objRec = arguments[1];
		var EpisodeID = objRec.get("Paadm");
		var CtrlDtl = objRec.get("CtrlDtl");
		if ((!EpisodeID)||(!CtrlDtl)) return;
		
		obj.CurrentEpisodeID = EpisodeID;
		obj.CurrentCtrlDtl = CtrlDtl;
		
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.NINFService.BC.CtlResultSrv',
				QueryName : 'QryMRBDtlByAdm',
				Arg1 : CtrlDtl,
				ArgCnt : 1
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var arryData = new Array();
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					arryData[arryData.length] = objItem;
				}
				obj.RowTemplate.overwrite("divCtrlDtl-" + EpisodeID, arryData);
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("divCtrlDtl-" + EpisodeID);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	obj.CtlPaadmGrid_rowcontextmenu = function(grid,rowIndex,e) {
		grid.getSelectionModel().clearSelections();
		grid.getSelectionModel().selectRow(rowIndex,true);
		//Ext.getCmp("mnuBaseInfo").disable();
		//Ext.getCmp("mnuBaseInfo").enable();
        obj.mnuMenu.showAt(e.getXY());
        e.stopEvent();
	};
	
	obj.mnuBaseInfo_click = function() {
		if (obj.CtlPaadmGrid.getSelectionModel().getCount() == 0) {
			return;
		}
		var objRec = obj.CtlPaadmGrid.getSelectionModel().getSelected();
		var objDisplayWin = new InitPatientDtl(objRec.get("Paadm"), SubjectCode);
		objDisplayWin.WinPatientDtl.show();
	};
	
	obj.cboLoc_OnExpand = function() {
		obj.cboLoc.clearValue();
		obj.cboLoc.getStore().load({});
	};
	
	obj.cboWard_OnExpand = function() {
		obj.cboWard.clearValue();
		obj.cboWard.getStore().load({});
	};
	
	obj.btnQuery_Click = function() {
		obj.CtlPaadmGridStore.removeAll();
		var DateType = obj.radioDateType1.getGroupValue();
		var DateFrom = obj.dfDateFrom.getRawValue();
		var DateTo = obj.dfDateTo.getRawValue();
		var CtrlItems = getChildString(obj.TreeControls.getRootNode());
		var LocID = obj.cboLoc.getValue();
		var WardID = obj.cboWard.getValue();
		var HospitalID = obj.cboSSHosp.getValue();
		
		var inputStr = "", inputErr = "";
		if ((obj.cboLoc.getValue() !== "") && (obj.cboLoc.getRawValue() !== "")) {
			obj.cboLoc.setValue("");
			obj.cboLoc.setRawValue("");
		} else {
			LocID = '';
		}
		if ((obj.cboWard.getValue() !== "") && (obj.cboWard.getRawValue() !== "")) {
			obj.cboWard.setValue("");
			obj.cboWard.setRawValue("");
		} else {
			WardID = '';
		}
		if ((DateFrom == '')||(DateTo == '')) {
			inputErr = inputErr + "开始日期、结束日期为空!" + CHR_13;
		} else {
			var objDateFrom = Date.parseDate(DateFrom, "Y-m-d");
			var objDateTo = Date.parseDate(DateTo, "Y-m-d");
			if ((objDateFrom) && (objDateTo)) {
				var tmpDaysTo = objDateTo.getTime() / 1000 / 3600 / 24;
				var tmpDaysFrom = objDateFrom.getTime() / 1000 / 3600 / 24;
				var tmpDays = tmpDaysTo - tmpDaysFrom;
				if (tmpDays > 31) {
					inputErr = inputErr + "日期范围不允许超过一个月(31天)!" + CHR_13;
				}
				if (tmpDays < 0) {
					inputErr = inputErr + "日期选择错误!" + CHR_13;
					obj.dfDateFrom.setValue("");
				}
			} else {
				inputErr = inputErr + "日期格式错误!" + CHR_13;
			}
		}
		if (inputErr) {
			inputErr = inputErr + "请认真选择查询条件!" + CHR_13;
			ExtTool.alert("确认", inputErr);
			return;
		}
		
		obj.QueryArgs.DateType = DateType;
		obj.QueryArgs.DateFrom = DateFrom;
		obj.QueryArgs.DateTo = DateTo;
		obj.QueryArgs.CtrlItems = CtrlItems;
		obj.QueryArgs.LocID = LocID;
		obj.QueryArgs.WardID = WardID;
		obj.QueryArgs.HospitalID = HospitalID;
		
		obj.CtlPaadmGridStore.load({params : {start : 0,limit : 100}});
	};
	
	obj.btnExport_Click = function() {
		var objDate = new Date();
		var strFileName = objDate.getDate()
		var objExcelTool = Ext.dhcc.DateToExcelTool;
		objExcelTool.ExprotGrid(obj.CtlPaadmGrid, strFileName);
	};
	
	obj.btnControl_Click = function() {
		obj.btnControl.setDiabled = true;
		if (SubjectCode == "") {
			ExtTool.alert("提示", '监控主题代码不允许为空!');
			return;
		}
		if (MACAddr == "") {
			ExtTool.alert("提示", 'MAC地址不允许为空!');
			return;
		}
		
		//执行监控主程序，显示进度条
		obj.progressBar=Ext.Msg.show({
			//title : "进度条",
			msg:'<font size="5"><b>监控主题执行进度：</b></font>',
			progress:true,
			width:400,
			height:40
		});
		
		//定义监控任务
		obj.ControlFlag = 0;
		var task = {
			run: function(){
				if (obj.ControlFlag > 0) {
					//结束监控任务
					Ext.TaskMgr.stop(task);
					obj.progressBar.hide();
					obj.btnControl.setDiabled = false;
				} else {
					Ext.Ajax.request({
						url : 'dhcmed.cc.sys.ctrlrequest.csp',
						method : "POST",
						timeout: 100000000,
						params  : {
							ClassName : 'DHCMed.CCService.AutoProcess.CoreVMNew',
							MethodName : 'Process03',
							Arg1 : SubjectCode,   //监控主题代码
							Arg2 : MACAddr,       //网卡MAC作为唯一进程号
							ArgCnt : 2
						},
						success : function(response) {
							var tmpText = response.responseText;  //输出内容最前端多了一个字符
							if (tmpText.indexOf('OK') > -1) {
								obj.ControlFlag = 1;
							} else {
								var tmpList = tmpText.split('^');
								var curnum = tmpList[0]*1;
								var bartext = tmpList[1];
								if (curnum < 0) {
									obj.ControlFlag = 1;
								} else {
									obj.progressBar.updateProgress(curnum,bartext);
								}
							}
						},
						failure: function(response, opts) {
							obj.ControlFlag = 2;
						}
					});
				}
			},
			interval: 1000
		}
		//开始执行监控任务
		Ext.TaskMgr.start(task);
	}
	
	obj.TreeControls_CheckChange = function() {
		var node = arguments[0];
		var val = arguments[1];
		
		// obj.SelectNode 非常重要,避免checkchange引起的死循环
		if (obj.SelectNode) return;
		
		obj.SelectNode = node;
		setChildNode(node, val);
		setParentNode(node, val);
		obj.SelectNode = null;
	};
	
	setChildNode = function(argNode, argVal) {
		// alert("setChildNode="+argNode.text+"//"+argVal);
		var childnodes = argNode.childNodes;
		for (var i = 0; i < childnodes.length; i++) {
			var childnode = childnodes[i];
			childnode.attributes.checked = argVal;
			childnode.getUI().toggleCheck(argVal);
			if (childnode.childNodes.length > 0) {
				setChildNode(childnode, argVal);
			}
		}
	};

	setParentNode = function(argNode, argVal) {
		// alert("setParentNode="+argNode.text+"//"+argVal);
		var parentnode = argNode.parentNode;
		if (!parentnode) return;
		if (parentnode.id=="root") return;
		if (argVal) {
			parentnode.attributes.checked = true;
			parentnode.getUI().toggleCheck(true);
			setParentNode(parentnode, true);
		} else {
			var childnodes = parentnode.childNodes;
			var isChecked = false;
			for (var i = 0; i < childnodes.length; i++) {
				var childnode = childnodes[i];
				if (childnode.attributes.checked) {
					isChecked = true;
				}
			}
			if (!isChecked) {
				parentnode.attributes.checked = false;
				parentnode.getUI().toggleCheck(false);
				setParentNode(parentnode, false);
			}
		}
	};

	getChildString = function(node) {
		var str = "";
		var childnodes = node.childNodes;
		for (var i = 0; i < childnodes.length; i++) {
			var childnode = childnodes[i];
			var nodeList = childnode.id.split("-");
			if (nodeList.length > 2) {
				if (nodeList[1] == "I") {
					if (childnode.attributes.checked) {
						str = str + nodeList[0] + "/";
					}
				}
			}
			str += getChildString(childnode);
		}
		return str;
	};
	
	obj.WindowRefresh_Handler = function()
	{
		var EpisodeID = obj.CurrentEpisodeID;
		var CtrlDtl = obj.CurrentCtrlDtl;
		if ((!EpisodeID)||(!CtrlDtl)) return;
		
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.NINFService.BC.CtlResultSrv',
				QueryName : 'QryMRBDtlByAdm',
				Arg1 : CtrlDtl,
				ArgCnt : 1
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				var arryData = new Array();
				var objItem = null;
				for(var i = 0; i < objData.total; i ++)
				{
					objItem = objData.record[i];
					arryData[arryData.length] = objItem;
				}
				obj.RowTemplate.overwrite("divCtrlDtl-" + EpisodeID, arryData);
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("divCtrlDtl-" + EpisodeID);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
}