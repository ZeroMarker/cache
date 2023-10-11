
var userdr = session['LOGON.USERID'];
var username = session['LOGON.USERNAME'];
var id = session['LOGON.HOSPID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var URL='herp.budg.budgctrldeptpaybudgreqexe.csp'
//alert(userdr+"^"+username)
/////////////////////////////////////// 执行年月 /////////////////////////////////////////

var startPeriodField= new Ext.form.DateField({
	format:'Y-m',
	emptyText:'开始年月...',
	columnWidth:1
});
var endPeriodField= new Ext.form.DateField({
	format:'Y-m',
	emptyText:'结束年月...',
	columnWidth:1
});

// ////////////////////预算项类别////////////////
var SchTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

SchTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=itemtype&flag=1',
						method : 'POST'
					});
		});

var SchTypeCombo = new Ext.form.ComboBox({
			fieldLabel : '科目类别',
			store : SchTypeDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 120,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			//columnWidth : .13,
			selectOnFocus : true
		});


///////////////报销科室////////////////////////
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=dept&flag=1',
						method : 'POST'
					});
		});

var deptCombo = new Ext.form.ComboBox({
			fieldLabel : '预算科室',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 120,
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			//columnWidth : .1,
			selectOnFocus : true
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
					
					var year1=startPeriodField.getValue();
					var year2  =endPeriodField.getValue();
					var itemtype=SchTypeCombo.getValue();
					
					if(year1==""||year2==""){
						Ext.Msg.show({title:'提示',msg:'年月不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:160});
						return false;
					}
					//alert(type)
					if(itemtype==""){
						Ext.Msg.show({title:'提示',msg:'科目类别不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:160});
						return false;
					}
					
					ShowReport();
				}
});


///////打印按钮/////////////////////////
var printBT = new Ext.Toolbar.Button({
	id : "printBT",
    text : '<font color=blue>打印</font>',
	tooltip : '点击科室报销执行查询',
	width : 50,
	iconCls : 'print',
	handler : function() {
	
	
	var year1=startPeriodField.getValue();
	var year2  =endPeriodField.getValue();
	var itemtype=SchTypeCombo.getValue();
	var deptcode=deptCombo.getValue();
	if(year1==""||year2==""){
						Ext.Msg.show({title:'提示',msg:'年月不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:160});
						return false;
	}
	if(itemtype==""){
						Ext.Msg.show({title:'提示',msg:'科目类别不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:160});
						return false;
					}
	if(year1!="") {year1  =year1.format('Y-m');}
	if(year2!="") {year2  =year2.format('Y-m');}
	//alert(year1+"^"+year2)
	fileName="{HERPBUDGBudgCtrlDeptPayBudgReqprint.raq(year1="+year1+";year2="+year2+";itemtype="+itemtype+";dept="+deptcode+";username="+username+")}";
	DHCCPM_RQDirectPrint(fileName);

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
			height : 70,
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
								value:'<center><p style="font-weight:bold;font-size:180%">'+'科室执行情况查询'+'</p></center>',
								columnWidth:1,
								height:'50'
								}]
	   				},{
		   				//columnWidth : 1,
		   				xtype: 'panel',
						layout:'column',
						items:[{
								xtype : 'displayfield',
								value : '执行期间：',
								columnWidth : .08
							 }, 
							 {
								columnWidth : .14,
								items:startPeriodField,
								allowBlank: false,
								type: "dateField",
            					dataIndex: 'year1',
            					dateFormat: 'Y-m'	
								
							},{
								xtype : 'displayfield',
								value : '',
								columnWidth : .01
							},
							 {
                                columnWidth:.17,
								items:endPeriodField,
                                allowBlank: false,
            					type: "dateField",
            					dataIndex: 'year2',
            					dateFormat: 'Y-m'
							},{
								xtype : 'displayfield',
								value : '科目类别：',
								columnWidth : .08
							 }, SchTypeCombo,
							 {
								xtype : 'displayfield',
								value : '',
								columnWidth : .07
							},{
								xtype : 'displayfield',
								value : '预算科室：',
								columnWidth : .08
							 }, deptCombo,
							 {
								xtype : 'displayfield',
								value : '',
								columnWidth : .06
							},{
							  	  columnWidth:.1,
								  items:findBT						  
							  },{
							  	  columnWidth:.1,
								  items:printBT						  
						}]
					}]
});

function ShowReport()
{
	
	var reportframe=document.getElementById("reportFrame");
	
	var year1=startPeriodField.getValue();
	var year2  =endPeriodField.getValue();
	var itemtype=SchTypeCombo.getValue();
	var deptcode=deptCombo.getValue();
	if(year1!="") {year1  =year1.format('Y-m');}
	if(year2!="") {year2  =year2.format('Y-m');}			
	
	//alert(year1+"^"+year2+"^"+type+"^"+deptcode+"^"+username)		
	var p_URL = 'dhccpmrunqianreport.csp?reportName=HERPBUDGBudgCtrlDeptPayBudgReq.raq&year1='+year1+'&year2='+year2+'&itemtype='+itemtype+'&dept='+deptcode+'&username='+username+''; 
	
	reportframe.src=p_URL;
	
}



