
function InitViewportEvent(obj) {
	obj.LoadEvent = function(args)
    {/*
		var LogLocID = session['LOGON.CTLOCID'];
		var objCtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc");
		var objLoc = objCtlocSrv.GetObjById(LogLocID);
		if (objLoc) {
			obj.cboLoc.setValue(objLoc.Rowid);
			obj.cboLoc.setRawValue(objLoc.Descs);
			if (obj.AdminPower != '1') {
				obj.cboLoc.setDisabled(true);
			}
		}*/
		var objCtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc");
		var objLoc = obj.CtlocSrv.GetObjById(session['LOGON.CTLOCID']);
		if (obj.AdminPower != '1') {
			obj.cboLoc.setDisabled(true);
			var LogLocID = session['LOGON.CTLOCID'];
			var objCtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc")
			var objLoc = objCtlocSrv.GetObjById(LogLocID);
			if (objLoc) {
				obj.cboLoc.setValue(objLoc.Rowid);
				obj.cboLoc.setRawValue(objLoc.Descs);
			}
		}
		
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
		obj.btnExport.on("click", obj.btnExport_click, obj);
		obj.QueryGridPanel.on("rowdblclick", obj.QueryGridPanel_rowdblclick, obj);
		
		obj.chkIsCommit.on('check',function(checkbox,value){
			obj.cboDateType.setDisabled(value);
			obj.txtDateFrom.setDisabled(value);
			obj.txtDateTo.setDisabled(value);
		});
  	}
	
	obj.btnQuery_click = function()
	{
		obj.QueryGridPanelStore.removeAll();
		obj.QueryGridPanelStore.load({});
	}
	
	obj.btnExport_click = function(){
		if (obj.QueryGridPanel.getStore().getCount() > 0)
		{
			var strFileName="导尿管信息查询";
			var objExcelTool=Ext.dhcc.DataToExcelTool;
			objExcelTool.ExprotGrid(obj.QueryGridPanel,strFileName);
		} else {
			ExtTool.alert("提示","查询列表数据为空!");
		}
	}
	
	obj.QueryGridPanel_rowdblclick = function(objGrid, rowIndex)
	{
		var record = objGrid.getStore().getAt(rowIndex);
		var ReportID = record.get("ReportID");
		var arrID = ReportID.split("||");
		
		var strUrl = "./dhcmed.ninf.rep.aimreport.csp?1=1&ReportID=" + arrID[0] + "&ModuleList=UC&2=2";
		
		var r_width = 800;
		var r_height = 500;
		var v_left = (window.screen.availWidth - 10 - r_width) / 2;		// 获得窗口的水平位置;
		var v_top = (window.screen.availHeight - 30 - r_height) / 2;	// 获得窗口的垂直位置;
		var r_params = "left=" + v_left +
						",top=" + v_top + 
						",width=" + r_width + 
						",height=" + r_height + 
						",status=yes,toolbar=no,menubar=no,location=no";
		window.open(strUrl, "_blank", r_params);
	}
}

