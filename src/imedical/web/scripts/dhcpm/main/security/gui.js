function Init() {
    var obj = new Object();
   
	obj.treeSSGroupTreeLoader = new Ext.tree.TreeLoader({
			//nodeParameter : 'Arg1',
			dataUrl : ExtToolSetting.TreeQueryPageURL,
			baseParams : {
				ClassName : 'DHCPM.Base.SSGroup',
				QueryName : 'QueryAllForTree',
				ArgCnt : 0
			}
		});
	
	 obj.treeSSGroup = new Ext.tree.TreePanel({
		buttonAlign : 'center'
		,title:'��ȫ��'
		,region : 'west'
		,width:300
		,rootVisible:false
		,autoScroll:true
		,loader : obj.treeSSGroupTreeLoader
		,root : new Ext.tree.AsyncTreeNode({id:'0', text:''})
		,tbar:[' ',   
            new Ext.form.TextField({   
                width:150,   
                emptyText:'���ټ���',   
                enableKeyEvents: true,   
                listeners:{   
                    keyup:function(node, event) {   
                        obj.findByKeyWordFiler(node, event);   
                    },   
                    scope: this  
                }   
            })   
           ]
});
	obj.treeFilter = new Ext.tree.TreeFilter(obj.treeSSGroup, {
        clearBlank: true,
        autoClear: true
    });
    
	obj.treePMsTreeLoader = new Ext.tree.TreeLoader({
			nodeParameter : 'Arg1',
			dataUrl : "dhcpm.main.loadpmo.csp",
			baseParams : {
				groupId:"0"
			}			
		});
	
	obj.treePMs = new Ext.tree.TreePanel({
		//buttonAlign : 'center'
		title:'�˵�'
		,region : 'center'
		,width:350
		,rootVisible:false
		,autoScroll:true
		,loader : null //obj.treePMsTreeLoader
		,root : new Ext.tree.AsyncTreeNode({id:'root',text:'root'})
	});
	
	obj.chkSelectAll = new Ext.form.Checkbox({
		fieldLabel : 'ȫѡ/ȫ��ѡ'
	});
	
	obj.treeMsPanel = new Ext.Panel({
		//buttonAlign : 'center'
		region : 'center'
		,layout : 'border'
		,items:[
			{
			layout : 'fit'
			,region : 'center'
			,width:350 
			,items:[obj.treePMs]
			}	
			,{
			layout : 'form'
			,region : 'south'
			,height:40 
			,frame : true 
			,items:[obj.chkSelectAll]
			}
		]
	});
	obj.panelCenter = new Ext.Panel({
		buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,items:[
			{
			layout : 'fit'
			,region : 'center'
			,width:350 
			,items:[obj.treeMsPanel]
			}			
		]
		,buttons:[
			{id:'btnSave',
		 	 text:'����',
		 	 iconCls:'icon-save'}	
			]
		
	});
	obj.viewPanel = new Ext.Viewport({
		layout : 'border'
		,items:[
			obj.treeSSGroup
			,obj.panelCenter
		]
	});
	InitEvent(obj);

	//�¼��������

	obj.treeSSGroup.on("click", obj.treeSSGroup_click, obj);
	obj.chkSelectAll.on("check", obj.chkSelectAll_check, obj);
	//obj.chkSelectAllPors.on("check", obj.chkSelectAllPors_check, obj);
	obj.treePMs.on("checkchange", obj.treePMs_checkchange, obj);
	//obj.treePPors.on("checkchange", obj.treePPors_checkchange, obj);
	Ext.get("btnSave").on("click", obj.btnSave_click, obj);
	
    return obj;
}