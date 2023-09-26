function InitMrTypeSetEvent(obj)
{
	obj.LoadEvent = function(){
		obj.btnSaveMrType.on('click',obj.btnSaveMrType_click,obj);
		obj.gridMrType.on('rowclick',obj.gridMrType_rowclick,obj);
		obj.gridCTHospList.on("cellclick",obj.gridCTHospList_cellclick,obj);
		obj.chkRecycleType.on("check",obj.chkRecycleType_check,obj);
	}
	
	obj.chkRecycleType_check = function(){
		var isCheck = obj.chkRecycleType.getValue();
		if (!isCheck){
			Common_SetDisabled('chkIsBWMrNo',true);
			Common_SetValue('chkIsBWMrNo',true);
		} else {
			Common_SetDisabled('chkIsBWMrNo',false);
		}
	}
	
	obj.gridCTHospList_cellclick = function(grid, rowIndex, columnIndex, e){
		if (columnIndex != 0) return;
		var objRec = grid.getStore().getAt(rowIndex);
	    var fieldName = grid.getColumnModel().getDataIndex(columnIndex);
	    var recValue = objRec.get(fieldName);
		if (recValue == '1') {
			var newValue = '0';
		} else {
			var newValue = '1';
		}
		objRec.set(fieldName, newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
	}
	
	obj.btnSaveMrType_click = function(){
		var Separate = String.fromCharCode(1);
		var errinfo="";
		
		var HospIDs="";
		for (var i =0; i< obj.gridCTHospList.store.data.items.length;i++){
			if (obj.gridCTHospList.store.data.items[i].data.IsChecked==1){
				HospIDs=HospIDs+"#"+obj.gridCTHospList.store.data.items[i].data.HospID;
			}
		}
		if (HospIDs != '') HospIDs=HospIDs.substr(1);
		
		var MTMrClass = obj.cboMrClass.getValue();
		var MTDesc = obj.txtMrTypeDesc.getValue();
		var MTReceiptType = obj.cboReceiptType.getValue();
		var MTGetWay = obj.cboMrGetWay.getValue();
		var MTRecycleType = obj.chkRecycleType.getValue();
		var MTNoFiled = obj.cboMrNoFiled.getValue();
		var WorkFlow = obj.cboWorkFlow.getValue();
		var MTIsBWMrNo = obj.chkIsBWMrNo.getValue();
		var MTAdmType = Common_GetValue('cbgAdmType');
		if (MTAdmType != "") MTAdmType = MTAdmType.replace(/,/g,'#');
		var MTResume = obj.txtMrResume.getValue();
		if (!MTMrClass) {
			errinfo = errinfo + "病案分类为空!<br>";
		}
		if (!MTDesc) {
			errinfo = errinfo + "病案类型名称为空!<br>";
		}
		if (!MTAdmType) {
			errinfo = errinfo + "就诊类型为空!<br>";
		}
		if (!MTRecycleType){ //病案号不回收
			if (!MTIsBWMrNo){
				errinfo = errinfo + "是否回写病人信息表为空!<br>";
			}
			if (!MTNoFiled){
				errinfo = errinfo + "号码存储字段为空!<br>";
			}
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var tmp = obj.MrTypeID + Separate;
			tmp += MTMrClass + Separate;
			tmp += MTDesc + Separate;
			tmp += HospIDs + Separate;
			tmp += MTReceiptType + Separate;
			tmp += MTGetWay + Separate;
			tmp += (MTRecycleType==true?1:0) + Separate;
			tmp += MTNoFiled + Separate;
			tmp += WorkFlow + Separate;
			tmp += (MTIsBWMrNo==true?1:0) + Separate;
			tmp += MTAdmType + Separate;
			tmp += MTResume + Separate;
		
		var ret = ExtTool.RunServerMethod("DHCWMR.SS.MrType","Update",tmp,Separate);
		if(ret<0) {
			ExtTool.alert("提示","保存失败！");
			return;
		}else{
			ExtTool.alert("提示","保存成功！");
			obj.gridMrTypeStore.load({});
		}
	}
	
	obj.gridMrType_rowclick = function(){
		var rowIndex = arguments[1];
		var objRec = obj.gridMrTypeStore.getAt(rowIndex);
		if (obj.MrTypeID == objRec.get("ID")) {
			obj.MrTypeID = '';
			obj.cboMrClass.setValue("");
			obj.txtMrTypeDesc.setValue("");
			obj.cboReceiptType.setValue("");
			obj.cboMrGetWay.setValue("");
			obj.chkRecycleType.setValue(false)
			obj.cboMrNoFiled.setValue("");
			obj.cboWorkFlow.setValue("");
			obj.chkIsBWMrNo.setValue(false)
			Common_SetValue('cbgAdmType','');
			obj.txtMrResume.setValue("");
			obj.gridCTHospListStore.load({});
		} else {
			obj.MrTypeID = objRec.get("ID");
			obj.txtMrTypeDesc.setValue(objRec.get("MrTypeDesc"));
			Common_SetValue('cboMrClass',objRec.get("MrClassID"),objRec.get("MrClassDesc"));
			Common_SetValue('cboReceiptType',objRec.get("ReceiptTypeID"),objRec.get("ReceiptTypeDesc"));
			Common_SetValue('cboMrGetWay',objRec.get("GetWayID"),objRec.get("GetWayDesc"));
			Common_SetValue('cboMrNoFiled',objRec.get("NoFiledID"),objRec.get("NoFiledDesc"));
			Common_SetValue('cboWorkFlow',objRec.get("WorkFlowID"),objRec.get("WorkFlowDesc"));
			obj.chkRecycleType.setValue(objRec.get("RecycleType")==1);
			obj.chkIsBWMrNo.setValue(objRec.get("IsBWMrNo")==1);
			var MTAdmType = objRec.get("AdmType");
			if (MTAdmType != "") MTAdmType=MTAdmType.replace(/#/g,',');
			Common_SetValue('cbgAdmType',MTAdmType);
			obj.txtMrResume.setValue(objRec.get("MTResume"));
			obj.gridCTHospListStore.load({});
		}
	}
}

function DisplayMrNoTypeWindow(rowIndex){
	var objRec = Ext.getCmp("gridMrType").store.getAt(rowIndex);
	var NTWindow= new InitMrNoTypeViewPort(objRec);
	NTWindow.MrNoTypeWindow.show();
}