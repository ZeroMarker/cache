function InitHistoryWindow()
{
    var store = new Ext.data.JsonStore({
		url: '../EMRservice.Ajax.appointdeptmanager.cls?AppType=getHistory&EpisodeID=' + episodeID,
		root: 'Data',
		totalProperty: 'TotalCount',
		fields: 	
		[{
			name: 'EpisodeID'
		}, {
			name: 'Action'
		}, {
			name: 'OperationDateTime'
		}, {
			name: 'OperationUserName'
		}, {
			name: 'TransInDeptDesc'
		}, {
			name: 'TransOutStartDateTime'
		}, {
			name: 'TransOutEndDateTime'
		}]
	});

	//数据正常加载
	store.on('load', function(){
		if('IE11.0'==isIE()){
			Ext.getCmp('dgResultGrid').addClass('ext-ie');
		}
		//changeRowBackgroundColor(Ext.getCmp('dgResultGrid'));
	});

	//数据加载异常
	store.on('loadexception', function(proxy, options, response, e){
		//debugger;
		alert("数据加载异常11" + response.responseText);
	});
    
    var cm = new Ext.grid.ColumnModel([
		{
			header: '就诊ID',
			dataIndex: 'EpisodeID',
			width: 70,
			hidden: true
		}, {
			header: '操作名称',
			dataIndex: 'Action',
			width: 70,
			sortable: true
		}, {
			header: '操作日期',
			dataIndex: 'OperationDateTime',
			width: 120,
			sortable: true
		}, {
			header: '操作医生',
			dataIndex: 'OperationUserName',
			width: 70,
			sortable: true
		}, {
			header: '转至科室',
			dataIndex: 'TransInDeptDesc',
			width: 120,
			sortable: true
		}, {
			header: '约定转移开始时间',
			dataIndex: 'TransOutStartDateTime',
			width: 120,
			sortable: true
		}, {
			header: '约定转移结束时间',
			dataIndex: 'TransOutEndDateTime',
			width: 120,
			sortable: true
		}
	]);
	
	var pageSize = 20;
	var dgResultGrid = new Ext.grid.EditorGridPanel({
		id: 'dgResultGrid',
		layout: 'fit',
		region: 'center',
		store: store,
		cm: cm,
		name: '病历转移历史记录', // add by niucaicai 导出结果时作为sheet名字
		stopPropagation:true,
		forceFit: true,
		autoScroll: true,
		frame: false,
		editable: true,
		enableColumnMove: true,
		enableColumnResize: true,
		loadMask: {
			msg: '数据正在加载中……'
		},
		clickToEdit: 1,
		viewConfig: {
			columnsText: '显示的列',
			sortAscText: '升序',
			sortDescText: '降序'
		},
		bbar: new Ext.PagingToolbar({
			id: "eprPagingToolbar",
			store: store,
			pageSize: pageSize,
			displayInfo: true,
			displayMsg: '第 {0} 条到  {1} 条, 一共 {2} 条',
			beforePageText: '当前页',
			afterPageText: '总页数{0}',
			firstText: '首页',
			prevText: '上一页',
			nextText: '下一页',
			lastText: '末页',
			refreshText: '刷新',
			emptyMsg: "没有记录",
			items: ['-', {
				xtype: 'label',
				text: '每页显示'
			}, {
				id: 'cbxPageSize',
				name: 'cbxPageSize',
				xtype: 'combo',
				width: 50,
				readOnly: true,
				editable: false,
				store: new Ext.data.SimpleStore({
					fields: ['id', 'name'],
					data: [['5', '5'], ['10', '10'], ['20', '20'], ['50', '50']]
				}),
				mode: 'local',
				displayField: 'name',
				valueField: 'id',
				triggerAction: 'all',
				selectOnFocus: true,
				emptyText: '请选择每页条目数',
				value: pageSize,
				listeners: {
					'select': function(){
						pageSize = Ext.getCmp('cbxPageSize').getValue();
						var grid = Ext.getCmp('dgResultGrid');
						Ext.getCmp('eprPagingToolbar').pageSize = pageSize;
						var s = grid.getStore();
						var link = getUrl();
						s.proxy.conn.url = link;
						s.load({
							params: {
								start: 0,
								limit: pageSize
							}
						});
					}
				}
			}, {
				xtype: 'label',
				text: '条记录'
			}]
		})
	});
	
	var link = getUrl();
	store.proxy.conn.url = link;
    
	store.load({
		params: {
			start: 0,
			limit: pageSize
		}
	});
    
	var HistoryWin = new Ext.Window({
		id : 'HistoryWin'
		,title: '病历转移历史记录'
		,height : 400
		,width : 638
		,layout : 'border'
		,modal: true
		,maximizable: false
		,items:[
			dgResultGrid
		]
	});

	HistoryWin.show();
	
	function getUrl()
	{
		var link = '../EMRservice.Ajax.appointdeptmanager.cls?AppType=getHistory&EpisodeID=' + episodeID;
		return link;
	}
}

function isIE(){
	var userAgent = navigator.userAgent, 
	rMsie = /(msie\s|trident.*rv:)([\w.]+)/; 
	var browser; 
	var version; 
	var ua = userAgent.toLowerCase(); 
	function uaMatch(ua){ 
 		var match = rMsie.exec(ua); 
 		if(match != null){ 
 			return { browser : "IE", version : match[2] || "0" }; 
 		}
	} 
	var browserMatch = uaMatch(userAgent.toLowerCase()); 
	if (browserMatch.browser){ 
 		browser = browserMatch.browser; 
 		version = browserMatch.version; 
	} 
	return(browser+version);
}