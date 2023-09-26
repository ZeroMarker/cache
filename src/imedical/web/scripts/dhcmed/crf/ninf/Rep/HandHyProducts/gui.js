
function InitViewport1(){
	var obj = new Object();
	
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	
	obj.cboExamLoc = Common_ComboToLoc("cboExamLoc","科室","","","","");
	obj.txtExamYYMM = Common_DateFieldToMonth("txtExamYYMM","年月");
	obj.cboProduct = Common_ComboToHandHyProducts("cboProduct","手卫生用品");
	obj.txtProUnit = Common_Label("txtProUnit","单位");
	obj.txtConsumption = Common_NumberField("txtConsumption","消耗量",0,0);
	obj.txtResume = Common_TextArea("txtResume","备注",50);
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width : 60
		,height : 25
		,text : '保存'
	})
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-Delete'
		,width: 60
		,height : 25
		,text : '删除'
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 60
		,height : 25
		,text : '查询'
	})
	
	obj.gridHandHyProductsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridHandHyProductsStore = new Ext.data.Store({
		proxy: obj.gridHandHyProductsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ReportID'
		},
		[
			{name: 'ReportID', mapping : 'ReportID'}
			,{name: 'ExamLocID', mapping : 'ExamLocID'}
			,{name: 'ExamLocDesc', mapping: 'ExamLocDesc'}
			,{name: 'ExamDate', mapping: 'ExamDate'}
			,{name: 'ExamYYMM', mapping: 'ExamYYMM'}
			,{name: 'ProductID', mapping: 'ProductID'}
			,{name: 'ProductDesc', mapping: 'ProductDesc'}
			,{name: 'ProductSpec', mapping: 'ProductSpec'}
			,{name: 'ProductUnit', mapping: 'ProductUnit'}
			,{name: 'Consumption', mapping: 'Consumption'}
			,{name: 'RepDate', mapping: 'RepDate'}
			,{name: 'RepTime', mapping: 'RepTime'}
			,{name: 'RepLocID', mapping: 'RepLocID'}
			,{name: 'RepLocDesc', mapping: 'RepLocDesc'}
			,{name: 'RepUserID', mapping: 'RepUserID'}
			,{name: 'RepUserDesc', mapping: 'RepUserDesc'}
			,{name: 'RepStatusID', mapping: 'RepStatusID'}
			,{name: 'RepStatusCode', mapping: 'RepStatusCode'}
			,{name: 'RepStatusDesc', mapping: 'RepStatusDesc'}
			,{name: 'RepResume', mapping: 'RepResume'}
		])
	});
	obj.gridHandHyProducts = new Ext.grid.EditorGridPanel({
		id : 'gridHandHyProducts'
		,store : obj.gridHandHyProductsStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		//,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '科室', width: 120, dataIndex: 'ExamLocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '年月', width: 80, dataIndex: 'ExamYYMM', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '手卫生用品', width: 100, dataIndex: 'ProductDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '规格', width: 60, dataIndex: 'ProductSpec', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '消耗量', width: 60, dataIndex: 'Consumption', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var Cons = rd.get("Consumption") + rd.get("ProductUnit");
					return Cons;
				}
			}
			,{header: '报告状态', width: 80, dataIndex: 'RepStatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '填报日期', width: 80, dataIndex: 'RepDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '填报时间', width: 60, dataIndex: 'RepTime', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 200, dataIndex: 'RepResume', sortable: false, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 100,
			store : obj.gridHandHyProductsStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			{
				region: 'east'
				,width: 300
				,layout : 'form'
				,frame : true
				,labelAlign : 'right'
				,labelWidth : 70
				,items : [
					obj.cboExamLoc
					,obj.txtExamYYMM
					,obj.cboProduct
					,{
						layout : 'column',
						items : [
							{
								columnWidth : 1
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.txtConsumption]
							},{
								width : 50
								,layout : 'form'
								,items: [obj.txtProUnit]
							}
						]
					}
					,obj.txtResume
					,{
						height : 5
					},{
						layout : 'column',
						items : [
							{
								columnWidth : .50
							},{
								width : 70
								,layout : 'form'
								,items: [obj.btnQuery]
							},{
								width : 70
								,layout : 'form'
								,items: [obj.btnUpdate]
							},{
								width : 70
								,layout : 'form'
								,items: [obj.btnDelete]
							},{
								columnWidth : .50
							}
						]
					}
				]
			},{
				region: 'center'
				,layout : 'fit'
				,frame : true
				,items : [
					obj.gridHandHyProducts
				]
			}
		]
	});
	
	obj.gridHandHyProductsStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.HandHyProducts';
		param.QueryName = 'QryHandHyProducts';
		param.Arg1 = Common_GetValue('txtExamYYMM');
		param.Arg2 = Common_GetValue('txtExamYYMM');
		param.Arg3 = Common_GetValue('cboExamLoc');
		param.Arg4 = '0|1|2|3|4';
		param.ArgCnt = 4;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

