var userdr = session['LOGON.USERCODE'];    
var projUrl = 'herp.srm.srmauditapplypaperexe.csp';
/**
Ext.Ajax.request({
					url: projUrl+'?action=GetUserdr&userdr='+userdr,			
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var bcodes = jsonData.info;													
						}else{
						    message="对不起，您没有审核权限!";
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					}
 });
**/
///////////////////类型/////////////////////////////  
var TypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '科研'],['2', '教学']]
	});		
		
var TypeCombox = new Ext.form.ComboBox({
	                   id : 'TypeCombox',
		           fieldLabel : '类型',
	                   width : 120,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : TypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true,
				   labelSeparator:''
						  });	
//////////////////////定义起始时间控件
	var PSField = new Ext.form.DateField({
		id : 'PSField',
		//format : 'Y-m-d',
		width : 120
		//emptyText : ''
	});
	var PEField = new Ext.form.DateField({
		id : 'PEField',
		//format : 'Y-m-d',
		width : 120
		//emptyText : ''	
	});
	
/////////////////////科室名称
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()), 
                        method:'POST'
					});
		});

var deptCombo = new Ext.form.ComboBox({
            id:'deptCombo',
			fieldLabel : '科室名称',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''

		});


/////////////////////论文题目///////////
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true,
	labelSeparator:''

});

//////////////////第一作者///////////  
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList&str='+encodeURIComponent(Ext.getCmp('user1Combo').getRawValue()), 
						method : 'POST'
					});
		});

var user1Combo = new Ext.form.ComboBox({
            id:'user1Combo',
			fieldLabel : '第一作者 ',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			//typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			labelSeparator:''

		});
		
//////////////作者///////////  
/*
var user2Ds = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

user2Ds.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList'+'&str='+encodeURIComponent(Ext.getCmp('AuthorName').getRawValue()), 
						method : 'POST'
					});
		});

var AuthorName = new Ext.form.ComboBox({
            id:'AuthorName',
			fieldLabel : '作者 ',
			store : user2Ds,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			//emptyText : '',
			name:'AuthorName',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
*/	
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
			//emptyText : '',
			mode : 'local', // 本地模式
			editable : true,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			labelSeparator:''

         });

// ///////////////////期刊名称
var JournalNameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


JournalNameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.paperpublishregisterexe.csp'+'?action=GetJournalDict&str='+encodeURIComponent(Ext.getCmp('JournalName').getRawValue()),method:'POST'});
});

var JournalName = new Ext.form.ComboBox({
	id: 'JournalName',
	fieldLabel: '期刊名称',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:JournalNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择期刊名称...',
	name: 'JournalName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	labelSeparator:''

});

///////////查询按钮////////////// 
function srmFundApply(){
	    var startdate= PSField.getRawValue();
	    if (startdate!=="")
	    {
	       //startdate=startdate.format ('Y-m-d');
	    }
	    //alert(startdate);
	    var enddate = PEField.getRawValue();
	    if (enddate!=="")
	    {
	       //enddate=enddate.format ('Y-m-d');
	    }
	    var dept  = deptCombo.getValue();
	    var title = titleText.getValue(); 
	   	//var AuthorName = AuthorNameText.getValue();
	    var FristAuthor= user1Combo.getValue();
        //var CorrAuthor = user2Combo.getValue();
      var jname = JournalName.getRawValue();
      var ChkResult  = ChkResultField.getValue();
	  var type  = TypeCombox.getValue();
		itemGrid.load({
		    params:{
			sortField:'',
			sortDir:'',
		    start:0,
		    limit:25,
		    startdate:startdate,
		    enddate:enddate,
		    dept:dept,
		    userdr:userdr,
		    title:title,
		    jname:jname,
		    FristAuthor:FristAuthor,
		    ChkResult:ChkResult,
			Type:type
		   }
	  });
  }


var queryPanel = new Ext.FormPanel({
			autoHeight : true,
	region : 'north',
	frame : true,
	title : '论文投稿审核信息查询',
	iconCls : 'search',	
			defaults: {bodyStyle:'padding:5px'},
				items:[{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">类型</p>',
						width : 30			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					TypeCombox,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">论文题目</p>',
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
						value : '<p style="text-align:right;">期刊名称</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					JournalName,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">申请日期</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					PSField,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:center;">至</p>',
						width : 20			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					PEField,
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
						iconCls : 'search'
					}
					]
			    },{
				xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">科室</p>',
						width : 30			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					deptCombo,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">第一作者</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					user1Combo,
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
					ChkResultField
					
				]
			}
			]
		});

var itemGrid = new dhc.herp.Grid({
		    title: '论文投稿审核信息列表',
			iconCls: 'list',
		    region : 'center',
		    url: projUrl,
			fields : [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '申请表ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'Type',
						header : '类型',
						editable:false,
						width : 40,
						dataIndex : 'Type'

					}, {
						id : 'Title',
						header : '论文名称',
						editable:false,
						width : 180,
						dataIndex : 'Title',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					}, {
						id : 'FristAuthorName',
						header : '第一作者(通讯作者)',
						width : 120,
						editable : false,
						dataIndex : 'FristAuthorName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
						
					},{
						id : 'JName',
						header : '期刊名称',
						editable:false,
						width : 180,
						dataIndex : 'JName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					}, {
						id : 'PressName',
						header : '出版社',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'JName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					}, {
						id : 'Content',
						header : '内容',
						editable:false,
						width : 60,
						dataIndex : 'Content'
					},{
						id : 'ParticipantsName',
						header : '作者排名',
						width : 120,
						hidden : true,
						editable:false,
						dataIndex : 'ParticipantsName'

					},{
						id : 'IsMultiContribution',
						header : '一稿多投',
						width : 60,
						editable:false,
						dataIndex : 'IsMultiContribution'

					},{
						id : 'IsKeepSecret',
						header : '涉及保密',
						width : 60,
						editable:false,
						dataIndex : 'IsKeepSecret'

					},{
						id : 'PrjName',
						header : '科研基金资助',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PrjName'

					},{
						id : 'PrjCN',
						header : '合同号',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PrjCN'

					},{
						id : 'SubUserDR',
						header : '申请人ID',
						editable:false,
						width : 120,
						hidden: true,
						dataIndex : 'SubUserDR'
					},{
						id : 'SubUserName',
						header : '申请人',
						editable:false,
						width : 60,
						dataIndex : 'SubUserName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id : 'Dept',
						header : '申请人科室',
						width : 120,
						editable:false,
						dataIndex : 'Dept',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id : 'SubDate',
						header : '申请时间',
						width : 80,
						editable:false,
						dataIndex : 'SubDate'
					},{
						id : 'DataStatus',
						header : '提交状态',
						editable:false,
						width : 60,
						dataIndex : 'DataStatus'
					},{
						id : 'Chercker',
						header : '审核人',
						editable:false,
						width : 60,
						dataIndex : 'Chercker',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id : 'CheckDate',
						header : '审核时间',
						width : 80,
						editable:false,
						dataIndex : 'CheckDate'
					},{
						id : 'ChkResult',
						header : '审批结果',
						editable:false,
						width : 120,
						hidden : true,
						dataIndex : 'ChkResult'
					},{
						id : 'ChkResultlist',
						header : '审批状态',
						editable:false,
						width : 100,
						dataIndex : 'ChkResultlist'
					},{
						id : 'Desc',
						header : '审批意见',
						width : 100,
						editable:false,
						dataIndex : 'Desc'
						
					},{
							id:'download',
							header: '下载',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
					    } 
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
						url:'herp.srm.srmauditapplypaperexe.csp?action=audit&&rowid='+rowObj[i].get("rowid")+'&checker='+checker,
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


downloadMainFun(itemGrid,'rowid','P001',24);
