var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '是否'
});

var CodeField = new Ext.form.TextField({
	  id:'CodeField',
    fieldLabel: 'ISSN',
	  width:180,
    allowBlank: false,
    ////emptyText:'ISSN...',
    anchor: '95%'
	});
var NameField = new Ext.form.TextField({
	  id:'NameField',
    fieldLabel: '期刊名称',
	  width:180,
    allowBlank: false,
    //emptyText:'期刊名称...',
    anchor: '95%'
	});

/////////////////// 查询按钮 
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'search',
	handler: function(){
	    
		var code = CodeField.getValue();
		var name = NameField.getValue();
	
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
		    code: code,
		    name: name
		   }
	  })
  }
});

var itemGrid = new dhc.herp.Grid({
        title: '期刊字典信息维护',
		iconCls: 'list',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.journaldictexe.csp',	  
		    atLoad : true, // 是否自动刷新
		    loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      //edit:false,
            hidden: true
        },{
            id:'Code',
            header: 'ISSN',
			allowBlank: false,
			width:180,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '期刊名称',
			allowBlank: false,
			width:180,
            dataIndex: 'Name'
        },{
            id:'CNCode',
            header: 'CN码',
			allowBlank: true,
			      width:100,
			      hidden:true,
            dataIndex: 'CNCode'
        },{
            id:'IsValid',
            header: '是否有效',
			      //allowBlank: false,
			      //editable:false,
			      width:80,
            dataIndex: 'IsValid',
            type : IsdriectField,
            renderer : function(v, p, record){
        	//p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';}
        }],
        tbar :['','期刊编码','',CodeField,'','期刊名称','',NameField,'-',findButton]
});

   itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮
itemGrid.load({	params:{start:0, limit:25}});
