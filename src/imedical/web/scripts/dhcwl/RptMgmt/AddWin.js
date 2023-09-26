(function(){
	Ext.ns("dhcwl.RptMgmt.AddMain");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.RptMgmt.AddMain=function(pObj){
	var serviceUrl="dhcwl/rptmgmt/addwin.csp";
	var outThis=this;
	var recParam=null;
	
	var comboQueryName=new Ext.form.ComboBox({
				fieldLabel:'主程序query',
				name:'QueryName',
				anchor: '98%',
				emptyText:'报表文件中,数据集配置的query',
				//allowBlank:false,
				mode:'local',
				//emptyText:'请选择搜索类型',
				triggerAction:  'all',
				editable: true,
				displayField:   'description',
				valueField:     'name',
				store:          new Ext.data.JsonStore({
					fields : ['description', 'name'],
					data   : [
						{
							description : 'DHCWL.MKPIService.MKPIQuery.QueryMKPIByDate',
							name: 'DHCWL.MKPIService.MKPIQuery.QueryMKPIByDate'
						}
					]
				})
	});				
	
	var comboSpec=new Ext.form.ComboBox({
				fieldLabel:'统计口径',
				name:'Spec',
				anchor: '98%',
				//allowBlank:false,
				mode:'local',
				//emptyText:'请选择搜索类型',
				triggerAction:  'all',
				editable: true,
				displayField:   'description',
				valueField:     'name',
				store:          new Ext.data.JsonStore({
					fields : ['description', 'name'],
					data   : [
						{description : '医嘱日期',name: '医嘱日期'},
						{description : '结算日期',name: '结算日期'},
						{description : '出院日期',name: '出院日期'},
						{description : '入院日期',name: '入院日期'}
					]
				})
	});				
	
	var comboHisTableName=new Ext.form.ComboBox({
				fieldLabel:'业务表',
				name:'HisTableName',
				anchor: '98%',
				emptyText:'统计过程中,使用到的业务表',
				//allowBlank:false,
				mode:'local',
				//emptyText:'请选择搜索类型',
				triggerAction:  'all',
				editable: true,
				displayField:   'description',
				valueField:     'name',
				store:          new Ext.data.JsonStore({
					fields : ['description', 'name'],
					data   : [
						{description : 'DHC_WorkLoad',name: 'DHC_WorkLoad'},
						{description : 'DHCMRIPDay',name: 'DHCMRIPDay'},
						{description : 'DHCWorkRegReport',name: 'DHCWorkRegReport'},
						{description : 'DHCWL_AnOperation',name: 'DHCWL_AnOperation'},
						{description : 'DHCMRInfo',name: 'DHCMRInfo'},
						{description : 'DHCMRBase',name: 'DHCMRBase'},
						{description : 'PA_Adm',name: 'PA_Adm'},
						{description : 'PA_AdmTransaction',name: 'PA_AdmTransaction'},		
						{description : 'DHC_PatientBill',name: 'DHC_PatientBill'},		
						{description : 'DHC_PatBillOrder',name: 'DHC_PatBillOrder'},		
						{description : 'DHC_PatBillDetails',name: 'DHC_PatBillDetails'}	
					]
				})
				,
				tpl:'<tpl for="."><div class="x-combo-list-item"><span><input type="checkbox" {[values.check?"checked":""]}  value="{[values.description]}" style="height: 12px;"/>&nbsp{description}</span></div></tpl>', 
				onSelect : function(record, index){  
							if(this.fireEvent('beforeselect', this, record, index) !== false){  
				                record.set('check',!record.get('check'));  
				                var str=[];//页面显示的值  
				                var strvalue=[];//传入后台的值  
								this.store.each(function(rc){  
				                    if(rc.get('check')){  
				                        str.push(rc.get('description'));  
				                        strvalue.push(rc.get('name'));  
				                    }  
				                });  
				                this.setValue(str.join());  
				                this.value=strvalue.join();  
				                //this.collapse();  
				                this.fireEvent('select', this, record, index);  
				            }  
				        }  
						

				
	});	


	var comboCSPName=new Ext.form.ComboBox({
				fieldLabel:'CSP名称',
				name:'CSPName',
				anchor: '98%',
				emptyText:'菜单项链接的CSP或组件',
				//allowBlank:false,
				mode:'local',
				//emptyText:'请选择搜索类型',
				triggerAction:  'all',
				editable: true,
				displayField:   'description',
				valueField:     'name',
				store:          new Ext.data.JsonStore({
					fields : ['description', 'name'],
					data   : [
						{description : 'dhccpmrunqianreport.csp',name: 'dhccpmrunqianreport.csp'}
					]
				})
	});		
	
	var addForm= new Ext.FormPanel({
        labelWidth: 75, // label settings here cascade unless overridden
		labelAlign : 'right',
        frame:true,
        layout:'column',  
		border:true,

        items:[  
			{  
				columnWidth:.5, 
				bodyStyle: 'padding:10px;',
				items:[{
					//margins:{top:15, right:15, bottom:15, left:15},
					layout:'form',  
					xtype:'fieldset',  
					////autoHeight:true,  
					defaultType:'textfield',  
					title:'智能报表说明',  
					items:[  
						{
							fieldLabel:'菜单名称',
							name:'MenuName',
							anchor: '98%'
						},{						
							fieldLabel:'当前页面(标题)名称',
							name:'AuxiliaryMenuName',
							emptyText:'页面或表头或标题名称',
							anchor: '98%'
						},{						
							fieldLabel:'raq名称',
							name:'RaqName',
							emptyText:'raq文件名称',
							anchor: '98%'
						},/*
						{
							fieldLabel:'CSP名称',
							name:'CSPName',
							anchor: '98%'
						}*/
						comboCSPName,
						comboQueryName
						/*{						
							fieldLabel:'主程序query',
							name:'QueryName',
							anchor: '98%'
						},*/
						
						
					]  
				},{
					layout:'form',  
					xtype:'fieldset',  
					//autoHeight:true,  
					defaultType:'textfield',  
					title:'条件说明',  
					items:[  
						{
							fieldLabel:'数据条件',
							name:'Filter',
							emptyText:'query或指标取数的过滤条件',
							anchor: '98%'
						},{						
							fieldLabel:'显示条件',
							name:'RowColShow',
							emptyText:'报表展示时的条件(统计子组、统计项目)',
							anchor: '98%'
						}    
					] 					
					
					
					
				}]
			},{  
				columnWidth:.5, 
				bodyStyle: 'padding:10px;',
				items:[{
					layout:'form',  
					xtype:'fieldset',  
					//autoHeight:true,  
					defaultType:'textfield',  
					title:'数据说明',  
					items:[  
						/*
						{
							fieldLabel:'统计口径',
							name:'Spec',
							anchor: '98%'
						}*/
						comboSpec,
						/*{						
							fieldLabel:'业务表',
							name:'HisTableName',
							anchor: '98%'
						}
						*/
						comboHisTableName,
						{						
							fieldLabel:'指标',
							name:'KPIName',
							emptyText:'使用到的指标编码',
							anchor: '98%'
						}    
					]  
				},{
					layout:'form',  
					xtype:'fieldset',  
					//autoHeight:true,  
					defaultType:'textfield',  
					title:'关系人',  
					items:[  
						{
							fieldLabel:'高级客户',
							name:'AdvUser',
							emptyText:'报表高级使用人员',
							anchor: '98%'
						},{						
							fieldLabel:'项目工程师',
							name:'ProMaintainer',
							emptyText:'报表实施人员',
							anchor: '98%'
						},{						
							fieldLabel:'开发工程师',
							name:'DepMaintainer',
							emptyText:'报表开发人员',
							anchor: '98%'
						},{						
							fieldLabel:'使用（科室）部门',
							name:'UsedByDep',
							//emptyText:'报表开发人员',
							anchor: '98%'
						}     
					]  					
				}]
			},{
				bodyStyle: 'padding:0 10px 10px 10px;',
				columnWidth:1, 
				items:[{
					layout:'form',  
					xtype:'fieldset',  
					//autoHeight:true,  
					defaultType:'textfield',  
					title:'备注说明',  
					items:[  
						{
							fieldLabel:'逻辑说明',
							name:'ProgramLogic',
							emptyText:'报表的逻辑说明',
							anchor: '98%'
						},{
							fieldLabel:'其他备注',
							name:'Demo',
							xtype: 'htmleditor',
							anchor: '98%'
						}
						]
				}]
			}
				
		]
			
    });	
	
	var addWin = new Ext.Window({
        width:900,
		height:550,
		resizable:false,
		closable : false,
		title:'新增',
		modal:true,
		//items:[saveAsForm,rptGrid],
		items:addForm ,		
		//layout:'fit',
		autoScroll :true,
		tbar:new Ext.Toolbar({
        	layout: 'hbox',
        	items : [{
				text: '<span style="line-Height:1">查询HIS菜单</span>',
				icon   : '../images/uiimages/search.png',		
				xtype:'button',
				handler:OnSearch
			},"-",{
				text: '<span style="line-Height:1">加载其他说明</span>',
				icon   : '../images/uiimages/read.png',	
				xtype:'button',
				handler:OnLoadOtherDemo
			}			
				
			]
		}),				
		buttons: [
		{
			text: '<span style="line-Height:1">保存</span>',				
			icon   : '../images/uiimages/filesave.png',
			id:'btnSave',
			handler:OnSave			
		},{
			text: '<span style="line-Height:1">关闭</span>',
			icon   : '../images/uiimages/cancel.png',
			handler: CloseWins
		}]
	});	
	
	function OnSave() {
		var ID="";
		var action="addRec";
		if (recParam.curAct=="modify") {
			action="updateRec";
			ID=recParam.curSelRec.get('ID');
		}
		var baseForm=addForm.getForm();
		var MenuName=baseForm.findField("MenuName").getValue();
		var RaqName=baseForm.findField("RaqName").getValue();
		var CSPName=baseForm.findField("CSPName").getValue();
		var QueryName=baseForm.findField("QueryName").getValue();
		
		var aryValues=baseForm.getValues();
		
		//var pattern=/[#$%|\'"]/;
		var pattern=/[$%|\"\']/;
		for (var x in aryValues) {
			if (x=='Demo') continue;
			if(pattern.test(aryValues[x])) 
			{
				//Ext.Msg.alert("提示","填写的数据不能包含特殊字符:@,#,$,%,&,|,\',\",>,< ");
				Ext.Msg.alert("提示","填写的数据不能包含特殊字符:$,%,|,\",\'");
				return ;
			}
		}
		/*
		var str="Is this all there is?";
		var patt1=/[a-h]/g;

		document.write(patt1.test(str));		
		*/
		if(pattern.test(MenuName)) 
		{
			Ext.Msg.alert("提示","名称只能由 '字母'、'数字'、'-'或'_' 组成!");
			return ;
		}			
		
		
		if (MenuName=="") {
			Ext.Msg.alert("提示","菜单名称不能为空");
			return;
		}
		if (QueryName=="") {
			Ext.Msg.alert("提示","query名称不能为空");
			return;
		}
		if (RaqName=="" && CSPName=="") {
			Ext.Msg.alert("提示","raq名称或csp名称不能同时为空");
			return;
		}	
		
		if (RaqName!="") {
			if (CSPName=="") {
				Ext.Msg.alert("提示","csp名称不能为空");
				return;
			}				
			if (baseForm.findField("Filter").getValue()=="") {
				Ext.Msg.alert("提示","数据条件不能为空");
				return;
			}		
			if (baseForm.findField("RowColShow").getValue()=="") {
				Ext.Msg.alert("提示","显示条件不能为空");
				return;
			}	
			if (baseForm.findField("Spec").getValue()=="") {
				Ext.Msg.alert("提示","统计口径不能为空");
				return;
			}
			if (baseForm.findField("HisTableName").getValue()=="" && baseForm.findField("KPIName").getValue()=="") {
				Ext.Msg.alert("提示","业务表名称或指标名称不能同时为空");
				return;
			}	

			if (baseForm.findField("ProgramLogic").getValue()=="") {
				Ext.Msg.alert("提示","逻辑说明不能为空");
				return;
			}	
			
		}
		if (baseForm.findField("AdvUser").getValue()=="") {
			Ext.Msg.alert("提示","高级客户不能为空");
			return;
		}
		if (baseForm.findField("ProMaintainer").getValue()=="") {
			Ext.Msg.alert("提示","项目工程师不能为空");
			return;
		}	
		if (baseForm.findField("DepMaintainer").getValue()=="") {
			Ext.Msg.alert("提示","开发工程师不能为空");
			return;
		}	
		if (baseForm.findField("UsedByDep").getValue()=="") {
			Ext.Msg.alert("提示","使用（科室）部门不能为空");
			return;
		}			
		if (baseForm.findField("AuxiliaryMenuName").getValue()=="") {
			Ext.Msg.alert("提示","当前页面(标题)名称不能为空");
			return;
		}		
		var aryValues=baseForm.getValues();
		
		//var pattern=/[#$%|\'"]/;
		/*
		var pattern=/[\"]/;
		if(pattern.test(baseForm.findField("Demo").getValue())) 
		{
			var a1=baseForm.findField("Demo").getValue().replace(/\"|\'/g,"\\\"");
		
		}		
		*/
		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:action,
			ID: ID,
			MenuName: baseForm.findField("MenuName").getValue(),
			RaqName: RaqName,
			CSPName: CSPName,
			QueryName: baseForm.findField("QueryName").getValue(),
			AuxiliaryMenuName: baseForm.findField("AuxiliaryMenuName").getValue(),
			Spec: baseForm.findField("Spec").getValue(),
			HisTableName:baseForm.findField("HisTableName").getValue(),
			KPIName:baseForm.findField("KPIName").getValue(),
			Filter:baseForm.findField("Filter").getValue(),
			RowColShow:baseForm.findField("RowColShow").getValue(),
			ProgramLogic:baseForm.findField("ProgramLogic").getValue(),
			AdvUser:baseForm.findField("AdvUser").getValue(),
			ProMaintainer:baseForm.findField("ProMaintainer").getValue(),
			DepMaintainer:baseForm.findField("DepMaintainer").getValue(),
			Demo:baseForm.findField("Demo").getValue(),
			UsedByDep:baseForm.findField("UsedByDep").getValue()
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				//store.reload();
				//Ext.Msg.alert("提示","操作成功！");
				//dhcwl.RptMgmt.util.msg('提示','操作成功！');
				ClearForm();
				if (recParam.curAct=="modify") {
					addWin.close();
					if (!!outThis.OnUpdateCallback) outThis.OnUpdateCallback();
				}else if (recParam.curAct=="add") {
					if (!!outThis.OnAddCallback) outThis.OnAddCallback();
				} 
				
				
				
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);			
	}
	
	function OnSearch() {
		var searchMenuObj=new dhcwl.RptMgmt.SearchMenuCfg();
		searchMenuObj.getSearchMenuWin().show();
		searchMenuObj.OnMenuCfgCallback=OnMenuCfgCallback;
	}
	
	function OnLoadOtherDemo() {
		var searchRptObj=new dhcwl.RptMgmt.SearchRptCfg();
		searchRptObj.OnRptCfgCallback=OnRptCfgCallback;
		searchRptObj.show();
	}
	
	function OnRptCfgCallback(rec) {
			addForm.getForm().loadRecord(rec)
	}		
	
	function OnMenuCfgCallback(outParam) {
		var baseForm=addForm.getForm();
		baseForm.findField("MenuName").setValue(outParam.MenuName);
		baseForm.findField("RaqName").setValue(outParam.RaqName);
		baseForm.findField("CSPName").setValue(outParam.CSPName);
		baseForm.findField("AuxiliaryMenuName").setValue(outParam.MenuName);
		
	}
	
	function OnLoad() {
		if(outThis.onLoadCallback)
		{
		}
				
	}
	function CloseWins() {
			addWin.close();
	}
 
	function ClearForm() {
		var baseForm=addForm.getForm();
		baseForm.setValues({

					MenuName: "",
					RaqName: "",
					CSPName: "",
					QueryName:"",
					Spec:"",
					HisTableName:"",
					KPIName:"",
					Filter:"",
					RowColShow:"",
					ProgramLogic:"",
					AdvUser:"",
					ProMaintainer:"",
					DepMaintainer:"",
					Demo:"",
					AuxiliaryMenuName:"",
					UsedByDep:""
		})
     }

	
	
	
	this.getAddWin=function() {
		return addWin;
	}
	
	this.show=function() {
		addWin.show();
	}

	this.initForAddWin=function() {

	}
	
	this.initParam=function(inParam) {
		recParam=inParam;
		if (recParam.curAct=='modify') {
			addWin.getTopToolbar().hide();
			addWin.setTitle("修改");
			var selRec=recParam.curSelRec;
			var baseForm=addForm.getForm();
			
			
			
			baseForm.findField("MenuName").setValue(selRec.get('MenuName'));	
			baseForm.findField("RaqName").setValue(selRec.get('RaqName'));
			baseForm.findField('CSPName').setValue(selRec.get('CSPName'));
			baseForm.findField('AdvUser').setValue(selRec.get('AdvUser'));
			baseForm.findField('AuxiliaryMenuName').setValue(selRec.get('AuxiliaryMenuName'));
			
			var reg=new RegExp("<br>","g"); 
			var newstr=selRec.get('Demo').replace(reg,"\n");    
			
			baseForm.findField('Demo').setValue(newstr);
			
			
			
			
			baseForm.findField('Demo').setValue(selRec.get('Demo'));
			baseForm.findField('DepMaintainer').setValue(selRec.get('DepMaintainer'));
			baseForm.findField('Filter').setValue(selRec.get('Filter'));
			baseForm.findField('HisTableName').setValue(selRec.get('HisTableName'));
			baseForm.findField('KPIName').setValue(selRec.get('KPIName'));
			baseForm.findField('ProMaintainer').setValue(selRec.get('ProMaintainer'));
			baseForm.findField('ProgramLogic').setValue(selRec.get('ProgramLogic'));
			baseForm.findField('QueryName').setValue(selRec.get('QueryName'));
			baseForm.findField('RowColShow').setValue(selRec.get('RowColShow'));
			baseForm.findField('Spec').setValue(selRec.get('Spec'));
			baseForm.findField('UsedByDep').setValue(selRec.get('UsedByDep'));
			//baseForm.findField('UPdateDate').setValue(selRec.get('UPdateDate'));
			//baseForm.findField('').setValue(selRec.get(''));			

			//baseForm.findField("MenuName").disable();
			baseForm.findField("RaqName").disable();
			baseForm.findField("CSPName").disable();
			baseForm.findField("AuxiliaryMenuName").disable();
			
		}
		//actParam.CreateDate=selRec.get('CreateDate');


	}
}

