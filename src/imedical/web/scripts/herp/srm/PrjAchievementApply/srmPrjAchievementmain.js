var projUrl = 'herp.srm.prjachievementapplyexe.csp';

var userdr = session['LOGON.USERCODE'];

//var username = session['LOGON.USERCODE'];

var groupdesc = session['LOGON.GROUPDESC'];
if (groupdesc=="科研管理系统(信息修改)")
{ var userdr=""
	}
if (groupdesc=="科研管理系统(信息查询)")
{ var userdr=""
	}

Date.dayNames = ["日", "一", "二", "三", "四", "五", "六"];  
    Date.monthNames=["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"];  
    if (Ext.DatePicker) {  
        Ext.apply(Ext.DatePicker.prototype, {  
            todayText: "今天",  
            minText: "日期在最小日期之前",  
            maxText: "日期在最大日期之后",  
            disabledDaysText: "",  
            disabledDatesText: "",  
            monthNames: Date.monthNames,  
            dayNames: Date.dayNames,  
            nextText: '下月 (Control+Right)',  
            prevText: '上月 (Control+Left)',  
            monthYearText: '选择一个月 (Control+Up/Down 来改变年)',  
            todayTip: "{0} (Spacebar)",  
            okText: "确定",  
            cancelText: "取消" 
        });  
    } 	   

function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}

function format(value){
	//alert(value);
	re=/(\d{1,3})(?=(\d{3})+(?:$|\D))/g;
	value=value.replace(re,"$1,")
	return value?value:'';
};
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
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true
});		

//年度
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('YearCombo').getRawValue()), 
                        method:'POST'
					});
		});

var YearCombo = new Ext.form.ComboBox({
			id:'YearCombo',
			fieldLabel : '年度',
			store : YearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
 //奖项类型
var RewardTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
RewardTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=rewardTypeList&str='+encodeURIComponent(Ext.getCmp('RewardTypeCombo').getRawValue()), 
                        method:'POST'
					});
		});

var RewardTypeCombo = new Ext.form.ComboBox({
			id:'RewardTypeCombo',
			fieldLabel : '奖项类型',
			store : RewardTypeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
//奖项名称
var RewardDictDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
RewardDictDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=rewardDictList&str='+encodeURIComponent(Ext.getCmp('RewardDictCombo').getRawValue()), 
                        method:'POST'
					});
		});

var RewardDictCombo = new Ext.form.ComboBox({
			id:'RewardDictCombo',
			fieldLabel : '奖项名称',
			store : RewardDictDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
	
// ////////////课题名称
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

/////////////////// 查询按钮 
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	width:30,
	iconCls: 'search',
	handler: function(){
	    var year = YearCombo.getValue();
	    var rewardtype= RewardTypeCombo.getValue();
	    var rewarddict  = RewardDictCombo.getValue();
	    var prjname = titleText.getValue();    
		var type = TypeCombox.getValue();
	    var data= year+'|'+rewardtype+'|'+rewarddict+'|'+prjname+'|'+userdr+'|'+type;
		itemGrid.load({
		    params:{
		    data:data,
		    sortField:'',
		    sortDir:'',
		    start:0,
		    limit:25   
		   }
	  })
  }
});


var queryPanel = new Ext.FormPanel({
	iconCls : 'search',	
	title : '科研成果申请查询',
	autoHeight : true,
	region : 'north',
	frame : true,
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">类型</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},TypeCombox,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">年度</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},YearCombo,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">获奖项目</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},titleText,{
				xtype:'displayfield',
				value:'',
				width:30
				},findButton]
	},{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">奖项级别</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},RewardTypeCombo,
				{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">奖项类型</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},RewardDictCombo]
	}]	
});

///////////////////添加按钮///////////////////////
var addButton = new Ext.Toolbar.Button({
		text: '新增',
		iconCls: 'edit_add',
		handler: function(){
			addFun();}
});

/////////////////修改按钮/////////////////////////
var editButton  = new Ext.Toolbar.Button({
		text: '修改',        
		iconCls: 'pencil',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'提示',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				var state = rowObj[0].get("DataStatus");	
				var participantids = rowObj[0].get("ParticipantsIDs")
				if((state == "未提交")||(groupdesc=="科研管理系统(信息修改)" ) ){editFun(participantids);}
				else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可再修改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}
			}
});

////////////////删除按钮//////////////////////////
var delButton  = new Ext.Toolbar.Button({
		text: '删除',        
		iconCls:'edit_remove',
		handler: function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len<1){
				Ext.Msg.show({title:'提示',msg:'请选择需要删除的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				for(var i = 0; i < len; i++){
				var state = rowObj[i].get("DataStatus");
				//alert(state);			
				if(state == "未提交" ){delFun()}
				else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可删除！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}
});

///////////////提交按钮//////////////////////////
var submitButton = new Ext.Toolbar.Button({
		text:'提交',
		iconCls: 'pencil',
		handler:function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len<1){
				Ext.Msg.show({title:'提示',msg:'请选择需要提交的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				for(var i = 0; i < len; i++){
				var state = rowObj[i].get("DataStatus");
				//alert(state);			
				if(state == "未提交" ){subFun()}
				else {Ext.Msg.show({title:'警告',msg:'数据已提交，不可重复提交！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}	
});


var itemGrid = new dhc.herp.Grid({
		    region : 'center',
			title: '科研成果申请查询列表',
			iconCls: 'list',
		    //viewConfig : {forceFit : false},
		    autoscroll:true,
		    url: projUrl,
			  fields : [
			      //new Ext.grid.CheckboxSelectionModel({editable:false}),
			    {
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						header : '奖励表ID',
						dataIndex : 'rewardinforowid',
						hidden : true
					},{
						id : 'Type',
						header : '类型',
						width : 40,
						editable:false,
						dataIndex : 'Type'
					},{
						id : 'Year',
						header : '年度',
						width : 60,
						editable:false,
						dataIndex : 'Year'

					},{
						id : 'RewardTypeName',
						header : '奖项级别',
						editable:false,
						width : 100,
						dataIndex : 'RewardTypeName'
					},{
						id : 'RewardName',
						header : '奖项类型',
						editable:false,
						width : 100,
						dataIndex : 'RewardName',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					}, {
						id : 'RewardLevel',
						header : '奖项等次',
						width :80,
						editable:false,
						hidden:false,
						dataIndex : 'RewardLevel'

					},{
						id : 'Name',
						header : '获奖项目名称',
						width : 180,
						editable:false,
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						},
						// renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           // return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						// },
						dataIndex : 'Name'

					},{
						id : 'Participants',
						header : '参与人员位次',
						width : 80,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['ParticipantsIDs']
						if (sf != "") {
							return '<span style="color:blue;cursor:hand"><u>项目参与人员</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand"></span>';
						}},
						dataIndex : 'Participants'
					},{
							id:'upload',
							header: '鉴定证书',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>上传</u></span>';
							}
					},{
							id:'upload2',
							header: '公示',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>上传</u></span>';
							}
					},{
							id:'upload3',
							header: '获奖证书',
							allowBlank: false,
							width:60,
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
						id : 'DataStatus',
						header : '数据状态',
						width : 60,
						editable:false,
						dataIndex : 'DataStatus'
					},{
						id : 'CheckResult',
						header : '审核状态',
						width : 80,
						editable:false,
						hidden:true,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['CheckResult']
						if (sf == "等待审批") {return '<span style="color:blue;cursor:hand">'+value+'</span>';} 
						if (sf == "通过") {return '<span style="color:red;cursor:hand">'+value+'</span>';} 
						if (sf == "不通过"){return '<span style="color:gray;cursor:hand">'+value+'</span>';}
						},
						dataIndex : 'CheckResult'
					},{
						id : 'ChkProcDesc',
						header : '审核结果',
						width : 100,
						editable:false,
						hidden:false,
						dataIndex : 'ChkProcDesc'
					},{
						id : 'Desc',
						header : '审核意见',
						editable:false,
						width : 100,			
						hidden:false,
						dataIndex : 'Desc'
					},{
						id : 'ParticipantsIDs',
						header : '参加人员ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'ParticipantsIDs'
					},{
						id : 'RewardUnit',
						header : '批准单位',
						width :180,
						editable:false,
						hidden:false,
						dataIndex : 'RewardUnit',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id : 'RewardDate',
						header : '获奖日期',
						width :80,
						editable:false,
						hidden:false,
						dataIndex : 'RewardDate'
					},{
						id : 'CompleteUnit',
						header : '我院单位位次',
						width :80,
						editable:false,
						hidden:false,
						dataIndex : 'CompleteUnit'

					},{
						id : 'RewardAmount',
						header : '奖励金额(元)',
						width :100,
						align:'right',
						editable:false,
						dataIndex : 'RewardAmount',
						renderer: function(val) 
						{
       						var val = Ext.util.Format.number(val,'0.00');
							return format(val);
    					}

					},{
						id : 'SubUser',
						header : '申请人',
						width : 60,
						editable:false,
						dataIndex : 'SubUser'
					},{
						id : 'SubDeptName',
						header : '申请人科室',
						width : 120,
						editable:false,
						dataIndex : 'SubDeptName',
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
						id : 'YearID',
						header : '年度ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'YearID'
					},{
						id : 'RewardTypeID',
						header : '奖项级别ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'RewardTypeID'
					},{
						id : 'RewardNameID',
						header : '奖项类型ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'RewardNameID'
					},{
						id : 'RewardLevelID',
						header : '奖项等次ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'RewardLevelID'
					},{
						id : 'RewardUnitID',
						header : '批准单位ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'RewardUnitID'
					},{
						id : 'CompleteUnitID',
						header : '我院单位位次ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'CompleteUnitID'
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
					},{
						id : 'PrjDR',
						header : '依托项目ID',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PrjDR'
					},{
						id : 'TypeID',
						header : '类型ID',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'TypeID'
					}]
				});

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

var data="||||"+userdr+"|";
itemGrid.load({	params:{start:0, limit:25,data:data}});

/**
itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var rowid= '';
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	rowid=selectedRow[0].data['rowid'];
        
	DetailGrid.load({params:{start:0, limit:12,rowid:rowid}});	
});

**/

// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

		var records = itemGrid.getSelectionModel().getSelections();
	    // if (columnIndex == 7) {
		  // var title   = records[0].get("Name");
		  // titleFun(title);
		// }
		if(columnIndex == 9){
		  var title= records[0].get("Name");
		  var authorinfo = records[0].get("ParticipantsIDs");
		  //alert(ParticipantsIDs);
		  AuthorInfoList(title,authorinfo);
		}
		
		/**
		if (columnIndex == 22) {
		var records = itemGrid.getSelectionModel().getSelections();
		var state = records[0].get("DataStatus");
		if (state=="已提交"){Ext.Msg.show({title:'警告',msg:'数据已提交，不可再上传附件！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
		else{uploadMainFun(itemGrid,'rowid','SRMReward001',22);}
	}
	if (columnIndex == 23) {
		var records = itemGrid.getSelectionModel().getSelections();
		var state = records[0].get("DataStatus");
		if (state=="已提交"){Ext.Msg.show({title:'警告',msg:'数据已提交，不可再上传附件！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
		else{uploadMainFun(itemGrid,'rowid','SRMReward002',23);}
	}
	if (columnIndex == 24) {
		var records = itemGrid.getSelectionModel().getSelections();
		var state = records[0].get("DataStatus");
		if (state=="已提交"){Ext.Msg.show({title:'警告',msg:'数据已提交，不可再上传附件！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}
		else{uploadMainFun(itemGrid,'rowid','SRMReward003',24);}
	}**/
	
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
	 editButton.disable();//设置为不可用
	  delButton.disable();//设置为不可用
	  submitButton.disable();//设置为不可用
}

uploadMainFun(itemGrid,'rowid','SRMReward001',10);
uploadMainFun(itemGrid,'rowid','SRMReward002',11);
uploadMainFun(itemGrid,'rowid','SRMReward003',12);
downloadMainFun(itemGrid,'rowid','SRMReward001,SRMReward002,SRMReward003',13);