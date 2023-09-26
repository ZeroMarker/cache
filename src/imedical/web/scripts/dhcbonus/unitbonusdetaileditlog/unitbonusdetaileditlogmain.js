var userCode = session['LOGON.USERCODE'];
var StartDateField = new Ext.form.DateField({
		id : 'StartDateField',
		format : 'Y-m-d',
		fieldLabel:'开始日期',
		width : 120,
		editable:true,
		emptyText : '请选择开始日期...'
	});
	var EndDateField = new Ext.form.DateField({
		id : 'EndDateField',
		format : 'Y-m-d',
		fieldLabel:'结束日期',
		width : 120,
		editable:true,
		emptyText : '请选择结束日期...'
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
				value : '修改日期:',
				columnWidth : .07
				},StartDateField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.005
				},{
				xtype : 'displayfield',
				value : '至',
				columnWidth : .013
				},{
				xtype:'displayfield',
				value:'',
				columnWidth:.005
				},EndDateField,{
				xtype:'displayfield',
				value:'',
				columnWidth:.01
				},{
				columnWidth:0.05,
				xtype:'button',
				text: '查询',
				handler:function(b){SearchFun();},
				iconCls: 'find'
				}]
	}]
	
});


var itemGrid = new dhc.herp.Grid({
        //width: 400,
        //editable:true,                   //是否可编辑
        //readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.unitbonusdetaileditlogexe.csp',	  
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
            id:'ModiDate',
            header: '修改日期',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'ModiDate'
        },{
           id:'ModiPerson',
            header: '修改人',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'ModiPerson'   
        },{
            id:'TableName',
            header: '所修改的表名',
			allowBlank: false,
			editable:false,
			width:185,
            dataIndex: 'TableName'
        },{
            id:'ItemCode',
            header: '修改项编码',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'ItemCode'
        },{
            id:'ItemName',
            header: '修改项名称',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'ItemName'
        },{
            id:'OldValue',
            header: '原值',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'OldValue'
        },{
            id:'NewValue',
            header: '新值',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'NewValue'
        },{
            id:'ReMark',
            header: '标识',
			allowBlank: false,
			editable:false,
			width:120,
            dataIndex: 'ReMark'
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
	var StartDate= StartDateField.getValue()
	var EndDate=EndDateField.getValue();
	
	//alert(sYear+"   "+sPeriod+"  "+BonusScheme+"   "+BonusUnit+"  "+SchemeItem);	
	itemGrid.load({params:{start:0,limit:25,StartDate:StartDate,EndDate:EndDate}});	
}

	
	
