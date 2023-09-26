
function InitViewport1Event(obj) {
	//加载类方法
	obj.intCurrRowIndex = -1;
	obj.ClsRepHandHyReportSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Rep.HandHyReport");
	
	obj.LoadEvent = function(args)
    {
		if (obj.AdminPower != '1') {
			Common_SetValue('cboObsLoc',LogonLocID,LogonLocDesc);
			Common_SetValue('cboObsUser',LogonUserID,LogonUserDesc);
			Common_SetDisabled('cboObsLoc',true);
			Common_SetDisabled('cboObsUser',true);
		} else {
			//Common_SetValue('cboObsLoc',LogonLocID,LogonLocDesc);
			Common_SetValue('cboObsUser',LogonUserID,LogonUserDesc);
			Common_SetDisabled('cboObsLoc',false);
			Common_SetDisabled('cboObsUser',false);
		}
		
		obj.btnQuery.on("click",obj.btnQuery_click,obj);
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.gridHandHyReport.on("rowclick",obj.gridHandHyReport_rowclick,obj);
		
		obj.gridHandHyReportStore.load({params : {start : 0,limit : 100}});
  	};
	
	obj.btnQuery_click = function() {
		obj.gridHandHyReportStore.removeAll();
		obj.gridHandHyReportStore.load({params : {start : 0,limit : 100}});
	}
	
	obj.ClearFormItem = function()
	{
		Common_SetValue("cbgStIdentity","");
		Common_SetValue("txtStName","");
		Common_SetValue("cbgPoint","","");
		Common_SetValue("cbgAction","","");
		Common_SetValue("cbgActionRit","","");
		Common_SetValue("txtResume","");
	}
	
	obj.btnUpdate_click = function() {
		var ObsLocID = Common_GetValue('cboObsLoc');
		var ObsDate = Common_GetValue('txtObsDate');
		var ObsUserID = Common_GetValue('cboObsUser');
		var StIdentity = Common_GetValue('cbgStIdentity');
		var StName = Common_GetText('txtStName');
		var Point = Common_GetValue('cbgPoint');
		var Action = Common_GetValue('cbgAction');
		var ActionDesc = Common_GetText('cbgAction');
		var ActionRit = Common_GetValue('cbgActionRit');
		var Resume = Common_GetValue('txtResume');
		
		var errInfo = '';
		if (ObsLocID == '') {
			errInfo = errInfo + '科室为空!<br>'
		}
		if (ObsDate == '') {
			errInfo = errInfo + '日期为空!<br>'
		}
		if (ObsUserID == '') {
			errInfo = errInfo + '观察员为空!<br>'
		}
		if (StIdentity == '') {
			errInfo = errInfo + '专业为空!<br>'
		}
		if (StName == '') {
			errInfo = errInfo + '工号/姓名为空!<br>'
		}
		if (Point == '') {
			errInfo = errInfo + '手卫生指针为空!<br>'
		}
		if (Action == '') {
			errInfo = errInfo + '手卫生措施为空!<br>'
		}
		if (ActionDesc != '未处理') {
			if (ActionRit == '') {
				errInfo = errInfo + '洗手正确性为空!<br>'
			}
		}
		if (errInfo != '') {
			ExtTool.alert("提示",errInfo);
			return;
		}
		var inputStr = obj.RecRowID;
		inputStr += strRowID + "^";
		inputStr = inputStr + CHR_1 + ObsLocID;
		inputStr = inputStr + CHR_1 + ObsDate;
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + ObsUserID;
		inputStr = inputStr + CHR_1 + StIdentity;
		inputStr = inputStr + CHR_1 + '';
		inputStr = inputStr + CHR_1 + StName;
		inputStr = inputStr + CHR_1 + Point;
		inputStr = inputStr + CHR_1 + Action;
		inputStr = inputStr + CHR_1 + ActionRit;
		inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
		inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
		inputStr = inputStr + CHR_1 + 1;
		inputStr = inputStr + CHR_1 + Resume;
		//alert(inputStr);
		var  flg = obj.ClsRepHandHyReportSrv.SaveRepRec(inputStr,CHR_1);
		if (parseInt(flg)<=0) {
			ExtTool.alert("提示","保存数据失败!Error=" + flg);
			return false;
		} else {
			obj.ClearFormItem();
			Common_LoadCurrPage("gridHandHyReport");
		}
	}
	
	obj.btnDelete_click = function() {
		var objGrid = Ext.getCmp("gridHandHyReport");
		if (objGrid){
			var objRecArr = objGrid.getSelectionModel().getSelections();
			if (objRecArr.length>0){
				Ext.MessageBox.confirm('删除', '是否【删除】选中数据记录?', function(btn,text){
					if (btn=="yes") {
						for (var indRec = 0; indRec < objRecArr.length; indRec++){
							var objRec = objRecArr[indRec];
							var inputStr = objRec.get('ReportID');
							inputStr = inputStr + CHR_1 + session['LOGON.CTLOCID'];
							inputStr = inputStr + CHR_1 + session['LOGON.USERID'];
							inputStr = inputStr + CHR_1 + '0';
							inputStr = inputStr + CHR_1 + text;
							var flg = obj.ClsRepHandHyReportSrv.SaveRepStatus(inputStr,CHR_1);
						}
						Common_LoadCurrPage("gridHandHyReport");
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击【删除】!");
			}
		}
	}
	//update by likai
	obj.gridHandHyReport_rowclick = function() {
		var index=arguments[1];
		var objRec = obj.gridHandHyReport.getStore().getAt(index);
		if (objRec.get("ReportID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("ReportID");
			Common_SetValue("cboObsLoc",objRec.get("ObsLocID"),objRec.get("ObsLocDesc"));
			Common_SetValue("txtObsDate",objRec.get("ObsDate"));
			Common_SetValue("cboObsUser",objRec.get("ObsUserID"),objRec.get("ObsUserDesc"));
			Common_SetValue("cbgStIdentity",objRec.get("StIdentityDesc"));
			Common_SetValue("txtStName",objRec.get("StName"));    
			Common_SetValue("cbgPoint",objRec.get("PointDesc"));
			Common_SetValue("cbgAction",objRec.get("ActionDesc"));
			Common_SetValue("cbgActionRit",objRec.get("ActionRitDesc"));
			Common_SetValue("txtResume",objRec.get("RepResume"));
		
		}
	}
}

