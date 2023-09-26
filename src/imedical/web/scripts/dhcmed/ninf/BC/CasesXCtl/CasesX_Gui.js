var objScreen = new Object();
function InitCasesXCtl(){
	var obj = objScreen;
	obj = InitCasesXDtl(obj);
	
	//查询条件
	obj.ArgumentData = {
		ViewType : '',
		QueryType : '',
		DateFrom : '',
		DateTo : '',
		AdmStatus : '',
		ScreenGrade : '',
		HandleGrade : '',
		LogonHospID : '',
		DisplayType : '',
		DisplayLoc : ''
	}
	
	var htmlNorthPanel = ''
		+ '<table  width="100%"><tr>'
		+ '<td width="1%"><div style="border:1px solid #F78181;width=10px;height=92px;">'
		+ '<table><tr><td>筛查病例</td></tr></table>'
		+ '</div></td>'
		+ '<td width="9%"><div style="border:1px solid #F78181;width=350px;height=92px;">'
		+ '<table><tr><td id="txtDateFromTD"></td><td>-</td><td id="txtDateToTD"></td><td></td><td id="cbgAdmStatusTD"></td></tr></table>'
		+ '<table><tr><td id="cbgScreenGradeTD"></td><td id="btnQryScreenCasesTD"></td></tr></table>'
		+ '<table><tr><td id="cbgHandleGradeTD"></td><td>(处置过滤条件)</td></tr></table>'
		+ '</div></td>'
		
		+ '<td width="1%"><div style="border:1px solid #58D3F7;width=10px;height=92px;">'
		+ '<table><tr><td>处置病例</td></tr></table>'
		+ '</div></td>'
		+ '<td width="9%"><div style="border:1px solid #58D3F7;width=400px;height=92px;">'
		+ '<table><tr><td id="txtDateFromXTD"></td><td>-</td><td id="txtDateToXTD"></td><td></td><td id="cbgAdmStatusXTD"></td></tr></table>'
		+ '<table><tr><td id="cbgHandleGradeXTD"></td><td id="btnQryHandleCasesTD"></td></tr></table>'
		+ '<table><tr><td id="cbgScreenGradeXTD"></td><td>(筛查过滤条件)</td></tr></table>'
		+ '</div></td>'
		
		+ '<td width="1%"><div style="border:1px solid #BDBDBD;width=10px;height=92px;">'
		+ '<table><tr><td>其他条件</td></tr></table>'
		+ '</div></td>'
		+ '<td width="79%"><div style="border:1px solid #BDBDBD;height=92px;">'
		+ '<table><tr><td><div id="cboSSHospTD" style="width:200px;overflow:hidden;"></div></td></tr></table>'
		+ '<table><tr><td><div id="cbgViewTypeTD" style="width:200px;overflow:hidden;"></div></td></tr></table>'
		+ '</div></td>'
		+ '</tr></table>'
	
	var htmlWestPanel = '<div id="LocXTemplateDIV"></div>'
	
	var htmlMainPanel = '<div id="PatXTemplateDIV"></div>'
	
	obj.NorthPanel = new Ext.Panel({
		id : 'NorthPanel',
		region : 'north',
		split:true,
		collapsible: true,
		collapsed : false,
        lines:false,
        animCollapse:false,
        animate: false,
        collapseMode:'mini',
		collapseFirst:false,
		hideCollapseTool:true,
		border:true,
		boxMinHeight : 100,
		boxMaxHeight : 100,
		//frame : true,
		html : htmlNorthPanel,
		height : 80
	});
	obj.WestPanel = new Ext.Panel({
		id : 'WestPanel'
		,region : 'west'
		,autoScroll : true
		//,frame : true
		,html : htmlWestPanel
		,width : 240
	});
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,region : 'center'
		,autoScroll : true
		//,frame : true
		,html : htmlMainPanel
	});
	
	obj.CasesXWin = new Ext.Viewport({
		id : 'CasesXWin'
		,layout : 'border'
		,items:[
			obj.NorthPanel
			,obj.WestPanel
			,obj.MainPanel
		]
	});
	
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"NINF");
	
	//************************筛查病例查询条件 START************************
	obj.txtDateFrom = new Ext.form.DateField({
		id : 'txtDateFrom'
		,fieldLabel : '开始日期'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 105
		,renderTo : 'txtDateFromTD'
		,value : new Date()
	});
	obj.txtDateTo = new Ext.form.DateField({
		id : 'txtDateTo'
		,fieldLabel : '结束日期'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 105
		,renderTo : 'txtDateToTD'
		,value : new Date()
	});
	obj.cbgAdmStatus = new Ext.form.CheckboxGroup({
		id : 'cbgAdmStatus'
		,fieldLabel : '在院状态'
		,xtype : 'checkboxgroup'
		,columns : 2
		,items : [
			{id : 'cbgAdmStatus-1', boxLabel : '在院', name : 'cbgAdmStatus-1', inputValue : '1', checked : false}
			,{id : 'cbgAdmStatus-2', boxLabel : '出院', name : 'cbgAdmStatus-2', inputValue : '2', checked : false}
		]
		,width : 130
		,height : 25
		,renderTo : 'cbgAdmStatusTD'
	});
	obj.cbgScreenGrade = new Ext.form.CheckboxGroup({
		id : 'cbgScreenGrade'
		,fieldLabel : '筛查等级'
		,xtype : 'checkboxgroup'
		,columns : 4
		,items : [
			{id : 'cbgScreenGrade-3', boxLabel : '高度疑似', name : 'cbgScreenGrade-3', inputValue : '3', checked : false}
			,{id : 'cbgScreenGrade-2', boxLabel : '疑似病例', name : 'cbgScreenGrade-2', inputValue : '2', checked : false}
			,{id : 'cbgScreenGrade-1', boxLabel : '易感人群', name : 'cbgScreenGrade-1', inputValue : '1', checked : false}
			,{id : 'cbgScreenGrade-0', boxLabel : '其它', name : 'cbgScreenGrade-0', inputValue : '0', checked : false}
		]
		,width : 320
		,height : 25
		,renderTo : 'cbgScreenGradeTD'
	});
	
	obj.cbgHandleGrade = new Ext.form.CheckboxGroup({
		id : 'cbgHandleGrade'
		,fieldLabel : '处置等级'
		,xtype : 'checkboxgroup'
		,columns : 3
		,items : [
			{id : 'cbgHandleGrade-1', boxLabel : '排除', name : 'cbgHandleGrade-1', inputValue : '1', checked : false}
			,{id : 'cbgHandleGrade-2', boxLabel : '疑似', name : 'cbgHandleGrade-2', inputValue : '2', checked : false}
			,{id : 'cbgHandleGrade-3', boxLabel : '确诊', name : 'cbgHandleGrade-3', inputValue : '3', checked : false}
			//,{id : 'cbgHandleGrade-4', boxLabel : '消息', name : 'cbgHandleGrade-4', inputValue : '4', checked : false}
		]
		,width : 220
		,height : 25
		,renderTo : 'cbgHandleGradeTD'
	});
	
	obj.btnQryScreenCases = new Ext.Button({
		id : 'btnQryScreenCases'
		,width : 40
		,text : '查询'
		,iconCls : 'icon-find'
		,renderTo : 'btnQryScreenCasesTD'
	})
	//************************筛查病例查询条件 END************************
	
	//************************处置病例查询条件 START************************
	obj.cbgAdmStatusX = new Ext.form.CheckboxGroup({
		id : 'cbgAdmStatusX'
		,fieldLabel : '在院状态'
		,xtype : 'checkboxgroup'
		,columns : 2
		,items : [
			{id : 'cbgAdmStatusX-1', boxLabel : '在院', name : 'cbgAdmStatusX-1', inputValue : '1', checked : false}
			,{id : 'cbgAdmStatusX-2', boxLabel : '出院', name : 'cbgAdmStatusX-2', inputValue : '2', checked : false}
		]
		,width : 130
		,height : 25
		,renderTo : 'cbgAdmStatusXTD'
	});
	obj.txtDateFromX = new Ext.form.DateField({
		id : 'txtDateFromX'
		,fieldLabel : '开始日期'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 105
		,renderTo : 'txtDateFromXTD'
		,value : new Date()
	});
	obj.txtDateToX = new Ext.form.DateField({
		id : 'txtDateToX'
		,fieldLabel : '结束日期'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 105
		,renderTo : 'txtDateToXTD'
		,value : new Date()
	});
	obj.cbgHandleGradeX = new Ext.form.CheckboxGroup({
		id : 'cbgHandleGradeX'
		,fieldLabel : '处置等级'
		,xtype : 'checkboxgroup'
		,columns : 4
		,items : [
			{id : 'cbgHandleGradeX-1', boxLabel : '排除', name : 'cbgHandleGradeX-1', inputValue : '1', checked : false}
			,{id : 'cbgHandleGradeX-2', boxLabel : '疑似', name : 'cbgHandleGradeX-2', inputValue : '2', checked : false}
			,{id : 'cbgHandleGradeX-3', boxLabel : '确诊', name : 'cbgHandleGradeX-3', inputValue : '3', checked : false}
			,{id : 'cbgHandleGradeX-4', boxLabel : '消息', name : 'cbgHandleGradeX-4', inputValue : '4', checked : false}
		]
		,width : 270
		,height : 25
		,renderTo : 'cbgHandleGradeXTD'
	});
	obj.cbgScreenGradeX = new Ext.form.CheckboxGroup({
		id : 'cbgScreenGradeX'
		,fieldLabel : '筛查等级'
		,xtype : 'checkboxgroup'
		,columns : 2
		,items : [
			{id : 'cbgScreenGradeX-1', boxLabel : '感染管理科处置', name : 'cbgScreenGradeX-1', inputValue : '1', checked : false}
			,{id : 'cbgScreenGradeX-2', boxLabel : '临床科室处置', name : 'cbgScreenGradeX-2', inputValue : '2', checked : false}
		]
		,width : 250
		,height : 25
		,renderTo : 'cbgScreenGradeXTD'
	});
	obj.btnQryHandleCases = new Ext.Button({
		id : 'btnQryHandleCases'
		,width : 40
		,text : '查询'
		,iconCls : 'icon-find'
		,renderTo : 'btnQryHandleCasesTD'
	})
	//************************处置病例查询条件 END************************
	
	obj.cbgViewType = new Ext.form.CheckboxGroup({
		id : 'cbgViewType'
		,fieldLabel : '显示方式'
		,xtype : 'checkboxgroup'
		,columns : 2
		,items : [
			{id : 'cbgViewType-1', boxLabel : '按科室显示', name : 'cbgViewType-1', inputValue : '1', checked : false,
				listeners : {
					check : function(checkbox, checked) {
						if (checked) {
							var chkBoxId = checkbox.id;
							var chkBoxValue = checkbox.inputValue;
							var chkGrpId = chkBoxId.substring(0, chkBoxId.length - chkBoxValue.length-1);
							var chkGrp = Ext.getCmp(chkGrpId);
							if (chkGrp) {
								for (idx = 0; idx < chkGrp.items.length; idx++) {
									var cbId=chkGrp.items.items[idx].id;
									if (cbId!=chkBoxId) {
										chkGrp.setValue(cbId,false);
									}
								}
							}
						}
					}
				}
			}
			,{id : 'cbgViewType-2', boxLabel : '按病区显示', name : 'cbgViewType-2', inputValue : '2', checked : false,
				listeners : {
					check : function(checkbox, checked) {
						if (checked) {
							var chkBoxId = checkbox.id;
							var chkBoxValue = checkbox.inputValue;
							var chkGrpId = chkBoxId.substring(0, chkBoxId.length - chkBoxValue.length-1);
							var chkGrp = Ext.getCmp(chkGrpId);
							if (chkGrp) {
								for (idx = 0; idx < chkGrp.items.length; idx++) {
									var cbId=chkGrp.items.items[idx].id;
									if (cbId!=chkBoxId) {
										chkGrp.setValue(cbId,false);
									}
								}
							}
						}
					}
				}
			}
		]
		,width : 100
		,renderTo : 'cbgViewTypeTD'
	});
	
	obj.LocXTemplate = new Ext.XTemplate(
		'<tpl for=".">',
			'<div class="vertmenu">',
				'<ul>',
				   '<table width="100%" border="0">',
						'<tpl for="LocGrpList">',
							'<tpl if="LocGrpCount!=\'0\'">',
								'<tr>',
									'<td><li><a class="vertmenu_a" onclick="{[this.RowOnClickA(values)]}" href="#">{LocGrpDesc}：{LocGrpIPCount}人({LocGrpCount}人)</li></td>',
								'</tr>',
								'<tpl for="LocList">',
									'<tpl if="LocCount!=\'0\'">',	
										'<tr>',
											'<td><li><a class="vertmenu_b" onclick="{[this.RowOnClickB(values)]}" href="#">{LocDesc}：{LocIPCount}人({LocCount}人)</li></td>',
										'</tr>',
									'</tpl>',
								'</tpl>',
							'</tpl>',
						'</tpl>',
						'<tr>',
							'<td><li><a class="vertmenu_a" href="#">全院：{HospIPCount}人({HospCount}人)</li></td>',
						'</tr>',
					'</table>',
				'</ul>',
			'</div>',
		'</tpl>',
		{
			RowOnClickA : function(values){
				//点击科室组触发事件
				var tabEv = 'objScreen.LoadLocGrpPatientList(\'' + values.LocGrpDesc + '\');';
				return tabEv;
			},
			RowOnClickB : function(values){
				//点击科室触发事件
				var tabEv = 'objScreen.LoadLocPatientList(\'' + values.LocID + '\');';
				return tabEv;
			}
		}
	);
	
	obj.PatXTemplate = new Ext.XTemplate(
		'<tpl for=".">',
			'<tpl if="LocCount!=\'0\'">',
				'<div style="border:0px solid wight;padding:3px;width:100%;">',
					'<div class="subtotal">', 
						'<table width="100%">',
							'<tr>',
								 '<td width="5%" class="subtotal_tdx"><div style="position: relative; width: 80px; height: 30px;"><img src="../scripts/dhcmed/img/ninf/subtotal08.png" width="60" height="25" style="position: absolute; top: 2; left: 10;" /></div></td>',
								 '<td width="95%" class="subtotal_tdx">{LocDesc}&nbsp;&nbsp;待处理病例：&nbsp;&nbsp;<span class="subtotal_number">共{LocCount}个</span></td>',
							'</tr>',
						'</table>',
					'</div>',
					'<tpl for="PatList">',
						'<div id="divPatCasesX-{EpisodeID}" style="position:relative;overflow-y:auto;"></div>',
					'</tpl>',
				'</div>',
			'</tpl>',
		'</tpl>'
	);
	
	Ext.ComponentMgr.all.each(function(cmp){
		var objTD = document.getElementById(cmp.id + 'TD');
		if (objTD) {
			cmp.setWidth(objTD.offsetWidth);
			cmp.render(cmp.id + 'TD');
		}
	});
	
	InitCasesXCtlEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}