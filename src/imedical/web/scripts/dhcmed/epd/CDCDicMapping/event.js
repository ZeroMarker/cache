
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args)
	{
		obj.cboCategory.on("select", obj.cboCategory_onSelect, obj);
		obj.gridResult.on("rowclick",obj.gridResult_rowclick,obj);
		obj.btnUpdate.on("click", obj.btnUpdate_onClick, obj);
	
		obj.txtSrcObjDesc.setDisabled(true);
	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		obj.SrcObjDescID = "";
		Common_SetValue("txtSrcObjDesc","");
		Common_SetValue("txtTargetDesc","");
	}
	
	obj.SetFormItem = function(objRec)
	{
		obj.RecRowID = objRec.get("MappingID");
		obj.SrcObjDescID = objRec.get("argDicID");
		Common_SetValue("txtSrcObjDesc",objRec.get("DicName"));
		Common_SetValue("txtTargetDesc",objRec.get("TargetDesc"));
	}
	
	obj.cboCategory_onSelect = function()
	{
			Common_LoadCurrPage('gridResult');
			obj.ClearFormItem();
	}
	
	obj.gridResult_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridResult.getStore().getAt(index);
		if (objRec.get("ID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.SetFormItem(objRec);
		}
	};
	
	obj.btnUpdate_onClick = function()
	{
		var errinfo = "";
		var CategValue = obj.cboCategory.getValue();
		if (!CategValue) return;
		var TargetDesc = Common_GetValue("txtTargetDesc");
	
		if (!CategValue) {
			errinfo = errinfo + "�ֵ����Ϊ��!<br>";
		}
		if(obj.SrcObjDescID=="")
		{
			errinfo = errinfo + "��ѡ��һ������!<br>";
		}
		if (errinfo) {
			ExtTool.alert("������ʾ",errinfo);
			return;
		}
		
		var strArg = obj.RecRowID;
		strArg += "^" + CategValue;
		strArg += "^" + obj.SrcObjDescID;
		strArg += "^" + TargetDesc;

		var ret = ExtTool.RunServerMethod("DHCMed.EPD.CDCDicMapping", "Update", strArg, "^");
		if (parseInt(ret) <= 0) {
			ExtTool.alert("��ʾ","���¼�¼����!Error=" + ret);
			return;
		} else {
			obj.ClearFormItem();
			Common_LoadCurrPage('gridResult');
		}
	}

}

