
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
	
	obj.ICUSurveryGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ICUSurveryGridPanelStore = new Ext.data.Store({
		proxy: obj.ICUSurveryGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Index'
		}, 
		[
			{name: 'Index', mapping : 'Index'}
			,{name: 'AISID', mapping : 'AISID'}
			,{name: 'LocID', mapping: 'LocID'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'SurveryDate', mapping: 'SurveryDate'}
			,{name: 'SurveryDay', mapping: 'SurveryDay'}
			,{name: 'AISItem1', mapping: 'AISItem1'}
			,{name: 'AISItem2', mapping: 'AISItem2'}
			,{name: 'AISItem3', mapping: 'AISItem3'}
			,{name: 'AISItem4', mapping: 'AISItem4'}
			,{name: 'AISItem5', mapping: 'AISItem5'}
			,{name: 'AISItem6', mapping: 'AISItem6'}
			,{name: 'AISItem7', mapping: 'AISItem7'}
			,{name: 'AISItem8', mapping: 'AISItem8'}
			,{name: 'AISItem9', mapping: 'AISItem9'}
			,{name: 'AISItem10', mapping: 'AISItem10'}
			,{name: 'AISItem11', mapping: 'AISItem11'}
			,{name: 'AISItem12', mapping: 'AISItem12'}
			,{name: 'AISItem13', mapping: 'AISItem13'}
			,{name: 'AISItem14', mapping: 'AISItem14'}
			,{name: 'AISItem15', mapping: 'AISItem15'}
			,{name: 'AISItem16', mapping: 'AISItem16'}
			,{name: 'AISItem17', mapping: 'AISItem17'}
			,{name: 'AISItem18', mapping: 'AISItem18'}
			,{name: 'AISItem19', mapping: 'AISItem19'}
			,{name: 'AISItem20', mapping: 'AISItem20'}
		])
	});
	obj.ICUSurveryGridPanel = new Ext.grid.EditorGridPanel({
		id : 'ICUSurveryGridPanel'
		,store : obj.ICUSurveryGridPanelStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,clicksToEdit : 1
		,columnLines : true
        ,stripeRows : true
		,region : 'center'
		,columns: [
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
			,{header: '新住进<br>患者数', width: 100, dataIndex: 'AISItem1', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAISItem1',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '住在<br>患者数', width: 150, dataIndex: 'AISItem2', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAISItem2',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '留置导尿管<br>患者数', width: 150, dataIndex: 'AISItem3', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAISItem3',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			/*,{header: '泌尿道插管相关<br>泌尿道感染人数', width: 150, dataIndex: 'AISItem13', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAISItem13',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }*/
			,{header: '中心静脉插管<br>患者数', width: 150, dataIndex: 'AISItem4', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAISItem4',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			/*,{header: '血管导管相关<br>血流感染人数', width: 150, dataIndex: 'AISItem14', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAISItem14',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }*/
			,{header: '使用呼吸机<br>患者数', width: 150, dataIndex: 'AISItem5', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAISItem5',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			/*,{header: '呼吸机相关<br>肺炎感染人数', width: 150, dataIndex: 'AISItem15', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAISItem15',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }*/
			,{header: '手术台数', width: 150, dataIndex: 'AISItem6', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAISItem6',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			/*
			,{header: '气管切开<br>患者数', width: 150, dataIndex: 'AISItem7', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAISItem7',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '气管切开<br>感染人数', width: 150, dataIndex: 'AISItem17', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAISItem17',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '气管插管<br>患者数', width: 150, dataIndex: 'AISItem8', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAISItem8',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }
			,{header: '气管插管<br>感染人数', width: 150, dataIndex: 'AISItem18', sortable: false, menuDisabled:true, align: 'center',
                editor: new Ext.form.NumberField({
                	id: 'txtAISItem18',
                    allowDecimals : false,          //不允许输入小数  
					allowNegative : false,          //不允许输入负数  
					nanText :'请输入有效的整数',    //无效数字提示  
                    maxValue: 100000
                })
            }*/
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
	
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"NINF");		//add by yanjf 20140417
    obj.cboSurveryLoc = Common_ComboToLoc("cboSurveryLoc","调查科室","W","","","cboSSHosp");	//add by yanjf 20140417
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-edit'
		,width: 80
		,text : '保存'
	});
	
	obj.btnInitData = new Ext.Button({
		id : 'btnInitData'
		,iconCls : 'icon-update'
		,width: 80
		,text : '初始化数据'
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
			obj.ICUSurveryGridPanel
			,{
				layout: 'column'
				,region : 'north'
				,height : 60
				,title : 'ICU患者日志'
				,frame : true
				,items: [
					{
						width:180
						,layout: 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.dtSurveryYYMM]
					},{
						width:200
						,layout: 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.cboSSHosp]
					},{
						width : 20
					},{
						columnWidth:1
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,boxMinWidth : 100
						,boxMaxWidth : 300
						,items: [obj.cboSurveryLoc]
					},{
						width : 20
					},{
						width:100
						,layout: 'form'
						,items: [obj.btnSave]
					},{
						width:100
						,layout: 'form'
						,items: [obj.btnExport]
					},{
						width:100
						,layout: 'form'
						,items: [obj.btnInitData]
					}
				]
			}
		]
	});
	
	obj.ICUSurveryGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.Rep.AimICUSurvery';
		param.QueryName = 'QryAISByMonth';
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

