// /����: ��������ɹ���˼���ά��
// /����: ��������ɹ���˼���ά��
// /��д�ߣ�zhangxiao
// /��д����: 2014.03.18
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';	
	var groupId=session['LOGON.GROUPID'];
	var userId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var StatusGrpGridUrl="dhcstm.dhcplanstatusinitaction.csp"
	var Loc=null;
	

     //���Ҵ���
        var locCode = new Ext.form.TextField({
					id:'locCode',
   				 allowBlank:true,
					anchor:'90%'
				});
     //��������
        var locName = new Ext.form.TextField({
					id:'locName',
    				allowBlank:true,
					anchor:'90%'
             });
    
	 // ��ȫ��Store
		var PointerStore = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
			totalProperty : "results",
			root : 'rows'
		}, ['Description', 'RowId'])
	});			
	// ��ȫ��
		var SSGroup=new Ext.form.ComboBox({ 
			fieldLabel:'<font color=blue>��ȫ��</font>',
			id : 'SSGroup',
			name : 'SSGroup',
			StkType:App_StkTypeCode,     //��ʶ��������
			UserId:userId,
			LocId:gLocId,
			store : PointerStore,
	        valueField : 'RowId',
	        displayField : 'Description',
	        allowBlank : true,
	        triggerAction : 'all',
	        selectOnFocus : true,
	        forceSelection : true,
	        minChars : 1,
	        pageSize : 999,
	        listWidth : 250,
	        valueNotFoundText : '',
			emptyText : '��ȫ��...',
			anchor : '90%'
		});
		
		
	SSGroup.on('beforequery', function(e){
		this.store.removeAll();
		var type="G"
		this.store.setBaseParam('Type',type);
		this.store.setBaseParam('filter',this.getRawValue());
		this.store.setBaseParam('Group',groupId);
		this.store.proxy=new Ext.data.HttpProxy({url : 'dhcstm.orgutil.csp?actiontype=GetSSPPoint',method:'POST'});
	    this.store.load({params:{start:0,limit:999}});
		});	
	
	// ���״̬
		var DHCPlanStatusStore = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
			totalProperty : "results",
			root : 'rows'
		}, ['Description', 'RowId'])
	});			
	    
		var DHCPlanStatus=new Ext.form.ComboBox({ 
			fieldLabel:'<font color=blue>���״̬</font>',
			id : 'DHCPlanStatus',
			name : 'DHCPlanStatus',
			StkType:App_StkTypeCode,     //��ʶ��������
			store : DHCPlanStatusStore,
	        valueField : 'RowId',
	        displayField : 'Description',
	        allowBlank : true,
	        triggerAction : 'all',
	        selectOnFocus : true,
	        forceSelection : true,
	        minChars : 1,
	        pageSize : 999,
	        listWidth : 250,
	        valueNotFoundText : '',
			emptyText : '���״̬...',
			anchor : '90%'
		});
		
		
	DHCPlanStatus.on('beforequery', function(e){
		this.store.removeAll();
		this.store.proxy=new Ext.data.HttpProxy({url : 'dhcstm.orgutil.csp?actiontype=GetPlanStatus',method:'POST'});
	    this.store.load({params:{start:0,limit:999}});
		});	
			
	var CTLocGrid=""
    //��������Դ
    var LocGridUrl="dhcstm.stkloccatgroupaction.csp"
    //var CTLocGridProxy= new Ext.data.HttpProxy({url:LocGridUrl+'?actiontype=QueryLoc&start=0&limit=999&groupId='+groupId+'&locDesc=',method:'GET'});
    var CTLocGridProxy= new Ext.data.HttpProxy({url:LocGridUrl+'?actiontype=QueryLoc',method:'GET'});
    var CTLocGridDs = new Ext.data.Store({
	    proxy:CTLocGridProxy,
        reader:new Ext.data.JsonReader({
            root:'rows',
		    totalProperty:'results'
        }, [
	    	{name:'Rowid'},
		    {name:'Code'},
		    {name:'Desc'}
	    ]),
        remoteSort:false,
        pruneModifiedRecords:true
    });
    
    //ģ��
    var CTLocGridCm = new Ext.grid.ColumnModel([
    	 new Ext.grid.RowNumberer(),
	   {
        header:"����",
        dataIndex:'Code',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'Desc',
        width:200,
        align:'left',
        sortable:true
    }
    ]);

        //��ʼ��Ĭ��������
    CTLocGridCm.defaultSortable = true;
        var find = new Ext.Toolbar.Button({
	    text:'��ѯ',
        tooltip:'��ѯ',
        iconCls:'page_find',
    	width : 70,
	    height : 30,
	    handler:function(){
    		Query()
    	}
    });
    function Query(){
              
	    CTLocGridDs.load({params:{strFilter:Ext.getCmp('locCode').getValue()+"^"+Ext.getCmp('locName').getValue(),start:0,limit:CTLocPagingToolbar.pageSize,sort:'Rowid',dir:'desc',groupId:groupId}})
	    
    }
    var CTLocPagingToolbar = new Ext.PagingToolbar({
    store:CTLocGridDs,
	pageSize:30,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='Rowid';
		B[A.dir]='desc';
		B['strFilter']=Ext.getCmp('locCode').getValue()+"^"+Ext.getCmp('locName').getValue();
		B['groupId']=groupId;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

	//�ɹ�����grid
    CTLocGrid = new Ext.grid.EditorGridPanel({
	   store:CTLocGridDs,
	   cm:CTLocGridCm,
	   trackMouseOver:true,
	   region:'center',
	   height:690,
	   stripeRows:true,
	   sm:new Ext.grid.CellSelectionModel({}),
	   loadMask:true,
	   bbar:CTLocPagingToolbar,
	   tbar:['���Ҵ���:',locCode,'��������:',locName,'-',find]
	   //clicksToEdit:1
    });
    CTLocGrid.addListener("rowclick",function(grid,rowindex,e){
	    var selectRow=CTLocGridDs.getAt(rowindex);
	     Loc=selectRow.get("Rowid");
	    StatusGrpGridDs.load({params:{Loc:Loc}});
	    });
   
    
	//��������Դ
	var DetailUrl =StatusGrpGridUrl+'?actiontype=Select';
    // ͨ��AJAX��ʽ���ú�̨����
    var proxy = new Ext.data.HttpProxy({
	    		url : DetailUrl,
	    		method : "POST"
	    });
		
    // ָ���в���
    var fields = ["InitRowId","DHCPlanStatus","DHCPlanStatusDesc","SSGroup","SSGroupDesc"];
    		
    // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
    var reader = new Ext.data.JsonReader({
	    	root : 'rows',
	    	totalProperty : "results",
		    id : "RowId",
		    fields : fields
    });	
    // ���ݼ�
    var StatusGrpGridDs = new Ext.data.Store({
	    	proxy : proxy,
	    	reader : reader,
	    	listeners:{
	    	'load':function(ds){
	    	 }
    	}
    });	
    
    //ģ��
    var nm = new Ext.grid.RowNumberer(); 
    var StatusGrpGridCm=new Ext.grid.ColumnModel([nm,{
        header : "InitRowId",
		dataIndex : 'InitRowId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	},{
	    header:"��˼���",
        dataIndex:'DHCPlanStatus',
        width:250,
        align:'left',
        sortable:true,
        //editable:false,
        renderer :Ext.util.Format.comboRenderer2(DHCPlanStatus,"DHCPlanStatus","DHCPlanStatusDesc"),
        editor:new Ext.grid.GridEditor(DHCPlanStatus,new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var Loc=field.getValue();
							if (Loc==null || Loc.length<1){
								Msg.info("warning","���Ҳ���Ϊ��!");
								return;
							}																
							var cell = StatusGrpGrid.getSelectionModel().getSelectedCell();
							var row = cell[0];
							var rowData = StatusGrpGrid.getStore().getAt(row);
							var record = StatusGrpGrid.getStore().getAt(cell[0]);
							var colIndex=GetColIndex(StatusGrpGrid,'SSGroup');
			        		StatusGrpGrid.startEditing(cell[0], colIndex);
							}
						}
					}
		}))
	 },{
        header:"��ȫ��",
        dataIndex:'SSGroup',
        width:250,
        align:'left',
        sortable:true,
		renderer :Ext.util.Format.comboRenderer2(SSGroup,"SSGroup","SSGroupDesc"),
		editor:new Ext.grid.GridEditor(SSGroup,new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var SSGroup=	field.getValue();
							if (SSGroup==""){
								Msg.info("warning","��ȫ�鲻��Ϊ��!");
								return;
							}																	
							addNewRow()
							}
						}
					}
		}))
      }
  ]);

	 //��ʼ��Ĭ��������
	 StatusGrpGridCm.defaultSortable = true;
    	 var addLocGrp = new Ext.Toolbar.Button({
		 text:'�½�',
   	  	 tooltip:'�½�',
   	  	 iconCls:'page_add',
		 width : 70,
		 height : 30,
		 handler:function(){
			if(Loc==null||Loc.length<1){
				Msg.info("warning","��ѡ��ɹ����ң�")
				return ;
				} 
		 	addNewRow();
		 }
	 });
     function addNewRow(){
	     var record=Ext.data.Record.create([{name:'InitRowId'},{name:'DHCPlanStatus'},{name:'SSGroup'}]);
	     var newRecord=new Ext.data.Record({
		     InitRowId:'',
		     DHCPlanStatus:'',
		     SSGroup:''
		     });
		    StatusGrpGridDs.add(newRecord);
		    var lastRow=StatusGrpGridDs.getCount()-1;
		    var colIndex=GetColIndex(StatusGrpGrid,'DHCPlanStatus');
			StatusGrpGrid.startEditing(lastRow,colIndex); 
	     }
	 var saveLocGrp = new Ext.Toolbar.Button({
		 text:'����',
   	 	 tooltip:'����',
    	 iconCls:'page_save',
		 width : 70,
		 height : 30,
		 handler:function(){
			if(Loc==null||Loc.length<1){
				Msg.info("warning","��ѡ��ɹ����ң�")
				return ;
				}  
	 		save()
	 	}
	 });
	 function save(){
		 var ListDetail="";
		 var rowCount = StatusGrpGrid.getStore().getCount();
		 for (var i = 0; i < rowCount; i++) {
				var rowData = StatusGrpGridDs.getAt(i);	
				//���������ݷ����仯ʱִ����������
				if(rowData.data.newRecord || rowData.dirty){
					var RowId = rowData.get("InitRowId");
					var Status = rowData.get("DHCPlanStatus").trim();
					var SSGroup=rowData.get("SSGroup").trim();
					if(Loc!="" && SSGroup!=""){
						var str = RowId+"^"+Loc+"^"+SSGroup+"^"+Status;	
						if(ListDetail==""){
							ListDetail=str;
						}
						else{
							ListDetail=ListDetail+xRowDelim()+str;
						}
					}
				}
			}
			if(ListDetail==""){
				Msg.info("warning","û���޸Ļ����������!");
				return false;
			}
			var PlanNo = tkMakeServerCall("web.DHCSTM.DHCPlanStatusInit", "GetPlanNotAuditAll",Loc );	
			if(PlanNo!=""){
				Msg.info("warning","�ÿ��Ҵ���δ�����ɵĲɹ���,��"+PlanNo+"�����޸Ŀ��Ҳɹ���˼���")
				return  false;
			}
			var url = StatusGrpGridUrl
					+ "?actiontype=Save";
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
						url : url,
						params: {Detail:ListDetail},
						method : 'POST',
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
						    mask.hide();
							if (jsonData.success == 'true') {
								 
								Msg.info("success", "����ɹ�!");
								// ˢ�½���
								StatusGrpGridDs.load({params:{Loc:Loc}});

							} else {
								var ret=jsonData.info;
								if(ret==-1){
									Msg.info("error", "û����Ҫ���������!");
								}else if(ret==-3){
									Msg.info("error", "�ÿ��Ҵ���˼�����ά��!");
								}else if(ret==-4){
									Msg.info("error", "�ÿ����µĸð�ȫ����ά��!");
								}else {
									Msg.info("error", "������ϸ���治�ɹ���"+ret);
								}
								
							}
						},
						scope : this
					});
		 
		 }
	 
	 var deleteLocGrp = new Ext.Toolbar.Button({
		text:'ɾ��',
   	 	tooltip:'ɾ��',
   	 	iconCls:'page_delete',
		width : 70,
		height : 30,
		handler:function(){
			Delete()
		}
	});
	function Delete(){
		var cell=StatusGrpGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","��ѡ��Ҫɾ���ļ�¼��");
			return;
			
		}
		var PlanNo = tkMakeServerCall("web.DHCSTM.DHCPlanStatusInit", "GetPlanNotAuditAll",Loc );	
		if(PlanNo!=""){
			Msg.info("warning","�ÿ��Ҵ���δ�����ɵĲɹ���,��"+PlanNo+"�����޸Ŀ��Ҳɹ���˼���")
			return  false;
		}
		var row=cell[0];
		var record=StatusGrpGridDs.getAt(row);
		var rowid=record.get("InitRowId");
		if(rowid==null || rowid.length<1){
			//Msg.info("warning","��ѡ��¼��δ���棬����ɾ��!");
			//return;
			StatusGrpGridDs.remove(record);
			StatusGrpGrid.getView().refresh();
		}else {
				Ext.MessageBox.show({
							title : '��ʾ',
							msg : '�Ƿ�ȷ��ɾ���ù�������Ϣ',
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});

			}
			function showResult(btn) {
			if (btn == "yes") {
		var url = StatusGrpGridUrl+ "?actiontype=Delete";
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url:url,
			method:'post',
			waitMsg:'������...',
			params:{Rowid:rowid},
			success: function(response,opts){	
				var jsonData=Ext.util.JSON.decode(response.responseText);
				  mask.hide();
				if (jsonData.success=='true'){
					Msg.info("success","ɾ���ɹ�!");
					StatusGrpGridDs.load({params:{Loc:Loc}})
				}else {
					Msg.info("error","ɾ��ʧ��!");
				}
			
			}
		});
		
	}}
		}	
	//��˼���ȫ��grid	
	StatusGrpGrid=	 new Ext.grid.EditorGridPanel({
	   store:StatusGrpGridDs,
	   cm:StatusGrpGridCm,
	   trackMouseOver:true,
	   region:'center',
	   height:690,
	   stripeRows:true,
	   sm:new Ext.grid.CellSelectionModel({}),
	   loadMask:true,
	   tbar:[addLocGrp,'-',saveLocGrp,'-',deleteLocGrp],		//
	   clicksToEdit:1
    });
   	 
   	//DHCPlanStatusGridDs.load()
   	
	//ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'west',
			                split: true,
                			width: 509,
                			minSize: 450,
                			maxSize: 550,
                			collapsible: true,
			                title: '�ɹ�����',
			                layout: 'fit', // specify layout manager for items
			                items: CTLocGrid       
			               
			            }, {             
			                region: 'center',						                
			                title: '��˼����밲ȫ��ά��',
			                layout: 'fit', // specify layout manager for items
			                items: StatusGrpGrid          	
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
				//find.handler();
				Query()
					
})	