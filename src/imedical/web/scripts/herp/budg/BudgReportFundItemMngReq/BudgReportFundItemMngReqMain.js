
var userdr = session['LOGON.USERID'];
var username = session['LOGON.USERNAME'];


//var URL='herp.budg.budgreportfunditemmngreqexe.csp'
//alert(userdr+"^"+username)
/////////////////////////////////////// 按日查询 /////////////////////////////////////////
var startDateField= new Ext.form.DateField({
	format:'Y-m-d',
	emptyText:'开始时间...',
	columnWidth:1
});
var endDateField= new Ext.form.DateField({
	format:'Y-m-d',
	emptyText:'结束时间...',
	renderer : function(v, p, r, i) {			
				if (v instanceof Date) {
					return new Date(v).format("Y-m-d");
				} else {
					return v;
				}
	},
	columnWidth:1
});
/////////////////////////////////////// 按月查询 /////////////////////////////////////////
var startPeriodField= new Ext.form.DateField({
	format:'Y-m',
	emptyText:'开始日期...',
	columnWidth:1
});
var endPeriodField= new Ext.form.DateField({
	format:'Y-m',
	emptyText:'结束日期...',
	columnWidth:1
});
/////////////////////////////////////// 现金流量项 /////////////////////////////////////////
var startCodeField = new Ext.form.TextField({
	fieldLabel: '现金流量项：',
	width:120,
	emptyText:'请输入开始编码...',
	name: 'startCodeField',
	selectOnFocus:true,
	editable:true
});
var endCodeField = new Ext.form.TextField({
	width:120,
	emptyText:'请输入结束编码...',
	name: 'endCodeField',
	selectOnFocus:true,
	editable:true
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

///////打印按钮/////////////////////////
var printBT = new Ext.Toolbar.Button({
	id : "printBT",
    text : '<font color=blue>打印</font>',
	tooltip : '点击打印现金流量表',
	width : 50,
	iconCls : 'print',
	handler : function() {
	
	
	var startdate  =startDateField.getValue();
	var enddate    =endDateField.getValue();
	var startperiod=startPeriodField.getValue();
	var endperiod  =endPeriodField.getValue();
	var startcode  =startCodeField.getValue();
	var endcode    =endCodeField.getValue();
	var year=""
	if(startdate!="")    {  startdate  =startdate.format('Y-m-d');var year=startdate.substring(0,4);}
	if(enddate!="")      {  enddate  =enddate.format('Y-m-d');var year=enddate.substring(0,4);}
	if(startperiod!="")  {  startperiod  =startperiod.format('Y-m');var year=startperiod.substring(0,4);}
	if(endperiod!="")    {  endperiod  =endperiod.format('Y-m');var year=endperiod.substring(0,4);}
	//alert(year)
	//alert(startdate+"^"+enddate+"^"+startperiod+"^"+endperiod+"^"+startcode+"^"+endcode+"^"+username)
	
	fileName="{HERPBUDGFundItemMngReqPrint.raq(startdate="+startdate+";enddate="+enddate+";startperiod="+startperiod+";endperiod="+endperiod+";startcode="+startcode+";endcode="+endcode+";username="+username+";year="+year+")}";
	DHCCPM_RQDirectPrint(fileName);

    }
});

var searchPanel = new Ext.form.FormPanel({
			id : 'searchPanel',
			width : 500,
			height : 90,
			region : 'north',
			frame : true,

			defaults : {
			bodyStyle : 'padding:5px'
			},
			items : [{
						xtype: 'panel',
						layout:"column",
						items: [{
								xtype:'displayfield',
								value:'<center><p style="font-weight:bold;font-size:180%">'+'现金流量表查询'+'</p></center>',
								columnWidth:1,
								height:'50'
								}]
	   				},{
		   				//columnWidth : 1,
		   				xtype: 'panel',
						layout:'column',
						items:[{
								xtype : 'displayfield',
								value : '按日查询：',
								columnWidth : .08
							},{
                                columnWidth:.1,
								items:startDateField,
                                allowBlank: false,
            					type: "dateField",
            					dataIndex: 'startdate',
            					dateFormat: 'Y-m-d'
            
        					},{
								xtype : 'displayfield',
								value : '',
								columnWidth : .01
							},{
                                columnWidth:.15,
								items:endDateField,
                                allowBlank: false,
            					type: "dateField",
            					dataIndex: 'enddate',
            					dateFormat: 'Y-m-d'
							},{
								xtype : 'displayfield',
								value : '现金流量项：',
								columnWidth : .08
							},{
                                columnWidth:.1,
								items:startCodeField,
                                //allowBlank: false,
            					type: "TextField",
            					dataIndex: 'startCode'
            
        					},{
								xtype : 'displayfield',
								value : '',
								columnWidth : .02
							},{
                                columnWidth:.15,
								items:endCodeField,
                                //allowBlank: false,
            					type: "TextField",
            					dataIndex: 'endCode'
            					
            
        					},{
							  	  columnWidth:.05,
								  items:findBT						  
							},{
								   columnWidth:.05,
								   items:printBT
								}]
					},{
						layout:'column',
						items:[{
								xtype : 'displayfield',
								value : '按月查询：',
								columnWidth : .08
							},{
                                columnWidth:.1,
								items:startPeriodField,
                                allowBlank: false,
            					type: "dateField",
            					dataIndex: 'startperiod',
            					dateFormat: 'Y-m'
            
        					},{
								xtype : 'displayfield',
								value : '',
								columnWidth : .01
							},{
                                columnWidth:.1,
								items:endPeriodField,
                                allowBlank: false,
            					type: "dateField",
            					dataIndex: 'endperiod',
            					dateFormat: 'Y-m'
							}]
						}
					]
});

var reportPanel=new Ext.Panel({
			autoScroll:true,
			frame:true,
			html:'<iframe id="reportFrame" height="100%" width="100%" src="../scripts/dhcmed/img/logon_bg2.jpg"/>'
});

function ShowReport()
{
	
	var reportframe=document.getElementById("reportFrame");
	
	var startdate  =startDateField.getValue();
	var enddate    =endDateField.getValue();
	var startperiod=startPeriodField.getValue();
	var endperiod  =endPeriodField.getValue();
	var startcode  =startCodeField.getValue();
	var endcode    =endCodeField.getValue();
	var year=""
	if(startdate!="")    {  startdate  =startdate.format('Y-m-d');var year=startdate.substring(0,4);}
	if(enddate!="")      {  enddate  =enddate.format('Y-m-d');var year=enddate.substring(0,4);}
	if(startperiod!="")  {  startperiod  =startperiod.format('Y-m');var year=startperiod.substring(0,4);}
	if(endperiod!="")    {  endperiod  =endperiod.format('Y-m');var year=endperiod.substring(0,4);}
	
	//alert(startdate+"^"+enddate+"^"+startperiod+"^"+endperiod+"^"+startcode+"^"+endcode+"^"+username)		
	var p_URL = 'dhccpmrunqianreport.csp?reportName=HERPBUDGFundItemMngReq.raq&startdate='+startdate+'&enddate='+enddate+'&startperiod='+startperiod+'&endperiod='+endperiod+'&startcode='+startcode+'&endcode='+endcode+'&username='+username+'&year='+year+''; 
	
	reportframe.src=p_URL;
	
}