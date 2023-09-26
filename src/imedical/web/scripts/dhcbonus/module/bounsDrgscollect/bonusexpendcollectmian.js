//����
	var yearmonth = new Ext.form.DateField({
		fieldLabel: '����',
		name: 'yearmonth',
		width: 150,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Y-m',
		editable: false
		// ,
	});
//	����
var deptDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusexpendcollectexe.csp'
								+ '?action=getDept&str='
								+ encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()),
						method : 'POST'
					})
		});

var deptCombo = new Ext.form.ComboBox({
			id : 'deptCombo',
			fieldLabel : '����',
			width : 100,
			listWidth : 285,
			//allowBlank : false,
			store : deptDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'deptCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
		
	var MethodField = new Ext.form.ComboBox({												
				fieldLabel: '�����ӿ�',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '���ʽӿ���'],['2', 'HR�ӿ���']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '1',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : 'ѡ��...',
				selectOnFocus:'true'
			});

		
var findButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls:'option',
			handler : function() {
				var myyearmonth,deptcode,tariffType;
				if (yearmonth!=undefined){
				myyearmonth = yearmonth.getRawValue();
				
				}
					
				if (deptCombo!=undefined){	
				deptcode = deptCombo.getValue();
				}
			
				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								yearmonth : myyearmonth,
								deptcode : deptcode
							
							}
						});

			}
			
		})
var collectbutton = new Ext.Toolbar.Button(
		{
			text : '���ݲɼ�',
			tooltip : '���ݲɼ�',
			iconCls : 'option',
			handler : function() {  
				var myyearmonth = yearmonth.getRawValue();	
			
				if (myyearmonth==""){
				Ext.Msg.show({title:'����',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}
				var userid=session['LOGON.USERID'];
				var method=MethodField.getValue();
			
			if (method==""){
				Ext.Msg.show({title:'����',msg:'��ѡ��ӿ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}
			
			
		        Ext.Ajax.request({
				url:'dhc.bonus.module.bonusexpendcollectexe.csp?action=collect&yearmonth='+myyearmonth+'&MethodDr='+method+'&userid='+userid,
		
				waitMsg:'�ɼ���...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'�ɼ��ɹ���',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGrid.load({
							params : {
								start : 0,
								limit : 25
							
							}
						});	
				}
				},
				scope: this
				});
			}
});
var importButton = new Ext.Toolbar.Button({
					text : 'Excel����',
					tooltip : 'Excel���ݵ���',
					iconCls : 'option',
					handler : function() {
						importExcel();
					}
				});
var itemGrid = new dhc.herp.Grid({
        title: 'ԭʼ֧�����ݲ�ѯ',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusexpendcollectexe.csp',	  
		    atLoad : true, // �Ƿ��Զ�ˢ��
		    loadmask:true,
        fields: [{
		     id:'rowid',
		     header: 'rowid',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'rowid',
		     hidden:true
		}, {
		     id:'yearperiod',
		     header: '��������',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'yearperiod'
		}, {
		     id:'deptcode',
		     header: '���ұ���',
		     allowBlank: true,
		     width:'auto',
		     editable:false,
		     dataIndex: 'deptcode',
		     hidden:true
		}, {
		     id:'deptname',
		     header: '��������',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'deptname'
		   
		},  {
		     id:'itemname',
		     header: '֧�����',
		     allowBlank: true,
		     width:120,
		     editable:false,
		     dataIndex: 'itemname'
		}, {
		     id:'itemvalue',
		     header: '֧�����',
		     allowBlank: true,
		     width:120,
		     editable:true,
		     dataIndex: 'itemvalue'
		}, {
		     id:'sstate',
		     header: '����״̬',
		     allowBlank: true,
		     width:120,
		     editable:false,
		     dataIndex: 'sstate'
		}, {
		     id:'collectdate',
		     header: '�ɼ�ʱ��',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'collectdate'
		}],
        
        tbar:['����:',yearmonth,'����:',deptCombo,'�ɼ��ӿ�:',MethodField,findButton,collectbutton,importButton]
        
});

	 	//itemGrid.hiddenButton(); 	//���ص�n����ť
		itemGrid.btnAddHide() ;	//�������Ӱ�ť
		//itemGrid.btnSaveHide(); 	//���ر��水ť
		itemGrid.btnResetHide(); 	//�������ð�ť
		itemGrid.btnDeleteHide(); //����ɾ����ť
		itemGrid.btnPrintHide() ;	//���ش�ӡ��ť