// ����:�˻�����˹���
// ��д����:2012-07-18
var URL = 'dhcst.ingdretaction.csp';
var HospId=session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var locId = session['LOGON.CTLOCID'];
var groupId=session['LOGON.GROUPID'];
var APPName="DHCSTPURPLANAUDIT"
var PurPlanParam=PHA_COM.ParamProp(APPName)

//var arr = window.status.split(":");
//var length = arr.length;

var ret = "";

//��ʼ����
var startDate = new Ext.form.DateField({
	id:'startDate',
	allowBlank:true,
	fieldLabel:$g('��ʼ����'),
	anchor:'90%',
	value:DefaultStDate()
	//,
	//editable:false
});
//��ֹ����
var endDate = new Ext.form.DateField({
	id:'endDate',
	allowBlank:true,
	fieldLabel:$g('��ֹ����'),
	anchor:'90%',
	value:DefaultEdDate()
	//,
	//editable:false
});

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:$g('�˻�����'),
	emptyText:$g('�˻�����...'),
	groupId:groupId
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : $g('��Ӫ��ҵ'),
	id : 'Vendor',
	name : 'Vendor'
});

var includeAudited=new Ext.form.Checkbox({
  boxLabel:$g('�������'),
  id:'auditFlag'

});

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
		{name:'scgDesc'},
		{name:'rpAmt'},
		{name:'spAmt'},
		{name:'magIn'}	
	]),
    remoteSort:false
});

IngDretGridDs.on('beforeload',function(ds){ds.removeAll();});

//ģ��
var IngDretGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:$g("�˻�DR"),
        dataIndex:'ingrt',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("�˻�����"),
        dataIndex:'ingrtNo',
        width:120,
        align:'left',
        sortable:true
    },{
        header:$g("��Ӫ��ҵ"),
        dataIndex:'vendorName',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("�Ƶ���"),
        dataIndex:'retUserName',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("�Ƶ�����"),
        dataIndex:'retDate',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("��ɱ�־"),
        dataIndex:'completed',
        width:60,
        align:'center',
        renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },
    	{
        header:$g("�Ƶ�ʱ��"),
        dataIndex:'retTime',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g('��˱�־'),
		dataIndex:'auditFlag',
        align:'center',
		width:60,
		sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:$g("�����"),
        dataIndex:'auditUserName',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("�������"),
        dataIndex:'auditDate',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("���ʱ��"),
        dataIndex:'auditTime',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("���۽��"),
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
        
    },{
        header:$g("�ۼ۽��"),
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridSpAmount
    },{
        header:$g("���۲��"),
        dataIndex:'magIn',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    }
]);

//��ʼ��Ĭ��������
IngDretGridCm.defaultSortable = true;

var findIngDret = new Ext.Toolbar.Button({
	text:$g('��ѯ'),
    tooltip:$g('��ѯ'),
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
		startDate = startDate.format(App_StkDateFormat);
	}else{
		Msg.info("error",$g("��ѡ����ʼ����!"));
		return false;
	}
	var endDate = Ext.getCmp('endDate').getValue();
	if((endDate!="")&&(endDate!=null)){
		endDate = endDate.format(App_StkDateFormat);
	}else{
		Msg.info("error",$g("��ѡ���ֹ����!"));
		return false;
	}
	
	var vorId = Ext.getCmp('Vendor').getValue();
	/*
	if((vorId=="")||(vorId==null)){
		Msg.info("error","��ѡ��Ӫ��ҵ!");
		return false;
	} */
	
	/*if((locId=="")||(locId==null)){
		Msg.info("error","��ѡ�����!");
		return false;
	}*/
	var rLocdr=Ext.getCmp('locField').getValue();
	//�޸�Ϊȡѡ����� wyx
	if((rLocdr=="")||(rLocdr==null)){
		Msg.info("error",$g("��ѡ�����!"));
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
	var strPar=startDate+"^"+endDate+"^"+rLocdr+"^"+vorId+"^"+auditFlag+"^"+completeFlag;
	IngDretGridDs.setBaseParam('strPar',strPar);
	IngDretGridDs.setBaseParam('sort','ingrt');
	IngDretGridDs.setBaseParam('dir','desc');
	IngDretDetailGrid.getStore().removeAll();
	IngDretGridDs.load({params:{start:0,limit:pagingToolbar.pageSize}});
}

IngDretGridDs.on('load',function(ds){
	if (ds.getCount()>0)
	{
		IngDretGrid.getSelectionModel().selectFirstRow();
		IngDretGrid.getView().focusRow(0);
	}
	
});

var clearIngDret = new Ext.Toolbar.Button({
	text:$g('����'),
    tooltip:$g('����'),
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
	id:"auditIngDret",
	text:$g('���'),
    tooltip:$g('���'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
	
		var rowObj = IngDretGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:$g('ע��'),msg:$g('��ѡ����Ҫ��˵�����!'),buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var audited=rowObj[0].get('auditFlag');
			if (audited=='Y'){Msg.info('warning',$g('�Ѿ����'));return;}
			
			Ext.MessageBox.confirm($g('��ʾ'),$g('ȷ��Ҫ���ѡ�����˻���?'),
				function(btn) {
					if(btn == 'yes'){
						///���Ԥ����Ŀ
						var ret = SendBusiData(rowObj[0].get("ingrt"),"RETURN","AUDIT")
						if(!ret) return;

						Ext.Ajax.request({
							url:URL+'?actiontype=audit&ret='+rowObj[0].get("ingrt")+'&userId='+userId,
							failure: function(result, request) {
								Msg.info("error",$g("������������!"));
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success",$g("��˳ɹ�!"));
									query();
								}else{
									if(jsonData.info==-2){
										Msg.info("warning",$g("�˻���δ���,���ܱ����!"));
										return false;
									}else if(jsonData.info==-14){
										Msg.info("warning",$g("�˻����д������ʵ����ο��С���˻�����!"));
										return false;
									}else{
										Msg.info("error",$g("���ʧ��!")+jsonData.info);
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

var cancelauditIngDret = new Ext.Toolbar.Button({
	text:$g('ȡ�����'),
    tooltip:$g('ȡ�����,��潫����!'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){	
		var rowObj = IngDretGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:$g('ע��'),msg:$g('��ѡ����Ҫȡ����˵��˻���!'),buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var audited=rowObj[0].get('auditFlag');
			if (audited!='Y'){Msg.info('warning',$g('�˻�����δ���'));return;}
			
			Ext.MessageBox.confirm($g('��ʾ'),$g('ȡ����˽����ӵ�ǰ���,���������!�Ƿ����?'),
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:URL+'?actiontype=CancelAudit&ret='+rowObj[0].get("ingrt"),
							failure: function(result, request) {
								Msg.info("error",$g("������������!"));
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success",$g("ȡ����˳ɹ�!�뼰ʱ�����˻���!"));
									query();
								}else{
									Msg.info("error",jsonData.info);
									return false;
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

var printBT = new Ext.Toolbar.Button({
	id : "printBT",
	text : $g('��ӡ'),
	tooltip : $g('��ӡ�˻���'),
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=IngDretGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", $g("��ѡ����Ҫ��ӡ���˻���!"));
			return;
		}
		var Ingrt = rowData.get("ingrt");
		PrintIngDret(Ingrt);
	}
});


/* �����ð�ť */
var GridColSetBT = new Ext.Toolbar.Button({
	text:$g('������'),
	tooltip:$g('������'),
	iconCls:'page_gear',
	handler:function(){
		GridSelectWin.show();
	}
});

// ȷ����ť
var returnColSetBT = new Ext.Toolbar.Button({
	text : $g('ȷ��'),
	tooltip : $g('���ȷ��'),
	iconCls : 'page_goto',
	handler : function() {
		var selectradio = Ext.getCmp('GridSelectModel').getValue();
		if(selectradio){
			var selectModel =selectradio.inputValue;	
			if (selectModel=='1') {
				GridColSet(IngDretGrid,"DHCSTRETURN");	
			}
			else {
				GridColSet(IngDretDetailGrid,"DHCSTRETURN");   							
			}						
		}
		GridSelectWin.hide();
	}
});

// ȡ����ť
var cancelColSetBT = new Ext.Toolbar.Button({
		text : $g('ȡ��'),
		tooltip : $g('���ȡ��'),
		iconCls : 'page_delete',
		handler : function() {
			GridSelectWin.hide();
		}
	});

//ѡ��ť
var GridSelectWin=new Ext.Window({
	title:$g('ѡ��'),
	width : 210,
	height : 110,
	labelWidth:100,
	closeAction:'hide' ,
	plain:true,
	modal:true,
	items:[{
		xtype:'radiogroup',
		id:'GridSelectModel',
		anchor: '95%',
		columns: 2,
		style: 'padding:10px 10px 10px 10px;',
		items : [{
				checked: true,				             
					boxLabel: $g('�˻���'),
					id: 'GridSelectModel1',
					name:'GridSelectModel',
					inputValue: '1' 							
				},{
				checked: false,				             
					boxLabel: $g('�˻�����ϸ'),
					id: 'GridSelectModel2',
					name:'GridSelectModel',
					inputValue: '2' 							
				}]
			}],
	
	buttons:[returnColSetBT,cancelColSetBT]
   })



var pagingToolbar = new Ext.PagingToolbar({
	store:IngDretGridDs,
	pageSize:20,
	displayInfo:true,
	displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
	emptyMsg:$g("û�м�¼")
});

//���
var IngDretGrid = new Ext.grid.EditorGridPanel({
	store:IngDretGridDs,
	title:$g('�˻���'),
	cm:IngDretGridCm,
	trackMouseOver:true,
	height:170, //document.body.clientHeight*0.35, 
	stripeRows:true,
	clicksToEdit:0,
	region:'north',
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	bbar:pagingToolbar
});

IngDretGrid.getSelectionModel().on('rowselect',function(x,rowIndex,y){
	var ret = IngDretGridDs.data.items[rowIndex].data["ingrt"];
	IngDretDetailGridDs.setBaseParam('ret',ret);
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
		{name:'InsuCode'},
		{name:'InsuDesc'}
	]),
    remoteSort:false
});


//ģ��
var IngDretDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
        header:$g("�˻��ӱ�rowid"),
        dataIndex:'ingrti',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("����"),
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("����"),
        dataIndex:'desc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("��λ"),
        dataIndex:'uomDesc',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("���"),
        dataIndex:'spec',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("�˻�����"),
        dataIndex:'qty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("����"),
        dataIndex:'batNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("��Ч��"),
        dataIndex:'expDate',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("������ҵ"),
        dataIndex:'manf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("�˻�ԭ��"),
        dataIndex:'retReason',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("�˻�����"),
        dataIndex:'rp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("���۽��"),
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    },{
        header:$g("�ۼ�"),
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("�ۼ۽��"),
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridSpAmount
    },{
        header:$g("����"),
        dataIndex:'oldSp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("���۽��"),
        dataIndex:'oldSpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridPpAmount
    },{
        header:$g("����ۼ�"),
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("��Ʊ���"),
        dataIndex:'invAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    },{
        header:$g("��Ʊ��"),
        dataIndex:'invNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("��Ʊ����"),
        dataIndex:'invDate',
        width:100,
        align:'left',
        sortable:true
    },{
		header : "����ҽ������",
		dataIndex : 'InsuCode',
		width : 100,
		align : ''
	},{
		header : "����ҽ������",
		dataIndex : 'InsuDesc',
		width : 100,
		align : ''
	}
]);

//��ʼ��Ĭ��������
IngDretDetailGridCm.defaultSortable = true;

var IngDretDetailPagingToolbar = new Ext.PagingToolbar({
    store:IngDretDetailGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
    emptyMsg:$g("û�м�¼")
});

//���
IngDretDetailGrid = new Ext.grid.EditorGridPanel({
	store:IngDretDetailGridDs,
	title:$g('�˻�����ϸ'),
	cm:IngDretDetailGridCm,
	trackMouseOver:true,
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
	//ret = IngDretGridDs.data.items[rowIndex].data["ingrt"];
	//IngDretDetailGridDs.load({params:{start:0,limit:IngDretDetailPagingToolbar.pageSize,sort:'ingrti',dir:'desc',ret:ret}});
});
//=============�˻����������˻�����ϸ��������===================
var formPanel = new Ext.form.FormPanel({
		labelWidth : 60,
		labelAlign : 'right',
		region:'north',
		autoHeight:true,
		title:$g('�˻������'),
		frame:true,
		//bodyStyle : 'padding:0px 0px 0px 0px;',	
		tbar:[findIngDret,'-',clearIngDret,'-',auditIngDret,'-',cancelauditIngDret,'-',printBT,'-',GridColSetBT],
		items : [{
			xtype : 'fieldset',
			title : $g('��ѯ����'),
			autoHeight : true,
			layout : 'column',
			defaults: { border:false}, 
			style:DHCSTFormStyle.FrmPaddingV,
			items : [{
				columnWidth : .3,
				xtype : 'fieldset',
				items : [locField,startDate]
			},{
				columnWidth : .3,
				xtype : 'fieldset',
				//defaultType: 'textfield',
				items : [Vendor,endDate]
			},{
				columnWidth : .3,
				xtype : 'fieldset',
				listWidth:10,
				//defaultType: 'textfield',
				items : [includeAudited,BudgetProComb]
			}]
		}]
	});
//===========ģ����ҳ��=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ��������������
	}	
	var IngDretPanel = new Ext.Panel({
		layout:'border',
    	region:'center',
		
		activeTab: 0,
		items:[IngDretGrid,IngDretDetailGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[{
            region: 'north',
            height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
            layout: 'fit', // specify layout manager for items
            items:formPanel
        },IngDretPanel],
		renderTo:'mainPanel'
	});
	RefreshGridColSet(IngDretGrid,"DHCSTRETURN");   
	RefreshGridColSet(IngDretDetailGrid,"DHCSTRETURN"); 
	query();
	SetBudgetPro(Ext.getCmp("locField").getValue(),"RETURN",[3],"auditIngDret") //����HRPԤ����Ŀ
});
//===========ģ����ҳ��=================================================
