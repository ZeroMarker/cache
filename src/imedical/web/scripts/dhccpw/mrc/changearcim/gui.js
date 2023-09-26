var objScreen = new Object();
function InitviewScreen(){
    var obj = objScreen;
	
	obj.cboArcim = Common_ComboToARCIM("cboArcim","名称");  //医嘱项
	obj.txtDoseQty = Common_NumberField("txtDoseQty","剂量",0,1,2); //允许输入小数点后两位
	obj.cboDoseUom = Common_ComboToDoseUom("cboDoseUom","单位",'cboArcim');
	obj.cboPHCFreq = Common_ComboToPHCFreq("cboPHCFreq","频次");
	obj.cboPHCInstruc = Common_ComboToPHCInstruc("cboPHCInstruc","用法");
	obj.cboPHCDuration = Common_ComboToPHCDuration("cboPHCDuration","疗程");
	obj.txtPackQty = Common_NumberField("txtPackQty","数量",0,0);
	obj.txtItmResume = Common_TextField("txtItmResume","备注");
	obj.chkSelectAll = Common_Checkbox("chkSelectAll","全选");
	obj.cboPathWayType = Common_ComboToPathWayType("cboPathWayType","路径类型");
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,text : '<span>替换</span>'
		,width : 70
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,text : '<span>查询</span>'
		,width : 60
	});
	
	obj.gridLnkArcimStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridLnkArcimStore = new Ext.data.GroupingStore({
		proxy: obj.gridLnkArcimStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IGAIndex'
		},
		[
			{name: 'IsChecked', mapping: 'IsChecked'}
			,{name: 'IGAIndex', mapping: 'IGAIndex'}
			,{name: 'CPWDID', mapping : 'CPWDID'}
			,{name: 'CPWDDesc', mapping : 'CPWDDesc'}
			,{name: 'IGGeneDesc', mapping : 'IGGeneDesc'}
			,{name: 'IGPriorityDesc', mapping: 'IGPriorityDesc'}
			,{name: 'IGIsMain', mapping: 'IGIsMain'}
			,{name: 'IGAArcimDesc', mapping: 'IGAArcimDesc'}
			,{name: 'IGAPackQty', mapping: 'IGAPackQty'}
			,{name: 'IGAFreqDesc', mapping: 'IGAFreqDesc'}
			,{name: 'IGADuratDesc', mapping: 'IGADuratDesc'}
			,{name: 'IGAInstrucDesc', mapping: 'IGAInstrucDesc'}
			,{name: 'IGADoseQty', mapping: 'IGADoseQty'}
			,{name: 'IGADoseUomDesc', mapping: 'IGADoseUomDesc'}
			,{name: 'IGAResume', mapping: 'IGAResume'}
			,{name: 'IGADefault', mapping: 'IGADefault'}
			,{name: 'IGAIsActive', mapping: 'IGAIsActive'}
			,{name: 'UpdateDate', mapping: 'UpdateDate'}
			,{name: 'UpdateUser', mapping: 'UpdateUser'}
			,{name: 'IGASign', mapping: 'IGASign'}
		])
		,sortInfo:{field: 'CPWDDesc', direction: "ASC"}
		,groupField:'CPWDDesc'
	});
	obj.gridLnkArcim = new Ext.grid.GridPanel({
		id : 'gridLnkArcim'
		,store : obj.gridLnkArcimStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,bbar : [{style:'width:50px;',xtype:'label'},"路径类型",obj.cboPathWayType,{style:'width:50px;',xtype:'label'},obj.btnQuery,'->',obj.chkSelectAll,'全选',{style:'width:50px;',xtype:'label'},obj.btnUpdate,{style:'width:50px;',xtype:'label'}]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '选择', width: 50, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhccpw/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhccpw/img/unchecked.gif'>";
					}
				}
			}
			,{header: '名称', width: 150, dataIndex: 'IGAArcimDesc', sortable: false, menuDisabled:true, align: 'left',
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
						return "是";
					} else {
						return "否";
					}
				}
			}
			,{header: '是否<br>有效', width: 50, dataIndex: 'IGAIsActive', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IGAIsActive = rd.get("IGAIsActive");
					if (IGAIsActive == '1') {
						return "是";
					} else {
						return "否";
					}
				}
			}
			,{header: '备注', width: 60, dataIndex: 'IGAResume', sortable: false, menuDisabled:true, align: 'center',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '更新日期', width: 80, dataIndex: 'UpdateDate', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '更新人', width: 60, dataIndex: 'UpdateUser', sortable: false, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '路径名称', width: 0, dataIndex: 'CPWDDesc', sortable: false, menuDisabled:true, hidden:true, align: 'center'}
		]
		,view: new Ext.grid.GroupingView({
			forceFit:true,
			groupTextTpl: '路径:{[values.rs[0].get("CPWDDesc")]}(共{[values.rs.length]}个)',
			groupByText:'依本列分组'
		})
    });
	
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort'
		,layout : 'border'
		,items:[
			{
				region: 'south',
				height: 70,
				layout : 'form',  //fix IE11下名称/频次等不显示
				frame : true,
				labelWidth : 70,
				buttonAlign : 'center',
				items : [
					{
						layout : 'column',
						items : [
							{
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
								,items: [obj.txtPackQty]
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
								width:120
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 50
								,items: [obj.cboPHCDuration]
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
		param.ClassName = 'DHCCPW.MRC.FORM.LnkArcimBat';
		param.QueryName = 'QryLnkArcimList';
		param.Arg1 = obj.cboArcim.getValue();
		param.Arg2 = '';
		param.Arg3 = obj.cboPathWayType.getRawValue();
		param.ArgCnt = 3;
	});
	
	InitviewScreenEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}