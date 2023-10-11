var HOSPID = session['LOGON.HOSPID'];
var userdr = session['LOGON.USERID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';

/////////////////////////////////////// 年度 /////////////////////////////////////////
var yearDs  = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});
yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:commonboxUrl+'?action=year&flag=',method:'POST'})
});
var yearFieldCom  = new Ext.form.ComboBox({
	id: 'yearFieldCom',
	fieldLabel: '会计年度',
	width : 100,
	listWidth : 220,
	store: yearDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'yearFieldCom',
	minChars: 1,
	pageSize: 10,
	columnWidth : .1,
	//selectOnFocus:true,
	//forceSelection:'true',
	listeners:{
            "select":function(combo,record,index){
	            ItemDictDs.removeAll();     
				ItemDictCombo.setValue('');
				ItemDictDs.proxy = new Ext.data.HttpProxy({url:commonboxUrl+'?action=item&flag=&year='+combo.value,method:'POST'})  
				ItemDictDs.load({params:{start:0,limit:10}});      					
			}
	}	
});

// ////////////////////预算编码////////////////
var ItemDictDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'codename'])
		});

ItemDictDs.on('beforeload', function(ds, o) {

			var year=yearFieldCom.getValue();	
	if(!year){
		Ext.Msg.show({title:'注意',msg:'请先选择会计年度',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
		});

var ItemDictCombo = new Ext.form.ComboBox({
			fieldLabel : '科目编码',
			store : ItemDictDs,
			displayField : 'codename',
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
					
					var year=yearFieldCom.getValue();
					
					if(year==""){
						Ext.Msg.show({title:'提示',msg:'年度不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:160});
						return false;
					}
					//alert(type)
					
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
	
	
	var year=yearFieldCom.getValue();
	var itemInfo=ItemDictCombo.getValue();
	if(year==""){
						Ext.Msg.show({title:'提示',msg:'年月不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:160});
						return false;
	}

	fileName="{HERPBUDGBudgAdjustInfoReqPrint.raq(year="+year+";itemInfo="+itemInfo+";HOSPID="+HOSPID+";userdr="+userdr+")}";
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
			height : 60,
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
								value:'<center><p style="font-weight:bold;font-size:180%">'+'全院预算调整查询'+'</p></center>',
								columnWidth:1,
								height:'40'
								}]
	   				},{
		   				//columnWidth : 1,
		   				xtype: 'panel',
						layout:'column',
						items:[{
								xtype : 'displayfield',
								value : '年度：',
								columnWidth : .08
							 }, yearFieldCom,
							 {
								xtype : 'displayfield',
								value : '',
								columnWidth : .07
							},{
								xtype : 'displayfield',
								value : '科目编码：',
								columnWidth : .08
							 }, ItemDictCombo,
							 {
								xtype : 'displayfield',
								value : '',
								columnWidth : .06
							},{
							  	  columnWidth:.06,
								  items:findBT						  
							  },{
							  	  columnWidth:.08,
								  items:printBT						  
						}]
					}]
});

function ShowReport()
{
	
	var reportframe=document.getElementById("reportFrame");
	
	var year=yearFieldCom.getValue();
	var itemInfo=ItemDictCombo.getValue();
	if (year=="") { year=0;}	
	//alert(year)encodeURIComponent(itemInfo)
	var p_URL = 'dhccpmrunqianreport.csp?reportName=HERPBUDGBudgAdjustInfoReq.raq&year='+year+'&itemInfo='+itemInfo+'&HOSPID='+HOSPID+'&userdr='+userdr+''; 
	//alert(itemInfo);
	//alert(p_URL);
	reportframe.src=p_URL;
	
}



