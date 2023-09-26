function InitEvent(obj) {
	var selectGroupNodeId="";
	var objMainService = ExtTool.StaticServerObject("DHCWMR.MainService.MainSrv");
	obj.treeSSGroup_click = function()
	{
		var objNode = arguments[0];
		selectGroupNodeId=objNode.id;
		//alert(objNode.id);
		obj.chkSelectAll.setValue(false);
		obj.treePMsTreeLoader.baseParams.groupId=selectGroupNodeId;
		obj.treePMs.loader=obj.treePMsTreeLoader;
		obj.treePMsTreeLoader.load(obj.treePMs.getRootNode());
		obj.treePMs.getRootNode().expanded=true;
	};
	
	obj.findByKeyWordFiler=function(node,event)
	{
		var text = node.getValue();
		// 根据输入制作一个正则表达式，'i'代表不区分大小写 
		var re = new RegExp(Ext.escapeRe(text), 'i');
		if(text != "")
		{
			//obj.treeFilter.filter(text);
			obj.treeFilter.filterBy(function(n) {
				return re.test(n.text);
			});
		}
	}
	
	obj.chkSelectAll_check = function()
	{
		var val = arguments[1];
		var roonode = obj.treePMs.getRootNode();  //获取根节点
		setChildNode(roonode,val);                //开始递归
	};
	
	obj.treePMs_checkchange = function()
	{
		var node = arguments[0];
		var val = arguments[1];
		//alert(node.text);
		if (val){
			checkParentNode(node);
		}
		else{
			noCheckChild(node);
		}
	}
	
	obj.btnSave_click = function()
	{
		//alert("save");
		if (selectGroupNodeId==""){
			ExtTool.alert("确认", "请选择一个安全组再授权!");
			return false;
		}
		var roonode = obj.treePMs.getRootNode();
		var nodeStr = getChildString(roonode);
		
		//ExtTool.alert("info", nodeStr);
		var ret = objMainService.Authorize(selectGroupNodeId,nodeStr);
		if (ret!="1"){
			ExtTool.alert("错误", "保存信息错误!",Ext.MessageBox.ERROR);
		}
		else{
			ExtTool.alert("信息", "保存成功!");
		}
	};
	
	checkParentNode = function(node){
		var parentNode=node.parentNode;
		if (parentNode.id!="root"){
			parentNode.attributes.checked=true;
			parentNode.getUI().toggleCheck(true);
			checkParentNode(parentNode);
		}
	};
	
	noCheckChild = function(node){
		var childnodes = node.childNodes;
		for(var i=0;i<childnodes.length;i++){
			var childnode = childnodes[i];
			childnode.attributes.checked=false;
			childnode.getUI().toggleCheck(false);
			if(childnode.childNodes.length>0){
				noCheckChild(childnode);
			}
		}
	};
	
	setChildNode = function(node,value){
		var childnodes = node.childNodes;
		for(var i=0;i<childnodes.length;i++){  //从节点中取出子节点依次遍历
			var childnode = childnodes[i];
			childnode.attributes.checked=value;
			childnode.getUI().toggleCheck(value);
			if(childnode.childNodes.length>0){
				setChildNode(childnode,value);
			}
		}
	};
	
	getChildString = function(node){
		var str = "";
		var childnodes = node.childNodes;
		for(var i=0;i<childnodes.length;i++){  //从节点中取出子节点依次遍历
			var childnode = childnodes[i];
			str += childnode.id + "^" + (childnode.attributes.checked ? "1" : "0");
			str += "/";
			str += getChildString(childnode);
		}
		return str;
	}
}