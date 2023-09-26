
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
		//���code�Ƿ��ظ�
		var objVarCateg = ExtTool.StaticServerObject("web.DHCCPW.MRC.VarianceCategory");
		var checkVal=objVarCateg.CheckVCCode(VCCode,VCID)
		if(checkVal==1){
			alert("�����ظ�������������");
			return
		}
		VCDesc=obj.txtVCDesc.getValue();
		VCColour=obj.txtVCColour.getValue();
		VCDateFrom=obj.dtVCDateFrom.getRawValue();
		VCDateTo=obj.dtVCDateTo.getRawValue();
		
		VCType=obj.cboVarCategType.getValue();
		var CRChar=String.fromCharCode(13) + String.fromCharCode(10);
		if (VCCode=="") InPutErr = InPutErr + "���벻��Ϊ��!" + CRChar;
		if (VCDesc=="") InPutErr = InPutErr + "��������Ϊ��!" + CRChar;
		if (VCDateFrom=="") InPutErr = InPutErr + "��ʼ��Ч���ڲ���Ϊ��!" + CRChar;
		var DateFrom = Date.parse(obj.dtVCDateFrom.getValue());
		var DateTo = Date.parse(obj.dtVCDateTo.getValue());
		if ((DateTo) && (DateFrom>DateTo)){
			InPutErr = InPutErr + "��ʼ���ڲ��ܴ��ڽ�������!" + CRChar;
		}
		if (VCType=="") InPutErr = InPutErr + "�������������Ϊ��!" + CRChar;
		if(InPutErr!=="") {
			ExtTool.alert("��ʾ",InPutErr);
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
				ExtTool.alert("��ʾ","����ʧ��!");
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
			InPutErr = "��ѡ��ɾ����¼,��ɾ��!";
			ExtTool.alert("��ʾ",InPutErr);
			return;
		}else{
			ExtTool.confirm('ѡ���','ȷ��ɾ���˼�¼?',function(btn){
				if (btn=='no') return;
				VCID=obj.CurrResultRowid;
				try{
					var objVarCateg = ExtTool.StaticServerObject("web.DHCCPW.MRC.VarianceCategory");
					var ret = objVarCateg.DeleteById(VCID);
					if(ret<0) {
						ExtTool.alert("��ʾ","ɾ��ʧ��!");
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
