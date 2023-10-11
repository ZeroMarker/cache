
var userdr = session['LOGON.USERID'];
var username = session['LOGON.USERNAME'];

var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var URL='herp.budg.budgreportctrlitembudgsearchreqexe.csp'


///获取科室名称
	var deptnameDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
	
	
	deptnameDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl + '?action=dept',method:'POST'});
	});
	
	var deptnameField = new Ext.form.ComboBox({
		id: 'deptnameField',
		fieldLabel: '科室名称',
		width:200,
		listWidth : 200,
		allowBlank: false,
		store: deptnameDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择科室名称...',
		name: 'deptnameField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});

///获取年份
	var yearDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
	});
	
	
	yearDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:commonboxUrl + '?action=year',method:'POST'});
	});
	
	var yearField = new Ext.form.ComboBox({
		id: 'yearField',
		fieldLabel: '年份',
		width:200,
		listWidth : 200,
		allowBlank: false,
		store: yearDs,
		valueField: 'year',
		displayField: 'year',
		triggerAction: 'all',
		emptyText:'请选择年份...',
		name: 'yearField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
var reportPanel=new Ext.Panel({
			autoScroll:true,
			frame:true,
			html:'<iframe id="reportFrame" height="100%" width="100%" src="../scripts/dhcmed/img/logon_bg2.jpg"/>'
});




////////////// 查询按钮 /////////////////
var findBT = new Ext.Toolbar.Button({
				id : "findBT",
				text : '<font color=blue>查询</font>',
				tooltip : '查询',
				width : 50,
				handler : function() {
					var deptdr = deptnameField.getValue();	
	
	                               if(deptdr==""){
			               Ext.Msg.show({title:'注意',msg:'请选择科室名称!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			               return;}
					ShowReport();
				}
});




////////////// 打印按钮 /////////////////
var printBT = new Ext.Toolbar.Button({
				id : "printBT",
				text : '<font color=blue>打印</font>',
				tooltip : '打印（无背景颜色）',
				width : 50,
				handler : function() {
					
					var deptdr = deptnameField.getValue();
	                        var year = yearField.getValue();
	                        ///alert(year+"^"+deptdr);
					ShowPrintReportFun(year,deptdr);
				}
});



/*
	ExtJs FormPanel布局 
	FormPanel有两种布局：form和column，form是纵向布局，column为横向布局。默认为后者。使用layout属性定义布局类型。对于一个复杂的布局表单，最重要的是正确分割，分割结果直接决定布局能否顺利实现。
	如果不再使用默认布局，那么我们必须为每一个元素指定一种布局方式，另外，还必须遵循以下几点：
	【1】落实到任何一个表单组件后，最后总是form布局
	【2】defaultType属性不一定起作用，必须显式为每一个表单组件指定xtype或new出新对象
	【3】在column布局中，通过columnWidth可以指定列所占宽度的百分比，如占50%宽度为.5。
*/

var searchPanel = new Ext.form.FormPanel({
			id : 'searchPanel',
			width : 500,
			labelWidth : 80,
			labelAlign : 'left',
			frame : true,
			bodyStyle : 'padding:1px;',
			layout : "form",
			items : [{  
						xtype : 'panel',
						layout:'column',
						items:[{
								 style :"padding-top:6px",
								 xtype : 'displayfield',
								 value : '年份：'
							  },yearField
							  ,{
								 xtype : 'displayfield',
								 value : '',
							     width : 15

							  },{
							      style :"padding-top:6px",
								  xtype : 'displayfield',
								  value : '科室名称：'
						       },deptnameField
						        ,{
								xtype : 'displayfield',
								value : '',
								width:15
							  },findBT
							  ,{
								 xtype : 'displayfield',
								 value : '',
							     width : 15
							  },printBT
							  ]
					}]
});

function ShowReport()
{
	
	var reportframe=document.getElementById("reportFrame");
	var deptdr = deptnameField.getValue();
	var year = yearField.getValue();	
	//alert(deptdr+"^^^^"+year);
	var p_URL = 'dhccpmrunqianreport.csp?reportName=HERPBUDGCtrlItemBudgCreate.raq&year='+year+'&deptdr='+deptdr; 
	
	reportframe.src=p_URL;
	
}



