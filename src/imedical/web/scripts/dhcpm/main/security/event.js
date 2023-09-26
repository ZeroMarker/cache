function InitEvent(obj) {

	var selectGroupNodeId="";
	var objMainService = ExtTool.StaticServerObject("DHCPM.SSService.Main");
	obj.treeSSGroup_click = function()
	{
		var objNode = arguments[0];
		//alert(objNode)
		selectGroupNodeId=objNode.id;
		//alert(objNode.id);
		obj.chkSelectAll.setValue(false);
		obj.treePMsTreeLoader.baseParams.groupId=selectGroupNodeId;
		obj.treePMs.loader=obj.treePMsTreeLoader;
		obj.treePMsTreeLoader.load(obj.treePMs.getRootNode());
		obj.treePMs.getRootNode().expanded=true;
		
		obj.chkSelectAllPors.setValue(false);
		obj.treePPorsTreeLoader.baseParams.groupId=selectGroupNodeId;
		obj.treePPors.loader=obj.treePPorsTreeLoader;		
		obj.treePPorsTreeLoader.load(obj.treePPors.getRootNode());
		obj.treePPors.getRootNode().expanded=true;
	};

	obj.findByKeyWordFiler=function(node,event)
	{
		var text = node.getValue(); 
		 // ������������һ��������ʽ��'i'�������ִ�Сд 
		var re = new RegExp(Ext.escapeRe(text), 'i');
	    /*  edit by  zzp  2015-06-02
		if(text != "")
		{
			//obj.treeFilter.filter(text);
			obj.treeFilter.filterBy(function(n) {   
           return re.test(n.text);   
          });   
		} */  
		//add  by   zzp  2015-06-02
		obj.treeFilter.filterBy(function(n) {   
           return re.test(n.text);   
          });   
	}

	obj.chkSelectAll_check = function()
	{
		var val = arguments[1];
		//alert(val)
		var roonode = obj.treePMs.getRootNode();  //��ȡ���ڵ�
    	setChildNode(roonode,val);                //��ʼ�ݹ�
	};
	
	/* obj.chkSelectAllPors_check = function()
	{
		var val = arguments[1];
		var roonode = obj.treePPors.getRootNode();  //��ȡ���ڵ�
    	setChildNode(roonode,val);                //��ʼ�ݹ�
	};
	 */
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
	
	/* 	obj.treePPors_checkchange = function()
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
	} */
	
	obj.btnSave_click = function()
	{
		//alert("save");
		if (selectGroupNodeId==""){
			ExtTool.alert("ȷ��", "��ѡ��һ����ȫ������Ȩ!");
			return false;
		}
		var roonode = obj.treePMs.getRootNode();
		var nodeStr = getChildString(roonode);
		
		/* var PorRoonode = obj.treePPors.getRootNode();
		var PorNodeStr = getChildString(PorRoonode); */
		//ExtTool.alert("info", nodeStr);    	
    	var ret = objMainService.Authorize(selectGroupNodeId,nodeStr);
    	//var ret1=objMainService.PorAuthorize(selectGroupNodeId,PorNodeStr);
    	if (ret!="1"){
    		ExtTool.alert("����", "������Ϣ����!",Ext.MessageBox.ERROR);
    	}
    	else{
    		ExtTool.alert("��Ϣ", "����ɹ�!");
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
    	for(var i=0;i<childnodes.length;i++){  //�ӽڵ���ȡ���ӽڵ����α���
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
		for(var i=0;i<childnodes.length;i++){  //�ӽڵ���ȡ���ӽڵ����α���
			var childnode = childnodes[i];
			str += childnode.id + "^" + (childnode.attributes.checked ? "1" : "0");
			str += "/";
			str += getChildString(childnode);
		}
		return str;
	}
}