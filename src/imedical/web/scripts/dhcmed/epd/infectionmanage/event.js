
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
  			ExtTool.alert("提示","请填写ICD代码!");
  			return false;
  		}
   		if(obj.cboKind.getValue() == "")
  		{
  			ExtTool.alert("提示","请选择传染病类别!");
  			return false;
  		} 		
     		if(obj.txtName.getValue() == "")
  		{
  			ExtTool.alert("提示","请输入传染病名称!");
  			return false;
  		} 			
     		if(obj.cboLevel.getValue() == "")
  		{
  			ExtTool.alert("提示","请选择传染病级别!");
  			return false;
  		} 		  		
       	if(obj.cboTimeLimit.getValue() == "")
  		{
  			ExtTool.alert("提示","请选择上报时限!");
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
		strRet += obj.txtResume.getValue()  + "^"; //备注
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
			ExtTool.alert("提示","保存成功!");
			obj.txtICD.setValue("");
		obj.txtName.setValue("");
		obj.cboKind.clearValue();
		obj.cboLevel.clearValue();
		obj.cboAppendix.clearValue();
		obj.chkMulti.setValue(false);
		obj.chkWork.setValue(false);    //新建默认有效  20160130
		obj.chkDependent.setValue(true);
		obj.cboTimeLimit.clearValue();
		obj.txtMinAge.setValue("");
		obj.txtMaxAge.setValue("");
		obj.intCurrRowIndex = -1;
			obj.gridInfectionStore.load({});
		}else{
			ExtTool.alert("提示","保存失败!");
			}
	};
	obj.btnAlias_click = function()
	{
		if(obj.intCurrRowIndex == -1)
		{
			ExtTool.alert("提示","请选择一个传染病字典项目再维护其别名!");
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
			//Modified By LiYang 2014-08-08 FixBug:1359 医政管理-传染病管理-传染病字典维护-添加别名时不填写类型，系统提示"保存成功",实际并未保存
			if(objRec.get("Alias") == "")
			{
				ExtTool.alert("提示", "第" + (i + 1) + "行数据，请输入“别名”!"); 
				return;
			}
			if(objRec.get("IsKeyWord") == "")
			{
				ExtTool.alert("提示", "第" + (i + 1) + "行数据，请选择“类型”!"); 
				return;
			}		
	 		strField = objRec.get("RowID").split("||");
	 		strArg = obj.InfectionID + "^^";
	 		strArg += (strField.length > 1 ? strField[1] : "") + "^";
	 		strArg += objRec.get("Alias") + "^";
	 		strArg += objRec.get("IsKeyWord");
	 		ret = objAliasManage.Update(strArg, "^");
			if (ret == '-100'){
				ExtTool.alert("错误", "第" + (i + 1) + "行数据，重复添加别名!"); 
				return;
			}
	 	}
	 	obj.gridAliasStore.load({});
	 	ExtTool.alert("提示","保存成功!"); //Modified By LiYang 2012-03-13 FixBug:46 传染病管理-传染病字典维护-【别名】保存成功之后无提示
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
		ExtTool.confirm('选择框','确定删除此记录?',function(btn){
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
