function InitViewPort()
{
	var obj = new Object();
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.txtFromMrNo = Common_TextField("txtFromMrNo","旧病案号");
	obj.txtToMrNo = Common_TextField("txtToMrNo","新病案号");
	obj.chkSelectAll = Common_Checkbox("chkSelectAll","全选");
	obj.cboMrNoMarker = Common_ComboToDic("cboMrNoMarker","病案号标记","MrNoMarker","^-");
	obj.cboMrNoMarker.setWidth(70);
	
	obj.cboNoTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboNoTypeStore = new Ext.data.Store({
		proxy: obj.cboNoTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'NoLen', mapping: 'NoLen'}
			,{name: 'NoHead', mapping: 'NoHead'}
			,{name: 'CurrNo', mapping: 'CurrNo'}
			,{name: 'CurrMrNo', mapping: 'CurrMrNo'}
			,{name: 'MaxNo', mapping: 'MaxNo'}
			,{name: 'MinNo', mapping: 'MinNo'}
			,{name: 'IsDefault', mapping: 'IsDefault'}
			,{name: 'IsDefaultDesc', mapping: 'IsDefaultDesc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.cboNoType = new Ext.form.ComboBox({
		id : 'cboNoType'
		,store : obj.cboNoTypeStore
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th align="center" width="50%">号码类型</th>',
					'<th align="center" width="50%">当前号</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{Desc}</td>',
					'<td>{CurrMrNo}</td>',
				'</tr></tpl>',
			'</table>'
		)
		,hideTrigger:false
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:150
		,valueField : 'ID'
		,displayField : 'Desc'
		,fieldLabel : '号码类型'
		,labelSeparator :''
		,editable : false
		,loadingText: '查询中,请稍等...'
		,width : 10
		,anchor : '100%'
	});
	
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-clearscreen'
		,width : 60
		,anchor : '100%'
		,text : '清空'
	});
	
	obj.btnSubmit = new Ext.Button({
		id : 'btnSubmit'
		,iconCls : 'icon-save'
		,width : 60
		,anchor : '100%'
		,text : '提交'
	});
	
	obj.btnMrNoMarker = new Ext.Button({
		id : 'btnMrNoMarker'
		,iconCls : 'icon-confirm'
		,width : 60
		,anchor : '100%'
		,text : '标记'
	});
	
	obj.gridFromVolumeListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridFromVolumeListStore = new Ext.data.Store({
		proxy: obj.gridFromVolumeListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IndexNo'
		},[
			{name: 'IndexNo', mapping : 'IndexNo'}
			,{name: 'VolID', mapping : 'VolID'}
			,{name: 'MainID', mapping : 'MainID'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'AdmLocDesc', mapping: 'AdmLocDesc'}
			,{name: 'AdmWardDesc', mapping: 'AdmWardDesc'}
			,{name: 'AdmDate', mapping: 'AdmDate'}
			,{name: 'AdmTime', mapping: 'AdmTime'}
			,{name: 'DischDate', mapping: 'DischDate'}
			,{name: 'BackDate', mapping: 'BackDate'}
			,{name: 'StepDesc', mapping: 'StepDesc'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'IsChecked', mapping: 'IsChecked'}
			,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
			,{name: 'PatLevel', mapping: 'PatLevel'}
		])
	});
	obj.gridFromVolumeList = new Ext.grid.GridPanel({
		id : 'gridFromVolumeList'
		,store : obj.gridFromVolumeListStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 240
		,loadMask : { msg : '正在查询,请稍后...'}
		,tbar : [
			{id:'msgGridFromVolumeList',text:'病案卷列表',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'-','旧病案号：',obj.txtFromMrNo,'-',obj.chkSelectAll,'全选','-',obj.btnCancel,'-','标记符号：',obj.cboMrNoMarker,'-',obj.btnMrNoMarker,'-'
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '选择', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
					}
				}
			}
			,{header: '病案号', width: 80, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 50, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			//,{header : '病人<br>密级', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			//,{header : '病人<br>级别', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header: '当前步骤', width: 60, dataIndex: 'StepDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '当前状态', width: 60, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: MrClass=='O'?'初诊科室':'科室', width: 150, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '病区', id : 'AdmWardDesc', width: 150, dataIndex: 'AdmWardDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: MrClass=='O'?'初诊日期':'就诊日期', width: 80, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出院日期', id : 'DischDate', width: 60, dataIndex: 'DischDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '回收日期', id : 'BackDate', width: 60, dataIndex: 'BackDate', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.gridToVolumeListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridToVolumeListStore = new Ext.data.Store({
		proxy: obj.gridToVolumeListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'IndexNo'
		},[
			{name: 'IndexNo', mapping : 'IndexNo'}
			,{name: 'VolID', mapping : 'VolID'}
			,{name: 'MainID', mapping : 'MainID'}
			,{name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'PapmiNo', mapping: 'PapmiNo'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'AdmLocDesc', mapping: 'AdmLocDesc'}
			,{name: 'AdmWardDesc', mapping: 'AdmWardDesc'}
			,{name: 'AdmDate', mapping: 'AdmDate'}
			,{name: 'AdmTime', mapping: 'AdmTime'}
			,{name: 'DischDate', mapping: 'DischDate'}
			,{name: 'BackDate', mapping: 'BackDate'}
			,{name: 'StepDesc', mapping: 'StepDesc'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
			,{name: 'PatLevel', mapping: 'PatLevel'}
		])
	});
	obj.gridToVolumeList = new Ext.grid.GridPanel({
		id : 'gridToVolumeList'
		,store : obj.gridToVolumeListStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'south'
		,height : 240
		,loadMask : { msg : '正在查询,请稍后...'}
		,tbar : [
			{id:'msgGridToVolumeList',text:'病案卷列表',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'-','新病案号：',obj.txtToMrNo,'-',obj.btnSubmit,'-'
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '病案号', width: 80, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '姓名', width: 80, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 50, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 50, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			//,{header : '病人<br>密级', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			//,{header : '病人<br>级别', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
			,{header: '当前步骤', width: 60, dataIndex: 'StepDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '当前状态', width: 60, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: MrClass=='O'?'初诊科室':'科室', width: 150, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '病区',id : 'AdmWardDesc', width: 150, dataIndex: 'AdmWardDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: MrClass=='O'?'初诊日期':'就诊日期', width: 80, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出院日期',id : 'DischDate', width: 60, dataIndex: 'DischDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '回收日期',id : 'BackDate', width: 60, dataIndex: 'BackDate', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.ViewPort = new Ext.Viewport({
		id : 'ViewPort'
		,layout : 'border'
		,frame : true
		,items:[
			{
				region: 'north',
				height: 35,
				layout : 'column',
				frame : true,
				items : [
					{
						width:220
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.cboHospital]
					},{
						width:180
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cboMrType]
					},{
						width:180
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cboNoType]
					}
				]
			}
			,obj.gridFromVolumeList
			,obj.gridToVolumeList
		]
	});
	
	obj.gridFromVolumeListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.MergerQry';
		param.QueryName = 'QryVolumeByMrNo';
		param.Arg1 = Common_GetValue('cboMrType');
		param.Arg2 = Common_GetValue('txtFromMrNo');
		param.ArgCnt = 2;
	});
	
	obj.gridToVolumeListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.MergerQry';
		param.QueryName = 'QryVolumeByMrNo';
		param.Arg1 = Common_GetValue('cboMrType');
		param.Arg2 = Common_GetValue('txtToMrNo');
		param.ArgCnt = 2;
	});
	
	obj.cboNoTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SS.NoType';
		param.QueryName = 'QryActNoType';
		param.Arg1 = Common_GetValue('cboMrType');
		param.ArgCnt = 1;
	});
	
	InitEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}