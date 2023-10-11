// ����:��Ӧ�̹���
// ��д����:2012-05-14
//=========================��Ӧ�����=============================
var currVendorRowId='';

var conditionCodeField = new Ext.form.TextField({
	id:'conditionCodeField',
	fieldLabel:$g('��Ӧ�̴���'),
	allowBlank:true,
	//width:180,
	listWidth:180,
	//emptyText:'��Ӧ�̴���...',
	anchor:'90%',
	selectOnFocus:true
});
	
var conditionNameField = new Ext.form.TextField({
	id:'conditionNameField',
	fieldLabel:$g('��Ӧ������'),
	allowBlank:true,
	//width:150,
	listWidth:150,
	//emptyText:'��Ӧ������...',
	anchor:'90%',
	selectOnFocus:true
});

var conditionStateStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["A",$g('ʹ��')], ["S",$g('ͣ��')], ["",$g('ȫ��')]]
});

var conditionStateField = new Ext.form.ComboBox({
	id:'conditionStateField',
	fieldLabel:$g('ʹ��״̬'),
	anchor:'90%',
	//width:230,
	listWidth:230,
	allowBlank:true,
	store:conditionStateStore,
	value:'', // Ĭ��ֵ"ȫ����ѯ"
	valueField:'key',
	displayField:'keyValue',
	//emptyText:'ʹ��״̬...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true	,
	mode:'local'
});
	
//��������Դ
var APCVendorGridUrl = 'dhcst.apcvendoraction.csp';
var APCVendorGridProxy= new Ext.data.HttpProxy({url:APCVendorGridUrl+'?actiontype=query',method:'POST'});
var APCVendorGridDs = new Ext.data.Store({
	proxy:APCVendorGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Name'},
		{name:'Tel'},
		{name:'Category'},
		{name:'CategoryId'},
		{name:'CtrlAcct'},
		{name:'CrAvail'},
		{name:'LstPoDate'},
		{name:'Fax'},
		{name:'President'},
		{name:'Status'}
	]),
    remoteSort:false
});

//ģ��
var APCVendorGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:$g("����"),
        dataIndex:'Code',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("����"),
        dataIndex:'Name',
        width:400,
        align:'left',
        sortable:true
    },{
        header:$g("�绰"),
        dataIndex:'Tel',
        width:120,
        align:'left',
        sortable:false
    },{
        header:$g("����"),
        dataIndex:'Category',
        width:400,
        align:'left',
        sortable:false
    },{
        header:$g("�˻�"),
        dataIndex:'CtrlAcct',
        width:200,
        align:'left',
        sortable:false
    },{
        header:$g("ע���ʽ�"),
        dataIndex:'CrAvail',
        width:200,
        align:'left',
        sortable:false
    },{
        header:$g("��ͬ��ֹ����"),
        dataIndex:'LstPoDate',
        width:150,
        align:'left',
        sortable:true
    },{
        header:$g("����"),
        dataIndex:'Fax',
        width:200,
        align:'left',
        sortable:false
    },{
        header:$g("�������֤"),
        dataIndex:'President',
        width:150,
        align:'left',
        sortable:true
    },{
        header:$g("ʹ�ñ�־"),
        dataIndex:'Status',
        width:200,
        align:'left',
        sortable:false,
		renderer : function(v, p, record){
			if(v=="A")
				return $g("ʹ��");
			if(v=="S")
				return $g("ͣ��");
		}
    }
]);

//��ʼ��Ĭ��������
APCVendorGridCm.defaultSortable = true;

var findAPCVendor = new Ext.Toolbar.Button({
	text:$g('��ѯ'),
    tooltip:$g('��ѯ'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var conditionCode = Ext.getCmp('conditionCodeField').getValue();
		var conditionName=Ext.getCmp('conditionNameField').getValue();
		var conditionState=Ext.getCmp('conditionStateField').getValue();
		APCVendorGridDs.load({params:{start:0,limit:APCVendorPagingToolbar.pageSize,sort:'RowId',dir:'DESC',conditionCode:conditionCode,conditionName:conditionName,conditionState:conditionState}});
	}
});

// ��水ť
var SaveAsBT = new Ext.Toolbar.Button({
	text : $g('���'),
	tooltip : $g('���ΪExcel'),
	iconCls : 'page_excel',
	width : 70,
	height : 30,
	handler : function() {
		ExportAllToExcel(APCVendorGrid);
	}
});
//�����༭����(����)
//rowid :��Ӧ��rowid
function CreateEditWin(rowid)
{	
	//��Ӧ�̴���
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel:'<font color=red>*'+$g('��Ӧ�̴���')+'</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'��Ӧ�̴���...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��Ӧ������
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel:'<font color=red>*'+$g('��Ӧ������')+'</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'��Ӧ������...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//ҵ��Ա����
	var bussPersonField = new Ext.form.TextField({
		id:'bussPersonField',
		fieldLabel:$g('ҵ��Ա����'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'ҵ��Ա����...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��Ӧ�̴���
	var addressField = new Ext.form.TextField({
		id:'addressField',
		fieldLabel:$g('��Ӧ�̵�ַ'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��Ӧ�̵�ַ...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��Ӧ�̵绰
	var telField = new Ext.form.TextField({
		id:'telField',
		fieldLabel:$g('��Ӧ�̵绰'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��Ӧ�̵绰...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//����
	var categoryField = new Ext.form.ComboBox({
		id:'categoryField',
		fieldLabel:$g('����'),
		anchor:'90%',
		//width:143,
		listWidth:250,
		allowBlank:true,
		store:GetVendorCatStore,
		valueField:'RowId',
		displayField:'Description',
		//emptyText:'����...',
		triggerAction:'all',
		//emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true
	});
	
	//�˻�
	var ctrlAcctField = new Ext.form.TextField({
		id:'ctrlAcctField',
		fieldLabel:$g('�˻�'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'�˻�...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��������
	var bankField = new Ext.form.TextField({
		id:'bankField',
		fieldLabel:$g('��������'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��������...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//ע���ʽ�
	var crAvailField = new Ext.form.TextField({
		id:'crAvailField',
		fieldLabel:$g('ע���ʽ�'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'ע���ʽ�...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//�ɹ����
	var feeField = new Ext.form.NumberField({
		id:'feeField',
		fieldLabel:$g('�ɹ����'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'�ɹ����...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��ͬ��ֹ����
	var lstPoDate = new Ext.ux.DateField({ 
		id:'lstPoDate',
		fieldLabel:$g('��ͬ��ֹ����'),  
		allowBlank:true,
		width:143,
		listWidth:143   
		//emptyText:'��ͬ��ֹ���� ...'
	});
	
	//ҵ��Ա֤����Ч��
	var validDate = new Ext.ux.DateField({ 
		id:'validDate',
		fieldLabel:$g('֤����Ч��'),  
		allowBlank:true,
		width:184,
		listWidth:184      
		//emptyText:'֤����Ч�� ...'
	});
	
	//ҵ��Ա�绰
	var phoneField = new Ext.form.TextField({ 
		id:'phoneField',
		fieldLabel:$g('ҵ��Ա�绰'),  
		allowBlank:true,
		width:184,
		listWidth:184      
		//emptyText:'ҵ��Ա�绰 ...'
	});
	
	//����
	var faxField = new Ext.form.TextField({
		id:'faxField',
		fieldLabel:$g('����'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//����
	var corporationField = new Ext.form.TextField({
		id:'corporationField',
		fieldLabel:$g('����(��ϵ��)'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����(��ϵ��)...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//�������֤
	var presidentField = new Ext.form.TextField({
		id:'presidentField',
		fieldLabel:$g('�������֤'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'�������֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//״̬
	var stateStore = new Ext.data.SimpleStore({
		fields:['key', 'keyValue'],
		data:[["A",$g('ʹ��')], ["S",$g('ͣ��')]]
	});
	
	var stateField = new Ext.form.ComboBox({
		id:'stateField',
		fieldLabel: '<font color=red>*'+$g('ʹ��״̬')+'</font>',
		anchor:'90%',
		listWidth:184,
		allowBlank:true,
		store:stateStore,
		value:'A', // Ĭ��ֵ"ʹ��"
		valueField:'key',
		displayField:'keyValue',
		//emptyText:'ʹ��״̬...',
		triggerAction:'all',
		//emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		mode:'local'
	});
	
	//���ƹ�Ӧ
	var limitSupplyField = new Ext.form.Checkbox({
		id: 'limitSupplyField',
		fieldLabel:$g('���ƹ�Ӧ'),
		allowBlank: true
	});
	
	//����ִ��
	var comLicField = new Ext.form.TextField({
		id:'comLicField',
		fieldLabel:$g('����ִ��'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����ִ��...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//����ִ����Ч��
	var comLicValidDate = new Ext.ux.DateField({ 
		id:'comLicValidDate',
		fieldLabel:$g('��Ч��'),  
		allowBlank:true,
		width:100,
		listWidth:100        
		//emptyText:'��Ч�� ...'
	});
	//˰��ִ��
	var taxLicField = new Ext.form.TextField({
		id:'taxLicField',
		fieldLabel:$g('˰��ִ��'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'˰��ִ��...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//˰��ִ����Ч��
	var taxLicValidDate = new Ext.ux.DateField({ 
		id:'taxLicValidDate',
		fieldLabel:$g('��Ч��'),  
		allowBlank:true,
		width:100,
		listWidth:100        
		//emptyText:'��Ч�� ...'
	});
	
	//��������
	var orgCodeField = new Ext.form.TextField({
		id:'orgCodeField',
		fieldLabel:$g('��������'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��������...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//����������Ч��
	var orgCodeValidDate = new Ext.ux.DateField({ 
		id:'orgCodeValidDate',
		fieldLabel:$g('��Ч��'),  
		allowBlank:true,
		width:100,
		listWidth:100        
		//emptyText:'��Ч�� ...'
	});
	
	//ҩƷ��Ӫ���֤
	var drugBusLicField = new Ext.form.TextField({
		id:'drugBusLicField',
		fieldLabel:$g('ҩƷ��Ӫ���֤'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'ҩƷ��Ӫ���֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//ҩƷ��Ӫ���֤��Ч��
	var drugBusLicValidDate = new Ext.ux.DateField({ 
		id:'drugBusLicValidDate',
		fieldLabel:$g('��Ч��'),  
		allowBlank:true,
		width:100,
		listWidth:100        
		//emptyText:'��Ч�� ...'
	});
	
	//��е��Ӫ���֤
	var insBusLicField = new Ext.form.TextField({
		id:'insBusLicField',
		fieldLabel:$g('��е��Ӫ���֤'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��е��Ӫ���֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��е��Ӫ���֤��Ч��
	var insBusLicValidDate = new Ext.ux.DateField({ 
		id:'insBusLicValidDate',
		fieldLabel:$g('��Ч��'),  
		allowBlank:true,
		width:100,
		listWidth:100      
		//emptyText:'��Ч�� ...'
	});

	//��е�������֤
	var insProLicField = new Ext.form.TextField({
		id:'insProLicField',
		fieldLabel:$g('��е�������֤'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��е�������֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��е�������֤��Ч��
	var insProLicValidDate = new Ext.ux.DateField({ 
		id:'insProLicValidDate',
		fieldLabel:$g('��Ч��'),  
		allowBlank:true,
		width:100,
		listWidth:100      
		//emptyText:'��Ч�� ...'
	});
	
	//������ŵ��
	var qualityCommField = new Ext.form.TextField({
		id:'qualityCommField',
		fieldLabel:$g('������ŵ��'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'������ŵ��...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//������ŵ����Ч��
	var qualityCommValidDate = new Ext.ux.DateField({ 
		id:'qualityCommValidDate',
		fieldLabel:$g('��Ч��'),  
		allowBlank:true,
		width:100,
		listWidth:100        
		//emptyText:'��Ч�� ...'
	});
	
	//������Ȩ��
	var agentAuthField = new Ext.form.TextField({
		id:'agentAuthField',
		fieldLabel:$g('������Ȩ��'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'������Ȩ��...',
		anchor:'90%',
		selectOnFocus:true
	});

	//������Ȩ����Ч��
	var agentAuthValidDate = new Ext.ux.DateField({ 
		id:'agentAuthValidDate',
		fieldLabel:$g('��Ч��'),  
		allowBlank:true,
		width:100,
		listWidth:100       
		//emptyText:'��Ч�� ...'
	});
	
	//�ۺ�����ŵ��
	var saleServCommField = new Ext.form.TextField({
		id:'saleServCommField',
		fieldLabel:$g('�ۺ�����ŵ��'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'�ۺ�����ŵ��...',
		anchor:'90%',
		selectOnFocus:true
	});

	//����ί����
	var legalCommField = new Ext.form.TextField({
		id:'legalCommField',
		fieldLabel:$g('����ί����'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����ί����...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//ҩƷ�������֤
	var drugProLicField = new Ext.form.TextField({
		id:'drugProLicField',
		fieldLabel:$g('ҩƷ�������֤'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'ҩƷ�������֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//ҩƷ�������֤��Ч��
	var drugProLicValidDate = new Ext.ux.DateField({ 
		id:'drugProLicValidDate',
		fieldLabel:$g('��Ч��'),  
		allowBlank:true,
		width:100,
		listWidth:100       
		//emptyText:'��Ч�� ...'
	});
	
	//ҩƷע������
	var drugRegLicField = new Ext.form.TextField({
		id:'drugRegLicField',
		fieldLabel:$g('ҩƷע������'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'ҩƷע������...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//ҩƷע��������Ч��
	var drugRegLicValidDate = new Ext.ux.DateField({ 
		id:'drugRegLicValidDate',
		fieldLabel:$g('��Ч��'),  
		allowBlank:true,
		width:100,
		listWidth:100       
		//emptyText:'��Ч�� ...'
	});
	
	//GSP��֤
	var gspLicField = new Ext.form.TextField({
		id:'gspLicField',
		fieldLabel:$g('GSP��֤'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'GSP��֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//GSP��֤��Ч��
	var gspLicValidDate = new Ext.ux.DateField({ 
		id:'gspLicValidDate',
		fieldLabel:$g('��Ч��'),  
		allowBlank:true,
		width:100,
		listWidth:100       
		//emptyText:'��Ч�� ...'
	});
	 
	//��еע��֤
	var insRegLicField = new Ext.form.TextField({
		id:'insRegLicField',
		fieldLabel:$g('��еע��֤'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'��еע��֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//��еע��֤��Ч��
	var insRegLicValidDate = new Ext.ux.DateField({ 
		id:'insRegLicValidDate',
		fieldLabel:$g('��Ч��'),  
		allowBlank:true,
		width:100,
		listWidth:100       
		//emptyText:'��Ч�� ...'
	});
	
	//����ע��ǼǱ�
	var inletRegLicField = new Ext.form.TextField({
		id:'inletRegLicField',
		fieldLabel:$g('����ע��ǼǱ�'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����ע��ǼǱ�...',
		anchor:'90%',
		selectOnFocus:true
	});

	//����ע��ǼǱ���Ч��
	var inletRegLicValidDate = new Ext.ux.DateField({ 
		id:'inletRegLicValidDate',
		fieldLabel:$g('��Ч��'),  
		allowBlank:true,
		width:100,
		listWidth:100        
		//emptyText:'��Ч�� ...'
	});
	
	//����ע��֤
	var inletRLicField = new Ext.form.TextField({
		id:'inletRLicField',
		fieldLabel:$g('����ע��֤'),
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����ע��֤...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	//����ע��֤��Ч��
	var inletRLicValidDate = new Ext.ux.DateField({ 
		id:'inletRLicValidDate',
		fieldLabel:$g('��Ч��'),  
		allowBlank:true,
		width:100,
		listWidth:100       
		//emptyText:'��Ч�� ...'
	});
	
	//����
	var VendorAlias = new Ext.form.TextField({
		id : 'VendorAlias',
		fieldLabel : $g('������'),
		anchor : '90%',
		maxLength : 20
	});
	
	var Universal = new Ext.form.Checkbox({
		id: 'Universal',
		fieldLabel:$g('ͨ�ñ�־'),
		checked:false,
		allowBlank: true,
		hidden:true
	});
	
	//��ʼ����Ӱ�ť
	var okButton = new Ext.Toolbar.Button({
		text:$g('����'),
		iconCls:'page_save',
		handler:function()
		{	
			var ss=getVendorDataStr();
			if (typeof(ss)=='undefined' || ss==""){return;}
			
			if (rowid!='') {
				ss=rowid+'^'+ss;
				UpdVendorInfo(ss);  //ִ�и���}
			} else {
				InsVendorInfo(ss);  //ִ�в���
			}
		}
	});
	
	//��ʼ��ȡ����ť
	var cancelButton = new Ext.Toolbar.Button({
		text:$g('�ر�'),
		iconCls:'page_close',
		handler:function()
		{
			//alert(Ext.getCmp('codeField').getValue());
			if (window){
				window.close();		
			}
		}
	});
	/*
	var clearButton = new Ext.Toolbar.Button({
		text:'���',
		handler:function()
		{
			
		
			
		}		
	})*/
	
	//��ʼ�����
	var vendorPanel = new Ext.form.FormPanel({
		labelWidth : 100,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		items : [{
			autoHeight : true,
			items : [{
				xtype : 'fieldset',
				title : $g('������Ϣ'),
				autoHeight : true,
				items : [{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[codeField]},
						{columnWidth:.7,layout:'form',items:[nameField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[categoryField]},
						{columnWidth:.35,layout:'form',items:[corporationField]},
						{columnWidth:.35,layout:'form',items:[presidentField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[ctrlAcctField]},
						{columnWidth:.35,layout:'form',items:[bankField]},
						{columnWidth:.35,layout:'form',items:[crAvailField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[lstPoDate]},
						{columnWidth:.7,layout:'form',items:[addressField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[telField]}, 
						{columnWidth:.35,layout:'form',items:[faxField]}, 
						{columnWidth:.35,layout:'form',items:[VendorAlias]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[feeField]},
						{columnWidth:.35,layout:'form',items:[stateField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.3,layout:'form',items:[limitSupplyField]},
						{columnWidth:.35,layout:'form',items:[Universal]}
					]
				}]
			},{
				xtype : 'fieldset',
				title : $g('������Ϣ'),
				autoHeight : true,
				items : [{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[comLicField]},
						{columnWidth:.25,layout:'form',items:[taxLicField]},
						{columnWidth:.25,layout:'form',items:[orgCodeField]},
						{columnWidth:.25,layout:'form',items:[drugBusLicField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[comLicValidDate]},
						{columnWidth:.25,layout:'form',items:[taxLicValidDate]},
						{columnWidth:.25,layout:'form',items:[orgCodeValidDate]},
						{columnWidth:.25,layout:'form',items:[drugBusLicValidDate]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[insBusLicField]},
						{columnWidth:.25,layout:'form',items:[insProLicField]},
						{columnWidth:.25,layout:'form',items:[qualityCommField]},
						{columnWidth:.25,layout:'form',items:[agentAuthField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[insBusLicValidDate]},
						{columnWidth:.25,layout:'form',items:[insProLicValidDate]},
						{columnWidth:.25,layout:'form',items:[qualityCommValidDate]},
						{columnWidth:.25,layout:'form',items:[agentAuthValidDate]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[saleServCommField]},
						{columnWidth:.25,layout:'form',items:[drugProLicField]},
						{columnWidth:.25,layout:'form',items:[drugRegLicField]},
						{columnWidth:.25,layout:'form',items:[gspLicField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[legalCommField]},
						{columnWidth:.25,layout:'form',items:[drugProLicValidDate]},
						{columnWidth:.25,layout:'form',items:[drugRegLicValidDate]},
						{columnWidth:.25,layout:'form',items:[gspLicValidDate]}
					]
				},{
					layout:'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[insRegLicField]},
						{columnWidth:.25,layout:'form',items:[inletRegLicField]},
						{columnWidth:.25,layout:'form',items:[inletRLicField]}
					]
				},{
					layout : 'column',
					height:25,
					items : [
						{columnWidth:.25,layout:'form',items:[insRegLicValidDate]},
						{columnWidth:.25,layout:'form',items:[inletRegLicValidDate]},
						{columnWidth:.25,layout:'form',items:[inletRLicValidDate]}
					]
				},{
					autoHeight : true,
					xtype:'fieldset',
					title : $g('ҵ��Ա��Ȩ����Ϣ'),
					items : [{
						layout : 'column',
						height:25,
						items : [
							{columnWidth:.3,layout:'form',items:[bussPersonField]},
							{columnWidth:.34,layout:'form',items:[validDate]},
							{columnWidth:.34,layout:'form',items:[phoneField]}
						]
					}]
				}]
			}]
		}]
	});
		

	

	//��ʼ������
	var window = new Ext.Window({
		title:$g('��Ӧ����Ϣ�༭'),
		width:document.body.clientWidth*0.9,
		height:document.body.clientHeight*0.9,
		minWidth:1000,
		minHeight:612,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'right',
		items:vendorPanel,
		buttons:[okButton,	cancelButton],
		listeners:{
			'show':function(){
				if (rowid!='')	{SetVendorInfo(rowid);}
			}
		}
	});
	
	window.show();
	
	//��ʾ��Ӧ����Ϣ
	function SetVendorInfo(rowid)
	{
		Ext.Ajax.request({
			url: APCVendorGridUrl+'?actiontype=queryByRowId&rowid='+rowid,
			failure: function(result, request) {
				Msg.info('error',$g('ʧ�ܣ�'));
			},
			success: function(result, request) {
				//alert(result.responseText)
				var jsonData = Ext.util.JSON.decode( result.responseText );
				//alert(result.responseText);
				if (jsonData.success=='true') {
					var value = jsonData.info;
					//alert(value);
					var arr = value.split("^");
					//������Ϣ
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('categoryField').setValue(arr[10]);
					Ext.getCmp('categoryField').setRawValue(arr[11]);
					Ext.getCmp('corporationField').setValue(arr[7]);
					Ext.getCmp('presidentField').setValue(arr[8]);
					Ext.getCmp('ctrlAcctField').setValue(arr[4]);
					Ext.getCmp('bankField').setValue(arr[3]);
					Ext.getCmp('crAvailField').setValue(arr[12]);
					Ext.getCmp('lstPoDate').setValue(arr[13]);
					Ext.getCmp('addressField').setValue(arr[14]);
					Ext.getCmp('telField').setValue(arr[2]);
					Ext.getCmp('faxField').setValue(arr[6]);
					Ext.getCmp('limitSupplyField').setValue(arr[15]=="Y"?true:false);
					Ext.getCmp('feeField').setValue(arr[5]);
					Ext.getCmp('stateField').setValue(arr[9]);
					Ext.getCmp('stateField').setRawValue(arr[9]=="A"?$g("ʹ��"):$g("ͣ��"));
					//������Ϣ
					Ext.getCmp('comLicField').setValue(arr[16]);
					Ext.getCmp('taxLicField').setValue(arr[38]);
					Ext.getCmp('orgCodeField').setValue(arr[33]);
					Ext.getCmp('drugBusLicField').setValue(arr[19]);
					Ext.getCmp('comLicValidDate').setValue(arr[17]);
					Ext.getCmp('taxLicValidDate').setValue(arr[39]);
					Ext.getCmp('orgCodeValidDate').setValue(arr[34]);
					Ext.getCmp('drugBusLicValidDate').setValue(arr[20]);
					Ext.getCmp('insBusLicField').setValue(arr[29]);
					Ext.getCmp('insProLicField').setValue(arr[31]);
					Ext.getCmp('qualityCommField').setValue(arr[43]);
					Ext.getCmp('agentAuthField').setValue(arr[18]);
					Ext.getCmp('insBusLicValidDate').setValue(arr[30]);
					Ext.getCmp('insProLicValidDate').setValue(arr[32]);
					Ext.getCmp('qualityCommValidDate').setValue(arr[44]);
					Ext.getCmp('agentAuthValidDate').setValue(arr[45]);
					Ext.getCmp('saleServCommField').setValue(arr[35]);
					Ext.getCmp('drugProLicField').setValue(arr[36]);
					Ext.getCmp('drugRegLicField').setValue(arr[40]);
					Ext.getCmp('gspLicField').setValue(arr[21]);
					Ext.getCmp('legalCommField').setValue(arr[42]);
					Ext.getCmp('drugProLicValidDate').setValue(arr[37]);
					Ext.getCmp('drugRegLicValidDate').setValue(arr[41]);
					Ext.getCmp('gspLicValidDate').setValue(arr[22]);
					Ext.getCmp('insRegLicField').setValue(arr[27]);
					Ext.getCmp('inletRegLicField').setValue(arr[25]);
					Ext.getCmp('inletRLicField').setValue(arr[23]);
					Ext.getCmp('insRegLicValidDate').setValue(arr[28]);
					Ext.getCmp('inletRegLicValidDate').setValue(arr[26]);
					Ext.getCmp('inletRLicValidDate').setValue(arr[24]);
					//ҵ��Ա��Ȩ��Ϣ
					Ext.getCmp('bussPersonField').setValue(arr[46]);
					Ext.getCmp('validDate').setValue(arr[47]);
					Ext.getCmp('phoneField').setValue(arr[48]);	
					Ext.getCmp('VendorAlias').setValue(arr[49]);	
					Ext.getCmp('Universal').setValue(arr[50]=="Y"?true:false);				
				}
			}
			,
			scope: this
		});
		
	}

	//ȡ�ù�Ӧ�̴�
	function  getVendorDataStr()
	{
		//������Ϣ
		//��Ӧ�̴���
		var code = codeField.getValue();
		//��Ӧ������
		var name = nameField.getValue();
		if(code.trim()==""){
			Msg.info("warning",$g("��Ӧ�̴���Ϊ��!"));
			//Ext.Msg.show({title:'��ʾ',msg:'��Ӧ�̴���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(name.trim()==""){
			Msg.info("warning",$g("��Ӧ������Ϊ��!"));
			//Ext.Msg.show({title:'��ʾ',msg:'��Ӧ������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		//��Ӧ�̷���
		var categoryId = categoryField.getValue();
		//����(��ϵ�� )
		var corporation = corporationField.getValue();
		//�������֤
		var president = presidentField.getValue();
		//�˻�
		var ctrlAcct = ctrlAcctField.getValue();
		//������
		var bankName = bankField.getValue();
		//ע���ʽ�
		var crAvail = crAvailField.getValue();
		if (crAvail!="" && isNaN(crAvail)){
			Msg.info("warning",$g("ע���ʽ������봿����!"));
			return;
		}
		/*
		if((crAvail!="" && crAvail<1)||crAvail==0){
			Msg.info("warning","ע���ʽ�����Ϊ1Ԫ!");
			return;
		}
		*/
		//��ͬ��ֹ����
		var lstPoDate = Ext.getCmp('lstPoDate').getValue();
		if((lstPoDate!="")&&(lstPoDate!=null)){
			lstPoDate = lstPoDate.format(App_StkDateFormat);
		}
		//��ַ
		var address = addressField.getValue();
		//��Ӧ�̵绰
		var tel = telField.getValue();
		//��Ӧ�̴���
		var fax = faxField.getValue();
		//���ƹ�Ӧ
		var isLimitSupply = (limitSupplyField.getValue()==true)?'Y':'N';
		//�ɹ����
		var fee = feeField.getValue();
		//ʹ��״̬
		var state = stateField.getValue();
		if(state==""){
			Msg.info("warning",$g("��ѡ��ʹ��״̬!"));
			return;
		};
	
		//������Ϣ
		//����ִ��
		var comLic = comLicField.getValue();
		//����ִ����Ч��
		var comLicValidDate = Ext.getCmp('comLicValidDate').getValue();
		if((comLicValidDate!="")&&(comLicValidDate!=null)){
			comLicValidDate = comLicValidDate.format(App_StkDateFormat);
		}
		//˰��ִ��
		var taxLic = taxLicField.getValue();
		//˰��ִ����Ч��
		var taxLicValidDate = Ext.getCmp('taxLicValidDate').getValue();
		if((taxLicValidDate!="")&&(taxLicValidDate!=null)){
			taxLicValidDate = taxLicValidDate.format(App_StkDateFormat);
		}
		//��������
		var orgCode = orgCodeField.getValue();
		//˰��ִ����Ч��
		var orgCodeValidDate = Ext.getCmp('orgCodeValidDate').getValue();
		if((orgCodeValidDate!="")&&(orgCodeValidDate!=null)){
			orgCodeValidDate = orgCodeValidDate.format(App_StkDateFormat);
		}
		//ҩƷ��Ӫ���֤
		var drugBusLic = drugBusLicField.getValue();
		//ҩƷ��Ӫ���֤��Ч��
		var drugBusLicValidDate = Ext.getCmp('drugBusLicValidDate').getValue();
		if((drugBusLicValidDate!="")&&(drugBusLicValidDate!=null)){
			drugBusLicValidDate = drugBusLicValidDate.format(App_StkDateFormat);
		}
		
		
		//��е��Ӫ���֤
		var insBusLic = insBusLicField.getValue();
		//��е��Ӫ���֤��Ч��
		var insBusLicValidDate = Ext.getCmp('insBusLicValidDate').getValue();
		if((insBusLicValidDate!="")&&(insBusLicValidDate!=null)){
			insBusLicValidDate = insBusLicValidDate.format(App_StkDateFormat);
		}
		//��е�������֤
		var insProLic = insProLicField.getValue();
		//��е�������֤��Ч��
		var insProLicValidDate = Ext.getCmp('insProLicValidDate').getValue();
		if((insProLicValidDate!="")&&(insProLicValidDate!=null)){
			insProLicValidDate = insProLicValidDate.format(App_StkDateFormat);
		}
		//������ŵ��
		var qualityComm = qualityCommField.getValue();
		//������ŵ����Ч��
		var qualityCommValidDate = Ext.getCmp('qualityCommValidDate').getValue();
		if((qualityCommValidDate!="")&&(qualityCommValidDate!=null)){
			qualityCommValidDate = qualityCommValidDate.format(App_StkDateFormat);
		}
		//������Ȩ��
		var agentAuth = agentAuthField.getValue();
		//������Ȩ����Ч��
		var agentAuthValidDate = Ext.getCmp('agentAuthValidDate').getValue();
		if((agentAuthValidDate!="")&&(agentAuthValidDate!=null)){
			agentAuthValidDate = agentAuthValidDate.format(App_StkDateFormat);
		}
		
		
		//�ۺ�����ŵ��
		var saleServComm = saleServCommField.getValue();
		//����ί����
		var legalComm = legalCommField.getValue();
		//ҩƷ�������֤
		var drugProLic = drugProLicField.getValue();
		//ҩƷ�������֤��Ч��
		var drugProLicValidDate = Ext.getCmp('drugProLicValidDate').getValue();
		if((drugProLicValidDate!="")&&(drugProLicValidDate!=null)){
			drugProLicValidDate = drugProLicValidDate.format(App_StkDateFormat);
		}
		//ҩƷע������
		var drugRegLic = drugRegLicField.getValue();
		//ҩƷע��������Ч��
		var drugRegLicValidDate = Ext.getCmp('drugRegLicValidDate').getValue();
		if((drugRegLicValidDate!="")&&(drugRegLicValidDate!=null)){
			drugRegLicValidDate = drugRegLicValidDate.format(App_StkDateFormat);
		}
		//GSP��֤
		var gspLic = gspLicField.getValue();
		//GSP��֤��Ч��
		var gspLicValidDate = Ext.getCmp('gspLicValidDate').getValue();
		if((gspLicValidDate!="")&&(gspLicValidDate!=null)){
			gspLicValidDate = gspLicValidDate.format(App_StkDateFormat);
		}
		
		
		//��еע��֤
		var insRegLic = insRegLicField.getValue();
		//��еע��֤��Ч��
		var insRegLicValidDate = Ext.getCmp('insRegLicValidDate').getValue();
		if((insRegLicValidDate!="")&&(insRegLicValidDate!=null)){
			insRegLicValidDate = insRegLicValidDate.format(App_StkDateFormat);
		}
		//����ע��ǼǱ�
		var inletRegLic = inletRegLicField.getValue();
		//����ע��ǼǱ���Ч��
		var inletRegLicValidDate = Ext.getCmp('inletRegLicValidDate').getValue();
		if((inletRegLicValidDate!="")&&(inletRegLicValidDate!=null)){
			inletRegLicValidDate = inletRegLicValidDate.format(App_StkDateFormat);
		}
		//����ע��֤
		var inletRLic = inletRLicField.getValue();
		//����ע��֤
		var inletRLicValidDate = Ext.getCmp('inletRLicValidDate').getValue();
		if((inletRLicValidDate!="")&&(inletRLicValidDate!=null)){
			inletRLicValidDate = inletRLicValidDate.format(App_StkDateFormat);
		}
		
		
		//ҵ��Ա��Ȩ��Ϣ
		//ҵ��Ա����
		var bussPerson = bussPersonField.getValue();
		//֤����Ч��
		var validDate = Ext.getCmp('validDate').getValue();
		if((validDate!="")&&(validDate!=null)){
			validDate = validDate.format(App_StkDateFormat);
		}
		//ҵ��Ա�绰
		var phone = phoneField.getValue();		
		// ������
		var vendorAlias=Ext.getCmp('VendorAlias').getValue();
		// ͨ�ñ�־
		// var universalFlag=(Universal.getValue()==true)?'Y':'N';  //ͨ�ñ�־��ʹ�� 2021-01-06 yangsj
		var universalFlag="N"
		/*
		��Ӧ�̴���^����^�绰^������^�˻�^�ɹ��޶�^����^����^����id^ʹ�ñ�־^����id^ע���ʽ�^��ͬ��ֹ����^��ַ^���ƹ�Ӧ��־^����ִ��^����ִ��Ч��^������Ȩ��^ҩƷ��Ӫ���֤^ҩƷ��Ӫ���֤��Ч��
		^Gsp��֤^Gsp��֤��Ч��^����ע��֤^����ע��֤��Ч��^����ע��ǼǱ�^����ע��ǼǱ���Ч��^��еע��֤^��еע��֤��Ч��^��е��Ӫ���֤^��е��Ӫ���֤��Ч��^��е�������֤^��е�������֤��Ч��
		^��֯��������^��֯������Ч��^�ۺ�����ŵ��^ҩƷ�������֤^ҩƷ�������֤��Ч��^˰��Ǽ�^˰��Ǽ���Ч��^ҩƷע������^ҩƷע��������Ч��^����ί����^������ŵ��^������ŵ����Ч��^������Ȩ����Ч��^ҵ��Ա����^ҵ��Ա��Ȩ����Ч��^ҵ��Ա�绰
		*/
		
		//ƴdata�ַ���
		var data=code+"^"+name+"^"+tel+"^"+bankName+"^"+ctrlAcct+"^"+fee+"^"+fax+"^"+corporation+"^"+president+"^"+state+"^"+categoryId+"^"+crAvail+"^"+lstPoDate+"^"+address+"^"+isLimitSupply
		+"^"+comLic+"^"+comLicValidDate+"^"+agentAuth+"^"+drugBusLic+"^"+drugBusLicValidDate
		+"^"+gspLic+"^"+gspLicValidDate+"^"+inletRLic+"^"+inletRLicValidDate+"^"+inletRegLic+"^"+inletRegLicValidDate
		+"^"+insRegLic+"^"+insRegLicValidDate+"^"+insBusLic+"^"+insBusLicValidDate+"^"+insProLic+"^"+insProLicValidDate
		+"^"+orgCode+"^"+orgCodeValidDate+"^"+saleServComm+"^"+drugProLic+"^"+drugProLicValidDate+"^"+taxLic+"^"+taxLicValidDate
		+"^"+drugRegLic+"^"+drugRegLicValidDate+"^"+legalComm+"^"+qualityComm+"^"+qualityCommValidDate
		+"^"+agentAuthValidDate+"^"+bussPerson+"^"+validDate+"^"+phone+"^"+vendorAlias+"^"+universalFlag;
		return data;
	}
	
	//���빩Ӧ��
	function InsVendorInfo(data)
	{
		var retstr=tkMakeServerCall("web.DHCST.APCVendor","CheckVendorBeforeInsert",data,HospId)
		var retflag=retstr.split("^")[0];
		var retmsg=retstr.split("^")[1];
		if(retflag==-1)
		{
			Msg.info("error",retmsg);
			return;
		}
		else if((retflag>0)||(retflag==-2))
		{
			Msg.info("error",$g("�Ѵ�����ͬ�Ĵ����������"));
			/*  ͨ����־�Ѳ�ʹ�� 2021-02-04 yangsj
			if(confirm($g("�Ѵ�����ͬ�Ĵ����������,�Ƿ��������������¼?"))==false)  return ;
			var updflag=0;
			if(retflag>0) updflag=1;
			var ret=tkMakeServerCall("web.DHCST.APCVendor","UpdateUniversal",retmsg,updflag,HospId)
			if(ret!=0)
			{
				Msg.info("error",$g("����ͨ�ñ�־ʧ��,�������:")+ret);
			}
			else
			{
				Msg.info("success", $g("����ɹ�!"));
				window.close();
				APCVendorGridDs.load({params:{start:0,limit:APCVendorPagingToolbar.pageSize,sort:'RowId',dir:'DESC',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue(),conditionState:Ext.getCmp('conditionStateField').getValue()}});
			}
			*/
			return;
		}
		Ext.Ajax.request({
			url: APCVendorGridUrl+'?actiontype=insert&data='+encodeURI(data),
			method:'post',
			waitMsg:$g('������...'),
			failure: function(result, request) {
				Msg.info("error",$g("������������!"));
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					var newRowid = jsonData.info;
				
					Msg.info("success", $g("����ɹ�!"));
					window.close();
					APCVendorGridDs.load({params:{start:0,limit:APCVendorPagingToolbar.pageSize,sort:'RowId',dir:'DESC',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue(),conditionState:Ext.getCmp('conditionStateField').getValue()}});
				}else{
					if(jsonData.info==-1){
						Msg.info("error",$g("���ƺʹ����ظ�!"));
					}else if(jsonData.info==-2){
						Msg.info("error",$g("�����ظ�!"));
					}else if(jsonData.info==-3){
						Msg.info("error",$g("�����ظ�!"));
					}else if(jsonData.info==-6){
						Msg.info("error",$g("�˴����Ѵ���������ϵͳ,���ó�ͨ��!"));
					}else if(jsonData.info==-7){
						Msg.info("error",$g("�������Ѵ���������ϵͳ,���ó�ͨ��!"));
					}else{
						Msg.info("error", $g("����ʧ��!"));
					}
				}
			},
			scope: this
		});	
	}
	//���¹�Ӧ��
	function UpdVendorInfo(data)
	{
		var retstr=tkMakeServerCall("web.DHCST.APCVendor","CheckVendorBeforeUpdate",data,HospId)
		var retflag=retstr.split("^")[0];
		var retmsg=retstr.split("^")[1];
		if(retflag=="-1")
		{
			Msg.info("error",retmsg);
			return;
		}
		else if((retflag=="-2")||(retflag>0))
		{
			if(confirm($g("�Ѵ�����ͬ�Ĵ����������,�Ƿ����ϱ����޸ļ�¼,����ԭ�м�¼?"))==false)  return ;
			var updflag=0;
			if(retflag>0) updflag=1;
			var ret=tkMakeServerCall("web.DHCST.APCVendor","UpdateVendor",data,retmsg,updflag,HospId);
			var flag=ret.split("^")[0];
			var msg=ret.split("^")[1];
			if(flag!=0)
			{
				Msg.info("error",$g("����ʧ��,������Ϣ:")+msg);
			}
			else
			{
				Msg.info("success",$g( "���³ɹ�!"));
				APCVendorGridDs.load({params:{start:APCVendorPagingToolbar.cursor,limit:APCVendorPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue(),conditionState:Ext.getCmp('conditionStateField').getValue()}});
				window.close();			
			}
			return;
		}
		
		Ext.Ajax.request({
			url:APCVendorGridUrl+'?actiontype=update',
			params:{data:data},
			waitMsg:$g('������...'),
			failure:function(result, request) {
				Msg.info("error",$g("������������!"));
			},
			success:function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if(jsonData.success=='true'){
					Msg.info("success",$g("���³ɹ�!"));
					APCVendorGridDs.load({params:{start:APCVendorPagingToolbar.cursor,limit:APCVendorPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue(),conditionState:Ext.getCmp('conditionStateField').getValue()}});
					window.close();
				}else{
					if (jsonData.info==-1) {
						Msg.info("error",$g("���ƺʹ����ظ�!"));
					} else if (jsonData.info==-2){
						Msg.info("error",$g("�����ظ�!"));
					} else if (jsonData.info==-3){
						Msg.info("error",$g("�����ظ�!"));
					} else{
						Msg.info("error",$g("����ʧ��!"));
					}
				}
			},
			scope: this
		});	
	}	
	
}

var addAPCVendor = new Ext.Toolbar.Button({
	text:$g('�½�'),
    tooltip:$g('�½�'),
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
	
		CreateEditWin('');
	}
});


var editAPCVendor = new Ext.Toolbar.Button({
	text:$g('�༭'),
    tooltip:$g('�༭'),
    iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		
		var rowObj = APCVendorGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error",$g("��ѡ������!"));
			return false;
		}else{
			var rowid = rowObj[0].get('RowId');
		
			
		CreateEditWin(rowid);
		//������ʾ
		}
    }
});

var HospWinButton = GenHospWinButton("APC_Vendor");
//�󶨵���¼�
HospWinButton.on("click" , function(){
	var rowObj = APCVendorGrid.getSelectionModel().getSelections(); 
	if (rowObj.length===0){
		Msg.info("warning",$g("��ѡ������!"));
		return;	
	}
	var rowID=rowObj[0].get("RowId")||'';
	if (rowID===''){
		Msg.info("warning",$g("���ȱ�������!"));
		return;	
	}
    GenHospWin("APC_Vendor",rowID,function(){APCVendorGridDs.reload();}).show()   
});

var HospPanel = InitHospCombo('APC_Vendor',function(combo, record, index){
	HospId = this.value; 
	APCVendorGridDs.reload();
});

var formPanel = new Ext.form.FormPanel({
	labelWidth : 80,
	autoScroll:true,
	labelAlign : 'right',
	autoHeight:true,
	frame : true,
    tbar:[findAPCVendor,'-',addAPCVendor,'-',editAPCVendor,'-',SaveAsBT,'-',HospWinButton],
	items : [{
		xtype : 'fieldset',
		title : $g('��ѯ����'),
		layout : 'column',	
		style:DHCSTFormStyle.FrmPaddingV,
		defaults: {border:false}, 
		items : [{
				columnWidth : .33,
				xtype : 'fieldset',
				items : [conditionCodeField]
			}, {
				columnWidth : .33,
				xtype : 'fieldset',
				items : [conditionNameField]
			}, {
				columnWidth : .33,
				xtype : 'fieldset',
				items : [conditionStateField]
			}]
	}]

});

//��ҳ������
var APCVendorPagingToolbar = new Ext.PagingToolbar({
    store:APCVendorGridDs,
	pageSize:40,
    displayInfo:true,
    displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
    emptyMsg:$g("û�м�¼"),
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='RowId';
		B[A.dir]='DESC';
		B['conditionCode']=Ext.getCmp('conditionCodeField').getValue();
		B['conditionName']=Ext.getCmp('conditionNameField').getValue();
		B['conditionState']=Ext.getCmp('conditionStateField').getValue();
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
APCVendorGrid = new Ext.grid.EditorGridPanel({
	store:APCVendorGridDs,
	cm:APCVendorGridCm,
	title:$g('��Ӧ����ϸ'),
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
	loadMask:true,
	bbar:APCVendorPagingToolbar,
	listeners:{
	'rowdblclick':function(){
	
		editAPCVendor.handler();}
	}
});

APCVendorGridDs.load({params:{start:0,limit:APCVendorPagingToolbar.pageSize,sort:'RowId',dir:'DESC',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue(),conditionState:Ext.getCmp('conditionStateField').getValue()}});
//=========================��Ӧ�����=============================



	
//===========ģ����ҳ��===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:$g('��Ӧ��ά��'),
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(1),
		layout:'fit',
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[
			{
				region:'north',
				height:'500px',
				items:[HospPanel,panel]
			},APCVendorGrid
		],
		renderTo:'mainPanel'
	});
});
	
//===========ģ����ҳ��===========================================