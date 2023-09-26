function InitMrNoTypeViewPort(){
	var obj = new Object();
	obj.MrTypeID = arguments[0].get('ID');
	obj.CTHospIDs = arguments[0].get('HospIDs');
	obj.NoTypeID = '';
	
	obj.btnSaveNoType = new Ext.Button({
		id : 'btnSaveNoType'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	
	obj.txtNTCode = new Ext.form.TextField({
		id : 'txtNTCode'
		,width : 340
		,fieldLabel : '代码'
		,labelSeparator :''
		,anchor : '100%'
	});
	
	obj.txtNTMaxNo = new Ext.form.NumberField({
		id : 'txtNTMaxNo'
		,width : 340
		,fieldLabel : '最大号'
		,labelSeparator :''
		,anchor : '100%'
	});
	
	obj.txtNTDesc = new Ext.form.TextField({
		id : 'txtNTDesc'
		,width : 340
		,fieldLabel : '描述'
		,labelSeparator :''
		,anchor : '100%'
	});

	obj.txtNTMinNo = new Ext.form.NumberField({
		id : 'txtNTMinNo'
		,width : 340
		,fieldLabel : '最小号'
		,labelSeparator :''
		,anchor : '100%'
	});
	
	obj.txtNTNoLen = new Ext.form.NumberField({
		id : 'txtNTNoLen'
		,width : 340
		,fieldLabel : '号码长度'
		,labelSeparator :''
		,anchor : '100%'
	});

	obj.chkNTIsDefault = new Ext.form.Checkbox({
		id : 'chkNTIsDefault'
		,width : 340
		,height : 25
		,fieldLabel : '是否默认类型'
		,labelSeparator :''
		,anchor : '100%'
	});
	
	obj.txtNTNoHead = new Ext.form.TextField({
		id : 'txtNTNoHead'
		,width : 340
		,regex : /^[A-Z]+$/
		,fieldLabel : '类型标记'
		,labelSeparator :''
		,anchor : '100%'
	});
	
	obj.chkNTIsActive = new Ext.form.Checkbox({
		id : 'chkNTIsActive'
		,width : 340
		,height : 25
		,fieldLabel : '是否有效'
		,labelSeparator :''
		,anchor : '100%'
	});
	
	obj.txtNTCurrNo = new Ext.form.NumberField({
		id : 'txtNTCurrNo'
		,width : 340
		,fieldLabel : '当前号'
		,labelSeparator :''
		,anchor : '100%'
	});

	obj.txtNTResume = new Ext.form.TextField({
		id : 'txtNTResume'
		,width : 340
		,fieldLabel : '备注'
		,labelSeparator :''
		,anchor : '100%'
	});
	
	obj.gridNoTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridNoTypeStore = new Ext.data.Store({
		proxy: obj.gridNoTypeStoreProxy,
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
			,{name: 'MaxNo', mapping: 'MaxNo'}	
			,{name: 'MinNo', mapping: 'MinNo'}
			,{name: 'IsDefaultDesc', mapping: 'IsDefaultDesc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'Resume', mapping: 'Resume'}
			,{name: 'IsDefault', mapping: 'IsDefault'}
			,{name: 'IsActiveDesc', mapping: 'IsActiveDesc'}
		])
	});
	obj.gridNoType = new Ext.grid.GridPanel({
		id : 'gridNoType'
		,store : obj.gridNoTypeStore
		,columnLines:true
		//,loadMask : true
		,region : 'center'
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 60, dataIndex: 'Code', align: 'center'}
			,{header: '描述', width: 120, dataIndex: 'Desc', align: 'center'}
			,{header: '类型<br>标记', width: 50 , dataIndex: 'NoHead', align: 'center'}
			,{header: '号码<br>长度', width: 50, dataIndex: 'NoLen', align: 'center'}
			,{header: '当前号', width: 60, dataIndex: 'CurrNo', align: 'center'}
			,{header: '默认<br>类型', width: 50, dataIndex: 'IsDefaultDesc', align: 'center'}
			,{header: '号码<br>关联', width: 50 , dataIndex: '' , align : 'center' ,
				renderer : function(v, m, rd, r, c, s){
					return " <a href='#' onclick='DisplayMrNoTypeLinkWindow(\""+r+"\",\""+obj.CTHospIDs+"\");'>编辑</a>";
				}
			}
			,{header: '是否<br>有效', width: 50, dataIndex: 'IsActiveDesc', align: 'center'}
			,{header: '备注', width: 50, dataIndex: 'Resume', align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
	});
	
	obj.inputNoType = new Ext.Panel({
		id :'inputNoType'
		,width : 270
		,layout : 'form'
		,frame : true
		,region : 'east'
		,labelAlign : 'right'
		,labelWidth : 90
		,items:[
			obj.txtNTCode
			,obj.txtNTDesc
			,obj.txtNTNoHead
			,obj.txtNTNoLen
			,obj.txtNTCurrNo
			,obj.txtNTMaxNo
			,obj.txtNTMinNo
			,obj.chkNTIsDefault
			,obj.chkNTIsActive
			,obj.txtNTResume
			,{
				layout : 'form'
				,buttonAlign : 'center'
				,buttons : [obj.btnSaveNoType]
			}
		]
	});
	
	obj.MrNoTypeWindow = new Ext.Window({
		id : 'MrNoTypeWindow'
		,width : 800
		,plain : true
		,height : 500
		,title : '病案号码类型维护'
		,layout : 'border'
		,frame  : true
		,bodyBorder : 'padding:0 0 0 0'
		,resizable:false
		,modal : true
		,items:[
			obj.gridNoType
			,obj.inputNoType
		]
	});
	
	obj.gridNoTypeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SS.NoType';
			param.QueryName = 'QryMrNoType';
			param.Arg1 = obj.MrTypeID;
			param.ArgCnt = 1;
	});	
	obj.gridNoTypeStore.load({});
	
	InitMrNoTypeEvent(obj);
	obj.LoadEvents(arguments);
	return obj;
}