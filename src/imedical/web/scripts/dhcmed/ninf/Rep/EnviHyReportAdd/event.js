function InitViewport1Event(obj) {
	//加载类方法
	obj.CtlocSrv = ExtTool.StaticServerObject("DHCMed.Base.Ctloc");
	obj.ClsRepEnviHyReportAdd = ExtTool.StaticServerObject("DHCMed.NINF.Rep.EnviHyReportAdd");
	obj.LoadEvent = function(args)
    {
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
		/*
		var objLoc = obj.CtlocSrv.GetObjById(session['LOGON.CTLOCID']);
		Common_SetValue("cboLoc",objLoc.Rowid,objLoc.Descs); 
		obj.cboLoc.setDisabled("true"); 
		*/
	    obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.gridEnviHyRepAdd.on("rowclick",obj.gridEnviHyRepAdd_rowclick,obj);
		obj.gridEnviHyRepAddStore.load({params : {start : 0,limit : 50}});
		
  	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("cboItem","");
		Common_SetValue("txtItemValue","","");
		Common_SetValue("cboUom","","");
		Common_SetValue("txtResume","","");
	}
	
	obj.btnQuery_click = function()
	{
		obj.gridEnviHyRepAddStore.load({params : {start : 0,limit : 50}});
	}
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var txtDate = Common_GetValue("txtDate");
		var cboLoc = Common_GetValue("cboLoc");
		var cboItem = Common_GetValue("cboItem");
		var txtItemValue = Common_GetValue("txtItemValue");
		var cboUom = Common_GetValue("cboUom");
		var txtResume = Common_GetValue("txtResume");
		if (!txtDate) {
			errinfo = errinfo + "日期为空!<br>";
		}
		//add by likai for bug:3874
		if (txtDate) {
			
			var today = new Date();
			var CurrDate = today.getYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate();
			var flg = Common_CompareDate(txtDate,CurrDate);
			if (!flg) errinfo = errinfo + '检测日期大于当前日期!<br>'
		}
		
		if (!cboLoc) {
			errinfo = errinfo + "科室为空!<br>";
		}
		if (!cboItem) {
			errinfo = errinfo + "检测项目为空!<br>";
		}
		if (!txtItemValue) {
			errinfo = errinfo + "项目值为空!<br>";
		}
		if (!cboUom) {
			errinfo = errinfo + "单位为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + txtDate;
		inputStr = inputStr + CHR_1 + cboLoc;
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + cboItem;
		inputStr = inputStr + CHR_1 + txtItemValue;
		inputStr = inputStr + CHR_1 + cboUom;
		inputStr = inputStr + CHR_1 + txtResume;
		var flg = obj.ClsRepEnviHyReportAdd.Update(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				ExtTool.alert("错误提示","数据重复!Error=" + flg);
			} else {
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			}
			return;
		}
		
		obj.ClearFormItem();
		Common_LoadCurrPage("gridEnviHyRepAdd");
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridEnviHyRepAdd");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.ClsRepEnviHyReportAdd.DeleteById(objRec.get("RepAddID"));
							if (parseInt(flg) <= 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
								obj.ClearFormItem();
								//objGrid.getStore().remove(objRec);
								obj.btnQuery_click();//Modified By LiYang 2014-07-05 医院感染管理-环境卫生学监测-科室其它项目-删除记录后，界面右下角【显示记录】和【合计】没有自动刷新
							}
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}

	obj.gridEnviHyRepAdd_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridEnviHyRepAdd.getStore().getAt(index);
		if (objRec.get("RepAddID") == obj.RecRowID) {
			obj.ClearFormItem();
			obj.btnDelete.setDisabled(true);
		} else {
			obj.RecRowID = objRec.get("RepAddID");
			Common_SetValue("txtDate",objRec.get("aDate"));
			Common_SetValue("cboLoc",objRec.get("LocID"),objRec.get("LocDesc"));
			Common_SetValue("cboItem",objRec.get("RepItemID"),objRec.get("RepItemDesc"));
			Common_SetValue("txtItemValue",objRec.get("RepValue"));
			Common_SetValue("cboUom",objRec.get("RepUomID"),objRec.get("RepUomDesc"));
			Common_SetValue("txtResume",objRec.get("Resume"));
			obj.btnDelete.setDisabled(false);
		}
	}
}

