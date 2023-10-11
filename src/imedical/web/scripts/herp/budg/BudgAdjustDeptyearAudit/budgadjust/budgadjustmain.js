var startDateField = new Ext.form.DateField({
	id:'startDateField',
	fieldLabel: '起始日期',
	columnWidth : .1,
	allowBlank:true,
	format:'Y-m-d',
	selectOnFocus:'true'
});

var endDateField = new Ext.form.DateField({
	id:'endDateField',
	fieldLabel: '起始日期',
	columnWidth : .1,
	allowBlank:true,
	format:'Y-m-d',
	selectOnFocus:'true'
});

var fileNo = new Ext.form.TextField({
			columnWidth : .1,
			selectOnFocus : true
});
		
var IsApproveCombo = new Ext.form.ComboBox({
			fieldLabel : '预算下达',
			store : [['0', '否'], ['1', '是']],
			edit:false,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			columnWidth : .1,
			listWidth : 120,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
});

///////////// 会计年度 ///////////////////
projUrl='herp.budg.budgadjustdeptyearauditexe.csp';
var yearDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});
yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:projUrl+'?action=yearlist',method:'POST'})
});
var yearField  = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '会计年度',
	width : 100,
	listWidth : 100,
	store: yearDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	columnWidth : .1,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners:{
            "select":function(combo,record,index){
	            AdjustNoStore.removeAll();     
				AdjustNo.setValue('');
				AdjustNoStore.proxy = new Ext.data.HttpProxy({url:projUrl+'?action=adjustno&year='+combo.value,method:'POST'})  
				AdjustNoStore.load({params:{start:0,limit:10}});      					
			}
	}	
});

////////////// 调整序号 //////////////////////
var strInfo="请选择..."
var AdjustNoStore = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','AdjustNo'])
});
AdjustNoStore.on('beforeload', function(ds, o){
	var year=yearField.getValue();	
	if(!year){
		Ext.Msg.show({title:'注意',msg:'请先选择会计年度',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
});
var AdjustNo = new Ext.form.ComboBox({
	id: 'AdjustNo',
	fieldLabel: '调整序号',
	width : 100,
	listWidth : 225,
	store: AdjustNoStore,
	valueField: 'AdjustNo',
	displayField: 'AdjustNo',
	triggerAction: 'all',
	emptyText:'请选择...',
	name: 'AdjustNo',
	minChars: 1,
	pageSize: 10,
	columnWidth : .1,
	selectOnFocus:true,
	//columnWidth:.15,
	forceSelection:'true',
	editable:true,
	listeners:{
		 "select":function(combo,record,index){
		 	/*itemGrid.load({
							params : {
								start: 0,
								limit: 25,
								Year:yearField.getValue(),
								AdjustNo : AdjustNo.getValue()
							}
			});  */ 
		}
	}
});


var startButton = new Ext.Toolbar.Button({
		text: '调整方案启用',
		tooltip: '调整方案启用',
		iconCls: 'add',
		handler: function(){
			var adjno = AdjustNo.getValue();
			var year = yearField.getValue();
			if((adjno=="")||(year=="")){
				Ext.Msg.show({title:'注意',msg:'请选择年度和调整号!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			if ((adjno!="")&&(year!=""))
			{
				Ext.MessageBox.confirm('提示', 
    	    '确定要启用该调整方案?', 
    	    function(btn){
				if(btn=="yes"){
				
				var myMask = new Ext.LoadMask(Ext.getBody(), {
       			msg: '调整启用中…',
        		removeMask: true //完成后移除
    			});
	
	 			myMask.show();
				//for(var i=0;i<len;i++){
				Ext.Ajax.request({
				url:'../csp/herp.budg.budgadjustexe.csp?action=start&Year='+year+'&AdjustNo='+adjno,
				waitMsg:'启用中...',
				failure: function(result, request){
					myMask.hide();
					Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						myMask.hide();
						Ext.Msg.show({title:'注意',msg:'启用成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					}else{
						var message = "";
						message = "SQLErr: " + jsonData.info;
						if(jsonData.info=='UNDO') message='该记录被执行过！';
						else message='启用失败！';
						myMask.hide();
						Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}
				},
				scope: this						
				});
			}
			else{return;}
			})										
		}
}
});


// 主页面查询
var queryButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls: 'option',
			//width:120,
			handler : function() {
				var startDate=((startDateField.getValue()=='')?'':startDateField.getValue().format('Y-m-d'));
				var endDate=((endDateField.getValue()=='')?'':endDateField.getValue().format('Y-m-d'));
				var fileno = fileNo.getValue();
				var IsApprove = IsApproveCombo.getValue();
				itemGrid.load({
							params : {
								start: 0,
								limit: 25,
								startDate: startDate,
								endDate: endDate,
								AdjustFile : fileno,
								IsApprove : IsApprove
							}
				});
			}	
});

var queryPanel = new Ext.FormPanel({
	height : 120,
	region : 'north',
	frame : true,
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:150%">年度预算调整启动</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '起始日期:',
					columnWidth : .08
				},startDateField,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '结束日期:',
					columnWidth : .08
				},endDateField
				,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '调整文号:',
					columnWidth : .08
				},fileNo
				,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '预算下达:',
					columnWidth : .08
				},IsApproveCombo
				,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},
				queryButton			
		]
	},{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '会计年度:',
					columnWidth : .08
				},yearField,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},
				{
					xtype : 'displayfield',
					value : '调整序号:',
					columnWidth : .08
				},AdjustNo,
				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},startButton				
		]
	}]
});




var IsApproveCombo2 = new Ext.form.ComboBox({
			fieldLabel : '预算下达',
			store : [['0', '否'], ['1', '是']],
			edit:false,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 200,
			listWidth : 120,
			pageSize : 10,
			minChars : 1,
			//columnWidth : .1,
			selectOnFocus : true
});


var adjustUrl = 'herp.budg.budgadjustexe.csp';
var addProxy = new Ext.data.HttpProxy({url: adjustUrl+'?action=list'});
var startDs = new Ext.data.Store({
	proxy: addProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
		}, [
     		'rowid',
     		'CompDR',
     		'Year',
			'AdjustNo',
			'AdjustDate',
			'AdjustFile',
			'Memo',
			'IsApprove',
			'IsElast',
			'ElastMonth',
			'schemeName',
			'itemCode'
		]),
    remoteSort: true
});

var itemGrid = new dhc.herp.Grid({
        title: '预算年度调整',
        width: 400,
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'herp.budg.budgadjustexe.csp',	  
		tbar:[addButton],
		atLoad : true, // 是否自动刷新
		loadmask:true,
        fields: [ new Ext.grid.CheckboxSelectionModel({sm:'sm',editable:false}),
        {
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'CompDR',
            header: '医疗单位',
			width:120,
			hidden: true,
            dataIndex: 'CompDR'
        },{
            id:'Year',
            header: '会计年度',
			allowBlank: false,
			//hidden: true,
			editable:false,
			width:120,
			update:true,
            dataIndex: 'Year'
        },{								//rowid CompDR  Year AdjustNo AdjustAate AdjustFile Memo IsApprove IsElast ElastMonth
            id:'AdjustNo',
            header: '调整序号',
           	editable:false,
            allowBlank: false,
			width:120,
            dataIndex: 'AdjustNo',
        	renderer : function(value, cellmeta, record, rowIndex, columnIndex, store)
						{ 
							return '<span style="color:blue;cursor:hand">'+value+'</span>'	 
						}
        },{
            id:'AdjustDate',
            header: '调整日期',
			//hidden: true,
			width:120,
			editable:false,
            dataIndex: 'AdjustDate',
            //type:"dateField" ,   
            altFormats:'Y-m-d'
        },{
            id:'AdjustFile',
            header: '调整文号',
			//hidden: true,
			width:120,
			editable:false,
            dataIndex: 'AdjustFile'
        },{
            id:'IsApprove',
            header: '是否指标下达',
			width:120,
			editable:false,
			type:IsApproveCombo2,
			dataIndex: 'IsApprove'
           
        },{
            id:'Memo',
            header: '调整说明',
			width:120,
			editable:false,
            dataIndex: 'Memo'
        },{
            id:'IsElast',
            header: '是否弹性预算',
			width:150,
			editable:false,
            dataIndex: 'IsElast',
            hidden: true
        },{
            id:'ElastMonth',
            header: '弹性调整月份',
			width:150,
			editable:false,
            dataIndex: 'ElastMonth',
            hidden: true
        },{
            id:'schemeName',
            header: '对应方案',
            edit:false,
			width:120,
			editable:false,
           // dataIndex: 'schemeName',
            renderer : function(value, cellmeta, record, rowIndex, columnIndex, store)
						{ 
							return '<span style="color:blue;cursor:hand">对应方案</span>'	 
						}
        },{
            id:'itemCode',
            header: '预算信息',
			width:120,
			editable:false,
			hidden: true,
            dataIndex: 'itemCode'
            /*,renderer : function(value, cellmeta, record, rowIndex, columnIndex, store)
						{ 
							return '<span style="color:blue;cursor:hand">'+value+'</span>'	 
						}*/
        }] 
});

    //itemGrid.hiddenButton(3);
	itemGrid.hiddenButton(4);
	itemGrid.btnAddHide(); 		//隐藏增加按钮
  	itemGrid.btnSaveHide(); 	//隐藏保存按钮
    itemGrid.btnResetHide() ;	//隐藏重置按钮
    itemGrid.btnPrintHide() ;	//隐藏打印按钮

// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	var records = itemGrid.getSelectionModel().getSelections();
	if (columnIndex == 5) {         	
		var rowid  = records[0].get("rowid");
		var CompDR  = records[0].get("CompDR");
		var Year  = records[0].get("Year");
		var AdjustNo  = records[0].get("AdjustNo");
		var AdjustDate  = records[0].get("AdjustDate");
		var AdjustFile  = records[0].get("AdjustFile");
		var Memo  = records[0].get("Memo");
		var IsApprove  = records[0].get("IsApprove");
		var IsElast  = records[0].get("IsElast");
		var ElastMonth  = records[0].get("ElastMonth");
		
		editFun(rowid,CompDR,Year, AdjustNo, AdjustDate, AdjustFile,Memo,IsApprove, IsElast,ElastMonth);
	    //alert("哈哈");
	}
	else if(columnIndex == 12)
		{
			var Year  = records[0].get("Year");
			var adjustNo = records[0].get("AdjustNo");
			var Memo = records[0].get("Memo");
			var rowid  = records[0].get("rowid");
			budginstructionFun(rowid,Year,adjustNo, Memo);
			//alert("shide");
		}
	/*else if (columnIndex == 13) {
		var year= records[0].get("Year");
		var adjustNo= records[0].get("AdjustNo");	
		var itemCode= records[0].get("itemCode");
		budginfoFun(year, adjustNo, itemCode);
		//alert(itemCode);
		
	}*/
});