//����
	var yearmonth = new Ext.form.DateField({
		fieldLabel: '����',
		name: 'yearmonth',
		width: 150,
		height:300,
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
					data : [['0', 'ȫ���ɱ�����'],['1', '���ʲ�������'],['2', '��Ա���ʾ���'],['3', '�̶��ʲ��۾�'],['4', '�칫���ñ���'],['90', 'Excel�ֶ�����']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				value : '0',
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
				var myyearmonth,deptcode,tariffTyp, MethodDr;
				if (yearmonth!=undefined){
				 myyearmonth = yearmonth.getRawValue();
				
				}
					
				if (deptCombo!=undefined){	
				 deptcode = deptCombo.getValue();
				}
			    if (MethodField!=undefined){	
				 MethodDr = MethodField.getValue();
				}
				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								yearmonth : myyearmonth,
								deptcode : deptcode,
							    MethodDr : MethodDr
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
			function handler(id){
			if(id=="yes"){
				if (myyearmonth==""){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
				return null;}
				var userid=session['LOGON.USERID'];
				var method=MethodField.getValue();
			
			if (method==""){
				Ext.Msg.show({title:'��ʾ',msg:'��ѡ��ӿ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARING});
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
			}}
				Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ�ɼ�������?',handler);
			}
});
var importButton = new Ext.Toolbar.Button({
					text : 'Excel����',
					tooltip : 'Excel����',
					iconCls : 'option',
					handler : function() {
						importExcel();
					}
				});
					var IsdriectField = new Ext.form.Checkbox({
			fieldLabel : '�Ƿ�'
	});
var itemGrid = new dhc.herp.Grid({
        title: 'ԭʼ֧�����ݲ�ѯ',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusexpendcollectexe.csp',	  
		    //atLoad : true, // �Ƿ��Զ�ˢ��
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
		     width:80,
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
		     width:110,
		     editable:false,
		     dataIndex: 'deptname'
		   
		},  {
		     id:'MethordName',
		     header: '������Դ',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'MethordName'
		},  {
		     id:'itemname',
		     header: '֧�����',
		     allowBlank: true,
		     width:130,
		     editable:false,
		     dataIndex: 'itemname'
		}, {
		     id:'itemvalue',
		     header: '֧�����',
		     allowBlank: true,
		     width:100,
		     align:'right',
		     editable:true,
		     dataIndex: 'itemvalue'
		}, {
		     id:'sstate',
		     header: '����״̬',
		     allowBlank: true,
		     width:100,
		     editable:false,
		     dataIndex: 'sstate'
		}, {
		     id:'collectdate',
		     header: '�ɼ�ʱ��',
		     allowBlank: true,
		     width:110,
		     editable:false,
		     dataIndex: 'collectdate'
		},{
            id:'IaValue',
            header: '�Ƿ���Ч',
			width:80,
            dataIndex: 'IsValue',
            //sortable: true,          
            type : IsdriectField,
            renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        }],
        
        tbar:['����:',yearmonth,'����:',deptCombo,'�ɼ��ӿ�:',MethodField,findButton,collectbutton,importButton]
        
});

	 	//itemGrid.hiddenButton(); 	//���ص�n����ť
		itemGrid.btnAddHide() ;	//�������Ӱ�ť
		//itemGrid.btnSaveHide(); 	//���ر��水ť
		itemGrid.btnResetHide(); 	//�������ð�ť
		itemGrid.btnDeleteHide(); //����ɾ����ť
		itemGrid.btnPrintHide() ;	//���ش�ӡ��ť