// /����: �������ⵥ��ѯ���޸�
// /����: �������ⵥ��ѯ���޸�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.18
		
FindIngInfo=function() {
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
		fieldLabel : $g('��ⲿ��'),
		id : 'PhaLoc',
		name : 'PhaLoc',
		width : 200,
		emptyText : $g('��ⲿ��...'),
		groupId:gGroupId
	});
	
	var fVendor=new Ext.ux.VendorComboBox({
		id : 'fVendor',
		name : 'fVendor',
		width : 200
	});
	
	// ��ⵥ��
	var InGrNo = new Ext.form.TextField({
				fieldLabel : $g('��ⵥ��'),
				id : 'InGrNo',
				name : 'InGrNo',
				anchor : '90%',
				width : 120,
				disabled : false
			});

	// ��Ʊ��
	var InvNo = new Ext.form.TextField({
				fieldLabel : $g('��Ʊ��'),
				id : 'InvNo',
				name : 'InvNo',
				anchor : '90%',
				width : 120,
				disabled : false
			});
	
	// ��ʼ����
	var StartDate= new Ext.ux.DateField({
				fieldLabel : $g('��ʼ����'),
				id : 'StartDate',
				name : 'StartDate',
				anchor : '80%',
				width : 120,
				value : DefaultStDate()
			});

	// ��������
	var EndDate= new Ext.ux.DateField({
				fieldLabel : $g('��������'),
				id : 'EndDate',
				name : 'EndDate',
				anchor : '80%',
				width : 120,
				value : DefaultEdDate()
			});

// ������ť
var searchBT = new Ext.Toolbar.Button({
			text : $g('��ѯ'),
			tooltip : $g('�����ѯ��ⵥ��Ϣ'),
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
		StartDate=StartDate.format(App_StkDateFormat);
	}else{
		Msg.info("warning",$g("��ѡ��ʼ����!"));
		return;
	}
	var EndDate = Ext.getCmp("EndDate").getValue();
	if(EndDate!=null && EndDate!=""){
		EndDate=EndDate.format(App_StkDateFormat);
	}else{
		Msg.info("warning",$g("��ѡ���ֹ����!"));
		return;
	}
	var InGrNo = Ext.getCmp("InGrNo").getValue();
	var Vendor = Ext.getCmp("fVendor").getValue();
	var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
	if(PhaLoc==""){
		Msg.info("warning", $g("��ѡ����ⲿ��!"));
		return;
	}
	var AuditFlag="Y";
	var InvNo= Ext.getCmp("InvNo").getValue();
	var ListParam=StartDate+'^'+EndDate+'^'+InGrNo+'^'+Vendor+'^'+PhaLoc+'^^^'+AuditFlag+'^'+InvNo;
	var Page=GridPagingToolbar.pageSize;
	GrMasterInfoStore.setBaseParam('ParamStr',ListParam);
	GrDetailInfoStore.removeAll();
	GrMasterInfoStore.removeAll();
	GrMasterInfoStore.load({
		params:{start:0, limit:Page},
		callback:function(r,options, success) {
			if(success==false){
     			Msg.info("error", $g("��ѯ������鿴��־!"));
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
			text : $g('����'),
			tooltip : $g('�������'),
			height:30,
			width:70,
			iconCls : 'page_save',
			handler : function() {
			
				var newVendor=Ext.getCmp("fVendor").getRawValue();
				var newVendorId=Ext.getCmp("fVendor").getValue();
				var selectRec=GrMasterInfoGrid.getSelectionModel().getSelected();
				if(selectRec==null){
					Msg.info("warning",$g("��ѡ��Ҫ�޸ĵ���ⵥ!"));
					return;
				}
				var oldVendor=selectRec.get("Vendor");
				//������ϸ
				var ret=Update();
				if(ret==0){
					Msg.info("success", $g("��ⵥ��ϸ���³ɹ�!"));
					// 7.��ʾ��ⵥ����
					Query(gIngrRowid);
				}else if((ret==-1)&(newVendor==oldVendor)){
					Msg.info("warning", $g("����û�з����仯������Ҫ����!"));
					return;
				}else if(ret!=-1){
					Msg.info("error", $g("����ĳ��ϸʧ�ܣ�")+ret);	
				}
				UpdateVendor();  //���¾�Ӫ��ҵ
			}
		});
		
	function UpdateVendor(){
		var newVendor=Ext.getCmp("fVendor").getRawValue();
		var newVendorId=Ext.getCmp("fVendor").getValue();	
		var selectRec=GrMasterInfoGrid.getSelectionModel().getSelected();
		var oldVendor=selectRec.get("Vendor");
		if(newVendor==oldVendor){
			return;
		}
		Ext.Msg.show({
			title:$g('��ʾ'),
			msg:$g('�Ƿ�ȷ���޸ľ�Ӫ��ҵ��'),
			buttons:Ext.Msg.YESNO,
			icon:Ext.Msg.QUESTION,
			fn:function(buttonId,text,opt){
				if(buttonId=="yes"){
					Ext.Ajax.request({
						url:DictUrl+ "ingdrecaction.csp?actiontype=UpdateVendor",
						method:'POST',
						params:{Ingr:gIngrRowid,Vendor:newVendorId},
						success:function(response,opt){
							var jsonData=Ext.util.JSON.decode(response.responseText);
							if(jsonData.success=='true'){
								Msg.info('success',$g("���¾�Ӫ��ҵ�ɹ�!"));
								GrMasterInfoGrid.store.reload();
								//selectRec.set("Vendor",newVendor);
							}else{
								var ret=jsonData.info;
								switch(ret){
									case '-11':
										Msg.info("warning",$g("��ⵥ������ϸ���˻��Ƶ�,�����޸ľ�Ӫ��ҵ"));
										break;
									case '-12':
										Msg.info("warning",$g("��ⵥ������ϸ�Ѹ����Ƶ�,�����޸ľ�Ӫ��ҵ"));
										break
									default:
										Msg.info('error',$g("���¾�Ӫ��ҵʧ��")+ret);
										break;
								}
							}
						
						}
					})
				}
			}
		});
	}
	/**
	 * ����������Ϣ
	 */
	function Update() {
		if(GrDetailInfoGrid.activeEditor != null){
			GrDetailInfoGrid.activeEditor.completeEdit();
		}
		var ListDetail="";
		var rowCount = GrDetailInfoGrid.getStore().getCount();
		//��ϸid^������ҵid^����^Ч��^���е���^��Ʊ��^��Ʊ����^��Ʊ���^����
		for (var i = 0; i < rowCount; i++) {
			var rowData = GrDetailInfoStore.getAt(i);	
			//���������ݷ����仯ʱִ����������
			if(rowData.data.newRecord || rowData.dirty){					
				var Ingri=rowData.get("Ingri");
				var ManfId = rowData.get("ManfId");
				var BatNo = rowData.get("BatchNo");
				var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),App_StkDateFormat);
				var SxNo = rowData.get("SxNo");
				var InvNo=rowData.get("InvNo");
				var InvDate =Ext.util.Format.date(rowData.get("InvDate"),App_StkDateFormat);
				var InvAmt=rowData.get("InvMoney");
				var Rp=rowData.get("Rp");
				//��֤�ӳ���							
				var sp=rowData.get("Sp");
				var margin=sp/Rp;
				var cnt=i+1	
				if(margin>gParam[5] || margin<1){
				//Msg.info("warning",	"��"+cnt+"�мӳ��ʳ����޶���Χ!");
				break;
						}
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
		var mask=ShowLoadMask(Ext.getBody(),$g("������..."));
		var url = DictUrl+ "ingdrecaction.csp?actiontype=UpdateRecInfo";
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{ListDetail:ListDetail},
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'false') {
					ret=jsonData.info;					
				}
				mask.hide();
			},
			scope : this
		});
		
		return ret;
	}
// ��հ�ť
var clearBT = new Ext.Toolbar.Button({
			text : $g('����'),
			tooltip : $g('�������'),
			height:30,
			width:70,
			iconCls : 'page_clearscreen',
			handler : function() {
				clearData();
			}
		});

function clearData() {
	Ext.getCmp("InGrNo").setValue("");
	Ext.getCmp("fVendor").setValue("");
	//Ext.getCmp("PhaLoc").setValue("");
	SetLogInDept(PhaLoc.getStore(),'PhaLoc');
	Ext.getCmp("InvNo").setValue("");
	Ext.getCmp("StartDate").setValue(DefaultStDate());
	Ext.getCmp("EndDate").setValue(DefaultEdDate());
	GrMasterInfoGrid.store.removeAll();
	GrDetailInfoGrid.store.removeAll();
}

// 3�رհ�ť
var closeBT = new Ext.Toolbar.Button({
			text : $g('�ر�'),
			tooltip : $g('�رս���'),
			iconCls : 'page_close',
			handler : function() {
				window.close();
			}
		});
		
var cancelBT=new Ext.Toolbar.Button({
	text : $g('ȡ�����'),
	tooltip : $g('���ȡ�����'),
	height:30,
	width:70,
	iconCls : 'page_gear',
	handler : function() {
		CancelAudit();
	}
});

function CancelAudit(){
	if(gIngrRowid==""){
		Msg.info("warning", $g("��ѡ����Ҫȡ����˵���ⵥ!"));
		return;
	}
	
	var mask=ShowLoadMask(Ext.getBody(),$g("������..."));
	var url = DictUrl+ "ingdrecaction.csp?actiontype=CancelAudit";
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		params:{Ingr:gIngrRowid},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// ˢ�½���
				Msg.info("success", $g("ȡ����˳ɹ�!"));
				searchDurgData();
			} else {
				var ret=jsonData.info;
				if(ret==-7){
					Msg.info("error",$g("����ⵥ�ѷ������ת��ҵ��!"));
				}else if(ret==-8){
					Msg.info("error", $g("����ⵥ����ϸ���˻��Ƶ�!"));
				}else if(ret==-9){
					Msg.info("error", $g("����ⵥ�Ѿ����ɸ��"));
				}else{	
					Msg.info("error", $g("ȡ�����ʧ�ܣ�")+ret);
				}							
			}
			mask.hide();
		},
		scope : this
	});
}

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
		"StkGrp","RpAmt","SpAmt","AcceptUser","VenId","InvNoflag"];
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
			hidden : true,
			hideable : false
		}, {
			header : $g("��ⵥ��"),
			dataIndex : 'IngrNo',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : $g("��Ӫ��ҵ"),
			dataIndex : 'Vendor',
			width : 200,
			align : 'left',
			sortable : true
		}, {
			header : $g('������'),
			dataIndex : 'AcceptUser',
			width : 70,
			align : 'left',
			sortable : true
		}, {
			header : $g('��������'),
			dataIndex : 'CreateDate',
			width : 90,
			align : 'center',
			sortable : true
		}, {
			header : $g('�ɹ�Ա'),
			dataIndex : 'PurchUser',
			width : 70,
			align : 'left',
			sortable : true
		}, {
			header : $g("��ɱ�־"),
			dataIndex : 'Complete',
			width : 70,
			align : 'left',
			sortable : true
		}, {
			header : $g('�Ƿ��л���Ʊδ��'),
			dataIndex : 'InvNoflag',
			width : 70,
			align : 'left',
			sortable : true,
			hidden : true
		}]);
GrMasterInfoCm.defaultSortable = true;
var GridPagingToolbar = new Ext.PagingToolbar({
	store:GrMasterInfoStore,
	pageSize:PageSize,
	displayInfo:true,
	displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
	emptyMsg:$g("û�м�¼")
});
var GrMasterInfoGrid = new Ext.grid.GridPanel({
			id : 'GrMasterInfoGrid',
			title : '',
			height : 170,
			cm : GrMasterInfoCm,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			store : GrMasterInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			//-----------------------------add by myq 20140425
		
		   
			//-----------------------------add by myq 20140425
			bbar:[GridPagingToolbar]
		});

// ��ӱ�񵥻����¼�
GrMasterInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, rec) {
	var InGr = GrMasterInfoStore.getAt(rowIndex).get("IngrId");
	var VenId=GrMasterInfoStore.getAt(rowIndex).get("VenId");
	var VenDesc=GrMasterInfoStore.getAt(rowIndex).get("Vendor");
	addComboData(Ext.getCmp("fVendor").getStore(),VenId,VenDesc);
	Ext.getCmp("fVendor").setValue(VenId);
	gIngrRowid=InGr;
	Query(InGr);
	
});

// ������ҵ
var Phmnf = new Ext.form.ComboBox({
			fieldLabel : $g('������ҵ'),
			id : 'Phmnf',
			name : 'Phmnf',
			anchor : '90%',
			width : 100,
			store : PhManufacturerStore,
			valueField : 'RowId',
			displayField : 'Description',
			//allowBlank : false,
			triggerAction : 'all',
			emptyText : $g('������ҵ...'),
			selectOnFocus : false,
			forceSelection : true,
			//editable:true,
			minChars : 3,
			typeAhead:true,
			pageSize : 20,
			listWidth : 250,
			valueNotFoundText : '',
			listeners : {
				'beforequery' : function(e) {
					var filter=Ext.getCmp('Phmnf').getRawValue();
					PhManufacturerStore.load({params : {start : 0,limit : 20,PHMNFName:filter}});	
					e.cancel=true;
				}
			}
		});

function Query(Parref){
	GrDetailInfoStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',Parref:Parref}});
}

// ����·��
var DetailInfoUrl = DictUrl
				+ 'ingdrecaction.csp?actiontype=QueryIngrDetail';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
			url : DetailInfoUrl,
			method : "POST"
		});
// ָ���в��� 	
var fields = ["Ingri", "BatchNo", "IngrUom",{name:"ExpDate",type:'date',dateFormat:App_StkDateFormat}, "Inclb",  "Margin", "RecQty",
		"IncCode", "IncDesc","InvNo", "ManfId","Manf", "Rp", "RpAmt","Sp", "SpAmt", {name:"InvDate",type:'date',dateFormat:App_StkDateFormat},"InvMoney","SxNo","Spec"];
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
	}
	
});

//����Ʊδ�����
GrDetailInfoStore.addListener('load',function(store,record,opt){
    var RowIndex=store.getCount();
    for(var i=0;i<RowIndex;i++){
       var invno=store.getAt(i).get("InvNo");
       if(invno==""){
          GrDetailInfoGrid.getView().getRow(i).style.backgroundColor = "#FF1493";
       }
    }
});

var nm = new Ext.grid.RowNumberer();
var GrDetailInfoCm = new Ext.grid.ColumnModel([nm, {
			header : "Ingri",
			dataIndex : 'Ingri',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true,
			hideable : false
		}, {
			header : $g('ҩƷ����'),
			dataIndex : 'IncCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : $g('ҩƷ����'),
			dataIndex : 'IncDesc',
			width : 230,
			align : 'left',
			sortable : true
		}, {
			header : $g("������ҵ"),
			dataIndex : 'ManfId',
			width : 180,
			align : 'left',
			sortable : true,
			editor : Phmnf,
			renderer :Ext.util.Format.comboRenderer2(Phmnf,"ManfId","Manf")	
		}, {
			header : $g("����"),
			dataIndex : 'BatchNo',
			width : 90,
			align : 'left',
			sortable : true,
			editor:new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					change : function(field, newValue,oldValue) {
						
							var cell = GrDetailInfoGrid.getSelectionModel().getSelectedCell();
							var colIndex=GetColIndex(GrDetailInfoGrid,"BatchNo");
							if (newValue == null || newValue.length <= 0) {
								Msg.info("warning", $g("���Ų���Ϊ��!"));
								field.setValue("");
								//GrDetailInfoGrid.startEditing(cell[0], colIndex);
								return;
							}	
							//GrDetailInfoGrid.startEditing(cell[0], colIndex);
						
					}
				}
			})
		}, {
			header : $g("��Ч��"),
			dataIndex : 'ExpDate',
			width : 100,
			align : 'left',
			sortable : true,
			renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
			editor:new Ext.ux.DateField({
				format:App_StkDateFormat,
				listeners:{
					change:function(field,newValue,oldValue){
						var cell = GrDetailInfoGrid.getSelectionModel().getSelectedCell();
						var col=GetColIndex(GrDetailInfoGrid,'ExpDate');
						var expDate = newValue.format('Y-m-d');
						var flag=ExpDateValidator(expDate);		
						
					    if(flag==false){
					    	Msg.info('Warning',$g('Ч�ڲ���,����ʧЧ�ڲ�������')+gParam[2]+'��!');	
					    	field.setValue('');
					    	GrDetailInfoGrid.startEditing(cell[0], col);
					    	return;
					    }
						
						//GrDetailInfoGrid.startEditing(cell[0]+1, col);
					}				
				}
			})
		}, {
			header : $g("��λ"),
			dataIndex : 'IngrUom',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : $g("����"),
			dataIndex : 'RecQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : $g("����"),
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
			header : $g("�ۼ�"),
			dataIndex : 'Sp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : $g("��Ʊ��"),
			dataIndex : 'InvNo',
			width : 80,
			align : 'left',
			sortable : true,
			editor:new Ext.form.TextField({
				selectOnFocus:true,
				listeners:{
					change:function(field,newValue,oldValue){
						var cell = GrDetailInfoGrid.getSelectionModel().getSelectedCell();
						var col=GetColIndex(GrDetailInfoGrid,"InvNo");
						
						var flag=InvNoValidator(newValue,gIngrRowid);					
						if(flag==false){
							Msg.info("Warning",$g("�÷�Ʊ���Ѵ����ڱ����ⵥ"));
							field.setValue('');					
							GrDetailInfoGrid.startEditing(cell[0], col);
							return;
						}	
						var lastRowIndex=GrDetailInfoGrid.getStore().getCount()-1;
						if(cell[0]<lastRowIndex){
							GrDetailInfoGrid.getSelectionModel().select(cell[0]+1, col);
							GrDetailInfoGrid.startEditing(cell[0]+1, col);	
						}
					}
				}
			
			})
		}, {
			header : $g("��Ʊ����"),
			dataIndex : 'InvDate',
			width : 100,
			align : 'left',
			sortable : true,
			renderer:Ext.util.Format.dateRenderer(App_StkDateFormat),
			editor:new Ext.ux.DateField({
				format:App_StkDateFormat,
				listeners:{
					specialkey:function(field,e){
						if(e.getKey() == Ext.EventObject.ENTER){
							var cell = GrDetailInfoGrid.getSelectionModel().getSelectedCell();
							var col=GetColIndex(GrDetailInfoGrid,"InvDate");
							GrDetailInfoGrid.startEditing(cell[0]+1, col);	
						}
					}				
				}
			})
		}, {
			header : $g("��Ʊ���"),
			dataIndex : 'InvMoney',
			width : 100,
			align : 'left',
			sortable : true,
			editor:new Ext.form.NumberField({
			
			})
		}, {
			header : $g("���۽��"),
			dataIndex : 'RpAmt',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : $g("�ۼ۽��"),
			dataIndex : 'SpAmt',
			width : 100,
			align : 'left',
			sortable : true
		},{			
			header : $g("���е���"),
			dataIndex : 'SxNo',
			width : 80,
			align : 'left',
			sortable : true,
			editor:new Ext.form.TextField({
				selectOnFocus:true,
				listeners:{
					specialkey:function(field,e){
						if(e.getKey() == Ext.EventObject.ENTER){
							var cell = GrDetailInfoGrid.getSelectionModel().getSelectedCell();
							var col=GetColIndex(GrDetailInfoGrid,"SxNo");
							GrDetailInfoGrid.startEditing(cell[0]+1, col);	
						}
					}				
				}
			})
		}, {
			header : $g("���"),
			dataIndex : 'Spec',
			width : 100,
			align : 'left',
			sortable : true
		}]);
GrDetailInfoCm.defaultSortable = true;
var GrDetailInfoGrid = new Ext.grid.EditorGridPanel({
			title : '',
			height : 170,
			cm : GrDetailInfoCm,
			sm : new Ext.grid.CellSelectionModel({}),
			store : GrDetailInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			clicksToEdit : 1,
			listeners:{
				'beforeedit':function(e){
					if(e.field=="ManfId"){
						var store=Ext.getCmp('Phmnf').getStore();
						addComboData(store,e.record.get('ManfId'),e.record.get('Manf'));
					}
				},
				afteredit:function(e){
					if(e.field=="Rp"){
						if(e.value==0){
							Msg.info("warning",	$g("���۲��ܵ���0!"));
							e.record.set('Rp',e.originalValue);
							GrDetailInfoGrid.startEditing(e.row,e.column);
							return;
						}
						//��֤�ӳ���							
						var sp=e.record.get("Sp");
						var margin=sp/e.value;
						
						if(margin>gParam[5] || margin<1){
							Msg.info("warning",	$g("�ӳ��ʳ����޶���Χ!"));
							e.record.set('Rp',e.originalValue);
							GrDetailInfoGrid.startEditing(e.row,e.column);
							return;
						}
					}
				}
			}
		});

	var InfoForm= new Ext.form.FormPanel({
			frame : true,
			labelWidth: 60,	
			labelAlign : 'right',
			id : "InfoForm",			
			tbar : [searchBT,'-',clearBT],
			items : [{
				xtype:'fieldset',
				title:$g('��ѯ����'),
				style:DHCSTFormStyle.FrmPaddingV,
				defaults: {border:false},    // Default config options for child items
				layout: 'column',    // Specifies that the items will now be arranged in columns
				items:[{ 				
					columnWidth: 0.33,
	            	xtype: 'fieldset',	            	
	            	autoHeight: true,
	            	items: [PhaLoc,fVendor]					
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
	var findWin = new Ext.Window({
			layout : 'border',
			height:document.body.clientHeight*0.9,	
			width:document.body.clientWidth*0.9,
			minWidth:document.body.clientWidth*0.5,	
			minHeight:document.body.clientHeight*0.5,
			title : $g('������ⵥ�˻�'),
		    plain:true,
		    modal:true,
			items : [            // create instance immediately
	            {
	                region: 'north',
	                height: DHCSTFormStyle.FrmHeight(1), // give north and south regions a height
	                layout: 'fit', // specify layout manager for items
	                items:InfoForm
	            }, {
	                region: 'west',
	                title: $g('��ⵥ')+'--<font color=blue>'+$g('���ɫ�������ⵥ����Ʊδ��')+'</font>',
	                collapsible: true,
	                split: true,
	                width: document.body.clientWidth*0.8*0.3,
	                minSize: document.body.clientWidth*0.8*0.1,
	                maxSize: document.body.clientWidth*0.8*0.8,
	                margins: '0 5 0 0',
	                layout: 'fit', // specify layout manager for items
	                items: GrMasterInfoGrid       
	               
	            }, {
	                region: 'center',
	                title: $g('��ⵥ��ϸ'),
	                layout: 'fit', // specify layout manager for items
	                items: GrDetailInfoGrid       
	               
	            }
   			]			
	});
	//��ʾ����
	findWin.show();
	GrMasterInfoGrid.on('rowdblclick',function(grid,rowIndex,e){
		var IngrId=GrMasterInfoStore.data.items[rowIndex].data["IngrId"];
		//alert(IngrId)
		SelectRec(IngrId);
		IngDretDetailGridDs.load({params:{start:0,limit:999,sort:'ingri',dir:'desc',ret:IngrId,type:'G'}});
		findWin.close();
	});
	RefreshGridColSet(GrMasterInfoGrid,"DHCSTIMPORT");   //�����Զ�������������������
	RefreshGridColSet(GrDetailInfoGrid,"DHCSTIMPORT");   //�����Զ�������������������


} 