var userdr = session['LOGON.USERCODE'];    
var projUrl = 'herp.srm.AuditPrjAppropriationexe.csp';


		
// ////////////项目名称
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});


//////////////审批结果///////////////
var ChkResultStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '等待审批'], ['2', '通过'], ['3', '不通过']]
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

///////////查询按钮////////////// 
function srmFundApply(){

	    var PName = titleText.getValue();
		var ChkResult = ChkResultField.getValue();
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
		    PName: PName,
			userdr:userdr,
			ChkResult:ChkResult
		 }
	  });
  }


var queryPanel = new Ext.FormPanel({
	title: '项目到位经费审核信息查询',
			iconCls: 'search',
			autoHeight : true,
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
				items:[{
				xtype: 'panel',
				layout:"column",
				items: [
				    {
					xtype : 'displayfield',
					value : '<p style="text-align:right;">项目名称</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
					titleText,
					{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
					{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">审批结果</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
					ChkResultField,
					{
					xtype : 'displayfield',
					value : '',
					width : 30
				},
					{
						width : 30,
						xtype:'button',
						text: '查询',
						handler:function(b){
							srmFundApply();
						},
						iconCls: 'search'
					}		
				]
			}
			]
		});

var itemGrid = new dhc.herp.Grid({
		    region : 'center',
		    title: '项目到位经费审核信息查询列表',
			iconCls: 'list',
		    url: projUrl,
			fields : [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			        {
				        id:'RowID',
						header : '到位经费信息ID',
						dataIndex : 'RowID',
						hidden : true
					},{
						id : 'name',
						header : '项目名称',
						width : 180,
						editable:false,
						dataIndex : 'name',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},
					{
						id : 'arriveexpenditure',
						header : '到位经费(万元)',
						width : 100,
						//editable:false,
						editable:false,
						align : 'right',
						dataIndex : 'arriveexpenditure',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id : 'recipient',
						header : '接收人',
						width : 60,
						//editable:false,
						editable:false,
						dataIndex : 'recipient'
					},{
       					id:'ArriveDate',
        				header: '到位时间',
        				width:80,
						//tip:true,
						editable:false,
        				dataIndex: 'ArriveDate',
        				type:'dateField'

					},{
       					id:'FundSources',
        				header: '项目经费来源',
        				width:180,
						//tip:true,
						editable:false,
        				dataIndex: 'FundSources',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
    				},{
       					id:'FundForm',
        				header: '经费形式',
        				width:120,
						//tip:true,
						editable:false,
        				dataIndex: 'FundForm'
    				},{
						id : 'midcheckFlag',
						header : '数据状态',
						width : 60,
						editable:false,
						dataIndex : 'midcheckFlag'
					},{
						id : 'ChkResult',
						header : '审批结果',
						editable:false,
						width : 120,
						hidden : true,
						dataIndex : 'ChkResult'
					},{
						id : 'midcheckState',
						header : '审核状态',
						width : 180,
						editable:false,
						dataIndex : 'midcheckState'
					},{
						id : 'Desc',
						header : '审批意见',
						width : 180,
						editable:false,
						//hidden:true,
						dataIndex : 'Desc'
					},{
						id : 'ApplyName',
						header : '录入人',
						editable:false,
						width : 60,
						dataIndex : 'ApplyName'
					},{
						id : 'MidDate',
						header : '录入时间',
						editable:false,
						width : 80,
						dataIndex :'MidDate'
					},{
						id : 'CheckName',
						header : '审核人',
						width : 60,
						//hidden : true,
						editable:false,
						dataIndex : 'CheckName'
					},{
						id : 'CheckDate',
						header : '审核时间',
						width : 80,
						editable:false,
						//hidden : true,
						dataIndex : 'CheckDate'
					}]					
		});
		
var AuditButton  = new Ext.Toolbar.Button({
		text: '通过',  
        id:'auditButton', 
        iconCls: 'pencil',
        handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		var checker = session['LOGON.USERCODE'];
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("ChkResult")!='等待审批')
		    
		 {
			      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){		
					    Ext.Ajax.request({
						url:'herp.srm.AuditPrjAppropriationexe.csp?action=audit&RowID='+rowObj[i].get("RowID")+'&checker='+checker,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25,userdr:userdr}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'审核失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
						var rowObj=itemGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						for(var j= 0; j < len; j++){
							 if(rowObj[j].get("ChkResult")!='等待审批')
							 {
								      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }
						}
						noauditfun();
				   }
  });
  
  itemGrid.addButton('-');
  itemGrid.addButton(AuditButton);
  itemGrid.addButton('-');
  itemGrid.addButton(NoAuditButton);

  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏重置按钮
  itemGrid.btnSaveHide(); 	//隐藏重置按钮
  itemGrid.load({params:{start:0, limit:12, userdr:userdr}});


//downloadMainFun(itemGrid,'rowid','P001',24);
