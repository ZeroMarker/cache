///////////////////////////////////////////////////

var tmpData="";


/////////////////////上级科室/////////////////////////////					
	var ufSuperDeptDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });

	ufSuperDeptDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.srmdeptexe.csp'
		                     + '?action=caldeptname&str='
		                     + encodeURIComponent(Ext.getCmp('ufSuperDeptField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var ufSuperDeptField = new Ext.form.ComboBox({
			id: 'ufSuperDeptField',
			fieldLabel: '上级科室',
			width:120,
			listWidth : 250,
			allowBlank: true,
			store: ufSuperDeptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			//emptyText : '',
			name: 'ufSuperDeptField',
			//暂时为空
			//disabled:true,
			pageSize: 10,
			minChars: 1,
			forceSelection : false,
			selectOnFocus:true,
		    editable:true
	});
/////////////////科室级别查询//////////////////

var ufDeptClassDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '一级科室'], ['2', '二级科室'], ['3', '三级科室'],['4','四级科室']]
	});
	var ufDeptClassField = new Ext.form.ComboBox({
	    id : 'ufDeptClassField',
		fieldLabel : '科室级别',
		width : 120,
		listWidth : 120,
		store : ufDeptClassDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		//emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection : true
	});	
/////////////////////科室编码或名称查询//////////////////////////////	
var ufDeptInfoField = new Ext.form.TextField({
		id: 'ufDeptInfoField',
		fieldLabel: '科室编码或名称',
		width:120,
		listWidth : 245,
		triggerAction: 'all',
		//emptyText:'',
		name: 'ufDeptInfoField',
		minChars: 1,
		pageSize: 10,
		editable:true
	});
	
var findButton = new Ext.Toolbar.Button({
    text: '查询', 
    //tooltip:'查询',        
    iconCls:'search',
	handler:function(){	
	    var deptinfo = ufDeptInfoField.getValue();
		var deptclass = ufDeptClassField.getValue();
        var superdept = ufSuperDeptField.getValue();
        
	//itemGridDs.load(({params:{start:0,limit:itemGridPagingToolbar.pageSize,deptinfo:deptinfo,deptclass:deptclass,superdept:superdept}}));
	    itemGridDs.proxy = new Ext.data.HttpProxy({
	    	
								url : itemGridUrl+'?action=list&deptinfo='+ encodeURIComponent(deptinfo)+ 
								'&deptclass='+encodeURIComponent(deptclass)+
								'&superdept='+ encodeURIComponent(superdept),
								
								method : 'GET'
								//'&type='+ userTypeField.getValue()
							});
					itemGridDs.load({
								params : {
									start : 0,
									limit : 25,
									sortDir:'',
									sortField:''
								}
							});
	}
});
/**
var srmdeptuserDs=function(){	

    itemGridDs.proxy = new Ext.data.HttpProxy({
    	
							url : 'herp.srm.srmdeptexe.csp?action=list',
							method : 'GET'
							//'&type='+ userTypeField.getValue()
						});
				itemGridDs.load({
							params : {
								start : 0,
								limit : 25
							}
						});
};
**/
var itemGridUrl = '../csp/herp.srm.srmdeptexe.csp';
//配件数据源
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'Code',
			'Name',
			'Type',
			'IsValid',
			'DeptClass',
			'SuperDept'
		]),
	    remoteSort: true
});


Ext.ns("dhc.herp");

dhc.herp.PageSizePlugin = function() {
	dhc.herp.PageSizePlugin.superclass.constructor.call(this, {
				store : new Ext.data.SimpleStore({
							fields : ['text', 'value'],
							data : [['10', 10], ['20', 20], ['30', 30],
									['50', 50], ['100', 100]]
						}),
				mode : 'local',
				displayField : 'text',
				valueField : 'value',
				editable : false,
				allowBlank : false,
				triggerAction : 'all',
				width : 40
			});
};

Ext.extend(dhc.herp.PageSizePlugin, Ext.form.ComboBox, {
			init : function(paging) {
				paging.on('render', this.onInitView, this);
			},

			onInitView : function(paging) {
				paging.add('-', this, '-');
				this.setValue(paging.pageSize);
				this.on('select', this.onPageSizeChanged, paging);
			},

			onPageSizeChanged : function(combo) {
				this.pageSize = parseInt(combo.getValue());
				this.doLoad(0);
			}
		});
var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 25,
		store: itemGridDs,
		plugins : new dhc.herp.PageSizePlugin(),
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid', 'name');

var tmpTitle='科室信息维护';	

var itemGridCm = new Ext.grid.ColumnModel([
        new Ext.grid.RowNumberer(), 
        {

            id:'rowid',
            header: '科室ID',
            allowBlank: false,
            width:120,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       }, {
            id:'Code',
            header: '科室编号',
            allowBlank: false,
            width:180,
            editable:false,
            dataIndex: 'Code'
       }, {
            id:'Name',
            header: '科室名称',
            allowBlank: false,
            width:240,
            editable:false,
            dataIndex: 'Name'
       },{
            id:'DeptClassID',
            header: '科室级别ID',
            allowBlank: false,
            width:100,
            editable:false,
			hidden:true,
            dataIndex: 'DeptClassID'
       },{
            id:'DeptClass',
            header: '科室级别',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'DeptClass'
       },{
            id:'SuperDeptID',
            header: '上级科室ID',
            allowBlank: false,
            width:100,
            editable:false,
			hidden:true,
            dataIndex: 'SuperDeptID'
       },{
            id:'SuperDept',
            header: '上级科室',
            allowBlank: false,
            width:240,
            editable:false,
            dataIndex: 'SuperDept'
       }, {
            id:'IsValid',
            header: '是否有效',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'IsValid',
			renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
       }
			    
]);

var addButton = new Ext.Toolbar.Button({
					text : '新增',
					//tooltip : '增加',
					iconCls : 'edit_add',
					handler : function() {
						srmdeptuserAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '修改',
					//tooltip : '修改',
					iconCls : 'pencil',
					handler : function() {
						srmdeptuserEditFun();
					}
				});
var delButton = new Ext.Toolbar.Button({
			text : '删除',
			//tooltip : '删除',
			iconCls : 'edit_remove',
			handler : function() {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				var tmpRowid = "";
		
				if (len < 1) {
					Ext.Msg.show({
								title : '注意',
								msg : '请选择需要删除的数据!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				} else {
					tmpRowid = rowObj[0].get("rowid");
					Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : itemGridUrl + '?action=del&rowid=' + tmpRowid,
								waitMsg : '删除中...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '错误',
												msg : '请检查网络连接!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : '注意',
													msg : '操作成功!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										itemGridDs.load({
													params : {
														start : 0,
														limit : 25
													}
												});
									} else {
										Ext.Msg.show({
													title : '错误',
													msg : '错误',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
									}
								},
								scope : this
							});
						}
					})
				}
			}
});
/*
var itemGrid = new Ext.grid.GridPanel({
			title: '科室信息维护',
			iconCls: 'list',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.srmdeptexe.csp',
		    atLoad : true, // 是否自动刷新
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			tbar:['','科室编码或名称','',ufDeptInfoField,'','科室级别','',ufDeptClassField,'','上级科室','',ufSuperDeptField,'','-',findButton,'-',addButton,'-',editButton,'-',delButton],
			bbar:itemGridPagingToolbar
});
*/

var itemGrid = new dhc.herp.Grid({
        title: '科室信息维护',
        iconCls: 'list',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.srmdeptexe.csp',	  
		    atLoad : true, // 是否自动刷新
		    loadmask:true,
        fields: [{
            header: '科室ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'Code',
            header: '科室编号',
			//allowBlank: false,
			editable:false,
			width:100,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '科室名称',
			//allowBlank: false,
			width:180,
			editable:false,
            dataIndex: 'Name'
        },{
            id:'DeptClassID',
            header: '科室级别ID',
			//allowBlank: false,
			editable:false,
		    hidden:true,
			width:180,
            dataIndex: 'DeptClassID'
        },{
            id:'DeptClass',
            header: '科室级别',
			//allowBlank: false,
		    editable:false,
			width:180,
            dataIndex: 'DeptClass'
        },{
            id:'SuperDeptID',
            header: '上级科室ID',
			//allowBlank: false,
			width:180,
			editable:false,
		    hidden:true,
            dataIndex: 'SuperDeptID'
        },{
            id:'SuperDept',
            header: '上级科室',
			//allowBlank: false,
			editable:false,
			width:180,
            dataIndex: 'SuperDept'
        },{
            id:'IsValid',
            header: '是否有效',
			//allowBlank: false,
			editable:false,
			width:80,
            dataIndex: 'IsValid',
            //type : IsdriectField,
            renderer : function(v, p, record){
        	//p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        }] 
});
itemGrid.hiddenButton(0);
itemGrid.hiddenButton(1);
itemGrid.hiddenButton(2);
itemGrid.hiddenButton(3);
itemGrid.hiddenButton(4);
itemGrid.btnAddHide();     //隐藏增加按钮
itemGrid.btnSaveHide();    //隐藏保存按钮
itemGrid.btnResetHide();   //隐藏重置按钮
itemGrid.btnDeleteHide();  //隐藏删除按钮
itemGrid.btnPrintHide();   //隐藏打印按钮

itemGrid.addButton('-');
itemGrid.addButton(addButton);
itemGrid.addButton('-');
itemGrid.addButton(editButton);
itemGrid.addButton('-');
itemGrid.addButton(delButton);

itemGridDs.load({	
			params:{start:0, limit:25},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});
