function InitviewScreenEvent(obj){
	obj.LoadEvent = function(args){
		obj.gridDataItem.on("rowclick", obj.gridDataItem_rowclick, obj);
		obj.gridDataItem.on("rowdblclick", obj.gridDataItem_rowdblclick, obj);
		obj.txtItemAlias.on("specialKey",obj.txtItemAlias_specialKey,obj);
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.cboDataCat.on('select', obj.cboDataCat_select, obj);

		obj.txtItemAlias.setWidth(200);
		
		obj.cboDataSource.getStore().load({});
		obj.cboDataType.getStore().load({});
		Common_LoadCurrPage('gridDataItem',1);
    };
	
	obj.cboDataCat_select = function(combo,record,index){
		obj.cboDataSubCatStore.removeAll();
		obj.cboDataSubCatStore.load({
			callback : function(r,option,success){
				if (success) {
						obj.cboDataSubCat.setValue('');
						obj.cboDataSubCat.setRawValue('');
				}
			}
		});
	}


	obj.txtItemAlias_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		obj.DataItemsClear();
		Common_LoadCurrPage('gridDataItem',1);
	}
	
	obj.DataItemsClear = function(){
		obj.cboDataSource.setDisabled(false);
		obj.txtElementCode.setDisabled(false);
		obj.txtElementDesc.setDisabled(false);
		
		obj.cboDataSource.clearValue("");
		obj.txtElementCode.setValue("");
		obj.txtElementDesc.setValue("");
		obj.cboDataType.clearValue("");
		obj.txtMRItemDesc.setValue("");
		Common_SetValue('cboDataSubCat','','');
		Common_SetValue('cboDataCat','','');
		obj.txtMRItemCol.setValue("");
		obj.MRIsIndex.setValue(false);
		obj.IsActive.setValue(false);
		obj.txtResume.setValue("");
		obj.intCurrRowIndex = -1;
	}
	
   	obj.gridDataItem_rowclick = function(objGrid, intIndex){
   		if(obj.intCurrRowIndex == intIndex) {
   			obj.DataItemsClear();
   		} else {
   			obj.DisplayInfectionInfo(obj.gridDataItemStore.getAt(intIndex).get("RowId"));
   			obj.intCurrRowIndex = intIndex;
   		}
   	}
	
	obj.gridDataItem_rowdblclick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.gridDataItemStore.getAt(rowIndex);
		var ItemID = objRec.get('RowId');
		var win = new InitDicSet(ItemID);
		win.WinDicSet.show();
	}

  	obj.DisplayInfectionInfo = function(Rowid){
		var objDataItem = ExtTool.RunServerMethod("DHCWMR.MQ.DataItems","GetObjById",Rowid);
		if (!objDataItem) return;
		
		obj.cboDataSource.setDisabled(true);
		obj.txtElementCode.setDisabled(true);
		obj.txtElementDesc.setDisabled(true);
		
		var objStore = obj.cboDataSource.getStore();
		for (var indRow = 0; indRow < objStore.getCount(); indRow++){
			var objRec = objStore.getAt(indRow);
			if (objRec.get('DicCode')==objDataItem.DataSource){
				obj.cboDataSource.setValue(objRec.get("DicRowId"));
				obj.cboDataSource.setRawValue(objRec.get("DicDesc"));
			}
		}
		obj.txtElementCode.setValue(objDataItem.ElementCode);
		obj.txtElementDesc.setValue(objDataItem.ElementDesc);
		var objStore = obj.cboDataType.getStore();
		for (var indRow = 0; indRow < objStore.getCount(); indRow++){
			var objRec = objStore.getAt(indRow);
			if (objRec.get('DicCode')==objDataItem.DataType){
				obj.cboDataType.setValue(objRec.get("DicRowId"));
				obj.cboDataType.setRawValue(objRec.get("DicDesc"));
			}
		}
		obj.txtMRItemDesc.setValue(objDataItem.MRItemDesc);
		var objItemCat = ExtTool.RunServerMethod("DHCWMR.MQ.DataCat","GetObjById",objDataItem.MRItemCat);
		var objItemSubCat = ExtTool.RunServerMethod("DHCWMR.MQ.DataSubCat","GetObjById",objDataItem.MRItemSubCat);
		obj.objDataCat(objDataItem.MRItemCat,objDataItem.MRItemSubCat);
		obj.txtMRItemCol.setValue(objDataItem.MRItemCol);
		obj.MRIsIndex.setValue(objDataItem.MRIsIndex == "1");
		obj.IsActive.setValue(objDataItem.IsActive == "1");
		obj.txtResume.setValue(objDataItem.Resume);
  	}
	
	obj.objDataCat = function(dataCatId,dataSubCatId){
		obj.cboDataCatStore.removeAll();
		obj.cboDataCatStore.load({
			callback : function(r,option,success){
				if (success) {
					if (r.length > 0) {
						var rowIndex = -1;
						if (dataCatId){
							rowIndex = obj.cboDataCat.getStore().find('ID',dataCatId);
						}
						if (rowIndex > -1){
							obj.cboDataCat.setValue(r[rowIndex].get('ID'));
							obj.cboDataCat.setRawValue(r[rowIndex].get('Desc'));
						} else {
							obj.cboDataCat.setValue(r[0].get('ID'));
							obj.cboDataCat.setRawValue(r[0].get('Desc'));
						}
					} else {
						obj.cboDataCat.setValue('');
						obj.cboDataCat.setRawValue('');
					}
					obj.cboDataSubCatStore.removeAll();
					obj.cboDataSubCatStore.load({
						callback :function(r,option,success){
							if (success) {
								if (r.length > 0) {
									var rowIndex = -1;
									if (dataCatId){
										rowIndex = obj.cboDataSubCat.getStore().find('ID',dataSubCatId);
									}
									if (rowIndex > -1){
										obj.cboDataSubCat.setValue(r[rowIndex].get('ID'));
										obj.cboDataSubCat.setRawValue(r[rowIndex].get('Desc'));
									} else {
										obj.cboDataSubCat.setValue(r[0].get('ID'));
										obj.cboDataSubCat.setRawValue(r[0].get('Desc'));
									}
								} else {
									obj.cboDataSubCat.setValue('');
									obj.cboDataSubCat.setRawValue('');
								}
							}
						}
					});
				}
			}
		});
	}

  	obj.ValidateContents = function(){                     //Fix Bug 6544 by pylian 2015-01-20 首页数据项,未录入任何信息，点击【保存】，提示中有多余字符“/n/n/n”
	  	var errorInfo="";
  		if(obj.cboDataSource.getValue() == "") {
	  		errorInfo=errorInfo+"请填写数据来源! ";
  		}
   		if(obj.txtElementCode.getValue() == "") {
  			errorInfo=errorInfo+"请填写首页单元! ";
  		}
   		if(obj.txtElementDesc.getValue() == "") {           //Fix Bug 6576 by pylian 2015-01-20 首页数据项,未录入单元名称，点击【保存】，无任何反应
  			errorInfo=errorInfo+"请填写单元名称! ";
  		}
     	if(obj.cboDataType.getValue() == "") {
  			errorInfo=errorInfo+"请填写数据类型! ";
  		}
     	if(obj.txtMRItemDesc.getValue() == "") {
  			errorInfo=errorInfo+"请填写项目名称! ";
  		}
       	if(Common_GetValue('cboDataCat') == "") {
  			errorInfo=errorInfo+"请填写大类! ";
  		}
  		if(Common_GetValue('cboDataSubCat')== "") {
  			errorInfo=errorInfo+"请填写子类! ";
  		}
  		if (errorInfo!="") {
	  		alert(errorInfo);
	  		return false;
	  	}else {
			return true;
		}
  	}
	
	obj.SaveToString = function(){
	  	var strRet = "";
	  	var strRowID = "";
	  	var objRec = null;
	  	//Fix Bug 6577 by pylian 2015-01-21 首页数据项,选中一条记录后，翻页到非记录所在页，点击【保存】，报错
	    /*
	  	if(obj.intCurrRowIndex != -1)
	  	{
			objRec = obj.gridDataItemStore.getAt(obj.intCurrRowIndex);
			strRowID = objRec.get("RowId");
	  	}
		*/
		var DataSourceID = obj.cboDataSource.getValue();
		var DataSourceCode = '';
		if (DataSourceID != ''){
			var objStore = obj.cboDataSource.getStore();
			for (var indRow = 0; indRow < objStore.getCount(); indRow++){
				var objRec = objStore.getAt(indRow);
				if (objRec.get('DicRowId')==DataSourceID){
					var DataSourceCode = objRec.get("DicCode");
				}
			}
		}
		var DataTypeID = obj.cboDataType.getValue();
		var DataTypeCode = '';
		if (DataTypeID != ''){
			var objStore = obj.cboDataType.getStore();
			for (var indRow = 0; indRow < objStore.getCount(); indRow++){
				var objRec = objStore.getAt(indRow);
				if (objRec.get('DicRowId')==DataTypeID){
					var DataTypeCode = objRec.get("DicCode");
				}
			}
		}
		
		var strRet = strRowID;
		strRet += CHR_1 + DataSourceCode;
		strRet += CHR_1 + obj.txtElementCode.getValue();
		strRet += CHR_1 + obj.txtElementDesc.getValue();
		strRet += CHR_1 + DataTypeCode;
		strRet += CHR_1 + obj.txtMRItemDesc.getValue();
		strRet += CHR_1 + obj.cboDataCat.getRawValue();
		strRet += CHR_1 + obj.cboDataSubCat.getRawValue();
		strRet += CHR_1 + obj.txtMRItemCol.getValue();
		strRet += CHR_1 + (obj.MRIsIndex.getValue() ? "1" : "0");
		strRet += CHR_1 + (obj.IsActive.getValue() ? "1" : "0");
		strRet += CHR_1 + obj.txtResume.getValue();
		return strRet;
	}
	
	obj.btnSave_click = function(){
		if(!obj.ValidateContents()) return;
		var strArg = obj.SaveToString();
		var strRet = ExtTool.RunServerMethod("DHCWMR.MQ.DataItems","Update",strArg,CHR_1);
		if (parseInt(strRet) > 0) {
			obj.DataItemsClear();
			Common_LoadCurrPage('gridDataItem')
		} else {
			if (parseInt(strRet) == -100){
				ExtTool.alert("提示","首页单元重复，不允许保存！");
			} else {
				ExtTool.alert("提示","保存失败！");
			}
		}
	};
}
