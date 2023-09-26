
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
		//�������Ƿ��ظ���
		var objVarReason = ExtTool.StaticServerObject("web.DHCCPW.MRC.VarianceReason");
			var CheckVal= objVarReason.CheckReaCode(VRCode,VRID)
			if(CheckVal==1){
				//ExtTool.alert("�����ظ������������룡",InPutErr); //ͳһ������
				ExtTool.alert("��ʾ","�����ظ������������룡");	//	Modified by zhaoyu 2012-11-22 ������Ϣά��--����ԭ��--������ʾ������������ʾ�򱣳�һ�� 232
				//alert("�����ظ������������룡")	
				return
			}
		
		VRDesc=obj.txtVRDesc.getValue();
		VRVarCateg=obj.cboVarCateg.getValue();
		VRDateFrom=obj.dtVRDateFrom.getRawValue();
		VRDateTo=obj.dtVRDateTo.getRawValue();
		
		//	*******
		VRType=obj.cboVarReasonType.getValue();
		var CRChar=String.fromCharCode(13) + String.fromCharCode(10);
		if (VRCode=="") InPutErr = InPutErr + "���벻��Ϊ��!" + CRChar;
		if (VRDesc=="") InPutErr = InPutErr + "��������Ϊ��!" + CRChar;
		if (VRVarCateg=="") InPutErr = InPutErr + "�������Ͳ���Ϊ��!" + CRChar;
		if (VRDateFrom=="") InPutErr = InPutErr + "��ʼ��Ч���ڲ���Ϊ��!" + CRChar;
		var DateFrom = Date.parse(obj.dtVRDateFrom.getValue());
		var DateTo = Date.parse(obj.dtVRDateTo.getValue());
		if ((DateTo) && (DateFrom>DateTo)){
			InPutErr = InPutErr + "��ʼ���ڲ��ܴ��ڽ�������!" + CRChar;
		}
		if (VRType=="") InPutErr = InPutErr + "����ԭ�����Ͳ���Ϊ��!" + CRChar;
		if(InPutErr!=="") {
			ExtTool.alert("��ʾ",InPutErr);
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
				ExtTool.alert("��ʾ","����ʧ��!");
				return;
			}else{
				obj.CurrResultRowid=ret;
				//Modified By LiYang 2011-05-21 Fix Bug:59 �ٴ�·��ά��--�����ֵ�ά��-����ԭ��ά��-�༭�ڶ�ҳ��Ϣ������һҳ��ʾ��Ϣ�������loadʱ�����ҳ��Ϣ
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
			InPutErr = "��ѡ��ɾ����¼,��ɾ��!";
			ExtTool.alert("��ʾ",InPutErr);
			return;
		}else{
			ExtTool.confirm('ѡ���','ȷ��ɾ���˼�¼?',function(btn){
				if (btn=='no') return;
				VRID=obj.CurrResultRowid;
				try{
					var objVarCateg = ExtTool.StaticServerObject("web.DHCCPW.MRC.VarianceReason");
					var ret = objVarCateg.DeleteById(VRID);
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

