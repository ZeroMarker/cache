function InitViewScreen(){
	Ext.QuickTips.init();
	var obj = new Object();
	obj.anciId=-1;
	obj.displayId=-1;
	obj.fieldName="";
	obj.infoAnciId="";
	obj.infoSearchLevel="";
	obj.infoAnciiSub="";
	obj.infoOpaId="";
	obj.historySeq="";
	obj.pageSize = 50;
	obj.currentPageStart = 0;
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
		,listeners:{
			'requestcomplete':function(arg1,arg2,arg3){
				obj.retGridStoreReponseText = arg2.responseText;
			}
		}
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'opaId'   
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'status', mapping: 'status'}
			,{name: 'jzstat', mapping: 'jzstat'}
			,{name: 'opdatestr', mapping: 'opdatestr'}
			,{name: 'appLocDesc', mapping: 'appLocDesc'}
			,{name: 'regno', mapping: 'regno'}
			,{name: 'medCareNo', mapping: 'medCareNo'}
			,{name: 'patName', mapping: 'patName'}
			,{name: 'sex', mapping: 'sex'}
			,{name: 'age', mapping: 'age'}
			,{name: 'diagStr', mapping: 'diagStr'}
			,{name: 'opdes', mapping: 'opdes'}
			,{name: 'surgeonDesc', mapping: 'surgeonDesc'}
			,{name: 'ash', mapping: 'ash'}
			,{name: 'opDocNote', mapping: 'opDocNote'}
			,{name: 'opAntibiotic', mapping: 'opAntibiotic'}
			,{name: 'anmethod', mapping: 'anmethod'}
			,{name: 'mzdoc', mapping: 'mzdoc'}
			,{name: 'MiniInvasiveStr', mapping: 'MiniInvasiveStr'}
			,{name: 'HbsAg', mapping: 'HbsAg'}
			,{name: 'HCVAb', mapping: 'HCVAb'}
			,{name: 'HivAb', mapping: 'HivAb'}
			,{name: 'TPAb', mapping: 'TPAb'}
			,{name: 'TestOther', mapping: 'TestOther'}
			,{name: 'xsh', mapping: 'xsh'}
			,{name: 'xch', mapping: 'xch'}
			,{name: 'jbxsh', mapping: 'jbxsh'}
			,{name: 'jbxch', mapping: 'jbxch'}
			,{name: 'jb', mapping: 'jb'}
			,{name: 'opreq', mapping: 'opreq'}
			,{name: 'oplevel', mapping: 'oplevel'}
			,{name: 'opduration', mapping: 'opduration'}
			,{name: 'theatreInOutDuration', mapping: 'theatreInOutDuration'}
			,{name: 'scNurNote', mapping: 'scNurNote'}
			,{name: 'cirNurNote', mapping: 'cirNurNote'}
			,{name: 'anaTheatreDateTimeStr', mapping: 'anaTheatreDateTimeStr'}
			,{name: 'anaStartEndDuration', mapping: 'anaStartEndDuration'}
			,{name: 'anaDateTimeStr', mapping: 'anaDateTimeStr'}
			,{name: 'searchOpaInfo', mapping: 'searchOpaInfo'}
			,{name: 'totalStatInfo', mapping: 'totalStatInfo'}
			,{name: 'opaId', mapping: 'opaId'}
		])
	});
	obj.retGridPanelStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'FindStatDetails';
		param.Arg1 = obj.anciId;
		param.Arg2 = obj.displayId;
		param.Arg3 = obj.fieldName;
		param.Arg4 = obj.historySeq;
		param.ArgCnt = 4;
	});
	obj.retGridPanelCheckCol=new Ext.grid.CheckboxSelectionModel({
		checkOnly : false
	});
	obj.gridcm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,obj.retGridPanelCheckCol
			,{
				header: '查询项目信息'
				,width: 100
				,dataIndex: 'searchOpaInfo'
				,sortable: true
				,renderer:function(value,metadata,record){
					return value.replace("\n","<br>");	
				}
			}
			,{
				header: '统计汇总信息'
				,width: 100
				,dataIndex: 'totalStatInfo'
				,sortable: true
				,renderer:function(value,metadata,record){
					return value.replace("\n","<br>");	
				}
			}
			,{header: 'opaId', width: 40, dataIndex: 'opaId', sortable: true}
			,{header: '类型', width: 40, dataIndex: 'jzstat', sortable: true}
			,{header: '状态', width: 40, dataIndex: 'status', sortable: true}
			,{header: '手术开始结束时间', width: 100, dataIndex: 'opdatestr', sortable: true}
			,{header: '手术计时', width: 60, dataIndex: 'opduration', sortable: true}
			,{header: '入离室时间', width: 100, dataIndex: 'anaTheatreDateTimeStr', sortable: true}
			,{header: '入离室时间间隔', width: 60, dataIndex: 'theatreInOutDuration', sortable: true}
			,{header: '麻醉开始结束时间', width: 100, dataIndex: 'anaDateTimeStr', sortable: true}
			,{header: '麻醉开始结束间隔', width: 60, dataIndex: 'anaStartEndDuration', sortable: true}
			,{
				header: '科室'
				, width: 70
				, dataIndex: 'appLocDesc'
				, sortable: true
				,renderer: function(value, meta, record) {     
	        		meta.attr = 'style="white-space:normal;"';      
	        		return value;      
	        	} 
			}
			,{header: '登记号', width: 75, dataIndex: 'regno', sortable: true}
			,{header: '病案号', width: 80, dataIndex: 'medCareNo', sortable: true}
			,{header: '姓名'
				, width: 55
				, dataIndex: 'patName'
				, sortable: true
				,renderer: function(value, meta, record) {     
			        meta.attr = 'style="white-space:normal;"';      
		    	    return value;      
				} 
			}
			,{header: '性别', width: 35, dataIndex: 'sex', sortable: true}
			,{header: '年龄', width: 35, dataIndex: 'age', sortable: true}
			,{
				header: '手术诊断', 
				width: 100, 
				dataIndex: 'diagStr', 
				sortable: true,
				renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        }   
			}
			,{
				header: '手术名称', 
				width: 150, 
				dataIndex: 'opdes', 
				sortable: true,
				renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        }   
			}
			,{
				header: '手术医师'
				, width: 60
				, dataIndex: 'surgeonDesc'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			,{
				header: '其他手术医师'
				, width: 60
				, dataIndex: 'ash'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			,{header: '手术医师备注', width: 100, dataIndex: 'opDocNote', sortable: true}
			,{header: '术中追加抗生素', width: 100, dataIndex: 'opantibiotic', sortable: true}
			,{
				header: '麻醉方法'
				, width: 120
				, dataIndex: 'anmethod'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			,{
				header: '麻醉医生'
				, width: 80
				, dataIndex: 'mzdoc'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			,{header: '是否微创', width: 60, dataIndex: 'miniinvasive', sortable: true}
			,{header: 'Hbs_Ag', width: 60, dataIndex: 'HbsAg', sortable: true}
			,{header: 'HCV_Ab', width: 60, dataIndex: 'HCVAb', sortable: true}
			,{header: 'Hiv_Ab', width: 60, dataIndex: 'HivAb', sortable: true}
			,{header: '梅毒', width: 60, dataIndex: 'TPAb', sortable: true}
			,{header: '其他感染', width: 60, dataIndex: 'TestOther', sortable: true}
			,{
				header: '手术级别'
				, width: 80
				, dataIndex: 'oplevel'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			,{
				header:'器械护士'
				, width: 60
				, dataIndex: 'xsh'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			,{
				header: '巡回护士'
				, width: 60
				, dataIndex: 'xch'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        }
			}
			,{
				header:'交班器械护士'
				, width: 60
				, dataIndex: 'jbxsh'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			,{
				header: '交班巡回护士'
				, width: 60
				, dataIndex: 'jbxch'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        }
			}
			,{header: '交班手术', width: 35, dataIndex: 'jb', sortable: true}
			,{
				header: '备注'
				, width: 100
				, dataIndex: 'opreq'
				, sortable: true
				,renderer: function(value, meta, record) {     
		        	meta.attr = 'style="white-space:normal;"';      
		        	return value;      
		        } 
			}
			,{header: '器械护士备注', width: 100, dataIndex: 'scNurNote', sortable: true}
			,{header: '巡回护士备注', width: 100, dataIndex: 'cirNurNote', sortable: true}
		]
	})
	obj.btnPrintResult = new Ext.Button({
		id : 'btnPrintResult'
		,iconCls : 'icon-page_excel'
		,text : '导出至Excel'
	});
	obj.btnPrintResult.setTooltip("在左边列表中可以选择需要导出的列!");
	obj.btnANMonitor = new Ext.Button({
		id : 'btnANMonitor'
		,iconCls : 'icon-application'
		,text : '麻醉监护'
	});
	obj.btnANMonitor.setTooltip("需当前用户登录科室有可查看麻醉监护的权限!");
	obj.tb=new Ext.Toolbar(
	{
		height: 35
		,items:[
			obj.btnPrintResult
			,"-"
			,obj.btnANMonitor
		]
	});
	obj.comboPageSize = new Ext.form.ComboBox({
		name : 'pagesize',
		triggerAction : 'all',
		mode : 'local',
		store : new Ext.data.ArrayStore({
			fields : ['value', 'text'],
			data : [
				[10, '10'], [20, '20'],
				[50, '50'], [100, '100'],
				[250, '250'], [500, '500'],
				[1000, '1000']
			]
		}),
		valueField : 'value',
		displayField : 'text',
		value : '50',
		editable : true,
		width : 65,
		listeners:{
			'select':function(){
				obj.pageSize = this.getValue();
				obj.gridPagingTool.pageSize = obj.pageSize;
				if(obj.anciId)
				{
					obj.retGridPanelStore.removeAll();
					obj.retGridPanelStore.load({
						params : {
							start:obj.currentPageStart
							,limit:obj.pageSize
						}
					});
				}
			}
		}
	});
	obj.gridPagingTool = new Ext.PagingToolbar({
		pageSize : obj.pageSize,
		store : obj.retGridPanelStore,
		displayMsg: '显示记录： {0} - {1} 合计： {2}',
		displayInfo: true,
		emptyMsg: '没有记录',
		items : ['-', '&emsp;每页显示', obj.comboPageSize,'行记录'],
		listeners :{
			'change':function(){
				obj.currentPageStart = this.cursor;
			}
		}
	});
	obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm:obj.retGridPanelCheckCol
		,clicksToEdit:1
		,loadMask : true
		,tbar:obj.tb
		,region : 'center'
		,buttonAlign : 'center'
		,cm:obj.gridcm
		,columnLines : true
		,viewConfig:
		{
			forceFit: false,
			getRowClass: function(record, index)
			{
				var status = record.get('status');
				var type=record.get('jzstat');
				switch (status)
				{
					case '申请':
						if(type=='急诊') return 'emergency';
						break;
					case '拒绝':
						return 'deepskyblue'; //blue /refuse
						break;
					case '安排':
						return 'palegreen';  //green //arranged
						break;
					case '完成':
						return 'yellow' ;//yellow //finish
						break;
					case '术中':
						return 'red' ;//red 
						break;
					case '术毕':
						return 'lightblue' ;//light blue
						break;
					case '恢复室':
						return 'resume';
						break;
					default:
						return 'exec'; //
						break; 
				}
			}
		}
		,bbar: obj.gridPagingTool
	});
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,title : '手术明细'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
			obj.retGridPanel
		]
	});
	obj.resultColsPrintPanel = new Ext.form.FormPanel({
		id : 'resultColsPrintPanel'
		,labelWidth : 10
		,labelAlign : 'right'
		,layout : 'form'
		,autoScroll : true
		,items : [
		]
	});
	obj.resultColsContainerPanel = new Ext.Panel({
		id : 'resultColsContainerPanel'
		,buttonAlign : 'center'
		,title : '<input id=\"chkselprintcol\" type=\"checkbox\" onclick=chkSelAllPrintCheck() checked></input><label for=\"chkselprintcol\">选择打印列</label>'
		,region : 'west'
		,width : 200
		,frame : true
		,layout : 'fit'
		,items : [
			obj.resultColsPrintPanel
		]
		,buttons:[
		]
	});
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,defaults: {
            split: true
			,collapsible: true
        }
		,items:[
			obj.resultColsContainerPanel
			,obj.resultPanel
		]
	});
	
	InitOpaInfoWindow(obj);
	
	InitViewScreenEvent(obj);

	obj.btnPrintResult.on('click',obj.btnPrintResult_click,obj);
	obj.retGridPanelStore.on('load',obj.retGridPanelStore_load,obj);
	obj.retGridPanelStore.on('loadexception',obj.retGridPanelStore_loadexception,obj);
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.btnANMonitor.on("click",obj.btnANMonitor_click,obj);
	obj.LoadEvent(arguments);
	return obj;
}
function chkSelAllPrintCheck()
{
	var val = Ext.getDom("chkselprintcol").checked;
	var itemslen = objControlArry['ViewScreen'].resultColsPrintPanel.items.length;
	for(var i=0;i<itemslen;i++)
	{
		objControlArry['ViewScreen'].resultColsPrintPanel.items.items[i].setValue(val);
	}
	objControlArry['ViewScreen'].resultColsPrintPanel.doLayout(true);
	for(var i in objControlArry['ViewScreen'].checkPrintCols)
	{
		if(typeof(objControlArry['ViewScreen'].checkPrintCols[i])!="object") objControlArry['ViewScreen'].checkPrintCols[i] = val;
	}
}