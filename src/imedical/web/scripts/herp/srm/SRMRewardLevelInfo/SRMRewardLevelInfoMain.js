var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '�Ƿ�'
});
//��¼����ȼ�������
var RewardTypelevel = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '���Ҽ�'], ['2', 'ʡ����'], ['3', '���ּ�']]
			//data : [['1', 'SCIE'], ['2', 'CSTPCD'], ['3', '����']]
		});
var itemGrid = new dhc.herp.Grid({
        title: '�������',
        width: 400,
        edit:true,                   //�Ƿ�ɱ༭
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.rewardlevelinfoexe.csp',	  
		    atLoad : true, // �Ƿ��Զ�ˢ��
		    loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      edit:false,
            hidden: true
        },{
            id:'Code',
            header: '����ȼ�',
			      allowBlank: false,
			      width:100,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '�������',
			      allowBlank: false,
			      width:100,
            dataIndex: 'Name',
            store : RewardTypelevelField
            
        },{
            id:'IsValid',
            header: '�Ƿ���Ч',
			      //allowBlank: false,
			      editable:false,
			      width:100,
            dataIndex: 'IsValid',
            type : IsdriectField,
            renderer : function(v, p, record){
        	//p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        }] 
});

    itemGrid.hiddenButton(3);
    itemGrid.hiddenButton(4);
