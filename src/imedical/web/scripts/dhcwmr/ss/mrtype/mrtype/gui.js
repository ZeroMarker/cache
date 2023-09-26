function InitMrTypeSetViewPort()
{
	var obj = new Object();
	obj.aMrTypeID = "";
	obj.MrTypeID = '';
	
	obj.btnSaveMrType = new Ext.Button({
		id : 'btnSaveMrType'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	
	obj.gridCTHospListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridCTHospListStore = new Ext.data.Store({
		proxy: obj.gridCTHospListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'HospID'
		},
		[
			{name: 'IsChecked', mapping : 'IsChecked'}
			,{name: 'HospID', mapping: 'HospID'}
			,{name: 'HospDesc', mapping: 'HospDesc'}
		])
	});
	obj.gridCTHospList = new Ext.grid.EditorGridPanel({
		id : 'gridCTHospList'
		,store : obj.gridCTHospListStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,height : 150        //修复Bug 6512
		//,loadMask : true
		,hideHeaders : true
		,columns: [
			{header: '选择', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get("IsChecked");
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
					}
				}
			}
			,{header: '医院名称', width: 150, dataIndex: 'HospDesc', sortable: false, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.cboMrClassStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboMrClassStore = new Ext.data.Store({
		proxy: obj.cboMrClassStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboMrClass = new Ext.form.ComboBox({
		id : 'cboMrClass'
		,width : 340
		,store : obj.cboMrClassStore
		,minChars : 1
		,valueField : 'ID'
		,displayField : 'Desc'
		,fieldLabel : '病案分类'
		,labelSeparator :''
		,editable : false
		,triggerAction : 'all'
		,anchor : '100%'
	});
	
	obj.cboMrGetWay = Common_ComboToDic("cboMrGetWay","病案号分号方式","AssignType");
	obj.cboReceiptType = Common_ComboToDic("cboReceiptType","接诊类型","ReceiptType");
	obj.cboMrNoFiled = Common_ComboToDic("cboMrNoFiled","病案号存储字段","MrNoField");
	obj.cbgAdmType = Common_CheckboxGroupToDC("cbgAdmType","就诊类型","AdmType",3);
	
	obj.txtMrResume = new Ext.form.TextField({
		id : 'txtMrResume'
		,width : 340
		,fieldLabel : '备注'
		,labelSeparator :''
		,anchor : '100%'
	});
	
	obj.chkIsBWMrNo = new Ext.form.Checkbox({
		id : 'chkIsBWMrNo'
		,fieldLabel : '回写病人信息表'
		,labelSeparator :''
		,anchor : '100%'
		,checked : false
	});
	
	obj.txtMrTypeDesc = new Ext.form.TextField({
		id : 'txtMrTypeDesc'
		,width : 340
		,fieldLabel : '病案类型名称'
		,labelSeparator :''
		,anchor : '100%'
	});
	
	obj.chkRecycleType = new Ext.form.Checkbox({
		id : 'chkRecycleType'
		,fieldLabel : '病案号回收'
		,labelSeparator :''
		,anchor : '100%'
		,checked : false
	});
	
	obj.cboWorkFlowStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboWorkFlowStore = new Ext.data.Store({
		proxy: obj.cboWorkFlowStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboWorkFlow = new Ext.form.ComboBox({
		id : 'cboWorkFlow'
		,width : 340
		,store : obj.cboWorkFlowStore
		,minChars : 1
		,valueField : 'ID'
		,displayField : 'Desc'
		,fieldLabel : '工作流'
		,labelSeparator :''
		,editable : false
		,triggerAction : 'all'
		,anchor : '100%'
	});
	
	obj.gridMrTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridMrTypeStore = new Ext.data.Store({
		proxy: obj.gridMrTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'MrClassID', mapping: 'MrClassID'}
			,{name: 'MrClassDesc', mapping: 'MrClassDesc'}
			,{name: 'MrTypeDesc', mapping: 'MrTypeDesc'}
			,{name: 'HospIDs', mapping: 'HospIDs'}
			,{name: 'HospDescs', mapping: 'HospDescs'}
			,{name: 'ReceiptTypeID', mapping: 'ReceiptTypeID'}
			,{name: 'ReceiptTypeDesc', mapping: 'ReceiptTypeDesc'}
			,{name: 'GetWayID', mapping: 'GetWayID'}
			,{name: 'GetWayDesc', mapping: 'GetWayDesc'}
			,{name: 'RecycleType', mapping: 'RecycleType'}
			,{name: 'RecycleTypeDesc', mapping: 'RecycleTypeDesc'}
			,{name: 'NoFiledID', mapping: 'NoFiledID'}
			,{name: 'NoFiledDesc', mapping: 'NoFiledDesc'}
			,{name: 'WorkFlowID', mapping: 'WorkFlowID'}
			,{name: 'WorkFlowDesc', mapping: 'WorkFlowDesc'}
			,{name: 'IsBWMrNo', mapping: 'IsBWMrNo'}
			,{name: 'IsBWMrNoDesc', mapping: 'IsBWMrNoDesc'}
			,{name: 'AdmType', mapping: 'AdmType'}
			,{name: 'AdmTypeDesc', mapping: 'AdmTypeDesc'}
			,{name: 'MTResume', mapping: 'MTResume'}
		])
	});
	obj.gridMrType = new Ext.grid.GridPanel({
		id : 'gridMrType'
		,store : obj.gridMrTypeStore
		,columnLines:true
		//,loadMask : true
		,region : 'center'
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '病案类型名称', width: 80, dataIndex: 'MrTypeDesc', align: 'center'}
			,{header: '接诊类型', width: 80, dataIndex: 'ReceiptTypeDesc', align: 'center'}
			,{header: '分号方式', width: 100 , dataIndex: 'GetWayDesc' , align : 'center'}
			,{header: '病案号<br>回收', width: 50, dataIndex: 'RecycleTypeDesc', align: 'center'}
			,{header: '工作流', width: 80, dataIndex: 'WorkFlowDesc', align: 'center'}
			,{header: '就诊类型', width: 80, dataIndex: 'AdmTypeDesc', align: 'center'}
			,{header: '号码<br>类型', width: 50 , dataIndex: '' , align : 'center' ,
				renderer : function(v, m, rd, r, c, s){
					return " <a href='#' onclick='DisplayMrNoTypeWindow(\""+r+"\",\"\");'>编辑</a>";
				}
			}
			,{header: '备注', width: 100, dataIndex: 'MTResume', align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
	});
	
	obj.inputMrType = new Ext.Panel({
		id :'inputMrType'
		,width : 340
		,layout : 'form'
		,frame : true
		,region : 'east'
		,labelAlign : 'right'
		,labelWidth : 110
		,items:[
			obj.cboMrClass
			,obj.txtMrTypeDesc
			,obj.cboWorkFlow
			,obj.cboReceiptType
			,obj.cboMrGetWay
			,obj.chkRecycleType
			,obj.chkIsBWMrNo
			,obj.cboMrNoFiled
			,obj.cbgAdmType
			,{
				layout : 'column'
				,items: [
					{
						width : 108
						,html : '<div style="width=100%;text-align:right;font-size:18px;">医院列表&nbsp;</div>'
					},{
						columnWidth : 1
						,layout : 'fit'
						,buttonAlign : 'left'
						,items: [obj.gridCTHospList]
					}
				]
			}
			,obj.txtMrResume
			,{
				layout : 'form'
				,buttonAlign : 'center'
				,buttons : [obj.btnSaveMrType]
			}
		]
	});
	
	obj.MrTypeSetViewPort = new Ext.Viewport({
		id : 'MrTypeSetViewPort'
		,layout : 'border'
		,items:[
			obj.gridMrType
			,obj.inputMrType
		]
	});
	
	obj.cboWorkFlowStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SS.WorkFlow';
		param.QueryName = 'QryWorkFlow';
		param.ArgCnt = 0;
	});
	obj.cboWorkFlowStore.load({});
	
	obj.gridMrTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SS.MrType';
		param.QueryName = 'QueryMrType';
		param.ArgCnt = 0;
	});
	obj.gridMrTypeStore.load({});
	
	obj.cboMrClassStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SS.MrClass';
		param.QueryName = 'QryMrClass';
		param.ArgCnt = 0;
	});
	obj.cboMrClassStore.load({});	
	
	obj.gridCTHospListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SS.MrType';
		param.QueryName = 'QryMTHospList';
		if (obj.MrTypeID =="") {
			param.ClassName = 'DHCWMR.SSService.HospitalSrv';
			param.QueryName = 'QryCTHospital';
			param.ArgCnt = 0;
		} else {
			param.Arg1 = obj.MrTypeID;
			param.ArgCnt = 1;
		}
	});
	obj.gridCTHospListStore.load({});
	
	InitMrTypeSetEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}