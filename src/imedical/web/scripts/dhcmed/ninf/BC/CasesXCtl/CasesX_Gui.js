var objScreen = new Object();
function InitCasesXCtl(){
	var obj = objScreen;
	obj = InitCasesXDtl(obj);
	
	//��ѯ����
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
		+ '<table><tr><td>ɸ�鲡��</td></tr></table>'
		+ '</div></td>'
		+ '<td width="9%"><div style="border:1px solid #F78181;width=350px;height=92px;">'
		+ '<table><tr><td id="txtDateFromTD"></td><td>-</td><td id="txtDateToTD"></td><td></td><td id="cbgAdmStatusTD"></td></tr></table>'
		+ '<table><tr><td id="cbgScreenGradeTD"></td><td id="btnQryScreenCasesTD"></td></tr></table>'
		+ '<table><tr><td id="cbgHandleGradeTD"></td><td>(���ù�������)</td></tr></table>'
		+ '</div></td>'
		
		+ '<td width="1%"><div style="border:1px solid #58D3F7;width=10px;height=92px;">'
		+ '<table><tr><td>���ò���</td></tr></table>'
		+ '</div></td>'
		+ '<td width="9%"><div style="border:1px solid #58D3F7;width=400px;height=92px;">'
		+ '<table><tr><td id="txtDateFromXTD"></td><td>-</td><td id="txtDateToXTD"></td><td></td><td id="cbgAdmStatusXTD"></td></tr></table>'
		+ '<table><tr><td id="cbgHandleGradeXTD"></td><td id="btnQryHandleCasesTD"></td></tr></table>'
		+ '<table><tr><td id="cbgScreenGradeXTD"></td><td>(ɸ���������)</td></tr></table>'
		+ '</div></td>'
		
		+ '<td width="1%"><div style="border:1px solid #BDBDBD;width=10px;height=92px;">'
		+ '<table><tr><td>��������</td></tr></table>'
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
	
	obj.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","ҽԺ",SSHospCode,"NINF");
	
	//************************ɸ�鲡����ѯ���� START************************
	obj.txtDateFrom = new Ext.form.DateField({
		id : 'txtDateFrom'
		,fieldLabel : '��ʼ����'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 105
		,renderTo : 'txtDateFromTD'
		,value : new Date()
	});
	obj.txtDateTo = new Ext.form.DateField({
		id : 'txtDateTo'
		,fieldLabel : '��������'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 105
		,renderTo : 'txtDateToTD'
		,value : new Date()
	});
	obj.cbgAdmStatus = new Ext.form.CheckboxGroup({
		id : 'cbgAdmStatus'
		,fieldLabel : '��Ժ״̬'
		,xtype : 'checkboxgroup'
		,columns : 2
		,items : [
			{id : 'cbgAdmStatus-1', boxLabel : '��Ժ', name : 'cbgAdmStatus-1', inputValue : '1', checked : false}
			,{id : 'cbgAdmStatus-2', boxLabel : '��Ժ', name : 'cbgAdmStatus-2', inputValue : '2', checked : false}
		]
		,width : 130
		,height : 25
		,renderTo : 'cbgAdmStatusTD'
	});
	obj.cbgScreenGrade = new Ext.form.CheckboxGroup({
		id : 'cbgScreenGrade'
		,fieldLabel : 'ɸ��ȼ�'
		,xtype : 'checkboxgroup'
		,columns : 4
		,items : [
			{id : 'cbgScreenGrade-3', boxLabel : '�߶�����', name : 'cbgScreenGrade-3', inputValue : '3', checked : false}
			,{id : 'cbgScreenGrade-2', boxLabel : '���Ʋ���', name : 'cbgScreenGrade-2', inputValue : '2', checked : false}
			,{id : 'cbgScreenGrade-1', boxLabel : '�׸���Ⱥ', name : 'cbgScreenGrade-1', inputValue : '1', checked : false}
			,{id : 'cbgScreenGrade-0', boxLabel : '����', name : 'cbgScreenGrade-0', inputValue : '0', checked : false}
		]
		,width : 320
		,height : 25
		,renderTo : 'cbgScreenGradeTD'
	});
	
	obj.cbgHandleGrade = new Ext.form.CheckboxGroup({
		id : 'cbgHandleGrade'
		,fieldLabel : '���õȼ�'
		,xtype : 'checkboxgroup'
		,columns : 3
		,items : [
			{id : 'cbgHandleGrade-1', boxLabel : '�ų�', name : 'cbgHandleGrade-1', inputValue : '1', checked : false}
			,{id : 'cbgHandleGrade-2', boxLabel : '����', name : 'cbgHandleGrade-2', inputValue : '2', checked : false}
			,{id : 'cbgHandleGrade-3', boxLabel : 'ȷ��', name : 'cbgHandleGrade-3', inputValue : '3', checked : false}
			//,{id : 'cbgHandleGrade-4', boxLabel : '��Ϣ', name : 'cbgHandleGrade-4', inputValue : '4', checked : false}
		]
		,width : 220
		,height : 25
		,renderTo : 'cbgHandleGradeTD'
	});
	
	obj.btnQryScreenCases = new Ext.Button({
		id : 'btnQryScreenCases'
		,width : 40
		,text : '��ѯ'
		,iconCls : 'icon-find'
		,renderTo : 'btnQryScreenCasesTD'
	})
	//************************ɸ�鲡����ѯ���� END************************
	
	//************************���ò�����ѯ���� START************************
	obj.cbgAdmStatusX = new Ext.form.CheckboxGroup({
		id : 'cbgAdmStatusX'
		,fieldLabel : '��Ժ״̬'
		,xtype : 'checkboxgroup'
		,columns : 2
		,items : [
			{id : 'cbgAdmStatusX-1', boxLabel : '��Ժ', name : 'cbgAdmStatusX-1', inputValue : '1', checked : false}
			,{id : 'cbgAdmStatusX-2', boxLabel : '��Ժ', name : 'cbgAdmStatusX-2', inputValue : '2', checked : false}
		]
		,width : 130
		,height : 25
		,renderTo : 'cbgAdmStatusXTD'
	});
	obj.txtDateFromX = new Ext.form.DateField({
		id : 'txtDateFromX'
		,fieldLabel : '��ʼ����'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 105
		,renderTo : 'txtDateFromXTD'
		,value : new Date()
	});
	obj.txtDateToX = new Ext.form.DateField({
		id : 'txtDateToX'
		,fieldLabel : '��������'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,altFormats : 'Y-m-d|d/m/Y'
		,width : 105
		,renderTo : 'txtDateToXTD'
		,value : new Date()
	});
	obj.cbgHandleGradeX = new Ext.form.CheckboxGroup({
		id : 'cbgHandleGradeX'
		,fieldLabel : '���õȼ�'
		,xtype : 'checkboxgroup'
		,columns : 4
		,items : [
			{id : 'cbgHandleGradeX-1', boxLabel : '�ų�', name : 'cbgHandleGradeX-1', inputValue : '1', checked : false}
			,{id : 'cbgHandleGradeX-2', boxLabel : '����', name : 'cbgHandleGradeX-2', inputValue : '2', checked : false}
			,{id : 'cbgHandleGradeX-3', boxLabel : 'ȷ��', name : 'cbgHandleGradeX-3', inputValue : '3', checked : false}
			,{id : 'cbgHandleGradeX-4', boxLabel : '��Ϣ', name : 'cbgHandleGradeX-4', inputValue : '4', checked : false}
		]
		,width : 270
		,height : 25
		,renderTo : 'cbgHandleGradeXTD'
	});
	obj.cbgScreenGradeX = new Ext.form.CheckboxGroup({
		id : 'cbgScreenGradeX'
		,fieldLabel : 'ɸ��ȼ�'
		,xtype : 'checkboxgroup'
		,columns : 2
		,items : [
			{id : 'cbgScreenGradeX-1', boxLabel : '��Ⱦ����ƴ���', name : 'cbgScreenGradeX-1', inputValue : '1', checked : false}
			,{id : 'cbgScreenGradeX-2', boxLabel : '�ٴ����Ҵ���', name : 'cbgScreenGradeX-2', inputValue : '2', checked : false}
		]
		,width : 250
		,height : 25
		,renderTo : 'cbgScreenGradeXTD'
	});
	obj.btnQryHandleCases = new Ext.Button({
		id : 'btnQryHandleCases'
		,width : 40
		,text : '��ѯ'
		,iconCls : 'icon-find'
		,renderTo : 'btnQryHandleCasesTD'
	})
	//************************���ò�����ѯ���� END************************
	
	obj.cbgViewType = new Ext.form.CheckboxGroup({
		id : 'cbgViewType'
		,fieldLabel : '��ʾ��ʽ'
		,xtype : 'checkboxgroup'
		,columns : 2
		,items : [
			{id : 'cbgViewType-1', boxLabel : '��������ʾ', name : 'cbgViewType-1', inputValue : '1', checked : false,
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
			,{id : 'cbgViewType-2', boxLabel : '��������ʾ', name : 'cbgViewType-2', inputValue : '2', checked : false,
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
									'<td><li><a class="vertmenu_a" onclick="{[this.RowOnClickA(values)]}" href="#">{LocGrpDesc}��{LocGrpIPCount}��({LocGrpCount}��)</li></td>',
								'</tr>',
								'<tpl for="LocList">',
									'<tpl if="LocCount!=\'0\'">',	
										'<tr>',
											'<td><li><a class="vertmenu_b" onclick="{[this.RowOnClickB(values)]}" href="#">{LocDesc}��{LocIPCount}��({LocCount}��)</li></td>',
										'</tr>',
									'</tpl>',
								'</tpl>',
							'</tpl>',
						'</tpl>',
						'<tr>',
							'<td><li><a class="vertmenu_a" href="#">ȫԺ��{HospIPCount}��({HospCount}��)</li></td>',
						'</tr>',
					'</table>',
				'</ul>',
			'</div>',
		'</tpl>',
		{
			RowOnClickA : function(values){
				//��������鴥���¼�
				var tabEv = 'objScreen.LoadLocGrpPatientList(\'' + values.LocGrpDesc + '\');';
				return tabEv;
			},
			RowOnClickB : function(values){
				//������Ҵ����¼�
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
								 '<td width="95%" class="subtotal_tdx">{LocDesc}&nbsp;&nbsp;����������&nbsp;&nbsp;<span class="subtotal_number">��{LocCount}��</span></td>',
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