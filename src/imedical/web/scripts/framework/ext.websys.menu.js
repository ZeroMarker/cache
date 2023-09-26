/*
 * Ext JS Library 3.1.0
 * Copyright(c) 2009-2010 DHCC
 */
//document.write('<style type="text/css"> .x-panel-ml{padding-left:0px;} .x-panel-mc{padding-top:0px;} .x-panel-mr{padding-right:1.5px;} </style>');  //2010.10.12  Lid  ���¶���Panel�ڱ߽���ʽ
Ext.onReady(function(){
	Ext.BLANK_IMAGE_URL='../scripts_lib/ext3.2.1/resources/images/default/s.gif';         //add by wuqk 2010-09-06 default icon path
    Ext.QuickTips.init();
    //var groupId = "1";  // session['LOGON.GROUPID'];	
	var centerpanel = new Ext.Panel({
		id:'centerpanel',
		region:"center",
		title:"",
		frame:true,
		autoScroll:true,
		//collapsible:true,   //�Զ�������ť 
		border:true,	
		layout:"accordion",
		layoutConfig: {animate: true}		
	})
	//##class(ext.websys.Menu).ShowBarJson(parent)
	var menusJson = tkMakeServerCall("ext.websys.Menu","ShowBarJson","1");
    if (menusJson=="") return;
    var menuArray = Ext.decode(menusJson);
    loadMenu(menuArray,centerpanel);
	var viewport = new Ext.Viewport({
        layout:'border',
        items:[centerpanel]
    });
   return;
	Ext.Ajax.request({
		url: 'ext.websysmenu.load.csp?val=1', //��csp��ִ��ҵ���߼���write����
		method : 'post',
		waitMsg:'������...',
		success: function(response, opts) {
			//var obj = Ext.decode(response.responseText);
			//console.dir(obj);
			//alert(response.responseText);
			window.eval("var menuArray = " + response.responseText);
			loadMenu(menuArray,centerpanel);
			//�Խ��յ������ݾ��д���
		},
		failure: function(response, opts) {
			console.log('server-side failure with status code ' + response.status);
		},
		scope : this
	});
	 //Ext.getCmp("centerpanel").layout.setActiveItem("2");  //2010.10.12 Lid ���á���ҳ��չ��
});
function SetKeepOpen(url,newwin) {
	parent.keepopen=true;	
	parent.location.href=url;
}
//modify by wanghc 
function loadMenu(menuArray,centerpanel){
	 for(var intRow = 0; intRow < menuArray.length; intRow ++){		
		var menuObj = menuArray[intRow];
		var proPanel = new Ext.Panel({
			title:menuObj.text,
			id:menuObj.id,			
			autoScroll:true,
			collapsed:true,
			menuObj:menuObj,
			firstClick: true,
			listeners:{"beforeexpand":function(p, animate){																							
					if(!p.firstClick) return ;
					var menuObj = p.menuObj;					
					var tree = new Ext.tree.TreePanel({
						border:false,
						animate:true,
						enableDD:false,
						containerScroll:true,
						loader: new Ext.tree.TreeLoader({nodeParameter : "id" ,dataUrl:"ext.websys.datatrans.csp?pClassName=ext.websys.Menu&pClassMethod=ShowBarJson"}),
						rootVisible:menuObj.leaf,
						lines:false,
						autoScroll:true,
						root: new Ext.tree.AsyncTreeNode({
							text: menuObj.text,		                          
							id: menuObj.id,
							href:menuObj.href,
							hrefTarget:menuObj.hrefTarget,
							leaf:menuObj.leaf,
							cls:menuObj.cls,
							expanded: menuObj.leaf
						}),
						listeners:{
							"click":function(node,event){
								if (node.isLeaf()){
									var s = node.attributes.cls;
									if (s.indexOf("javascript")>-1){
										window.eval(s);
									}
								}else{
									node.expand(!node.isExpanded());
								}
							}
						}
					});
					
					p.firstClick  = false;
					p.add(tree);
				}
			}			
		});
    	centerpanel.add(proPanel);		
	}
}