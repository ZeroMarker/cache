
function InitviewScreenEvent(obj) {
	obj.LoadEvent = function(args)
  {
  	obj.cboCategory.on("select", obj.cboCategory_OnSelect, obj);
   	obj.gridResult.on("beforeedit", obj.gridResult_beforeedit, obj);
  	obj.gridResult.on("afteredit", obj.gridResult_afteredit, obj); 	
  	obj.btnDelete.on("click", obj.btnDelete_onClick, obj);
  	
  };
  
  obj.btnDelete_onClick = function()
  {
  	var objSelRec = obj.gridResult.getSelectionModel().selection.record;
  	if(objSelRec == null)
  		return;  	
  	var RowID = objSelRec.get("ID");
  	var ret = ExtTool.RunServerMethod("DHCMed.NINF.Rep.ExportDataMap", "DeleteByID", RowID);
  	obj.cboCategory_OnSelect();
  }
  
  
  obj.cboCategory_OnSelect = function()
  {
  	obj.gridResultStore.load({});
  }
  

  obj.gridResult_beforeedit = function()
  {
  	var SelectIndex = obj.cboCategoryStore.find("Code", obj.cboCategory.getValue());
  	if(SelectIndex < 0)
  		return;
  	var objRec = obj.cboCategoryStore.getAt(SelectIndex);
  	var objDic = ExtTool.RunServerMethod("DHCMed.SS.Dictionary", "GetObjById", objRec.get("myid"));  		
  	obj.MainCode =  objDic.StrB;
  	obj.cboMinkeDic.clearValue();
  	obj.cboMinkeDicStore.load({});
  }
 
   obj.gridResult_afteredit = function(objConfig)
  {
  	var SelectIndex = obj.cboMinkeDicStore.find("Code", objConfig.value);
  	if(SelectIndex > 0)
  	{
  		var objSelDicRec = obj.cboMinkeDicStore.getAt(SelectIndex);
  		objConfig.record.set("TargetDesc", objSelDicRec.get("Desc"));
  	}
  	var strArg = "";
  	strArg += obj.cboCategory.getValue() + "^";
  	strArg += objConfig.record.get("SrcObjectID") + "^";
  	strArg += objConfig.record.get("SrcDescription") + "^";
  	strArg += objConfig.record.get("Target") + "^";
  	strArg += objConfig.record.get("TargetDesc") + "^";
  	strArg += objConfig.record.get("ResumeText") + "^";
  	var ret = ExtTool.RunServerMethod("DHCMed.NINF.Rep.ExportDataMap", "Update", strArg, "^"); 
  }   
  
  
/*viewScreen新增代码占位符*/}

