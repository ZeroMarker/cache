
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
	
	/*
	obj.GridColumnHeaderGroup = new Ext.ux.grid.ColumnHeaderGroup({
		rows: [[
			{header: '',align: 'center',colspan: 1}
			,{header: '临床病情等级',align: 'center',colspan: 5}
			,{header: '',align: 'center',colspan: 1}
			,{header: '',align: 'center',colspan: 1}
		]]
	});
	*/
	obj.ICUGradeGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ICUGradeGridPanelStore = new Ext.data.Store({
		proxy: obj.ICUGradeGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'AIGIndex'
		}, 
		[
			{name: 'AIGIndex', mapping : 'AIGIndex'}
			,{name: 'AIGGrade', mapping : 'AIGGrade'}
			,{name: 'AIGScore', mapping: 'AIGScore'}
			,{name: 'AIGItem1', mapping: 'AIGItem1'}
			,{name: 'AIGItem2', mapping: 'AIGItem2'}
			,{name: 'AIGItem3', mapping: 'AIGItem3'}
			,{name: 'AIGItem4', mapping: 'AIGItem4'}
			,{name: 'AIGYear', mapping: 'AIGYear'}
			,{name: 'AIGMonth', mapping: 'AIGMonth'}
			,{name: 'AIGLocID', mapping: 'AIGLocID'}
		])
	});
	obj.ICUGradeGridPanel = new Ext.grid.EditorGridPanel({
		id : 'ICUGradeGridPanel'
		,store : obj.ICUGradeGridPanelStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,clicksToEdit : 1
		,columnLines : true
        ,stripeRows : true
		,region : 'center'
		//,plugins: obj.GridColumnHeaderGroup
		,columns: [
			{header: '临床病情登记', width: 100, dataIndex: 'AIGGrade', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '分值', width: 40, dataIndex: 'AIGScore', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '第1周', width: 60, dataIndex: 'AIGItem1', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAIGItem1',
                    allowDecimals : false,          //不允许输入小数
					allowNegative : false,          //不允许输入负数
					nanText :'请输入有效的整数',    //无效数字提示
                    maxValue: 100000
                })
            }
			,{header: '第2周', width: 60, dataIndex: 'AIGItem2', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAIGItem2',
                    allowDecimals : false,          //不允许输入小数
					allowNegative : false,          //不允许输入负数
					nanText :'请输入有效的整数',    //无效数字提示
                    maxValue: 100000
                })
            }
			,{header: '第3周', width: 60, dataIndex: 'AIGItem3', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAIGItem3',
                    allowDecimals : false,          //不允许输入小数
					allowNegative : false,          //不允许输入负数
					nanText :'请输入有效的整数',    //无效数字提示
                    maxValue: 100000
                })
            }
			,{header: '第4周', width: 60, dataIndex: 'AIGItem4', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAIGItem4',
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
	
	obj.dtGradeYYMM = new Ext.form.DateField({
		id : 'dtGradeYYMM'
		,fieldLabel : '调查月份'
		,plugins: 'monthPickerPlugin'
		,format :'Y-m'
		,editable : false
		,width : 100
		,anchor : '95%'
		,value : new Date().dateFormat('Y-m')
	});
	
	obj.cboGradeLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboGradeLocStore = new Ext.data.Store({
		proxy: obj.cboGradeLocStoreProxy,
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
    obj.cboGradeLoc = new Ext.form.ComboBox({
		id : 'cboGradeLoc'
		,fieldLabel : '调查科室'
		,store : obj.cboGradeLocStore
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
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.ICUGradeGridPanel
			,{
				layout: 'column'
				,region : 'north'
				,height : 60
				,title : 'ICU患者各危险等级登记表'
				,frame : true
				,items: [
					{
						width:180
						,layout: 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.dtGradeYYMM]
					},{
						columnWidth:1
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,boxMinWidth : 100
						,boxMaxWidth : 300
						,items: [obj.cboGradeLoc]
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
				]
			}
		]
	});
	
	obj.ICUGradeGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.AimICUGrade';
		param.QueryName = 'QryAIGByMonth';
		param.Arg1 = obj.dtGradeYYMM.getRawValue();
		param.Arg2 = obj.cboGradeLoc.getValue();
		param.ArgCnt = 2;
	});
	
    obj.cboGradeLocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Srv.CommonCls';
			param.QueryName = 'QueryLoction';
			param.Arg1 = obj.cboGradeLoc.getRawValue();
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

