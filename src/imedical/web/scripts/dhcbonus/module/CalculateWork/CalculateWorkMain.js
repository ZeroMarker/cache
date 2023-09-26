var StratagemTabUrl = '../csp/dhc.bonus.calculateworkexe.csp';
//����������
 var YearMonth = new Ext.ux.MonthField({   
     id:'month',   
     fieldLabel: '�·�',   
     allowBlank:false,   
     readOnly : true,   
     format:'Y-m',   
        listeners:{"blur":function(){   
        //alert(this.getValue()); 
  }}   
});   
	

//����������
var DeptDataStor  = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'DeptCode','DeptName'])
		});

DeptDataStor.on('beforeload',function(ds,o){
    ds.proxy = new Ext.data.HttpProxy({
    url:StratagemTabUrl + '?action=GetDept&str='+DeptFiled.getValue(),
	method : 'POST'
					})
});


var DeptFiled = new Ext.form.ComboBox({
    id:'DeptFiled',
	fieldLabel:'�������',
	width:80,
	listWidth:205,
	anchor : '100%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'DeptName',
	store : DeptDataStor,
	triggerAction : 'all',
	name : 'DeptFiled',
	emptyText:"",
	minChars:1,
	pageSize:10,
	editable:true,
	selectOnFocus : false,
	forceSelection : 'true',
	editable : true
});

//������Ŀ������
var WorkItemStor = new Ext.data.Store({
 autoLoad:true,
 proxy:"",
 reader:new Ext.data.JsonReader({
 totalProperty:'results',
 root:'rows'
 },['rowid','WorkItemCode','WorkItemName'])
});

WorkItemStor.on('beforeload',function(ds,o){
    ds.proxy = new Ext.data.HttpProxy({
    url:StratagemTabUrl + '?action=GetWorkItem',
	method : 'POST'
					})
});

var WorkItemFiled = new Ext.form.ComboBox({
    id:'WorkItemFiled',
	fieldLabel:'������Ŀ',
	width:80,
	listWidth:205,
	anchor : '100%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'WorkItemName',
	store : WorkItemStor,
	triggerAction : 'all',
	name : 'WorkItemFiled',
	emptyText:"",
	minChars:1,
	pageSize:10,
	editable:true,
	selectOnFocus : false,
	forceSelection : 'true',
	editable : true
});

//���ݽӿ�������
var DataInterfStor = new Ext.data.Store({
 autoLoad:true,
 proxy:"",
 reader:new Ext.data.JsonReader({
 totalProperty:'results',
 root:'rows'
 },['rowid','DataInter'])
});

DataInterfStor.on('beforeload',function(ds,o){
    ds.proxy = new Ext.data.HttpProxy({
    url:StratagemTabUrl + '?action=GetInterf',
	method : 'POST'
					})
});



var DataInterFiled = new Ext.form.ComboBox({
    id:'DataInterFiled',
	fieldLabel:'���ݽӿ�',
	width:103,
	listWidth:205,
    anchor : '100%',
	allowBlank:true,
	valueField:'rowid',
	displayField:'DataInter',
	store : DataInterfStor,
	triggerAction : 'all',
	name : 'DataInterFiled',
	emptyText:"",
	minChars:1,
	pageSize:10,
	editable:true,
	selectOnFocus : false,
	forceSelection : 'true',
	editable : true
});

//��ѯ��ť
var FindButton = new Ext.Toolbar.Button({
    text : '��ѯ',
	tooltip : '��ѯ',
	iconCls : 'find',
	handler : function(){
	     var data = YearMonth.getRawValue()+"^"+DeptFiled.getValue()+"^"+WorkItemFiled.getValue();
	     //alert(data);
	     DeptWorkDs.load({
					params:{
							start : 0,
							limit : DeptWorkPagTba.pageSize,
							data:data
							}
					});
	}
});

//���㰴ť
var CalculateButton = new Ext.Toolbar.Button({
    text : '����',
	tooltip : '����',
	iconCls : 'add',
	handler : function(){
	  if(YearMonth.getRawValue()=="")
	  {
	  	Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ���������£�!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		return;
	  }
	 else
	 {
	 	Ext.MessageBox.confirm("����ȷ��",'����Ҫ����'+YearMonth.getRawValue()+"�����ݣ��Ƿ�ȷ�ϼ���?",function(btn){  
         if(btn=='yes')
		 {
		   var data =YearMonth.getRawValue()+"^"+DataInterFiled.getValue()+"^"+DeptFiled.getValue()+"^"+WorkItemFiled.getValue();
	       request('calculat',data);
		   //����ˢ��ҳ��
		   FindButton.handler();
		 }
	
	   });
	 }

	return;
	
	}
});


//�˺�������ǰ��̨����
function request(actions,data){
Ext.Ajax.request({
		//url: StratagemTabUrl+'?action=check&data='+data,
		url: StratagemTabUrl+'?action='+actions+'&data='+data,
		waitMsg : '������...',
		failure : function(result, request) {
			Ext.Msg.show({
						title : '����',
						msg : '������������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
				},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
					flag = jsonData.info;
					Ext.Msg.show({
								    title : 'ע��',
									msg : '�ɹ�!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
											});
					} 
					else {
										Ext.Msg.show({
											title : '����',
											msg : '����',
										    buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
					}
										
		},
	scope : this
  });
return;
}


//��˰�ť
var CheckButton = new Ext.Toolbar.Button({
    text : '���',
	tooltip : '���',
	iconCls : 'add',
	handler : function(){
	  var data = "";
	  var rowObj=DeptWorkGrid.getSelections();
	  if ( YearMonth.getRawValue()=="")
	  {
	     alert("��ѡ��Ҫ��˵�����.....");
	  }
	  else if(YearMonth.getRawValue()!="")
	  {
		   Ext.MessageBox.confirm("���ȷ��",'����Ҫ���'+YearMonth.getRawValue()+"�����ݣ��Ƿ�ȷ�����?",function(btn){  
               if (btn == 'yes') { 
				 data = session['LOGON.USERNAME']+'||'+YearMonth.getRawValue();
				 //alert(data);
				 request('check',data);
				 //����ˢ��ҳ��
		         FindButton.handler();
			} 		   
           });  
	  }
	return;
	}
});



//���ҹ���������  dhc.bonus.targetCollect

var DeptWorkProxy = new Ext.data.HttpProxy({
			url : StratagemTabUrl + '?action=list'
		});
var DeptWorkDs = new Ext.data.Store({
			proxy : DeptWorkProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'YearMonths', 'Dept', 'ProjectClass',
							'WorkItem', 'Counts','Price','Amount', 'DataState', 'Checker',
							'CheckDate', 'CollectDate']),
			// turn on remote sorting
			remoteSort : true
		});                              
var DeptWorkCm = new Ext.grid.ColumnModel([new Ext.grid.CheckboxSelectionModel(), {
			header : 'RowID',
			dataIndex : 'rowid',
			width : 40,
			hidden:'true',
			sortable : true

		}, {
			header : '����',
			dataIndex : 'YearMonths',
			width : 70,
			sortable : true

		}, {
			header : '��������',
			dataIndex : 'Dept',
			width : 100,
			sortable : true
		}, {
			header : '��Ŀ����',
			dataIndex : 'ProjectClass',
			width : 100,
			sortable : true
		}, {
			header : '��������Ŀ',
			dataIndex : 'WorkItem',
			width : 80,
			sortable : true
		}, {
			header : '����',
			dataIndex : 'Counts',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : '����',
			dataIndex : 'Price',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : '���',
			dataIndex : 'Amount',
			width : 90,
			align : 'right',
			sortable : true
		}, {
			header : '����״̬',
			dataIndex : 'DataState',
			width : 80,
			sortable : true
		}, {
			header : '�����',
			dataIndex : 'Checker',
			width : 80,
			sortable : true
		}, {
			header : '���ʱ��',
			align : 'right',
			dataIndex : 'CheckDate',
			width : 80,
			sortable : true
		}, {
			header : '����ʱ��',
			align : 'right',
			dataIndex : 'CollectDate',
			width : 120,
			sortable : true
		}
		]);
		
var DeptWorkPagTba = new Ext.PagingToolbar({
			store : DeptWorkDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '��ǰ��ʾ{0} - {1}������{2}',
			emptyMsg : "û�м�¼"
			// buttons: ['-',StratagemFilterItem,'-',StratagemSearchBox],
		});
	
// ����
 var tbar1 = new Ext.Toolbar(['���ݽӿ�:', DataInterFiled,'-',CalculateButton,'-',CheckButton]); 

var DeptWorkGrid = new Ext.grid.EditorGridPanel({
			title : '���ҹ�����ά��',
			store : DeptWorkDs,
			cm : DeptWorkCm,
			clicksToEdit : 1,
			trackMouseOver : true,
			stripeRows : true,
			sm: new Ext.grid.CheckboxSelectionModel({singleSelect:false}),
			tbar : ['��������:', YearMonth,'-','����:',DeptFiled,'-','������Ŀ:',WorkItemFiled,'-',FindButton,'-',CalculateButton,'-',CheckButton],
			bbar:DeptWorkPagTba,
			loadMask : true
			/*,
			listeners : { 
            'render': function(){ 
            	tbar1.render(DeptWorkGrid.tbar); 
            } 
            
           } */
		}); 