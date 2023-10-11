﻿
var userdr = session['LOGON.USERID'];
var username = session['LOGON.USERNAME'];

//var URL='herp.budg.budgreportdeptexeanaexe.csp'


			
var reportPanel=new Ext.Panel({
			autoScroll:true,
			frame:true,
			html:'<iframe id="reportFrame" height="100%" width="100%" src="../scripts/dhcmed/img/logon_bg2.jpg"/>'
});


var StartField = new Ext.form.DateField({
		id : 'StartField',
		format : 'Y-m-d',
		fieldLabel : '开始日期',
		width : 150,
		emptyText : ''
});
var EndField = new Ext.form.DateField({
		id : 'EndField',
		format : 'Y-m-d',
		fieldLabel : '结束日期',
		width : 150,
		emptyText : ''
		
});



////////////// 查询按钮 /////////////////
var findBT = new Ext.Toolbar.Button({
				id : "findBT",
				text : '<font color=blue>查询</font>',
				tooltip : '查询',
				width : 50,
				handler : function() {
					
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
					
					var startdate = StartField.getValue();
	                var enddate = EndField.getValue();
					ShowPrintReportFun(startdate,enddate);
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
								  value : '开始日期：'
						       },StartField,
						        {
								xtype : 'displayfield',
								value : '',
								width:15
							  },{
								 style :"padding-top:6px",
								 xtype : 'displayfield',
								 value : '结束日期：'
							  },EndField
							  ,{
								 xtype : 'displayfield',
								 value : '',
							         width : 15

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
	var startdate = StartField.getValue();
	var enddate = EndField.getValue();
	if( startdate !=""){startdate=startdate.format('Y-m-d');}
	if( enddate !=""){enddate=enddate.format('Y-m-d');}		
	
	var p_URL = 'dhccpmrunqianreport.csp?reportName=HERPBUDGBudgExeReq.raq&startdate='+startdate+'&enddate='+enddate; 
	
	reportframe.src=p_URL;
	
}


