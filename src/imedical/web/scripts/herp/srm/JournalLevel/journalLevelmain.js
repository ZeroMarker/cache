var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '是否'
});

var itemGrid = new dhc.herp.Grid({
        title: '期刊级别信息维护',
		iconCls: 'list',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.JournalLevelexe.csp',	  
		    atLoad : true, // 是否自动刷新
		    loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      edit:false,
            hidden: true
        },{
            id:'Code',
            header: '期刊级别编码',
			      allowBlank: false,
			      width:100,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '期刊级别名称',
			      allowBlank: false,
			      width:180,
            dataIndex: 'Name'
        },{
            id:'IsValid',
            header: '是否有效',
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
