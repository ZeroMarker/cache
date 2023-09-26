function InitVpInfPatientAdmEvent(obj)
{	obj.LoadEvent = function(args)
	{
		//科室为登陆科室
		var objLoc= ExtTool.StaticServerObject("DHCMed.Base.Ctloc");
		var LocStr=objLoc.GetStringById(session['LOGON.CTLOCID'],"^");
		var LocDesc=LocStr.split("^")[2];
		ExtTool.AddComboItem(obj.Loc,LocDesc,session['LOGON.CTLOCID']);
		
		obj.grdPatAdmListStore.load({
	  	params : {
			start:0
			,limit:100
		}});
		window.refreshDataGrid = function() {
	  		obj.DataGridPanelStore.load({});
	  	};
	}
	obj.txtRegNoM_specialkey = function()
	{
	  obj.grdPatAdmListStore.load({
	  params : {
		start:0
		,limit:100
	   }});
	};
	obj.BtnFind_click= function()
	{
		obj.aCtrls="";
		
		obj.grdPatAdmListStore.removeAll();
		obj.grdPatAdmRepListStore.removeAll();
		
	  obj.grdPatAdmListStore.load({
	  	params : {
			start:0
			,limit:100
	   }});	
	   
	   EpisodeID="";
	   
	  obj.grdPatAdmRepListStore.load({
	  	params : {
			start:0
			,limit:100
		}});
	  obj.grdPatAdmListStore.load({
			callback : function(){
				obj.expCtrlDetail.bodyContent={}; //清除RowExpander bodyContent 
			}
		});
		
	};
	
	obj.BtnExport_click= function()
	{
		var Arg1 = (obj.InHospital.getValue()? "A":"D");		//是否在院
		var Arg2 = obj.MrNo.getValue();
		var Arg3 = obj.RegNo.getValue();
		var Arg4 = obj.DateFrom.getValue();
		var Arg5 = obj.DateTo.getValue();
		var Arg6 = obj.Loc.getValue();
		var Arg7 = obj.Ward.getValue();
		var Arg8 = obj.PatName.getValue();
		var Arg9 = "";
		var Arg10 = "I";		// 住院类型 I/O/E  以"/"分割
		var Arg11 = "";
		var Arg12 = "";
		var Arg13 = 1;
		var Arg14 = (obj.IsReport.getValue()?"Y":"N");	//横断面是否已上报
		var cArguments=Arg1+"^"+Arg2+"^"+Arg3+"^"+Arg4+"^"+Arg5+"^"+Arg6+"^"+Arg7+"^"+Arg8+"^"+Arg9+"^"+Arg10+"^"+Arg11+"^"+Arg12+"^"+Arg13+"^"+Arg14;
		var flg=ExportDataToExcel("","","",cArguments);
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
			,limit:100
	   }});	
	   
	   EpisodeID="";
	   
	  obj.grdPatAdmRepListStore.load({
	  	params : {
			start:0
			,limit:100
		}});
		
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
		obj.grdPatAdmRepListStore.load({
	  params : {
		start:0
		,limit:100
		}});
	}
		
	obj.grdPatAdmList_rowcontextmenu = function (objGrid, rowIndex, eventObj) {
		eventObj.preventDefault();//覆盖默认右键
		//alert(123);
		var sel = obj.grdPatAdmListStore.getAt(rowIndex);
		EpisodeID = sel.get("Paadm");
		PatientID = sel.get("PatientID");
		
		var objPrj= ExtTool.StaticServerObject("DHCMed.CR.Project");
		var objConfig= ExtTool.StaticServerObject("DHCMed.SSService.ConfigSrv");
		var HDMProjectID=objConfig.GetValueByKeyHospN("INFHDMCRReportID","")
		//alert(HDMProjectID);
		if(HDMProjectID=="") return;
				
		var PrjStr=objPrj.GetById(HDMProjectID);
		//alert(PrjStr);
		var PrintDocID=PrjStr.split("^")[3];
		var TemplateDocID=PrjStr.split("^")[5];
		obj.objSelContextMenu = new Ext.menu.Menu({
		items:[
					{
						text:'横断面调查'
						,icon:'../scripts/dhcmed/img/menudic.gif'
						,handler:function(){
							ReportClickHeader(PrintDocID,TemplateDocID,"ML"+PrintDocID,obj,EpisodeID,HDMProjectID,rowIndex)
						}
					}
					,{
						text:'查看电子病历'
						,icon:'../scripts/dhcmed/img/menudic.gif'
						,handler:function(){
							ShowEPRReport()
						}
					},{
						text:'查看检验报告'
						,icon:'../scripts/dhcmed/img/menudic.gif'
						,handler:function(){
							ShowLibReport()
						}
					}
				]})
		obj.objSelContextMenu.showAt(eventObj.getXY());
	}
	
	obj.grdPatAdmRepList_rowdblclick = function () {
		var rc=obj.grdPatAdmRepList.getSelectionModel().getSelected();
		if(rc==null)return;
		
		var PrintDocID = rc.get("PrintDocID");
		var TemplateDocID = rc.get("TemplateDocID");
		var InstanceID = rc.get("InstanceID");
		var EPRNum=InstanceID.split("||",1);
	  var ChartItemID="ML"+PrintDocID;
	  if((EpisodeID=="")||(PatientID=="")||(PrintDocID=="")||(TemplateDocID=="")||(InstanceID=="")||(WebServerAppURL=="")||(EPRNum=="")) return;
		
		var objClass = ExtTool.StaticServerObject("DHCMed.NINFService.Aim.ICUSrv");
		var WebServerAppURL=""
		if (objClass) {
			WebServerAppURL=objClass.GetServerInfo()
		}
		if (WebServerAppURL=="") return;
		var url=WebServerAppURL+"/csp/dhcmed.ninf.aim.centertablistdetail.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PrintDocID="+PrintDocID+"&TemplateDocID="+TemplateDocID+"&ChartItemID="+ChartItemID+"&InstanceDataID="+InstanceID+"&EPRNum="+EPRNum
		var objWin = new Ext.Window(
			{
				title:"临床上报",
				html:'<iframe width=847 height=627 scrollbars=no src='+ url + '></iframe>',
				height:650,
				width:852
			}
		);
	objWin.show();
		
	}
}

function ReportClickHeader(PrintDocID,TemplateDocID,ChartItemID,obj,EpisodeID,HDMProjectID,rowIndex)
{
	var objClass = ExtTool.StaticServerObject("DHCMed.NINFService.Aim.ICUSrv");
	var WebServerAppURL=""
	if (objClass) {
		WebServerAppURL=objClass.GetServerInfo()
	}

	if (WebServerAppURL=="") return;
	alert(WebServerAppURL);
	var url=WebServerAppURL+"/csp/dhcmed.ninf.aim.centertablistdetail.csp?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&PrintDocID="+PrintDocID+"&TemplateDocID="+TemplateDocID+"&ChartItemID="+ChartItemID+"&InstanceDataID=&EPRNum="
	var objWin = new Ext.Window(
		{
			title:"横断面调查",
			html:'<iframe width=800 height=600 scrollbars=no src='+ url + '></iframe>',
			height:650,
			width:852
		}
	);
	objWin.on('close', function(){
		
		var objInterface= ExtTool.StaticServerObject("DHCMed.NINFService.Aim.Interface");

		var flg=objInterface.SyncDataEPRByEpisodeID(HDMProjectID,EpisodeID)

		if(flg<0) return;
		obj.grdPatAdmListStore.removeAt(rowIndex);
		//obj.grdPatAdmListStore.load({params : {start:0,limit:100}});
	  obj.grdPatAdmRepListStore.removeAll();
	});
	objWin.show();

}

function ShowEPRReport()
{
	var objClass = ExtTool.StaticServerObject("DHCMed.NINFService.Aim.ICUSrv");
	var WebServerAppURL=""
	if (objClass) {
		WebServerAppURL=objClass.GetServerInfo()
	}

	if (WebServerAppURL=="") return;
	
	var strUrl = WebServerAppURL + "/csp/dhceprredirect.csp?EpisodeID="+EpisodeID;
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
	var objClass = ExtTool.StaticServerObject("DHCMed.NINFService.Aim.ICUSrv");
	var WebServerAppURL=""
	if (objClass) {
		WebServerAppURL=objClass.GetServerInfo()
	}

	if (WebServerAppURL=="") return;
	
	var strUrl = WebServerAppURL + "/csp/dhcmed.ninf.aim.looklibresult.csp?paadmdr="+EpisodeID;
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