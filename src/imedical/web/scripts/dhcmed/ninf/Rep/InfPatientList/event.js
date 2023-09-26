
function InitViewportEvent(obj) {
	obj.LoadEvent = function(args)
    {
	    obj.cboSSHosp.on('expand',obj.cboSSHosp_expand,obj);
		obj.cboSSHosp.on('select',obj.cboSSHosp_Select,obj);
		obj.cboAdmLoc.on('expand',obj.cboAdmLoc_expand,obj);
		obj.cboAdmLoc.on('select',obj.cboAdmLoc_Select,obj);
		obj.cboAdmWard.on('expand',obj.cboAdmWard_expand,obj);
		obj.txtRegNo.on('specialkey',obj.txtRegNo_specialkey,obj);
		/*
		var LogLocID = session['LOGON.CTLOCID'];
		var objCtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc")
		var objLoc = objCtlocSrv.GetObjById(LogLocID);
		if (objLoc) {
			if (obj.LogLocType == 'E') {
				//update by zf 20130318
				var objStore = obj.cboAdmLoc.getStore();
				objStore.load({
					callback : function() {
						var ind = this.find("LocRowId",LogLocID);
						if (ind > -1) {
							obj.cboAdmLoc.setValue(objLoc.Rowid);
							obj.cboAdmLoc.setRawValue(objLoc.Descs);  
						}
					}
					,scope : objStore
					,add : false
				});
				if (obj.AdminPower != '1') {
					obj.cboAdmLoc.setDisabled(true);
				}
			} else if (obj.LogLocType == 'W') {
				//update by zf 20130318
				var objStore = obj.cboAdmWard.getStore();
				objStore.load({
					callback : function() {
						var ind = this.find("LocRowId",LogLocID);
						if (ind > -1) {
							obj.cboAdmWard.setValue(objLoc.Rowid);
							obj.cboAdmWard.setRawValue(objLoc.Descs1);
						}
					}
					,scope : objStore
					,add : false
				});
				if (obj.AdminPower != '1') {
					obj.cboAdmWard.setDisabled(true);
				}
			} else {
				if (obj.AdminPower != '1') {
					obj.cboAdmLoc.setDisabled(true);
					obj.cboAdmWard.setDisabled(true);
				}
			}
		}
	*/
		obj.btnAdmFind.on("click", obj.btnAdmFind_click, obj);
		obj.ShowInNewTab("./dhcmed.ninf.rep.welcomepage.csp");
		
		obj.PatientListTreePanel.on("click",function(objNode){
			if(objNode == null) return;
			var args = objNode.id.split("-");
			switch(args[1])
			{
				case "AdmTrans":
					var arrId = args[0].split('||');
					if (arrId.length>=2) {
						//obj.ShowInNewTab("./dhcmed.ninf.clinrepview.csp?1=1&EpisodeID=" + arrId[0] + "&TransID=" + args[0] + "&TransLoc=" + args[2] + "&AdminPower=" + obj.AdminPower + "&ConfigCode=" + GetParam(window,"ConfigCode") + "&2=2");
						//obj.ShowInNewTab("./dhcmed.ss.clinreptoadm.csp?1=1&EpisodeID=" + arrId[0]);
						obj.ShowInNewTab("./dhcmed.ninf.clinrepview.csp?1=1&EpisodeID=" + arrId[0] + "&DoctorFlag=D" + "&SubjectCode=" + GetParam(window,"ConfigCode") + "&2=2");
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
  	}
	obj.cboSSHosp_expand=function(){
	    obj.cboAdmLoc.setValue('');
	    obj.cboAdmWard.setValue('');
	}
	obj.cboSSHosp_Select=function(){
		obj.cboAdmWard.setValue('');
		obj.cboAdmLoc.getStore().load({}); 
	}
	obj.cboAdmLoc_expand=function () {
		obj.cboAdmWard.setValue('');		
	}
	obj.cboAdmLoc_Select=function () {
		obj.cboAdmWard.getStore().load({});	
	}
	//add by likai for bug:3954
	obj.cboAdmWard_expand=function () {
		obj.cboAdmWard.clearValue();
		obj.cboAdmWard.getStore().load({});		
	}
	obj.btnAdmFind_click = function()
	{
		var objRootNode = obj.PatientListTreePanel.getRootNode();
		var objTreeLoader = obj.PatientListTreePanel.getLoader();
		var cboAdmLoc = obj.cboAdmLoc.getValue();
		var cboAdmWard = obj.cboAdmWard.getValue();
		var txtRegNo = obj.txtRegNo.getValue();
		var txtMrNo = obj.txtMrNo.getValue();
		var txtPatName= obj.txtPatName.getValue();
		if (!cboAdmLoc&&!cboAdmWard&&!txtRegNo&&!txtMrNo&&!txtPatName) {
			ExtTool.alert("错误提示","请选择查询条件");
			return ;
		} 
		objTreeLoader.baseParams.Arg1 = (obj.chkIPFlag.getValue() ? 'Y' : 'N');
		objTreeLoader.baseParams.Arg2 = cboAdmLoc;
		objTreeLoader.baseParams.Arg3 = cboAdmWard;
		objTreeLoader.baseParams.Arg4 = txtRegNo+"^"+txtMrNo+"^"+txtPatName;
		objTreeLoader.baseParams.Arg5 = obj.TransType;
		objTreeLoader.baseParams.Arg6 = (obj.AdminPower != '1' ? session['LOGON.CTLOCID'] : '');
		objTreeLoader.baseParams.Arg7 = obj.cboSSHosp.getValue();

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
	obj.txtRegNo_specialkey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		var xRegNo=obj.txtRegNo.getValue();
		var FormRegNo=ExtTool.StaticServerObject("DHCMed.Base.CommFunSrv");
		var aRegNo=FormRegNo.RegNoCon(xRegNo);
		obj.txtRegNo.setValue(aRegNo);
		obj.btnAdmFind_click();
	}
}

