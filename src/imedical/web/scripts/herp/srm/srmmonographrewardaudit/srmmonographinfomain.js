///////////////////////////////////////////////////
var userdr=session['LOGON.USERID'];
var tmpData="";

var projUrl = '../csp/herp.srm.monographrewardauditexe.csp';

var itemGridUrl = '../csp/herp.srm.monographrewardapplyexe.csp';

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
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true
						  });	
						  
/////////////定义起始时间控件
var PSField = new Ext.form.DateField({
	id : 'PSField',
	//format : 'Y-m-d',
	width : 120,
	//allowBlank : false,
	emptyText : ''
});

var PEField = new Ext.form.DateField({
	id : 'PEField',
	//format : 'Y-m-d',
	width : 120,
	emptyText : ''
});

///////////////////ISBN号
var ISBNText = new Ext.form.TextField({
width :120,
selectOnFocus : true
});
///////////////////著作名称
var monogName = new Ext.form.TextField({
width :120,
selectOnFocus : true
});
//////////////////作者
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
		fieldLabel : '作者 ',
		store : userDs,
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
	//emptyText:'请选择审核结果...',
	mode : 'local',
	name: 'AuditState',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});
function srmFundSearch(){
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
    //alert(enddate);
    var editor  = userCombo.getValue();
    var isbn = ISBNText.getValue();
	var name = monogName.getValue(); 
    var auditstate = AuditStateField.getValue();
    var stype = sTypeCombox.getValue();
  	itemGrid.load({
	    params:{
	    start:0,
	    limit:25,
	    starttime:startdate,
	    endtime:enddate,
	    editor:editor,
	    isbn:isbn,
	    name:name,
	    auditstate:auditstate,
	    userdr:userdr,
		sType:stype
	   }
  });
}


var queryPanel = new Ext.FormPanel({
		autoHeight : true,
	region : 'north',
	frame : true,
	title : '专著奖励审核信息查询',
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
				monogName,
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
					value : '<p style="text-align:right;">审核结果</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				AuditStateField,
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
	
	
/////////////////奖励时间///////////////////////
var RewardDateField = new Ext.form.DateField({
	        id: 'RewardDateField',
			fieldLabel: '奖励时间',
			width:180,
			allowBlank:false,
			format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});

	
	
var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: '专著奖励审核信息查询列表',
			iconCls: 'list',
			url : 'herp.srm.monographrewardauditexe.csp',	
			/**listeners:{
				
	        'cellclick' : function(grid, rowIndex, columnIndex, e) {
	               var record = grid.getStore().getAt(rowIndex);
	               // 根据条件设置单元格点击编辑是否可用
	               if ((record.get('ChkResult') != '等待审批') &&((columnIndex == 14)||(columnIndex == 13))) {    
	                      Ext.Msg.show({title:'注意',msg:'已审核或未通过,不能修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	                      return false;
	               } else 
	                      {
	                      return true;
	                      }
	        },        
	        'celldblclick' : function(grid, rowIndex, columnIndex, e) {
	            var record = grid.getStore().getAt(rowIndex);
	            // 根据条件设置单元格点击编辑是否可用
	        
	            if ((record.get('ChkResult') != '等待审批') &&((columnIndex == 13)||(columnIndex == 14))) {          
	                   return false;
	            } else 
	                   {
	                   return true;
	                   }
	     	}},	**/		
			fields : [
			 new Ext.grid.CheckboxSelectionModel({editable:false}),    
        {
            id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       },{
           id:'sType',
           header: '类型',
           allowBlank: false,
           width:40,
           editable:false,
           dataIndex: 'sType'
      }, {
            id:'YearName', 
            header: '年度',
            allowBlank: false,
            width:60,
			//hidden:true,
            editable:false,
            dataIndex: 'YearName'
       }, {
           id:'Type',
           header: '著作类别',
           allowBlank: false,
           width:60,
           editable:false,
           dataIndex: 'Type'
      }, {
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
      }, {
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
       }, {
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
       },  {
            id:'PublishFreq',
            header: '出版版次',
            allowBlank: false,
            width:80,
            editable:false,
            align:'right',
            dataIndex: 'PublishFreq'
       },{
			id : 'RewardAmount',
			header : '奖励(元)',
			width : 80,
			align:'right',
			editable:true,
			allowblank:false,
			dataIndex : 'RewardAmount',
			
renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
		},{
						id : 'RewardDate',
						header : '奖励时间',
						editable:true,
						width : 100,
						dataIndex : 'RewardDate',
						type:RewardDateField,
						renderer : function(v, p, r, i) {			
						if (v instanceof Date) {
							return new Date(v).format("Y-m-d");
						} else {return v;}
			          }
			         },{
           id:'SubUserName',
           header: '申请人',
           allowBlank: false,
           width:60,
           editable:false,
           dataIndex: 'SubUserName'
      },{
          id:'DeptName',
          header: '申请人科室',
          allowBlank: false,
          width:120,
        //  hidden:true,
          editable:false,
          dataIndex: 'DeptName',
		  renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       },  {
            id:'SubDate',
            header: '申请时间',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'SubDate'
       },{
            id:'SysNo',
            header: '系统号',
            allowBlank: false,
            width:100,
            hidden:true,
            editable:false,
            dataIndex: 'SysNo'
       }, {
			id:'score',
			header:'计算得分',
			editable:true,
			width:120,
			hidden:true,
			dataIndex:'score'
		},{
			id:'Auditor',
			header:'审核人',
			editable:false,
			width:60,
			align:'left',
			dataIndex:'Auditor'
		},{
			id:'CheckDeptName',
			header:'审核人科室',
			editable:false,
			 hidden:true,
			width:120,
			align:'center',
			dataIndex:'CheckDeptName'
		},{
			id:'AuditDate',
			header:'审核时间',
			editable:false,
			width:80,
			align:'left',
			dataIndex:'AuditDate'
		},{
            id:'ChkResult', 
            header: '审核状态',
            allowBlank: false,
            width:120,
            editable:false,
            hidden:true,
            dataIndex: 'ChkResult'
       },{
            id:'ChkProcDesc', 
            header: '审核结果',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'ChkProcDesc'
       },{
            id:'CheckDesc', 
            header: '审核意见',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'CheckDesc'
       },{
            id:'EditorIDs', 
            header: '著作作者IDs',
            allowBlank: false,
            width:120,
            editable:false,
            hidden:true,
            dataIndex: 'EditorIDs'
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
            width:120,
             hidden:true,
            editable:false,
            dataIndex: 'DataStatus'
       },{
						id : 'IsReward',
						header : '是否奖励',
						editable:false,
						hidden:true,
						//format:'Y-m-d',
						width : 60,
						dataIndex : 'IsReward'
					}
					
					
					
					]
  }
  
  
  
  );


var AuditButton  = new Ext.Toolbar.Button({
	text: '报销审核通过',  
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
				    url:projUrl+'?action=audit&&rowid='+rowObj[i].get("rowid")+'&checker='+checker,
					waitMsg:'审核中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGrid.load({params:{start:0,limit:12,userdr:userdr}});
							
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
						 }else{noauditfun();}
					}
					
					
			   }
});

 var RewardAuditButton  = new Ext.Toolbar.Button({
		text: '奖励审核',  
        id:'RewardAuditButton', 
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
	     
	         
	         var RewardState= rowObj[j].get("IsReward") 
		     if(rowObj[j].get("IsReward")=="已奖励")
		     { 
			      Ext.Msg.show({title:'注意',msg:'已奖励',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		     }
		    
		     
		      var RewardAmount = rowObj[j].get("RewardAmount")  
		 	  if(rowObj[j].get("RewardAmount")==""){
			     Ext.Msg.show({title:'注意',msg:'请填写奖励金额!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			     return;
		    }
		    
		    
		       var RewardDate=rowObj[j].get("RewardDate");
				 if(RewardDate=="")
				 {
								     Ext.Msg.show({title:'注意',msg:'请选择奖励时间',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								     return;
				 }
		    
		      var aaa=rowObj[j].get("ChkProcDesc");
		      if((aaa.indexOf("等待审批")>0)||(aaa.indexOf("不通过")>0))
		      {
			     Ext.Msg.show({title:'注意',msg:'数据未审核不能发放奖励!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			     return;
		      }
		    		 
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					  var RewardAmount = rowObj[i].get("RewardAmount");  
					  var RewardDate=rowObj[i].get("RewardDate"); 
					  if(rowObj[i].isModified("RewardDate")){
						 
						  var RewardDate=RewardDate.format('Y-m-d');
						  
						  } 
					  
					      
					  Ext.Ajax.request({
						url:projUrl+'?action=rewardaudit&&rowid='+rowObj[i].get("rowid")+'&RewardAmount='+RewardAmount+'&checker='+checker+'&RewardDate='+RewardDate,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0,limit:12,userdr:userdr}});
								
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
	
var records = itemGrid.getSelectionModel().getSelections();
	var state = records[0].get("ChkResult");
	
	if(state!="通过")
	{
	  RewardAuditButton.disable();//设置为不可用
	  return;
	}else{
	   RewardAuditButton.enable();//设置为可用
	  return;
	}
	
	
});

//uploadMainFun(itemGrid,'rowid','P004',24);
downloadMainFun(itemGrid,'rowid','P004',29);	

