if (type=="0"){
	rooText="�ɱ�����ֲ���";
}else{
	rooText="���ŷֲ���";
}
//���νṹ������
var deptTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	uiProviders:{
		'col': Ext.tree.ColumnNodeUI
	}
});

//����ǰ�¼�
deptTreeLoader.on('beforeload', function(deptTreeLoader,node){
	var url=deptSetUrl+'?action=treelist&type='+type+'&parent='+node.id+'&sort=order'+'&dir=asc';
	deptTreeLoader.dataUrl=url;
});
//���νṹ�ĸ�
var deptTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
	text:rooText,
	value:'0',
	expanded:true
});


var findDeptButton  = new Ext.Toolbar.Button({
	text: '�鿴δ���䲿��',
	tooltip: '�鿴δ���䲿��',
	iconCls: 'add',
	handler: function(){
		if(repdr.split("||").length>1){
		    Ext.Msg.show({title:'ע��',msg:'����ѡ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	    }
		if(repdr == "roo"){
		    Ext.Msg.show({title:'ע��',msg:'�˽ڵ㲻�ܲ鿴!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	    }
	    //============================================================���ؼ�=============================================================
        var findCommTabProxy = new Ext.data.HttpProxy({url:deptSetUrl+'?action=undist'});

	    function formatDate(value){
		    return value ? value.dateFormat('Y-m-d'):'';
	    };

	    var findCommTabDs = new Ext.data.Store({
		    proxy: findCommTabProxy,
		    reader: new Ext.data.JsonReader({
			    root: 'rows',
			    totalProperty: 'results'
		    }, [
			    'rowid',
                'parRef',
                'childSub',
			    'code',
			    'name',
                'py',
			    'shortcut',
                'phone',
			    'location',
			    'remark',
			    {name:'start',type:'date',dateFormat:'Y-m-d'},
			    {name:'stop',type:'date',dateFormat:'Y-m-d'},
                'vFlag',
                'active'
		    ]),
		    remoteSort: true
	    });

	    //--------------------------------
	    var unitTypeDs = new Ext.data.Store({
		    proxy: "",
		    reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','remark','flag','active'])
	    });
	    var unitType = new Ext.form.ComboBox({
		    id: 'unitType',
		    fieldLabel: '��Ԫ���',
		    anchor: '90%',
		    listWidth : 260,
		    allowBlank: false,
		    store: unitTypeDs,
		    valueField: 'rowid',
		    displayField: 'name',
		    triggerAction: 'all',
		    emptyText:'ѡ��Ԫ���...',
		    pageSize: 10,
		    minChars: 1,
		    selectOnFocus: true,
		    forceSelection: true
	    });
	    unitTypeDs.on('beforeload', function(ds, o){
		    ds.proxy=new Ext.data.HttpProxy({
				url:deptSetUrl+'?action=unittype&searchValue='+Ext.getCmp('unitType').getRawValue()+'&active=Y',method:'POST'})
	    });

	    var unitsDs = new Ext.data.Store({
		    proxy: "",
		    reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','py','shortcut','address','phone','contact','remark','unitTypeDr','active'])
	    });
	    var units = new Ext.form.ComboBox({
		    id: 'units',
		    fieldLabel: '��Ԫ',
		    anchor: '90%',
		    listWidth : 260,
		    allowBlank: false,
		    store: unitsDs,
		    valueField: 'rowid',
		    displayField: 'name',
		    triggerAction: 'all',
		    emptyText:'ѡ��Ԫ...',
		    pageSize: 10,
		    minChars: 1,
		    selectOnFocus: true,
		    forceSelection: true
	    });

	    unitType.on("select",function(cmb,rec,id ){
		    units.setRawValue("");
		    units.setValue("");
		    unitsDs.load({params:{start:0, limit:cmb.pageSize/*,id:cmb.getValue()*/}});

	    });
	    unitsDs.on('beforeload', function(ds, o){
		    ds.proxy=new Ext.data.HttpProxy({
                url:deptSetUrl+'?action=unit&searchValue='+Ext.getCmp('units').getRawValue()+'&unittypedr='+Ext.getCmp('unitType').getValue()+'&active=Y',method:'POST'})
	    });
	    //--------------------------------

	    var findCommTabCm = new Ext.grid.ColumnModel([
		    new Ext.grid.RowNumberer(),{
    		    header: '����',
			    dataIndex: 'code',
			    width: 80,
			    align: 'left',
			    sortable: true
		    },{
			    header: "����",
			    dataIndex: 'name',
			    width: 80,
			    align: 'left',
			    sortable: true
		    },{
			    header: "ƴ��",
			    dataIndex: 'py',
			    width: 70,
			    align: 'left',
			    sortable: true
		    },{
			    header: "λ��",
			    dataIndex: 'location',
			    width: 100,
			    align: 'left',
			    sortable: true
		    },{
			    header: "��ע",
			    dataIndex: 'remark',
			    width: 100,
			    align: 'left',
			    sortable: true
		    },{
			    header: "��������",
			    dataIndex: 'start',
			    width: 80,
			    align: 'left',
			    sortable: true,
			    renderer: formatDate
		    },{
			    header: "ͣ������",
			    dataIndex: 'stop',
			    width: 80,
			    align: 'left',
			    sortable: true,
			    renderer: formatDate
		    },{
			    header: "�绰",
			    dataIndex: 'phone',
			    width: 100,
			    align: 'left',
			    sortable: true
		    },{
			    header: "�����־",
			    dataIndex: 'vFlag',
			    width: 80,
			    align: 'left',
			    sortable: true,
                renderer : function(v, p, record){
				    p.css += ' x-grid3-check-col-td';
				    return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			    }
		    },{
			    header: "��Ч��־",
			    dataIndex: 'active',
			    width: 80,
			    align: 'left',
			    sortable: true,
                renderer : function(v, p, record){
				    p.css += ' x-grid3-check-col-td';
				    return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			    }
		    }
	    ]);

		var findCommTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
			pageSize: 10,
			store: findCommTabDs,
			displayInfo: true,
			displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
			emptyMsg: "û������",
			doLoad:function(C){
				var B={},
				A=this.paramNames;
				B[A.start]=C;
				B[A.limit]=this.pageSize;
				B['unitDr']=units.getValue();
				B['deptSetDr']=repdr;
				if(this.fireEvent("beforechange",this,B)!==false){
					this.store.load({params:B});
				}
			}
		});


		//==========================================================���==========================================================
		var formPanel = new Ext.grid.GridPanel({
			store: findCommTabDs,
			cm: findCommTabCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:['��λ���:',unitType,'��λ:',units],
			bbar: findCommTabPagingToolbar
		});
		//============================================================����========================================================
		var window = new Ext.Window({
			title: 'δ��Ӳ��Ų�ѯ����',
			width: 950,
			height:450,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [{
				text: 'ȡ��',
				handler: function(){window.close();}
			}]
		});

		window.show();
		units.on("select",function(cmb,rec,id ){
			findCommTabDs.load({params:{start:0, limit:findCommTabPagingToolbar.pageSize,unitDr:cmb.getValue(),deptSetDr:repdr}});
		});
	}
});

var copyButton  = new Ext.Toolbar.Button({
	text:'���Ʒֲ���',
	tooltip:'���Ʒֲ���',
	iconCls:'remove',
	handler: function(){
		if(leaf!=false){
			Ext.Msg.show({title:'ע��',msg:'��ѡ��Ĳ��ǽڵ�,���ܽ��и���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ����ѡ���ķֲ���?',
			function(btn) {
				if(btn == 'yes'){
					Ext.Ajax.request({
						url:deptSetUrl+'?action=copy&deptSetDr='+repdr+'&type='+type,
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'ע��',msg:'���Ƴɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								Ext.getCmp('detailReport').getNodeById("roo").reload();
								deptSetDs.load({params:{start:0, limit:deptSetPagingToolbar.pageSize,parent:parent,type:type,action:'gridlist',active:""}});
							}else{
								var message="";
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			})
		}
	}
});

var detailReport = new Ext.tree.TreePanel({
	id:'detailReport',
	width:300,
	region: 'west',
	split: true,
	autoScroll:true,
	collapsible: true,
	containerScroll: true,
	rootVisible: true,
    title:rooText,
	tbar: [findDeptButton,'-',copyButton],
	columns:[{
		dataIndex:'name'
	}],
    loader:deptTreeLoader,
    root:deptTreeRoot,
	listeners:{
		beforeexpandnode:{fn:alt},
		click:{fn:nodeClicked}
	}
});

function nodeClicked(node){
	parent=node.id;
	repdr=parent;
	leaf=node.leaf;
	deptSetDs.load({params:{start:0, limit:deptSetPagingToolbar.pageSize,type:type,parent:parent,action:'gridlist'}});
}
function alt(node){
	parent=node.id;
	repdr=parent;
	leaf=node.leaf;
	deptSetDs.load({params:{start:deptSetPagingToolbar.cursor,limit:deptSetPagingToolbar.pageSize,type:type,parent:parent,action:'gridlist'}});
}
deptTreeRoot.expand();
