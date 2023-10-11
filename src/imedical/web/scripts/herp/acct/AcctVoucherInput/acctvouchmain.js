var userid = session['LOGON.USERID'];

projUrl='herp.acct.acctvouchexe.csp';
/////////////凭证类型
		var VouchTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid','name'])
		});

		VouchTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({

					url : projUrl+'?action=GetVouchType&str='+encodeURIComponent(Ext.getCmp('VouchTypeCombo').getRawValue()),method:'POST'
			});
		});
		var VouchTypeCombo = new Ext.form.ComboBox({
	        id:'VouchTypeCombo',
			fieldLabel : '凭证类型',
			store : VouchTypeDs,
			valueField : 'rowid',
			displayField : 'name',
			typeAhead : true,
			triggerAction : 'all',
			emptyText : '请选择类型',
			width : 100,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus:true,
			forceSelection:'true'
		});


		
		//////凭证日期时间范围
		var VouchDateStartField = new Ext.form.DateField({
			fieldLabel: '凭证日期开始时间',
			width:100,
			allowBlank:false,
			format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
		
		
		var VouchDateEndField = new Ext.form.DateField({
			fieldLabel: '凭证日期结束时间',
			width:100,
			allowBlank:false,
			format:'Y-m-d',
			columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
		
		
		
		/////////////////////凭证号范围/////////////////////////
		VouchNoMax= new Ext.form.TextField({
 			fieldLabel : '凭证编号',
			width : 100,
			columnWidth : .142,
			selectOnFocus : true
		});	
		VouchNoMin= new Ext.form.TextField({
 			fieldLabel : '凭证编号',
			width : 100,
			columnWidth : .142,
			selectOnFocus : true
		});	


		var StateStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '新增'], ['05', '审核不通过'],  ['11', '提交'], 
			        ['21', '审核通过'],['31', '记账'], ['41', '结账']]
		});
		var StateField = new Ext.form.ComboBox({
			id : 'State',
			fieldLabel : '凭证状态',
			width : 100,
			columnWidth : .15,
			listWidth :100,
			selectOnFocus : true,
			allowBlank : false,
			store : StateStore,
			anchor : '90%',
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', 
			editable : false,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});
				
//////查询按钮
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls:'find',
	handler: function(){
	//Summaryfield MakeDateField MakeDate2Field Makerfield Checkerfield StateField
	    var vouchtype = VouchTypeCombo.getValue();
	    var vouchdatestart = VouchDateStartField.getValue();
	    var vouchdateend = VouchDateEndField.getValue();
	    var vouchnomax = VouchNoMax.getValue();
	    var vouchnomin = VouchNoMin.getValue();
	    var state = StateField.getValue();
	    var data=vouchtype+"^"+vouchdatestart+"^"+vouchdateend+"^"+vouchnomax+"^"+vouchnomin+"^"+state;
		//alert(data);
		itemGrid.load({params:{start:0,limit:25,data:data,userid:userid}});
	}
});

//////添加按钮
var addButton = new Ext.Toolbar.Button({
	text: '添加凭证',
    tooltip:'添加',        
    iconCls:'add',
	handler:function(){
        var myPanel = new Ext.Panel({
        layout : 'fit',
		//scrolling="auto"
        html : '<iframe src="acct.html"  width="100%"  height="100%" ></iframe>',
        frame : true
		});
		
        var win = new Ext.Window({
                    title : '凭证录入',
                    width :1020,
                    height :500,
                    resizable : false,
                    closable : true,
                    draggable : true,
                    resizable : false,
                    layout : 'fit',
                    modal : false,
                    plain : true, // 表示为渲染window body的背景为透明的背景
                    //bodyStyle : 'padding:5px;',
                    items : [myPanel ],
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

});


//////提交
var submitButton = new Ext.Toolbar.Button({
	text: '提交凭证',
    tooltip:'提交',        
    iconCls:'add',
	handler:function(){
		
			submitFun();
			
	}
	
});

//////复制
var copyButton = new Ext.Toolbar.Button({
	text: '复制凭证',
    tooltip:'复制',        
    iconCls:'add',
	handler:function(){
		copyFun();
	}
	
});

//////冲销1
var destroyButton = new Ext.Toolbar.Button({
	text: '冲销凭证',
    tooltip:'冲销',        
    iconCls:'reset',
	handler:function(){
		destroyFun();
	}
	
});

//////作废
var cacelButton = new Ext.Toolbar.Button({
	text: '作废凭证',
    tooltip:'作废',        
    iconCls:'remove',
	handler:function(){
		cacelFun();
	}
	
});

//////打印
var printButton = new Ext.Toolbar.Button({
	text: '打印凭证',
    tooltip:'打印',        
    iconCls:'add',
	handler:function(){
            var records = itemGrid.getSelectionModel().getSelections();   
			var VouchNo = records[0].get("VouchNo");
            var objPrint = new ActiveXObject("PrintBar.prnbar");
           /*  objPrint.CARDLEFT = 2;
			 alert("3");
            objPrint.CARDTOP = 2;
            objPrint.LABHEIGHT = 10;
            objPrint.LABWIDTH = 30;  */
                //标签,审核人,包名,日期,效期 ,时间,接收科室名称,配包人
            objPrint.PrintLabelVouch(VouchNo);

	}
	
});


       
	var button1= new Ext.Toolbar([addButton,'-',submitButton,'-',copyButton,'-',destroyButton,'-',cacelButton,'-',printButton]);
    var itemGrid = new dhc.herp.Grid({
			//title:'凭证录入',
		    region : 'center',
		    url: 'herp.acct.acctvouchexe.csp',
		    //atLoad : true, // 是否自动刷新
			tbar:['凭证类型:',VouchTypeCombo,'-','凭证日期:',VouchDateStartField,'至',VouchDateEndField,'-','凭证号:',VouchNoMax,'至',VouchNoMin,'-','凭证处理状态:',StateField,'-',findButton],                                                    
		    listeners :{
				 'render': function(){button1.render(itemGrid.tbar);},	
			}, 
			items:[ {xtype : 'panel',
                   width : 1120,
						height : 580,
						title : 'ddd'
       
		}],
			
			viewConfig : {forceFit : true},
			fields : [{
						id : 'VouchID',
						header : '凭证表ID',
						editable:false,
						width : 130,
						dataIndex : 'VouchID',
                        hidden : true
	                 },{
						id : 'AcctYear',
						header : '年',
						width : 50,
						editable:false,
						dataIndex : 'AcctYear'

					},{
						id : 'AcctMonth',
						header : '月',
						width : 50,
						editable:false,
						dataIndex : 'AcctMonth'

					},{
						id : 'VouchDate',
						header : '凭证日期',
						width : 90,
						editable:false,
						dataIndex : 'VouchDate'

					},{
						id : 'VouchNo',
						header : '凭证号',
						editable:false,
						width : 100,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
						var sf = record.data['IsDestroy']
						if (sf == "是") {
							return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>'+'<b> </b>'
							+'<span style="color:red;cursor:hand;backgroundColor:white">冲</span>';
						}else{
							return '<span style="color:blue;cursor:hand;backgroundColor:red;src="../scripts/herp/acct/acct.html""><u>'+value+'</u></span>';
						}},
						dataIndex : 'VouchNo'

					},{
                        id : 'typename',
						header : '凭证类型',
						width : 80,
						editable:false,
						dataIndex : 'typename'
					},{
						id : 'Operator',
						header : '制单人',
						width : 100,
						editable:false,
						dataIndex : 'Operator'

					},{
						id : 'MakeBillDate',
						header : '制单日期',
						width : 90,
						editable:false,
						dataIndex : 'MakeBillDate'

					},{
						id : 'Auditor',
						header : '审核人',
						width : 100,
						editable:false,
						dataIndex : 'Auditor'

					},{
                        id : 'Poster',
						header : '记账人',
						width : 100,
						editable:false,
						dataIndex : 'Poster'
					},{
                        id : 'VouchState',
						header : '凭证状态',
						width : 90,
						editable:false,
						dataIndex : 'VouchState'
					},
					{
                        id : 'VouchProgress',
						header : '凭证处理过程',
						width : 100,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
							return '<span style="color:blue;cursor:hand;TEXT-DECORATION:underline">'+value+'</span>';
						},
						dataIndex : 'VouchProgress'
					},{
                        id : 'IsDestroy',
						header : '冲销',
						width : 40,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['IsDestroy']
						if (sf == "是") {
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:red;cursor:hand;backgroundColor:white">'+value+'</span>';
						}},
						dataIndex : 'IsDestroy'
					},{
                        id : 'IsCancel',
						header : '作废',
						width : 40,
						editable:false,
						//hidden: true,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['IsCancel']
						if (sf == "是") {
							//cellmeta.css="cellColor3";// 设置可编辑的单元格背景色
							return '<span style="color:red;cursor:hand;backgroundColor:white">'+value+'</span>';
						}},
						dataIndex : 'IsCancel'
					},{
                        id : 'VouchState1',
						header : '凭证状态',
						width : 100,
						editable:false,
						hidden:true,
						dataIndex : 'VouchState1'
					},{
							id:'upload',
							header: '附件',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){		
							return '<span style="color:blue"><u>上传</u></span>';			
							}	
					},{
							id:'download',
							header: '下载',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
					}} ]
		});
		

	
	itemGrid.load({params:{start:0,limit:25,userid:userid}});

	uploadMainFun(itemGrid,'VouchID','P007',16);
    downloadMainFun(itemGrid,'VouchID','P007',17);	
		
    itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

	    if(columnIndex=='5'){
			//p_URL = 'acct.html?acctno=2';
		    //document.getElementById("frameReport").src='acct.html';
			var records = itemGrid.getSelectionModel().getSelections();   
			var VouchNo = records[0].get("VouchNo");
			var VouchState = records[0].get("VouchState1");
			var myPanel = new Ext.Panel({
			layout : 'fit',
			//scrolling="auto"
			html : '<iframe id="frameReport" width="100%"  height="100%" src="../csp/acct.html?acctno='+VouchNo+'&user='+userid+'&acctstate='+VouchState+'" /></iframe>',
			frame : true
			});

			var win = new Ext.Window({
						title : '凭证录入',
						width :1020,
						height :600,
						resizable : false,
						closable : true,
						draggable : true,
						resizable : false,
						layout : 'fit',
						modal : false,
						plain : true, // 表示为渲染window body的背景为透明的背景
						//bodyStyle : 'padding:5px;',
						items : [myPanel ],
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
		if(columnIndex=='12'){
			var records = itemGrid.getSelectionModel().getSelections();   
			var VouchID = records[0].get("VouchID");
			VouchProgressFun(VouchID);
		}
    });

    itemGrid.btnAddHide();  //隐藏增加按钮
   	itemGrid.btnSaveHide();  //隐藏保存按钮
    itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    itemGrid.btnPrintHide();  //隐藏打印按钮


