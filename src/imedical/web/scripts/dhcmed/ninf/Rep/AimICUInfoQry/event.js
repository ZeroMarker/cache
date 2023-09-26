﻿
function InitViewportEvent(obj) {
	obj.LoadEvent = function(args)
    {
		if (obj.AdminPower != '1') {
			var LogWardID = session['LOGON.WARDID'];
			
			if(LogWardID !="") obj.cboLoc.setDisabled(true);
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
  	}
	
	obj.btnQuery_click = function()
	{
		obj.QueryGridPanelStore.removeAll();
		obj.QueryGridPanelStore.load({});
	}
	
	obj.btnExport_click = function(){
		if (obj.QueryGridPanel.getStore().getCount() > 0)
		{
			var strFileName="ICU信息汇总表";
			var objExcelTool=Ext.dhcc.DataToExcelTool;
			objExcelTool.ExprotGrid(obj.QueryGridPanel,strFileName);
		} else {
			ExtTool.alert("提示","查询列表数据为空!");
		}
	}
}

