
var userdr = session['LOGON.USERID'];
var username = session['LOGON.USERNAME'];

var URL='herp.budg.budgreportreqssumexeanaexe.csp'
var ComBoxURL='herp.budg.budgcommoncomboxexe.csp';

/////////////////////////////////////// 预算期 /////////////////////////////////////////
var YearMonthS = new Ext.form.DateField({
    id:'YearMonthS',
    fieldLabel: '预算期间',
    name : 'YEAR_MONTH',
    format : 'Y-m',
    editable : false,
    allowBlank : false,
    emptyText:'请选择年月...',
    width: 145,
    widthlist: 250,
    maxValue : new Date(),
    value: new Date(),
    plugins: 'monthPickerPlugin',
    listeners : {
        scope : this,
        'select' : function(dft){
        	schemDs.removeAll(); 
            schemField.setValue('');     				
            schemDs.load({params:{start:0,limit:10,year:YearMonthS.getValue().format('Y-m').substr(0,4),flag:1}});                     
        }
    }
});

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

///////////////////////本期执行进度开始值///////////////////////////////////////////////////////////
var CurRealExeS=new Ext.form.NumberField({  		
                fieldLabel:'本期执行进度下限%', 
                width:60, 
                decimalPrecision:2,                //精确到小数点后2位(执行4舍5入)   
                allowDecimals:true,                //允许输入小数   
                nanText:'请输入有效小数',  
                emptyText:'百分比...',
                allowNegative:false  
})

///////////////////////本期执行进度结束值///////////////////////////////////////////////////////////
var CurRealExeE=new Ext.form.NumberField({ 
                fieldLabel:'本期执行进度上限%',
                width:60, 
                decimalPrecision:2,                //精确到小数点后2位(执行4舍5入)   
                allowDecimals:true,                //允许输入小数   
                nanText:'请输入有效小数',  
                emptyText:'百分比...',
                allowNegative:false  	
})


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

schemDs.on('beforeload', function(ds, o){
	
    var year=YearMonthS.getValue();	

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
			url : ComBoxURL+'?action=bsm&flag=1&year='+YearMonthS.getValue().format('Y-m').substr(0,4)+'&start=0&limit=10&str=',
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
					var yearmonth=YearMonthS.getValue()
					var schemeMainDr=schemField.getValue();
					if(yearmonth!=""){
						var yearmonth=YearMonthS.getValue().format('Y-m');
					}else{
						Ext.Msg.show({title:'注意',msg:'请选择预算期间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return ;
					}
					if(schemeMainDr==""){
						Ext.Msg.show({title:'注意',msg:'请选择方案名称!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return ;
					}
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
					
					var yearmonth=YearMonthS.getValue()
					var schemeMainDr=schemField.getValue();
					if(yearmonth!=""){
						var yearmonth=YearMonthS.getValue().format('Y-m');
					}else{
						Ext.Msg.show({title:'注意',msg:'请选择预算期间!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return ;
					}
					if(schemeMainDr==""){
						Ext.Msg.show({title:'注意',msg:'请选择方案名称!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return ;
					}
					var itemType=ItemTyCombo.getValue();
					var itemLevel=levelCombo.getValue();
					var minExcuteRate=CurRealExeS.getValue();
					var maxExcuteRate=CurRealExeE.getValue();
					
					
					if (minExcuteRate!="" && maxExcuteRate!="" && minExcuteRate>maxExcuteRate){
						Ext.Msg.show({title:'注意',msg:'本期执行进度下限不能大于上限!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return ;
					}
					//ShowPrintReportFun(year,itemType,itemLevel,schemeMainDr);
					fileName="{HERPBUDGHosBudgAddExeAnaprint.raq(yearmonth="+yearmonth+";schemeMainDr="+schemeMainDr+";dept=-1"+";itemType="+itemType+'&itemCode='+";itemLevel="+itemLevel+";reportType="+";minExcuteRate="+minExcuteRate+";maxExcuteRate="+maxExcuteRate+";USERNAME="+username+")}";
					
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
							items: [YearMonthS,schemField]
						},{
							columnWidth: 0.25,
							layout:'form',
							items: [ItemTyCombo,levelCombo]
						},{
							columnWidth: 0.25,
							layout:'form',
							labelWidth : 120,
							items: [CurRealExeS,CurRealExeE]
						}]
			}]
});



function ShowReport()
{
	
	var reportframe=document.getElementById("reportFrame");
	
	var yearmonth=YearMonthS.getValue()
	if(yearmonth!=""){
		var yearmonth=YearMonthS.getValue().format('Y-m');
	}
	var schemeMainDr=schemField.getValue();
	var itemType=ItemTyCombo.getValue();
	var itemLevel=levelCombo.getValue();
	var minExcuteRate=CurRealExeS.getValue();
	var maxExcuteRate=CurRealExeE.getValue();
					
					
	if (minExcuteRate!="" && maxExcuteRate!="" && minExcuteRate>maxExcuteRate){
		Ext.Msg.show({title:'注意',msg:'本期执行进度下限不能大于上限!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
	var p_URL = 'dhccpmrunqianreport.csp?reportName=HERPBUDGHosBudgAddExeAna.raq&yearmonth='+yearmonth+'&schemeMainDr='+schemeMainDr+'&dept=-1'+'&itemType='+itemType+'&itemLevel='+itemLevel+'&itemCode='+'&periodType='+"&minExcuteRate="+minExcuteRate+"&maxExcuteRate="+maxExcuteRate; 
	
	reportframe.src=p_URL;
	
}



