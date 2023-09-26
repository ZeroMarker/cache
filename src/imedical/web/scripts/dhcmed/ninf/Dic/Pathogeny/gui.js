
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.txtCode = Common_TextField("txtCode","代码");
	obj.txtWhonet = Common_TextField("txtWhonet","whonet码");
	obj.txtDesc = Common_TextField("txtDesc","名称");
	obj.txtPinyin = Common_TextField("txtPinyin","拼音码");   //update by zhangxing 20121018
	obj.txtDesc1 = Common_TextField("txtDesc1","英文名称");
	obj.chkIsActive = Common_Checkbox("chkIsActive","是否有效");
	obj.txtResume = Common_TextField("txtResume","备注");
	obj.chkIsMultires = Common_Checkbox("chkIsMultires","是否多重耐药");
	obj.cboMultiresGroup = Common_ComboToDic("cboMultiresGroup","多重耐药分类","NINFMultiresGroup");
	
	obj.comboCate = new Common_ComboCustom({
		 id: "comboCate",                //控件id
		 label: "分类",                  //标签
		 idProperty: "ID" ,              //id域
		 displayField : 'Description',   //显示域
	         valueField : 'Code',        //值域
			 editable : true             //是否允许编辑
		},
		function(objProxy, param){
			param.ClassName="DHCMed.NINF.Dic.Cate";
			param.QueryName="QueryByType";
			param.Arg1="";
			param.Arg2="INFPY";
			param.Arg3=1;
			param.ArgCnt=3;
		}
	);
	
	obj.comboSubCate = new Common_ComboCustom({
		 id: "comboSubCate",             //控件id
		 label: "子分类",                //标签
		 idProperty: "ID" ,              //id域
		 displayField : 'Description',   //显示域
	         valueField : 'Code',        //值域
			 editable : true             //是否允许编辑
		},
		function(objProxy, param){
			param.ClassName="DHCMed.NINF.Dic.Cate";
			param.QueryName="QueryByType";
			param.Arg1="";
			param.Arg2=obj.comboCate.getValue();
			param.Arg3=1;
			param.ArgCnt=3;
		}
	);
	
	obj.gridPathogenyStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridPathogenyStore = new Ext.data.Store({
		proxy: obj.gridPathogenyStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PyID'
		},
		[
			{name: 'PyID', mapping : 'PyID'}
			,{name: 'PyCode', mapping : 'PyCode'}
			,{name: 'PyDesc', mapping: 'PyDesc'}
			,{name: 'PyDesc1', mapping: 'PyDesc1'}
			,{name: 'PyActive', mapping: 'PyActive'}
			,{name: 'PyActiveDesc', mapping: 'PyActiveDesc'}
			,{name: 'PyResume', mapping: 'PyResume'}
			,{name: 'PYIsMultires', mapping: 'PYIsMultires'}
			,{name: 'PYIsMultiresDesc', mapping: 'PYIsMultiresDesc'}
			,{name: 'MultiresGroupID', mapping: 'MultiresGroupID'}
			,{name: 'MultiresGroupDesc', mapping: 'MultiresGroupDesc'}
			,{name: 'PyWhonet', mapping: 'PyWhonet'}
			,{name: 'PyPinyin', mapping: 'PyPinyin'}
			,{name: 'PYCateCode', mapping: 'PYCateCode'}
			,{name: 'PYCateDesc', mapping: 'PYCateDesc'}
			,{name: 'PYSubCateCode', mapping: 'PYSubCateCode'}
			,{name: 'PYSubCateDesc', mapping: 'PYSubCateDesc'}
		])
	});
	obj.gridPathogeny = new Ext.grid.EditorGridPanel({
		id : 'gridPathogeny'
		,store : obj.gridPathogenyStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '代码', width: 60, dataIndex: 'PyCode', sortable: false, menuDisabled:true, align: 'center'}
			,{header: 'whonet码', width: 70, dataIndex: 'PyWhonet', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '名称', width: 200, dataIndex: 'PyDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '拼音码', width: 100, dataIndex: 'PyPinyin', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '英文名称', width: 200, dataIndex: 'PyDesc1', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '分类', width:120, dataIndex: 'PYCateDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '子类', width: 120, dataIndex: 'PYSubCateDesc', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '是否多<br>重耐药', width: 60, dataIndex: 'PYIsMultiresDesc', sortable: false, menuDisabled:true, align: 'center'}
			//,{header: '多重耐药分类', width: 200, dataIndex: 'MultiresGroupDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '是否<br>有效', width: 40, dataIndex: 'PyActiveDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 200, dataIndex: 'PyResume', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridPathogenyStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });
    
    obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-find'
		,width: 80
		,text : '查询'
	});
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width: 80
		,text : '更新'
	});
	
	obj.btnDelete = new Ext.Button({
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
						height: 135,
						layout : 'form',
						frame : true,
						labelWidth : 70,
						items : [
							{
								layout : 'column',
								items : [
									{
										columnWidth : .25
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtCode]
									},{
										columnWidth : .25
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtWhonet]
									},{
										columnWidth: .3
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtPinyin]
									},{
										columnWidth : .2
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.chkIsActive]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.5
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtDesc]
									},{
										columnWidth : .5
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,labelWidth : 70
										,items: [obj.txtDesc1]
									}
								]
							},{
								layout : 'column',
								items : [
									{
										columnWidth:.5
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.comboCate]
									},{
										columnWidth:.5
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.comboSubCate]
									}
								]
							}/*,{
								layout : 'column',
								items : [
									{
										columnWidth:.5
										,layout : 'form'
										,labelAlign : 'right'
										//,labelWidth : 40
										,items: [obj.chkIsMultires]
									},{
										columnWidth:.5
										,layout : 'form'
										,labelAlign : 'right'
										//,labelWidth : 40
										,items: [obj.cboMultiresGroup]
									}
								]
							}*/,{
								layout : 'column',
								items : [{
										columnWidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtResume]
									}]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridPathogeny
						]
					}
				],
				bbar : [obj.btnFind,obj.btnUpdate,obj.btnDelete,'->','…']
			}
		]
	});
	
	obj.gridPathogenyStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.Pathogeny';
		param.QueryName = 'QryPathogeny';
		param.Arg1 = '';
		param.Arg2 = '';
		param.Arg3 = Common_GetValue("comboCate");
		param.Arg4 = Common_GetValue("comboSubCate");
		param.Arg5 = Common_GetValue("txtWhonet");
		param.Arg6 = Common_GetValue("txtDesc");
		param.ArgCnt = 6;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

