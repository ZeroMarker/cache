AddFun = function(itemDetail,projDr,projName,userid,Username,deptdr,deptname,year){

//itemDetail,Username,userid,FundBillDR,projDr,Name,deptdr,deptname,ApplBillCode,year
var statetitle = projName +"支出申请";

/////////////报销单号////////////////
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			disabled: true,
			selectOnFocus : true
		});

/////////////////////项目名称/////////////////////////
var projnameCombo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: projName,
			disabled: true,
			selectOnFocus : true
		});
/*
/////////////////////申请人/////////////////////////
var appuName = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: Username,
			disabled: true,
			selectOnFocus : true
		});*/
///////////////报销人////////////////////////
var appuDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

appuDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.expenseaccountdetailexe.csp?action=userlist',
						method : 'POST'
					});
		});

var appuName = new Ext.form.ComboBox({
			fieldLabel : '申请人',
			store : appuDs,
			displayField : 'name',
			valueField : 'rowid',
			//typeAhead : true,			//系统自动选择第一项
			forceSelection:'true',
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true,
			disabled:true	//不允许编辑
		});		
 //默认登录人 
 appuName.setValue(session['LOGON.USERCODE']+'-'+session['LOGON.USERNAME']);
/////////////////////报销说明/////////////////////////
 Descfield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			selectOnFocus : true

		});		
/*

/////////////////////申请科室/////////////////////////
var dnamefield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: deptname,
			disabled: true,
			selectOnFocus : true

		});
		*/
///////////////科室名称////////////////////////
var dnameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

dnameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgprojclaimapplyaddexe.csp?action=getdept&userdr='+session['LOGON.USERID'],
						method : 'POST'
					});
		});

var dnamefield = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : dnameDs,
			displayField : 'name',
			valueField : 'rowid',
			//typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true
		});		
/////////////资金申请单//////////// 
var applyDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'namedesc'])
});

applyDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgprojclaimapplynos.csp?action=billcode&projDr='+projDr,
				method : 'POST'
			});
});

 applyCombo = new Ext.form.ComboBox({
	fieldLabel : '资金申请单',
	store : applyDs,
	displayField : 'namedesc',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 90,
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true
});


///////////////////////////////////////////////////////
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
			value : '<center><p style="font-weight:bold;font-size:120%">项目支出申请</p></center>',
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
					value : '报销单号:',
					columnWidth : .12
				}, applyNo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '项目名称:',
					columnWidth : .12
				},projnameCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '申请人:',
					columnWidth : .12
				}, appuName

		]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '报销说明:',
					columnWidth : .12
				}, Descfield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '申请科室:',
					columnWidth : .12
				},dnamefield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}/*, {
					xtype : 'displayfield',
					value : '资金申请单:',
					columnWidth : .12
				}, applyCombo */

		]
	}]
});

var del = function() {

	Ext.Ajax.request({
		url: '../csp/herp.budg.budgprojclaimapplyaddexe.csp?action=Del',
				waitMsg : '处理中...',
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
					}
				},
				scope : this
			});
}


///////////////////// 当前预算结余 ///////////////////////////
var budgbalanceDs = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['name', 'name'])
});

budgbalanceDs.on('beforeload', function(ds, o){
	var code=codeCombo.getValue();	
	if(!code)
	{
		Ext.Msg.show({title:'注意',msg:'请先选择预算项',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}	
});

var budgbalanceCombo = new Ext.form.ComboBox({
	fieldLabel : '当前预算结余',
	store : budgbalanceDs,
	displayField : 'name',
	valueField : 'name',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 70,
	listWidth : 225,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});

///////////////// 预算项 /////////////////
var codeDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['code', 'name'])
});

codeDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgprojclaimapplynos.csp?action=itemcode&projDr='+projDr,
				method : 'POST'
			});
});

 codeCombo = new Ext.form.ComboBox({
	fieldLabel : '预算项',
	store : codeDs,
	displayField : 'name',
	valueField : 'code',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 50,
	listWidth : 225,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true,
	listeners:{
            "select":function(combo,record,index){
	            budgbalanceDs.removeAll();     
							budgbalanceCombo.setValue('');
							budgbalanceDs.proxy = new Ext.data.HttpProxy({url:'herp.budg.budgprojclaimapplynos.csp?action=budgbalance&itemcode='+combo.value+'&projDr='+projDr+'&year='+year,method:'POST'})  
							budgbalanceDs.load({params:{start:0,limit:10}});           					
				}
	}
});

////////// 本次报销申请 数据录入 ///////////////////
var valueField = new Ext.form.TextField({
	id: 'valueField',
	width:215,
	listWidth : 215,
	name: 'valueField',
	regex : /^(-?\d+)(\.\d+)?$/,
	regexText : "只能输入数字",
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////添加按钮////////////////////////////
var saveButton = new Ext.Toolbar.Button({
	text: '保存',
  tooltip:'添加',        
  iconCls: 'save',
	handler:function(){
	if(Descfield.getValue()=="")
			{
				Ext.Msg.show({
						title : '注意',
						msg : '请输入报销说明',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
			}
			
			/*if(applyCombo.getValue()=="")
			{
				Ext.Msg.show({
						title : '注意',
						msg : '请先选择您所需要报销的资金申请单!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
			}*/
			
	AddFun1();			//调用申请单据管理界面
	}
	
});

/////////////// 项目支出明细表 //////////////////////////
var adddetailGrid = new dhc.herp.Gridapplyadddetail({
				width : 600,
				height : 150,
				region : 'south',
				url : 'herp.budg.budgprojclaimapplyaddexe.csp',				
				fields : [
						{
							header : '支出明细ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'itemcode',
							header : '预算项(编码)',
							dataIndex : 'itemcode',
							width : 60,
							editable:true,
							hidden : true
						},{
							id : 'Name',
							header : '预算项',
							dataIndex : 'Name',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							width: 120,
							allowBlank: true,
							editable:true,
							type:codeCombo
						},{
							id : 'budgreal',
							header : '当前预算结余',
							dataIndex : 'budgreal',
							align:'right',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							width: 120,
							editable:true,
							type:budgbalanceCombo
						},{
							id : 'reqpay',
							header : '本次报销申请',
							dataIndex : 'reqpay',
							align:'right',
							width : 120,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							editable:true,
							type:valueField
						},{
							id : 'actpay',
							header : '审批支付',
							align:'right',
							dataIndex : 'actpay',
							width : 120,
							editable:false
						},{
							id : 'ddesc',
							header : '说明',
							dataIndex : 'ddesc',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
								cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
								return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
								},
							width : 220,
							editable:true
						},{
							id : 'budgco',
							header : '执后预算结余',
							dataIndex : 'budgco',
							align:'right',
							width : 120,
							editable:false
						},{
							id : 'budgcotrol',
							header : '预算控制',
							dataIndex : 'budgcotrol',
							width : 100,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['budgcotrol']
							if (sf == "超出预算") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
							editable:false
						},{
							id : 'supplier',
							header : '供应商(按发票全称填写)',
							dataIndex : 'supplier',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
								cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
								return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
								},
							width : 220,
							editable:true
						}],
						loadMask : true
			});

adddetailGrid.btnSaveHide();
adddetailGrid.addButton(saveButton);
 

var addmainGrid = new dhc.herp.GridapplyaddMain({
				width : 600,
				region : 'center',
				url : 'herp.budg.budgprojclaimapplyaddexe.csp',
				fields : [
				{
							header : '支出单据主表ID',
							width : 100,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'budgtotal',
							header : '项目总预算',
							dataIndex : 'budgtotal',
							width : 120,
							align:'right',
							editable:false
						},{
							id : 'reppay',
							header : '申请资金',
							dataIndex : 'reppay',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'actpaywait',
							header : '在途报销',
							dataIndex : 'actpaywait',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'actpay',
							header : '已执行预算',
							dataIndex : 'actpay',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgcur',
							header : '当前预算结余',
							dataIndex : 'budgcur',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'actpaycur',
							header : '本次报销',
							dataIndex : 'actpaycur',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgco',
							header : '执行后预算结余',
							dataIndex : 'budgco',
							align:'right',
							width : 120,
							editable:false

						},{
							id : 'budgcontrol',
							header : '预算控制',
							dataIndex : 'budgcontrol',
							width : 100,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['budgcontrol']
							if (sf == "超出预算") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
							editable:false

						},{
							id : 'FundBillDR',
							header : '报销单对应的资金申请单ID',
							dataIndex : 'FundBillDR',
							align:'right',
							width : 120,
							editable:false,
							hidden : true

						}],
						viewConfig : {forceFit : true}
			}
);
	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function(){ 
	  itemDetail.load({params:{start:0, limit:12,userid:userid,projdr:projDr}});
	  window.close();
	};

	// 添加取消按钮的监听事件
	cancelButton.addListener('click',cancelHandler, false);
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [queryPanel,addmainGrid,adddetailGrid]
			});

	var tabPanel =  new Ext.Panel({
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,addmainGrid,adddetailGrid]                                 //添加Tabs
  });
	
	var window = new Ext.Window({
				layout : 'fit',
				title : statetitle,
				plain : true,
				width : 950,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]

			});
	
	//adddetailGrid.setUrlParam({No:applyNo.getValue()});
	
	
	
	window.show();	
	//window.on('beforeclose',del);
	
	
	AddFun1=function() {
		var records=adddetailGrid.store.getModifiedRecords();
		var o = {};
	    var tmpDate = adddetailGrid.dateFields;
	    var tmpstro = "";
	    var tmpstros="";
	    var data = [];
	    var rtn = 0;
	    var datad="";
	    Ext.MessageBox.confirm('提示', '请确定是否保存？', function(btn) {
			if(btn=="yes")
			{
			var length = addmainGrid.getStore().getCount();

			var rowidm="";
			var oldfundbilldr=""
			var datam="";
			var deptdr = dnamefield.getValue();
			var userdr = session['LOGON.USERID']; //appuName.getValue();系统默认登陆人信息
			if(length!=0)
			{
				addmainGrid.getStore().each(function(rec){
								rowidm=rec.get('rowid'); // 项目支出主表ID
								oldfundbilldr=rec.get('FundBillDR');				
							})
				datam='&rowidm='+rowidm+'&mdesc='+encodeURIComponent(Descfield.getValue())+'&fundbilldr='+applyCombo.getValue()+'&oldfundbilldr='+oldfundbilldr;				
			}
			else
			{
				datam='&deptdr='+deptdr+'&userdr='+userdr+'&projdr='+projDr+'&mdesc='+encodeURIComponent(Descfield.getValue())+'&fundbilldr='+applyCombo.getValue();					
			}
			
	    	Ext.Ajax.request({  
				url: 'herp.budg.budgprojclaimapplyaddexe.csp?action=Add1'+datam,
				waitMsg : '处理中...',
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
						applyNo.setValue(jsonData.info);	
	    
			Ext.each(records, function(r) {
			var o = {};
			var tmpstro = "";
			var deleteFlag = r.data['delFlag'];// 删除标识，1：是该记录已经删除，0：未删除。

			// 数据完整性验证Beging
			for (var i = 0; i < adddetailGrid.fields.length; i++) {
				var indx = adddetailGrid.getColumnModel().getColumnId(i + 1)
				var tmobj = adddetailGrid.getColumnModel().getColumnById(indx)
				if (tmobj != null) {
					// 列增加update属性，true：该列数据没有变化也向后台提交数据，false：则不会强制提交数据
					var reValue = r.data[indx];
					if ((typeof(reValue) != "undefined") && (tmobj.update)) {
						tmpstro += "&" + indx + "=" + r.data[indx].toString();
					}
					if (tmobj.allowBlank == false) {
						var title = tmobj.header
						if ((r.data[indx].toString() == "")|| (parseInt(r.data[indx].toString()) == 0)) {
							var info = "[" + title + "]列为必填项，不能为空或零！"
							Ext.Msg.show({
										title : '错误',
										msg : info,
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							rtn = -1;
							return -1;

						}
					}
				}

			}
			// 数据完整性验证END

			if (r.isValid()) {
				if (deleteFlag == "-1") {
					return;
				}
			
			} else {
				Ext.Msg.show({
							title : '错误',
							msg : '请将数据添加完整后再试!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			}
			//alert(tmpstro);
			var itemcode=r.data['Name'];
			var budgreal=r.data['budgreal'];
			var reqpay  =r.data['reqpay'];
			var ddesc   =r.data['ddesc'];
			var supplier=r.data['supplier'];
		  //alert(supplier);
			var recordType;
			if (r.data.newRecord) {
				recordType = "add";
				datad='&itemcode='+itemcode+'&budgreal='+budgreal+'&reqpay='+reqpay+'&ddesc='+encodeURIComponent(ddesc)+'&supplier='+encodeURIComponent(supplier);
			} else {
				recordType = "edit";
				//tmpstro = "&rowid=" + r.data['rowid'];
				datad="&rowid=" + r.data['rowid']+'&reqpay='+reqpay+'&ddesc='+encodeURIComponent(ddesc)+'&supplier='+encodeURIComponent(supplier);
			}
			
			var saveUrl = adddetailGrid.url+'?action='+recordType+datad;
			//alert(saveUrl);
			p = {
				url : saveUrl,
				method : 'GET',
				waitMsg : '保存中...',
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

						var message = "";
						message = recordType == 'add' ? '添加成功!' : '保存成功!'
						Ext.Msg.show({
									title : '注意',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.INFO
								});
						addmainGrid.load({params:{start:0,limit:25,projdr:projDr}});
						adddetailGrid.store.commitChanges();
						if (jsonData.refresh == 'true') {
							adddetailGrid.store.load({
								params : {
									start : Ext
											.isEmpty(adddetailGrid.getTopToolbar().cursor)
											? 0
											: adddetailGrid.getTopToolbar().cursor,
									limit : adddetailGrid.pageSize
								}
							});
						}
					} else {
						if (jsonData.refresh == 'true') {
							adddetailGrid.store.load({
								params : {
									start : Ext
											.isEmpty(adddetailGrid.getTopToolbar().cursor)
											? 0
											: adddetailGrid.getTopToolbar().cursor,
									limit : adddetailGrid.pageSize
								}
							});
						}
						var message = "";
						message = "SQLErr: " + jsonData.info;
						if (jsonData.info == 'EmptyName')
							message = '输入的预算项不能为空!';
						if (jsonData.info == 'EmptyOrder')
							message = '输入的序号为空!';
						if (jsonData.info == 'RepCode')
							message = '输入的编码已经存在!';
						if (jsonData.info == 'RepName')
							message = '输入的名称已经存在!';
						if (jsonData.info == 'RepOrder')
							message = '输入的序号已经存在!';
						if (jsonData.info == 'RecordExist')
							message = '输入的记录已经存在!';
						Ext.Msg.show({
									title : '错误',
									msg : message,
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
						adddetailGrid.store.rejectChanges();
					}
				},
				scope : this
			};
			Ext.Ajax.request(p);
		}, this);
		return rtn;
				}
			},
				scope : this
		});
	
		}
		
		})
		
	}  	

	
}


