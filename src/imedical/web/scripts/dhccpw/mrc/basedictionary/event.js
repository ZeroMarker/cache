
function InitMainViewportEvent(obj){
	obj.LoadEvent = function(args){
		obj.btnUpdate.on('click', obj.btnUpdate_click, obj);
		//obj.btnFind.on('click', obj.btnFind_click, obj);
		obj.MainGridPanel.on("rowclick", obj.MainGridPanel_rowclick, obj);
		obj.MainGridPanel.on("rowdblclick", obj.MainGridPanel_rowclick, obj);
	};
	obj.CurrResultRowid = "";
	obj.btnFind_click = function(){
		obj.MainGridPanelStore.removeAll();
		obj.MainGridPanelStore.load({
		params : {
			start:0
			,limit:20
		}});
	};
	obj.btnUpdate_click = function(){
		var Rowid="",Code="",Desc="",IsActive="",CPWDID="",CPWDDesc="",InPutErr="";  //SubCategID="",SubCategDesc="",
		if (obj.CurrResultRowid) Rowid=obj.CurrResultRowid;
		Code=obj.txtCode.getValue();
		//检查code是否重复
		var objBaseDic= ExtTool.StaticServerObject("web.DHCCPW.MRC.BaseDictionary");
		//update by zf 2011-04-25
        //Update By NiuCaicai 2011-07-20 FixBug:113 临床路径维护--基础信息维护-评估字典维护-可以添加代码相同的记录
		var checkVal=objBaseDic.CheckCode(Code,Rowid,SubCategID)
		if(checkVal==1){
			alert("代码重复，请重新输入!");
			return;
		}
		Desc=obj.txtDesc.getValue();
		IsActive=(obj.chkIsActive.getValue() ? "Y" : "N");
		//SubCategID=obj.cboSubCateg.getValue();
		//SubCategDesc=obj.cboSubCateg.getRawValue();
		//CPWDID=obj.cboCPWDic.getValue();
		//CPWDDesc=obj.cboCPWDic.getRawValue();
		//if (CPWDDesc=='') CPWDID='';
		var CRChar=String.fromCharCode(13) + String.fromCharCode(10);
        if (Code=="") InPutErr = InPutErr + "代码不能为空!" + CRChar;
        if (Desc=="") InPutErr = InPutErr + "描述不能为空!" + CRChar;
        //if ((SubCategID=="")||(SubCategDesc=="")) InPutErr = InPutErr + "基础字典项目子类不能为空!" + CRChar;
        if(InPutErr!=="") {
			ExtTool.alert("提示",InPutErr);
			return;
		}
	    var separete = "^";
		var InPutStr = Rowid + separete;
		InPutStr = InPutStr + Code + separete;
		InPutStr = InPutStr + Desc + separete;
		InPutStr = InPutStr + SubCategID + separete;
		InPutStr = InPutStr + CPWDID + separete;
		InPutStr = InPutStr + IsActive + separete;
		try{
			var ret = objBaseDic.Update(InPutStr);
			if(ret<0) {
				ExtTool.alert("提示","更新失败!");
				return;
			}else{
				obj.CurrResultRowid=ret;
				obj.MainGridPanelStore.load();
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
		if ((obj.CurrResultRowid)&&(objRec.get("ID")==obj.CurrResultRowid)){
			obj.ClearFormData();
		}else{
			obj.CurrResultRowid=objRec.get("ID");
			obj.txtCode.setValue(objRec.get("Code"));
			obj.txtDesc.setValue(objRec.get("Desc"));
			//obj.cboSubCateg.setValue(objRec.get("TypeID"));
			//obj.cboCPWDic.setValue(objRec.get("CPWDID"));
			obj.chkIsActive.setValue(objRec.get("IsActive")=="Yes");
			//obj.cboSubCateg.setDisabled(true);
			//obj.cboCPWDic.setDisabled(true);
		}
	};
	obj.ClearFormData = function(){
		obj.CurrResultRowid="";
		obj.txtCode.setValue("");
		obj.txtDesc.setValue("");
		//obj.cboSubCateg.setValue("");
		//obj.cboCPWDic.setValue("");
		obj.chkIsActive.setValue(false);
		//obj.cboSubCateg.setDisabled(false);
		//obj.cboCPWDic.setDisabled(false);
	}
}
