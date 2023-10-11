
var userdr = session['LOGON.USERID'];
var projUrl  = 'herp.budg.budgadjustdeptyearauditdetailexe.csp'; 

////////////////  多表头  ///////////////////////
var row = [
 	{ header: '', colspan: 1, align: 'center' },  
    { header: '科目编码', colspan: 2, align: 'left' },//header表示父表头标题，colspan表示包含子列数目  
    { header: '科目名称', colspan: 1, align: 'left' },  
    { header: '预算调整', colspan: 4, align: 'center' },  
    { header: '与上年执行比较', colspan: 3, align: 'center' }, 
    { header: '参考方法', colspan: 1, align: 'left' },
    { header: '审批意见', colspan: 1, align: 'left' },
    { header: '审核状态', colspan: 1, align: 'left' },
    { header: '调整序号', colspan: 1, align: 'left' }
     
   ];  
var group = new Ext.ux.grid.ColumnHeaderGroup({  
       rows: [row]  
   }); 


///////////////// 审核按钮 ///////////////////
var auditButton = new Ext.Toolbar.Button({
	text: '审核',
    tooltip:'审核',        
    iconCls:'option',
    handler:function(){
	
	var selectedRow = itemMain.getSelectionModel().getSelections();
	
	var len = selectedRow.length;
	    	 
    if(len=="") //判断是否选择了要修改的数据
    {
		Ext.Msg.show({title:'错误',msg:'请选择需要操作的记录！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	};
				
	var SchemDr=selectedRow[0].data['rowid'];
	var auditdr=selectedRow[0].data['bsarowid'];
	var bsachkstate=selectedRow[0].data['bsachkstate'];
		 
	auditFun(SchemDr,auditdr);
	}
});


////////////////// 取消审核按钮 //////////////////
var cancleauditButton = new Ext.Toolbar.Button({
	text: '取消审核',
    tooltip:'取消审核',        
    iconCls:'reset',
    handler:function(){
 
	 var selectedRow = itemMain.getSelectionModel().getSelections();
 
	 var len=selectedRow.length;
	 if(len=="")
     {
		Ext.Msg.show({title:'错误',msg:'请选择需要操作的记录！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	 }

	 var SchemDr=selectedRow[0].data['rowid'];
	 var auditdr=selectedRow[0].data['bsarowid'];
	
	 Ext.MessageBox.confirm('提示','是否撤销', function(btn){
	 if(btn=="yes")
	 {
		 Ext.Ajax.request({
					url:projUrl+'?action=cancleaudit&SchemDr='+SchemDr+'&auditdr='+auditdr+'&userdr='+userdr,
					waitMsg:'撤销中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if (jsonData.success=='true')
						{					
							Ext.Msg.show({title:'注意',msg:'撤销审核成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});							
							itemMain.load({params:{start:0, limit:12,userdr:userdr}});	
					    }
						else if(jsonData.info=='RepName')
						{
							Ext.Msg.show({title:'错误',msg:'尚未审核或者下一个人已经审核!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						
						}	
					},
					scope: this
						});
		}
      })
    }
}) 

var itemDetail = new dhc.herp.Gridwolf({
    title: '',
    region : 'center',
    tbar:[auditButton,cancleauditButton],
    layout:"fit",
	split : true,
	collapsible : true,
	xtype : 'grid',
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	atLoad: true,
	height : 250,
	trackMouseOver: true,
	stripeRows: true,
    atLoad : true, // 是否自动刷新
    url: projUrl,
    plugins: group,
    
    fields: [
    {
        id:'rowid',
        header: 'ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{
        id:'pfitemcode',
        //header: '科目编码',
        dataIndex: 'pfitemcode',
        width:150,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: false
    },{
        id:'bidname',
        //header: '科目名称',
        dataIndex: 'bidname',
        width:200,
        update:true,
        allowBlank: true,
		editable:false,
		hidden: false
    },{ 
        id:'sumpfplanvalue',
        header: '期初预算',
        dataIndex: 'sumpfplanvalue',
        align:'right',
        width:150,
        allowBlank: true,
		editable:false,
		hidden: false
    },{
        id:'pfplanvalue',
        header: '本次调整',
        width:150,
		allowBlank: true,
		align:'right',
		editable:false,
        dataIndex: 'pfplanvalue'	
    }, {
        id:'adjustrange',   
        header: '调整幅度',
        align:'right',
        width:100,
        editable:false,
        allowBlank: true,
        dataIndex: 'adjustrange'
		
    },{
        id:'afteradjust',
        header: '调整后预算',
        align:'right',
        width:150,
		allowBlank: true,
		editable:false,
        dataIndex: 'afteradjust'
		
    },{
        id:'pfrealvalueLast',
        header: '上年执行',
        align:'right',
        width:150,
		allowBlank: true,
		editable:false,
        dataIndex: 'pfrealvalueLast'
    },{
    	id:'balance',
        header: '差额',
        align:'right',
        width:150,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'balance'
    },{
    	id:'differenceratio',
        header: '差异率(%)',
        align:'right',
        width:100,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'differenceratio'
    },{
        id:'bsdcaldesc',
        //header: '参考方法',
        width:100,
		allowBlank: false,
		editable:false,
        dataIndex: 'bsdcaldesc'
		
    }, {
        id:'bfchkdesc',
        //header: '审批意见',
        width:150,
		allowBlank: true,
		editable:false,
        dataIndex: 'bfchkdesc'
		
    },{
    	id:'ischeck',
        //header: '审批状态',
        width:100,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'ischeck'
    },{
    	id:'bfadjustno',
        //header: '调整序号',
        align:'right',
        width:100,
	    allowBlank: true,
	    editable:false,
	    hidden:true,
	    update:true,
        dataIndex: 'bfadjustno'
    }]
	

});

// pfitemcode bidname  sumpfplanvalue pfplanvalue adjustrange afteradjust pfrealvalueLast 
// balance differenceratio   bsdcaldesc   bfchkdesc    ischeck		




