
var unitsUrl = 'dhcst.phccatmaintainaction.csp';
var gParentId=""

Ext.onReady(function() {

	Ext.QuickTips.init();// ������Ϣ��ʾ
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
             text: '����',
             iconCls : 'page_save',
             //icon:"../scripts/dhcpha/img/addwl.gif",
             listeners:{
                          "click":function(){   
                             
                              CommitBedComment();
                              
                              }   
             }
             
         })
      var AddRootBT = new Ext.Toolbar.Button({
			text : '����һ������',
			//tooltip : '�������һ������',
			iconCls : 'page_add',
			width : 70,
			height : 30,
			handler : function() {
				CatAdd("0","",Reflsh);
				//treepanel.getRootNode().reload();
			}
     })
     var AddBT = new Ext.Toolbar.Button({
			text : '�����ӷ���',
			tooltip : '��������ӷ���',
			iconCls : 'page_add',
			width : 70,
			height : 30,
			handler : function() {
				var node=treepanel.getSelectionModel().getSelectedNode();  //��ȡѡ�нڵ�
				if (node==null) {Msg.info("warning", "��ѡ��һ����������!");
	                                                       return;}
				CatAdd(node.attributes.id,node.text,Reflsh);
				
			}
     })
     function Reflsh()
     {ChildGridDs.load({params:{parentId:gParentId}});
	     treepanel.getRootNode().reload();}
     
     var UpdBT = new Ext.Toolbar.Button({
			text : '�޸�',
			tooltip : '����޸ķ�������',
			iconCls : 'page_save',
			width : 70,
			height : 30,
			handler : function() {
				var node=treepanel.getSelectionModel().getSelectedNode();  //��ȡѡ�нڵ�
			 if (node==null) {Msg.info("warning", "��ѡ��һ����������!");
	                           return;}
			 if (node.attributes.id==0) {Msg.info("warning", "���ڵ㲻�����޸�!");
	                           return;}	                           
				CatUpd(node.attributes.id,node.text,Reflsh);
				//treepanel.getRootNode().reload();
			}
     })  
     var DeleteBT = new Ext.Toolbar.Button({
			text : 'ɾ��',
			tooltip : '���ɾ��',
			iconCls : 'page_delete',
			width : 70,
			height : 30,
			handler : function() {
			}
     })    
     var NewBT = new Ext.Toolbar.Button({
			text : '�½�',
			tooltip : '����½�',
			iconCls : 'page_add',
			width : 70,
			height : 30,
			handler : function() {
				if(gParentId!=""){
				    addNewRow();
				}else{
			      Msg.info("error", "��ѡ��ҩ��ѧ����!");
			      return false;
		      }
			}
     })  
     var SaveBT = new Ext.Toolbar.Button({
			text : '����',
			tooltip : '�������',
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
	fieldLabel : 'ҽԺ',
	id : 'Hosp',
	name : 'Hosp',
	anchor : '90%',
	width : 120,
	store : HospStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	emptyText : 'ҽԺ...',
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
	

  


	// ����һ����д

	var Tree = Ext.tree;

	// ������ڵ��Loader

	var treeloader = new Tree.TreeLoader({

				dataUrl : unitsUrl + '?action=ListTreeData'

			});

	// ���һ���������

	var treepanel = new Tree.TreePanel({

				//el : 'tree-panel',// 

				region : 'west',

				title : 'ҩѧ������ͼ',

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

	// �첽���ظ��ڵ�

	var rootnode = new Tree.AsyncTreeNode({

				text : 'ҩѧ����',

				id : 'id',

				value : '0',

				level : '0',

				draggable : false , // ���ڵ㲻�����϶�

				expanded : true

			});

	// Ϊtree���ø��ڵ�

	treepanel.setRootNode(rootnode);

	// ��Ӧ����ǰ�¼�������node����

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

	// �������ĵ���¼�

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

	// ������굥���¼�

	//treepanel.on('dblclick', treeClick);
	


	function rightClickFn(node, e){ 
	    e.preventDefault();
	     node.select();
	    rightClick.showAt(e.getXY());
		//selectreasongrid.getSelectionModel().selectRow(rowindex); 
    }
    //treepanel.addListener('ItemContextMenu', rightClickFn);//�Ҽ��˵�����ؼ�����
    treepanel.on("contextmenu",rightClickFn)
    var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{
					id: 'mnuAdd', 
					handler: function() {
				       var node=treepanel.getSelectionModel().getSelectedNode();  //��ȡѡ�нڵ�
				       if(node==null){
					       Ext.Msg.show({title:'����',msg:'��ѡ��ҩѧ���࣡',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					       return;
					       }
				       CatAdd(node.attributes.id,node.text,Reflsh);
				       //treepanel.getRootNode().reload();
			        },
					text: '�����ӷ���',
					click:true
				},{
					id: 'mnuUpd', 
					handler: function() {
				        var node=treepanel.getSelectionModel().getSelectedNode();  //��ȡѡ�нڵ�
				        if(node==null){
					       Ext.Msg.show({title:'����',msg:'��ѡ��ҩѧ���࣡',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					       return;
					       }
			 if (node.attributes.id==0) {Msg.info("warning", "���ڵ㲻�����޸�!");
	                           return;}					       
				        CatUpd(node.attributes.id,node.text,Reflsh);
				        //treepanel.getRootNode().reload();
			        }, 
					text: '�޸ķ�������',
					click:true
				}]
    })
    
    function SaveChildCat(){
	    //��ȡ���е��¼�¼
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
			if (code==""){Msg.info("warning","���벻��Ϊ��!");return;};
			//if (rowid==""){Msg.info("warning","���Ͳ���Ϊ��!");return;};
			if (desc==""){Msg.info("warning","��������Ϊ��!");return;};
			//if (hosp==""){Msg.info("warning","ҽԺ����Ϊ��!");return;};
	
			
		
		
		if((gParentId!="")&&(code!="")&&(desc!="")){
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
				url: unitsUrl+'?action=SaveChildCat',
				params: {ParCat:gParentId,CatId:rowid,CatCode:code,CatDesc:desc},
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error", "������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success", "����ɹ�!");
						ChildGridDs.load({params:{parentId:gParentId}});
						treepanel.getRootNode().reload();
					}
					else{
						if (jsonData.info==-11){
							Msg.info("warning", "�����ظ�");
						}else if (jsonData.info==-12){
							Msg.info("warning", "�����ظ�");
						}else{
							Msg.info("error", "����ʧ��,�������:"+jsonData.info);
						}
						
					}
				},
				scope: this
			});
		}
		else{Msg.info("error", "û���޸Ļ����������!")};
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
    //ģ��
    var ChildGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"����",
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
        header:"����",
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
		title:'�¼�������ͼ',
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
			title:'ҩѧ����ά��',
			frame : true,
			autoScroll : false,
			region : 'north',	
			bodyStyle:'padding:0px'//,
			//tbar : [AddRootBT, '-', AddBT, '-', DeleteBT]
    })

	var por = new Ext.Viewport({

				layout : 'border', // ʹ��border����

				items : [treepanel,ChildPanel]

			});





        ///-----------------------Events----------------------

	//ѡ�����¼�
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
		  		     Ext.Msg.show({title:'��ʾ',msg:'�Ѵ���,�����ظ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
