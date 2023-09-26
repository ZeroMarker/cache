
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.txtCode = Common_TextField("txtCode","代码");
	obj.txtDesc = Common_TextField("txtDesc","名称");
	obj.txtICD10 = Common_TextField("txtICD10","ICD10");
	obj.txtAlias = Common_TextField("txtAlias","别名");
	obj.chkIsActive = Common_Checkbox("chkIsActive","是否有效");
	obj.txtResume = Common_TextField("txtResume","备注");
	obj.chkIsViewAll = Common_Checkbox("chkIsViewAll","显示全部");
	
	obj.gridInfDiagnoseStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridInfDiagnoseStore = new Ext.data.Store({
		proxy: obj.gridInfDiagnoseStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		},
		[
			{name: 'RowID', mapping : 'RowID'}
			,{name: 'IDCode', mapping : 'IDCode'}
			,{name: 'IDDesc', mapping: 'IDDesc'}
			,{name: 'IDICD10', mapping: 'IDICD10'}
			,{name: 'IDActive', mapping: 'IDActive'}
			,{name: 'IDActiveDesc', mapping: 'IDActiveDesc'}
			,{name: 'IDAlias', mapping: 'IDAlias'}
			,{name: 'IDResume', mapping: 'IDResume'}
		])
	});
	obj.gridInfDiagnose = new Ext.grid.EditorGridPanel({
		id : 'gridInfDiagnose'
		,store : obj.gridInfDiagnoseStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '代码', width: 80, dataIndex: 'IDCode', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '名称', width: 150, dataIndex: 'IDDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: 'ICD10', width: 80, dataIndex: 'IDICD10', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '别名', width: 150, dataIndex: 'IDAlias', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '是否<br>有效', width: 50, dataIndex: 'IDActiveDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '诊断标准', width: 80, sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var strRet = "<A id='lnkDiagnosGistDtl' HREF='#' onClick='DiagnosGistDtlHeader()'><div align='center'>诊断标准</div></A>";
					return strRet;
				}
			}
			,{header: '备注', width: 200, dataIndex: 'IDResume', sortable: false, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-edit'
		,width: 80
		,text : '更新'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-Delete'
		,width: 80
		,text : '删除'
	});
	
	obj.gridInfDiagnosCategStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridInfDiagnosCategStore = new Ext.data.Store({
		proxy: obj.gridInfDiagnosCategStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IDCRowID'
		}, 
		[
			{name: 'IsChecked', mapping: 'IsChecked'}
			,{name: 'MapID', mapping: 'MapID'}
			,{name: 'IDRowID', mapping: 'IDRowID'}
			,{name: 'IDCode', mapping: 'IDCode'}
			,{name: 'IDDesc', mapping: 'IDDesc'}
			,{name: 'IDCRowID', mapping: 'IDCRowID'}
			,{name: 'IDCCode', mapping: 'IDCCode'}
			,{name: 'IDCDesc', mapping: 'IDCDesc'}
		])
	});
	obj.gridInfDiagnosCateg = new Ext.grid.EditorGridPanel({
		id : 'gridInfDiagnosCateg'
		,store : obj.gridInfDiagnosCategStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '选择', width: 30, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcmed/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcmed/img/unchecked.gif'>";
					}
				}
			}
			,{header: '感染诊断子分类', width: 150, dataIndex: 'IDCDesc', sortable: false, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'south',
						height: 70,
						layout : 'form',
						//frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 120
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtCode]
									},{
										width : 120
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtICD10]
									},{
										columnWidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										//,boxMinWidth : 150
										//,boxMaxWidth : 200
										,items: [obj.txtDesc]
									},{
										width : 110
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.chkIsActive]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width : 240
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtAlias]
									},{
										columnWidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtResume]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridInfDiagnose
						]
					}
				],
				bbar : [obj.btnUpdate,obj.btnDelete,'->','…']
			},{
				region: 'east',
				width : 300,
				layout : 'border',
				//frame : true,
				items : [
					{
						region: 'south',
						height: 35,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 120
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.chkIsViewAll]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						frame : true,
						items : [
							obj.gridInfDiagnosCateg
						]
					}
				],
				bbar : ['关联感染诊断子分类','->','…']
			}
		]
	});
	
	obj.gridInfDiagnoseStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.InfDiagnose';
		param.QueryName = 'QryInfDiagnose';
		param.ArgCnt = 0;
	});
	
	obj.gridInfDiagnosCategStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.MapDiagCat';
		param.QueryName = 'QryInfDiagCat';
		
		var InfDiagnos = "";
		var objRec = obj.gridInfDiagnose.getSelectionModel().getSelected();
		if (objRec) {
			InfDiagnos = objRec.get("RowID");
		}
		
		param.Arg1 = InfDiagnos;
		param.Arg2 = (obj.chkIsViewAll.getValue()==true ? "Y" : "N");
		param.ArgCnt = 2;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

