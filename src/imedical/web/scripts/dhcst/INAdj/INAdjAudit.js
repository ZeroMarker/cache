// ����:�����������
// ��д����:2012-08-28
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
//var arr = window.status.split(":");
//var length = arr.length;
var mainRowId = "";
//����
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	name:'locField',
	fieldLabel:'����',
	anchor:'90%',
	groupId:gGroupId
	});

//=========================��汨�����=============================
var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	//width:100,
	listWidth:100,
    allowBlank:false,
	fieldLabel:'��ʼ����',
	value:new Date(),
	anchor:'90%'
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	width:100,
	listWidth:100,
    allowBlank:false,
	fieldLabel:'��������',
	value:new Date(),
	anchor:'90%'
});

var AuditedCK = new Ext.form.Checkbox({
	id: 'AuditedCK',
	boxLabel:'�����',
	anchor:'90%',
	allowBlank:true
});
var CancelAuditBT = new Ext.Toolbar.Button({
			id:'CancelAuditBT',
			text : 'ȡ�����',
			tooltip : '���ȡ�����������ȷ��',
			width : 70,
			height : 30,
			//disabled:true,
			iconCls : 'page_gear',
			handler : function() {
				CancelAudit();
			}
		});
//====================================================
//var InadjAuditGrid="";
//��������Դ
var InadjAuditGridUrl = 'dhcst.inadjaction.csp';
var InadjAuditGridProxy= new Ext.data.HttpProxy({url:InadjAuditGridUrl+'?actiontype=query',method:'GET'});
var InadjAuditGridDs = new Ext.data.Store({
	proxy:InadjAuditGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'adj'},
		{name:'no'},
		{name:'loc'},
		{name:'locDesc'},
		{name:'date'},
		{name:'time'},
		{name:'user'},
		{name:'userName'},
		{name:'chkDate'},
		{name:'chkTime'},
		{name:'chkUser'},
		{name:'chkUserName'},
		{name:'scg'},
		{name:'scgDesc'},
		{name:'comp'},
		{name:'state'},
		{name:'chkFlag'},
		{name:'stkType'},
		{name:'spAmt'},
		{name:'rpAmt'},
		{name:'adjReason'},
		{name:'adjRemark'}
	]),
    remoteSort:false,
	listeners:{
		'beforeload':function(ds)
	    {
			var startDate = Ext.getCmp('startDateField').getValue().format(App_StkDateFormat);
			var endDate = Ext.getCmp('endDateField').getValue().format(App_StkDateFormat);
			var locId = Ext.getCmp('locField').getValue();
		
	    	var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
			var completedFlag="Y"  //Ҫ�����Ѿ���ɵ�
			var strPar = startDate+"^"+endDate+"^"+locId+"^"+Audited+"^"+completedFlag;

			ds.baseParams={start:0,limit:InadjAuditPagingToolbar.pageSize,sort:'NO',dir:'desc',strParam:strPar};
	    },
	    'load':function(ds)
	    {
	    	if (ds.getCount()>0){
	    		InadjAuditGrid.getSelectionModel().selectFirstRow();
	    		InadjAuditGrid.getView().focusRow(0);
	    	}
	    }
	 }
    
});

//ģ��
var InadjAuditGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
        header:"rowid",
        dataIndex:'adj',
        width:100,
        align:'left',
        sortable:true,
        hidden:true
    },
	 {
        header:"��������",
        dataIndex:'no',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"��������",
        dataIndex:'locDesc',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"�Ƶ���",
        dataIndex:'userName',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�Ƶ�����",
        dataIndex:'date',
        width:100,
        align:'center',
        sortable:true
    },{
        header:"�Ƶ�ʱ��",
        dataIndex:'time',
        width:100,
        align:'center',
        sortable:true
    },{
        header:"���",
        dataIndex:'comp',
        width:60,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:"���",
        dataIndex:'chkFlag',
        width:60,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    }/*,{
        header:"�����rowid",
        dataIndex:'chkUser',
        width:100,
        align:'left',
        sortable:true
    }*/,{
        header:"�����",
        dataIndex:'chkUserName',
        width:100,
        align:'center',
        sortable:true
    },{
        header:"�������",
        dataIndex:'chkDate',
        width:100,
        align:'center',
        sortable:true
    },{
        header:"���ʱ��",
        dataIndex:'chkTime',
        width:100,
        align:'center',
        sortable:true
    },{
        header:"���۽��",
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    },{
        header:"�ۼ۽��",
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridSpAmount
    },{
        header:"����ԭ��",
        dataIndex:'adjReason',
        width:100,
        align:'left'
    },{
        header:"��ע",
        dataIndex:'adjRemark',
        width:100,
        align:'left'
    }
]);
//��ʼ��Ĭ��������
InadjAuditGridCm.defaultSortable = true;

var findInadjAudit = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		query()
	}
});
function query()
{
	var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(App_StkDateFormat);
		}else{
			Msg.info("error","��ѡ����ʼ����!");
			return false;
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(App_StkDateFormat);
		}else{
			Msg.info("error","��ѡ���ֹ����!");
			return false;
		}
			
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","��ѡ�����벿��!");
			return false;
		}

		InadjAuditDetailGrid.store.removeAll();
		InadjAuditGridDs.load();
	
	}
var auditInadjAudit = new Ext.Toolbar.Button({
	text:'���',
    tooltip:'���',
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","��ѡ�����벿��!");
			return false;
		}
		//alert(mainRowId);
		if((mainRowId!="")&&(mainRowId!=null)){
			Ext.Ajax.request({
				url: InadjAuditGridUrl+'?actiontype=audit&adj='+mainRowId+'&userId='+UserId,
				failure: function(result, request) {
					Msg.info("error","������������!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success","��˳ɹ�!");
						
						//��˳ɹ���ˢ��ҳ��
						var startDate = Ext.getCmp('startDateField').getValue();
						if((startDate!="")&&(startDate!=null)){
							startDate = startDate.format(App_StkDateFormat);
						}else{
							Msg.info("error","��ѡ����ʼ����!");
							return false;
						}
						var endDate = Ext.getCmp('endDateField').getValue();
						if((endDate!="")&&(endDate!=null)){
							endDate = endDate.format(App_StkDateFormat);
						}else{
							Msg.info("error","��ѡ���ֹ����!");
							return false;
						}
						var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
				
						var strPar = startDate+"^"+endDate+"^"+locId+"^"+Audited+"^N";
						
						InadjAuditGridDs.load();
						InadjAuditDetailGridDs.removeAll();
					}else{
						if(jsonData.info==-1){
							Msg.info("error","�����!");
						}else if(jsonData.info==-2){
							Msg.info("error","��¼�û�rowidΪ��!");
						}else if(jsonData.info==-102){
							Msg.info("error","��洦�����!");
						}else if(jsonData.info==-103){
							Msg.info("error","����̨�����ݳ���!");
						}else{
						Ext.Msg.show({
							title:'������ʾ',
							msg:jsonData.info,
							buttons: Ext.Msg.OK,
							icon:Ext.MessageBox.ERROR
						});
						}
					}
				},
				scope: this
			});
		}
    }
});
function CancelAudit()
{
	var rowObj = InadjAuditGrid.getSelectionModel().getSelections(); 
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫȡ����˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else{
		var audited=rowObj[0].get('chkFlag');
		if (audited!='Y'){Msg.info('warning','����������δ���,�޷�ȡ��!');return;}
		var inadj = rowObj[0].get("adj");
		if ((inadj==null)||(inadj=="")){Msg.info('warning','��ѡ����Ҫȡ����˵�����!');return;}
		Ext.MessageBox.confirm('��ʾ','ȡ����˽�����ǰ���,���������!�Ƿ����?',
			function(btn) {
				if(btn == 'yes'){
					Ext.Ajax.request({
						url: InadjAuditGridUrl+'?actiontype=CancelAudit&adj='+inadj,
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.MessageBox.confirm('��ʾ','ȡ����˳ɹ�,�Ƿ�ɾ����������?',
									function(btn) {
										if(btn == 'yes'){
											Ext.Ajax.request({
												url: InadjAuditGridUrl+'?actiontype=delete&adj='+inadj,
												success: function(result, request) {
													var jsonData = Ext.util.JSON.decode( result.responseText );
													if (jsonData.success=='true') {
														Msg.info('success','ɾ���ɹ�!')
													}
													else{
														Msg.info('error',"ɾ��ʧ��!"+jsonData.info)
													}
												}
											})
	
										}
									}
								)
								query();
								
							}
							else{
								Msg.info('error',jsonData.info)
								return;
							
							}
						}
					})
	
				}
			}
		);
	}
}
var printInadjAudit = new Ext.Toolbar.Button({
	id : "printInadjAudit",
	text : '��ӡ',
	tooltip : '��ӡ������',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=InadjAuditGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "��ѡ����Ҫ��ӡ�ĵ�����!");
			return;
		}
		var inadj = rowData.get("adj");
		PrintInAdj(inadj);
	}
});

var formPanel = new Ext.form.FormPanel({
	labelWidth : 60,
	labelAlign : 'right',
	autoScroll:true,
	autoHeight : true,
	frame : true,
	//layout : 'fit',
    tbar:[findInadjAudit,'-',auditInadjAudit,'-',CancelAuditBT,'-',printInadjAudit],
	items : [{	
		xtype : 'fieldset',
		title : '����ѡ��',		
		autoHeight : true,
		style:DHCSTFormStyle.FrmPaddingV,
		items : [{
			layout : 'column',
			items : [{	
            	xtype: 'fieldset',
            	columnWidth: 0.25, 
            	border: false,
				items : [locField]
			}, {
				xtype: 'fieldset',
				columnWidth : .2,
				border:false,
				items : [startDateField]
			}, {
				xtype: 'fieldset',
				columnWidth : .2,
				border:false,
				items : [endDateField]
			}, {
				xtype: 'fieldset',
				columnWidth : .25,
				border:false,
				labelWidth:10,
				items : [AuditedCK]
			}]
		}]
	}]
});

var InadjAuditPagingToolbar = new Ext.PagingToolbar({
	store:InadjAuditGridDs,
	pageSize:15,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
	emptyMsg:"û�м�¼",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['sort']='NO';
		B['dir']='desc';
		B['strParam']=Ext.getCmp('startDateField').getValue().format(App_StkDateFormat)+"^"+Ext.getCmp('endDateField').getValue().format(App_StkDateFormat)+"^"+Ext.getCmp('locField').getValue()+"^"+(Ext.getCmp('AuditedCK').getValue()==true?'Y':'N')+"^N";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
InadjAuditGrid = new Ext.grid.EditorGridPanel({
	store:InadjAuditGridDs,
	cm:InadjAuditGridCm,
	trackMouseOver:true,
	region:'north',
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true,
		listeners:{'rowselect':function(sm,rowIndex,rec){
			var adj = InadjAuditGridDs.data.items[rowIndex].data["adj"];
			if (adj!=''){
				mainRowId = adj;
				InadjAuditDetailGridDs.setBaseParam('adj',adj)
				InadjAuditDetailGridDs.load({params:{start:0,limit:InadjAuditItmPagingToolbar.pageSize}});
			}
		}}
		}),
	loadMask:true,
	clicksToEdit:1,
	bbar:InadjAuditPagingToolbar
});
//=========================��汨�����=============================


//��������Դ
var InadjAuditDetailGridUrl = 'dhcst.inadjaction.csp';
var InadjAuditDetailGridProxy= new Ext.data.HttpProxy({url:InadjAuditDetailGridUrl+'?actiontype=queryItem',method:'GET'});
var InadjAuditDetailGridDs = new Ext.data.Store({
	proxy:InadjAuditDetailGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'adjitm'},
		{name:'inclb'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'manf'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'qty',type:'float'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'qtyBUOM'},
		{name:'rp',type:'float'},
		{name:'rpAmt',type:'float'},
		{name:'sp',type:'float'},
		{name:'spAmt',type:'float'},
		{name:'insti'}
	]),
    remoteSort:false
});


//ģ��
var InadjAuditDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 /*{
			header: '��ϸrowid',
			dataIndex: 'adjitm',
			width: 72,
			sortable:true,
			align: 'center'
		},{
			header: '����rowid',
			dataIndex: 'inclb',
			width: 72,
			sortable:true,
			align: 'center'
		},{
			header: 'ҩƷrowid',
			dataIndex: 'inci',
			width: 72,
			sortable:true,
			align: 'center'
		},*/{
			header: '����',
			dataIndex: 'code',
			width: 100,
			//sortable:true,
			align: 'center'
		},{
			header: '����',
			dataIndex: 'desc',
			width: 200,
			//sortable:true,
			align: 'left'
		},{
			header:'���',
			dataIndex:'spec',
			align:'left',
			width:100,
			//sortable:true
		},{
			header: "����",
			dataIndex: 'manf',
			width: 100,
			align: 'left',
			//sortable: true
		},{
			header: "����~Ч��",
			dataIndex: 'batNo',
			width: 200,
			align: 'left',
			//sortable: true
		},{
			header: "��������",
			dataIndex: 'qty',
			width: 100,
			align: 'right',
			//sortable: true
		},{
			header:'��λ',
			dataIndex:'uomDesc',
			align:'right',
			width:80,
			//sortable:true
		}/*,{
			header:'����',
			dataIndex:'rp',
			align:'right',
			width:80,
			sortable:true
		}*/,{
			header:'����',
			dataIndex:'rp',
			align:'right',
			width:80,
			//sortable:true
		},{
			header:'���۽��',
			dataIndex:'rpAmt',
			align:'right',
			width:100,
			//sortable:true,
			renderer:FormatGridRpAmount
		},{
			header:'�ۼ�',
			dataIndex:'sp',
			align:'right',
			width:80,
			//sortable:true
		},{
			header:'�ۼ۽��',
			dataIndex:'spAmt',
			align:'right',
			width:100,
			//sortable:true,
			renderer:FormatGridSpAmount
		}
]);
//��ʼ��Ĭ��������
InadjAuditDetailGridCm.defaultSortable = true;

var InadjAuditItmPagingToolbar = new Ext.PagingToolbar({
	store:InadjAuditDetailGridDs,
	pageSize:15,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
	emptyMsg:"û�м�¼"
});

//���
InadjAuditDetailGrid = new Ext.grid.EditorGridPanel({
	store:InadjAuditDetailGridDs,
	cm:InadjAuditDetailGridCm,
	trackMouseOver:true,
	region:'center',
	height:300,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:InadjAuditItmPagingToolbar
});

InadjAuditGrid.on('rowclick',function(grid,rowIndex,e){
	//if  ( rowIndex>=0)
	//{
	//	var adj = InadjAuditGridDs.data.items[rowIndex].data["adj"];
	//	mainRowId = adj;
	//	InadjAuditDetailGridDs.load({params:{adj:adj}});
	//}
});
//===========ģ����ҳ��=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ��������������
	}	
	var panel = new Ext.Panel({
		title:'�����������',
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(1),
		layout:'fit',
		items:[formPanel]                                 
	});
	
	var panel2 = new Ext.Panel({
		activeTab:0,
		region:'center',
		//height:document.body.clientHeight*0.34,
		layout:'fit',
		items:[InadjAuditGrid]                                 
	});
	var panel3= new Ext.Panel({
		activeTab:0,
		region:'south',
		height:document.body.clientHeight*0.45,
		layout:'fit',
		items:[InadjAuditDetailGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel,panel2,panel3],
		renderTo:'mainPanel'
	});
	query()
});
//===========ģ����ҳ��=============================================