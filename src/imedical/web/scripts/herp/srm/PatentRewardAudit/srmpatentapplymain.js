
var usercode = session['LOGON.USERCODE'];
var projUrl = 'herp.srm.srmpatentrewardauditexe.csp';
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
			fieldLabel: '授权日期',
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
			fieldLabel: '授权日期',
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
	url:'herp.srm.srmpatentrewardapplyexe.csp'+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),
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
	url:'herp.srm.srmpatentrewardapplyexe.csp'+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patentees').getRawValue()),
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


/////////////////专利号///////////////////
var PatentNumber = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PatentNumber',
                fieldLabel: '专利号',
                blankText: '专利号'
            });
/////////////////专利名称///////////////////
var PatentName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PatentName',
                fieldLabel: '专利名称',
                blankText: '专利名称'
            });



/////////////////专利发明人///////////////////////////
var InventorsDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


InventorsDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.srmpatentrewardapplyexe.csp?action=GetInventors&str='+encodeURIComponent(Ext.getCmp('Inventorss').getRawValue()),
	method:'POST'});
});

var InventorsField = new Ext.form.ComboBox({
	id: 'Inventorss',
	fieldLabel: '专利发明人',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:InventorsDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择专利发明人...',
	name: 'Inventorss',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
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
        var PatentNum = PatentNumber.getValue();
        var Name = PatentName.getValue();
        var Inventors = InventorsField.getValue();
        var auditstate = AuditStateField.getValue();
		
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,DeptDr:DeptDr,Patentee:Patentee,PatentNum:PatentNum,Name:Name,Inventors:Inventors,auditstate:auditstate,usercode:usercode}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	autoHeight : true,
	region : 'north',
	frame : true,
	title : '专利奖励审核信息查询',
	iconCls : 'search',

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
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
				DeptField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
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
					value : '<p style="text-align:right;">授权日期</p>',
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
					width : 70			
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
					value : '<p style="text-align:right;">专利号</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},	
				PatentNumber,
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
					value : '<p style="text-align:right;">专利发明人</p>',
					width : 70			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				InventorsField
				]
	}]
	
});



/////////////////奖励时间///////////////////////
var RewardDateField = new Ext.form.DateField({
	        id: 'RewardDateField',
			fieldLabel: '奖励时间',
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
////////////////////报销比例/////////////////////////////

var RatioStore = new Ext.data.SimpleStore({
	fields:['key','keyvalue'],
	data:[['0','0'],['0.5','50%'],['1','100%']]
});

var RatioCombox = new Ext.form.ComboBox({
	id: 'RatioCombox',
	fieldLabel: '报销比例',
	width:120,
	//anchor: '95%',
	listWidth : 80,
	allowBlank: true,
	store:RatioStore,
	valueField: 'key',
	displayField: 'keyvalue',
	value:'',
	triggerAction: 'all',
	//emptyText:'请选择报销比例...',
	mode : 'local',
	name: 'RatioCombox',
	minChars: 1,
	//pageSize: 10,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: '专利奖励审核信息查询列表',
			iconCls: 'list',
			url : 'herp.srm.srmpatentrewardauditexe.csp',
			///// 根据条件设置单元格点击编辑是否可用
			listeners:{
	        'cellclick' : function(grid, rowIndex, columnIndex, e) {
	               var record = grid.getStore().getAt(rowIndex);
	               if ((record.get('ChkResult') != '等待审批') &&(columnIndex == 17)) {    
	                      Ext.Msg.show({title:'注意',msg:'报销已审核,不能修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	                      return false;
	               }else{
		               /**
	                   if((record.get('ChkResult') == '通过')&&(record.get('IsReward')=='已奖励')&&((columnIndex==23)||(columnIndex==24)))
					   {
					   Ext.Msg.show({title:'注意',msg:'奖励已审核,不能修改!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	                      return false;
					   }
					   else{
					   return true;
					   }**/
	               }
	        }},				
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
						id:'CertificateNo',
						header:'证书号',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'CertificateNo'

					},{
						id:'PatentType',
						header:'专利类别',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'PatentType'
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

					}, {
						id:'Inventors',
						header:'发明人IDs',
						width:120,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Inventors'
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
						id:'PatentNum',
						header:'专利号',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'PatentNum'

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
						id:'AnnDate',
						header:'授权公告日期',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AnnDate'

					},{
						id:'AnnUnit',
						header:'公布单位',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AnnUnit'

					},{
						id:'AnnUnitList',
						header:'公布单位',
						width:120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'AnnUnitList'

					},{
						id:'CompleteUnit',
						header:'第几完成单位',
						//xtype:'numbercolumn',
						width : 120,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'CompleteUnit'

					},{
						id:'VCAmount',
						header:'申请报销(元)',
						editable:false,
						width:100,
						align:'right',
						dataIndex:'VCAmount',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }			
					},{
						id:'unitMoney',
						header:'货币单位',
						editable:false,
						width:60,
						align:'left',
						editable:false,
						dataIndex:'unitMoney'
					},{
						id:'Ratio',
						header:'报销比例',
						editable:true,
						width:80,
						align:'right',
						dataIndex:'Ratio',
						type:RatioCombox
					},{
						id:'REAmount',
						header:'实际报销(元)',
						editable:false,
						width:100,
						align:'right',
						dataIndex:'REAmount',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id:'InvoiceCode',
						header:'报销编码',
						editable:false,
						width:120,
						align:'left',
						hidden:true,
						dataIndex:'InvoiceCode'
					},{
						id:'InvoiceNo',
						header:'报销号',
						editable:false,
						width:120,
						align:'left',
						hidden:true,
						dataIndex:'InvoiceNo'
					},{
						id : 'IsReward',
						header : '是否奖励',
						width : 120,
						editable:false,
						hidden:true,
						allowblank:false,
						dataIndex : 'IsReward'
					},{
						id : 'RewardAmount',
						header : '奖励(元)',
						width : 80,
						editable:true,
						allowblank:false,
						align:'right',
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
						width : 80,
						dataIndex : 'RewardDate',
						type:RewardDateField,
						renderer : function(v, p, r, i) {			
						if (v instanceof Date) {
							return new Date(v).format("Y-m-d");
						} else {return v;}
			          }
			         },{
						id:'score',
						header:'计算得分',
						width:120,
						editable:true,
						align:'left',
						hidden:true,
						dataIndex:'score'
					},{
						id:'SubUser',
						header:'申请人',
						editable:false,
						width:60,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'DeptDr',
						header:'申请人科室',
						editable:false,
						width:120,
						align:'left',
						dataIndex:'DeptDr',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id:'SubDate',
						header:'申请时间',
						editable:false,
						width:80,
						align:'left',
						dataIndex:'SubDate'
					},{
						id:'AuditStatus',
						header:'审核状态',
						width:150,
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
						width:150,
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
					}, {
							id:'IsLastStep',
							header: '是否最后一步',
							allowBlank: false,
							width:120,
							hidden:true,
							editable:false,
							dataIndex: 'IsLastStep'
						}
					]
		});


var AuditButton = new Ext.Toolbar.Button({
	text: '报销审核通过',  
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
		      Ext.Msg.show({title:'注意',msg:'数据报销已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
	 
	    var tmpIsLastStep=rowObj[j].get("IsLastStep");
		 //if((rowObj[j].get("Ratio")=="")&&(rowObj[j].get("ChkProcDesc").indexOf("科研处主任")>-1)){
		if((rowObj[j].get("Ratio")=="")&&(tmpIsLastStep=="Y")){
			Ext.Msg.show({title:'注意',msg:'请填写报销比例!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
								Ext.Msg.show({title:'注意',msg:'报销审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25,usercode:usercode}});								
							}else{
							Ext.Msg.show({title:'错误',msg:'报销审核失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
		      Ext.Msg.show({title:'注意',msg:'数据报销已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	       }else
						{noauditfun();}
					}
					
					
			   }
});
var RewardAuditButton = new Ext.Toolbar.Button({
    id:'RewardAudit',
	text: '奖励审核',  
    iconCls: 'pencil',
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
	   

	   if(rowObj[j].get("IsReward")!='未奖励')
		{
		    Ext.Msg.show({title:'注意',msg:'该数据已奖励',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
		}

		 if(rowObj[j].get("RewardAmount")==""){
			Ext.Msg.show({title:'注意',msg:'奖励金额不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(rowObj[j].get("RewardDate")==""){
			Ext.Msg.show({title:'注意',msg:'奖励时间不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
						url:projUrl+'?action=rewardaudit&rowid='+rowObj[i].get("rowid")+'&rewardamount='+RewardAmount+'&RewardDate='+RewardDate,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},   
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'奖励审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25,usercode:usercode}});								
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
  itemGrid.load({params:{start:0, limit:12, usercode:usercode}});
 
 // 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//明细信息
	if (columnIndex == 6) {
		PatentDetail(itemGrid);
	}
	//作者排名
	if (columnIndex == 9) {
		var records = itemGrid.getSelectionModel().getSelections();
		var authorinfo = records[0].get("Inventors");
		var title = records[0].get("Name");
		AuthorInfoList(title,authorinfo);
	}
	var records = itemGrid.getSelectionModel().getSelections();
	var state = records[0].get("ChkResult");
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

//uploadMainFun(itemGrid,'rowid','P005',24);
downloadMainFun(itemGrid,'rowid','P005',36);