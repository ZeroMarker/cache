var objScreen = new Object();
function InitViewport1(){
	var obj = new Object();
	objScreen = obj;
	
	obj.WFIConfig = new Object();
	obj.ExtraItemInput = '';
	obj.CheckUserInput = '';
	
	//病案回收时默认打印病案条码
	obj.DefaultPrintMrBarcode = ExtTool.RunServerMethod("DHCWMR.SSService.ConfigSrv","GetValueByKeyHosp",'DefaultPrintMrBarcode');
	//病案回收时默认打印卷条码
	obj.DefaultPrintVolBarcode = ExtTool.RunServerMethod("DHCWMR.SSService.ConfigSrv","GetValueByKeyHosp",'DefaultPrintVolBarcode');
	
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.chkMBarCode = Common_Checkbox("chkMBarCode","打印病案条码");
	obj.chkVBarCode = Common_Checkbox("chkVBarCode","打印卷条码");
	obj.chkUpdoFlag = Common_Checkbox("chkUpdoFlag","撤销动作");
	
	obj.txtMrNo = new Ext.form.TextField({
		id : "txtMrNo"
		,fieldLabel : "病案号"
		,labelSeparator :''
		,emptyText : ''  //'病案号/条码号'
		,regex : /^[A-Za-z0-9]+$/
		,style: 'font-weight:bold;font-size:18;'
		,width : 180
	});
	
	obj.txtUpdoMrNo = new Ext.form.TextField({
		id : "txtUpdoMrNo"
		,labelSeparator :''
		,fieldLabel : "病案号"
		,emptyText : ''  //'病案号/条码号'
		,regex : /^[A-Za-z0-9]+$/
		,style: 'font-weight:bold;font-size:18;'
		,width : 180
	});
	
	//操作项目列表
	obj.cboWFItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboWFItemStore = new Ext.data.Store({
		proxy: obj.cboWFItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			,idProperty: 'WFItemID'
		}, 
		[
			{name: 'WFItemID', mapping: 'WFItemID'}
			,{name: 'WFItemDesc', mapping: 'WFItemDesc'}
			,{name: 'ItemID', mapping: 'ItemID'}
			,{name: 'ItemType', mapping: 'ItemType'}
			,{name: 'SubFlow', mapping: 'SubFlow'}
			,{name: 'PostStep', mapping: 'PostStep'}
			,{name: 'SysOpera', mapping: 'SysOpera'}
			,{name: 'CheckUser', mapping: 'CheckUser'}
			,{name: 'BeRequest', mapping: 'BeRequest'}
			,{name: 'BatchOper', mapping: 'BatchOper'}
		])
	});
	obj.cboWFItem = new Ext.form.ComboBox({
		id : 'cboWFItem'
		,fieldLabel : '操作项目'
		,labelSeparator :''
		,store : obj.cboWFItemStore
		,editable : false
		,selectOnFocus : true
		,forceSelection : true
		,mode : 'local'
		,triggerAction : 'all'
		,minListWidth:100
		,valueField : 'WFItemID'
		,displayField : 'WFItemDesc'
		,loadingText: '加载中,请稍候...'
		,anchor : '100%'
	});
	
	obj.btnClean = new Ext.Button({
		id : 'btnClean'
		,iconCls : 'icon-clearscreen'
		,width: 60
		,text : '清空列表'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width: 60
		,text : '移除'
	});
	obj.btnAloneSave = new Ext.Button({
		id : 'btnAloneSave'
		,iconCls : 'icon-save'
		,width: 60
		,text : '保存'
	});
	obj.btnBatchPrintBar = new Ext.Button({
		id : 'btnBatchPrintBar'
		,iconCls : 'icon-print'
		,width: 60
		,text : '打印条码'
	});
	obj.btnBatchSave = new Ext.Button({
		id : 'btnBatchSave'
		,iconCls : 'icon-save'
		,width: 60
		,text : '批量保存'
	});
	obj.btnUpdoQuery = new Ext.Button({
		id : 'btnUpdoQuery'
		,iconCls : 'icon-find'
		,width: 60
		,text : '当日查询'
	});
	obj.btnUpdoOpera = new Ext.Button({
		id : 'btnUpdoOpera'
		,iconCls : 'icon-delete'
		,width: 60
		,text : '撤销'
	});
	
	//病案操作工作列表
	obj.GridWorkListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.GridWorkListStore = new Ext.data.Store({
		proxy: obj.GridWorkListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowIndex'
		}, 
		[
			{name: 'RowIndex',type:'int', mapping: 'RowIndex'}
			,{name: 'RecordID', mapping: 'RecordID'}
			,{name: 'ProblemCode', mapping: 'ProblemCode'}
			,{name: 'ProblemDesc', mapping: 'ProblemDesc'}
			,{name: 'HappenDate', mapping: 'HappenDate'}
			,{name: 'HappenTime', mapping: 'HappenTime'}
			,{name: 'HappenUser', mapping: 'HappenUser'}
			,{name: 'HappenUserDesc', mapping: 'HappenUserDesc'}
			,{name: 'RequestDate', mapping: 'RequestDate'}
			,{name: 'RequestTime', mapping: 'RequestTime'}
			,{name: 'RequestUser', mapping: 'RequestUser'}
			,{name: 'RequestUserDesc', mapping: 'RequestUserDesc'}
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
			,{name: 'DischCondit', mapping: 'DischCondit'}
			,{name: 'DischDate', mapping: 'DischDate'}
			,{name: 'BackDate', mapping: 'BackDate'}
			,{name: 'StepDesc', mapping: 'StepDesc'}
			,{name: 'StatusDesc', mapping: 'StatusDesc'}
			,{name: 'IsChecked', mapping: 'IsChecked'}
			,{name: 'EncryptLevel', mapping: 'EncryptLevel'}
			,{name: 'PatLevel', mapping: 'PatLevel'}
		]),sortInfo:{field: 'RowIndex', direction: "DESC"}
	});
	obj.GridWorkList = new Ext.grid.GridPanel({
		id : 'GridWorkList'
		,store : obj.GridWorkListStore
		,region : 'center'
		,stripeRows : true
		,loadMask : { msg : '正在查询,请稍后...'}
		,tbar : [
			{id:'msgGridFrontPage',text:'病案操作列表【卷】',style:'font-weight:bold;font-size:14px;',xtype:'label'},'-',{id:'msgNumber',text:'',style:'font-weight:bold;font-size:14px;',xtype:'label'}
			,'->',{text:'病案号：',style:'font-weight:bold;font-size:18px;',xtype:'label'},obj.txtMrNo,{text:'',width:50,xtype:'label'}
			,'-',obj.btnAloneSave,'-',obj.btnBatchSave,'-',obj.btnDelete,'-',obj.btnClean,'-'
		]
		,bbar : [
			'-','打印卷条码：',obj.chkVBarCode,'-','病案条码：',obj.chkMBarCode,'-',obj.btnBatchPrintBar,'-'
			,'->','-',obj.chkUpdoFlag,'操作记录','-',obj.btnUpdoQuery
			,'-',{text:'病案号：',style:'font-weight:bold;font-size:18px;',xtype:'label'},obj.txtUpdoMrNo
			,'-',obj.btnUpdoOpera,'-'
		]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '标记', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (rd.get('ProblemCode') != 1){
						return "<IMG src='../scripts/dhcwmr/img/error.png'>";
					} else {
						if (IsChecked == '1') {
							return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
						} else {
							return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
						}
					}
				}
			}
			,{header: '姓名', width: 60, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '病案号', width: 60, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '性<br>别', width: 40, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年<br>龄', width: 40, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			//,{header : '病人<br>密级', id : 'Secret1', width : 60, dataIndex : 'EncryptLevel', sortable: false, menuDisabled:true, align:'center' }
			//,{header : '病人<br>级别', id : 'Secret2', width : 60, dataIndex : 'PatLevel', sortable: false, menuDisabled:true, align:'center' }
			//,{header: '当前<br>步骤', width: 50, dataIndex: 'StepDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '当前状态', width: 80, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'
				,renderer : function(v, m, rd, r, c, s){
					var StatusDesc  = rd.get("StatusDesc");
					if (StatusDesc == obj.WFIConfig.WFItemDesc){
						m.attr = 'style="background:#FF5151;"';
					}
					return v;
				}
			}
			,{header: '科室', width: 120, dataIndex: 'AdmLocDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '病区', width: 120, dataIndex: 'AdmWardDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '就诊日期', width: 80, dataIndex: 'AdmDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出院<br>情况', width: 60, dataIndex: 'DischCondit', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					if ((v.indexOf('已故')>-1)||(v.indexOf('死亡')>-1)) m.attr = 'style="background:#FF5151;"';
					return v;
				}
			}
			,{header: '出院日期', width: 80, dataIndex: 'DischDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '申请日期', width: 80, dataIndex: 'RequestDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '登记日期', width: 80, dataIndex: 'HappenDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '问题说明', width: 100, dataIndex: 'ProblemDesc', sortable: false, menuDisabled:true, align: 'left'}
			,{header: '登记号', width: 80, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true,
			getRowClass: function(record, index) {
				if (record.get('IsChecked') == '1') {
					return 'x-grid-record-red';
				} else{
					return '';
				}
			}
		}
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id: 'Viewport1'
		,layout : 'border'
		,items:[
			{
				region: 'north',
				height: 40,
				layout : 'column',
				frame : true,
				labelWidth : 70,
				buttonAlign : 'center',
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
						,items: [obj.cboWFItem]
					}
				]
			}
			,obj.GridWorkList
		]
	});
	
	obj.cboWFItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.SSService.WorkFlowSrv"
		param.QueryName = "QryWFItemList"
		param.Arg1 = Common_GetValue('cboMrType');
		param.Arg2 = obj.GetOperaList();
		param.ArgCnt = 2
	});
	
	obj.GridWorkListStoreProxy.on('beforeload', function(objProxy, param){
		var updoFlag = obj.chkUpdoFlag.getValue();
		if (updoFlag){
			param.ClassName = "DHCWMR.SSService.OperationQry"
			param.QueryName = "QryUpdoVolList"
			param.Arg1 = Common_GetValue("cboMrType")
			param.Arg2 = Common_GetValue("cboWFItem")
			param.Arg3 = session['LOGON.USERID']
			param.Arg4 = Common_GetValue("txtUpdoMrNo")
			param.ArgCnt = 4
		} else {
			param.ClassName = "DHCWMR.SSService.OperationQry"
			param.QueryName = "QryOperaVolList"
			param.Arg1 = Common_GetValue("cboMrType")
			param.Arg2 = Common_GetValue("cboWFItem")
			param.Arg3 = session['LOGON.USERID']
			param.ArgCnt = 3
		}
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}
