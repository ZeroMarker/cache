var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '�Ƿ�'
					});


var itemGrid = new dhc.herp.Grid({
        title: 'ѧ����Ϣά��',
        iconCls: 'list',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.srmcommitteeinfoexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'name',
            header: 'ѧ������',
			allowBlank: false,
			width:180,
            dataIndex: 'name'
        },{
            id:'isValid',
            header: '�Ƿ���Ч',
			//allowBlank: false,
			//editable:false,
			width:80,
            dataIndex: 'isValid',
		    type : IsdriectField,
            renderer : function(v, p, record){
        	//p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}

        }] 
});

    itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
itemGrid.load({params:{sortField:'', sortDir:'',start:0,limit:25}});     