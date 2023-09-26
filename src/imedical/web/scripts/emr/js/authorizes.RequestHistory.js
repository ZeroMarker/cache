function InitHistoryWindow()
{
	var store = new Ext.data.JsonStore({
		url: '../EMRservice.Ajax.Appoint.cls?Action=getHistory&EpisodeID=' + episodeID + '&RequestUserID=' + userID,
		/// http://10.10.13.194/dthealth/web/EMRservice.Ajax.AuthAppoint.cls?Action=getHistory&EpisodeID=4125408&RequestUserID=5671
		//url: '../EMRservice.Ajax.Appoint.cls?Action=getHistory&RequestUserID=' + userID,
		root: 'Data',
		totalProperty: 'TotalCount',
		fields: 	
		[{
			name: 'EpisodeID'
		}, {
			name: 'PaadmNO'
		}, {
			name: 'PapmiNo'
		}, {
			name: 'Name'
		}, {
			name: 'MedicareNo'
		}, {
			name: 'AdmDate'
		}, {
			name: 'AdmTime'
		}, {
			name: 'MainDoc'
		}, {
			name: 'CurDept'
		}, {
			name: 'PAAdmType'
		}, {
			name: 'PAStatus'
		}, {
			name: 'PADischgeDateTime'
		}, {
			name: 'AppointID'
		}, {
			name: 'RequestUser'
		}, {
			name: 'RequestDept'
		}, {
			name: 'RequestDate'
		}, {
			name: 'RequestTime'
		}, {
			name: 'RequestDateTime'
		}, {
			name: 'AppointDate'
		}, {
			name: 'AppointTime'
		}, {
			name: 'AppointDateTime'
		}, {
			name: 'AppointUser'
		}, {
			name: 'AppointType'
		}, {
			name: 'IsActive'
		}, {
			name: 'AppointSpan'
		}, {
			name: 'AppointEndDateTime'
		}, {
			name: 'IsAppointed'
		}, {
			name: 'CanAppoint'
		}, {
			name: 'AuthLevel'
		}, {
			name: 'AuthLevelDesc'
		}, {
			name: 'RefuseReason'
		}, {
			name: 'RequestReason'
		}, {
			name: 'BeforeRequestContent'
		}, {
			name: 'AfterRequestContent'
		}, {
			name: 'AppointDetailData'
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
		alert("数据加载异常" + response.responseText);
	});

	var expander = new Ext.grid.RowExpander({
		 tpl : new Ext.XTemplate(
		 '<div class="detailData" id="expanderdiv"></div>'
		 )
	 });

	expander.on("expand",function(expander,r,body,rowIndex){
		
		var dgResultGrid = Ext.getCmp('dgResultGrid');
		/*
		Ext.util.Observable.capture(dgResultGrid,function(){
			if(arguments[0] == 'rowclick'){
				if(DisableParent == 1){
					DisableParent = 0;
				}
				else{
					return true;
				}
			} 
			return false;
		});
		*/
		var expanderdivID = "expanderdiv" + rowIndex;
		body.innerHTML = '<div class="detailData" id="' + expanderdivID + '" data-options="fit:true,border:false" sysle="width:400px;overflow-x:auto;"></div>'
		
		var expanderdata = r.data['AppointDetailData'];
		var expanderstore=new Ext.data.JsonStore({
			fields:  
			[
				{
					name: 'CateCharpter'
				}, {
					name: 'CCDesc'
				}, {
					name: 'CCDateTime'
				}, {
					name: 'CCCreator'
				}, {
					name: 'IsAppointed'
				}, {
					name: 'CanAppoint'
				}, {
					name: 'DAction'
				}, {
					name: 'AppiontAction'
				}
			]
			,data:expanderdata
		});

		var expandercm = new Ext.grid.ColumnModel([
			{
				header: '实例(模板)ID',
				dataIndex: 'CateCharpter',
				width: 70,
				hidden: true
			},{
				header: '病历名称',
				dataIndex: 'CCDesc',
				width: 415
			},{
				header: '病历书写日期',
				dataIndex: 'CCDateTime',
				width: 160
			},{
				header: '病历创建者',
				dataIndex: 'CCCreator',
				width: 90
			},{
				header: '申请的操作',
				dataIndex: 'DAction',
				width: 170,
				renderer: rendererRequestAction
			},{
				header: '授权的操作',
				dataIndex: 'AppiontAction',
				width: 170,
				renderer: rendererAppointAction
			},{
				header: 'DetailStr',
				dataIndex: 'DetailStr',
				width: 70,
				hidden: true
			} 
			
		]);
		
		var expanderGridID = "expanderGrid" + rowIndex;
		var expanderGrid = new Ext.grid.GridPanel({
			id: expanderGridID,
			store:expanderstore,
			cm:expandercm,
			renderTo:expanderdivID,
			autoScroll: true,
			frame: true,
			//height: 280,
			//width: 600,
			autoHeight: true,
			autoWidth: true,
			viewConfig: {
				columnsText: '显示的列',
				sortAscText: '升序',
				sortDescText: '降序'
			}
		});
	});

	var cm = new Ext.grid.ColumnModel([
		expander,
		{
			header: '授权表ID',
			dataIndex: 'AppointID',
			width: 70,
			hidden: true
		}, {
			header: '授权级别',
			dataIndex: 'AuthLevelDesc',
			width: 70,
			sortable: true
		}, {
			header: '授权状态',
			dataIndex: 'IsAppointed',
			width: 70,
			sortable: true,
			renderer: rendererIsAppointed
		}, {
			header: '是否过期',
			dataIndex: 'IsActive',
			width: 70,
			sortable: true,
			renderer: rendererIsActive
		}, {
			header: '患者姓名',
			dataIndex: 'Name',
			width: 80,
			sortable: true
		}, {
			header: '登记号',
			dataIndex: 'PapmiNo',
			width: 100,
			sortable: true
		}, {
			header: '病案号',
			dataIndex: 'MedicareNo',
			width: 80,
			sortable: true
		}, {
			header: '就诊日期',
			dataIndex: 'AdmDate',
			width: 90,
			sortable: true
		}, {
			header: '就诊时间',
			dataIndex: 'AdmTime',
			width: 80,
			sortable: true
		}, {
			header: '就诊类型',
			dataIndex: 'PAAdmType',
			width: 70,
			sortable: true,
			renderer: rendererPAAdmType
		}, {
			header: '就诊号',
			dataIndex: 'PaadmNO',
			width: 110,
			sortable: true
		}, {
			header: '就诊科室',
			dataIndex: 'CurDept',
			width: 140,
			sortable: true
		}, {
			header: '主治医师',
			dataIndex: 'MainDoc',
			width: 70,
			sortable: true
		}, {
			header: '在院状态',
			dataIndex: 'PAStatus',
			width: 75,
			sortable: true,
			renderer: rendererPAStatus
		}, {
			header: '出院日期',
			dataIndex: 'PADischgeDateTime',
			width: 150,
			sortable: true,
			renderer: rendererDateTime
		}, {
			header: '申请医师',
			dataIndex: 'RequestUser',
			width: 70,
			sortable: true
		}, {
			header: '申请时间',
			dataIndex: 'RequestDateTime',
			width: 150,
			sortable: true
		}, {
			header: '申请原因',
			dataIndex: 'RequestReason',
			width: 180,
			renderer:function(data,metadata){
				var data = TrimEnterAndWrite(data);
				metadata.attr = 'ext:qtip=' + data;

				return data;
			}
		}, {
			header: '申请科室',
			dataIndex: 'RequestDept',
			width: 140,
			sortable: true
		}, {
			header: '授权医师',
			dataIndex: 'AppointUser',
			width: 70,
			sortable: true
		}
		, {
			header: '授权类型',
			dataIndex: 'AppointType',
			width: 80,
			sortable: true,
			renderer: getAppointType
		}, {
			header: '授权剩余时间（小时）',
			dataIndex: 'AppointSpan',
			width: 150,
			sortable: true,
			renderer: rendererAppointSpan
		}
		, {
			header: '授权/拒绝时间',
			dataIndex: 'AppointDateTime',
			width: 150,
			sortable: true
			,renderer: rendererDateTime
		}, {
			header: '授权结束时间',
			dataIndex: 'AppointEndDateTime',
			width: 150,
			sortable: true
			,renderer: rendererDateTime
		}, {
			header: '修改前内容',
			dataIndex: 'BeforeRequestContent',
			width: 180,
			sortable: true,
			//renderer: TrimEnterAndWrite
			renderer:function(data,metadata){
				var data = TrimEnterAndWrite(data);
				metadata.attr = 'ext:qtip=' + data;

				return data;
			}
		}, {
			header: '修改后内容',
			dataIndex: 'AfterRequestContent',
			width: 180,
			sortable: true,
			//renderer: TrimEnterAndWrite
			renderer:function(data,metadata){
				var data = TrimEnterAndWrite(data);
				metadata.attr = 'ext:qtip=' + data;

				return data;
			}
		}, {
			header: '拒绝原因',
			dataIndex: 'RefuseReason',
			width: 180,
			sortable: true,
			//renderer: TrimEnterAndWrite
			renderer:function(data,metadata){
				var data = TrimEnterAndWrite(data);
				metadata.attr = 'ext:qtip=' + data;

				return data;
			}
		}
	]);
	
	var pageSize = 20;
	var dgResultGrid = new Ext.grid.EditorGridPanel({
		id: 'dgResultGrid',
		layout: 'fit',
		region: 'center',
		maximizable : true,
		store: store,
		cm: cm,
		name: '病历授权查询结果', // add by niucaicai 导出结果时作为sheet名字
		plugins: [
			expander
		],
		stopPropagation:true,
		forceFit: true,
		autoScroll: true,
		frame: true,
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
		,title: '历史申请记录'
		,height : 485
		,width : 1100
		,layout : 'border'
		,modal: true
		,maximizable: true
		,items:[
			dgResultGrid
		]
	});

	HistoryWin.show();
	
	function getUrl()
	{
		var link = '../EMRservice.Ajax.Appoint.cls?Action=getHistory&EpisodeID=' + episodeID + '&RequestUserID=' + userID;
		//var link = '../EMRservice.Ajax.AuthAppoint.cls?Action=getHistory&RequestUserID=' + userID;
		return link;
	}
}

function rendererRequestAction(val)
{
	var actionStr = "";
	var actionDesc = getActionByCode(val);
	actionStr = actionDesc;
	return actionStr;
}

function rendererAppointAction(val)
{
	var actionStr = "";
	var actionDesc = getActionByCode(val);
	actionStr = actionDesc;
	return actionStr;
}

function rendererIsActive(val){
    var retStr = "";
    if (val == 1) {
        retStr = "<span style='color:green;font-weight:bold;'>授权中</span>";
        return retStr;
    }
    else 
        if (val == 0) {
            retStr = '过期';
            return retStr;
        }
        else {
            return ""
        }
}

function rendererPAAdmType(val){
    var retStr = "";
    if (val == 'I') {
        retStr = '住院';
        return retStr;
    }
    else 
        if (val == 'O') {
            retStr = '门诊';
            return retStr;
        }
        else {
            retStr = '急诊';
            return retStr;
        }
}

function rendererPAStatus(val){
    var retStr = "";
    if (val == 'in') {
        retStr = '在院';
        return retStr;
    }
    else {
        retStr = "<span style='color:green;font-weight:bold;'>出院</span>";
        return retStr;
    }
}

//转换授权状态为名称，并上色
function rendererIsAppointed(val){
    var retStr = "";
    if (val == 'unappointed') {
        retStr = '未授权';
        return retStr;
    }
    else 
        if (val == 'appointed') {
            retStr = '已授权';
            //已授权改变背景色
            retStr = "<span style='color:red;font-weight:bold;'>已授权</span>";
            return retStr;
        }
        else 
            if (val == 'refuse') {
                retStr = '拒绝';
                return retStr;
            }
            else {
                retStr = val;
                return retStr;
            }
}

function rendererDateTime(val){
    if (val == "" || typeof(val) == "undefined") {
        return;
    }
    else {
        if (val == "1840-12-31 00:00:00") {
            return "";
        }
        else {
            return val;
        }
    }
}

function rendererRequestAction(val)
{
	var actionStr = "";
	var actionDesc = getActionByCode(val);
	actionStr = actionDesc;
		
		
	
	return actionStr;
}

function getActionByCode(val)
{
	//alert(val)
	var retStr = "";
    switch (val) {
        case 'save':
            retStr = '保存';
            break;
        case 'print':
            retStr = '打印';
            break;
		case 'delete':
            retStr = '删除';
            break;
        case 'view':
            retStr = '查看';
            break;
		case 'new':
            retStr = '创建';
            break;
        default:
            retStr = val;
    }
    return retStr;
}

function getAppointType(val){
    if (val == "" || typeof(val) == "undefined") {
        return;
    }
    var retStr = "";
    switch (val) {
        case '0':
            retStr = '个人';
            break;
        case '1':
            retStr = '科室';
            break;
        default:
            retStr = val;
    }
    return retStr;
}

//给予授权时间
function rendererAppointSpan(val){
    if (val == "" || typeof(val) == "undefined") {
        return;
    }
    val = parseFloat(val);
    val = parseInt(val)
	if (val==168)
	{
		return '1周';
	}
	else
	{
		return val + '小时';
	}
}

function TrimEnterAndWrite(val)
{
	while (val.indexOf("xiegangxiegang")!= -1)
	{
		val = val.replace("xiegangxiegang","\\");
	}
	while (val.indexOf("@@@")!= -1)
	{
		val = val.replace("@@@","'");
	}
	while (val.indexOf("fanxiegangfanxiegang")!= -1)
	{
		val = val.replace("fanxiegangfanxiegang","/");
	}
	while (val.indexOf("douhaodouhao")!= -1)
	{
		val = val.replace("douhaodouhao",",");
	}
	while (val.indexOf("tanhaotanhao")!= -1)
	{
		val = val.replace("tanhaotanhao","!");
	}
	while (val.indexOf("juhaojuhao")!= -1)
	{
		val = val.replace("juhaojuhao","。");
	}
	while (val.indexOf("zuodanyinhao")!= -1)
	{
		val = val.replace("zuodanyinhao","‘");
	}
	while (val.indexOf("youdanyinhao")!= -1)
	{
		val = val.replace("youdanyinhao","’");
	}
	while (val.indexOf(" ")!= -1)
	{
		val = val.replace(" ","");
	}

	return val;
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
