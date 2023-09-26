
var unitsUrl = 'dhcst.phccatmaintainaction.csp';
var gParentId=""

Ext.onReady(function() {

	Ext.QuickTips.init();// 浮动信息提示
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	//var addstr= document.URL;
	//var num=addstr.indexOf("orditm=") 

        //var Request = new Object();
        //Request = GetRequest();
        //var orditem = Request['orditm'];
        //var waycode = Request['waycode'];
        
        var CommitBedButton = new Ext.Button({
             //width : 65,
             id:"ComBedBtn",
             text: '保存',
             iconCls : 'page_save',
             //icon:"../scripts/dhcpha/img/addwl.gif",
             listeners:{
                          "click":function(){   
                             
                              CommitBedComment();
                              
                              }   
             }
             
         })
      var AddRootBT = new Ext.Toolbar.Button({
			text : '增加一级分类',
			//tooltip : '点击增加一级分类',
			iconCls : 'page_add',
			width : 70,
			height : 30,
			handler : function() {
				CatAdd("0","",Reflsh);
				//treepanel.getRootNode().reload();
			}
     })
     var AddBT = new Ext.Toolbar.Button({
			text : '增加子分类',
			tooltip : '点击增加子分类',
			iconCls : 'page_add',
			width : 70,
			height : 30,
			handler : function() {
				var node=treepanel.getSelectionModel().getSelectedNode();  //获取选中节点
				if (node==null) {Msg.info("warning", "请选择一条分类数据!");
	                                                       return;}
				CatAdd(node.attributes.id,node.text,Reflsh);
				
			}
     })
     function Reflsh()
     {ChildGridDs.load({params:{parentId:gParentId}});
	     treepanel.getRootNode().reload();}
     
     var UpdBT = new Ext.Toolbar.Button({
			text : '修改',
			tooltip : '点击修改分类描述',
			iconCls : 'page_save',
			width : 70,
			height : 30,
			handler : function() {
				var node=treepanel.getSelectionModel().getSelectedNode();  //获取选中节点
			 if (node==null) {Msg.info("warning", "请选择一条分类数据!");
	                           return;}
			 if (node.attributes.id==0) {Msg.info("warning", "根节点不允许修改!");
	                           return;}	                           
				CatUpd(node.attributes.id,node.text,Reflsh);
				//treepanel.getRootNode().reload();
			}
     })  
     var DeleteBT = new Ext.Toolbar.Button({
			text : '删除',
			tooltip : '点击删除',
			iconCls : 'page_delete',
			width : 70,
			height : 30,
			handler : function() {
			}
     })    
     var NewBT = new Ext.Toolbar.Button({
			text : '新建',
			tooltip : '点击新建',
			iconCls : 'page_add',
			width : 70,
			height : 30,
			handler : function() {
				if(gParentId!=""){
				    addNewRow();
				}else{
			      Msg.info("error", "请选择药理学分类!");
			      return false;
		      }
			}
     })  
     var SaveBT = new Ext.Toolbar.Button({
			text : '保存',
			tooltip : '点击保存',
			iconCls : 'page_save',
			width : 70,
			height : 30,
			handler : function() {
				SaveChildCat();
				Reflsh();
				//treepanel.getRootNode().reload();
			}
     })
	HospStore.load();
    var Hosp = new Ext.form.ComboBox({
	fieldLabel : '医院',
	id : 'Hosp',
	name : 'Hosp',
	anchor : '90%',
	width : 120,
	store : HospStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : '医院...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 250,
	valueNotFoundText : '',
	listeners:{
		specialKey:function(field, e) {
			if(e.getKey() == Ext.EventObject.ENTER){
				//addRow();	
			}
		}
	}
});  
	

  


	// 创建一个简写

	var Tree = Ext.tree;

	// 定义根节点的Loader

	var treeloader = new Tree.TreeLoader({

				dataUrl : unitsUrl + '?action=ListTreeData'

			});

	// 添加一个树形面板

	var treepanel = new Tree.TreePanel({

				//el : 'tree-panel',// 

				region : 'west',

				title : '药学分类视图',

				width : 500,

				//minSize : 180,

				//maxSize : 250,

				split : true,

				//autoHeight : true,
				
				height : 300,

				frame : true,

				autoScroll : true,

				enableDD : false,

				containerScroll : true,

				border : true,

				animate : true,
				
				//rootVisible:false,

				loader : treeloader,

				tbar:[AddRootBT, '-',AddBT, '-', UpdBT]

			});

	// 异步加载根节点

	var rootnode = new Tree.AsyncTreeNode({

				text : '药学分类',

				id : 'id',

				value : '0',

				level : '0',

				draggable : false , // 根节点不容许拖动

				expanded : true

			});

	// 为tree设置根节点

	treepanel.setRootNode(rootnode);

	// 响应加载前事件，传递node参数

	treeloader.on('beforeload', function(treeloader, node) {

				if (node == rootnode) {
					node.attributes.id = '0';
				}

				treeloader.baseParams = {
					id : node.attributes.id,
					level : node.attributes.level,
					actiontype : 'load'
				}

			}, this);;

	// 设置树的点击事件

	function treeClick(node, e) {
	
                 //if (node.isLeaf()){
                    CatAdd(node.attributes.id,node.text,Reflsh);
                    //treepanel.getRootNode().reload();
                //}

		//if (node.isLeaf()) {

			//e.stopEvent();
                        //Ext.getCmp('IncitmSelecter').clearValue();
			//FindItmDetail(node.attributes.level, node.id, "")
			//alert(node.attributes.level)
			//alert(node.id)

		//}

	}

	// 增加鼠标单击事件

	//treepanel.on('dblclick', treeClick);
	


	function rightClickFn(node, e){ 
	    e.preventDefault();
	     node.select();
	    rightClick.showAt(e.getXY());
		//selectreasongrid.getSelectionModel().selectRow(rowindex); 
    }
    //treepanel.addListener('ItemContextMenu', rightClickFn);//右键菜单代码关键部分
    treepanel.on("contextmenu",rightClickFn)
    var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{
					id: 'mnuAdd', 
					handler: function() {
				       var node=treepanel.getSelectionModel().getSelectedNode();  //获取选中节点
				       if(node==null){
					       Ext.Msg.show({title:'错误',msg:'请选择药学分类！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					       return;
					       }
				       CatAdd(node.attributes.id,node.text,Reflsh);
				       //treepanel.getRootNode().reload();
			        },
					text: '增加子分类',
					click:true
				},{
					id: 'mnuUpd', 
					handler: function() {
				        var node=treepanel.getSelectionModel().getSelectedNode();  //获取选中节点
				        if(node==null){
					       Ext.Msg.show({title:'错误',msg:'请选择药学分类！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					       return;
					       }
			 if (node.attributes.id==0) {Msg.info("warning", "根节点不允许修改!");
	                           return;}					       
				        CatUpd(node.attributes.id,node.text,Reflsh);
				        //treepanel.getRootNode().reload();
			        }, 
					text: '修改分类描述',
					click:true
				}]
    })
    
    function SaveChildCat(){
	    //获取所有的新记录
		if(ChildGrid.activeEditor != null){
			ChildGrid.activeEditor.completeEdit();
		} 
		
		
		
		var mr=ChildGridDs.getModifiedRecords();
		var rowid="",code="",desc="",hosp="";
		for(var i=0;i<mr.length;i++){
			var rowid =mr[i].get('RowId');
			var code = mr[i].data["Code"];
			var desc = mr[i].data["Desc"];
			var hosp = mr[i].data["Hospital"];
			if (code==""){Msg.info("warning","代码不能为空!");return;};
			//if (rowid==""){Msg.info("warning","类型不能为空!");return;};
			if (desc==""){Msg.info("warning","描述不能为空!");return;};
			//if (hosp==""){Msg.info("warning","医院不能为空!");return;};
	
			
		
		
		if((gParentId!="")&&(code!="")&&(desc!="")){
			var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
			Ext.Ajax.request({
				url: unitsUrl+'?action=SaveChildCat',
				params: {ParCat:gParentId,CatId:rowid,CatCode:code,CatDesc:desc},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", "请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
						ChildGridDs.load({params:{parentId:gParentId}});
						treepanel.getRootNode().reload();
					}
					else{
						if (jsonData.info==-11){
							Msg.info("warning", "代码重复");
						}else if (jsonData.info==-12){
							Msg.info("warning", "名称重复");
						}else{
							Msg.info("error", "保存失败,错误代码:"+jsonData.info);
						}
						
					}
				},
				scope: this
			});
		}
		else{Msg.info("error", "没有修改或添加新数据!")};
		}
	 }
	 function GetCurMaxCode(){
		var url="dhcst.phccatmaintainaction.csp?action=GetCurCode&CatId="+gParentId+"&Hospital="+session['LOGON.HOSPID'];
		var CurMaxCode=ExecuteDBSynAccess(url);
		return CurMaxCode;
		}


    function addNewRow() {
	var record = Ext.data.Record.create([
		{
			name : 'RowId',
			type : 'int'
		}, {
			name : 'Code',
			type : 'string'
		}, {
			name : 'Desc',
			type : 'string'
		}, {
			name : 'Hospital',
			type : 'string'
		}
	]);
	var curMaxCode=GetCurMaxCode();				
	var NewRecord = new record({
		RowId:'',
		Code:curMaxCode,
		Desc:'',
		Hospital:''
	});
					
	ChildGridDs.add(NewRecord);
	ChildGrid.startEditing(ChildGridDs.getCount() - 1, 1);
   }
    var ChildGridProxy= new Ext.data.HttpProxy({url:unitsUrl,method:'GET'});
    var ChildGridDs = new Ext.data.Store({
	proxy:ChildGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Desc'},
		{name:'Hospital'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
    });
    //模型
    var ChildGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"代码",
        dataIndex:'Code',
        width:100,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
			id:'codeField',
            allowBlank:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						ChildGrid.startEditing(ChildGridDs.getCount() - 1, 4);
					}
				}
			}
        })
	 },{
        header:"名称",
        dataIndex:'Desc',
        width:200,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
			id:'descField',
            allowBlank:true,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						ChildGrid.startEditing(ChildGridDs.getCount() - 1, 4);
					}
				}
			}
        })
	 }
	 ])
    ChildGrid = new Ext.grid.EditorGridPanel({
	store:ChildGridDs,
	cm:ChildGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
    tbar:[NewBT, '-', SaveBT],
	clicksToEdit:1
    });  
    var ChildPanel = new Ext.Panel({
		title:'下级分类视图',
		activeTab: 0,
		region:'center',
		layout:'fit',
		items:[ChildGrid]                                 
	});        	  
        
    treepanel.on('click',function(node,e){
	gParentId=node.attributes.id
	ChildGridDs.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetChild&parentId='+node.attributes.id,method:'GET'});
	ChildGridDs.load();
   });  

	
        
    var HisListTab = new Ext.form.FormPanel({
			height:30,
			labelAlign : 'right',
			title:'药学分类维护',
			frame : true,
			autoScroll : false,
			region : 'north',	
			bodyStyle:'padding:0px'//,
			//tbar : [AddRootBT, '-', AddBT, '-', DeleteBT]
    })

	var por = new Ext.Viewport({

				layout : 'border', // 使用border布局

				items : [treepanel,ChildPanel]

			});





        ///-----------------------Events----------------------

	//选择树事件
	/*
	function TreeNodeClickEvent(nodeid,nodedesc)
	{               
	                if (nodeid==0){
	                 return;
	                }
	                var totalnum =selectreasongrid.getStore().getCount() ;
			for(var i=0;i<totalnum;i++){		      
			        var reasondr=selectreasongridds.getAt(i).get("reasonrowid") ;	  	        
		  		if (reasondr==nodeid){	  		     
		  		     Ext.Msg.show({title:'提示',msg:'已存在,不能重复添加',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		  		     return;
		  		}
			}
	
	                var newselreagridds = selectreasongrid.getStore().recordType;
	                var p = new newselreagridds({
	                    reasondesc: nodedesc,
	                    reasonrowid: nodeid,
	                    reasonlevel:''
	                });
	                selectreasongrid.stopEditing();
	                //selectreasongridds.insert(0, p);
	                selectreasongridds.insert(totalnum, p);	                
	                //selectreasongrid.startEditing(0, 0);
	}
	*/


	 
	


	



	

      
	



});
