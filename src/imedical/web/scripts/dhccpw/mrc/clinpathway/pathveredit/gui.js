function InitfrmPathWayVerEdit(verID,cpwDicID){
	var obj = new Object();
	obj.txtCode = new Ext.form.TextField({
		id : 'txtCode'
		,fieldLabel : '代码'
		,disabled : true
		,width : 100
		,anchor : '98%'
	});
	obj.txtDesc = new Ext.form.TextField({
		id : 'txtDesc'
		,fieldLabel : '描述'
		,disabled : true
		,width : 100
		,anchor : '98%'
	});
	obj.txtPathType = new Ext.form.TextField({
		id : 'txtPathType'
		,fieldLabel : '路径类型'
		,disabled : true
		,width : 100
		,anchor : '98%'
	});
	obj.txtIsActive = new Ext.form.TextField({
		id : 'txtIsActive'
		,fieldLabel : '是否有效'
		,disabled : true
		,width : 100
		,anchor : '98%'
	});
	obj.txtStartDate = new Ext.form.TextField({
		id : 'txtStartDate'
		,fieldLabel : '开始日期'
		,disabled : true
		,width : 100
		,anchor : '98%'
	});
	obj.txtToDate = new Ext.form.TextField({
		id : 'txtToDate'
		,fieldLabel : '结束日期'
		,disabled : true
		,width : 100
		,anchor : '98%'
	});
	
	obj.txtCost = new Ext.form.TextField({
		id : 'txtCost'
		,fieldLabel : '参考费用'
		,width : 100
		,anchor : '98%'
	});
	obj.txtDays = new Ext.form.TextField({
		id : 'txtDays'
		,fieldLabel : '参考天数'
		,width : 100
		,anchor : '98%'
	});
	obj.txtICD = new Ext.form.TextField({
		id : 'txtICD'
		,fieldLabel : '准入诊断ICD'
		,width : 100
		,anchor : '98%'
	});
	obj.txtKeys = new Ext.form.TextField({
		id : 'txtKeys'
		,fieldLabel : '准入诊断关键字'
		,width : 100
		,anchor : '98%'
	});
	obj.txtOperICD = new Ext.form.TextField({
		id : 'txtOperICD'
		,fieldLabel : '准入手术ICD'
		,width : 100
		,anchor : '98%'
	});
	obj.txtOperKeys = new Ext.form.TextField({
		id : 'txtOperKeys'
		,fieldLabel : '准入手术关键字'
		,width : 100
		,anchor : '98%'
	});
	obj.txtLabel = new Ext.form.TextArea({
		id : 'txtLabel'
		,fieldLabel : '准入提示'
		,width : 100
		,height : 60
		,anchor : '98%'
	});
	obj.txtVarReason = new Ext.form.TextArea({
		id : 'txtVarReason'
		,fieldLabel : '变异及原因分析'
		,width : 100
		,height : 60
		,anchor : '98%'
	});
	obj.txtVersion = new Ext.form.NumberField({
		id : 'txtVersion'
		,readOnly : true
		,fieldLabel : '版本'
		,value : 0
		,disabled : true
		,width : 100
		,anchor : '98%'
	});
	obj.cboPathDicStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboPathDicStore = new Ext.data.Store({
		proxy: obj.cboPathDicStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboPathDic = new Ext.form.ComboBox({
		id : 'cboPathDic'
		,store : obj.cboPathDicStore
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : '临床路径字典'
		,valueField : 'Rowid'
		,editable : false
		,triggerAction : 'all'
	});
	
	obj.chkIsOffShoot = new Ext.form.Checkbox({
		id : 'chkIsOffShoot'
		,boxLabel : '<b>分支型路径</b> 分支型路径需要为每个入径的患者选择和排列步骤,制定治疗路径'
	});
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	obj.btnHelp = new Ext.Button({
		id : 'btnHelp'
		,iconCls : 'icon-edit'
		,text : '文档'
	});
	obj.btnEvaluateList = new Ext.Button({
		id : 'btnEvaluateList'
		,iconCls : 'icon-Evaluate'
		,text : '评估项目'
	});
	obj.pnControl = new Ext.form.FormPanel(
		{
			layout : "form"
			,frame : true
			,buttonAlign : "center"
			//,title : "临床路径版本维护"
			,labelAlign : 'right'
			,labelWidth : 110
			,items : [
			  obj.chkIsOffShoot      //add by wuqk 2011-07-21
				,obj.txtCode
				,obj.txtDesc
				,obj.txtPathType
				,obj.txtIsActive
				,obj.txtStartDate
				,obj.txtToDate
				,obj.txtCost
				,obj.txtDays
				,obj.txtICD
				,obj.txtKeys
				,obj.txtOperICD
				,obj.txtOperKeys
				,obj.txtLabel
				,obj.txtVarReason
				//,obj.txtVersion
			]
			,buttons:[
				obj.btnSave
				,obj.btnHelp
				,obj.btnEvaluateList
			]
		}
	);

	obj.frmPathWayVerEdit = new Ext.Viewport({
		id : 'frmPathWayVerEdit'
		,height : 438
		,buttonAlign : 'center'
		,width : 600
		,title : '临床路径版本控制'
		,layout : 'fit'
		,modal : true
		,items:[
			obj.pnControl
		]

	});
	
	obj.btnHelp.on("click", function(){var winHelp=new InitWinHelpEdit(verID);winHelp.winScreen.show();});
	
	//add by wuqk 2011-09-19 路径的评估字典
	obj.btnEvaluateList.on("click", function(){var winbtnEvaluateList=new InitWinbtnEvaluateList(verID);winbtnEvaluateList.winScreen.show();});
	
	obj.cboPathDicStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.ClinPathWaysSrv';
			param.QueryName = 'QryPathWaysDic';
			param.ArgCnt = 0;
	});
	InitfrmPathWayVerEditEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

function InitWinHelpEdit(verID){
	var obj = new Object();
	
	var objcpw = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
	var verHelp=objcpw.GetHelpById(verID);
	obj.btnSaveHelp = new Ext.Button({
		id : 'btnSaveHelp'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 500
		,buttonAlign : 'center'
		,width : 680
		,layout : 'fit'
		,modal : true
		,title : '帮助信息'
		,items:{
        xtype: 'htmleditor',
        id : 'fieldHelp',
        enableColors: false,
        enableAlignments: false,
        value : verHelp
    }
		,buttons:[obj.btnSaveHelp]
	});
	saveHelp = function(){
		var help = Ext.getCmp("fieldHelp").getValue();
		var ret=objcpw.UpdateHelp(verID,help);
		if (eval(ret)<1){
			ExtTool.alert("提示", "保存失败,errCode="+ret);
		}
		else{
				obj.winScreen.close();
		}
	}
	obj.btnSaveHelp.on("click", saveHelp);
	return obj;
}


// add by wuqk 2011-09-19 for 路径评估字典
function InitWinbtnEvaluateList(verID){
	var obj = new Object();
	
	var objcpw = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
	var verEvaluateList=objcpw.GetEvaluateListById(verID);
	obj.btnSaveEva = new Ext.Button({
		id : 'btnSaveEva'
		,iconCls : 'icon-save'
		,text : '保存'
	});
		obj.MainGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.MainGridPanelStore = new Ext.data.Store({
		proxy: obj.MainGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'Type', mapping: 'Type'}
			,{name: 'checked', mapping: 'Matching'}
			,{name: 'unique', mapping: 'unique'}
		])
	});
	obj.MainGridPanelCheckCol = new Ext.grid.CheckColumn({header:'选择', dataIndex: 'checked', sortable: false});
	obj.MainGridPanelUnique = new Ext.grid.CheckColumn({header:'必填项', dataIndex: 'unique', sortable: false});
	obj.MainGridPanel = new Ext.grid.GridPanel({
		id : 'MainGridPanel'
		,store : obj.MainGridPanelStore
		,region : 'center'
		,viewConfig: {forceFit: true}
		,buttonAlign : 'center'
		,plugins : [obj.MainGridPanelCheckCol,obj.MainGridPanelUnique]
		,columns: [
			//{header: '大类',  dataIndex: 'CategDesc', sortable: true}
			obj.MainGridPanelCheckCol
			,obj.MainGridPanelUnique
			//,{header: '代码',  dataIndex: 'Code', sortable: false}
			,{header: '评估项目',  dataIndex: 'Desc', sortable: false}
			,{header: '类型',  dataIndex: 'Type', sortable: false,
				renderer:function(value, metaData, record, rowIndex, colIndex, store){
					//data: [['DIC', '字典'], ['B', '是否'], ['T', '文本'], ['D', '日期'], ['I', '整数'], ['N', '数值']]
					switch(value)
					{
						case "DIC":
							strRet="字典";
							break;
						case "B":
							strRet="是否";
							break;
						case "T":
							strRet="文本";
							break;
						case "D":
							strRet="日期";
							break;
						case "I":
							strRet="整数";
							break;
						case "N":
							strRet="数值";
							break;
					}
					return strRet;
				}
			}
		]
	});
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 500
		,buttonAlign : 'center'
		,width : 380
		,layout : 'fit'
		,modal : true
		,title : '评估项目'
		,items:obj.MainGridPanel
		,buttons:[obj.btnSaveEva]
	});
	
	/// d ##Class(%ResultSet).RunQuery("web.DHCCPW.MRC.BaseDicSubCategory","QrySubCateByCPWVer","")
 /*
	obj.aaStore.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseDicSubCategory';
			param.QueryName = 'QrySubCateByCPWVer';
			param.Arg1 = "Evaluate";
			param.Arg2 = verID;
			param.Arg3 = "";
			param.ArgCnt = 3;
	});
	obj.aaStore.load({
		callback : function(r,o,s){
			alert(r);
			}
		});
	*/
	
	obj.MainGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseDicSubCategory';
			param.QueryName = 'QrySubCategory';
			param.QueryName = 'QrySubCateByCPWVer';
			param.Arg1 = "Evaluate";
			param.Arg2 = verID;
			param.Arg3 = "";
			param.ArgCnt = 3;
	});
	obj.MainGridPanelStore.load();
	saveEvaluate = function(){
		//var help = Ext.getCmp("fieldHelp").getValue();
		
		var evaList="";
		var evaStore=obj.MainGridPanel.getStore();
		var evaColumnModel=obj.MainGridPanel.getColumnModel();
		for (var rowIndex=0;rowIndex<evaStore.getCount();rowIndex++){
			var objRec = evaStore.getAt(rowIndex);
			var subCateId=objRec.get("Rowid");
			var evaChecked=objRec.get("checked");
			var unique=objRec.get("unique");
			if (unique==true) {unique="1";}
			else {unique="0";}
			if (evaChecked=="1"){
				evaList=evaList+"^"+subCateId+":"+unique;
			}
		}
		var ret=objcpw.UpdateEvaluateList(verID,evaList);
		if (eval(ret)<1){
			ExtTool.alert("提示", "保存失败,errCode="+ret);
		}
		else{
				obj.winScreen.close();
		}
	}
	obj.btnSaveEva.on("click", saveEvaluate);
	return obj;
}
