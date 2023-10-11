 var ProjCompUrl = '../csp/herp.srm.projectapprovalapplyexe.csp';
 
 //CompInfoList=function(projectrowid){
 	

///////////////////Flag//////////////////////////////////
var FlagStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '���е�λ'], ['2', '������λ']]
		});
var FlagField = new Ext.form.ComboBox({
			fieldLabel : '��λ',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : false,
			store : FlagStore,
			anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			listeners:{
            "select":function(combo,record,index){
                CompStore.removeAll();
				if(FlagField.getValue()==1){   
					CompCombox.setValue('');
					var selectedRow = itemGrid.getSelectionModel().getSelections();
					var projectrowid=selectedRow[0].data['rowid'];
					CompStore.proxy = new Ext.data.HttpProxy({url:ProjCompUrl+'?action=relyuintslist1&prjrowid='+projectrowid+'&type='+FlagField.getValue(),method:'POST'})  
					CompStore.load({params:{start:0,limit:10,prjrowid:projectrowid,type:FlagField.getValue()}});  
				}   		
				else if(FlagField.getValue()==2)
				{   
					CompCombox.setValue('');
					var selectedRow = itemGrid.getSelectionModel().getSelections();
					var projectrowid=selectedRow[0].data['rowid'];
					CompStore.proxy = new Ext.data.HttpProxy({url:ProjCompUrl+'?action=relyuintslist1&prjrowid='+projectrowid+'&type='+FlagField.getValue(),method:'POST'})
					CompStore.load({params:{start:0,limit:10,prjrowid:projectrowid,type:FlagField.getValue()}});		
				}
				else{
					CompCombox.setValue('');	
				}
			}
			}
		});
////////////////////��λComp/////////////
var CompStore = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

CompStore.on('beforeload', function(ds, o){
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var projectrowid=selectedRow[0].data['rowid'];
    CompStore.proxy = new Ext.data.HttpProxy({
		url:ProjCompUrl+'?action=relyuintslist1&prjrowid='+projectrowid+'&type='+FlagField.getValue(),method:'POST'});
	if(FlagField.getValue()==""){   
		Ext.Msg.show({title:'ע��',msg:'����ѡ��λ����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	};
});	
var CompCombox = new Ext.form.ComboBox({
			store : CompStore,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
////////////////////�ֹ�/////////////
var DivideWorkField=new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

////////////////////��Ŀ����/////////////
var FundTotalField=new Ext.form.NumberField({
	width : 120,
	selectOnFocus : true
});

////////////////////�ϼ�����/////////////
var FundGovField=new Ext.form.NumberField({
	width : 120,
	selectOnFocus : true
});

var ProjCompGrid = new dhc.herp.CompGrid({
	//title: '��Ŀ�ֹ���Ϣά��',iconCls: 'list',
			region : 'center',
			url : ProjCompUrl,	
      cm : colModel,
      //selModel:sm,
      readerModel:'remote',		
			fields : [          
			{ 		
            id:'ID',
						header : 'ID',
						dataIndex : 'rowid',
						width : '120',
						hidden : true
					},{ 		
            id:'prjrowid',
						header : '��ĿID',
						dataIndex : 'prjrowid',
						width : '120',
						hidden : true
					},{
						id : 'Flag',
						header : '��λ����',
						dataIndex : 'Flag',
						width : 100,
						align : 'left',
						editable:true, 
						allowBlank:false,
						hidden : false,
						type:FlagField

					}, {
						id : 'CompDR',
						header : '��λDR',
						width : 120,
						editable:true,
						align : 'right',
						//allowBlank:false,
						dataIndex : 'CompDR',
						hidden:true
				}, {
						id : 'CompName',
						header : '��λ����',
						width : 180,
						allowBlank:false,
						editable:true,
						align : 'left',
						dataIndex : 'CompName',
					  type:CompCombox
				}, {
						id : 'DivideWork',
						header : '��Ŀ�ֹ�',
						width : 100,
						align : 'left',
						allowBlank:false,
						editable: true,
						dataIndex : 'DivideWork',
						type:DivideWorkField
					},{
						id : 'FundTotal',
						header : '��Ŀ���ѣ���Ԫ��',
						width : 120,
						editable: true,
						allowBlank:false,
						align : 'right',	
						dataIndex : 'FundTotal',
						//type:FundTotalField,
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id : 'FundGov',
						header : '�ϼ��������ѣ���Ԫ��',
						width : 150,
						editable : true,
						align : 'right',
						dataIndex : 'FundGov',
						//type:FundGovField,
						allowBlank:false,
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
						
					}]
		});
ProjCompGrid.btnResetHide();  //�������ð�ť
ProjCompGrid.btnPrintHide();  //���ش�ӡ��ť
    
//ProjCompGrid.load({params:{start:0,limit:15,prjrowid:projectrowid}});

  // ��ʼ��ȡ����ť
  /**
	cancelButton = new Ext.Toolbar.Button({
				text : '�ر�'
			});

	// ����ȡ����ť����Ӧ����
	cancelHandler = function() {
		window.close();
	}

	// ���ȡ����ť�ļ����¼�
	cancelButton.addListener('click', cancelHandler, false);
	// ��ʼ�����
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [ProjCompGrid]
			});
	var window = new Ext.Window({
				layout : 'fit',
				title : '��Ŀ�ֹ���Ϣ',
				plain : true,
				width : 468,
				height : 300,
				modal : true,
				// bodyStyle : 'padding:5px;',
				buttonAlign : 'center',
				items : formPanel,
				buttons : [cancelButton]

			});
	window.show();
}
**/