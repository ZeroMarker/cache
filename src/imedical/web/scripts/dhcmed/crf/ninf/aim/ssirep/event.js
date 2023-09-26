var SubjectID = obj.SubjectID;
function InitVpInfPatientAdmEvent(obj)
{	obj.LoadEvent = function(args)
	{
		//事件处理代码
		obj.grdPatAdmList.on("rowcontextmenu" , obj.grdPatAdmList_rowcontextmenu , obj);
		obj.grdPatAdmRepList.on("rowdblclick" , obj.grdPatAdmRepList_rowdblclick , obj);
		obj.RegNo.on("specialkey", obj.txtRegNoM_specialkey, obj);
		obj.grdPatAdmList.on("rowclick",obj.grdPatAdmList_rowclick, obj);
		obj.BtnFind.on("click",obj.BtnFind_click,obj);
		obj.BtnCC.on("click",obj.BtnCC_click,obj);
		obj.BtnLocManager.on("click",obj.BtnLocManager_click,obj);
		//科室为登陆科室
		var objLoc= ExtTool.StaticServerObject("DHCMed.Base.Ctloc");
		var LocStr=objLoc.GetStringById(session['LOGON.CTLOCID'],"^");
		var LocDesc=LocStr.split("^")[2];
		var objAimLoc= ExtTool.StaticServerObject("DHCMed.NINFService.Aim.CtlocOperSrv");
		var IsAimLoc = objAimLoc.IsAimLoc("SSI",session['LOGON.CTLOCID']);
		if(tDHCMedMenuOper['Admin']==0)
		{
			if(IsAimLoc<0)
			{
				ExtTool.alert("提示","本科室未开展手术部位感染监测,如需开展,请联系感染办!");
				obj.FPanSouthPad.hide();
				return;
			}else{
				ExtTool.AddComboItem(obj.Loc,LocDesc,session['LOGON.CTLOCID']);
				obj.Loc.disable(true);
				obj.BtnLocManager.setVisible(false);
			}
		}
		obj.TreeControlsTreeLoader.baseParams.SubjectID=obj.SubjectID;
		obj.TreeControls.loader=obj.TreeControlsTreeLoader;
		obj.TreeControlsTreeLoader.load(obj.TreeControls.getRootNode());
		obj.TreeControls.getRootNode().expanded=true;
		obj.TreeControls.on("checkchange", obj.TreeControls_CheckChange, obj);
		
		window.refreshDataGrid = function() {
	  		obj.DataGridPanelStore.load({});
	  	};
	}
	obj.txtRegNoM_specialkey = function()
	{
		obj.grdPatAdmListStore.load({
			params : {
				start:0
				,limit:50
			}
		});	
	};
	obj.BtnFind_click= function()
	{
		obj.aCtrls="";
		
		obj.grdPatAdmListStore.removeAll();
		obj.grdPatAdmRepListStore.removeAll();
		
		obj.grdPatAdmListStore.load({
			params : {
				start:0
				,limit:50
			}
		});	
		
		EpisodeID="";
		
		obj.grdPatAdmRepListStore.load({});
		
		obj.grdPatAdmListStore.load({
			callback : function(){
				obj.expCtrlDetail.bodyContent={}; //清除RowExpander bodyContent 
			}
		});
		
	};
	obj.BtnLocManager_click= function()
	{
		var objWinEdit = new InitwinScreen("SSI");
		objWinEdit.winScreen.show();
	}
	obj.BtnCC_click= function()
	{
		obj.grdPatAdmListStore.removeAll();
		obj.grdPatAdmRepListStore.removeAll();
		
		obj.aCtrls = getChildString(obj.TreeControls.getRootNode());
		if (obj.aCtrls==""){
			alert( "监控项目未选择,请至少选择一个监控项目!");
			return;
		}
		
		obj.grdPatAdmListStore.load({
			params : {
				start:0
				,limit:50
			}
		});	
		
		EpisodeID="";
		
		obj.grdPatAdmRepListStore.load({});
		
		obj.grdPatAdmListStore.load({
			callback : function(){
				obj.expCtrlDetail.bodyContent={}; //清除RowExpander bodyContent 
			}
		});
	};
	
	obj.grdPatAdmList_rowclick = function()
	{
		var rc=obj.grdPatAdmList.getSelectionModel().getSelected();
		if(rc==null)return;
		
		EpisodeID = rc.get("Paadm");
		PatientID = rc.get("PatientID");
		obj.grdPatAdmRepListStore.load({});
	}
		
	obj.grdPatAdmList_rowcontextmenu = function (objGrid, rowIndex, eventObj) {
		eventObj.preventDefault();//覆盖默认右键
	
		var sel = obj.grdPatAdmListStore.getAt(rowIndex);
		EpisodeID = sel.get("Paadm");
		PatientID = sel.get("PatientID");
	
		obj.objSelContextMenu="";
		var objClass = ExtTool.StaticServerObject("DHCMed.NINFService.Aim.ICUSrv");
		if (objClass) {
			var JsonExp = objClass.GetCRReportInfo(CRPrjCode);
			window.eval(JsonExp);
		}
		obj.objSelContextMenu.showAt(eventObj.getXY());
		
	}
	
	obj.grdPatAdmRepList_rowdblclick = function () {
		var rc=obj.grdPatAdmRepList.getSelectionModel().getSelected();
		if(rc==null)return;
		
		var PrintDocID = rc.get("PrintDocID");
		var TemplateDocID = rc.get("TemplateDocID");
		var InstanceID = rc.get("InstanceID");
		var Description= rc.get("Description");
		var RepStatus = rc.get("RepStatus");
		var ReportID = rc.get("rowid");
		var EPRNum=InstanceID.split("||",1);
	  var ChartItemID="ML"+PrintDocID;
	  if((EpisodeID=="")||(PatientID=="")||(PrintDocID=="")||(TemplateDocID=="")||(InstanceID=="")||(EPRNum=="")) return;
		
		var url="./dhcmed.ninf.aim.centertablistdetail.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PrintDocID="+PrintDocID+"&TemplateDocID="+TemplateDocID+"&ChartItemID="+ChartItemID+"&InstanceDataID="+InstanceID+"&EPRNum="+EPRNum+"&RepStatus="+RepStatus+"&ReportID="+ReportID+"&SubjectID="+SubjectID;
		var objWin = new Ext.Window(
			{
				title:Description,
				html:'<iframe width=990 height=620 scrollbars=no src='+ url + '></iframe>',
				height:650,
				width:1000
			}
		);
	objWin.show();
		
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

function ReportClickHeader(PrintDocID,TemplateDocID,ChartItemID,Description)
{
	var CtlocId=session['LOGON.CTLOCID'];
	var UserId=session['LOGON.USERID'];
	var GroupId=session['LOGON.GROUPID'];

	var url="./dhcmed.ninf.aim.centertablistdetail.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PrintDocID="+PrintDocID+"&TemplateDocID="+TemplateDocID+"&ChartItemID="+ChartItemID+"&InstanceDataID=&EPRNum=&CtlocId="+CtlocId+"&UserId="+UserId+"&GroupId="+GroupId+"&SubjectID="+SubjectID;
	var objWin = new Ext.Window(
		{
			title:Description,
			html:'<iframe width=990 height=620 scrollbars=no src='+ url + '></iframe>',
			height:650,
			width:1000
		}
	);
	objWin.show();
}

function ShowEPRReport()
{
	var strUrl = "./dhceprredirect.csp?EpisodeID="+EpisodeID+"&PatientID="+PatientID;
	var objWin = new Ext.Window(
		{
			title:"电子病历",
			html:'<iframe width=847 height=627 scrollbars=no src='+ strUrl + '></iframe>',
			height:650,
			width:852
		}
	);
	objWin.show();
}	

function ShowLibReport()
{
	var strUrl = "./dhcmed.ninf.aim.looklibresult.csp?paadmdr="+EpisodeID;
	var objWin = new Ext.Window(
		{
			title:"检验报告",
			html:'<iframe width=847 height=627 scrollbars=no src='+ strUrl + '></iframe>',
			height:650,
			width:852
		}
	);
	objWin.show();
}	

function ShowTypeLocPatInfo()
{
	var strUrl = "./dhcmed.inf.typelocpatinfo.csp";
	var objWin = new Ext.Window(
		{
			title:"ICU日志",
			html:'<iframe width=847 height=627 scrollbars=no src='+ strUrl + '></iframe>',
			height:650,
			width:852
		}
	);
	objWin.show();
}

function ShowICUGrade()
{
	var strUrl = "./dhcmed.inf.icugrade.csp";
	var objWin = new Ext.Window(
		{
			title:"ICU危险等级",
			html:'<iframe width=847 height=627 scrollbars=no src='+ strUrl + '></iframe>',
			height:650,
			width:852
		}
	);
	objWin.show();
}