///ҩѧ�༶���൯��

function PhcCatNewSelect(gNewPhcCatId,Fn) {	
	var phcmulticatdescstr=""
	var phcmulticatrowid=""
	var closeflag=""
	var unitsUrl = 'dhcst.phccatmaintainaction.csp';
	var gQueryDesc=""
	var newcatid="" 
	setCommFlag();
    Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
      var AddRootBT = new Ext.Toolbar.Button({
			text : $g('����һ������'),
			tooltip : $g('�������һ������'),
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				CatAdd("0","");
				treepanel.getRootNode().reload();
			}
     })
     var AddBT = new Ext.Toolbar.Button({
			text : $g('����'),
			tooltip : $g('�������'),
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
			text : $g('ɾ��'),
			tooltip : $g('���ɾ��'),
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
			}
     })  
     var QueryBT = new Ext.Toolbar.Button({
			text : $g('��ѯ'),
			tooltip : $g('�����ѯ'),
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
			text : $g('ά��Ϊ��'),
			tooltip : $g('���ά��Ϊ�գ�'),
			//iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
					closeflag="1"
                    window.close();
			}
     }) 
	 var M_PhcDesc = new Ext.form.TextField({
			fieldLabel : $g('ҩѧ��������'),
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
				//width : 500,
				split : true,
				//height : 300,
				frame : true,
				autoScroll : true,
				enableDD : false,
				containerScroll : true,
				border : true,
				animate : true,
				rootVisible:true,
				loader : treeloader,
				listeners: {        
                	afterrender: function(node) { 
                	}        
            	} ,
				tbar:[$g('����:'),
					new Ext.form.TextField({
						id:'FindTreeText',
						width:150,
						emptyText:$g('�������������'),
						enableKeyEvents: true,
						listeners:{
							keyup:function(node, event) {
								findByKeyWordFiler(node, event);
							},
							scope: this
						}
					}), '-', 
					{
						text:$g('���'),
						iconCls:'page_clearscreen',
						handler:function(){
							clearFind();
						}
					  } ,'-',
					{
						text:$g('���ݿ�ֵ'),
						iconCls:'page_refresh',
						handler:function(){
							closeflag="1"
		                    window.close();
						} //���������
				}]
			});

	// �첽���ظ��ڵ�
	var rootnode = new Tree.AsyncTreeNode({

				text : $g('ҩѧ�༶����'),

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

			}, this);
	// �������ĵ���¼�

	function treeClick(node, e) {
                 
                 //if (node.isLeaf()){
	                var url="dhcst.phccatmaintainaction.csp?action=GetAllCat&CatId="+node.attributes.id;
			        var catdescstr=ExecuteDBSynAccess(url);
			        phcmulticatdescstr=catdescstr;
					phcmulticatrowid=node.attributes.id;
                    closeflag="1"
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
       
	        {header:$g('����'),dataIndex:'reasondesc',width:300},
	        {header:'rowid',dataIndex:'reasonrowid',width:40},
	        {header:$g('�ּ�'),dataIndex:'reasonlevel',width:40}  
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
			labelAlign : 'right',
			frame : true,
			autoScroll : false,
			region : 'north',	
			bodyStyle:'padding:5px 0px 0px 0px'
			//tbar : [M_PhcDesc, '-', QueryBT,'-',KongBT]
    })
function setCommFlag(){
    newcatid=gNewPhcCatId;
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

	var panel = new Ext.Panel({
		activeTab:0,
		region:'north',
		items:[HisListTab]                                 
	});
	
	var window = new Ext.Window({
			title:$g('ҩѧ�༶����(˫��ѡȡ)'),
			layout:'border',
			modal:true,
			width : document.body.clientWidth*0.6,
			height : document.body.clientHeight*0.85,
			items:[treepanel]
		});
	window.show();	
	window.on('close', function(panel) {
			if (closeflag=="")
			{
				
			}
			else
			{
				Fn(phcmulticatdescstr,phcmulticatrowid)
			}
		});
		
}

