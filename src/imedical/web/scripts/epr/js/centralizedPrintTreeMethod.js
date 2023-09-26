//全选
function selectAll(node){
	node.getUI().toggleCheck(true);
	node.attributes.checked=true;
	var childNodes = node.childNodes;
	for(var i=0;i<childNodes.length;i++){
		var rootNode=childNodes[i];
		if(rootNode.leaf){
			rootNode.getUI().toggleCheck(true);
			rootNode.attributes.checked=true;
		}
		if(rootNode.childNodes.length>0){
			selectAll(rootNode);
		}
	}	
}

//增加选中项目到当前方案
function addItems(){
	//获取备选范围树中选中选项，形式是选中项目ID串，用^分隔大项CG，#分隔第二层CD
	//第一层为大项名称：比如病历文书，第二次是目录#范畴
	//例如：CG01#CD0101^CG02#CD0202^CG07#CD#1#2^CG07#CD#7#13
	schemeItems = "";
	//根节点下第一层
	for(var i = 0; i<rootNode.childNodes.length; i++){
	    var cgNode = rootNode.childNodes[i];
	    var cgID = cgNode.id;

		//第二层
		for (var j = 0; j < cgNode.childNodes.length; j++) {
			var cdNode = cgNode.childNodes[j];
			var cdID = cdNode.id;
			//没有第三层
			if (cdNode.leaf) {
				if (cdNode.attributes.checked) {
					if (schemeItems == "") {
						schemeItems = cgID + "#" + cdID
					}
					else {
						schemeItems = schemeItems + "^" + cgID + "#" + cdID
					}
				}
				else{
					continue;
				}
			}
		}
	}
	var schemeID = parent.Ext.getCmp('currentSchemeID').getValue();
	
	//ajax保存方案
	Ext.Ajax.request({
		url: '../web.eprajax.CentralizedPrintScheme.cls',
		timeout: 5000,
		methode: 'POST',
		params: {
			Action: "additems",
			SchemeID: schemeID,
			SchemeItems: schemeItems,
			UserID: userID
		},
		success: function(response, opts){
			//debugger;
			if (response.responseText == "-1") {
				Ext.MessageBox.alert('操作提示', "增加项目失败");
			}
			//没有删除权限
			else if (response.responseText == "nopower") 
			{
				Ext.MessageBox.alert("提示", "无删除权限");
			}
			else{
				var win1 = parent.Ext.getCmp('addItemWin');
				win1.hide();
			}
		},
		failure: function(response, opts){
			Ext.MessageBox.alert("提示", response.responseText);
		}
	});	
}

function moveBack(){
	var win1 = parent.Ext.getCmp('addItemWin');
	win1.close();
}
