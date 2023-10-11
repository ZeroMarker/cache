var JobTypeURL='herp.srm.jobtypeexe.csp';

var itemGrid = new dhc.herp.Grid({
        title: '岗位性质信息维护',
        iconCls: 'list',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: JobTypeURL,	  
		    atLoad : true, // 是否自动刷新
		    loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      edit:false,
            hidden: true
        },{
            id:'Code',
            header: '岗位性质编码',
			      allowBlank: false,
			      width:100,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '岗位性质名称',
			      allowBlank: false,
			      width:100,
            dataIndex: 'Name'
        }] 
});

    itemGrid.hiddenButton(3);
    itemGrid.hiddenButton(4);
