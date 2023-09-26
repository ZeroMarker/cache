function InitViewportEvent(obj) {
	obj.LoadEvent = function()
	{
		obj.vGridPanel.on("rowclick", obj.vGridPanel_rowclick, obj);
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.btnDelete.on("click", obj.btnDelete_click, obj);
  	};
	obj.vGridPanel_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.vGridPanelStore.getAt(rowIndex);
		if(objRec.get("Rowid")==obj.CurrICRowid)
		{
			obj.CurrICRowid="";
			obj.ICCode.setValue("");
			obj.ICDesc.setValue("");
		}else{
			obj.CurrICRowid=objRec.get("Rowid");
			obj.ICCode.setValue(objRec.get("Code"));
			obj.ICDesc.setValue(objRec.get("Desc"));
		}
		return;
	};
	obj.btnSave_click = function(){
		if((obj.ICCode.getValue()=="")||(obj.ICDesc.getValue()=="")){
			ExtTool.alert("��ʾ","���롢��������Ϊ��,��������д!");
			return;	
		}
		//*******	Modified by zhaoyu 2012-11-30 �ٴ�·��ά��-������Ŀ-���ӹ�����Ŀ���࣬��������ظ� 192
		var BLICCode = obj.ICCode.getValue();
		var BLICRID = ""
		if (obj.CurrICRowid){
			BLICRID = obj.CurrICRowid;
		}
		var objBLIC = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemCat");
		var CheckVal = objBLIC.CheckBLICCode(BLICCode,BLICRID)
		if(CheckVal==1){
			ExtTool.alert("��ʾ","�����ظ������������룡");
			return
		}
		//*******
		var tmp = obj.CurrICRowid;
		tmp += "^" + obj.ICCode.getValue();
		tmp += "^" + obj.ICDesc.getValue();
		var objItemCat = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemCat");
		var ret = objItemCat.Update(tmp);
		if (ret>0){
			obj.CurrICRowid="";
			obj.ICCode.setValue("");
			obj.ICDesc.setValue("");
			obj.vGridPanelStore.load({params : {start:0,limit:20}});
			window.parent.RefreshLeftTree();
		}else{
			ExtTool.alert("��ʾ", "����ʧ��!");
		}
	};
	obj.btnDelete_click = function(){
		if(obj.CurrICRowid==""){
	 		ExtTool.alert("��ʾ","����ѡ��һ��,��ɾ��!");
	 		return;
	 	}
		ExtTool.confirm('ѡ���','ȷ��ɾ��?',function(btn){
            if(btn=="no") return;
            var objIC = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemCat");
			var ret = objIC.DeleteById(obj.CurrICRowid);
			if(parseInt(ret)>-1){
				obj.CurrICRowid="";
				obj.ICCode.setValue("");
				obj.ICDesc.setValue("");
				obj.vGridPanelStore.load({params : {start:0,limit:20}});
				window.parent.RefreshLeftTree();
			}else{
				ExtTool.alert("��ʾ","ɾ��ʧ��!");
			}
		});
	};
}
