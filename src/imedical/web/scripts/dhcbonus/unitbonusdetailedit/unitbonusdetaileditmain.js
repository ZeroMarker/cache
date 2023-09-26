var userCode = session['LOGON.USERCODE'];
var periodStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue']
		});

var data = "";
var periodTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['M', '�·�'], ['Q', '����'], ['H', '����'], ['Y', '���']]
		});

var periodTypeField = new Ext.form.ComboBox({
			id : 'periodTypeField',
			fieldLabel : '�ڼ�����',
			width : 80,
			listWidth : 60,
			allowBlank : false,
			store : periodTypeStore,
			anchor : '90%',
			value : '', // Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			//minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
periodTypeField.on("select", function(cmb, rec, id) {
	if (cmb.getValue() == "M") {
		data = [['M01', '01��'], ['M02', '02��'], ['M03', '03��'], ['M04', '04��'],
				['M05', '05��'], ['M06', '06��'], ['M07', '07��'], ['M08', '08��'],
				['M09', '09��'], ['M10', '10��'], ['M11', '11��'], ['M12', '12��']];
	}
	if (cmb.getValue() == "Q") {
		data = [['Q01', '01����'], ['Q02', '02����'], ['Q03', '03����'],
				['Q04', '04����']];
	}
	if (cmb.getValue() == "H") {
		data = [['H01', '�ϰ���'], ['H02', '�°���']];
	}
	if (cmb.getValue() == "Y") {
		data = [['Y00', '00']];
	}
	periodStore.loadData(data);

});

var periodField = new Ext.form.ComboBox({
			id : 'periodField',
			fieldLabel : '�����ڼ�',
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
			mode : 'local', // ����ģʽ
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
			fieldLabel : '�������',
			width : 80,
			listWidth : 60,
			selectOnFocus : true,
			allowBlank : false,
			store : cycleDs,
			anchor : '90%',
			value : '', // Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'BonusYear',
			valueField : 'BonusYear',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
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
//////////////���𷽰�����//////////////////
var BonusSchemeField = new Ext.form.TextField({
		id:'BonusScheme',
		name:'BonusScheme',
		fieldLabel:'���𷽰�',
		width : 100,
		emptyText : '��������������'
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
			fieldLabel:'���𷽰�',
			width : 80,
			listWidth : 60,
			selectOnFocus : true,
			allowBlank : false,
			store : schemeDs,
			anchor : '90%',
			value : '', // Ĭ��ֵ
			valueNotFoundText : '',
			displayField : 'BonusScheme',
			valueField : 'rowid',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // ����ģʽ
			editable : false,
			//pageSize : 10,
			//minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
*/

//////////////�������//////////////////
var BonusUnitField = new Ext.form.TextField({
		id:'BonusUnit',
		name:'BonusUnit',
		fieldLabel:'�������',
		width : 100,
		emptyText : '��������������'
	});

//////////////�����������//////////////////
var SchemeItemField = new Ext.form.TextField({
		id:'SchemeItem',
		name:'SchemeItem',
		fieldLabel:'�������',
		width : 100,
		emptyText : '��������������'
	});
	
/////////////////////��ѯ���///////////////
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
				value : '�������:',
				columnWidth : .1
				},periodYear,{
				xtype:'displayfield',
				value:'',
				columnWidth:.005
				},{
				xtype : 'displayfield',
				value : '�ڼ�����:',
				columnWidth : .1
				},periodTypeField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.005
				},{
				xtype : 'displayfield',
				value : '�����ڼ�:',
				columnWidth : .1
				},periodField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.005
				},{
				xtype : 'displayfield',
				value : '���𷽰�:',
				columnWidth : .1
				},BonusSchemeField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.005
				},{
				xtype : 'displayfield',
				value : '�������:',
				columnWidth : .1
				},BonusUnitField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.005
				},{
				xtype : 'displayfield',
				value : '�������:',
				columnWidth : .1
				},SchemeItemField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.01
				},{
				columnWidth:0.05,
				xtype:'button',
				text: '��ѯ',
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
        //editable:true,                   //�Ƿ�ɱ༭
        //readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.unitbonusdetaileditexe.csp',	  
		atLoad : true, // �Ƿ��Զ�ˢ��
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
            header: '���𷽰���������',
			allowBlank: false,
			editable:false,
			width:160,
            dataIndex: 'BonusSchemeCodeName'   
        },{
            id:'BonusYear',
            header: '�������',
			allowBlank: false,
			editable:false,
			width:60,
            dataIndex: 'BonusYear'
        },{
            id:'BonusPeriod',
            header: '�����ڼ�',
			allowBlank: false,
			editable:false,
			width:60,
            dataIndex: 'BonusPeriod'
        },{
            id:'BonusUnitCodeName',
            header: '������ұ�������',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'BonusUnitCodeName'
        },{
            id:'SchemeItemCode',
            header: '����������',
			allowBlank: false,
			editable:false,
			width:80,
            dataIndex: 'SchemeItemCode'
        },{
            id:'SchemeItemName',
            header: '�����������',
			allowBlank: false,
			editable:false,
			width:100,
            dataIndex: 'SchemeItemName'
        },{
            id:'BonusValue',
            header: '����',
			allowBlank: false,
			width:120,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							return '<span style="color:blue;cursor:hand">'+value+'</span>';
						},
            dataIndex: 'BonusValue'
        },{
            id:'BonusFormula',
            header: '����ʽ',
			allowBlank: false,
			hidden:true,
			width:120,
            dataIndex: 'BonusFormula'
        },{
            id:'BonusFormulaDesc',
            header: '��ʽ����',
			allowBlank: false,
			editable:false,
			width:120,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						},
            dataIndex: 'BonusFormulaDesc'
        },{
            id:'BonusFormulaValue',
            header: '��ʽʵ��ֵ',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'BonusFormulaValue'
        },{
            id:'BonusItemTypeName',
            header: '������Ŀ',
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
	itemGrid.btnAddHide();     //�������Ӱ�ť
    itemGrid.btnSaveHide();    //���ر��水ť
    itemGrid.btnResetHide();   //�������ð�ť
    itemGrid.btnDeleteHide();  //����ɾ����ť
    itemGrid.btnPrintHide();   //���ش�ӡ��ť
	
/////////////////��ѯ��ť��Ӧ����//////////////
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


// ����gird�ĵ�Ԫ���¼�
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
			//Ext.Msg.show({title:'����',msg:year+"^"+Period+"^"+UnitCodeName,buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			unitbonusformula(year,Period,UnitCodeName,BonusFormula,BonusSchemeCodeName);
		}
		

	}
		
});
itemGrid.on("afteredit", afterEdit, itemGrid);  

function afterEdit(obj){  
var r = obj.record;//��ȡ���޸ĵ���  
var l = obj.field;//��ȡ���޸ĵ���  
var myRowid = r.get("RowID");
var ItemCode=r.get("SchemeItemCode");
var ItemName=r.get("SchemeItemName");
var BonusSchemeCodeName=r.get("BonusSchemeCodeName");
var BonusYear=r.get("BonusYear");
var BonusPeriod=r.get("BonusPeriod");
var BonusUnitCodeName=r.get("BonusUnitCodeName");
var BonusValue=r.get("BonusValue");
var YearMonth=BonusYear+BonusPeriod;
var detailData="������"+BonusSchemeCodeName+"--"+"���ң�"+BonusUnitCodeName
Ext.Ajax.request({
			url:  'dhc.bonus.unitbonusdetaileditexe.csp?action=edit&rowid='+myRowid+'&oldBonusValue='+oldBonusValue+'&BonusValue='+BonusValue+'&userCode='+userCode+'&ItemCode='+ItemCode+'&ItemName='+ItemName+'&detailData='+detailData+'&YearMonth='+YearMonth,
			waitMsg:'������...',
			failure: function(result, request) {
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request) {				
				var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					itemGrid.load({params:{start:0, limit:25}});
				}
				else
				{
					var message = "";
					message = "SQLErr: " + jsonData.info;
					if(jsonData.info!=0) message='��Ϣ�޸�����!';
				  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			},
		scope: this
		});
}  

	
	
