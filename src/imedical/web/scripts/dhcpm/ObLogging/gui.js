//Create by zzp
// 20150519
//任务计划界面
function InitviewScreen(){
	var obj = new Object();
	//******************************Start****************************

	//****************************** End ****************************
	obj.ObLoggingStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ObLoggingStore = new Ext.data.Store({
		proxy: obj.ObLoggingStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['title'
		,'forumtitle'
		,'forumid'
		,'author'
		,'ObRowid'
		,'ObDate'
		,'lastposter'
		,'ObMenu'
		,'ObSolution'
		,'glipml'
		,'gluser'])
		
	});
	obj.ObLoggingStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Common';
			param.QueryName = 'ObStoreQuery';
			param.Arg1 = '';
			param.Arg2 = '';
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	obj.ObGrid = new Ext.grid.GridPanel({
	    id:'ObGrid',
        width:410,
        height:610,
        //title:'ExtJS.com - Browse Forums',
        store: obj.ObLoggingStore,
        trackMouseOver:false,
        disableSelection:true,
        loadMask: true,

        // grid columns
        columns:[{
            id: 'topic', // id assigned so we can apply custom css (e.g. .x-grid-col-topic b { color:#333 })
            header: "标题",
            dataIndex: 'title',
            width: 220,
            renderer: renderTopic,
            sortable: true
        },{
            header: "创建者",
            dataIndex: 'author',
            width: 100,
            hidden: true,
            sortable: true
        },{
            header: "解决方案",
            dataIndex: 'ObSolution',
            width: 100,
            hidden: true,
            sortable: true
        },{
            header: "次数",
            dataIndex: 'ObRowid',
            width: 70,
            align: 'right',
            hidden: true,
            sortable: true
        },{
            id: 'last',
            header: "创建信息",
            dataIndex: 'ObDate',
            width: 150,
            renderer: renderLast,
            sortable: true
        }],

        // customize view config
        sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
        viewConfig: {
            forceFit:true,
            enableRowBody:true,
            showPreview:true,
            getRowClass : function(record, rowIndex, p, store){
                if(this.showPreview){
                    p.body = '<p><br/>'+record.data.ObMenu+'</p>'+'<br/>';
                    return 'x-grid3-row-expanded';
                }
                return 'x-grid3-row-collapsed';
            }
        },
        tbar:Obtbar,
        // paging bar on the bottom
        bbar: new Ext.PagingToolbar({
            pageSize: 25,
            store: obj.ObLoggingStore,
            displayInfo: true,
            displayMsg: '{0} - {1} of {2}',
           // emptyMsg: "No rows to display",
            items:[
                '-', {
                pressed: true,
                enableToggle:true,
                text:'显示标题',
                cls: 'x-btn-text-icon details',
                toggleHandler: function(btn, pressed){
                    var view = obj.ObGrid.getView();
                    view.showPreview = pressed;
                    view.refresh();
                }
            }]
        }),
        listeners : {// 表格单击事件  
		"rowclick":function(ObGrid, rowIndex,columnIndex,e) {
		 var data=ObGrid.getStore().getAt(rowIndex).data;
		 OjrowclickS(data);
		}}
    });
	
	obj.gridContractCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.ContractGridPanel = new Ext.grid.GridPanel({
		id : 'ContractGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'正在查询中，请稍等...'}
		//,region : 'west'
		,region : 'center'
		//,split: true
		//,collapsible: true
		,width : 300
		,height: 100
		,minHeight: 10
        ,maxHeight: 500
		,plugins : obj.gridContractCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.PlanGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridContractCheckCol
			, {header : "操作",width : 200,forceFit : true,dataIndex : 'node',align : 'center',renderer: function (value, metaData, record, rowIndex, colIndex, store) {
			   var strRet = "";
			   if(record.get("PPPGridAdjuc")=="Y"){
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='ContractDetail'>详细查看</a>";
			   formatStr=formatStr+" | <a href='javascript:void({1});' onclick='javscript:return false;' class='ContractUser'>责任人</a>";
			   formatStr=formatStr+" | <a href='javascript:void({2});' onclick='javscript:return false;' class='Download'>附件管理</a>"; 
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   }
			   else {
			   formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='ContractDetail'>详细查看</a>";
			   formatStr=formatStr+" | <a href='javascript:void({1});' onclick='javscript:return false;' class='ContractUser'>责任人</a>";
			   formatStr=formatStr+" | <a href='javascript:void({2});' onclick='javscript:return false;' class='Download'>附件管理</a>"; 
			   strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   };
			   return strRet;
			   }}
			, { header : 'Rowid', width : 150, dataIndex : 'PPPGridRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '计划编码', width : 150, dataIndex : 'PPPGridCode', sortable : false, align : 'center',editable: true }
			, { header : '计划名称', width : 200, dataIndex : 'PPPGridDesc', sortable : false ,align : 'center'}
			, { header : '计划开始日期', width : 100, dataIndex : 'PPPGridPlanStartDate', sortable : true, align : 'center' }
			, { header : '计划开始时间', width : 100, dataIndex : 'PPPGridPlanStartTime',sortable : true,align : 'center' }
			, { header : '实际开始日期', width : 100, dataIndex : 'PPPGridStartDate',sortable : true,align : 'center'}
			, { header : '实际结束时间', width : 100, dataIndex : 'PPPGridStartTime', sortable : true, align : 'center' }
			, { header : '计划结束日期', width : 100, dataIndex : 'PPPGridPlanEndDate', sortable : true, align : 'center' }
			, { header : '计划结束时间', width : 100, dataIndex : 'PPPGridPlanEndTime', sortable : true, align : 'center' }
			, { header : '实际结束日期', width : 100, dataIndex : 'PPPGridEndDate', sortable : true, align : 'center' }
			, { header : '实际结束时间', width : 100, dataIndex : 'PPPGridEndTime', sortable : true, align : 'center' }
			, { header : '计划状态', width : 100, dataIndex : 'PPPGridStatus', sortable : true, align : 'center' }
			, { header : '计划状态id', width : 100, dataIndex : 'PPPGridStatusid',hidden:true, sortable : true, align : 'center' }
			, { header : '关联需求', width : 100, dataIndex : 'PPPGridImprovment', sortable : true, align : 'center' }
			, { header : '关联需求id', width : 100, dataIndex : 'PPPGridImprovmentid', hidden:true,sortable : true, align : 'center' }
			, { header : '工作记录', width : 100, dataIndex : 'PPPGridJobLogg', sortable : true, align : 'center' }
			, { header : '工作记录id', width : 100, dataIndex : 'PPPGridJobLoggid',hidden:true, sortable : true, align : 'center' }
			, { header : '关联模块', width : 100, dataIndex : 'PPPGridModule', sortable : true, align : 'center' }
			, { header : '关联模块id', width : 100, dataIndex : 'PPPGridModuleid', sortable : true, align : 'center' }
			, { header : '关联工期', width : 100, dataIndex : 'PPPGridContractAging', sortable : true, align : 'center' }
			, { header : '关联工期id', width : 100, dataIndex : 'PPPGridContractAgingid', sortable : true, align : 'center' }
			, { header : '关联合同', width : 100, dataIndex : 'PPPGridContract', sortable : true, align : 'center' }
			, { header : '关联合同id', width : 100, dataIndex : 'PPPGridContractid', sortable : true, align : 'center' }
			, { header : '附件标志', width : 100, dataIndex : 'PPPGridAdjuc', sortable : true, align : 'center' }
			, { header : '主要内容', width : 100, dataIndex : 'PPPGridMenu', sortable : true, align : 'center' }
			, { header : '备注信息', width : 100, dataIndex : 'PPPGridRemark', sortable : true, align : 'center' }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.PlanGridStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			//,scrollOffset: 0
			enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
	});
	obj.PlanPanal=new Ext.Panel({
			id : 'PlanPanal'
			,layout : 'border'
			,width : '100%'
			,region : 'center'
			,collapsible: true
			,border:true
			,items:[obj.ContractGridPanel]
		});

	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [obj.Plantree
		          ,obj.PlanPanal]});
	
	//--------------------------------------------------------------------------------------------
	
	obj.PlanGridStore.removeAll();
	obj.PlanGridStore.load({params : {start:0,limit:20}});
	InitviewScreenEvent(obj);	
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}