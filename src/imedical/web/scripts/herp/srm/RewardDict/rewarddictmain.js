var IsdriectField = new Ext.form.Checkbox({
						fieldLabel : '是否'
});

var CodeField = new Ext.form.TextField({
	  id:'CodeField',
    fieldLabel: '奖励编码',
	  width:120
    //allowBlank: false,
    //emptyText:'奖励编码...'
    //anchor: '95%'
	});
var NameField = new Ext.form.TextField({
	  id:'NameField',
    fieldLabel: '奖励名称',
	  width:120
    //allowBlank: false,
    //emptyText:'奖励名称...'
    //anchor: '95%'
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
        title: '奖项字典信息维护',
        iconCls: 'list',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.srm.rewarddictexe.csp',	  
		    atLoad : true, // 是否自动刷新
		    loadmask:true,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			      edit:false,
            hidden: true
        },{
            id:'Code',
            header: '奖励编码',
			      allowBlank: false,
			      width:100,
            dataIndex: 'Code'
        },{
            id:'Name',
            header: '奖励名称',
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
        }],
        tbar :['','奖励编码','',CodeField,'','奖励名称','',NameField,'-',findButton]
 
});

    
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮
itemGrid.load({	params:{start:0, limit:25}});