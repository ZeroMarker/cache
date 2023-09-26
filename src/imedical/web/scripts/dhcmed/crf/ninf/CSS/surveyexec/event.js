function InitViewport1Event(obj) {
	obj.LoadEvent = function()
  	{
		obj.CurrRecRowID = "";
		obj.GridPanel.on("rowclick", obj.GridPanel_rowclick, obj);
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
		
		setTimeout('objScreen.btnQuery_click()',1000);
  	};
	
	obj.btnQuery_click = function()
	{
		obj.GridPanelStore.removeAll();
		obj.GridPanelStore.load({params : {start : 0,limit : 100}});
	};
	
	obj.GridPanel_rowclick = function(objGrid, intIndex)
	{
		var objRec = obj.GridPanel.getStore().getAt(intIndex);
		if (obj.CurrRecRowID == objRec.get("RowID")) {
			obj.CurrRecRowID = "";
			//obj.cboHospital.setValue('');
			obj.cboSurvMethod.setValue('');
			obj.dtFromDate.setValue('');
			obj.dtToDate.setValue('');
			obj.txtResume.setValue('');
   		} else {
			obj.CurrRecRowID = objRec.get("RowID");
			obj.cboHospital.setValue(objRec.get("SEHospDR"));
			obj.cboSurvMethod.setValue(objRec.get("SESurvMethodDR"));
			obj.dtFromDate.setValue(objRec.get("SESurvSttDate"));
			obj.dtToDate.setValue(objRec.get("SESurvEndDate"));
			obj.txtResume.setValue(objRec.get("SEResume"));
   		}
	};
	
	obj.btnSave_click = function()
	{
		var RowID = obj.CurrRecRowID;
		var HospitalID = obj.cboHospital.getValue();
		var SurvMethod = obj.cboSurvMethod.getValue();
		//Add By LiYang 2014-11-03 FixBug:3885医院感染管理-医院感染患病率调查-调查方法执行登记表-手动输入无效的日期（而不是在下拉框中选择日期），点击【更新】，提示“Error:illegal”
		if(!obj.dtFromDate.isValid())
		{
			ExtTool.alert('错误提示', '“开始日期”格式非法！');
			return;
		}
		if(!obj.dtToDate.isValid())
		{
			ExtTool.alert('错误提示', '“结束日期”格式非法！');
			return;
		}		
		var FromDate = obj.dtFromDate.getRawValue();
		var ToDate = obj.dtToDate.getRawValue();
		var Resume = obj.txtResume.getValue();
		if ((!HospitalID)||(!SurvMethod)||(!FromDate)) {
			ExtTool.alert('错误提示', '医院、调查方法、开始日期、结束日期不允许为空！');
			return;
		}
		if ((FromDate>ToDate)) {
			ExtTool.alert('错误提示', '开始日期不能大于结束日期');
			return;
		}
		var tmpList = HospitalID.split(',');
		for (var indHosp = 0; indHosp < tmpList.length; indHosp++) {
			var HospID = tmpList[indHosp];
			if (HospID == '') continue;
			
			var strInput = RowID;
			strInput += '^' + HospID;
			strInput += '^' + SurvMethod;
			strInput += '^' + FromDate;
			strInput += '^' + ToDate;
			strInput += '^' + session['LOGON.USERID'];
			strInput += '^' + Resume;
			
			try {
				objClass = ExtTool.StaticServerObject("DHCMed.NINF.CSS.SurveyExec");
				var ret = objClass.Update(strInput);
				if (parseInt(ret) > 0) {
					ExtTool.alert('提示', '保存成功！');
					obj.CurrRecRowID = ret;
				} else {
					ExtTool.alert('提示', '保存失败！');
					return;
				}
				obj.GridPanelStore.load({});
			} catch(err) {
				ExtTool.alert("错误提示", err.description, Ext.MessageBox.ERROR);
			}
		}
	};
}