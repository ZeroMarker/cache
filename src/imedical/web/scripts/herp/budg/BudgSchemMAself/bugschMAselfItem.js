var userdr = session['LOGON.USERID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var schemselfUrl = 'herp.budg.budgschemmaselfitemexe.csp';
//////////////////////////////////////
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

var smYear1Ds = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});
smYear1Ds.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgcommoncomboxexe.csp?action=year',
						method : 'POST'
					});
		});
var yearCombo1 = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : smYear1Ds,
			displayField : 'year',
			valueField : 'year',
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
/////////////////////科目编码/////////////////////////////
var ItemCodefield = new Ext.form.TextField({
		id: 'ItemCodefield',
		fieldLabel: '科目编码',
		allowBlank: true,
		emptyText:'请填写...',
		width:100,
	    listWidth : 100
	});
var searchbotton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){	
	      	var selectedRow = itemGrid.getSelectionModel().getSelections();
			var len = selectedRow.length;
	    
	   		if((len < 1)){
		    Ext.Msg.show({title:'注意',msg:'请先选择方案！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	       }
			else{
			SchemDr=selectedRow[0].data['rowid'];
			var year = selectedRow[0].get("Year");
			var schtype=SchTypeCombo.getValue();
			var ccode = ItemCodefield.getValue();
			var dcode = deptCombo.getValue();
			selfitemGrid.load({params:{start:0, limit:12,SchemDr:SchemDr,dcode:dcode,ccode:ccode,type:schtype,year:year,userdr:userdr}})
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
		    var selectidDetail=selfitemGrid.getStore().getModifiedRecords();
		    for(i=0;i<selectidDetail.length;i++){
		    	var rowid = selectidDetail[i].get("rowid");
		    	var PlanValue = selectidDetail[i].get("PlanValue");
	    	var url = schemselfUrl+'?action=edit&&rowid='+ rowid+'&PlanValue='+PlanValue;
	    	selfitemGrid.saveurl(url);
	    	}

	    	var url2 = schemselfUrl+'?action=submit&&SchemDr='+SchemDr+'&UserID='+userdr+'&schemAuditDR='+schemAuditDR;
	    	selfitemGrid.saveurl(url2);
		
	    	var year = selectedRow[0].get("Year");
			var schtype=SchTypeCombo.getValue();
			var ccode = ItemCodefield.getValue();
			var dcode = deptCombo.getValue();
			selfitemGrid.load({params:{start:0, limit:12,SchemDr:SchemDr,dcode:dcode,ccode:ccode,type:schtype,year:year,userdr:userdr}})
			itemGrid.load({params : {start : 0,limit : 25,year:year,dcode:dcode}});
	   		backoutButton.enable();
			submitButton.disable();
			var tbar = selfitemGrid.getTopToolbar();
			var tbutton = tbar.get('herpSaveId');
			tbutton.disable();
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
	       				var url = schemselfUrl+'?action=backout&&UserID='+userdr+'&schemAuditDR='+schemAuditDR;
	    				selfitemGrid.saveurl(url);
	    				var year = selectedRow[0].get("Year");
						var schtype=SchTypeCombo.getValue();
						var ccode = ItemCodefield.getValue();
						var dcode = deptCombo.getValue();
						selfitemGrid.load({params:{start:0, limit:12,SchemDr:SchemDr,dcode:dcode,ccode:ccode,type:schtype,year:year,userdr:userdr}})
						itemGrid.load({params : {start : 0,limit : 25,year:year,dcode:dcode}});
	   					backoutButton.disable();
	   					submitButton.enable();
	   					var tbar = selfitemGrid.getTopToolbar();
						var tbutton = tbar.get('herpSaveId');
						tbutton.enable();
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

var selfitemGrid = new dhc.herp.Gridhss({
            title : '预算项预算', 
			region : 'center',
			url : 'herp.budg.budgschemmaselfitemexe.csp',
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                	var selectedRow = itemGrid.getSelectionModel().getSelections();
							var BillState=selectedRow[0].data['ChkState'];//1:新建,2:提交,3:通过,4:不通过,5:完成
		                    if ((BillState == 1)&&((columnIndex == 11)||(columnIndex == 10))&&((record.get('EditMod') == "2")||(record.get('EditMod') == "3"))) {
		                         return true;
		                     } 
		                    else {
		                     return false;
		                     }
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						var selectedRow = itemGrid.getSelectionModel().getSelections();
						var BillState=selectedRow[0].data['ChkState'];//1:新建,2:提交,3:通过,4:不通过,5:完成
						
						if ((BillState == 1)&&((columnIndex == 11)||(columnIndex == 10))&&((record.get('EditMod') == "2")||(record.get('EditMod') == "3"))) {						
							return true;
						} else {
							return false;
						}
					}
            },
						
			fields : [
			//new Ext.grid.CheckboxSelectionModel({editable:false}),
			{
						header : 'ID',
						dataIndex : 'rowid',
						update:true,
						width : 60,
						hidden : true
					}, {
						id : 'Code',
						header : '预算编码',
						dataIndex : 'Code',
						width : 100,
						editable:false,
						update:true,
						hidden : false

					}, {
						id : 'Name',
						header : '预算名称',
						width : 200,
						editable:false,
						dataIndex : 'Name'

					}, {
						id : 'Year',
						header : '年度',
						width : 120,
						editable:false,
						update:true,
						hidden : true,
						dataIndex : 'Year'

					}, {
						id : 'BITName',
						header : '预算类别',
						width : 80,
						editable:false,
						hidden : true,
						dataIndex : 'BITName'

					}, {
						id : 'PreLastPlanValue',
						header : '前年预算',
						width : 120,
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						dataIndex : 'PreLastPlanValue'
						
					}, {
						id : 'PreLast9ExeValue',
						header : '前年执行',
						width : 120,
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						dataIndex : 'PreLast9ExeValue'
						
					}, {
						id : 'LastPlanValue',
						header : '去年预算',
						width : 120,
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						dataIndex : 'LastPlanValue'
						
					}, {
						id : 'Last9ExeValue',
						header : '去年1-9月执行',
						width : 120,
						xtype:'numbercolumn',
						editable : false,
						align : 'right',
						dataIndex : 'Last9ExeValue'
						
					},{
						id : 'CalcValue',
						header : '全院下达',
						width : 140,
						editable: true,
						hidden : true,
						xtype:'numbercolumn',
						align : 'right',			
						dataIndex : 'CalcValue'
					}, {
						id : 'PlanValue',
						header : '科室预算',
						width : 140,
						align : 'right',
						editable: true,
						xtype:'numbercolumn',
						dataIndex : 'PlanValue'
					}, {
						id : 'dis1',
						header : '差额',
						width : 120,
						xtype:'numbercolumn',
						editable : false,
						align : 'right',
						dataIndex : 'dis1'						
					},{
						id : 'disrate1',
						header : '差异率(%)',
						width : 120,
						editable:false,
						align : 'right',
						//hidden:true,
						dataIndex : 'disrate1'

					}, {
						id : 'RealValueLast',
						header : '上年执行',
						width : 140,
						xtype:'numbercolumn',
						editable : false,
						align : 'right',
						dataIndex : 'RealValueLast'
						
					},{
						id : 'dis2',
						header : '差额',
						width : 120,
						editable : false,
						xtype:'numbercolumn',
						align : 'right',
						dataIndex : 'dis2'
					},{
						id : 'disrate2',
						header : '差异率(%)',
						width : 120,
						editable:false,
						align : 'right',
						dataIndex : 'disrate2'
						
					},{
						id : 'DeptDR',
						header : '科室',
						width : 70,
						editable:false,
						update:true,
						hidden:true,
						dataIndex : 'DeptDR'

					},{
						id : 'PlanValueModi',
						header : '上次修改',
						width : 80,
						editable:false,
						hidden:true,
						update:true,
						dataIndex : 'PlanValueModi'

					},{
						id : 'PlanValueModiMid',
						header : '修改中间数',
						width : 80,
						editable:false,
						update:true,
						hidden:true,
						dataIndex : 'PlanValueModiMid'

					},{
						id : 'Level',
						header : '级次',
						width : 80,
						editable:false,
						update:true,
						hidden:true,
						dataIndex : 'Level'
						
					},{
						id : 'EditMod',
						header : '编制模式',
						width : 80,
						editable:false,
						hidden:true,
						dataIndex : 'EditMod'

					}, {
						id : 'TypeCode',
						header : '预算类别',
						width : 100,
						hidden:true,
						editable:false,
						dataIndex : 'TypeCode'

					}],
					tbar:['预算项类别',SchTypeCombo,'-','科目编码',ItemCodefield,searchbotton,'-',submitButton,backoutButton],
					layout:"fit",
					split : true,
					collapsible : true,
					containerScroll : true,
					xtype : 'grid',
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					//viewConfig : {forceFit : true}, //'-','会计年度',yearCombo1,		
					loadMask: true,
					atLoad: true
		});