
//删除函数

delFun = function(itemGrid,data,rowid,VouchID){ 
				function handler(id){
		
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/herp.acct.acctvouchexe.csp?action=del&rowid='+rowid+'&rowidm='+VouchID,
							waitMsg:'删除中...',
							failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'删除成功!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:12,data:data}});
								}else
						{	
							var message='删除失败!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}							
								},
							scope: this
						});
					}else{
						return false;
					}
				}

			    Ext.MessageBox.confirm('提示','您真的要删除吗?',handler);
                            
 
	

};





///////撤销函数

backoutfun= function(rowid,userid){

					
				Ext.Ajax.request({
							url:'../csp/herp.budg.costclaimapplyexe.csp?action=backout&rowid='+rowid+"&userid="+userid,
							waitMsg:'撤销中...',
							failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'撤销成功!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:12}});
								}
                                                else if(jsonData.success=='hhhh')
                                                 {
                                                 Ext.Msg.show({title:'提示',msg:'审批已完成不允许撤销！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                                                  }
                                                else
						{	if(jsonData.info=='fail') message='保存到相应的组失败!';
							else message='撤销失败!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}							
								},
							scope: this
						});
					
			
			
                          
	
};




///////提交函数


submitfun= function(rowid,userid,billcodes){




		function handlera(id){
                                  if(id=="yes"){
			    Ext.MessageBox.confirm('提示','提交之后不能修改，您确定提交吗?',handler);}
                                  else
                            {        return false;   }                      
  
                                    }
   
				function handler(id){
		
					if(id=="yes"){
						Ext.Ajax.request({
							url:'../csp/herp.budg.costclaimapplyexe.csp?action=submit&rowid='+rowid+"&userid="+userid+"&billcodes="+billcodes,
							waitMsg:'删除中...',
							failure: function(result, request){
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'提示',msg:'提交成功!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									itemGrid.load({params:{start:0, limit:12}});
								}
                                                 else if(jsonData.success=='hhhh')
                                                 {
                                                 Ext.Msg.show({title:'提示',msg:'审批已完成不允许提交！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
                                                  }
                                               else
						{	if(jsonData.info=='fail') message='保存到相应的组失败!';
							else message='提交失败!';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}							
								},
							scope: this
						});
					}else{
						return false;
					}
				}

			    Ext.MessageBox.confirm('提示','您真的要提交吗?',handlera);
                            
 
                          
	
};



///////////////修改函数
modificationfun= function(rowid){



Ext.Msg.show({title:'提示',msg:'修改成功!',width:200,buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});

};






/////查看文件


function MSComDlg_CommonDialog(cmd){
   ////if(!ActiveXObject)return;
    var obj=new ActiveXObject('MSComDlg.CommonDialog');
    var filename=false;
    try{
        switch(cmd){
        case 2:
            obj.ShowColor();
            break;
        case 3:
            obj.ShowFont();
            break;
        case 4:
            obj.ShowHelp();
            break;
        default:
            obj.Filter='所有文件(*.*)';
            obj.FilterIndex = 1;
            obj.MaxFileSize = 255;
            if(cmd==0){
                obj.ShowSave();
            }else{
                obj.ShowOpen();
            }
        }
        filename = obj.filename;
    }catch(e){alert(e.message);}
    return filename;
} 














/////添加函数

/*
addFun = function(itemGrid){

var userCode = session['LOGON.USERCODE'];
var Username = session['LOGON.USERNAME'];
var userId	= session['LOGON.USERID'];
Username=userId+'_'+Username;
var Billcode = "";
var statetitle = name +"支出申请";

/////////////////////申请单号/////////////////////////
var applyNo = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			emptyText: '回车生成单据号......',
			//disabled: true,
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

var del = function() {

	Ext.Ajax.request({
		url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=Del',
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
			value: Username,
			//disabled: true,
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
/////////////////////申请科室/////////////////////////
var dnamefield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			emptyText : '回车生成科室...',
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

		});
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
					if(yearmonField.getValue()!==""){
						yearmonField.focus();
					}else{
					Handler = function(){yearmonField.focus();};
					Ext.Msg.show({title:'错误',msg:'预算期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
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
					value : '申请说明:',
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
				}

		]
	}]
});

//预算项
var codeDs = new Ext.data.Store({proxy : "",reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['code', 'name'])});

codeDs.on('beforeload', function(ds, o) {ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.budgprojclaimapplynos.csp?action=itemcode',method : 'POST'});});

 ItemcodeCombo = new Ext.form.ComboBox({
	fieldLabel : '预算项',
	store : codeDs,
	displayField : 'name',
	valueField : 'code',
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
    tooltip:'添加',        
    iconCls: 'save',
	handler:function(){
	AddFun();			//调用申请单据管理界面
	}
	
});

//////////////////提交/////////////////////
var SubButton = new Ext.Toolbar.Button({
			text : '提交',
			tooltip : '提交',
			iconCls:'add',
			handler : function() {
				var rowObj = addmainGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if (len < 1) {
					Ext.Msg.show({title : '注意',msg : '请选择需要提交的记录!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
					return;
				}
				var billcode = applyNo.getValue();
				var ReqPay = rowObj[0].get("ReqPay");
				var itemcode = rowObj[0].get("ItemCode");
				var yearmonth = yearmonField.getValue();
				var deptdr = dnamefield.getValue();
				var arr = deptdr.split("_");deptdr=arr[0];
				Ext.Ajax.request({
					url : 'herp.budg.budgctrlfundbillmngexe.csp?action=submit&ReqPay='+ReqPay+'&itemcode='+itemcode+'&yearmonth='+yearmonth+'&deptdr='+deptdr,
					failure : function(result, request) {
						Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({title : '注意',msg : '提交成功!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
							addmainGrid.load({params:{start:0, limit:25,BillCode:billcode}});
						} else {
							var message="SQLErr: "+ jsonData.info;
							Ext.Msg.show({title : '错误',msg : message,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						}
					},
					scope : this
				});
			}
		});

var addmainGrid = new dhc.herp.Grid({
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
					           	var yearmonth = yearmonField.getValue();
								var DeptDR = dnamefield.getValue();
								var arr = DeptDR.split("_");DeptDR=arr[0];
					            Ext.Ajax.request({
								url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getcurbalance&deptdr='+DeptDR+'&yearmonth='+yearmonth+'&itemcode='+record.get('ItemName'),				
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
		                    if ((record.get('rowid') != "")&& (columnIndex == 4)) {
		                         return false;
		                     } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						if ((record.get('ItemName')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) {
					           	var yearmonth = yearmonField.getValue();
								var DeptDR = dnamefield.getValue();
								var arr = DeptDR.split("_");DeptDR=arr[0];
					            Ext.Ajax.request({
								url: '../csp/herp.budg.budgctrlfundbillmngexe.csp?action=getcurbalance&deptdr='+DeptDR+'&yearmonth='+yearmonth+'&itemcode='+record.get('ItemName'),				
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
						if ((record.get('rowid') != "") && (columnIndex == 4)) {
						
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
							type:ItemcodeCombo
						},{
							id : 'Balance',
							header : '目前预算结余',
							dataIndex : 'Balance',
							align:'right',
							width : 120,
							editable:false
						},{
							id : 'ReqPay',
							header : '本次报销申请',
							dataIndex : 'ReqPay',
							align:'right',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							width : 120
						},{
							id : 'ActPay',
							header : '审批支付',
							dataIndex : 'ActPay',
							align:'right',
							editable:false,
							width : 120
						},{
							id : 'Balance1',
							header : '审批后预算结余',
							dataIndex : 'Balance1',
							align:'right',
                                                        editable:false,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
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
						}],
						viewConfig : {forceFit : true}
			}
);
	AddFun=function() {
		var records=addmainGrid.store.getModifiedRecords();
		var o = {};
	    var tmpDate = addmainGrid.dateFields;
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
			for (var i = 0; i < addmainGrid.fields.length; i++) {
				var indx = addmainGrid.getColumnModel().getColumnId(i + 1)
				var tmobj = addmainGrid.getColumnModel().getColumnById(indx)
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
			var ItemCode = r.data['ItemName'];
			var ReqPay = r.data['ReqPay'];
			var ActPay = r.data['ActPay'];
			var BudgBalance = r.data['Balance'];
			//BillDR ItemName Balance ReqPay ActPay Balance1
			//FundBillDR ItemCode ReqPay ActPay Desc BudgBalance
			var datad = FundBillDR+"|"+ItemCode+"|"+ReqPay+"|"+ActPay+"|"+BudgBalance;
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
                         
			var datam = BillCode+"|"+YearMonth+"|"+DeptDR+"|"+UserDR+"|"+Desc;

			var rowidm="";
			var recordType;
			if (r.data.newRecord) {
				recordType = "add";
			} else {
				recordType = "edit";
			}
			o[this.idName] = r.get(this.idName);
			data.push(o);
			var saveUrl = addmainGrid.url + '?action=' + recordType + tmpstro.toString()+"&rowidm="+rowidm+"&datad="+encodeURIComponent(datad)+"&datam="+encodeURIComponent(datam)
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
						addmainGrid.store.commitChanges();
						if (jsonData.refresh == 'true') {
							addmainGrid.store.load({
								params : {
									start : Ext
											.isEmpty(addmainGrid.getTopToolbar().cursor)
											? 0
											: addmainGrid.getTopToolbar().cursor,
									limit : addmainGrid.pageSize,
									BillCode:BillCode
								}
							});
						}
					} else {
						if (jsonData.refresh == 'true') {
							addmainGrid.store.load({
								params : {
									start : Ext
											.isEmpty(addmainGrid.getTopToolbar().cursor)
											? 0
											: addmainGrid.getTopToolbar().cursor,
									limit : addmainGrid.pageSize,
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
						addmainGrid.store.rejectChanges();
					}
				},
				scope : this
			};
			Ext.Ajax.request(p);
		}, this);
		return rtn;
	}
addmainGrid.load({params:{start:0, limit:25,BillCode:Billcode}});
addmainGrid.addButton(SubButton);
addmainGrid.btnSaveHide();
addmainGrid.btnResetHide();
addmainGrid.btnPrintHide();
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
				items : [queryPanel,addmainGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,addmainGrid]                                 //添加Tabs
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
	
	window.show();	
	///window.on('beforeclose',del);
	
};

*/











addFun = function(itemGrid){

var userCode = session['LOGON.USERCODE'];
var username = session['LOGON.USERNAME'];
var userId	= session['LOGON.USERID'];
username=userId+'_'+username;
var billcode = "";
var statetitle = name +"支出申请";

/////////////////////申请单号/////////////////////////
var applyNofield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			emptyText: '回车生成单据号......',	
			//disabled: true,
			selectOnFocus : true,
			listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					Ext.Ajax.request({
					url: '../csp/herp.budg.expenseaccountdetailexe.csp?action=getclaimcode',				
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							var bcode = jsonData.info;
							applyNofield.setValue(bcode);
						}else{
							var message="";
							if(jsonData.info=='RepCode') message='单据号已经存在，请回车重新生成！';
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							applyNofield.focus();
						}
					},
					scope: this
					});
					dnamefield.focus();
						
						}
					}}

		});

var del = function() {

	Ext.Ajax.request({
		url: '../csp/herp.budg.expenseaccountdetailexe.csp?action=Del',
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

/////////////////////报销人/////////////////////////
var appuName = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			value: username,
			//disabled: true,
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
/////////////////////报销说明/////////////////////////
 Descfield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			selectOnFocus : true,
			listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(Descfield.getValue()!==""){
						timeCombo.focus();
					}else{
					Handler = function(){Descfield.focus();};
					Ext.Msg.show({title:'错误',msg:'申请说明不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}

		});		
/////////////////////报销科室/////////////////////////
var dnamefield = new Ext.form.TextField({
			columnWidth : .1,
			width : 90,
			columnWidth : .15,
			emptyText : '回车生成科室...',
			selectOnFocus : true,
			listeners : {
					specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					Ext.Ajax.request({
					url: '../csp/herp.budg.expenseaccountdetailexe.csp?action=deptlist&&userdr='+userId,				
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

		});
////////////预算期//////////////////////
var timeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['yearmonth', 'yearmonth'])
		});

timeDs.on('beforeload', function(ds, o) {ds.proxy = new Ext.data.HttpProxy({url :'herp.budg.expenseaccountdetailexe.csp?action=timelist' ,method : 'POST'});});

var timeCombo = new Ext.form.ComboBox({
			fieldLabel : '预算期',
			store : timeDs,
			displayField : 'yearmonth',
			valueField : 'yearmonth',
			typeAhead : true,
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
					if(timeCombo.getValue()!==""){
						applyCombo.focus();
					}else{
					Handler = function(){yearmonField.focus();};
					Ext.Msg.show({title:'错误',msg:'预算期不能为空!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
		});
		
//资金申请单号：
var applyDs = new Ext.data.Store({
	proxy : "",
	reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['rowid', 'applycode'])
});

applyDs.on('beforeload', function(ds, o) {

	ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.expenseaccountdetailexe.csp?action=applycode&&userdr='+ userId,
				method : 'POST'
			});
});

 applyCombo = new Ext.form.ComboBox({
	fieldLabel : '资金申请单号',
	store : applyDs,
	displayField : 'applycode',
	valueField : 'rowid',
	disabled:false,
	typeAhead : true,
	emptyText:'请选择资金申请单号',
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 90,
	listWidth : 200,
	pageSize : 10,
	minChars : 1,
	columnWidth : .15,
	selectOnFocus : true,
	listeners : {
				specialKey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					if(applyCombo.getValue()!==""){
						applyCombo.focus();
					}else{
					Handler = function(){applyCombo.focus();};
					Ext.Msg.show({title:'错误',msg:'资金申请单号不能为空!',buttons:Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
					}
					}}
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
				}, applyNofield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '报销科室:',
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
					value : '报销说明:',
					columnWidth : .12
				}, Descfield,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '预算期:',
					columnWidth : .12
				},timeCombo,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .02
				}, {
					xtype : 'displayfield',
					value : '资金申请单号:',
					columnWidth : .12
				}, applyCombo
		]
	}]
});

//预算项
var codeDs = new Ext.data.Store({proxy : "",reader : new Ext.data.JsonReader({totalProperty : "results",root : 'rows'}, ['code', 'name'])});

codeDs.on('beforeload', function(ds, o) {ds.proxy = new Ext.data.HttpProxy({
				url : 'herp.budg.expenseaccountdetailexe.csp?action=bidlist',method : 'POST'});});

 codeCombo = new Ext.form.ComboBox({
	fieldLabel : '预算项',
	store : codeDs,
	displayField : 'name',
	valueField : 'code',
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
    tooltip:'添加',        
    iconCls: 'save',
	handler:function(){
	AddFun();			//调用申请单据管理界面
	}
	
});

//////////////////提交/////////////////////
var SubButton = new Ext.Toolbar.Button({
			text : '提交',
			tooltip : '提交',
			iconCls:'add',
			handler : function() {
				var rowObj = addGrid.getSelectionModel().getSelections();
				var len = rowObj.length;
				if (len < 1) {
					Ext.Msg.show({title : '注意',msg : '请选择需要提交的记录!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.WARNING});
					return;
				}
				var billcode = applyNofield.getValue();
				var reqpay = rowObj[0].get("reqpay");
				var itemcode = rowObj[0].get("itemcode");
				var yearmonth = timeCombo.getValue();
				var deptdr = dnamefield.getValue();
				var arr = deptdr.split("_");deptdr=arr[0];
				Ext.Ajax.request({
					url : 'herp.budg.expenseaccountdetailexe.csp?action=submit&reqpay='+reqpay+'&itemcode='+itemcode+'&yearmonth='+yearmonth+'&deptdr='+deptdr+'&billcode='+billcode,
					failure : function(result, request) {
						Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							Ext.Msg.show({title : '注意',msg : '提交成功!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
							addGrid.load({params:{start:0, limit:25,billcode:billcode}});
						} else {
							var message="SQLErr: "+ jsonData.info;
							Ext.Msg.show({title : '错误',msg : message,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						}
					},
					scope : this
				});
			}
		});

var addGrid = new dhc.herp.Grid({
				width : 600,
				region : 'center',
				url : 'herp.budg.expenseaccountdetailexe.csp',
				tbar:addButton,
				forms : [],
				listeners : {
		            'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用
		                  //alert(columnIndex);
		                  	if ((record.get('itemname')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) {
					           	var yearmonth = timeCombo.getValue();
								var deptdr = dnamefield.getValue();
								var arr = deptdr.split("_");deptdr=arr[0];
					            Ext.Ajax.request({
								url: '../csp/herp.budg.expenseaccountdetailexe.csp?action=getcurbalance&deptdr='+deptdr+'&yearmonth='+yearmonth+'&itemcode='+record.get('itemname'),				
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true'){
										var curbalance = jsonData.info;
										record.data.balance=curbalance;
										record.set(5, curbalance);
									}
								},scope: this
								});
							}
		                    if ((record.get('rowid') != "")&& (columnIndex == 4)) {
		                         return false;
		                     } else {return true;}
		               },
		            'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						if ((record.get('itemname')!="")&&(record.get('rowid')=="")&&(columnIndex == 5)) {
					           	var yearmonth = timeCombo.getValue();
								var deptdr = dnamefield.getValue();
								var arr = deptdr.split("_");deptdr=arr[0];
					            Ext.Ajax.request({
								url: '../csp/herp.budg.expenseaccountdetailexe.csp?action=getcurbalance&deptdr='+deptdr+'&yearmonth='+yearmonth+'&itemcode='+record.get('itemname'),				
								success: function(result, request){
									var jsonData = Ext.util.JSON.decode( result.responseText );
									if (jsonData.success=='true'){
										var curbalance = jsonData.info;
										record.data.balance=curbalance;
										record.set(5, curbalance);
									}
								},scope: this
								});
							}
						if ((record.get('rowid') != "") && (columnIndex == 4)) {
						
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
							id : 'billdr',
							header : '报销主表ID',
							dataIndex : 'billdr',
							width : 120,
							hidden:true
						},{
							id : 'itemcode',
							header : '预算项编码',
							dataIndex : 'itemcode',
							hidden:true,
							width : 120
						},{
							id : 'itemname',
							header : '预算项',
							dataIndex : 'itemname',
							width : 120,
							type:codeCombo
						},{
							id : 'balance',
							header : '目前预算结余',
							dataIndex : 'balance',
							align:'right',
							width : 120,
							editable:false
						},{
							id : 'reqpay',
							header : '本次报销申请',
							dataIndex : 'reqpay',
							align:'right',
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
							width : 120,
							type:valueField
						},{
							id : 'actpay',
							header : '审批支付',
							dataIndex : 'actpay',
							align:'right',
							editable:false,
							width : 120
						},{
							id : 'balance1',
							header : '审批后预算结余',
							dataIndex : 'balance1',
							align:'right',
							editable:false,
							renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:black;cursor:hand;backgroundColor:red">'+value+'</span>';
							},
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
						}],
						viewConfig : {forceFit : true}
			}
);
	AddFun=function() {
		var records=addGrid.store.getModifiedRecords();
		var o = {};
	    var tmpDate = addGrid.dateFields;
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
			for (var i = 0; i < addGrid.fields.length; i++) {
				var indx = addGrid.getColumnModel().getColumnId(i + 1)
				var tmobj = addGrid.getColumnModel().getColumnById(indx)
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
			var paybilldr = r.data['billdr'];
			var itemcode = r.data['itemname'];
			var reqpay = r.data['reqpay'];
			var actpay = r.data['actpay'];
			var budgbalance = r.data['balance'];
			//BillDR ItemName Balance ReqPay ActPay Balance1
			//FundBillDR ItemCode ReqPay ActPay Desc BudgBalance
			var datad = paybilldr+"|"+itemcode+"|"+reqpay+"|"+actpay+"|"+budgbalance;
			} else {
				Ext.Msg.show({
							title : '错误',
							msg : '请将数据添加完整后再试!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
				return;
			}
			
			var billcode = applyNofield.getValue();
			var yearmonth = timeCombo.getValue();
			var deptdr = dnamefield.getValue();
			var arr = deptdr.split("_");deptdr=arr[0];
			var userdr = appuName.getValue();
			var arr1 = userdr.split("_"); userdr=arr1[0];
			var mdesc = Descfield.getValue();
			var applycode = applyCombo.getValue();
			var datam = billcode+"|"+yearmonth+"|"+deptdr+"|"+userdr+"|"+mdesc+"|"+applycode;
                       

			var rowidm="";
			var recordType;
			if (r.data.newRecord) {
				recordType = "add";
			} else {
				recordType = "edit";
			}
			o[this.idName] = r.get(this.idName);
			data.push(o);
			var saveUrl = addGrid.url + '?action=' + recordType + tmpstro.toString()+"&rowidm="+rowidm+"&datad="+encodeURIComponent(datad)+"&datam="+encodeURIComponent(datam)
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
						addGrid.store.commitChanges();
						if (jsonData.refresh == 'true') {
							addGrid.store.load({
								params : {
									start : Ext
											.isEmpty(addGrid.getTopToolbar().cursor)
											? 0
											: addGrid.getTopToolbar().cursor,
									limit : addGrid.pageSize,
									billcode:billcode
								}
							});
						}
					} else {
						if (jsonData.refresh == 'true') {
							addGrid.store.load({
								params : {
									start : Ext
											.isEmpty(addGrid.getTopToolbar().cursor)
											? 0
											: addGrid.getTopToolbar().cursor,
									limit : addGrid.pageSize,
									billcode:billcode
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
						addGrid.store.rejectChanges();
					}
				},
				scope : this
			};
			Ext.Ajax.request(p);
		}, this);
		return rtn;
	}
addGrid.load({params:{start:0, limit:25,billcode:billcode}});
addGrid.addButton(SubButton);
addGrid.btnSaveHide();
addGrid.btnResetHide();
addGrid.btnPrintHide();
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
				items : [queryPanel,addGrid]
			});

	var tabPanel =  new Ext.Panel({
  	//activeTab: 0,
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,addGrid]                                 //添加Tabs
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
	
	window.show();	
	//window.on('beforeclose',del);
	
};
