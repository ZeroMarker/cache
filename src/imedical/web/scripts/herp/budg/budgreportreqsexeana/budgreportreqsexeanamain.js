
var userdr = session['LOGON.USERID'];
var username = session['LOGON.USERNAME'];

var URL='herp.budg.budgreportreqsexeanaexe.csp'
var ComBoxURL='herp.budg.budgcommoncomboxexe.csp';

/////////////////////////////////////// 预算年度 /////////////////////////////////////////
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});
YearDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : ComBoxURL+'?action=year&flag=',
						method : 'POST'
					});
		});
		

var YearComb = new Ext.form.ComboBox({
			id:'YearComb',
			fieldLabel : '预算年度',
			store : YearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 145,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			//columnWidth : .1,
			selectOnFocus : true,
			listeners:{
            	select:{fn:function(combo,record,index) { 
                	schemDs.removeAll();
                	schemField.setValue('');     				
                    schemDs.load({params:{start:0,limit:10,year:combo.value,flag:1}});
            	}}
         	}
});

YearComb.setValue(new Date().getFullYear());


///////////////////////预算项类别///////////////////////////////////////////////////////////

var ItemTypeDs = new Ext.data.Store({

	url : ComBoxURL+'?action=itemtype&flag=1&start=0&limit=10&str=',
	autoLoad : true,  
	fields: ['rowid','code','name'],
	reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid','name'])
					
});
 
		
var ItemTyCombo = new Ext.form.ComboBox({
			id:'test',
			fieldLabel : '科目类别',
			mode:'remote',
			store : ItemTypeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 120,
			listWidth : 230,
			pageSize : 2,
			minChars : 1,
			columnWidth : .13,
			selectOnFocus : true
		});
			
//ItemTypeDs.load();		
ItemTypeDs.on("load", function(){
	
	var Num=ItemTypeDs.getCount();
    if (Num!=0){
        var id=ItemTypeDs.getAt(0).get('rowid');
	    ItemTyCombo.setValue(id); 
    } 

});
		
///////////////////////////科目级次////////////////
var levelDs = new Ext.data.Store({
	
			url : ComBoxURL+'?action=itemlev&start=0&limit=10&str=',
			autoLoad : true,  
			fields: ['level','level'],
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['level', 'level'])
		});
		


var levelCombo = new Ext.form.ComboBox({
			fieldLabel : '科目级次',
			store : levelDs,
			displayField : 'level',
			valueField : 'level',
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

levelDs.on("load", function(){
	var Num=levelDs.getCount();
    if (Num!=0){
	    var id=levelDs.getAt(0).get('level');
	    levelCombo.setValue(id);  
    } 

});

///////////////////////预算总额///////////////////////////////////////////////////////////
var ChangeFlagStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '期初预算'], ['2', '调整后预算']]
		});
var ChangeFlagField = new Ext.form.ComboBox({
			id : 'ChangeFlagField',
			fieldLabel : '预算总额',
			width : 120,
			listWidth : 230,
			selectOnFocus : true,
			allowBlank : false,
			store : ChangeFlagStore,
			//anchor : '90%',
			value:'1', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '请选择...',
			mode : 'local', // 本地模式
			editable : false,
			pageSize : 10,
			minChars : 1,
			//columnWidth : .12,
			selectOnFocus : true,
			forceSelection : true          

});	

/////////////////////////////////////// 预算方案 /////////////////////////////////////////

var schemDs = new Ext.data.Store({

	//url : ComBoxURL+'?action=bsm&flag=1&year='+YearComb.getValue()+'&start=0&limit=10&str=',
	autoLoad : true,  
	fields: ['rowid','name'],
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])

});


var schemField = new Ext.form.ComboBox({
	id: 'schemField',
	name: 'schemField',
	fieldLabel: '方案名称',
	width:145,
	listWidth : 245,
	//allowBlank: false,
	store: schemDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择...',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

schemDs.on('beforeload', function(ds, o) {
    var year=YearComb.getValue();
	if(!year){
		Ext.Msg.show({title:'注意',msg:'请先选择预算年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		ds.proxy = new Ext.data.HttpProxy({
						url : ComBoxURL+'?action=bsm&flag=1&year=&start=0&limit=10&str=',
						method : 'POST'
		});
		schemField.setValue('');  
		return ;
	}else{
			ds.proxy = new Ext.data.HttpProxy({
						url : ComBoxURL+'?action=bsm&flag=1&year='+YearComb.getValue()+'&start=0&limit=10&str=',
						method : 'POST'
					});
	}
});

schemDs.on("load", function(){
	var Num=schemDs.getCount();
    if (Num!=0){
	var id=schemDs.getAt(0).get('rowid');
		schemField.setValue(id);  
    } 

});

///////////////预算科室////////////////////////
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : ComBoxURL+'?action=dept&flag=1',
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
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});


//////////////////////预算科目////////////////
var itemDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code', 'name'])
		});

itemDs.on('beforeload', function(ds, o) {
			
			var year=YearComb.getValue();
			if (year!==""){
				var year=YearComb.getValue();
			}else{
				Ext.Msg.show({title:'提示',msg:'年度不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:160});
				return false;
			}
			ds.proxy = new Ext.data.HttpProxy({
						url : ComBoxURL+'?action=item'+'&flag='+'&year='+year+'&type='+'&level='+'&supercode=',
						method : 'POST'
					});
		});

var itemCombo = new Ext.form.ComboBox({
			fieldLabel : '预算科目',
			store : itemDs,
			displayField : 'name',
			valueField : 'code',
			//typeAhead : true,
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
				id : 'findBT',
				text : '<font color=blue>查询</font>',
				tooltip : '查询',
				width : 110,
				height : 30,
				iconCls : 'find',
				handler : function() {
										
					ShowReport();
				}
});


////////////// 打印按钮 /////////////////
var printBT = new Ext.Toolbar.Button({
				id : 'printBT',
				text : '<font color=blue>打印</font>',
				iconCls : 'print',
				tooltip : '打印（无背景颜色）',
				width : 110,
				height : 30,
				handler : function() {
					
					var year=YearComb.getValue();
					var itemType=ItemTyCombo.getValue();
					var itemLevel=levelCombo.getValue();
					var budgAll=ChangeFlagField.getValue();
					var schemeMainDr=schemField.getValue();
						
					//ShowPrintReportFun(year,itemType,itemLevel,budgAll,schemeMainDr);
					fileName="{HERPBUDGHosBudgExeAnaprint.raq(year="+year+";itemType="+itemType+";itemLevel="+itemLevel+";budgAll="+budgAll+";reportType="+";dept=-1"+";itemCode="+";schemeMainDr="+schemeMainDr+";USERNAME="+username+")}";
					DHCCPM_RQDirectPrint(fileName);
				}
});



//参照物资设备组
var searchPanel = new Ext.form.FormPanel({
			id : 'searchPanel',
			labelWidth : 60,
			labelAlign : 'left',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:5px 0px 0px 0px;',
			tbar : [findBT,'-',printBT],
			items : [{
						xtype : 'fieldset',
						title : '查询条件',
						style:'padding 0px 0px 0px 5px',
						layout: 'column',					
						items : [{
							columnWidth: 0.25,
							layout:'form',
							items: [YearComb,schemField]
						},{
							columnWidth: 0.25,
							layout:'form',
							items: [ItemTyCombo,levelCombo]
						},{
							columnWidth: 0.25,
							layout:'form',
							items: [ChangeFlagField]
						}]
			}]
});



function ShowReport()
{
	
	var reportframe=document.getElementById("reportFrame");
	
	var year=YearComb.getValue();
	var itemType=ItemTyCombo.getValue();
	var itemLevel=levelCombo.getValue();
	var budgAll=ChangeFlagField.getValue();
	var schemeMainDr=schemField.getValue();

	///alert(year)		
	//alert(year+"^"+type+"^"+level+"^"+deptdr+"^"+itemcode)		
	var p_URL = 'dhccpmrunqianreport.csp?reportName=HERPBUDGHosBudgExeAna.raq&year='+year+'&itemType='+itemType+'&itemLevel='+itemLevel+'&budgAll='+budgAll+'&reportType='+'&dept=-1'+'&itemCode='+'&schemeMainDr='+schemeMainDr; 
	
	reportframe.src=p_URL;
	
}



