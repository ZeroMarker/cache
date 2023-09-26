
function InitViewport1Event(obj) {
	obj.LoadEvent = function(args)
	
  { 
  	obj.GridPanel4Store.load();
  	
  	};
	obj.B_Save_click = function()
	{
		SaveData()
	};
	;
	obj.B_Clear_click = function()
	{
		ClearFrm()
	};
	obj.TblTree_click=function()
	{
		SetCodeType()
	};
	obj.GridPanel_rowclick = function()
	{
		obj.EditProduct();
	}
/*Viewport1新增代码占位符*/




	function ClearFrm(){
		obj.CTCode.setValue("");
		obj.CTDesc.setValue("");
		obj.CTExpandCode.setValue("");
		obj.CTRemark.setValue("");
		obj.CTActive.setValue(true);
		obj.CTDefault.setValue(false)
		obj.Rowid.setValue("");
		obj.CTCode.focus(true,3);
	}

	function SaveData(){
		if(!obj.FormPanel14.getForm().isValid()) {
			ExtTool.alert("提示","请检查必填项！");
			return;
		}
		
		if (obj.CTType.getValue()=="")
		{
			ExtTool.alert("提示", "请选择要维护的项目!");
			return;
			}
		var Instr="CTActive^CTCode^CTDefault^CTDesc^CTExpandCode^CTRemark^CTType"
		var Valuestr=ExtTool.GetValuesByIds(Instr);
		
		var cacheobj=ExtTool.StaticServerObject("web.DHCHM.HMCodeConfig");
		var IDstr=obj.Rowid.getValue()
		
		var ret=cacheobj.SaveData(IDstr,Valuestr)
	  var infoStr=ret.split("^");
	  if (infoStr[0]=="-1") {
	  	ExtTool.alert ("提示", infoStr[1]);	
		}
		else{
			ClearFrm();
		}
		
		obj.GridPanel4Store.load();
	}
	
	function SetCodeType(){
		// 得到选中的节点
		var selectedNode = obj.TypeTree.getSelectionModel().getSelectedNode();
    
    var tmpid = selectedNode.attributes.id;
    var tmpname = selectedNode.attributes.text;

		obj.main.setTitle(tmpname);
		if (tmpid!="0"){
			obj.CTType.setValue(tmpid);
			obj.main.setTitle(tmpname);
		}
		//清除
		ClearFrm();
		//数据展现
		obj.GridPanel4Store.load();
		
	}
	
	obj.EditProduct = function(){
		var selectObj = obj.GridPanel4.getSelectionModel().getSelected();
		//alert(selectObj);
		if (selectObj){
			
			obj.CTCode.setValue(selectObj.get("CTCode"));
			obj.CTDesc.setValue(selectObj.get("CTDesc"));
			obj.CTExpandCode.setValue(selectObj.get("CTExpandCode"));
			obj.CTRemark.setValue(selectObj.get("CTRemark"));
			if(selectObj.get("CTActive")=="true"){obj.CTActive.setValue("1")};
			else{obj.CTActive.setValue("0")};
			if (selectObj.get("CTDefault")=="true"){
				obj.CTDefault.setValue("1")};
			else{obj.CTDefault.setValue("0")}
			obj.Rowid.setValue(selectObj.get("ID"));
			
		}
		else{
			ExtTool.alert("提示","请先选中一行!");
		}		
	};
}












































































































































































































































































