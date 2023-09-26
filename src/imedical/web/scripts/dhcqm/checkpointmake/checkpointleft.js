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

//医嘱项		



  
var addButton = new Ext.Toolbar.Button({
		text: '添加',
    	//tooltip: '添加新的项目',        
    	iconCls: 'add',
		handler: function(){
			addProjFun(itemGridDs,itemGrid)
		}
});
//alert("sfdsfsd234");
/////////////////修改按钮/////////////////////////
var editPatentInfoButton  = new Ext.Toolbar.Button({
		text: '修改',        
		//tooltip: '修改选定的项目',
		iconCls: 'option',
		handler: function(){
		editProjFun(itemGridDs,itemGrid);}
		});


////////////////删除按钮//////////////////////////
var delButton = new Ext.Toolbar.Button({
	text: '删除',
   // tooltip:'删除',        
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
			width:80,
			     
            dataIndex: 'schemcode'
        },{
            id:'schemname',
            header: '项目名称',
			allowBlank: true,
			width:150,    
            dataIndex: 'schemname'
        },{
            id:'schemeType',
            header: '周期类型',
			allowBlank: true,
			align:'center',
			width:60,
            dataIndex: 'schemeType',
			renderer:function(value){
				if(value=="M"){
					 value="月份";
				}else if (value=="Q"){
					 value="季度";
				}else if (value=="H"){
					 value="半年";
				}else{
					 value="全年";
				}
				return value;
			}
        },{
            id:'importType',
            header: '数据来源',
			allowBlank: true,
			width:60,
			align:'center',
            dataIndex: 'importType',
			renderer:function(value){
				if(value=="1") {
					var value="移动端";
				} else { 
					var value="电脑端";
				}
			  return value;
			}
        },{
            id:'checkType',
            header: '记录类型',
			allowBlank: true,
			align:'center',
			width:80,
            dataIndex: 'checkType',
			renderer:function(value){
				if (value=="3") {
					value="特殊检查点";
				}else if (value=="2"){
					value="全部记录"
				}else if (value=="1"){
					value="不合格记录";
				}
		
				return value;		

			}
        },{
            id:'active',
            header: '是否启用',
			allowBlank: true,
			width:60,
			align:'center',
            dataIndex: 'active',
			renderer:function(value,meta,record){
				var viewValue="启用";
				if(value=="N"){
					var viewValue="禁用";
				} 
			    return viewValue; 
			}
        },{
            id:'linker',
            header: '关联医嘱', 
            allowBlank:true,
            width:300,
            //align:'center',            
            //type:RelyUnitCombo,
            dataIndex: 'linker',
            editable:false
			,
			renderer:function(value,meta,record){
				if(value!=""){
			   	 return '<div class="x-grid3-cell-inner x-grid3-col-linker" unselectable="on" ext:qtitle ext:qtip="'+value+'">'+value+'</div>'
				}
			}
        }]
);

var AuditPagingToolbar = new Ext.PagingToolbar({
		pageSize: 25,
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
	      //  maxSize: 450,
			autoScroll:true,
			readerModel:'local',		
            url: 'dhc.qm.checkpointmakeexe.csp',
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
			tbar: [addButton,'-',editPatentInfoButton,'-',delButton],
			bbar:AuditPagingToolbar
});

  itemGridDs.load({	
			params:{start:0, limit:AuditPagingToolbar.pageSize}
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
    importType=selectedRow.data['importType'];//获得检查项目是pc端还是pad的
	personDs.proxy = new Ext.data.HttpProxy({url:projUrl+'?action=listright&schemcode='+rowid});
	personDs.load({params:{start:0, limit:AuditPagingToolbar.pageSize}});
	}
});
