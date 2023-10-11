//取当前用户ID
var UserId = session['LOGON.USERID'];
var AcctBookID = IsExistAcctBook();
var AcctInitCompUrl = '../csp/herp.acct.acctinitcompcheckexe.csp';

// 配件数据源
var AcctTypeTabProxy = new Ext.data.HttpProxy({
		url: AcctInitCompUrl + '?action=listType' + '&AcctBookID=' + AcctBookID
	});

var AcctTypeTabDs = new Ext.data.Store({
		proxy: AcctTypeTabProxy,
		reader: new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: 'results'
		}, ['rowid', 'CheckTypeCode', 'CheckTypeName', 'IsFinishInit', 'isValid', 'StartYearMonth', 'StartYear']),
		remoteSort: true

	});
AcctTypeTabDs.load({
	params: {
		start: 0,
		limit: 25
	}
});

var AcctTypeTabCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
				header: 'AcctCheckTypeID',
				dataIndex: 'rowid',
				width: 40,
				hidden: true
			}, {
				header: '辅助帐启用年度',
				dataIndex: 'StartYear',
				width: 40,
				hidden: true
			}, {
				header: '<div style="text-align:center">编号</div>',
				dataIndex: 'CheckTypeCode',
				width: 90,
				sortable: true
			}, {
				header: '<div style="text-align:center">辅助核算类型</div>',
				dataIndex: 'CheckTypeName',
				width: 120
			}, {
				header: '<div style="text-align:center">初始化状态</div>',
				dataIndex: 'IsFinishInit',
				width: 90,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">是否有效</div>',
				dataIndex: 'isValid',
				width: 70,
				align: 'center',
				sortable: true
			}, {
				header: '<div style="text-align:center">辅助帐启用年月</div>',
				dataIndex: 'StartYearMonth',
				width: 120,
				align: 'center',
				sortable: true
			}

		]);

// 设置默认排序字段和排序方向
AcctTypeTabDs.setDefaultSort('rowid', 'CheckTypeCode');

// 初始化默认排序功能
AcctTypeTabCm.defaultSortable = true;

var AcctTypeTabGrid = new Ext.grid.GridPanel({
		title: '会计辅助帐初始化校验',
		iconCls:'maintain',
		region: 'west',
		width: 520,
		height: 750,
		atload: true,
		collapsible: true,
		store: AcctTypeTabDs,
		cm: AcctTypeTabCm,
		trackMouseOver: true,
		stripeRows: true,
		/*viewConfig : {
		forceFit : true
		},*/
		sm: new Ext.grid.RowSelectionModel({
			singleSelect: true
		}),
		loadMask: true,
		bbar: new Ext.PagingToolbar({
			store: AcctTypeTabDs,
			pageSize: 25,
			displayInfo: true,
			displayMsg: '第 {0} 条到 {1}条 ，一共 {2} 条',
			emptyMsg: "没有记录"

		})

	});


// 点击后刷新右侧数据
AcctTypeTabGrid.on('rowclick', function(grid, rowIndex, e) {
	showCheckList(grid, rowIndex, e)
});

// 显示科室辅助账初始化校验
function showCheckList(grid, rowIndex, e){
	var selectedRow = AcctTypeTabDs.data.items[rowIndex];
	AcctCheckTypeID = selectedRow.data['rowid'];
	AcctCheckGrid.setTitle("科室辅助账初始化校验");
	initflag = selectedRow.data['IsFinishInit'];
	isValid = selectedRow.data['isValid'];
	if (initflag == "完成") {
		CompInitButton.disable();
	} else {
		if (isValid == "否") {
			CompInitButton.disable();
		} else {
			CompInitButton.enable();
		}
	}
	
	Ext.Ajax.request({
		url : AcctInitCompUrl+'?action=GetGridTitle&AcctCheckTypeID='+AcctCheckTypeID+ '&AcctBookID=' + AcctBookID,
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
			var jsonHeadNum = jsonData.results;		
			var jsonHeadList = jsonData.rows;
			//alert(jsonHeadList.length);
			var tmpDataMapping = [];				
			for (var i = 0; i < jsonHeadList.length; i++) {
				if (i<4) { 
                   if(i==3||i==2){
					   cmConfig = {
						header :jsonHeadList[i].title,
						dataIndex : jsonHeadList[i].IndexName,
						width : 80,
						sortable : true,
						align : 'center',
						editor : new Ext.form.TextField({
							allowBlank : true
						})
					}
					   
				   }else{		
					cmConfig = {
						header :jsonHeadList[i].title,
						dataIndex : jsonHeadList[i].IndexName,
						width : 130,
						sortable : true,
						align : 'center',
						editor : new Ext.form.TextField({
							allowBlank : true
						})
					}	
}						
				}else if(i<=jsonHeadList.length){
					cmConfig = {
						header : jsonHeadList[i].title,
						//type:'numberField',
						dataIndex : jsonHeadList[i].IndexName,
						width : 150,
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
						align : 'center',
						editor : new Ext.form.TextField({
									allowBlank : true	
								})
					}
				}
				cmItems.push(cmConfig);
				tmpDataMapping.push(jsonHeadList[i].IndexName);
			}

			// 金额数据
			var tmpColumnModel = new Ext.grid.ColumnModel(cmItems);
			// return false tmpDataMapping
			tmpStore.proxy = new Ext.data.HttpProxy({
				url : AcctInitCompUrl+'?action=listCheck&AcctCheckTypeID='+AcctCheckTypeID+ '&AcctBookID=' + AcctBookID,
				method : 'POST'
			})
			tmpStore.reader = new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, tmpDataMapping);
			AcctCheckGrid.reconfigure(tmpStore, tmpColumnModel);
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
