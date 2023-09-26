//���Ӱ�ť
var AddButton = new Ext.Toolbar.Button({
      text : '����',
	  tooltip : '����',
	  iconCls : 'add',
      handler : function(){AddFun();}
});

//�޸İ�ť
var EditButton = new Ext.Toolbar.Button({
      text : '�޸�',
	  tooltip : '�޸�',
	  iconCls : 'add',
      handler : function(){
	  var rowObj=MainGrid.getSelections();
	  if ( rowObj.length<1)
	  {
	  	Ext.Msg.show({
						title : '��ʾ',
						msg : '��ѡ��Ҫ�޸ĵ����ݣ�!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		return;
	  }
	  else if (rowObj.length>1)
	  {
	  	Ext.Msg.show({
						title : '��ʾ',
						msg : 'ÿ��ֻ���޸�һ�����ݣ���������ѡ��!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.ERROR
					});
		return;
	  }
	  else
	  {EditFun(rowObj);}
	}
});

//ɾ����ť
var DelButton = new Ext.Toolbar.Button({
      text : 'ɾ��',
	  tooltip : 'ɾ��',
	  iconCls : 'remove',
	  handler : function(){
	 function handler1(id){ 	
	  if(id=="yes"){
	   var rowObj=MainGrid.getSelections();
	  if ( rowObj.length>0)
	  {
	    var rowIdArry = [];
		var data = "";
	    for (var i=0;i<rowObj.length;i++)
		 {
		  //rowIdArry.push(rowObj[i].get("rowid"));
		  if(data!="")
		   data = data+'^'+ rowObj[i].get("rowid");
		  else
		   data=rowObj[i].get("rowid");
		 }
	     //alert(data);
		 request('del',data);
		 //����ˢ��ҳ��
		 FindButton.handler();
	  }
	}else{
					return;
				}
		}		
	Ext.MessageBox.confirm('��ʾ','ȷʵҪɾ����?',handler1);			
	  //------
	  }
	  

	

			
			
});

//��ѯ��ť
var FindButton = new Ext.Toolbar.Button({
    text : '��ѯ',
	tooltip : '��ѯ',
	iconCls : 'find',
	handler : function(){
	     var data = DeptFiled.getValue()+"^"+WorkItemFiled.getValue();
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
					
					Ext.Msg.show({
								    title : 'ע��',
									msg : '�ɹ�!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
											});
					} 
					else {
					        flag = jsonData.info;
							if (flag=="RepCode")
							{
							Ext.Msg.show({
											title : '����',
											msg : '�������ظ���',
										    buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
							}
							else
							{
							Ext.Msg.show({
											title : '����',
											msg : '����',
										    buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
							}
										
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
	  var rowObj=MainGrid.getSelections();
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
					}, ['rowid', 'BonusTarget', 'DragName', 'InputProport','UpdateDate']),
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
			header : '����ָ��',
			dataIndex : 'BonusTarget',
			width : 150,
			sortable : true

		}, {
			header : 'Drag����',
			dataIndex : 'DragName',
			width : 150,
			sortable : true
		}, {
			header : '¼�����',
			dataIndex : 'InputProport',
			width : 80,
			align:'right',
			sortable : true
		}, {
			header : '�޸�ʱ��',
			dataIndex : 'UpdateDate',
			width : 100,
			align:'right',
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
DeptWorkDs.load({params:{start:0,limit:DeptWorkPagTba.pageSize}});	
var MainGrid = new Ext.grid.EditorGridPanel({
			title : 'Drgsָ��ӳ��',
			store : DeptWorkDs,
			cm : DeptWorkCm,
			clicksToEdit : 1,
			trackMouseOver : true,
			stripeRows : true,
			sm: new Ext.grid.CheckboxSelectionModel({singleSelect:false}),
			tbar : ['����ָ��:',DeptFiled,'-','Drag����:',WorkItemFiled,'-',FindButton,'-',AddButton,'-',EditButton ,'-',DelButton],
			bbar:DeptWorkPagTba,
			loadMask : true
	
		}); 