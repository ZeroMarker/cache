additemFun = function(curSchemeDr,schemeDetailGrid){
    //alert(SpltMainDR);

//herp.budg.budgSchSplitAccDeptDexe.csp
///////////////////////����Ԥ�������///////////////////////////
var TypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	TypeDs.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschemmainbexe.csp?action=itemtype',method:'POST'});
		
	});
		
	var TypeCombo = new Ext.form.ComboBox({
		fieldLabel:'Ԥ�������',
		store: TypeDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'ѡ��...',
		width: 120,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});

// ////////////////////////////////////
var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

smYearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgschemmamainexe.csp?action=yearList',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '���',
			store : smYearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});


//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
    tooltip:'��ѯ',        
    iconCls:'add',
	handler:function(){

		var type=TypeCombo.getValue();
		var Year=yearCombo.getValue();
		budgDeptGrid.load(({params:{start:0, limit:25,Year:Year, type:type}}));
	}
});		

//ȷ�ϰ�ť
var addButton = new Ext.Toolbar.Button({
	text: 'ȷ��',
    tooltip:'ȷ��',        
    iconCls:'add'});


	// ��������grid
var budgDeptGrid = new dhc.herp.Grid({
				width : 400,
				region : 'center',
				url : 'herp.budg.budgschemmainbexe.csp',
				fields : [
				new Ext.grid.CheckboxSelectionModel({editable:false}),
				{//rowid^code^name^
							header : 'ID',
							dataIndex : 'rowid',
							hidden : true
						}, {
							id : 'Year',
							header : '���',
							dataIndex : 'Year',
							width : 100,
							editable:false,
							hidden : false

						}, {
							id : 'code',
							header : 'Ԥ�������',
							dataIndex : 'code',
							width : 100,
							editable:false,
							hidden : false

						},{
							id : 'name',
							header : 'Ԥ��������',
							dataIndex : 'name',
							width : 280,
							editable:false,
							hidden : false

						}, {
							id : 'Level',
							header : 'Ԥ���뼶��',
							dataIndex : 'Level',
							width : 200,
							editable:false,
							hidden : false

						}],
						viewConfig : {forceFit : true},
						tbar:['Ԥ�������:',TypeCombo,'��ȣ�',yearCombo,findButton]
			});



 budgDeptGrid.load({params:{start:0,limit:15}});
	
//������Ӱ�ť��Ӧ����
addHandler = function(){

        var rowObj=budgDeptGrid.getSelectionModel().getSelections();
	    //���岢��ʼ���ж��󳤶ȱ���
	    var len = rowObj.length;
	    //�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
	    if(len < 1){
		    Ext.Msg.show({title:'ע��',msg:'������ѡ��һ��Ԥ���',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	       }
	    else{
	    for(var i = 0; i < len; i++){	    
		   var code = rowObj[i].get("code");
		   var Level = rowObj[i].get("Level");
			Ext.Ajax.request({
				url: '../csp/herp.budg.budgschemmainbexe.csp?action=addD&SchemDR='+curSchemeDr+'&Code='+code+'&Level='+Level,
				waitMsg:'������...',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'���Ԥ����ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					schemeDetailGrid.load({params:{start:0,limit:15}});
					}
					/*else{
						if(jsonData.info=='RepName'){
							Ext.Msg.show({title:'����',msg:'�����Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						
						}
					}*/
				},
				scope: this
			});
			}
			 
		  }	
		 // schemeDetailGrid.load({params:{start:0,limit:15}});	 
		  window.close();
		  
		};
	
	addButton.addListener('click',addHandler,false);
	// ��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({ text : '�ر�'});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function() { window.close(); };

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [budgDeptGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : 'Ԥ����ѡ��',
				plain : true,
				width : 850,
				height : 500,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [addButton,cancelButton]

			});
			
	window.show();
    budgDeptGrid.btnAddHide();  //�������Ӱ�ť
    budgDeptGrid.btnSaveHide();  //���ر��水ť
    budgDeptGrid.btnResetHide();  //�������ð�ť
    budgDeptGrid.btnDeleteHide(); //����ɾ����ť
    budgDeptGrid.btnPrintHide();  //���ش�ӡ��ť
};