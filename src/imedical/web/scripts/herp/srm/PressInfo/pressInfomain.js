var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '�Ƿ�'
});

var itemGrid = new dhc.herp.Grid({
        title: '��������Ϣά��',
        iconCls: 'list',
        width: 500,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.PressInfoexe.csp',	  
		    atLoad : true, // �Ƿ��Զ�ˢ��
		    loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      editable:false,
            hidden: true
        },{
            id:'Code',
            header: '���������',
			      allowBlank: false,
			      width:100,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '����������',
			      allowBlank: false,
			      width:180,
            dataIndex: 'Name'
        },{
            id:'Address',
            header: '�������ַ',
			      allowBlank: false,
			      width:180,
            dataIndex: 'Address'
        },{
            id:'Level',
            header: '�����缶��',
			      allowBlank: false,
			      width:100,
            dataIndex: 'Level'
        },{
            id:'IsValid',
            header: '�Ƿ���Ч',
			editable:true,
			 width:80,
            dataIndex: 'IsValid',
            type : IsdriectField,
            renderer : function(v, p, record){
        	//p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        }] 
});

    itemGrid.hiddenButton(3);
    itemGrid.hiddenButton(4);
