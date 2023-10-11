//项目中检信息
//why
var aaaa = 'herp.srm.projectmidchecknewdetailauditexe.csp';
//alert(aaaa);
var usercode = session['LOGON.USERCODE'];


var AuditButton  = new Ext.Toolbar.Button({
		text: '通过',  
        iconCls: 'pencil',
        handler:function(){
        var checker =session['LOGON.USERCODE'];
		//定义并初始化行对象
		var rowObj=DetailGrid.getSelectionModel().getSelections();
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("midcheckState")=="不通过"||rowObj[j].get("midcheckState")=="已通过")
		 {
			      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:'herp.srm.projectmidchecknewdetailauditexe.csp?action=audit&RowID='+rowObj[i].get("RowID")+'&checker='+checker,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								DetailGrid.load({params:{start:0, limit:12}});	
								
							}else{
								Ext.Msg.show({title:'错误',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要审核该条记录吗?',handler);
    }
});
  var NoAuditButton = new Ext.Toolbar.Button({
					text : '不通过',
					iconCls: 'pencil',
					handler : function() {
						var rowObj=DetailGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						for(var j= 0; j < len; j++){
							 if(rowObj[j].get("midcheckState")=="不通过"||rowObj[j].get("midcheckState")=="已通过")
							 {
								      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }
						}
						noauditfun();
				   }
  });
//  
// var tbuttonbar = new Ext.Toolbar({   
//        items: [
//        '-',AuditButton,NoAuditButton]   
// }); 
// 

 
var DetailGrid = new dhc.herp.Gridhss({
	title: '项目中检审核明细信息列表',iconCls: 'list',
			region : 'center',
			url : aaaa,	
      //view : new MyGridView(viewConfig),	
      cm : colModel,
      //selModel:sm,
      readerModel:'remote',		
			fields :  [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
				        id:'RowID',
						header : '中检信息ID',
						dataIndex : 'RowID',
						hidden : true
					},
					{
						id : 'rowid',
						header : '课题信息id',
						width : 200,
						hidden : true,
						dataIndex : 'rowid'

					},{
						id : 'Detail',
						header : '中检信息内容',
						width : 180,
						editable:false,
						dataIndex : 'Detail',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id : 'ApplyName',
						header : '申请人',
						editable:false,
						width : 60,
						dataIndex : 'ApplyName'
					},{
						id : 'MidDate',
						header : '申请时间',
						editable:false,
						width : 80,
						dataIndex :'MidDate'

					}, {
						id : 'midcheckFlag',
						header : '数据状态',
						width : 60,
						editable:false,
						dataIndex : 'midcheckFlag'

					},{
						id : 'midcheckState',
						header : '审核状态',
						width : 100,
						editable:false,
						dataIndex : 'midcheckState'

					},{
						id : 'CheckName',
						header : '审核人',
						width : 60,
						editable:false,
						dataIndex : 'CheckName'

					},
					{
						id : 'CheckDate',
						header : '审核时间',
						width : 80,
						editable:false,
						dataIndex : 'CheckDate'

					},{
						id : 'midcheckopinion',
						header : '审批意见',
						width : 100,
						editable:false,
						//hidden:true,
						dataIndex : 'midcheckopinion'
           // type:grafundsField,//引用定义的数值文本框
					},{
						id : 'RelyUnitIDs',
						header : '参加人员ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'RelyUnitIDs'
					}, {
							id:'download',
							header: '下载',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
						

					} }],
					tbar:[AuditButton,'-',NoAuditButton],
					layout:"fit",
					split : true,
					collapsible : true,
					containerScroll : true,
					xtype : 'grid',	
					loadMask: true,
					trackMouseOver: true,
					stripeRows: true
//					listeners : { 'render': function(){ 
//            tbuttonbar.render(this.tbar); 
//        } 
//     }
		});
// DetailGrid.btnAddHide();  //隐藏增加按钮
// DetailGrid.btnSaveHide();  //隐藏保存按钮
// DetailGrid.btnDeleteHide(); 

// DetailGrid.addButton('-');
//  DetailGrid.addButton(AuditButton);
//  DetailGrid.addButton('-');
//  DetailGrid.addButton(NoAuditButton);
//DetailGrid.load({params:{start:0, limit:25,rowid:rowid}});


   downloadMainFun(DetailGrid ,'RowID','C007',13);




