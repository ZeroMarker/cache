function PathWEpStepItem(StepItemId, CateID, IsReadOnly){
	var obj = new Object();
	
	//本窗体的Title
	var ItemTitle="<font color='green'>临床路径</font>："
	//var clinlPathnode=Ext.getCmp('way-tree').getSelectionModel().getSelectedNode() ;
	//ItemTitle=ItemTitle+clinlPathnode.text;
	//var epNode=node.parentNode
	ItemTitle= "" //Modified BY LiYang 2010-12-26 ItemTitle+"&nbsp&nbsp&nbsp&nbsp<font color='green'>阶段</font>:"+epNode.text
	//var stepStr=node.text
	//stepStr=stepStr.split(" ")
	//ItemTitle=ItemTitle+"&nbsp&nbsp&nbsp&nbsp<font color='green'>步骤</font>:"+stepStr[0]
	//临时变量
	
	var arryID = StepItemId.split("||");
	obj.StepRowid=arryID[0] + "||" + arryID[1] + "||"  + arryID[2]; //StepId  modified by LiYang 2010-12-26  node.id
	obj.StepItemId=StepItemId;  
	obj.StepItemId1=StepItemId;
	obj.PathARCIM="";
	
	//*********************************Start***********************************
	//表单项目列表，列表带编辑功能
	obj.CPWEpStepItemEditor = new Ext.ux.grid.RowEditor({
	        saveText: '保存',
	        cancelText: '取消',
	        readOnly: IsReadOnly  //Add By LiYang 2010-12-29
	});
 	obj.CPWEpStepItemLinkARCIMEditor = new Ext.ux.grid.RowEditor({
	        saveText: '保存',
	        cancelText: '取消'
	        ,readOnly: IsReadOnly  //Add By wuqk 2011-07-26
	});
	obj.CPWEpStepItemLinkCNEditor = new Ext.ux.grid.RowEditor({
	        saveText: '保存',
	        cancelText: '取消'
	        ,readOnly: IsReadOnly  //Add By wuqk 2011-07-26
	});
	obj.PathItemDsec = new Ext.form.TextField({
		id : 'PathItemDsec'
		,width : 170
		,fieldLabel : '项目描述'
	});
	obj.PathItemGroupNo = new Ext.form.TextField({
		id : 'PathItemGroupNo'
		,width : 170
		,fieldLabel : '项目分组'
	});
	obj.PathItemSubCatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.PathItemSubCatStore = new Ext.data.Store({
		proxy: obj.PathItemSubCatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
			,{name: 'ItemRowid', mapping: 'ItemRowid'}
			,{name: 'ItemDesc', mapping: 'ItemDesc'}
		])
	});
	obj.PathItemSubCat = new Ext.form.ComboBox({
		id : 'PathItemSubCatCom'
		,width : 170
		,hiddenName :"hiddenSubCat"
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : '项目子类'
		,store : obj.PathItemSubCatStore
		,editable : false
		,triggerAction : 'all'
		,valueField : 'Rowid'
	});
	obj.hiddenSubCat=new Ext.form.Hidden({
		id:"hiddenSubCat",
		value:""
	});
	/*
	obj.PathItemOrdSetStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.PathItemOrdSetStore = new Ext.data.Store({
		proxy: obj.PathItemOrdSetStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'ordCode', mapping: 'ordCode'}
			,{name: 'ordSetDesc', mapping: 'ordSetDesc'}
		])
	});
	obj.PathItemOrdSet = new Ext.form.ComboBox({
		id : 'PathItemOrdSetCom'
		,minChars : 1
		,width : 170
		,store : obj.PathItemOrdSetStore
		,fieldLabel : '医嘱套'
		,triggerAction : 'all'
		,valueField : 'rowid'
		,displayField : 'ordSetDesc'
	});
	*/
	obj.IsMustItem = new Ext.form.ComboBox({
		id : 'IsMustItem'
		,minChars : 1
		,width : 170
		,fieldLabel : '可否不执行项目'
		,editable : false
		,triggerAction : 'all',
		store:new Ext.data.ArrayStore({
			fields:['active'],
			data:	[[''],['Yes'],['No']]
		}),
		displayField:'active',
		valueField:'active',
		mode:'local'
	});
	/*
	obj.PathItemCheckPoint = new Ext.form.ComboBox({
		id : 'PathItemCheckPoint'
		,minChars : 1
		,width : 170
		,fieldLabel : '关键点'
		,editable : false
		,triggerAction : 'all',
		store:new Ext.data.ArrayStore({
			fields:['active'],
			data:	[[''],['KEY'],['TIME']]
		}),
		displayField:'active',
		valueField:'active',
		mode:'local'
	});
	*/
	/*
	obj.PathItemCheckDesc = new Ext.form.TextField({
		id : 'PathItemCheckDesc'
		,width : 170
		,fieldLabel : '关键点描述'
	});
	*/
	obj.ItmDefault = new Ext.form.ComboBox({
		id : 'ItmDefault'
		,minChars : 1
		,width : 120
		,fieldLabel : '默认标志'
		,triggerAction : 'all',
		editable:false,
		store:new Ext.data.ArrayStore({
      			fields:['active'],
      			data:	[['Yes'],['No']]
		}),
    		displayField:'active',
		valueField:'active',
		mode:'local'
	});
	obj.ItmIsMain = new Ext.form.ComboBox({
		id : 'ItmIsMain'
		,minChars : 1
		,width : 120
		,fieldLabel : '是否主项目'
		,triggerAction : 'all',
		editable:false,
		store:new Ext.data.ArrayStore({
      			fields:['active'],
      			data:	[['Yes'],['No']]
		}),
    	displayField:'active',
		valueField:'active',
		mode:'local'
	});
	obj.ItmIsActive = new Ext.form.ComboBox({
		id : 'ItmIsActive'
		,minChars : 1
		,width : 120
		,fieldLabel : '是否有效'
		,triggerAction : 'all',
		editable:false,
		store:new Ext.data.ArrayStore({
      			fields:['active'],
      			data:	[['Yes'],['No']]
		}),
    	displayField:'active',
		valueField:'active',
		mode:'local'
	});
	obj.CPWEpStepItemGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.CPWEpStepItemGridStore = new Ext.data.Store({
		proxy: obj.CPWEpStepItemGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'StepItemRowid'
		}, 
		[
			{name: 'StepItemRowid', mapping: 'StepItemRowid'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'GroupNo', mapping: 'GroupNo'}
			,{name: 'SubCatRowid', mapping: 'SubCatRowid'}
			,{name: 'SubCat', mapping: 'SubCatDesc'}
			,{name: 'OrdSetRowid', mapping: 'OrdSetRowid'}
			,{name: 'OrdSet', mapping: 'OrdSetDesc'}
			,{name: 'CheckPoint', mapping: 'CheckPoint'}
			,{name: 'CheckPointRowid', mapping: 'CheckPoint'}
			,{name: 'CheckDesc', mapping: 'CheckDesc'}
			,{name: 'IsMustItem', mapping: 'IsMustItem'}
			,{name: 'IsMustItemRowid', mapping: 'IsMustItem'}
		])
	});
	obj.CPWEpStepItemGrid = new Ext.grid.GridPanel({
		id : 'CPWEpStepItemGrid'
		,store : obj.CPWEpStepItemGridStore
		,width : 620
		,height : 250
		//,frame:true
		,region:"center"
		,plugins: [obj.CPWEpStepItemEditor]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '项目描述', width: 300, dataIndex: 'Desc', sortable: true,editor:obj.PathItemDsec}
			,{header: '项目<br>分组', width: 40, dataIndex: 'GroupNo', sortable: true,editor:obj.PathItemGroupNo}
			,{header: '项目子类', width: 60, dataIndex: 'SubCat', sortable: true,editor:obj.PathItemSubCat}
			//,{header: '医嘱套', width: 40, dataIndex: 'OrdSet', sortable: true,editor:obj.PathItemOrdSet}
			,{header: '可否<br>不执行', width: 40, dataIndex: 'IsMustItem', sortable: true,editor:obj.IsMustItem}
			//,{header: '关键点', width: 40, dataIndex: 'CheckPoint', sortable: true,editor:obj.PathItemCheckPoint}
			//,{header: '关键点描述', width: 80, dataIndex: 'CheckDesc', sortable: true,editor:obj.PathItemCheckDesc}
		],
		tbar: [
			{
				text: '增加',
				iconCls: 'icon-add',
				handler: function(){
					obj.onAdd();
				}
				,disabled : IsReadOnly
        	}, '-', {
				text: '删除',
				iconCls: 'icon-delete',
				handler: function(){
					obj.onDelete();	
				}
				,disabled : IsReadOnly
			}, '-'
		]
		,viewConfig: {
        	forceFit: true
     	}
	});
	//*********************************End***********************************
	
	
	//*********************************Start***********************************
	//表单项目关联可选医嘱项列表，列表带编辑功能
	obj.ItmNo = new Ext.form.TextField({
		id : 'ItmNo'
		,width : 150
		,fieldLabel : '序号'
		,enableKeyEvents: true
		,disabled : true
		//,readOnly:true
	});
	obj.ItmLinkNo = new Ext.form.NumberField({
		id : 'ItmLinkNo'
		,width : 150
		,fieldLabel : '关联号'
		,enableKeyEvents: true
		,allowDecimals:false
		,nanText : '只允许输入整数!'
	});
	/*
	obj.ItmGroupNo = new Ext.form.NumberField({
		id : 'ItmGroupNo'
		,width : 150
		,fieldLabel : '医嘱分组'
		,enableKeyEvents: true
		,allowDecimals:false
		,nanText : '只允许输入整数!'
	});
	*/
	obj.ItmResume = new Ext.form.TextField({
		id : 'ItmResume'
		,width : 150
		,fieldLabel : '备注'
	});
	
	obj.ItmARCIMStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ItmARCIMStore = new Ext.data.Store({
		proxy: obj.ItmARCIMStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'ordCode', mapping: 'ordCode'}
			,{name: 'ordSetDesc', mapping: 'ordSetDesc'}
		])
	});
	obj.ItmARCIM = new Ext.form.ComboBox({
		id: 'ItmARCIM'
    		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>名称</th>',
					'<th>代码</th>',
				'</tr></thead>',
				'<tpl for="."><tr>',
					'<td><div class="search-item">{ordSetDesc}</div></td>',
					'<td>{ordCode}</td>',
		    	'</tr></tpl>',
			'</table>'
	   	 )
		,hideTrigger:true
		,triggerAction : 'all'
		,itemSelector: 'div.search-item'
		,minListWidth: 600
		,store : obj.ItmARCIMStore
		,valueField : 'rowid'
		,displayField : 'ordSetDesc'
		,loadingText: '查询中,请稍等...'
		,listeners: {
			keyup : function(field, e){
				if (e.getKey() == e.ENTER) {
					if ((field.getValue()=='')||(field.getRawValue()!=field.lastSelectionText)) {
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
	
	obj.ItmDoseQty = new Ext.form.NumberField({
		id : 'ItmDoseQty'
		,width : 150
		,fieldLabel : '剂量'
		,editable : false
		,allowDecimals: false
		,allowNegative: false
		,decimalSeparator: '.'
		,decimalPrecision: 2
		,baseChars: '0123456789.'
		,nanText : '只允许输入数字!'
	});
	obj.ItmUomStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ItmUomStore = new Ext.data.Store({
		proxy: obj.ItmUomStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'FormDoseUOMRowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'FormDoseUOMRowid', mapping: 'FormDoseUOMRowid'}
			,{name: 'FormDoseUOMDesc', mapping: 'FormDoseUOMDesc'}
		])
	});
	obj.ItmUom = new Ext.form.ComboBox({
		id : 'ItmUom'
		,width : 150
		,store : obj.ItmUomStore
		,displayField : 'FormDoseUOMDesc'
		,minChars : 1
		,fieldLabel : '剂量单位'
		,valueField : 'FormDoseUOMRowid'
		,triggerAction : 'all'
		,editable:true
	});
	obj.ItmPriorityStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ItmPriorityStore = new Ext.data.Store({
		proxy: obj.ItmPriorityStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OECPRID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'OECPRID', mapping: 'OECPRID'}
			,{name: 'OECPRCode', mapping: 'OECPRCode'}
			,{name: 'OECPRDesc', mapping: 'OECPRDesc'}
		])
	});
	obj.ItmPriority = new Ext.form.ComboBox({
		id : 'ItmPriority'
		,width : 150
		,store : obj.ItmPriorityStore
		,displayField : 'OECPRDesc'
		,minChars : 1
		,fieldLabel : '类型'
		,valueField : 'OECPRID'
		,triggerAction : 'all',
		editable:true
	});
	obj.ItmDuratStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ItmDuratStore = new Ext.data.Store({
		proxy: obj.ItmDuratStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.ItmDurat = new Ext.form.ComboBox({
		id : 'ItmDurat'
		,width : 150
		,displayField : 'desc'
		,minChars : 1
		,fieldLabel : '疗程'
		,triggerAction : 'all'
		,store : obj.ItmDuratStore
		,valueField : 'Rowid'
	});
	obj.ItmFreqStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ItmFreqStore = new Ext.data.Store({
		proxy: obj.ItmFreqStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'desc1', mapping: 'desc1'}
		])
	});
	obj.ItmFreq = new Ext.form.ComboBox({
		id : 'ItmFreq'
		,width : 150
		,minChars : 1
		,displayField : 'desc1'
		,fieldLabel : '频次'
		,store : obj.ItmFreqStore
		,triggerAction : 'all'
		,valueField : 'Rowid'
	});
	obj.ItmInstrucStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ItmInstrucStore = new Ext.data.Store({
		proxy: obj.ItmInstrucStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.ItmInstruc = new Ext.form.ComboBox({
		id : 'ItmInstruc'
		,width : 150
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '用法'
		,store : obj.ItmInstrucStore
		,triggerAction : 'all'
		,valueField : 'Rowid'
	});
	obj.ItmQty = new Ext.form.NumberField({
		id : 'ItmQty'
		,width : 150
		,fieldLabel : '数量'
		,allowDecimals: false
		,allowNegative: false
		,decimalSeparator: '.'
		,decimalPrecision: 2
		,baseChars: '0123456789.'
		,nanText : '只允许输入数字!'
	});
	
	obj.CPWEpStepItemLinkARCIMGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.CPWEpStepItemLinkARCIMGridStore = new Ext.data.Store({
		proxy: obj.CPWEpStepItemLinkARCIMGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		},
		[
			{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'itmNo', mapping: 'itmNo'}
			,{name: 'itmLinkNo', mapping: 'itmLinkNo'}
			,{name: 'ARCIMDescRowid', mapping: 'itmARCIMDR'}
			,{name: 'ARCIMDesc', mapping: 'ARCIMDesc'}
			,{name: 'itmDoseQty', mapping: 'itmDoseQty'}
			,{name: 'UomDescRowid', mapping: 'itmUomDr'}
			,{name: 'UomDesc', mapping: 'UomDesc'}
			,{name: 'DuratDescRowid', mapping: 'itmDuratDR'}
			,{name: 'DuratDesc', mapping: 'DuratDesc'}
			,{name: 'FreqDescRowid', mapping: 'itmFreqDR'}
			,{name: 'FreqDesc', mapping: 'FreqDesc'}
			,{name: 'InstrucDescRowid', mapping: 'itmInstrucDR'}
			,{name: 'InstrucDesc', mapping: 'InstrucDesc'}
			,{name: 'itmQty', mapping: 'itmQty'}
			,{name: 'itmDefault', mapping: 'itmDefault'}
			,{name: 'itmDefaultRowid', mapping: 'itmDefault'}
			,{name: 'itmPriorityRowid', mapping: 'itmPriorityRowid'}
			,{name: 'itmPriority', mapping: 'itmPriority'}
			,{name: 'itmIsMain', mapping: 'itmIsMain'}
			,{name: 'itmIsMainRowid', mapping: 'itmIsMain'}
			,{name: 'itmGroupNo', mapping: 'itmGroupNo'}
			,{name: 'itmResume', mapping: 'itmResume'}
			,{name: 'itmIsActive', mapping: 'itmIsActive'}
			,{name: 'itmIsActiveRowid', mapping: 'itmIsActive'}
		])
	});
	obj.CPWEpStepItemLinkARCIMGrid = new Ext.grid.GridPanel({
		id : 'PathWaysARCIMGrid'
		,store : obj.CPWEpStepItemLinkARCIMGridStore
		,buttonAlign : 'center'
		,width : 680
		,height : 400
		,plugins:[obj.CPWEpStepItemLinkARCIMEditor]
		,columns: [
			{header: '序号', width: 40, dataIndex: 'itmNo', sortable: true,editor:obj.ItmNo}
			,{header: '是否<br>主项', width: 60, dataIndex: 'itmIsMain', sortable: true,editor:obj.ItmIsMain}
			,{header: '默认<br>标志', width: 60, dataIndex: 'itmDefault', sortable: true,editor:obj.ItmDefault}
			,{header: '关联号', width: 60, dataIndex: 'itmLinkNo', sortable: true,editor:obj.ItmLinkNo}
			,{header: '类型', width: 100, dataIndex: 'itmPriority', sortable: true,editor:obj.ItmPriority}
			,{header: '医嘱项', width: 220, dataIndex: 'ARCIMDesc', sortable: true,editor:obj.ItmARCIM}
			,{header: '数量', width: 60, dataIndex: 'itmQty', sortable: true,editor:obj.ItmQty}
			//,{header: '医嘱<br>分组', width: 60, dataIndex: 'itmGroupNo', sortable: true,editor:obj.ItmGroupNo}
			,{header: '剂量', width: 60, dataIndex: 'itmDoseQty', sortable: true,editor:obj.ItmDoseQty}
			,{header: '剂量单位', width: 100, dataIndex: 'UomDesc', sortable: true,editor:obj.ItmUom}
			,{header: '疗程', width: 60, dataIndex: 'DuratDesc', sortable: true,editor:obj.ItmDurat}
			,{header: '频次', width: 120, dataIndex: 'FreqDesc', sortable: true,editor:obj.ItmFreq}
			,{header: '用法', width: 120, dataIndex: 'InstrucDesc', sortable: true,editor:obj.ItmInstruc}
			,{header: '备注', width: 150, dataIndex: 'itmResume', sortable: true,editor:obj.ItmResume}
			,{header: '是否<br>有效', width: 60, dataIndex: 'itmIsActive', sortable: true,editor:obj.ItmIsActive}
		]
		,tbar: [{
	            text: '增加',
	            iconCls: 'icon-add',
	            handler: function(){
	            	obj.onARCIMAdd();	
	            }
	            ,disabled : IsReadOnly
	        }, '-', {
	            text: '删除',
	            iconCls: 'icon-delete',
	            handler: function(){
	            	obj.onARCIMDelete();	
	            }
	            ,disabled : IsReadOnly
	        }, '-' ,{
	            text: '复制',
	            iconCls: 'icon-add',
	            handler: function(){
					var record=obj.CPWEpStepItemGrid.getSelectionModel().getSelected();
					if(!record){
						ExtTool.alert("提示","请选择项目！")
						return	
					}
					var arrID=obj.StepItemId.split("||");
					if (arrID.length<4)
					{
						return;
					}
					var CPWID=arrID[0];
					var CPWItemID=obj.StepItemId;
					var obj2=obj;
	            	CopyLinkArcimLookUpHeader(CPWID,CPWItemID,obj2);
	            }
	            ,disabled : IsReadOnly
	        }, '-'
		]
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
	obj.CPWEpStepItemLinkARCIM = new Ext.Panel({
		id : 'CPWEpStepItemLinkARCIM'
		,buttonAlign : 'center'
		,frame : true
		,title : '关联医嘱'
		,layout : 'fit'
		,items:[
			obj.CPWEpStepItemLinkARCIMGrid
		]
	});
	//*********************************End*************************************
	
	//*********************************Start***********************************
	//表单项目关联诊疗或护理(关联项目字典)，列表带编辑功能
	//关联项目大类下拉框
	obj.LnkItemCategStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.LnkItemCategStore = new Ext.data.Store({
		proxy: obj.LnkItemCategStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ItemCategRowid'
		}, 
		[
			{name: 'ItemCategRowid', mapping: 'Rowid'}
			,{name: 'ItemCateg', mapping: 'Desc'}
		])
	});
	obj.LnkItemCateg = new Ext.form.ComboBox({
		id : 'LnkItemCateg'
		,minChars : 0
		,store : obj.LnkItemCategStore
		,width : 150
		,fieldLabel : '关联项目大类'
		,displayField : 'ItemCateg'
		,valueField:'ItemCategRowid'
		,triggerAction : 'all'
		,pageSize:7
		,listWidth:250
		,editable : false
		,listeners:{
			select:function(){obj.LnkItemDicStore.load({});}   //add by zhaoyu 2013-01-05 临床路径维护-路径表单维护-增加关联项目时，先点击【项目】下拉框，再选择【类型】，然后点击【项目】下拉框，列表为空 204
			}
	});
	
	//关联项目下拉框
	obj.LnkItemDicStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.LnkItemDicStore = new Ext.data.Store({
		proxy: obj.LnkItemDicStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ItemDicRowid'
		}, 
		[
			{name: 'ItemDicRowid', mapping: 'rowid'}
			,{name: 'ItemDic', mapping: 'IDDesc'}
		])
	});
	obj.LnkItemDic = new Ext.form.ComboBox({
		id : 'LnkItemDic'
		,minChars : 0
		,store : obj.LnkItemDicStore
		,width : 150
		,fieldLabel : '关联项目'
		,displayField : 'ItemDic'
		,valueField:'ItemDicRowid'
		,triggerAction : 'all'
		,pageSize:10
		,listWidth:250
		,editable : false
	});
	/*
	//关联项目分组号
	obj.LnkItemGroupNo = new Ext.form.NumberField({
		id : 'LnkItemGroupNo'
		,width : 150
		,fieldLabel : '关联项目分组号'
		,allowDecimals: false
		,allowNegative: false
		,decimalSeparator: '.'
		,decimalPrecision: 2
		,baseChars: '0123456789'
		,nanText : '只允许输入数字!'
	});
	*/
	//关联项目是否有效
	obj.LnkItemIsActive = new Ext.form.ComboBox({
		id : 'LnkItemIsActive'
		,minChars : 1
		,width : 170
		,fieldLabel : '关联项目是否有效'
		,editable : false
		,triggerAction : 'all',
		store:new Ext.data.ArrayStore({
			fields:['IsActive'],
			data:	[['Yes'],['No']]
		}),
		displayField:'IsActive',
		valueField:'IsActive',
		mode:'local'
	});
	
	obj.CPWEpStepItemLinkCNGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.CPWEpStepItemLinkCNGridStore = new Ext.data.Store({
		proxy: obj.CPWEpStepItemLinkCNGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ItemID'
		},
		[
			{name: 'ItemID', mapping: 'ItemID'}
			,{name: 'ItemNo', mapping: 'ItemNo'}
			,{name: 'ItemCategRowid', mapping: 'ItemCategID'}
			,{name: 'ItemCateg', mapping: 'ItemCateg'}
			,{name: 'ItemDicRowid', mapping: 'ItemDicID'}
			,{name: 'ItemDic', mapping: 'ItemDic'}
			,{name: 'GroupNo', mapping: 'GroupNo'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'UpdateUser', mapping: 'UpdateUser'}
			,{name: 'UpdateDate', mapping: 'UpdateDate'}
			,{name: 'UpdateTime', mapping: 'UpdateTime'}
		])
	});
	obj.CPWEpStepItemLinkCNGrid = new Ext.grid.GridPanel({
		id : 'CPWEpStepItemLinkCNGrid'
		,store : obj.CPWEpStepItemLinkCNGridStore
		,buttonAlign : 'center'
		,width : 680
		,height : 400
		,plugins:[obj.CPWEpStepItemLinkCNEditor]
		,columns: [
			{header: '序号', width: 40, dataIndex: 'ItemNo', sortable: true}
			,{header: '类型', width: 100, dataIndex: 'ItemCateg', sortable: true, editor:obj.LnkItemCateg}
			,{header: '项目', width: 150, dataIndex: 'ItemDic', sortable: true, editor:obj.LnkItemDic}
			//,{header: '分组号', width: 40, dataIndex: 'GroupNo', sortable: true, editor:obj.LnkItemGroupNo}
			,{header: '是否有效', width: 40, dataIndex: 'IsActive', sortable: true, editor:obj.LnkItemIsActive}
		]
		,tbar: [
			{
	            text: '增加',
	            iconCls: 'icon-add',
	            handler: function(){
	            	obj.OnLinkItemAdd();
	            }
	            ,disabled : IsReadOnly
	        }, '-', {
	            text: '删除',
	            iconCls: 'icon-delete',
	            handler: function(){
	            	obj.OnLinkItemDelete();
	            }
	            ,disabled : IsReadOnly
	        }, '-'
	    ]
	    ,viewConfig : {
			forceFit : true
		}
	});
	obj.CPWEpStepItemLinkCN = new Ext.Panel({
		id : 'CPWEpStepItemLinkCN'
		,buttonAlign : 'center'
		,frame : true
		,title : '关联项目'
		,layout : 'fit'
		,items:[
			obj.CPWEpStepItemLinkCNGrid
		]
	});
	//*********************************End*************************************
	
	obj.CPWEpStepItemLink = new Ext.TabPanel({
		id : 'CPWEpStepItemLink'
		,activeTab : 0
		//,collapsible : true
		//,collapsed : true
		,height : 300
		,region : 'south'
		,items:[
			obj.CPWEpStepItemLinkARCIM
			,obj.CPWEpStepItemLinkCN
		]
	});
	obj.PathItemWindow = new Ext.Viewport({
		id : 'PathItemWindow'
		,title:ItemTitle
		//,height : 650
		//,buttonAlign : 'center'
		//,width : 900
		,layout : 'border'
		//,closeAction: 'close'
		//,closable:true
		//,modal: true
		//,resizable:false
		,items:[
			obj.CPWEpStepItemGrid
			,obj.CPWEpStepItemLink
		]
	});
	
	
	//*********************************Start*************************************
	//StoreProxy,涉及数据的加载和初始化
	//表单项目关联医嘱列表
	obj.CPWEpStepItemLinkARCIMGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWaysARCIM';
			param.QueryName = 'GetPathWaysARCIM';
			param.Arg1=obj.StepItemId
			param.ArgCnt = 1;
	});
	//obj.CPWEpStepItemLinkARCIMGridStore.load({});
	//表单项目关联医嘱项选择框
	obj.ItmARCIMStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCPW.MRC.PathWaysARCIM';
		param.QueryName = 'GetAllItem';
		var tmpAlias = obj.ItmARCIM.getRawValue();
		param.Arg1 = (tmpAlias.length>1 ? tmpAlias : '');
		param.ArgCnt = 1;
	});
	//obj.ItmARCIMStore.load({});
	
	obj.ItmUomStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCPW.MRC.PathWaysARCIM';
		param.QueryName = 'GetUnit';
		param.Arg1 = obj.ItmARCIM.getValue();
		param.ArgCnt = 1;
	});
	obj.ItmUomStore.on({
		load:{
			fn:function(){
				if(obj.ItmUomValue!=""){
					obj.ItmUom.setValue(obj.ItmUomValue)	
				}	
			}	
		}	
		
	});
	//obj.ItmUomStore.load({});
	obj.ItmPriorityStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCPW.MRC.PathWaysARCIM';
		param.QueryName = 'QryOECPriority';
		param.ArgCnt = 0;
	});
	obj.ItmPriorityStore.on({});
	obj.ItmDuratStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWaysARCIM';
			param.QueryName = 'GetDurat';
			param.Arg1=obj.ItmDurat.getRawValue();
			param.ArgCnt = 1;
	});
	obj.ItmDuratStore.on({
			load:{
			fn:function(){  
					var objRec = new Ext.data.Record({
            	 			rowid : "",
            	 			desc : ""
            	});
           obj.ItmDuratStore.insert(0,objRec)
          }       
       },   
       scope:this	
	});
	obj.ItmDuratStore.load({});
	obj.ItmFreqStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWaysARCIM';
			param.QueryName = 'GetFreq';
			param.Arg1 =obj.ItmFreq.getRawValue();
			param.ArgCnt = 1;
	});
	obj.ItmFreqStore.on({
			load:{
			fn:function(){  
					var objRec = new Ext.data.Record({
            	 			rowid : "",
            	 			desc1 : ""
            	});
           obj.ItmFreqStore.insert(0,objRec)
          }       
       },   
       scope:this	
	});
	obj.ItmFreqStore.load({});
	obj.ItmInstrucStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWaysARCIM';
			param.QueryName = 'GetInstruc';
			param.Arg1=obj.ItmInstruc.getRawValue();
			param.ArgCnt = 1;
	});
	obj.ItmInstrucStore.on({
			load:{
			fn:function(){  
					var objRec = new Ext.data.Record({
            	 			rowid : "",
            	 			desc: ""
            	});
           obj.ItmInstrucStore.insert(0,objRec)
          }       
       },   
       scope:this	
	});
	obj.ItmInstrucStore.load({});
	obj.CPWEpStepItemGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWEpStepItem';
			param.QueryName = 'GetPathEpStepItem';
			param.Arg1 = obj.StepRowid;
			param.Arg2 = CateID;
			param.ArgCnt = 2;
	});
	obj.CPWEpStepItemGridStore.load({});
	
	/* update by zf 2012-02-10
	//StepItemId不为空时自动选中项目。
	obj.CPWEpStepItemGridStore.on({
		load:{
			fn:function(){
				if(StepItemId=="") return
				var stepItemServer = ExtTool.StaticServerObject("web.DHCCPW.MRC.PathWEpStepItem");
				var num=stepItemServer.GetStepItemNum(obj.StepRowid,StepItemId)
				if(num!=0){
					var page=parseInt(num/obj.pageSize)+1
				  	//var pathIndex=num%obj.pageSize
				  	//if(pathIndex==0) pathIndex=10
				  	var num=parseInt(num)
				  	obj.CPWEpStepItemGrid.getSelectionModel().selectRow(num-1)
				  	if(num==15) num=num-1
				  	obj.CPWEpStepItemGrid.getView().focusRow(num);//focusRow的参数类型必需是number类型
				  	StepItemId=0
				}
			}
		}
		,scope:this
	});
	*/
	
	//项目子类加载
	obj.PathItemSubCatStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.StepItemSubCategory';
			param.QueryName = 'GetStepItemSubCat';
			param.Arg1 = CateID;
			param.Arg2 = '';
			param.Arg3 = '';
			param.Arg4 = new Date().format('Y-m-d');
			param.Arg5 = new Date().format('Y-m-d');
			param.ArgCnt = 5;
	});
	obj.PathItemSubCatStore.load({});
	/*
	obj.PathItemOrdSetStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWEpStepItem';
			param.QueryName = 'GetAllOrdSet';
			param.Arg1 = obj.PathItemOrdSet.getRawValue();
			param.ArgCnt = 1;
	});	
	obj.PathItemOrdSetStore.load({});
	obj.PathItemOrdSetStore.on({
		load:{
			fn:function(){
				var objRec = new Ext.data.Record({
            	 			rowid : "",
            	 			ordSetDesc:""
				});
				obj.PathItemOrdSetStore.insert(0,objRec)
			}  
		},   
		scope:this	
	});
	*/
	
	//表单项目关联医嘱列表
	obj.CPWEpStepItemLinkCNGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWEpStepItemLnk';
			param.QueryName = 'QryCNLinkByStepItem';
			param.Arg1=obj.StepItemId
			param.ArgCnt = 1;
	});
	//obj.CPWEpStepItemLinkCNGridStore.load({});
	//表单项目关联项目 关联项目大类下拉框
	obj.LnkItemCategStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseLinkItemSrv';
			param.QueryName = 'QryItemCat';
			param.ArgCnt = 0;
	});
	obj.LnkItemCategStore.load({});
	//表单项目关联项目 关联项目下拉框
	obj.LnkItemDicStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseLinkItemSrv';
			param.QueryName = 'QryItemDic';
			param.Arg1 = '';   //obj.LnkItemDic.getRawValue();
			param.Arg2 = '';
			param.Arg3 = obj.LnkItemCateg.getValue();
			param.ArgCnt = 3;
	});
	//obj.LnkItemDicStore.load({});
/****************************基础数据加载(上)***************************************/

	PathWEpStepItemEvent(obj);

/****************************可选医嘱项事件监听(下)*********************************/
	obj.ItmARCIM.on('select',obj.ItmARCIMSelect)
	obj.CPWEpStepItemLinkARCIMEditor.on('validateedit',function(edi,allValue,r,rowIndex){
		//验证数据是否有效
		var checkVal=obj.CheckARCIM(allValue,rowIndex)
		if(!checkVal){
			return false;
		}
		var addVal=obj.InsertARCIM(allValue,rowIndex)
		return addVal;
	})
	obj.CPWEpStepItemLinkARCIMEditor.on('canceledit',function(){
		var rec = null;
		for(var i = obj.CPWEpStepItemLinkARCIMGrid.store.getCount() - 1; i >= 0; i --)
		{
			rec=obj.CPWEpStepItemLinkARCIMGrid.store.getAt(i)  //Add by LiYang 2011-06-02 FixBug:69
			if(rec.get("Rowid") == "") //Add by LiYang 2011-06-02 FixBug:69
			{
				obj.CPWEpStepItemLinkARCIMGrid.store.remove(rec);
				obj.CPWEpStepItemLinkARCIMEditor.Type="";			
			}
		}
	})
	obj.CPWEpStepItemLinkARCIMEditor.on('initField',function(edi){
		obj.ItmUomStore.load();	//	Add by zhaoyu 2012-11-14 基础信息维护-路径表单维护-重点医嘱-在切换选中的关联医嘱后，【剂量单位】列表叠加显示 缺陷编号174
		var rec=obj.CPWEpStepItemLinkARCIMGrid.store.getAt(obj.CPWEpStepItemLinkARCIMEditor.RowIndex);
		if (rec) {
			obj.ItmPriority.setRawValue(rec.get('itmPriority'));
		}
		obj.ItmDoseQty.setDisabled(false)
	  	obj.ItmUom.setDisabled(false)
	  	obj.ItmInstruc.setDisabled(false)
	  	obj.ItmQty.setDisabled(false)
	  	obj.ItmFreq.setDisabled(false)
	  	obj.ItmDurat.setDisabled(false)
		if ((obj.ItmARCIM.getValue()=="")||(obj.ItmARCIM.getRawValue()=="")) return;
		var stepItemServer=ExtTool.StaticServerObject("web.DHCCPW.MRC.PathWEpStepItem")
	  	var arcimStr=stepItemServer.GetArcimInfoById(obj.ItmARCIM.getValue())
	  	var arcim=arcimStr.split("^")
	  	if(arcim[1]=="R"){
	  		obj.ItmQty.setDisabled(false)
	  	}else if(arcim[2]=="4"){
			obj.ItmDoseQty.setDisabled(true)
			obj.ItmUom.setDisabled(true)
			obj.ItmInstruc.setDisabled(true)
	  	}else{
			obj.ItmDoseQty.setDisabled(true)
		  	obj.ItmUom.setDisabled(true)
		  	obj.ItmInstruc.setDisabled(true)
		  	obj.ItmFreq.setDisabled(true)
		  	obj.ItmDurat.setDisabled(true)
	  	}
	  	
	})
	obj.CPWEpStepItemLinkARCIMEditor.on('comSetValue',function(edi,comId,rowIndex,comVal,comRawVal){
		if(comId=="ItmARCIM"){
			obj.ItmARCIM.initialConfig.store.removeAll();
			var objRec = new Ext.data.Record({
            	 			rowid : comVal,
            	 			ordSetDesc : comRawVal
            	 	});
			obj.ItmARCIM.initialConfig.store.add([objRec]);	
			return;
		}
		if(comId=="ItmUom"){
			//obj.ItmUom.initialConfig.store.removeAll();
			var objRec = new Ext.data.Record({
            	 		FormDoseUOMRowid : comVal,
            	 		FormDoseUOMDesc: comRawVal
            	 	});
			obj.ItmUom.initialConfig.store.add([objRec]);
		}
	})
/****************************可选医嘱项事件监听(上)*********************************/

/****************************关联项目事件监听(下)*********************************/
	obj.LnkItemCateg.on('expand',obj.LnkItemCateg_OnExpand);
	obj.LnkItemDic.on('expand',obj.LnkItemDic_OnExpand);
	obj.CPWEpStepItemLinkCNEditor.on('validateedit',function(edi,allValue,r,rowIndex){
		//验证数据是否有效
		var checkVal=obj.CheckLinkCN(allValue,rowIndex)
		if(!checkVal){
			return false;
		}
		//保存按钮保存记录
		var addVal=obj.InsertLinkCN(allValue,rowIndex)
		return addVal;
		return true;
	})
	obj.CPWEpStepItemLinkCNEditor.on('canceledit',function(){
		var rec = null;
		for(var i = obj.CPWEpStepItemLinkCNGrid.store.getCount() - 1; i >= 0; i --)
		{
			rec=obj.CPWEpStepItemLinkCNGrid.store.getAt(i)
			if(rec.get("ItemID") == "")
			{
				obj.CPWEpStepItemLinkCNGrid.store.remove(rec);
				obj.CPWEpStepItemLinkCNEditor.Type="";
			}
		}
	})
	
	obj.CPWEpStepItemLinkCNEditor.on('initField',function(edi){
		var rec=obj.CPWEpStepItemLinkCNGrid.store.getAt(obj.CPWEpStepItemLinkCNEditor.RowIndex);
		if (rec) {
			obj.LnkItemIsActive.setRawValue(rec.get('IsActive'));
		}
	})
	
	obj.CPWEpStepItemLinkCNEditor.on('comSetValue',function(edi,comId,rowIndex,comVal,comRawVal){
		if(comId=="LnkItemCateg"){
			obj.LnkItemCateg.initialConfig.store.removeAll();
			var objRec = new Ext.data.Record({
	 			ItemCategRowid : comVal,
	 			ItemCateg : comRawVal
    	 	});
			obj.LnkItemCateg.initialConfig.store.add([objRec]);
			return;
		}
		if(comId=="LnkItemDic"){
			obj.LnkItemDic.initialConfig.store.removeAll();
			var objRec = new Ext.data.Record({
	 			ItemDicRowid : comVal,
	 			ItemDic : comRawVal
    	 	});
			obj.LnkItemDic.initialConfig.store.add([objRec]);
			return;
		}
	})
	
/****************************关联项目事件监听(上)*********************************/
	
/****************************项目事件监听(下)***************************************/
	obj.CPWEpStepItemGrid.getSelectionModel().on('rowselect',obj.StepItemSelect)
	obj.CPWEpStepItemEditor.on('canceledit',function(){
			var rec=obj.CPWEpStepItemGrid.store.getAt(obj.CPWEpStepItemEditor.RowIndex)
			if(rec.get('StepItemRowid')==""){
				obj.CPWEpStepItemGrid.store.remove(rec);	
			}
	})
	
	obj.CPWEpStepItemEditor.on('validateedit',function(edi,allValue, r,rowIndex){   //验证数据是否有效
		var checkVal=obj.CheckStepItem(allValue)
		if(!checkVal){
			return false;	
		}
		if(r.get("StepItemRowid")==""){
			var addVal=obj.AddPathItem(allValue,rowIndex)
				return addVal;
		}else{
			var StepItemRowid=r.get("StepItemRowid")
			var updateVal=obj.UpdatePathItem(StepItemRowid,allValue)
			return updateVal;
		}
		
		var rec = null;
		for(var i = obj.CPWEpStepItemLinkARCIMGrid.store.getCount() - 1; i >= 0; i --)
		{
			rec=obj.CPWEpStepItemLinkARCIMGrid.store.getAt(i)  //Add by LiYang 2011-06-02 FixBug:69
			if(rec.get("Rowid") == "") //Add by LiYang 2011-06-02 FixBug:69
			{
				obj.CPWEpStepItemLinkARCIMGrid.store.remove(rec);
				obj.CPWEpStepItemLinkARCIMEditor.Type="";			
			}
		}		
		
	})
	obj.CPWEpStepItemEditor.on('afteredit',function(edi,allValue, r,rowIndex){
			var checkVal=obj.CheckStepItem(allValue);
			return checkVal;
			if(!checkVal){
				var rec=obj.CPWEpStepItemGrid.store.getById(rowIndex);
				if(rec) obj.CPWEpStepItemGrid.store.remove(rec);
			}
	})
	obj.CPWEpStepItemEditor.on('comSetValue',function(edi,comId,rowIndex,comVal,comRawVal){
		/*
		if(comId=="PathItemOrdSetCom"){
			obj.PathItemOrdSet.initialConfig.store.removeAll();
			var objRec = new Ext.data.Record({
            	 		rowid : comVal,
            	 		ordSetDesc : comRawVal
            	 	});
			obj.PathItemOrdSet.initialConfig.store.add([objRec]);	
		}
		*/
	})
	obj.CPWEpStepItemEditor.on('setComboBoxHidden',function(edi,rowIndex){
		//项目子类设置默认值
		var record=obj.CPWEpStepItemGrid.store.getAt(rowIndex)
		if(record.data['StepItemRowid']==""){
			if(obj.hiddenSubCat.getValue()!=""){
					obj.PathItemSubCat.setValue(obj.hiddenSubCat.getValue())
			}
		}
	})
	obj.PathItemSubCat.on('select',function(){
		obj.hiddenSubCat.setValue(obj.PathItemSubCat.getValue());	
	})
/****************************项目事件监听(上)***************************************/
	
	
	//事件处理代码
	obj.LoadEvent();
	return obj;
}

