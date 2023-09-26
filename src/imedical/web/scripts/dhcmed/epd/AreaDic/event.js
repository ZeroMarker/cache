
function InitviewScreenEvent(obj){
	obj.LoadEvent = function(args){
		obj.btnAdd.on("click", obj.btnAdd_click, obj);
		obj.gridResult.on("rowdblclick",obj.gridResult_rowdblclick,obj);
		obj.gridResultStore.load({});
		
		obj.cboCity.setDisabled(true);
		obj.cboCounty.setDisabled(true);
	};
  	
 	obj.btnAdd_click = function(){
		var objWin = new InitwinArea(obj.ParentId,'');
		objWin.winArea.show();
	};
	
	obj.gridResult_rowdblclick = function() {
		var rowIndex = arguments[1];
		var objRec = obj.gridResult.getStore().getAt(rowIndex);
		var objWin = new InitwinArea(obj.ParentId,objRec);
		objWin.winArea.show();
	}
}

//维护窗体的事件代码
function InitwinAreaEvent(obj){
	obj.LoadEvent = function(args){
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.btnCancel.on("click",obj.btnCancel_click, obj);
		if (obj.Record) {
			obj.txtCode.setValue(obj.Record.get('Code'));
			obj.txtShortDesc.setValue(obj.Record.get('ShortDesc'));
			obj.txtLongDesc.setValue(obj.Record.get('LongDesc'));
			obj.chkIsActive.setValue((obj.Record.get('IsActive') == '1'));
		}
	} 
	obj.btnSave_click = function(){
		var objAreaDicUpdate = ExtTool.StaticServerObject("DHCMed.EPD.AreaDic");
		if ((obj.txtCode.getValue()=="")||(obj.txtShortDesc.getValue()=="")||(obj.txtLongDesc.getValue()=="")) {
			ExtTool.alert("提示","代码、名称及全名不能为空,请认真填写!");
			return;	
		}
		
		if (obj.Record) {
			var RowID = obj.Record.get('RowID');
		} else {
			var RowID = '';
		}
		
		var tmp = RowID;
		tmp += "^" + obj.txtCode.getValue();
		tmp += "^" + obj.txtShortDesc.getValue();
		tmp += "^" + obj.txtLongDesc.getValue();
		tmp += "^" + "";
		tmp += "^" + obj.ParentId;
		tmp += "^" + ""
		tmp += "^" + ""
		tmp += "^" + (obj.chkIsActive.getValue()? "1" : "0");
		
		var ret = objAreaDicUpdate.Update(tmp);
		if (ret>0){
			obj.txtCode.setValue("");
			obj.txtShortDesc.setValue("");
			obj.txtLongDesc.setValue("");
			obj.chkIsActive.setValue(false);
			
			var objCmp = Ext.getCmp("gridResult");
			if (objCmp) {
				objCmp.getStore().load({});
			}
			
			obj.winArea.close();
		}else{
			ExtTool.alert("提示", "保存失败!");
		}
	};
	
	obj.btnCancel_click = function(){
		obj.winArea.close();
	};

}
