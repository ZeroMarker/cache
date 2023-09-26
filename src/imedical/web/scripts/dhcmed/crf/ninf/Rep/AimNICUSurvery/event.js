
function InitViewport1Event(obj) {
	obj.LoadEvent = function(args)
    {
		obj.dtSurveryYYMM.on("select",obj.NICUSurveryGrid_load,obj);
		obj.cboSurveryLoc.on("select",obj.NICUSurveryGrid_load,obj);
		obj.btnSave.on("click",obj.btnSave_click,obj);
		obj.cboSurveryLoc.on("expand", obj.cboSurveryLoc_OnExpand, obj);
		obj.btnExport.on("click",obj.btnExport_OnClick,obj)
		obj.btnExportMonth.on("click",obj.btnExportMonth_OnClick,obj)
		obj.cboSurveryLocStore.load({
			callback : function() {
				var LogLocID = session['LOGON.CTLOCID'];
				var ind = obj.cboSurveryLocStore.find("LocRowId",LogLocID);
				if (ind > -1) {
					var objCtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc")
					var objLoc = objCtlocSrv.GetObjById(LogLocID);
					if (objLoc) {
						obj.cboSurveryLoc.setValue(objLoc.Rowid);
						obj.cboSurveryLoc.setRawValue(objLoc.Descs);
					}
					obj.NICUSurveryGrid_load();
					
				}
			}
			,scope : obj.cboSurveryLocStore
			,add : false
		});
		obj.cboSurveryLoc.setDisabled((obj.AdminPower != '1'));
  	};
	
	obj.btnExport_OnClick = function()
	{
		var strFileName="新生儿病房日志";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.NICUSurveryGridPanel,strFileName);
	}
	
	obj.btnExportMonth_OnClick = function()
	{
		if(obj.dtSurveryYYMM.getRawValue()=="")
		{
			alert("年月不能为空！！");	
			return;
		}
		if(obj.cboSurveryLoc.getValue()=="")
		{
			alert("科室不能为空！！");
			return;
		}
		var cArguments=obj.dtSurveryYYMM.getRawValue()+"^"+obj.cboSurveryLoc.getValue();
		var flg=ExportDataToExcel("","","",cArguments);
	}
	
	obj.cboSurveryLoc_OnExpand = function()
	{
		//obj.cboSurveryLocStore.load({});
	}
	
	obj.NICUSurveryGrid_load = function()
	{
		if ((obj.dtSurveryYYMM.getRawValue()!='')&&(obj.cboSurveryLoc.getValue()!=''))
		{
			obj.NICUSurveryGridPanelStore.load({});
		}
	}
	
	obj.btnSave_click = function()
	{
		var errorInfo="";
		var objNICUSurvery = ExtTool.StaticServerObject("DHCMed.NINF.Rep.AimNICUSurvery");
		var objStore = obj.NICUSurveryGridPanel.getStore();
    	var objRec = null;
    	for (var indRec=0;indRec<objStore.getCount();indRec++)
    	{
    		objRec = objStore.getAt(indRec);
			if (objRec.dirty!=true) continue;   //只有某行记录值改变,才保存数据
    		
    		var ANISID = objRec.get("ANISID");              //调查日志ID
			var LocID = objRec.get("LocID");              //调查科室
			var SurveryDate = objRec.get("SurveryDate");  //调查日期
			var SurveryDay = objRec.get("SurveryDay");    //日期
			var ANISItem1 = objRec.get("ANISItem1");        //项目1
			var ANISItem2 = objRec.get("ANISItem2");        //项目2
			var ANISItem3 = objRec.get("ANISItem3");        //项目3
			var ANISItem4 = objRec.get("ANISItem4");        //项目4
			var ANISItem5 = objRec.get("ANISItem5");        //项目5
			var ANISItem6 = objRec.get("ANISItem6");        //项目6
			var ANISItem7 = objRec.get("ANISItem7");        //项目7
			var ANISItem8 = objRec.get("ANISItem8");        //项目8
			var ANISItem9 = objRec.get("ANISItem9");        //项目9
			var ANISItem10 = objRec.get("ANISItem10");      //项目10
			var ANISItem11 = objRec.get("ANISItem11");        //项目5
			var ANISItem12 = objRec.get("ANISItem12");        //项目6
			var ANISItem13 = objRec.get("ANISItem13");        //项目7
			var ANISItem14 = objRec.get("ANISItem14");        //项目8
			var ANISItem15 = objRec.get("ANISItem15");        //项目9
			var ANISItem16 = objRec.get("ANISItem16");      //项目10
			
			var InputStr = ANISID;
			InputStr = InputStr + "^" + LocID;
			InputStr = InputStr + "^" + SurveryDate;
			InputStr = InputStr + "^" + ANISItem1;
			InputStr = InputStr + "^" + ANISItem2;
			InputStr = InputStr + "^" + ANISItem3;
			InputStr = InputStr + "^" + ANISItem4;
			InputStr = InputStr + "^" + ANISItem5;
			InputStr = InputStr + "^" + ANISItem6;
			InputStr = InputStr + "^" + ANISItem7;
			InputStr = InputStr + "^" + ANISItem8;
			InputStr = InputStr + "^" + ANISItem9;
			InputStr = InputStr + "^" + ANISItem10;
			InputStr = InputStr + "^" + ANISItem11;
			InputStr = InputStr + "^" + ANISItem12;
			InputStr = InputStr + "^" + ANISItem13;
			InputStr = InputStr + "^" + ANISItem14;
			InputStr = InputStr + "^" + ANISItem15;
			InputStr = InputStr + "^" + ANISItem16;
			InputStr = InputStr + "^" + session['LOGON.USERID'];
			
			var rtn = objNICUSurvery.Update(InputStr,"^");
    		if (parseInt(rtn) < 0)
    		{
				errorInfo = errorInfo + SurveryDay + "号 "
    		}
    	}
		if (errorInfo!='')
		{
			alert("错误提示:" + errorInfo + "数据有误!");
		} else {
			obj.NICUSurveryGrid_load();
		}
    	return true;
	}
}

