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
               // obj.cboWard.clearValue();
            },obj
        );
        obj.cboWard.on("collapse", 
            function(){
               // obj.cboLoc.clearValue();
            },obj
        );
		
		/*var curDate = new Date();
		var preDate = new Date(curDate.getTime() - 24*60*60*1000);
		var timeYesterday = preDate.format("Y") +"-" +preDate.format("m") + "-"+(preDate.format("d"));
		Common_SetValue('dfDateFrom',timeYesterday);*/
		obj.dfDateFrom.setValue(new Date().add(Date.DAY, -1));
		
		obj.CtlPaadmGrid.on("contextmenu", obj.CtlPaadmGrid_contextmenu, obj);
		Ext.getCmp("mnuBaseInfo").on("click", obj.mnuBaseInfo_click, obj);
	};
	
	obj.RowExpander_expand = function(){
		var objRec = arguments[1];
		var EpisodeID = objRec.get("Paadm");
		var CtrlDtl = objRec.get("CtrlDtl");
		if ((!EpisodeID)||(!CtrlDtl)) return;
		
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.NINFService.BC.CtlResultSrv',
				QueryName : 'QryCtrlDtlByAdm',
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
				//fix bug 211314 ����һ���������������ͬһ�ξ��������¼ֻ�ܴ�һ�ε����
				obj.RowTemplate.overwrite("divCtrlDtl-" + EpisodeID + "-" +CtrlDtl, arryData);
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("divCtrlDtl-" + EpisodeID + "-" +CtrlDtl);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	obj.CtlPaadmGrid_contextmenu = function(objEvent) {
		if (obj.CtlPaadmGrid.getSelectionModel().getCount() == 0) {
			Ext.getCmp("mnuBaseInfo").disable();
		} else {
			Ext.getCmp("mnuBaseInfo").enable();
		}
		obj.mnuMenu.showAt(objEvent.getXY());
		objEvent.stopEvent();
	};
	
	obj.mnuBaseInfo_click = function() {
		if (obj.CtlPaadmGrid.getSelectionModel().getCount() == 0) {
			return;
		}
		var objRec = obj.CtlPaadmGrid.getSelectionModel().getSelected();
		//var objDisplayWin = new DisplayPatientWin(objRec.get("Paadm"));
		//objDisplayWin.objDisplayWin.show();
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
		//Add By LiYang 2014-11-03 FixBug:3861 ҽԺ��Ⱦ����-ȫԺ�ۺ��Լ��-��Ⱦ�ۺϼ��-��Ⱦ�ۺϼ�⣬���ա����ҡ��򡾲�������ѯ�󣬡����ҡ��򡾲������Զ����
		/*
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
		*/
		if ((DateFrom == '')||(DateTo == '')) {
			inputErr = inputErr + "��ʼ���ڡ���������Ϊ��!" + CHR_13;
		} else {
			/*var objDateFrom = Date.parseDate(DateFrom, "Y-m-d");
			var objDateTo = Date.parseDate(DateTo, "Y-m-d");
			if ((objDateFrom) && (objDateTo)) {
				var tmpDaysTo = objDateTo.getTime() / 1000 / 3600 / 24;
				var tmpDaysFrom = objDateFrom.getTime() / 1000 / 3600 / 24;
				var tmpDays = tmpDaysTo - tmpDaysFrom;
				if (tmpDays > 31) {
					inputErr = inputErr + "���ڷ�Χ��������һ����(31��)!" + CHR_13;
				}
				if (tmpDays < 0) {
					inputErr = inputErr + "����ѡ�����!" + CHR_13;
					obj.dfDateFrom.setValue("");
				}
			} else {
				inputErr = inputErr + "���ڸ�ʽ����!" + CHR_13;
			}*/
			var tmpDays = Common_ComputeDays("dfDateFrom","dfDateTo");
			if (tmpDays=="") {
				inputErr = inputErr + "���ڸ�ʽ����!" + CHR_13;
			}else{
				if (tmpDays < 0) {
					inputErr = inputErr + "��ʼ���ڲ��ܴ��ڽ�������!" + CHR_13;
					obj.dfDateFrom.setValue("");
				}
				if (tmpDays > 31) {
					inputErr = inputErr + "���ڷ�Χ��������һ����(31��)!" + CHR_13;
				}
			}	
		}
		if (inputErr) {
			inputErr = inputErr + "������ѡ���ѯ����!" + CHR_13;
			ExtTool.alert("ȷ��", inputErr);
			return;
		}
		
		obj.QueryArgs.DateType = DateType;
		obj.QueryArgs.DateFrom = DateFrom;
		obj.QueryArgs.DateTo = DateTo;
		obj.QueryArgs.CtrlItems = CtrlItems;
		obj.QueryArgs.LocID = LocID;
		obj.QueryArgs.WardID = WardID;
		obj.QueryArgs.HospID = HospitalID;
		
		obj.CtlPaadmGridStore.load({params : {start : 0,limit : 100}});
	};
	
	obj.btnExport_Click = function() {
		if (obj.CtlPaadmGrid.getStore().getCount() > 0)
		{
			var objDate = new Date();
			//var strFileName = objDate.getDate()
			//var strFileName = "��Ⱦ�ۺϼ�ⱨ��"; //Modified By LiYang 2014-11-03 FixBug:3857 ҽԺ��Ⱦ����-ȫԺ�ۺ��Լ��-��Ⱦ�ۺϼ��-��Ⱦ�ۺϼ��-������Ĭ���ļ���Ϊ��29.xls��
			//fix bug 206533 �����пڼ��/ICU���ܼ���ѯ��������ļ��������ֿ�
			var objSubConfig = ExtTool.RunServerMethod("DHCMed.CC.SubjectConfig","GetObjByCode",SubjectCode);
			var strFileName = objSubConfig.Description+"����";
		//var objExcelTool = Ext.dhcc.DateToExcelTool;
		var objExcelTool = Ext.dhcc.DataToExcelTool; //Modified By LiYang 2014-07-04 FixBug:1949 ҽԺ��Ⱦ����-ҽԺ��Ⱦ�����ʵ���-���Ե������ɼ�¼-���������Ӧ�黼�߾����¼������������Ӧ���������ɵ����¼
			objExcelTool.ExprotGrid(obj.CtlPaadmGrid,strFileName);
		} else {
			ExtTool.alert("��ʾ","����б�����Ϊ��!");
		}
	};

		
	obj.btnControl_Click = function() {
		obj.btnControl.setDiabled = true;
		if (SubjectCode == "") {
			ExtTool.alert("��ʾ", '���������벻����Ϊ��!');
			return;
		}
		if (MACAddr == "") {
			ExtTool.alert("��ʾ", 'MAC��ַ������Ϊ��!');
			return;
		}
		
		//ִ�м����������ʾ������
		obj.progressBar=Ext.Msg.show({
			//title : "������",
			msg:'<font size="5"><b>�������ִ�н��ȣ�</b></font>',
			progress:true,
			width:400,
			height:40
		});
		
		//����������
		obj.ControlFlag = 0;
		var task = {
			run: function(){
				if (obj.ControlFlag > 0) {
					//�����������
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
							Arg1 : SubjectCode,   //����������
							Arg2 : MACAddr,       //����MAC��ΪΨһ���̺�
							ArgCnt : 2
						},
						success : function(response) {
							var tmpText = response.responseText;  //���������ǰ�˶���һ���ַ�
							if (tmpText.indexOf('OK') > -1) {
								obj.ControlFlag = 1;
							} else {
								var tmpArry = tmpText.split('\r\n'); //add by mxp 20170630 ����ֵ�а�����w�������,��\r\n�ָ�
								tmpText = tmpArry[tmpArry.length-1];
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
		//��ʼִ�м������
		Ext.TaskMgr.start(task);
	}
	
	obj.TreeControls_CheckChange = function() {
		var node = arguments[0];
		var val = arguments[1];
		
		// obj.SelectNode �ǳ���Ҫ,����checkchange�������ѭ��
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

}






//��д������Excel����
function BuildBody(grid,row,col,isChecked)
{
    var cm = grid.getColumnModel();
    var ds = grid.getStore();
	var rowIndex=1;
    var cfg = null;
	//modify by liyi 2016-05-12 �޸�Ժ���ۺϼ��ҳ�浼����ť����޷�Ӧbug
	//var objBuffer = document.createElement("<div style='visibility:hidden'/>");
    var objBuffer = document.createElement("div");
    objBuffer.style.visibility="hidden";
    document.body.appendChild(objBuffer);
    ds.each(function(rec) {
    	if (isChecked){  //ͨ��ѡ���ж��Ƿ񵼳�
	    	if (rec.get('checked')){
		        for (var i = 0;i < cm.config.length;++i) {
		            cfg = cm.config[i];
		            if (cfg.id == 'checker') {
		                this.ExcelApp.WriteData(row, col + i, ' ');
		            }else if (cfg.id=='numberer'){
		            	//var IndNum = ReplaceText(rec.id, "ext-record-", '');
		        		this.ExcelApp.WriteData(row, col + i, rowIndex);
		            }else if (cfg.id == "expander"){ //Add By LiYang 2011-12-08
		            	var tmpData =  cfg.tpl.apply(rec.data);
		            	objBuffer.innerHTML = tmpData;
		            	this.ExcelApp.WriteData(row, col + i, objBuffer.innerText);
		            }else{
		                var val = rec.get(cfg.dataIndex);
		                this.ExcelApp.WriteData(row, col + i, val);
		            }
		        }
		        rowIndex++;
		        row++;
	    	}
    	}else{
    		for (var i = 0;i < cm.config.length;++i) {
	            cfg = cm.config[i];
	            if (cfg.id == 'checker') {
	                this.ExcelApp.WriteData(row, col + i, ' ');
	            }else if (cfg.id=='numberer'){
	            	//var IndNum = ReplaceText(rec.id, "ext-record-", '');
	        			this.ExcelApp.WriteData(row, col + i, rowIndex);
		        }else if (cfg.id == "expander"){ //Add By LiYang 2011-12-08
					var objRec = rec;
					var objRequest = new ActiveXObject("MSXML2.XMLHTTP");
					var EpisodeID = objRec.get("Paadm");
					var CtrlDtl = objRec.get("CtrlDtl");
					objRequest.open("GET", ExtToolSetting.RunQueryPageURL + "?ClassName=DHCMed.NINFService.BC.CtlResultSrv&QueryName=QryCtrlDtlByAdm&Arg1=" +  CtrlDtl + "&ArgCnt=1"
						, false);
					objRequest.send();
					var objData = Ext.decode(objRequest.responseText);
					var arryData = new Array();
					var objItem = null;
					var strTmp = "";
					for(var j = 0; j < objData.total; j ++)
					{
						objItem = objData.record[j];
						if(strTmp != "")
							strTmp += "\r\n";
						strTmp += objItem.ItemCatDesc + "  " + objItem.DataTime + "  " + objItem.ItemDesc + "  " + objItem.DataValue + "  " + objItem.ActLoc + "  " + objItem.ActUser;
					}
		            this.ExcelApp.WriteData(row, col + i, strTmp);      			
	            }else{
	                var val = rec.get(cfg.dataIndex);
	                //Modified By LiYang 2013-03-13 FixBug:54 ��Ⱦ������-��Ⱦ�������ѯ-���鵼���ļ�����ʾ��ѡ����
	                if(!Ext.isBoolean(val))
	                	this.ExcelApp.WriteData(row, col + i, val);
	                else
	                	this.ExcelApp.WriteData(row, col + i, (val ? "��" : ""));
	            }
	        }
	        rowIndex++;
	        row++;
    	}
    },this);
}