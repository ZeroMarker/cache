/**
 * @author Qse
 */
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
   
   //根节点
   var root=new Ext.tree.TreeNode({
       id:"root",
       text:"病区",
       expanded:true,
	   singleClickExpand:true
   });
 cspRunServerMethod(GetSortDep,"NUR","addward");
 

   function addward(wardid,ward)
   {
 //  	alert(ward);
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
       id:'nurwork',
       text:'工作量',
       singleClickExpand:true
   });
    node.appendChild(sub1); 
   sub1=new Ext.tree.TreeNode({
       id:'OutIn',
       text:'出入转',
       singleClickExpand:true
   });
    node.appendChild(sub1); 
 }
  
 //  root.appendChild(sub1);
   mytree.setRootNode(root);//设置根节点
mytree.on('click',function(node,event){  	
 
	//if (!node.isLeaf()){return;}

	var wardid =  node.parentNode.id;

 	var nodetype = node.id
  //frames['centerTab'].src="dhcmgnurwardinfo.csp";
	if (nodetype=="attention")
	{
		cspRunServerMethod(GetMainPat,wardid);
		frames['centerTab'].location.href="dhcmgwardattenion.csp?Ward="+wardid; 
	}
	if (nodetype=="bedcode") frames['centerTab'].location.href="dhcmgwardattention.csp?Ward="+wardid; 
	if (nodetype=="nurwork") frames['centerTab'].location.href="dhcmgwardattention.csp?Ward="+wardid; 
	return ;

}); 
Ext.onReady(function(){ new Ext.Viewport(
        {
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
                        title: '病区列表',
                        width:190, 
                        split: true, 
						autoScroll:true,
                        //collapsible: true, 
                       // bbar: null,
                       // titleCollapse: true,
                        //html: '<iframe marginheight="0" marginwidth="0" height="100%" width="100%"></iframe>'
                       items: [mytree
						]},
                        { region: 'center', layout: "border", id: "mainCenter",
                            items: [
                                    { border: false,tools: null, id: 'mainSouth', region: 'south', title: ' ', split: true, collapsible: true, collapsed: true, titleCollapse: false, layout: 'fit', height: 280,
                                        html: '<iframe id ="southTab" style="width:100%; height:100%" src="" ></iframe>'
                                    },
                                    { border: false,region: 'center', layout: 'fit',
									   // items:[ttab],
                                    	html: '<iframe id ="centerTab" style="width:100%; height:100%;" src="" ></iframe>'
                                    	//autoLoad: { scripts: true, scope: this, url:"",callback: function(){}} 
                                    }
								]
                        }
                    ]
        })})
// 	    var frameUrl = 'epr.newfw.centerTabDetial.csp?episodeID=' + episodeID + '&patientID=' + patientID + '&templateDocId=' + templateDocId + '&printTemplateDocId=' + printTemplateDocId;
  //Ext.getDom("tabHelpFrame").src= '../scripts/epr/help/help.htm';
