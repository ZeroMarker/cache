/**
 * ��ҩ��λ
 */
 var DispUomUrl='dhcst.druginfomaintainaction.csp';
function DispUomEdit(dataStore, ArcRowid,BuomId) {
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
			//������ͬ��¼			
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
			// �����������
			Save();			
		}
	});
	
	
	function Save() {	
			var phaloc=Ext.getCmp("PhaLoc").getValue();
			var Arcitm=Ext.getCmp("Arcitm").getValue();
			var rowCount = DispuomGrid.getStore().getCount();
			if (rowCount<1)
			{
				Msg.info("warning", "�޿��ñ�������!");
				return
			}
			var ListData="";
			if ((phaloc=="")||(phaloc==null)){Msg.info("error", "��ѡ������ң�"); return}
			for (var i = 0; i < rowCount; i++) {
					var ilduid = MasterInfoStore.getAt(i).get("ilduid");
					var uomdr=MasterInfoStore.getAt(i).get("UomId");
					if ((uomdr=="")||(uomdr==null))
					{
						Msg.info("warning", "��λ����Ϊ��!");
						return
						}
					var acttive=MasterInfoStore.getAt(i).get("ActiveFlag");
					var df=Ext.util.Format.date( MasterInfoStore.getAt(i).get("SDate"),'Y-m-d'); 
					var dt=Ext.util.Format.date(MasterInfoStore.getAt(i).get("EDate"),'Y-m-d');
					//alert(ilduid+"^"+uomdr+"^"+acttive+"^"+df+"^"+dt)
					if (ListData=="") 
						{
							ListData=ilduid+"^"+uomdr+"^"+acttive+"^"+df+"^"+dt;
						}
					else
					{ListData=ListData+","+ilduid+"^"+uomdr+"^"+acttive+"^"+df+"^"+dt;}
				}

			SaveDispUom(phaloc,Arcitm,ListData);
		}
		
	function SaveDispUom(phaloc,Arcitm,ListData){
			var url = DispUomUrl
					+ '?actiontype=DispUomSave';
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{phaloc:phaloc,Arcitm:Arcitm,ListData:ListData},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "����ɹ�!");
								GetDispUomInfo();
							} else {
								if (jsonData.info) {Msg.info("error", "����ʧ��:"+"�����ںͻ�����λ��ת��ϵ����");}
								else {Msg.info("error", "����ʧ��:"+jsonData.info);}
							}
						},
						scope : this
				});
				
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
		}
	});	
	function deleteData(){
					var cell = DispuomGrid.getSelectionModel().getSelectedCell();
					if (cell==null)
					{
						return;
					}
					var record = DispuomGrid.getStore().getAt(cell[0]);
					var ilduid = record.get("ilduid");
					if (ilduid=="") {
						DispuomGrid.getStore().remove(record);
						DispuomGrid.getView().refresh();
						return;
						}
					 //ɾ����������
					 var url = DispUomUrl+'?actiontype=DeleteDispUomInfo';
					 Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{ilduid:ilduid},
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
			GetDispUomInfo();
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
	var incibuom = new Ext.form.TextField({
		fieldLabel : '��������λid',
		id : 'incibuom',
		name : 'incibuom',
		anchor : '90%',
		hidden:true,
		value:BuomId
	});

	
	var PhaLoc = new Ext.ux.ComboBox({
		fieldLabel : '������',
		id : 'PhaLoc',
		name : 'PhaLoc',
		store : dispuomStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'phadisploc',  //����¼�����ݹ����������ݵĲ�������
		selectOnFocus : true,
		forceSelection : true,
		params:{Arcitm:'Arcitm'},
		listeners : {
			'select' : function(e) {
				GetDispUomInfo()
				}
		}

	});

	var uom = new Ext.ux.ComboBox({
					fieldLabel : '��λ',
					id : 'uom',
					name : 'uom',
					anchor : '90%',
					width : 100,
					store :CONUomStore,          //           CTUomStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'CTUomDesc',
					params:{UomId:'incibuom'},
					selectOnFocus : true,
					forceSelection : true,
				      listeners:{      
                      	'select':function(combo){
		                         var cell = DispuomGrid.getSelectionModel().getSelectedCell();
		                         var record = DispuomGrid.getStore().getAt(cell[0]);
                                 var colIndex=GetColIndex(DispuomGrid,'UomId');
                                 DispuomGrid.stopEditing(cell[0], colIndex); //����ǰ������ɱ༭ LiangQiang 2013-11-22 
								 var inputUomDr = record.get("UomId");
								 var repeatflag=CheckInciUomRep(inputUomDr,cell[0]);  //���һ��
								 if (repeatflag=="1")
								 {
									Msg.info("warning", "�Ѵ�����ͬ��λ��¼!");
									record.set("UomId","");
									DispuomGrid.startEditing(cell[0], colIndex);
									return;	 
								 }
								 
                         }
				      }

				});
	 var ActiveFlag=new Ext.grid.CheckColumn({
       header: '�����־',
       dataIndex: 'ActiveFlag',
       width: 80
    });

	var nm = new Ext.grid.RowNumberer();	
	var sm=new Ext.grid.CheckboxSelectionModel()                //({singleSelect:false});
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "ilduid",
				dataIndex : 'ilduid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true

			},{
				header : "��λ",
				dataIndex : 'UomId',
				width : 80,
				align : 'left',
				sortable : true,
				renderer :Ext.util.Format.comboRenderer2(uom,"UomId","Uom")	,
				editor : new Ext.grid.GridEditor(uom)
			},ActiveFlag,{
				header : "��ʼʱ��",
				dataIndex : 'SDate',
				width : 140,
				align : 'center',
				sortable : true,						
				renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
				editor :new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : false,
						format : App_StkDateFormat
				}) 
			},{
				header : "����ʱ��",
				dataIndex : 'EDate',
				width : 100,
				align : 'center',
				sortable : true,						
				renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
				editor :new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : true,
						format : App_StkDateFormat
				})
				}
			]);
	
	// ����·��
	var MasterInfoUrl = DispUomUrl + '?actiontype=GetDispUomInfo';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["ilduid","UomId","Uom","ActiveFlag","SDate","EDate"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "ilduid",
				fields : fields
			});
	// ���ݼ�
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
			
	function GetDispUomInfo(IngrRowid) {
			var Arcitm=Ext.getCmp("Arcitm").getValue();
			var phaloc=Ext.getCmp("PhaLoc").getValue();
			if (Arcitm == null) {
				return;
			}
			if (phaloc == null) {
				return;
			}
			MasterInfoStore.removeAll();
			MasterInfoStore.load({params:{phaloc:phaloc,Arcitm:Arcitm}});
		}
	///�жϵ�λ�ظ�
	function CheckInciUomRep(InputUomDr,InputRow){
	    var repflag="0"
		var Count = DispuomGrid.getStore().getCount();
		for (var i = 0; i < Count; i++) {
			var rowData = MasterInfoStore.getAt(i);
			var rowUomDr = rowData.get("UomId");
			if ((InputRow==i)){continue}
			if ((rowUomDr!="")&&(InputUomDr==rowUomDr)){
				var repflag="1";
				return repflag;
				}
			}
		return repflag;
	}			
	var DispuomGrid = new Ext.grid.EditorGridPanel({
                id:'DispuomGrid',
                region : 'center',
                cm : MasterInfoCm,
                store : MasterInfoStore,
                trackMouseOver : true,
                stripeRows : true,
                sm : new Ext.grid.CellSelectionModel({}),
                clicksToEdit : 1,
                plugins: [ActiveFlag],
                loadMask : true
            });
			
			
	var HisListTab = new Ext.form.FormPanel({
			height:50,
			labelWidth: 80,	
			labelAlign : 'right',
			frame : true,
			autoScroll : false,
			region : 'north',
			defaults:{border:false},
			items:[{
				xtype:'fieldset',
				columnWidth : 0.5,
				items : [PhaLoc]

			}]
	})

	var window = new Ext.Window({
				title : '��ҩ��λ',
				width :400,
				height : 400,
				layout : 'border',
				items :  [{
                	region: 'center',
                	split: true,
               		width: 500, 
                	minSize: 470,
                	maxSize: 600,
                	layout: 'border', 
                	items : [HisListTab,DispuomGrid]          
            	}],
				tbar : [AddBT, '-', SaveBT, '-', DeleteBT, '-', closeBT]
				
			});
	window.show();
	function addNewRow() {

			var record = Ext.data.Record.create([{
						name :'ilduid',
						type : 'string',
						hidden : false
					},{
						name : 'UomId',
						type : 'string'
					}, {
						name : 'DispUom',
						type : 'string'
					},{
						name : 'ActiveFlag'
						//type : 'ActiveFlag'

					}, {
						name : 'SDate',
						type : 'date'
					}, {
						name : 'EDate',
						type : 'date'
					}]);
			var NewRecord = new record({
						ilduid:'',
						UomRowid : '',
						DispUom : '',
						ActiveFlag:'',
						SDate:new Date().add(Date.DAY,1),
						EDate:new Date().add(Date.DAY,1)
					});
			MasterInfoStore.add(NewRecord);
	}
	
	addNewRow();
}
