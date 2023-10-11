
var CalcFieldConfUrl='herp.srm.calcfieldconfexe.csp';
///////////��ѯ����/////////////////////////////////////////////////////////////////
//���
var YearSearchDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
YearSearchDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : CalcFieldConfUrl+'?action=yearlist&str='+encodeURIComponent(Ext.getCmp('YearSearchField').getRawValue()),
						method : 'POST'
					});
		});
var YearSearchField = new Ext.form.ComboBox({
            id:'YearSearchField',
			name:'YearSearchField',
			fieldLabel : '���',
			width : 120,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : YearSearchDs,
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
var CodeField = new Ext.form.TextField({
	  id:'CodeField',
    fieldLabel: '����',
	  width:120,
    //allowBlank: false,
    //emptyText:'����...',
    anchor: '95%'
	});
var NameField = new Ext.form.TextField({
	  id:'NameField',
    fieldLabel: '����',
	  width:120,
    //allowBlank: false,
    //emptyText:'����...',
    anchor: '95%'
	});
//ϵͳģ���
var SysModListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
SysModListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : CalcFieldConfUrl+'?action=sysmodelist&str='+encodeURIComponent(Ext.getCmp('SysModListField').getRawValue()),
						method : 'POST'
					});
		});
var SysModListField = new Ext.form.ComboBox({
            id:'SysModListField',
			name:'SysModListField',
			fieldLabel : 'ϵͳģ��',
			width : 120,
			listWidth : 260,
			selectOnFocus : true,
			//allowBlank : false,
			store : SysModListDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
///////////EditGrid�༭������/////////////////////////////////////////////////////////////////
//���
var YearListDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
YearListDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : CalcFieldConfUrl+'?action=yearlist&str='+encodeURIComponent(Ext.getCmp('YearField').getRawValue()),
						method : 'POST'
					});
		});
var YearField = new Ext.form.ComboBox({
            id:'YearField',
			name:'YearField',
			fieldLabel : '���',
			width : 120,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : YearListDs,
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//ϵͳģ���
var SysModDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
SysModDs.on('beforeload', function(ds, o) {
		ds.proxy = new Ext.data.HttpProxy({
						url : CalcFieldConfUrl+'?action=sysmodelist&str='+encodeURIComponent(Ext.getCmp('SysModField').getRawValue()),
						method : 'POST'
					});
		});
var SysModField = new Ext.form.ComboBox({
            id:'SysModField',
			name:'SysModField',
			fieldLabel : 'ϵͳģ��',
			width : 120,
			listWidth : 260,
			selectOnFocus : true,
			allowBlank : false,
			store : SysModDs,
			//anchor : '90%',
			// value:'key', //Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'name',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			//mode : 'local', // ����ģʽ
			editable : true,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
//�Ƿ��������ֶι���
var IsComprehensiveDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '��'], ['0', '��']]
		});
var IsComprehensiveField = new Ext.form.ComboBox({
			fieldLabel : '�Ƿ��������ֶι���',
			width : 120,
			listWidth : 150,
			selectOnFocus : true,
			//allowBlank : false,
			store : IsComprehensiveDs,
			//anchor : '90%',
			value:'1', //Ĭ��ֵ
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
			forceSelection : true
		});
//���㷽��
var CalcMethodDs = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '����ϵ����'], ['2', '��ʽ��'], ['3', '�ȱȲ�����'], ['4', '�ǵȱȲ�����'], ['5', '�оٷ�']]
		});
var CalcMethodField = new Ext.form.ComboBox({
			fieldLabel : '���㷽��',
			width : 120,
			listWidth : 150,
			selectOnFocus : true,
			//allowBlank : false,
			store : CalcMethodDs,
			//anchor : '90%',
			value:'1', //Ĭ��ֵ
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
			forceSelection : true
		});
/////////////////// ��ѯ��ť 
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	//tooltip: '��ѯ',
	iconCls: 'search',
	handler: function(){
	    
		//var year = YearSearchField.getValue();
		var sysno = SysModListField.getValue();
		var code = CodeField.getValue();
		var name = NameField.getValue();
	
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
			SysNO:sysno,
		    Code: code,
		    Name: name
		   }
	  })
  }
});

var itemGrid = new dhc.herp.Grid({
        title: '������м�Ч�����ֶ�ά���б�',
		iconCls: 'list',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: CalcFieldConfUrl,	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      //edit:false,
            hidden: true
        },{
            id:'SysNO',
            header: 'ϵͳģ��',
			      //allowBlank: false,
			      width:150,
            dataIndex: 'SysNO',
			allowBlank:false,
			type:SysModField
        },{
            id:'Code',
            header: '�ֶα���',
			allowBlank: false,
			width:120,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '�ֶ�����',
			allowBlank: false,
			width:150,
            dataIndex: 'Name'
        },{
            id:'CalcMethod',
            header: '���㷽��',
			allowBlank: false,
			width:100,
			hidden:false,
            dataIndex: 'CalcMethod',
			type:CalcMethodField
        },{
            id:'IsComprehensive',
            header: '�Ƿ��������ֶι���',
			//allowBlank: false,
			editable:true,
			width:150,
            dataIndex: 'IsComprehensive',
            type : IsComprehensiveField
        }
		/**,{
            id:'TableIndex',
            header: '�ֶ�ָ���',
			      //allowBlank: false,
			      editable:true,
			      width:200,
            dataIndex: 'TableIndex'
        }**/
		],
        tbar :['','ϵͳģ��','',SysModListField,'','�ֶα���','', CodeField,'','�ֶ�����','',NameField,'-',findButton]
});

    itemGrid.btnResetHide();  //�������ð�ť
    itemGrid.btnPrintHide();  //���ش�ӡ��ť
  //itemGrid.load({	params:{start:0, limit:25}});
