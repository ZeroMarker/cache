function InitwinProblem(ReportIDList, Delimiter){
	var obj = new Object();
	
	obj.RecRowID = '';
	obj.MappingTypeCode = '';
	obj.MapDicGroupCode =  '';
	obj.MapDicTypeCode =  '';
	
	obj.txtSrcValue = new Ext.form.TextField({
		//id : 'txtSrcValue'
		fieldLabel : "源值"
		,width : 10
		,anchor : '100%'
	});
	obj.txtSrcDesc = new Ext.form.TextField({
		//id : 'txtSrcDesc'
		fieldLabel : "描述"
		,width : 10
		,anchor : '100%'
	});
	obj.txtTargetValue = new Ext.form.TextField({
		//id : 'txtTargetValue'
		fieldLabel : "目标值"
		,width : 10
		,anchor : '100%'
	});
	obj.txtResume = new Ext.form.TextField({
		//id : 'txtResume'
		fieldLabel : "说明"
		,width : 10
		,anchor : '100%'
	});
	
	obj.cboTargetDescStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboTargetDescStore = new Ext.data.Store({
		proxy: obj.cboTargetDescStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicID'
		},
		[
			{name: 'DicID', mapping : 'DicID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
			,{name: 'DicSpell', mapping: 'DicSpell'}
		])
	});
	obj.cboTargetDesc = new Ext.form.ComboBox({
		//id : 'cboTargetDesc'
		fieldLabel : '描述'
		,width : 100
		,store : obj.cboTargetDescStore
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>代码</th>',
					'<th>名称</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{DicCode}</td>',
					'<td>{DicDesc}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:300
		,valueField : 'DicCode'
		,displayField : 'DicDesc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((!field.getValue())||(field.getRawValue()!=field.lastSelectionText)) {
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(){
								field.setValue('');
							}
						});
					}
				}
			}
		}
	});
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width : 80
		,text : '保存'
	});
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-update'
		,width : 80
		,text : '确认'
	});
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		//,tooltip : '取消当前此次【导出接口】操作!'
		,iconCls : 'icon-cancel'
		,width : 80
		,text : '取消'
	});
	obj.btnSkip = new Ext.Button({
		id : 'btnSkip'
		//,tooltip : '跳过当前步骤,会导致部分数据导入不到民科系统,还需要到民科系统补录数据!'
		,iconCls : 'icon-delete'
		,width : 80
		,text : '跳过'
	});
	
	obj.gridProblemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridProblemStore = new Ext.data.GroupingStore({
		proxy: obj.gridProblemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Index'
		}, 
		[
			{name: 'Index', mapping : 'Index'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'SrcValue', mapping: 'SrcValue'}
			,{name: 'SrcDesc', mapping: 'SrcDesc'}
			,{name: 'TargetValue', mapping: 'TargetValue'}
			,{name: 'TargetDesc', mapping: 'TargetDesc'}
			,{name: 'ResumeText', mapping: 'ResumeText'}
			,{name: 'MappingTypeCode', mapping: 'MappingTypeCode'}
			,{name: 'MappingTypeDesc', mapping: 'MappingTypeDesc'}
			,{name: 'MapDicGroupCode', mapping : 'MapDicGroupCode'}
			,{name: 'MapDicTypeCode', mapping : 'MapDicTypeCode'}
		])
		,sortInfo:{field:'Index',direction:'ASC'}
		,groupField:'MappingTypeDesc'
	});
	obj.gridProblem = new Ext.grid.GridPanel({
		id : 'gridProblem'
		,store : obj.gridProblemStore
		,buttonAlign : 'center'
		,columnLines : true
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '源值', width: 100, dataIndex: 'SrcValue', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '源值描述', width: 100, dataIndex: 'SrcDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '目标值', width: 100, dataIndex: 'TargetValue', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '目标值描述', width: 100, dataIndex: 'TargetDesc', sortable: true, menuDisabled:true, align: 'center'}
			//,{header: '说明', width: 150, dataIndex: 'ResumeText', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '对照类别', width: 100, dataIndex: 'MappingTypeDesc', sortable: true, hidden:true}
		]
		,view : new Ext.grid.GroupingView({
			forceFit:true,
			groupTextTpl:'{[values.rs[0].get("MappingTypeDesc")]}(共{[values.rs.length]}条记录)',
			groupByText:'对照字典类别'
		})
	});
	
	obj.winProblem = new Ext.Window({
		//id : 'winProblem'
		height : 500
		,width : 800
		,resizable : false
		,closeAction: 'close'
		,closable : false
		,modal : true
		,title : '医院感染--导出接口字典对照'
		,layout : 'border'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
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
										columnWidth:.25
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtSrcValue]
									},{
										columnWidth:.25
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtSrcDesc]
									},{
										columnWidth:.25
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtTargetValue]
									},{
										columnWidth:.25
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.cboTargetDesc]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridProblem
						]
					}
				]
			}
		],
		bbar : [obj.btnUpdate,'->',obj.btnSave,obj.btnSkip,obj.btnCancel]
	});
	obj.gridProblemStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCHAI.MK.ExportToMKSrv';
			param.QueryName = 'QryValidateInfo';
			param.Arg1 = ReportIDList;
			param.Arg2 = Delimiter;
			param.ArgCnt = 2;
	});
	obj.cboTargetDescStoreProxy.on('beforeload', function(objProxy, param){
		if (obj.MapDicGroupCode=='MKDIC') {
			//调用民科字典
			param.ClassName = 'DHCHAI.MK.BTDictionary';
			param.QueryName = 'QryMKDicByType';
			param.Arg1 = obj.MapDicTypeCode;
			param.Arg2 = obj.cboTargetDesc.getRawValue();
			param.ArgCnt = 2;
		} else {
			//调用院感相关字典
			param.ClassName = 'DHCHAI.MK.BTMappingSrv';
			param.QueryName = 'QryInfDicByType';
			param.Arg1 = obj.MapDicGroupCode;
			param.Arg2 = obj.MapDicTypeCode;
			param.Arg3 = obj.cboTargetDesc.getRawValue();
			param.ArgCnt = 3;
		}
	});
	
	InitwinProblemEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

