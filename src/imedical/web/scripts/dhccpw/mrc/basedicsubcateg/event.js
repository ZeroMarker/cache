
function InitMainViewportEvent(obj){
	obj.LoadEvent = function(args){
		obj.btnUpdate.on('click', obj.btnUpdate_click, obj);
		obj.cboType.on('change', obj.cboType_change, obj);
		obj.MainGridPanel.on("rowclick", obj.MainGridPanel_rowclick, obj);
		obj.MainGridPanel.on("rowdblclick", obj.MainGridPanel_rowclick, obj);
	};
	obj.CurrResultRowid = "";
	obj.cboType_change = function(args){
			if (obj.cboType.getValue()=="DIC"){obj.chkMultiSelect.setDisabled(false);}
			else{obj.chkMultiSelect.setDisabled(true);obj.chkMultiSelect.setValue(false);}
	}
	obj.btnUpdate_click = function(){
		var Rowid="",Code="",Desc="",CategDesc="",InPutErr="",Type="",MultiSelect="";  //CategID="",
		if (obj.CurrResultRowid) Rowid=obj.CurrResultRowid;
		
		var objDicSubCateg = ExtTool.StaticServerObject("web.DHCCPW.MRC.BaseDicSubCategory");
		Code=obj.txtCode.getValue();
		//���code�Ƿ��ظ�
		
		var checkVal=objDicSubCateg.CheckCode(Code,Rowid)
		if(checkVal==1){
			alert("�����ظ�������������");
			return
		}
		Desc=obj.txtDesc.getValue();
		//CategID=obj.cboCateg.getValue();
		//CategDesc=obj.cboCateg.getRawValue();
		Type=obj.cboType.getValue();
		//MultiSelect=obj.chkMultiSelect.getValue();
		if (obj.chkMultiSelect.getValue()){MultiSelect="1";}
		
		var CRChar=String.fromCharCode(13) + String.fromCharCode(10);
        if (Code=="") InPutErr = InPutErr + "���벻��Ϊ��!" + CRChar;
        if (Desc=="") InPutErr = InPutErr + "��������Ϊ��!" + CRChar;
        if (Type=="") InPutErr = InPutErr + "�ֵ����Ͳ���Ϊ��!" + CRChar;
        //if ((CategID=="")||(CategDesc=="")) InPutErr = InPutErr + "�����ֵ���Ŀ���಻��Ϊ��!" + CRChar;
        if(InPutErr!=="") {
			ExtTool.alert("��ʾ",InPutErr);
			return;
		}
	    var separete = "^";
	    if (Rowid=="") Rowid=CategID;
		var InPutStr = Rowid + separete;
		InPutStr = InPutStr + Code + separete;
		InPutStr = InPutStr + Desc + separete;
		InPutStr = InPutStr + Type + separete;
		InPutStr = InPutStr + MultiSelect + separete;
		try{
			var ret = objDicSubCateg.Update(InPutStr);
			if(ret<0) {
				ExtTool.alert("��ʾ","����ʧ��!");
				return;
			}else{
				obj.CurrResultRowid=ret;
				obj.MainGridPanelStore.load();
				obj.ClearFormData();
				window.parent.RefreshLeftTree();   //add by wuqk 2011-09-16
			}
		}catch(err){
			ExtTool.alert("Error", err.description, Ext.MessageBox.ERROR);
		}
	};
	
	obj.MainGridPanel_rowclick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.MainGridPanelStore.getAt(rowIndex);
		if ((obj.CurrResultRowid)&&(objRec.get("Rowid")==obj.CurrResultRowid)){
			obj.ClearFormData();
		}else{
			obj.CurrResultRowid=objRec.get("Rowid");
			obj.txtCode.setValue(objRec.get("Code"));
			obj.txtDesc.setValue(objRec.get("Desc"));
			//obj.cboCateg.setValue(objRec.get("CategID"));
			obj.cboType.setValue(objRec.get("Type"));
			obj.chkMultiSelect.setValue(objRec.get("MultiSelect"));
			obj.txtCode.setDisabled(true);
			obj.cboType_change();
		}
	};
	obj.ClearFormData = function(){
		obj.CurrResultRowid="";
		obj.txtCode.setValue("");
		obj.txtDesc.setValue("");
		//obj.cboCateg.setValue("");
		obj.txtCode.setDisabled(false);
		obj.cboType.setValue("");
		obj.chkMultiSelect.setValue(false);
		obj.chkMultiSelect.setDisabled(true);
		obj.cboType_change();
	}
}
