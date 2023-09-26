
function InitViewport1Event(obj) {
	obj.LoadEvent = function(args)
    {
		obj.dtGradeYYMM.on("select",obj.ICUGradeGrid_load,obj);
		obj.cboGradeLoc.on("select",obj.ICUGradeGrid_load,obj);
		obj.btnSave.on("click",obj.btnSave_click,obj);
		obj.cboGradeLoc.on("expand", obj.cboGradeLoc_OnExpand, obj);
		obj.btnExport.on("click",obj.btnExport_OnClick,obj)
		
		obj.cboGradeLocStore.load({
			callback : function() {
				var LogLocID = session['LOGON.CTLOCID'];
				var ind = obj.cboGradeLocStore.find("LocRowId",LogLocID);
				if (ind > -1) {
					var objCtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc")
					var objLoc = objCtlocSrv.GetObjById(LogLocID);
					if (objLoc) {
						obj.cboGradeLoc.setValue(objLoc.Rowid);
						obj.cboGradeLoc.setRawValue(objLoc.Descs);
					}
					obj.ICUGradeGrid_load();
				}
			},
			scope : obj.cboGradeLocStore,
			add : false
		});
		obj.cboGradeLoc.setDisabled((obj.AdminPower != '1'));
  	};
	
	obj.btnExport_OnClick = function()
	{
		var strFileName="ICU临床病情等级调查";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.ICUGradeGridPanel,strFileName);
	}
	
	obj.cboGradeLoc_OnExpand = function()
	{
		//obj.cboGradeLocStore.load({});
	}
	
	obj.ICUGradeGrid_load = function()
	{
		if ((obj.dtGradeYYMM.getRawValue()!='')&&(obj.cboGradeLoc.getValue()!=''))
		{
			obj.ICUGradeGridPanelStore.load({});
		}
	}
	
	obj.btnSave_click = function()
	{
		var errorInfo="";
		var objICUGrade = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.AimICUGrade");
		var objStore = obj.ICUGradeGridPanel.getStore();
		for (var indRow=1;indRow<=4;indRow++)
		{
			var objRec = null;
			var InputStr = "";
	    	for (var indRec=0;indRec<5;indRec++)
	    	{
	    		objRec = objStore.getAt(indRec);
				var AIGItem = objRec.get("AIGItem" + indRow);     //项目值
				if (indRec>0){
					InputStr = InputStr + "^" + AIGItem;
				} else {
					var AIGLocID = objRec.get("AIGLocID");        //调查科室
					var AIGYear = objRec.get("AIGYear");          //调查年
					var AIGMonth = objRec.get("AIGMonth");        //调查月
					InputStr = InputStr + "^" + AIGLocID;
					InputStr = InputStr + "^" + AIGYear;
					InputStr = InputStr + "^" + AIGMonth;
					InputStr = InputStr + "^" + indRow;
					InputStr = InputStr + "^" + AIGItem;
				}
	    	}
	    	InputStr = InputStr + "^" + session['LOGON.USERID'];
			var rtn = objICUGrade.SaveRec(InputStr,"^");
			if (parseInt(rtn) < 0)
			{
				errorInfo = errorInfo + "第" + indRow + "周数据错误!"
			}
		}
    	if (errorInfo!=''){
			alert("错误提示:" + errorInfo);
		} else {
			obj.ICUGradeGrid_load();
		}
    	return true;
	}
}

