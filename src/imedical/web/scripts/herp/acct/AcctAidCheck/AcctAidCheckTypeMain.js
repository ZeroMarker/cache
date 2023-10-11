var acctbookid =IsExistAcctBook();

var CheckTypeUrl='../csp/herp.acct.acctaidcheckexe.csp';

//增加按钮
var addButton = new Ext.Toolbar.Button({
		text: '增加',
		tooltip:'增加',        //悬停提示
		iconCls: 'add',
		handler:function(){
				addtypefun();
	}
});


//修改按钮
var editButton = new Ext.Toolbar.Button({
		text:'修改',
		tooltip:'修改',
		iconCls: 'edit',
		handler:function(){
				edittypefun();
		}
	});
//删除按钮
var delButton = new Ext.Toolbar.Button({
		text : '删除',
		tooltip : '删除',
		iconCls : 'remove',
		handler :function() {
			
			var records = AcctCheckTypeBookGrid.getSelectionModel().getSelections();
			if(records.length<1){
				Ext.Msg.show({
					title:'注意',
					msg:'请选择需要删除的数据!',
					buttons: Ext.Msg.OK,
					icon:Ext.MessageBox.WARNING
				});
				return;
			}
			Ext.MessageBox.confirm('提示', '确定要删除此核算类别吗?', function(btn) {
				if (btn == 'yes') {
				
					/* Ext.each(records, function(record) {
						if (Ext.isEmpty(record.get("rowid"))) {
							Ext.Msg.show({
								title:'注意',
								msg:'请选择需要删除的数据!',
								buttons: Ext.Msg.OK,
								icon:Ext.MessageBox.WARNING
							});
							CheckTypeBookDs.getStore().remove(record);
							return;
						}
 */
						Ext.Ajax.request({
							url : CheckTypeUrl + '?action=TypeBookdel&rowid='+records[0].get("rowid")+'&AcctBookID='+acctbookid,
							waitMsg : '删除中...',
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
									Ext.Msg.show({
										title:'注意',
										msg:'删除成功!',
										buttons: Ext.Msg.OK,
										icon:Ext.MessageBox.INFO
									});
									CheckTypeBookDs.load({
										params : {
											start : 0,
											limit : 25
										}
									});
									/* CheckItemDs.load({
										params:{
											start : 0,
											limit : 25
										}
									}); */		
								} else {
									var message = jsonData.info;
									Ext.Msg.show({
												title : '错误',
												msg : message,
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
										}
							}
							
						});
						
				// });
			}
		});
		
	}
});

//主数据源
var CheckTypeBookProxy = new Ext.data.HttpProxy({
		url:CheckTypeUrl+'?action=TypeBookList'+'&AcctBookID='+acctbookid
});
var CheckTypeBookDs = new Ext.data.Store({
		proxy:CheckTypeBookProxy,
		reader:new Ext.data.JsonReader({
					root:'rows',
					totalProperty:'results'
		},['rowid','AcctBookID','BookName','AcctCheckTypeID','CheckTypeName','isValid','IsFinishInit',
		'StartYear','StartMonth','EndYear','EndMonth']),
		remoteSort:true
});
	CheckTypeBookDs.load({
		params:{
			start:0,
			limit:25
		}
	});

var AcctCheckTypeBookGrid = new Ext.grid.GridPanel({
		title: '所属核算类型',
		iconCls:'find',
		region: 'west',
		width: 540,
		height: 600,	//Ext.getBody().getHeight()
		atLoad:true,
		collapsible : true,	//向左收起
		autoScoll:true, //滚动条
		store:CheckTypeBookDs,
		trackMouseOver:true,
		stripeRows:true,
		viewConfig:{
			//forceFit:true,
			scrollOffset:0
		},
		sm:new Ext.grid.RowSelectionModel({
			singleSelect:true
		}),
		loadMask:true,
		columns:[
			new Ext.grid.RowNumberer(),
			{
				header:'<div style="text-align:center">ID</div>',
				dataIndex:'rowid',
				width:40,
				align:'center',
				hidden:true
			},{
				header:'<div style="text-align:center">单位账套代码</div>',
				dataIndex:'AcctBookID',
				width:40,
				align:'center',
				hidden:true
			},{
				id:'AcctBookName',
				header:'<div style="text-align:center">单位账套名称</div>',
				//type:AcctBookNameField,
				dataIndex:'BookName',
				width:120,
				//align:'center',
				editable:true
			},{
				header:'<div style="text-align:center">会计核算类别代码</div>',
				dataIndex:'AcctCheckTypeID',
				width:40,
				align:'center',
				hidden:true
			},{
				id:'CheckTypeName',
				header:'<div style="text-align:center">会计核算类别</div>',
				//type:CheckTypeField,
				dataIndex:'CheckTypeName',
				width:120,
				align:'center'
			},{
				id:'isValid',
				header:'<div style="text-align:center">是否有效</div>',
				dataIndex:'isValid',
				width:65,
				align:'center'
			},{
				id:'IsFinishInit',
				header:'<div style="text-align:center">是否完成初始化</div>',
				dataIndex:'IsFinishInit',
				width:110,
				align:'center',
				editable:false
			},{
				id:'StartYear',
				header:'<div style="text-align:center">启用年</div>',
				dataIndex:'StartYear',
				width:50,
				align:'center'
			},{
				id:'StartMonth',
				header:'<div style="text-align:center">启用月</div>',
				dataIndex:'StartMonth',
				width:50,
				align:'center'
			},{
				id:'EndYear',
				header:'<div style="text-align:center">停用年</div>',
				dataIndex:'EndYear',
				width:50,
				align:'center'
			},{
				id:'EndMonth',
				header:'<div style="text-align:center">停用月</div>',
				dataIndex:'EndMonth',
				width:50,
				align:'center'
			}
		],
		tbar:['-',addButton,'-',editButton,'-',delButton],
		bbar : new Ext.PagingToolbar({
			store : CheckTypeBookDs,
			pageSize : 25,
			displayInfo : true,
			displayMsg : '第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg : "没有记录"
		})	
	
});
/* 
//重写工具栏刷新按钮的方法
	AcctCheckTypeBookGrid.bbar.refresh.handler=function(){
		alert(12314);
		rowidArr=[];	//刷新前清空复选框选中的数据行
		this.doLoad(this.cursor);
		
	};
 */
AcctCheckTypeBookGrid.on('rowclick', function (grid, rowIndex, e) {
	var selectedRow = CheckTypeBookDs.data.items[rowIndex];
	// var rowidArr=[];
	var AcctCheckTypeID = selectedRow.data['AcctCheckTypeID'];
	CheckItemDs.proxy = new Ext.data.HttpProxy({
			url: CheckTypeUrl + '?action=CheckItemList' + '&AcctBookID=' + acctbookid + '&AcctCheckTypeID=' + AcctCheckTypeID
		});

	// 清除选择的数据行复选框
	rowidArr = [];
	
	CheckItemDs.load({
		params: {
			start: 0,
			limit: 25
		}
	});

});

