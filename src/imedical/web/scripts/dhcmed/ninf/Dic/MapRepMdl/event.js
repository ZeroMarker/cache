
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsSSDictionary = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");
	obj.ClsDicMapRepMdl = ExtTool.StaticServerObject("DHCMed.NINF.Dic.MapRepMdl");
	obj.ClsDicMapRepMdlSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.MapRepMdl");
	
	obj.LoadEvent = function(args)
    {
		Common_SetDisabled("cboRepLoc",true);
		Common_SetDisabled("cboRepType",true);
		
		obj.cboRepCat.on("select",obj.cboRepCat_select,obj);
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.gridMapRepMdl.on("rowclick",obj.gridMapRepMdl_rowclick,obj);
		obj.gridMapRepMdlStore.load({});
  	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("cboRepCat","","");
		Common_SetValue("cboRepLoc","","");
		Common_SetValue("cboRepType","","");
		Common_SetValue("txtModuleList","");
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var RepCatID = Common_GetValue("cboRepCat");
		var RepLocID = Common_GetValue("cboRepLoc");
		var RepTypeID = Common_GetValue("cboRepType");
		var ModuleList = Common_GetValue("txtModuleList");
		if (!RepCatID) {
			errinfo = errinfo + "报告分类为空!<br>";
		} else {
			var objDic = obj.ClsSSDictionary.GetObjById(RepCatID);
			if (objDic){
				if (objDic.Code == "Inf"){
					if (!RepTypeID) {
						errinfo = errinfo + "报告类型为空!<br>";
					}
				} else if (objDic.Code == "Aim"){
					if (!RepLocID) {
						errinfo = errinfo + "报告科室为空!<br>";
					}
				} else {}
			}
		}
		if (!ModuleList) {
			errinfo = errinfo + "模块列表为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + RepCatID;
		inputStr = inputStr + CHR_1 + RepLocID;
		inputStr = inputStr + CHR_1 + RepTypeID;
		inputStr = inputStr + CHR_1 + ModuleList;
		var flg = obj.ClsDicMapRepMdlSrv.SaveMapRec(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if ((parseInt(flg) == -100)||(parseInt(flg) == -200)) {
				ExtTool.alert("错误提示","数据重复!Error=" + flg);
			} else {
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			}
			return;
		}
		
		obj.ClearFormItem();
		obj.gridMapRepMdlStore.load({});
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridMapRepMdl");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.ClsDicMapRepMdl.DeleteById(objRec.get("RowID"));
							if (parseInt(flg) <= 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
								obj.ClearFormItem();
								objGrid.getStore().remove(objRec);
							}
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	
	obj.cboRepCat_select = function()
	{
		Common_SetValue("cboRepLoc","","");
		Common_SetValue("cboRepType","","");
		Common_SetValue("txtModuleList","");
		Common_SetDisabled("cboRepLoc",true);
		Common_SetDisabled("cboRepType",true);
		
		var RepCatID=Common_GetValue("cboRepCat");
		var objDic = obj.ClsSSDictionary.GetObjById(RepCatID);
		if (objDic){
			if (objDic.Code == "Inf"){
				Common_SetDisabled("cboRepType",false);
			} else if (objDic.Code == "Aim"){
				Common_SetDisabled("cboRepLoc",false);
			} else {}
		}
	}
	
	obj.gridMapRepMdl_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridMapRepMdl.getStore().getAt(index);
		if (objRec.get("RowID") == obj.RecRowID) {
			obj.ClearFormItem();
		} else {
			obj.RecRowID = objRec.get("RowID");
			Common_SetValue("cboRepCat",objRec.get("RepCatID"),objRec.get("RepCatDesc"));
			Common_SetValue("cboRepLoc",objRec.get("RepLocID"),objRec.get("RepLocDesc"));
			Common_SetValue("cboRepType",objRec.get("RepTypeID"),objRec.get("RepTypeDesc"));
			Common_SetValue("txtModuleList",objRec.get("ModuleList"));
		}
		
		Common_SetDisabled("cboRepLoc",true);
		Common_SetDisabled("cboRepType",true);
		var RepCatID=Common_GetValue("cboRepCat");
		var objDic = obj.ClsSSDictionary.GetObjById(RepCatID);
		if (objDic){
			if (objDic.Code == "Inf"){
				Common_SetDisabled("cboRepType",false);
			} else if (objDic.Code == "Aim"){
				Common_SetDisabled("cboRepLoc",false);
			} else {}
		}
	};
}

