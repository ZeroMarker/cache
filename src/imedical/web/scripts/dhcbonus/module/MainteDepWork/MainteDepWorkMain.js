var StratagemTabUrl = '../csp/dhc.bonus.maintedepworkexe.csp';
//����������
 var YearMonth = new Ext.ux.MonthField({   
     id:'month',   
     width:100,
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
	width:120,
	listWidth:205,
	anchor : '100%',
	allowBlank:true,
	valueField:'DeptCode',
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
	fieldLabel:'�����',
	width:120,
	listWidth:205,
	anchor : '100%',
	allowBlank:true,
	valueField:'WorkItemCode',
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
	width:100,
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
	     DeptWorkDs.load({
					params:{
							start : 0,
							limit : DeptWorkPagTba.pageSize,
							data:data
							}
					});
	}
});

//���ݲɼ���ť
var DataCollButton = new Ext.Toolbar.Button({
    text : '���ݲɼ�',
	tooltip : '���ݲɼ�',
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
	 if(DataInterFiled.getValue()=="")
	 {
	 	Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ�����ݽӿڣ�!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		return;
	 }
	var data =YearMonth.getRawValue()+"^"+DataInterFiled.getValue();
	request('collect',data);
	return;
	
	}
});

//Excel���밴ť
var ExcelButton = new Ext.Toolbar.Button({
    text : 'Excel����', 
	tooltip : 'Excel����',
	iconCls : 'add',
	handler : function(){
	importExcel();
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
	  if ( rowObj.length>0)
	  {
	    var rowIdArry = [];
	    for (var i=0;i<rowObj.length;i++)
		 {
		  //rowIdArry.push(rowObj[i].get("rowid"));
		  if(data!="")
		   data = data+'^'+ rowObj[i].get("rowid");
		  else
		   data=rowObj[i].get("rowid");
		 }
		 data='A||'+session['LOGON.USERNAME']+'||'+data;
	     //alert(data);
		 request('check',data);
		 //����ˢ��ҳ��
		 FindButton.handler();
	  }
	  else if(YearMonth.getRawValue()!="")
	  {
	
	    if(DeptFiled.getValue()!=""){
		   Ext.MessageBox.confirm("���ȷ��",'����Ҫ���'+YearMonth.getRawValue()+DeptFiled.getRawValue()+"�����ݣ��Ƿ�ȷ�����?",function(btn){  
              if (btn == 'yes'){ 
			     data = "B||"+session['LOGON.USERNAME']+'||'+YearMonth.getRawValue()+"^"+DeptFiled.getValue();
				//alert(data);
				request('check',data);
			    //����ˢ��ҳ��
		        FindButton.handler();
			} 
					   
          });  			
		}
	    else
		{
		   Ext.MessageBox.confirm("���ȷ��",'����Ҫ���'+YearMonth.getRawValue()+"�����ݣ��Ƿ�ȷ�����?",function(btn){  
               if (btn == 'yes') { 
				 data = "B||"+session['LOGON.USERNAME']+'||'+YearMonth.getRawValue();
				 //alert(data);
				 request('check',data);
				 //����ˢ��ҳ��
		         FindButton.handler();
			} 		   
           });  
		}
		
	  }
	  else
	  {
	  alert("��ѡ��Ҫ��˵�����.....")
	  }
	  //var data = YearMonth.getRawValue()+"^"+DeptFiled.getValue()+"^"+WorkItemFiled.getValue()
	  //session['LOGON.USERCODE']   session['LOGON.USERNAME'] 
	return;
	}
});



//���ҹ���������

var DeptWorkProxy = new Ext.data.HttpProxy({
			url : StratagemTabUrl + '?action=list'
		});
var DeptWorkDs = new Ext.data.Store({
			proxy : DeptWorkProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, ['rowid', 'YearMonths', 'Dept', 'ProjectClass',
							'WorkItem', 'Counts', 'DataState', 'Checker',
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
			header : '��������',
			dataIndex : 'YearMonths',
			width : 80,
			sortable : true

		}, {
			header : '����',
			dataIndex : 'Dept',
			width : 110,
			sortable : true
		}, {
			header : '��Ŀ����',
			dataIndex : 'ProjectClass',
			width : 100,
			sortable : true
		}, {
			header : '��������Ŀ',
			dataIndex : 'WorkItem',
			width : 120,
			sortable : true
		}, {
			header : '����',
			dataIndex : 'Counts',
			width : 80,
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
			header : '�ɼ�ʱ��',
			align : 'right',
			dataIndex : 'CollectDate',
			width : 110,
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
 var tbar1 = new Ext.Toolbar(['���ݽӿ�:', DataInterFiled,'-',DataCollButton,'-',ExcelButton,'-',CheckButton]); 

var DeptWorkGrid = new Ext.grid.EditorGridPanel({
			title : '���ҹ�����ά��',
			store : DeptWorkDs,
			cm : DeptWorkCm,
			clicksToEdit : 1,
			trackMouseOver : true,
			stripeRows : true,
			sm: new Ext.grid.CheckboxSelectionModel({singleSelect:false}),
			tbar : ['��������:', YearMonth,'-','����:',DeptFiled,'-','�����:',WorkItemFiled,'-',FindButton],
			bbar:DeptWorkPagTba,
			loadMask : true,
			listeners : { 
            'render': function(){ 
            tbar1.render(DeptWorkGrid.tbar); 
            } 
           } 
		}); 