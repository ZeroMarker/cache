var subjNameMain = new dhc.herp.Grid({
        title: '会计科目性质',
		iconCls:'find',
        width: 400,
        edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.acct.syssubjnatureexe.csp',	  
		//tbar:delButton,
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
            header: '科目性质体系ID',
            dataIndex: 'rowid',
			edit:false,
			editable:false,
            hidden: true
        },{
            id:'code',
            header: '科目性质编码',
			allowBlank: false,
			width:150,
			update:true,
			editable:false,
            dataIndex: 'code'
        },{
            id:'name',
            header: '科目性质名称',
			allowBlank: false,
			width:180,
			update:true,
			editable:false,
            dataIndex: 'name'
        },{
            id:'note',
            header: '备注',
			allowBlank: true,
			align:'center',
			width:260,
			update:true,
			editable:false,
            dataIndex: 'note'
        }] 
});
	//var peg = new PrintExtgrid(this);
	subjNameMain.hiddenButton(0);
	subjNameMain.hiddenButton(1);
	subjNameMain.hiddenButton(2);	
    subjNameMain.hiddenButton(3);
	subjNameMain.hiddenButton(4);
	
