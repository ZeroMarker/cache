
function InitviewScreenEvent(obj) {
	obj.intCurrRowIndex = -1;
	obj.objInfManage = ExtTool.StaticServerObject("DHCMed.EPD.Infection");
	
	obj.LoadEvent = function(args){
		obj.btnQuery.on("click", obj.btnQuery_click, obj);
		obj.btnSave.on("click", obj.btnSave_click, obj);
		obj.btnAlias.on("click", obj.btnAlias_click, obj);
		obj.gridInfection.on("rowclick", obj.gridInfection_rowclick, obj);
    };
	
   	obj.gridInfection_rowclick = function(objGrid, intIndex)
   	{
   		if(obj.intCurrRowIndex == intIndex)
   		{
   			obj.txtICD.setValue("");
   			obj.txtName.setValue("");
   			obj.cboKind.clearValue();
   			obj.cboLevel.clearValue();
   			obj.cboAppendix.clearValue();
   			obj.chkMulti.setValue("");
   			
   			obj.chkWork.setValue("");
   			
   			obj.chkDependent.setValue(true);
   			obj.cboTimeLimit.clearValue();
   			obj.txtMinAge.setValue("");
   			obj.txtMaxAge.setValue("");
   			obj.intCurrRowIndex = -1;
   			obj.txtResume.setValue(""); //Modified By LiYang 2012-02-14 
   		}
   		else
   		{
   			obj.DisplayInfectionInfo(obj.gridInfectionStore.getAt(intIndex).get("RowID"));
   			obj.intCurrRowIndex = intIndex;
   		}
   	}
  
  	obj.DisplayInfectionInfo = function(InfectionID)
  	{
  		var objInf = obj.objInfManage.GetObjById(InfectionID);
 		obj.txtICD.setValue(objInf.MIFICD) ;
		obj.txtName.setValue(objInf.MIFDisease);
		obj.cboKindStore.load({
			callback : function(){
				obj.cboKind.setValue(objInf.MIFKind);
			}
		});
		obj.cboLevelStore.load({
			callback : function(){
				obj.cboLevel.setValue(objInf.MIFRank);
			}
		});
		obj.cboAppendixStore.load({
			callback : function(){
				obj.cboAppendix.setValue(objInf.MIFAppendix);
			}
		});
		obj.chkMulti.setValue(objInf.MIFMulti == "Y");
		obj.chkWork.setValue(objInf.MIFIsActive == "Y");
		obj.chkDependent.setValue(objInf.MIFDependence == "Y");
		obj.cboTimeLimitStore.load({
			callback : function(){
				obj.cboTimeLimit.setValue(objInf.MIFTimeLimit); 		
			}
		});
		obj.txtMinAge.setValue(objInf.MIFMinAge);
		obj.txtMaxAge.setValue(objInf.MIFMaxAge);
		obj.txtResume.setValue(objInf.MIFResume);
  	}
  
  
  	obj.ValidateContents = function()
  	{
  		if(obj.txtICD.getValue() == "")
  		{
  			ExtTool.alert("��ʾ","����дICD����!");
  			return false;
  		}
   		if(obj.cboKind.getValue() == "")
  		{
  			ExtTool.alert("��ʾ","��ѡ��Ⱦ�����!");
  			return false;
  		} 		
     		if(obj.txtName.getValue() == "")
  		{
  			ExtTool.alert("��ʾ","�����봫Ⱦ������!");
  			return false;
  		} 			
     		if(obj.cboLevel.getValue() == "")
  		{
  			ExtTool.alert("��ʾ","��ѡ��Ⱦ������!");
  			return false;
  		} 		  		
       	if(obj.cboTimeLimit.getValue() == "")
  		{
  			ExtTool.alert("��ʾ","��ѡ���ϱ�ʱ��!");
  			return false;
  		} 			
  		return true;
  	}
  
	  obj.SaveToString = function()
	  {
	  	var strRet = "";
	  	var strRowID = "";
	  	var objRec = null;
	  	if(obj.intCurrRowIndex != -1)
	  	{
	  	  objRec = obj.gridInfectionStore.getAt(obj.intCurrRowIndex);
	  	  strRowID = objRec.get("RowID");
	  	}
		strRet += strRowID + "^";
		strRet += obj.txtICD.getValue()  + "^";
		strRet += obj.txtName.getValue() + "^";
		strRet += obj.cboKind.getValue() + "^";
		strRet += obj.cboLevel.getValue() + "^";
		strRet += obj.cboAppendix.getValue() + "^";
		strRet += (obj.chkMulti.getValue() ? "Y" : "N") + "^";
		strRet += (obj.chkDependent.getValue() ? "Y" : "N") + "^";
		strRet += obj.cboTimeLimit.getValue() + "^";
		strRet += obj.txtResume.getValue()  + "^"; //��ע
		strRet += obj.txtMinAge.getValue()  + "^";
		strRet += obj.txtMaxAge.getValue()  + "^";
		strRet += (obj.chkWork.getValue() ? "Y" : "N") + "^";
		return strRet;
	  }
  
	obj.btnSave_click = function()
	{
		if(!obj.ValidateContents())
			return;
		var strArg = obj.SaveToString();
		var strRet = obj.objInfManage.Update(strArg, "^");
		if(strRet > 0 )
		{
			ExtTool.alert("��ʾ","����ɹ�!");
			obj.txtICD.setValue("");
		obj.txtName.setValue("");
		obj.cboKind.clearValue();
		obj.cboLevel.clearValue();
		obj.cboAppendix.clearValue();
		obj.chkMulti.setValue(false);
		obj.chkWork.setValue(false);    //�½�Ĭ����Ч  20160130
		obj.chkDependent.setValue(true);
		obj.cboTimeLimit.clearValue();
		obj.txtMinAge.setValue("");
		obj.txtMaxAge.setValue("");
		obj.intCurrRowIndex = -1;
			obj.gridInfectionStore.load({});
		}else{
			ExtTool.alert("��ʾ","����ʧ��!");
			}
	};
	obj.btnAlias_click = function()
	{
		if(obj.intCurrRowIndex == -1)
		{
			ExtTool.alert("��ʾ","��ѡ��һ����Ⱦ���ֵ���Ŀ��ά�������!");
			return;
		}
		var objRec = obj.gridInfectionStore.getAt(obj.intCurrRowIndex);
		var objWin = new InitwinAlias(objRec.get("RowID"));
		objWin.winAlias.show();
	};
	obj.btnQuery_click = function(){
		obj.gridInfectionStore.load({});
		/*
		obj.txtICD.setValue("");
		obj.txtName.setValue("");
		obj.cboKind.clearValue();
		obj.cboLevel.clearValue();
		obj.cboAppendix.clearValue();
		obj.chkMulti.setValue(false);
		obj.chkDependent.setValue(true);
		obj.cboTimeLimit.clearValue();
		obj.txtMinAge.setValue("");
		obj.txtMaxAge.setValue("");
		*/
		obj.intCurrRowIndex = -1;
	};
}

function InitwinAliasEvent(obj)
{	
	obj.InfectionID = "";
	
	obj.LoadEvent = function(args)
	{
		obj.InfectionID = args[0];
		obj.gridAliasStore.load({});
	}
	
	 obj.btnSaveAlias_click = function()
	 {
	 	var objRec = null;
	 	var strArg = "";
	 	var strField = null;
	 	var objAliasManage = ExtTool.StaticServerObject("DHCMed.EPD.InfectionAlias");
	 	var ret = "";
	 	for(var i = 0; i < obj.gridAliasStore.getCount(); i ++)
	 	{
	 		objRec = obj.gridAliasStore.getAt(i);
	 		if(!objRec.dirty)
	 			continue;
			//Modified By LiYang 2014-08-08 FixBug:1359 ҽ������-��Ⱦ������-��Ⱦ���ֵ�ά��-��ӱ���ʱ����д���ͣ�ϵͳ��ʾ"����ɹ�",ʵ�ʲ�δ����
			if(objRec.get("Alias") == "")
			{
				ExtTool.alert("��ʾ", "��" + (i + 1) + "�����ݣ������롰������!"); 
				return;
			}
			if(objRec.get("IsKeyWord") == "")
			{
				ExtTool.alert("��ʾ", "��" + (i + 1) + "�����ݣ���ѡ�����͡�!"); 
				return;
			}		
	 		strField = objRec.get("RowID").split("||");
	 		strArg = obj.InfectionID + "^^";
	 		strArg += (strField.length > 1 ? strField[1] : "") + "^";
	 		strArg += objRec.get("Alias") + "^";
	 		strArg += objRec.get("IsKeyWord");
	 		ret = objAliasManage.Update(strArg, "^");
			if (ret == '-100'){
				ExtTool.alert("����", "��" + (i + 1) + "�����ݣ��ظ���ӱ���!"); 
				return;
			}
	 	}
	 	obj.gridAliasStore.load({});
	 	ExtTool.alert("��ʾ","����ɹ�!"); //Modified By LiYang 2012-03-13 FixBug:46 ��Ⱦ������-��Ⱦ���ֵ�ά��-������������ɹ�֮������ʾ
	 }
	 
	 obj.btnAddAlias_click = function()
	 {
	 	var objRec = new Ext.data.Record({
	 		RowID : "",
	 		Alias : "a",
	 		IsKeyWord : ""
	 	});
	 	obj.gridAliasStore.add([objRec]);
	 	objRec.set("Alias", "");
	 }
	
	obj.btnDeleteAlias_click = function()
	{
		var objRec = ExtTool.GetGridSelectedData(obj.gridAlias);
		if(objRec == null)
		{
			return;
		}
		ExtTool.confirm('ѡ���','ȷ��ɾ���˼�¼?',function(btn){
				if (btn=='no') return;
				var objAliasManage = ExtTool.StaticServerObject("DHCMed.EPD.InfectionAlias");
				objAliasManage.Delete(objRec.get("RowID"));
				obj.gridAliasStore.load({});
		});
	}
	
	obj.btnCancelAlias_click = function()
	{
		obj.winAlias.close();
	};
	
	obj.gridAlias_afteredit = function(objEvent)
	{
		var objCurrRec = objEvent.record;
		switch(objEvent.column )
		{
			case 2:
			 	var objStore = obj.cboInfAliasType.getStore();
				var index = objStore.findExact("Code", obj.cboInfAliasType.getValue());
				var objRec = objStore.getAt(index);
				objCurrRec.set("IsKeyWordDesc", objRec.get("Description"));
				objCurrRec.set("IsKeyWord", objRec.get("Code"));
				break;
			default:
				break;
		}		
	}
}
