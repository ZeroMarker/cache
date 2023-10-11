var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var schemmaUrl='herp.budg.budgschemmafactyearexe.csp';
var USERID = session['LOGON.USERID'];
// ////////////////////////////////////
var SchTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

SchTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgcommoncomboxexe.csp?action=itemtype&flag=1',
						method : 'POST'
					});
		});

var SchTypeCombo = new Ext.form.ComboBox({
			fieldLabel : '预算项类别',
			store : SchTypeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 150,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

// ////////////////////////////////////
var smYear1Ds = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

smYear1Ds.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgschemmamainexe.csp?action=yearList',
						method : 'POST'
					});
		});

var yearCombo1 = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : smYear1Ds,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 150,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

/////////////////////科目名称/////////////////////////////
var ItemCodefield = new Ext.form.TextField({
		id: 'ItemCodefield',
		fieldLabel: '科目名称',
		allowBlank: true,
	    //name:'',
	    //value:'',
		emptyText:'请填写...',
		width:100,
	    listWidth : 100
	});

var searchbotton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
			
	      	var schtype=SchTypeCombo.getValue();
	      	var itemcode=ItemCodefield.getValue();
	      	var selectedRow = itemGrid.getSelectionModel().getSelections();
			var len = selectedRow.length;
	   		if((len < 1)){
		    Ext.Msg.show({title:'注意',msg:'请先选择一行方案！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	       }
			else{	
			schemeDr=selectedRow[0].data['rowid'];
			var year = selectedRow[0].data['Year'];
			MAitemGrid.load({params:{start:0, limit:12,SchemDr:schemeDr,type:schtype,year:year,itemcode:itemcode}})
			}
	}
});


//提交
var submitButton = new Ext.Toolbar.Button({
	text: '提交',
    tooltip:'提交',        
    iconCls:'add',
    handler:function(){
		    
		    var selectedRow = itemGrid.getSelectionModel().getSelections();
		    var len = selectedRow.length;
		    if(len < 1){
            	Ext.Msg.show({title:'错误',msg:'请选择对应的方案',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            	return false;
        	}
        	var rowIndex = itemGrid.getSelectionModel().lastActive;//主表选中的行号
		    var SchemDr=selectedRow[0].data['rowid'];
		    var schemAuditDR=selectedRow[0].data['schemAuditDR'];
		    var BillState=selectedRow[0].data['ChkState'];//1:新建,2:提交,3:通过,4:不通过,5:完成
			if((BillState!=='1')&&(BillState!==''))
			{
				Ext.Msg.show({
						title : '',
						msg : '只有新建状态的单据需要提交',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
				return;
			}
		Ext.MessageBox.confirm('提示', '确定要提交吗？', function(btn) {
		if (btn == 'yes') {
		    var selectidDetail=MAitemGrid.getStore().getModifiedRecords();
		    for(i=0;i<selectidDetail.length;i++){
		    	var rowid = selectidDetail[i].get("rowid");
		    	var PlanValue = selectidDetail[i].get("PlanValue");
	    		var url = schemmaUrl+'?action=edit&&rowid='+ rowid+'&PlanValue='+PlanValue;
	    		MAitemGrid.saveurl(url);
	    	}

	    	var url2 = schemmaUrl+'?action=submit&&SchemDr='+SchemDr+'&UserID='+USERID+'&schemAuditDR='+schemAuditDR;
	    	MAitemGrid.saveurl(url2);
		
	    	var year = yearCombo.getValue();
	    	var schName = schemNo.getValue();
			var schtype=SchTypeCombo.getValue();
			MAitemGrid.load({params:{start:0,limit:12,SchemDr:SchemDr,type:schtype,year:year}})
			itemGrid.load({params : {start : 0,limit : 25,year : year,schemtype : schName,USERID:USERID}});
	   		backoutButton.enable();
			submitButton.disable();
		 	var d = new Ext.util.DelayedTask(function(){  
            	itemGrid.getSelectionModel().selectRow(rowIndex);
           	});  
            d.delay(1000); 
			itemGrid.getSelectionModel().selectRow(rowIndex)
       }	
	}); 
	}
	
});
//撤销
var backoutButton = new Ext.Toolbar.Button({
	text: '撤销',
    tooltip:'撤销',        
    iconCls:'add',
    handler:function(){
		    
		    var selectedRow = itemGrid.getSelectionModel().getSelections();
		    var len = selectedRow.length;
		    if(len < 1){
            	Ext.Msg.show({title:'错误',msg:'请选择对应的方案',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
            	return false;
        	}
        	var rowIndex = itemGrid.getSelectionModel().lastActive;//主表选中的行号
        	
		    var SchemDr=selectedRow[0].data['rowid'];
		    var schemAuditDR=selectedRow[0].data['schemAuditDR'];
		    var BillState=selectedRow[0].data['ChkState'];//1:新建,2:提交,3:通过,4:不通过,5:完成
		    var StepNO=selectedRow[0].data['StepNOC'];
		    var CurStepNO=selectedRow[0].data['CurStepNO'];
			if((BillState=='1')&&(BillState==''))
			{
				Ext.Msg.show({title : '',msg : '方案未提交,不能撤销！',buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
				return;
			}
			 else if((StepNO<=CurStepNO)&&(BillState!=='1'))
        	{
	        	Ext.MessageBox.confirm('提示', '确定要撤销吗？', function(btn) {
					if (btn == 'yes') {
	       				var url = schemmaUrl+'?action=backout&&UserID='+USERID+'&schemAuditDR='+schemAuditDR;
	    				MAitemGrid.saveurl(url);
	    				var year = yearCombo.getValue();
	    				var schName = schemNo.getValue();
						var schtype=SchTypeCombo.getValue();
						MAitemGrid.load({params:{start:0,limit:12,SchemDr:SchemDr,type:schtype,year:year}})
						itemGrid.load({params:{start:0,limit:25,year:year,schemtype:schName,USERID:USERID}});
	   					backoutButton.disable();
	   					submitButton.enable();
	   					var d = new Ext.util.DelayedTask(function(){  
            				itemGrid.getSelectionModel().selectRow(rowIndex);
           				});  
            			d.delay(1000); 
						itemGrid.getSelectionModel().selectRow(rowIndex)
	   				}	
				}); 
        	}else if(StepNO=="")
        	{
	        	//表示这个人没有审核权限
	        	Ext.Msg.show({title:'注意',msg:'已审核，不可撤销！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	        	return;
        	}else
        	{
	        	Ext.Msg.show({title:'注意',msg:'不是当前权限人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	        	return;
        	}
	    	
       }	
	
});

var MAitemGrid = new dhc.herp.Gridhss({
            title : '预算项预算', 
			region : 'center',
			url : 'herp.budg.budgschemmafactyearexe.csp',
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用 
		                    if ((record.get('t2d') =="")&& (columnIndex == 9)) {
		                         return false;
		                     } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 预算项目公式编辑
						if ((record.get('t2d') =="") && (columnIndex == 9)) {						
							return false;
						} else {
							return true;
						}
					}
            },
						
			fields : [
			//new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'year',
						header : '年度',
						dataIndex : 'year',
						width : 80,
						editable:false,
						hidden : false

					}, {
						id : 'Code',
						header : '预算编码',
						dataIndex : 'Code',
						width : 120,
						editable:false,
						// type:itemcbbox,
						hidden : false

					}, {
						id : 'Name',
						header : '预算项名称',
						width : 200,
						editable:false,
						//allowBlank : false,
						dataIndex : 'Name'

				}, {
						id : 'Year',
						header : '年度',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'Year'

				}, {
						id : 'TypeCode',
						header : '预算项类别',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'TypeCode'

					},{
						id : 't1s',
						header : '全院',
						width : 140,
						editable:false,
						align : 'right',
						/*renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['t2s']
						if (sf != "") {
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						} else {
							'<span style="color:blue;cursor:hand"><u></u></span>';
						}},*/
						dataIndex : 't1s'

					}, {
						id : 't2d',
						header : '科室汇总',
						width : 140,
						align : 'right',
						editable:false,
						overrender: true,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['t2d']
						if (sf != "") {
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						} else {
							'<span style="color:blue;cursor:hand"><u></u></span>';
						}},
						dataIndex : 't2d'

					}, {
						id : 'dis',
						header : '差额',
						width : 140,
						editable : false,
						align : 'right',
						dataIndex : 'dis'
						
					},{
						id : 'disrate',
						header : '差异率(%)',
						width : 140,
						editable:false,
						align : 'right',
						//hidden:true,
						dataIndex : 'disrate'

					}, {
        id:'prebfrealvaluelast',
        header: '前年预算',
        align:'right',
        width:100,
		//tip:true,
		allowBlank: false,
		editable:false
        ,dataIndex: 'prebfrealvaluelast'
		
    }, {
        id:'prebfrealvaluelastexe',
        header: '前年执行',
        align:'right',
        width:100,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'prebfrealvaluelastexe'
		
    }, {
        id:'bfrealvaluelast',
        header: '去年预算',
        align:'right',
        width:100,
		//tip:true,
		allowBlank: false,
		editable:false,
        dataIndex: 'bfrealvaluelast'
		
    }, {
						id : 'RealValueLast',
						header : '上年执行',
						width : 140,
						align : 'right',
						editable : false,
						dataIndex : 'RealValueLast'
						
					},{
						id : 'disitem',
						header : '差额',
						width : 140,
						editable : false,
						align : 'right',
						dataIndex : 'disitem'
					},{
						id : 'updisrate',
						header : '差异率(%)',
						width : 140,
						align : 'right',
						editable:false,
						dataIndex : 'updisrate'

					},{
						id : 'IdxType',
						header : '指标属性',
						width : 80,
						editable:false,
						//hidden:true,
						dataIndex : 'IdxType'

					},{
						id : 'SchemDR',
						header : '方案dr',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'SchemDR'

					}],
					tbar:['预算项类别',SchTypeCombo,'-','科目名称:',ItemCodefield,'-',searchbotton,'-',submitButton,'-',backoutButton],
					layout:"fit",
					split : true,
					collapsible : true,
					containerScroll : true,
					xtype : 'grid',
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					//viewConfig : {forceFit : true},		
					loadMask: true,
					atLoad: true,
					height : 250,
					trackMouseOver: true,
					stripeRows: true
					

		});




// 单击gird的单元格事件
MAitemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	 //alert(columnIndex)
	// 科室明细
	if (columnIndex == 8) {
		var records = MAitemGrid.getSelectionModel().getSelections();
		var sName = records[0].get("Code")
		var SchemDR = records[0].get("SchemDR")
        var schName = records[0].get("Name")
        var Year = records[0].get("Year")
        //alert(OrderBy);
		// 科室年度预算维护界面
		MADFun(sName,SchemDR, MAitemGrid,schName,Year);
	}
		// 预算方案明细添加
	/*if (columnIndex == 10) {
		var records = MAitemGrid.getSelectionModel().getSelections();
		var schmDr = records[0].get("rowid")
		var schmName = records[0].get("Name")
		var syear = records[0].get("Year")
		// 预算方案明细编制
		schemeDetailFun(schmDr,schmName,syear);
	}*/

  /*
	// 预算方案复制
	if (columnIndex == 11) {
		Ext.MessageBox.confirm('提示', '确定要复制选定的方案吗', function(btn) {
			if (btn == 'yes') {
				var records = MAitemGrid.getSelectionModel().getSelections();
				var schmDr = records[0].get("rowid")
				var surl = 'herp.budg.budgschemmainexe.csp?action=copysheme&rowid='
						+ schmDr;

				MAitemGrid.saveurl(surl)
			}
		});
	}*/
	

})

    
    

