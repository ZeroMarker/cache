//var userdr = session['LOGON.USERID'];    
var username = session['LOGON.USERCODE'];
var projUrl = 'herp.srm.srmapplypaperexe.csp';
var subusername = session['LOGON.USERCODE']; 

var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="科研管理系统(信息修改)")
{ var username=""
}
//成本核算会计
if (groupdesc=="科研管理系统(信息查询)")
{ var username=""
}

//userkdr="";
/**
Ext.Ajax.request({			        
     url: '../csp/herp.srm.srmapplypaperexe.csp?action=GetSRMUserID&usercode='+username,	
     method:'POST',
     async:false,
		 success: function(result, request){		 
	     var jsonData = Ext.util.JSON.decode( result.responseText );  	         
       userkdr = jsonData;   
       //userkdr=result.responseText;
       //alert(userkdr)
					         	
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
		           forceSelection : true
						  });	
// 定义起始时间控件
	var PSField = new Ext.form.DateField({
		id : 'PSField',
		//format : 'Y-m-d',
		fieldLabel:'开始日期',
		width : 120,
		editable:true
		//emptyText : '请选择开始日期...'
	});
	
	var PEField = new Ext.form.DateField({
		id : 'PEField',
		//format : 'Y-m-d',
		fieldLabel:'结束日期',
		width : 120,
		editable:true
		//emptyText : '请选择结束日期...'
	});
		
		
 ///科室名称
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						//url : projUrl+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue())+'&userdr='+userdr,method:'POST'
						url : projUrl+'?action=deptList',method:'POST'
					});
		});
var deptCombo = new Ext.form.ComboBox({
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
			selectOnFocus : true
		});


// ///////////////////论文题目
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

// ///////////////////期刊名称
var JournalNameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


JournalNameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=JournalList&str='+encodeURIComponent(Ext.getCmp('JournalName').getRawValue()),method:'POST'});
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
	editable:true
});

/////第一作者  
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList',
						method : 'POST'
					});
		});

var user1Combo = new Ext.form.ComboBox({
			fieldLabel : '作者 ',
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
		
///////////////////科研审批结果
var ChkResultStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '等待审批'], ['1', '通过'], ['2', '不通过']]
		});
var ChkResultField = new Ext.form.ComboBox({
			fieldLabel : '科研审批结果',
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
			forceSelection : true
		});

  var QueryButton = new Ext.Toolbar.Button({
			text : '查询',
			//tooltip : '查询',
			iconCls : 'search',
			width : 30,
			handler : function() {
			
			var startdate= PSField.getRawValue();
		    var enddate = PEField.getRawValue();
		    var dept  = deptCombo.getValue();
		    var title = titleText.getRawValue(); 
		    var jname = JournalName.getRawValue();
		    var FristAuthor= user1Combo.getValue();
	        var ChkResult = ChkResultField.getValue();
			var type = TypeCombox.getValue();
	      //alert(userkdr)
	      itemGrid.load({
			    params:{
			    start:0,
			    limit:25,
			    SubDateStart:startdate,
			    SubDateEnd:enddate,
			    DeptDr:dept,
			    Title:title,
			    JName:jname,
			    FristAuthor:FristAuthor,
			    ChkResult:ChkResult,
			    username:username,
				Type:type
				   }
		  });			
}
})


var queryPanel = new Ext.FormPanel({
			autoHeight : true,
			title : '论文投稿申请信息查询',
	iconCls : 'search',
			region:'north',
			frame:true,
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
					QueryButton
					]
			    },{
				xtype: 'panel',
				layout:"column",
				items: [
				   
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">科室</p>',
						width : 60			
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
						value : '<p style="text-align:right;">作者</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					user1Combo	
				]
			}
			]
		});
var AddButton = new Ext.Toolbar.Button({
					text : '新增',
					iconCls: 'edit_add',
					handler : function() {
						 AddPaperfun();
				   }
  });
   
   var UpdateButton = new Ext.Toolbar.Button({
   	      text : '修改',
		  iconCls: 'pencil',
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
			//alert(state);
			if((state == "未提交")||(groupdesc=="科研管理系统(信息修改)" ) ){ 
				EditPaperfun(participantsids);}
			else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
						 
	
  });
   var DeleteButton = new Ext.Toolbar.Button({
   	        text : '删除',
		    iconCls: 'edit_remove',
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
			if(state == "未提交" ){ delFun();}
			else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可删除！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
  });
  
  var SubmitButton = new Ext.Toolbar.Button({
   	        text : '提交',
			iconCls: 'pencil',
			handler : function() {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			//////////////////////////判断是否有附件上传记录///////////////////////////
				Ext.Ajax.request({
					url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'P001',
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
			
			
			
			if (len>0){
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");
				
			if(state == "未提交" ){ SubmitPaperfun();}
			else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可重复提交！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
  });	
  	 var PrintButton = new Ext.Toolbar.Button({
   	        text : '打印',
			iconCls : 'option',
			handler : function() {
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if (len<1){
				Ext.Msg.show({title:'注意',msg:'请选择需要打印的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			    return;
			}
			//////////////////////////判断是否有附件上传记录///////////////////////////
				Ext.Ajax.request({
					url:'herp.srm.uploadexe.csp?action=GetUpLoadInfo&RecDr='+rowObj[0].get("rowid")+'&SysNo='+'P001',
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
			
			
			
			if (len>0){
			for(var i = 0; i < len; i++){
			var state = rowObj[i].get("DataStatus");
				
			if(state == "未提交" ){ SubmitPaperfun();}
			else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可重复提交！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
  });	
  exportexcel = function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var rowid = rowObj[0].get("rowid");
		ExportDataToExcel("","","",rowid);
	}
	
   printexcel = function(){
		var rowObj = itemGrid.getSelectionModel().getSelections();
		var rowid = rowObj[0].get("rowid");
		var flg=PrintDataToExcel("","","",rowid);
	}
var itemGrid = new dhc.herp.Grid({
		    title: '论文投稿申请信息列表',
			iconCls: 'list',
		    region : 'center',
		    url: projUrl,
		    tbar:[AddButton,UpdateButton,DeleteButton,SubmitButton],
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用 
		                 if ((record.get('AllAudit') =="0")&& (columnIndex == 2)) {
		                      return false;
		                 } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 
						if ((record.get('AllAudit') =="0") && (columnIndex == 2)) {						
							return false;
						} else {
							return true;
						}
					}
            }, 
			fields : [
			      new Ext.grid.CheckboxSelectionModel({
				      hidden : true,
				      editable:false
				      }),
				   {
						header : '选择',
						width:40,
						hidden : false,
						editable:false,
						align:'center',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store)
						{ 
						    if(record.get('AllAudit')=="1"){
								return '<span style="color:blue;cursor:hand"><BLINK id="print" onclick=exportexcel();>打印</BLINK></span>'+'<b> </b>';  
							}else{
								return '<span style="color:gray;cursor:hand"><BLINK id="print" >打印</BLINK></span>'+'<b> </b>';  
							}
						}
					},{
						header : '申请表ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'Type',
						header : '类型',
						editable:false,
						width :40,
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
						width : 180,
						hidden:true,
						dataIndex : 'PressName'
					}, {
						id : 'ParticipantsName',
						header : '作者排名',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'ParticipantsName'

					}, {
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
					},{
						id : 'Content',
						header : '内容',
						editable:false,
						width : 60,
						dataIndex : 'Content'
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
						id : 'ChkResult',
						header : '审批结果',
						editable:false,
						width : 120,
						hidden: true,
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
						id : 'ParticipantsID',
						header : '作者排名ID',
						width : 120,
						editable: false,
						hidden : true,
						dataIndex : 'ParticipantsID'
					}, {
						id : 'AllAudit',
						header : '是否全部审批通过',
						width : 120,
						editable: false,
						hidden : true,
						dataIndex : 'AllAudit'
					},{
						header : '论文依托科研课题(院外)',
						dataIndex : 'OutPrjName',
						hidden : true
					},{
						header : '类型ID',
						dataIndex : 'TypeID',
						hidden : true
					},{
						header : '论文依托科研课题ID',
						dataIndex : 'PrjDR',
						hidden : true
					},{
						header : '期刊ID',
						dataIndex : 'JNameID',
						hidden : true
					},{
						header : '收录类别ID',
						dataIndex : 'RecordTypeDR',
						hidden : true
					},{
						header : '依托课题ID',
						dataIndex : 'PrjDR',
						hidden : true
					},{
						header : '第一作者ID',
						dataIndex : 'FristAuthorNameID',
						hidden : true
					},{
						header : '内容ID',
						dataIndex : 'ContentID',
						hidden : true
					},{
						header : '是否一稿多投ID',
						dataIndex : 'IsMultiContributionID',
						hidden : true
					},{
						header : '是否保密ID',
						dataIndex : 'IsKeepSecretID',
						hidden : true
					}]					
		});
		
  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏重置按钮
  itemGrid.btnSaveHide(); 	//隐藏重置按钮

 itemGrid.load({params:{start:0, limit:12, username:username}});
 
	
	if (groupdesc=="科研管理系统(信息修改)")
{
	 AddButton.disable();//设置为不可用
	  DeleteButton.disable();//设置为不可用
	  SubmitButton.disable();//设置为不可用

	
}
    if (groupdesc=="科研管理系统(信息查询)")
{
	  AddButton.disable();//设置为不可用
	  UpdateButton.disable();//设置为不可用
	  DeleteButton.disable();//设置为不可用
	  SubmitButton.disable();//设置为不可用

	
	}
uploadMainFun(itemGrid,'rowid','P001',10);
downloadMainFun(itemGrid,'rowid','P001',11);