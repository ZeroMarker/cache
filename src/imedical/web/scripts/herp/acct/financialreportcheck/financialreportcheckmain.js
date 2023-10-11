var FinancialUrl ="../csp/herp.acct.financialreportcheckexe.csp";
var userid = session['LOGON.USERID'];//登录人ID
var AcctBook=IsExistAcctBook();
//期间类型
var PerTypeStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['M', '月'], ['S', '季度'], ['H', '半年'], ['Y', '年']]
		});
var PerTypeField = new Ext.form.ComboBox({
			id : 'PerTypeField',
			fieldLabel : '期间类型',
			width : 70,
			listWidth : 125,
			selectOnFocus : true,
			allowBlank : false,
			store : PerTypeStore,
			anchor : '90%',
			value:'M', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : false,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true,
			listeners: {
               select: function(){ 
			         var PerType=Ext.getCmp('PerTypeField').getValue();
			         SPeriodDs.proxy=new Ext.data.HttpProxy({
	                 url:FinancialUrl+'?action=GetPeriod&PerType='+PerType+'&BookID='+AcctBook,
				     method:'POST'
				  });
				  EPeriodDs.proxy=new Ext.data.HttpProxy({
	                 url:FinancialUrl+'?action=GetPeriod&PerType='+PerType+'&BookID='+AcctBook,
				     method:'POST'
				  });
				  SPeriodField.setValue("");
				  EPeriodField.setValue("");
				  SPeriodDs.load({params : {start:0,limit:10}});
				  EPeriodDs.load({params : {start:0,limit:10}});
			   }
            }
		});
		
//会计期间(开始)
var SPeriodDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
 SPeriodDs.proxy=new Ext.data.HttpProxy({
	                 url:FinancialUrl+'?action=GetPeriod&PerType='+Ext.getCmp('PerTypeField').getRawValue()+'&BookID='+AcctBook,
				     method:'POST'
				  });
var SPeriodField = new Ext.form.ComboBox({
	id: 'SPeriodField',
	fieldLabel: '会计期间',
	width:100,
	listWidth : 225,
	allowBlank: false,
	store: SPeriodDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择单位名称...',
	name: 'SPeriodField',
	minChars: 1,
	pageSize: 12,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


//会计期间(结束)
var EPeriodDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
 EPeriodDs.proxy=new Ext.data.HttpProxy({
	                 url:FinancialUrl+'?action=GetPeriod&PerType='+Ext.getCmp('PerTypeField').getRawValue()+'&BookID='+AcctBook,
				     method:'POST'
				  });
var EPeriodField = new Ext.form.ComboBox({
	id: 'EPeriodField',
	fieldLabel: '会计期间',
	width:100,
	listWidth : 225,
	allowBlank: false,
	store: EPeriodDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择单位名称...',
	name: 'EPeriodField',
	minChars: 1,
	pageSize: 12,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//报表状态
var RepState = new Ext.data.SimpleStore({
	fields:['key','keyValue'],
	data:[['0','编制'],['1','审核']]
});
var RepStateField = new Ext.form.ComboBox({
	id: 'RepStateField',
	fieldLabel: '是否当前帐套',
	width:100,
	listWidth : 130,
	selectOnFocus: true,
	allowBlank: true,
	store: RepState,
	//anchor: '90%',
	valueNotFoundText:'',
	displayField: 'keyValue',
	valueField: 'key',
	triggerAction: 'all',
	//emptyText:'选择期间类型...',
	mode: 'local', //本地模式
	editable:true,
	//pageSize: 10,
	minChars: 1,
	selectOnFocus:true,
	forceSelection:true
});
//选择复选框
var SelectChbox = new Ext.form.Checkbox({ 
            id : 'SelectChbox', 
            name : "SelectChbox", 
            autoScroll : false, 
			//height:4,
            //width : 90, 
            anchor : "70%", 
            hideLabel : true
});	
//查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'find',
	handler: function(){
				//alert(year);
				//var bookID= GetAcctBookID();
				
                 if(AcctBook==""){
                  AcctBook=GetAcctBookID();
                 }
                
				var PerType = PerTypeField.getValue();
				var SPeriod = SPeriodField.getValue();
				var EPeriod = EPeriodField.getValue();
				var RepState= RepStateField.getValue();
				itemGrid.load({params:{start:0,limit:25,PerType:PerType,SPeriod:SPeriod,EPeriod:EPeriod,RepState:RepState,AcctBook:AcctBook}});
	}
});

var CheckButton = new Ext.Toolbar.Button({
	text: '批量审核',
	tooltip: '批量审核',
	iconCls: 'audit',
	handler: function(){
		    var RowIdStr="";
			var RepStr  ="";
			var type="";
			var yearmonth="";
			/*
			itemGrid.store.each(function (record) {  
                if(record.get('selecteds')===true)
				{
				  if(record.get('Repstate')=="审核"){
				     if(RepStr!=""){
					    RepStr=RepStr+"、"+record.get('RepName');
					 }
				     else{
					    RepStr=record.get('RepName');
					 }
				  }
				  else{
				     if(RowIdStr!=""){
					    RowIdStr=RowIdStr+"^"+record.get('rowid');
					 }
					 else{
					    RowIdStr=record.get('rowid');
					 } 
				  }
				}
            }); 
			if((RowIdStr==="")&&(RepStr==="")){
			    Ext.Msg.show({
					title : '注意',
					msg : '请选择要审核的模板!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		        return;
			} 
			var PerType =Ext.getCmp("PerTypeField").getValue();         //期间类型
			var SPeriod =Ext.getCmp("SPeriodField").getValue();         //会计期间(开始)
		    var EPeriod =Ext.getCmp("EPeriodField").getValue();         //会计期间(结束)
		    var RepState=Ext.getCmp("RepStateField").getValue();        //报表状态
			var CheckUrl =FinancialUrl+'?action=Checked&data='+RowIdStr;
			if(RepStr!==""){
			RepStr="您所选的模板中，"+RepStr+"已经审核，将不会审核，是否确认审核其余未审核模板?"
			}
			else{
			RepStr="是否确定审核所选数据？"
			}
			*/
			var records=itemGrid.getSelectionModel().getSelections();
			var length=records.length;
			if(length<1){
				  Ext.Msg.show({
					title : '注意',
					msg : '请选择要审核的模板! ',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.WARNING
				});
		        return;
				
			}
			
			for(i=0;i<length;i++){
				var rowid=records[i].data["ReportTempletID"];
				var status=records[i].data["Repstate"];
				var rpeName=records[i].data["RepName"];
				var periodType=records[i].data["PeriodType"];
				//alert(periodType=="月");
				if(periodType=="月"){
					//alert("mmmm");
				var periodType="M" 
				
				}else if(periodType=="季度"){
					var periodType="S"
				}else if(periodType=="半年"){
					var periodType="H"
				}else if(periodType=="年"){
					var periodType="Y"
				}
				
				var AcctMonth=records[i].data["YearMonth"]
				//alert(status+rpeName);
				if(status=="审核"){
					RepStr=RepStr+rpeName+"、";
				}
				if((RowIdStr=="")&&(status!="审核")){
					RowIdStr=rowid;
					type=periodType;
					yearmonth=AcctMonth
				}else if((RowIdStr!="")&&(status!="审核")){
					RowIdStr=RowIdStr+"^"+rowid;
					type=type+"^"+periodType
					yearmonth=yearmonth+"^"+AcctMonth
				}
								
				
			}
			 //alert(RowIdStr+"^"+type+"^"+yearmonth);
			if((RepStr!=="")&&(RowIdStr!="")){
				
			RepStr="您所选的模板中，"+RepStr+"已经审核将不会审核，是否确认审核其余未审核模板? "
			}else if((RepStr!=="")&&(RowIdStr=="")){
				 Ext.Msg.show({
					title:'提示',
					msg:'数据已审核 ',
					buttons:Ext.Msg.OK,
					icon:Ext.MessageBox.WARNING
				});
	            return;
			}
			else{
			RepStr="是否确定审核所选数据？ "
			}
			
			var PerType =Ext.getCmp("PerTypeField").getValue();         //期间类型
			var SPeriod =Ext.getCmp("SPeriodField").getValue();         //会计期间(开始)
		    var EPeriod =Ext.getCmp("EPeriodField").getValue();         //会计期间(结束)
		    var RepState=Ext.getCmp("RepStateField").getValue();        //报表状态
			var CheckUrl =FinancialUrl+'?action=Checked&data='+RowIdStr+'&type='+type+'&yearmonth='+yearmonth;
			Ext.MessageBox.confirm("提示", RepStr, function (id) {
			   if(id=="yes"){
			     if(RowIdStr!=""){
				   itemGrid.saveurl(CheckUrl);
		           itemGrid.load({params : {start:0,limit:25,PerType:PerType,SPeriod:SPeriod,EPeriod:EPeriod,RepState:RepState}});
				 }  
			   }        			 
			 return ;
			 });  		
	  return;	
	}
});
var report=new Ext.Toolbar.Button({
	text:'生成报表数据',
	tooltip:'生成报表数据', 
	iconCls: 'add',
	handler:function(){
		createData();
		}
});

var queryPanel = new Ext.FormPanel({
	     title: '财务报表审核',
	     iconCls:'audit',
		region: 'north',
		height: 75,
		frame: true,
		defaults: {
			bodyStyle: 'padding:5px '
		},
		items: [{
				xtype: 'panel',
				layout: 'column',
				hideLabel: true,
				width: 1200,
				items: [{
						xtype: 'displayfield',
						value: '期间类型',
						style: 'padding : 0 5px;'
						//width: 60
					}, PerTypeField,  {
						xtype: 'displayfield',
						value: '',
						width: 40
					}, {
						xtype: 'displayfield',
						value: '会计期间',
						style: 'padding : 0 5px;'
						//width: 60
					}, SPeriodField, {
						xtype: 'displayfield',
						value: '至',
						style: 'padding : 0 5px;'
					}, EPeriodField,{
						xtype: 'displayfield',
						value: '',
						width: 40
					},{
						xtype: 'displayfield',
						value: '报表状态',
						style: 'padding : 0 5px;'
						//width: 60
					}, RepStateField, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, findButton,{
						xtype: 'displayfield',
						value: '',
						style: 'line-height: 15px;',
						width: 30
					}, CheckButton, {
						xtype: 'displayfield',
						value: '',
						width: 30
					}, 
					report
				]
			}
		]

	});
	
var itemGrid = new dhc.herp.Grid({
       // title: '财务报表审核',
        width: 400,
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
		//tbar:['期间类型：',PerTypeField,'-','会计期间：',SPeriodField,'--',EPeriodField,'-','报表状态：',RepStateField,'-',findButton,'-',CheckButton,'-',report],
        url: FinancialUrl,	  
		atLoad : false, // 是否自动刷新
		loadmask:true,
		listeners :{
		'cellclick':function(grid, rowIndex, columnIndex, e) {
			var record = grid.getStore().getAt(rowIndex);
			var repcode=record.get("RepCode");
			var PeriodType=record.get("PeriodType");
			if(PeriodType=="月"){
				var PeriodType="M" 
				}else if(PeriodType=="季度"){
					var PeriodType="S"
				}else if(PeriodType=="半年"){
					var PeriodType="H"
				}else if(PeriodType=="年"){
					var PeriodType="Y"
				}
			var YearMonth=record.get("YearMonth");
			var year=YearMonth.substring(0,4);
			var month=YearMonth.substring(4,6);
			
			var data=year+"^"+month+"^"+PeriodType+"^"+userid
			//var report=document.getElementById("report");
			//alert(data);
			if(columnIndex==4){
				
		     if(repcode=="KY01"){
			var myPanel = new Ext.Panel( {
			layout : 'fit',
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="dhccpmrunqianreport.csp?reportName=herp.acct.AssetsLiabilites.raq&year='+year+'&frequency='+PeriodType+'&period='+month+'&userid='+userid+'" /></iframe>'
			//frame : true
			});
			var win = new Ext.Window({
						//title : '资产负债表数据审核',
						width :1150,
						height :580,
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
					
			 }else if(repcode=="KY02"){
		    var myPanel = new Ext.Panel( {
			layout : 'fit',
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="dhccpmrunqianreport.csp?reportName=herp.acct.IncomePaymentTotal.raq&year='+year+'&frequency='+PeriodType+'&period='+month+'&userid='+userid+'" /></iframe>'
			//frame : true
			});
			var win = new Ext.Window({
						//title : '收入费用总表数据审核',
						width :1150,
						height :580,
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
					
					 
		 }else if(repcode=="KY0201"){
			var myPanel = new Ext.Panel( {
			layout : 'fit',
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="dhccpmrunqianreport.csp?reportName=herp.acct.IncomePaymentDetail.raq&year='+year+'&frequency='+PeriodType+'&period='+month+'&userid='+userid+'" /></iframe>'
			//frame : true
			});
			var win = new Ext.Window({
						//title : '医疗收入费用明细表数据审核',
						width :1150,
						height :580,
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
		}else if(repcode=="KY03"){
		    var myPanel = new Ext.Panel( {
			layout : 'fit',
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="dhccpmrunqianreport.csp?reportName=herp.acct.CashFlowT.raq&year='+year+'&userid='+userid+'" /></iframe>'
			//frame : true
			});
			var win = new Ext.Window({
						//title : '现金流量表数据审核',
						width :1150,
						height :580,
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
					 
		}else if(repcode=="KY04"){
		   var myPanel = new Ext.Panel( {
			layout : 'fit',
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="dhccpmrunqianreport.csp?reportName=herp.acct.FinancialAidPayments.raq&year='+year+'&userid='+userid+'" /></iframe>'
			//frame : true
			});
			var win = new Ext.Window({
						//title : '财政补助收支情况表数据审核',
						width :1150,
						height :580,
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
					 
				 }else if(repcode=="KY05"){
			var myPanel = new Ext.Panel( {
			layout : 'fit',
			html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="dhccpmrunqianreport.csp?reportName=herp.acct.AcctPayOutEconomyAnalysis.raq&year='+year+'&frequency='+PeriodType+'&period='+month+'&userid='+userid+'" /></iframe>'
			//frame : true
			});
			var win = new Ext.Window({
						//title : '医疗收入费用明细表数据审核',
						width :1150,
						height :580,
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
			}
			 
		}
		},
		
        fields: [
		new Ext.grid.CheckboxSelectionModel({editable:false}),
		{
			header : 'RowID',
			dataIndex : 'ReportTempletID',
			width : 40,
			hidden:'true',
			sortable : true

		}, 
		/*
		{
			header : '选择',
			dataIndex : 'selecteds',
			width : 60,
			type:SelectChbox,
			renderer: function (v) { return '<input type="checkbox"'+(v=="1"?" checked":"")+'/>'; },//根据值返回checkbox是否勾选
			sortable : true

		},*/
		{
			header : '报表编码',
			dataIndex : 'RepCode',
			width : 110,
			editable:false,
			sortable : true
		}, {
			header : '报表名称',
			dataIndex : 'RepName',
			renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>'	
						},   
			width : 140,
			//align:'right',
			editable:false,
			sortable : true
		}, {
			header : '年月',
			dataIndex : 'YearMonth',
			width : 100,
			align:'center',
			editable:false,
			sortable : true
		}, {
			header : '期间类型',
			dataIndex : 'PeriodType',
			width : 100,
			align:'center',
			
			editable:false,
			sortable : true
		}, {
			header : '报表说明文件',
			dataIndex : 'RepDesc',
			width : 120,
			align:'center',
			renderer : function(v, p, r) {
						  return '<span style="color:blue;cursor:hand"><u>查看</u></span>';						
						},
			editable:false,
			sortable : true
		}, {
			header : '报表状态',
			dataIndex : 'Repstate',
			width : 100,
			align:'center',
			editable:false,
			sortable : true
		}, {
			header : '归档文件',
			dataIndex : 'Pigeonhole',
			width : 100,
			editable:false,
			hidden:true,
			renderer : function(v, p, r) {
						  return '<span style="color:blue;cursor:hand"><u>连接PDF文件</u></span>';								
						},
			align:'center',
			sortable : true
		}, {
			header : '编制人',
			dataIndex : 'Editor',
			width : 100,
			align:'center',
			editable:false,
			sortable : true
		}, {
			header : '编制时间',
			dataIndex : 'EditDate',
			width : 100,
			align:'center',
			editable:false,
			sortable : true
		}, {
			header : '审核人',
			dataIndex : 'Checker',
			width : 100,
			align:'center',
			editable:false,
			sortable : true
		}, {
			header : '审核时间',
			dataIndex : 'CheckDate',
			width : 100,
			align:'right',
			editable:false,
			sortable : true
		}] 
});

itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	// alert(columnIndex)
	// 前置方案设置
	if (columnIndex == 7) {
		var filename="";
		var server="";
		var path="";
		var records = itemGrid.getSelectionModel().getSelections();
	    var repCode=records[0].get("RepCode");
		var RepName=records[0].get("RepName");
		 //alert(repCode);
		Ext.Ajax.request({
        url:FinancialUrl+'?action=GetFileName&AcctBook='+ AcctBook+'&RepCode='+repCode,
        method: 'GET',
        success: function(result, request) {
        var jsonData = Ext.util.JSON.decode( result.responseText );
		var result=jsonData.info;
        if (jsonData.success=='true'){
			filename=result.split("*")[0];
			server=result.split("*")[1];
			path=result.split("*")[2];
			//alert(server+path);
			if(filename==""){
				  Ext.Msg.show({
						title : '提示',
						msg : '未上传文件! ',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
						});
		    return;
				
			}else{
	     // window.open("ftp://192.168.102.144:21/acct/reportFile/"+filename); 
		  window.open("ftp://"+server+"/"+path+"/"+filename); 
                  }
		}
             }
	});
	
	}
}); 



	itemGrid.btnAddHide() 	//隐藏增加按钮
	itemGrid.btnSaveHide() 	//隐藏保存按钮
	itemGrid.btnResetHide() 	//隐藏重置按钮
	itemGrid.btnDeleteHide() //隐藏删除按钮
	itemGrid.btnPrintHide() 	//隐藏打印按钮
	itemGrid.load(({params:{start:0,limit:25,AcctBook:AcctBook}}));