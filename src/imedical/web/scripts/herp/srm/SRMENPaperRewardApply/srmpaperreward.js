//实际上获得的是usercode
var userdr = session['LOGON.USERCODE'];    
var projUrl = 'herp.srm.enpaperrewardexe.csp';

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
    
var StartDateField = new Ext.form.DateField({
			fieldLabel: '开始时间',
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

/////////////////结束时间///////////////////////		
var EndDateField = new Ext.form.DateField({
			fieldLabel: '结束时间',
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
			//typeAhead : true,	
			allowblank:true,
			triggerAction : 'all',
			emptyText : '',
			name:'deptCombo',
			width : 120,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			editale:true
		});


// ///////////////////论文题目
var titleText = new Ext.form.TextField({
	width : 100,
	selectOnFocus : true
});

// ///////////////////期刊名称

var jnameTextDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


jnameTextDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.srm.paperpublishregisterexe.csp'+'?action=GetJournalDict&str='+encodeURIComponent(Ext.getCmp('jnameText').getRawValue()),method:'POST'});
});

var jnameText = new Ext.form.ComboBox({
	id: 'jnameText',
	fieldLabel: '期刊名称',
	width:120,
	listWidth : 240,
	allowBlank: true,
	store:jnameTextDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择期刊名称...',
	name: 'jnameText',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////第一作者  
var FirstAuthorDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

FirstAuthorDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=userList&str='+encodeURIComponent(Ext.getCmp('FirstAuthorCombox').getRawValue()),
						method : 'POST'
					});
		});

var FirstAuthorCombox = new Ext.form.ComboBox({
	    id:'FirstAuthorCombox',
			fieldLabel : '第一作者 ',
			store : FirstAuthorDs,
			displayField : 'name',
			valueField : 'rowid',
			//typeAhead : true,
			allowBlank:true,
			triggerAction : 'all',
			emptyText : '',
			name:'FirstAuthorCombox',
			width : 120,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			editable:true
		});	
	
/////第一通讯作者 
var CorrAuthorDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

CorrAuthorDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=userList&str='+encodeURIComponent(Ext.getCmp('CorrAuthorCombox').getRawValue()),
						method : 'POST'
					});
		});

var CorrAuthorCombox = new Ext.form.ComboBox({
	    id:'CorrAuthorCombox',
			fieldLabel : '第一通讯作者 ',
			store : CorrAuthorDs,
			displayField : 'name',
			valueField : 'rowid',
			//typeAhead : true,
			allowblank:true,
			name:'CorrAuthorCombox',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 240,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

//报销金额
var costNumberField = new Ext.form.NumberField({
	id: 'costNumberField',
	fieldLabel: '报销金额',
	width:200,
	allowBlank: false,
	listWidth : 220,
	triggerAction: 'all',
	emptyText:'',
	name: 'costNumberField',
	minChars: 1,
	pageSize: 10,
	editable:true
});

/////////////////// 查询按钮 
function srmFundApply(){
	    var startdate = StartDateField.getValue();
	    var enddate = EndDateField.getValue();
	    var dept  = deptCombo.getValue();
	    var title = titleText.getValue(); 
	    var jname = jnameText.getRawValue();
	    var FristAuthor = FirstAuthorCombox.getValue();
	    var CorrAuthor = CorrAuthorCombox.getValue();
	    var usercode = userdr;
	    var data = startdate+"|"+enddate+"|"+dept+"|"+title+"|"+jname+"|"+FristAuthor+"|"+CorrAuthor+"|"+usercode;
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


var queryPanel = new Ext.FormPanel({
			height:130,
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
				items:[{
				xtype: 'panel',
				layout:"column",
				items: [
					     {   
						xtype:'displayfield',
						value:'<center><p style="font-weight:bold;font-size:120%">英文论文奖励申请</p></center>',
						columnWidth:1,
						height:'50'
					 }]
			    },{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
				    {
							xtype:'displayfield',
							value:'开始时间:',
							columnWidth:.09
						},StartDateField,
						{
							xtype:'displayfield',
							value:'',
							columnWidth:.02
						},{
							xtype:'displayfield',
							value:'至',
							columnWidth:.02
						},{
							xtype:'displayfield',
							value:'结束时间:',
							columnWidth:.09
						},EndDateField
						,{
							xtype:'displayfield',
							value:'',
							columnWidth:.02
						},{
							xtype:'displayfield',
							value:'科室:',
							columnWidth:.05
						},
						deptCombo,
						{
							xtype:'displayfield',
							value:'',
							columnWidth:.02
						},{
							xtype:'displayfield',
							value:'论文题目:',
							columnWidth:.09
						},titleText
						]},{
			    columnWidth:1,
			    xtype: 'panel',
				  layout:"column",
				 items: [
						{
							xtype:'displayfield',
							value:'期刊名称:',
							columnWidth:.09
						},
						jnameText,
						{
							xtype:'displayfield',
							value:'',
							columnWidth:.02
						},
						{
							xtype:'displayfield',
							value:'第一作者:',
							columnWidth:.09
						},
						FirstAuthorCombox,
						{
							xtype:'displayfield',
							value:'',
							columnWidth:.02
						},{
							xtype:'displayfield',
							value:'第一通讯作者:',
							columnWidth:.12
						},CorrAuthorCombox,
						{
							xtype:'displayfield',
							value:'',
							columnWidth:.02
						}
						,{
							xtype:'button',
							text: '查询',
							handler:function(b){
								srmFundApply();
							},
							iconCls: 'find'
						}		
					]
			    }
			]
		});

var itemGrid = new dhc.herp.Grid({
		    //title: '论文申请审批',
		    region : 'center',
		    url: projUrl,
		    atLoad : true, // 是否自动刷新
			fields : [
			      //new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '奖励信息表ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'RecordType',
						header : '论文类型',
						editable:false,
						width : 120,
						dataIndex : 'RecordType'  
					},{
						id : 'RewardAmountStd',
						header : '标准奖励金额',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'RewardAmountStd'  
					},{
						id : 'DeptDr',
						header : '科室',
						width : 120,
						editable:false,
						dataIndex : 'DeptDr'
					},{
						id : 'Title',
						header : '论文题目',
						editable:false,
						width : 180,
						dataIndex : 'Title'
					}, {
						id : 'JName',
						header : '期刊名称',
						editable:false,
						width : 120,
						dataIndex : 'JName'
					},{
						id : 'PType',
						header : '国内外期刊',
						width : 120,
						editable:false,
						dataIndex : 'PType'
					},{
						id : 'RegInfo',
						header : '年卷期页',
						width : 150,
						editable:false,
						dataIndex : 'RegInfo'
					},  {
						id : 'FristAuthor',
						header : '第一作者',
						width : 120,
						editable : false,
						dataIndex : 'FristAuthor'						
					},{
						id : 'FristAuthorComp',
						header : '第一作者单位',
						width : 120,
						editable : false,
						dataIndex : 'FristAuthorComp'						
					},{
						id : 'FristAuthorRange',
						header : '第一作者排名',
						width : 120,
						editable : false,
						dataIndex : 'FristAuthorRange'						
					},{
						id : 'CorrAuthor',
						header : '第一通讯作者',
						width : 120,
						editable : false,
						dataIndex : 'CorrAuthor'			
					},{
						id : 'CorrAuthorComp',
						header : '第一通讯作者单位',
						width : 120,
						editable : false,
						dataIndex : 'CorrAuthorComp'						
					},{
						id : 'CorrAuthorRange',
						header : '第一通讯作者排名',
						width : 120,
						editable : false,
						dataIndex : 'CorrAuthorRange'						
					},{
						id : 'IF',
						header : '影响因子',
						width : 120,
						editable : false,
						dataIndex : 'IF'						
					},{
						id : 'PageCharge',
						header : '版面费',
						width : 120,
						editable:true,
						allowblank:false,
						dataIndex : 'PageCharge'
					},{
						id : 'RewardAmount',
						header : '奖励',
						width : 120,
						editable:true,
						allowblank:false,
						dataIndex : 'RewardAmount'
					},{
						id : 'SubUser',
						header : '申请人',
						width : 120,
						editable:false,
						allowblank:false,
						dataIndex : 'SubUser'
					},{
						id : 'SubDate',
						header : '申请时间',
						width : 120,
						editable:false,
						dataIndex : 'SubDate'
					},{
						id : 'DataStatus',
						header : '数据状态',
						width : 120,
						editable:false,
						dataIndex : 'DataStatus'
					},{
						id : 'CheckState',
						header : '审批结果',
						editable:false,
						width : 120,
						hidden:false,
						dataIndex : 'CheckState'
					},{
						id : 'CheckDesc',
						header : '审批意见',
						width : 150,
						editable:false,
						dataIndex : 'CheckDesc'
					}]					
		});

var RewardApplyButton  = new Ext.Toolbar.Button({
		text: '奖励申请',  
        iconCls:'option',
        handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要申请的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		for(var j= 0; j < len; j++){
			if(rowObj[j].get("DataStatus")=="已提交"){
				Ext.Msg.show({title:'注意',msg:'已提交申请数据不能再申请!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			if(rowObj[j].get("RewardAmount")==0){
				Ext.Msg.show({title:'注意',msg:'奖励金额不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			//var firstAuthor=rowObj[j].get("FristAuthorName")+"的";
		 var RewardAmountStd=rowObj[j].get("RewardAmountStd");
		 if(rowObj[j].get("RewardAmount")>RewardAmountStd)
		 {
		 	var recordtype=rowObj[j].get("RecordType");
		 	Ext.Msg.show({title:'注意',msg:recordtype+'的奖励金额不能超过'+RewardAmountStd,buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		 }
		 /**
		  if(rowObj[j].get("RecordType")=="SCI"&&((rowObj[j].get("RewardAmount")>10000)||(rowObj[j].get("RewardAmount")<0)))
		 {
			      Ext.Msg.show({title:'注意',msg:'SCI论文奖励金额不能超过10000元',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }else if(rowObj[j].get("RecordType")=="核心期刊"&&((rowObj[j].get("RewardAmount")!=500)||(rowObj[j].get("RewardAmount")<0))){
			 Ext.Msg.show({title:'注意',msg:'核心期刊论文奖励金额为500元',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
		 }else if(rowObj[j].get("RecordType")=="非核心期刊"&&((rowObj[j].get("RewardAmount")>0)||(rowObj[j].get("RewardAmount")<0))){
			 Ext.Msg.show({title:'注意',msg:'非核心期刊论文奖励金额为0元',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
		 }
		 **/
		}
		
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:projUrl+'?action=submit&&rowid='+rowObj[i].get("rowid")+'&rewardamount='+rowObj[i].get("RewardAmount")+'&userdr='+userdr,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'申请成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:12,data:data}});								
							}else{
								var message='论文奖励申请失败!';
								if(jsonData.info=="RepInvoice") message="不能重复申请";
								if(jsonData.info=="该人员在科研人员中不存在!") message="该人员在科研人员中不存在!";
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
		Ext.MessageBox.confirm('提示','确实要申请所选记录吗?',handler);
    }
});

  itemGrid.addButton('-');
  itemGrid.addButton(RewardApplyButton);
//  itemGrid.addButton('-');
//  itemGrid.addButton(NoAuditButton);

  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏重置按钮
  itemGrid.btnSaveHide(); 	//隐藏重置按钮
  
  var data="|||||||"+userdr;
  itemGrid.load({params:{start:0, limit:12, data:data}});

