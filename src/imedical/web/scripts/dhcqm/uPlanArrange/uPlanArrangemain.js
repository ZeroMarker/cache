var itemGridUrl = '../csp/dhc.qm.uPlanArrangeexe.csp';
//�������Դ
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var subStop=20;  //��ʾ��ȡ�ַ����ĳ���
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
		'Rowid',
		'Title',
		'qmschemDr',
		'qmschemName',
		'deptGroupDr',
		'deptGroupName',
		'CheckStartDate',
		'CheckEndDate',
		'taskStart',
		'taskEndData',
		'checkUser',
		'checkUserName',
		'Status',
		'statusName'
		
	]),
	remoteSort: true
});
var QMSchemField="";
var nameField="";
//��Ӹ�ѡ��
var sm = new Ext.grid.CheckboxSelectionModel();
var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 15,
	store: itemGridDs,
	atLoad : true,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"//,

});
//����Ĭ�������ֶκ�������
itemGridDs.setDefaultSort('Rowid', 'Title');

var CheckStartDate = new Ext.form.DateField({
	id:'CheckStartDate',
	//format:'Y-m-d',
	fieldLabel:'��ʼʱ��',
	//width:180,
	anchor: '90%',
	disabled:false,
	emptyText: '��ѡ����ʼʱ��...',
	listeners :{
		specialKey :function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				if(startDate.getValue()!=""){
					endDate.focus();
				}else{
					Handler = function(){startDate.focus();}
					Ext.Msg.show({title:'��ʾ',msg:'��ʼʱ�䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
				}
			}
		}
	}
});
		
		//�������ʱ��ؼ�
var CheckEndDate = new Ext.form.DateField({
	id:'CheckEndDate',
	//format:'Y-m-d',
	fieldLabel:'����ʱ��',
	//width:180,
	anchor: '90%',
	disabled:false,
	emptyText: '��ѡ�����ʱ��...',
	listeners :{
		specialKey :function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER){
				if(endDate.getValue()!=""){
					
				}else{
					Handler = function(){endDate.focus();}
					Ext.Msg.show({title:'��ʾ',msg:'����ʱ�䲻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
				}
			}
		}
	}
});
		
		
var userdDs = new Ext.data.Store({   //��������Դ   
	proxy: "",
	reader: new Ext.data.JsonReader({
		totalProperty: 'results',
		root: 'rows'	
	},['grupRowid','grupName'])	
});

userdDs.on('beforeload',function(ds,o){  //����Դ�����������ú�̨�෽����ѯ����
	ds.proxy = new Ext.data.HttpProxy({
		url:'dhc.qm.uPlanArrangeexe.csp'+'?action=userList&str='+encodeURIComponent(Ext.getCmp('userdField').getRawValue()),method:'POST'
	});	
});

var userdField= new Ext.form.ComboBox({   //���嵥λ��Ͽؼ�
	id: 'userdField',
	fieldLabel: '�����',
	store: userdDs,
	anchor: '90%',
	valueNotFoundText:'',
	displayField: 'grupName',
	valueField: 'grupRowid',
	triggerAction: 'all',
	emptyText: '��ѡ��...',
	pageSize: 10,
	minChars: 1,
	
	forceSelection: false	
});
/*var uTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['0', 'δ���'], ['1', '���']]
	});
	var StatusField = new Ext.form.ComboBox({
	    id : 'StatusField',
		fieldLabel : '���״̬',
		width : 100,
		listWidth : 200,
		store : uTypeDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // ����ģʽ
		triggerAction: 'all',
		emptyText:'��ѡ��...',
		selectOnFocus:true,
		forceSelection : true
	});	*/
var tmpTitle='�ƻ���������';

//���ݿ�����ģ��
var itemGridCm = new Ext.grid.ColumnModel([
	{

		id:'Rowid',
		header: 'ID',
		allowBlank: false,
		width:100,
		editable:false,
		dataIndex: 'Rowid',
		hidden:'true'
	   
   }, {
		id:'Title',
		header: '������',
		allowBlank: false,
		width:80,
	   editable:false,
		dataIndex: 'Title'
		
   }, {
		id:'qmschemName',
		header: '�������',
		allowBlank: false,
		width:100,
		editable:false,
		dataIndex: 'qmschemName',
		renderer:function(value,meta,record){
			var dot="";
			 if(value.length>subStop){
					  meta.attr = 'ext:qtitle  ext:qtip="'+value+'"';
					  dot="...";
				  }else{
					
				  }
				return value.substring(0,subStop)+dot; 
			
		}
   },{
		id:'checkUserName',
		header: '�����Ա',
		allowBlank: false,
		width:40,
		editable:false,
		dataIndex: 'checkUserName'
            
   }, {
		id:'checkUser',
		header: '�����ԱID',
		allowBlank: false,
		width:40,
		editable:false,
		dataIndex: 'checkUser',
		hidden:true
            
   },{
		id:'CheckStartDate',
		header: '��ʼ����',
		allowBlank: false,
		width:35,
		editable:false,
		dataIndex: 'CheckStartDate'
            
   }, {
		id:'CheckEndDate',
		header: '��������',
		allowBlank: false,
		width:35,
		editable:false,
		dataIndex: 'CheckEndDate'
            
   },{
		id:'taskStart',
		header: '����ʼ����',
		allowBlank: false,
		width:35,
		editable:false,
		dataIndex: 'taskStart'
		
   },{
		id:'taskEndData',
		header: '�����������',
		allowBlank: false,
		width:35,
		editable:false,
		dataIndex: 'taskEndData'
		
   }, {
		id:'statusName',
		header: '���״̬',
		allowBlank: false,
		width:25,
		editable:false,
		dataIndex: 'statusName'
		
   }, {
		id:'deptGroupName',
		header: '������',
		allowBlank: false,
		//width:100,
		editable:false,
		dataIndex: 'deptGroupName',
		renderer:function(value,meta,record){
			/*if(value!=""){
			 return '<div class="x-grid3-cell-inner x-grid3-col-linker" unselectable="on" ext:qtitle ext:qtip="'+value+'">'+value+'</div>'
			}*/
			var dot="";
			 if(value.length>subStop){
					  meta.attr = 'ext:qtitle  ext:qtip="'+value+'"';
					  dot="...";
				  }else{
					
				  }
				return value.substring(0,subStop)+dot; 
		}
          
    }
			    
]);
//��ѯ����
var SearchButton = new Ext.Toolbar.Button({
    text: '��ѯ', 
    tooltip:'��ѯ',        
    iconCls:'search',
	handler:function(){	
	//alert(userdField.getValue());
	var user=userdField.getRawValue();
	//alert(user);
	if(user!=""){
		var userDr= userdField.getValue();
	}else{
	    var userDr="";
	}
	var CheckStartDate = Ext.getCmp('CheckStartDate').getValue();
    var CheckEndDate = Ext.getCmp('CheckEndDate').getValue();
    if(CheckStartDate!=""){
		CheckStartDate = CheckStartDate.format('Y-m-d');
	}
	if(CheckEndDate!=""){
		CheckEndDate = CheckEndDate.format('Y-m-d');
	}  
	itemGridDs.load(({params:{start:0,limit:itemGridPagingToolbar.pageSize,CheckStartDate:CheckStartDate,CheckEndDate:CheckEndDate,userDr:userDr}}));}
});
var addButton = new Ext.Toolbar.Button({
	text : '�½�',
	tooltip : '�½�',
	iconCls : 'add',
	handler : function() {
		sysorgaffiaddFun(itemGridDs,itemGridPagingToolbar);
	}
});
//2016-6-30 cyl add  �޸İ�ť			
var xiuButton = new Ext.Toolbar.Button({
	text : '�޸�',
	tooltip : '�޸�',
	iconCls : 'edit',
	handler : function() {
		editFun(itemGrid);
	}
});
var editButton = new Ext.Toolbar.Button({
	text : '����',
	tooltip : '����',
	iconCls : 'stop',
	handler : function() {
		var rowObj=itemGrid.getSelectionModel().getSelections();
	    var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ���ϵļ�¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{	
			var rowId = rowObj[0].get("Rowid");
		}
		function handler(id){          
			if(id=="yes"){
                Ext.Ajax.request({
					url:'dhc.qm.uPlanArrangeexe.csp?action=edit&rowId='+rowId,
				
					waitMsg:'������...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
				
					success: function(result, request){
			   		var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'���ϳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});		
					}
					else
					{
						var message="�Ѵ�����ͬ��¼";
						Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					};
			      },
				scope: this
			   });
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('��ʾ','ȷʵҪ���ϸ�����¼��?',handler);
	}

});
				


var itemGrid = new Ext.grid.GridPanel({
	        
	//title: '��Ч��λ��¼',
	region: 'center',
	layout:'fit',
	width: 400,
	readerModel:'local',
	url: 'dhc.qm.uPlanArrange.csp',
	split: true,
	collapsible: true,
	containerScroll: true,
	store: itemGridDs,
	cm: itemGridCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	viewConfig: {forceFit:true},
	tbar: ['��ʼ�ڼ�:','-',CheckStartDate,'�����ڼ� :','-',CheckEndDate,'����� :','-',userdField,'-',SearchButton,'-',addButton,'-',xiuButton,'-',editButton],
	bbar:itemGridPagingToolbar
});
itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});




