function InitViewport1Event(obj) {
	//�����෽��
	obj.ClsDicLocItem = ExtTool.StaticServerObject("DHCMed.NINF.Dic.EnviHyLocItems");
	obj.ClsDicLocItemSrv = ExtTool.StaticServerObject("DHCMed.NINFService.Dic.EnviHyLocItems");
	
	obj.LoadEvent = function(args) {
		obj.btnUpdate.on("click", obj.btnUpdate_Click, obj);
		obj.btnDelete.on("click", obj.btnDelete_Click, obj);
		obj.btnSelectAll.on("click", obj.btnSelectAll_Click, obj);
		obj.btnSelectUnall.on("click", obj.btnSelectUnall_Click, obj);
		obj.cboEnviHyLoc.on("select",obj.cboEnviHyLoc_select, obj);
		obj.cboEnviHyItem.on("select",obj.cboEnviHyItem_select, obj);
		obj.chkIsViewAll.on("check",obj.chkIsViewAll_check,obj);
		obj.gridEnviHyLocItems.on("rowclick",obj.gridEnviHyLocItems_rowclick,obj);
		obj.gridEnviHyNorms.on("cellclick",obj.gridEnviHyNorms_cellclick,obj);
		obj.gridEnviHyLocItemsStore.load({});
	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		//Common_SetValue("cboEnviHyLoc","","");
		Common_SetValue("cboEnviHyItem","","");
	}
	
	obj.btnSelectAll_Click = function() {
		var objStore = obj.gridEnviHyNorms.getStore();
		for (var i = 0; i < objStore.getCount(); i++) {
			var objRec = objStore.getAt(i);
			objRec.set("IsLocNorm", '1');
		}
		obj.gridEnviHyNorms.getStore().commitChanges();
		obj.gridEnviHyNorms.getView().refresh();
	}
	
	obj.btnSelectUnall_Click = function() {
	    var objStore = obj.gridEnviHyNorms.getStore();
		for (var i = 0; i < objStore.getCount(); i++) {
			var objRec = objStore.getAt(i);
			var recValue = objRec.get("IsLocNorm");
			if (recValue == '1') {
				var newValue = '0';
			} else {
				var newValue = '1';
			}
			objRec.set("IsLocNorm", newValue);
		}
		obj.gridEnviHyNorms.getStore().commitChanges();
		obj.gridEnviHyNorms.getView().refresh();
	}
	
	obj.btnUpdate_Click = function() {
		var errinfo = "";
		var LocID = Common_GetValue("cboEnviHyLoc");
		var ItemID = Common_GetValue("cboEnviHyItem");
		
		//ȡѡ���ļ�ⷶΧ
		var objStore = obj.gridEnviHyNorms.getStore();
		var Norms = "";
		for (var i = 0; i < objStore.getCount(); i++) {
			var objRec = objStore.getAt(i);
			if (objRec.get("IsLocNorm") == '1') {
				if (Norms == '') {
					Norms = objRec.get("NormID");
				} else {
					Norms = Norms + "#" + objRec.get("NormID");
				}
			}
		}
		
		if (!LocID) {
			errinfo = errinfo + "��������Ϊ��!<br>";
		}
		if (!ItemID) {
			errinfo = errinfo + "�����ĿΪ��!<br>";
		}
		if (errinfo) {
			ExtTool.alert("������ʾ",errinfo);
			return;
		}
		if (obj.RecRowID==undefined) {
			obj.RecRowID="";
		}
		var inputStr = obj.RecRowID;
		inputStr = inputStr + CHR_1 + LocID;
		inputStr = inputStr + CHR_1 + ItemID;
		inputStr = inputStr + CHR_1 + Norms;
		inputStr = inputStr + CHR_1 + "1";
		inputStr = inputStr + CHR_1 + "";
		var flg = obj.ClsDicLocItemSrv.SaveRec(inputStr,CHR_1);
		if (parseInt(flg) <= 0) {
			if (parseInt(flg) == -100) {
				ExtTool.alert("������ʾ","�����ظ�!Error=" + flg);
			} else {
				ExtTool.alert("������ʾ","�������ݴ���!Error=" + flg);
			}
		} else {
			obj.ClearFormItem();
			obj.cboEnviHyLoc_select();
		}
	}
	
	obj.btnDelete_Click = function() {
		var objGrid = Ext.getCmp("gridEnviHyLocItems");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('ɾ��', '�Ƿ�ɾ��ѡ�����ݼ�¼?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							alert(objRec.get("EHLIID"));
							var flg = obj.ClsDicLocItem.DeleteById(objRec.get("EHLIID"));
							if (parseInt(flg) <= 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //��ȡ�к�
								ExtTool.alert("������ʾ","ɾ����" + row + "�����ݴ���!Error=" + flg);
							} else {
								obj.ClearFormItem();
								objGrid.getStore().remove(objRec);
							}
						}
						obj.gridEnviHyLocItemsStore.removeAll();
						obj.gridEnviHyLocItemsStore.load({});
					}
				});
			} else {
				ExtTool.alert("��ʾ","��ѡ�����ݼ�¼,�ٵ��ɾ��!");
			}
		}
	}
	
	obj.cboEnviHyLoc_select = function() {
		obj.gridEnviHyLocItemsStore.removeAll();
		obj.gridEnviHyLocItemsStore.load();
		Common_SetValue('cboEnviHyItem','','');
		obj.gridEnviHyNormsStore.removeAll();
		obj.gridEnviHyNormsStore.load();
	};
	
	obj.cboEnviHyItem_select = function() {
		obj.gridEnviHyNormsStore.removeAll();
		obj.gridEnviHyNormsStore.load();
	};
	
	//�������¼�
	obj.gridEnviHyLocItems_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridEnviHyLocItems.getStore().getAt(index);
		if (objRec.get("EHLIID") == obj.RecRowID) {
			obj.ClearFormItem();
			obj.gridEnviHyNormsStore.removeAll();
		} else {
			obj.RecRowID = objRec.get("EHLIID");
			Common_SetValue("cboEnviHyLoc",objRec.get("EnviHyLocID"),objRec.get("EnviHyLoc"));
			Common_SetValue("cboEnviHyItem",objRec.get("EnviHyItemID"),objRec.get("EnviHyItem"));
			obj.gridEnviHyNormsStore.removeAll();
			obj.gridEnviHyNormsStore.load({});
		}
	};
	
	obj.gridEnviHyNorms_cellclick = function(grid, rowIndex, columnIndex, e)
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
	    
		objRec.set(fieldName, newValue);
		grid.getStore().commitChanges();
		grid.getView().refresh();
	}
	
	obj.chkIsViewAll_check = function()
	{
		obj.gridEnviHyNormsStore.removeAll();
		obj.gridEnviHyNormsStore.load({});
	};

}