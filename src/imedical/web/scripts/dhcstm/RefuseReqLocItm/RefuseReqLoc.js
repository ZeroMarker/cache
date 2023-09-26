// ����:������ҽ�ֹ��������
// ��д����:2014-03-07
// ����:taosongrui

var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var RefuseReqLocGridUrl="dhcstm.refusereqlocaction.csp"
var gItmdr="";
var gInciCode="";

// ҩƷ����
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
	id : 'StkGrpType',
	name : 'StkGrpType',
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:gLocId,
	UserId:gUserId,
	anchor:'70%'
});
var ToLoc = new Ext.ux.LocComboBox({
	id:'ToLoc',
	name:'ToLoc',
	fieldLabel:'�������',
	allowBlank:true,
	emptyText:'�������...',
	anchor:'90%',
	defaultLoc:''
});
var M_InciDesc = new Ext.form.TextField({
	fieldLabel : '��������',
	id : 'M_InciDesc',
	name : 'M_InciDesc',
	anchor : '90%',
	listeners : {
	specialkey : function(field, e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
			var stktype = Ext.getCmp("StkGrpType").getValue();
			GetPhaOrderInfo(field.getValue(), stktype);
			}
		}
	}
});
var AuditedCK = new Ext.form.Checkbox({
	id: 'AuditedCK',
	hideLabel : true,
	boxLabel : '������ά��',
	anchor:'90%',
	allowBlank:true
});
//����ҩƷ���岢���ؽ��
function GetPhaOrderInfo(item, group) {
	if (item != null && item.length > 0) {
	    GetPhaOrderWindow(item, group,App_StkTypeCode, "", "", "0", "",
						getDrugList);
		}
}
// ���ط���
function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	gItmdr=record.get("InciDr");
	gInciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	Ext.getCmp("M_InciDesc").setValue(inciDesc);
}
function GetPhaOrderInfo1(item, group) {
	if (item != null && item.length > 0) {
	    GetPhaOrderWindow(item, group,App_StkTypeCode, "", "N", "0", "",
						getDrugList1);
		}
} 
function getDrugList1(record) {
	if (record == null || record == "") {
		return;
	}
	var inciDr=record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	var ReqLoc=Ext.getCmp("ToLoc").getValue();
	var cell = RefuseReqLocGrid.getSelectionModel().getSelectedCell();
	var row = cell[0];
	var rowData = RefuseReqLocGrid.getStore().getAt(row);
	rowData.set("IncId",inciDr);
	rowData.set("InciCode",inciCode);
	rowData.set("MDesc",inciDesc);
	rowData.set("FrLoc",gLocId);
	rowData.set("ReqLoc",ReqLoc);
	
//���������ʼ����
	var colIndex=GetColIndex(RefuseReqLocGrid,'StartDate');
	RefuseReqLocGrid.startEditing(row, colIndex);
}
 
//=====================================
// ��Ӧ����
var Frloc = new Ext.ux.LocComboBox({
	fieldLabel : '��Ӧ����',
	id : 'Frloc',
	name : 'Frloc',
	anchor : '90%'
});
var ReqLoc = new Ext.ux.LocComboBox({
	fieldLabel : '�������',
	id : 'ReqLoc',
	name : 'ReqLoc',
	anchor : '90%',
	listeners:{
		'select':function(cb){
			var cell = RefuseReqLocGrid.getSelectionModel().getSelectedCell();
							var row = cell[0];
							var rowData = RefuseReqLocGrid.getStore().getAt(row);
							var M_InciDesc=	Ext.getCmp("M_InciDesc").getValue();
							rowData.set("MDesc",M_InciDesc);
							rowData.set("IncId",gItmdr);
							rowData.set("InciCode",gInciCode);
							rowData.set("FrLoc",gLocId);
			}
		}
});

var findAPCVendor = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		Query()
	}
});

var addAPCVendor = new Ext.Toolbar.Button({
    text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
    width : 70,
    height : 30,
    handler:function(){
	    var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
	 	if(Audited=="Y"){
		    var ReqLoc=	Ext.getCmp("ToLoc").getValue();
				if (ReqLoc==""){
					Msg.info("warning","������Ҳ���Ϊ��!");
					return;
				}
			var rowCount = RefuseReqLocGrid.getStore().getCount();
			if(rowCount>0){
				var rowData = RefuseReqLocGridDs.data.items[rowCount - 1];
				var data=rowData.get("MDesc")
				if(data=="" || data.length<=0){
					Msg.info("warning","�Ѵ����½���");
					RefuseReqLocGrid.startEditing(RefuseReqLocGridDs.getCount()-1,4)
					return;
				}
			}
			RefuseReqLocGrid.store.removeAll();
       		addNewRow();
	 	}
	 	else{
		 	var M_InciDesc = Ext.getCmp("M_InciDesc").getValue();
				if (M_InciDesc==""){
					Msg.info("warning","�������Ʋ���Ϊ��!");
					return;
				}
				else{
					if(gItmdr==""){
						Msg.info("warning","���������Ʋ�����!");
              			return;
					}
					var rowCount =RefuseReqLocGrid.getStore().getCount();
					if(rowCount>0){
						var rowData = RefuseReqLocGridDs.data.items[rowCount - 1];
						var data=rowData.get("ReqLoc")
						if(data=="" || data.length<=0){
							Msg.info("warning","�Ѵ����½���");
							RefuseReqLocGrid.startEditing(RefuseReqLocGridDs.getCount()-1,6)
							return;
						}
					}
					RefuseReqLocGrid.store.removeAll();
        			addNewRow();
				}
	 	}	 	
    }
});
var SaveBT = new Ext.Toolbar.Button({
	id : "SaveBT",
	text : '����',
	tooltip : '�������',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		saveOrder();}
});
//ɾ����ť
var deleteMarkType = new Ext.Toolbar.Button({
    text:'ɾ��',
    tooltip:'ɾ��',
    iconCls:'page_delete',
    width : 70,
    height : 30,
    handler:function(){
	    deleteDetail(); }
})				
			

//ģ��
var nm = new Ext.grid.RowNumberer();
var RefuseReqLocGridCm = new Ext.grid.ColumnModel([nm,{
        header : "RowId",
		dataIndex : 'RowId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
		},{
		header : "IncRowid",
		dataIndex : 'IncId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
		},{
		header : "���ʴ���",
		dataIndex : 'InciCode',
		width : 80,
		align : 'left',
		sortable : true
		},{
        header:"��������",
        dataIndex:'MDesc',
        width:120,
        align:'left',
        sortable:true,
        editor :new Ext.grid.GridEditor(new Ext.form.TextField({
								selectOnFocus : true,
								allowBlank : false,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											var ReqLoc=	Ext.getCmp("ToLoc").getValue();
											if (ReqLoc==""){
												Msg.info("warning","������Ҳ���Ϊ��!");
												return;
											}
											var group = Ext.getCmp("StkGrpType").getValue();
											GetPhaOrderInfo1(field.getValue(),group);
											
										}
									   
									}
								}
							}))
							
    },{
	    header:"��Ӧ����",
        dataIndex:'FrLoc',
        width:250,
        align:'left',
        sortable:true,
        editable:false,
        renderer :Ext.util.Format.comboRenderer2(Frloc,"FrLoc","FrLocDesc")
	 },{
        header:"�������",
        dataIndex:'ReqLoc',
        width:250,
        align:'left',
        sortable:true,
		renderer :Ext.util.Format.comboRenderer2(ReqLoc,"ReqLoc","ReqLocDesc"),
		editor:new Ext.grid.GridEditor(ReqLoc,new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var M_InciDesc=	Ext.getCmp("M_InciDesc").getValue();
							if (M_InciDesc==""){
								Msg.info("warning","���ʲ���Ϊ��!");
								return;
							}																	
							var cell = RefuseReqLocGrid.getSelectionModel().getSelectedCell();
							//var row = cell[0];
							//var rowData = RefuseReqLocGrid.getStore().getAt(row);
							//rowData.set("MDesc",M_InciDesc);
							//rowData.set("IncId",gItmdr);
							//rowData.set("InciCode",gInciCode);
							//rowData.set("FrLoc",gLocId);
							//var record = RefuseReqLocGrid.getStore().getAt(cell[0]);
							var colIndex=GetColIndex(RefuseReqLocGrid,'StartDate');
			        		RefuseReqLocGrid.startEditing(cell[0], colIndex);
							}
						}
					}
		}))
    },{
        header:"��ʼ����",
        dataIndex:'StartDate',
        width:200,
        align:'center',
        sortable:true,
        renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor : new Ext.ux.DateField({
				selectOnFocus : true,
				allowBlank : true,
				
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = RefuseReqLocGrid.getSelectionModel().getSelectedCell();
							var record = RefuseReqLocGrid.getStore().getAt(cell[0]);
							var colIndex=GetColIndex(RefuseReqLocGrid,'EndDate');
			                RefuseReqLocGrid.startEditing(cell[0], colIndex);
						}
					}
			   }
		})
    },{
        header:"��ֹ����",
        dataIndex:'EndDate',
        width:200,
        align:'center',
        sortable:true,
         renderer : Ext.util.Format.dateRenderer(DateFormat),
					editor : new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : true,
						
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cell = RefuseReqLocGrid.getSelectionModel().getSelectedCell();
									var record = RefuseReqLocGrid.getStore().getAt(cell[0]);
									var SDate=record.get("StartDate")//.format(ARG_DATEFORMAT)
									var EDate=field.getValue()//.format(ARG_DATEFORMAT);
									if((SDate!="")&(EDate!="")){
										if (EDate.format(ARG_DATEFORMAT) <SDate.format(ARG_DATEFORMAT)) {
										Msg.info("warning", "��ֹ���ڲ���С�ڿ�ʼ����!");
										return;
									}}
									var colIndex=GetColIndex(RefuseReqLocGrid,'Remark');
			                        RefuseReqLocGrid.startEditing(cell[0], colIndex);
								}
							}
						}
					})
    },{
		  header:'��ע',
	    dataIndex:'Remark',
	    width:150,
	    align:'left',
	    sortable:true,
	    editor : new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
								addNewRow()
								}
							}
		}})   
	 }
]);

//��ʼ��Ĭ��������
RefuseReqLocGridCm.defaultSortable = true;

function addNewRow() {
	var record = Ext.data.Record.create([
      {
            name : 'RowId',
            type : 'int'
        },{
            name : 'IncId',
            type : 'string'
        },{
            name : 'InciCode',
            type : 'string'
        },{
            name : 'MDesc',
            type : 'string'
        },{
	        name : 'FrLoc',
	        type : 'string'
	    },{
            name : 'ReqLoc',
            type : 'string'
        }, {
            name : 'StartDate',
            type : 'date'
        }, {
            name : 'EndDate',
            type : 'date'
        }, {
            name : 'Remark',
            type : 'string'
        }
    ]);
    var NewRecord = new record({
	    RowId:'',
	    IncId:'',
	    InciCode:'',
        MDesc:'',
        FrLoc:'',
        ReqLoc:'',
        StartDate:'',
        EndDate:'',
        Remark:''
    });
    RefuseReqLocGridDs.add(NewRecord);
    var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
	 	if(Audited=="Y"){
		    RefuseReqLocGrid.startEditing(RefuseReqLocGridDs.getCount() - 1,4);
	 	}
	 	else{
			RefuseReqLocGrid.startEditing(RefuseReqLocGridDs.getCount() - 1, 6);
	 	}
    }

// ����·��
var DetailUrl =RefuseReqLocGridUrl+
	'?actiontype=Query&ReqLoc=&IncId=&start=0&limit=RefuseReqLocPagingToolbar.pageSize';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
			url : DetailUrl,
			method : "POST"
	});
		
// ָ���в���
var fields = ["RowId", "IncId", "InciCode", "MDesc","FrLoc","FrLocDesc","ReqLoc","ReqLocDesc",{name:'StartDate',type:'date',dateFormat:DateFormat},
	{name:'EndDate',type:'date',dateFormat:DateFormat},"Remark"];
		
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "RowId",
		fields : fields
});
// ���ݼ�
var RefuseReqLocGridDs = new Ext.data.Store({
		proxy : proxy,
		reader : reader,
		listeners:{
		'load':function(ds){
		 }
	}
});	 
			
//����������ҽ�ֹ��������
function saveOrder(){
	var ListDetail="";
	var rowCount = RefuseReqLocGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		var rowData = RefuseReqLocGridDs.getAt(i);
		//���������ݷ����仯ʱִ����������
		if(rowData.data.newRecord || rowData.dirty){
			var RowId=rowData.get("RowId"); 
			var IncId=rowData.get("IncId");
			var FrLoc=rowData.get("FrLoc");
			var ReqLoc=rowData.get("ReqLoc");
			var StartDate =Ext.util.Format.date(rowData.get("StartDate"),ARG_DATEFORMAT);
			var EndDate =Ext.util.Format.date(rowData.get("EndDate"),ARG_DATEFORMAT);
			if((StartDate!="")&(EndDate!="")){
				if (EndDate<StartDate) {
					Msg.info("warning", "��ֹ���ڲ���С�ڿ�ʼ����,����ʧ��!");
					return;
				}
			}
			var Remark=rowData.get("Remark");    
 			var str= ReqLoc + "^" + IncId+"^"+FrLoc+"^"+StartDate+"^"+EndDate+"^"+ Remark +"^"+RowId
			if(ListDetail==""){
				ListDetail=str;
			}else{
				ListDetail=ListDetail+","+str;
			}
		}
	}
	                   
	if(ListDetail==""){
		Msg.info("error","û���޸Ļ����������!");
		return false;
	}else{
		var url = RefuseReqLocGridUrl+"?actiontype=Save";
		var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{ListDetail:ListDetail},
			waitMsg : '������...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
							.decode(result.responseText);
				mask.hide();		
				if (jsonData.success == 'true') {
					var IngrRowid = jsonData.info;
					Msg.info("success", "����ɹ�!");
					Query();
				}else{
					var ret=jsonData.info;
					if (ret=-10){
						Msg.info("warning","�����ʵĸ���������Ѿ�ά��");
						return;
					}else{
						Msg.info("error", "���治�ɹ���"+ret);
					}
				}
			},
			scope : this
		});
	}
}
           
//��ѯ����
function Query()
{
	var ReqLoc=Ext.getCmp("ToLoc").getValue();
	var InciDesc=Ext.getCmp("M_InciDesc").getValue();
	var Stkcat=Ext.getCmp("StkGrpType").getValue();
	if(InciDesc==null||InciDesc==""){
		gItmdr="";
	}
    RefuseReqLocGridDs.removeAll();
	RefuseReqLocGridDs.load({
		params:{start:0,limit:RefuseReqLocPagingToolbar.pageSize,ReqLoc:ReqLoc,IncId:gItmdr,Stkcat:Stkcat},
		callback:function(r,options,success){
			if(success==false){
				Msg.info("error","��ѯ����, ��鿴��־!");
			}
		}
	});
}
function deleteDetail()
{
	var cell = RefuseReqLocGrid.getSelectionModel().getSelectedCell();
        if(cell==null){
                Msg.info("error","��ѡ������!");
               return false;}
         else{ var record = RefuseReqLocGrid.getStore().getAt(cell[0]);
               var RowId = record.get("RowId");
               if (RowId!=""){
	               Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ��ѡ������?',
	               function(btn){
		               if(btn=="yes"){
			               var url = RefuseReqLocGridUrl+"?actiontype=Delete&rowid="+RowId;
			               var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			               Ext.Ajax.request({
				              url:url,
				               waitMsg:'ɾ����...',
                                failure: function(result, request) {
                                    Msg.info("error","������������!");
                                     mask.hide();
                                },
                                success: function(result, request) {
                                    var jsonData = Ext.util.JSON.decode( result.responseText );
                                     mask.hide();
                                     if (jsonData.success=='true') {
                                        Msg.info("success","ɾ���ɹ�!");
                                        Query()
                                      }
                                      else{
                                        Msg.info("error","ɾ��ʧ��!");
                                    }
                                },
                                scope: this
				               });
				               
				               }
			               
			               })
	  }else{ var rowInd=cell[0];      
                if (rowInd>=0) RefuseReqLocGrid.getStore().removeAt(rowInd);  }
          
 
          
            }   
	
	}


//�½�����
            
var formPanel = new Ext.ux.FormPanel({
	title:'���ҽ�ֹ��������ά��',
    tbar:[findAPCVendor,'-',addAPCVendor,'-',SaveBT,'-',deleteMarkType],
	items : [{
		xtype : 'fieldset',
		title : '��ѯ����',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,xtype:'fieldset'},
		items : [{
				columnWidth : 0.3,
				items : [StkGrpType]
			},{
				columnWidth : 0.3,
				items : [M_InciDesc]
			},{
				columnWidth : 0.25,
				items : [ToLoc]
			}, {
				columnWidth : 0.15,
				items : [AuditedCK]
			}]
	}]

});

//��ҳ������
var RefuseReqLocPagingToolbar = new Ext.PagingToolbar({
    store:RefuseReqLocGridDs,
	pageSize:19,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼",
     doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		
		var ReqLoc=Ext.getCmp("ToLoc").getValue();
	    var InciDesc=Ext.getCmp("M_InciDesc").getValue();
	    var ReqLoc=Ext.getCmp("ToLoc").getValue();
	    var InciDesc=Ext.getCmp("M_InciDesc").getValue();
	    var Stkcat=Ext.getCmp("StkGrpType").getValue();
	    if(InciDesc==null||InciDesc==""){
		      gItmdr="";
	    }
	    B['ReqLoc']=ReqLoc
	    B['IncId']=gItmdr
	    B['Stkcat']=Stkcat

		var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
	 	if(Audited=="Y"){
        	B['Parref']=Ext.getCmp("ToLoc").getValue();
	 	}
	 	else{
		 	B['Parref']=Ext.getCmp("M_InciDesc").getValue();
	 	}
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}

});

//���
RefuseReqLocGrid = new Ext.grid.EditorGridPanel({
	store:RefuseReqLocGridDs,
	cm:RefuseReqLocGridCm,
	title:'��ֹ����������ϸ',
	trackMouseOver:true,
	clicksToEdit:0,
	region:'center',
	height:690,
	stripeRows:true,
    sm:new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:RefuseReqLocPagingToolbar
});
//=========================��Ӧ�����=============================



	
//===========ģ����ҳ��===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,RefuseReqLocGrid],
		renderTo:'mainPanel'
	});
});
	
//===========ģ����ҳ��===========================================