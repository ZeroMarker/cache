
var itemGrid = new dhc.herp.Grid({
        title: '计量单位维护',
        width: 400,
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.budg.budgcalunitexe.csp',	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'code',
            header: '代码',
			allowBlank: false,
			width:200,
            dataIndex: 'code'
        },{
            id:'name',
            header: '名称',
			allowBlank: false,
			width:200,
            dataIndex: 'name'
        }] 
});

    itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
