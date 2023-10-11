/**按钮权限说明
*提交、删除、附件：只有新建状态的单子可用
*撤销：
*	1.单据不是新建状态、
*	2.分状态
*		①单据刚提交、还未开始审核
*			本人和对应审核权限人可操作
*		②单据状态提交、还未审核结束
*			顺序号≧当前顺序号的人权限人可撤销
*	
**/
var userdr = session['LOGON.USERID'];
var commonboxUrl = 'herp.budg.budgcommoncomboxexe.csp';
var projUrl = 'herp.budg.budgfundapplyexe.csp';
////////////申请年月//////////////////////
var yearmonDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['year', 'year'])
		});

yearmonDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : commonboxUrl+'?action=year&flag=1',
						method : 'POST'
					});
		});

var yearmonField = new Ext.form.ComboBox({
			fieldLabel : '申请年月',
			store : yearmonDs,
			displayField : 'year',
			valueField : 'year',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择年月...',
			width : 100,
			listWidth : 220,
			pageSize : 12,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
///////////////// 申请单号 //////////////
var billcodeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['billcode', 'billcode'])
		});

billcodeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=getbillcode'+'&userdr='+userdr,
						method : 'POST'
					});
		});

var billcodeField = new Ext.form.ComboBox({
			fieldLabel : '申请单号',
			store : billcodeDs,
			displayField : 'billcode',
			valueField : 'billcode',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择单号...',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
/////////////////添加按钮////////////////////////////
var addButton = new Ext.Toolbar.Button({
	text: '添加',
    tooltip:'添加',        
    iconCls:'option',
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
	
	if(BillState!=="新建"){
	         Ext.Msg.show({title:'注意',msg:"单据已提交或审核，不能上传！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});		
        	return;
    }
	    var len = selectedRow.length;
        var message="请选择对应的单据！";  
        if(len < 1){
            Ext.Msg.show({title:'提示',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
            return false;
        }else{
            var rowid = selectedRow[0].get('rowid');
       		
            var dialog = new Ext.ux.UploadDialog.Dialog({
            url: 'herp.budg.budgfundapplyexe.csp?action=Upload&rowid='+rowid,
            reset_on_hide: false, 
            permitted_extensions:['gif','jpeg','jpg','png','bmp'],
            allow_close_on_upload: true,
            upload_autostart: false,
            title:'上传单据信息图片'
            //post_var_name: 'file'
      });
      dialog.show();
     
        }
}

/////////////////提交按钮////////////////////////////
function submitFun()
{
	var records = itemGrid.getSelectionModel().getSelections();
		
	var BillState=records[0].get("BillState");
	if((BillState=="提交")||(BillState=="完成"))
	{
		Ext.Msg.show({title:'注意',msg:'单据已结束或已提交，不允许提交!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
									Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
								},
						success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.show({title : '提示',msg : '提交完成',buttons : Ext.Msg.OK,icon : Ext.MessageBox.OK});
									itemGrid.load({params:{start:0,limit:25}});
								} else {
									var message = "SQLErr: "+ jsonData.info;
									Ext.Msg.show({title : '错误',msg : message,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
									}
								},scope : this
							});
			}
		})
}

/////////////////删除//////////////
function deleteFun()
{
	var records = itemGrid.getSelectionModel().getSelections();	
	var BillState=records[0].get("BillState");
	if(BillState!=="新建")
         {
         Ext.Msg.show({title:'注意',msg:"申请单已提交或审核，不允许删除！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});		
        	return;
         }
         else
         {
			Ext.MessageBox.confirm('提示', '请确定是否删除', function(btn){
				if(btn=='yes')
					{	
						var sig=0;
						Ext.MessageBox.confirm('提示', '是否级联删除明细表信息', function(btn){
							if (btn=='yes')
							{
				   				sig=1;	 //  标记是否级联删除明细表
							}
							var rowid=records[0].get("rowid");	
							//alert(rowid);	
							Ext.Ajax.request({
								url : projUrl + '?action=delete&rowid='+rowid+'&sig='+sig,
								waitMsg : '删除中...',
								failure : function(result, request) {
									Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.MessageBox.alert('提示','删除完成');
										itemGrid.load({params:{start:0,limit:25}});
									} else {
										var message = "SQLErr: "+ jsonData.info;
										Ext.Msg.show({title : '错误',msg : message,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
										}
								},scope : this
							});
						})
				}		
			})	
		}
}

/////////////////撤销////////////////////////////
function revocationFun()
{
	var records = itemGrid.getSelectionModel().getSelections();
	
	var sOver		=records[0].get("sOver");
	var billstate 	=records[0].get("BillState");
    var ChkSatte   	=records[0].get("ChkSatte");
    var CurStepNO 	=records[0].get("CurStepNO");  
    var StepNO 		=records[0].get("StepNO"); 
        //alert(billstate);
        if(billstate=="新建"){
	       	Ext.Msg.show({title:'注意',msg:"申请单未提交,不能撤销！",buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});		
        	return;
	    }
        else if(((billstate=="提交")&&(ChkSatte==""))||((StepNO>=CurStepNO)&&((StepNO!=="")&&(CurStepNO!==""))))
        {
	       Ext.MessageBox.confirm('提示', '请确认是否撤销', function(btn){
			if(btn=='yes')
			{	
				var rowid=records[0].get("rowid");	
				//alert(rowid);	
				Ext.Ajax.request({
						url : projUrl + '?action=revocation&rowid='+rowid+'&userdr='+userdr,
						waitMsg : '撤销中...',
						failure : function(result, request) {
								Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
								},
						success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
										Ext.MessageBox.alert('提示','撤销完成');
										itemGrid.load({params:{start:0,limit:25}});
								} else {
										var message = "SQLErr: "+ jsonData.info;
										Ext.Msg.show({title : '错误',msg : message,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
										}
								},scope : this
							});
				}
			})
        }else
        {
	        Ext.Msg.show({title:'注意',msg:'不是当前权限人!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
	        return;
        }
}

/////////////////查询按钮响应函数//////////////
function budgFundApply()
{
	var yearmonth=yearmonField.getValue();
	var billcode = billcodeField.getValue();
	itemGrid.load({params:{start:0,limit:25,yearmonth:yearmonth,billcode:billcode}});
	
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
				columnWidth:.03
				},
				{
					xtype : 'displayfield',
					value : '申请单号:',
					columnWidth : .05
				}, billcodeField,
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
						var bs = record.data['BillState'];
						var cs = record.data['ChkSatte'];
						var curno = record.data['CurStepNO'];
						var no = record.data['StepNO'];
											
						if(bs=="新建"){
							return '<span style="color:blue;cursor:hand"><BLINK id="submit" onclick=submitFun();> 提交 </BLINK></span>'+'<b> </b>'
							+'<span style="color:gray;cursor:hand"><BLINK id="revocation" onclick=revocationFun();> 撤销 </BLINK></span>'+'<b> </b>'
							+'<span style="color:blue;cursor:hand"><BLINK id="delete"  onclick=deleteFun();> 删除 </BLINK></span>'+'<b> </b>' 
							+'<span style="color:blue;cursor:hand"><BLINK id="accessory" onclick=accessoryFun();> 附件 </BLINK></span>'+'<b> </b>'
							+'<span style="color:blue;cursor:hand"><u id="revocation" onclick=EditFun(itemGrid);>修改  </u></span>';  
						}else if((bs=="提交")&&(cs=="")){
							return '<span style="color:gray;cursor:hand"><BLINK id="submit" onclick=submitFun();> 提交 </BLINK></span>'+'<b> </b>'
							+'<span style="color:blue;cursor:hand"><BLINK id="revocation" onclick=revocationFun();> 撤销 </BLINK></span>'+'<b> </b>'
							+'<span style="color:gray;cursor:hand"><BLINK id="delete" onclick=deleteFun();> 删除 </BLINK></span>'+'<b> </b>' 
							+'<span style="color:gray;cursor:hand"><BLINK id="accessory" onclick=accessoryFun();> 附件 </BLINK></span>'+'<b> </b>'
							+'<span style="color:blue;cursor:hand"><u id="revocation" onclick=EditFun(itemGrid);>修改  </u></span>';  
						}else {
							//alert(no+"----"+curno);
							if((no>=curno)&&((no!=="")&&(curno!==""))){
								return '<span style="color:gray;cursor:hand"><BLINK id="submit" onclick=submitFun();> 提交 </BLINK></span>'+'<b> </b>'
								+'<span style="color:blue;cursor:hand"><BLINK id="revocation" onclick=revocationFun();> 撤销 </BLINK></span>'+'<b> </b>'
								+'<span style="color:gray;cursor:hand"><BLINK id="delete" onclick=deleteFun();> 删除 </BLINK></span>'+'<b> </b>' 
								+'<span style="color:gray;cursor:hand"><BLINK id="accessory" onclick=accessoryFun();> 附件 </BLINK></span>'+'<b> </b>'
								+'<span style="color:blue;cursor:hand"><u id="revocation" onclick=EditFun(itemGrid);>修改  </u></span>';  
							}else {
								return '<span style="color:gray;cursor:hand"><BLINK id="submit" onclick=submitFun();> 提交 </BLINK></span>'+'<b> </b>'
								+'<span style="color:gray;cursor:hand"><BLINK id="revocation" onclick=revocationFun();> 撤销 </BLINK></span>'+'<b> </b>'
								+'<span style="color:gray;cursor:hand"><BLINK id="delete" onclick=deleteFun();> 删除 </BLINK></span>'+'<b> </b>' 
								+'<span style="color:gray;cursor:hand"><BLINK id="accessory" onclick=accessoryFun();> 附件 </BLINK></span>'+'<b> </b>'
								+'<span style="color:blue;cursor:hand"><u id="revocation" onclick=EditFun(itemGrid);>修改  </u></span>';  
							}
						}
						}
					},{
						id : 'filedesc',
						header : '附件',
						editable:false,
						width : 120,
						dataIndex : 'filedesc',
						hidden:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
			 			}
					},{
						id : 'CompName',
						header : '医疗单位',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'CompName'
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
						header : '审核过程',
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
					},  {
						id : 'ChkSatte',
						header : '审核状态',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'ChkSatte'
					}, {
						id : 'CurStepNO',
						header : '当前审批号',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'CurStepNO'
					}, {
						id : 'StepNO',
						header : '登录人顺序号',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'StepNO'
					}, {
						id : 'UserDR',
						header : '申请人ID',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'UserDR'
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
	if (columnIndex == 12) {
		var records = itemGrid.getSelectionModel().getSelections();
		var FundBillDR   = records[0].get("rowid");
		var BillCode  	 = records[0].get("BillCode");
		var dName		 = records[0].get("dName");
		stateFun(FundBillDR,BillCode,dName);
	}
	//alert(columnIndex);	
		//附件图片的显示
	if (columnIndex == 3) {

		var records = itemGrid.getSelectionModel().getSelections();
		var rowid   = records[0].get("rowid");
		projuploadFun(rowid);
		
	}		
});


