
function InitViewport1Event(obj) {
	//加载类方法
	obj.ClsSSDictionary = ExtTool.StaticServerObject("DHCMed.SS.Dictionary");
	obj.ClsDicInfPosition = ExtTool.StaticServerObject("DHCMed.NINF.Dic.InfPosition");
	obj.ClsDicInfPositionSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.InfPosition");
	obj.ClsDicMapPosDiaSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.MapPosDia");
	
	obj.ClsDicMapPosOperSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.MapPosOperDic");

	obj.LoadEvent = function(args)
    	{
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.chkIsViewAll.on("check",obj.chkIsViewAll_check,obj);
		obj.gridInfPosition.on("rowclick",obj.gridInfPosition_rowclick,obj);
		obj.gridInfDiagnose.on("cellclick",obj.gridInfDiagnose_cellclick,obj);
		obj.gridInfOper.on("cellclick",obj.gridInfOper_cellclick,obj);
		obj.gridInfPositionStore.load({});
		obj.gridInfDiagnoseStore.load({});
		obj.gridInfOperStore.load({});
  	};
	
	obj.gridInfDiagnose_cellclick = function(grid, rowIndex, columnIndex, e)
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
	    
		var InfPosition = "";
		var objRecPos = obj.gridInfPosition.getSelectionModel().getSelected();
		if (objRecPos) {
			InfPosition = objRecPos.get("InfPosRowId");
		}
		var InfDiagnose = objRec.get("IDRowID");
		if (newValue == '1') {
			var flg = obj.ClsDicMapPosDiaSrv.SaveMapPosDia(InfPosition,InfDiagnose);
			if (parseInt(flg) <= 0) {
				ExtTool.alert("错误提示","关联感染诊断诊断错误!");
				return;
			}
		} else {
			var flg = obj.ClsDicMapPosDiaSrv.DeleteMapPosDia(InfPosition,InfDiagnose);
			if (parseInt(flg) <= 0) {
				ExtTool.alert("错误提示","取消关联感染诊断诊断错误!");
				return;
			}
		}
		
		objRec.set(fieldName, newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
	}

	obj.gridInfOper_cellclick = function(grid, rowIndex, columnIndex, e)
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
	    
		var InfPosition = "";
		var objRecPos = obj.gridInfPosition.getSelectionModel().getSelected();
		if (objRecPos) {
			InfPosition = objRecPos.get("InfPosRowId");
		}
		var InfOper = objRec.get("IDRowID");
		if (newValue == '1') {
			var flg = obj.ClsDicMapPosOperSrv.SaveMapPosOper(InfPosition,InfOper);
			if (parseInt(flg) <= 0) {
				ExtTool.alert("错误提示","关联感染侵害性操作错误!");
				return;
			}
		} else {
			var flg = obj.ClsDicMapPosOperSrv.DeleteMapPosOper(InfPosition,InfOper);
			if (parseInt(flg) <= 0) {
				ExtTool.alert("错误提示","取消关联感染侵害性操作错误!");
				return;
			}
		}
		
		objRec.set(fieldName, newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
	}
	
	obj.chkIsViewAll_check = function()
	{
		obj.gridInfDiagnoseStore.removeAll();
		obj.gridInfDiagnoseStore.load({});
		
		obj.gridInfOperStore.removeAll();
		obj.gridInfOperStore.load({});
	}
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
		Common_SetValue("chkIsActive",false);
		Common_SetValue("txtResume","");
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Code = Common_GetValue("txtCode");
		var Desc = Common_GetValue("txtDesc");
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
		inputStr = inputStr + CHR_1 + (IsActive ? '1' : '0');
		inputStr = inputStr + CHR_1 + Resume;
		var flg = obj.ClsDicInfPositionSrv.SaveRec(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				ExtTool.alert("错误提示","数据重复!Error=" + flg);
			} else {
				ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			}
			return;
		}
		
		obj.ClearFormItem();
		obj.gridInfPositionStore.load({});
		obj.gridInfDiagnoseStore.removeAll();
		obj.gridInfDiagnoseStore.load({});

		obj.gridInfOperStore.removeAll();
		obj.gridInfOperStore.load({});
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridInfPosition");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.ClsDicInfPosition.DeleteById(objRec.get("InfPosRowId"));
							if (parseInt(flg) <= 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
								obj.ClearFormItem();
								objGrid.getStore().remove(objRec);
							}
						}
						obj.gridInfDiagnoseStore.removeAll();
						obj.gridInfDiagnoseStore.load({});
		
						obj.gridInfOperStore.removeAll();
						obj.gridInfOperStore.load({});
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	
	obj.gridInfPosition_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridInfPosition.getStore().getAt(index);
		if (objRec.get("InfPosRowId") == obj.RecRowID) {
			obj.ClearFormItem();
			obj.gridInfDiagnoseStore.removeAll();
			obj.gridInfOperStore.removeAll();
		} else {
			obj.RecRowID = objRec.get("InfPosRowId");
			Common_SetValue("txtCode",objRec.get("InfPosCode"));
			Common_SetValue("txtDesc",objRec.get("InfPosDesc"));
			Common_SetValue("chkIsActive",(objRec.get("InfPosActive")=='1'));
			Common_SetValue("txtResume",objRec.get("InfPosResume"));
			obj.gridInfDiagnoseStore.removeAll();
			obj.gridInfDiagnoseStore.load({});
			obj.gridInfOperStore.removeAll();
			obj.gridInfOperStore.load({});
		}
	};
}

