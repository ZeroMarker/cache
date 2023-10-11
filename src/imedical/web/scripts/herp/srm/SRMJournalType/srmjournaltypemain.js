var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '是否'
});

var itemGrid = new dhc.herp.Grid({
        title: '被收录数据库信息维护',
        iconCls: 'list',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.journaltypeexe.csp',	  
		    atLoad : true, // 是否自动刷新
		    loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      edit:false,
            hidden: true
        },{
            id:'Code',
            header: '被收录数据库编码',
			      allowBlank: false,
			      width:180,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '被收录数据库名称',
			      allowBlank: false,
			      width:180,
            dataIndex: 'Name'
        },{
            id:'RewardAmount',
            header: '报销比例(%)',
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
            header: '报销上限(元)',
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
