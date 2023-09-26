//Description:������Ŀ��
//Creator:zdm
//CreatDate:2013-03-07

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var code=new Ext.form.TextField({
		id:'code',
		fieldLabel:'����',
		anchor:'90%'
	});

	var desc=new Ext.form.TextField({
		id:'desc',
		fieldLabel:'����',
		anchor:'90%'
	});
	
	var activeStore=new Ext.data.SimpleStore({
		id:'activeStore',
		autoDestroy: true,
		fields:['rowid','description'],
		data:[['Y','�Ѽ���'],['N','δ����']]
	})
	
	var active=new Ext.form.ComboBox({
		id:'active',
		fieldLabel:'�����־',
		anchor:'90%',
		store:activeStore,
		mode:'local',
		triggerAction:'all',
		valueField:'rowid',
		displayField:'description'
	});
	
	var SearchBT=new Ext.Toolbar.Button({
		id:'SearchBT',
		text:'��ѯ',
		height:30,
		width:70,
		iconCls:'page_find',
		handler:function(){
			Query();
		}
	});
	
	var SaveBT=new Ext.Toolbar.Button({
		id:'SaveBT',
		text:'����',
		height:30,
		width:70,
		iconCls:'page_save',
		handler:function(){
			Save();		
		}
	});

	var DeleteBT=new Ext.Toolbar.Button({
		id:'DeleteBT',
		text:'ɾ��',
		height:30,
		width:70,
		iconCls:'page_delete',
		handler:function(){
			Delete();
		}
	});
	
	var AddBT=new Ext.Toolbar.Button({
		id:'AddBT',
		text:'�½�',
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
			Msg.info("warning","û����Ҫ����ļ�¼!");
			return;
		}
		
		var listData="";
		for(var i=0;i<count;i++){
			var record=gridItemGrp.getStore().getAt(i);
			if (record.get("Code")==""){
				Msg.info("warning", "��"+(i+1)+"�д���Ϊ��!");
				return;
			}
			if (record.get("Desc")==""){
				Msg.info("warning", "��"+(i+1)+"������Ϊ��!");
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
			Msg.info("warning","û����Ҫ����ļ�¼");
			return;
		}
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url:DictUrl+"locitemgrpaction.csp?actiontype=save",
			method:'POST',
			params:{ListData:listData},
			success:function(response,opts){
				var jsonData=Ext.util.JSON.decode(response.responseText);
				 mask.hide();
				if(jsonData.success=='true'){
					Msg.info("success","����ɹ�!");
					Query();
				}else{
					Msg.info("error", "����ʧ��,�����¼" +jsonData.info+"����������Ƿ��ظ�!");
				}
			}
		});
		
	}
	
	function Delete(){
		var cell=gridItemGrp.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","��ѡ����Ҫɾ���ļ�¼!");
			return;
		}
		var record=gridItemGrp.getStore().getAt(cell[0]);
		var rowid=record.get("RowId");
		if (rowid!=""){
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
				function(btn){
					if(btn=="yes"){
						var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
						Ext.Ajax.request({
							url:DictUrl+"locitemgrpaction.csp?actiontype=delete",
							method:'POST',
							params:{Rowid:rowid},
							success:function(response,opts){
								var jsonData=Ext.util.JSON.decode(response.responseText);
								 mask.hide();
								if(jsonData.success=='true'){
									Msg.info("success","ɾ���ɹ�!");
									gridStore.remove(record);
									gridItemGrp.getView().refresh();
									gridStore.reload();
								}else{
									Msg.info("error", "ɾ��ʧ��!" +jsonData.info);
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
		       header: '����',
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
				header:'����',
				dataIndex:'Code',
				width:150,
				sortable:true,
				editor:new Ext.form.TextField({
					allowBlank:false,
					listeners:{
						'specialkey':function(field,e){
							if(e.getKey()==Ext.EventObject.ENTER){
								if(field.getValue()==null || field.getValue()==""){
									Msg.info("warning", "���벻��Ϊ��!");
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
				header:'����',
				dataIndex:'Desc',
				width:200,
				sortable:true,
				editor:new Ext.form.TextField({
					allowBlank:false,
					listeners:{
						'specialkey':function(field,e){
							if(e.getKey()==Ext.EventObject.ENTER){
								if(field.getValue()==null || field.getValue()==""){
									Msg.info("warning","���Ʋ���Ϊ��!");
									
									e.cancel=true;
									return;
								}
								
								AddNewRow();
							}
						}
					}
				})
			},{
				header:'��ע',
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
		firstText:'��һҳ',
		lastText:'���һҳ',
		nextText:'��һҳ',
		prevText:'��һҳ',
		refreshText:'ˢ��',
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼",
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
	
	//���ӿ���
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
		title:'������Ŀ��ά��',
		labelWidth:60,
		labelAlign:'right',
		frame:true,
		autoHeight:true,
		tbar:[SearchBT,'-',AddBT,'-',SaveBT,'-',DeleteBT],
		items:[{
			xtype:'fieldset',
			layout:'column',
			title:'��ѯ����',
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