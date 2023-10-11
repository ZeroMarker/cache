var userdr = session['LOGON.USERID'];
// 年度///////////////////////////////////
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var projUrl = 'herp.budg.budgprojfundreqexe.csp';
var YearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

YearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=year',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '立项年度',
			store : YearDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
// ////////////项目名称////////////////////////
var projDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

projDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=projList',
						method : 'POST'
					});
		});

var projCombo = new Ext.form.ComboBox({
			fieldLabel : '项目名称',
			store : projDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
/////////////////////申请单号/////////////////////////
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 70,
			columnWidth : .12,
			selectOnFocus : true

		});


var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){

	      	var year = yearCombo.getValue();
			var projname = projCombo.getValue();
			var billcode = applyNo.getValue();

		itemGrid.load({params:{start:0,limit:25,year:year,projname:projname,billcode:billcode,userdr:userdr}});
	}
});

var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){
	addFun();
	}
	
});
var editButton = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改',        
    iconCls:'edit',
	handler:function(){
	EditFun(itemGrid);
	}
	
});
var queryPanel = new Ext.FormPanel({
	height : 90,
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
			value : '<center><p style="font-weight:bold;font-size:120%">项目资金申请</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [

		{
					xtype : 'displayfield',
					value : '立项年度:',
					columnWidth : .05
				}, yearCombo,

				{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '项目名称:',
					columnWidth : .05
				}, projCombo, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '申请单号:',
					columnWidth : .05
				}, applyNo

		]
	}]
});
function renderTopic(value, p, record){
	    return String.format(
	    		"<b><a href=\""+dhcbaUrl+"/runqianReport/report/jsp/dhccpmrunqianreport.jsp?projdr={1}&year={2}&report=HERPBUDGProjAdjDetail.raq&reportName=HERPBUDGProjAdjDetail.raq&ServerSideRedirect=dhccpmrunqianreport.csp\" >{0}</a></b>",
	            value, record.data.ProjDR,record.data.Year);
//下面这个东西是个数组，猜的，value是这个单元格的值，record是整个记录，record.data.Year可以获得记录的某一条的值通过如year={2}这样的东西传递{2}就是record.data.Year	            
}
var itemGrid = new dhc.herp.Grid({
			region : 'center',
			url : 'herp.budg.budgprojfundreqexe.csp',		
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用 
		                 if ((record.get('BillState') =="提交")&& (columnIndex == 3)) {
		                      return false;
		                 } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 预算项目公式编辑
						if ((record.get('BillState') =="提交") && (columnIndex == 3)) {						
							return false;
						} else {
							return true;
						}
					}
            },
			fields : [{
						header : 'ID',
						dataIndex : 'rowid',
						hidden : true
					},{
	                                                                                id : 'CompName',
	                                                                                header : '医疗单位',
                                                                                                width : 90,
	                                                                                editable : false,
                                                                                                dataIndex : 'CompName'

	                                                                    }, {
	 					id : 'submit',
						header : '选择',
						dataIndex : 'submit',
						width : 100,
						align:'center',
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['IsCurStep'];
						var cf = record.data['BillState'];
						var chk = record.data['ChkStep'];
						var no = record.data['StepNO'];
						var ifc = record.data['ifcancel'];	
						var iff = record.data['iffirst'];
						
						 return   '<span style="color:blue;cursor:hand"><BLINK id="submit" onclick=submitFun();>提交</BLINK></span>'+'<b> </b>'
							   	  +'<span style="color:blue;cursor:hand"><BLINK id="revocation" onclick=revocationFun();>撤销</BLINK></span>'+'<b> </b>'
							   	  +'<span style="color:blue;cursor:hand"><BLINK id="delete" onclick=deleteFun();>删除</BLINK></span>'+'<b> </b>' ;  
						},
						hidden : false

					}, {
						id : 'Year',
						header : '年度',
						width : 50,
						editable:false,
						dataIndex : 'Year'

					}, {
						id : 'Code',
						header : '申请单号',
						width : 120,
						editable:false,
						allowBlank : false,
						dataIndex : 'Code'

					},{
						id : 'Name',
						header : '项目名称',
						editable:false,
						width : 200,
						/*renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},*/
						dataIndex : 'Name',
						renderer : renderTopic

					}, {
						id : 'deptdr',
						header : '申请科室id',
						editable:false,
						width : 120,
						dataIndex : 'deptdr',
						hidden : true

					},{
						id : 'dname',
						header : '申请科室',
						editable:false,
						width : 120,
						dataIndex : 'dname'

					}, {
						id : 'ApplyerDR',
						header : '申请人id',
						editable : false,
						//align : 'center',
						width : 60,
						hidden : true,
						dataIndex : 'ApplyerDR'

					},{
						id : 'uName',
						header : '申请人',
						width : 100,
						editable:false,
						dataIndex : 'uName'

					}, {
						id : 'ApplyMoney',
						header : '申请额度',
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'ApplyMoney'
						
					},{
						id : 'ApplyDate',
						header : '申请时间',
						width : 80,
						editable : false,
						dataIndex : 'ApplyDate'
					},{
						id : 'BillState',
						header : '单据状态',
						width : 60,
						align : 'center',
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var cf = record.data['BillState']
						if (cf == "新建") {
							return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						} else if (cf == "提交"){
							return '<span style="color:brown;cursor:hand"><u>'+value+'</u></span>';
						}else {
							return '<span style="color:black;cursor:hand"><u>'+value+'</u></span>';
						}},
						dataIndex : 'BillState'

					},{
						id : 'Desc',
						header : '资金申请说明',
						width : 200,
						editable:false,
						//hidden:true,
						dataIndex : 'Desc'

					},{
						id : 'budgco',
						header : '预算结余',
						width : 120,
						editable:false,
						align:'right',
						dataIndex : 'budgco'

					},{
						id : 'budgcotrol',
						header : '预算控制',
						width : 60,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var cf = record.data['budgcotrol']
						if (cf == "超出预算") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'budgcotrol'

					},{
						id : 'FundTotal',
						header : '项目总预算',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'FundTotal'

					},{
						id : 'ReqMoney',
						header : '申请资金总额',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'ReqMoney'

					},{
						id : 'ActPayWait',
						header : '在途报销额',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'ActPayWait'

					},{
						id : 'ActPayMoney',
						header : '已执行预算',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'ActPayMoney'

					},{
						id : 'ProjDR',
						header : '项目ID',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'ProjDR'

					},{
						id : 'pdname',
						header : '项目科室',
						width : 60,
						editable:false,
						dataIndex : 'pdname'

					},{
						id : 'chkStepNO',
						header : '审批顺序号',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'chkStepNO'

					},{
						id : 'IsCurStep',
						header : '是否为当前审批',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'IsCurStep'

					},{
						id : 'ChkStep',
						header : '登录人步奏号',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'ChkStep'

					},{
						id : 'StepNO',
						header : '当前步奏号',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'StepNO'

					},{
						id : 'ifcancel',
						header : '能否撤销',
						width : 60,
						editable:false,
						hidden:true,
						dataIndex : 'ifcancel'

					},{
						id : 'iffirst',
						header : '是否第一人',
						width : 80,
						editable:false,
						hidden:true,
						dataIndex : 'iffirst'

					}],
					xtype : 'grid',
					loadMask : true,
					//viewConfig : {forceFit : true},
					tbar : ['-',findButton ,'-',addButton,'-',editButton]

		});

    itemGrid.btnAddHide();  //隐藏增加按钮
   	itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({params:{start:0, limit:12,userdr:userdr}});

// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	//alert(columnIndex);
	
	if (columnIndex == 6) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Name	 = records[0].get("Name");
		//detailFun(FundBillDR,Name);
		
	}
	
	if (columnIndex == 13) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var Code  		 = records[0].get("Code");
		var Name		 = records[0].get("Name");
		stateFun(FundBillDR,Code,Name);
	}


});


/////提交按钮//////
function submitFun(){
	var records = itemGrid.getSelectionModel().getSelections();
	var BillState=records[0].get("BillState");
	var IsCurStep = records[0].get("IsCurStep");
	var ChkStep=records[0].get("ChkStep");
	var chkStepNO=records[0].get("chkStepNO");
	//alert(chkStepNO);
	var StepNO = records[0].get("StepNO");
	var ifcancel  = records[0].get("ifcancel");
	var iffirst  = records[0].get("iffirst");
	//alert(ChkStep+"-"+StepNO+"-"+iffirst);
	if((BillState=="提交")||(BillState=="完成"))
	{
		Ext.Msg.show({
						title : '注意',
						msg : '数据已提交不能重复提交!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	}
	else if((chkStepNO!=1)&&((StepNO!="")||(StepNO==""))&&((IsCurStep!="")||(IsCurStep=="")))
	{
		
		Ext.Msg.show({
						title : '',
						msg : '不是权限指定的提交人！',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
		return;
	}
	Ext.MessageBox.confirm('提示', '确定要提交选定的项目吗？', function(btn) {
			if (btn == 'yes') {
				var rowid = records[0].get("rowid")
				var surl = projUrl+'?action=submit&rowid='+ rowid+'&userdr='+userdr;
				//itemGrid.saveurl(surl)
				Ext.Ajax.request({
					url: surl,
					waitMsg:'提交中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var apllycode = jsonData.info;
							Ext.Msg.show({title:'注意',msg:'提交成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
							//ApplBillCodeField.setValue(apllycode);
							itemGrid.load({params:{start:0, limit:12,userdr:userdr}});	
						}else
						{
							var message="";
							if(jsonData.info=='Nocheck') message='项目预算的审批流未建!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
				
				
			}
		});
}
 
///////撤销按钮////////
function revocationFun(){
	var records = itemGrid.getSelectionModel().getSelections();
	var BillState=records[0].get("BillState");
	var ifcancel  = records[0].data['ifcancel'];
	var chkStepNO=records[0].get("chkStepNO");
	//alert(ifcancel);
	if(BillState=="新建")
	{
		Ext.Msg.show({
						title : '注意',
						msg : '本条数据未提交  无需撤销!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	}
	else if(BillState=="撤销")
	{
		Ext.Msg.show({
						title : '注意',
						msg : '本申请已撤销  无需再次撤销!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	}else if(BillState=="完成")
	{
		Ext.Msg.show({
						title : '注意',
						msg : '本申请已审核  不能撤销!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
    } else if((ifcancel=="否")||(chkStepNO!=1)){
	      
		Ext.Msg.show({
						title : '注意',
						msg : '不具有撤销权限!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	        }    
	Ext.MessageBox.confirm('提示', '请确认是否撤销', function(btn){
		if(btn=='yes')
		{	
			var rowid=records[0].get("rowid");	
			//alert(rowid);	
			Ext.Ajax.request({
						url : projUrl + '?action=revocation&rowid='+rowid+'&userdr='+userdr,
						waitMsg : '撤销中...',
						failure : function(result, request) {
								Ext.Msg.show({
											title : '错误',
											msg : '请检查网络连接!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
								},
						success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
										Ext.MessageBox.alert('提示','撤销完成');
										itemGrid.load({params:{start:0,limit:25}});
								} else {
										var message = "SQLErr: "+ jsonData.info;
										Ext.Msg.show({
													title : '错误',
													msg : message,
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
													});
										}
								},
										scope : this
							});
					
			
			}

		})
		
	}

//////////删除按钮///////////
function deleteFun()
{
	var records = itemGrid.getSelectionModel().getSelections();
		
	var BillState=records[0].get("BillState");
	var ChkStep	=records[0].data['ChkStep'];
	var StepNO 	= records[0].data['StepNO'];
    var ifcancel  = records[0].data['ifcancel'];
    var iffirst  = records[0].data['iffirst'];
    var chkStepNO=records[0].get("chkStepNO");
    //alert(BillState+"^"+ChkStep+"^"+StepNO+"^"+ifcancel+"^"+iffirst+"^"+chkStepNO);
	if((BillState=="提交")||(BillState=="完成"))
	{
		Ext.Msg.show({
						title : '注意',
						msg : '已提交或完成的数据不能删除!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	}
	Ext.MessageBox.confirm('提示', '是否删除选中数据？', function(btn){
		if(btn=='yes')
		{	
			var rowid=records[0].get("rowid");	
			//alert(rowid);	
			Ext.Ajax.request({
						url : projUrl + '?action=delete&rowid='+rowid,
						waitMsg : '删除中...',
						failure : function(result, request) {
								Ext.Msg.show({
											title : '错误',
											msg : '请检查网络连接!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
											});
								},
						success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
										Ext.MessageBox.alert('提示','删除成功');
										itemGrid.load({params:{start:0,limit:25}});
								} else {
										var message = "SQLErr: "+ jsonData.info;
										Ext.Msg.show({
													title : '错误',
													msg : message,
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
													});
										}
								},
										scope : this
							});
					
			
			}

		})
	
}