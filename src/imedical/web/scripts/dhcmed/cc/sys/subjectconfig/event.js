﻿
function InitViewport1Event(obj) {
	//加载类方法
	obj.SubjectConfig = ExtTool.StaticServerObject("DHCMed.CC.SubjectConfig");
	obj.MapConfigItem = ExtTool.StaticServerObject("DHCMed.CC.MapSubjectSubCat");
	
	obj.LoadEvent = function(args)
    {
		obj.btnUpdate.on("click",obj.btnUpdate_click,obj);
		obj.btnDelete.on("click",obj.btnDelete_click,obj);
		obj.gridConfig.on("rowclick",obj.gridConfig_rowclick,obj);
		obj.gridConfigStore.load({});
  	};
	
	obj.ClearFormItem = function()
	{
		obj.RecRowID = "";
		Common_SetValue("txtCode","");
		Common_SetValue("txtDesc","");
		Common_SetValue("chkIsActive",false);
		Common_SetValue("txtResume","");
		Common_SetValue("cboSubject","","");
	}
	
	obj.btnUpdate_click = function()
	{
		var errinfo = "";
		var Code = Common_GetValue("txtCode");
		var Desc = Common_GetValue("txtDesc");
		var IsActive = Common_GetValue("chkIsActive");
		var Resume = Common_GetValue("txtResume");
		var SubjectCode = Common_GetValue("cboSubject");
		if (!SubjectCode) {
			errinfo = errinfo + "监控主题为空!<br>";
		}
		if (!Code) {
			errinfo = errinfo + "代码为空!<br>";
		}
		if (!Desc) {
			errinfo = errinfo + "名称为空!<br>";
		}
		if (errinfo) {
			ExtTool.alert("错误提示",errinfo);
			return;
		}
		
		var selectObj = obj.gridConfig.getSelectionModel().getSelected();	
		var strCodeLast = (selectObj != null ? selectObj.get("Code") : "");
		var strCode = obj.txtCode.getValue();
		if ((strCode != strCodeLast) && (obj.gridConfigStore.findExact("Code", strCode) >-1))
		{
			ExtTool.alert("提示","代码与列表中的现有项目重复，请仔细检查!");
			return;
		}
		
		var inputStr = obj.RecRowID;
		inputStr = inputStr + "^" + SubjectCode;
		inputStr = inputStr + "^" + Code;
		inputStr = inputStr + "^" + Desc;
		inputStr = inputStr + "^" + (IsActive ? '1' : '0');
		inputStr = inputStr + "^" + Resume;
		var flg = obj.SubjectConfig.Update(inputStr);
		if (parseInt(flg) <= 0) {
			ExtTool.alert("错误提示","更新数据错误!Error=" + flg);
			return;
		}
		
		obj.ClearFormItem();
		obj.gridConfigStore.load({});
		obj.gridConfigStore.removeAll();
		obj.gridConfigStore.load({});
	}
	
	obj.btnDelete_click = function()
	{
		var objGrid = Ext.getCmp("gridConfig");
		if (objGrid){
			var arrRec = objGrid.getSelectionModel().getSelections();
			if (arrRec.length>0){
				Ext.MessageBox.confirm('删除', '是否删除选中数据记录?', function(btn,text){
					if(btn=="yes"){
						for (var indRec = 0; indRec < arrRec.length; indRec++){
							var objRec = arrRec[indRec];
							var flg = obj.SubjectConfig.DeleteById(objRec.get("RowId"));
							if (parseInt(flg) <= 0) {
								var row = objGrid.getStore().indexOfId(objRec.id);  //获取行号
								ExtTool.alert("错误提示","删除第" + row + "行数据错误!Error=" + flg);
							} else {
								obj.ClearFormItem();
								objGrid.getStore().remove(objRec);
							}
						}
					}
				});
			} else {
				ExtTool.alert("提示","请选中数据记录,再点击删除!");
			}
		}
	}
	
	obj.gridConfig_rowclick = function()
	{
		var index=arguments[1];
		var objRec = obj.gridConfig.getStore().getAt(index);
		if (objRec.get("RowId") == obj.RecRowID) {
			obj.ClearFormItem();
			//obj.gridItemDicStore.removeAll();
			obj.TreeControlsTreeLoader.baseParams.SubjectCode="";
		} else {
			obj.RecRowID = objRec.get("RowId");
			Common_SetValue("txtCode",objRec.get("Code"));
			Common_SetValue("txtDesc",objRec.get("Desc"));
			Common_SetValue("chkIsActive",(objRec.get("IsActive")=='1'));
			Common_SetValue("txtResume",objRec.get("Resume"));
			Common_SetValue("cboSubject",objRec.get("SubjectCode"),objRec.get("SubjectDesc"));
			obj.TreeControlsTreeLoader.baseParams.SubjectCode=objRec.get("SubjectCode");
		}
		obj.TreeControlsTreeLoader.baseParams.SubjectConfigID=objRec.get("RowId");
		obj.TreeControls.loader=obj.TreeControlsTreeLoader;
		obj.TreeControlsTreeLoader.load(obj.TreeControls.getRootNode());
		obj.TreeControls.getRootNode().expanded=true;
		obj.TreeControls.on("checkchange", obj.TreeControls_CheckChange, obj);
	};
	
	obj.TreeControls_CheckChange = function(){
		var node = arguments[0];
		var val = arguments[1];
		//obj.SelectNode 非常重要,避免checkchange引起的死循环
		if (obj.SelectNode) return;
		obj.SelectNode=node;
		setChildNode(node,val);
		setParentNode(node,val);
		obj.SelectNode=null;
		
		var ItemDicID=node.id.split("||")[2];
		var ConfigID = "";
		var objRecPos = obj.gridConfig.getSelectionModel().getSelected();
		if (objRecPos) {
			ConfigID = objRecPos.get("RowId");
		}
		if(node.attributes.checked)
		{
			var flg = obj.MapConfigItem.Update("^"+ConfigID+"^"+ItemDicID);
		}else{
			var flg = obj.MapConfigItem.DeleteMapConfigItem(ConfigID,ItemDicID);	
		}
	}
		
	setChildNode = function(argNode,argVal){
		//alert("setChildNode="+argNode.text+"//"+argVal);
		var childnodes = argNode.childNodes;
		for(var i=0;i<childnodes.length;i++){
			var childnode = childnodes[i];
			childnode.attributes.checked=argVal;
			childnode.getUI().toggleCheck(argVal);
			if(childnode.childNodes.length>0){
				setChildNode(childnode,argVal);
			}
      	}
	};
	
	setParentNode = function(argNode,argVal){
		//alert("setParentNode="+argNode.text+"//"+argVal);
		var parentnode=argNode.parentNode;
		if (!parentnode) return;
		if (parentnode.id=="root") return;
		if (argVal){
			parentnode.attributes.checked=true;
			parentnode.getUI().toggleCheck(true);
			setParentNode(parentnode,true);
		}else{
			var childnodes=parentnode.childNodes;
			var isChecked=false;
			for(var i=0;i<childnodes.length;i++){
				var childnode=childnodes[i];
				if (childnode.attributes.checked){
					isChecked=true;
				}
			}
			if (!isChecked){
				parentnode.attributes.checked=false;
				parentnode.getUI().toggleCheck(false);
				setParentNode(parentnode,false);
			}
		}
	};
	
	getChildString = function(node){
		var str = "";
		var childnodes = node.childNodes;
		for(var i=0;i<childnodes.length;i++){
			var childnode = childnodes[i];
			var nodeList = childnode.id.split("-");
			if (nodeList.length>2){
				if (nodeList[1]=="I"){
					if (childnode.attributes.checked){
						str = str + nodeList[0] + "/";
					}
				}
			}
			str += getChildString(childnode);
		}
		return str;
	}
}

