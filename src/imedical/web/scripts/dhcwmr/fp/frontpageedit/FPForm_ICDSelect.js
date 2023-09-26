//obj.cboICD = FP_ICDSelect("cboICD","诊断",1,类型);
function FP_ICDSelect(){
	var FPItemID = arguments[2];
	var LnkCmpName = (arguments[3] ? arguments[3] : '');
	var pageSize = (arguments[4] ? arguments[4] : 100);
	var anchor = (arguments[5] ? arguments[5] : '100%');
	
	var tmpCombo = new Ext.form.ComboBox({
		id : arguments[0]
		,fieldLabel : arguments[1]
		,store : new Ext.data.Store({
			proxy: new Ext.data.HttpProxy({
				url : ExtToolSetting.RunQueryPageURL
				,listeners : {
					'beforeload' : function(objProxy, param){
						param.ClassName = 'DHCWMR.FPService.ICDDxSrv';
						param.QueryName = 'QryICDByAlias';
						param.Arg1 = tmpCombo.getRawValue();
						param.Arg2 = FPItemID;
						param.Arg3 = Common_GetValue(LnkCmpName);
						param.Arg4 = pageSize;
						param.ArgCnt = 4;
					}
				}
			}),
			reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'ID'
			}, 
			[
				{name: 'ID', mapping: 'ID'}
				,{name: 'Code', mapping: 'Code'}
				,{name: 'Desc', mapping: 'Desc'}
				,{name: 'ICD10', mapping: 'ICD10'}
			])
		})
		,minChars : 100
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table style="border-bottom:1px #BDBDBD solid;">',
				'<thead align="center"><tr>',
					'<th align="center" width="5%">ID</th>',
					'<th align="center" width="65%">诊断</th>',
					'<th align="center" width="30%">ICD10</th>',
				'</tr></thead>',
				'<tbody>',
					'<tpl for=".">',
						'<tr class="x-combo-list-item">',
							'<td align="center">{[xindex]}</td>',
							'<td align="left">{Desc}</td>',
							'<td align="left">{ICD10}</td>',
						'</tr>',
					'</tpl>',
				'</tbody>',
			'</table>'
		)
		,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:400
		,valueField : 'ID'
		,displayField : 'Desc'
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : anchor
		,enableKeyEvents : true
		,listeners: {
			'keydown' : function(field, e){
				if ((e.getKey() == e.ENTER)||(e.getKey() == e.DOWN)){
					if (field.isExpanded() == false){
						//检查是否触发Tab键
						if (e.getKey() == e.ENTER){
							if (field.id == 'FPD_RowEditor_ICD'){  //诊断
								if ((objScreen.FPD_RowEditor.ICDId != '')
								&&(objScreen.FPD_RowEditor.ICDTxt == field.getRawValue()))
								{
									event.keyCode=9;  //触发Tab键
									return;
								}
							} else if (field.id == 'FPO_RowEditor_ICD'){  //手术
								if ((objScreen.FPO_RowEditor.ICDId != '')
								&&(objScreen.FPO_RowEditor.ICDTxt == field.getRawValue()))
								{
									event.keyCode=9;  //触发Tab键
									return;
								}
							} else {
								event.keyCode=9;  //触发Tab键
								return;
							}
						}
						//加载Store数据
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success) {
								if (success){
									//field.setValue('');
								}
							}
						});
					} else {
						//if (e.getKey() == e.ENTER){
						//	event.keyCode=9;  //触发Tab键
						//}
					}
				} else if (e.getKey() == e.UP){
					//向上箭头
				} else {
					field.getStore().removeAll();
					field.collapse();
				}
			}
			,'render' : function(field){
				field.getEl().on('dblclick', function(field){
					var field = tmpCombo;
					if (field.isExpanded() == false){
						field.getStore().removeAll();
						field.getStore().load({
							callback : function(records, options, success) {
								if (success){
									field.setValue('');
								}
							}
						});
					}
				});
			}
			,'blur' : function(){
				if (this.getValue() == ''){
					this.setRawValue('');
				} else if (this.getRawValue() == ''){
					this.setValue('');
				}
			}
		}
	});
	//tmpCombo.getStore().load({});
	return tmpCombo;
}

function FP_FindICDWin(aAlias,aTypeID,aCmpName){
	var win = new Object();
	win.FPICD_txtAlias = new Ext.form.TextField({
		id : "FPICD_txtAlias"
		,fieldLabel : "ICD检索"
		,emptyText : 'ICD检索'
		,value : aAlias
		,width : 150
	});
	win.FPICD_btnSave = new Ext.Button({
		id : 'FPICD_btnSave'
		,iconCls : 'icon-update'
		,width: 60
		,text : '确定'
	});
	win.FPICD_btnCancel = new Ext.Button({
		id : 'FPICD_btnCancel'
		,iconCls : 'icon-exit'
		,width: 60
		,text : '关闭'
	});
	
	win.FPICD_FindICDListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	win.FPICD_FindICDListStore = new Ext.data.Store({
		proxy: win.FPICD_FindICDListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'ICD10', mapping: 'ICD10'}
		])
		//,sortInfo : {field : 'ICD10', direction : 'ASC'}
	});
	win.FPICD_FindICDList = new Ext.grid.GridPanel({
		id : 'FPICD_FindICDList'
		,store : win.FPICD_FindICDListStore
		,region : 'center'
		,stripeRows : true
		,loadMask : { msg : '正在查询,请稍后...'}
		,tbar : [
			'-','ICD检索：',win.FPICD_txtAlias,'-',win.FPICD_btnSave,'-',win.FPICD_btnCancel,'-'
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 60, dataIndex: 'Code', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '名称', width: 200, dataIndex: 'Desc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: 'ICD10', width: 60, dataIndex: 'ICD10', sortable: false, menuDisabled:true, align : 'center'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : win.FPICD_FindICDListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : true
		}
	});
	win.FPICD_FindICDListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.FPService.ICDDxSrv';
		param.QueryName = 'QryICDByAlias';
		param.Arg1 = win.FPICD_txtAlias.getValue();
		param.Arg2 = objScreen.FrontPage.FPItemID;
		param.Arg3 = aTypeID;
		param.Arg4 = 10000;
		param.ArgCnt = 4;
	});
	if (aAlias != '') win.FPICD_FindICDListStore.load({params:{start:0,limit:200}});
	
	win.FPICD_btnSave_click = function(){
		var records = win.FPICD_FindICDList.getSelectionModel().getSelections();
		if (records.length<1) {
			ExtTool.alert('提示', '请选择一条记录!');
			return;
		}
		var rd = records[0];
		if (rd){
			if (aCmpName == 'FPD_RowEditor_ICD'){
				Common_SetValue("FPD_RowEditor_ICD10",rd.get('ICD10'));
				Common_SetValue("FPD_RowEditor_ICD",rd.get('ID'),rd.get('Desc'));
				objScreen.FPD_RowEditor.ICDId = rd.get('ID');
				objScreen.FPD_RowEditor.ICDTxt = rd.get('Desc');
			} else if (aCmpName == 'FPO_RowEditor_ICD'){
				Common_SetValue("FPO_RowEditor_ICD10",rd.get('ICD10'));
				Common_SetValue("FPO_RowEditor_ICD",rd.get('ID'),rd.get('Desc'));
				objScreen.FPO_RowEditor.ICDId = rd.get('ID');
				objScreen.FPO_RowEditor.ICDTxt = rd.get('Desc');
			}
		}
		win.FPICD_FindICDWin.close();
	}
	
	win.FPICD_btnCancel_click = function(){
		win.FPICD_FindICDWin.close();
	}
	//add by zhouruimeng 2015-03-17 添加双击事件
	win.FPICD_FindICDList_dblclick = function(objGrid,rowIndex){
		var records = win.FPICD_FindICDListStore.getAt(rowIndex);
		if (records.length<1) {
			ExtTool.alert('提示', '请选择一条记录!');
			return;
		}
		var rd = records;
		if (rd){
			if (aCmpName == 'FPD_RowEditor_ICD'){
				Common_SetValue("FPD_RowEditor_ICD10",rd.get('ICD10'));
				Common_SetValue("FPD_RowEditor_ICD",rd.get('ID'),rd.get('Desc'));
				objScreen.FPD_RowEditor.ICDId = rd.get('ID');
				objScreen.FPD_RowEditor.ICDTxt = rd.get('Desc');
			} else if (aCmpName == 'FPO_RowEditor_ICD'){
				Common_SetValue("FPO_RowEditor_ICD10",rd.get('ICD10'));
				Common_SetValue("FPO_RowEditor_ICD",rd.get('ID'),rd.get('Desc'));
				objScreen.FPO_RowEditor.ICDId = rd.get('ID');
				objScreen.FPO_RowEditor.ICDTxt = rd.get('Desc');
			}
		}
		win.FPICD_FindICDWin.close();
	}
	
	win.FPICD_txtAlias_specialKey = function(field, e) {
		if (e.getKey() != Ext.EventObject.ENTER) return;
		var alias = field.getValue();
		if (alias == '') {
			ExtTool.alert('提示', '请输入别名检索!');
			return;
		}
		win.FPICD_FindICDList.getStore().removeAll();
		win.FPICD_FindICDList.getStore().load({params:{start:0,limit:200}});
	}
	
	win.FPICD_btnCancel.on("click",win.FPICD_btnCancel_click,win);
	win.FPICD_btnSave.on("click",win.FPICD_btnSave_click,win);
	win.FPICD_txtAlias.on("specialKey",win.FPICD_txtAlias_specialKey,win);
	win.FPICD_FindICDList.on("rowdblclick",win.FPICD_FindICDList_dblclick,win);
	
	win.FPICD_FindICDWin = new Ext.Window({
		id : 'FPICD_FindICDWin'
		,height : 400
		,width : 500
		,modal : true
		,title : 'ICD检索'
		,closable : false
		,layout : 'fit'
		,frame : true
		,items:[
			win.FPICD_FindICDList
		]
	});
	win.FPICD_FindICDWin.show();
	
	return win;
}