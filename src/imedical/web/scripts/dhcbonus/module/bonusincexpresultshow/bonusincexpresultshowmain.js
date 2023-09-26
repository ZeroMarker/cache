var userid=session['LOGON.USERNAME'];

//����
	var yearmonth = new Ext.form.DateField({
		fieldLabel: '����',
		name: 'yearmonth',
		width: 150,
		//value: (new Date()).getFullYear() + "" + "01",
		plugins: 'monthPickerPlugin',
		format: 'Ym',
		editable: false,
                  listeners:{'select':function(combo,record,index){
                          deptCombo.setValue("");
                          }} 
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
						url : 'dhc.bonus.module.bonusincexpresultshowexe.csp'
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
			editable : true,
                        listeners:{'select':function(combo,record,index){
                          yearmonth.setValue("");
                          }} 
		});

		

			
var auditbutton = new Ext.Toolbar.Button(
		{
			text : '���',
			tooltip : '���',
			iconCls : 'option',
			handler : function() {
				if (yearmonth!=undefined){
				myyearmonth = yearmonth.getValue();
				if (myyearmonth!=""){
				myyearmonth=myyearmonth.getFirstDateOfMonth().format("Y-m-d");
				}else{				Ext.Msg.show({title:'����',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}
				}
				
		         
		        if (deptCombo!=undefined){	
				deptcode = deptCombo.getValue();
				}
				    
		        Ext.Ajax.request({
				url:'dhc.bonus.module.bonusincexpresultexe.csp?action=audit&yearmonth='+myyearmonth+"&user="+userid,
		
				waitMsg:'�����...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
											itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								yearmonth : myyearmonth,
								deptcode : deptcode
							}
						});	
				}
				},
				scope: this
				});
			}
});


var calculator = new Ext.Toolbar.Button(
		{
			text : '����',
			tooltip : '����',
			iconCls : 'option',
			handler : function() {
				
				if (yearmonth!=undefined){
				myyearmonth = yearmonth.getValue();
				if (myyearmonth!=""){
				myyearmonth=myyearmonth.getFirstDateOfMonth().format("Y-m-d");
				}else{				Ext.Msg.show({title:'����',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}
				}
				
		         
		        if (deptCombo!=undefined){	
				deptcode = deptCombo.getValue();
				}
		        Ext.Ajax.request({
				url:'dhc.bonus.module.bonusincexpresultexe.csp?action=calculator&yearmonth='+myyearmonth+"&user="+userid,
		
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'����ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
									itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								yearmonth : myyearmonth,
								deptcode : deptcode
							}
						});		
				}
				},
				scope: this
				});
			}
		});
var findButton = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '��ѯ',
			iconCls:'option',
			handler : function() {

				if (yearmonth!=undefined){
				myyearmonth = yearmonth.getValue();
				if (myyearmonth!=""){
				myyearmonth=myyearmonth.getFirstDateOfMonth().format("Y-m-d");
				}
				}
					
				if (deptCombo!=undefined){	
				deptcode = deptCombo.getValue();
				}
                             //������Ǭ����
                              var reportFrame = document.getElementById("frameReport"); 
                              var p_URL = 'dhccpmrunqianreport.csp?reportName=dhcBonusModuleBonusIncExp.raq'
				+'&yearmonth='+myyearmonth+'&deptcode='+deptcode;
                              reportFrame.src=p_URL;
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
		
var itemGrid = new dhc.herp.Grid({
        title: '����������',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusincexpresultexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{

		     id:'yearmonth',
		     header: '����',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'yearmonth'
		}, {
		     id:'deptcode',
		     header: '���ұ���',
		     allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'deptcode'
		}, {
		     id:'deptname',
		     header: '��������',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'deptname'
		}, {
		     id:'myin',
		     header: '����',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'myin',
 		      renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
			return '<font color="blue" onclick="income(\''+record.data.deptcode+'\',\''+record.data.yearmonth+'\')">'+value+'</blue>';
			
			}
		}, {
		     id:'myout',
		     header: '֧��',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'myout',
		      renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
			return '<font color="blue" onclick="expend(\''+record.data.deptcode+'\',\''+record.data.yearmonth+'\')">'+value+'</blue>';
			
			}

		}, {
		     id:'myleave',
		     header: '����',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'myleave'
		}, {
		     id:'checkdate',
		     header: '���ʱ��',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'checkdate'
		}, {
		     id:'checkman',
		     header: '�����',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'checkman'
		}, {
		     id:'state',
		     header: '���״̬',
		     allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'state'
		}]
		,
        
        tbar:['����:',yearmonth,'����:',deptCombo,findButton/*,calculator,auditbutton*/]
        
});
 //�����޸İ�ť��Ӧ����
 
		itemGrid.btnAddHide() ;	//�������Ӱ�ť
		itemGrid.btnSaveHide(); 	//���ر��水ť
		itemGrid.btnResetHide(); 	//�������ð�ť
		itemGrid.btnDeleteHide(); //����ɾ����ť
		itemGrid.btnPrintHide() ;	//���ش�ӡ��ť
//itemGrid.tbar.push(auditbutton);