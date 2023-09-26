function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

deptManagerFun = function(ds,grid,pagingToolbar){
    var rowObj = grid.getSelections();
    var len = rowObj.length;
    if(len < 1){
        Ext.Msg.show({title:'提示',msg:'请选择部门分层套!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;
    }
    if(repdr=="roo"){
		Ext.Msg.show({title:'提示',msg:'根节点不能维护部门!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;
	}
	if(leaf){
		Ext.Msg.show({title:'提示',msg:'部门不能维护部门!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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
				header: "部门顺序",
				dataIndex: 'order',
				width: 80,
				sortable: true
			},{
				header: '部门代码',
				dataIndex: 'deptCode',
				width: 80,
				sortable: true
			},{
				header: '部门名称',
				dataIndex: 'deptName',
				width: 80,
				sortable: true
			},{
				header: "接受标志",
				dataIndex: 'recFlag',
				width: 60,
				sortable: true,
				renderer : function(v, p, record){
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
				}
			},{
				header: "分摊标志",
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
				header: "部门顺序",
				dataIndex: 'order',
				width: 80,
				sortable: true
			},{
				header: '部门代码',
				dataIndex: 'deptCode',
				width: 80,
				sortable: true
			},{
				header: '部门名称',
				dataIndex: 'deptName',
				width: 80,
				sortable: true
			}
		]);
	}
	
	var deptTabPagingToolbar = new Ext.PagingToolbar({//分页工具栏
		pageSize:15,
		store:deptTabDs,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据",
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
		text: '添加',
		tooltip: '添加',
		iconCls: 'add',
		handler: function(){
            addDeptFun(deptTabDs,formPanel,deptTabPagingToolbar,ds,pagingToolbar,parRef);
        }
	});

	var editButton  = new Ext.Toolbar.Button({
		text: '修改',
		tooltip: '修改',
		iconCls: 'add',
		handler: function(){
            editDeptFun(deptTabDs,formPanel,deptTabPagingToolbar,ds,pagingToolbar,parRef);
        }
	});
	var delButton  = new Ext.Toolbar.Button({
		text:'删除',
		tooltip:'删除',
		iconCls:'add',
		handler: function(){
			var rowObj = formPanel.getSelections();
			var len = rowObj.length;
			if(len < 1){
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的部门数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				    function(btn) {
					    if(btn == 'yes'){
						    Ext.Ajax.request({
						        url:deptSetUrl+'?action=deletedept'+'&rowid='+rowObj[0].get("rowid"),
						        waitMsg:'删除中...',
						        failure: function(result, request) {
							        Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						        },
						        success: function(result, request) {
							        var jsonData = Ext.util.JSON.decode( result.responseText );
							        if (jsonData.success=='true') {
								        Ext.Msg.show({title:'注意',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								        Ext.getCmp('detailReport').getNodeById(repdr).reload();
								        ds.load({params:{start:0, limit:pagingToolbar.pageSize,parent:parent,type:type,action:'gridlist',active:"",dir:'asc',sort:'order'}});
                                        deptTabDs.load({params:{start:0, limit:deptTabPagingToolbar.pageSize,parRef:parRef,active:"",dir:'asc',sort:'order'}});
							        }else{
									    var message="";
									    Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
		title: '部门维护',
		width: 600,
		height:400,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
				text: '关闭窗口',
				handler: function(){window.close();}
			}]
		});

	window.show();
	deptTabDs.load({params:{start:0, limit:deptTabPagingToolbar.pageSize,parRef:parRef,active:"",dir:'asc',sort:'order'}});
};