/**
 * @author Administrator
 */
/**
 * @author Qse
 */

 var EpisodeID="";
 Ext.onReady(function(){   
            //北边，标题栏   
            var north_item = new Ext.Panel({   
                title: '你的公司公司组织架构',   
                region: 'north',   
                //contentEl: 'north-div',   
                split: true,   
                border: true,   
                collapsible: true,   
                height: 50,   
                minSize: 50,   
                maxSize: 120   
            });   
               
            //南边，状态栏   
            var parr="DHCNURXH2^"+EpisodeID+"^CaseMeasureXml^";
            var emrknowurl="" //"dhcnuremrknow.csp?EmrCode=DHCNurKnowldge&Parr="+parr+"&EpisodeID="+EpisodeID;  
            //alert(emrknowurl)
            var south_item = new Ext.Panel({   
                title: '版权所有',   
                region: 'south',   
              //  contentEl: 'south-div',   
                split: true,   
                border: true,   
                collapsible: true,   
                height: 400,   
                minSize: 50,   
                html: '<iframe id ="southzsk" name="ddd" style="width:100%; height:100%" src='+emrknowurl+' ></iframe>', 
                maxSize: 120   
            });   
               
          
               
               
            //右边   知识库
            var east_item = new Ext.Panel({               
                region: 'east',                   
              //  el: 'center-center',                   
                title: '知识库',       
                split: true,   
                collapsible: true,   
                titlebar: true,   
                collapsedTitle: '内容',   
                height: 200,   
                width: 200,   
                minSize: 100,   
                maxSize: 400   
            });   
               
               
            //中间的南边,信息列表   
            var center_south_item = new Ext.Panel({   
                region: 'center',   
              //  contentEl: 'center-south',   
 				       html: '<iframe id ="centerTab" style="width:100%; height:100%;" src="" ></iframe>',
                split: true,   
                collapsible: true,   
                //titlebar: true,   
                autoHeight:true,
                collapsedTitle: '内容'   
            });   
               
            //中间   
            var center_item = new Ext.Panel({   
                region: 'center',   
                layout: 'border',   
                autoHeight:true,
                items: [center_south_item]   
            });   
               
               
            //西边，后台管理            
            var west_item = new Ext.Panel({   
               // title: '护理病历',   
                region: 'west',   
              //  contentEl: 'west-div',   
                split: true,   
                border: true,   
                collapsible: true,   
                width: 360,   
                height:200,
                //minSize: 120,   
                //maxSize: 200,   
                layout: "accordion",   
                layoutConfig: {   
                    animate: true   
                },   
                items: [{   
                    title: "护理病历",   
                    html: '<div id="tree"></div>'   
                }]   
            });   
            //设置树形面板   
            //定义树的跟节点   
           var root = new Ext.tree.AsyncTreeNode({   
 
            });   
    var THeight=window.screen.height-180;   
    var Tree = Ext.tree;
    var treeLoader = new Tree.TreeLoader( {dataUrl : "../NurMp.DHCNURMPMENUOnPage.cls?&ActionType=0"});         
    var tree = new Tree.TreePanel({
		//el:"currentDocs",
		rootVisible: false,
		autoScroll:true,
		//trackMouseOver:false,
		//title:'护理病历',
		animate:true,
		containerScroll:true,
		//bodyStyle:'padding:5px 1px 0',
		lines:true, 
		//checkModel:'cascade',
		//autoHeight:true,
		height:THeight,
		width:360,
		border:true,
		loader : treeLoader,
		id:"myTree"
		//tbar:treeTbar,
		//bbar:treeBbar
	});
	var rootNode = new Tree.AsyncTreeNode( {
		text : '护理病历',
		nodeType: 'async',
		draggable : false,
		id : "RT0"
    });		
    //抛出异常时的处理				
    treeLoader.on("loadexception", function(tree, node, response) {
	    var obj = response.responseText;
    });   
    tree.setRootNode(rootNode);
    rootNode.expand(true); 
    new Ext.Viewport({   
                layout: "border",   
                items: [west_item
                       , 
                       center_item,
                       {
									       xtype : "tabpanel",
									       enableTabScroll : true,
		                     autoWidth : true,
			                   //scrollIncrement : 500,
									      //tabWidth : 230,
									      minTabWidth : 20,
									      resizeTabs : true,
									      id : "NurTabpanel",
									      region : "center",
									      items : []
								       }]   
      }); 
          //,east_item,south_item
 tree.render('tree');
 tree.doLayout();
tree.on('click',function(node,event){  	
  nodeclick(node, event);
  return
	}); 
});   

function nodeclick(node, e) {
  var nodetype = node.id
  if (nodetype=="RT0")
  {
  	return
  }
	var wardid = node.parentNode.id;
	
	if (node.leaf == "true") {
	
		var nurtab = Ext.getCmp("NurTabpanel");
		var tabpic = nurtab.getComponent("tabpic"); //图片		
		
		var oItem = {};

		var hlurl="DHCNurEmrComm.csp?EpisodeID="+EpisodeID+"&EmrCode=DHCNURPGD_Rule"+"&NurRecId="+node.id;
		
		oItem.id = "tab" + node.id;
		oItem.title = node.text;
		oItem.closable = true;
		oItem.listeners={activate: function (tab) { 
			             var parr=node.id+"^"+EpisodeID+"^CaseMeasureXml^";
                   var emrknowurl="dhcnuremrknow.csp?EmrCode=DHCNurKnowldge&Parr="+parr+"&EpisodeID="+EpisodeID;  
                   //alert(emrknowurl)
									// document.getElementById("southzsk").src= emrknowurl
									}}
		var frameid = "iframe" + oItem.id;
		oItem.html = '<iframe id="'
				+ frameid
				+ '" scrolling="auto" frameborder="0" width="100%" height="100%" src="'
				+ hlurl + '"> </iframe>'
		nurtab.add(oItem);
		nurtab.setActiveTab("tab" + node.id);
	}

} 