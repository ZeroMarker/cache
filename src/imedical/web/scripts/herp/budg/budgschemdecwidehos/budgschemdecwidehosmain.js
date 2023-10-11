var BudgSchemDecWideHosUrl = '../csp/herp.budg.budgschemdecwidehosexe.csp';
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
// 预算编制年度
var yearDs  = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});

yearDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl+'?action=year',method:'POST'})
		});

var yearField  = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '预算编制年度',
	width:120,
	listWidth : 245,
	// allowBlank: false,
	store: yearDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
});

//科室名称
var deptnmDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

deptnmDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl+'?action=dept',method:'POST'})
});
var deptnmField = new Ext.form.ComboBox({
	id: 'deptnmField',
	fieldLabel: '科室名称',
	width:145,
	listWidth : 245,
	//allowBlank: false,
	store: deptnmDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室名称...',
	name: 'deptnmField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


var queryPanel = new Ext.FormPanel({
	height : 120,
	region : 'center',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<left><p style="font-weight:bold;font-size:100%">科室年度科目预算分解计算</p></center>',
			columnWidth : 1,
			height : '30'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		        {
					xtype : 'displayfield',
					value : '预算编制年度:',
					columnWidth : .09
				}, yearField,

				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .07
				},
				 {
					xtype : 'displayfield',
					value : '科室名称:',
					columnWidth : .07
				}, deptnmField,

				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .07
				}
				]
	},
	{
		xtype: 'panel',
		layout:"column",
		items: [
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .38
				},{
					columnWidth:.07,
					xtype:'button',
					text: '计算',
					handler:function(){
						var year=yearField.getValue();
						if(year==""){
							Ext.Msg.show({title:'错误',msg:'年度不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						};
	
						var deptdr=deptnmField.getValue();
						if(deptdr==""){
							Ext.Msg.show({title:'错误',msg:'科室名称不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						};
	
						function handler(id) {
							if (id == 'yes') {
								Ext.Ajax.request({
											url : BudgSchemDecWideHosUrl + '?action=calculate&Year='
													+ year+'&DeptDR='+deptdr+'&changeflag=1',
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
																msg : '计算成功!',
																buttons : Ext.Msg.OK,
																icon : Ext.MessageBox.INFO
															});
											
	
												} else {
													Ext.Msg.show({
																title : '错误',
																msg : jsonData.info,
																buttons : Ext.Msg.OK,
																icon : Ext.MessageBox.ERROR
															});
												}
											},
											scope : this
										})
								}
							}
							Ext.MessageBox.confirm('提示','确实要计算吗?',handler);			
							}					
					}				
				]
	},{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<p style="color:red;font-size:100%">说明：****科室年度月科目预算分解计算****</p>',
			columnWidth : 1,
			height : '30'
		}]
	}
	,{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<p style="color:red;font-size:100%">@@@：****根据科室年分解到科室月****</p>',
			columnWidth : 1,
			height : '30'
		}]
	}]
	});