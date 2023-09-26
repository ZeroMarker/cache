
function InitViewport1(){
	var obj = new Object();
	objScreen = obj;
	obj.ICDID="";
	obj.RecRowID = "";
	obj.RecSubRowID = "";
	obj.txtCode     = Common_TextField("txtCode","<font color='red'>*</font>代码");
	obj.txtDesc     = Common_TextField("txtDesc","<font color='red'>*</font>名称");
	obj.txtICD10    = Common_TextField("txtICD10","ICD10");
	obj.txtICD9     = Common_TextField("txtICD9","ICD9");
	obj.txtIDMCode  = Common_TextField("txtIDMCode","肿瘤码");
	obj.ChkIsActive = Common_Checkbox("ChkIsActive","是否有效");
	obj.txtResume   = Common_TextField("txtResume","备注");
	
	//add by niepeng 20141217    
	//obj.txtCode.setDisabled(true);	//update by liuyh 2015-1-21
	//obj.txtDesc.setDisabled(true);
	//obj.txtICD10.setDisabled(true);
	//obj.txtICD9.setDisabled(true);
	//obj.txtIDMCode.setDisabled(true);
	//obj.ChkIsActive.setDisabled(true);
	//obj.txtResume.setDisabled(true);
	
	//窗口组件
	obj.RowEditerIAAlias   =  Common_TextField("RowEditerIAAlias","<b style='color:red'>*</b>别名");
	
	//别名
	obj.gridICDAliasStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	//别名Store
	obj.gridICDAliasStore = new Ext.data.Store({
		proxy: obj.gridICDAliasStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'SubID'
		},
		[
			{name: 'SubID', mapping : 'SubID'}
			,{name: 'ICDAlias', mapping : 'ICDAlias'}
		])
	});
	
	//别名Panel
	obj.gridICDAlias = new Ext.grid.EditorGridPanel({
		id : 'gridICDAlias'
		,store : obj.gridICDAliasStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '别名', width: 150, dataIndex: 'ICDAlias', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
    
	//诊断库
	obj.cboICDVersionStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboICDVersionStore = new Ext.data.Store({
		proxy: obj.cboICDVersionStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			,idProperty: 'ICDID'
		}, 
		[
			{name: 'ICDID', mapping : 'Id'}
			,{name: 'ICDCode', mapping : 'Code'}
			,{name: 'ICDDesc', mapping: 'Desc'}
		])
	});
	obj.cboICDVersion = new Ext.form.ComboBox({
		id : 'cboICDVersion'
		,fieldLabel : '诊断库'
		,labelSeparator :''
		,width : 100
		,store : obj.cboICDVersionStore
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,triggerAction : 'all'
		,minListWidth:100
		,valueField : 'ICDID'
		,displayField : 'ICDDesc'
		,loadingText: '加载中,请稍候...'
		,width : 10
		,anchor : '100%'
		
	});
	
	obj.gridICDLibraryStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridICDLibraryStore = new Ext.data.Store({
		proxy: obj.gridICDLibraryStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[
			{name: 'ID', mapping : 'ID'}
			,{name: 'ICDCode', mapping : 'ICDCode'}
			,{name: 'ICDDesc', mapping: 'ICDDesc'}
			,{name: 'ICDVID', mapping: 'ICDVID'}
			,{name: 'ICDVCode', mapping: 'ICDVCode'}
			,{name: 'ICDVDesc', mapping: 'ICDVDesc'}
			,{name: 'IDICD10', mapping: 'IDICD10'}
			,{name: 'IDICD9', mapping: 'IDICD9'}
			,{name: 'ICDMCode', mapping: 'ICDMCode'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'Resume', mapping: 'Resume'}
			,{name: 'Alias', mapping: 'Alias'}
		])
	});
	obj.gridICDLibrary = new Ext.grid.EditorGridPanel({
		id : 'gridICDLibrary'
		,store : obj.gridICDLibraryStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 80, dataIndex: 'ICDCode', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '名称', width: 200, dataIndex: 'ICDDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '诊断库编码', width: 150, dataIndex: 'ICDVDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: 'ICD10', width: 150, dataIndex: 'IDICD10', sortable: true, menuDisabled:true, align: 'center'}
			,{header: 'ICD9', width: 150, dataIndex: 'IDICD9', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '肿瘤码', width: 150, dataIndex: 'ICDMCode', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '别名', width: 200, dataIndex: 'Alias', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var ICDID = rd.get("ID");
					var ICDDesc = rd.get("ICDDesc");
					var Alias = rd.get("Alias");
					if (Alias != ''){
						var strRet = "<A id='lnkICDAlias' HREF='#' onClick='objScreen.ICDAliasHeader(\""+ ICDID +"\",\"" + ICDDesc + "\")'><div align='center'>" + Alias + "</div></A>";
					} else {
						var strRet = "<A id='lnkICDAlias' HREF='#' onClick='objScreen.ICDAliasHeader(\""+ ICDID +"\",\"" + ICDDesc + "\")'><div align='center'>别名维护</div></A>";
					}
					return strRet;
				}
			}
			,{header: '是否有效', width:80, dataIndex: 'IsActive', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 200, dataIndex: 'Resume', sortable: true, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridICDLibraryStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });
	
	obj.txtAlias = new Ext.form.TextField({
		id : 'txtAlias'
		,fieldLabel : '关键字'
		,labelSeparator :''
		,width : 150
	});
	obj.btnLIBDS = new Ext.Button({
		id : 'btnLIBDS'
		,iconCls : 'icon-update'
		,text : '诊断库同步'
		,width : 80
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,text : '查询'
		,width : 80
	});
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width: 80
		,text : '更新'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
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
						height: 70,
						layout : 'form',
						frame : true,
						labelWidth : 70,
						items : [
							{
								layout : 'column',
								items : [
									{
										width:180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtCode]
									},{
										width:360
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtDesc]
									},{
										width:120
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.ChkIsActive]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										width:180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtICD10]
									},{
										width:180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtICD9]
									},{
										width:180
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtIDMCode]
									},{
										width:250
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtResume]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						frame : true,
						items : [
							obj.gridICDLibrary
						]
					},{
						region: 'north',
						layout : 'fit',
						height : 40,
						frame : true,
						items : [
						{
							layout : 'column',
								items : [
									{
										width:200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.cboICDVersion]
									},{
										width:220
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtAlias]
									},{
										width:100
									},{
										width:100
										,layout : 'form'
										,items: [obj.btnLIBDS]
									}
								]
							}
						]
					}
				],
				bbar : [obj.btnUpdate,obj.btnDelete]   //removed by niepeng 20141217
			}
		]
	});
	
	obj.gridICDLibraryStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.FPService.ICDDxSrv"
		param.QueryName = "QryICDLibrary"
		param.Arg1 = Common_GetValue('cboICDVersion');
		param.Arg2 = Common_GetValue('txtAlias');
		param.Arg3 = obj.ICDID;
		param.ArgCnt = 3
	});
	
	obj.gridICDAliasStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.FPService.ICDDxSrv';
		param.QueryName = 'QryICDAlias';
		param.Arg1 = Ext.getCmp("gridICDLibrary").getSelectionModel().getSelections()[0].get("ID")
		param.ArgCnt = 1;
	});
	
	obj.cboICDVersionStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.FP.ICDVersion"
		param.QueryName = "QryICDVersion"
		param.ArgCnt = 0
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

