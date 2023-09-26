
function InitViewport1Event(obj) {
	obj.LoadEvent = function(args)
    {
		obj.dtSurveryYYMM.on("select",obj.ICUSurveryGrid_load,obj);
		obj.cboSurveryLoc.on("select",obj.ICUSurveryGrid_load,obj);
		obj.btnSave.on("click",obj.btnSave_click,obj);
		obj.cboSurveryLoc.on("expand", obj.cboSurveryLoc_OnExpand, obj);
		obj.btnExport.on("click",obj.btnExport_OnClick,obj)
		obj.btnInitData.on("click",obj.btnInitData_OnClick,obj)
		
    	obj.cboSSHosp.on('expand',obj.cboSSHosp_expand,obj);
		obj.cboSSHosp.on('select',obj.cboSSHosp_Select,obj);
		/*
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
					obj.ICUSurveryGrid_load();
				}
			}
			,scope : obj.cboSurveryLocStore
			,add : false
		});
		obj.cboSurveryLoc.setDisabled((obj.AdminPower != '1'));
		*/
  	};
	
	//add by yanjf 20140417
    obj.cboSSHosp_expand=function(){
	    obj.cboSurveryLoc.setValue('');
	}
	obj.cboSSHosp_Select=function(){
	    obj.cboSurveryLoc.getStore().load({}); 
	}
	
	obj.btnInitData_OnClick = function()
	{
		var aMonth = obj.dtSurveryYYMM.getRawValue();
		var aLoc = obj.cboSurveryLoc.getValue();
		var aLocDesc = obj.cboSurveryLoc.getRawValue();
		var aHospId = obj.cboSSHosp.getValue();
		if ((aMonth == '')||(aLoc == '')) {
			ExtTool.alert("提示",'年月与科室不能为空!');
			return;
		}
		
		Ext.MessageBox.confirm('提示', '是否初始化"ICU患者日志"数据?', function(btn,text){
			if (btn=="yes") {
				//创建进度条
				Ext.MessageBox.progress('提示', '开始初始化"ICU患者日志"数据...');
				
				//更新进度条
				Ext.MessageBox.updateProgress(0.3, '', "正在处理：" + aLocDesc + " " + aMonth + "数据!");
				
				var objICUSurvery = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.AimICUSurvery");
				var flg = objICUSurvery.LogDataProcess(aMonth,aLoc);
				if (flg != 'OK') {
					ExtTool.alert("提示",'初始化"ICU患者日志"数据失败!');
					return;
				} else {
					obj.ICUSurveryGrid_load();
				}
				
				//关闭进度条
				Ext.MessageBox.hide();
			}
		});
	}
	
	obj.btnExport_OnClick = function()
	{
		var strFileName="ICU调查日志";
		var objExcelTool=Ext.dhcc.DataToExcelTool;
		objExcelTool.ExprotGrid(obj.ICUSurveryGridPanel,strFileName);
	}
	/*
	obj.cboSurveryLoc_OnExpand = function()
	{
		obj.cboSurveryLocStore.load({});
	}
	*/
	obj.ICUSurveryGrid_load = function()
	{
		if ((obj.dtSurveryYYMM.getRawValue()!='')&&(obj.cboSurveryLoc.getValue()!=''))
		{
			obj.ICUSurveryGridPanelStore.load({});
		}
	}
	
	obj.btnSave_click = function()
	{
		var errorInfo="";
		var objICUSurvery = ExtTool.StaticServerObject("DHCMed.NINF.Rep.AimICUSurvery");
		var objStore = obj.ICUSurveryGridPanel.getStore();
    	var objRec = null;
    	for (var indRec=0;indRec<objStore.getCount();indRec++)
    	{
    		objRec = objStore.getAt(indRec);
			if (objRec.dirty!=true) continue;   //只有某行记录值改变,才保存数据
    		
    		var AISID = objRec.get("AISID");              //调查日志ID
			var LocID = objRec.get("LocID");              //调查科室
			var SurveryDate = objRec.get("SurveryDate");  //调查日期
			var SurveryDay = objRec.get("SurveryDay");    //日期
			var AISItem1 = objRec.get("AISItem1");        //项目1
			var AISItem2 = objRec.get("AISItem2");        //项目2
			var AISItem3 = objRec.get("AISItem3");        //项目3
			var AISItem4 = objRec.get("AISItem4");        //项目4
			var AISItem5 = objRec.get("AISItem5");        //项目5
			var AISItem6 = objRec.get("AISItem6");        //项目6
			var AISItem7 = objRec.get("AISItem7");        //项目7
			var AISItem8 = objRec.get("AISItem8");        //项目8
			var AISItem9 = objRec.get("AISItem9");        //项目9
			var AISItem10 = objRec.get("AISItem10");      //项目10
			var AISItem11 = objRec.get("AISItem11");      //项目11
			var AISItem12 = objRec.get("AISItem12");      //项目12
			var AISItem13 = objRec.get("AISItem13");      //项目13
			var AISItem14 = objRec.get("AISItem14");      //项目14
			var AISItem15 = objRec.get("AISItem15");      //项目15
			var AISItem16 = objRec.get("AISItem16");      //项目16
			var AISItem17 = objRec.get("AISItem17");      //项目17
			var AISItem18 = objRec.get("AISItem18");      //项目18
			var AISItem19 = objRec.get("AISItem19");      //项目19
			var AISItem20 = objRec.get("AISItem20");      //项目20
			
			var InputStr = AISID;
			InputStr = InputStr + "^" + LocID;
			InputStr = InputStr + "^" + SurveryDate;
			InputStr = InputStr + "^" + AISItem1;
			InputStr = InputStr + "^" + AISItem2;
			InputStr = InputStr + "^" + AISItem3;
			InputStr = InputStr + "^" + AISItem4;
			InputStr = InputStr + "^" + AISItem5;
			InputStr = InputStr + "^" + AISItem6;
			InputStr = InputStr + "^" + AISItem7;
			InputStr = InputStr + "^" + AISItem8;
			InputStr = InputStr + "^" + AISItem9;
			InputStr = InputStr + "^" + AISItem10;
			InputStr = InputStr + "^" + session['LOGON.USERID'];
			InputStr = InputStr + "^" + AISItem11;
			InputStr = InputStr + "^" + AISItem12;
			InputStr = InputStr + "^" + AISItem13;
			InputStr = InputStr + "^" + AISItem14;
			InputStr = InputStr + "^" + AISItem15;
			InputStr = InputStr + "^" + AISItem16;
			InputStr = InputStr + "^" + AISItem17;
			InputStr = InputStr + "^" + AISItem18;
			InputStr = InputStr + "^" + AISItem19;
			InputStr = InputStr + "^" + AISItem20;
			
			var rtn = objICUSurvery.Update(InputStr,"^");
    		if (parseInt(rtn) < 0)
    		{
				errorInfo = errorInfo + SurveryDay + "号 "
    		}
    	}
		if (errorInfo!='')
		{
			alert("错误提示:" + errorInfo + "数据有误!");
		} else {
			obj.ICUSurveryGrid_load();
		}
    	return true;
	}
}

