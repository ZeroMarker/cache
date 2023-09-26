function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

deptManagerFun = function(ds,grid,pagingToolbar){
    var rowObj = grid.getSelections();
    var len = rowObj.length;
    if(len < 1){
        Ext.Msg.show({title:'��ʾ',msg:'��ѡ���ŷֲ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;
    }
    if(repdr=="roo"){
		Ext.Msg.show({title:'��ʾ',msg:'���ڵ㲻��ά������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;
	}
	if(leaf){
		Ext.Msg.show({title:'��ʾ',msg:'���Ų���ά������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;
	}
	var parRef = rowObj[0].get("rowid");
    var deptTabProxy = new Ext.data.HttpProxy({url:deptSetUrl+'?action=adeptlist'});
	var deptTabDs = new Ext.data.Store({
		proxy: deptTabProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, [
			'parRef',
			'rowid',
			'childSub',
			'order',
            'unitTypeDr',
            'unitTypeName',
            'unitDr',
            'unitName',
			'deptDr',
			'deptCode',
			'deptName',
			'recFlag',
			'distFlag'
		]),
		remoteSort: true
	});

	deptTabDs.setDefaultSort('order', 'asc');

	if(type==0){
		var deptTabCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{
				header: "����˳��",
				dataIndex: 'order',
				width: 80,
				sortable: true
			},{
				header: '���Ŵ���',
				dataIndex: 'deptCode',
				width: 80,
				sortable: true
			},{
				header: '��������',
				dataIndex: 'deptName',
				width: 80,
				sortable: true
			},{
				header: "���ܱ�־",
				dataIndex: 'recFlag',
				width: 60,
				sortable: true,
				renderer : function(v, p, record){
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
			},{
				header: "��̯��־",
				dataIndex: 'distFlag',
				width: 60,
				sortable: true,
				renderer : function(v, p, record){
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
			}
		]);
	}else{
		var deptTabCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(),
			{
				header: "����˳��",
				dataIndex: 'order',
				width: 80,
				sortable: true
			},{
				header: '���Ŵ���',
				dataIndex: 'deptCode',
				width: 80,
				sortable: true
			},{
				header: '��������',
				dataIndex: 'deptName',
				width: 80,
				sortable: true
			}
		]);
	}
	
	var deptTabPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize:15,
		store:deptTabDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['active']="";
			B['parRef']=parRef;
			B['dir']=asc;
			B['sort']=order;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}

	});
	var addButton  = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '���',
		iconCls: 'add',
		handler: function(){
            addDeptFun(deptTabDs,formPanel,deptTabPagingToolbar,ds,pagingToolbar,parRef);
        }
	});

	var editButton  = new Ext.Toolbar.Button({
		text: '�޸�',
		tooltip: '�޸�',
		iconCls: 'add',
		handler: function(){
            editDeptFun(deptTabDs,formPanel,deptTabPagingToolbar,ds,pagingToolbar,parRef);
        }
	});
	var delButton  = new Ext.Toolbar.Button({
		text:'ɾ��',
		tooltip:'ɾ��',
		iconCls:'add',
		handler: function(){
			var rowObj = formPanel.getSelections();
			var len = rowObj.length;
			if(len < 1){
				Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫɾ���Ĳ�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				    function(btn) {
					    if(btn == 'yes'){
						    Ext.Ajax.request({
						        url:deptSetUrl+'?action=deletedept'+'&rowid='+rowObj[0].get("rowid"),
						        waitMsg:'ɾ����...',
						        failure: function(result, request) {
							        Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						        },
						        success: function(result, request) {
							        var jsonData = Ext.util.JSON.decode( result.responseText );
							        if (jsonData.success=='true') {
								        Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								        Ext.getCmp('detailReport').getNodeById(repdr).reload();
								        ds.load({params:{start:0, limit:pagingToolbar.pageSize,parent:parent,type:type,action:'gridlist',active:"",dir:'asc',sort:'order'}});
                                        deptTabDs.load({params:{start:0, limit:deptTabPagingToolbar.pageSize,parRef:parRef,active:"",dir:'asc',sort:'order'}});
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

	var formPanel = new Ext.grid.GridPanel({
		store: deptTabDs,
		cm: deptTabCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		tbar:[addButton,'-',editButton,'-',delButton],
		bbar: deptTabPagingToolbar
	});
	
	var window = new Ext.Window({
		title: '����ά��',
		width: 600,
		height:400,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
				text: '�رմ���',
				handler: function(){window.close();}
			}]
		});

	window.show();
	deptTabDs.load({params:{start:0, limit:deptTabPagingToolbar.pageSize,parRef:parRef,active:"",dir:'asc',sort:'order'}});
};