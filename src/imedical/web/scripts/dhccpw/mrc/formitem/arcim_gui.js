var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	obj.currRowIndex = '';
	
	obj.cboOECPriority = Common_ComboToOECPriority("cboOECPriority","类型");
	obj.txtLinkNo = Common_NumberField("txtLinkNo","关联",0,0);
	obj.cboArcim = Common_ComboToARCIM("cboArcim","名称");  //医嘱项
	obj.txtDoseQty = Common_NumberField("txtDoseQty","剂量",0,1,2); //允许输入小数点后两位
	obj.cboDoseUom = Common_ComboToDoseUom("cboDoseUom","单位",'cboArcim');
	obj.cboPHCFreq = Common_ComboToPHCFreq("cboPHCFreq","频次");
	obj.cboPHCInstruc = Common_ComboToPHCInstruc("cboPHCInstruc","用法");
	obj.cboPHCDuration = Common_ComboToPHCDuration("cboPHCDuration","疗程");
	obj.txtPackQty = Common_NumberField("txtPackQty","数量",0,0);
	obj.txtItmResume = Common_TextField("txtItmResume","备注");
	
	obj.IsReadOnly = (ReadOnly=='Y');
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,text : '<span>更新</span>'
		,disabled : obj.IsReadOnly
		,width : 70
	});
	obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,iconCls : 'icon-add'
		,text : '<span>增加</span>'
		,disabled : obj.IsReadOnly
		,width : 60
	});
	obj.btnCopy = new Ext.Button({
		id : 'btnCopy'
		,iconCls : 'icon-add'
		,text : '<span>复制</span>'
		,disabled : obj.IsReadOnly
		,width : 60
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,text : '<span>删除</span>'
		,disabled : obj.IsReadOnly
		,width : 60
	});
	obj.btnMerge = new Ext.Button({
		id : 'btnMerge'
		,icon: '../scripts/dhcwmr/img/moveto.gif'
		,text : '<span>合并</span>'
		,disabled : obj.IsReadOnly
		,width : 60
	});
	obj.btnMoveUp = new Ext.Button({
		id : 'btnMoveUp'
		,icon: '../scripts/dhcwmr/img/moveup.gif'
		,text : '<span>上移</span>'
		,disabled : obj.IsReadOnly
		,width : 60
	});
	obj.btnMoveDown = new Ext.Button({
		id : 'btnMoveDown'
		,icon: '../scripts/dhcwmr/img/movedown.gif'
		,text : '<span>下移</span>'
		,disabled : obj.IsReadOnly
		,width : 60
	});
	
	obj.gridLnkArcimStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridLnkArcimStore = new Ext.data.Store({
		proxy: obj.gridLnkArcimStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IGAIndex'
		},
		[
			{name: 'IGAIndex', mapping: 'IGAIndex'}
			,{name: 'IGNo', mapping: 'IGNo'}
			,{name: 'IGLinkNo', mapping: 'IGLinkNo'}
			,{name: 'IGPriority', mapping: 'IGPriority'}
			,{name: 'IGPriorityDesc', mapping: 'IGPriorityDesc'}
			,{name: 'IGIsMain', mapping: 'IGIsMain'}
			,{name: 'IGAArcimDR', mapping: 'IGAArcimDR'}
			,{name: 'IGAArcimDesc', mapping: 'IGAArcimDesc'}
			,{name: 'PHCGeneDesc', mapping: 'PHCGeneDesc'}
			,{name: 'PHCSpecDesc', mapping: 'PHCSpecDesc'}
			,{name: 'PHCFormDesc', mapping: 'PHCFormDesc'}
			,{name: 'IGAPackQty', mapping: 'IGAPackQty'}
			,{name: 'IGAFreqDR', mapping: 'IGAFreqDR'}
			,{name: 'IGAFreqDesc', mapping: 'IGAFreqDesc'}
			,{name: 'IGADuratDR', mapping: 'IGADuratDR'}
			,{name: 'IGADuratDesc', mapping: 'IGADuratDesc'}
			,{name: 'IGAInstrucDR', mapping: 'IGAInstrucDR'}
			,{name: 'IGAInstrucDesc', mapping: 'IGAInstrucDesc'}
			,{name: 'IGADoseQty', mapping: 'IGADoseQty'}
			,{name: 'IGADoseUomDR', mapping: 'IGADoseUomDR'}
			,{name: 'IGADoseUomDesc', mapping: 'IGADoseUomDesc'}
			,{name: 'IGADefault', mapping: 'IGADefault'}
			,{name: 'IGAIsActive', mapping: 'IGAIsActive'}
			,{name: 'IGAResume', mapping: 'IGAResume'}
			,{name: 'IGASign', mapping: 'IGASign'}
		])
	});
	obj.gridLnkArcim = new Ext.grid.EditorGridPanel({
		id : 'gridLnkArcim'
		,store : obj.gridLnkArcimStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,bbar : [obj.btnMoveUp,obj.btnMoveDown,{style:'width:50px;',xtype:'label'},obj.btnMerge,{style:'width:50px;',xtype:'label'},obj.btnUpdate,{style:'width:50px;',xtype:'label'},obj.btnAdd,{style:'width:50px;',xtype:'label'},obj.btnCopy,{style:'width:50px;',xtype:'label'},obj.btnDelete]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '通用名', width: 120, dataIndex: 'PHCGeneDesc', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var IGASign = rd.get("IGASign");
					if (IGASign == '1'){
						v = '┏' + v;
					} else if (IGASign == '2'){
						v = '┗' + v;
					} else if (IGASign == '3'){
						v = '' + v;
					} else {
						v = '┃' + v;
					}
					return v;
				}
			}
			,{header: '医嘱类型', width:80, dataIndex: 'IGPriorityDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '顺序号', width: 50, dataIndex: 'IGNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '关联', width: 50, dataIndex: 'IGLinkNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '副医嘱', width: 50, dataIndex: 'IGIsMain', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IGIsMain = rd.get("IGIsMain");
					if (IGIsMain == '0') {
						return "<IMG src='../scripts/dhccpw/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhccpw/img/unchecked.gif'>";
					}
				}
			}
			,{header: '名称', width: 200, dataIndex: 'IGAArcimDesc', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '单次<br>剂量', width: 50, dataIndex: 'IGADoseQty', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '单位', width: 50, dataIndex: 'IGADoseUomDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '频次', width: 70, dataIndex: 'IGAFreqDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '用法', width: 70, dataIndex: 'IGAInstrucDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '疗程', width: 70, dataIndex: 'IGADuratDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '数量', width:50, dataIndex: 'IGAPackQty', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '首选<br>医嘱', width: 50, dataIndex: 'IGADefault', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IGADefault = rd.get("IGADefault");
					if (IGADefault == '1') {
						return "<IMG src='../scripts/dhccpw/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhccpw/img/unchecked.gif'>";
					}
				}
			}
			,{header: '是否<br>有效', width: 50, dataIndex: 'IGAIsActive', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IGAIsActive = rd.get("IGAIsActive");
					if (IGAIsActive == '1') {
						return "<IMG src='../scripts/dhccpw/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhccpw/img/unchecked.gif'>";
					}
				}
			}
			,{header: '备注', width: 100, dataIndex: 'IGAResume', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort'
		,layout : 'border'
		,items:[
			{
				region: 'south',
				height: 70,
				layout : 'form',  //fix IE11下类型/频次等不显示
				frame : true,
				labelWidth : 70,
				buttonAlign : 'center',
				items : [
					{
						layout : 'column',
						items : [
							{
								width:150
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 50
								,items: [obj.cboOECPriority]
							},{
								width:150
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 50
								,items: [obj.txtLinkNo]
							},{
								width:300
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 50
								,items: [obj.cboArcim]
							},{
								width:120
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 50
								,items: [obj.txtDoseQty]
							},{
								width:120
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 50
								,items: [obj.cboDoseUom]
							}
						]
					},{
						layout : 'column',
						items : [
							{
								width:150
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 50
								,items: [obj.cboPHCFreq]
							},{
								width:150
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 50
								,items: [obj.cboPHCInstruc]
							},{
								width:150
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 50
								,items: [obj.cboPHCDuration]
							},{
								width:150
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 50
								,items: [obj.txtPackQty]
							},{
								width:240
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 50
								,items: [obj.txtItmResume]
							}
						]
					}
				]
			}
			,obj.gridLnkArcim
		]
	});
	
	obj.gridLnkArcimStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCCPW.MRC.FORM.LnkArcimSrv';
		param.QueryName = 'QryLnkArcimByItm';
		param.Arg1 = FormItemID;
		param.ArgCnt = 1;
	});
	
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}