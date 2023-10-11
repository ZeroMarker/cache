var userdr = session['LOGON.USERCODE'];

var ListUrl='herp.srm.prjachievementapplyexe.csp';

var itemGridUrl='herp.srm.auditprjachievementexe.csp';

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
//////年度
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : ListUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('YearCombo').getRawValue()), 
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
			// emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

 ///奖项类型
var RewardTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
RewardTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : ListUrl+'?action=rewardTypeList&str='+encodeURIComponent(Ext.getCmp('RewardTypeCombo').getRawValue()), 
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
			// emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
///奖项名称
var RewardDictDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
RewardDictDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : ListUrl+'?action=rewardDictList&str='+encodeURIComponent(Ext.getCmp('RewardDictCombo').getRawValue()), 
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
			// emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
	
// ////////////鉴定名称
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

/////////////////审核结果///////////////////////////
var AuditStateStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['1','等待审批'],['2','已通过'],['3','未通过']]
});

var AuditStateField = new Ext.form.ComboBox({
	id: 'AuditState',
	fieldLabel: '审核结果',
	width:120,
	listWidth : 120,
	allowBlank: true,
	store:AuditStateStore,
	valueField: 'key',
	displayField: 'keyvalue',
	triggerAction: 'all',
	// emptyText:'请选择审核结果...',
	mode : 'local',
	name: 'AuditState',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

/////////////////奖励时间///////////////////////
var RewardDateField = new Ext.form.DateField({
	        id: 'RewardDateField',
			fieldLabel: '奖励时间',
			width:180,
			allowBlank:false,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
		
/////////////////查询按钮响应函数//////////////
function SearchFun()
{
	    var year = YearCombo.getValue();
	    var rewardtype= RewardTypeCombo.getValue();
	    var rewarddict  = RewardDictCombo.getValue();
	    var prjname = titleText.getValue();   
	    var auditstate =  AuditStateField.getValue();
		var type =TypeCombox.getValue();
	    var data= year+'|'+rewardtype+'|'+rewarddict+'|'+prjname+'|'+auditstate+'|'+userdr+'|'+type;

	itemGrid.load({
		    params:{
		    data:data,
		    sortField:'',
		    sortDir:'',
		    start:0,
		    limit:25   
		   }
	  });
	
}

//////////////////////////////////////////////

var queryPanel = new Ext.FormPanel({
	autoHeight : true,
	region : 'north',
	frame : true,
	iconCls : 'search',	
	title : '科研成果审核查询',
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
				value : '<p style="text-align:right;">奖项类别</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},RewardTypeCombo,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">奖项名称</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},RewardDictCombo,
				{
				xtype:'displayfield',
				value:'',
				width:30
				},{
					xtype : 'button',
					width:30,
					text: '查询',
					iconCls: 'search',
					handler: function(){SearchFun()}
				}]
	},{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">项目名称</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},titleText,{
				xtype:'displayfield',
				value:'',
				width:10
				},{
				xtype : 'displayfield',
				value : '<p style="text-align:right;">审核状态</p>',
				width:60
				},{
				xtype:'displayfield',
				value:'',
				width:10
				},AuditStateField]
	}]	
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: '科研成果审核查询列表',
			iconCls: 'list',
			url : itemGridUrl,
			listeners:{
	        'cellclick' : function(grid, rowIndex, columnIndex, e) {
	                   var record = grid.getStore().getAt(rowIndex);
	                   if((record.get('CheckResult') == '通过')&&(record.get('IsReward')=='已奖励')&&((columnIndex==13)||(columnIndex==14)))
					   {
					   //Ext.Msg.show({title:'注意',msg:'奖励已审核,不能修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					   }
					   else{
					   return true;
					   }
	        }},	
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
						header : '奖项类别',
						editable:false,
						width : 100,
						dataIndex : 'RewardTypeName'
					},{
						id : 'RewardName',
						header : '奖项等级',
						editable:false,
						width : 80,
						dataIndex : 'RewardName'

					},  {
						id : 'RewardLevel',
						header : '奖励等次',
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
						header : '参与人位次',
						width : 80,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['rowid']
						if (sf != "") {
							return '<span style="color:blue;cursor:hand"><u>课题参与人员</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand"></span>';
						}},
						dataIndex : 'Participants'
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
						id : 'IsReward',
						header : '是否奖励',
						width :80,
						editable:false,
						hidden:true,
						dataIndex : 'IsReward'
					},{
						id : 'RewardAmount',
						header : '奖励金额(元)',
						width :100,
						align:'right',
						editable:true,
						dataIndex : 'RewardAmount',
						renderer: function(val) 
						{
       						var val = Ext.util.Format.number(val,'0.00');
							return format(val);
    					}

					},{
						id : 'eRewardDate',
						header : '奖励时间',
						editable:true,
						width : 80,
						dataIndex : 'eRewardDate',
						type:RewardDateField,
						renderer : function(v, p, r, i) {			
						if (v instanceof Date) {
							return new Date(v).format("Y-m-d");
						} else {return v;}
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
						id : 'DataStatus',
						header : '数据状态',
						width : 80,
						editable:false,
						hidden: true,
						dataIndex : 'DataStatus'
					},{
						id : 'Chercker',
						header : '审核人',
						width : 60,
						editable:false,
						dataIndex : 'Chercker'
					},{
						id : 'CheckDeptName',
						header : '审核人科室',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'CheckDeptName'
					},{
						id : 'CheckDate',
						header : '审核时间',
						width : 100,
						editable:false,
						dataIndex : 'CheckDate'

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
							id:'download',
							header: '鉴定证书',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
					    } 
					},{
							id:'download1',
							header: '公示',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'download1',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
					    } 
					},{
							id:'download2',
							header: '获奖证书',
							allowBlank: false,
							width:60,
							editable:false,
							dataIndex: 'download2',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
					    } 
					}
					
					
					]				
		});

var AuditButton  = new Ext.Toolbar.Button({
		text: '通过',  
        id:'auditButton', 
        iconCls:'pencil',
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
		 if(rowObj[j].get("CheckResult")!="等待审批")
		 {
			      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:itemGridUrl+'?action=audit&&rowid='+rowObj[i].get("rowid")+'&checker='+checker,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								var inputdata="|||||"+userdr;
								itemGrid.load({params:{start:0,limit:25,data:inputdata}});
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
					iconCls : 'pencil',
					handler : function() {
						var rowObj=itemGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						for(var j= 0; j < len; j++){
							 if(rowObj[j].get("CheckResult")!="等待审批")
							 {
								      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }else{noauditfun();}
						}
						
						
				   }
  });
  var RewardAuditButton = new Ext.Toolbar.Button({
    id:'RewardAudit',
	text: '奖励审核',  
    iconCls:'pencil',
    handler:function(){
	//定义并初始化行对象
	var usercode = session['LOGON.USERCODE'];
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要奖励的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	for(var j= 0; j< len; j++){
	     //alert(rowObj[j].get("RewardAmount"))
	    /* var state=rowObj[j].get("ChkResult");
		//alert(state);
	    if(state!="通过"){
	      Ext.getCmp('RewardAudit').disable();//设置为不可用
	       return;
	   } */
	   /**
	   if(rowObj[j].get("IsReward")!='未奖励')
	 {
		      Ext.Msg.show({title:'注意',msg:'该数据已奖励',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
	 **/
		 if(rowObj[j].get("RewardAmount")==""){
			Ext.Msg.show({title:'注意',msg:'奖励金额不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
		if(rowObj[j].get("eRewardDate")==""){
			Ext.Msg.show({title:'注意',msg:'奖励时间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
	}
	function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					
					
					var rewardamount = rowObj[i].get("RewardAmount");  
					  var erewarddate=rowObj[i].get("eRewardDate"); 
					  if(rowObj[i].isModified("eRewardDate")){
						 
						     erewarddate=erewarddate.format('Y-m-d');
						  
						  } 
					
					    Ext.Ajax.request({
						url:itemGridUrl+'?action=rewardaudit&rowid='+rowObj[i].get("rowid")+'&rewardamount='+rewardamount+'&rewarddate='+erewarddate,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},   
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'奖励审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});                              
								var inputdata="|||||"+userdr;
								itemGrid.load({params:{start:0, limit:25,data:inputdata}});								
							}else{
							    var ErrMSG="";
							    ErrMSG=jsonData.info;
							    Ext.Msg.show({title:'错误',msg:ErrMSG,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						    }
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要审核所选记录吗?审核后不能修改',handler);
    }
});

  itemGrid.addButton('-');
  itemGrid.addButton(AuditButton);
  itemGrid.addButton('-');
  itemGrid.addButton(NoAuditButton);
  itemGrid.addButton('-');
  itemGrid.addButton(RewardAuditButton);

  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏添加按钮
  itemGrid.btnSaveHide(); 	//隐藏保存按钮
  
  var data="|||||"+userdr+'|';
  itemGrid.load({params:{start:0, limit:25, data:data}});
  /**
  itemGrid.on('cellclick',function(g,rowIndex,columnIndex,e){
  	var rowObj=itemGrid.getSelectionModel().getSelections();
		if(rowObj[0].get("Title")=="Reward7"){
			alert("abcdefg");
			paperPublishDetail(itemGrid);	
		}    
	 if(rowObj[0].get("Title")=="Reward3")
	 {
	 	alert("12345");
	 	paperPublishDetail2(itemGrid);	
	 	}
	});
**/
// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

		var records = itemGrid.getSelectionModel().getSelections();
	    // if (columnIndex == 6) {
		  // var title   = records[0].get("IdentifyName");
		  // titleFun(title);
		// }
		if(columnIndex == 9){
		  var title= records[0].get("Name");
		  var authorinfo = records[0].get("ParticipantsIDs");
		  //alert(ParticipantsIDs);
		  AuthorInfoList(title,authorinfo);
		}
		var records = itemGrid.getSelectionModel().getSelections();
	    var state = records[0].get("CheckResult");
	    //alert(state);
	    if(state!="通过")
	    {
	      Ext.getCmp('RewardAudit').disable();//设置为不可用
	      return;
	    }
	    else{
	      Ext.getCmp('RewardAudit').enable();//设置为可用
	      return;
	    }
	
});
downloadMainFun(itemGrid,'rowid','SRMReward001',27);
downloadMainFun(itemGrid,'rowid','SRMReward002',28);
downloadMainFun(itemGrid,'rowid','SRMReward003',29);