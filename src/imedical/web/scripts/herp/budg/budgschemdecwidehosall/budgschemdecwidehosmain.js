var BudgSchemDecWideHosUrl = '../csp/herp.budg.budgschemdecwidehosexe.csp';
// 预算编制年度
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
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


var queryPanel = new Ext.FormPanel({
	title: '全院年度预算分解',
	//height : 120,
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
			value : '',//'<left><p style="font-weight:bold;font-size:100%">全院年度预算分解</p></center>',
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
	
						var deptdr= -1;          
						function handler(id) {
							if (id == 'yes') {
							Ext.Ajax.request({
											url : BudgSchemDecWideHosUrl + '?action=calculate1&Year='
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
			value : '<p style="color:red;font-size:100%">说明：****全院年度预算分解计算****</p>',
			columnWidth : 1,
			height : '30'
		}]
	},{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<p style="color:red;font-size:100%">@@@：****全院年度预算分解到全院月预算****</p>',
			columnWidth : 1,
			height : '30'
		}]
	},{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<p style="color:red;font-size:100%">@@@：****全院年度预算分解到非独立核算的科室年预算****</p>',
			columnWidth : 1,
			height : '30'
		}]
	}]
	});