
var usercode = session['LOGON.USERCODE'];
var projUrl = 'herp.srm.srmpatentcertificateauditexe.csp';
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



/////////////////授权日期///////////////////////
var StartDateField = new Ext.form.DateField({
			fieldLabel: '专利申请日期',
			width:120,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
var EndDateField = new Ext.form.DateField({
			fieldLabel: '专利申请日期',
			width:120,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
/////////////////科室///////////////////////
var DeptDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


DeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentcertificateapplyexe.csp'+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),
	method:'POST'});
});

var DeptField = new Ext.form.ComboBox({
	id: 'DeptField',
	fieldLabel: '科室',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:DeptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择科室...',
	name: 'DeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////////专利权人///////////////////
var PatenteeDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


PatenteeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentcertificateapplyexe.csp'+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patentees').getRawValue()),
	method:'POST'});
});

var PatenteeField = new Ext.form.ComboBox({
	id: 'Patentees',
	fieldLabel: '专利权人',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:PatenteeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择专利权人...',
	name: 'Patentees',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////////专利名称///////////////////
var PatentName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PatentName',
                fieldLabel: '专利名称',
                blankText: '专利名称'
            });

/////////////////////专利类别/////////////////////////////					
var ufPatentTypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '发明专利'], ['2', '实用新型专利'], ['3', '外观设计专利']]
	});
	var ufPatentTypeField = new Ext.form.ComboBox({
	    id : 'ufPatentTypeField',
		fieldLabel : '专利类别',
		width : 120,
		listWidth : 120,
		store : ufPatentTypeDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		//emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection : true
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
/////////////////////是否获批/////////////////////////////					
var IsApprovedDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['Y', '是'], ['N', '否']]
	});
var IsApprovedCombo = new Ext.form.ComboBox({
	    id : 'IsApprovedCombo',
		fieldLabel : '是否获批',
		width : 120,
		listWidth : 120,
		store : IsApprovedDs,
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		mode : 'local', // 本地模式
		triggerAction: 'all',
		//emptyText:'请选择...',
		selectOnFocus:true,
		forceSelection : true
	});	
/////////////////获批时间///////////////////////
var ApprovedDateField = new Ext.form.DateField({
	        id: 'ApprovedDateField',
			fieldLabel: '获批时间',
			width:120,
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
	    var startdate= StartDateField.getRawValue()
		if(startdate!=""){
			//startdate.format("Y-m-d");
		};
		var enddate= EndDateField.getRawValue()
		if(enddate!=""){
			//enddate.format("Y-m-d");
		};
	    var DeptDr  = DeptField.getValue();
        var Patentee = PatenteeField.getValue();
        
        var Name = PatentName.getValue();
        var PatentType = ufPatentTypeField.getValue();
        var auditstate = AuditStateField.getValue();
		
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,DeptDr:DeptDr,Patentee:Patentee,Name:Name,auditstate:auditstate,usercode:usercode,PatentType:PatentType}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	autoHeight : true,
	title : '专利院内证明审核信息查询',
	iconCls : 'search',
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
				/* {
					xtype : 'displayfield',
					value : '<p style="text-align:right;">科室</p>',
					width : 60			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				DeptField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				}, */
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">专利权人</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PatenteeField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">专利名称</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},	
				PatentName,
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
				StartDateField,
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
				EndDateField,
				{
					xtype : 'displayfield',
					value : '',
					width : 30
				},		
				{
					xtype : 'button',
					text : '查询',
					handler : function(b){SearchFun();},
					iconCls : 'search',
					width : 30
				}
				]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">专利类型</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				ufPatentTypeField,
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
				AuditStateField
				]
	}]
	
});




var itemGrid = new dhc.herp.Grid({
	title: '专利院内证明审核信息查询列表',
			iconCls: 'list',
			region : 'center',
			url : projUrl,
			///// 根据条件设置单元格点击编辑是否可用
			
			fields : [
			 new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
						header:'ID',
						dataIndex:'rowid',
						align:'center',
						hidden:true
					},{
						id:'YearDr',
						header:'年度 ',
						width:60,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'YearDr'

					},{
						id:'PatentType',
						header:'专利类别',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'PatentTypeList'
					},{
						id:'Name',
						header:'专利名称',
						width:180,
						editable:false,
						align:'left',
						/*
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						*/
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+data+'</span>';;
						},
						dataIndex:'Name'
					}, {
						id:'Patentee',
						header:'专利权人',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'Patentee',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id:'InventorsID',
						header:'发明人IDs',
						width:100,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'InventorsID'
					},{
						id:'InventorInfos',
						header:'发明人',
						width:80,
						editable:false,
						align:'left',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						dataIndex:'InventorInfos'
					},{
						id:'IsApproved',
						header:'是否获批',
						width:60,
						editable:true,
						align:'left',
						dataIndex:'IsApproved',
						type:IsApprovedCombo
					},{
						id:'ApprovedDate',
						header:'获批日期',
						width:80,
						editable:true,
						align:'left',
						dataIndex:'ApprovedDate',
						type:ApprovedDateField,
						renderer : function(v, p, r, i) {			
						if (v instanceof Date) {
							return new Date(v).format("Y-m-d");
						} else {return v;}
			          }
					},{
						id:'AppDate',
						header:'专利申请日期',
						//xtype:'numbercolumn',
						width : 120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AppDate'

					},{
						id:'SubUser',
						header:'申请人',
						editable:false,
						width:60,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'SubDept',
						header:'申请人科室',
						editable:false,
						width:120,
						align:'left',
						dataIndex:'SubDept',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id:'SubDate',
						header:'登记时间',
						editable:false,
						width:80,
						align:'left',
						dataIndex:'SubDate'
					},{
						id:'AuditStatus',
						header:'审核状态',
						width:120,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'AuditStatus'
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
						width:120,
						hidden:true,
						align:'left',
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
						header:'审核状态',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'ChkResult'
					},{
						id:'ChkProcDesc',
						header:'审核结果',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'ChkProcDesc'
					},{
						id:'Desc',
						header:'审核意见',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'Desc'
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
							id:'Phone',
							header: '电话号码',
							allowBlank: false,
							width:120,
							hidden:true,
							editable:false,
							dataIndex: 'Phone'
						},{
							id:'Email',
							header: '邮件',
							allowBlank: false,
							width:120,
							hidden:true,
							editable:false,
							dataIndex: 'Email'
						},{
							id:'IsApprovedID',
							header: '是否获批标志',
							allowBlank: false,
							width:120,
							hidden:true,
							editable:false,
							dataIndex: 'IsApprovedID'
						}
					
					
					
					]
		});


var AuditButton = new Ext.Toolbar.Button({
	text: '通过',  
    iconCls: 'pencil',
    handler:function(){
	//定义并初始化行对象
	var usercode = session['LOGON.USERCODE'];
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	for(var j= 0; j< len; j++){
	     //alert(rowObj[j].get("RewardAmount"))
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
						url:projUrl+'?action=audit&rowid='+rowObj[i].get("rowid")+'&usercode='+usercode+'&ratio='+rowObj[i].get("Ratio"),
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},   
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'专利院内证明审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25,usercode:usercode}});								
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
		Ext.MessageBox.confirm('提示','确实要审核所选记录吗?审核后不能修改',handler);
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
	       }else
						{noauditfun();}
					}
					
					
			   }
});
 var ApprovedAuditButton  = new Ext.Toolbar.Button({
		text: '是否获批',  
        id:'ApprovedAuditButton', 
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
			var rowid=rowObj[j].get("rowid");
		    
		 	
		   var aaa=rowObj[j].get("ChkProcDesc");
		    if((aaa.indexOf("等待审批")>0)||(aaa.indexOf("不通过")>0))
		    {
			     Ext.Msg.show({title:'注意',msg:'数据未审核通过不能确认是否获批!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			     return;
		    }
			var IsApprovedID = rowObj[j].get("IsApprovedID"); 
			if(IsApprovedID!="")
		    {
			     Ext.Msg.show({title:'注意',msg:'已确认是否获批，不能再次更改！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			     return;
		    }
			
			if(rowObj[j].get("IsApproved")==""){
			     Ext.Msg.show({title:'注意',msg:'请填写是否获批!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			     return;
		    } 
		    var ApprovedDate=rowObj[j].get("ApprovedDate");
			if((IsApprovedCombo.getValue()=="Y")&(ApprovedDateField.getValue()==""))
			{
				Ext.Msg.show({title:'注意',msg:'请选择获批日期',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					  var IsApproved = IsApprovedCombo.getValue();   
					     var ApprovedDate=ApprovedDateField.getValue();
					      if(rowObj[i].isModified("ApprovedDate")){ 
						  var ApprovedDate=ApprovedDate.format('Y-m-d');
						  } 
					  var rowid=rowObj[i].get("rowid")
					  Ext.Ajax.request({
						url:projUrl+'?action=approvedaudit&rowid='+rowid+'&isapproved='+IsApproved+'&date='+ApprovedDate,
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
	itemGrid.addButton(ApprovedAuditButton);
	

  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏添加按钮
  itemGrid.btnSaveHide(); 	//隐藏保存按钮
  itemGrid.load({params:{start:0, limit:12, usercode:usercode}});
 
 // 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//明细信息
	var records = itemGrid.getSelectionModel().getSelections();
	if (columnIndex == 5) {
		PatentDetail(itemGrid);
	}
	if (columnIndex == 8) {
		var authorinfo = records[0].get("InventorsID");
		var title = records[0].get("Name");
		AuthorInfoList(title,authorinfo);
	}
	// var IsApproved=records[0].get("IsApproved");
	var IsApproved = IsApprovedCombo.getRawValue();
	if (IsApproved=="否")
	{
		ApprovedDateField.disable();
	}
	if (IsApproved=="是")
	{
		ApprovedDateField.enable();
	} 
}); 

//uploadMainFun(itemGrid,'rowid','P005',24);
downloadMainFun(itemGrid,'rowid','SRMpatentapply001,SRMpatentapply002,SRMpatentapply003,SRMpatentapply004,SRMpatentapply005',22);