
function InitWinVarReasonEvent(obj){
	obj.LoadEvent = function(args){
		obj.btnUpdate.on('click', obj.btnUpdate_click, obj);
		obj.btnDelete.on('click', obj.btnDelete_click, obj);
		obj.MainGridPanel.on("rowclick", obj.MainGridPanel_rowclick, obj);
		obj.MainGridPanel.on("rowdblclick", obj.MainGridPanel_rowclick, obj);
	};
	obj.CurrResultRowid = "";
	obj.btnUpdate_click = function(){
		var VRID="",VRCode="",VRDesc="",VRVarCateg="",VRDateFrom="",VRDateTo="",InPutErr="";
		if (obj.CurrResultRowid) VRID=obj.CurrResultRowid;
		VRCode=obj.txtVRCode.getValue();
		//检查代码是否重复。
		var objVarReason = ExtTool.StaticServerObject("web.DHCCPW.MRC.VarianceReason");
			var CheckVal= objVarReason.CheckReaCode(VRCode,VRID)
			if(CheckVal==1){
				//ExtTool.alert("代码重复，请重新输入！",InPutErr); //统一界面风格
				ExtTool.alert("提示","代码重复，请重新输入！");	//	Modified by zhaoyu 2012-11-22 基础信息维护--变异原因--建议提示框风格与其他提示框保持一致 232
				//alert("代码重复，请重新输入！")	
				return
			}
		
		VRDesc=obj.txtVRDesc.getValue();
		VRVarCateg=obj.cboVarCateg.getValue();
		VRDateFrom=obj.dtVRDateFrom.getRawValue();
		VRDateTo=obj.dtVRDateTo.getRawValue();
		
		//	*******
		VRType=obj.cboVarReasonType.getValue();
		var CRChar=String.fromCharCode(13) + String.fromCharCode(10);
		if (VRCode=="") InPutErr = InPutErr + "代码不能为空!" + CRChar;
		if (VRDesc=="") InPutErr = InPutErr + "描述不能为空!" + CRChar;
		if (VRVarCateg=="") InPutErr = InPutErr + "变异类型不能为空!" + CRChar;
		if (VRDateFrom=="") InPutErr = InPutErr + "开始有效日期不能为空!" + CRChar;
		var DateFrom = Date.parse(obj.dtVRDateFrom.getValue());
		var DateTo = Date.parse(obj.dtVRDateTo.getValue());
		if ((DateTo) && (DateFrom>DateTo)){
			InPutErr = InPutErr + "开始日期不能大于结束日期!" + CRChar;
		}
		if (VRType=="") InPutErr = InPutErr + "变异原因类型不能为空!" + CRChar;
		if(InPutErr!=="") {
			ExtTool.alert("提示",InPutErr);
			return;
		}
		var separete = "^";
		var InPutStr = VRID + separete;
		InPutStr = InPutStr + VRCode + separete;
		InPutStr = InPutStr + VRDesc + separete;
	   	InPutStr = InPutStr + VRVarCateg + separete;
		InPutStr = InPutStr + VRDateFrom + separete;
		InPutStr = InPutStr + VRDateTo + separete;
		InPutStr = InPutStr + VRType + separete;
		InPutStr = InPutStr + (obj.chkIsActive.getValue() ? "Y" : "N");
		try{
			var objVarReason = ExtTool.StaticServerObject("web.DHCCPW.MRC.VarianceReason");
			var ret = objVarReason.Update(InPutStr);
			if(ret<0) {
				ExtTool.alert("提示","更新失败!");
				return;
			}else{
				obj.CurrResultRowid=ret;
				//Modified By LiYang 2011-05-21 Fix Bug:59 临床路径维护--基础字典维护-变异原因维护-编辑第二页信息保存后第一页显示信息数量变多load时传入分页信息
				var objOption = new Object();
				var t = obj.MainGridPanel.initialConfig.bbar;
				objOption.params = new Object();
				objOption.params.start = (Math.ceil((t.cursor + t.pageSize) / t.pageSize) - 1) * t.pageSize;
				objOption.params.limit = t.pageSize;
				obj.MainGridPanelStore.load(objOption);
				//--------------
				obj.ClearFormData();
			}
		}catch(err){
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};
	
	obj.btnDelete_click = function(){
		var VRID="",InPutErr="";
		if (obj.CurrResultRowid==""){
			InPutErr = "请选择删除记录,再删除!";
			ExtTool.alert("提示",InPutErr);
			return;
		}else{
			ExtTool.confirm('选择框','确定删除此记录?',function(btn){
				if (btn=='no') return;
				VRID=obj.CurrResultRowid;
				try{
					var objVarCateg = ExtTool.StaticServerObject("web.DHCCPW.MRC.VarianceReason");
					var ret = objVarCateg.DeleteById(VRID);
					if(ret<0) {
						ExtTool.alert("提示","删除失败!");
						return;
					}else{
						obj.ClearFormData();
						obj.MainGridPanelStore.load()
					}
				}catch(err){
					ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
				}
			});
		}
	};
	obj.MainGridPanel_rowclick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.MainGridPanelStore.getAt(rowIndex);
		if ((obj.CurrResultRowid)&&(objRec.get("ID")==obj.CurrResultRowid)){
			obj.ClearFormData();
		}else{
			obj.CurrResultRowid=objRec.get("ID");
			obj.txtVRCode.setValue(objRec.get("VRCode"));
			obj.txtVRDesc.setValue(objRec.get("VRDesc"));
			obj.cboVarCateg.setValue(objRec.get("VRVarCategDR"));
			obj.cboVarCateg.setRawValue(objRec.get("VRVarCategDesc"));
			obj.dtVRDateFrom.setValue(objRec.get("VRDateFrom"));
			obj.dtVRDateTo.setValue(objRec.get("VRDateTo"));
			obj.cboVarReasonType.setValue(objRec.get("VRType"));
			obj.cboVarReasonType.setRawValue(objRec.get("VRTypeDesc"));
			obj.chkIsActive.setValue(objRec.get("VRActive")=='Yes');
		}
	};
	obj.ClearFormData = function(){
		obj.CurrResultRowid="";
		obj.txtVRCode.setValue("");
		obj.txtVRDesc.setValue("");
		obj.cboVarCateg.setValue("");
		obj.dtVRDateFrom.setValue("");
		obj.dtVRDateTo.setValue("");
		obj.cboVarReasonType.setValue("");
		obj.chkIsActive.setValue(true);
	}
}

