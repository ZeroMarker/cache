
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
	obj.comboCate = new Common_ComboCustom({
		 id: "comboCate",                //控件id
		 label: "分类",                  //标签
		 idProperty: "ID" ,              //id域
		 displayField : 'Description',   //显示域
		 valueField : 'Code',            //值域
		 editable : true                 //是否允许编辑
		},
		function(objProxy, param){
			param.ClassName="DHCMed.NINF.Dic.Cate";
			param.QueryName="QueryByType";
			param.Arg1="";
			param.Arg2="INFANT";
			param.Arg3=1;
			param.ArgCnt=3;
		}
	);
	
	obj.comboSubCate = new Common_ComboCustom({
		 id: "comboSubCate",             //控件id
		 label: "子分类",                //标签
		 idProperty: "ID" ,              //id域
		 displayField : 'Description',   //显示域
		 valueField : 'Code',            //值域
		 editable : true                 //是否允许编辑
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
	obj.gridAntibioticsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridAntibioticsStore = new Ext.data.Store({
		proxy: obj.gridAntibioticsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'AntiID'
		},
		[
			{name: 'AntiID', mapping : 'AntiID'}
			,{name: 'AntiCode', mapping : 'AntiCode'}
			,{name: 'AntiDesc', mapping: 'AntiDesc'}
			,{name: 'AntiPinyin', mapping: 'AntiPinyin'}
			,{name: 'AntiDesc1', mapping: 'AntiDesc1'}
			,{name: 'AntiActive', mapping: 'AntiActive'}
			,{name: 'AntiActiveDesc', mapping: 'AntiActiveDesc'}
			,{name: 'AntiResume', mapping: 'AntiResume'}
			,{name: 'AntiWhonet', mapping: 'AntiWhonet'}
			,{name: 'ANTCateCode', mapping: 'ANTCateCode'}
			,{name: 'ANTCateDesc', mapping: 'ANTCateDesc'}
			,{name: 'ANTSubCateCode', mapping: 'ANTSubCateCode'}
			,{name: 'ANTSubCateDesc', mapping: 'ANTSubCateDesc'}
		])
	});
	obj.gridAntibiotics = new Ext.grid.EditorGridPanel({
		id : 'gridAntibiotics'
		,store : obj.gridAntibioticsStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '代码', width: 60, dataIndex: 'AntiCode', sortable: false, menuDisabled:true, align: 'center'}
			,{header: 'whonet码', width: 70, dataIndex: 'AntiWhonet', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '名称', width: 200, dataIndex: 'AntiDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '拼音码', width:100, dataIndex: 'AntiPinyin', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '英文名称', width: 200, dataIndex: 'AntiDesc1', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '分类', width:100, dataIndex: 'ANTCateDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '子类', width: 200, dataIndex: 'ANTSubCateDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '是否有效', width: 60, dataIndex: 'AntiActiveDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 200, dataIndex: 'AntiResume', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridAntibioticsStore,
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
										columnWidth:.25
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtCode]
									},{
										columnWidth:.25
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtWhonet]
									},{
										columnWidth:.3
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.txtPinyin]
									},{
										columnWidth:.2
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
										columnWidth:.5
										,layout : 'form'
										,labelAlign : 'right'
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
							},{
								layout : 'column',
								items : [
									{
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
							obj.gridAntibiotics
						]
					}
				],
				bbar : [obj.btnFind,obj.btnUpdate,obj.btnDelete,'->','…']
			}
		]
	});
	
	obj.gridAntibioticsStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Dic.Antibiotics';
		param.QueryName = 'QryAntibiotics';
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

