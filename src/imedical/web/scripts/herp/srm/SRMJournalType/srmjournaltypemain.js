var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '�Ƿ�'
});

var itemGrid = new dhc.herp.Grid({
        title: '����¼���ݿ���Ϣά��',
        iconCls: 'list',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.journaltypeexe.csp',	  
		    atLoad : true, // �Ƿ��Զ�ˢ��
		    loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      edit:false,
            hidden: true
        },{
            id:'Code',
            header: '����¼���ݿ����',
			      allowBlank: false,
			      width:180,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '����¼���ݿ�����',
			      allowBlank: false,
			      width:180,
            dataIndex: 'Name'
        },{
            id:'RewardAmount',
            header: '��������(%)',
			      allowBlank: true,
		    align:'right',
			width:100,
			hidden:true,
            dataIndex: 'RewardAmount',
            renderer: function(val)
         	{
	         	val=val.replace(/(^\s*)|(\s*$)/g, "");
	         	val=Ext.util.Format.number(val,'0.00');
	         	val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         	return val?val:'';
		 	}
        },{
            id:'Reimbursement',
            header: '��������(Ԫ)',
			      allowBlank: true,
			       align:'right',
			      width:100,
            dataIndex: 'Reimbursement',
			hidden:true,
            renderer: function(val)
         	{
	         	val=val.replace(/(^\s*)|(\s*$)/g, "");
	         	val=Ext.util.Format.number(val,'0.00');
	         	val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         	return val?val:'';
		 	}
        },{
            id:'IsValid',
            header: '�Ƿ���Ч',
			      //allowBlank: false,
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
