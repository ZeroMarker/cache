
var projUrl="herp.acct.acctPersonnelWagesexe.csp";
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
    plugins: 'monthPickerPlugin'
});

///////////////工资方案////////////////////////////  
var WageSchemeDs = new Ext.data.Store({
			autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
WageSchemeDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=getSchemeName',method:'POST'
					});
		});
var WageSchemeCombo = new Ext.form.ComboBox({
			fieldLabel : '工资方案',
			store : WageSchemeDs,
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
			selectOnFocus : true
		});
  

//////////////////////单据状态///////////////////////	
var StatusDS=new Ext.data.SimpleStore({
    fields : ['key', 'keyValue'],
	data : [['1', '未记账'],['2', '记账']]
});
//配置下拉框  单据状态
var StatusCombo=new Ext.form.ComboBox({
	id:'StatusCombo',
	fieldLabel : '单据状态',
	width : 120,
	listWidth : 100,
	store : StatusDS,
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

//查询按钮
var findButton=new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',        
	iconCls:'find',
	width:55,
    handler:function(){
		var Month=YearMonth.getValue();	  
		var WageScheme=WageSchemeCombo.getValue();	
		var Status=StatusCombo.getValue();
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
				WageScheme:WageScheme,
				Status:Status,
				VouchNO:vouchNO
			}
		});	
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
   
//生成凭证按钮 
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
		title:'人事工资凭证',
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
			items: [{
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
						value:'工资方案',
						style:'padding:0 5px;'   
						//width:60
					},WageSchemeCombo,
					{
						xtype:'displayfield',
						value:'',
						width:40	
					},{
						xtype:'displayfield',
						value:'单据状态',
						style:'padding:0 5px;' 
						//width:60
					},StatusCombo,
							  
					{
						xtype:'displayfield',
						value:'',
						width:40	
					},findButton,
					{
						xtype:'displayfield',
						value:'',
						width:40	
					},createVouch
		    ]}/* ,{
				columnWidth:1,
				xtype: 'panel',
				layout:"column",
				items:[{
						xtype:'displayfield',
						value:'凭证日期:',
						style:'line-height: 20px;',  
						width:60
					},vouchDate,
					{
						xtype:'displayfield',
						value:'',
						width:100	
					},createVouch
				]
			} */
		]	
	});
}else if(vouchNO!=""){	
	var queryPanel =new Ext.FormPanel({
		region:'north',
		frame:true,
		height:80,		
		items:[			
			{
                xtype:'displayfield',
                value:'人事工资会计记账表',
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
           iconCls:'list',
			region: 'center',
			title:'人事工资主表',
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
					id:'WagesDate',
					header:'<div style="text-align:center">所属日期</div>',
					width : 100,
					align:'center',
					editable : false,
					allowBlank : true,     
					dataIndex : 'WagesDate'
				},{
				  id:'WageSchemeCode',
				  header:'<div style="text-align:center">工资方案编码</div>',
				  width : 150,
				  align:'left',
				  editable : false,
				  allowBlank : true,     
				  dataIndex : 'WageSchemeCode'
				},{
				  id:'SchemeName',
				  header:'<div style="text-align:center">工资方案名称</div>',
				  width : 180,
				  align:'left',
				  editable : false,
				  allowBlank : true,    
				  dataIndex : 'SchemeName'
				},{
					id:'AcctVoucherStatus',
					header:'<div style="text-align:center">数据状态</div>',
					width : 100,
					align:'center',
					editable : false,
					allowBlank : true,  
					dataIndex : 'AcctVoucherStatus'
				},{
					id:'AcctVoucherUser',
					header:'<div style="text-align:center">记账人</div>',
					width : 120,
					align: 'center',
					editable : false,
					allowBlank : true,     
					dataIndex : 'AcctVoucherUser'
				},{
					id:'AcctVoucherDate',
					header:'<div style="text-align:center">记账日期</div>',
					width : 150,
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
				} ,{
					id:'PdfFile',
					header : 'PDF文件',
					editable : false,
					align : 'center',
					width:120,					
					renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
						return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
						},
					dataIndex : 'PdfFile'
				} ],
	sm : new Ext.grid.RowSelectionModel({singleSelect : true}),
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

// 单击人事工资主表 刷新 工资方案明细信息
itemGrid.on('rowclick', function(grid, rowIndex, e) {
	showWagesDetail(grid, rowIndex, e)
});
   
//生成凭证 
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
	var rowid = "";
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
  							
  							for (var i = 0; i < len; i++) {
  								var mainID = selectedRow[i].data['WageSchemeCode'];
  								var state = selectedRow[i].data['AcctVoucherStatus'];
  								//alert(vouchNO)
  								if (rowid == "") {
  									rowid = mainID
  								} else {
  									rowid = rowid + "^" + mainID
  								}
  								if (state == "记账") {
  									Ext.Msg.show({
  										title: '提示',
  										msg: '所选数据中有已经生成凭证的数据,不能重复生成！ ',
  										buttons: Ext.Msg.OK,
  										icon: Ext.MessageBox.WARNING
  									});
  									return;
  								}
  							}
  							
  							//alert(rowid+" "+VouchDate);
  							Ext.MessageBox.confirm('提示', '确定要生成凭证？ ', function (btn) {
  								if (btn == 'yes') {
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
  															msg: '生成凭证失败！未找到[' + Loc + ']对应的科室类别,请先进行维护！ ',
  															buttons: Ext.Msg.OK,
  															icon: Ext.MessageBox.INFO
  														});
  												} else if (information.split("*")[0] == "NoDept") {
  													var Dept = information.split("*")[1]
  														var deptname = information.split("*")[2]
  														Ext.Msg.show({
  															title: '提示',
  															width: 300,
  															msg: '生成凭证失败！未找到[' + Dept + ']对应的[' + deptname + '],请在"凭证模板维护界面"进行维护！ ',
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

itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e){   
	    if(columnIndex=='10'){
			var records = itemGrid.getSelectionModel().getSelections();   
			var VouchNo = records[0].get("AcctVoucherCode");
			var AcctBookID=records[0].get("bookid");
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
									win .close();
								}
							}]
				});
				win.show();
			}
	    }else if(columnIndex=='11'){
			var records = itemGrid.getSelectionModel().getSelections();   
			var filename=records[0].get("PdfFile");
			if(filename!=""){
				window.open("ftp://192.168.102.144:21/acct/reportFile/"+filename);
			} 
		}
});


// 显示工资方案明细
function showWagesDetail(grid, rowIndex, e){
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	SchemeCode=selectedRow[0].data['WageSchemeCode'];
	
	var Month=YearMonth.getValue();	
	if(Month!=""){		
		Month=Month.format('Y-m');
	}
	wagesitemgrid.setTitle("工资方案明细信息");
	Ext.Ajax.request({
		url : projUrl+'?action=GetGridTitle&SchemeCode='+SchemeCode,
		waitMsg : '正在核算中...',
		failure : function(result, request) {
			Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
		},
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			var cmItems = [];
			var cmConfig = {};
			// cmItems.push(sm);
			cmItems.push(new Ext.grid.RowNumberer());
			var cmConfig = {};
			var jsonHeadNum = jsonData.results;		
			var jsonHeadList = jsonData.rows;
			//alert(jsonHeadList.length);
			var tmpDataMapping = [];				
			for (var i = 0; i < jsonHeadList.length; i++) {
				if (i<3) { 
					if (i==1){
						cmConfig = {
						header :jsonHeadList[i].title,
						dataIndex : jsonHeadList[i].IndexName,
						width : 130,
						sortable : true,
						align : 'left',
						hidden : true,//隐藏科室编码列
						editor : new Ext.form.TextField({
									allowBlank : true
								})
						}						
					}else(
						cmConfig = {
							header :jsonHeadList[i].title,
							dataIndex : jsonHeadList[i].IndexName,
							width : 130,
							sortable : true,
							align : 'left',
							editor : new Ext.form.TextField({
									allowBlank : true
								})
						}
					)					
				}else if(i<jsonHeadList.length-1){
					cmConfig = {
						header : jsonHeadList[i].title,
						//type:'numberField',
						dataIndex : jsonHeadList[i].IndexName,
						width : 100,
						sortable : true,
						align : 'right',
						editor : new Ext.form.NumberField({
									allowBlank : true				
								})
					};
				}else{
					cmConfig = {
						header : jsonHeadList[i].title,
						dataIndex : jsonHeadList[i].IndexName,
						width : 130,
						sortable : true,
						align : 'left',
						editor : new Ext.form.TextField({
									allowBlank : true	
								})
					}
				}
				cmItems.push(cmConfig);
				tmpDataMapping.push(jsonHeadList[i].IndexName);
			}

			// 工资项数据
			var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
			// return false tmpDataMapping
			tmpStore.proxy = new Ext.data.HttpProxy({
				url : projUrl+'?action=ListDetail&SchemeCode='+SchemeCode+'&YearMonth='+Month,
				method : 'POST'
			})
			tmpStore.reader = new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, tmpDataMapping);
			wagesitemgrid.reconfigure(tmpStore, tmpColumnModel);
			tmpStore.load({
						params : {
							start : 0,
							limit : jxUnitPagingToolbar.pageSize
						}
					});
			jxUnitPagingToolbar.bind(tmpStore);
		},
		scope : this
	});
}

