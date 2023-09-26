//��Ӱ�ť
var AddButton = new Ext.Toolbar.Button({
      text : '���',
	  tooltip : '���',
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
	  
	  }
});

//��ѯ��ť
var FindButton = new Ext.Toolbar.Button({
    text : '��ѯ',
	tooltip : '��ѯ',
	iconCls : 'find',
	handler : function(){
	     var data = DeptFiled.getValue()+"^"+periodTypeField.getValue();
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

var isEndField = new Ext.form.Checkbox({
						id : 'isEndField',
						labelSeparator : 'ĩ�˱�־:',
						allowBlank : false
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
					}, ['rowid', 'BonusTarget','TargetType', 'PaSchem', 'PiTarget','Proportion','BonusTargetID','PaSchemID','PiTargetID','TargetTypeID']),
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
			header : 'ָ�����',
			dataIndex : 'TargetType',
			width : 150,
			//align:'right',
			//xtype:'isEndField',
			sortable : true
		}, {
			header : '��Ч����',
			dataIndex : 'PaSchem',
			width : 150,
			sortable : true
		}, {
			header : '��Чָ��',
			dataIndex : 'PiTarget',
			width : 150,
			align:'left',
			sortable : true
		}, {
			header : '�������',
			dataIndex : 'Proportion',
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
			title : '��Ч����ָ��ӳ��',
			store : DeptWorkDs,
			cm : DeptWorkCm,
			clicksToEdit : 1,
			trackMouseOver : true,
			stripeRows : true,
			sm: new Ext.grid.CheckboxSelectionModel({singleSelect:false}),
			tbar : ['ָ�����:',periodTypeField,'-','����ָ��:',DeptFiled,'-',FindButton,'-',AddButton,'-',DelButton,'-',EditButton],
			bbar:DeptWorkPagTba,
			loadMask : true
	
		}); 