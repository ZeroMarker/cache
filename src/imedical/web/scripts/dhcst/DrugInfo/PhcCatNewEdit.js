
var unitsUrl = 'dhcst.phccatmaintainaction.csp';
var gQueryDesc=""
var newcatid=""
//function PhcCatNewEdit(newcatid,Fn){

	//Ext.QuickTips.init();// ������Ϣ��ʾ
	//Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	//var addstr= document.URL;
	//var num=addstr.indexOf("orditm=") 

        //var Request = new Object();
        //Request = GetRequest();
        //var orditem = Request['orditm'];
        //var waycode = Request['waycode'];
        
        
      var AddRootBT = new Ext.Toolbar.Button({
			text : '����һ������',
			tooltip : '�������һ������',
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				CatAdd("0","");
				treepanel.getRootNode().reload();
			}
     })
     var AddBT = new Ext.Toolbar.Button({
			text : '����',
			tooltip : '�������',
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				var node=treepanel.getSelectionModel().getSelectedNode();  //��ȡѡ�нڵ�
				CatAdd(node.attributes.id,node.text);
				treepanel.getRootNode().reload();
			}
     })  
     var DeleteBT = new Ext.Toolbar.Button({
			text : 'ɾ��',
			tooltip : '���ɾ��',
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
			}
     })  
     var QueryBT = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '�����ѯ',
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				gQueryDesc=Ext.getCmp("M_PhcDesc").getValue();
				treepanel.getRootNode().reload();
				gQueryDesc=""
			}
     })   
          var KongBT = new Ext.Toolbar.Button({
			text : 'ά��Ϊ��',
			tooltip : '���ά��Ϊ�գ�',
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
                    window.returnValue=""+"^"+"";
                    window.close();
			}
     }) 
	 var M_PhcDesc = new Ext.form.TextField({
			fieldLabel : 'ҩѧ��������',
			id : 'M_PhcDesc',
			name : 'M_PhcDesc',
			anchor : '90%',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						gQueryDesc=Ext.getCmp("M_PhcDesc").getValue();
				        treepanel.getRootNode().reload();
				        gQueryDesc=""
					}
				}
			}
		}); 
	

  


	// ����һ����д

	var Tree = Ext.tree;

	// ������ڵ��Loader

	var treeloader = new Tree.TreeLoader({

				dataUrl : unitsUrl + '?action=ListTreeDataById'

			});

	// ���һ���������

	var treepanel = new Tree.TreePanel({
				region : 'center',
				title : '��ʾ:˫��ѡȡ',
				width : 500,
				split : true,
				height : 300,
				frame : true,
				autoScroll : true,
				enableDD : false,
				containerScroll : true,
				border : true,
				animate : true,
				rootVisible:true,
				loader : treeloader,
				tbar:['����:',
					new Ext.form.TextField({
						id:'FindTreeText',
						width:150,
						emptyText:'�������������',
						enableKeyEvents: true,
						listeners:{
							keyup:function(node, event) {
								findByKeyWordFiler(node, event);
							},
							scope: this
						}
					}), '-', 
					{
						text:'���',
						iconCls:'page_clearscreen',
						handler:function(){
							clearFind();
						}
					  } ,'-',
					{
						text:'���ݿ�ֵ',
						iconCls:'page_refresh',
						handler:function(){
							window.returnValue=""+"^"+"";
		                    window.close();
						} //���������
				}]
			});

	// �첽���ظ��ڵ�

	var rootnode = new Tree.AsyncTreeNode({

				text : 'ҩѧ�༶����',

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
					checkednode : newcatid,
					querydesc:gQueryDesc,
					actiontype : 'load'
				}

			}, this);;

	// �������ĵ���¼�

	function treeClick(node, e) {
                 
                 //if (node.isLeaf()){
	                var url="dhcst.phccatmaintainaction.csp?action=GetAllCat&CatId="+node.attributes.id;
			        var catdescstr=ExecuteDBSynAccess(url);
                    window.returnValue=catdescstr+"^"+node.attributes.id;
                    window.close();
               // }


	}

	// �������˫���¼�

	treepanel.on('dblclick', treeClick);
	
	treepanel.on('expandnode', function(node) { 
	if(node.attributes.id==newcatid){     
	    node.select();//�˽ڵ㱻ѡ��
	}       
	}, this);

   var selectreasongridcm = new Ext.grid.ColumnModel({ 
	  columns:[
       
	        {header:'����',dataIndex:'reasondesc',width:300},
	        {header:'rowid',dataIndex:'reasonrowid',width:40},
	        {header:'�ּ�',dataIndex:'reasonlevel',width:40}  
	          ]   
	});
 
 
    var selectreasongridds = new Ext.data.Store({
	proxy: "",
        reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'reasondesc',
            'reasonrowid',
            'reasonlevel'
	    
		]),
		
		

        remoteSort: true
});
	function rightClickFn(grid,rowindex,e){ 
	    e.preventDefault();
	    rightClick.showAt(e.getXY());
		selectreasongrid.getSelectionModel().selectRow(rowindex); 
    }
        
    var HisListTab = new Ext.form.FormPanel({
			height:50,
			labelAlign : 'right',
			frame : true,
			autoScroll : false,
			region : 'north',	
			bodyStyle:'padding:5px 0px 0px 0px'
			//tbar : [M_PhcDesc, '-', QueryBT,'-',KongBT]
    })
function setCommFlag(){
    newcatid=gNewCatId;
}
//**************** ���������� ****************************************//
	var timeOutId = null;
	var treeFilter = new Ext.tree.TreeFilter(treepanel, {
		clearBlank : true,
		autoClear : true
	});
	// �����ϴ����صĿսڵ�
	var hiddenPkgs = [];
	var findByKeyWordFiler = function(node, event) {
		clearTimeout(timeOutId);// ���timeOutId
		treepanel.expandAll();// չ�����ڵ�
		// Ϊ�˱����ظ��ķ��ʺ�̨������������ɵ�ѹ��������timeOutId���п��ƣ��������treeFilterҲ��������ظ���keyup
		timeOutId = setTimeout(function() {
			// ��ȡ������ֵ
			var text = node.getValue();
			// ������������һ��������ʽ��'i'�������ִ�Сд
			var re = new RegExp(Ext.escapeRe(text), 'i');
			// ��Ҫ��ʾ�ϴ����ص��Ľڵ�
			Ext.each(hiddenPkgs, function(n) {
				n.ui.show();
			});
			hiddenPkgs = [];
			if (text != "") {
				treeFilter.filterBy(function(n) {
					// ֻ����Ҷ�ӽڵ㣬����ʡȥ֦�ɱ����˵�ʱ�򣬵��µ�Ҷ�Ӷ��޷���ʾ
					return !n.isLeaf() || re.test(n.text);
				});
				// �������ڵ㲻��Ҷ�ӣ���������û���ӽڵ㣬��Ӧ�����ص�
				treepanel.root.cascade(function(n) {
					if(n.id!='0'){
						if(!n.isLeaf() &&judge(n,re)==false&& !re.test(n.text)){
							hiddenPkgs.push(n);
							n.ui.hide();
						}
					}
				});
			} else {
				treeFilter.clear();
				return;
			}
		}, 500);
	}
	// ���˲�ƥ��ķ�Ҷ�ӽڵ������Ҷ�ӽڵ�
	var judge =function(n,re){
		var str=false;
		n.cascade(function(n1){
			if(n1.isLeaf()){
				if(re.test(n1.text)){ str=true;return; }
			} else {
				if(re.test(n1.text)){ str=true;return; }
			}
		});
		return str;
	};
	// ���������
	var clearFind = function () {
		Ext.getCmp('FindTreeText').reset();
		treepanel.root.cascade(function(n) {
					if(n.id!='0'){
							n.ui.show();
						}
				});
	}
//=========================ҩѧ�༶����=============================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	setCommFlag();
	var panel = new Ext.Panel({
		title:'ҩѧ�༶����',
		activeTab:0,
		region:'north',
		height:90,
		layout:'fit',
		items:[HisListTab]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		//items:[panel,treepanel],
		items:[treepanel],
		renderTo:'mainPanel'
	});
	
});
//

/*

	var window = new Ext.Window({
				title : 'ҩѧ����ά��',
				width :400,
				height : 600,
				modal:true,
				layout : 'border',
				items : [HisListTab,treepanel]
			});
	window.show();
	var rootnode=treepanel.getRootNode();
	var node = treepanel.getNodeById(rootnode.id);
   */

//}
