// ����:�����̹���
// ��д����:2012-05-10

//=========================���������=============================
var conditionCodeField = new Ext.form.TextField({
	id:'conditionCodeField',
	fieldLabel:'����',
	allowBlank:true,
	//width:180,
	listWidth:180,
	//emptyText:'����...',
	anchor:'90%',
	selectOnFocus:true
});
	
var conditionNameField = new Ext.form.TextField({
	id:'conditionNameField',
	fieldLabel:'����',
	allowBlank:true,
	//width:150,
	listWidth:150,
	//emptyText:'����...',
	anchor:'90%',
	selectOnFocus:true
});

var PhManfStore = new Ext.data.SimpleStore({
	fields:['key', 'keyValue'],
	data:[["O",'����'], ["I",'���']]
});
	
var PhManfGrid="";
//��������Դ
var PhManfGridUrl = 'dhcst.phmanfaction.csp';
var PhManfGridProxy= new Ext.data.HttpProxy({url:PhManfGridUrl+'?actiontype=query',method:'POST'});
var PhManfGridDs = new Ext.data.Store({
	proxy:PhManfGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results',
        pageSize:35
    }, [
		{name:'RowId'},
		{name:'Code'},
		{name:'Name'},
		{name:'Address'},
		{name:'Tel'},
		{name:'AddManfId'},
		{name:'ParManfId'},
		{name:'ParManf'},
		{name:'DrugProductP'},
		{name:'DrugProductExp'},
		{name:'MatProductP'},
		{name:'MatProductExp'},
		{name:'ComLic'},
		{name:'ComLicDate'},
		{name:'Active'}
	]),
    remoteSort:false
});

//ģ��
var PhManfGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"����",
        dataIndex:'Code',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"����",
        dataIndex:'Name',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"��ַ",
        dataIndex:'Address',
        width:200,
        align:'left',
        sortable:false
    },{
        header:"�绰",
        dataIndex:'Tel',
        width:100,
        align:'left',
        sortable:false
    },{
        header:"�ϼ�����",
        dataIndex:'ParManf',
        width:150,
        align:'left',
        sortable:false
    },{
        header:"ҩ���������",
        dataIndex:'DrugProductP',
        width:120,
        align:'left',
        sortable:false
    },{
        header:"ҩ�����������Ч��",
        dataIndex:'DrugProductExp',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�����������",
        dataIndex:'MatProductP',
        width:120,
        align:'left',
        sortable:false
    },{
        header:"�������������Ч��",
        dataIndex:'MatProductExp',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"����ִ�����",
        dataIndex:'ComLic',
        width:120,
        align:'left',
        sortable:false
    },{
        header:"����ִ�������Ч��",
        dataIndex:'ComLicDate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"�����ʶ",
        dataIndex:'Active',
        width:80,
        align:'left',
        sortable:true,
		renderer : function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    }
]);

//��ʼ��Ĭ��������
PhManfGridCm.defaultSortable = true;

var findPhManf = new Ext.Toolbar.Button({
	text:'��ѯ',
    tooltip:'��ѯ',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var conditionCode = Ext.getCmp('conditionCodeField').getValue();
		var conditionName=Ext.getCmp('conditionNameField').getValue();
		PhManfGridDs.load({params:{start:0,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:conditionCode,conditionName:conditionName},			callback : function(r,options, success) {					//Store�쳣��������
			if(success==false){
				Msg.info("error", "��ѯ������鿴��־!");
				//DrugInfoGrid.loadMask.hide();

				//return "{results:0,rows:[]}";
			}         				
		}});
	}
});

// ��水ť
var SaveAsBT = new Ext.Toolbar.Button({
	text : '���',
	tooltip : '���ΪExcel',
	iconCls : 'page_excel',
	width : 70,
	height : 30,
	handler : function() {
		ExportAllToExcel(PhManfGrid);
	}
});
//���̱༭����
//zdm,2013-03-06
function CreateEditWin(rowid){
	
	//���̴���
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel:'<font color=red>���̴���</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'���̴���...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('codeField').getValue()==""){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'����',msg:'���̴��벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						nameField.focus();
					}
				}
			}
		}
	});
	
	//��������
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel:'<font color=red>��������</font>',
		allowBlank:false,
		width:200,
		listWidth:200,
		//emptyText:'��������...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('nameField').getValue()==""){
						Handler = function(){nameField.focus();}
						Ext.Msg.show({title:'����',msg:'�������Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						addressField.focus();
					}
				}
			}
		}
	});
	
	//���̵�ַ
	var addressField = new Ext.form.TextField({
		id:'addressField',
		fieldLabel:'���̵�ַ',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'���̵�ַ...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
						phoneField.focus();
				}
			}
		}
	});
	
	//���̵绰
	var phoneField = new Ext.form.TextField({
		id:'phoneField',
		fieldLabel:'���̵绰',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'���̵绰...',
		anchor:'90%',
		regex:/^[^\u4e00-\u9fa5]{0,}$/,
		regexText:'����ȷ�ĵ绰����',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
						lastPhManfField.focus();
				}
			}
		}
	});
	//�ϼ�����
	var lastPhManfField = new Ext.ux.ComboBox({
		id:'lastPhManfField',
		fieldLabel:'�ϼ�����',
		width:298,
		listWidth:298,
		allowBlank:true,
		store:PhManufacturerStore,
		valueField:'RowId',
		displayField:'Description',
		filterName: 'PHMNFName',
		//emptyText:'�ϼ�����...',
		triggerAction:'all',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:true,
		editable:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
						drugProductPermitField.focus();
				}
			}
		}
	});
	
	//ҩ���������
	var drugProductPermitField = new Ext.form.TextField({
		id:'drugProductPermitField',
		fieldLabel:'ҩ���������',
		width:200,
		listWidth:200,
		//emptyText:'ҩ���������...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('drugProductPermitField').getValue()==""){
						Handler = function(){drugProductPermitField.focus();}
						Ext.Msg.show({title:'����',msg:'ҩ��������ɲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						drugProductExpDate.focus();
					}
				}
			}
		}
	});
	
	//ҩ�����������Ч��
	var drugProductExpDate = new Ext.ux.DateField({ 
		id:'drugProductExpDate',
		fieldLabel:'ҩ�����������Ч��',  
		allowBlank:true,
		width:298,
		listWidth:298,    
		format:App_StkDateFormat,        
		//emptyText:'ҩ�����������Ч�� ...',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('drugProductExpDate').getValue()==""){
						Handler = function(){drugProductExpDate.focus();}
						Ext.Msg.show({title:'����',msg:'ҩ�����������Ч�ڲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						matProductPermitField.focus();
					}
				}
			}
		}      
	});  
	
	//�����������
	var matProductPermitField = new Ext.form.TextField({
		id:'matProductPermitField',
		fieldLabel:'�����������',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'�����������...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('matProductPermitField').getValue()==""){
						Handler = function(){matProductPermitField.focus();}
						Ext.Msg.show({title:'����',msg:'����������ɲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						matProductExpDate.focus();
					}
				}
			}
		}
	});
	
	//�������������Ч��
	var matProductExpDate = new Ext.ux.DateField({ 
		id:'matProductExpDate',
		fieldLabel:'�������������Ч��',  
		allowBlank:true,
		width:298,
		listWidth:298,       
		format:App_StkDateFormat,        
		//emptyText:'�������������Ч�� ...',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('matProductExpDate').getValue()==""){
						Handler = function(){matProductExpDate.focus();}
						Ext.Msg.show({title:'����',msg:'�������������Ч�ڲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						comLicField.focus();
					}
				}
			}
		}        
	});
	
	//����ִ�����
	var comLicField = new Ext.form.TextField({
		id:'comLicField',
		fieldLabel:'����ִ�����',
		allowBlank:true,
		width:200,
		listWidth:200,
		//emptyText:'����ִ�����...',
		anchor:'90%',
		selectOnFocus:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('comLicField').getValue()==""){
						Handler = function(){comLicField.focus();}
						Ext.Msg.show({title:'����',msg:'����ִ����ɲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						comLicExpDate.focus();
					}
				}
			}
		}
	});
	
	//����ִ�������Ч��
	var comLicExpDate = new Ext.ux.DateField({ 
		id:'comLicExpDate',
		fieldLabel:'����ִ�������Ч��',  
		allowBlank:true,
		width:298,
		listWidth:298,       
		format:App_StkDateFormat,        
		//emptyText:'����ִ�������Ч�� ...',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(Ext.getCmp('comLicExpDate').getValue()==""){
						Handler = function(){comLicExpDate.focus();}
						Ext.Msg.show({title:'����',msg:'����ִ�������Ч�ڲ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler,width:250});
					}else{
						activeField.focus();
						activeField.setValue(true);
					}
				}
			}
		}        
	});
	
	//����
	var activeField = new Ext.form.Checkbox({
		id: 'activeField',
		fieldLabel:'����',
		hideLabel:false,
		allowBlank:false,
		checked:true,  //Ĭ����"����"״̬
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					editButton.focus();
				}
			}
		}
	});
	
	//��ʼ�����
	editForm = new Ext.form.FormPanel({
		baseCls:'x-plain',
		labelWidth:130,
		labelAlign : 'right',
		autoScroll:true,
		items:[
			codeField,
			nameField,
			addressField,
			phoneField,
			lastPhManfField,
			drugProductPermitField,
			drugProductExpDate,
			matProductPermitField,
			matProductExpDate,
			comLicField,
			comLicExpDate,
			activeField
		]
	});
	
	//��ʼ����Ӱ�ť
	editButton = new Ext.Toolbar.Button({
		text:'ȷ��',
		iconCls:'page_save',
		handler:function(){
			if(rowid==""){
				addHandler();
			}
			else{
				var ret2=confirm("�Ƿ����ɳ�����ʷ��Ϣ?");
				if (ret2==true){
					editHistoryHandler();
				}else{
				    editHandler();
				}
					
			}
		}
	});
	//��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��',
		iconCls:'page_close'
	});
	
	//����ȡ����ť����Ӧ����
	cancelHandler = function(){
		win.close();
	};
	
	//���ȡ����ť�ļ����¼�
	cancelButton.addListener('click',cancelHandler,false);
	//��ʼ������
	var win = new Ext.Window({
		title:'����ά��',
		width:500,
		height:440,
		minWidth:500,
		minHeight:405,
		layout:'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items:editForm,
		buttons:[
			editButton,
			cancelButton
		],
		listeners:{
			'show':function(thisWin){
				Select(rowid);
			}
		}
	});

	win.show();
	//����
	var addHandler = function(){
		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var drugProductPermit = drugProductPermitField.getValue();
		var drugProductExpDate = Ext.getCmp('drugProductExpDate').getValue()
		if (drugProductExpDate!='') drugProductExpDate=drugProductExpDate.format(App_StkDateFormat);
		
		var matProductPermit = matProductPermitField.getValue();
		var matProductExpDate = Ext.getCmp('matProductExpDate').getValue()
		if (matProductExpDate!='') matProductExpDate=matProductExpDate.format(App_StkDateFormat);

		var comLic = comLicField.getValue();
		var comLicExpDate = Ext.getCmp('comLicExpDate').getValue()
		if (comLicExpDate!='') comLicExpDate=comLicExpDate.format(App_StkDateFormat);		
		
		var active = (activeField.getValue()==true)?'Y':'N';
		
		if(code.trim()==""){
			Msg.info('warning',"���̴��벻��Ϊ��");
			return;
		};
		
		if(name.trim()==""){
			Msg.info('warning',"�������Ʋ���Ϊ��");
			return;
		};
		
		/*
		if(drugProductPermit.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'ҩ���������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(drugProductExpDate==""){
			Ext.Msg.show({title:'��ʾ',msg:'ҩ�����������Ч��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductPermit.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'�����������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductExpDate==""){
			Ext.Msg.show({title:'��ʾ',msg:'�������������Ч��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLic.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'����ִ�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLicExpDate==""){
			Ext.Msg.show({title:'��ʾ',msg:'����ִ�������Ч��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		*/
		
		
		//ƴdata�ַ���
		var data=code+"^"+name+"^"+address+"^"+phone+"^"+lastPhManfId+"^"+drugProductPermit+"^"+drugProductExpDate+"^"+matProductPermit+"^"+matProductExpDate+"^"+comLic+"^"+comLicExpDate+"^"+active;
		var retstr=tkMakeServerCall("web.DHCST.ItmManf","CheckManfBeforeInsert",data,HospId)
		var retflag=retstr.split("^")[0];
		var retmsg=retstr.split("^")[1];
		if(retflag==-1)
		{
			Msg.info("error",retmsg);
			return;
		}
		else if((retflag>0)||(retflag==-2))
		{
			if(confirm("�Ѵ�����ͬ�Ĵ����������,�Ƿ��������������¼,����ԭ�м�¼?")==false)  return ;
			var updflag=0;
			if(retflag>0) updflag=1;
			var ret=tkMakeServerCall("web.DHCST.ItmManf","UpdateUniversal",retmsg,updflag)
			if(ret!=0)
			{
				Msg.info("error","����ͨ������ʧ��,�������:"+ret);
			}
			else
			{
				Msg.info("success", "����ɹ�!");
				win.close();
				PhManfGridDs.load({params:{start:0,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue()}});
			}
			return;
		}
		
		Ext.Ajax.request({
			url: PhManfGridUrl+'?actiontype=insert&data='+encodeURIComponent(data),
			method:'post',
			waitMsg:'�½���...',
			failure: function(result, request) {
				Msg.info("error","������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					var newRowid = jsonData.info;
					Msg.info("success", "����ɹ�!");
					win.close();
					PhManfGridDs.load({params:{start:0,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue()}});
				}else{
					if(jsonData.info==-1){
						Msg.info("error","�����ظ�!");
					}else if(jsonData.info==-11){
						Msg.info("error","�����ظ�!");
					}else{
						Msg.info("error", "����ʧ��!");
					}
				}
			},
			scope: this
		});
	};
	
	//�޸�
    var editHandler= function(){
		
		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var drugProductPermit = drugProductPermitField.getValue();
		var drugProductExpDate = Ext.getCmp('drugProductExpDate').getValue()
		if (drugProductExpDate!='') {drugProductExpDate=drugProductExpDate.format(App_StkDateFormat);}
		
		var matProductPermit = matProductPermitField.getValue();
		var matProductExpDate = Ext.getCmp('matProductExpDate').getValue()
		if (matProductExpDate!='') {matProductExpDate=matProductExpDate.format(App_StkDateFormat);}
		var comLic = comLicField.getValue();
		var comLicExpDate = Ext.getCmp('comLicExpDate').getValue();
		if (comLicExpDate!='') {comLicExpDate=comLicExpDate.format(App_StkDateFormat);}
		var active = (activeField.getValue()==true)?'Y':'N';
		//alert('0')
		if(code.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'���̴���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(name.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		/*
		if(drugProductPermit.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'ҩ���������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(drugProductExpDate==""){
			Ext.Msg.show({title:'��ʾ',msg:'ҩ�����������Ч��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductPermit.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'�����������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductExpDate==""){
			Ext.Msg.show({title:'��ʾ',msg:'�������������Ч��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLic.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'����ִ�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLicExpDate==""){
			Ext.Msg.show({title:'��ʾ',msg:'����ִ�������Ч��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		*/
		//ƴdata�ַ���
		var data=rowid+"^"+code+"^"+name+"^"+address+"^"+phone+"^"+lastPhManfId+"^"+drugProductPermit+"^"+drugProductExpDate+"^"+matProductPermit+"^"+matProductExpDate+"^"+comLic+"^"+comLicExpDate+"^"+active+"^";
		var retstr=tkMakeServerCall("web.DHCST.ItmManf","CheckManfBeforeUpdate",data,HospId)
		var retflag=retstr.split("^")[0];
		var retmsg=retstr.split("^")[1];
		if(retflag==-1)
		{
			Msg.info("error",retmsg);
			return;
		}
		else if((retflag>0)||(retflag==-2))
		{
			if(confirm("�Ѵ�����ͬ�Ĵ����������,�Ƿ���������޸ļ�¼,����ԭ�м�¼?")==false)  return ;
			var updflag=0;
			if(retflag>0) updflag=1;
			var ret=tkMakeServerCall("web.DHCST.ItmManf","UpdateManf",data,retmsg,updflag)
			var flag=ret.split("^")[0];
			var msg=ret.split("^")[1];
			if(flag!=0)
			{
				Msg.info("error","����ͨ������ʧ��,������Ϣ:"+msg);
			}
			else
			{
				Msg.info("success", "���³ɹ�!");
				win.close();
				PhManfGridDs.load({params:{start:0,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue()}});
			}
			return;
		}
		Ext.Ajax.request({
			url:PhManfGridUrl+'?actiontype=update&data='+encodeURIComponent(data)+'&histype=',
			waitMsg:'������...',
			failure:function(result, request) {
				Msg.info("error","������������!");
			},
			success:function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if(jsonData.success=='true'){
					Msg.info("success","���³ɹ�!");
					PhManfGridDs.load({params:{start:PhManfPagingToolbar.cursor,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue()}});
					win.close();
				}else{
					if(jsonData.info==-1){
						Msg.info("error","�����ظ�!");
					}
					if(jsonData.info==-11){
						Msg.info("error","�����ظ�!");
					}
				}
			},
			scope: this
		});
	};
	var editHistoryHandler= function(){
		
		var code = codeField.getValue();
		var name = nameField.getValue();
		var address = addressField.getValue();
		var phone = phoneField.getValue();
		var lastPhManfId = lastPhManfField.getValue();
		var drugProductPermit = drugProductPermitField.getValue();
		var drugProductExpDate = Ext.getCmp('drugProductExpDate').getValue()
		if (drugProductExpDate!='') {drugProductExpDate=drugProductExpDate.format(App_StkDateFormat);}
		
		var matProductPermit = matProductPermitField.getValue();
		var matProductExpDate = Ext.getCmp('matProductExpDate').getValue()
		if (matProductExpDate!='') {matProductExpDate=matProductExpDate.format(App_StkDateFormat);}
		var comLic = comLicField.getValue();
		var comLicExpDate = Ext.getCmp('comLicExpDate').getValue();
		if (comLicExpDate!='') {comLicExpDate=comLicExpDate.format(App_StkDateFormat);}
		var active = (activeField.getValue()==true)?'Y':'N';
		//alert('0')
		if(code.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'���̴���Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(name.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		/*
		if(drugProductPermit.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'ҩ���������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(drugProductExpDate==""){
			Ext.Msg.show({title:'��ʾ',msg:'ҩ�����������Ч��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductPermit.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'�����������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(matProductExpDate==""){
			Ext.Msg.show({title:'��ʾ',msg:'�������������Ч��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLic.trim()==""){
			Ext.Msg.show({title:'��ʾ',msg:'����ִ�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		
		if(comLicExpDate==""){
			Ext.Msg.show({title:'��ʾ',msg:'����ִ�������Ч��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
			return;
		};
		*/
		//ƴdata�ַ���
		var data=rowid+"^"+code+"^"+name+"^"+address+"^"+phone+"^"+lastPhManfId+"^"+drugProductPermit+"^"+drugProductExpDate+"^"+matProductPermit+"^"+matProductExpDate+"^"+comLic+"^"+comLicExpDate+"^"+active+"^";
		var retstr=tkMakeServerCall("web.DHCST.ItmManf","CheckManfBeforeUpdate",data,HospId)
		var retflag=retstr.split("^")[0];
		var retmsg=retstr.split("^")[1];
		if(retflag==-1)
		{
			Msg.info("error",retmsg);
			return;
		}
		else if((retflag>0)||(retflag==-2))
		{
			if(confirm("�Ѵ�����ͬ�Ĵ����������,�Ƿ���������޸ļ�¼,����ԭ�м�¼?")==false)  return ;
			var updflag=0;
			if(retflag>0) updflag=1;
			var ret=tkMakeServerCall("web.DHCST.ItmManf","UpdateManf",data,retmsg,updflag,"1")
			var flag=ret.split("^")[0];
			var msg=ret.split("^")[1];
			if(flag!=0)
			{
				Msg.info("error","����ͨ������ʧ��,������Ϣ:"+msg);
			}
			else
			{
				Msg.info("success", "����ɹ�!");
				win.close();
				PhManfGridDs.load({params:{start:0,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue()}});
			}
			return;
		}
		Ext.Ajax.request({
			url:PhManfGridUrl+'?actiontype=update&data='+encodeURIComponent(data)+'&histype=1',
			waitMsg:'������...',
			failure:function(result, request) {
				Msg.info("error","������������!");
			},
			success:function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if(jsonData.success=='true'){
					Msg.info("success","���³ɹ�!");
					PhManfGridDs.load({params:{start:PhManfPagingToolbar.cursor,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue()}});
					win.close();
				}else{
					if(jsonData.info==-1){
						Msg.info("error","�����ظ�!");
					}
					if(jsonData.info==-11){
						Msg.info("error","�����ظ�!");
					}
				}
			},
			scope: this
		});
	};
	
	function Select(rowid){
		Ext.Ajax.request({
			url: PhManfGridUrl+'?actiontype=queryByRowId&rowid='+rowid,
			failure: function(result, request) {
				Msg.info("error", "������������!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true') {
					//��ѯ�ɹ�,��ֵ���ؼ�
					var value = jsonData.info;
					var arr = value.split("^");
					Ext.getCmp('codeField').setValue(arr[0]);
					Ext.getCmp('nameField').setValue(arr[1]);
					Ext.getCmp('addressField').setValue(arr[2]);
					Ext.getCmp('phoneField').setValue(arr[3]);
					Ext.getCmp('lastPhManfField').setValue(arr[5]);
					Ext.getCmp('lastPhManfField').setRawValue(arr[6]);
					Ext.getCmp('drugProductPermitField').setValue(arr[7]);
					Ext.getCmp('drugProductExpDate').setValue(arr[8]);
					Ext.getCmp('matProductPermitField').setValue(arr[9]);
					Ext.getCmp('matProductExpDate').setValue(arr[10]);
					Ext.getCmp('comLicField').setValue(arr[11]);
					Ext.getCmp('comLicExpDate').setValue(arr[12]);
					Ext.getCmp('activeField').setValue((arr[13]=="Y")?true:false);
					//s Data1=Code_"^"_Name_"^"_Address_"^"_Tel_"^"_ManfAddId_"^"_$g(ParManfId)_"^"_$g(ParManf)_"^"_$g(DrugProductP)_"^"_$g(DrugProductE)_"^"_$g(MatProductP)_"^"_$g(MatProductE)_"^"_$g(ComLic)_"^"_$g(ComLicDate)_"^"_Active
				}else{
					Msg.info("error", "��ѯʧ��!" +newRowid);
				}
			},
			scope: this
		});
	}
}

var addPhManf = new Ext.Toolbar.Button({
	text:'�½�',
    tooltip:'�½�',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){

		//������ʾ
		CreateEditWin("");
	}
});
		
var editPhManf = new Ext.Toolbar.Button({
	text:'�༭',
    tooltip:'�༭',
    id:'EditManfBt',
    iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		var rowObj = PhManfGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error","��ѡ������!");
			return false;
		}else{
					
			CreateEditWin(rowObj[0].get("RowId"));
		}
    }
});
var viewHisManf = new Ext.Toolbar.Button({
	text:'�鿴��ʷ��Ϣ',
    tooltip:'�鿴��ʷ��Ϣ',
    id:'viewHisManf',
    iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		var rowObj = PhManfGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Msg.info("error","��ѡ������!");
			return false;
		}else{
					
			ManfHisSearch(rowObj[0].get("RowId"));
		}
    }
});

var HospWinButton = GenHospWinButton("PH_Manufacturer");

//�󶨵���¼�
HospWinButton.on("click" , function(){
	var rowObj = PhManfGrid.getSelectionModel().getSelections(); 
	if (rowObj.length===0){
		Msg.info("warning","��ѡ������!");
		return;	
	}
	var rowID=rowObj[0].get("RowId")||'';
	if (rowID===''){
		Msg.info("warning","���ȱ�������!");
		return;	
	}
    GenHospWin("PH_Manufacturer",rowID,function(){PhManfGridDs.reload();}).show()   
});

var formPanel = new Ext.form.FormPanel({
	labelWidth : 60,
	labelAlign : 'right',
	frame : true,
	//autoScroll : true,
	autoHeight:true,
    tbar:[findPhManf,'-',addPhManf,'-',editPhManf,'-',SaveAsBT,'-',viewHisManf,'-',HospWinButton],
	items : [{
		xtype : 'fieldset',
		title : '��ѯ����',
		defaults: {border:false},
		style:DHCSTFormStyle.FrmPaddingV,
		layout : 'column',
		items : [{
			columnWidth : .33,
			xtype : 'fieldset',
			items : [conditionCodeField]
		}, {
			columnWidth : .33,
			xtype : 'fieldset',
			items : [conditionNameField]
		}]
	}]
});

//��ҳ������
var PhManfPagingToolbar = new Ext.PagingToolbar({
    store:PhManfGridDs,
	pageSize:35,
    displayInfo:true,
    displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
    emptyMsg:"û�м�¼",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='RowId';
		B[A.dir]='desc';
		B['conditionCode']=Ext.getCmp('conditionCodeField').getValue();
		B['conditionName']=Ext.getCmp('conditionNameField').getValue();
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//���
PhManfGrid = new Ext.grid.EditorGridPanel({
	store:PhManfGridDs,
	title:'������ϸ',
	cm:PhManfGridCm,
	trackMouseOver:true,
	region:'center',
	height:690,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
	loadMask:true,
	bbar:PhManfPagingToolbar,
	listeners:{
		'rowdblclick':function(){
			Ext.getCmp('EditManfBt').handler();
			
		}
	
	}
});

PhManfGridDs.load({params:{start:0,limit:PhManfPagingToolbar.pageSize,sort:'RowId',dir:'desc',conditionCode:Ext.getCmp('conditionCodeField').getValue(),conditionName:Ext.getCmp('conditionNameField').getValue()}});

var HospPanel = InitHospCombo('PH_Manufacturer',function(combo, record, index){
	HospId = this.value; 
	PhManfGridDs.reload();
});

//=========================���������=============================

//===========ģ����ҳ��===============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title:'����ά��',
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
			},PhManfGrid
		],
		renderTo:'mainPanel'
	});
});
//===========ģ����ҳ��===============================================