function InitviewSubWindowEvent(obj)
{
	obj.LoadEvent = function (args)
	{
		obj.gridCTHospList.on("cellclick",obj.gridCTHospList_cellclick,obj);
		obj.gridMrType.on("cellclick",obj.gridMrType_cellclick,obj);
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.gridFeeItemSub.on('rowclick',obj.gridFeeItemSub_rowclick,obj);
		obj.dfSttDate.setValue("");
		obj.dfEndDate.setValue("");
	}
	
	obj.gridMrType_cellclick = function(grid, rowIndex, columnIndex, e){
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
	
	obj.btnUpdate_click = function()
	{
		var Separate = String.fromCharCode(1);
		var errinfo="";
		
		var TarItemDr = obj.cboTarItem.getValue();
		var SttDate = obj.dfSttDate.getRawValue();
		var EndDate = obj.dfEndDate.getRawValue();
		
		var MrTypeIDs="";
		for (var i =0; i< obj.gridMrType.store.data.items.length;i++){
			if (obj.gridMrType.store.data.items[i].data.IsChecked==1){
				MrTypeIDs=MrTypeIDs+"#"+obj.gridMrType.store.data.items[i].data.ID;
			}
		}
		if (MrTypeIDs != '') MrTypeIDs=MrTypeIDs.substr(1);
		
		var HospIDs="";
		for (var i =0; i< obj.gridCTHospList.store.data.items.length;i++){
			if (obj.gridCTHospList.store.data.items[i].data.IsChecked==1){
				HospIDs=HospIDs+"#"+obj.gridCTHospList.store.data.items[i].data.HospID;
			}
		}
		if (HospIDs != '') HospIDs=HospIDs.substr(1);
		
		var Resume = obj.txtResume.getValue();		
		
		if (!TarItemDr) {
			errinfo = errinfo + "HIS�շ���Ϊ��!<br>";
		}
		if (!SttDate) {
			errinfo = errinfo + "��ʼ����Ϊ��!<br>";
		}
		if ((EndDate)&&(Common_DateParse(SttDate)>Common_DateParse(EndDate))) {
			errinfo = errinfo + "��ʼ���ڴ��ڽ�������!<br>";
		}
		if (!MrTypeIDs) {
			errinfo = errinfo + "��������Ϊ��!<br>";
		}
		if (!HospIDs) {
			errinfo = errinfo + "ҽԺΪ��!<br>";
		}
		if (errinfo) {
			ExtTool.alert("������ʾ",errinfo);
			return;
		}
		
		var inputStr = obj.FeeItemSubId + Separate;
			inputStr += obj.FeeItemID + Separate;
			inputStr += TarItemDr + Separate;
			inputStr += SttDate + Separate;
			inputStr += EndDate + Separate;
			inputStr += MrTypeIDs + Separate;
			inputStr += HospIDs + Separate;
			inputStr += Resume + Separate;

		var ret = ExtTool.RunServerMethod("DHCWMR.MF.FeeItemSub","Update",inputStr,Separate);
		if(parseInt(ret)<0) {
			if (parseInt(ret)==-100){
				ExtTool.alert("��ʾ","¼�������������������ͻ��");
				return;
			}else{
				ExtTool.alert("��ʾ","����ʧ�ܣ�");
				return;
			}
		}else{
			ExtTool.alert("��ʾ","����ɹ���");
			obj.gridFeeItemSubStore.load({});
		}
	}
	
	obj.gridFeeItemSub_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.gridFeeItemSubStore.getAt(rowIndex);
		if (obj.FeeItemSubId == objRec.get("ID")) {
			obj.FeeItemSubId = '';
			obj.cboTarItem.setValue("");
			obj.dfSttDate.setValue("");
			obj.dfEndDate.setValue("");
			obj.txtResume.setValue("");
			obj.gridMrTypeStore.load({});
			obj.gridCTHospListStore.load({});
		} else {
			obj.FeeItemSubId = objRec.get("ID");
			Common_SetValue('cboTarItem',objRec.get("TarItemDr"),objRec.get("TarItemDesc"));
			obj.dfSttDate.setValue(objRec.get("SttDate"));
			obj.dfEndDate.setValue(objRec.get("EndDate"));
			obj.txtResume.setValue(objRec.get("Resume"));
			obj.gridCTHospListStore.load({});
			obj.gridMrTypeStore.load({});
		}
	}
	
}