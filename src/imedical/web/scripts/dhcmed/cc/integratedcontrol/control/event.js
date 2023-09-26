var CRChar=String.fromCharCode(13) + String.fromCharCode(10);
function InitWinControlEvent(obj){
	obj.LoadEvent = function(args){
		//obj.radioVisit.on("change",obj.radioVisit_Change,obj);
		obj.radioVisit.setValue("I");
		obj.btnQuery.on("click",obj.btnQuery_Click,obj);
		obj.btnExport.on("click",obj.btnExport_Click,obj);
        Ext.getCmp("mnuSendMsg").on("click", obj.mnuSendMsg_click, obj);
        Ext.getCmp("mnuBaseInfo").on("click", obj.mnuBaseInfo_click, obj);
		Ext.getCmp("mnuViewObservation").on("click", obj.mnuViewObservation_click, obj);
		
		//update by zf 20130506
		//window.refreshDataGrid = function() {
	  	//	obj.DataGridPanelStore.load({});
	  	//};
		
		//update by zf 2013-04-18
		//监控项目加载完，执行查询操作
		obj.TreeControlsTreeLoader.baseParams.SubjectID=obj.SubjectID;
		obj.TreeControls.loader=obj.TreeControlsTreeLoader;
		obj.TreeControlsTreeLoader.load(
			obj.TreeControls.getRootNode()
			,function (){
				obj.btnQuery_Click();
			}
		);
		obj.TreeControls.getRootNode().expanded=true;
		obj.TreeControls.on("checkchange", obj.TreeControls_CheckChange, obj);
		
		//初始化时监控主题下的项目存起来，显示明细时用
		//obj.allCtrlItems = getChildString(obj.TreeControls.getRootNode());
		obj.allCtrlSubCats = ExtTool.RunServerMethod("DHCMed.CCService.Sys.SubjectConfig", "GetCtrlSubCatsByConfigCode", ViewConfigCode);
	}
    
    obj.mnuViewObservation_click = function()
    {
        if(obj.DataGridPanel.getSelectionModel().getCount() == 0) return;
		var objRec = obj.DataGridPanel.getSelectionModel().getSelected();
		var strUrl = "./dhcmed.cc.doctempature.csp?"+"EmrCode=DHCNURTEM"+"&EpisodeID="+objRec.get("Paadm");
		window.showModalDialog(strUrl ,"","dialogWidth=300px;dialogHeight=300px;status=no");
    }
	
	//“明细”页签【提示医师】按钮对应触发事件
    obj.btnNoticeDoctor_onclick = function(LastSummaryID,LnkSummaryIDs)
    {
        var frmMsgSender = new InitwinSendFeedback(LastSummaryID,LnkSummaryIDs);
        frmMsgSender.winSendFeedback.show();
    }
	
	//“明细”页签【排除】按钮对应触发事件
	obj.btnReject_onclick = function(SummaryID,LnkSummaryIDs)
	{
		var ret=ExtTool.RunServerMethod("DHCMed.CC.CtlSummary", "RejectSummary", SummaryID, session['LOGON.USERID']);
		
		//处理关联Summary状态
		var flg = ExtTool.RunServerMethod("DHCMed.CC.CtlSummary", "ProcessLnkSummary", SummaryID, LnkSummaryIDs);
		
		//obj.btnQuery_onClick();
	}
	
	//“明细”页签【摘要】按钮对应触发事件
    obj.viewPatientInfo = function(Paadm,SummaryID)
    {
        var objDisplayWin = new InitViewBaseInfo();
		objDisplayWin.DisplayDetailInfo(Paadm, obj.SubjectID,SummaryID);
		objDisplayWin.viewPatientWin.show();
    }
	
	//主页面【查询】按钮的触发事件
	obj.btnQuery_Click = function(){
		obj.BuildArguments();
		obj.DisplayWardSummary();
		obj.tabResult.remove(obj.DataLocBedPanel);
		obj.tabResult.remove(obj.FloorplanPanel);
		obj.tabResult.remove(obj.DataGridPanel);
		obj.tabResult.setActiveTab(0);
	}
	
	obj.BuildArguments = function(){
		var inputStr="",inputErr="";
		var aCtrls="",aVisitStatus="",aDateFrom="",aDateTo="",aLoc="",aWard="";
		if(obj.radioVisitI.getValue()) aVisitStatus += "I";
		if(obj.radioVisitO.getValue()) aVisitStatus += "O";
		
		var dfDateFrom = Ext.getCmp('dfDateFrom').getRawValue();
		var dfDateTo = Ext.getCmp('dfDateTo').getRawValue();
		var today = new Date();
		var CurrDate = today.getYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
		if (dfDateFrom == '') {
			Ext.getCmp('dfDateFrom').setValue(CurrDate);
			dfDateFrom = Ext.getCmp('dfDateFrom').getRawValue();
		}
		if (dfDateTo == '') {
			Ext.getCmp('dfDateTo').setValue(CurrDate);
			dfDateTo = Ext.getCmp('dfDateTo').getRawValue();
		}
		var flg = objINTCCommon.CompareDate(dfDateFrom,CurrDate);
		if (!flg) {
			Ext.getCmp('dfDateFrom').setValue(CurrDate);
			dfDateFrom = Ext.getCmp('dfDateFrom').getRawValue();
			ExtTool.alert("提示", '开始日期大于当前日期,开始日期设为当前日期!');
		}
		var flg = objINTCCommon.CompareDate(dfDateTo,CurrDate);
		if (!flg) {
			Ext.getCmp('dfDateTo').setValue(CurrDate);
			dfDateTo = Ext.getCmp('dfDateTo').getRawValue();
			ExtTool.alert("提示", '结束日期大于当前日期,结束日期设为当前日期!');
		}
		var flg = objINTCCommon.CompareDate(dfDateFrom,dfDateTo);
		if (!flg) {
			Ext.getCmp('dfDateTo').setValue(dfDateFrom);
			dfDateTo = Ext.getCmp('dfDateTo').getRawValue();
			ExtTool.alert("提示", '结束日期大于开始日期,结束日期设为开始日期!');
		}
		
		var dtMaxDate = dfDateFrom;
		var dtMaxMonth = dtMaxDate.substring(5,dtMaxDate.lastIndexOf ("-"));
		var dtMaxDay = dtMaxDate.substring(dtMaxDate.length,dtMaxDate.lastIndexOf ("-")+1);
		var dtMaxYear = dtMaxDate.substring(0,dtMaxDate.indexOf ("-"));
		var dtMaxDate = new Date(dtMaxMonth+"/"+dtMaxDay+"/"+dtMaxYear);
		dtMaxDate = dtMaxDate.add(Date.DAY, 31);  //7天改为31天
		dtMaxDate = dtMaxDate.format('Y-m-d');
		if (dfDateTo > dtMaxDate)
		{
			Ext.getCmp('dfDateTo').setValue(dtMaxDate);
			dfDateTo = Ext.getCmp('dfDateTo').getRawValue();
			ExtTool.alert("提示", '最大时间跨度为7天,结束日期设为"' + dtMaxDate + '".');
		}
		
		aDateFrom=dfDateFrom;
		aDateTo=dfDateTo;
		
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
		obj.loadParamArg4='';//aLoc;
		obj.loadParamArg5='';//aWard;
		obj.loadParamArg6=aCtrls;
		obj.loadParamArg7=(obj.chkRelation.getValue() ? 1 : 2);
		return;	
	}
	
	//明细触发事件
	obj.DisplayControlPatientDetail = function(WardID, WardDesc, CtrlItems, aEpisodeID){
		//update by zf 20130514 给床位图增加链接
		if (aEpisodeID) {
			obj.tabResult.setActiveTab(3);
			obj.tabResult.setActiveTab(1);
			obj.tabResult.setActiveTab(2);
		} else {
			obj.tabResult.add(obj.DataLocBedPanel);
			obj.tabResult.add(obj.DataGridPanel);
			obj.tabResult.add(obj.FloorplanPanel);
			obj.tabResult.setActiveTab(3);
			obj.tabResult.setActiveTab(2);
			obj.tabResult.setActiveTab(1);
			
			var strHTML = '<iframe height="100%" width="100%" src="./dhcmed.cc.floorplan.view.csp?1=1&WardID=' + WardID + '&ProfileID=' + '&rnd=Math.random()" />';
			obj.FloorplanPanel.update(strHTML);
		}
		
		if((WardDesc == null)||(WardDesc == '')) {
			obj.DataLocBedPanel.setTitle('床位图（全院）');
			obj.FloorplanPanel.setTitle('病区床位图（全院）');
			obj.DataGridPanel.setTitle('明细（全院）');
		} else {
			obj.DataLocBedPanel.setTitle('床位图（' + WardDesc + '）');
			obj.FloorplanPanel.setTitle('病区床位图（' + WardDesc + '）');
			obj.DataGridPanel.setTitle('明细（' + WardDesc + '）');
		}
		
		Ext.Ajax.request({
			url : ExtToolSetting.RunQueryPageURL,
			method : "POST",
			params  : {
				ClassName : 'DHCMed.CCService.IntegratedCtrl.Control',
				QueryName : 'QryByPaadm',
				Arg1 : obj.loadParamArg1,
				Arg2 : obj.loadParamArg2,
				Arg3 : obj.loadParamArg3,
				Arg4 : obj.loadParamArg4,
				Arg5 : (WardID ? WardID : obj.loadParamArg5),
				Arg6 : (CtrlItems ? CtrlItems : obj.loadParamArg6),
				Arg7 : obj.SubjectID,
				Arg8 : obj.loadParamArg7,
				Arg9 : aEpisodeID,
				ArgCnt : 9
			},
			success: function(response, opts) {
				var objData = Ext.decode(response.responseText);
				//*************************************************
				//update by zf 20130329
				//此处修改，影响疑似病例筛查明细页面患者数量
				//如果病人明细超过20，只显示50个人
				if (objData.record.length>50) {
					objData.record.length = 50;
				}
				//*************************************************
				
				//update by zf 20130514 给床位图增加链接
				if (aEpisodeID) {
					obj.objTpl.overwrite(obj.DataGridPanel.body, objData);
				} else {
					obj.objLocBedTpl.overwrite(obj.DataLocBedPanel.body, objData);
					obj.objTpl.overwrite(obj.DataGridPanel.body, objData);
				}
			},
			failure: function(response, opts) {
				//
			}
		});
	}
	
	//摘要触发事件（科室床位图）
	obj.DisplayWardSummary = function()
	{
		obj.dataViewStore.load({
			params :{
				ClassName : 'DHCMed.CCService.IntegratedCtrl.ControlCurrWard',
				QueryName : 'QryCurrPatient',
				Arg1 : obj.loadParamArg1,
				Arg2 : obj.loadParamArg2,
				Arg3 : obj.loadParamArg3,
				Arg4 : obj.loadParamArg4,
				Arg5 : obj.loadParamArg5,
				Arg6 : obj.loadParamArg6,
				Arg7 : obj.SubjectID,
				Arg8 : obj.loadParamArg7,
				ArgCnt : 8
			}
		});
	}
	
	obj.btnExport_Click = function(){
		var objDate = new Date();
		var strFileName=objDate.getDate()
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.DataGridPanel,strFileName);
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
			var arryField = nodeList[0].split("||");
			if (nodeList.length>2){
				if (nodeList[1]=="D"){
					if (childnode.attributes.checked){
						str = str + arryField[3] + "/";
					}
				}
			}
			str += getChildString(childnode);
		}
		return str;
	}
	
	obj.RenderCtlResult = function(TargetElement, arryResult)
	{
		var objTemplate = new Ext.XTemplate(
			//'<div style="height:500px; width:750px; text-align: left>',
			'<table width="700">',
				'<tr>',
					'<th width="10%">序号</th>',
					'<th width="60%">项目</th>',
					'<th width="10%">用户</th>',
					'<th width="10%">日期</th>',
					'<th width="10%">时间</th>',
				'</tr>',
				'<tpl for=".">',
					//'<tpl if="values.Score &gt; 0">',
					'<tr>',
						'<td>{[xindex]}</td>',
						'<td>{Summary}</td>',
						'<td>{UserName}</td>',
						'<td>{ActDate}</td>',
						'<td>{ActTime}</td>',
					'</tr>',
					//'</tpl>',
				'</tpl>',
			'</table>'
			//'</div>'
		);		
		objTemplate.overwrite(TargetElement, arryResult);
	}
	
	obj.RenderInfectionResult = function(TargetElement, arryResult)
	{
		var objTemplate = new Ext.XTemplate(
			'<table width="700" scrollHeight="500">',
				'<tr>',
					'<th width="10%">序号</th>',
					'<th width="20%">感染部位</th>',
					'<th width="20%">感染诊断</th>',
					'<th width="10%">报告用户</th>',
					'<th width="10%">报告日期</th>',
					'<th width="10%">报告时间</th>',
				'</tr>',
				'<tpl for=".">',
					'<tr>',
						'<td>{[xindex]}</td>',
						'<td>{Position}</td>',
						'<td>{Diagnose}</td>',
						'<td>{RepUser}</td>',
						'<td>{RepDate}</td>',
						'<td>{RepTime}</td>',
					'</tr>',
				'</tpl>',
			'</table>'
		);		
		objTemplate.overwrite(TargetElement, arryResult);	
	}

    
}