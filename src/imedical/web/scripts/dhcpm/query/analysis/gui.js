//Create by dongzt
// 2015016
//需求统计分析
function InitviewScreen(){
	var obj = new Object();
	//******************************Start****************************
	obj.cboDateType = Common_ComboToDateType1("cboDateType","日期类型","创建日期");
	obj.cboStatisticType = Common_ComboStatisticType("cboStatisticType","统计维度","科室维度");
	obj.dtFromDate = new Ext.form.DateField({
		id : 'dtFromDate'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '开始日期'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		,value : new Date()
	});
	
	obj.dtToDate = new Ext.form.DateField({
		id : 'dtToDate'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '结束日期'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,plugins: 'monthPickerPlugin'
		,value : new Date()
	});
	
	
	obj.cboLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboLocStore = new Ext.data.Store({
		proxy: obj.cboLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'desc', mapping: 'desc'}
			,{name: 'rowid', mapping: 'rowid'}
		])
	});
	obj.cboLoc = new Ext.form.ComboBox({
		id : 'cboLoc'
		,width : 100
		,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '科室'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.cboLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Query.PMQueryLookUp';
			param.QueryName = 'PMLocLookUp';
			param.Arg1 = obj.cboLoc.getRawValue();
			param.Arg2 = '';
			param.ArgCnt = 2;
	});
	
	obj.cboDemStatusStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboDemStatusStore = new Ext.data.Store({
		proxy: obj.cboDemStatusStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.cboDemStatus = new Ext.form.ComboBox({
		id : 'cboDemStatus'
		,width : 100
		,store : obj.cboDemStatusStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '需求状态'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.cboDemStatusStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Query.PMQueryLookUp';
			param.QueryName = 'PMDicLookUp';
			param.Arg1 = obj.cboDemStatus.getRawValue();;
			param.Arg2 = 'Improvement';
			param.ArgCnt = 2;
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,text : '查询'
	});
	//****************************** End ****************************
	obj.StatDataGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
			,timeout: 300000
			,method:'POST'
	}));
	obj.StatDataGridPanelStore = new Ext.data.Store({
		proxy: obj.StatDataGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'TRowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'TRowid', mapping: 'TRowid'}
			,{name: 'TDesc', mapping: 'TDesc'}
			,{name: 'TNum', mapping: 'TNum'}
			,{name: 'TRatio', mapping: 'TRatio'} //TFlag
			,{name: 'TFlag', mapping: 'TFlag'}
		])
	});
	obj.DataCheckColumn = new Ext.grid.CheckColumn({header : '',	dataIndex : 'checked',width : 40});
	     
	obj.StatDataGridPanel = new Ext.grid.GridPanel({
		id : 'StatDataGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'Loading...'}
		//,region : 'west'
		//,split: true
		,width : 300
		,minWidth: 10
        ,maxWidth: 500
		,height:430
		//,autoScroll : true
		//,animCollapse: true
		//,collapsible : true
		//,collapsed : true
		//,margins: '0 0 0 5'
		,store : obj.StatDataGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({ singleSelect: true })
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ID', width: 50, dataIndex: 'TRowid', hidden:true,sortable: false}
			,{header: '科室/需求状态', width: 100, dataIndex: 'TDesc', sortable: false
			,renderer : function(value, metaData, record, rowIndex, colIndex, store) {
				
					var DemDescValue=record.get("TDesc");
					var strRet = "";
					
					if ((DemDescValue=="科室需求分析")||(DemDescValue=="需求状态分析"))
					{
						strRet = "<div style='color:#EE9A00;font-size:20px;font-weight:bold;'>" + value + "</div>";
					}
					else
					{
						strRet = "<div style='font-size:12px;font-weight:bold;'>" + value + "</div>";
					}
					
					return strRet;
				}
			
			
			}
			,{header: '需求<br>数量', width: 50, dataIndex: 'TNum', sortable: false
			,renderer : function(value, metaData, record, rowIndex, colIndex, store) {
				
					var DemDescValue=record.get("TNum");
					var strRet = "";
						strRet = "<div style='color:#A52A2A;font-size:14px;font-weight:bold;'>" + value + "</div>";
					
					
					return strRet;
				}
			
			
			
			
			}
			,{header: '比例', width: 50, dataIndex: 'TRatio', sortable: false}
			,{header: 'TFlag', width: 50, dataIndex: 'TFlag',hidden:true,sortable: false}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.StatDataGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			forceFit : true
		}
	});
	
	
	//---------------------------------------------
	obj.StaNumPanal=new Ext.Panel({
			id : 'StaNumPanal'
			//,layout : 'border'
			,split: true
			,title:'科室汇总'
			,collapsible: true
			,collapseDirection:'bottom'
			//,margins: '0 0 0 5'
			,autoScroll : true
			,animCollapse: true
			,region : "west"
			,border:true
			,width : 300
			//,height: '100%'
			,items:[
			obj.StatDataGridPanel
			
		]	
		});
	
	
	obj.StatiscticChart = {
						
            store: obj.StatDataGridPanelStore,
            //region : "center",
			width: '100%',
			height: '100%',
            xtype: 'piechart',
            dataField: 'TNum',
            categoryField: 'TDesc',
            title : '数量构成图',
            //extra styles get applied to the chart defaults
            extraStyle:
            {
                legend:
                {
                    //display: 'bottom',
					
					display: 'right',
                    padding: 5,
                    font:
                    {
                        family: 'Tahoma',
                        size: 12
                    }
                },
				border:
				{
					color:'ffffff',
					size:65
				}
            }
        };
		
		obj.ChartPanal=new Ext.Panel({
			id : 'ChartPanal'
			//,layout : 'border'
			,split: true
			,title:'科室需求构成图'
			,collapsible: true
			//,collapseDirection:'bottom'
			//,margins: '0 0 0 5'
			,autoScroll : true
			,animCollapse: true
			,region : "center"
			,border:true
			//,width : '30%'
			,items:[
			obj.StatiscticChart
			
		]	
		});
		
		//------------------------------------
	
	
	obj.StatDataGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCPM.Query.PMStatistic';
			param.QueryName = 'QryLocDemInfo';
			param.Arg1 = obj.cboDateType.getValue(); //"Common_GetValue('cboDateType');；
			param.Arg2 = obj.dtFromDate.getRawValue(); 
			param.Arg3 = obj.dtToDate.getRawValue(); 
			param.Arg4 = obj.cboLoc.getValue();
			param.Arg5 = obj.cboDemStatus.getValue();
			param.Arg6 = ""
			param.Arg7 = ""
			param.Arg8 = ""
			param.Arg9 = obj.cboStatisticType.getValue();
			param.ArgCnt = 9;
	});
	obj.DtlDataGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
			,method:'POST'
	}));
	obj.DtlDataGridPanelStore = new Ext.data.Store({
		proxy: obj.DtlDataGridPanelStoreProxy,
		reader : new Ext.data.JsonReader({
				root : 'record',
				totalProperty : 'total',
				idProperty : 'DemandID'
			}, [
				{ name : 'checked', mapping : 'checked' }
				, { name : 'DemandID', mapping : 'DemandID' }
				, { name : 'DemandType', mapping : 'DemandType' }
				, { name : 'MenuName', mapping : 'MenuName' }
				, { name : 'UserName', mapping : 'UserName' }
				, { name : 'UserPhone', mapping : 'UserPhone' }
				, { name : 'LocName', mapping : 'LocName' }
				, { name : 'DemondCode', mapping : 'DemondCode' }
				, { name : 'DemandDesc', mapping : 'DemandDesc' }
				, { name : 'EmergDegree', mapping : 'EmergDegree' }
				, { name : 'DemandStatus', mapping : 'DemandStatus' }
				, { name : 'DCreateDate', mapping : 'DCreateDate' }
				, { name : 'DCreateTime', mapping : 'DCreateTime' }
				, { name : 'DEndDate', mapping : 'DEndDate' }
				, { name : 'DEndTime', mapping : 'DEndTime' }
				, { name : 'AdjunctFlag', mapping : 'AdjunctFlag' }
			]
		)
	});
	obj.DtlDataGridPanel = new Ext.grid.GridPanel({
		id : 'DtlDataGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'Loading...'}
		,region : 'south'
		//,split: true
		//,collapsible: true
		,width : '100%'
		,height: 275
		,minHeight: 10
        ,maxHeight: 500
		,store : obj.DtlDataGridPanelStore
		,columns: [
			new Ext.grid.RowNumberer()
			, { header : '需求类型', width : 100, dataIndex : 'DemandType', sortable : true, align : 'center' }
			, { header : '菜单名称', width : 100, dataIndex : 'MenuName',sortable : true,align : 'center' }
			, { header : '创建者', width : 100, dataIndex : 'UserName', sortable : false, align : 'center' }
			, { header : '联系电话', width : 100, dataIndex : 'UserPhone', sortable : false, align : 'center' }
			, { header : '科室', width : 100, dataIndex : 'LocName', sortable : false, align : 'center' }
			, { header : '需求代码', width : 100, dataIndex : 'DemondCode', sortable : false, align : 'center' }
			, { header : '需求名称', width : 250, dataIndex : 'DemandDesc', sortable : false }
			, { header : '紧急程度', width : 80, dataIndex : 'EmergDegree', sortable : false }
			, { header : '状态', width : 100, dataIndex : 'DemandStatus', sortable : false
			,renderer : function(value, metaData, record, rowIndex, colIndex, store) {
					var strRet = "";
					switch (record.get("DemandStatus")) {
						case "审核不通过" :
							strRet = "<div style='color:red';font-weight:bold>" + value + "</div>";
							break;
						case "提交" :
							strRet = "<div style='color:green'>" + value + "</div>";
							break;
						case "测试" :
							strRet = "<div style='color:orange'>" + value + "</div>";
							break;
						case "保存" :
							strRet = "<div style='color:#8968CD'>" + value + "</div>";
							break;
						case "审核1" :
							strRet = "<div style='color:blue'>" + value + "</div>";
							break;
						case "分配" :
							strRet = "<div style='color:gray'>" + value + "</div>";
							break;
						default :
							strRet = "<div style='color:black'>" + value + "</div>";
							break;
					}
					return strRet;
				}
			
			
			}
			, { header : '创建日期', width : 100, dataIndex : 'DCreateDate', sortable : false }
			, { header : '创建时间', width : 80, dataIndex : 'DCreateTime', sortable : false, align : 'center' }
			, { header : '完成日期', width : 120, dataIndex : 'DEndDate', sortable : true, align : 'center' }
			, { header : '完成时间', width : 80, dataIndex : 'DEndTime', sortable : false, align : 'center' }
			, { header : '附件标志', width : 120, dataIndex : 'AdjunctFlag', hidden:true,sortable : true, align : 'center' }
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.DtlDataGridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
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
	//--------------------------------------------------------------------
	obj.StaDetailPanal=new Ext.Panel({
			id : 'StaDetailPanal'
			//,layout : 'border'
			,width : '70%'
			//,height: '100%'
			,title:'需求明细'
			,split: true
			,height:300
			,collapsible: true
			,collapsed:true
			,collapseDirection:'bottom'
			//,margins: '0 0 0 5'
			,autoScroll : true
			,animCollapse: true
			,region : "south"
			,border:true
			//,width : 300
			,items:[
			obj.DtlDataGridPanel
			
		]
			
		});
	
	
	
	//--------------------------------------------------------------------
	
	
	obj.StatDataGridPanel.getSelectionModel().on('rowselect', function(sm, rowIdx, r) {
            //var StatDataGridPanel = Ext.getCmp('StatDataGridPanel');
            //bookTpl.overwrite(StatDataGridPanel.body, r.data);
            //Ext.MessageBox.alert(r.data.TFlag+"  "+r.data.TRowid);
			var w = Ext.getCmp('StaDetailPanal');
            // expand or collapse that Panel based on its collapsed property state
           // w.collapsed ? w.expand() : w.collapse();
			if (w.collapsed)
			{
				 w.expand();
			}
			var LocValue=obj.cboLoc.getValue();
				var StatusValue=obj.cboDemStatus.getValue();
				
			var DemRowid=r.data.TRowid;
			var DemFlag=r.data.TFlag;
			
			obj.DtlDataGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		
			param.ClassName = 'DHCPM.Query.PMQueryAll';
			param.QueryName = 'QryAllDemInfo';
			param.Arg1 = obj.cboDateType.getValue();;
			param.Arg2 = obj.dtFromDate.getRawValue();
			param.Arg3 = obj.dtToDate.getRawValue();
			if (DemFlag=="LOC"){
				if(StatusValue=="")
				{
					param.Arg4 = r.data.TRowid;
					param.Arg5 = "";
				}
				else 
				{
					param.Arg4 = r.data.TRowid;
					param.Arg5 = StatusValue;
				}
				
				}
			else if (DemFlag=="STATUS"){
				
				if(LocValue=="")
				{
					param.Arg5 = r.data.TRowid;
					param.Arg4 = "";
				}
				else
				{
					
					param.Arg4 = LocValue;
					param.Arg5 = r.data.TRowid;
				}
				
				}
			else
			{
				
				
				if ((LocValue!="")&&(StatusValue!=""))
				{
					param.Arg4 = LocValue;
					param.Arg5 = StatusValue;
				}
				else if (LocValue=="")
				{
					param.Arg4 = "";
					param.Arg5 = StatusValue;
				}
				else if (StatusValue=="")
				{
					param.Arg4 = LocValue;
					param.Arg5 = "";
				}
				else
				{
					param.Arg4 = "";
					param.Arg5 = "";
				}
			}
			param.Arg6 = "";
			param.Arg7 = "";
			param.Arg8 = "";
			param.ArgCnt = 8;
	});
		obj.DtlDataGridPanelStore.removeAll();
		obj.DtlDataGridPanelStore.load({params : {start:0,limit:20}});
        });
		
	obj.DataGridPanel = new Ext.Panel({
		id : 'DataGridPanel'
		,buttonAlign : 'center'
		,layout : 'border'
		,region : 'center'
		,items:[
		obj.ChartPanal
		,obj.StaNumPanal
		,obj.StaDetailPanal
		//obj.StatDataGridPanel
		//,obj.DtlDataGridPanel
		]
	});
	//---------------------------------------------------------------------------------------------

	//---------------------------------------------------------------------------------------------
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [
			//obj.ConditionPanel
			//,obj.ConditionPanel2
			obj.DataGridPanel,
			//,obj.ChartPanel
			{
				layout : 'form',
				region : "north",
				height : 90,
				frame : true,
				buttonAlign : 'center',
				title : '需求统计分析',
				items : [
					{
						layout : 'column',
						items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboDateType
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.dtFromDate
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.dtToDate
								]
							},{
								columnWidth:.20,
								layout : 'form',
								boxMinWidth : 80,
								boxMaxWidth : 80,
								items : [
									obj.btnQuery
								]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboLoc
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboDemStatus
								]
							},{
								columnWidth:.20,
								layout : 'form',
								labelAlign : 'right',
								labelWidth : 60,
								boxMinWidth : 100,
								boxMaxWidth : 220,
								items : [
									obj.cboStatisticType
								]
							}
						]
					}
				]
			}
		]
	});
	
	
	
	InitviewScreenEvent(obj);
		
	//事件处理代码
	obj.LoadEvent(arguments);
	
	
	return obj;
}

