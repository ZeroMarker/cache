//����
	var yearmonth = new Ext.form.DateField({
		fieldLabel: '����',
		name: 'yearmonth',
		width: 110,
		listWidth : 180,
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
						url : 'dhc.bonus.module.bonusincomecollectexe.csp'
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
		
//
//	�շ����
var tariffTypeDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

tariffTypeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusincomecollectexe.csp'
								+ '?action=getTariffType&str='
								+ encodeURIComponent(Ext.getCmp('tariffTypeCombo').getRawValue()),
						method : 'POST'
					})
		});

var tariffTypeCombo = new Ext.form.ComboBox({
			id : 'tariffTypeCombo',
			fieldLabel : '�շ����',
			width : 100,
			listWidth : 285,
			//allowBlank : false,
			store : tariffTypeDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'tariffTypeCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
		
var findButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls:'option',
			handler : function() {
				var myyearmonth,deptcode,tariffType;
				if (yearmonth!=undefined){
				myyearmonth = yearmonth.getValue();
				if (myyearmonth!=""){
				myyearmonth=myyearmonth.getFirstDateOfMonth().format("Y-m-d");
				}
				}
					
				if (deptCombo!=undefined){	
				deptcode = deptCombo.getValue();
				}
				if (tariffTypeCombo!=undefined){
				tariffType = tariffTypeCombo.getValue();
				}
				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								yearmonth : myyearmonth,
								deptcode : deptcode,
								tariffType : tariffType
							}
						});

			}
			
		});
		
var collectbutton = new Ext.Toolbar.Button(
		{
			text : '���ݲɼ�',
			tooltip : '���ݲɼ�',
			iconCls : 'option',
			handler : function() {  
				var myyearmonth = yearmonth.getValue();	
				if (myyearmonth==""){
				Ext.Msg.show({title:'ע��',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}
				var indate=myyearmonth.getFirstDateOfMonth().format("Y-m-d");
				//var enddate=myyearmonth.getLastDateOfMonth().format("Y-m-d");
				var progressBar = Ext.Msg.show({
						title : "���ݲɼ�",
						msg : "'���ڲɼ���...",
						width : 300,
						wait : true,
						closable : true
					});
		        Ext.Ajax.request({
				url:'dhc.bonus.module.bonusincomecollectexe.csp?action=collect&date='+indate,
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
								limit : 25,
								yearmonth : indate
								
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
				})
var itemGrid = new dhc.herp.Grid({
        title: 'ԭʼ�������ݲ�ѯ',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusincomecollectexe.csp',	  
		    atLoad : true, // �Ƿ��Զ�ˢ��
		    loadmask:true,
        fields: [{

		     id:'rowid',
		     header: 'rowid',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     hidden:true,
		     dataIndex: 'rowid'
		}, {
		     id:'bonusyear',
		     header: '��������',
		     allowBlank: true,
		     width:80,
		     editable:false,
		     dataIndex: 'bonusyear'
		}, {
		     id:'incomeitemcode',
		     header: '������Ŀ',
		     allowBlank: true,
		     width:110,
		     editable:false,
		     dataIndex: 'incomeitemcode'
		}, {
		     id:'bonusperiod',
		     header: '�����ڼ�',
		     allowBlank: true,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'bonusperiod'
		}, {
		     id:'makebilldeptcode',
		     header: '��������',
		     allowBlank: true,
		     width:120,
		     editable:false,
		     dataIndex: 'makebilldeptcode'
		}, {
		     id:'executedeptcode',
		     header: 'ִ�п���',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'executedeptcode'
		}, {
		     id:'sickdeptcode',
		     header: '���˿���',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'sickdeptcode'
		}, {
		     id:'sicktype',
		     header: '��������',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'sicktype'
		}, {
		     id:'chiefdoctorcode',
		     header: '����ҽʦ',
		     allowBlank: true,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'chiefdoctorcode'
		}, {
		     id:'makebilldoctorcode',
		     header: '����ҽ��',
		     allowBlank: true,
		     hidden:true,
		     width:100,
		     editable:false,
		     dataIndex: 'makebilldoctorcode'
		}, {
		     id:'executedoctorcode',
		     header: 'ִ��ҽ��',
		     allowBlank: true,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'executedoctorcode'
		}, {
		     id:'incomemoney',
		     header: '���',
		     allowBlank: true,
		     width:80,
		     align:'right',
		     editable:true,
		     dataIndex: 'incomemoney'
		}, {
		     id:'state',
		     header: '����״̬',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'state'
		}, {
		     id:'updatedate',
		     header: '�ɼ�ʱ��',
		     allowBlank: true,
		     width:130,
		     editable:false,
		     dataIndex: 'updatedate'
		}],
        
        tbar:['����:',yearmonth,'����:',deptCombo,'�շ����:',tariffTypeCombo,findButton,collectbutton,importButton]
        
});

	 	//itemGrid.hiddenButton(); 	//���ص�n����ť
		itemGrid.btnAddHide() ;	//�������Ӱ�ť
		//itemGrid.btnSaveHide(); //���ر��水ť
		itemGrid.btnResetHide(); 	//�������ð�ť
		itemGrid.btnDeleteHide(); //����ɾ����ť
		itemGrid.btnPrintHide() ;	//���ش�ӡ��ť
