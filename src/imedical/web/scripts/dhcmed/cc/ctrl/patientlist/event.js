var CRChar=String.fromCharCode(13) + String.fromCharCode(10);
function InitWinControlEvent(obj){
	obj.LoadEvent = function(args){
		obj.TreeControlsTreeLoader.baseParams.SubjectID=obj.SubjectID;
		obj.TreeControls.loader=obj.TreeControlsTreeLoader;
		obj.TreeControlsTreeLoader.load(obj.TreeControls.getRootNode());
		obj.TreeControls.getRootNode().expanded=true;
		obj.TreeControls.on("checkchange", obj.TreeControls_CheckChange, obj);
		
		obj.radioVisit.on("change",obj.radioVisit_Change,obj);
		obj.radioVisit.setValue("I");
		obj.btnQuery.on("click",obj.btnQuery_Click,obj);
		obj.btnExport.on("click",obj.btnExport_Click,obj);
		obj.cboLoc.on("expand", obj.cboLoc_OnExpand, obj);
		obj.cboWard.on("expand", obj.cboWard_OnExpand, obj);
		
		obj.cboLoc.on("collapse", 
            function()
            {
                obj.cboWard.clearValue();
                obj.LoadTreeCtrlsByLoc();
            },
            obj
        );
        obj.cboWard.on("collapse", 
            function()
            {
                obj.cboLoc.clearValue();
                obj.LoadTreeCtrlsByLoc();
            },
            obj
        );
        
		obj.DataGridPanel.on("rowclick", obj.DataGridPanel_OnRowClick, obj);
        obj.DataGridPanel.on("contextmenu", obj.DataGridPanel_contextmenu, obj);
        Ext.getCmp("mnuEva").on("click",  obj.mnuEva_click, obj);
        Ext.getCmp("mnuSendMsg").on("click", obj.mnuSendMsg_click, obj);
		
		window.refreshDataGrid = function() {
	  		obj.DataGridPanelStore.load({});
	  	};
	}
    
    obj.LoadTreeCtrlsByLoc = function(){
		obj.TreeControlsTreeLoader.baseParams.SubjectID=obj.SubjectID;
        obj.TreeControlsTreeLoader.baseParams.Loc = this.cboLoc.getValue();
     	obj.TreeControlsTreeLoader.baseParams.Ward = this.cboWard.getValue();
		obj.TreeControlsTreeLoader.load(obj.TreeControls.getRootNode());
		obj.TreeControls.getRootNode().expanded=true;
    }
    
    obj.DataGridPanel_contextmenu = function(objEvent)
    {
        if(obj.DataGridPanel.getSelectionModel().getCount() == 0)
        {
              Ext.getCmp("mnuEva").disable() ;
              Ext.getCmp("mnuSendMsg").disable() ;
        }
        else
       {
              Ext.getCmp("mnuEva").enable();
              Ext.getCmp("mnuSendMsg").enable() ;                    
        }
        obj.mnuMenu.showAt(objEvent.getXY());
        objEvent.stopEvent();       
    }
    
    obj.mnuEva_click = function()
    {
        if(obj.DataGridPanel.getSelectionModel().getCount() == 0)
            return;
        var objRec = obj.DataGridPanel.getSelectionModel().getSelected();
        EvaluationLookUpHeader(obj.SubjectID,  objRec.get("Paadm"));
    }

    obj.mnuSendMsg_click = function()
    {
        if(obj.DataGridPanel.getSelectionModel().getCount() == 0)
            return;
        var objRec = obj.DataGridPanel.getSelectionModel().getSelected();
        //EvaluationLookUpHeader(obj.SubjectID,  objRec.get("Paadm"));
        var frmMsgSender = new InitwinsSendMessage(objRec.get("Paadm"));
        frmMsgSender.winsSendMessage.show();
    }
	
	obj.DataGridPanel_OnRowClick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.DataGridPanelStore.getAt(rowIndex);
		var PatientID=objRec.get("PatientID");
		var EpisodeID=objRec.get("Paadm");
		var mradm=objRec.get("MRAdm");
        //window.alert(objRec.get("CtrlDtl"));
		//var frm =top.document.forms["fEPRMENU"];
		//parent.frames[0].document.forms["fEPRMENU"];
		var frm=parent.document.forms["fEPRMENU"];
		if (frm){
			var frmEpisodeID=frm.EpisodeID;
			var frmPatientID=frm.PatientID;
			var frmmradm=frm.mradm;
			frmPatientID.value=PatientID;
			frmEpisodeID.value=EpisodeID;
			frmmradm.value=mradm;
		}
		var frm=parent.parent.document.forms["fEPRMENU"];
		if (frm){
			var frmEpisodeID=frm.EpisodeID;
			var frmPatientID=frm.PatientID;
			var frmmradm=frm.mradm;
			frmPatientID.value=PatientID;
			frmEpisodeID.value=EpisodeID;
			frmmradm.value=mradm;
		}
		var frm=parent.frames[0].document.forms["fEPRMENU"];
		if (frm){
			var frmEpisodeID=frm.EpisodeID;
			var frmPatientID=frm.PatientID;
			var frmmradm=frm.mradm;
			frmPatientID.value=PatientID;
			frmEpisodeID.value=EpisodeID;
			frmmradm.value=mradm;
		}
		var frm=parent.parent.frames[0].document.forms["fEPRMENU"];
		if (frm){
			var frmEpisodeID=frm.EpisodeID;
			var frmPatientID=frm.PatientID;
			var frmmradm=frm.mradm;
			frmPatientID.value=PatientID;
			frmEpisodeID.value=EpisodeID;
			frmmradm.value=mradm;
		}
	}
	
	obj.cboLoc_OnExpand = function(){
         obj.cboLoc.clearValue();
		obj.cboLocStore.load({});
	}
	obj.cboWard_OnExpand = function(){
         obj.cboWard.clearValue();
		obj.cboWardStore.load({});
	}
	obj.btnQuery_Click = function(){
		obj.DataGridPanelStore.removeAll();
		var inputStr="",inputErr="";
		var aCtrls="",aVisitStatus="",aDateFrom="",aDateTo="",aLoc="",aWard="";
		aVisitStatus=obj.radioVisitI.getGroupValue();
		aDateFrom=obj.dfDateFrom.getRawValue();
		aDateTo=obj.dfDateTo.getRawValue();
		if ((obj.cboLoc.getValue()!=="")&&(obj.cboLoc.getRawValue()!=="")){
			aLoc=obj.cboLoc.getValue();
		}else{
			obj.cboLoc.setValue("");
			obj.cboLoc.setRawValue("");
		}
		if ((obj.cboWard.getValue()!=="")&&(obj.cboWard.getRawValue()!=="")){
			aWard=obj.cboWard.getValue();
		}else{
			obj.cboWard.setValue("");
			obj.cboWard.setRawValue("");
		}
		if (aVisitStatus=="O"){
			if ((aDateFrom=="")||(aDateTo=="")){
				inputErr=inputErr + "开始日期或结束日期为空,出院患者监控必须选择时间条件!" + CRChar;
			}else{
				var objDateFrom = Date.parseDate(aDateFrom, "Y-m-d");
				var objDateTo = Date.parseDate(aDateTo, "Y-m-d");
				if ((objDateFrom)&&(objDateTo)){
					var tmpDays=objDateTo.getDate()-objDateFrom.getDate();
					if ((tmpDays>9)||(tmpDays<0)){
						inputErr = inputErr + "结束日期必须大于开始日期,时间差不允许超过10天!" + CRChar;
						obj.dfDateFrom.setValue("");
					}
				}else{
					inputErr = inputErr + "开始日期或结束日期时间格式错误!" + CRChar;
				}
			}
		}else if (aVisitStatus=="I"){
			if ((aLoc=="")&&(aWard=="")){
				inputErr=inputErr + "住院科室和住院病区为空,在院患者监控必须选择科室或病区!" + CRChar;
			}
		}
		aCtrls = getChildString(obj.TreeControls.getRootNode());
		if (aCtrls==""){
			inputErr=inputErr + "监控项目未选择,请至少选择一个监控项目!" + CRChar;
		}
		if (inputErr){
			inputErr=inputErr + "请认真选择查询条件!" + CRChar;
			ExtTool.alert("确认", inputErr);
			return;
		}
		
		obj.loadParamArg1=aVisitStatus;
		obj.loadParamArg2=aDateFrom;
		obj.loadParamArg3=aDateTo;
		obj.loadParamArg4=aLoc;
		obj.loadParamArg5=aWard;
		obj.loadParamArg6=aCtrls;

		obj.DataGridPanelStore.load({
			callback : function(){
				obj.expCtrlDetail.bodyContent={}; //清除RowExpander bodyContent 
			}
		});
	}
	
	obj.btnExport_Click = function(){
		var objDate = new Date();
		var strFileName=objDate.getDate()
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.DataGridPanel,strFileName);
	}
	obj.radioVisit_Change = function(){
		if (obj.radioVisitI.getGroupValue()=="I"){
			obj.dfDateFrom.setValue("");
			obj.dfDateTo.setValue("");
			//obj.dfDateFrom.disable();
			//obj.dfDateTo.disable();
		}else{
			obj.dfDateFrom.setValue(new Date());
			obj.dfDateTo.setValue(new Date());
			//obj.dfDateFrom.enable();
			//obj.dfDateTo.enable();
		}
	}
	
	obj.TreeControls_CheckChange = function(){
		var node = arguments[0];
		var val = arguments[1];
		//obj.SelectNode 非常重要,避免checkchange引起的死循环
		if (obj.SelectNode) return;
		obj.SelectNode=node;
		setChildNode(node,val);
		setParentNode(node,val);
		obj.SelectNode=null;
	}
		
	setChildNode = function(argNode,argVal){
		//alert("setChildNode="+argNode.text+"//"+argVal);
		var childnodes = argNode.childNodes;
		for(var i=0;i<childnodes.length;i++){
			var childnode = childnodes[i];
			childnode.attributes.checked=argVal;
			childnode.getUI().toggleCheck(argVal);
			if(childnode.childNodes.length>0){
				setChildNode(childnode,argVal);
			}
      	}
	};
	
	setParentNode = function(argNode,argVal){
		//alert("setParentNode="+argNode.text+"//"+argVal);
		var parentnode=argNode.parentNode;
		if (!parentnode) return;
		if (parentnode.id=="root") return;
		if (argVal){
			parentnode.attributes.checked=true;
			parentnode.getUI().toggleCheck(true);
			setParentNode(parentnode,true);
		}else{
			var childnodes=parentnode.childNodes;
			var isChecked=false;
			for(var i=0;i<childnodes.length;i++){
				var childnode=childnodes[i];
				if (childnode.attributes.checked){
					isChecked=true;
				}
			}
			if (!isChecked){
				parentnode.attributes.checked=false;
				parentnode.getUI().toggleCheck(false);
				setParentNode(parentnode,false);
			}
		}
	};
	
	getChildString = function(node){
		var str = "";
		var childnodes = node.childNodes;
		for(var i=0;i<childnodes.length;i++){
			var childnode = childnodes[i];
			var nodeList = childnode.id.split("-");
			if (nodeList.length>2){
				if (nodeList[1]=="I"){
					if (childnode.attributes.checked){
						str = str + nodeList[0] + "/";
					}
				}
			}
			str += getChildString(childnode);
		}
		return str;
	}

    
}