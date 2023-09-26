   
function getBorwserTree(episodeID)
{
      var Tree = Ext.tree;
      var treeLoader = new Tree.TreeLoader( {dataUrl : "../web.eprajax.brwoserTestTree.cls?EpisodeID=" + episodeID});
      var tree = new Tree.TreePanel( {
				
				rootVisible: true,
				autoScroll:true,
				animate:false,
				//enableDD:true,
				containerScroll:true,
				lines:true, 
				checkModel:'cascade',
				autoHeight:true,
				border:false,
				loader : treeLoader,
				id:"browserTreeTest"				
      });
      
      var root = new Tree.AsyncTreeNode( {
				text : '电子病历',
				nodeType: 'async',
				draggable : false,
				id : "XT0"
      });	
	

     tree.on('click',function(node,event){
		selectNode = node;
     }); 

      tree.setRootNode(root);
      root.expand(); 
      return tree;
}
	
	
new Ext.Toolbar({renderTo: 'pagetoolbar', items:['-',
	{ id : 'cboEprRecordTest',listWidth: 170, resizable: false, xtype :'combo', width: 120, readOnly: true, mode: 'local',store: new Ext.data.SimpleStore({ fields:[], data:[[]]}),
		tpl: '<tpl for="."><div id="divTreeTest" style="height: 200px;"><div id="divBrowserTreeTest"></div></div></tpl>',
			valueField: "retrunValue", displayField: "displayText",blankText: '请选择查询条件', 
			emptyText: '请选择查询条件',editable : false, triggerAction : 'all', allowBlank : false},
	{id:'btnConfirmTest',text:'确定',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/btnConfirm.gif',pressed:false, handler: confirm},'-',
	{id:'btnBrowerTest',text:'浏览',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/browser.gif',pressed:false,handler:browser},
	'->'
	]});

	
Ext.getCmp('cboEprRecordTest').on('Expand', function(){
	if(!Ext.getCmp('browserTreeTest'))
	{
		getBorwserTree(episodeID).render('divBrowserTreeTest');
	}
	
});