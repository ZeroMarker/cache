/**
 *  ���ƿ�����ҩ
 */
var RestrictDocUrl='dhcst.druginfomaintainaction.csp';
function RestrictDocEdit(dataStore,ArcRowid,ArcimCode,ArcimDesc,Spec,ManfId) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
 	// ���Ӱ�ť
	var AddBT = new Ext.Toolbar.Button({
		text : '����',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_add',
		handler : function() {
			addNewRow();			
		}
	});
	// ���水ť
	var SaveBT = new Ext.Toolbar.Button({
		id : "SaveBT",
		text : '����',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			Save();		
		}
	});
	
	
	function Save() {	
		var Arcitm=Ext.getCmp("Arcitm").getValue();
		var rowCount = RestrictDocGrid.getStore().getCount();
		var ListData="";
		if(CheckDataBeforeSave()==true){
		for (var i = 0; i < rowCount; i++) {
		
				var autid = MasterInfoStore.getAt(i).get("autid");
				var relation=MasterInfoStore.getAt(i).get("relation");
				var type=MasterInfoStore.getAt(i).get("type");
				var Operate=MasterInfoStore.getAt(i).get("Operate");
				var Pointer=MasterInfoStore.getAt(i).get("Pointer");
				if (Pointer==""){continue;}
				if (ListData=="") 
					{
						ListData=autid+"^"+relation+"^"+type+"^"+Operate+"^"+Pointer;
					}
				else
				{ListData=ListData+"!"+autid+"^"+relation+"^"+type+"^"+Operate+"^"+Pointer;}
			}
		RestrictDocSave(Arcitm,ListData);
		}
	}
	/**
	 * ������ⵥǰ���ݼ��
	 */		
	function CheckDataBeforeSave() {
		// 1.�ж����ҩƷ�Ƿ�Ϊ��
		var rowCount = MasterInfoStore.getCount();
		if (rowCount<1)
		{
			Msg.info("warning", "�޿��ñ�������!");
			return;	
		}
		// 2.��Ч����
		for (var i = 0; i < rowCount; i++) {
			var pointer = MasterInfoStore.getAt(i).get("Pointer");
			var operate = MasterInfoStore.getAt(i).get("Operate");
			var type = MasterInfoStore.getAt(i).get("type");
			var relation = MasterInfoStore.getAt(i).get("relation");
	        if((pointer != "")||(operate != "")||(type != "")||(relation != "")){
				if ((relation == "") || (relation == null) ) {
					Msg.info("warning", "��ϵ����Ϊ�գ�");
					var cell = RestrictDocGrid.getSelectionModel().getSelectedCell();
					RestrictDocGrid.getSelectionModel().select(cell[0], 1);
					changeBgColor(i, "yellow");
					return false;
				}
				else if ((type == "") || (type == null) ) {
					Msg.info("warning", "���Ͳ���Ϊ�գ�");
					var cell = RestrictDocGrid.getSelectionModel().getSelectedCell();
					RestrictDocGrid.getSelectionModel().select(cell[0], 1);
					changeBgColor(i, "yellow");
					return false;
				}
				else if ((operate == "") || (operate == null) ) {
					Msg.info("warning", "��������Ϊ�գ�");
					var cell = RestrictDocGrid.getSelectionModel().getSelectedCell();
					RestrictDocGrid.getSelectionModel().select(cell[0], 1);
					changeBgColor(i, "yellow");
					return false;
				}
				else if ((pointer == "") || (pointer == null) ) {
					Msg.info("warning", "���Ʋ���Ϊ�գ�");
					var cell = RestrictDocGrid.getSelectionModel().getSelectedCell();
					RestrictDocGrid.getSelectionModel().select(cell[0], 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
        }
		// 3.�ж��ظ�����
		for (var i = 0; i < rowCount - 1; i++) {
			for (var j = i + 1; j < rowCount; j++) {
				var relation_i = MasterInfoStore.getAt(i).get("relation");;
				var relation_j = MasterInfoStore.getAt(j).get("relation");;
				
				var type_i = MasterInfoStore.getAt(i).get("type");;
				var type_j = MasterInfoStore.getAt(j).get("type");;
				
				var Operate_i = MasterInfoStore.getAt(i).get("Operate");;
				var Operate_j = MasterInfoStore.getAt(j).get("Operate");;

				var Pointer_i = MasterInfoStore.getAt(i).get("Pointer");;
				var Pointer_j = MasterInfoStore.getAt(j).get("Pointer");;					
				
				//var itemdesc=DetailStore.getAt(i).get("IncDesc");;
				var icnt=i+1;
				var jcnt=j+1;
				if (relation_i == relation_j && type_i == type_j && Operate_i == Operate_j && Pointer_i == Pointer_j) {
					changeBgColor(i, "yellow");
					changeBgColor(j, "yellow");
					Msg.info("warning", "��"+icnt+","+jcnt+"��"+"�ظ�������������!");
					return false;
				}
			}
		}
		return true;
    } 
			

	// �任����ɫ
		function changeBgColor(row, color) {
			RestrictDocGrid.getView().getRow(row).style.backgroundColor = color;
		}
		
	function RestrictDocSave(Arcitm,ListData){
		if(ListData==""){
			Msg.info("error","û���޸Ļ����������!");
			return false;
		}
		else{
			var url = RestrictDocUrl
					+ '?actiontype=RestrictDocSave';
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{Arcitm:Arcitm,ListData:ListData},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "����ɹ�!");
								GetRestrictDocInfo();
							} else {
								Msg.info("error", "����ʧ��:"+jsonData.info);
							}
						},
						scope : this
				});
		}	
	}
	//2. ɾ����ť
	var DeleteBT = new Ext.Toolbar.Button({
		id : "DeleteBT",
		text : 'ɾ��',
		tooltip : '���ɾ��',
		width : 70,
		height : 30,
		iconCls : 'page_delete',
		handler : function() {
			deleteData();
			GetRestrictDocInfo();
		}
	});	
	function deleteData(){
					var cell = RestrictDocGrid.getSelectionModel().getSelectedCell();
					if (cell==null)
					{
						return;
					}
					var record = RestrictDocGrid.getStore().getAt(cell[0]);
					var autid = record.get("autid");
					if (autid=="") {
						RestrictDocGrid.getStore().remove(record);
						RestrictDocGrid.getView().refresh();
						return;
						}
					//ɾ����������
					 var url = RestrictDocUrl+'?actiontype=DeleteRestrictDoc';
					 Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{autid:autid},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "ɾ���ɹ�!");
							} else {
								Msg.info("error", "ɾ��ʧ��:"+jsonData.info);
							}
						},
						scope : this
				});

		}
	var closeBT = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '�رս���',
				iconCls : 'page_close',
				height:30,
				width:70,
				handler : function() {
					window.close();
				}
			});

	var Arcitm = new Ext.form.TextField({
		fieldLabel : 'ҽ����id',
		id : 'Arcitm',
		name : 'Arcitm',
		anchor : '90%',
		value:ArcRowid,
		hidden:true
	});


    var ManfDesc=tkMakeServerCall("web.DHCST.RestrictDoc","GetManfDescForResDoc",ManfId);
	var code=ArcimCode
	var descstr=ArcimDesc.split("[")
	var desc=descstr[0]
	var spec=Spec
	var manf=ManfDesc
    var Code = new Ext.form.Label({
		fieldLabel : '����',
		id : 'Code',
		name : 'Code',
		anchor : '90%',
		html:'<div style="padding-top:3px">'+code+'</div>'
	});		
	var Desc = new Ext.form.Label({
		fieldLabel : '����',
		id : 'Desc',
		name : 'Desc',
		anchor : '90%',
		html:'<div style="padding-top:3px">'+desc+'</div>'
	});
	var Spec = new Ext.form.Label({
		fieldLabel : '���',
		id : 'Spec',
		name : 'Spec',
		anchor : '90%',
		html:'<div style="padding-top:3px">'+spec+'</div>'
	});

	var Manf = new Ext.form.Label({
		fieldLabel : '����',
		id : 'Manf',
		name : 'Manf',
		anchor : '90%',
		html:'<div style="padding-top:3px">'+manf+'</div>'
	});
	
    var RelArr={results:2,rows:[{RowId:'AND',Description:'����'},{RowId:'OR',Description:'����'}]}
    var TypeArr={results:3,rows:[{RowId:'KS',Description:'����'},{RowId:'ZC',Description:'ְ��'},{RowId:'YS',Description:'ҽ��'},{RowId:'JB',Description:'���˼���'}]}
    var OpeArr={results:3,rows:[{RowId:'=',Description:'����'},{RowId:'<>',Description:'������'},{RowId:'>=',Description:'���ڵ���'}]}
         			
	var RelBoxStore = new Ext.data.Store({
		proxy :new Ext.data.MemoryProxy(RelArr), 
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['RowId','Description'])
	});

	//var RelBoxStore = new Ext.data.SimpleStore({
	//		fields : ['Description','RowId'],
	//	    data : [['����','AND'], ['����','OR']]
	//	});


	var TypeBoxStore = new Ext.data.Store({
		proxy :new Ext.data.MemoryProxy(TypeArr), 
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['Description', 'RowId'])
	});

	var OpeBoxStore = new Ext.data.Store({
		proxy :new Ext.data.MemoryProxy(OpeArr), 
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['Description', 'RowId'])
	});
        
	var PointerStore = new Ext.data.Store({
			proxy : new Ext.data.HttpProxy({
					url : 'dhcst.drugutil.csp?actiontype=GetDescInfo'
				}),
			reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['Description', 'RowId']),
	        baseParams:{Type:'',PointerDesc:''}
		});
				
	var RelBox = new Ext.ux.ComboBox({
					fieldLabel : '��ϵ',
					pageSize:0,
					id : 'RelBox',
					name : 'RelBox',
					anchor : '90%',
					width : 50,
					store :RelBoxStore,         
					valueField : 'RowId',
					displayField : 'Description',
					selectOnFocus : true,
					forceSelection : true,
				      listeners:{      
                                     'select':function(combo){
		                         var cell = RestrictDocGrid.getSelectionModel().getSelectedCell();
		                         var record = RestrictDocGrid.getStore().getAt(cell[0]);
                                        var colIndex=GetColIndex(RestrictDocGrid,'autid');
                                         RestrictDocGrid.stopEditing(cell[0], colIndex); //����ǰ������ɱ༭ LiangQiang 2013-11-22 
                                          //PointerStore.removeAll();   
                                              }
				      }
				});

	var TypeBox = new Ext.ux.ComboBox({
					fieldLabel : '����',
					id : 'TypeBox',
					name : 'TypeBox',
					anchor : '90%',
					width : 50,
					pageSize:0,
					store :TypeBoxStore,         
					valueField : 'RowId',
					displayField : 'Description',
					selectOnFocus : true,
					forceSelection : true,
				    listeners:{      
                    	'select':function(combo){
	                    		 var tmpcombovalue=combo.value
		                         var cell = RestrictDocGrid.getSelectionModel().getSelectedCell();
		                         var record = RestrictDocGrid.getStore().getAt(cell[0]);
                                 var colIndex=GetColIndex(RestrictDocGrid,'autid');
                                 RestrictDocGrid.stopEditing(cell[0], colIndex); //����ǰ������ɱ༭ LiangQiang 2013-11-22 
                      			 if (record.get("type")!="ZC")
                      			 {
	                      			 if (record.get("Operate")==">=")
	                      			 {
		                      			 Msg.info("warning", "��ְ�ƿ�ѡ����ڵ��ڵĹ�ϵ!");
		                      			 record.set("type","")
		                      			 RestrictDocGrid.startEditing(cell[0], colIndex);
		                      			 return;
		                      			 
		                      		  }
	                      			 
	                      		 } 
		                      		record.set("Pointer","")
                       }
				      }
				});
	
	var OpeBox = new Ext.ux.ComboBox({
					fieldLabel : '����',
					id : 'OpeBox',
					name : 'OpeBox',
					anchor : '90%',
					width : 50,
					store :OpeBoxStore,         
					valueField : 'RowId',
					displayField : 'Description',
					selectOnFocus : true,
					forceSelection : true,
					pageSize:0,
				      listeners:{      
                            'select':function(combo){
		                         var cell = RestrictDocGrid.getSelectionModel().getSelectedCell();
		                         var record = RestrictDocGrid.getStore().getAt(cell[0]);
                                 var colIndex=GetColIndex(RestrictDocGrid,'autid');
                                 RestrictDocGrid.stopEditing(cell[0], colIndex); //����ǰ������ɱ༭ LiangQiang 2013-11-22   
                      			 var recordtype=record.get("type")
                      			 if ((recordtype==null)||(recordtype==""))
                      			 {
	                      			 record.set("Operate","")
	                      			 Msg.info("warning", "����ѡ������");
	                      			 RestrictDocGrid.startEditing(cell[0], colIndex);
	                      			 return
	                      	     }
                      			 if (recordtype!="ZC")
                      			 {
	                      			 if (record.get("Operate")==">=")
	                      			 {
		                      			 Msg.info("warning", "��ְ�ƿ�ѡ����ڵ��ڵĹ�ϵ!");
		                      			 record.set("Operate","")
		                      			 RestrictDocGrid.startEditing(cell[0], colIndex);
		                      			 return;
		                      			 
		                      		  }
	                      			 
	                      		 }
                      			 
                      		}
				      }
				});
	
	var PointerBox = new Ext.ux.ComboBox({
					fieldLabel : '����',
					id : 'PointerBox',
					name : 'PointerBox',
					anchor : '90%',
					width : 50,
					pageSize:0,
					store :PointerStore,         
					valueField : 'RowId',
					displayField : 'Description',
					selectOnFocus : true,
					forceSelection : true,
					params : {Type:'TypeBox'},
					filterName:'PointerDesc',
				      listeners:{      
                                     'select':function(combo){
		                         var cell = RestrictDocGrid.getSelectionModel().getSelectedCell();
		                         var record = RestrictDocGrid.getStore().getAt(cell[0]);
                                        var colIndex=GetColIndex(RestrictDocGrid,'autid');
                                         RestrictDocGrid.stopEditing(cell[0], colIndex); //����ǰ������ɱ༭ LiangQiang 2013-11-22 
                                          PointerStore.removeAll();   
                                              }
				      }
				});
		/**
		 * ����չ���¼�
		 */
		PointerBox.on('expand', function(combo) {
					var cell = RestrictDocGrid.getSelectionModel().getSelectedCell();
					var record = RestrictDocGrid.getStore().getAt(cell[0]);
                                   var type = record.get("type");
					PointerStore.removeAll();

					PointerStore.load({params:{Type:type}});
				});


				
	var nm = new Ext.grid.RowNumberer();	
	var sm=new Ext.grid.CheckboxSelectionModel()                
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "autid",
				dataIndex : 'autid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true

			},{
				header : "��ϵ",
				dataIndex : 'relation',
				width : 100,
				align : 'center',
				sortable : true,
				renderer :Ext.util.Format.comboRenderer2(RelBox,"relation","relationDesc"),
				editor : new Ext.grid.GridEditor(RelBox)
			},{
				header : "����",
				dataIndex : 'type',
				width : 100,
				align : 'center',
				sortable : true,
				renderer :Ext.util.Format.comboRenderer2(TypeBox,"type","typeDesc"),
				editor : new Ext.grid.GridEditor(TypeBox)
			},{
				header : "����",
				dataIndex : 'Operate',
				width : 100,
				align : 'center',
				sortable : true,						
				renderer :Ext.util.Format.comboRenderer2(OpeBox,"Operate","OperateDesc"),
				editor : new Ext.grid.GridEditor(OpeBox)
			},{
				header : "����",
				dataIndex : 'Pointer',
				width : 180,
				align : 'center',
				sortable : true,
				renderer :Ext.util.Format.comboRenderer2(PointerBox,"Pointer","PointerDesc"),
				editor : new Ext.grid.GridEditor(PointerBox)
			}
			]);
    
	
	// ����·��
    var MasterInfoUrl = RestrictDocUrl + '?actiontype=GetRestrictDocInfo';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["autid","relation","relationDesc","type","typeDesc","Operate","OperateDesc","Pointer","PointerDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "autid",
				fields : fields
			});
	// ���ݼ�
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
			
	function GetRestrictDocInfo() {
			var Arcitm=Ext.getCmp("Arcitm").getValue();
			if (Arcitm == null) {
				return;
			}
			MasterInfoStore.removeAll();
			MasterInfoStore.load({params:{Arcitm:Arcitm}});
		}
	
			
	var RestrictDocGrid = new Ext.grid.EditorGridPanel({
                id:'RestrictDocGrid',
                region : 'center',
                cm : MasterInfoCm,
                store : MasterInfoStore,
                trackMouseOver : true,
                stripeRows : true,
                sm : new Ext.grid.CellSelectionModel({}),
                clicksToEdit : 1,
                loadMask : true
            });
			
		var HisListTab = new Ext.form.FormPanel({
			height:110,
			labelWidth: 60,	
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			region : 'north',	
			bodyStyle:'padding:5px',
			items:[{
				xtype:'fieldset',
				title:'ҩƷ��Ϣ',
				layout: 'column',   
				style:'padding:0px 0px 0px 5px',
				defaults: {border:false},
				items : [{ 				
					columnWidth: 0.5,
	            	xtype: 'fieldset',	            	
	            	items: [Code,Spec]					
				}, {
					columnWidth: 0.5,
	            	xtype: 'fieldset',
					items : [Desc,Manf]
				}]					
			}]			
		});
			
 
	var window = new Ext.Window({
				title : '����������ҩ',
				width :600,
				height : 400,
				layout : 'border',
				items :  [{
                	region: 'center',
                	split: true,
               		width: 500, 
                	minSize: 470,
                	maxSize: 600,
                	layout: 'border', 
                	items : [HisListTab,RestrictDocGrid]          
            	}],
				tbar : [AddBT, '-', SaveBT, '-', DeleteBT, '-', closeBT]
				
			});
	window.show();
	function addNewRow() {
			var record = Ext.data.Record.create([{
						name :'autid',
						type : 'string',
						hidden : false
					},{
						name : 'relation',
						type : 'string'
					}, {
						name : 'type',
						type : 'string'
					}, {
						name : 'Operate',
						type : 'string'
					},{
						name : 'Pointer',
						type : 'string'
					}]);
			var NewRecord = new record({
						autid:'',
						relation : '',
						type : '',
						Operate:'',
						Pointer:''
					});
			MasterInfoStore.add(NewRecord);
	}
	
	addNewRow();
	GetRestrictDocInfo();
}

