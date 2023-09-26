if (type=="0"){
	rooText="成本核算分层套";
}else{
	rooText="部门分层套";
}
//树形结构导入器
var deptTreeLoader = new Ext.tree.TreeLoader({
	dataUrl:'../scripts/ext2/cost/report/test11.csp',
	uiProviders:{
		'col': Ext.tree.ColumnNodeUI
	}
});

//加载前事件
deptTreeLoader.on('beforeload', function(deptTreeLoader,node){
	var url=deptSetUrl+'?action=treelist&type='+type+'&parent='+node.id+'&sort=order'+'&dir=asc';
	deptTreeLoader.dataUrl=url;
});
//树形结构的根
var deptTreeRoot = new Ext.tree.AsyncTreeNode({
	id:'roo',
	text:rooText,
	value:'0',
	expanded:true
});


var findDeptButton  = new Ext.Toolbar.Button({
	text: '查看未分配部门',
	tooltip: '查看未分配部门',
	iconCls: 'add',
	handler: function(){
		if(repdr.split("||").length>1){
		    Ext.Msg.show({title:'注意',msg:'不能选择部门!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	    }
		if(repdr == "roo"){
		    Ext.Msg.show({title:'注意',msg:'此节点不能查看!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	    }
	    //============================================================面板控件=============================================================
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
		    fieldLabel: '单元类别',
		    anchor: '90%',
		    listWidth : 260,
		    allowBlank: false,
		    store: unitTypeDs,
		    valueField: 'rowid',
		    displayField: 'name',
		    triggerAction: 'all',
		    emptyText:'选择单元类别...',
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
		    fieldLabel: '单元',
		    anchor: '90%',
		    listWidth : 260,
		    allowBlank: false,
		    store: unitsDs,
		    valueField: 'rowid',
		    displayField: 'name',
		    triggerAction: 'all',
		    emptyText:'选择单元...',
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
    		    header: '代码',
			    dataIndex: 'code',
			    width: 80,
			    align: 'left',
			    sortable: true
		    },{
			    header: "名称",
			    dataIndex: 'name',
			    width: 80,
			    align: 'left',
			    sortable: true
		    },{
			    header: "拼音",
			    dataIndex: 'py',
			    width: 70,
			    align: 'left',
			    sortable: true
		    },{
			    header: "位置",
			    dataIndex: 'location',
			    width: 100,
			    align: 'left',
			    sortable: true
		    },{
			    header: "备注",
			    dataIndex: 'remark',
			    width: 100,
			    align: 'left',
			    sortable: true
		    },{
			    header: "启用日期",
			    dataIndex: 'start',
			    width: 80,
			    align: 'left',
			    sortable: true,
			    renderer: formatDate
		    },{
			    header: "停用日期",
			    dataIndex: 'stop',
			    width: 80,
			    align: 'left',
			    sortable: true,
			    renderer: formatDate
		    },{
			    header: "电话",
			    dataIndex: 'phone',
			    width: 100,
			    align: 'left',
			    sortable: true
		    },{
			    header: "虚拟标志",
			    dataIndex: 'vFlag',
			    width: 80,
			    align: 'left',
			    sortable: true,
                renderer : function(v, p, record){
				    p.css += ' x-grid3-check-col-td';
				    return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			    }
		    },{
			    header: "有效标志",
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

		var findCommTabPagingToolbar = new Ext.PagingToolbar({//分页工具栏
			pageSize: 10,
			store: findCommTabDs,
			displayInfo: true,
			displayMsg: '当前显示{0} - {1}，共计{2}',
			emptyMsg: "没有数据",
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


		//==========================================================面板==========================================================
		var formPanel = new Ext.grid.GridPanel({
			store: findCommTabDs,
			cm: findCommTabCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:['单位类别:',unitType,'单位:',units],
			bbar: findCommTabPagingToolbar
		});
		//============================================================窗口========================================================
		var window = new Ext.Window({
			title: '未添加部门查询窗口',
			width: 950,
			height:450,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [{
				text: '取消',
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
	text:'复制分层套',
	tooltip:'复制分层套',
	iconCls:'remove',
	handler: function(){
		if(leaf!=false){
			Ext.Msg.show({title:'注意',msg:'您选择的不是节点,不能进行复制!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			Ext.MessageBox.confirm('提示','确定要复制选定的分层套?',
			function(btn) {
				if(btn == 'yes'){
					Ext.Ajax.request({
						url:deptSetUrl+'?action=copy&deptSetDr='+repdr+'&type='+type,
						waitMsg:'复制中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'复制成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								Ext.getCmp('detailReport').getNodeById("roo").reload();
								deptSetDs.load({params:{start:0, limit:deptSetPagingToolbar.pageSize,parent:parent,type:type,action:'gridlist',active:""}});
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
