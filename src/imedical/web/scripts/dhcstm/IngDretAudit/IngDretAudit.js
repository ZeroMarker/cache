// ����:�˻�����˹���
// ��д����:2012-07-18
var URL = 'dhcstm.ingdretauditaction.csp';
var HospId=session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var locId = session['LOGON.CTLOCID'];
var arr = window.status.split(":");
var length = arr.length;
var IngDretGrid;
var ret = "";

//��ʼ����
var startDate = new Ext.ux.DateField({
	id:'startDate',
	width:210,
	listWidth:210,
	allowBlank:true,
	fieldLabel:'��ʼ����',
	anchor:'90%',
	value:new Date(),
	editable:false
});
//��ֹ����
var endDate = new Ext.ux.DateField({
	id:'endDate',
	width:210,
	listWidth:210,
	allowBlank:true,
	fieldLabel:'��ֹ����',
	anchor:'90%',
	value:new Date(),
	editable:false
});

var locField = new Ext.form.ComboBox({
	id:'locField',
	fieldLabel:'�˻�����',
	width:210,
	listWidth:210,
	allowBlank:true,
	store:GetGroupDeptStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'�˻�����...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:999,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});
GetGroupDeptStore.load();
GetGroupDeptStore.on('load',function(ds,records,o){
	Ext.getCmp('locField').setRawValue(arr[length-1]);
	Ext.getCmp('locField').setValue(locId);
});	

var Vendor = new Ext.form.ComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	width : 210,
	store : APCVendorStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : true,
	triggerAction : 'all',
	emptyText : '',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 210,
	valueNotFoundText : ''
});
//=========================�˻�����˹���=================================
var IngDretGrid="";
//��������Դ
var IngDretGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=selectBatch',method:'GET'});
var IngDretGridDs = new Ext.data.Store({
	proxy:IngDretGridProxy,
    reader:new Ext.data.JsonReader({
        totalProperty:'results',
        root:'rows'
    }, [
		{name:'ingrt'},
		{name:'vendor'},
		{name:'vendorName'},
		{name:'loc'},
		{name:'locDesc'},
		{name:'ingrtNo'},
		{name:'retDate'},
		{name:'retTime'},
		{name:'retUser'},
		{name:'retUserName'},
		{name:'auditDate'},
		{name:'auditTime'},
		{name:'auditUser'},
		{name:'auditUserName'},
		{name:'auditFlag'},
		{name:'completed'},
		{name:'adjCheque'},
		{name:'scg'},
		{name:'scgDesc'}
	]),
    remoteSort:false
});
//ģ��
var IngDretGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"�˻�DR",
        dataIndex:'ingrt',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"�˻�����",
        dataIndex:'ingrtNo',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"��Ӧ��",
        dataIndex:'vendorName',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"�Ƶ���",
        dataIndex:'retUserName',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�Ƶ�����",
        dataIndex:'retDate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�Ƶ�ʱ��",
        dataIndex:'retTime',
        width:100,
        align:'left',
        sortable:true
    },{
        header:'��˱�־',
		dataIndex:'auditFlag',
        align:'center',
		width:120,
		sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:"�����",
        dataIndex:'auditUserName',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�������",
        dataIndex:'auditDate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"���ʱ��",
        dataIndex:'auditTime',
        width:100,
        align:'left',
        sortable:true
    }/*,{
        header:"���۽��",
        dataIndex:'expdate',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"����ۼ۽��",
        dataIndex:'recqty',
        width:100,
        align:'right',
        sortable:true
    }*/
]);

//��ʼ��Ĭ��������
IngDretGridCm.defaultSortable = true;

var findIngDret = new Ext.Toolbar.Button({
	text:'����',
    tooltip:'����',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var startDate = Ext.getCmp('startDate').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ����ʼ����!");
			return false;
		}
		var endDate = Ext.getCmp('endDate').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ���ֹ����!");
			return false;
		}
		var vorId = Ext.getCmp('Vendor').getValue();
		if((vorId=="")||(vorId==null)){
			Msg.info("error","��ѡ��Ӧ��!");
			return false;
		}
		if((locId=="")||(locId==null)){
			Msg.info("error","��ѡ�����!");
			return false;
		}
		IngDretGridDs.load({params:{start:0,limit:pagingToolbar.pageSize,sort:'ingrt',dir:'desc',strPar:startDate+"^"+endDate+"^"+locId+"^"+vorId}});
	}
});


IngDretGridDs.addListener('load',function(){
	IngDretGrid.getSelectionModel().selectFirstRow();
});

var clearIngDret = new Ext.Toolbar.Button({
	text:'���',
    tooltip:'���',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		IngDretGridDs.removeAll();
		IngDretDetailGridDs.removeAll();
	}
});

var auditIngDret = new Ext.Toolbar.Button({
	text:'���',
    tooltip:'���',
    iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		var startDate = Ext.getCmp('startDate').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ����ʼ����!");
			return false;
		}
		var endDate = Ext.getCmp('endDate').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","��ѡ���ֹ����!");
			return false;
		}
		var vorId = Ext.getCmp('Vendor').getValue();
		if((vorId=="")||(vorId==null)){
			Msg.info("error","��ѡ��Ӧ��!");
			return false;
		}
		if((locId=="")||(locId==null)){
			Msg.info("error","��ѡ�����!");
			return false;
		}
	
		var rowObj = IngDretGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ���ѡ������?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:URL+'?actiontype=audit&ret='+rowObj[0].get("ingrt")+'&userId='+userId,
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Msg.info("error","������������!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success","��˳ɹ�!");
									IngDretGridDs.load({params:{start:0,limit:pagingToolbar.pageSize,sort:'ingrt',dir:'desc',strPar:startDate+"^"+endDate+"^"+locId+"^"+vorId}});
								}else{
									if(jsonData.info==-2){
										Msg.info("error","�˻���δ���,���ܱ����!");
										return false;
									}else{
										Msg.info("error","���ʧ��!");
										return false;
									}
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

var pagingToolbar = new Ext.PagingToolbar({
	store:IngDretGridDs,
	pageSize:20,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
	emptyMsg:"û�м�¼",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['sort']='ingrt';
		B['dir']='desc';
		B['strPar']=Ext.getCmp('startDate').getValue().format(ARG_DATEFORMAT)+"^"+Ext.getCmp('endDate').getValue().format(ARG_DATEFORMAT)+"^"+locId+"^"+Ext.getCmp('Vendor').getValue();
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
IngDretGrid = new Ext.grid.EditorGridPanel({
	store:IngDretGridDs,
	cm:IngDretGridCm,
	trackMouseOver:true,
	height:250,
	stripeRows:true,
	clicksToEdit:0,
	region:'north',
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	bbar:pagingToolbar
});
//=========================�˻�����˹���=================================
var IngDretDetailGrid="";
//��������Դ
var IngDretDetailGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=select',method:'GET'});
var IngDretDetailGridDs = new Ext.data.Store({
	proxy:IngDretDetailGridProxy,
    reader:new Ext.data.JsonReader({
        totalProperty:'results',
        root:'rows'
    }, [
		{name:'ingrti'},
		{name:'ingri'},
		{name:'inclb'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'manf'},
		{name:'qty'},
		{name:'uom'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'oldSp'},
		{name:'oldSpAmt'},
		{name:'invNo'},
		{name:'invDate'},
		{name:'invAmt'},
		{name:'sxNo'},
		{name:'retReason'}
	]),
    remoteSort:false
});

//ģ��
var IngDretDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
        header:"�˻��ӱ�rowid",
        dataIndex:'ingrti',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"����",
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'desc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"��λ",
        dataIndex:'uom',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"���",
        dataIndex:'spec',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�˻�����",
        dataIndex:'qty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"����",
        dataIndex:'batNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"��Ч��",
        dataIndex:'expDate',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"����",
        dataIndex:'manf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"�˻�ԭ��",
        dataIndex:'retReason',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�˻�����",
        dataIndex:'rp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"���۽��",
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"�ۼ�",
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"�ۼ۽��",
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"����",
        dataIndex:'oldSp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"���۽��",
        dataIndex:'oldSpAmt',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"����ۼ�",
        dataIndex:'sp',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����ۼ۽��",
        dataIndex:'invAmt',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"��Ʊ��",
        dataIndex:'invNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"��Ʊ����",
        dataIndex:'invDate',
        width:100,
        align:'left',
        sortable:true
    }
]);

//��ʼ��Ĭ��������
IngDretDetailGridCm.defaultSortable = true;

var IngDretDetailPagingToolbar = new Ext.PagingToolbar({
    store:IngDretDetailGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['sort']='ingrti';
		B['dir']='desc';
		B['ret']=ret;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
IngDretDetailGrid = new Ext.grid.EditorGridPanel({
	store:IngDretDetailGridDs,
	cm:IngDretDetailGridCm,
	trackMouseOver:true,
	height:350,
	stripeRows:true,
	region:'center',
	clicksToEdit:0,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	bbar:IngDretDetailPagingToolbar
});
//=============�˻����������˻�����ϸ��������===================
IngDretGrid.on('rowclick',function(grid,rowIndex,e){
	ret = IngDretGridDs.data.items[rowIndex].data["ingrt"];
	IngDretDetailGridDs.load({params:{start:0,limit:IngDretDetailPagingToolbar.pageSize,sort:'ingrti',dir:'desc',ret:ret}});
});
//=============�˻����������˻�����ϸ��������===================
var formPanel = new Ext.form.FormPanel({
		labelwidth : 30,
		autoScroll:true,
		labelAlign : 'right',
		region:'north',
		height:113,
		frame:true,
		tbar:[findIngDret,'-',clearIngDret,'-',auditIngDret],
		autoScroll : true,
		bodyStyle : 'padding:0px;',
		items : [{
			autoHeight : true,
			layout : 'column',
			items : [{
				xtype : 'fieldset',
				title : 'ѡ��',
				width:1340,
				autoHeight : true,
				items : [{
					layout : 'column',
					items : [{
						columnWidth : .25,
						layout : 'form',
						items : [locField]
					},{
						columnWidth : .25,
						layout : 'form',
						items : [startDate]
					},{
						columnWidth : .25,
						layout : 'form',
						items : [endDate]
					},{
						columnWidth : .25,
						layout : 'form',
						items : [Vendor]
					}]
				}]
			}]
		}]
	});
//===========ģ����ҳ��=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var IngDretPanel = new Ext.Panel({
		layout:'border',
    	region:'center',
		title:'�˻�����˹���',
		activeTab: 0,
		items:[IngDretGrid,IngDretDetailGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,IngDretPanel],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��=================================================