function InitVpInfPatientAdmEvent(obj)
{
	//事件处理代码
	obj.BtnFind.on("click", obj.BtnFind_click, obj);
	obj.EPRReportList.on("rowcontextmenu" , obj.EPRReportList_rowcontextmenu , obj);
	obj.EPRReportList.on("rowdblclick",obj.EPRReportList_rowdblclick, obj);
	
	var objConfig=ExtTool.StaticServerObject("DHCMed.SSService.ConfigSrv");
	var HDMResDate=objConfig.GetValueByKeyHospN("INFHDMResDate","")
	var CurDate=new Date().format('Y-m-d');
	obj.LoadEvent = function(args)
	{
		if (tDHCMedMenuOper['Admin']!=1) {
			obj.cboCtlocStore.load({
				callback : function(){
					obj.cboCtloc.setValue(session['LOGON.CTLOCID']);
					obj.cboCtloc.setDisabled(true);
					obj.Ward.setDisabled(true);
				},
				scope : obj.cboCtlocStore,
				add : false
			});
			//obj.cboCtloc.setValue(session['LOGON.CTLOCID']);
			//ExtTool.AddComboItem(obj.cboCtloc,selectObj.get("LocTypeDesc"),selectObj.get("LocType"));
			//obj.cboCtloc.setDisabled(true);
		}
		var objCls=ExtTool.StaticServerObject("DHCMed.Base.Ctloc");
		var locId =session['LOGON.CTLOCID'];
		var CtlocStr=objCls.GetStringById(locId)
		var CtlocDesc=CtlocStr.split("^")[2];
	}
	obj.BtnFind_click = function()
	{
	 	obj.EPRReportListStore.load({
			callback:function() {
				var store = obj.EPRReportList.getStore();
				for(var i = 0, lens = store.getCount(); i < lens; i++) 
				{
					var rc=store.getAt(i);
					if(rc.get("statusDesc")=="已审")
					{
						obj.EPRReportList.getView().getRow(i).style.backgroundColor="#D1EEEE";
					}
					else if(rc.get("statusDesc")=="退回")
					{
						obj.EPRReportList.getView().getRow(i).style.backgroundColor="#FFB90F";
					}
					else if(rc.get("statusDesc")=="删除")      
					{
						obj.EPRReportList.getView().getRow(i).style.backgroundColor="#B452CD";
					}
				}
			}
		});
		 
	};
	
	obj.hiddenRepTypeList = function() {
		var TypeList = "/";
		var objStore=obj.cboInfType.getStore();
		for(var i=0;i<objStore.getCount();i++)
		{
			var rc=objStore.getAt(i);
			if(rc.get("checked"))
			{
				TypeList=TypeList+rc.get("Rowid")+"/";
	  		}
	  	}
		return TypeList;
	};
	
	obj.hiddenStatusList = function() {
		var StatusList = "*";
		var objStore=obj.gridStatus.getStore();
		for(var i=0;i<objStore.getCount();i++)
		{
			var rc=objStore.getAt(i);
			if(rc.get("checked"))
			{
				StatusList=StatusList+rc.get("Code")+"*";
	  		}
	  	}
		return StatusList;
	};
		
	obj.EPRReportList_rowdblclick = function()
	{
		var rc=obj.EPRReportList.getSelectionModel().getSelected();
		
		if(rc==null) return;
		var EpisodeID=rc.get("EpisodeID");
		var PrintDocID=rc.get("PrtTemplateID");
		var ChartItemID="ML"+PrintDocID;
		var InstanceID=rc.get("InstanceID");
		var EPRNum=InstanceID.split("||",1);
		var TemplateDocID=rc.get("TemplateCatID");
		var ProjectID=rc.get("ProjectID")
		var ReportID=rc.get("ReportID");
		var ProjectDesc=rc.get("ProjectDesc");
		var ReportStatus = rc.get("ReportStatus");
	
		if(tDHCMedMenuOper['Admin']==1)	//审核权限
		{
			ClinReportLookUpHeader(ProjectID,ReportID,EpisodeID,TemplateDocID,InstanceID,PrintDocID,ProjectDesc,ReportStatus);
			return;
		}
		
		var url="./dhcmed.ninf.aim.centertablistdetail.csp?PatientID="+"&EpisodeID="+EpisodeID+"&PrintDocID="+PrintDocID+"&TemplateDocID="+TemplateDocID+"&ChartItemID="+ChartItemID+"&InstanceDataID="+InstanceID+"&EPRNum="+EPRNum+"&RepStatus="+ReportStatus+"&ReportID="+ReportID;
		var objWin = new Ext.Window(
			{
				title:ProjectDesc,
				html:'<iframe width=990 height=600 scrollbars=no src='+ url + '></iframe>',
				height:630,
				width:1000
			}
		);
		objWin.show();
	}
	
	obj.EPRReportList_rowcontextmenu = function (objGrid, rowIndex, eventObj) {
		eventObj.preventDefault();//覆盖默认右键
	
		var sel = obj.EPRReportListStore.getAt(rowIndex);
		EpisodeID = sel.get("EpisodeID");
		PatientID = "";
		obj.objSelContextMenu="";
		var objClass = ExtTool.StaticServerObject("DHCMed.NINFService.Aim.ICUSrv");
		if (objClass) {
			var JsonExp = objClass.GetCRReportInfo("");
			window.eval(JsonExp);
		}
		obj.objSelContextMenu.showAt(eventObj.getXY());
	}
}

function ClinReportLookUpHeader(cPrjID,cRowid,cEpisodeID,cCategoryID,cInstanceID,cprtDocID,cProjectDesc,ReportStatus)
{
	var url="dhcmed.cr.audit.csp?PrjID="+cPrjID+"&Rowid="+cRowid+"&EpisodeID="+cEpisodeID+"&CategoryID="+cCategoryID+"&InstanceID="+cInstanceID+"&prtDocID="+cprtDocID+"&ReportStatus="+ReportStatus;
	var objWin = new Ext.Window(
		{
			title:"临床上报["+cProjectDesc+"]",
			html:'<iframe width=1000 height=627 scrollbars=no src='+ url + '></iframe>',
			height:650,
			width:1000
		}
	);
	objWin.show();
}

function ShowEPRReport()
{
	var strUrl = "./dhceprredirect.csp?EpisodeID="+EpisodeID;
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