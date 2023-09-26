
function InitMainViewportEvent(obj){
	obj.LoadEvent = function(args){
		obj.btnUpdate.on('click', obj.btnUpdate_click, obj);
		obj.MainGridPanel.on("rowclick", obj.MainGridPanel_rowclick, obj);
		obj.MainGridPanel.on("rowdblclick", obj.MainGridPanel_rowclick, obj);
	};
	obj.CurrResultRowid = "";
	obj.btnUpdate_click = function(){
		var Rowid="",Code="",Desc="",InPutErr="";
		if (obj.CurrResultRowid) Rowid=obj.CurrResultRowid;
		Code=obj.txtCode.getValue();
		//���code�Ƿ��ظ�
		var objDicCateg = ExtTool.StaticServerObject("web.DHCCPW.MRC.BaseDicCategory");
		var checkVal=objDicCateg.CheckCode(Code,Rowid)
		if(checkVal==1){
			alert("�����ظ�������������!");
			return
		}
		Desc=obj.txtDesc.getValue();
		var CRChar=String.fromCharCode(13) + String.fromCharCode(10);
        if (Code=="") InPutErr = InPutErr + "���벻��Ϊ��!" + CRChar;
        if (Desc=="") InPutErr = InPutErr + "��������Ϊ��!" + CRChar;
        if(InPutErr!=="") {
			ExtTool.alert("��ʾ",InPutErr);
			return;
		}
	    var separete = "^";
		var InPutStr = Rowid + separete;
		InPutStr = InPutStr + Code + separete;
		InPutStr = InPutStr + Desc + separete;
		try{
			var ret = objDicCateg.Update(InPutStr);
			if(ret<0) {
				ExtTool.alert("��ʾ","����ʧ��!");
				return;
			}else{
				obj.CurrResultRowid=ret;
				obj.MainGridPanelStore.load({
				params : {
					start:0
					,limit:20
				}});
				obj.ClearFormData();
				window.parent.RefreshLeftTree();
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
		}
	};
	obj.ClearFormData = function(){
		obj.CurrResultRowid="";
		obj.txtCode.setValue("");
		obj.txtDesc.setValue("");
	}
}
