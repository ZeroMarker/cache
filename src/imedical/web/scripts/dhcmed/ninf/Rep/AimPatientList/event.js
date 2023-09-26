
function InitViewportEvent(obj) {
	obj.ClsMapRepMdlSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.MapRepMdl");
	
	obj.LoadEvent = function(args)
    {
		var LogLocID = session['LOGON.CTLOCID'];
		var objCtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc")
		var objLoc = objCtlocSrv.GetObjById(LogLocID);
		if (objLoc) {
			if (obj.LogLocType == 'E') {
				obj.cboAdmLoc.setValue(objLoc.Rowid);
				obj.cboAdmLoc.setRawValue(objLoc.Descs);
				if (obj.AdminPower != '1') {
					obj.cboAdmLoc.setDisabled(true);
				}
			} else if (obj.LogLocType == 'W') {
				obj.cboAdmWard.setValue(objLoc.Rowid);
				obj.cboAdmWard.setRawValue(objLoc.Descs);
				if (obj.AdminPower != '1') {
					//obj.cboAdmWard.setDisabled(true);lxf 2012-08-09
				}
			} else {
				if (obj.AdminPower != '1') {
					obj.cboAdmLoc.setDisabled(true);
					//obj.cboAdmWard.setDisabled(true);lxf 2012-08-09
				}
			}
		}
		
		var ModuleList = obj.ClsMapRepMdlSrv.GetAimRepMdl(session['LOGON.CTLOCID']);
		var arrRepType = ModuleList.split('^');
		for (var indType = 0; indType < arrRepType.length; indType++) {
			switch (arrRepType[indType]) {
				case "UC" :
					obj.ReportQueryRootNode.appendChild(
						new Ext.tree.TreeNode({
							leaf: false
							, text: "导尿管信息查询"
							, id: "menuUC"
							, draggable: false
						})
					);
					break;
				case "PICC" :
					obj.ReportQueryRootNode.appendChild(
						new Ext.tree.TreeNode({
							leaf: false
							, text: "中央导管信息查询"
							, id: "menuPICC"
							, draggable: false
						})
					);
					break;
				case "VAP" :
					obj.ReportQueryRootNode.appendChild(
						new Ext.tree.TreeNode({
							leaf: false
							, text: "呼吸机信息查询"
							, id: "menuVAP"
							, draggable: false
						})
					);
					break;
				case "OPR" :
					obj.ReportQueryRootNode.appendChild(
						new Ext.tree.TreeNode({
							leaf: false
							, text: "手术部位信息查询"
							, id: "menuOPR"
							, draggable: false
						})
					);
					break;
				case "MDR" :
					obj.ReportQueryRootNode.appendChild(
						new Ext.tree.TreeNode({
							leaf: false
							, text: "多重耐药信息查询"
							, id: "menuMDR"
							, draggable: false
						})
					);
					break;
				case "NICU" :
					obj.ReportQueryRootNode.appendChild(
						new Ext.tree.TreeNode({
							leaf: false
							, text: "NICU-脐静脉信息查询"
							, id: "menuNUC"
							, draggable: false
						})
					);
					obj.ReportQueryRootNode.appendChild(
						new Ext.tree.TreeNode({
							leaf: false
							, text: "NICU-PICC信息查询"
							, id: "menuNPICC"
							, draggable: false
						})
					);
					obj.ReportQueryRootNode.appendChild(
						new Ext.tree.TreeNode({
							leaf: false
							, text: "NICU-气管插管信息查询"
							, id: "menuNVNT"
							, draggable: false
						})
					);
					break;
				default :
					break;
			}
			
		}
		
		obj.ReportQueryRootNode.appendChild(
						new Ext.tree.TreeNode({
							leaf: false
							, text: "院感监测统计表"
							, id: "menuIF"
							, draggable: false
						})
					);
					
		obj.btnAdmFind.on("click", obj.btnAdmFind_click, obj);
		obj.ShowInNewTab("./dhcmed.ninf.rep.welcomepage.csp");
		
		obj.PatientListTreePanel.on("dblclick",function(objNode){
			if(objNode == null) return;
			var args = objNode.id.split("-");
			switch(args[1])
			{
				case "AdmTrans":
					var arrId = args[0].split('||');
					if (arrId.length>=2) {
						obj.ShowInNewTab("./dhcmed.ninf.rep.aimreport.csp?1=1&EpisodeID=" + arrId[0] + "&TransID=" + args[0] + "&TransLoc=" + args[2] + "&2=2");
					}
					break;
				case "Adm":
					break;
				case "Loc":
					break;
				default:
					break;
			}
		},obj);
		
		obj.ReportQueryTreePanel.on("click",function(objNode){
			if(objNode == null) return;
			switch(objNode.id)
			{
				case "menuUC":
					obj.ShowInNewTab("./dhcmed.ninf.rep.aimreportqryuc.csp?AdminPower=" + obj.AdminPower);
					break;
				case "menuPICC":
					obj.ShowInNewTab("./dhcmed.ninf.rep.aimreportqrypicc.csp?AdminPower=" + obj.AdminPower);
					break;
				case "menuVAP":
					obj.ShowInNewTab("./dhcmed.ninf.rep.aimreportqryvap.csp?AdminPower=" + obj.AdminPower);
					break;
				case "menuOPR":
					obj.ShowInNewTab("./dhcmed.ninf.rep.aimreportqryopr.csp?AdminPower=" + obj.AdminPower);
					break;
				case "menuMDR":
					obj.ShowInNewTab("./dhcmed.ninf.rep.aimreportqrymdr.csp?AdminPower=" + obj.AdminPower);
					break;
				case "menuNUC":
					obj.ShowInNewTab("./dhcmed.ninf.rep.aimreportqrynuc.csp?AdminPower=" + obj.AdminPower);
					break;
				case "menuNVNT":
					obj.ShowInNewTab("./dhcmed.ninf.rep.aimreportqrynvnt.csp?AdminPower=" + obj.AdminPower);
					break;
				case "menuNPICC":
					obj.ShowInNewTab("./dhcmed.ninf.rep.aimreportqrynpicc.csp?AdminPower=" + obj.AdminPower);
					break;
				case "menuIF":
					obj.ShowInNewTab("./dhcmed.ninf.rep.aimicuinfoqry.csp?AdminPower=" + obj.AdminPower);
					break;
				default:
					break;
			}
		},obj);
  	}
	
	obj.btnAdmFind_click = function()
	{
		var objRootNode = obj.PatientListTreePanel.getRootNode();
		var objTreeLoader = obj.PatientListTreePanel.getLoader();
		objTreeLoader.baseParams.Arg1 = (obj.chkIPFlag.getValue() ? 'Y' : 'N');
		objTreeLoader.baseParams.Arg2 = obj.cboAdmLoc.getValue();
		objTreeLoader.baseParams.Arg3 = obj.cboAdmWard.getValue();
		objTreeLoader.baseParams.Arg4 = obj.txtRegNo.getValue() + '^' + obj.txtMrNo.getValue() + '^' + obj.txtPatName.getValue();
		objTreeLoader.baseParams.Arg5 = obj.TransType;
		objTreeLoader.baseParams.Arg6 = (obj.AdminPower != '1' ? session['LOGON.CTLOCID'] : '');
		objTreeLoader.load(objRootNode,function(){
			obj.PatientListTreePanel.expandAll();
		});
	}
	
	obj.ShowInNewTab = function(cspUrl)
	{
		var objFrame = document.getElementById("MainPanelFrame");
		if (objFrame) {
			objFrame.src = cspUrl;
		}
	}
}

