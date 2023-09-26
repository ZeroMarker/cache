var projUrl = '../csp/dhc.qm.checkpointmakeexe.csp';

var itemGridProxy= new Ext.data.HttpProxy({url:projUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
			proxy : itemGridProxy,
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'schemcode','schemname','linker','schemeType','importType','checkType','active']),
					remoteSort: true
		});

///医嘱项		
var RelyUnitDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['Rowid', 'name'])
		});
		

//添加复选框
var sm = new Ext.grid.CheckboxSelectionModel();

RelyUnitDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url :projUrl+'?action=Listcheckproj', 
                        method:'POST'
					});
		});


  
var addButton = new Ext.Toolbar.Button({
		text: '添加',
    	tooltip: '添加新的项目',        
    	iconCls: 'add',
		handler: function(){
			addProjFun(itemGridDs,itemGrid);}
});
/////////////////修改按钮/////////////////////////
var editPatentInfoButton  = new Ext.Toolbar.Button({
		text: '修改',        
		tooltip: '修改选定的项目',
		iconCls: 'option',
		handler: function(){
		editProjFun();}
		});


////////////////删除按钮//////////////////////////
var delButton = new Ext.Toolbar.Button({
	text: '删除',
    tooltip:'删除',        
    iconCls:'remove',
	handler:function(){

		//var selectedRow = itemGridDs.data.items[rowIndex];
		
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要删除的记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'../csp/dhc.qm.checkpointmakeexe.csp?action=delleft&rowid='+rowObj[0].get("rowid"),
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'删除成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGridDs.load({params:{start:0,limit:25,sort:"rowid",dir:"asc"}});
								}else{
									Ext.Msg.show({title:'提示',msg:'删除失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
							},
							scope: this
						});
					}
				}
			)
		}
	}
});

		

var itemGridCm = new Ext.grid.ColumnModel([
		    
		new Ext.grid.RowNumberer(),
        {
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'schemcode',
            header: '项目编码',
			allowBlank: true,
			//width:100,
			     
            dataIndex: 'schemcode'
        },{
            id:'schemname',
            header: '项目名称',
			allowBlank: true,
			//width:100,    
            dataIndex: 'schemname'
        },{
            id:'schemeType',
            header: '项目类型',
			allowBlank: true,
			//width:100,
            dataIndex: 'schemeType'
        },{
            id:'importType',
            header: '数据来源',
			allowBlank: true,
			//width:100,
            dataIndex: 'importType'
        },{
            id:'checkType',
            header: '不合格类型',
			allowBlank: true,
			//width:100,
            dataIndex: 'checkType'
        },{
            id:'linker',
            header: '关联医嘱', 
            allowBlank:true,
           // width:300,
            align:'right',            
            //type:RelyUnitCombo,
            dataIndex: 'linker'
        },{
            id:'active',
            header: '是否启用',
			allowBlank: true,
			//width:100,
            dataIndex: 'active'
        }]
);

var AuditPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"

})

var itemGrid = new Ext.grid.GridPanel({
			//title: '绩效单位记录',
	        region: 'west',
            width: '60%',
	       // minSize: 350,
	       // maxSize: 700,
	        split: true,
	        collapsible: true,
	        containerScroll: true,
	        xtype: 'grid',
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			viewConfig: {forceFit:true},
			tbar: [addButton,'-',editPatentInfoButton,'-',delButton],
			bbar:AuditPagingToolbar
});

 itemGridDs.load({	
			params:{start:0, limit:AuditPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});

itemGrid.on('rowclick',function(grid,rowIndex,e){
	//单击绩效单元后刷内部人员记录
	
	if (rowIndex !=='0')
	{ 
	//alert (rowIndex);
	//personGrid.getSelectionModel().getSelections()
	var selectedRow = itemGridDs.data.items[rowIndex];
	//alert(itemGridDs.data.items);
    rowid = selectedRow.data['rowid'];
    itemID=rowid;
	personDs.proxy = new Ext.data.HttpProxy({url:projUrl+'?action=listright&schemcode='+rowid});
	personDs.load({params:{start:0, limit:AuditPagingToolbar.pageSize}});
	}
});   

itemGrid.load({params:{start:0,limit:25}});
