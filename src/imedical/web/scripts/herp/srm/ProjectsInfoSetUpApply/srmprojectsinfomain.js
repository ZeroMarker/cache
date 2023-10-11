var userdr = session['LOGON.USERID']; 
//��ʼʱ��ؼ�
var startTime = new Ext.form.DateField({
		id : 'startTime',
		format : 'Y-m-d',
		width : 120,
		emptyText : ''
	});
	//����ʱ��ؼ�
var endTime = new Ext.form.DateField({
		id : 'endTime',
		format : 'Y-m-d',
		width : 120,
		emptyText : ''
	});
//��ȡ��������
	var deptnameDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
    deptnameDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:'herp.srm.srmprojectsinfoexe.csp'+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('deptnameField').getRawValue()),method:'POST'});
	});
var deptnameField = new Ext.form.ComboBox({
		id: 'deptnameField',
		fieldLabel: '����',
		width:100,
		listWidth : 100,
		store: deptnameDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ�����...',
		name: 'deptnameField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
/////////////������Դ
var sourceDs= new Ext.data.Store({
	proxy:'',
	reader: new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	},['rowid','Name'])
});
sourceDs.on('beforeload',function(ds,o){
	ds.proxy= new Ext.data.HttpProxy({
		url:'herp.srm.srmprojectsinfoexe.csp'+'?action=sourceList&str='+encodeURIComponent(Ext.getCmp('sourceField').getRawValue()),
		method:'POST'
	});
});
var sourceField = new Ext.form.ComboBox({
		id: 'sourceField',
		fieldLabel: '������Դ',
		width:200,
		listWidth : 200,
		store: sourceDs,
		valueField: 'rowid',
		displayField: 'Name',
		triggerAction: 'all',
		emptyText:'��ѡ�������Դ...',
		name: 'sourceField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
var projStatus= new Ext.data.SimpleStore({
	fields : ['key', 'keyValue'],
	data : [ ['1', '����'],['2','ִ��']]
});
var projStatusField = new Ext.form.ComboBox({
				fieldLabel : '��Ŀ״̬',
				width : 120,
				listWidth : 120,
				selectOnFocus : true,
				allowBlank : false,
				store : projStatus,
				anchor : '90%',
				value:'1', //Ĭ��ֵ
				valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				triggerAction : 'all',
				emptyText : '',
				mode : 'local', // ����ģʽ
				editable : false,
				pageSize : 10,
				minChars : 1,
				selectOnFocus : true,
				forceSelection : true
			});
/////////////���⸺����
var headerDs= new Ext.data.Store({
	proxy:'',
	reader: new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	},['rowid','name'])
});
headerDs.on('beforeload',function(ds,o){
	ds.proxy= new Ext.data.HttpProxy({
		url:'herp.srm.srmprojectsinfoexe.csp'+'?action=applyerList&str='+encodeURIComponent(Ext.getCmp('headerField').getRawValue()),
		method:'POST'
	});
});
var headerField = new Ext.form.ComboBox({
		id: 'headerField',
		fieldLabel: '���⸺����',
		width:120,
		listWidth : 120,
		store: headerDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ����⸺����...',
		name: 'headerField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
// ///////////////////��������
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});	
function srmFundApply(){
	
		var startdate= startTime.getValue();

	    if (startdate!=="")
	    {
	       startdate=startdate.format ('Y-m-d');
	    }
	    
		var enddate=endTime.getValue();
		if(enddate!=="")
			{
			enddate=enddate.format('Y-m-d');
			}
		var deptDr= deptnameField.getValue();
	    var sourceDr= sourceField.getValue();
		var projStatus =projStatusField.getValue();
		var header= headerField.getValue();
	    var name = titleText.getValue(); 
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,  
			sortField:'', 
			sortDir:'' ,
		    startDate:startdate,
		    endDate:enddate,
		    deptDr:deptDr,
		    source:sourceDr,
			projStatus:projStatus,
			header:header,
		    name:name
		   }
	  });
  }
var queryPanel = new Ext.FormPanel({
			height:150,
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
				items:[{
				xtype: 'panel',
				layout:"column",
				items: [
					     {   
						xtype:'displayfield',
						value:'<center><p style="font-weight:bold;font-size:150%">��Ŀ����</p></center>',
						columnWidth:1,
						height:'50'
					 }]
			    },{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'����ʱ��:',
						columnWidth:.12
					},
					startTime,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.06
					},{
						xtype:'displayfield',
						value:'��:',
						columnWidth:.08
					},
					endTime,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.1
					},{
						xtype:'displayfield',
						value:'����:',
						columnWidth:.1
					},
					deptnameField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.1
					},
					{
						xtype:'displayfield',
						value:'������Դ:',
						columnWidth:.1
					},
					sourceField
					]
			    },{
				xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'��Ŀ״̬:',
						columnWidth:.092
					},
					projStatusField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.04
					},
					{
						xtype:'displayfield',
						value:'���⸺����:',
						columnWidth:.1
					},
					headerField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.04
					},
					{
						xtype:'displayfield',
						value:'��������:',
						columnWidth:.08
					},
					titleText,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.04
					},
					{
						columnWidth:0.05,
						xtype:'button',
						text: '��ѯ',
						handler:function(b){
							srmFundApply();
						},
						iconCls: 'add'
					}		
				]
			}
			]
		});
		//������׼����ֻ����������
var grafundsField = new Ext.form.NumberField({
	id: 'grafundsField',
	fieldLabel: '��׼���',
	width:90,
	allowBlank: false,
	emptyText:'',
	name: 'grafundsField',
	editable:true
});

var itemGrid = new dhc.herp.Grid({
		    region : 'center',
		    url: 'herp.srm.srmprojectsinfoexe.csp',
		    atLoad : true, // �Ƿ��Զ�ˢ��
		   
			fields : [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '����ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'deptname',
						header : '����',
						editable:false,
						align:'center',
						width : 80,
						dataIndex : 'deptname'
					},{
						id : 'pname',
						header : '��������',
						width : 120,
						align:'center',
						editable:false,
						dataIndex : 'pname'

					},{
						id : 'headname',
						header : '���⸺����',
						editable:false,
						align:'center',
						width : 120,
						dataIndex : 'headname'

					}, {
						id : 'sex',
						header : '�Ա�',
						editable:false,
						align:'center',
						width : 50,
						dataIndex : 'sex'
					},{
						id : 'birth',
						header : '��������',
						width : 80,
						editable:false,
						align:'center',
						dataIndex : 'birth'
					}, {
						id : 'tname',
						header : '����ְ��',
						width : 100,
						align:'center',
						editable : false,
						dataIndex : 'tname'
						
					},{
						id : 'phone',
						header : '��ϵ�绰',
						width : 90,
						align:'center',
						editable:false,
						dataIndex : 'phone'

					},{
						id : 'email',
						header : '�����ַ',
						width : 120,
						editable:false,
						align:'center',
						dataIndex : 'email'

					},{
						id : 'participants',
						header : '�μ���Ա',
						width : 150,
						editable:false,
						align:'center',
						dataIndex : 'participants'
					},{
						id : 'source',
						header : '������Դ',
						width : 120,
						editable:false,
						align:'center',
						dataIndex : 'source'
					},{
						id : 'relyunit',
						header : '�������е�λ',
						width : 150,
						editable:false,
						align:'center',
						dataIndex : 'relyunit'

					},{
						id : 'appfunds',
						header : '���뾭��(��Ԫ)',
						width : 90,
						editable:false,
						align:'center',
						dataIndex : 'appfunds'
					},{
						id : 'grafunds',
						header : '��׼����(��Ԫ)',
						width : 90,
						//editable:true,
						allowBlank:false,
						align:'center',
						dataIndex : 'grafunds',
						type:grafundsField,//���ö������ֵ�ı���
					   renderer: function(value, cellmeta, record, rowIndex,
								columnIndex, store){
								 if(record.data["projstatus"]!='����'){
								 this.editable=false;
								 return '<span>'+value+'</span>';
								 }else{
								 this.editable=true;
								 return '<span>'+value+'</span>';
								 }
								}
					},{
						id : 'subno',
						header : '������',
						width : 100,
						//editable:true,
						allowBlank:false,
						align:'center',
						dataIndex : 'subno',
						renderer: function(value, cellmeta, record, rowIndex,
								columnIndex, store){
								 if(record.data["projstatus"]!='����'){
								 
								 this.editable=false;
								 //console.log(this.editable+"<-edit"+this.value+"<-value");
								 return '<span>'+value+'</span>';
								 }else{
								 this.editable=true;
								 return '<span>'+value+'</span>';
								 }
								}
					}
					,{
						id : 'issuedDate',
						header : '�����´�ʱ��',
						width : 100,
						//editable:true,
						allowBlank:false,
						align:'center',
						emptyText : '',
						dataIndex : 'issuedDate',
						type: "dateField",
						dateFormat: 'Y-m-d',
						renderer: function(value, cellmeta, record, rowIndex,
								columnIndex, store){
								 if(record.data["projstatus"]!='����'){
								 this.editable=false;
								 return '<span>'+value+'</span>';
								 }else{
								 this.editable=true;
								 return '<span>'+value+'</span>';
								 }
								}
					},{
						id : 'subDate',
						header : '����ʱ��',
						width : 100,
						editable:false,
						align:'center',
						dataIndex : 'subDate'
					},
					{
						id : 'startDate',
						header : '��ʼʱ��',
						width : 100,
						editable:false,
						align:'center',
						dataIndex : 'startDate'
					}
					,{
						id : 'endDate',
						header : '��ֹʱ��',
						width : 100,
						editable:false,
						align:'center',
						dataIndex : 'endDate'
					},{
						id : 'remark',
						header : '��ע',
						width : 100,
						editable:false,
						align:'center',
						dataIndex : 'remark'
					},{
						id : 'projstatus',
						header : '��Ŀ״̬',
						width : 100,
						editable:false,
						align:'center',
						dataIndex : 'projstatus'
					}]					
		});
		itemGrid.btnResetHide(); 	//�������ð�ť
        itemGrid.btnDeleteHide(); //����ɾ����ť
        itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
        itemGrid.btnAddHide(); 	//�������ð�ť
        itemGrid.btnSaveHide(); 	//�������ð�ť

var setup = new Ext.Toolbar.Button({
	    text: '����',  
        iconCls:'option',
        handler:function(){
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ���������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("projstatus")=="ִ��")
		 {
			      Ext.Msg.show({title:'ע��',msg:rowObj[j].get("pname")+'������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		//û�и�ѡ�������� ���Բ���forѭ��
		for(var i= 0; i < len; i++){
		   var rowid=rowObj[i].get("rowid");
		   var subno=rowObj[i].get("subno");
		   var issuedDate=rowObj[i].get("issuedDate");
		   if (issuedDate!=""&&issuedDate!=null){
				issuedDate=issuedDate.format('Y-m-d');
			}
		   var grafunds=rowObj[i].get("grafunds");
		    if(subno==""||subno==null||issuedDate==""||issuedDate==null||grafunds==""||grafunds==null){
				Ext.Msg.show({title:'����',msg:'�����š���׼���ѡ������´�ʱ�������д!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			    return;
		    }
		   /* if(isNaN(grafunds)){
		     Ext.Msg.show({title:'����',msg:'��׼����ֻ��������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		     return;
		    }*/
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    var rowid=rowObj[i].get("rowid");
						var subno=rowObj[i].get("subno");
						var issuedDate=rowObj[i].get("issuedDate");
					    if (issuedDate!=""&&issuedDate!=null){
							issuedDate=issuedDate.format('Y-m-d');
						}
						var grafunds=rowObj[i].get("grafunds");
					    Ext.Ajax.request({
						url:'herp.srm.srmprojectsinfoexe.csp?action=setup&rowid='+rowid+'&subno='+subno+'&issuedDate='+issuedDate+'&grafunds='+grafunds,
						waitMsg:'�ύ��...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'�ύ�ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});	
								itemGrid.load({params:{start:0, limit:12}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'�ύʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ������?',handler);
    }
});
var refuse = new Ext.Toolbar.Button({
	    text: '��ͨ��',  
        iconCls:'option',
        handler:function(){
		//���岢��ʼ���ж���
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//���岢��ʼ���ж��󳤶ȱ���
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ��ͨ��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("projstatus")=="ִ��")
		 {
			      Ext.Msg.show({title:'ע��',msg:rowObj[j].get("pname")+'��ͨ������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    var rowid=rowObj[i].get("rowid");
					    Ext.Ajax.request({
						url:'herp.srm.srmprojectsinfoexe.csp?action=refuse&rowid='+rowid,
						waitMsg:'�ύ��...',
						failure: function(result, request){
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'ע��',msg:'�ύ�ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:12}});
								
							}else{
								Ext.Msg.show({title:'����',msg:'�ύʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷ�ϲ�ͨ����?',handler);
    }
});
		itemGrid.addButton(setup);
		itemGrid.addButton(refuse);