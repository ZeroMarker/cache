//Description:科室项目组
//Creator:zdm
//CreatDate:2013-03-07

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var code=new Ext.form.TextField({
		id:'code',
		fieldLabel:'代码',
		anchor:'90%'
	});

	var desc=new Ext.form.TextField({
		id:'desc',
		fieldLabel:'名称',
		anchor:'90%'
	});
	
	var activeStore=new Ext.data.SimpleStore({
		id:'activeStore',
		autoDestroy: true,
		fields:['rowid','description'],
		data:[['Y','已激活'],['N','未激活']]
	})
	
	var active=new Ext.form.ComboBox({
		id:'active',
		fieldLabel:'激活标志',
		anchor:'90%',
		store:activeStore,
		mode:'local',
		triggerAction:'all',
		valueField:'rowid',
		displayField:'description'
	});
	
	var SearchBT=new Ext.Toolbar.Button({
		id:'SearchBT',
		text:'查询',
		height:30,
		width:70,
		iconCls:'page_find',
		handler:function(){
			Query();
		}
	});
	
	var SaveBT=new Ext.Toolbar.Button({
		id:'SaveBT',
		text:'保存',
		height:30,
		width:70,
		iconCls:'page_save',
		handler:function(){
			Save();		
		}
	});

	var DeleteBT=new Ext.Toolbar.Button({
		id:'DeleteBT',
		text:'删除',
		height:30,
		width:70,
		iconCls:'page_delete',
		handler:function(){
			Delete();
		}
	});
	
	var AddBT=new Ext.Toolbar.Button({
		id:'AddBT',
		text:'新建',
		height:30,
		width:70,
		iconCls:'page_add',
		handler:function(){
			AddNewRow();
		}
	});
	
	function Query(){
		var code=Ext.getCmp("code").getValue();
		var desc=Ext.getCmp("desc").getValue();
		var active=Ext.getCmp("active").getValue();
		var pagesize=pageToolBar.pageSize;
		
		gridStore.setBaseParam("Code",code);
		gridStore.setBaseParam("Desc",desc);
		gridStore.setBaseParam("Active",active);
		
		gridStore.load({params:{start:0,limit:pagesize,sort:'RowId',dir:'ASC'}});
	}
	
	function Save(){
		var count=gridItemGrp.getStore().getCount();
		if(count<=0){
			Msg.info("warning","没有需要保存的记录!");
			return;
		}
		
		var listData="";
		for(var i=0;i<count;i++){
			var record=gridItemGrp.getStore().getAt(i);
			if (record.get("Code")==""){
				Msg.info("warning", "第"+(i+1)+"行代码为空!");
				return;
			}
			if (record.get("Desc")==""){
				Msg.info("warning", "第"+(i+1)+"行名称为空!");
				return;
			}
			if(record.data.newRecord||record.dirty){
				if(listData==""){
					listData=record.get("RowId")+FieldDelim+record.get("Code")+FieldDelim+record.get("Desc")+FieldDelim+record.get("Active")+FieldDelim+record.get("Remark");
				}else{
					listData=listData+xRowDelim()+record.get("RowId")+FieldDelim+record.get("Code")+FieldDelim+record.get("Desc")+FieldDelim+record.get("Active")+FieldDelim+record.get("Remark");
				}
			}
		
		}
		if(listData==""){
			Msg.info("warning","没有需要保存的记录");
			return;
		}
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url:DictUrl+"locitemgrpaction.csp?actiontype=save",
			method:'POST',
			params:{ListData:listData},
			success:function(response,opts){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				 mask.hide();
				if(jsonData.success=='true'){
					Msg.info("success","保存成功!");
					Query();
				}else{
					Msg.info("error", "保存失败,请检查记录" +jsonData.info+"代码和名称是否重复!");
				}
			}
		});
		
	}
	
	function Delete(){
		var cell=gridItemGrp.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择需要删除的记录!");
			return;
		}
		var record=gridItemGrp.getStore().getAt(cell[0]);
		var rowid=record.get("RowId");
		if (rowid!=""){
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',
				function(btn){
					if(btn=="yes"){
						var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
						Ext.Ajax.request({
							url:DictUrl+"locitemgrpaction.csp?actiontype=delete",
							method:'POST',
							params:{Rowid:rowid},
							success:function(response,opts){
								var jsonData=Ext.util.JSON.decode(response.responseText);
								 mask.hide();
								if(jsonData.success=='true'){
									Msg.info("success","删除成功!");
									gridStore.remove(record);
									gridItemGrp.getView().refresh();
									gridStore.reload();
								}else{
									Msg.info("error", "删除失败!" +jsonData.info);
								}
							}
						});	
					}
				}
			)
		}else{
			gridStore.remove(record);
			gridItemGrp.getView().refresh();
		}	
	}
	
	var gridStore=new Ext.data.JsonStore({
		id:'gridStore',
		autoDestroy:true,
		url:DictUrl+"locitemgrpaction.csp?actiontype=query",
		baseParams:{Code:'',Desc:'',Active:''},
		fields:["RowId","Code","Desc","Active","Remark"],
		idProperty:'RowId',
		totalProperty:'results',
		root:'rows'
	});
	
	var activeCheckColumn=new Ext.grid.CheckColumn({
		       header: '激活',
		       dataIndex: 'Active',
		       align:"center",
		       width: 55
	});
	
	var gridCm=new Ext.grid.ColumnModel({
		columns:[
			new Ext.grid.RowNumberer(),
			{
				header:'rowid',
				dataIndex:'RowId',
				hidden:true
			},{
				header:'代码',
				dataIndex:'Code',
				width:150,
				sortable:true,
				editor:new Ext.form.TextField({
					allowBlank:false,
					listeners:{
						'specialkey':function(field,e){
							if(e.getKey()==Ext.EventObject.ENTER){
								if(field.getValue()==null || field.getValue()==""){
									Msg.info("warning", "代码不能为空!");
									e.cancel=true;
									return;
								}
								
								var cell=gridItemGrp.getSelectionModel().getSelectedCell();
								var col=GetColIndex(gridItemGrp,"Desc");
								gridItemGrp.getSelectionModel().select(cell[0],col);
								gridItemGrp.startEditing(cell[0],col);
							}
						}
					}
				})
			},{
				header:'名称',
				dataIndex:'Desc',
				width:200,
				sortable:true,
				editor:new Ext.form.TextField({
					allowBlank:false,
					listeners:{
						'specialkey':function(field,e){
							if(e.getKey()==Ext.EventObject.ENTER){
								if(field.getValue()==null || field.getValue()==""){
									Msg.info("warning","名称不能为空!");
									
									e.cancel=true;
									return;
								}
								
								AddNewRow();
							}
						}
					}
				})
			},{
				header:'备注',
				dataIndex:'Remark',
				width:150,
				sortable:true,
				editor:new Ext.form.TextField({
					allowBlank:true,
					listeners:{
						'specialkey':function(field,e){
							if(e.getKey()==Ext.EventObject.ENTER){
								AddNewRow();
							}
						}
					}
				})			
			},
			activeCheckColumn
		]
	});
	
	var pageToolBar=new Ext.PagingToolbar({
		id:'pageToolBar',
		store:gridStore,
		firstText:'第一页',
		lastText:'最后一页',
		nextText:'下一页',
		prevText:'上一页',
		refreshText:'刷新',
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录",
		pageSize:PageSize
	});
	var gridItemGrp=new Ext.grid.EditorGridPanel({
		id:'gridItemGrp',
		region:'center',
		store:gridStore,
		cm:gridCm,
		sm:new Ext.grid.CellSelectionModel(),
		bbar:pageToolBar,
		plugins: [activeCheckColumn]
	});
	
	//增加空行
	function AddNewRow(){
		var newRecord=new Ext.data.Record.create(["RowId","Code","Desc","Active","Remark"]);
		var newRecordData=new newRecord({
			RowId:'',
			Code:'',
			Desc:'',
			Active:'Y',
			Remark:''
		})
		
		gridItemGrp.getStore().add(newRecordData);
		//gridItemGrp.getView().refresh();
		var count=gridItemGrp.getStore().getCount();
		var colIndex=GetColIndex(gridItemGrp,"Code");
		gridItemGrp.getSelectionModel().select(count-1,colIndex);
		gridItemGrp.startEditing(count-1,colIndex);
	}
	
	var HospPanel = InitHospCombo('DHC_LocItemGrp',function(combo, record, index){
		HospId = this.value; 
		Ext.getCmp("code").setValue('');
		Ext.getCmp("desc").setValue('');
		Query()
	});
	
	var formPanel=new Ext.form.FormPanel({
		title:'科室项目组维护',
		labelWidth:60,
		labelAlign:'right',
		frame:true,
		autoHeight:true,
		tbar:[SearchBT,'-',AddBT,'-',SaveBT,'-',DeleteBT],
		items:[{
			xtype:'fieldset',
			layout:'column',
			title:'查询条件',
			defaults:{border:false},
			style:DHCSTFormStyle.FrmPaddingV,
			items:[{
				columnWidth:.33,
				xtype:'fieldset',
				items:[code]
			},{
				columnWidth:.33,
				xtype:'fieldset',
				items:[desc]
			},{
				columnWidth:.15,
				xtype:'fieldset',
				items:[active]
			}]
		}]		
	});
	
	var mainPanel=new Ext.Viewport({
		layout:'border',
		items:[
			{
				region:'north',
				height:'500px',
				items:[HospPanel,formPanel]
			},gridItemGrp
		]
	});

	
	Query();
});