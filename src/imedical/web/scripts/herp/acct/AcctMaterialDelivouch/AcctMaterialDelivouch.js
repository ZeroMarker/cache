
//var acctbookid=IsExistAcctBook();
//var userid = session['LOGON.USERID'];
var projUrl="herp.acct.acctMaterialDelivouchexe.csp";
var acctbookid="";
var userid="";
var vouchNO="";
var Vno=document.getElementById("vouchNO").innerHTML;
if(document.getElementById("vouchNO").innerHTML!=""){
	acctbookid=document.getElementById("AcctBookID").innerHTML;
	userid=document.getElementById("userid").innerHTML;
	vouchNO=document.getElementById("vouchNO").innerHTML+"#"+acctbookid;	
}

if(vouchNO==""){
 acctbookid=IsExistAcctBook();
 userid = session['LOGON.USERID'];	
	
}

/////////////所属月份///////////////////////
var YearMonth = new Ext.form.DateField({
    id:'YearMonth',
    fieldLabel: '所属月份',
    name : 'YearMonth',
    format : 'Y-m',
    editable : true,
    //allowBlank : false,
    emptyText:'请选择年月...',
   // value:new Date(),
    width: 120,
   // maxValue : new Date(),
    plugins: 'monthPickerPlugin',
	listeners:{
	
		"change":function(field,newvalue,oldvalue,op){
			depotDs.removeAll();
			depotCombo.setValue('');
			
			var Month=newvalue.format('Y-m');	
		    //alert(Month);
			depotDs.on('beforeload', function(ds, o) {
			depotDs.proxy=new Ext.data.HttpProxy({
						url : projUrl+'?action=Ctlocdr&yearMonth='+Month,method:'POST'
					});
			
		   });
		   depotDs.load({params:{start:0,limit:10,yearMonth:Month}});    
		}
		
	}
});

///////////////所属库房////////////////////////////  
var depotDs = new Ext.data.Store({
			autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		

depotDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=Ctlocdr',method:'POST'
					});
			
		});
var depotCombo = new Ext.form.ComboBox({
			fieldLabel : '所属库房',
			store : depotDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 150,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			editable:true,
			 model : 'remote',
			selectOnFocus : true
		});
  
///////////////业务单号////////////////////////  
var OrderNO = new Ext.form.TextField({
    id:'OrderNO',
	fieldLabel:'业务单号',
	labelAlign:'left',
	labelWidth:40,
	width : 120,
	name:'OrderNO',
	triggerAction: 'all',
	forceSelection:'true',
    editable:true,
	selectOnFocus : true
});
	
//////////////////////单据状态///////////////////////	
var orderStatusDS=new Ext.data.SimpleStore({
    fields : ['key', 'keyValue'],
	data : [['','全部'],['Q', '未记账'],['P', '记账']]
});
//配置下拉框  单据状态
var orderStatus=new Ext.form.ComboBox({
   id:'orderStatus',
   fieldLabel : '单据状态',
	width : 120,
	listWidth : 100,
	store : orderStatusDS,
	valueNotFoundText : '',
	displayField : 'keyValue',
	valueField : 'key',
	mode : 'local', // 本地模式
	triggerAction: 'all',
	emptyText:'全部',
	selectOnFocus:true,
	forceSelection : true,
	editable:true
	//allowBlank:true	
});	

var findButton=new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',        
	iconCls:'find',
	width:55,
    handler:function(){
		var Month=YearMonth.getValue();	  
		var depot=depotCombo.getValue();
		var OrderNOs=OrderNO.getValue();
		var Status=orderStatus.getValue();
		if(Month!=""){		
			Month=Month.format('Y-m');
		}
			itemGrid.load({
				params:{		
				sortField:'',
				sortDir:'',
				start:0,
				limit:25,
				YearMonth:Month,
				depot:depot,
				OrderNO:OrderNOs,
				orderStatus:Status,
				VouchNO:vouchNO
				}
			});	
			itemGridf.load({params:{start:0, limit:25, rowid:"", kf:""}});
		//}else{
		//	Ext.Msg.show({title:'提示',msg:'请选择所属月份 ',buttons:Ext.Msg.OK,icon:Ext.MessageBox.INFO});		
		//}   
	}
});
   
 //凭证日期
var vouchDate = new Ext.form.DateField({
    id:'vouchDate',
    fieldLabel: '凭证日期',
    name : 'vouchDate',
    format : 'Y-m-d',
    editable : true,
	value:new Date(),
    allowBlank : false,
    emptyText:'请选择年月...',
    width: 120
   // plugins: 'monthPickerPlugin'
});
   
  
  var createVouch=new Ext.Toolbar.Button({
		text : '&nbsp;生成凭证',
		width:80,
		tooltip : '生成凭证',
		iconCls : 'createvouch',
		handler:function(){
		createVouch();
		}
	  
  });
  
  
  //查询面板
if(vouchNO==""){
	var queryPanel = new Ext.FormPanel({
		title:'物资出库凭证',
		iconCls:'createvouch',
		  height:73,	  
		  region:'north',
		  frame:true,
		  //split : true,
		  //collapsible : true,
		  defaults: {bodyStyle:'padding:5px'},
		  items:[{
			 columnWidth:1,
			 xtype: 'panel',
			 layout:"column",
			 width:1200,
			 items: [ {
							xtype:'displayfield',
							value:'所属月份',
							style:'padding:0 5px;'
							//width:60
						},YearMonth,
					 {
						 xtype:'displayfield',
						 value:'',
						 width:40	
					 },{
							xtype:'displayfield',
							value:'出库科室',
							style:'padding:0 5px;'  
							//width:60
						},depotCombo,
					 {
						 xtype:'displayfield',
						 value:'',
						 width:40	
					 },
					 {
							xtype:'displayfield',
							value:'业务单号',
							style:'padding:0 5px;'
							//width:60
					 },OrderNO,
					 {
						 xtype:'displayfield',
						 value:'',
						 width:40	
					  },
					 {
							xtype:'displayfield',
							value:'单据状态',
							style:'padding:0 5px;'
							//width:60
						},orderStatus,
					 		  
					 {
						 xtype:'displayfield',
						 value:'',
						 width:30	
					  },findButton,{
						xtype:'displayfield',
						value:'',
						width:30	
					 },createVouch 
		 ] }/* ,{
			 columnWidth:1,
			 xtype: 'panel',
			 layout:"column",
			 items:[
					{
						xtype:'displayfield',
						value:'凭证日期:',
						style:'line-height: 20px;',  
						width:60
					},vouchDate,
					 {
						xtype:'displayfield',
						value:'',
						width:100	
					 },createVouch ]
		 } */]	
	});
}else if(vouchNO!=""){	
	var queryPanel =new Ext.FormPanel({
		region:'north',
		frame:true,
		height:80,		
		items:[			
			{
                xtype:'displayfield',
                value:'物资出库记账明细表',
                style:'text-align:center;font-size:16px;height:40px;vertical-align:middle; line-height:40px;font-weight:bold'
                        //width:60
            },{
				xtype:'displayfield',
                value:'凭证单号：'+Vno,
				style:'text-align:left'
			}
		]				
	});	
}

 var itemGrid = new dhc.herp.Grid({
            //width: 400,
			region: 'center',
			iconCls:'list',
			title:'物资出库主表',
			url : projUrl,
			fields : [
			new Ext.grid.CheckboxSelectionModel({editable:false}),
				{
				id:'rowid',
				header:'<div style="text-align:center">ID</div>',
				width:50,
				editable : false,
				align:'left',
				allowBlank : false, 
                hidden : true,				
				dataIndex : 'rowid'
				},{
				id:'bookid',
				header:'<div style="text-align:center">bookid</div>',
				width:50,
				editable : false,
				align:'left',
				allowBlank : false, 
                hidden : true,				
				dataIndex : 'bookid'
				},{
				  id:'StkMonNo',
				  header:'<div style="text-align:center">业务单号</div>',
				  width : 150,
				  align:'left',
				  editable : false,
				  allowBlank : true,     
				  dataIndex : 'StkMonNo'
				},{
				  id:'CTLOCID',
				  header:'<div style="text-align:center">出库科室id</div>',
				  width : 80,
				  align:'left',
				  editable : false,
				  allowBlank : true,   
				  hidden : true,				  
				  dataIndex : 'CTLOCID'
				},{
				  id:'CTLOCDR',
				  header:'<div style="text-align:center">出库科室</div>',
				  width : 180,
				  align:'left',
				  editable : false,
				  allowBlank : true,     
				  dataIndex : 'CTLOCDR'
				},{
				  id:'Month',
				  header:'<div style="text-align:center">所属月份</div>',
				  width : 90,
				  align:'center',
				  editable : false,
				  allowBlank : true,    
				  dataIndex : 'Month'
				},{
				  id:'FromDate',
				  header:'<div style="text-align:center">开始日期</div>',
				  width : 90,
				  align:'center',
				  editable : false,
				  allowBlank : true,    
				  dataIndex : 'FromDate'
				},{
				  id:'ToDate',
				  header:'<div style="text-align:center">结束日期</div>',
				  width : 90,
				  align:'center',
				  editable : false,
				  allowBlank : true, 
				 // hidden:true,       
				  dataIndex : 'ToDate'
				},{
				  id:'CreatedUser',
				  header:'<div style="text-align:center">制单人</div>',
				  width : 120,
				  align:'center',
				  editable : false,
				  allowBlank : true, 
				 // hidden:true,       
				  dataIndex : 'CreatedUser'
				},{
				  id:'AcctVoucherStatus',
				  header:'<div style="text-align:center">数据状态</div>',
				  width : 70,
				  align:'center',
				  editable : false,
				  allowBlank : true,  
				  dataIndex : 'AcctVoucherStatus'
				},{
				 id:'AcctVoucherUser',
				 header:'<div style="text-align:center">记账人</div>',
				 width : 120,
				// align:'left',
				 align: 'center',
				 editable : false,
				 allowBlank : true,     
				 dataIndex : 'AcctVoucherUser'
				},{
				  id:'AcctVoucherDate',
				  header:'<div style="text-align:center">记账日期</div>',
				  width : 90,
				  align:'center',
				  editable : false,
				  allowBlank : true,     
				  dataIndex : 'AcctVoucherDate'
				},{
				 id:'AcctVoucherCode',
				 header:'<div style="text-align:center">凭证号</div>',
				 width : 120,
				  align:'center',
				  editable : false,
				  allowBlank : true,     			  
				  renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
						},				  
				  dataIndex : 'AcctVoucherCode'
				},{
				id:'PdfFile',
				header : 'PDF文件',
				editable : false,
				align : 'center',
				width:120,					
				renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
					return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
					},
				dataIndex : 'PdfFile'
				}],
	sm : new Ext.grid.RowSelectionModel({	singleSelect : true	}),
	split : true,
	collapsible : true,
	containerScroll :true,
	xtype : 'grid',
	stripeRows : true,
	loadMask : true,
	height:300,
	trackMouseOver: true
});
    
	itemGrid.btnAddHide();
    itemGrid.btnSaveHide();
    itemGrid.btnResetHide();
    itemGrid.btnDeleteHide();
    itemGrid.btnPrintHide();
	//itemGrid.load(({params:{start:0,limit:25}}));
if(vouchNO!=""){
	itemGrid.load(({params:{start:0,limit:25,VouchNO:vouchNO}}));
}
itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var MainRowid='';
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var MainRowid=selectedRow[0].data['rowid'];
	var kf=selectedRow[0].data['CTLOCDR'];
	var CTLOCID=selectedRow[0].data['CTLOCID'];
	//alert(MainRowid);
	itemGridf.load({params:{start:0, limit:25,rowid:MainRowid,kf:kf,CTLOCID:CTLOCID}});	
});

// 生成凭证窗口的panel
var VouchDatePanel = new Ext.form.FormPanel({
	baseCls: 'x-plain',
	labelWidth: 90,
	labelAlign: 'right',
	lineHeight: 20,
	items: vouchDate
});
// 生成凭证窗口
var CreateVouchWin;


   var createVouch = function () {
   	var selectedRow = itemGrid.getSelectionModel().getSelections();
   	var len = selectedRow.length;
   var Vouchrowid = "";
   	// alert(len);
   	if (len == 0) {
   		Ext.Msg.show({
   			title: '提示',
   			msg: '请选择需要生成凭证的数据！ ',
   			buttons: Ext.Msg.OK,
   			icon: Ext.MessageBox.WARNING
   		});
   		return;
   	}

   	for (var i = 0; i < len; i++) {
   		
   		//var VouchmainID = "";
   		var VouchmainID = selectedRow[i].get('rowid');
   		//var vouchNO = selectedRow[i].data['AcctVoucherCode'];
   		var Status = selectedRow[i].get('AcctVoucherStatus');
   		if (Vouchrowid == "") {
   			Vouchrowid = VouchmainID
   		} else {
   			Vouchrowid = Vouchrowid + "^" + VouchmainID
   		}
   	
   		if (Status == "记账") {
   			Ext.Msg.show({
   				title: '提示',
   				msg: '所选数据中有已经生成凭证的数据,不能重复生成！ ',
   				buttons: Ext.Msg.OK,
   				icon: Ext.MessageBox.WARNING
   			});
   			return;
   		}
   	}

	Ext.Ajax.request({
		url: projUrl + '?action=ifNotConfigured&rowid=' + Vouchrowid + '&AcctBookID=' + acctbookid + "&userid=" + userid,
		method: 'POST',
		success: function (result, request) {
		
	    var jsonData = Ext.util.JSON.decode(result.responseText);
	    if (jsonData.success == 'true') {
		 Ext.MessageBox.confirm('提示', '确定要生成凭证？ ', function (btn) {
   		  if (btn == 'yes') {

   			if (!CreateVouchWin) {
   				CreateVouchWin = new Ext.Window({
   						title: "生成凭证的日期",
   						height: 200,
   						width: 300,
   						bodyStyle: 'padding:30px 10px 0 5px;',
   						buttonAlign: 'center',
   						closeAction: 'hide',
   						items: VouchDatePanel,
   						buttons: [{
   								text: "确定",
   								handler: function () {
   									var VouchDate = vouchDate.getValue();
   									if (VouchDate == "") {
   										Ext.Msg.show({
   											title: '提示',
   											msg: '凭证日期不可为空！ ',
   											buttons: Ext.Msg.OK,
   											icon: Ext.MessageBox.WARNING
   										});
   										return;
   									} else {
   										VouchDate = VouchDate.format('Y-m-d');
   										CreateVouchWin.hide();
   									}
                                  	var selectedRow = itemGrid.getSelectionModel().getSelections();
									var len = selectedRow.length;
                                    var rowid = "";
   									   	for (var i = 0; i < len; i++) {
   		

		//var VouchmainID = "";
                                   var VouchID = selectedRow[i].get('rowid');
                                      //var vouchNO = selectedRow[i].data['AcctVoucherCode'];
                                   var Status = selectedRow[i].get('AcctVoucherStatus');
                                if (rowid == "") {
                                 rowid = VouchID
                                     } else {
                                           rowid = rowid + "^" + VouchID
                                     }
										}
									Ext.Ajax.request({
   										url: projUrl + '?action=CreateVouch&rowid=' + rowid + '&vouchdate=' + VouchDate + '&AcctBookID=' + acctbookid + "&userid=" + userid,
   										method: 'POST',
   										success: function (result, request) {
   											var jsonData = Ext.util.JSON.decode(result.responseText);
   											if (jsonData.success == 'true') {
   												Ext.Msg.show({
   													title: '提示',
   													msg: '生成凭证成功 ',
   													buttons: Ext.Msg.OK,
   													icon: Ext.MessageBox.INFO
   												});
   												var tbarnum = itemGrid.getBottomToolbar();
   												tbarnum.doLoad(tbarnum.cursor);
   											} else if (jsonData.success == 'false') {
												Ext.Msg.show({
   													title: '提示',
   													msg: '生成凭证失败 ',
   													buttons: Ext.Msg.OK,
   													icon: Ext.MessageBox.INFO
   												});
   											} else {
   												Ext.Msg.show({
   													title: '提示',
   													msg: '生成凭证失败 ',
   													buttons: Ext.Msg.OK,
   													icon: Ext.MessageBox.INFO
   												});
   											}
   										},
   										failure: function (result, request) {
   											Ext.Msg.show({
   												title: '错误',
   												msg: '生成凭证失败,请检查网络连接! ',
   												buttons: Ext.Msg.OK,
   												icon: Ext.MessageBox.ERROR
   											});
   										}
   									});

   								}
   							}, {
   								text: "取消",
   								handler: function () {
   									CreateVouchWin.hide();
   								}
   							}
   						]
   					});
   			}
   			CreateVouchWin.show();
   		}
   	});
								
					} else if (jsonData.success == 'false') {
						var information = jsonData.info;
						if (information == "EmptyRecData") {
							Ext.Msg.show({
								title: '提示',
								msg: '凭证信息不存在! ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.INFO
							});
						} else if (information == "Emptydetail") {
							Ext.Msg.show({
								title: '提示',
								width: 350,
								msg: '凭证明细信息不存在,请核查[会计科室对照]以及[凭证模板配置]是否维护了当前账套的信息！',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.INFO
							});
						} else if (information == "NoSubj") {
							Ext.Msg.show({
								title: '提示',
								msg: '会计科目不存在,请确保会计科目的完整性！ ',
								buttons: Ext.Msg.OK,
								icon: Ext.MessageBox.INFO
							});
						} else if (information.split("*")[0] == "NoLoc") {
							var Loc = information.split("*")[1]
								Ext.Msg.show({
									title: '提示',
									width: 300,
									msg: '生成凭证失败！未找到[<span style="color:blue">' + Loc + '</span><br/>]对应的科室类别,请先进行维护！ ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
						} else if (information.split("*")[0] == "NoDept") {
							var Dept = information.split("*")[1]
								//var deptname = information.split("*")[2]
								Ext.Msg.show({
									title: '提示',
									width: 300,
									msg: '生成凭证失败！未找到[<br/><span style="color:blue">' + Dept + '</span><br/>],请在"凭证模板配置"界面进行维护！ ',
									buttons: Ext.Msg.OK,
									icon: Ext.MessageBox.INFO
								});
						}
					} else {
						Ext.Msg.show({
							title: '提示',
							msg: '生成凭证失败 ',
							buttons: Ext.Msg.OK,
							icon: Ext.MessageBox.INFO
						});
					}
				},
				failure: function (result, request) {
					Ext.Msg.show({
						title: '错误',
						msg: '生成凭证失败,请检查网络连接! ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.ERROR
					});
				}
			});

   }
		
	itemGrid.on('cellclick', function (g, rowIndex, columnIndex, e) {
	    if(columnIndex=='14'){
			var records = itemGrid.getSelectionModel().getSelections();   
			var VouchNo = records[0].get("AcctVoucherCode");
			var AcctBookID=records[0].get("bookid");
			var VouchState = '11';
			if(VouchNo!=""){
				var myPanel = new Ext.Panel( {
				layout : 'fit',
				//scrolling="auto"
				html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno='+VouchNo+'&user='+userid+'&acctstate='+VouchState+'&bookID='+AcctBookID+'&SearchFlag='+'3'+'" /></iframe>'
				//frame : true
				});
				var win = new Ext.Window({
							title : '凭证查看',
							width :1090,
							height :620,
							resizable : false,
							closable : true,
							draggable : true,
							resizable : false,
							layout : 'fit',
							modal : false,
							plain : true, // 表示为渲染window body的背景为透明的背景
							//bodyStyle : 'padding:5px;',
							items : [myPanel],
							buttonAlign : 'center',
							buttons : [{
								text : '关闭',
								type : 'button',
								handler : function() {
									win .close();
								}
							}]
				});
				win.show();
			}
	    }else if(columnIndex=='15'){
			var records = itemGrid.getSelectionModel().getSelections();   
			var filename=records[0].get("PdfFile");
			if(filename!=""){
				window.open("ftp://192.168.102.144:21/acct/reportFile/"+filename);
			} 
		}
     });