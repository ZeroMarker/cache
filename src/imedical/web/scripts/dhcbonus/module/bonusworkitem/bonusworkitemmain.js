//var username = session['LOGON.USERCODE'];

var projUrl = 'dhc.bonus.module.bonusworkitemexe.csp';
/////////////////// 项目分类下拉列表 //////////////////

var WorkItemTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'itemtype'])
		});

WorkItemTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						//url : projUrl+'?action=List&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue())+'&userdr='+userdr,method:'POST'
						url : projUrl+'?action=WorkItemTypeList',method:'POST'
					});
		});

var itemtypeCombo = new Ext.form.ComboBox({
			fieldLabel : '项目分类',
			store : WorkItemTypeDs,
			displayField : 'itemtype',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 190,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
		
var itemtypeCombo1 = new Ext.form.ComboBox({
			fieldLabel : '项目分类',
			store : WorkItemTypeDs,
			displayField : 'itemtype',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});		
			

// ///////////////////项目名称
var titleText = new Ext.form.TextField({
	width : 120,
	listWidth : 240,
	pageSize : 10,
	minChars : 1,
	selectOnFocus : true
});
/////////////////// 查询按钮 //////////////////
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	    var ItemTypeID  = itemtypeCombo.getValue();
	    var ItemName = titleText.getValue();
		itemGrid.load({params:{start:0,limit:25,ItemTypeID:ItemTypeID,ItemName:ItemName}});
		
	}
});

 var CheckButton = new Ext.Toolbar.Button({
   	      text : '审核',
					iconCls : 'remove',
					handler : function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			   }
			else
			   {
				   var row = rowObj[0].get("rowid");
				   	Ext.Ajax.request({
							url: projUrl+'?action=CheckList&rowid='+row+'&username='+session['LOGON.USERNAME'],
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:25}});
									window.close();
								}
								else
								{
								  Ext.Msg.show({title:'审核失败',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
			   }
			   //刷新页面
			   itemGrid.load({params:{start:0,limit:25}});
			}
  });

//var itemGrid={};

//var emGrid = new dhc.herp.Grid();

var itemGrid = new dhc.herp.Grid({
        title: '工作量单项奖奖励额度',
        width: 400,
        edit:true,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.module.bonusworkitemexe.csp',	  
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [{
           id: 'ID',
            dataIndex: 'rowid',
			edit:true,
            hidden: true
        },{
            id:'itemtype',
            header: '项目分类',
			allowBlank: true,
			width:100,
			type:itemtypeCombo1,
            dataIndex: 'itemtype'
        },{
            id:'code',
            header: '项目编码',
			allowBlank: true,
			width:100,
            dataIndex: 'code'
        },{
            id:'name',
            header: '工作量项目',
			allowBlank: true,
			width:150,
			//encodeURIComponent(name)
            dataIndex: 'name'
        },{
            id:'price',
            header: '单位奖励额度', 
            allowBlank:true,
            width:100,
            dataIndex: 'price'
        },{
            id:'state',
            header: '数据状态',
			allowBlank: true,
			editable:false,
			width:100,
            dataIndex: 'state'
        },{
            id:'auditperson',
            header: '审核人',
			allowBlank: true,
		    editable:false,
			width:100,
            dataIndex: 'auditperson'
        },{
            id:'auditdate',
            type:'datefield',
            header: '审核时间',
			allowBlank: true,
		    editable:false,
			width:100,
            dataIndex: 'auditdate'
        }],
        
       tbar:['项目分类：',itemtypeCombo,'-','项目名称：',titleText,'-',findButton,'-',CheckButton]
        
});
var datefield =	new Ext.form.DateField({
						id:'datefield',
                        fieldLabel: '审核时间',
                        name: 'datefield',
                        width:190,
                        allowBlank:true,
                        format:'Y-m-d',
						selectOnFocus:'true'
                    })


   
   var UpdateButton = new Ext.Toolbar.Button({
   	      text : '修改',
		  iconCls : 'option',
		  handler : function() {
			var rowObj=itemGrid.getSelectionModel().getSelections();
		  var len = rowObj.length;
		  if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		  }if (len>0){
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");	
			var participantsids = rowObj[i].get("ParticipantsID");	
			
			if(state == "未提交" ){ 
				EditPaperfun(participantsids);}
			else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
			//刷新页面
			//itemGrid.load({params:{start:0,limit:25}});			 
	
  });
   var DeleteButton = new Ext.Toolbar.Button({
   	      text : '删除',
					iconCls : 'remove',
					handler : function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
			}
			if (len>0){
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");	
			//alert(state);
			if(state == "未提交" ){ 
				delFun();}
			else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可删除！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
  });
  
/*  ///////////////////审批
var ChkResultStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '等待审批'], ['1', '通过'], ['2', '不通过']]
		});
var ChkResultField = new Ext.form.ComboBox({
			fieldLabel : '审批结果',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : ChkResultStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : true,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
*/
 
  itemGrid.btnResetHide(); 	//隐藏重置按钮
/*itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏重置按钮
  itemGrid.btnSaveHide(); 	//隐藏重置按钮
  itemGrid.load({params:{start:0, limit:12, userdr:username}});
*/
   
   
    

