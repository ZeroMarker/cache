addDeptFun = function(SpltMainDR,budgDetailGrid){
    //alert(SpltMainDR);

//herp.budg.budgSchSplitAccDeptDexe.csp
///////////////////////�������///////////////////////////
var deptTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	deptTypeDs.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgSchSplitAccDeptDexe.csp?action=deptTypeist',method:'POST'});
		
	});
		
	var deptTypeCombo = new Ext.form.ComboBox({
		fieldLabel:'�������',
		store: deptTypeDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'ѡ��...',
		width: 110,
		listWidth : 110,
		pageSize: 10,
		minChars: 1,
		selectOnFocus:true
	});

/////////////////////���ұ���/////////////////////////////
var DeptCodefield = new Ext.form.TextField({
		id: 'DeptCodefield',
		fieldLabel: '���ұ���',
		allowBlank: true,
		emptyText:'����д...',
		width:100,
	    listWidth : 100
	});

/////////////////////��������/////////////////////////////
var DeptNamefield = new Ext.form.TextField({
		id: 'DeptNamefield',
		fieldLabel: '���ұ���',
		allowBlank: true,
		emptyText:'����д...',
		width:100,
	    listWidth : 100
	});


//��ѯ��ť
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
    tooltip:'��ѯ',        
    iconCls:'add',
	handler:function(){
//rowid, DeptType, DeptCode, DeptName,

		var Dtype=deptTypeCombo.getValue();
		var Dcode=DeptCodefield.getValue();
		var Dname=DeptNamefield.getValue();

		budgDeptGrid.load(({params:{start:0, limit:25, Dtype:Dtype, Dcode:Dcode, Dname:Dname}}));
	}
});		

//ȷ�ϰ�ť
var addButton = new Ext.Toolbar.Button({
	text: 'ȷ��',
    tooltip:'ȷ��',        
    iconCls:'add'});


	// ��������grid
var budgDeptGrid = new dhc.herp.Grid({
				title :' ����ѡ��',
				width : 400,
				region : 'center',
				url : 'herp.budg.budgSchSplitAccDeptDexe.csp',
				fields : [
				new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
							header : 'ID',
							dataIndex : 'rowid',
							hidden : true
						}, {
							id : 'Dcode',
							header : '���Ҵ���',
							dataIndex : 'Dcode',
							width : 200,
							align : 'center',
							editable:false,
							hidden : false

						},{
							id : 'Dname',
							header : '��������',
							dataIndex : 'Dname',
							width : 200,
							align : 'left',
							editable:false,
							hidden : false

						}, {
							id : 'Dtype',
							header : '�������',
							dataIndex : 'Dtype',
							width : 200,
							align : 'left',
							editable:false,
							hidden : false

						}],
				tbar:['�������:',deptTypeCombo,'-','���Ҵ���:',DeptCodefield,'-','��������:',DeptNamefield,'-',findButton]
			});



 budgDeptGrid.load({params:{start:0,limit:15}});
	
//������Ӱ�ť��Ӧ����
addHandler = function(){
		
		//var UnitID = Ext.getCmp('UnField').getValue();			
		//var data=UnitID.trim();
        var rowObj=budgDeptGrid.getSelectionModel().getSelections();
	    //���岢��ʼ���ж��󳤶ȱ���
	    var len = rowObj.length;
	    //�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
	    if(len < 1){
		    Ext.Msg.show({title:'ע��',msg:'������ѡ��һ������',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	       }
	    else{
	    for(var i = 0; i < len; i++){	    
		   var Dcode = rowObj[i].get("Dcode");
			Ext.Ajax.request({
				url: '../csp/herp.budg.budgschsplitaccdeptdexe.csp?action=addD&SpltMainDR='+SpltMainDR+'&Dcode='+Dcode,
				waitMsg:'������...',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'��ӿ��ҳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					budgDetailGrid.load({params:{start:0,limit:15}});
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
		 // budgDetailGrid.load({params:{start:0,limit:15}});	 
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
				title : '����ѡ��',
				plain : true,
				width : 660,
				height : 400,
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