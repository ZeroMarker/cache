
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
	obj.GridPanel_cellclick=function(g,row,col,e)
	{
		obj.GridPanel4_cellclick(g,row,col,e);
	}
/*Viewport1新增代码占位符*/




	function ClearFrm(){
		obj.HCCode.setValue("");
		obj.HCDesc.setValue("");
		obj.HCExpandCode.setValue("");
		obj.HCRemark.setValue("");
		obj.HCMonths.setValue("");
		obj.HCActive.setValue(true);
		obj.Rowid.setValue("");
		obj.HCCode.focus(true,3);
	}

	function SaveData(){
		if (obj.HCType.getValue()=="")
		{
			ExtTool.alert("提示", "请选择要维护的项目!");
			return;
			}
		if(!obj.FormPanel14.getForm().isValid()) {
			ExtTool.alert("提示","请检查必填项");
			return;
		}
		var Instr="HCActive^HCCode^HCDesc^HCExpandCode^HCMonths^HCRemark^HCType"
		var Valuestr=ExtTool.GetValuesByIds(Instr);
		
		var cacheobj=ExtTool.StaticServerObject("web.DHCHM.HMCodeConfig");
		var IDstr=obj.Rowid.getValue()
		///alert(Valuestr);
		var ret=cacheobj.SaveHumClass(IDstr,Valuestr)
	  var infoStr=ret.split("^");
	  if (infoStr[0]!="-1") {
	  	//ExtTool.alert("提示", "保存成功!");
	  	ClearFrm();  	
		}
		else{
			ExtTool.alert ("提示", infoStr[1]);
		}
		obj.GridPanel4Store.load();
	}
	
	function SetCodeType(){
		// 得到选中的节点
		var selectedNode = obj.TypeTree.getSelectionModel().getSelectedNode();
    
    var tmpid = selectedNode.attributes.id;
    var tmpname = selectedNode.attributes.text;

		
		if (tmpid!="0"){
			obj.HCType.setValue(tmpid);
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
			
			obj.HCCode.setValue(selectObj.get("HCCode"));
			obj.HCDesc.setValue(selectObj.get("HCDesc"));
			obj.HCExpandCode.setValue(selectObj.get("HCExpandCode"));
			obj.HCRemark.setValue(selectObj.get("HCRemark"));
			obj.HCMonths.setValue(selectObj.get("HCMonths"));
			if(selectObj.get("HCActive")=="true"){obj.HCActive.setValue("1")};
			else{obj.HCActive.setValue("0")};
			obj.Rowid.setValue(selectObj.get("ID"));
			
		}
		else{
			ExtTool.alert("提示","请先选中一行!");
		}		
	};
	
	obj.GridPanel4_cellclick = function(g,row,col,e)
	{
		var fieldName = g.getColumnModel().getDataIndex(col);
		if(fieldName!='EditExpression') return;
		var objWindowEx = new InitWindowEx();
		objWindowEx.WindowEx.show();
		var record=g.getStore().getAt(row);
		var ID=record.get("ID");
		objWindowEx.ESourceID.setValue(ID);
		var EType="2001";
		EType=EType+obj.HCType.getValue();
		///alert(EType);
		objWindowEx.EType.setValue(EType);
		objWindowEx.GridPanelExStore.load();
	};
}












































































































































































































































































