function InitWinControlEvent(obj) {
	obj.LoadEvent = function(args) {
		obj.TreeControlsTreeLoader.load(obj.TreeControls.getRootNode());
		obj.TreeControls.getRootNode().expanded = true;
		obj.TreeControls.on("checkchange", obj.TreeControls_CheckChange, obj);
		
		obj.btnQuery.on("click", obj.btnQuery_Click, obj);
		obj.cboLoc.on("expand", obj.cboLoc_OnExpand, obj);
		obj.cboWard.on("expand", obj.cboWard_OnExpand, obj);
		obj.btnControl.on("click", obj.btnControl_Click, obj);
		obj.btnExport.on("click", obj.btnExport_Click, obj);
		obj.RowExpander.on("expand",obj.RowExpander_expand,obj);
		
		obj.cboLoc.on("collapse", 
            function(){
                //obj.cboWard.clearValue();
            },obj
        );
        obj.cboWard.on("collapse", 
            function(){
               // obj.cboLoc.clearValue();
            },obj
        );
		 if (tDHCMedMenuOper['admin'] == '1') {
			obj.cboLoc.setDisabled(false);
			obj.cboWard.setDisabled(false);
				
		} else {
			var LogLocID = session['LOGON.CTLOCID'];
			var objCtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc")
			var objLoc = objCtlocSrv.GetObjById(LogLocID);
			if (objLoc) {
				obj.cboLoc.setValue(objLoc.Rowid);
				obj.cboLoc.setRawValue(objLoc.Descs);
			}
			
			obj.cboLoc.setDisabled(true);
			obj.cboWard.setDisabled(true);
		}
		
		if (IsSecret!=1) {     //�����ܾ����ء������ܼ����͡����˼�������
			var cm = obj.gridReport.getColumnModel();
    			var cfg = null;
    			for(var i=0;i<cm.config.length;++i)
   	 		{
	   	 		cfg = cm.config[i];
	   	 		if ((cfg.id=="Secret1")||(cfg.id=="Secret2")) {
					cm.setHidden(i,true);
	   	 		}
			}
		}	
		/*var curDate = new Date();
		var preDate = new Date(curDate.getTime() - 24*60*60*1000);
		var timeYesterday = preDate.format("Y") +"-" +preDate.format("m") + "-"+(preDate.format("d"));
		Common_SetValue('DateFrom',timeYesterday);*/
		obj.DateFrom.setValue(new Date().add(Date.DAY, -1));
		
		//�Ҽ�����¼�
		obj.CtlPaadmGrid.on("rowcontextmenu", obj.CtlPaadmGrid_rowcontextmenu, obj);
		obj.CtlPaadmGrid.on("rowmousedown", obj.CtlPaadmGrid_rowmousedown, obj);
		window.objScreenEventObj = obj;
		
		window.refreshCtlPaadmGridStoreFn = function() {//ˢ�±��Ļص����� 
		 	//obj.CtlPaadmGridStore.load({}); 
		 	//update by pylian 201150526  ����102712 
		 	//obj.CtlPaadmGridStore.load({params : {start : 0,limit : 15}}); 
			Common_LoadCurrPage("CtlPaadmGrid");
	  	};
	};
	
	obj.cboLoc_OnExpand = function() {
		obj.cboLoc.clearValue();
		obj.cboLoc.getStore().load({});
	};
	
	obj.cboWard_OnExpand = function() {
		obj.cboWard.clearValue();
		obj.cboWard.getStore().load({});
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
	
	obj.RowExpander_expand = function(){
		var objRec = arguments[1];
		var EpisodeID = objRec.get("Paadm");
		var CtrlDtl = objRec.get("CtrlDtl");
		if ((!EpisodeID)||(!CtrlDtl)) return;
		
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.SPEService.PatientsQry',
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
                //fix bug 148479 ����һ�����������ͬһ���˶�����¼ֻ�ܴ�һ�ε����
				obj.RowTemplate.overwrite("divCtrlDtl-" + EpisodeID+"-"+CtrlDtl, arryData);
			},
			failure: function(response, opts) {
				var objTargetElement = document.getElementById("divCtrlDtl-" + EpisodeID+"-"+CtrlDtl);
				if (objTargetElement) {
					objTargetElement.innerHTML = response.responseText;
				}
			}
		});
	}
	
	obj.objContextMenu = new Ext.menu.Menu({
		items:[
			{
				text:'<b>������⻼��</b>',
				icon:'../scripts/dhcmed/img/edit.gif',
				handler:function(){
					var objSel = ExtTool.GetGridSelectedData(obj.CtlPaadmGrid);
					if(objSel == null) return;
					var EpisodeID = objSel.get('Paadm');
					
					var objInput = new Object();
					objInput.SpeID     = '';
					objInput.EpisodeID = EpisodeID;
					objInput.OperTpCode = (tDHCMedMenuOper['admin'] == '1'?'2':'1');
					
					var objMarkWin = new SPM_InitSpeMarkWin(objInput);
					objMarkWin.SPM_WinSpeMark.show();
				}
			}
			,new Ext.menu.Separator({})
			,{
				text:'<b>�鿴������Ϣ</b>',
				icon:'../scripts/dhcmed/img/menudic.gif',
				handler:function(){
					var objSel = ExtTool.GetGridSelectedData(obj.CtlPaadmGrid);
					if(objSel == null) return;
					var WinPatInfo = new InitViewPatInfo(objSel.get("Paadm"));
					WinPatInfo.WinPatInfo.show();
				}
			}
		]
	});
	
	//ͼ����ʾ
	obj.DisplaySpeMarkWin = function(SpeID){
		var objInput = new Object();
		objInput.SpeID     = SpeID;
		objInput.EpisodeID = '';
		objInput.OperTpCode = (tDHCMedMenuOper['admin'] == '1'?'2':'1');
		
		var objMarkWin = new SPM_InitSpeMarkWin(objInput);
		objMarkWin.SPM_WinSpeMark.show();
		window.event.returnValue = false;
		return true;
	}
	
	//�һ��¼�
	obj.CtlPaadmGrid_rowcontextmenu = function(objGrid, rowIndex, eventObj){
		eventObj.stopPropagation();
		objGrid.getSelectionModel().selectRow(rowIndex);
		obj.objContextMenu.showAt(eventObj.getXY());
		//fix bug 135538 by pylian 2015-10-09 �һ����⻼�߼�¼�����ǰ����ŵ����С�ˢ�¡�/�����ԡ���
		if (document.all) window.event.returnValue = false;// for IE
		else event.preventDefault();
	}
	obj.btnQuery_Click = function() {
		obj.CtlPaadmGridStore.removeAll();
		var DateFrom = obj.DateFrom.getRawValue();
		var DateTo = obj.DateTo.getRawValue();
		if ((DateFrom == '')||(DateTo == '')){
			ExtTool.alert('������ʾ','��ʼ���ںͽ������ڲ�����Ϊ��!');
			return false;
		} else {
			if (Common_ComputeDays("DateFrom","DateTo")<0){
				ExtTool.alert('������ʾ','��ʼ���ڲ��ܴ��ڽ�������!');
				return false;
			}
		}
		
		var CtrlItems = getChildString(obj.TreeControls.getRootNode());
		var LocID = obj.cboLoc.getValue();
		var WardID = obj.cboWard.getValue();
		var HospitalID = obj.cboSSHosp.getValue();
		
		obj.QueryArgs.DateFrom = DateFrom;
		obj.QueryArgs.DateTo = DateTo;
		obj.QueryArgs.CtrlItems = CtrlItems;
		obj.QueryArgs.LocID = LocID;
		obj.QueryArgs.WardID = WardID;
		obj.QueryArgs.HospID = HospitalID;
		obj.CtlPaadmGridStore.load({params : {start : 0,limit : 15}});
	};
	
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

    obj.CtlPaadmGrid_rowmousedown  = function(grid, rowIndex, eventObj)
	{
		var rec = obj.CtlPaadmGridStore.getAt(rowIndex);
		if(rec == null)
			return;
		obj.SelAdmRec = rec;
		window.event.returnValue = false;		
	}
	obj.btnExport_Click = function() {
	    var startDate=obj.QueryArgs.DateFrom;
        var endDate=obj.QueryArgs.DateTo;
      	var ctls=obj.QueryArgs.CtrlItems; 
        var loc= obj.QueryArgs.LocID;
        var wardId=obj.QueryArgs.WardID;
        var hospId= obj.QueryArgs.HospID;
      
		var Arg=startDate+"^"+endDate+"^"+ctls+"^"+loc+"^"+wardId+"^"+hospId;
	
		ExportDataToExcel("","","",Arg);
	}
	
	obj.CtrlGridRowRefresh_Handler = function(SpeID){
		if (SpeID == '') return;
		var strSpeInfo = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsSrv","GetSepInfoByID",SpeID);
		if (strSpeInfo == '') return;
		var arrSepInfo = strSpeInfo.split('^');
		var EpisodeID = arrSepInfo[1];
		if (EpisodeID == '') return;
		var objGrid = Ext.getCmp('CtlPaadmGrid');
		if (!objGrid) return;
		var objStore = objGrid.getStore();
		if (!objStore) return
		var SelectIndex = objStore.find('Paadm',EpisodeID);
		if (SelectIndex > -1){
			var rd = objStore.getAt(SelectIndex);
			var strPatTypes = rd.get('PatTypes');
			
			var IsDisplayFlag = 0;
			if (strPatTypes != ''){
				var arryRows = strPatTypes.split(String.fromCharCode(1));
				var arryFields = null;
				for (var i = 0; i < arryRows.length; i ++){
					if(arryRows[i] == "") continue;
					arryFields = arryRows[i].split("^");
					if (SpeID != arryFields[0]) continue;
					IsDisplayFlag = 1;
				}
			}
			
			if (IsDisplayFlag == 0) {
				var tmpSpeInfo = ExtTool.RunServerMethod("DHCMed.SPEService.PatientsQry","GetSpeIconCont",SpeID);
				if (tmpSpeInfo == '') return;
				if (strPatTypes == ''){
					strPatTypes = tmpSpeInfo;
				} else {
					strPatTypes += String.fromCharCode(1) + tmpSpeInfo;
				}
			}
			
			rd.set('PatTypes',strPatTypes);
			rd.commit();
		}
	}
}