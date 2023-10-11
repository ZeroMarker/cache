
var projUrl="herp.acct.acctdepartmentincomeexe.csp";
var acctbookid="";
var userid="";
var vouchNO="";
var Vno=document.getElementById("vouchNO").innerHTML;
if(document.getElementById("vouchNO").innerHTML!=""){
	acctbookid=document.getElementById("AcctBookID").innerHTML;
	userid=document.getElementById("userid").innerHTML;
	vouchNO=document.getElementById("vouchNO").innerHTML+"#"+acctbookid;	
}
 //vouchNO="201601010001";
if(vouchNO==""){
 acctbookid=IsExistAcctBook();
 userid = session['LOGON.USERID'];	
	
}
//alert(vouchNO);


 //采集日期
var collStartDate = new Ext.form.DateField({
    id:'collStartDate',
    fieldLabel: '所属月份',
    name : 'collStartDate',
    format : 'Y-m',
    editable : true,
	value:new Date(),
    allowBlank : false,
    emptyText:'请选择年月...',
    plugins: 'monthPickerPlugin',
    width: 120
});
 var collEndDate = new Ext.form.DateField({
		id:'collEndDate',
		name : 'collEndDate',
		format : 'Y-m-d',
		editable : true,
		 value:new Date(),
		allowBlank : false,
		emptyText:'请选择年月...',
		//plugins: 'monthPickerPlugin',
		width: 120
	  
	}); 
	
 //记账日期
 var accountDate = new Ext.form.DateField({
    id:'accountDate',
    fieldLabel: '记账日期',
    name : 'accountDate',
    format : 'Y-m-d',
    editable : true,
	//value:new Date(),
    allowBlank : false,
    emptyText:'请选择年月...',
    width: 120
});
  
  //科室类型
  var departTypeDS=new Ext.data.SimpleStore({
    fields : ['key', 'keyValue'],
	data : [['A', '全部'],['I', '住院'],['O','门诊'],['E','急诊'],['H','体检']]
});
//配置下拉框 
var departType=new Ext.form.ComboBox({
	id:'departType',
	fieldLabel : '科室类型',
	width : 120,
	listWidth : 100,
	store : departTypeDS,
	valueNotFoundText : '',
	displayField : 'keyValue',
	valueField : 'key',
	mode : 'local', // 本地模式
	triggerAction: 'all',
	emptyText:'全部',
	selectOnFocus:true,
	forceSelection : true,
	editable:true
	
});	

//数据状态	
	var dataStatusDS=new Ext.data.SimpleStore({
      fields : ['key', 'keyValue'],
	  data : [['0', '采集'],['1', '记账']]
});
//配置下拉框  单据状态
var  dataStatus=new Ext.form.ComboBox({
	id:' dataStatus',
	fieldLabel : '数据状态',
	width : 120,
	listWidth : 100,
	store : dataStatusDS,
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
		find();
	}
});


//数据采集
 var collectionButton=new Ext.Toolbar.Button({
	text:'财务签收',
	tooltip:'财务签收',        
	iconCls:'dataabstract',
	width:55,
    handler:function(){
		collect();
	}
});

   
//生成PDF
 var createPDFButton=new Ext.Toolbar.Button({
	text:'生成PDF',
	tooltip:'生成PDF',        
	iconCls:'opTion',
	width:55,
    handler:function(){
		createPDF();
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
  
if(vouchNO==""){
  //查询面板
	var queryPanel = new Ext.FormPanel({
		title:'科室收入凭证',
		iconCls : 'createvouch',
		height:115,
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
			items:[
				{
                    xtype:'displayfield',
                    value:'所属月份',
                    style:'padding:0 5px;',  
                   // width:60,
					id:'SDate'
				},collStartDate,						  
				// {
                    // xtype:'displayfield',
                    // value:'--',
                    // style:'line-height: 20px;',  
                    // width:12					
				// },collEndDate,
				{
					xtype:'displayfield',
                    value:'',
                    width:40	
			    },
                {
                    xtype:'displayfield',
                    value:'记账日期',
                    style:'padding:0 5px;'
                    //width:60
                },accountDate,
				{
					xtype:'displayfield',
                    value:'',
                    width:40	
			    },
                {
                    xtype:'displayfield',
                    value:'科室类型',
                    style:'padding:0 5px;'
                    //width:60
                },departType,
				{
					xtype:'displayfield',
                    value:'',
                    width:40	
				},{
                    xtype:'displayfield',
                    value:'数据状态',
                   style:'padding:0 5px;'
                    //width:60
                },dataStatus,
				{
					xtype:'displayfield',
                    value:'',
                    width:40	
				},findButton
			]
		},{
			columnWidth:1,
			xtype: 'panel',
			layout:"column",
			width:1200,
			items:[
				collectionButton,{
					xtype:'displayfield',
                    value:'',
                    width:40	
			    },createPDFButton,{
					xtype:'displayfield',
                    value:'',
                    width:40	
			    },createVouch 
			]
		}]	
	});
}else if(vouchNO!=""){	
	var queryPanel =new Ext.FormPanel({
		region:'north',
		frame:true,
		height:80,		
		items:[			
			{
                xtype:'displayfield',
                value:'科室收入明细表',
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
           iconCls : 'list',
			region: 'center',
			title:'科室收入数据总表',
			url : projUrl,
			atLoad : false, // 是否自动刷新
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
				},
				{
					id:'bookid',
					header:'<div style="text-align:center">BookID</div>',
					width:50,
					editable : false,
					align:'left',
					allowBlank : false, 
					hidden : true,				
					dataIndex : 'bookid'
				},
				{
					id:'BillNo',
					header:'<div style="text-align:center">业务编码</div>',
					width : 120,
					align:'center',
					editable : false,
					allowBlank : true,     
					dataIndex : 'BillNo'
				},{
					id:'DateRange',
					header:'<div style="text-align:center">所属月份</div>',
					width : 150,
					align:'center',
					editable : false,				  
					dataIndex : 'DateRange'
				},
				{
					id:'CollectPerson',
					header:'<div style="text-align:center">签收人员</div>',
					width : 100,
					align:'center',
					editable : false,
					allowBlank : true,     
					dataIndex : 'CollectPerson'
				},
				{
					id:'CollectDate',
					header:'<div style="text-align:center">签收时间</div>',
					width : 90,
					align:'center',
					editable : false,
					allowBlank : true,    
					dataIndex : 'CollectDate'
				},
				{
					id:'AcctAmount',
					header:'<div style="text-align:center">总金额</div>',
					width : 100,
					align:'right',
					editable : false,
					allowBlank : true, 
					// hidden:true,       
					dataIndex : 'AcctAmount'
				},
				{
					id:'DataStatus',
					header:'<div style="text-align:center">数据状态</div>',
					width : 100,
					align:'center',
					editable : false,
					allowBlank : true, 
					// hidden:true,       
					dataIndex : 'DataStatus'
				},
				{
					id:'PostPerson',
					header:'<div style="text-align:center">记账人</div>',
					width : 100,
					align:'center',
					editable : false,
					allowBlank : true,  
					dataIndex : 'PostPerson'
				},
				{
					id:'PostDate',
					header:'<div style="text-align:center">记账日期</div>',
					width : 90,
					// align:'left',
					align: 'center',
					editable : false,
					allowBlank : true,     
					dataIndex : 'PostDate'
				},
				{
					id:'VounchNo',
					header:'<div style="text-align:center">凭证号</div>',
					width : 120,
					align:'center',
					editable : false,
					allowBlank : true, 
                    renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
						},				  
					dataIndex : 'VounchNo'
				},
				{
					id:'PdfUrl',
					header : 'PDF文件',
					editable : false,
					align : 'center',
					width:100,
					renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
						return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
					},
					dataIndex : 'PdfUrl'
				}],
	sm : new Ext.grid.RowSelectionModel({	singleSelect : true	}),
	split : true,
	collapsible : true,
	containerScroll :true,
	xtype : 'grid',
	stripeRows : true,
	//loadMask : true,
	height:250,
	trackMouseOver: true
    });
    
	itemGrid.btnAddHide();
    itemGrid.btnSaveHide();
    itemGrid.btnResetHide();
    itemGrid.btnDeleteHide();
    itemGrid.btnPrintHide();
if(vouchNO!=""){
	itemGrid.load(({params:{start:0,limit:25,VouchNO:vouchNO}}));
}
itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var rowid='';
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	rowid=selectedRow[0].data['rowid'];	
	itemGridf.load({params:{start:0, limit:25,rowid:rowid}});	
});


var find=function(){
	
	var CollStartDate=collStartDate.getValue();
	if(CollStartDate!=""){
		CollStartDate=CollStartDate.format('Y-m');  
	}	
	// var CollEndDate=collEndDate.getValue();
	// if(CollEndDate!=""){
		// CollEndDate=CollEndDate.format('Y-m-d');  
	// }	
	var AccountDate=accountDate.getValue();
	if(AccountDate!=""){
		AccountDate=AccountDate.format('Y-m-d');  
	}		  
	var DepartType=departType.getValue();
	var DataStatus=dataStatus.getValue();
	  
	itemGrid.load({
		params:{		
			sortField:'',
			sortDir:'',
		    start:0,
		    limit:25,
			collStartDate:CollStartDate,
			//collEndDate:CollEndDate,
			accountDate:AccountDate, 
			departType:DepartType, 
			dataStatus:DataStatus
			}
	  });	
     
	itemGridf.load({params:{start:0, limit:25,rowid:""}});	  
};

var createPDF=function(){
	var URL="";
	Ext.Ajax.request({
        url:projUrl+'?action=GetURL&AcctBookID='+ acctbookid,
        method: 'GET',
        success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true'){
				var URL= jsonData.info;	
				//alert(URL);		
				callback(URL);
            }
        }		 
	});	
	function callback(URL){
		var selectedRow = itemGrid.getSelectionModel().getSelections();
		var len=selectedRow.length;
		var rowidd="";
		// alert(len);
		if(len==0){
			Ext.Msg.show({
				title:'提示',msg:'请选择需要生成pdf文件的数据！ ',
				buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING		  
			});
			return;
        }else{
			for(var i=0;i<len;i++){
				pdffile=selectedRow[i].data['PdfUrl'];
				if(pdffile!=""){
					Ext.Msg.show({
						title:'提示',msg:'所选数据中有已经生成pdf文件的数据,不能重复生成！ ',
						buttons:Ext.Msg.OK,icon:Ext.MessageBox.WARNING		  
					});
					return;	
				}
				rowidd=selectedRow[i].data['rowid'];  
				var pdfloadUrl= "http://"+ URL+"/herpacctPDFcreate/CreatePDFServlet"
				Ext.Ajax.request({			
					url:pdfloadUrl,
					waitMsg:'数据生成中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success==true){
							Ext.Msg.show({title:'注意',msg:'生成PDF成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});	
							var tbarnum = itemGrid.getBottomToolbar();  
							tbarnum.doLoad(tbarnum.cursor);
						}else{
							Ext.Msg.show({title:'错误',msg:'生成失败',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					},
					params:{rowid:rowidd},
					scope: this
				});		
			}				
		}						
	}	
}  
    
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
   		var Status = selectedRow[i].get('DataStatus');
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
											var VouchID = selectedRow[i].get('rowid');
											//var vouchNO = selectedRow[i].data['AcctVoucherCode'];
											var Status = selectedRow[i].get('DataStatus');
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
								}]
							});
						}
						CreateVouchWin.show();
					}
				});
			} else if (jsonData.success == 'false') {
				var information = jsonData.info;
				var ZY = information.split("^")[0]
				var MZ = information.split("^")[1]
				if (ZY == "EmptyRecData") {
					Ext.Msg.show({
						title: '提示',
						msg: '住院收入的凭证信息不存在! ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (MZ == "EmptyRecData") {
					Ext.Msg.show({
						title: '提示',
						msg: '门诊收入的凭证信息不存在! ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (ZY == "Emptydetail") {
					Ext.Msg.show({
						title: '提示',
						width: 350,
						msg: '住院收入的凭证明细信息不存在,请核查[会计科室对照]以及[凭证模板配置]是否维护了当前账套的信息！',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (MZ == "Emptydetail") {
					Ext.Msg.show({
						title: '提示',
						width: 350,
						msg: '门诊收入的凭证明细信息不存在,请核查[会计科室对照]以及[凭证模板配置]是否维护了当前账套的信息！',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (ZY == "NoSubj") {
					Ext.Msg.show({
						title: '提示',
						msg: '住院收入的会计科目不存在,请确保会计科目的完整性！ ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (MZ == "NoSubj") {
					Ext.Msg.show({
						title: '提示',
						msg: '门诊收入的会计科目不存在,请确保会计科目的完整性！ ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (ZY.split("*")[0] == "NoLoc") {
					var Loc = ZY.split("*")[1]
					Ext.Msg.show({
						title: '提示',
						width: 300,
						msg: '生成凭证失败！未找到[<span style="color:blue">' + Loc + '</span><br/>]对应的科室类别,请先进行维护！ ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (MZ.split("*")[0] == "NoLoc") {
					var Loc = MZ.split("*")[1]
					Ext.Msg.show({
						title: '提示',
						width: 300,
						msg: '生成凭证失败！未找到[<span style="color:blue">' + Loc + '</span><br/>]对应的科室类别,请先进行维护！！ ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (ZY.split("*")[0] == "NoDept") {
					var Dept = ZY.split("*")[1]
					//var deptname = ZY.split("*")[2]
					Ext.Msg.show({
						title: '提示',
						width: 300,
						msg: '生成凭证失败！未找到[<br/><span style="color:blue">' + Dept + '</span><br/>],请在"凭证模板配置"界面进行维护！ ',
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.INFO
					});
				} else if (MZ.split("*")[0] == "NoDept") {
					var Dept = MZ.split("*")[1]
					//var deptname = MZ.split("*")[2]
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

itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
        
	    if(columnIndex=='12'){
			//p_URL = 'acct.html?acctno=2';
		    //document.getElementById("frameReport").src='acct.html';
			var records = itemGrid.getSelectionModel().getSelections();   
			var VouchNo = records[0].get("VounchNo");
			var AcctBookID=records[0].get("bookid");
			//alert(AcctBookID);
			var VouchState = '11';
			if(VouchNo!=""){
			var myPanel = new Ext.Panel({
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
									win.close();
									}
								}]
					});
					win.show();
				}
	    }else if(columnIndex=='13'){
			var records = itemGrid.getSelectionModel().getSelections();   
			var filename=records[0].get("PdfUrl");			
			if(filename!=""){	 
				window.open("../scripts/herp/acct/AcctDepartmentIncom/pdf/"+filename);
			}
		}
     });
	 
