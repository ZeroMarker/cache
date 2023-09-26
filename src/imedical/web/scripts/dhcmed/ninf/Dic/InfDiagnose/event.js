
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsSSDictionary = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");
	obj.ClsDicInfDiagnose = ExtTool.StaticServerObject("DHCMed.NINF.Dic.InfDiagnose");
	obj.ClsDicInfDiagnoseSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.InfDiagnose");
	obj.ClsDicMapDiagCatSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.MapDiagCat");
	
	obj.LoadEvent = function(args)
    {
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.chkIsViewAll.on("check",obj.chkIsViewAll_check,obj);
		obj.gridInfDiagnose.on("rowclick",obj.gridInfDiagnose_rowclick,obj);
		obj.gridInfDiagnosCateg.on("cellclick",obj.gridInfDiagnosCateg_cellclick,obj);
		obj.gridInfDiagnoseStore.load({});
  	};
	
	obj.gridInfDiagnosCateg_cellclick = function(grid, rowIndex, columnIndex, e)
	{
		if (columnIndex !=0) return;
		var objRec = grid.getStore().getAt(rowIndex);
	    var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
	    var recValue = objRec.get(fieldName);
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
	    
		var InfDiagnos = "";
		var objRecDiag = obj.gridInfDiagnose.getSelectionModel().getSelected();
		if (objRecDiag) {
			InfDiagnos = objRecDiag.get("RowID");
		}
		var InfDiagCat = objRec.get("IDCRowID");
		if (newValue == '1') {
			var flg = obj.ClsDicMapDiagCatSrv.SaveMapDiagCat(InfDiagnos,InfDiagCat);
			if (parseInt(flg) <= 0) {
				ExtTool.alert("错误提示","关联感染诊断子分类错误!");
				return;
			}
		} else {
			var flg = obj.ClsDicMapDiagCatSrv.DeleteMapDiagCat(InfDiagnos,InfDiagCat);
			if (parseInt(flg) <= 0) {
				ExtTool.alert("错误提示","取消关联感染诊断子分类错误!");
				return;
			}
		}
		
		objRec.set(fieldName, newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
	}
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
		Common_SetValue("txtICD10","");
		Common_SetValue("txtAlias","");
		Common_SetValue("chkIsActive",false);
		Common_SetValue("txtResume","");
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Code = Common_GetValue("txtCode");
		var Desc = Common_GetValue("txtDesc");
		var ICD10 = Common_GetValue("txtICD10");
		var Alias = Common_GetValue("txtAlias");
		var IsActive = Common_GetValue("chkIsActive");
		var Resume = Common_GetValue("txtResume");
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + Code;
		inputStr = inputStr + CHR_1 + Desc;
		inputStr = inputStr + CHR_1 + ICD10;
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');
		inputStr = inputStr + CHR_1 + Alias;
		inputStr = inputStr + CHR_1 + Resume;
		var flg = obj.ClsDicInfDiagnoseSrv.SaveRec(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				ExtTool.alert("错误提示","数据重复!Error=" + flg);
			} else {
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			}
			return;
		}
		
		obj.ClearFormItem();
		obj.gridInfDiagnoseStore.load({});
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridInfDiagnose");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.ClsDicInfDiagnose.DeleteById(objRec.get("RowID"));
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
	
	obj.gridInfDiagnose_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridInfDiagnose.getStore().getAt(index);
		if (objRec.get("RowID") == obj.RecRowID) {
			obj.ClearFormItem();
			obj.gridInfDiagnosCategStore.removeAll();
		} else {
			obj.RecRowID = objRec.get("RowID");
			Common_SetValue("txtCode",objRec.get("IDCode"));
			Common_SetValue("txtDesc",objRec.get("IDDesc"));
			Common_SetValue("txtICD10",objRec.get("IDICD10"));
			Common_SetValue("txtAlias",objRec.get("IDAlias"));
			Common_SetValue("chkIsActive",(objRec.get("IDActive")=='1'));
			Common_SetValue("txtResume",objRec.get("IDResume"));
			obj.gridInfDiagnosCategStore.removeAll();
			obj.gridInfDiagnosCategStore.load({});
		}
	};
	
	obj.chkIsViewAll_check = function()
	{
		obj.gridInfDiagnosCategStore.removeAll();
		obj.gridInfDiagnosCategStore.load({});
	};
}

function DiagnosGistDtlHeader(){
	var objGrid = Ext.getCmp("gridInfDiagnose");
	if (objGrid) {
		var objRec = objGrid.getSelectionModel().getSelected();
		if (objRec){
			var objWinEdit = new InitwinScreen(objRec);
			objWinEdit.winScreen.show();
		}else{
			ExtTool.alert("提示","未选中记录!");
		}
	}
}



