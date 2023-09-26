var objScreen = new Object();
function InitViewport1(){
	var obj = new Object();
	objScreen = obj;
	
	obj.RecRowID = "";
	obj.RecSubRowID = "";
	obj.txtCode = Common_TextField("txtCode","<b style='color:red'>*</b>代码");
	obj.txtDesc = Common_TextField("txtDesc","<b style='color:red'>*</b>名称");
	obj.txtContent = Common_TextField("txtContent","<b style='color:red'>*</b>检测对象");
	obj.cboCateg = Common_ComboToDic("cboCateg","<b style='color:red'>*</b>项目分类","NINFEnviHyItemCategory");
	obj.cboFreq = Common_ComboToDic("cboFreq","<b style='color:red'>*</b>频次","NINFEnviHyItemFrequency");
	obj.cboNormUom = Common_ComboToDic("cboNormUom","<b style='color:red'>*</b>单位","NINFEnviHyNormUom");
	obj.chkIsActive = Common_Checkbox("chkIsActive","是否有效");
	obj.txtResume = Common_TextField("txtResume","备注");
	//窗口组件
	obj.RowEditerTxtFormula =  Common_TextField("RowEditerTxtFormula","<b style='color:red'>*</b>计算公式");
	obj.RowEditerChkIsActive =  Common_Checkbox("RowEditerChkIsActive","是否有效");
	obj.RowEditerTxtResume =  Common_TextField("RowEditerTxtResume","备注");
	
	//项目代理
	obj.gridEnviHyItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	//公式代理
	obj.gridEnviHyItmForMulaStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	//公式Store
	obj.gridEnviHyItmForMulaStore = new Ext.data.Store({
		proxy: obj.gridEnviHyItmForMulaStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ForMulaID'
		},
		[
			{name: 'ForMulaID', mapping : 'ForMulaID'}
			,{name: 'ForMula', mapping : 'ForMula'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	//项目Store
	obj.gridEnviHyItemStore = new Ext.data.Store({
		proxy: obj.gridEnviHyItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ItemID'
		},
		[
			{name: 'ItemID', mapping : 'ItemID'}
			,{name: 'ItemCode', mapping : 'ItemCode'}
			,{name: 'ItemDesc', mapping: 'ItemDesc'}
			,{name: 'ItemContent', mapping: 'ItemContent'}
			,{name: 'ItemCategID', mapping: 'ItemCategID'}
			,{name: 'ItemCategDesc', mapping: 'ItemCategDesc'}
			,{name: 'ItemFreqID', mapping: 'ItemFreqID'}
			,{name: 'ItemFreqDesc', mapping: 'ItemFreqDesc'}
			,{name: 'ItemNormUomID', mapping: 'ItemNormUomID'}
			,{name: 'ItemNormUomDesc', mapping: 'ItemNormUomDesc'}
			,{name: 'ItemActive', mapping: 'ItemActive'}
			,{name: 'ItemActiveDesc', mapping: 'ItemActiveDesc'}
			,{name: 'ItemResume', mapping: 'ItemResume'}
			,{name: 'ItemFormula', mapping: 'ItemFormula'}
		])
	});
	//公式Panel
	obj.gridEnviHyItmForMula = new Ext.grid.EditorGridPanel({
		id : 'gridEnviHyItmForMula'
		,store : obj.gridEnviHyItmForMulaStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '计算公式', width: 200, dataIndex: 'ForMula', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '是否<br>有效', width: 40, dataIndex: 'IsActive', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 160, dataIndex: 'Resume', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	//项目Panel
	obj.gridEnviHyItem = new Ext.grid.EditorGridPanel({
		id : 'gridEnviHyItem'
		,store : obj.gridEnviHyItemStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '代码', width: 40, dataIndex: 'ItemCode', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '名称', width: 150, dataIndex: 'ItemDesc', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var ItemID = rd.get("ItemID");
					var ItemDesc = rd.get("ItemDesc");
					var strRet = "<A id='lnkItemNorms' HREF='#' onClick='objScreen.EditItemNormsHander(\""+ ItemID +"\",\"" + ItemDesc + "\")'><div align='center'>" + ItemDesc + "</div></A>";
					return strRet;
				}
			}
			,{header: '检测对象', width: 80, dataIndex: 'ItemContent', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '项目分类', width: 100, dataIndex: 'ItemCategDesc', sortable: false, align: 'center'}
			,{header: '频次', width: 60, dataIndex: 'ItemFreqDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '单位', width: 60, dataIndex: 'ItemNormUomDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '计算公式', width: 80, dataIndex: 'ItemFormula', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var ItemID = rd.get("ItemID");
					var ItemDesc = rd.get("ItemDesc");
					var ItemFormula = rd.get("ItemFormula");
					if (ItemFormula != ''){
						var strRet = "<A id='lnkItemFormula' HREF='#' onClick='objScreen.ItemFormulaHeader(\""+ ItemID +"\",\"" + ItemDesc + "\")'><div align='center'>" + ItemFormula + "</div></A>";
					} else {
						var strRet = "<A id='lnkItemFormula' HREF='#' onClick='objScreen.ItemFormulaHeader(\""+ ItemID +"\",\"" + ItemDesc + "\")'><div align='center'>计算公式</div></A>";
					}
					return strRet;
				}
			}
			,{header: '是否<br>有效', width: 40, dataIndex: 'ItemActiveDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 150, dataIndex: 'ItemResume', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridEnviHyItemStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });
	obj.btnQuery = new Ext.Toolbar.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width: 80
		,text : '查询'
	});
	obj.btnUpdate = new Ext.Toolbar.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-save'
		,width: 80
		,text : '保存'
	});
	
	obj.btnDelete = new Ext.Toolbar.Button({
		id : 'btnDelete'
		,iconCls : 'icon-Delete'
		,width: 80
		,text : '删除'
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'fit'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'south',
						height: 75,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 160
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtCode]
									},{
										width : 400
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtDesc]
									},{
										width : 300
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 80
										,items: [obj.cboCateg]
									},{
										width : 150
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 80
										,items: [obj.chkIsActive]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width : 160
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboFreq]
									},{
										width : 200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboNormUom]
									},{
										width :200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 80
										,items: [obj.txtContent]
									},{
										width : 400
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 80
										,items: [obj.txtResume]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						items : [
							obj.gridEnviHyItem
						]
					}
				],
				bbar : [obj.btnQuery,obj.btnUpdate,obj.btnDelete,'->','…']
			}
		]
	});
	
	obj.gridEnviHyItmForMulaStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.EnviHyItmForMula';
		param.QueryName = 'QryEnviHyItmForMula';
		param.Arg1 = obj.RecRowID;
		param.ArgCnt = 1;

	});
	
	obj.gridEnviHyItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.EnviHyItem';
		param.QueryName = 'QryEnviHyItem';
		param.Arg1 = Common_GetValue("txtCode");
		param.Arg2 = Common_GetValue("txtDesc");
		param.Arg3 = Common_GetValue("txtContent");
		param.Arg4 = Common_GetValue("cboCateg");
		param.Arg5 = Common_GetValue("cboFreq");
		param.Arg6 = Common_GetValue("cboNormUom");
		param.Arg7 = "";  //(Common_GetValue("chkIsActive"));
		param.Arg8 = Common_GetValue("txtResume");
		param.Arg9 = Common_GetValue("txtFormula");
		param.ArgCnt = 9;

	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

