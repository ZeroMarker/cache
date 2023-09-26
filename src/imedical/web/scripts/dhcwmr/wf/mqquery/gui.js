function InitviewScreen(){
	var obj = new Object();

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.gridResultStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.gridResultStore = new Ext.data.Store({
		proxy: obj.gridResultStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'MainID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'MainID', mapping: 'MainID'}
			,{name: 'PatiName', mapping: 'PatiName'}
			,{name: 'MrNo', mapping: 'MrNo'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'PeronalID', mapping: 'PeronalID'}
			,{name: 'Company', mapping: 'Company'}
			,{name: 'Address', mapping: 'Address'}
			,{name: 'RelativeName', mapping: 'RelativeName'}
			,{name: 'MrNo', mapping: 'MrNo'}
		])
	});
	obj.gridResultCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridResult = new Ext.grid.GridPanel({
		id : 'gridResult'
		,store : obj.gridResultStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '病案号', width: 80, dataIndex: 'MrNo', sortable: true, 
				renderer : function(v,m,r) {
					return "<a href='#' onclick='ShowPatInfo(\"" + r.get("MainID") + "\",\"\")'>" + v + "</a>"
				}
			}			
			,{header: '姓名', width: 80, dataIndex: 'PatiName', sortable: true}
			,{header: '病案号', width: 80, dataIndex: 'MrNo', sortable: true}
			,{header: '性别', width: 80, dataIndex: 'Sex', sortable: true}
			,{header: '年龄', width: 80, dataIndex: 'Age', sortable: true}
			,{header: '身份证号', width: 120, dataIndex: 'PeronalID', sortable: true}
			,{header: '工作单位', width: 150, dataIndex: 'Company', sortable: true}
			,{header: '住址', width: 150, dataIndex: 'Address', sortable: true}
			,{header: '联系人姓名', width: 100, dataIndex: 'RelativeName', sortable: true}
		]});
	obj.txtName = new Ext.form.TextField({
		id : 'txtName'
		,fieldLabel : '患者姓名'
});
	obj.txtCompany = new Ext.form.TextField({
		id : 'txtCompany'
		,fieldLabel : '工作单位'
});
	obj.pn1 = new Ext.Panel({
		id : 'pn1'
		,buttonAlign : 'center'
		,columnWidth : 0.3
		,layout : 'form'
		,items:[
			obj.txtName
			,obj.txtCompany
		]
	});
	obj.txtSpell = new Ext.form.TextField({
		id : 'txtSpell'
		,fieldLabel : '拼音'
});
	obj.txtAddress = new Ext.form.TextField({
		id : 'txtAddress'
		,fieldLabel : '住址'
});
	obj.pn2 = new Ext.Panel({
		id : 'pn2'
		,buttonAlign : 'center'
		,columnWidth : 0.3
		,layout : 'form'
		,items:[
			obj.txtSpell
			,obj.txtAddress
		]
	});
	obj.txtPID = new Ext.form.TextField({
		id : 'txtPID'
		,fieldLabel : '身份证号'
});
	obj.txtTel = new Ext.form.TextField({
		id : 'txtTel'
		,fieldLabel : '电话'
});
	obj.pn3 = new Ext.Panel({
		id : 'pn3'
		,buttonAlign : 'center'
		,columnWidth : 0.3
		,layout : 'form'
		,items:[
			obj.txtPID
			,obj.txtTel
		]
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,text : '查询'
});
	obj.pnCondi = new Ext.form.FieldSet({
		id : 'pnCondi'
		,buttonAlign : 'center'
		,layout : 'column'
		,title : '查询条件'
		,labelWidth : 80
		,labelStyle : 'text-align:right;'
		,items:[
			obj.pn1
			,obj.pn2
			,obj.pn3
		]
	,	buttons:[
			obj.btnQuery
		]
	});
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items:[
			{
				
				frame : true,
				region : 'north',
				layout : 'fit',
				height : 145,
				items : [obj.pnCondi]
			}
			,obj.gridResult
		]
	});
	obj.gridResultStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.PatiQrySrv';
			param.QueryName = 'PatiQry';
			param.Arg1 = 1;
			param.Arg2 = obj.txtSpell.getValue();
			param.Arg3 = obj.txtName.getValue();
			param.Arg4 = obj.txtPID.getValue();
			param.Arg5 = obj.txtAddress.getValue();
			param.Arg6 = obj.txtCompany.getValue();
			param.Arg7 = '';
			param.Arg8 = obj.txtTel.getValue();
			param.ArgCnt = 8;
	});
	InitviewScreenEvent(obj);
	//事件处理代码
	obj.btnQuery.on("click", obj.btnQuery_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

