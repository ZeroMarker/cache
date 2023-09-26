var incomeDatasUrl = 'dhc.ca.incomedatasexe.csp';
var incomeDatasProxy = new Ext.data.HttpProxy({url: incomeDatasUrl + '?action=list'});
var monthDr = "";

var user=session['GROUPDESC'];

function formatDate(value){
	return value?value.dateFormat('Y-m-d'):'';
};
var incomeDatasDs = new Ext.data.Store({
		proxy: incomeDatasProxy,
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowid',
			'intervalDr',
			'intervalName',
			{name:'feeDate',type:'date',dateFormat:'Y-m-d'},
			'patType',
			'itemCode',
			'itemName',
			'itemDr',
			'inItemCode',
			'inItemName',
			'fee',
			'cost',
			'fDeptCode',
			'fDeptName',
			'fDeptDr',
			'inFDeptCode',
			'inFDeptName',
			'tDeptCode',
			'tDeptName',
			'tDeptDr',
			'inTDeptCode',
			'inTDeptName',
			'patDeptCode',
			'patDeptName',
			'patDeptDr',
			'inPatDeptCode',
			'inPatDeptName',
			'inType',
			'personDr',
			'personName',
			{name:'inDate',type:'date',dateFormat:'Y-m-d'},
			'remark',
			'patWardCode',
			'patWardDesc',
			'patWardDr',
			'inPatWardCode',
			'inPatWardDesc',
			'patDocCode',
			'patDocDesc',
			'patDocDr',
			'inPatDocCode',
			'inPatDocDesc',
			'fDocCode',
			'fDocName',
			'fDocDr',
			'fInDocName'
			
		]),
    // turn on remote sorting
    remoteSort: true
});

incomeDatasDs.setDefaultSort('rowid', 'desc');

var incomeDatasCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),new Ext.grid.CheckboxSelectionModel(),
	{
		header: '��������',
		dataIndex: 'patType',
		width: 40,
		align: 'left',
		sortable: true
    },
	{
		header: '��Ŀ����',
		dataIndex: 'itemCode',
		width: 100,
		align: 'left',
		sortable: true
    },
	{
        header: '��Ŀ����',
        dataIndex: 'itemName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '������Ŀ����',
        dataIndex: 'inItemName',
        width: 100,
        align: 'left',
        renderer:color,
        sortable: true
    },
	{
        header: '���',
        dataIndex: 'fee',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '�������Ŵ���',
        dataIndex: 'fDeptCode',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '������������',
        dataIndex: 'fDeptName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '���㿪����������',
        dataIndex: 'inFDeptName',
        width: 100,
        align: 'left',
        renderer:color,
        sortable: true
    },
	{
        header: '���ղ��Ŵ���',
        dataIndex: 'tDeptCode',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '���ղ�������',
        dataIndex: 'tDeptName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '������ղ�������',
        dataIndex: 'inTDeptName',
        width: 100,
        align: 'left',
        renderer:color,
        sortable: true
    },
	{
        header: '���˲��Ŵ���',
        dataIndex: 'patDeptCode',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '���˲�������',
        dataIndex: 'patDeptName',
        width: 100,
        align: 'left',
        sortable: true
    },
	{
        header: '���㲡�˲�������',
        dataIndex: 'inPatDeptName',
        width: 100,
        align: 'left',
        renderer:color,
        sortable: true
    },/*zjw 20160809 pingbi
	{
        header: '�ⲿ���˲�������',
        dataIndex: 'patWardCode',
        width: 100,
        align: 'left',
	hidden:true,
        sortable: true
    },
	{
        header: '�ⲿ���˲�������',
        dataIndex: 'patWardDesc',
        width: 100,
        align: 'left',
	hidden:true,
        sortable: true
    },
	{
        header: '���㲡�˲�������',
        dataIndex: 'inPatWardDesc',
        width: 100,
        align: 'left',
        renderer:color,
	hidden:true,
        sortable: true
    },
	{
        header: '�ⲿ����ҽ������',
        dataIndex: 'patDocCode',
        width: 100,
        align: 'left',
	hidden:true,
        sortable: true
    },
	{
        header: '�ⲿ����ҽ������',
        dataIndex: 'patDocDesc',
        width: 100,
        align: 'left',
	hidden:true,
        sortable: true
    },
	{
        header: '�ڲ�����ҽ������',
        dataIndex: 'inPatWardDesc',
        width: 100,
        align: 'left',
        hidden:true,
        sortable: true
    },*/
	{
        header: '¼������',
        dataIndex: 'inType',
        width: 100,
        align: 'left',
        sortable: true
    },{
        header: '�ɼ���',
        dataIndex: 'personName',
        width: 70,
        align: 'left',
        sortable: true
    },
	{
        header: '�ɼ�����',
        dataIndex: 'inDate',
        width: 70,
	renderer:formatDate,
        align: 'left',
        sortable: true
    },
	{
        header: '��ע',
        dataIndex: 'remark',
        width: 100,
        align: 'left',
	//hidden:true,
        sortable: true
    }/*zjw 20160809 pingbi, 
{
    header: '����ҽ������',
    dataIndex: 'fDocCode',
    width: 70,
    align: 'left',
    hidden:true,
    sortable: true
}, 
{
    header: '����ҽ������',
    dataIndex: 'fDocName',
    width: 70,
    align: 'left',
    hidden:true,
    sortable: true
}, {
    header: '����ҽ��',
    dataIndex: 'fInDocName',
    width: 70,
    align: 'left',
    hidden:true,
    sortable: true
}*/
]);
var monthsDs = new Ext.data.Store({
	proxy: "",                                                           
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc','start','end','dataFinish'])
});
var months = new Ext.form.ComboBox({
	id: 'months',
	fieldLabel: '��������',
	width: 80,
	listWidth : 200,
	allowBlank: false,
	store: monthsDs,
	//readOnly:true,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'ѡ���������...',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
monthsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.vouchdatasexe.csp?action=months&searchValue='+Ext.getCmp('months').getRawValue(),method:'GET'});
});	

//----------------------------------------------------------------------------------------------
var loadRulesDs = new Ext.data.Store({
	proxy: "",                                                           
	reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','order','code','name','deptSetDr','itemSetDr','itemTypeDr','deptSetName','itemSetName','itemTypeName'])
});
var loadRules = new Ext.form.ComboBox({
	id: 'loadRules',
	fieldLabel: '�������',
	width: 80,
	listWidth : 200,
	allowBlank: false,
	store: loadRulesDs,
	valueField: 'rowId',
	displayField: 'name',
	triggerAction: 'all',
	//readOnly:true,
	emptyText:'ѡ�������...',
	pageSize: 10,
	minChars: 1,
	selectOnFocus: true,
	forceSelection: true
});
loadRulesDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.incomedatasexe.csp?action=loadrules&searchValue='+Ext.getCmp('loadRules').getRawValue(),method:'GET'});
});	
//---------------------------------------------------------------------------------------------

months.on("select",function(cmb,rec,id ){
	monthDr=cmb.getValue();
	/**
	Ext.Ajax.request({
		url: 'dhc.ca.vouchdatasexe.csp?action=checkMonth&monthDr='+monthDr,
		waitMsg:'������...',
		failure: function(result, request) {
			Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success!='true') {
				addDataTypesButton.setDisabled(true);
				editDataTypesButton.setDisabled(true);
				delDataTypesButton.setDisabled(true);
			}else{
				addDataTypesButton.setDisabled(false);
				editDataTypesButton.setDisabled(false);
				delDataTypesButton.setDisabled(false);
			}
		},
		scope: this
	});
	*/
	incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
});

var addDataTypesButton = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '����µ��������ݱ�',        
		iconCls: 'add',
		handler: function(){addFun(incomeDatasDs,incomeDatasMain,incomeDatasPagingToolbar);}
});

var editDataTypesButton  = new Ext.Toolbar.Button({
		text: '�޸�',        
		tooltip: '�޸�ѡ�����������ݱ�',
		iconCls: 'remove',
		handler: function(){editFun(incomeDatasDs,incomeDatasMain,incomeDatasPagingToolbar);}
});

var delDataTypesButton  = new Ext.Toolbar.Button({
		text: '��ѡ��/����ɾ��',        
		tooltip: 'ɾ��ѡ�����������ݱ�',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){delFun(incomeDatasDs,incomeDatasMain,incomeDatasPagingToolbar);}
});

var delMonthDataButton  = {
		text: '���·�ɾ��',        
		tooltip: 'ɾ��ѡ�����·��������ݱ�',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			if(monthDr=="")
			{
				Ext.Msg.show({title:'ע��',msg:'��ѡ���·ݺ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
				Ext.MessageBox.confirm('��ʾ', 
					'ȷ��Ҫɾ�����µ�����?', 
					function(btn) {
						if(btn == 'yes'){
							//--------------------------------------
							Ext.Ajax.request({
								url: incomeDatasUrl+'?action=delMonth&monthDr='+monthDr,
								waitMsg:'������...',
								failure: function(result, request) {
									Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
								success: function(result, request) {
									var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
										incomeDatasDs.setDefaultSort('rowid', 'desc');
										incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
										//window.close();
									}
									else
									{
										var message = "";
										message = "SQLErr: " + jsonData.info;
										Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
									}
								},
							scope: this
							});
							//--------------------------------------
						}
					}
				)
		}
};



var importButtonO  = {
		text: '��������',        
		tooltip: '����������������',
		iconCls: 'remove',
		//disabled: true,[
		handler: function(){
			Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ�ϵ�������?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					var ruleDr=loadRules.getValue();
	    	         		var loadMask = new Ext.LoadMask(document.body, {msg : '�������������������...'});								
					if(monthDr==""){
						Ext.Msg.show({title:'����',msg:'��ѡ�������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(ruleDr==""){
						Ext.Msg.show({title:'����',msg:'��ѡ�����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else{
                               	 	  loadMask.show();
						Ext.Ajax.request({
                                               
							url: 'dhc.ca.incomedatasexe.csp?action=importo&monthDr='+monthDr+'&ruleDr='+ruleDr+'&userCode='+userCode,
							waitMsg:'������...',
						failure: function(result, request) {
	    	                 			loadMask.hide();
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
	    	                 		loadMask.hide();
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
								}else{
									Ext.Msg.show({title:'ע��',msg:'����ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
							},
							scope: this
						});
					}
				 }
			})
			
			
		}
};

var importButtonGh  = {
		text: '����Һ�',
		hidden:true,        
		tooltip: '����Һ�����',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ�ϵ�������?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					var ruleDr=loadRules.getValue();
					if(monthDr==""){
						Ext.Msg.show({title:'����',msg:'��ѡ�������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(ruleDr==""){
						Ext.Msg.show({title:'����',msg:'��ѡ�����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else{
						Ext.Ajax.request({
							url: 'dhc.ca.incomedatasexe.csp?action=importG&monthDr='+monthDr+'&ruleDr='+ruleDr+'&userCode='+userCode,
							waitMsg:'������...',
							failure: function(result, request) {
								loadMask.hide();
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
								}else{
									Ext.Msg.show({title:'ע��',msg:'����ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
							},
							scope: this
						});
					}
				 }
			})
			
			
		}
};

var importButtonI  = {
		text: '����סԺ',        
		tooltip: '����סԺ��������',
		 //hidden:true,
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ�ϵ�������?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					var ruleDr=loadRules.getValue();
	    	         		var loadMask = new Ext.LoadMask(document.body, {msg : '�������������������...'});								
					
					if(monthDr==""){
						Ext.Msg.show({title:'����',msg:'��ѡ�������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(ruleDr==""){
						Ext.Msg.show({title:'����',msg:'��ѡ�����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else{
                               	 	  loadMask.show();
						Ext.Ajax.request({
							url: 'dhc.ca.incomedatasexe.csp?action=importi&monthDr='+monthDr+'&ruleDr='+ruleDr+'&userCode='+userCode,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								loadMask.hide();
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
								}else{
									Ext.Msg.show({title:'ע��',msg:'����ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
							},
							scope: this
						});
					}
				 }
			})
			
			
		}
};

var importButtonE  = {
		text: '���뼱��',        
		tooltip: '���뼱����������',
         //hidden:true,
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ�ϵ�������?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					var ruleDr=loadRules.getValue();
					var loadMask = new Ext.LoadMask(document.body, {msg : '�������������������...'});								
					
					if(monthDr==""){
						Ext.Msg.show({title:'����',msg:'��ѡ�������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(ruleDr==""){
						Ext.Msg.show({title:'����',msg:'��ѡ�����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else{
						  loadMask.show();
						Ext.Ajax.request({
							url: 'dhc.ca.incomedatasexe.csp?action=importe&monthDr='+monthDr+'&ruleDr='+ruleDr+'&userCode='+userCode,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								loadMask.hide();
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
								}else{
									Ext.Msg.show({title:'ע��',msg:'����ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
							},
							scope: this
						});
					}
				 }
			})
			
			
		}
};

var importButtonH  = {
		text: '�������',      
		tooltip: '���������������',
        hidden:true,        
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ�ϵ�������?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					var ruleDr=loadRules.getValue();
					var loadMask = new Ext.LoadMask(document.body, {msg : '�������������������...'});								
					
					if(monthDr==""){
						Ext.Msg.show({title:'����',msg:'��ѡ�������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(ruleDr==""){
						Ext.Msg.show({title:'����',msg:'��ѡ�����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else{
						loadMask.show();
						Ext.Ajax.request({
							url: 'dhc.ca.incomedatasexe.csp?action=importh&monthDr='+monthDr+'&ruleDr='+ruleDr+'&userCode='+userCode,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								loadMask.hide();
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
								}else{
									Ext.Msg.show({title:'ע��',msg:'����ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
							},
							scope: this
						});
					}
				 }
			})
			
			
		}
};

var SearchUnrefreshButton  = new Ext.Toolbar.Button({
		text: '�鿴δ��������',        
		tooltip: '�鿴δ��������',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){CommFindFun();}
});

var findcompreButton  = new Ext.Toolbar.Button({
		text: '�ۺϲ�ѯ',        
		tooltip: '�ۺϲ�ѯ...',
		iconCls: 'remove',
                disabled: true,
		handler: function(){CompreFindFun();}
});
var refreshButton  = new Ext.Toolbar.Button({
		text: 'ִ�����ݶ���',        
		tooltip: '��Ӧ�����������',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){refresh(incomeDatasDs,incomeDatasMain,incomeDatasPagingToolbar,monthDr,"1");}
});
/*
var refreshButton  = new Ext.Toolbar.Button({
		text: 'ˢ������',        
		tooltip: '��Ӧ�����������',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			var ruleDr=loadRules.getValue();
			if(monthDr==""){
				Ext.Msg.show({title:'����',msg:'��ѡ�������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
			else if(ruleDr==""){
				Ext.Msg.show({title:'����',msg:'��ѡ�����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}else{
				Ext.Ajax.request({
					url: 'dhc.ca.incomedatasexe.csp?action=refresh&monthDr='+monthDr+'&ruleDr='+ruleDr, //+'&userCode='+userCode, 
					waitMsg:'������...',
					failure: function(result, request) {
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'ˢ�³ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
						}else{
							Ext.Msg.show({title:'ע��',msg:'����ʧ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					},
					scope: this
				});
			}
		}
});*/
//--------------------------------------------
var innerDeptControlButton  = new Ext.Toolbar.Button({
		text: '�ڲ�����ת��',        
		tooltip: '�ڲ�����ת��',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			var ruleDr=loadRules.getValue();
			if(monthDr==""){
				Ext.Msg.show({title:'����',msg:'��ѡ�������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}else{
				InnerDeptControl();
			}
		}
});
//--------------------------------------------
var opMenu = new Ext.menu.Menu({
    id: 'opMenu',
    //items: [importButtonO,importButtonI,importButtonE,importButtonH,importButtonGh]
    items: [importButtonO,importButtonI]
});
var opTool = new Ext.Toolbar([{
    text: '���ݵ���',
    iconCls: 'add',
    //disabled: true,
    menu: opMenu
}]);


var importButton = ({
    text: 'EXCEL�ϴ�',
    tooltip: '�ϴ�����',
    iconCls: 'add',
    handler: function() { loadIncomeDatas(incomeDatasDs,incomeDatasPagingToolbar) }
});



//----------zjw 20160718 ���տ�����Ŀ����������������
//var YPRatio = new Ext.form.NumberField({
//var CXMoney = new Ext.form.TextField
var WriteOffCharge = new Ext.form.TextField({
		id: 'WriteOffCharge',
		fieldLabel: '���������',
		//allowDecimals:false,
		allowBlank: false,
		iconCls: 'remove',
		//value:0,
		emptyText: '������...',
		width:60,
		align: 'left',
		anchor: '50%'
	});
var importButtonCX = {
		text: '��������',        
		tooltip: '����������',
		iconCls: 'remove',
		//disabled: true,
		handler: function(){
			
			
			
			Ext.MessageBox.confirm('��ʾ', 
    	    'ȷ�ϵ�������?', 
    	    function(btn) {
	    	     if(btn == 'yes')
		         {
					//var itemTypeId=itemTypeSelecter.getValue();
					var ruleDr=loadRules.getValue();
					//alert(ruleDr)
					var CXMoney=WriteOffCharge.getValue();
					//alert(CXMoney)
	    	         		var loadMask = new Ext.LoadMask(document.body, {msg : '�������������������...'});								
					if(monthDr==""){
						Ext.Msg.show({title:'����',msg:'��ѡ�������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else if(ruleDr==""){
						Ext.Msg.show({title:'����',msg:'��ѡ�����������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else if(CXMoney==""){
						Ext.Msg.show({title:'����',msg:'����д��������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}else if(CXMoney<=0){
						Ext.Msg.show({title:'����',msg:'��������������������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					else{
                               	 	  loadMask.show();
						Ext.Ajax.request({
							url: 'dhc.ca.incomedatasexe.csp?action=ImportCXData&monthDr='+monthDr+'&CXMoney='+CXMoney+'&userCode='+userCode,
							waitMsg:'������...',
							failure: function(result, request) {
								//alert("1")
	    	                 			loadMask.hide();
								Ext.Msg.show({title:'����',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								},
							success: function(result, request) {
								//alert("2")
	    	                 		loadMask.hide();
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									incomeDatasDs.load({ params: { start: 0, limit: incomeDatasPagingToolbar.pageSize, monthDr:monthDr} });
								}else{
									Ext.Msg.show({title:'ע��',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}
							},
							scope: this
						});
					}
				 }
			})
			
			
		}
};
//----------------------

var IncomeDataTypesButton  = new Ext.Toolbar.Button({
		text: 'ͳ������',        
		tooltip: 'ͳ����������',
		iconCls: 'remove',
		handler: function(){CommFindIncomeFun();}
});
    
var incomeDatasSearchField = 'patType';

var incomeDatasFilterItem = new Ext.Toolbar.MenuButton({
		text: '������',
		tooltip: '�ؼ����������',
		menu: {items: [
				new Ext.menu.CheckItem({ text: '��������',value: 'feeDate',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��������',value: 'patType',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ŀ����',value: 'itemCode',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��Ŀ����',value: 'itemName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '<span style="color:blue;">������Ŀ����</span>',value: 'inItemName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '���',value: 'fee',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				//new Ext.menu.CheckItem({ text: '�ɱ�',value: 'cost',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�������Ŵ���',value: 'fDeptCode',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '������������',value: 'fDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '<span style="color:blue;">���㿪����������</span>',value: 'inFDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),				
				new Ext.menu.CheckItem({ text: '���ղ��Ŵ���',value: 'tDeptCode',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '���ղ�������',value: 'tDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '<span style="color:blue;">������ղ�������</span>',value: 'inTDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '���˲��Ŵ���',value: 'patDeptCode',checked: true,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '���˲�������',value: 'patDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '<span style="color:blue;">���㲡�˲�������</span>',value: 'inPatDeptName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�ɼ���',value: 'personName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '��ע',value: 'remark',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck }),
				new Ext.menu.CheckItem({ text: '�ɼ�����',value: 'inDate',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck })//,
				//new Ext.menu.CheckItem({ text: '����ҽ������',value: 'fDocCode',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck}), 
				//new Ext.menu.CheckItem({ text: '����ҽ������',value: 'fDocName',checked: false,group: 'DataTypesFilter',checkHandler: onDataTypesItemCheck})
		]}
});

function onDataTypesItemCheck(item, checked)
{
		if(checked) {
				incomeDatasSearchField = item.value;
				incomeDatasFilterItem.setText(item.text + ':');
		}
};

var incomeDatasSearchBox = new Ext.form.TwinTriggerField({//���Ұ�ť
		width: 180,
		trigger1Class: 'x-form-clear-trigger',
		trigger2Class: 'x-form-search-trigger',
		emptyText:'����...',
		listeners: {
				specialkey: {fn:function(field, e) {
				var key = e.getKey();
	      	  if(e.ENTER === key) {this.onTrigger2Click();}}}
	    	},
		grid: this,
		onTrigger1Click: function() {
				if(this.getValue()) {
					this.setValue('');    
					incomeDatasDs.proxy = new Ext.data.HttpProxy({url: incomeDatasUrl + '?action=list'});
					incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
				}
		},
		onTrigger2Click: function() {
				if(this.getValue()) {
				incomeDatasDs.proxy = new Ext.data.HttpProxy({
				url: incomeDatasUrl + '?action=list&searchField=' + incomeDatasSearchField + '&searchValue=' + this.getValue()});
	        	incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize, monthDr:monthDr}});
	    	}
		}
});

var incomeDatasPagingToolbar = new Ext.PagingToolbar({//��ҳ������
		pageSize: 25,
		store: incomeDatasDs,
		displayInfo: true,
		displayMsg: '��ǰ��ʾ{0} - {1}������{2}',
		emptyMsg: "û������",
		buttons: ['-',incomeDatasFilterItem,'-',incomeDatasSearchBox],
		doLoad:function(C){
			var B={},
			A=this.paramNames;
			B[A.start]=C;
			B[A.limit]=this.pageSize;
			B['monthDr']=monthDr;
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
				}
});

var incomeDatasMain = new Ext.grid.GridPanel({ //���
		title: '�������ݱ�ά��',
		store: incomeDatasDs,
		cm: incomeDatasCm,
		trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.CheckboxSelectionModel(),
		loadMask: true,
		//tbar: ['��������:',months,'-','�������:',loadRules,'-',addDataTypesButton,'-',delDataTypesButton,'-',opTool,'-',refreshButton,'-',innerDeptControlButton,'-',editDataTypesButton,'-',findcompreButton,'-',delMonthDataButton],
		//tbar: ['��������:',months,'-','�������:',loadRules,'-',BaseTool,'-',opTool,'-',importButton,'-',refreshButton,'-',innerDeptControlButton,'-',SearchUnrefreshButton,'-',IncomeDataTypesButton],
		//tbar: ['��������:',months,'-','�������:',loadRules,'-',addDataTypesButton,'-',delDataTypesButton,'-',opTool,'-',importButton,'-',WriteOffCharge,"��Ԫ",'-',importButtonCX,'-',refreshButton,'-',innerDeptControlButton,'-',SearchUnrefreshButton,'-',IncomeDataTypesButton],
		tbar: ['��������:',months,'-','�������:',loadRules,'-',addDataTypesButton,'-',delDataTypesButton,'-',opTool,'-',importButton,'-',refreshButton,'-',innerDeptControlButton,'-',SearchUnrefreshButton,'-',IncomeDataTypesButton],
		
		bbar: incomeDatasPagingToolbar
});

//incomeDatasDs.load({params:{start:0, limit:incomeDatasPagingToolbar.pageSize}});