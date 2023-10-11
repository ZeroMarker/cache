
var userdr = session['LOGON.USERID'];
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
						url : 'herp.budg.budgcommoncomboxexe.csp?action=year',
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
			///value: new Date().getFullYear(),
			width : 120,
			listWidth : 230,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true,
			listeners:{
            	select:{fn:function(combo,record,index) { 
                	schemDs.removeAll();
                	schemField.setValue('');     				
                  schemDs.load({params:{start:0,limit:10,year:combo.value,flag:2}});
            	}}
         	}
});
YearComb.setValue(new Date().getFullYear());     

///////////////////////科目类别///////////////////////////////////////////////////////////

var ItemTypeDs = new Ext.data.Store({

	url : 'herp.budg.budgcommoncomboxexe.csp?action=itemtype&flag=1&start=0&limit=10&str=',
	autoLoad : true,  
	fields: ['rowid','code','name'],
	reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['code','name'])
					
});
 
		
var ItemTyCombo = new Ext.form.ComboBox({
			id:'test',
			fieldLabel : '科目类别',
			mode:'remote',
			store : ItemTypeDs,
			displayField : 'name',
			valueField : 'code',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 120,
			listWidth : 230,
			pageSize : 3,
			minChars : 1,
			columnWidth : .13,
			selectOnFocus : true
		});
			
//ItemTypeDs.load();		
ItemTypeDs.on("load", function(){
	
	var Num=ItemTypeDs.getCount();
    if (Num!=0){
        var id=ItemTypeDs.getAt(0).get('code');
	    ItemTyCombo.setValue(id); 
    } 

});

///////////////////////////科目级次////////////////
var levelDs = new Ext.data.Store({
			url : 'herp.budg.budgcommoncomboxexe.csp?action=itemlev&start=0&limit=10&str=',
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
///////////////////////////科室名称////////////////
var deptDs = new Ext.data.Store({
			url : 'herp.budg.budgcommoncomboxexe.csp?action=dept&start=0&limit=10&str=',
			autoLoad : true,  
			fields: ['rowid', 'name'],
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		


var deptCombo = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
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
			//columnWidth : .13,
			selectOnFocus : true
});	

deptDs.on("load", function(){
	var Num=deptDs.getCount();
      if (Num!=0){
	    var id=deptDs.getAt(0).get('rowid');
	    deptCombo.setValue(id);  
    } 

});


/////////////////////////////////////// 预算方案 /////////////////////////////////////////

var schemDs = new Ext.data.Store({
	proxy:"",
	url : 'herp.budg.budgcommoncomboxexe.csp?action=bsm&flag=2&start=0&limit=10&str=',
	autoLoad : true,  
	fields: ['rowid','name'],
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

var schemField = new Ext.form.ComboBox({
	id: 'schemField',
	name: 'schemField',
	fieldLabel: '方案名称',
	width:120,
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
						url : 'herp.budg.budgcommoncomboxexe.csp?action=bsm&flag=2&year=&start=0&limit=10&str=',
						method : 'POST'
		});
		schemField.setValue('');  
		return ;
	}else{
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgcommoncomboxexe.csp?action=bsm&flag=2&year='+YearComb.getValue()+'&start=0&limit=10&str=',
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


		
/*/预算方案
var BSMnameDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader(
	{totalProperty:'results',root:'rows'},['rowid','name']
	
	)
});

BSMnameDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url: 'herp.budg.budgcommoncomboxexe.csp'+'?action=bsm&year='+YearComb.value+'&userdr='+userdr+'&flag=2',method:'POST'})
		});
		

var BSMnameField = new Ext.form.ComboBox({
	id: 'BSMnameField',
	fieldLabel: '方案名称',
	width:120,
	listWidth : 230,
	store: BSMnameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择...',
	///value:'rowid',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',	
	editable:true
 }); 
*/


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

					ShowReport();
				}
});

/*////////////// 打印按钮 /////////////////
var printBT = new Ext.Toolbar.Button({
				id : "printBT",
				text : '<font color=blue>打印</font>',
				tooltip : '打印（无背景颜色）',
				width : 50,
				handler : function() {
					var year=YearComb.getValue();
					var type=SchTypeCombo.getValue();
					var level=levelCombo.getValue();
					var chageflag=ChangeFlagField.getValue();
					var deptdr=deptCombo.getValue();
					var schemdr=BSMnameField.getValue();

					ShowPrintReportFun(year,type,level,chageflag,deptdr,schemdr);
				}
});*/

////////////// 打印按钮 /////////////////
var printBT = new Ext.Toolbar.Button({
				id : "printBT",
				text : '<font color=blue>打印</font>',
				tooltip : '打印（无背景颜色）',
				width : 50,
	                 
	                  iconCls : 'print',
	                  handler : function() {
		                  var year=YearComb.getValue();
	                        var type=ItemTyCombo.getValue();
	                        var level=levelCombo.getValue();
	                        var chageflag=ChangeFlagField.getValue();
	                        var deptdr=deptCombo.getValue();
	                        var schemdr=schemField.getValue();
					///alert(year+"^"+type+"^"+level+"^"+chageflag+"^"+deptdr+"^"+schemdr);
					fileName="{HERPBUDGHosInOutBudgReq2print.raq(year="+year+";itemType="+type+";itemLevel="+level+";budgAll="+chageflag+";dept="+deptdr+";schemeMainDr="+schemdr+")}";
	                        ///alert(year+"^"+type+"^"+level+"^"+chageflag+"^"+deptdr+"^"+schemdr);
	                        DHCCPM_RQDirectPrint(fileName);
	                        
				}
});



var searchPanel = new Ext.form.FormPanel({
			id : 'searchPanel',
			width : 650,
			labelWidth : 80,
			labelAlign : 'left',
			frame : true,
			bodyStyle : 'padding:5px;',
			layout : "form",
			items : [{
						xtype: 'panel',
						layout:"column",
						items: [{
								xtype:'displayfield',
								value:'<center><p style="font-weight:bold;font-size:180%">'+'科室收支预算查询'+'</p></center>',
								columnWidth:1,
								height:'50'
								}]
	   				},{
						layout:'column',
						items:[{
								  columnWidth:.2,
								  layout:'form',
								  labelWidth : 80,
								  items:YearComb
							  },{
								layout:'form',
								columnWidth:.02
							  },{
								  columnWidth:.2,
								  layout:'form',
								  labelWidth : 80,
								  items:ItemTyCombo
							  },{
								layout:'form',
								columnWidth:.02
							  },{
								  columnWidth:.2,
								  layout:'form',
								  labelWidth : 80,
								  items:levelCombo
							  },{
								layout:'form',
								columnWidth:.02
							  }]
					},{
						layout:'column',
						items:[{
								  columnWidth:.2,
								  layout:'form',
								  labelWidth : 80,
								  items:ChangeFlagField
							  },{
								layout:'form',
								columnWidth:.02
							  },{
								  columnWidth:.2,
								  layout:'form',
								  labelWidth : 80,
								  items:deptCombo
							  },{
								layout:'form',
								columnWidth:.02
							  },{
								  columnWidth:.2,
								  layout:'form',
								  labelWidth : 80,
								  items:schemField
								  
							  },{
								layout:'form',
								columnWidth:.02
							  },{
							  	  columnWidth:.05,
								  layout:'form',
								  items:findBT						  
							  },{
								layout:'form',
								columnWidth:.01
							  },{
							  	  columnWidth:.05,
								  layout:'form',
								  items:printBT						  
						}]							  
					}]
});

function ShowReport()
{
	var reportframe=document.getElementById("reportFrame");
	
	var year=YearComb.getValue();
	var type=ItemTyCombo.getValue();
	var level=levelCombo.getValue();
	var chageflag=ChangeFlagField.getValue();
	var deptdr=deptCombo.getValue();
	var schemdr=schemField.getValue();
	
	///alert(year+"^"+type+"^"+level+"^"+chageflag+"^"+deptdr+"^"+schemdr);			
	var p_URL = 'dhccpmrunqianreport.csp?reportName=HERPBUDGHosInOutBudgReq2.raq&year='+year+'&itemType='+type+'&itemLevel='+level+'&budgAll='+chageflag+'&dept='+deptdr+'&schemeMainDr='+schemdr; 
	
	reportframe.src=p_URL;
}



