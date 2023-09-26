
function InitWinVarCategEvent(obj){
	obj.LoadEvent = function(args){
		obj.ColorPicker.on('select', function(p,v){
			obj.txtVCColour.setValue('#'+v);
			Ext.getDom(obj.txtVCColour.id).style.background='#'+v;
		});
		obj.txtVCColour.on('focus',function(){
			obj.ColorPicker.show();
		})
		obj.txtVCColour.on('blur',function(){
			obj.ColorPicker.hide();
		})
		obj.btnUpdate.on('click', obj.btnUpdate_click, obj);
		obj.btnDelete.on('click', obj.btnDelete_click, obj);
		obj.MainGridPanel.on("rowclick", obj.MainGridPanel_rowclick, obj);
		obj.MainGridPanel.on("rowdblclick", obj.MainGridPanel_rowclick, obj);
	};
	obj.CurrResultRowid = "";
	obj.btnUpdate_click = function(){
		var VCID="",VCCode="",VCDesc="",VCColour="",VCDateFrom="",VCDateTo="",InPutErr="";
		if (obj.CurrResultRowid) VCID=obj.CurrResultRowid;
		VCCode=obj.txtVCCode.getValue();
		//检查code是否重复
		var objVarCateg = ExtTool.StaticServerObject("web.DHCCPW.MRC.VarianceCategory");
		var checkVal=objVarCateg.CheckVCCode(VCCode,VCID)
		if(checkVal==1){
			alert("代码重复，请重新输入");
			return
		}
		VCDesc=obj.txtVCDesc.getValue();
		VCColour=obj.txtVCColour.getValue();
		VCDateFrom=obj.dtVCDateFrom.getRawValue();
		VCDateTo=obj.dtVCDateTo.getRawValue();
		
		VCType=obj.cboVarCategType.getValue();
		var CRChar=String.fromCharCode(13) + String.fromCharCode(10);
		if (VCCode=="") InPutErr = InPutErr + "代码不能为空!" + CRChar;
		if (VCDesc=="") InPutErr = InPutErr + "描述不能为空!" + CRChar;
		if (VCDateFrom=="") InPutErr = InPutErr + "开始有效日期不能为空!" + CRChar;
		var DateFrom = Date.parse(obj.dtVCDateFrom.getValue());
		var DateTo = Date.parse(obj.dtVCDateTo.getValue());
		if ((DateTo) && (DateFrom>DateTo)){
			InPutErr = InPutErr + "开始日期不能大于结束日期!" + CRChar;
		}
		if (VCType=="") InPutErr = InPutErr + "变异类型类别不能为空!" + CRChar;
		if(InPutErr!=="") {
			ExtTool.alert("提示",InPutErr);
			return;
		}
		var separete = "^";
		var InPutStr = VCID + separete;
		InPutStr = InPutStr + VCCode + separete;
		InPutStr = InPutStr + VCDesc + separete;
		InPutStr = InPutStr + VCColour + separete;
		InPutStr = InPutStr + VCDateFrom + separete;
		InPutStr = InPutStr + VCDateTo + separete;
		InPutStr = InPutStr + VCType;
		try{
			var objVarCateg = ExtTool.StaticServerObject("web.DHCCPW.MRC.VarianceCategory");
			var ret = objVarCateg.Update(InPutStr);
			if(ret<0) {
				ExtTool.alert("提示","更新失败!");
				return;
			}else{
				obj.CurrResultRowid=ret;
				obj.MainGridPanelStore.load();
				obj.ClearFormData();
			}
		}catch(err){
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};
	
	obj.btnDelete_click = function(){
		var VCID="",InPutErr="";
		if (obj.CurrResultRowid==""){
			InPutErr = "请选择删除记录,再删除!";
			ExtTool.alert("提示",InPutErr);
			return;
		}else{
			ExtTool.confirm('选择框','确定删除此记录?',function(btn){
				if (btn=='no') return;
				VCID=obj.CurrResultRowid;
				try{
					var objVarCateg = ExtTool.StaticServerObject("web.DHCCPW.MRC.VarianceCategory");
					var ret = objVarCateg.DeleteById(VCID);
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
			obj.txtVCCode.setValue(objRec.get("VCCode"));
			obj.txtVCDesc.setValue(objRec.get("VCDesc"));
			obj.txtVCColour.setValue(objRec.get("VCColour"));
			Ext.getDom(obj.txtVCColour.id).style.background=objRec.get("VCColour");
			obj.dtVCDateFrom.setValue(objRec.get("VCDateFrom"));
			obj.dtVCDateTo.setValue(objRec.get("VCDateTo"));
			obj.cboVarCategType.setValue(objRec.get("VCType"));
			obj.cboVarCategType.setRawValue(objRec.get("VCTypeDesc"));
		}
	};
	obj.ClearFormData = function(){
		obj.CurrResultRowid="";
		obj.txtVCCode.setValue("");
		obj.txtVCDesc.setValue("");
		obj.txtVCColour.setValue("");
		Ext.getDom(obj.txtVCColour.id).style.background='#FFFFFF';
		obj.dtVCDateFrom.setValue("");
		obj.dtVCDateTo.setValue("");
		obj.cboVarCategType.setValue("");
	}
}
