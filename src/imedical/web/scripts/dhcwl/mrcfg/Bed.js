(function() {
	Ext.ns("DHCMRTJ.Bed");
})();
DHCMRTJ.Bed.ShowWin = function() {
	// 右键菜单定义
	Ext.QuickTips.init();
	// 科室和病区单选标记
	var selectRadioLocOrWard = "Loc";
	// 列模型
	var selectdDataIds = Array();

	var columnModel = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
				align : 'center',
				header : ' ID',
				dataIndex : 'ID',
				sortable : true,
				width : 50,
				sortable : true
			}, {
				align : 'center',
				header : ' 日 期 ',
				dataIndex : 'Date',
				width : 100,
				sortable : true
			}, {
				align : 'left',
				header : ' 名 称 ',
				dataIndex : 'LocOrWard',
				width : 150,
				sortable : true
			}, {
				align : 'center',
				header : ' 编制床位数 ',
				dataIndex : 'GDNum',
				width : 100,
				sortable : true
			}, {
				align : 'center',
				header : ' 实有床位数 ',
				dataIndex : 'SYNum',
				width : 100,
				sortable : true
			}, {
				align : 'center',
				header : ' 备注床位数',
				dataIndex : 'BZNum',
				width : 100,
				sortable : true
			}]);

	var store = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
			url : 'dhcwl/mrcfg/mrtjservice.csp?action=mulSearch&onePage=1&LocOrWardType='
					+ selectRadioLocOrWard
		}),
		reader : new Ext.data.JsonReader({
					totalProperty : 'totalNum',
					root : 'root',
					fields : [{
								name : 'ID'
							}, {
								name : 'Date'
							}, {
								name : 'LocOrWard'
							}, {
								name : 'GDNum'
							}, {
								name : 'SYNum'
							}, {
								name : 'BZNum'
							}]
				})
	});
	store.reload();
	var record = Ext.data.Record.create([{
				name : 'ID',
				type : 'int'
			}, {
				name : 'Date',
				type : 'string'
			}, {
				name : 'LocOrWard',
				type : 'string'
			}, {
				name : 'GDNum',
				type : 'int'
			}, {
				name : 'SYNum',
				type : 'int'
			}, {
				name : 'BZNum',
				type : 'int'
			}]);

	var pageTool = new Ext.PagingToolbar({
		pageSize : 20,
		store : store,
		displayInfo : true,
		displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg : "没有记录",
		listeners : {
			'change' : function(pt, page) {
				var id = "", j = 0, found = false, storeLen = selectdDataIds.length;
				for (var i = store.getCount() - 1; i > -1; i--) {
					id = store.getAt(i).get("ID");
					found = false;
					for (j = storeLen - 1; j > -1; j--) {
						if (selectdDataIds[j] == id)
							found = true;
					}
					if (found) {
						BedDataGrid.selectRow(i, true, false);
					}
				}
			},
			'beforechange' : function(th, param) {
				store.proxy
						.setUrl(encodeURI('dhcwl/mrcfg/mrtjservice.csp?action=mulSearch&onePage=1&LocOrWardType='
								+ selectRadioLocOrWard));
			}
		}
	});

	var BedDataGrid = new Ext.grid.GridPanel({
		id : "BedDataGrid",
		resizeAble : true,
		// autoHeight:true,
		height : 485,
		loadMask : true,
		enableColumnResize : true,
		store : store,
		cm : columnModel,
		sm : new Ext.grid.RowSelectionModel(),
		bbar : pageTool,
		listeners : {
			'contextmenu' : function(event) {
				event.preventDefault();
				var sm = this.getSelectionModel();
				var record = sm.getSelected();
				if (record) {
					var id = record.get("ID");
					var record = sm.getSelected();
				}
			},
			'click' : function(ele, event) {
				var sm = BedDataGrid.getSelectionModel();
				if (!sm)
					return;
				var record = sm.getSelected();
				if (!record)
					return;
				var ID = record.get("ID");
				var LocWardDesc = record.get('LocOrWard');
				Ext.Ajax.request({
					method : 'POST',
					url : encodeURI('dhcwl/mrcfg/mrtjservice.csp?action=GetLocWardType&GetLocWardTypebyID='
							+ ID),
					success : function(response) {
						var Text = dhcwl.mkpi.Util
								.trimLeft(response.responseText);
						var ArrayStr = Text.split('||');
						var LocWardType = ArrayStr[1];
						var LocWardCode = ArrayStr[0]; // CT_Loc的Code

						if (LocWardType == "W") {
							LocOrWardRadioGroup.setValue("Ward");
						}
						if (LocWardType == "E") {
							LocOrWardRadioGroup.setValue("Loc");
						}

						LocOrWardCombox.setValue(LocWardDesc);
						BedForm.getForm().loadRecord(record);
						addSelectedDataId(ID);
					}
				});
			}
		}
	});
	var DateField = new Ext.form.DateField({
				xtype : 'datefield',
				//format : 'Y-m-d',
				fieldLabel : '日 期',
				name : 'Date',
				id : 'Date',
				invalidText : '无效日期格式',
				anchor : '90%',
				value : dhcwl.mkpi.Util.nowDate()
			});
	var checkboxModule = new Ext.form.Checkbox({
				id : "IsActive",
				autoScroll : false,
				width : 20,
				anchor : "90%",
				fieldLabel : '加入日期'
				//hideLabel : true
			});
	var LocRadio = new Ext.form.Radio({
				boxLabel : "科室",
				name : "LocOrWard",
				inputValue : "Loc",
				checked : true
			});
	var WardRadio = new Ext.form.Radio({
				boxLabel : "病区",
				name : "LocOrWard",
				inputValue : "Ward"
			});
	var LocOrWardRadioGroup = new Ext.form.RadioGroup({
		        autoHeight: true,
				width :150,
				hideLabel : true, // 隐藏RadioGroup标签
				items : [LocRadio, WardRadio]
			});

	LocOrWardRadioGroup.on('change', function(rdgroup, checked) {
		// /切换科室之前，初始化pagetool
		store.load({
					params : {
						start : 0,
						limit : 20,
						onePage : 1
					}
				});
		// /pageTool.changePage(0); 都是初始化操作，存在2个动作
		selectRadioLocOrWard = checked.getRawValue();
		// alert(selectRadioLocOrWard);
		// /显示下拉科室病区内容
		LocOrWardStore.proxy = new Ext.data.HttpProxy({
					url : 'dhcwl/mrcfg/mrtjservice.csp?action=GetLocWard&GetLocOrWard='
							+ selectRadioLocOrWard
				});
		LocOrWardStore.reload();
		// 切换科室病区情况数据
		checkboxModule.setValue('');
		LocOrWardCombox.setValue('');
		GDNum.setValue('');
		SYNum.setValue('');
		BZNum.setValue('');
		selectdDataIds.length = 0;
		// /切换科室病区后内容跟着显示科室和病区的
		store.proxy
				.setUrl(encodeURI("dhcwl/mrcfg/mrtjservice.csp?action=mulSearch&LocOrWardType="
						+ selectRadioLocOrWard + "&onePage=1"));
		store.reload();
		BedDataGrid.show();

	});

	var LocOrWardStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : 'dhcwl/mrcfg/mrtjservice.csp?action=GetLocWard&GetLocOrWard='
							+ selectRadioLocOrWard
				}),
		reader : new Ext.data.ArrayReader({}, [{
							name : 'Code'
						}, {
							name : 'Desc'
						}])
	});

	LocOrWardStore.reload();

	var LocOrWardCombox = new Ext.form.ComboBox({
				id : 'LocOrWardCombox',
				hiddenName : 'Code',
				width : 120,
				editable : true,
				xtype : 'combo',
				mode : 'local',
				typeAhead : true,
				fieldLabel : '名 称',
				triggerAction : 'all',
				emptyText : '',
				anchor : '100%',
				displayField : 'Desc',
				valueField : 'Code',
				store : LocOrWardStore,
				listeners : {
					'select' : function(combox) {
						this.setValue(combox.value);
					}
				}
			});
	var GDNum = new Ext.form.NumberField({
				fieldLabel : '固定床位数',
				name : 'GDNum',
				id : 'GDNum',
				anchor : '90%',
				allowDecimals : false, // 不允许输入小数
				nanText : '请输入有效整数', // 无效数字提示
				allowNegative : false, // 不允许输入负数
				maxValue : 200, // 最大值
				maxText : '值太大',
				minValue : 0, // 最小值
				minText : '值太小'
			});
	var SYNum = new Ext.form.NumberField({
				fieldLabel : '实有床位数',
				name : 'SYNum',
				id : 'SYNum',
				anchor : '90%',
				allowDecimals : false, // 不允许输入小数
				nanText : '请输入有效整数', // 无效数字提示
				allowNegative : false, // 不允许输入负数
				maxValue : 200, // 最大值
				maxText : '值太大',
				minValue : 0, // 最小值
				minText : '值太小'
			});
	var BZNum = new Ext.form.NumberField({
				fieldLabel : '备注床位数',
				name : 'BZNum',
				id : 'BZNum',
				anchor : '90%',
				allowDecimals : false, // 不允许输入小数
				nanText : '请输入有效整数', // 无效数字提示
				allowNegative : false, // 不允许输入负数
				maxValue : 200, // 最大值
				maxText : '值太大',
				minValue : 0, // 最小值
				minText : '值太小'
			});

	var pnRow1 = new Ext.Panel({
				border : false,
				layout : 'column',
				items : [new Ext.Panel({
									columnWidth : .15,
									layout : 'form',
									border : false,
									labelWidth : 40,
									labelAlign : 'right',
									items : [DateField]
								}), new Ext.Panel({
									columnWidth : .15,
									layout : 'form',
									border : false,
									labelWidth : 40,
									labelAlign : 'right',
									items : [checkboxModule]
								})]
			});
	var pnRow2 = new Ext.Panel({
				border : false,
				layout : 'column',
				items : [new Ext.Panel({
									columnWidth : .1,
									layout : 'form',
									border : false,
									labelWidth : 40,
									labelAlign : 'right',
									items : [LocOrWardRadioGroup]
								}), new Ext.Panel({
									columnWidth : .25,
									layout : 'form',
									border : false,
									labelWidth : 40,
									labelAlign : 'right',
									items : [LocOrWardCombox]
								}), new Ext.Panel({
									columnWidth : .12,
									layout : 'form',
									border : false,
									labelWidth : 65,
									labelAlign : 'right',
									items : [GDNum]
								}), new Ext.Panel({
									columnWidth : .12,
									layout : 'form',
									border : false,
									labelWidth : 65,
									labelAlign : 'right',
									items : [SYNum]
								}), new Ext.Panel({
									columnWidth : .12,
									layout : 'form',
									border : false,
									labelWidth : 65,
									labelAlign : 'right',
									items : [BZNum]
								})]
			});

	var BedForm = new Ext.FormPanel({
		labelAlign : 'right',
		labelWidth : 75,
		region : 'north',
		frame : true,
		bodyStyle : 'padding:10px',
		layout : 'column',
		items:[
		{
			columnWidth : .25,
			layout : 'form',
			defaultType : 'textfield',
			items : [DateField,GDNum]
		},{
			columnWidth : .25,
			layout : 'form',
			defaultType : 'textfield',
			items : [checkboxModule,SYNum]
		},{
			columnWidth : .25,
			layout : 'form',
			items : [LocOrWardRadioGroup,BZNum]
		},{
			columnWidth : .2,
			layout : 'form',
			items : LocOrWardCombox
		}		
		],
		tbar : new Ext.Toolbar([{
			cls : 'align:right',
			text: '<span style="line-Height:1">保存</span>',	
			icon   : '../images/uiimages/filesave.png',
			handler : function() {
				var cursor = Math.ceil((pageTool.cursor + pageTool.pageSize)
						/ pageTool.pageSize);
				var paraValues;
				var Date = DateField.getRawValue();
				var LocOrWardType = selectRadioLocOrWard;
				var LocCode = LocOrWardCombox.getValue();
				var LocDesc = LocOrWardCombox.getRawValue();
				var GDNum = Ext.get('GDNum').getValue();
				var SYNum = Ext.get('SYNum').getValue();
				var BZNum = Ext.get('BZNum').getValue();
				if (Date == "") {
					alert("日期不能为空！");
					return;
				}
				if (LocOrWardType == "" || LocCode == "" || LocDesc == "") {
					alert("科室病区不能为空！");
					return;
				}
				if (GDNum == "" || SYNum == "" || BZNum == "") {
					alert("床位数不能为空！");
					return;
				}

				paraValues = 'Date=' + Date + '&LocOrWardType=' + LocOrWardType
						+ '&LocCode=' + LocCode;
				paraValues += '&LocDesc=' + LocDesc + '&GDNum=' + GDNum
						+ '&SYNum=' + SYNum + '&BZNum=' + BZNum;
				// alert(paraValues);
				dhcwl.mkpi.Util
						.ajaxExc('dhcwl/mrcfg/mrtjservice.csp?action=add&'
								+ paraValues);
				store.proxy
						.setUrl(encodeURI("dhcwl/mrcfg/mrtjservice.csp?action=mulSearch&LocOrWardType="
								+ selectRadioLocOrWard
								+ "&onePage=1&start="
								+ cursor + "&limit=" + 20));
				store.reload();
				// alert(selectRadioLocOrWard);
				pageTool.cursor = 0;
				pageTool.doLoad(pageTool.pageSize * (cursor - 1));
				return;
			}
		}, '-', {
			cls : 'align:right',
			text: '<span style="line-Height:1">查询</span>',
			icon   : '../images/uiimages/search.png',	
			handler : function() {
				var Date = DateField.getRawValue();
				var IsActive = checkboxModule.getValue();
				var LocOrWardType = selectRadioLocOrWard;
				var LocCode = LocOrWardCombox.getValue();
				var LocDesc = LocOrWardCombox.getRawValue();

				paraValues = 'Date=' + Date + '&IsActive=' + IsActive
						+ '&LocOrWardType=' + LocOrWardType + '&LocCode='
						+ LocCode;
				paraValues += '&LocDesc=' + LocDesc;
				// alert(paraValues);
				store.proxy
						.setUrl(encodeURI("dhcwl/mrcfg/mrtjservice.csp?action=mulSearch&"
								+ paraValues + "&onePage=1"));
				store.load();
				BedDataGrid.show();
			}
		}, '-', {
			cls : 'align:right',
text: '<span style="line-Height:1">清空</span>',					
icon   : '../images/uiimages/clearscreen.png',
			handler : function() {
				DateField.setValue('');
				checkboxModule.setValue('');
				LocOrWardCombox.setValue('');
				GDNum.setValue('');
				SYNum.setValue('');
				BZNum.setValue('');
				selectdDataIds.length = 0;
			}
		}])
	});
	var MRBedWin = new Ext.Panel({
				title : '床位维护',
				layout : 'border',
				items : [{
							region : 'north',
							height : 130,
							//autoScroll : true,
							layout:'fit',
							items : BedForm
						}, {
							region : 'center',
							autoScroll : true,
							items : BedDataGrid,
							layout:'fit'
						}],
				listeners : {
					"resize" : function(win, width, height) {
						BedDataGrid.setHeight(height - 150);
						BedDataGrid.setWidth(width - 15);
					}
				}
			});
	store.load({
				params : {
					start : 0,
					limit : 20,
					onePage : 1
				}
			});
	this.getMRBedWin = function() {
		return MRBedWin;
	}
	function addSelectedDataId(id) {
		if (!id || id == "")
			return;
		for (var i = selectdDataIds.length - 1; i > -1; i--) {
			if (selectdDataIds[i] == id)
				return;
		}
		// selectdDataIds.push(id);
	}
}
// 用于设置表单中某一个字段的值
DHCMRTJ.Bed.ShowWin.prototype.setBedFormFile = function(filed) {
	this.getBedForm().getForm().setValues(filed);
}
DHCMRTJ.Bed.ShowWin.prototype.refresh = function() {
	this.getStore().proxy
			.setUrl(encodeURI("dhcwl/mrcfg/mrtjservice.csp?action=mulSearch&LocOrWardType="
					+ selectRadioLocOrWard + "&onePage=1"));
	this.getStore().load();
	this.getBedDataGrid().show();
}