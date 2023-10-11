 var itemGridUrl = '../csp/herp.acct.checkdetailexe.csp';

//�������Դ

var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
	proxy: itemGridProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
		'ISBN',
		'StoreName',
		'UnitName',
		'DataType',
		'DataFrom',
		'yearmonth',
		'DataValue',
		'InsertDate'
	]),
    remoteSort: true
});

var itemGridPagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: itemGridDs,
	atLoad : false,
	displayInfo: true,
	displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
	emptyMsg: "û������"
});
//����Ĭ�������ֶκ�������

itemGridDs.setDefaultSort('ISBN');
var itemGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
	    id:'ISBN',
        header: '���ݱ���',
        dataIndex: 'ISBN',
        width: 80,		  
        hidden: false,
        sortable: true
	    
    },
    {
	    id:'yearmonth',
	    header:'����',
	    dataIndex:'yearmonth',
	    width: 80,
	    hidden: false,
	    sortable:true
	},
    {
	    id:'StoreName',
	    header:'�ⷿ����',
	    dataIndex:'StoreName',
	    width: 220,
	    hidden: false,
	    sortable:true
	},{
	    id:'DataType',
	    header:'�������',
	    dataIndex:'DataType',
	    width: 180,
	    hidden: false,
	    sortable:true
	},
	{
	    id:'DataValue',
	    header:'���',
	    dataIndex:'DataValue',
	    width: 100,
	    hidden: false,
	    sortable:true
	},{
	    id:'DataFrom',
	    header:'�������',
	    dataIndex:'DataFrom',
	    width: 100,
	    hidden: false,
	    sortable:true
	},{
	    id:'InsertDate',
	    header:'�ɼ�ʱ��',
	    dataIndex:'InsertDate',
	    width: 250,
	    hidden: false,
	    sortable:true
	}
   
]);
//��ʼ��Ĭ��������
itemGridCm.defaultSortable = true;
  var DataFromStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��������'], ['2', '����Ӧ����']]
		});
	var DataFrom = new Ext.form.ComboBox({
            id : 'DataFrom',
			fieldLabel : 'DataFrom',
			width : 130,
			listWidth : 130,
			store : DataFromStore,
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			mode : 'local', // ����ģʽ
			triggerAction: 'all',
			emptyText:'��ѡ��...',
			selectOnFocus:true,
			forceSelection : true
		});	
var yearmonth = new Ext.form.DateField({
		fieldLabel: '����',
		name: 'yearmonth',
		width: 150,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Y-m',
		editable: false
	
	});

	var findButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls:'option',
			handler : function() {
			
				var myyearmonth=yearmonth.getRawValue();
				var datafrom= DataFrom.getValue();
				if (myyearmonth=="")
				{
				Ext.MessageBox.show({
		           title: '��ʾ',
		           msg: "���²���Ϊ��!",
		           buttons: Ext.MessageBox.OK
		       });
		     return null;
		     	}
	
				    itemGridDs.proxy = new Ext.data.HttpProxy({
	    	
								url : 'herp.acct.checkdetailexe.csp?action=list&yearmonth='+encodeURIComponent(myyearmonth)+'&kind='+encodeURIComponent(datafrom),
								
								method : 'GET'
								//'&type='+ userTypeField.getValue()
							});
							
				itemGridDs.load({
					
							params : {
								start : 0,
								limit : itemGridPagingToolbar.pageSize
								//yearmonth :'',
							    //kind:''
							
							}
						});
						

			}
			
			
		});
			
		
      
		var UpdataButton = new Ext.Toolbar.Button({
			text : '���ݸ���',
			tooltip : '���ݸ���',
			iconCls:'option',
			handler : function() {
			
				var myyearmonth=yearmonth.getRawValue();
				if (myyearmonth=="")
				{
				Ext.MessageBox.show({
		           title: '��ʾ',
		           msg: "���²���Ϊ��!",
		           buttons: Ext.MessageBox.OK
		       });
		     return null;
		     	}
	Ext.Ajax.request({
							url: 'herp.acct.checkdetailexe.csp?action=update'+'&start='+0+'&limit='+25+'&yearmonth='+encodeURIComponent(myyearmonth),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'���³ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									
								}
								else
								{	
								  if(jsonData.info==100)
								  {
								 Ext.MessageBox.show({
		                       title: '��ʾ',
		                       msg: "û���ݹ�!",
		                        buttons: Ext.MessageBox.OK
		                                 });
								  return;
								  }
								
								  
								 Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								 
								}
							},
					  	scope: this
						});
			
			
   
			}
			
			
		});
		
var itemGrid = new Ext.grid.GridPanel({
	//title: 'ȡ��ѯ',
    region: 'center',
    layout:'fit',
    width:400,
    readerModel:'local',
 
    atLoad : true, // �Ƿ��Զ�ˢ��
	store: itemGridDs,
	cm: itemGridCm,
	trackMouseOver: true,
	stripeRows: true,
	sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	tbar:['����:','-',yearmonth,'-','������Դ',DataFrom,UpdataButton,findButton],
	bbar:itemGridPagingToolbar
});
var myyearmonth=yearmonth.getRawValue();
var datafrom= DataFrom.getValue();
/*
 itemGridDs.load({	
			params:{start:0, 
			limit:itemGridPagingToolbar.pageSize,
			yearmonth : myyearmonth,
			kind:datafrom,
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
			}
});
*/
itemGridDs.loadPage(1);
