var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '�Ƿ�'
});

var CodeField = new Ext.form.TextField({
	  id:'CodeField',
    fieldLabel: 'ISSN',
	  width:180,
    allowBlank: false,
    ////emptyText:'ISSN...',
    anchor: '95%'
	});
var NameField = new Ext.form.TextField({
	  id:'NameField',
    fieldLabel: '�ڿ�����',
	  width:180,
    allowBlank: false,
    //emptyText:'�ڿ�����...',
    anchor: '95%'
	});

/////////////////// ��ѯ��ť 
var findButton = new Ext.Toolbar.Button({
	text: '��ѯ',
	tooltip: '��ѯ',
	iconCls: 'search',
	handler: function(){
	    
		var code = CodeField.getValue();
		var name = NameField.getValue();
	
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
		    code: code,
		    name: name
		   }
	  })
  }
});

var itemGrid = new dhc.herp.Grid({
        title: '�ڿ��ֵ���Ϣά��',
		iconCls: 'list',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.journaldictexe.csp',	  
		    atLoad : true, // �Ƿ��Զ�ˢ��
		    loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      //edit:false,
            hidden: true
        },{
            id:'Code',
            header: 'ISSN',
			allowBlank: false,
			width:180,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '�ڿ�����',
			allowBlank: false,
			width:180,
            dataIndex: 'Name'
        },{
            id:'CNCode',
            header: 'CN��',
			allowBlank: true,
			      width:100,
			      hidden:true,
            dataIndex: 'CNCode'
        },{
            id:'IsValid',
            header: '�Ƿ���Ч',
			      //allowBlank: false,
			      //editable:false,
			      width:80,
            dataIndex: 'IsValid',
            type : IsdriectField,
            renderer : function(v, p, record){
        	//p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        }],
        tbar :['','�ڿ�����','',CodeField,'','�ڿ�����','',NameField,'-',findButton]
});

   itemGrid.btnResetHide();  //�������ð�ť
    itemGrid.btnPrintHide();  //���ش�ӡ��ť
itemGrid.load({	params:{start:0, limit:25}});
