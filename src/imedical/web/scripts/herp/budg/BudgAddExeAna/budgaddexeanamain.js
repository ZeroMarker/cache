
var userdr = session['LOGON.USERID'];
var username = session['LOGON.USERNAME'];

var URL='herp.budg.budgcommoncomboxexe.csp'
var YearMonth = new Ext.form.DateField({
    id:'YearMonth',
    fieldLabel: '预算时间',
    name : 'YEAR_MONTH',
    format : 'Y-m',
    editable : false,
    allowBlank : false,
    emptyText:'请选择年月...',
    width: 120,
    widthlist: 250,
    /*maxValue : new Date(),
    plugins: 'monthPickerPlugin', }
    listeners :{
        scope :this,
        'select':function(dft){
        	bsmnameDs.removeAll();     				
            bsmnameDs.load({params:{start:0,limit:10,year:YearMonth.getValue().format('Y-m').substr(0,4),flag:1}});                     
        }
    }*/
    listeners:{
            	select:{fn:function(combo,record,index) { 
                	bsmnameDs.removeAll();     				
                    bsmnameDs.proxy= new Ext.data.HttpProxy({url : URL+'?action=bsm&year='+YearMonth.getValue().format('Y-m').substr(0,4)+'&flag=2',method : 'POST'});      
                    bsmnameDs.load({params:{start:0,limit:10}});                     
            	}}
         	}
});

var YearMonth2 = new Ext.form.DateField({
    id:'YearMonth2',
    fieldLabel: '预算时间',
    name : 'YEAR_MONTH2',
    format : 'Y-m',
    editable : false,
    allowBlank : false,
    emptyText:'请选择年月...',
    width: 120,
    widthlist: 250,
    /*maxValue : new Date(),
    plugins: 'monthPickerPlugin', }
    listeners :{
        scope :this,
        'select':function(dft){
        	bsmnameDs.removeAll();     				
            bsmnameDs.load({params:{start:0,limit:10,year:YearMonth.getValue().format('Y-m').substr(0,4),flag:1}});                     
        }
    }*/
    listeners:{
            	select:{fn:function(combo,record,index) { 
                	bsmnameDs.removeAll();     				
                    bsmnameDs.proxy= new Ext.data.HttpProxy({url : URL+'?action=bsm&year='+YearMonth2.getValue().format('Y-m').substr(0,4)+'&flag=2',method : 'POST'});      
                    bsmnameDs.load({params:{start:0,limit:10}});                     
            	}}
         	}
});

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
var Name1Field = new Ext.form.TextField({
	fieldLabel: '本期执行进度>',
	width:120,
	emptyText:'请输入整数',
	name: 'unituserField',
	selectOnFocus:true,
	editable:true
});
var Name2Field = new Ext.form.TextField({
	fieldLabel: '%并且<',
	width:120,
	emptyText:'请输入整数',
	name: 'unituserField',
	selectOnFocus:true,
	editable:true
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
	
//////////////////////百分比////////////////
var CurRealExeS=new Ext.form.NumberField({  		
                fieldLabel:'', 
                width:60, 
                decimalPrecision:2,                //精确到小数点后2位(执行4舍5入)   
                allowDecimals:true,                //允许输入小数   
                nanText:'请输入有效小数',  
                emptyText:'百分比...',
                allowNegative:false  
})

///////////////////////本期执行进度结束值///////////////////////////////////////////////////////////
var CurRealExeE=new Ext.form.NumberField({ 
                fieldLabel:'< 本期执行进度 <',
                width:60, 
                decimalPrecision:2,                //精确到小数点后2位(执行4舍5入)   
                allowDecimals:true,                //允许输入小数   
                nanText:'请输入有效小数',  
                emptyText:'百分比...',
                allowNegative:false  	
})



var bsmnameDs = new Ext.data.Store({
	            autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name2'])
		});

bsmnameDs.on('beforeload', function(ds, o) {
			
			var year=YearMonth.getValue();
			var year=YearMonth2.getValue();
			///if (year!==""){
				///var year=YearMonth.getValue();
			///}else{
				///Ext.Msg.show({title:'提示',msg:'年度不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO,width:160});
				///return false;
			///}
			///var type=SchTypeCombo.getValue();
			ds.proxy = new Ext.data.HttpProxy({
						url : URL+'?action=bsm&year='+YearMonth.getValue().format('Y-m').substr(0,4)+'&flag=2',
						method : 'POST'
					});
		    ds.proxy = new Ext.data.HttpProxy({
						url : URL+'?action=bsm&year='+YearMonth2.getValue().format('Y-m').substr(0,4)+'&flag=2',
						method : 'POST'
					});
		});

var bsmnameCombo = new Ext.form.ComboBox({
	            id: 'bsmnameCombo',
			fieldLabel : '方案名称',
			store : bsmnameDs,
			displayField : 'name2',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 120,
			listWidth : 230,
			pageSize : 10,
		
			//columnWidth : .13,
			selectOnFocus : true,
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
					
					
					
					ShowReport();
				}
});

/*/////////////// 打印按钮 /////////////////
var printBT = new Ext.Toolbar.Button({
				id : "printBT",
				text : '<font color=blue>打印</font>',
				tooltip : '打印（无背景颜色）',
				width : 50,
				handler : function() {
					var year=YearMonth.getValue()
	                         if(year!=""){
		                  var year=YearMonth.getValue().format('Y-m');
	                       }
	                        var SchType=SchTypeCombo.getValue();
	                        var level=levelCombo.getValue();
	                        var deptcode=deptCombo.getValue();
	                        var bsmname=bsmnameCombo.getValue();
					ShowPrintReportFun(year,SchType,level,deptcode,bsmname);
				}
});
*/

///////////// 打印按钮 /////////////////
var printBT = new Ext.Toolbar.Button({
				id : "printBT",
				text : '<font color=blue>打印</font>',
				tooltip : '打印（无背景颜色）',
				width : 50,
	                 
	                  iconCls : 'print',
	                  handler : function() {
		                 var year=YearMonth.getValue()
	                         if(year!=""){
		                  var year=YearMonth.getValue().format('Y-m');
	                       }
	                        var SchType=ItemTyCombo.getValue();
	                        var level=levelCombo.getValue();
	                        var deptcode=deptCombo.getValue();
	                        var bsmname=bsmnameCombo.getValue();
	                        ///alert(year+"^"+SchType+"^"+level+"^"+deptcode+"^"+bsmname);
					filename="{HERPBUDGHosBudgAddExeAna2print.raq(year="+year+";itemType="+SchType+";itemLevel="+level+";dept="+deptcode+";schemeMainDr="+bsmname+")}";
	                        DHCCPM_RQDirectPrint(filename);
	                        ///alert(year+"^"+SchType+"^"+level+"^"+deptcode+"^"+bsmname);
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
			bodyStyle : 'padding:5px;',
			layout : "form",
			items : [{
						xtype: 'panel',
						layout:"column",
						items: [{
								xtype:'displayfield',
								value:'<center><p style="font-weight:bold;font-size:180%">'+'科室收支预算累计执行分析'+'</p></center>',
								columnWidth:1,
								height:'50'
								}]
	   				},{
						layout:'column',
						items:[{
								  columnWidth:.2,
								  layout:'form',
								  labelWidth : 80,
								  items:YearMonth
							  },{
								  columnWidth:.2,
								  layout:'form',
								  labelWidth : 80,
								  items:YearMonth2
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
								  items:deptCombo
							  },{
								layout:'form',
								columnWidth:.02
							  },{
								  columnWidth:.2,
								  layout:'form',
								  labelWidth : 80,
								  items:bsmnameCombo
							  },{
								layout:'form',
								columnWidth:.02
							  },{
							      columnWidth: 0.13,
							      layout:'form',
							      items:CurRealExeS
						        },{
							     columnWidth: 0.17,
							     labelWidth : 110,
							     layout:'form',
							     items: CurRealExeE
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
								  items:printBT}]
					}]
});

function ShowReport()
{
	
	var reportframe=document.getElementById("reportFrame");
	
	var year=YearMonth.getValue()
	var year1=YearMonth2.getValue()
	//alert(year);
	//alert(year1);
	if(year!=""&&year1!=""){
		var year3=YearMonth.getValue().format('Y-m');
		var year4=YearMonth2.getValue().format('Y-m');
		//alert(year3);
		//alert(year4);
	}
	var SchType=ItemTyCombo.getValue();
	var level=levelCombo.getValue();
	var deptcode=deptCombo.getValue();
	var bsmname=bsmnameCombo.getValue();

	//alert(year3+"^"+year4+"^"+SchType+"^"+level+"^"+deptcode+"^"+bsmname);		
	var p_URL = 'dhccpmrunqianreport.csp?reportName=HERPBUDGHosBudgAddExeAna2.raq&year='+year3+'&year2='+year4+'&itemType='+SchType+'&itemLevel='+level+'&dept='+deptcode+'&schemeMainDr='+bsmname; 
	
	reportframe.src=p_URL;
	
}



