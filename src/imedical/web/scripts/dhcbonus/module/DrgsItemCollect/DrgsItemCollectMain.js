//���ݲɼ���ť
var DataCollect = new Ext.Toolbar.Button({
      text : '���ݲɼ�',
	  tooltip : '���ݲɼ�',
	  iconCls : 'add',
      handler : function(){
	  alert("���ݲɼ�������������ӣ�");
	  }
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


//��ѯ��ť
var FindButton = new Ext.Toolbar.Button({
    text : '��ѯ',
	tooltip : '��ѯ',
	iconCls : 'find',
	handler : function(){
	     var data = YearMonth.getRawValue()+"^"+WorkItemFiled.getValue();
	     DeptWorkDs.load({
					params:{
							start : 0,
							limit : DeptWorkPagTba.pageSize,
							data:data
							}
					});
	}
});




//��˰�ť
var CheckButton = new Ext.Toolbar.Button({
    text : '���',
	tooltip : '���',
	iconCls : 'add',
	handler : function(){
	  var data = "";
	  var rowObj=MainGrid.getSelections();
	  if ((YearMonth.getRawValue()=="")&&(rowObj.length<1))
	  {
	     alert("��ѡ��Ҫ��˵�����.....");
	  }
	  else if((YearMonth.getRawValue()!="")&&(rowObj.length<1))
	  {
		   Ext.MessageBox.confirm("���ȷ��",'����Ҫ���'+YearMonth.getRawValue()+"�����ݣ��Ƿ�ȷ�����?",function(btn){  
               if (btn == 'yes') { 
				 data ="A"+"||"+ session['LOGON.USERNAME']+'||'+YearMonth.getRawValue();
				 //alert(data);
				 request('check',data);
				 //����ˢ��ҳ��
		         FindButton.handler();
			} 		   
           });  
	  }
	  else
	  {
	    Ext.MessageBox.confirm("���ȷ��",'����Ҫ�����ѡ��'+rowObj.length+"�����ݣ��Ƿ�ȷ�����?",function(btn){  
		if (btn == 'yes') { 
	      for (var i=0;i<rowObj.length;i++)
		   {
		    //rowIdArry.push(rowObj[i].get("rowid"));
		    if(data!="")
		     data = data+'^'+ rowObj[i].get("rowid");
		    else
		     data=rowObj[i].get("rowid");
		  }
	      data = "B"+"||"+session['LOGON.USERNAME']+'||'+data
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
					}, ['rowid', 'YearMonth', 'DeptName', 'DrgsName','NumDiseases','CMI','CostFactor','CollectDate','State','CheckDate']),
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
			dataIndex : 'YearMonth',
			width : 120,
			sortable : true

		}, {
			header : '��������',
			dataIndex : 'DeptName',
			width : 120,
			sortable : true
		}, {
			header : 'Drgs����',
			dataIndex : 'DrgsName',
			width : 120,
			//align:'right',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'NumDiseases',
			width : 100,
			align:'right',
			sortable : true
		}, {
			header : 'CMIֵ',
			dataIndex : 'CMI',
			width : 100,
			align:'right',
			sortable : true
		}, {
			header : '����ϵ��',
			dataIndex : 'CostFactor',
			width : 100,
			align:'right',
			sortable : true
		}, {
			header : '�ɼ�ʱ��',
			dataIndex : 'CollectDate',
			width : 100,
			align:'right',
			sortable : true
		}, {
			header : '����״̬',
			dataIndex : 'State',
			width : 100,
			//align:'right',
			sortable : true
		}, {
			header : '���ʱ��',
			dataIndex : 'CheckDate',
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
			title : 'Drgs��Ŀ���ݲɼ�',
			store : DeptWorkDs,
			cm : DeptWorkCm,
			clicksToEdit : 1,
			trackMouseOver : true,
			stripeRows : true,
			sm: new Ext.grid.CheckboxSelectionModel({singleSelect:false}),
			tbar : ['��������:',YearMonth,'-','Drag����:',WorkItemFiled,'-',FindButton,'-',DataCollect,'-',CheckButton],
			bbar:DeptWorkPagTba,
			loadMask : true
	
		}); 