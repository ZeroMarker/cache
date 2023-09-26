var userCode = session['LOGON.USERCODE'];
var periodStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue']
		});

var data = "";
var periodTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['M', '月份'], ['Q', '季度'], ['H', '半年'], ['Y', '年份']]
		});

var periodTypeField = new Ext.form.ComboBox({
			id : 'periodTypeField',
			fieldLabel : '期间类型',
			width : 80,
			listWidth : 60,
			allowBlank : false,
			store : periodTypeStore,
			anchor : '90%',
			value : '', // 默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			//minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
periodTypeField.on("select", function(cmb, rec, id) {
	if (cmb.getValue() == "M") {
		data = [['M01', '01月'], ['M02', '02月'], ['M03', '03月'], ['M04', '04月'],
				['M05', '05月'], ['M06', '06月'], ['M07', '07月'], ['M08', '08月'],
				['M09', '09月'], ['M10', '10月'], ['M11', '11月'], ['M12', '12月']];
	}
	if (cmb.getValue() == "Q") {
		data = [['Q01', '01季度'], ['Q02', '02季度'], ['Q03', '03季度'],
				['Q04', '04季度']];
	}
	if (cmb.getValue() == "H") {
		data = [['H01', '上半年'], ['H02', '下半年']];
	}
	if (cmb.getValue() == "Y") {
		data = [['Y00', '00']];
	}
	periodStore.loadData(data);

});

var periodField = new Ext.form.ComboBox({
			id : 'periodField',
			fieldLabel : '核算期间',
			width : 80,
			listWidth : 60,
			selectOnFocus : true,
			allowBlank : false,
			store : periodStore,
			anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			//minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

var cycleDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'BonusYear'])
		});

cycleDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'dhc.bonus.unitbonusdetaileditexe.csp?action=yearlist&topCount=5&orderby=Desc',
							method : 'POST'
						})
			});

var periodYear = new Ext.form.ComboBox({
			id : 'periodYear',
			fieldLabel : '核算年度',
			width : 80,
			listWidth : 60,
			selectOnFocus : true,
			allowBlank : false,
			store : cycleDs,
			anchor : '90%',
			value : '', // 默认值
			valueNotFoundText : '',
			displayField : 'BonusYear',
			valueField : 'BonusYear',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			//minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
periodYear.on("select", function(cmb, rec, id) {

			if (Ext.getCmp('periodField').getValue() != '')
				schemDs.load({
							params : {
								bonusYear : Ext.getCmp('periodYear').getValue(),
								bonusPeriod : Ext.getCmp('periodField')
										.getValue(),
								userCode : session['LOGON.USERCODE'],
								schemeType : p_SchemeType,
								start : 0,
								limit : schemPagingToolbar.pageSize
							}
						});
		});
//////////////奖金方案名称//////////////////
var BonusSchemeField = new Ext.form.TextField({
		id:'BonusScheme',
		name:'BonusScheme',
		fieldLabel:'奖金方案',
		width : 100,
		emptyText : '请输入编码或名称'
	});
/*
var schemeDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : 'results',
						root : 'rows'
					}, ['rowid', 'BonusScheme'])
		});

schemeDs.on('beforeload', function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({
							url : 'dhc.bonus.unitbonusdetaileditexe.csp?action=schemelist&topCount=5&orderby=Desc',
							method : 'POST'
						})
			});

var BonusSchemeField = new Ext.form.ComboBox({
			id : 'BonusScheme',
			name:'BonusScheme',
			fieldLabel:'奖金方案',
			width : 80,
			listWidth : 60,
			selectOnFocus : true,
			allowBlank : false,
			store : schemeDs,
			anchor : '90%',
			value : '', // 默认值
			valueNotFoundText : '',
			displayField : 'BonusScheme',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			//minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
*/

//////////////核算科室//////////////////
var BonusUnitField = new Ext.form.TextField({
		id:'BonusUnit',
		name:'BonusUnit',
		fieldLabel:'核算科室',
		width : 100,
		emptyText : '请输入编码或名称'
	});

//////////////奖金核算名称//////////////////
var SchemeItemField = new Ext.form.TextField({
		id:'SchemeItem',
		name:'SchemeItem',
		fieldLabel:'奖金核算',
		width : 100,
		emptyText : '请输入编码或名称'
	});
	
/////////////////////查询面板///////////////
var queryPanel = new Ext.FormPanel({
	height : 35,
	region : 'north',
	frame : true,
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '核算年度:',
				columnWidth : .1
				},periodYear,{
				xtype:'displayfield',
				value:'',
				columnWidth:.005
				},{
				xtype : 'displayfield',
				value : '期间类型:',
				columnWidth : .1
				},periodTypeField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.005
				},{
				xtype : 'displayfield',
				value : '核算期间:',
				columnWidth : .1
				},periodField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.005
				},{
				xtype : 'displayfield',
				value : '奖金方案:',
				columnWidth : .1
				},BonusSchemeField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.005
				},{
				xtype : 'displayfield',
				value : '核算科室:',
				columnWidth : .1
				},BonusUnitField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.005
				},{
				xtype : 'displayfield',
				value : '奖金核算:',
				columnWidth : .1
				},SchemeItemField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.01
				},{
				columnWidth:0.05,
				xtype:'button',
				text: '查询',
				handler:function(b){SearchFun();},
				iconCls: 'find'
				},{
				xtype:'displayfield',
				value:'',
				columnWidth:.01
				}]
	}]
	
});


var itemGrid = new dhc.herp.Grid({
		id:'itemGrid',
		name:'itemGrid',
        //width: 400,
        //editable:true,                   //是否可编辑
        //readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.unitbonusdetaileditexe.csp',	  
		atLoad : true, // 是否自动刷新
		//loadmask:true,
        fields: [
			//new Ext.grid.CheckboxSelectionModel({editable:false}),
		{
            header: 'ID',
            dataIndex: 'RowID',
			editable:false,
            hidden: true
        },{
           id:'BonusSchemeCodeName',
            header: '奖金方案编码名称',
			allowBlank: false,
			editable:false,
			width:160,
            dataIndex: 'BonusSchemeCodeName'   
        },{
            id:'BonusYear',
            header: '核算年度',
			allowBlank: false,
			editable:false,
			width:60,
            dataIndex: 'BonusYear'
        },{
            id:'BonusPeriod',
            header: '核算期间',
			allowBlank: false,
			editable:false,
			width:60,
            dataIndex: 'BonusPeriod'
        },{
            id:'BonusUnitCodeName',
            header: '核算科室编码名称',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'BonusUnitCodeName'
        },{
            id:'SchemeItemCode',
            header: '奖金核算编码',
			allowBlank: false,
			editable:false,
			width:80,
            dataIndex: 'SchemeItemCode'
        },{
            id:'SchemeItemName',
            header: '奖金核算名称',
			allowBlank: false,
			editable:false,
			width:100,
            dataIndex: 'SchemeItemName'
        },{
            id:'BonusValue',
            header: '奖金',
			allowBlank: false,
			width:120,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							return '<span style="color:blue;cursor:hand">'+value+'</span>';
						},
            dataIndex: 'BonusValue'
        },{
            id:'BonusFormula',
            header: '奖金公式',
			allowBlank: false,
			hidden:true,
			width:120,
            dataIndex: 'BonusFormula'
        },{
            id:'BonusFormulaDesc',
            header: '公式描述',
			allowBlank: false,
			editable:false,
			width:120,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						},
            dataIndex: 'BonusFormulaDesc'
        },{
            id:'BonusFormulaValue',
            header: '公式实际值',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'BonusFormulaValue'
        },{
            id:'BonusItemTypeName',
            header: '核算项目',
			allowBlank: false,
			editable:false,
			width:80,
            dataIndex: 'BonusItemTypeName'
        }]
});
	
	
	/*
	itemGrid.hiddenButton(0);
	itemGrid.hiddenButton(1);
	itemGrid.hiddenButton(2);
    itemGrid.hiddenButton(3);
    itemGrid.hiddenButton(4);*/
	itemGrid.btnAddHide();     //隐藏增加按钮
    itemGrid.btnSaveHide();    //隐藏保存按钮
    itemGrid.btnResetHide();   //隐藏重置按钮
    itemGrid.btnDeleteHide();  //隐藏删除按钮
    itemGrid.btnPrintHide();   //隐藏打印按钮
	
/////////////////查询按钮响应函数//////////////
function SearchFun()
{			
	var sYear= periodYear.getValue()
	var sPeriod  = periodField.getValue();
	var BonusScheme = BonusSchemeField.getValue();
	var BonusUnit = BonusUnitField.getValue();
	var SchemeItem = SchemeItemField.getValue();
	//alert(sYear+"   "+sPeriod+"  "+BonusScheme+"   "+BonusUnit+"  "+SchemeItem);	
	itemGrid.load({params:{start:0,limit:25,sYear:sYear,sPeriod:sPeriod,BonusScheme:BonusScheme,BonusUnit:BonusUnit,SchemeItem:SchemeItem}});	
}
var oldBonusValue="";


// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	var rowObj = itemGrid.getSelectionModel().getSelections();     // get the selected items
	var len = rowObj.length;
    if(len > 0)
    {
		if (columnIndex == 8) {
			var BonusValue=rowObj[0].get("BonusValue");
			oldBonusValue=BonusValue;
			//BonusValue=this.getStore().getModifiedRecords();
			

		}
		if(columnIndex == 10){
			var year=rowObj[0].get("BonusYear");
			var Period=rowObj[0].get("BonusPeriod");
			var UnitCodeName=rowObj[0].get("BonusUnitCodeName");
			var BonusFormula=rowObj[0].get("BonusFormula");
			var BonusSchemeCodeName=rowObj[0].get("BonusSchemeCodeName");
			//Ext.Msg.show({title:'测试',msg:year+"^"+Period+"^"+UnitCodeName,buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			unitbonusformula(year,Period,UnitCodeName,BonusFormula,BonusSchemeCodeName);
		}
		

	}
		
});
itemGrid.on("afteredit", afterEdit, itemGrid);  

function afterEdit(obj){  
var r = obj.record;//获取被修改的行  
var l = obj.field;//获取被修改的列  
var myRowid = r.get("RowID");
var ItemCode=r.get("SchemeItemCode");
var ItemName=r.get("SchemeItemName");
var BonusSchemeCodeName=r.get("BonusSchemeCodeName");
var BonusYear=r.get("BonusYear");
var BonusPeriod=r.get("BonusPeriod");
var BonusUnitCodeName=r.get("BonusUnitCodeName");
var BonusValue=r.get("BonusValue");
var YearMonth=BonusYear+BonusPeriod;
var detailData="方案："+BonusSchemeCodeName+"--"+"科室："+BonusUnitCodeName
Ext.Ajax.request({
			url:  'dhc.bonus.unitbonusdetaileditexe.csp?action=edit&rowid='+myRowid+'&oldBonusValue='+oldBonusValue+'&BonusValue='+BonusValue+'&userCode='+userCode+'&ItemCode='+ItemCode+'&ItemName='+ItemName+'&detailData='+detailData+'&YearMonth='+YearMonth,
			waitMsg:'保存中...',
			failure: function(result, request) {
				Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {				
				var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					itemGrid.load({params:{start:0, limit:25}});
				}
				else
				{
					var message = "";
					message = "SQLErr: " + jsonData.info;
					if(jsonData.info!=0) message='信息修改有误!';
				  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
		scope: this
		});
}  

	
	
