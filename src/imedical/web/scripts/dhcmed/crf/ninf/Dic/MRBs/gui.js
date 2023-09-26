
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.txtCode = Common_TextField("txtCode","代码");
	obj.txtDesc = Common_TextField("txtDesc","名称");
	obj.txtResume = Common_TextField("txtResume","说明");
	obj.chkIsActive = Common_Checkbox("chkIsActive","是否有效");
	obj.cboPYCate = Common_ComboToCate("cboPYCate","病原体分类",'MDRPY','');
	obj.cboPYDic = Common_ComboToCateItem("cboPYDic","病原体",'','cboPYCate');
	
	obj.chkANTCate = Common_Checkbox("chkANTCate","启用");
	obj.cboANTCate = Common_ComboToCate("cboANTCate","抗生素分类",'MDRANT','');
	obj.numANTCate = Common_NumberField("numANTCate","耐药数",0,0);
	
	obj.chkANTDic = Common_Checkbox("chkANTDic","启用");
	obj.cboANTDic = Common_ComboToCateItem("cboANTDic","抗生素",'','cboANTCate');
	obj.numANTDic = Common_NumberField("numANTDic","耐药数",0,0);
	
	obj.gridMRBsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridMRBsStore = new Ext.data.Store({
		proxy: obj.gridMRBsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[
			{name: 'ID', mapping : 'ID'}
			,{name: 'Code', mapping : 'Code'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'Active', mapping: 'Active'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.gridMRBs = new Ext.grid.EditorGridPanel({
		id : 'gridMRBs'
		,store : obj.gridMRBsStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,frame : true
		,columns: [
			{header: '代码', width: 40, dataIndex: 'Code', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '名称', width: 120, dataIndex: 'Description', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '是否<br>有效', width: 30, dataIndex: 'Active', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("Active");
					if (IsChecked == '1') {
						return "是";
					} else {
						return "否";
					}
				}
			}
			,{header: '说明', width: 120, dataIndex: 'Resume', sortable: false, menuDisabled:true, align: 'left'}
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
	
	obj.dsANTCate = new Ext.data.ArrayStore({
		data: [],
		fields: ['ID','Description'],
		sortInfo: {
			field: 'ID',
			direction: 'ASC'
		}
	});	
	
	obj.dsANTDic = new Ext.data.ArrayStore({
		data: [],
		fields: ['ID','Description'],
		sortInfo: {
			field: 'ID',
			direction: 'ASC'
		}
	});
	
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
				{
					region: 'south',
					id:'formEdit',
					xtype:'form',
					height: 320,
					layout : 'form',
					frame : true,
					buttonAlign : 'center',
					items : [
						{
							layout : 'column',
							labelWidth : 80,
							items : [
								{
									columnWidth:.50
								},{
									width:400
									,layout : 'form'
									,labelAlign : 'right'
									,items: [obj.txtCode]
								},{
									width:400
									,layout : 'form'
									,labelAlign : 'right'
									,items: [obj.chkIsActive]
								},{
									columnWidth:.50
								}
							]
						},{
							layout : 'column',
							labelWidth : 80,
							items : [
								{
									columnWidth:.50
								},{
									width:400
									,layout : 'form'
									,labelAlign : 'right'
									,items: [obj.txtDesc]
								},{
									width:400
									,layout : 'form'
									,labelAlign : 'right'
									,items: [obj.txtResume]
								},{
									columnWidth:.50
								}
							]
						},{
							layout : 'column',
							labelWidth : 80,
							items : [
								{
									columnWidth:.50
								},{
									width:400
									,layout : 'form'
									,labelAlign : 'right'
									,items: [obj.cboPYCate]
								},{
									width:400
									,layout : 'form'
									,labelAlign : 'right'
									,items: [obj.cboPYDic]
								},{
									columnWidth:.50
								}
							]
						},{
							layout : 'column',
							items : [
								{
									columnWidth:.50
								},{
									width:400
						            ,layout : 'form'
									//,frame : true
									,labelWidth : 80
									,labelAlign : 'right'
						            ,items :[
										{
											layout : 'form',
											height : 30,
											html : '<table border="0" width="100%" height="100%"><tr><td align="center" ><b>维护抗生素分类</b></td></tr></table>'
										},{
											layout : 'column',
											items : [
												{
													width:120
													,layout : 'form'
													,labelWidth : 80
													,labelAlign : 'right'
													,items: [obj.chkANTCate]
												},{
													width:140
													,layout : 'form'
													,labelWidth : 80
													,labelAlign : 'right'
													,items: [obj.numANTCate]
												}
											]
										}
										,obj.cboANTCate
										,{
											id: 'multiANTCate'
											,xtype: 'multiselect'
											,fieldLabel: '值列表'
											,allowBlank: false
											,store: obj.dsANTCate
											,autoHeight:true
											,autoWidth:true
											,width : 310
											,displayField: 'Description'
											,valueField: 'ID'
										}
									]
            					},{
									width:400
						            ,layout : 'form'
									//,frame : true
									,labelWidth : 80
									,labelAlign : 'right'
						            ,items :[
										{
											layout : 'form',
											height : 30,
											html : '<table border="0" width="100%" height="100%"><tr><td align="center" ><b>维护抗生素</b></td></tr></table>'
										},{
											layout : 'column',
											items : [
												{
													width:120
													,layout : 'form'
													,labelWidth : 80
													,labelAlign : 'right'
													,items: [obj.chkANTDic]
												},{
													width:140
													,layout : 'form'
													,labelWidth : 80
													,labelAlign : 'right'
													,items: [obj.numANTDic]
												}
											]
										}
										,obj.cboANTDic
										,{
											id: 'multiANTDic'
											,xtype: 'multiselect'
											,fieldLabel: '值列表'
											,allowBlank: false
											,store: obj.dsANTDic
											,autoHeight:true
											,autoWidth:true
											,width : 310
											,displayField: 'Description'
											,valueField: 'ID'
										}
									]
            					},{
									columnWidth:.50
								}
							]
						}
					]
					,buttons : [obj.btnUpdate]
				},
				obj.gridMRBs
			]
		
	});
	
	obj.gridMRBsStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINF.Dic.MRB';
		param.QueryName = 'QueryAll';
		param.ArgCnt = 0;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

