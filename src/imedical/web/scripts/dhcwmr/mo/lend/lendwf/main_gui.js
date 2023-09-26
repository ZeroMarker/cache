var objScreen = new Object();
function InitViewport(){
	var obj = objScreen;
	obj.WFIBatchOper = 0;
	obj.cboHospital = Common_ComboToSSHosp("cboHospital","医院",SSHospCode);
	obj.cboMrType = Common_ComboToMrType("cboMrType","病案类型",MrClass,"cboHospital");
	obj.dfDateFrom 	= Common_DateFieldToDate("dfDateFrom","查询日期");
	obj.dfDateTo	= Common_DateFieldToDate("dfDateTo","至");
	
	obj.cboQryType = new Ext.form.ComboBox({
		id : 'cboQryType'
		,name :'cboQryType'
		,fieldLabel : '病历状态'
		,labelSeparator :''
		,mode : 'local'
		,valueField : 'svalue'
		,displayField : 'stext'
		,triggerAction : 'all'
		,value : 'L'
		,anchor : '100%'
		,store: new Ext.data.ArrayStore({
			fields:['svalue','stext'],
			//data:[["L","出库"],["B","入库"],["R","申请"]]
			data:[["L","出库"],["B","入库"]] //fix by mxp 2016-06-02 目前没有申请操作,屏蔽申请状态
		})
	});
	
	obj.txtMrNo = new Ext.form.TextField({
		id : "txtMrNo"
		,fieldLabel : "病案号"
		,labelSeparator :''
		,emptyText : ''
		,regex : /^[A-Za-z0-9]+$/
		,style: 'font-weight:bold;font-size:18;'
		,width : 180
	});
	
	obj.cboOperType = new Ext.form.ComboBox({
		id : 'cboOperType'
		,name :'cboOperType'
		,fieldLabel : ''
		,mode : 'local'
		,valueField : 'svalue'
		,displayField : 'stext'
		,triggerAction : 'all'
		,value : '1'
		,anchor : '99%'
		,store: new Ext.data.ArrayStore({
			fields:['svalue','stext'],
			data:[["1","自动出库"],["2","手工执行"]]
		})
	});
	
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,width : 60
		,anchor : '100%'
		,text : '查询'
	});
	
	obj.btnBack = new Ext.Button({
		id : 'btnBack'
		,iconCls : 'icon-confirm'
		,width : 60
		,anchor : '100%'
		,text : '入库'
	});
	
	obj.btnLend = new Ext.Button({
		id : 'btnLend'
		,iconCls : 'icon-cancel'
		,width : 60
		,anchor : '100%'
		,text : '出库'
	});
	
	obj.btnPrint = new Ext.Button({
		id : 'btnPrint'
		,iconCls : 'icon-print'
		,width : 60
		,anchor : '100%'
		,hidden : true
		,text : '打印'
	});
	
	obj.gridLendRecordStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.gridLendDataRecord = Ext.data.Record.create(
		[
			{name: 'RecordID', mapping : 'RecordID'}
			,{name: 'PatientID', mapping : 'PatientID'}
			,{name: 'PapmiNo' , mapping : 'PapmiNo'}
			,{name: 'MrNo', mapping : 'MrNo'}
			,{name: 'PatName', mapping : 'PatName'}
			,{name: 'Sex', mapping : 'Sex'}
			,{name: 'Age', mapping :'Age'}
			,{name: 'MainID', mapping : 'MainID'}
			,{name: 'StatusCode', mapping : 'StatusCode'}
			,{name: 'StatusDesc', mapping : 'StatusDesc'}
			,{name: 'ReqDate', mapping : 'ReqDate'}
			,{name: 'ReqTime', mapping : 'ReqTime'}
			,{name: 'ReqUser', mapping : 'ReqUser'}
			,{name: 'LendDate', mapping : 'LendDate'}
			,{name: 'LendTime', mapping : 'LendTime'}
			,{name: 'LendUser', mapping : 'LendUser'}
			,{name: 'BackDate', mapping : 'BackDate'}
			,{name: 'BackTime', mapping : 'BackTime'}
			,{name: 'BackUser', mapping : 'BackUser'}
			,{name: 'LLocCode', mapping : 'LLocCode'}
			,{name: 'LLocDesc', mapping : 'LLocDesc'}
			,{name: 'LLocTel', mapping : 'LLocTel'}
			,{name: 'LUserCode', mapping : 'LUserCode'}
			,{name: 'LUserDesc', mapping : 'LUserDesc'}
			,{name: 'LUserTel', mapping : 'LUserTel'}
			,{name: 'PurposeDescs', mapping : 'PurposeDescs'}
			,{name: 'PrintFlag', mapping : 'PrintFlag'}
			,{name: 'ExpBackDate', mapping : 'ExpBackDate'}
			,{name: 'Note', mapping : 'Note'}
			,{name: 'LendFlag', mapping: 'LendFlag'}
			,{name: 'VolumeIDs', mapping : 'VolumeIDs'}
		]
	);
	obj.gridLendRecordStore = new Ext.data.Store({
		proxy: obj.gridLendRecordStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RecordID'
		},obj.gridLendDataRecord)
	});
	
	obj.gridLendRecord = new Ext.grid.GridPanel({
		id : 'gridLendRecord'
		,store : obj.gridLendRecordStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,tbar : [{id:'msgGridLendRecord',text:'出库查询列表',style:'font-weight:bold;font-size:17px;',xtype:'label'},
		'->',{text:'病案号：',style:'font-weight:bold;font-size:17px;',xtype:'label'},obj.txtMrNo,'-',obj.btnLend,'-',obj.btnBack,'-',obj.btnPrint]
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '选择', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					var StatusCode = rd.get("StatusCode");
					if (StatusCode=="U"){
						return "<IMG src='../scripts/dhcwmr/img/error.png'>";
					}else{
						if (IsChecked == '1') {
							return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
						} else {
							return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
						}
					}
				}
			}
			,{header: '病案号', width: 70, dataIndex: 'MrNo', sortable: false, menuDisabled:true, align : 'center'}
			,{header: '姓名', width: 70, dataIndex: 'PatName', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '性别', width: 40, dataIndex: 'Sex', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '年龄', width: 40, dataIndex: 'Age', sortable: false, menuDisabled:true, align: 'center'}
			,{id:'LendFlag' ,header: '副页', width: 40, dataIndex: 'LendFlag', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v,m,rd,r,c,s){
					var LendFlag = rd.get('LendFlag');
					if (LendFlag=='F')
						return '副页';
					else 
						return '';
				}
			}
			,{header: '状态', width: 40, dataIndex: 'StatusDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '申请日期', width: 70, dataIndex: 'ReqDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '申请人', width: 70, dataIndex: 'ReqUser', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出库日期', width: 70, dataIndex: 'LendDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '出库人', width: 70, dataIndex: 'LendUser', sortable: false, menuDisabled:true, align: 'center'}
			/*
			,{header: '出库小条', width: 70, dataIndex: 'PrintFlag', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var PrintFlag = rd.get("PrintFlag");
					if (PrintFlag==1){
						return "已打印";
					}else{
						return "";
					}
				}
			}
			*/
			,{header: '入库日期', width: 70, dataIndex: 'BackDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '入库人', width: 70, dataIndex: 'BackUser', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '借阅科室', width: 100, dataIndex: 'LLocDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '科室电话', width: 80, dataIndex: 'LLocTel', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '借阅人', width: 70, dataIndex: 'LUserDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '借阅人电话', width: 80, dataIndex: 'LUserTel', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '借阅目的', width: 80, dataIndex: 'PurposeDescs', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '预计归还日期', width: 90, dataIndex: 'ExpBackDate', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '登记号', width: 90, dataIndex: 'PapmiNo', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			//forceFit : true,
			getRowClass: function(record, index) {
				if (record.get('IsChecked') == '1') {
					return 'x-grid-record-red';
				} else{
					return '';
				}
			}
		}
    });
    
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			{
				region:'north'
				,layout:'column'
				,height: 40
				,frame: true
				,items:[
					{
						width:220
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items:[obj.cboHospital]
					},{
						width:170
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items:[obj.cboMrType]
					},{
						width:180
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items:[obj.dfDateFrom]
					},{
						width:140
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 30
						,items:[obj.dfDateTo]
					},{
						width:130
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items:[obj.cboQryType]
					},{
						width:5
						,layout:'form'
						,height:1
					},{
						width:70
						,layout:'form'
						,items:[obj.btnQuery]
					},{
						width:10
						,layout:'form'
						,height:1
					},{
						width:90
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 1
						,items:[obj.cboOperType]
					}
				]
			}
			,obj.gridLendRecord
		]
	});
	
	obj.gridLendRecordStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MOService.LendRecordSrv';
		param.QueryName = 'QryLendRecord';
		param.Arg1 = Common_GetValue("cboHospital");
		param.Arg2 = Common_GetValue("cboMrType");
		param.Arg3 = Common_GetValue("dfDateFrom");
		param.Arg4 = Common_GetValue("dfDateTo");
		param.Arg5 = Common_GetValue("txtMrNo");
		param.Arg6 = Common_GetValue("cboQryType");
		param.ArgCnt = 6;
	});
	
	InitViewportEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}