var userid=session['LOGON.USERNAME'];
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
			allowBlank : false,
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
//���ڲ�ѯ
var sDeptCombo = new Ext.form.ComboBox({
			id : 'deptCombo',
			fieldLabel : '����',
			width : 100,
			listWidth : 285,
			allowBlank : false,
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
//	����
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
						url : 'dhc.bonus.module.bonusincomerateexe.csp'
								+ '?action=getItem&str='
								+ encodeURIComponent(Ext.getCmp('tariffTypeCombo').getRawValue()),
						method : 'POST'
					})
		});

var tariffTypeCombo = new Ext.form.ComboBox({
			id : 'tariffTypeCombo',
			fieldLabel : '�շ����',
			width : 100,
			listWidth : 285,
			allowBlank : false,
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
//���ڲ�ѯ
//	����
var stariffTypeDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

stariffTypeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusincomerateexe.csp'
								+ '?action=getItem&str='
								+ encodeURIComponent(Ext.getCmp('sTariffTypeCombo').getRawValue()),
						method : 'POST'
					})
		});

var sTariffTypeCombo = new Ext.form.ComboBox({
			id : 'sTariffTypeCombo',
			fieldLabel : '�շ����',
			width : 100,
			listWidth : 285,
			allowBlank : false,
			store : stariffTypeDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'sTariffTypeCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
/*
var sikeType = new Ext.form.ComboBox({												
				fieldLabel: '�������',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['1', '����'], ['2', 'סԺ'],['3', '����'], ['4', '���'], ['9', '����']]
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
			
//���ڲ�ѯ

var ssickType = new Ext.form.ComboBox({												
				fieldLabel: '�������',
				width:180,
				anchor: '95%',
				store : new Ext.data.ArrayStore({
					fields : ['rowid', 'name'],
					data : [['0', 'ȫ��'], ['1', '����'], ['2', 'סԺ'],['3', '����'], ['4', '���'], ['9', '����']]
				}),
				displayField : 'name',
				valueField : 'rowid',
				typeAhead : true,
				mode : 'local',
				//value : '0',
				forceSelection : true,
				triggerAction : 'all',
				emptyText : 'ѡ��...',
				selectOnFocus:'true'
			});	
			*/
			var deptGroupDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptGroupDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusincomerateexe.csp'
								+ '?action=getDeptGroup&str='
								+ encodeURIComponent(Ext.getCmp('deptGroupCombo').getRawValue()),
						method : 'POST'
					})
		});

var deptGroupCombo = new Ext.form.ComboBox({
			id : 'deptGroupCombo',
			fieldLabel : '����',
			width : 100,
			listWidth : 285,
			allowBlank : false,
			store : deptGroupDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'deptGroupCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
//���ڲ�ѯ
	var sdeptGroupDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'name'])
		});

sdeptGroupDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'dhc.bonus.module.bonusincomerateexe.csp'
								+ '?action=getDeptGroup&str='
								+ encodeURIComponent(Ext.getCmp('sdeptGroupCombo').getRawValue()),
						method : 'POST'
					})
		});
var sDeptGroupCombo = new Ext.form.ComboBox({
			id : 'sdeptGroupCombo',
			fieldLabel : '����',
			width : 100,
			listWidth : 285,
			allowBlank : false,
			store : deptGroupDs,
			valueField : 'rowid',
			displayField : 'name',
			triggerAction : 'all',
			emptyText : '',
			name : 'sdeptGroupCombo',
			minChars : 1,
			pageSize : 10,
			selectOnFocus : true,
			forceSelection : 'true',
			editable : true
		});
			

var auditbutton = new Ext.Toolbar.Button(
		{
			text : '���',
			tooltip : '���',
			iconCls : 'option',
			handler : function() {
				var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");     
		        Ext.Ajax.request({
				url:'dhc.bonus.module.bonusincomerateexe.csp?action=audit&rowid='+rowid+"&checker="+userid,
		
				waitMsg:'�����...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'��˳ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGrid.load({params:{start:0, limit:25}});		
				}
				},
				scope: this
				});
			}
});


var unauditbutton = new Ext.Toolbar.Button(
		{
			text : 'ȡ�����',
			tooltip : 'ȡ�����',
			iconCls : 'option',
			handler : function() {
			var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");     
		        Ext.Ajax.request({
				url:'dhc.bonus.module.bonusincomerateexe.csp?action=unaudit&rowid='+rowid+"&c+hecker="+userid,
		
				waitMsg:'ȡ�������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
		
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'ȡ����˳ɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					itemGrid.load({params:{start:0, limit:25}});		
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

				if (sTariffTypeCombo!=undefined){
			 var tartype = sTariffTypeCombo.getValue();

				}
					
				if (sdeptGroupCombo!=undefined){	
			 var sicktype =sDeptGroupCombo.getValue();
				}

				itemGrid.load({
							params : {
								start : 0,
								limit : 25,
								tartype : tartype,
								DeptGroupName : sicktype
							}
						});

			}
			
		})
    function pctChange(val) {
        if (val > 0) {
            return '<span >' + val*100 + '%</span>';
        } else if (val < 0) {
            return '<span >' + val*100 + '%</span>';
        }
        return val;
    }
var itemGrid = new dhc.herp.Grid({
        title: '����������ά��',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusincomerateexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
		   	 id:'rowid',
		     header: 'rowid',
		     //allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'rowid'
		}, {
		     id:'IncItemCode',
		     header: '�շ����',
		     allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'IncItemCode',
		     type:tariffTypeCombo
		}, {
		     id:'DeptGroupName',
		     header: '������',
		     //allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'DeptGroupName',
		     type:deptGroupCombo
		}, {
		     id:'makebilldeptrate',
		     header: '������ɱ���',
		     //allowBlank: false,
		     width:100,
		     align:'right',
		     renderer : pctChange, 
		     editable:true,
		     dataIndex: 'makebilldeptrate'
		}, {
		     id:'executedeptrate',
		     header: 'ִ����ɱ���',
		     //allowBlank: false,
		     align:'right',
		     renderer : pctChange, 
		     width:100,
		     editable:true,
		     dataIndex: 'executedeptrate'
		}, {
		     id:'sickdeptrate',
		     header: '���˿�����ɱ���',
		     align:'right',
		     //allowBlank: false,
		     renderer : pctChange, 
		     width:100,
		     editable:true,
		     dataIndex: 'sickdeptrate'
		}, {
		     id:'checkman',
		     header: '�����',
		     //allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'checkman'
		}, {
		     id:'checkdate',
		     header: '���ʱ��',
		     //allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'checkdate'
		}, {
		     id:'updatedate',
		     header: '����ʱ��',
		    // allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'updatedate'
		}, {
		     id:'state',
		     header: '����״̬',
		     //allowBlank: false,
		     width:100,
		     editable:false,
		     dataIndex: 'state'
		}],
        
        tbar:['�շ�����:',sTariffTypeCombo,'������:',sDeptGroupCombo,findButton,auditbutton,'-',unauditbutton]
        
});
 //�����޸İ�ť��Ӧ����
auditHandler = function(){
		
       
};
//itemGrid.tbar.push(auditbutton);