// ����:�˻�����˹���
// ��д����:2012-07-18
var URL = 'dhcstm.ingdretaction.csp';
var HospId=session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var locId = session['LOGON.CTLOCID'];
var groupId=session['LOGON.GROUPID'];
var ret = "";

//ȡ��ֵ�������
var UseItmTrack="";
if(gItmTrackParam.length<1){
	GetItmTrackParam();
	UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
}

//��ʼ����
var startDate = new Ext.ux.DateField({
	id:'startDate',
	listWidth:180,
	allowBlank:true,
	fieldLabel:'��ʼ����',
	anchor:'90%',
	value:DefaultStDate()
	//,
	//editable:false
});
//��ֹ����
var endDate = new Ext.ux.DateField({
	id:'endDate',
	listWidth:180,
	allowBlank:true,
	fieldLabel:'��ֹ����',
	anchor:'90%',
	value:DefaultEdDate()
	//,
	//editable:false
});

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'�˻�����',
	anchor:'90%',
	emptyText:'�˻�����...',
	groupId:groupId,
	childCombo : 'Vendor'
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	anchor:'90%',
	params : {LocId : 'locField'}
});

var includeAudited=new Ext.form.Checkbox({
  fieldLabel:'�������',
  anchor:'90%',
  id:'auditFlag'

});
var SendToSCMFlagData=[['ȫ��','1'],['����','2'],['δ����','3']];
var SendToSCMFlagStore = new Ext.data.SimpleStore({
	fields: ['STSCMdesc', 'STSCMid'],
	data : SendToSCMFlagData
});

var SendToSCMFlagCombo = new Ext.form.ComboBox({
	store: SendToSCMFlagStore,
	displayField:'STSCMdesc',
	mode: 'local', 
	anchor : '90%',
	emptyText:'',
	id:'SendToSCMFlagCombo',
	fieldLabel : '�Ƿ���',
	triggerAction:'all', //ȡ���Զ�����
	valueField : 'STSCMid'
});
Ext.getCmp("SendToSCMFlagCombo").setValue("1");
//=========================�˻�����˹���=================================
//��������Դ
var IngDretGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=selectOrder',method:'GET'});
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
	remoteSort:false,
	listeners : {
		'load' : function(ds){
			if (ds.getCount()>0){
				IngDretGrid.getSelectionModel().selectFirstRow();
				IngDretGrid.getView().focusRow(0);
			}
		}
	}
});

IngDretGridDs.on('beforeload',function(ds){ds.removeAll();});

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
        header:"��ɱ�־",
        dataIndex:'completed',
        width:80,
        align:'center',
        renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },
    	{
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
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		query();
	}
});

function query(){
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
	/*
	if((vorId=="")||(vorId==null)){
		Msg.info("error","��ѡ��Ӧ��!");
		return false;
	} */
	var locId=Ext.getCmp("locField").getValue();
	if((locId=="")||(locId==null)){
		Msg.info("error","��ѡ�����!");
		return false;
	}
	
	//��˱�־
	if (Ext.getCmp('auditFlag').getValue()==true)
	{
		var auditFlag="Y";
	}
	else
	{
		var auditFlag="N";
	}
	var completeFlag="Y" ; //��ɱ�־
	var SendFlag=Ext.getCmp("SendToSCMFlagCombo").getValue();
	var strPar=startDate+"^"+endDate+"^"+locId+"^"+vorId+"^"+auditFlag+"^"+completeFlag+"^"+SendFlag;
	IngDretGridDs.setBaseParam('strPar',strPar);
	IngDretGridDs.setBaseParam('sort','ingrt');
	IngDretGridDs.setBaseParam('dir','desc');
	IngDretDetailGrid.getStore().removeAll();
	IngDretGridDs.load({params:{start:0,limit:pagingToolbar.pageSize}});
}

var clearIngDret = new Ext.Toolbar.Button({
	text:'���',
    tooltip:'���',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		Ext.getCmp('Vendor').setValue('');
	 	Ext.getCmp('auditFlag').setValue('');
			
	 	IngDretGrid.getStore().removeAll();
	 	IngDretGrid.view.refresh();
	 	//IngDretGrid.getStore().setBaseParam('locId','');

	 	IngDretDetailGrid.getStore().removeAll();
	 	IngDretDetailGrid.view.refresh();
	}
});

var auditIngDret = new Ext.Toolbar.Button({
	text:'���ͨ��',
    tooltip:'������ͨ��',
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
	
		var rowObj = IngDretGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var audited=rowObj[0].get('auditFlag');
			if (audited=='Y'){Msg.info('error','�Ѿ����');return;}
			
			var ingrt=rowObj[0].get("ingrt");
			
			///����ֵ���ϱ�ǩ¼�����
			if(UseItmTrack && CheckHighValueLabels("R",ingrt)==false){
				return;
			}
			
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ���ѡ�����˻���?',
				function(btn) {
					if(btn == 'yes'){
						var Ingrt = rowObj[0].get("ingrt");
						Ext.Ajax.request({
							url:URL+'?actiontype=audit&ret='+Ingrt+'&userId='+userId,
							failure: function(result, request) {
								Msg.info("error","������������!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success","���ͨ���ɹ�!");
									if(gParam[4] == 'Y'){
										var HVflag=GetCertDocHVFlag(Ingrt,"R");
										if (HVflag=="Y"){
										 PrintIngDretHVCol.defer(300,this,[Ingrt, 'Y']);
										}else{
										PrintIngDret.defer(300,this,[Ingrt, 'Y']);
										}
									}
									query();
								}else{
									if(jsonData.info==-2){
										Msg.info("error","�˻���δ���,���ܱ����!");
										return false;
									}else if(jsonData.info==-14){
										Msg.info("error","�˻����д������ʵ����ο��С���˻�����!");
										return false;
									}else{
										Msg.info("error","���ʧ��!"+jsonData.info);
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

/*
var auditIngDret = new Ext.Toolbar.Button({
	text:'���',
    tooltip:'���',
    iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
	
		var rowObj = IngDretGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ��˵�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var audited=rowObj[0].get('auditFlag');
			if (audited=='Y'){Msg.info('error','�Ѿ����');return;}
			
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ���ѡ�����˻���?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:URL+'?actiontype=audit&ret='+rowObj[0].get("ingrt")+'&userId='+userId,
							failure: function(result, request) {
								Msg.info("error","������������!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success","��˳ɹ�!");
									query();
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
*/

///�����˻�����ƽ̨
var SendIngRetBT = new Ext.Toolbar.Button({
			id : "SendIngRetBT",
			text : '�����˻�������ƽ̨',
			width : 70,
			height : 30,
			iconCls : 'page_find',
			handler : function() {
				    var rowData=IngDretGrid.getSelectionModel().getSelected();
					if (rowData ==null) {
						Msg.info("warning", "��ѡ����Ҫ���͵��˻���!");
						return;
					}
					var IngRet = rowData.get("ingrt");
					SendIngRet(IngRet);
			}
});
function SendIngRet(IngRet){
	 var url = URL+ "?actiontype=SendIngRet";
        var loadMask=ShowLoadMask(Ext.getBody(),"�����˻�����...");
        Ext.Ajax.request({
                    url : url,
                    method : 'POST',
                    params:{IngRet:IngRet},
                    waitMsg : '������...',
                    success : function(result, request) {
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                            // ˢ�½���
                            var IngrRowid = jsonData.info;
                            Msg.info("success", "���ͳɹ�!");
                            query();
                        } else {
                            var ret=jsonData.info;
                            if (ret==-2){
	                            Msg.info("error","���˻����ѷ���,���ܱ�����!");
								return false;
	                        }else{
                                Msg.info("error", jsonData.info);
                                return false;
	                        }
                        }
                    },
                    scope : this
                });
        loadMask.hide();
}
var printBT = new Ext.Toolbar.Button({
	id : "printBT",
	text : '��ӡ',
	tooltip : '��ӡ�˻���',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=IngDretGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "��ѡ����Ҫ��ӡ���˻���!");
			return;
		}
		var Ingrt = rowData.get("ingrt");
		var HVflag=GetCertDocHVFlag(Ingrt,"R");
		if (HVflag=="Y"){
		 PrintIngDretHVCol(Ingrt);
		}else{
		PrintIngDret(Ingrt);
		}
	}
});

var PrintHVCol = new Ext.Toolbar.Button({
	id : "PrintHVCol",
	text : '��ֵ���ܴ�ӡ',
	tooltip : '��ӡ��ֵ�˻���',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=IngDretGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "��ѡ����Ҫ��ӡ���˻���!");
			return;
		}
		var Ingrt = rowData.get("ingrt");
		var HVflag=GetCertDocHVFlag(Ingrt,"R");
		if (HVflag=="Y"){
			PrintIngDretHVCol(Ingrt);
		}else{
			Msg.info("warning","�Ǹ�ֵ����ʹ�ô�ӡ��ť����!");
			return;
		}
	}
});

var pagingToolbar = new Ext.PagingToolbar({
	store:IngDretGridDs,
	pageSize:20,
	displayInfo:true,
	displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
	emptyMsg:"û�м�¼"
//	,
//	doLoad:function(C){
//		var B={},
//		A=this.getParams();
//		B[A.start]=C;
//		B[A.limit]=this.pageSize;
//		B['sort']='ingrt';
//		B['dir']='desc';
//		B['strPar']=Ext.getCmp('startDate').getValue().format(ARG_DATEFORMAT)+"^"+Ext.getCmp('endDate').getValue().format(ARG_DATEFORMAT)+"^"+locId+"^"+Ext.getCmp('Vendor').getValue();
//		if(this.fireEvent("beforechange",this,B)!==false){
//			this.store.load({params:B});
//		}
//	}
});

//���
var IngDretGrid = new Ext.grid.EditorGridPanel({
	region:'center',
	store:IngDretGridDs,
	title:'�˻���',
	cm:IngDretGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	bbar:pagingToolbar
});

IngDretGrid.getSelectionModel().on('rowselect',function(x,rowIndex,y){
	ret = IngDretGridDs.data.items[rowIndex].data["ingrt"];
	IngDretDetailGridDs.load({params:{start:0,limit:IngDretDetailPagingToolbar.pageSize,sort:'ingrti',dir:'desc',ret:ret}});
	
})
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
		{name:'inci'},
		{name:'inclb'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'manf'},
		{name:'qty'},
		{name:'uomDesc'},
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
		{name:'retReason'},
		{name:'Remark'},
		{name:'SpecDesc'}
		
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
        header:"inci",
        dataIndex:'inci',
        width:100,
        align:'left',
        sortable:true,
        hidden:true
    },{
        header:"���ʴ���",
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"��������",
        dataIndex:'desc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"��λ",
        dataIndex:'uomDesc',
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
        align:'right',
        sortable:true
    },{
        header:"��Ʊ���",
        dataIndex:'invAmt',
        width:100,
        align:'right',
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
    },{
		header:"��ע",
		dataIndex:'Remark',
		width:100,
		align:'left'
		
	},{
    	header:"������",
   		dataIndex:'SpecDesc',
    	width:100,
   		align:'left'
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
	region:'south',
	height: 240,
	store:IngDretDetailGridDs,
	title:'�˻�����ϸ',
	cm:IngDretDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	bbar:IngDretDetailPagingToolbar
});

var formPanel = new Ext.ux.FormPanel({
		title:'�˻������',
		tbar:[findIngDret,'-',clearIngDret,'-',auditIngDret,'-',printBT,'-',PrintHVCol,'-',SendIngRetBT],
		bodyStyle : 'padding:0px;',
		items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			autoHeight : true,
			items : [{
				layout : 'column',
				items : [{
					columnWidth : .4,
					layout : 'form',
					items : [locField,startDate]
				},{
					columnWidth : .4,
					layout : 'form',
					items : [Vendor,endDate]
				},{
					columnWidth : .2,
					layout : 'form',
					items : [includeAudited,SendToSCMFlagCombo]
				}]
			}]
		
		}]
	});
//===========ģ����ҳ��=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,IngDretGrid,IngDretDetailGrid],
		renderTo:'mainPanel'
	});
	query();
});
//===========ģ����ҳ��=================================================