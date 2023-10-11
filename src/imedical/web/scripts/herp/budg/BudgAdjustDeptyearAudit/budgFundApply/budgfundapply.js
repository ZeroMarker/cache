var userdr = session['LOGON.USERID'];

var projUrl = 'herp.budg.budgfundapplyexe.csp';
////////////申请年月//////////////////////
var yearmonDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['yearmonth', 'yearmonth'])
		});

yearmonDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=yearmonthlist',
						method : 'POST'
					});
		});

var yearmonField = new Ext.form.ComboBox({
			fieldLabel : '申请年月',
			store : yearmonDs,
			displayField : 'yearmonth',
			valueField : 'yearmonth',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择年月...',
			width : 100,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
/////////////////添加按钮////////////////////////////
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){
	AddFun(itemGrid);			//调用申请单据管理界面
	}
	
});

var modificationButton = new Ext.Toolbar.Button({
	text: '修改',
    tooltip:'修改',        
    iconCls:'add',
	handler:function(){	
		EditFun(itemGrid);		//调用申请单据管理界面
	}
	
});


/////////////////附件////////////////////////////
function accessoryFun()
{
	var selectedRow = itemGrid.getSelectionModel().getSelections();
		
	var BillState=selectedRow[0].data['BillState'];
	var rowid = selectedRow[0].data['rowid'];
	
	if((BillState=="提交")||(BillState=="完成"))
	{
		Ext.Msg.show({
						title : '注意',
						msg : '本条数据已提交  不能上传附件!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
		//alert("调用预览功能");			
		/////////////////调用预览功能////////////////////////			
		return;
	}
	
	var fileName = new Ext.form.TextField({
			xtype: 'textfield',
            fieldLabel: '文件名',
            name: 'userfile',
            inputType: 'file',
            allowBlank: false,
            blankText: '文件不能为空.',
            anchor: '90%'  // anchor width by percentage

		});
	
	var form = new Ext.form.FormPanel({
        baseCls: 'x-plain',
        labelWidth: 80,
        //url:'upload.php',
        fileUpload:true,
        defaultType: 'textfield',

        items: [ fileName ]
    });
    
    var upLaodButton = new Ext.Toolbar.Button({
		text: '上传',
        handler: function() {
              if(form.form.isValid()){
                   Ext.MessageBox.show({
                       title: '请稍等',
                       msg: '上传中...',
                       progressText: '',
                       width:300,
                       progress:true,
                       closable:false,
                        animEl: 'loding'
                       });
                       
               var filename = "\""+fileName.getValue()+"\"";
					
               form.getForm().submit({
	                url:projUrl + '?action=upload'+'&rowid'+rowid+'&filename'+filename, 
	                method:'POST', 
	                //params:rowid,filename,
                    success: function(form, action){
                        Ext.Msg.alert(filename+'上传成功',action.result.msg);
                        win.hide();  
                        },    
                    failure: function(){
	                    Ext.Msg.alert('错误', '文件'+filename+'上传失败.');    
                       }
                    })               
                }
           }
	})
        
    var win = new Ext.Window({
        title: '上传附件',
        width: 400,
        height:200,
        minWidth: 300,
        minHeight: 100,
        layout: 'fit',
        plain:true,
        bodyStyle:'padding:5px;',
        buttonAlign:'center',
        items: form,

        buttons: [upLaodButton,
        {
            text: '取消上传',
            handler:function(){win.hide();}
        }]
    });
    win.show();
}

/////////////////提交按钮////////////////////////////
function submitFun()
{
	var records = itemGrid.getSelectionModel().getSelections();
		
	var BillState=records[0].get("BillState");
	if((BillState=="提交")||(BillState=="完成"))
	{
		Ext.Msg.show({
						title : '注意',
						msg : '本条数据已提交  无需再次提交!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	}

	Ext.MessageBox.confirm('提示', '提交后的数据只能撤销 不可再编辑  请确定是否提交', function(btn){
		if(btn=='yes')
		{	
			var rowid=records[0].get("rowid");	
			//alert(rowid);
	
			Ext.Ajax.request({
						url : projUrl + '?action=submit&rowid='+rowid,
						waitMsg : '提交中...',
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
										Ext.MessageBox.alert('提示','提交完成');
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

/////////////////删除//////////////
function deleteFun()
{
	
	var records = itemGrid.getSelectionModel().getSelections();
		
	var BillState=records[0].get("BillState");
	if((BillState=="提交")||(BillState=="完成"))
	{
		Ext.Msg.show({
						title : '注意',
						msg : '已提交的数据不能删除!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	}
	
	Ext.MessageBox.confirm('提示', '请确定是否删除', function(btn){
		if(btn=='yes')
		{	
			var sig=0;
			Ext.MessageBox.confirm('提示', '是否级联删除明细表信息', function(btn){
				if (btn=='yes')
				{
				   sig=1;	 //  标记是否级联删除明细表
				}			
			
			//alert(sig);
			var rowid=records[0].get("rowid");	
			//alert(rowid);	
			Ext.Ajax.request({
						url : projUrl + '?action=delete&rowid='+rowid+'&sig='+sig,
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
										Ext.MessageBox.alert('提示','删除完成');
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
					
				})
			}
		
		
		})	

}

/////////////////撤销////////////////////////////
function revocationFun()
{
	var records = itemGrid.getSelectionModel().getSelections();
	
	var sOver=records[0].get("sOver");
	if(sOver=="完成")
	{
		Ext.Msg.show({
						title : '注意',
						msg : '本条单据已结束  不能撤销!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
	}
	
	var BillState=records[0].get("BillState");
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

/////////////////查询按钮响应函数//////////////
function budgFundApply()
{
	var yearmonth=yearmonField.getValue();
	
	itemGrid.load({params:{start:0,limit:25,yearmonth:yearmonth}});
	
}

//////////////////////////////////////////////
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
			value : '<center><p style="font-weight:bold;font-size:120%">借款管理</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
					xtype : 'displayfield',
					value : '申请年月:',
					columnWidth : .05
				}, yearmonField,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.05
				},{
				columnWidth:0.05,
				xtype:'button',
				text: '查询',
				handler:function(b){budgFundApply();},
				iconCls: 'add'
				}]
	}]
	
});

var itemGrid = new dhc.herp.Grid({
			region : 'center',
			url : 'herp.budg.budgfundapplyexe.csp',		
			listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用 
		                 if ((record.get('ChkStep') =="提交")&& (columnIndex == 2)) {
		                      return false;
		                 } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 预算项目公式编辑
						if ((record.get('ChkStep') =="提交") && (columnIndex == 2)) {						
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
						header : '选择',
						width:180,
						hidden : false,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store)
						{ 
							return '<span style="color:blue;cursor:hand"><BLINK id="submit"     onclick=submitFun();>      提交  </BLINK></span>'+'<b> </b>'
							   	  +'<span style="color:blue;cursor:hand"><BLINK id="revocation" onclick=revocationFun();>  撤销  </BLINK></span>'+'<b> </b>'
							   	  +'<span style="color:blue;cursor:hand"><BLINK id="delete"     onclick=deleteFun();>       删除  </BLINK></span>'+'<b> </b>' 
							   	  +'<span style="color:blue;cursor:hand"><BLINK id="accessory" 	onclick=accessoryFun();>   附件  </BLINK></span>'+'<b> </b>' 
							   	  +'<span style="color:blue;cursor:hand"><u id="revocation"     onclick=EditFun(itemGrid);>修改  </u></span>';  
						}
					},{
						id : 'YearMonth',
						header : '年月',
						width : 50,
						editable:false,
						dataIndex : 'YearMonth'
					}, {
						id : 'BillCode',
						header : '申请单号',
						width : 120,
						editable:false,
						allowBlank : false,
						dataIndex : 'BillCode'

					},{
						id : 'dName',
						header : '申请科室',
						editable:false,
						width : 120,
						dataIndex : 'dName'
					},{
						id : 'uName',
						header : '申请人',
						width : 100,
						editable:false,
						dataIndex : 'uName'

					}, {
						id : 'ReqPay',
						header : '申请额度',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'ReqPay'
					}, {
						id : 'ReqPayRes',
						header : '审批额度',
						//xtype:'numbercolumn',
						width : 120,
						editable : false,
						align:'right',
						dataIndex : 'ReqPayRes'
					},{
						id : 'BillDate',
						header : '申请时间',
						width : 80,
						editable : false,
						dataIndex : 'BillDate'
					},{
						id : 'BillState',
						header : '单据状态',
						width : 60,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['BillState']
						if (sf == "新建") {
							return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand"><u>'+value+'</u></span>';
						}},
						dataIndex : 'BillState'

					},{
						id : 'Desc',
						header : '资金申请说明',
						width : 200,
						editable:false,
						dataIndex : 'Desc'

					},{
						id : 'BudgBal',
						header : '审批后结余',
						//xtype:'numbercolumn',
						width : 120,
						editable:false,
						align:'right',
						dataIndex : 'BudgBal'

					},{
						id : 'budgcotrol',
						header : '预算控制',
						width : 60,
						editable:false,
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['budgcotrol']
						if (sf == "超出预算") {
							return '<span style="color:red;cursor:hand;">'+value+'</span>';
						} else {
							return '<span style="color:black;cursor:hand">'+value+'</span>';
						}},
						dataIndex : 'budgcotrol'

					},{
						id : 'sOver',
						header : '审核状态',
						width : 80,
						editable:false,
						dataIndex : 'sOver',
						hidden:true
					},{
						id : 'deptID',
						header : '申请科室ID',
						editable:false,
						width : 60,
						hidden:true,
						dataIndex : 'deptID'
					},{
						id : 'CheckDR',
						header : '审批流名称',
						editable:false,
						width : 100,
						dataIndex : 'CheckDR'
					},{
						id : 'Checkid',
						header : '审批流ID',
						editable:false,
						width : 100,
						hidden:true,
						dataIndex : 'Checkid'
					}, {
						id : 'audname',
						header : '归口科室',
						editable:false,
						width : 120,
						dataIndex : 'audname',
						hidden:false
					}, {
						id : 'audeprdr',
						header : '归口科室dr',
						editable:false,
						width : 120,
						dataIndex : 'audeprdr',
						hidden:true
					}],
					xtype : 'grid',
					loadMask : true,
					tbar : [addButton] 

		});

    itemGrid.btnAddHide();     //隐藏增加按钮
   	itemGrid.btnSaveHide();    //隐藏保存按钮
    itemGrid.btnResetHide();   //隐藏重置按钮
    itemGrid.btnDeleteHide();  //隐藏删除按钮
    itemGrid.btnPrintHide();   //隐藏打印按钮

itemGrid.load({params:{start:0, limit:12, userdr:userdr}});


// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

	//  单据状态
	if (columnIndex == 10) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var BillCode  		 = records[0].get("BillCode");
		var dName		 = records[0].get("dName");
		stateFun(FundBillDR,BillCode,dName);
	}
		
});


