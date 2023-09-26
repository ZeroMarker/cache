function InitPathWaySyndWindowEvent(obj) {
	// obj.SyndromeServer
	obj.LoadEvent = function(args) {
		obj.SyndInfo_Load();
		obj.cboCompl1.on("select", obj.Combobox1_Select, obj);
		obj.cboCompl2.on("select", obj.Combobox2_Select, obj);
		obj.btnSyndUpdate.on("click", obj.btnSyndUpdate_OnClick, obj);
		obj.btnSyndClose.on("click", obj.btnSyndClose_OnClick, obj);
	};
	
	obj.SyndInfo_Load = function() {
		var SyndString = obj.SyndromeServer.GetSyndInfoByCPWID(obj.PathWayID);
		var SyndArray = SyndString.split("^");
		if (SyndArray[0]=="") {
			obj.cboCompl1.setValue('Y');
			obj.cboCompl2.setValue('Y');
			obj.txtCompl1.setValue('');
			obj.txtCompl2.setValue('');
		} else {
			obj.txtCompl1.setValue(SyndArray[1]);
			obj.txtCompl2.setValue(SyndArray[2]);
			if (SyndArray[1]=="") {
				obj.cboCompl1.setValue('N');
				obj.txtCompl1.setDisabled(true);
			} else {
				obj.cboCompl1.setValue('Y');
				obj.txtCompl1.setDisabled(false);
			}
			if (SyndArray[2]=="") {
				obj.cboCompl2.setValue('N');
				obj.txtCompl2.setDisabled(true);
			} else {
				obj.cboCompl2.setValue('Y');
				obj.txtCompl2.setDisabled(false);
			}
		}
	}
	
	obj.Combobox1_Select = function() {
		if (obj.cboCompl1.getValue()=="N") {
			obj.txtCompl1.setValue('');
			obj.txtCompl1.setDisabled(true);
		} else {
			var SyndString = obj.SyndromeServer.GetSyndInfoByCPWID(obj.PathWayID);
			var SyndArray = SyndString.split("^");
			obj.txtCompl1.setValue(SyndArray[1]);
			obj.txtCompl1.setDisabled(false);
		}
	}
	
	obj.Combobox2_Select = function() {
		if (obj.cboCompl2.getValue()=="N") {
			obj.txtCompl2.setValue('');
			obj.txtCompl2.setDisabled(true);
		} else {
			var SyndString = obj.SyndromeServer.GetSyndInfoByCPWID(obj.PathWayID);
			var SyndArray = SyndString.split("^");
			obj.txtCompl2.setValue(SyndArray[2]);
			obj.txtCompl2.setDisabled(false);
		}
	}
	
	obj.btnSyndUpdate_OnClick = function() {
		var textCompl1 = obj.txtCompl1.getValue();
		var textCompl2 = obj.txtCompl2.getValue();
		var tipInfo = "";
		if (obj.cboCompl1.getValue()=="Y" && textCompl1=="") { tipInfo = tipInfo + "合并症、"; }
		if (obj.cboCompl2.getValue()=="Y" && textCompl2=="") { tipInfo = tipInfo + "并发症、"; }
		if (tipInfo!="") {
			tipInfo = "请填写" + tipInfo.substring(0, tipInfo.length-1) + "内容！";
			ExtTool.alert("提示", tipInfo); return;
		}
		var InputStr = obj.PathWayID + "||^" + textCompl1 + "^" + textCompl2 + "^" + obj.UserID + "^^";
		var ret = obj.SyndromeServer.UpdateSyndrome(InputStr);
		if (ret<0) {
			ExtTool.alert("提示", "保存失败！");
		} else {
			ExtTool.alert("提示", "保存成功！");
			//obj.SyndInfo_Load();
		}
	}
	
	obj.btnSyndClose_OnClick = function() {
		Ext.getCmp("PathWaySyndWindow").close();
	}
	
}

function PathWaySyndHeader(WinParent, PathWayID, UserID) {
	var objPathWaySyndWindow = new InitPathWaySyndWindow(WinParent, PathWayID, UserID);
	objPathWaySyndWindow.PathWaySyndWindow.show();
	var numTop = (screen.availHeight-objPathWaySyndWindow.PathWaySyndWindow.height)/2;
	var numLeft = (screen.availWidth-objPathWaySyndWindow.PathWaySyndWindow.width)/2;
	objPathWaySyndWindow.PathWaySyndWindow.setPosition(numLeft, numTop);
	ExtDeignerHelper.HandleResize(objPathWaySyndWindow);
}