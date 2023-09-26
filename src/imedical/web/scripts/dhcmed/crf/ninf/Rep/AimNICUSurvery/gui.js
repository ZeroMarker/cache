
function InitViewport1(){
	var obj = new Object();
	
	obj.AdminPower  = '0';
	if (typeof tDHCMedMenuOper != 'undefined')
	{
		if (typeof tDHCMedMenuOper['Admin'] != 'undefined')
		{
			obj.AdminPower  = tDHCMedMenuOper['Admin'];
		}
	}
	
	obj.GridColumnHeaderGroup = new Ext.ux.grid.ColumnHeaderGroup({
		rows: [[
			{header: '',align: 'center',colspan: 1}
			,{header: 'BW<=1000g',align: 'center',colspan: 4}
			,{header: 'BW 1001g~1500g',align: 'center',colspan: 4}
			,{header: 'BW 1501g~2500g',align: 'center',colspan: 4}
			,{header: 'BW>2500g',align: 'center',colspan: 4}
		]]
	});
	
	obj.NICUSurveryGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.NICUSurveryGridPanelStore = new Ext.data.Store({
		proxy: obj.NICUSurveryGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Index'
		}, 
		[
			{name: 'Index', mapping : 'Index'}
			,{name: 'ANISID', mapping : 'ANISID'}
			,{name: 'LocID', mapping: 'LocID'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'SurveryDate', mapping: 'SurveryDate'}
			,{name: 'SurveryDay', mapping: 'SurveryDay'}
			,{name: 'ANISItem1', mapping: 'ANISItem1'}
			,{name: 'ANISItem2', mapping: 'ANISItem2'}
			,{name: 'ANISItem3', mapping: 'ANISItem3'}
			,{name: 'ANISItem4', mapping: 'ANISItem4'}
			,{name: 'ANISItem5', mapping: 'ANISItem5'}
			,{name: 'ANISItem6', mapping: 'ANISItem6'}
			,{name: 'ANISItem7', mapping: 'ANISItem7'}
			,{name: 'ANISItem8', mapping: 'ANISItem8'}
			,{name: 'ANISItem9', mapping: 'ANISItem9'}
			,{name: 'ANISItem10', mapping: 'ANISItem10'}
			,{name: 'ANISItem11', mapping: 'ANISItem11'}
			,{name: 'ANISItem12', mapping: 'ANISItem12'}
			,{name: 'ANISItem13', mapping: 'ANISItem13'}
			,{name: 'ANISItem14', mapping: 'ANISItem14'}
			,{name: 'ANISItem15', mapping: 'ANISItem15'}
			,{name: 'ANISItem16', mapping: 'ANISItem16'}
		])
	});
	obj.NICUSurveryGridPanel = new Ext.grid.EditorGridPanel({
		id : 'NICUSurveryGridPanel'
		,store : obj.NICUSurveryGridPanelStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,clicksToEdit : 1
		,columnLines : true
        ,stripeRows : true
		,region : 'center'
		,plugins: obj.GridColumnHeaderGroup
		,columns: [
			//{header: '日期', width: 50, dataIndex: 'SurveryDay', sortable: true, align: 'center'}
			{header: '日期'
			, width: 50
			, dataIndex: 'SurveryDay'
			, align: 'center'
			 ,renderer : function(v, m, rd, r, c, s){
				var SurveryDate = rd.get("SurveryDate");
				var LocID = rd.get("LocID");
				return " <a href='#' onclick='StrAdmLookUpHeader(\"" + SurveryDate + "\",\"" + LocID + "\");'>" + v + "</a>";
				}
			}
			,{header: '新<br>住<br>院<br>新<br>生<br>儿<br>数', width: 50, dataIndex: 'ANISItem1', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem1',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '已<br>住<br>新<br>生<br>儿<br>数', width: 50, dataIndex: 'ANISItem2', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem2',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '脐<br>/<br>中<br>心<br>静<br>脉<br>插<br>管<br>数', width: 50, dataIndex: 'ANISItem3', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem3',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '使<br>用<br>呼<br>吸<br>机<br>数', width: 50, dataIndex: 'ANISItem4', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem4',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '新<br>住<br>院<br>新<br>生<br>儿<br>数', width: 50, dataIndex: 'ANISItem5', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem5',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '已<br>住<br>新<br>生<br>儿<br>数', width: 50, dataIndex: 'ANISItem6', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem6',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '脐<br>/<br>中<br>心<br>静<br>脉<br>插<br>管<br>数', width: 50, dataIndex: 'ANISItem7', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem7',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '使<br>用<br>呼<br>吸<br>机<br>数', width: 50, dataIndex: 'ANISItem8', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem8',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '新<br>住<br>院<br>新<br>生<br>儿<br>数', width: 50, dataIndex: 'ANISItem9', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem9',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '已<br>住<br>新<br>生<br>儿<br>数', width: 50, dataIndex: 'ANISItem10', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem10',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '脐<br>/<br>中<br>心<br>静<br>脉<br>插<br>管<br>数', width: 50, dataIndex: 'ANISItem11', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem11',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '使<br>用<br>呼<br>吸<br>机<br>数', width: 50, dataIndex: 'ANISItem12', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem12',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '新<br>住<br>院<br>新<br>生<br>儿<br>数', width: 50, dataIndex: 'ANISItem13', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem13',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '已<br>住<br>新<br>生<br>儿<br>数', width: 50, dataIndex: 'ANISItem14', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem14',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '脐<br>/<br>中<br>心<br>静<br>脉<br>插<br>管<br>数', width: 50, dataIndex: 'ANISItem15', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem15',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '使<br>用<br>呼<br>吸<br>机<br>数', width: 50, dataIndex: 'ANISItem16', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtANISItem16',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.dtSurveryYYMM = new Ext.form.DateField({
		id : 'dtSurveryYYMM'
		,fieldLabel : '调查月份'
		,plugins: 'monthPickerPlugin'
		,format :'Y-m'
		,editable : false
		,width : 100
		,anchor : '95%'
		,value : new Date().dateFormat('Y-m')
	});
	
	obj.cboSurveryLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboSurveryLocStore = new Ext.data.Store({
		proxy: obj.cboSurveryLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'LocRowId'
		}, 
		[
			{name: 'LocRowId', mapping: 'LocRowId'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'LocDesc1', mapping: 'LocDesc1'}
		])
	});
    obj.cboSurveryLoc = new Ext.form.ComboBox({
		id : 'cboSurveryLoc'
		,fieldLabel : '调查科室'
		,store : obj.cboSurveryLocStore
		,displayField : 'LocDesc1'
		,valueField : 'LocRowId'
		,editable : true
		,minChars : 2
		,triggerAction : 'all'
		,mode: 'local'
		,anchor:'95%'
	});
    
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-edit'
		,width: 80
		,text : '保存'
	});
	
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-Export'
		,width: 80
		,text : '导出Excel'
	});
	
	obj.btnExportMonth = new Ext.Button({
		id : 'btnExportMonth'
		,iconCls : 'icon-Export'
		,width: 80
		,text : '导出月报表'
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.NICUSurveryGridPanel
			,{
				layout: 'column'
				,region : 'north'
				,height : 60
				,title : '新生儿病房日志'
				,frame : true
				,items: [
					{
						width:180
						,layout: 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.dtSurveryYYMM]
					},{
						columnWidth:1
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,boxMinWidth : 100
						,boxMaxWidth : 300
						,items: [obj.cboSurveryLoc]
					},{
						width:100
						,layout: 'form'
						,items: [obj.btnSave]
					}
					,{
						width:100
						,layout: 'form'
						,items: [obj.btnExport]
					}
					,{
						width:100
						,layout: 'form'
						,items: [obj.btnExportMonth]
					}
				]
			}
		]
	});
	
	obj.NICUSurveryGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.AimNICUSurvery';
		param.QueryName = 'QryANISByMonth';
		param.Arg1 = obj.dtSurveryYYMM.getRawValue();
		param.Arg2 = obj.cboSurveryLoc.getValue();
		param.ArgCnt = 2;
	});
	
    obj.cboSurveryLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Srv.CommonCls';
			param.QueryName = 'QueryLoction';
			param.Arg1 = obj.cboSurveryLoc.getRawValue();
			param.Arg2 = '';
			param.Arg3 = '';
			param.Arg4 = 'W';
			param.Arg5 = '';
			param.Arg6 = '';
			param.ArgCnt = 6;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

