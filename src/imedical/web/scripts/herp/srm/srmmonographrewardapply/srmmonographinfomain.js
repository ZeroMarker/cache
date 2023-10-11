///////////////////////////////////////////////////
var userdr = session['LOGON.USERID'];
//alert(userdr);
var usercode=session['LOGON.USERCODE'];
var tmpData="";

var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="科研管理系统(信息修改)")
{ var userdr=""
	}
if (groupdesc=="科研管理系统(信息查询)")
{ var userdr=""
	}


var itemGridUrl = '../csp/herp.srm.monographrewardapplyexe.csp';

///////////////////类型/////////////////////////////  
var sTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '科研'],['2', '教学']]
	});		
		
var sTypeCombox = new Ext.form.ComboBox({
	                   id : 'sTypeCombox',
		           fieldLabel : '类型',
	                   width : 120,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : sTypeDs,
		           //anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           ////emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true
						  });	
						  
//定义起始时间控件
var PSField = new Ext.form.DateField({
	id : 'PSField',
	//format : 'Y-m-d',
	width : 120
	//allowBlank : false,
	//emptyText : ''
});
var PEField = new Ext.form.DateField({
	id : 'PEField',
	//format : 'Y-m-d',
	width : 120
	//emptyText : ''
	
});
/////////////////////著作名称
var monoName = new Ext.form.TextField({
width :120,
selectOnFocus : true
});
/////////////////////ISBN号
var ISBNText = new Ext.form.TextField({
width :120,
selectOnFocus : true
});

/////作者
var userDs = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['rowid', 'name'])
	});

userDs.on('beforeload', function(ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
					url : itemGridUrl+'?action=userList',
					method : 'POST'
				});
	});

var userCombo = new Ext.form.ComboBox({
		fieldLabel : '著作作者 ',
		store : userDs,
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
		selectOnFocus : true
	});
	
function srmFundSearch(){
    var startdate= PSField.getRawValue();
    if (startdate!=="")
    {
       //startdate=startdate.format ('Y-m-d');
    }
    var enddate = PEField.getRawValue();
    if (enddate!=="")
    {
       //enddate=enddate.format ('Y-m-d');
    }
    var editor  = userCombo.getValue();
    var isbn = ISBNText.getValue(); 
	var name = monoName.getValue(); 
    var sType = sTypeCombox.getValue();
  	itemGrid.load({
	    params:{
	    start:0,
	    limit:25,
	    starttime:startdate,
	    endtime:enddate,
	    editor:editor,
	    name:name,
	    isbn:isbn,
	    userdr:userdr,
		sType:sType
	   }
  });
}


var queryPanel = new Ext.FormPanel({
		autoHeight : true,
	region : 'north',
	frame : true,
	title : '专著奖励申请信息查询',
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
					width : 60			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				sTypeCombox,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">著作名称</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				monoName,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">出版时间</p>',
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
					xtype : 'button',
					text : '查询',
					handler : function(b){srmFundSearch();},
					iconCls : 'search',
					width : 30
				}
			]
		}, 
		{
			columnWidth : 1,
			xtype : 'panel',
			layout : "column",
			items : 
			[
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">作者</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},	
				userCombo,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">ISBN号</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				ISBNText
				]
		    }
		]
	});
var itemGrid =new dhc.herp.Grid({
			region : 'center',
			title: '专著奖励申请信息查询列表',
			iconCls: 'list',
			url : 'herp.srm.monographrewardapplyexe.csp',					
			fields :[
        new Ext.grid.CheckboxSelectionModel({
	        hidden:true,
	        editable:false
	        }),      
        {
            id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:120,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       }, {
           id:'sType',
           header: '类型',
           allowBlank: false,
           width:40,
           editable:false,
           dataIndex: 'sType'
      },{
            id:'YearName', 
            header: '年度',
            allowBlank: false,
            width:60,
			//hidden:true,
            editable:false,
            dataIndex: 'YearName'
       },{
           id:'Type',
           header: '著作类别',
           allowBlank: false,
           width:60,
           editable:false,
           dataIndex: 'Type'
      },{
           id:'Name',
           header: '著作名称',
           allowBlank: false,
           width:180,
           editable:false,
           dataIndex: 'Name',
		   renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       }, {
           id:'CompleteUnit',
           header: '第几完成单位',
           allowBlank: false,
           width:120,
           editable:false,
		   hidden:true,
           dataIndex: 'CompleteUnit'
      },{
           id:'EditorName',
           header: '著作作者',
           allowBlank: false,
           width:80,
           editable:false,
           renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
           dataIndex: 'EditorName'
      },{
			id:'upload',
			header: '附件',
			allowBlank: false,
			width:40,
			editable:false,
			dataIndex: 'upload',
			renderer : function(v, p, r){			
			return '<span style="color:blue"><u>上传</u></span>';
			}
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
		}, {
            id:'DataStatus',
            header: '数据状态',
            allowBlank: false,
            width:60,
            editable:false,
            dataIndex: 'DataStatus'
       },{
            id:'ChkResult', 
            header: '审核结果',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'ChkResult'
       },{
            id:'CheckDesc', 
            header: '审核意见',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'CheckDesc'
       },  {
			     id:'EditorIDs',         
			     header:'著作作者IDs',
			     width:120,
			     editable:false,
			     hidden:true,
			     align:'center',
			     dataIndex:'EditorIDs'
		},{
           id:'PressName',
           header: '出版社名称',
           allowBlank: false,
           width:120,
           editable:false,
           dataIndex: 'PressName',
		   renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       },{
           id:'PressLevel',
           header: '出版社级别',
           allowBlank: false,
           width:100,
           editable:false,
           dataIndex: 'PressLevel',
		   renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       },{
            id:'ISBN',
            header: 'ISBN号',
            allowBlank: false,
            width:120,
            editable:false,
            dataIndex: 'ISBN',
			renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       }, {
            id:'TotalNum',
            header: '总字数(千字)',
            allowBlank: false,
            width:100,
            align:'right',
            editable:false,
            dataIndex: 'TotalNum',
            renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
       },  {
            id:'PubTime',
            header: '出版时间',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'PubTime'
       },{
            id:'PublishFreq',
            header: '出版版次',
            allowBlank: false,
            width:80,
            editable:false,
            align:'right',
            dataIndex: 'PublishFreq'
       },{
           id:'SubUserName',
           header: '申请人',
           allowBlank: false,
           width:60,
           editable:false,
           dataIndex: 'SubUserName'
       }, {
          id:'DeptName',
          header: '申请人科室',
          allowBlank: false,
          width:120,
          editable:false,
          dataIndex: 'DeptName',
		  renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       },{
            id:'SubDate',
            header: '申请时间',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'SubDate'
       }, {
            id:'SysNo',
            header: '系统号',
            allowBlank: false,
            width:120,
            hidden:true,
            editable:false,
            dataIndex: 'SysNo'
       },{
			      id : 'RewardAmount',
			      header : '奖励(元)',
			      width : 80,
			      align:'right',
			      editable:false,
			      allowblank:false,
				  
			      renderer : function(val,cellmeta, record,rowIndex, columnIndex, store) { 
				  val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
			      var sf = record.data['RewardAmount']
			      if (sf !== "") {
				    return '<span style="color:red;cursor:hand">'+val+'</span>';
			      }},
			      dataIndex : 'RewardAmount'
		},{
			      id:'score',
			      header:'计算得分',
			      editable:false,
			      width:120,
			      align:'center',
			      hidden:true,
			      renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
			        var sf = record.data['score']
			        if (sf !== "") {
				      return '<span style="color:red;cursor:hand">'+value+'</span>';
			      }},
			      dataIndex:'score'
		},{
            id:'YearID', 
            header: '年度ID',
            allowBlank: false,
            width:180,
			hidden:true,
            editable:false,
            dataIndex: 'YearID'
       },{
			id : 'PrjName',
			header : '科研基金资助',
			width : 120,
			editable:false,
			hidden : true,
			dataIndex : 'PrjName'
		},{
			header : '论文依托科研课题(院外)',
			dataIndex : 'OutPrjName',
			hidden : true
		}]
			    
});
var addButton = new Ext.Toolbar.Button({
					text : '新增',
					//tooltip : '添加',
					iconCls: 'edit_add',
					handler : function() {
						srmmonographAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '修改',
					//tooltip : '修改',
					iconCls: 'pencil',
					handler : function() {
					var rowObj = itemGrid.getSelectionModel().getSelections();
					var len = rowObj.length; 
					if(len < 1)
					{
						Ext.Msg.show({title:'提示',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}else{
						var state = rowObj[0].get("DataStatus");	
						var editorids = rowObj[0].get("EditorIDs");	
						if((state == "未提交")||(groupdesc=="科研管理系统(信息修改)" )){srmMonographEditFun(editorids);
					    }				
						else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可再修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
					}
});
var submitButton = new Ext.Toolbar.Button({
	text : '提交',
	//tooltip : '提交',
	iconCls: 'pencil',
	handler : function() {
		    var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'提示',msg:'请选择需要提交的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var state = rowObj[0].get("DataStatus");
				
				
				
				
		//////////////////////////判断是否有附件上传记录///////////////////////////
				Ext.Ajax.request({
					url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'P004',
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'注意',msg:'请上传附件!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
						
							return;
						}
						
					},
					scope: this			
				  });
		///////////////////////////////////////
	
							
				if(state == "未提交" ){srmMonographSubmitFun();
			    }				
				else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可再修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
			}
});
var delButton = new Ext.Toolbar.Button({
			text : '删除',
			//tooltip : '删除',
			iconCls: 'edit_remove',
			handler : function() {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if (len < 1) {
					Ext.Msg.show({
								title : '注意',
								msg : '请选择需要删除的数据!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				} else {
				    for(var i = 0; i < len; i++){
				    var state = rowObj[i].get("DataStatus");	
				    if(state == "已提交" ){
					      Ext.Msg.show({title:'注意',msg:'已提交记录无法删除！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					       return;
				    }
				}
					Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn) {
						if (btn == 'yes') {
						    for(var i = 0; i < len; i++){
							Ext.Ajax.request({
								url : itemGridUrl + '?action=del&rowid='+rowObj[i].get("rowid"),
								waitMsg : '删除中...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '错误',
												msg : '请检查网络连接!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : '注意',
													msg : '操作成功!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										itemGrid.load({
													params : {
														start : 0,
														limit : 25,
														userdr:userdr
													}
												});
									} else {
										Ext.Msg.show({
													title : '错误',
													msg : '错误',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
									}
								},
								scope : this
							});
						 }
						}
					});
				
				}
			}
});


  
	/**
	 * 此处应设计成用户只能提交自己的作品*/
	srmMonographSubmitFun=function(){
		
     var usercode=session['LOGON.USERCODE'];
	//定义并初始化行对象
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	 for(var j= 0; j < len; j++){
		 if(rowObj[j].get("DataStatus")=="已提交")
		 {
			      Ext.Msg.show({title:'注意',msg:'已提交记录无法再次提交！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		//此段代码用于判断用户只能提交自己的代码 此处需要修改
//		 if(rowObj[j].get("EditorDr")!=session['LOGON.USERID'])
//		 {
//			      Ext.Msg.show({title:'注意',msg:'用户只能提交自己的著作！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
//			       return;
//		 }
		}
    
	function handler(id){
		if(id=="yes"){	
			for(var i = 0; i < len; i++){
				    Ext.Ajax.request({
					url:'herp.srm.monographrewardapplyexe.csp?action=submit&&rowid='+rowObj[i].get("rowid")+'&usercode='+usercode,
					waitMsg:'提交中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){				
						//alert(result.responseText);
						var jsonData = Ext.util.JSON.decode( result.responseText );
						
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'提交成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0, limit:25,userdr:userdr}});	
							
						}else{
							var message='提交失败!';
							//if(jsonData.info=="RepName") message="名称重复";
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}else{
			return;
		}
	}
	
	Ext.MessageBox.confirm('提示','确实要提交所选记录吗?',handler);
	}
	
  itemGrid.addButton('-');
  itemGrid.addButton(addButton);
  itemGrid.addButton('-');
  itemGrid.addButton(editButton);
  itemGrid.addButton('-');
  itemGrid.addButton(delButton);
  itemGrid.addButton('-');
  itemGrid.addButton(submitButton);

  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏添加按钮
  itemGrid.btnSaveHide(); 	//隐藏保存按钮
	

  itemGrid.load({params:{start:0, limit:12, userdr:userdr}});

// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//作者排名
	if (columnIndex == 8) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("EditorIDs");
		var title = records[0].get("Name"); 
		BookAuthorInfoList(title,authorinfo);
	}
	
		
	
	
});
if (groupdesc=="科研管理系统(信息修改)")
{
	 addButton.disable();//设置为不可用
	  delButton.disable();//设置为不可用
	  submitButton.disable();//设置为不可用
	  
	
	}
if (groupdesc=="科研管理系统(信息查询)")
{
	 addButton.disable();//设置为不可用
	 editButton.disable();
	  delButton.disable();//设置为不可用
	  submitButton.disable();//设置为不可用
	  
	
	}


uploadMainFun(itemGrid,'rowid','P004',9);
downloadMainFun(itemGrid,'rowid','P004',10);