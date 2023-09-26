
function InitwinProblemEvent(obj) {

	obj.LoadEvent = function(args)
  {
  	obj.objParent = args[2];
  	obj.btnCancel.on("click", obj.btnCancel_onclick, obj);
  	obj.btnSave.on("click", obj.btnSave_onclick, obj);
  	obj.btnSkip.on("click", obj.btnSkip_onclick, obj);
  	obj.gridProblem.on("beforeedit", obj.gridProblem_beforeedit, obj);
  	obj.gridProblem.on("afteredit", obj.gridProblem_afteredit, obj);
  };
  
  obj.gridProblem_beforeedit = function()
  {
  	var objSelRec = obj.gridProblem.getSelectionModel().selection.record;
  	if(objSelRec == null)
  		return;
  	obj.MainCode = objSelRec.get("MapDicTypeCode");
  	obj.cboMinkeDic.clearValue();
  	obj.cboMinkeDicStore.load({});
  }
 
   obj.gridProblem_afteredit = function(objConfig)
  {
  	var SelectIndex = obj.cboMinkeDicStore.find("DicCode", objConfig.value);
  	if(SelectIndex < 0)
  		return;
  	objSelDicRec = obj.cboMinkeDicStore.getAt(SelectIndex);
  	objConfig.record.set("TargetDesc", objSelDicRec.get("DicDesc"));
  	
  } 
  
  
  obj.btnCancel_onclick = function(){
  	obj.winProblem.close();	
  }
  
  obj.btnSave_onclick = function(){
  	//obj.winProblem.close();	
  	var ret = "";
  	for(var i = 0; i < obj.gridProblemStore.getCount(); i ++)
  	{
  		var objRec = obj.gridProblemStore.getAt(i);
		if(objRec.get("Target") == "")
			continue;
  		ret = obj.UpdateMapping(objRec);
  	}
  	obj.gridProblemStore.load({
  		callback : function(){
  			if(obj.gridProblemStore.getCount() > 0)
  			{
  				ExtTool.alert("提示", "还有" + obj.gridProblemStore.getCount() + "条信息没有对照！", Ext.MessageBox.INFO); 
  			}
  			else
  			{
  				obj.btnSkip_onclick();
  			}	
  		}	
  	});
  }
  
  obj.btnSkip_onclick = function(){
  	obj.winProblem.close();	
  	ExportEPDInterface(objControlArry['viewScreen'], true);
  }   
  
	obj.UpdateMapping = function(objRec)
	{
		var strArg = objRec.get("ID") + "^";
		strArg += objRec.get("MappingTypeCode") + "^";
		strArg += objRec.get("SrcValue") + "^";
		strArg += objRec.get("SrcDesc") + "^";
		strArg += objRec.get("Target") + "^";
		strArg += objRec.get("TargetDesc") + "^";
		strArg += objRec.get("ResumeText") + "^";
		var ret = ExtTool.RunServerMethod("DHCMed.EPD.IOMapping", "Update", strArg, "^");
		return ret;
	}
  
  
  
/*winProblem新增代码占位符*/}

