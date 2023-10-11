
var userid = session['LOGON.USERID'];
var acctbookid = IsExistAcctBook();
var projUrl='herp.acct.acctcashjournalvouchexe.csp';

var sDateField = new Ext.form.DateField({
		fieldLabel : '日期范围',
		width:120,
		//format : 'Y-m-d',
		emptyText : '开始时间...',
		renderer : function (v, p, r, i) {
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {
				return v;
			}
		}
	});
var eDateField = new Ext.form.DateField({
		fieldLabel : '-',
		width:120,
		//format : 'Y-m-d',
		emptyText : '结束时间...',
		renderer : function (v, p, r, i) {
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {
				return v;
			}
		}
	});

var summaryFeild = new Ext.form.TextField({
		fieldLabel : '摘  要',
		id : 'summaryFeild',
		name : 'summaryFeild',
		width : 120,
		emptyText : '摘要...'
	});

	
var vouchStateComb = new Ext.form.ComboBox({
		fieldLabel : '凭证状态',
		width : 100,
		listWidth : 100,
		store : new Ext.data.ArrayStore({
			fields : ['code', 'name'],
			data : [['11', '提交'], ['21', '审核通过'], ['31', '记账'], ['41', '结账']]
		}),
		displayField : 'name',
		valueField : 'code',
		typeAhead : true,
		mode : 'local',
		forceSelection : true,
		triggerAction : 'all',
		selectOnFocus : true
	});
	
	
var cVouchDateField = new Ext.form.DateField({
		fieldLabel : '凭证日期',
		width:120,
		//format : 'Y-m-d',
		value : new Date(),
		renderer : function (v, p, r, i) {
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {
				return v;
			}
		}
	});	
	
//////查询按钮
var findButton = new Ext.Toolbar.Button({
		text : '查询',
		tooltip : '查询',
		width:55,
		iconCls : 'find',
		handler : function () {
			var startDate=sDateField.getValue();
			if (startDate != "") {
                            var startDate = startDate.format('Y-m-d');
                        } 
			var endDate=eDateField.getValue();	
			if (endDate != "") {
                            var endDate = endDate.format('Y-m-d');
                        } 
			var summary=summaryFeild.getValue();
			var vouchstate=vouchStateComb.getValue();
			// alert(startDate+"^"+endDate+"^"+summary+"^"+vouchstate)
			itemGrid.store.load({
				params:{
					start:0,
					limit:25,
					AcctBookID:acctbookid,
					startDate:startDate,
					endDate:endDate,
					summary:summary,
					vouchstate:vouchstate
				}
			});
		}
	});	
/*******************凭证生成按钮*******************/
var VouchButton = new Ext.Toolbar.Button({
		id : 'VouchButton',
		text : '生成凭证',
		width:80,
		tooltip : '生成凭证',
		iconCls : 'createvouch',
		handler : function () {
			var selRows=itemGrid.getSelectionModel().getSelections();
			var len=selRows.length;
			if(len<1){
				Ext.Msg.show({
					title:'提示',
					msg:'请选择要生成凭证的日记账数据！ ',
					icon:Ext.Msg.INFO,
					buttons:Ext.Msg.OK
				});
				return;
			}else{
				var vouchdate=cVouchDateField.getValue();
				if (vouchdate != "") {
                            var vouchdate = vouchdate.format('Y-m-d');
                        } 
				Ext.Msg.confirm('提示','确实要将所选的日记账数据生成'+vouchdate+'的凭证吗？'+
					'<br>已经生成凭证的数据会自动过滤。',rollback);
				function rollback(id){
					if(id=='yes'){
						var rowids="";
						Ext.each(selRows,function(recode){
							var currowid=recode.get("rowid");
							var vouchNo=recode.get("acctvouchno");
							if(!vouchNo){
								rowids=rowids==""?currowid:rowids+','+currowid;
							}
						})
						// alert(rowids)

						Ext.Ajax.request({
							url:projUrl+'?action=generateVouch&AcctBookID='+acctbookid+
							'&selRows='+rowids+'&VouchDate='+vouchdate,
							success:function(result,requset){
								var jsonDate=Ext.util.JSON.decode(result.responseText);
								if(jsonDate.success=='true'){
									Ext.Msg.show({
										title:'注意',
										msg:'凭证生成成功! ',
										buttons: Ext.Msg.OK,
										icon:Ext.MessageBox.INFO
									});
									// 刷新后停留在当前页
									var curpage=itemGrid.getBottomToolbar();
									curpage.doLoad(curpage.cursor);
									return;
								}else{
									alert(jsonDate.info);
									Ext.Msg.show({
										title : '错误',
										msg : '凭证生成失败！ ',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
								}
							}

						});
					}
				}
				
			}
		}
});

var queryPanel=new Ext.FormPanel({
	title:"现金日记账生成凭证",
	iconCls : 'createvouch',
	height : 115,
    region : 'north',
    frame : true,
	defaults: {
		width:1200,
		bodyStyle:'padding:5px;text-align:right;'
	},
	items:[{	
		xtype: 'panel',
		layout:'column',
		items:[
		{
			xtype: 'displayfield',
			style:'padding:0 5px;',
			value:'日期范围'
			//width:70
		},sDateField,{
			xtype: 'displayfield',
			style:'margin-left:0px;text-align:center;',
			value:'--',
			width:14
		},eDateField,{
			xtype: 'displayfield',
			width:40
		},{
			xtype: 'displayfield',
			style:'padding:0 5px;',
			value:'摘  要'
			//width:60
		},summaryFeild,{
			xtype: 'displayfield',
			width:40
		},{
			xtype: 'displayfield',
			style:'padding:0 5px;',
			value:'凭证状态'
			//width:70
		},vouchStateComb,{
			xtype: 'displayfield',
			width:40
		},findButton
		]},{
		xtype: 'panel',
		layout:'column',
		items:[{
			xtype: 'displayfield',
			style:'padding:0 5px;',
			value:'凭证日期'
			//width:70
		},cVouchDateField,{
			xtype: 'displayfield',
			width:55
		},VouchButton
		]}
	]
});


var itemGrid= new dhc.herp.Grid({
		region : 'center',
		url : projUrl,
		fields : [
			new Ext.grid.CheckboxSelectionModel({
				editable : false
			}), {
				header : 'ID',
				dataIndex : 'rowid',
				hidden : true
			}, {
				id : 'billdate',
				header : '日期',
				editable : false,
				width : 90,
				align : 'center',
				dataIndex : 'billdate'
			}, {
				id : 'summary',
				header : '摘要',
				editable : false,
				// align : 'center',
				width : 150,
				dataIndex : 'summary'
			}, {
				id : 'acctsubjcode',
				header : '对方科目',
				editable : false,
				width : 110,
				dataIndex : 'acctsubjcode'
			}, {
				id : 'amtdebit',
				header : '借方金额',
				editable : false,
				align : 'center',
				width : 120,
				dataIndex : 'amtdebit', 
				renderer:function(v){
					if(v!=""){
						return Ext.util.Format.number(v,"0,000.00");
					}else{
						return v;
					}
				}
			}, {
				id : 'amtcredit',
				header : '贷方金额',
				editable : false,
				align : 'center',
				width : 120,
				dataIndex : 'amtcredit',
				renderer:function(v){
					if(v!=""){
						return Ext.util.Format.number(v,"0,000.00");
					}else{
						return v;
					}
				}
			}, {
				id : 'recorddr',
				header : '登记人',
				editable : false,
				align : 'center',
				width : 100,
				dataIndex : 'recorddr'
			}, {
				id : 'journalstate',
				header : '数据状态',
				editable : false,
				align : 'center',
				width : 80,
				dataIndex : 'journalstate'
			}, {
				id : 'acctvouchno',
				header : '凭证号',
				editable : false,
				width : 110,
				align:'center',
				dataIndex : 'acctvouchno',
				renderer:function(value,cellmeta,record,rowIndex,columnIndex,store){
					return '<span style="color:blue;cursor:hand;Text-Decoration:underline">'+value+'</span>';
				}
			}, {
				id : 'vouchdate',
				header : '凭证日期',
				editable : false,
				align : 'center',
				width : 90,
				dataIndex : 'vouchdate'
			}, {
				id : 'vouchstate',
				header : '凭证状态',
				editable : false,
				align : 'center',
				width : 80,
				dataIndex : 'vouchstate'
			}, {
				id : 'vouchstatenum',
				header : '凭证状态num',
				editable : false,
				align : 'center',
				width : 80,
				dataIndex : 'vouchstatenum',
				hidden:true
			}, {
				id : 'operator',
				header : '制单人',
				editable : false,
				align : 'center',
				width : 100,
				dataIndex : 'operator'
			}]
});


//凭证链接
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

		if(columnIndex=='10'){
			var records = itemGrid.getSelectionModel().getSelections();   
			var VouchNo = records[0].get("acctvouchno");
			if(!VouchNo) return;
			var VouchState = records[0].get("vouchstatenum");
			var myPanel = new Ext.Panel({
				layout : 'fit',
				html : '<iframe id="frameReport" style="margin-top:-3px;" frameborder="0" width="100%"  height="100%" src="../csp/acct.html?acctno='+VouchNo+'&user='+userid+'&acctstate='+VouchState+'&bookID='+acctbookid+'&SearchFlag=1 "/></iframe>'
			});

			var win = new Ext.Window({
					title : '凭证查看',
					width :1093,
					height :620,
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