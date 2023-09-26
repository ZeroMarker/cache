// /����: ��ⵥ���
// /����: �����Ѿ��������ҳ�������Ѿ������±���û������ҵ����������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.18

Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var HospId=session['LOGON.HOSPID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gIngrRowid="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;	

	if(gParam.length<1){
		GetParam();  //����������ò���
	}
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '��ⲿ��',
		id : 'PhaLoc',
		name : 'PhaLoc',
		width : 200,
		emptyText : '��ⲿ��...',
		groupId:gGroupId
	});
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		params : {LocId : 'PhaLoc'}
	});
	
	// ��ⵥ��
	var InGrNo = new Ext.form.TextField({
				fieldLabel : '��ⵥ��',
				id : 'InGrNo',
				name : 'InGrNo',
				anchor : '90%',
				width : 120,
				disabled : false
			});

	// ��Ʊ��
	var InvNo = new Ext.form.TextField({
				fieldLabel : '��Ʊ��',
				id : 'InvNo',
				name : 'InvNo',
				anchor : '90%',
				width : 120,
				disabled : false
			});
	
	// ��ʼ����
	var StartDate= new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '80%',
				
				width : 120,
				value : DefaultStDate()
			});

	// ��������
	var EndDate= new Ext.ux.DateField({
				fieldLabel : '��������',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '80%',
				
				width : 120,
				value : DefaultEdDate()
			});

// ������ť
var searchBT = new Ext.Toolbar.Button({
			text : '����',
			tooltip : '���������ⵥ��Ϣ',
			height:30,
			width:70,
			iconCls : 'page_find',
			handler : function() {
				searchDurgData();
			}
		});

function searchDurgData() {
	var StartDate = Ext.getCmp("StartDate").getValue();
	if(StartDate!=null && StartDate!=""){
		StartDate=StartDate.format(ARG_DATEFORMAT);
	}else{
		Msg.info("warning","��ѡ��ʼ����!");
		return;
	}
	var EndDate = Ext.getCmp("EndDate").getValue();
	if(EndDate!=null && EndDate!=""){
		EndDate=EndDate.format(ARG_DATEFORMAT);
	}else{
		Msg.info("warning","��ѡ���ֹ����!");
		return;
	}
	var InGrNo = Ext.getCmp("InGrNo").getValue();
	var Vendor = Ext.getCmp("Vendor").getValue();
	var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
	if(PhaLoc==""){
		Msg.info("warning", "��ѡ����ⲿ��!");
		return;
	}
	var AuditFlag="Y";
	var InvNo= Ext.getCmp("InvNo").getValue();
	var ListParam=StartDate+'^'+EndDate+'^'+InGrNo+'^'+Vendor+'^'+PhaLoc+'^^^'+AuditFlag+'^'+InvNo+'^'+gUserId;
	var Page=GridPagingToolbar.pageSize;
	GrMasterInfoStore.setBaseParam('ParamStr',ListParam);
	GrDetailInfoStore.removeAll();
	GrMasterInfoStore.removeAll();
	GrMasterInfoStore.load({
		params:{start:0, limit:Page},
		callback:function(r,options, success) {
			if(success==false){
     			Msg.info("error", "��ѯ������鿴��־!");
     		}else{
     			if(r.length>=1){
     				GrMasterInfoGrid.getSelectionModel().selectFirstRow();
     				GrMasterInfoGrid.fireEvent('select',this,0);
     				GrMasterInfoGrid.getView().focusRow(0);
     			}
     		}
		}
	});
}

// ѡȡ��ť
var acceptBT = new Ext.Toolbar.Button({
			text : '���',
			tooltip : '������',
			height:30,
			width:70,
			iconCls : 'page_save',
			handler : function() {
			
				var newVendor=Ext.getCmp("Vendor").getRawValue();
				var newVendorId=Ext.getCmp("Vendor").getValue();
				var selectRec=GrMasterInfoGrid.getSelectionModel().getSelected();
				if(selectRec==null){
					Msg.info("warning","��ѡ��Ҫ�޸ĵ���ⵥ!");
					return;
				}
				
			  if(GrDetailInfoGrid.activeEditor != null){
		    	GrDetailInfoGrid.activeEditor.completeEdit();
		        }
		      var ListDetail="";
		      var rowCount = GrDetailInfoGrid.getStore().getCount();
		      //��ϸid^����id^����^Ч��^���е���^��Ʊ��^��Ʊ����^��Ʊ���^����
		     for (var i = 0; i < rowCount; i++) {
			    var rowData = GrDetailInfoStore.getAt(i);	
			   //���������ݷ����仯ʱִ����������
			    if(rowData.data.newRecord || rowData.dirty){					
				  var Ingri=rowData.get("Ingri");
				  var incidesc=rowData.get("IncDesc");
				  var ManfId = rowData.get("ManfId");
				  var BatNo = rowData.get("BatchNo");
				  var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),ARG_DATEFORMAT);
				  var SxNo = rowData.get("SxNo");
				  var InvNo=rowData.get("InvNo");
				  var InvDate =Ext.util.Format.date(rowData.get("InvDate"),ARG_DATEFORMAT);
				  var InvAmt=rowData.get("InvMoney");
				  var Rp=rowData.get("Rp");
				  var str = Ingri+"^"+Rp;	
				  if(ListDetail==""){
					    ListDetail=str;
				    }
				     else{
				        	ListDetail=ListDetail+xRowDelim()+str;
				    }
			      }
		         }
		         if(ListDetail==""){
			         Msg.info("warning", "û����Ҫ�������ϸ��");
			       //return -1;  //û����Ҫ���µ���ϸ
		         }
		      var ret=0;  //���³ɹ�
		      var mask=ShowLoadMask(Ext.getBody(),"������...");
		      var url = DictUrl+ "ingdrecredaction.csp?actiontype=UpdateRecInfo";
		      Ext.Ajax.request({
			    url : url,
			    method : 'POST',
			    params:{ListDetail:ListDetail},
			    success : function(result, request) {
				    var jsonData = Ext.util.JSON.decode(result.responseText);
				  
				    if (jsonData.success == 'false') {
					ret=jsonData.info;	
					if(ret==-4){Msg.info("error", "�����ϸ�����ٴκ�壡");	
					return	
					}else if(ret==-63){Msg.info("error", incidesc+"�Ѿ����˻�����");	
					return	
					}else if(ret==-3){Msg.info("error", incidesc+"�Ѿ����");	
					return	
					}else if(ret==-66){Msg.info("error", incidesc+"�ѵ�������");	
					return	
					}else if(ret==-67){Msg.info("error", incidesc+"�ѱ�����");	
					return	
					}else if((ret==-5)||(ret==-6)){Msg.info("error", incidesc+"���������ⵥʧ��!");	
					return	
					}else if((ret==-7)||(ret==-8)){Msg.info("error", incidesc+"��¼��ⵥʧ�ܣ�");	
					return	
					}else if((ret==-9)||(ret==-10)){Msg.info("error", incidesc+"�����ⵥʧ�ܣ�");	
					return	
					}else if(ret==-11){Msg.info("error", incidesc+"��¼���ⵥʧ�ܣ�");	
					return	
					}else if(ret==-65){Msg.info("error", incidesc+"����������Ϣ�����ʧ�ܣ�");	
					return	
					}		
				    }else{
					Msg.info("success", "��ⵥ���ɹ�!");
					// 7.��ʾ��ⵥ����
					Query(gIngrRowid);
					
					}
				mask.hide();
			    },
			     scope : this
		       });
		       mask.hide();
				/*
				var oldVendor=selectRec.get("Vendor");
				//������ϸ
				var ret=Update();
				
			
				if(ret==0){
					Msg.info("success", "��ⵥ��ϸ���³ɹ�!");
					// 7.��ʾ��ⵥ����
					Query(gIngrRowid);
				}else if((ret==-1)&(newVendor==oldVendor)){
					Msg.info("warning", "����û�з����仯������Ҫ����!");
					return;
				}else if(ret!=-1){
					Msg.info("error", "����ĳ��ϸʧ�ܣ�"+ret);	
				}
				//UpdateVendor();  //���¹�Ӧ��
				*/
			}
		});
		
	
	/**
	 * ����������Ϣ
	 */
	function Update() {
		if(GrDetailInfoGrid.activeEditor != null){
			GrDetailInfoGrid.activeEditor.completeEdit();
		}
		var ListDetail="";
		var rowCount = GrDetailInfoGrid.getStore().getCount();
		//��ϸid^����id^����^Ч��^���е���^��Ʊ��^��Ʊ����^��Ʊ���^����
		for (var i = 0; i < rowCount; i++) {
			var rowData = GrDetailInfoStore.getAt(i);	
			//���������ݷ����仯ʱִ����������
			if(rowData.data.newRecord || rowData.dirty){					
				var Ingri=rowData.get("Ingri");
				var ManfId = rowData.get("ManfId");
				var BatNo = rowData.get("BatchNo");
				var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),ARG_DATEFORMAT);
				var SxNo = rowData.get("SxNo");
				var InvNo=rowData.get("InvNo");
				var InvDate =Ext.util.Format.date(rowData.get("InvDate"),ARG_DATEFORMAT);
				var InvAmt=rowData.get("InvMoney");
				var Rp=rowData.get("Rp");
				var str = Ingri + "^" + ManfId + "^"	+ BatNo + "^" + ExpDate + "^"
						+ SxNo + "^" + InvNo + "^" + InvDate+"^"+InvAmt+"^"+Rp;	
				if(ListDetail==""){
					ListDetail=str;
				}
				else{
					ListDetail=ListDetail+xRowDelim()+str;
				}
			}
		}
		if(ListDetail==""){
			return -1;  //û����Ҫ���µ���ϸ
		}
		var ret=0;  //���³ɹ�
		var mask=ShowLoadMask(Ext.getBody(),"������...");
		var url = DictUrl+ "ingdrecredaction.csp?actiontype=UpdateRecInfo";
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{ListDetail:ListDetail},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'false') {
					ret=jsonData.info;		
					Msg.info("error", "����ĳ��ϸʧ�ܣ�"+ret);	
					return			
				}
				mask.hide();
			},
			scope : this
		});
		
		return ret;
	}
// ��հ�ť
var clearBT = new Ext.Toolbar.Button({
			text : '���',
			tooltip : '������',
			height:30,
			width:70,
			iconCls : 'page_clearscreen',
			handler : function() {
				clearData();
			}
		});

function clearData() {
	Ext.getCmp("InGrNo").setValue("");
	Ext.getCmp("Vendor").setValue("");
	//Ext.getCmp("PhaLoc").setValue("");
	SetLogInDept(PhaLoc.getStore(),'PhaLoc');
	Ext.getCmp("InvNo").setValue("");
	Ext.getCmp("StartDate").setValue(DefaultStDate());
	Ext.getCmp("EndDate").setValue(DefaultEdDate());
	GrMasterInfoGrid.store.removeAll();
	GrDetailInfoGrid.store.removeAll();
	gIngrRowid="";
}

// 3�رհ�ť
var closeBT = new Ext.Toolbar.Button({
			text : '�ر�',
			tooltip : '�رս���',
			iconCls : 'page_close',
			handler : function() {
				window.close();
			}
		});
		


// ����·��
var MasterInfoUrl = DictUrl	+ 'ingdrecaction.csp?actiontype=Query';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
			url : MasterInfoUrl,
			method : "POST"
		});

// ָ���в���
var fields = ["IngrId","IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
		"PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
		"StkGrp","RpAmt","SpAmt","AcceptUser","VenId"];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "IngrId",
			fields : fields
		});
// ���ݼ�
var GrMasterInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader
		});
var nm = new Ext.grid.RowNumberer();
var GrMasterInfoCm = new Ext.grid.ColumnModel([nm, {
			header : "RowId",
			dataIndex : 'IngrId',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true//,
			//hideable : false
		}, {
			header : "��ⵥ��",
			dataIndex : 'IngrNo',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "����",
			dataIndex : 'Vendor',
			width : 200,
			align : 'left',
			sortable : true
		}, {
			header : '������',
			dataIndex : 'AcceptUser',
			width : 70,
			align : 'left',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'CreateDate',
			width : 90,
			align : 'center',
			sortable : true
		}, {
			header : '�ɹ�Ա',
			dataIndex : 'PurchUser',
			width : 70,
			align : 'left',
			sortable : true
		}, {
			header : "��ɱ�־",
			dataIndex : 'Complete',
			width : 70,
			align : 'left',
			sortable : true
		}]);
GrMasterInfoCm.defaultSortable = true;
var GridPagingToolbar = new Ext.PagingToolbar({
	store:GrMasterInfoStore,
	pageSize:PageSize,
	displayInfo:true
});
var GrMasterInfoGrid = new Ext.grid.GridPanel({
			region: 'west',
			title: '��ⵥ',
			collapsible: true,
			split: true,
			width: 225,
			minSize: 175,
			maxSize: 400,
			margins: '0 5 0 0',
			id : 'GrMasterInfoGrid',
			cm : GrMasterInfoCm,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			store : GrMasterInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			bbar:[GridPagingToolbar]
		});

// ��ӱ�񵥻����¼�
GrMasterInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, rec) {
	var InGr = GrMasterInfoStore.getAt(rowIndex).get("IngrId");
	var VenId=GrMasterInfoStore.getAt(rowIndex).get("VenId");
	var VenDesc=GrMasterInfoStore.getAt(rowIndex).get("Vendor");
	//addComboData(Ext.getCmp("Vendor").getStore(),VenId,VenDesc);
	//Ext.getCmp("Vendor").setValue(VenId);
	gIngrRowid=InGr;
	Query(InGr);
});

// ��������
var Phmnf = new Ext.ux.ComboBox({
			fieldLabel : '��������',
			id : 'Phmnf',
			store : PhManufacturerStore,
			allowBlank : true,
			triggerAction : 'all',
			emptyText : '��������...',
			selectOnFocus : false,
			forceSelection : true,
			filterName:'PHMNFName',
			params : {LocId : 'PhaLoc'}
		});

function Query(Parref){
	GrDetailInfoStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',Parref:Parref}});
}

// ����·��
var DetailInfoUrl = DictUrl
				+ 'ingdrecaction.csp?actiontype=QueryDetail';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
			url : DetailInfoUrl,
			method : "POST"
		});
// ָ���в��� 	
var fields = ["Ingri", "BatchNo", "IngrUom",{name:"ExpDate",type:'date',dateFormat:DateFormat}, "Inclb",  "Margin", "RecQty",
		"IncCode", "IncDesc","InvNo", "ManfId","Manf", "Rp", "RpAmt","Sp", "SpAmt", {name:"InvDate",type:'date',dateFormat:DateFormat},"InvMoney","SxNo"];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "Ingri",
			fields : fields
		});
// ���ݼ�
var GrDetailInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader
		});
GrDetailInfoStore.addListener('update',function(store,record,opt){
	if(record.isModified("Rp")){							
		// ����ָ���еĽ������
		var RealTotal = Number(record.get("RecQty")).mul(Number(record.get("Rp")));
		record.set("RpAmt",RealTotal);
		record.set("InvMoney",RealTotal);
	}
	
});

var nm = new Ext.grid.RowNumberer();
var GrDetailInfoCm = new Ext.grid.ColumnModel([nm, {
			header : "Ingri",
			dataIndex : 'Ingri',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true//,
			//hideable : false
		}, {
			header : '���ʴ���',
			dataIndex : 'IncCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'IncDesc',
			width : 230,
			align : 'left',
			sortable : true
		}, {
			header : "����",
			dataIndex : 'ManfId',
			width : 180,
			align : 'left',
			sortable : true,
			//editor : Phmnf,
			renderer :Ext.util.Format.comboRenderer2(Phmnf,"ManfId","Manf")	
		}, {
			header : "����",
			dataIndex : 'BatchNo',
			width : 90,
			align : 'left',
			sortable : true
		}, {
			header : "��Ч��",
			dataIndex : 'ExpDate',
			width : 100,
			align : 'left',
			sortable : true,
			renderer:Ext.util.Format.dateRenderer(DateFormat)
		}, {
			header : "��λ",
			dataIndex : 'IngrUom',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "����",
			dataIndex : 'RecQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "����",
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			sortable : true,
			editor : new Ext.form.NumberField({
				selectOnFocus : true,
				allowBlank : false,
				allowNegative:false
			})
		}, {
			header : "�ۼ�",
			dataIndex : 'Sp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : "��Ʊ��",
			dataIndex : 'InvNo',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "��Ʊ����",
			dataIndex : 'InvDate',
			width : 100,
			align : 'left',
			sortable : true,
			renderer:Ext.util.Format.dateRenderer(DateFormat)
		}, {
			header : "��Ʊ���",
			dataIndex : 'InvMoney',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "���۽��",
			dataIndex : 'RpAmt',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "�ۼ۽��",
			dataIndex : 'SpAmt',
			width : 100,
			align : 'left',
			sortable : true
		},{			
			header : "���е���",
			dataIndex : 'SxNo',
			width : 80,
			align : 'left',
			sortable : true
		}]);
GrDetailInfoCm.defaultSortable = true;
var GrDetailInfoGrid = new Ext.grid.EditorGridPanel({
			region: 'center',
			title: '��ⵥ��ϸ',
			cm : GrDetailInfoCm,
			sm : new Ext.grid.CellSelectionModel({}),
			store : GrDetailInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			clicksToEdit : 1,
			listeners:{
				afteredit:function(e){
					if(e.field=="Rp"){
						if(e.value==0){
							Msg.info("warning",	"���۲��ܵ���0!");
							e.record.set('Rp',e.originalValue);
							GrDetailInfoGrid.startEditing(e.row,e.column);
							return;
						}
						/*
						//��֤�ӳ���							
						var sp=e.record.get("Sp");
						var margin=accDiv(sp,e.value);
						
						if(margin>gParam[5] || margin<1){
							Msg.info("warning",	"�ӳ��ʳ����޶���Χ!");
							e.record.set('Rp',e.originalValue);
							GrDetailInfoGrid.startEditing(e.row,e.column);
							return;
						}*/
					}
				}
			}
		});
	var InfoForm = new Ext.ux.FormPanel({
			labelWidth: 60,	
			title : '��ⵥ���',
			id : "InfoForm",			
			tbar : [searchBT, '-', acceptBT,'-',clearBT],
			items : [{
				xtype:'fieldset',
				title:'��ѯ����',
				style:'padding:5px 0px 0px 10px',
				defaults: {border:false},    // Default config options for child items
				layout: 'column',    // Specifies that the items will now be arranged in columns
				items:[{
					columnWidth: 0.33,
	            	xtype: 'fieldset',	            	
	            	autoHeight: true,
	            	items: [PhaLoc,Vendor]					
				},{
					columnWidth: 0.33,
	            	xtype: 'fieldset',
	            	autoHeight: true,	            	
	            	items: [StartDate,EndDate]					
				},{
					columnWidth: 0.33,
	            	xtype: 'fieldset',	            
	            	items: [InGrNo,InvNo]
				}]
			}]
		});
		
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [InfoForm, GrMasterInfoGrid, GrDetailInfoGrid]			
	});
})