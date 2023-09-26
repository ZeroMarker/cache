//Create by zzp
// 20150521
//目录树维护
function InitviewScreen(){
	var obj = new Object();
	//******************************Start****************************
	obj.DirTreeStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=DirTreeStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.DirTreeStore.load();
	obj.DirTreeType = new Ext.form.ComboBox({
		id : 'DirTreeType'
		,width : 200
		,store : obj.DirTreeStore
		,minChars : 1
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '树类型'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.DirTreeAdd = new Ext.Button({
		id : 'DirTreeAdd'
		,iconCls : 'icon-add'
		,text : '新增'
	});
	obj.DirTreeDelete = new Ext.Button({
		id : 'DirTreeDelete'
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	obj.DirTreeUpdate = new Ext.Button({
		id : 'DirTreeUpdate'
		,iconCls : 'icon-Update'
		,text : '修改'
	});
	obj.DirTreeQuery = new Ext.Button({
		id : 'DirTreeQuery'
		,iconCls : 'icon-find'
		,text : '查询'
	});
	obj.contextmenu=new Ext.menu.Menu({  
                id:'theContextMenu',  
                items:[{       
				        text:'新增',  
						iconCls : 'icon-add',
                        handler:function(){  
                           obj.DirTreeAdd_OnClick();  
                           }  
                      },{
					    text:'删除',  
						iconCls : 'icon-delete',
                        handler:function(){  
                           obj.DirTreeDelete_OnClick();  
                           }  
					  },{
					    text:'更新',  
						iconCls : 'icon-Update',
                        handler:function(){  
                           obj.DirTreeUpdate_OnClick();  
                           }  
					  },{
					    text:'刷新',  
						iconCls : 'icon-find',
                        handler:function(){  
                           obj.DirTreeQuery_OnClick();  
                           }  
					  }]  
            });  
	obj.tbDirTree = new Ext.Toolbar({
	        id:'tbDirTree',
			enableOverflow : true,
			items : [new Ext.Toolbar.TextItem('树类型：'),obj.DirTreeType,'-',obj.DirTreeQuery,'-', obj.DirTreeAdd,'-',obj.DirTreeUpdate,'-',obj.DirTreeDelete]
		});
	obj.nodeid=new Ext.tree.TreeLoader({
	id:'nodeid',
	dataUrl:'PMP.Document.csp?actiontype=DirTree',
	clearOnLoad:true
	});
	obj.nodeid.on('beforeload', function(nodeid,node){
	if(obj.dDirTreeRoot.value!="undefined"){
		var url='PMP.Document.csp?actiontype=DirTree&InPut='+Ext.getCmp('DirTreeType').getValue();
		nodeid.dataUrl=url+'&parent='+node.id;
	}
    });
    obj.dDirTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
    text:'ceshi',
	value:'',
	expanded:true
    });
	obj.DirTree = new Ext.tree.TreePanel({
	            id:'DirTree',
	            border:false,
				width:300,
				height:700,
				title:'树结构管理',
    			animate:true,
				useArrows:true,
				//rootVisible:false,
    			enableDD:false,
    			containerScroll:true,
				tbar:obj.tbDirTree,
		        loader: obj.nodeid,
		        rootVisible:false,
				root:obj.dDirTreeRoot
		        //lines:false,
		        //autoScroll:true,
	});
	//--------------------------------------------------------------------
   obj.DirTreeType.on("select",function(cmb,rec,id ){
   //alert(schemeaddField.getValue());
    var url='PMP.Document.csp?actiontype=DirTree&InPut='+Ext.getCmp('DirTreeType').getValue();
	obj.nodeid.dataUrl=url+"&parent=0";	
	Ext.getCmp('DirTree').getNodeById("roo").reload();   
    });
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'fit'
		,frame : true
		,items : [obj.DirTree]});
	
	//--------------------------------------------------------------------------------------------

	InitviewScreenEvent(obj);	
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}

function AddDirTreeWind (rowid,type,flag){
    var obj = new Object();
    obj.AddDirTitle	= new Ext.form.TextField({
		id : 'AddDirTitle'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '标题'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AddDirType	= new Ext.form.TextField({
		id : 'AddDirType'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '类型'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AddDirNode	= new Ext.form.TextField({
		id : 'AddDirNode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '节点'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AddDirSub = new Ext.form.Checkbox({
		id : 'AddDirSub'
		,checked : false
		,fieldLabel : '子标题'
		,anchor : '99%'
	});
	obj.AddDirAdd = new Ext.Button({
		id : 'AddDirAdd'
		,iconCls : 'icon-add'
		,text : '保存'
	});
	obj.AddDirUpdate = new Ext.Button({
		id : 'AddDirUpdate'
		,iconCls : 'icon-Delete'
		,text : '取消'
	});
	obj.AddDirPanel=new Ext.Panel({
			id : 'AddDirPanel'
			,layout : 'form'
			,width : '100%'
			,frame:true
			,region : 'center'
			//,collapsible: true
			,labelWidth:60
			,border:true
			,items:[obj.AddDirTitle,obj.AddDirSub ]
		});
	obj.menuwindAddDir= new Ext.Window({
		id : 'menuwindAddDir'
		,height : 140
		,buttonAlign : 'center'
		,width : 330
		,modal : true
		,title : '树节点维护'
		,layout : 'form'
		,border:true
		,items:[
			   obj.AddDirPanel
		]
		,buttons:[
			   obj.AddDirAdd
			  ,obj.AddDirUpdate
		]
	});
    AddDirTreeWindEvent(obj,rowid,type,flag);	
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}