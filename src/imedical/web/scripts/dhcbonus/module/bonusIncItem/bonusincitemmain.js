var IsSecretaryField = new Ext.form.Checkbox({
	fieldLabel : '�Ƿ�'
});
var itemGrid = new dhc.herp.Grid({
        title: '������Ŀά��',
        width: 800,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusincitemexe.csp',	  
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
		     id:'code',
		     header: '��Ŀ����',
		     allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'code'
		 
		}, {
		     id:'name',
		     header: '��Ŀ����',
		     //allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'name'
		    
		}, {
		     id:'UpdateDate',
		     header: '����ʱ��',
		     //allowBlank: false,
		     width:100,
		     align:'right',
		  
		     editable:false,
		     dataIndex: 'UpdateDate'
		}, {
		     id:'IsValid',
		     header: '�Ƿ���Ч',
		     align:'right',
		     type : IsSecretaryField,
		     width:100,
		     editable:true,
		     dataIndex: 'IsValid',
		    renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        
		  }], 
		  
		atLoad : true, // �Ƿ��Զ�ˢ��
        trackMouseOver: true,
		stripeRows: true,
		loadMask: true
		
        
});
itemGrid.btnPrintHide(); 	//���ش�ӡ��ť
itemGrid.btnResetHide(); 	//�������ð�ť

