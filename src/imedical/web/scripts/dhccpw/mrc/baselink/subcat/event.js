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
		if(objRec.get("Rowid")==obj.CurrISCRowid)
		{
			obj.CurrISCRowid="";
			obj.ISCCode.setValue("");
			obj.ISCDesc.setValue("");
		}else{
			obj.CurrISCRowid=objRec.get("Rowid");
			obj.ISCCode.setValue(objRec.get("Code"));
			obj.ISCDesc.setValue(objRec.get("Desc"));
		}
		return;
	};
	obj.btnSave_click = function(){
		if((obj.ISCCode.getValue()=="")||(obj.ISCDesc.getValue()=="")){
			ExtTool.alert("��ʾ","���롢��������Ϊ��,��������д!");
			return;	
		}
		//*******	Modified by zhaoyu 2012-11-30 �ٴ�·��ά��-������Ŀ-���Ӵ����ظ��Ĺ�����Ŀ���࣬��ʾ"����ʧ��"�����������ȷ��ʾ 191
		var BLISCCode = obj.ISCCode.getValue();
		var BLISCRID = ""
		if (obj.CurrISCRowid){
			BLISCRID = obj.CurrISCRowid;
		}
		var objBLISC = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemSubCat");
		var CheckVal = objBLISC.CheckBLISCCode(BLISCCode,BLISCRID)
		if(CheckVal==1){
			ExtTool.alert("��ʾ","�����ظ������������룡");
			return
		}
		//*******
		var tmp = obj.CurrISCRowid;
		tmp += "^" + obj.ISCCode.getValue();
		tmp += "^" + obj.ISCDesc.getValue();
		tmp += "^" + obj.CategID;
		var objItemSubCat = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemSubCat");
		var ret = objItemSubCat.Update(tmp);
		if (ret>0){
			obj.CurrISCRowid="";
			obj.ISCCode.setValue("");
			obj.ISCDesc.setValue("");
			obj.vGridPanelStore.load({params : {start:0,limit:20}});
			window.parent.RefreshLeftTree();
		}else{
			ExtTool.alert("��ʾ", "����ʧ��!");
		}
	};
	obj.btnDelete_click = function(){
		if(obj.CurrISCRowid==""){
	 		ExtTool.alert("��ʾ","����ѡ��һ��,��ɾ��!");
	 		return;
	 	}
		ExtTool.confirm('ѡ���','ȷ��ɾ��?',function(btn){
            if(btn=="no") return;
            var objISC = ExtTool.StaticServerObject("User.DHCMRCBaseLinkItemSubCat");
			var ret = objISC.DeleteById(obj.CurrISCRowid);
			if(parseInt(ret)>-1){
				obj.CurrISCRowid="";
				obj.ISCCode.setValue("");
				obj.ISCDesc.setValue("");
				obj.vGridPanelStore.load({params : {start:0,limit:20}});
				window.parent.RefreshLeftTree();
			}else{
				ExtTool.alert("��ʾ","ɾ��ʧ��!");
			}
		});
	};
}
