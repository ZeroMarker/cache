var IsSecretaryField = new Ext.form.Checkbox({
	fieldLabel : '是否'
});
var itemGrid = new dhc.herp.Grid({
        title: '收入项目维护',
        width: 800,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusincitemexe.csp',	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
		   	 id:'rowid',
		     header: 'rowid',
		     //allowBlank: false,
		     width:100,
		     hidden:true,
		     editable:false,
		     dataIndex: 'rowid'
		}, {
		     id:'code',
		     header: '项目编码',
		     allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'code'
		 
		}, {
		     id:'name',
		     header: '项目名称',
		     //allowBlank: false,
		     width:100,
		     editable:true,
		     dataIndex: 'name'
		    
		}, {
		     id:'UpdateDate',
		     header: '更新时间',
		     //allowBlank: false,
		     width:100,
		     align:'right',
		  
		     editable:false,
		     dataIndex: 'UpdateDate'
		}, {
		     id:'IsValid',
		     header: '是否有效',
		     align:'right',
		     type : IsSecretaryField,
		     width:100,
		     editable:true,
		     dataIndex: 'IsValid',
		    renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        
		  }], 
		  
		atLoad : true, // 是否自动刷新
        trackMouseOver: true,
		stripeRows: true,
		loadMask: true
		
        
});
itemGrid.btnPrintHide(); 	//隐藏打印按钮
itemGrid.btnResetHide(); 	//隐藏重置按钮

