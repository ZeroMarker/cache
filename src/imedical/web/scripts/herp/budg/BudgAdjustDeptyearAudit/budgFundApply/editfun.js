EditFun = function(itemGrid){

var userCode = session['LOGON.USERCODE'];
var Username = session['LOGON.USERNAME'];
var userId	= session['LOGON.USERID'];
Username=userId+'_'+Username;
var Billcode = "";
var statetitle = name +"支出申请";

var selectedRow = itemGrid.getSelectionModel().getSelections();
var rowidm=selectedRow[0].data['rowid'];
var yearmonth=selectedRow[0].data['YearMonth'];
var billcode=selectedRow[0].data['BillCode'];
var dname=selectedRow[0].data['dName'];
var uname=selectedRow[0].data['uName'];
var desc=selectedRow[0].data['Desc'];
var deptID=selectedRow[0].data['deptID'];
dname=deptID+'_'+dname;
var billstate=selectedRow[0].data['BillState'];
var chkFlow=selectedRow[0].data['CheckDR'];
var tmpCheckid=selectedRow[0].data['Checkid'];
var audeprdr=selectedRow[0].data['audeprdr'];
var audname=selectedRow[0].data['audname'];
audname=audeprdr+'_'+audname;

/////////////////////申请单号/////////////////////////
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value:billcode,
			disabled: true,
			selectOnFocus : true,
			listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					Ext.Ajax.request({
					url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getbcode',				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var bcode = jsonData.info;
							applyNo.setValue(bcode);
						}else{
							var message="";
							if(jsonData.info=='RepCode') message='单据号已经存在，请回车重新生成！';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							applyNo.focus();
						}
					},
					scope: this
					});
					dnamefield.focus();
						
						}
					}}

		});

/////////////////////项目名称/////////////////////////
var projnameDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'name'])
});

projnameDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgprojclaimapplynos.csp?action=projname&&userdr='+ userid+ '&rowId=' + projDr,
				method : 'POST'
			});
});

var projnameCombo = new Ext.form.ComboBox({
	fieldLabel : '项目名称',
	store : projnameDs,
	displayField : 'name',
	valueField : 'rowid',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	disabled:true,
	allowBlank:false,
	width : 90,
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true
});

/////////////////////申请人/////////////////////////
var appuName = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: uname,
			disabled: true,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(appuName.getValue()!==""){
						Descfield.focus();
					}else{
					Handler = function(){appuName.focus();};
					Ext.Msg.show({title:'错误',msg:'申请人不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}

		});
/////////////////////申请说明/////////////////////////
 Descfield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value : desc,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(Descfield.getValue()!==""){
						yearmonField.focus();
					}else{
					Handler = function(){Descfield.focus();};
					Ext.Msg.show({title:'错误',msg:'申请说明不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}

		});		
// ////////////科室名称////////////////////////
var dnameDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

dnameDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgctrlfundbillmngexe.csp?action=deptlist&flag=2',
						method : 'POST'
					});
		});

var dnamefield = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : dnameDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			value : dname,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			disabled: true,
			pageSize : 10,
			minChars : 1,
			columnWidth : .15,
			selectOnFocus : true,
			listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(dnamefield.getValue()!==""){
							appuName.focus();
						}else{
							Handler = function(){dnamefield.focus();};
							Ext.Msg.show({title:'错误',msg:'科室名称不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						}
					}}
		});
///////////////归口科室////////////////////////
var audnameDs = new Ext.data.Store({
	proxy : "",reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['rowid', 'name'])
});

audnameDs.on('beforeload', function(ds, o) {
	ds.proxy = new Ext.data.HttpProxy({
		url : 'herp.budg.budgctrlfundbillmngexe.csp?action=deptlist&flag=1',
		method : 'POST'
		});
});
var audnamefield = new Ext.form.ComboBox({
			fieldLabel : '归口科室',
			store : audnameDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			value : audname,
			disabled:true,
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

/*
/////////////////////申请科室/////////////////////////
var dnamefield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value : dname,
			emptyText : '回车生成科室...',
			disabled: true,
			selectOnFocus : true,
			listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					Ext.Ajax.request({
					url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getdept&userID='+userId,				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var dept = jsonData.info;
							dnamefield.setValue(dept);
							appuName.focus();
						}else{
							var message="";
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							dnamefield.focus();
						}
					},
					scope: this
					});
						
						}
					}}

		});*/
////////////预算期//////////////////////
var yearmonDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['yearmonth', 'yearmonth'])
		});

yearmonDs.on('beforeload', function(ds, o) {ds.proxy = new Ext.data.HttpProxy({url : projUrl+'?action=yearmonthlist',method : 'POST'});});

var yearmonField = new Ext.form.ComboBox({
			fieldLabel : '预算期',
			store : yearmonDs,
			displayField : 'yearmonth',
			valueField : 'yearmonth',
			typeAhead : true,
			//disabled: true,
			forceSelection : true,
			triggerAction : 'all',
			value : yearmonth,
			emptyText : '请选择...',
			width : 100,
			listWidth : 220,
			columnWidth : .15,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(yearmonField.getValue()!==""){
						checkflowField.focus();
					}else{
					Handler = function(){yearmonField.focus();};
					Ext.Msg.show({title:'错误',msg:'预算期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
		});

////////////审批流//////////////////////
var checkflowDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['rowid', 'name'])
		});

checkflowDs.on('beforeload', function(ds, o) {ds.proxy = new Ext.data.HttpProxy({
url :'../csp/herp.budg.budgctrlfundbillmngexe.csp?action=checkflowlist',method : 'POST'});});

var checkflowField = new Ext.form.ComboBox({
			fieldLabel : '审批流',
			store : checkflowDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			value : chkFlow,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '请选择...',
			width : 100,
			listWidth : 220,
			columnWidth : .15,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(checkflowField.getValue()!==""){
						checkflowField.focus();
					}else{
					Handler = function(){checkflowField.focus();};
					Ext.Msg.show({title:'错误',msg:'审批流不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
		});
checkflowField.on('select',function(combo, record, index){
			tmpCheckid = combo.getValue();
		});
		
var queryPanel = new Ext.FormPanel({
	height : 120,
	region : 'north',
	frame : true,
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '申请单号:',
					columnWidth : .12
				}, applyNo,{
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
					value : '借款说明:',
					columnWidth : .12
				}, Descfield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '预算期:',
					columnWidth : .12
				},yearmonField,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				},{
					xtype : 'displayfield',
					value : '审批流:',
					columnWidth : .12
				}, checkflowField

		]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		{
					xtype : 'displayfield',
					value : '归口科室:',
					columnWidth : .12
				}, audnamefield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}

		]
	}]
});
// ////////////预算项名称////////////////////////
var codeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

codeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgctrlfundbillmngexe.csp?action=itemcodelist&year='+ yearmonField.getValue().substr(0,4),
						method : 'POST'
					});
		});

var codeCombo = new Ext.form.ComboBox({
			fieldLabel : '预算项',
			store : codeDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
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

//当前预算结余
var budgbalanceDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['name', 'name'])
});

budgbalanceDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgprojclaimapplynos.csp'+'?action=budgbalance&&itemcode='+ codeCombo.getValue(),
				method : 'POST'
			});
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
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});


//数据录入
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
var addButton = new Ext.Toolbar.Button({
	text: '保存',
    tooltip:'保存',        
    iconCls: 'save',
	handler:function(){
	Add1Fun();			//调用申请单据管理界面
	}
	
});

//////////////////提交/////////////////////
var SubButton = new Ext.Toolbar.Button({
			text : '提交',
			tooltip : '提交',
			iconCls:'add',
			handler : function() {
				var rowObj = editmainGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if (len < 1) {
					Ext.Msg.show({title : '注意',msg : '请选择需要提交的记录!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
					return;
				}
				var ReqPay = rowObj[0].get("ReqPay");
				var itemcode = rowObj[0].get("ItemCode");
				var State = rowObj[0].get("State");
				if((State=="提交")||(State=="完成")){
					Ext.Msg.show({
								title : '错误',
								msg : '记录已经提交,不能重复提交!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
					return;
				}
				
				var yearmonth = yearmonField.getValue();
				var deptdr = dnamefield.getValue();
				var audeptdr = audnamefield.getValue();
				var arr = deptdr.split("_");deptdr=arr[0];
				var arr1 = audeptdr.split("_");audeptdr=arr1[0];
				
				Ext.Ajax.request({
					url : 'herp.budg.budgctrlfundbillmngexe.csp?action=submit&ReqPay='+ReqPay+'&itemcode='+itemcode+'&yearmonth='+yearmonth+'&deptdr='+deptdr+'&audeptdr='+audeptdr,
					failure : function(result, request) {
						Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({title : '注意',msg : '提交成功!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
							editmainGrid.load({params:{start:0, limit:25,BillCode:billcode}});
						} else {
							var message="SQLErr: "+ jsonData.info;
							if(jsonData.info=='Empty') message='该记录未生成预算项！';
							Ext.Msg.show({title : '错误',msg : message,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						}
					},
					scope : this
				});
			}
		});

var editmainGrid = new dhc.herp.Grid({
				width : 600,
				region : 'center',
				url : 'herp.budg.budgctrlfundbillmngexe.csp',
				tbar:addButton,
				forms : [],
				listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用
		                  //alert(columnIndex);
		                  if ((record.get('ItemName')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) {
					            Ext.Ajax.request({
								url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getcurbalance&deptdr='+audeprdr+'&yearmonth='+yearmonth+'&itemcode='+record.get('ItemName')+'&state=""&rowidd=""',				
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true'){
										var curbalance = jsonData.info;
										record.data.Balance=curbalance;
										record.set(5, curbalance);
									}
								},scope: this
								});
							}  
		                    if (((record.get('rowid') != "")&& (columnIndex == 4))||((record.get('State') !== "新建")&& (columnIndex == 6))) {
		                         return false;
		                     } else {return true;}
		                    
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						if ((record.get('ItemName')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) {
					            Ext.Ajax.request({
								url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getcurbalance&deptdr='+audeprdr+'&yearmonth='+yearmonth+'&itemcode='+record.get('ItemName')+'&state=""&rowidd=""',				
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true'){
										var curbalance = jsonData.info;
										record.data.Balance=curbalance;
										record.set(5, curbalance);
									}
								},scope: this
								});
							}
						if (((record.get('rowid')!="")&&(columnIndex == 4))||((record.get('State') !== "新建")&& (columnIndex == 6))){
							return false;
						} else {
							return true;
						}
					}
	            },
				fields : [
				{
							header : 'ID',
							width : 30,
							editable:false,
							dataIndex : 'rowid',
							hidden : true
						},{
							id : 'BillDR',
							header : '申请主表ID',
							dataIndex : 'BillDR',
							width : 120,
							hidden:true
						},{
							id : 'ItemCode',
							header : '预算项编码',
							dataIndex : 'ItemCode',
							hidden:true,
							width : 120
						},{
							id : 'ItemName',
							header : '预算项',
							dataIndex : 'ItemName',
							width : 120,
							type:codeCombo
						},{
							id : 'Balance',
							header : '目前预算结余',
							dataIndex : 'Balance',
							align:'right',
							xtype:'numbercolumn',
							width : 120,
							editable:false
						},{
							id : 'ReqPay',
							header : '申请金额',
							dataIndex : 'ReqPay',
							align:'right',
							xtype:'numbercolumn',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							width : 120
						},{
							id : 'ActPay',
							header : '审批金额',
							dataIndex : 'ActPay',
							xtype:'numbercolumn',
							align:'right',
							editable:false,
							width : 120
						},{
							id : 'Balance1',
							header : '审批后预算结余',
							dataIndex : 'Balance1',
							xtype:'numbercolumn',
							editable:false,
							align:'right',
							width : 120
						},{
							id : 'budgcotrol',
							header : '预算控制',
							dataIndex : 'budgcotrol',
							width : 100,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							var sf = record.data['budgcotrol']
							if (sf == "超预算") {
								return '<span style="color:red;cursor:hand;">'+value+'</span>';
							} else {
								return '<span style="color:black;cursor:hand">'+value+'</span>';
							}},
							editable:false
						},{
							id : 'State',
							header : '单据状态',
							dataIndex : 'State',
							editable:false,
							width : 120
						}],
						viewConfig : {forceFit : true}
			}
);
	Add1Fun=function() {
		var records=editmainGrid.store.getModifiedRecords();
		var o = {};
	    var tmpDate = editmainGrid.dateFields;
	    var tmpstro = "";
	    var tmpstros="";
	    var data = [];
	    var rtn = 0;
	    var datad="";
		Ext.each(records, function(r) {
			var o = {};
			var tmpstro = "&rowid=" + r.data['rowid'];
			var deleteFlag = r.data['delFlag'];// 删除标识，1：是该记录已经删除，0：未删除。

			// 数据完整性验证Beging
			for (var i = 0; i < editmainGrid.fields.length; i++) {
				var indx = editmainGrid.getColumnModel().getColumnId(i + 1)
				var tmobj = editmainGrid.getColumnModel().getColumnById(indx)
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
			var FundBillDR = r.data['BillDR'];
			var ItemCode = r.data['ItemCode'];
			//alert(ItemCode);
			if(ItemCode==""){
			//alert("aa");
			var ItemCode = r.data['ItemName'];
			}
			var ReqPay = r.data['ReqPay'];
			var ActPay = r.data['ActPay'];
			var BudgBalance = r.data['Balance'];
			var State = r.data['State'];
			//BillDR ItemName Balance ReqPay ActPay Balance1
			//FundBillDR ItemCode ReqPay ActPay Desc BudgBalance
			var datad = FundBillDR+"|"+ItemCode+"|"+ReqPay+"|"+ActPay+"|"+BudgBalance+"|"+State;
			} else {
				Ext.Msg.show({
							title : '错误',
							msg : '请将数据添加完整后再试!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			}
			
			var BillCode = applyNo.getValue();
			var YearMonth = yearmonField.getValue();
			var DeptDR = dnamefield.getValue();
			var arr = DeptDR.split("_");DeptDR=arr[0];
			var UserDR = appuName.getValue();
			var arr1 = UserDR.split("_"); UserDR=arr1[0];
			var Desc = Descfield.getValue();
			var chkflow = tmpCheckid; //checkflowField.getValue();
			var audeptdr = audnamefield.getValue();
			var arr2 = audeptdr.split("_"); audeptdr=arr2[0];
			var datam = BillCode+"|"+YearMonth+"|"+DeptDR+"|"+UserDR+"|"+Desc+"|"+chkflow+"|"+audeptdr;
			var recordType;
			if (r.data.newRecord) {
				recordType = "add";
			} else {
				recordType = "edit";
			}
			o[this.idName] = r.get(this.idName);
			data.push(o);
			var saveUrl = editmainGrid.url + '?action=' + recordType + tmpstro.toString() +"&rowidm="+rowidm+"&datad="+encodeURIComponent(datad)+"&datam="+encodeURIComponent(datam)
					+ Ext.urlEncode(this.urlParam);
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
						editmainGrid.store.commitChanges();
						if (jsonData.refresh == 'true') {
							editmainGrid.store.load({
								params : {
									start : Ext
											.isEmpty(editmainGrid.getTopToolbar().cursor)
											? 0
											: editmainGrid.getTopToolbar().cursor,
									limit : editmainGrid.pageSize,
									BillCode:BillCode
								}
							});
						}
					} else {
						if (jsonData.refresh == 'true') {
							editmainGrid.store.load({
								params : {
									start : Ext
											.isEmpty(editmainGrid.getTopToolbar().cursor)
											? 0
											: editmainGrid.getTopToolbar().cursor,
									limit : editmainGrid.pageSize,
									BillCode:BillCode
								}
							});
						}
						var message = "";
						message = "SQLErr: " + jsonData.info;
						if (jsonData.info == 'EmptyName')
							message = '输入的名称为空!';
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
						editmainGrid.store.rejectChanges();
					}
				},
				scope : this
			};
			Ext.Ajax.request(p);
		}, this);
		return rtn;
	}
editmainGrid.load({params:{start:0, limit:25,BillCode:billcode}});
editmainGrid.addButton(SubButton);
//editmainGrid.btnAddHide();
editmainGrid.btnSaveHide();
editmainGrid.btnResetHide();
//editmainGrid.btnDeleteHide();
editmainGrid.btnPrintHide();

if(billstate!=='完成') {
	var tbar = editmainGrid.getTopToolbar();
	var addbutton = tbar.get('herpAddId');
	var deletebutton = tbar.get('herpDeleteId');
	addbutton.disable();
	addButton.disable();
	deletebutton.disable();
	SubButton.disable();
}
// 单击gird的单元格事件
editmainGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

		var records = editmainGrid.getSelectionModel().getSelections();
		var State   = records[0].get("State");
		var tbar = editmainGrid.getTopToolbar();
		var tbutton = tbar.get('herpDeleteId');
		
		if(State!=="新建"){
		tbutton.disable();
		}

		
});

	// 初始化取消按钮
	cancelButton = new Ext.Toolbar.Button({ text : '关闭'});

	// 定义取消按钮的响应函数
	cancelHandler = function(){
		itemGrid.load({params:{start:0, limit:12, userdr:userId}});
	  	window.close();
	};

	// 添加取消按钮的监听事件
	cancelButton.addListener('click', cancelHandler, false);
	
	
	// 初始化面板
	formPanel = new Ext.form.FormPanel({
				baseCls : 'x-plain',
				layout : 'fit',
				labelWidth : 100,
				items : [queryPanel,editmainGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,editmainGrid]                                 //添加Tabs
  });
	
	var window = new Ext.Window({
				layout : 'fit',
				title : '借款管理',
				plain : true,
				width : 950,
				height : 500,
				modal : true,
				buttonAlign : 'center',
				items : tabPanel,
				buttons : [cancelButton]

			});
	
	window.show();	
	//window.on('beforeclose',del);
	
};