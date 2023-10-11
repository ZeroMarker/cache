var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '是否'
});

var itemGrid = new dhc.herp.Grid({
        title: '论文类别信息维护',
        iconCls: 'list',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.SRMThesisTySexe.csp',	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
	    	id:'code',
            header: '论文类别编码',
			allowBlank: false,
			width:100,
            dataIndex: 'code'    
	    },{
            id:'name',
            header: '论文类别名称',
			allowBlank: false,
			width:180,
            dataIndex: 'name'
        },{
            id:'isValid',
            header: '是否有效',
			//allowBlank: false,
			editable:true,
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
