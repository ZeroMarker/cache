/**
 * @author Qse
 */

cspRunServerMethod(GetMainPat,"");
cspRunServerMethod(MakeAdmData,"");

   var mytree1=new Ext.tree.TreePanel({
       animate:true,
       title:"门急诊",
       collapsible:true,
       enableDD:true,
       enableDrag:true,
       rootVisible:true,
       autoScroll:true,
       autoHeight:true,
       width:250,
       lines:true
   });
   var mytree=new Ext.tree.TreePanel({
        animate:true,
       title:"病区列表",
       collapsible:true,
       enableDD:true,
       enableDrag:true,
       rootVisible:true,
       autoScroll:true,
       autoHeight:true,
       width:250,
       lines:true
   });
   var mytree2=new Ext.tree.TreePanel({
       animate:true,
       title:"住院",
       collapsible:true,
       enableDD:true,
       enableDrag:true,
       rootVisible:true,
       autoScroll:true,
       autoHeight:true,
       width:250,
       lines:true
   });
   //根节点
   var root=new Ext.tree.TreeNode({
       id:"root",
       text:"病区",
       expanded:true,
	   singleClickExpand:true
   });
  var no1=new Ext.tree.TreeNode({
       id:"nod1",
       text:"门急诊数据",
       expanded:true,
	   singleClickExpand:true
   });
   var root2=new Ext.tree.TreeNode({
       id:"root2",
       text:"关注项目总计",
       expanded:true,
	   singleClickExpand:true
   }); 
  cspRunServerMethod(GetSortDep,"NUR","addward");
 

   function addward(wardid,ward)
   {
 		//alert(ward);
   	 	var sub1=new Ext.tree.TreeNode({
       		id:wardid,
       		text:ward,
       		singleClickExpand:true
   		});
    	addsubnod(sub1);
    	root.appendChild(sub1);
   }
   //第一个子节点及其子节点
  function addsubnod(node)
  {
       	var sub1=new Ext.tree.TreeNode({
       		id:'bedcode',
       		text:'床位图',
       		singleClickExpand:true
   		});
    	node.appendChild(sub1); 
    	sub1=new Ext.tree.TreeNode({
       		id:'attention',
       		text:'关注数据',
       		singleClickExpand:true
   		});
    	node.appendChild(sub1); 
   		sub1=new Ext.tree.TreeNode({
       		id:'OutIn',
       		text:'出入转数据',
       		singleClickExpand:true
   		});
    	node.appendChild(sub1); 
 }
  
 //  root.appendChild(sub1);
   mytree.setRootNode(root);//设置根节点
   mytree1.setRootNode(no1);//设置根节点
   mytree2.setRootNode(root2);
mytree.on('click',function(node,event){  	
 
	//if (!node.isLeaf()){return;}
	var wardid =  node.parentNode.id;
 	var nodetype = node.id
	//alert(nodetype);
  	//frames['centerTab'].src="dhcmgwardpatlist.csp";
	if (nodetype=="attention"){
		//
		frames['centerTab'].location.href="dhcmgwardattenion.csp?Ward="+wardid+"&AttTyp=A"; 
	}
	if (nodetype=="bedcode"){
		//
		frames['centerTab'].location.href="dhcmgwardpatlist.csp?Ward="+wardid+"&AttTyp=A"; 
	}
	if (nodetype=="OutIn"){
		//cspRunServerMethod(GetMainPat,wardid);
		//alert(wardid);
		frames['centerTab'].location.href="dhcmgwardattenion.csp?Ward="+wardid+"&AttTyp=O"; 
	}
	//if (nodetype=="bedcode") frames['centerTab'].location.href="dhcmgwardattention.csp?Ward="+wardid; 
	//if (nodetype=="nurwork") frames['centerTab'].location.href="dhcmgwardattention.csp?Ward="+wardid; 
	return ;
}); 
mytree1.on('click',function(node,event){  	
	//if (!node.isLeaf()){return;}
 	var nodetype = node.id
	//alert(nodetype);
  	//frames['centerTab'].src="dhcmgwardpatlist.csp";
	if (nodetype=="nod1"){
		//
		frames['centerTab'].location.href="dhcmgwardattenion.csp?AttTyp=MZ"; 
	}
});
mytree2.on('click',function(node,event){  	
 	var nodetype = node.id
	if (nodetype=="root2"){
		frames['centerTab'].location.href="dhcmgallattention.csp?AttTyp=A^O"; 
	}
});
Ext.onReady(function(){ new Ext.Viewport({
	id: 'mainViewPort',
	shim: false,
	animCollapse: false,
	constrainHeader: true, 
	margins:'0 0 0 0',           
	layout: 'border',        
	border: false,             
	items: [{ 
		region: 'west', 
		layout: 'accordion',
		title: '功能菜单',
		width:190, 
		split: true, 
		autoScroll:true,
		collapsible: true, 
		bbar: null,
		titleCollapse: true,
		//html: '<iframe marginheight="0" marginwidth="0" height="100%" width="100%"></iframe>'
		items: [mytree2,mytree,mytree1
		]},{ 
			region: 'center', 
			title: '',
			width:190, 
			split: true, 
			autoScroll:true,
			html: '<iframe id ="centerTab" style="width:100%; height:100%;" src="dhcmgallattention.csp?AttTyp=A^O" ></iframe>'
			//html: '<iframe id ="centerTab" style="width:100%; height:100%;" src="dhcmgwardattenion.csp?AttTyp=MZ" ></iframe>'
		},{ 
			region: 'south', 
 			layout: 'accordion',
  			title: '护理管理',
			width:190, 
			split: true, 
			autoScroll:true,
			bbar: null,
			collapsible: true, collapsed: true, titleCollapse: false, layout: 'fit', height: 500,
			html: '<iframe id ="southTab" style="width:100%; height:100%" src="" ></iframe>'
			//html: '<iframe marginheight="0" marginwidth="0" height="100%" width="100%"></iframe>'
		}]
	})
})
// 	    var frameUrl = 'epr.newfw.centerTabDetial.csp?episodeID=' + episodeID + '&patientID=' + patientID + '&templateDocId=' + templateDocId + '&printTemplateDocId=' + printTemplateDocId;
  //Ext.getDom("tabHelpFrame").src= '../scripts/epr/help/help.htm';
