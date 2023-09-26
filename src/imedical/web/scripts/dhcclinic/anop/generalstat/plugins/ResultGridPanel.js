function InitResultGridPanel(obj)
{
	obj.retGridHeaderStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridHeaderStore = new Ext.data.Store({
		proxy: obj.retGridHeaderStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'code'   
			}, 
			[
				{name: 'code', mapping: 'code'}
				,{name: 'desc', mapping: 'desc'}
				,{name: 'width', mapping: 'width'}
			]
		)
	});
	obj.retGridHeaderStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'GetANCIResultHeader';
		param.Arg1=obj.comInquiry.getValue();
		param.ArgCnt =1;
	});
	
	obj.retGridStoreReponseText = "";
	
	obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : "./dhcclinic.anop.statmethodresponse.csp"
		,timeout:300000
		,listeners:{
			'requestcomplete':function(arg1,arg2,arg3){
				obj.retGridStoreReponseText = arg2.responseText;
			}
		}
	}));
	
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		remoteSort: true,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'displayId'   
			}, 
			[
				{name: 'displayId', mapping: 'displayId'}
				,{name: 'desc', mapping: 'desc'}
			]
		)
	});
	
	obj.retGridPanelStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.MethodName = 'ResponseInquiryResult';
		param.Arg1 = obj.itemComAppLoc.getValue();
		param.Arg2 = obj.anciId;
		param.Arg3 = obj.itemDateFrm.getRawValue()+" "+obj.itemTimeFrm.getRawValue();
		param.Arg4 = obj.itemDateTo.getRawValue()+" "+obj.itemTimeTo.getRawValue();
		param.Arg5 = obj.ifInquiry;
		param.Arg6 = obj.dateType;
		param.Arg7 = obj.comRetSumType.getValue();
		param.Arg8 = obj.historySeq;
		param.ArgCnt = 8;
		obj.retGridStoreReponseText = "";
	});
	obj.retGridPanelCheckCol = new Ext.grid.CheckboxSelectionModel({
		checkOnly : false
	});
	obj.retGridPanelRowNumber = new Ext.grid.NumberColumn({
		dataIndex:'rowId',
		header:'No',
		align:'center',
		width:50,
		format:0,
		css:'text-overflow: ellipsis;padding: 3px 5px 0 0 !important;text-align: right;color: #444;'
	});
	obj.gridcm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true
		}
        ,columns: [
			obj.retGridPanelRowNumber
			,obj.retGridPanelCheckCol
		]
	});

	InitResultGridTool(obj);

	obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm:obj.retGridPanelCheckCol
		,clicksToEdit:1
		,loadMask : {
			msg : '正在加载表格数据,请稍等...'
		}
		,viewConfig: {
    	    forceFit: false,
    	    getRowClass: function(record, index) {
    	        if (index%2 == 0) {
    	            return 'row-even';
    	        }
    	        else {
    	            return 'row-odd';
    	        }
    	    }
    	}
		,tbar:obj.gridHeaderTool
		,region : 'center'
		,buttonAlign : 'center'
		,cm:obj.gridcm
		,columnLines : true
		,enableDragDrop : false
		,bbar: obj.gridPagingTool
	});

	obj.retGridHeaderStore_load=function(args)
	{
		ReConfigGridPanel();
	}

	function ReConfigGridPanel()
	{
		var columnArray = new Array();
		var readerArray = new Array();
		var count = obj.retGridHeaderStore.getCount();
		var headerCode="",headerDesc="";
		if(count<1)
		{
		}
		columnArray[0]=obj.retGridPanelRowNumber;
		columnArray[1]=obj.retGridPanelCheckCol;
		readerArray[0]={name: 'checked', mapping : 'checked'};
		readerArray[1]={name: 'displayId', mapping : 'displayId'};
		readerArray[2]={name: 'rowId', mapping : 'rowId'};
		var cols=0;
		for(var i=0;i<count;i++)
		{
			var record=obj.retGridHeaderStore.getAt(i);
			cols++;
			columnArray[1+cols]={
				header: record.get('desc'),
				width: Number(record.get('width'))>0?Number(record.get('width')):80,
				dataIndex: record.get('code'),
				sortable: true,
				renderer:function(value,metadata,record){
					if(value=="总计") return "<span style='color:#FF0000;'>"+value+"</span>";
					else if((this.dataIndex.indexOf("D")>-1) || (value=="0")) return value;
					else if((this.dataIndex.indexOf("R")>-1)) return value.replace(/\n/g,"<br/>");
					else if((this.dataIndex.indexOf("S")>-1) && (value=="") && obj.chkShowZero.checked) return "0";
					//view_window 只打开一个新窗口(会覆盖之前打开的窗口)   _blank 打开一个新窗口(不会覆盖之前打开的窗口)
					return "<a target='view_window' title='查看明细' href='dhcclinic.anop.statdetailshow.csp?anciId="+obj.anciId+"&displayId="+record.get("displayId")+"&fieldName="+this.dataIndex+"'>"+value+"</a>";	
				}
			};
			readerArray[2+cols]={name: record.get('code'), mapping : record.get('code')};
		}
		obj.gridcm.setConfig(columnArray);
		obj.retGridPanelStore.reader = new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'displayId'
			},
			readerArray
		);
		var newGridPanelStore = new Ext.data.Store({
			proxy: obj.retGridPanelStoreProxy,
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'displayId'
				},
				readerArray
			)
		});
		obj.retGridPanelStore.fields = newGridPanelStore.fields;
		obj.retGridPanel.reconfigure(obj.retGridPanelStore,obj.gridcm);
	}

	obj.retGridPanelStore_load=function(args)
	{
		if(obj.retGridPanelStore.getCount()<1)
		{
			alert("查询结果为空,请重新设置查询开始结束日期!");
		}
		obj.SetButtonAbility(true);
	}
	obj.retGridPanelStore_loadexception=function(args)
	{
		try{
			if(obj.retGridStoreReponseText)
			{
				var errorText = obj.retGridStoreReponseText.split("</font>")[1].split("<ul>")[1].split("</ul>")[0];
				errorText = "<ul>"+errorText+"</ul>";
				Ext.Msg.show({
				   title: '程序运行错误',
				   msg: "<div>"+errorText+"</div>",
				   buttons: Ext.MessageBox.OK,
				   icon: Ext.MessageBox.ERROR,
				   width:600
				});
			}
			else
			{
				alert("服务器忙,请稍后重试!");
			}
		}
		catch(ex)
		{}

		obj.SetButtonAbility(true);
	}

	obj.retGridHeaderStore.on('load',obj.retGridHeaderStore_load,obj);
	obj.retGridPanelStore.on('load',obj.retGridPanelStore_load,obj);
	obj.retGridPanelStore.on('loadexception',obj.retGridPanelStore_loadexception,obj);

	obj.retGridPanel_rowclick = function()
	{
		var rowSelectObj=obj.retGridPanel.getSelectionModel().getSelected();
		if(rowSelectObj!=obj.selectObj)
		{
			if(obj.winScreen.isVisible())obj.winScreen.hide();
			obj.selectObj = rowSelectObj;
		}
	}
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);

	InitGridRowMoveMenu(obj);

	obj.retGridPanel_rowcontextmenu = function()
	{
		var rowSelectObj=obj.retGridPanel.getSelectionModel().getSelected();
		if(!rowSelectObj) return true;
		if(event && event.preventDefault) event.preventDefault();
		else window.event.returnValue = false;
		obj.resultContextMenu.showAt([window.event.clientX,window.event.clientY]);
		document.getElementById("rowno_moveto").value = "";
	}
	
	obj.retGridPanel.on("rowcontextmenu",obj.retGridPanel_rowcontextmenu,obj);
}