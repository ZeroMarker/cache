function InitViewportEvent(obj) {
	obj.LoadEvent = function()
	{
		obj.CurrISCRowid=""
		obj.vGridPanel.on("rowclick", obj.vGridPanel_rowclick, obj);
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.btnDelete.on("click", obj.btnDelete_click, obj);
  	};
	obj.vGridPanel_rowclick = function()
	{
		var rowIndex = arguments[1];
		var objRec = obj.vGridPanelStore.getAt(rowIndex);
		
		//Modified By LiYang 2014-07-24 FixBug:1606 ҽ������-�������-�������-ά����Ŀ����ʱ�����ѡ��ĳ����Ŀ���࣬�ٴε���ü�¼���޷�ȡ��ѡ��
		//if(objRec.get("rowid")==obj.CurrISCRowid)
		if(objRec.get("Rowid")==obj.CurrISCRowid)
		{
			obj.ISCCode.setValue("");
			obj.ISCDesc.setValue("");
			obj.cboISCKeyWord.setValue("");
			obj.CurrISCRowid=""
		}else{
			obj.CurrISCRowid=objRec.get("Rowid");
			obj.ISCCode.setValue(objRec.get("Code"));
			obj.ISCDesc.setValue(objRec.get("Desc"));
			obj.cboISCKeyWord.setValue(objRec.get("KeywordID"));
			obj.Currrowid=objRec.get("rowid")
		}
		return;
	};
	obj.btnSave_click = function(){
		if((obj.ISCCode.getValue()=="")||(obj.ISCDesc.getValue()=="")){
			ExtTool.alert("��ʾ","���롢��������Ϊ��,��������д!");
			return;
		}
		var objItemSubCat = ExtTool.StaticServerObject("DHCMed.CC.ItemSubCat");
		var tmp = obj.CurrISCRowid;
		tmp += "^" + obj.ISCCode.getValue();
		tmp += "^" + obj.ISCDesc.getValue();
		tmp += "^" + obj.CategID;
		tmp += "^" + obj.cboISCKeyWord.getValue();
		//alert(tmp)
		var ret = objItemSubCat.Update(tmp);
		//alert(ret)
		if (ret>0){
			obj.CurrISCRowid="";
			obj.ISCCode.setValue("");
			obj.ISCDesc.setValue("");
			obj.cboISCKeyWord.setValue("");
			obj.vGridPanelStore.load({});
			window.parent.RefreshLeftTree();
		}else if(ret==-1){
			ExtTool.alert("��ʾ", "�����ظ�����������д!");
		}
	};
	obj.btnDelete_click = function(){
		if(obj.CurrISCRowid==""){
	 		ExtTool.alert("��ʾ","����ѡ��һ��,��ɾ��!");
	 		return;
	 	}
		ExtTool.confirm('ѡ���','ȷ��ɾ��?',function(btn){
            if(btn=="no") return;
            var objISC = ExtTool.StaticServerObject("DHCMed.CC.ItemSubCat");
			var ret = objISC.DeleteById(obj.CurrISCRowid);
			if(ret>-1){
				obj.CurrISCRowid="";
				obj.ISCCode.setValue("");
				obj.ISCDesc.setValue("");
				obj.cboISCKeyWord.setValue("");
				obj.vGridPanelStore.load({});
				window.parent.RefreshLeftTree();
			}else{
				ExtTool.alert("��ʾ","ɾ��ʧ��!");
			}
		});
	};
}
