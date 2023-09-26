function InitfrmPathWayVerEdit(verID,cpwDicID){
	var obj = new Object();
	obj.txtCode = new Ext.form.TextField({
		id : 'txtCode'
		,fieldLabel : '����'
		,disabled : true
		,width : 100
		,anchor : '98%'
	});
	obj.txtDesc = new Ext.form.TextField({
		id : 'txtDesc'
		,fieldLabel : '����'
		,disabled : true
		,width : 100
		,anchor : '98%'
	});
	obj.txtPathType = new Ext.form.TextField({
		id : 'txtPathType'
		,fieldLabel : '·������'
		,disabled : true
		,width : 100
		,anchor : '98%'
	});
	obj.txtIsActive = new Ext.form.TextField({
		id : 'txtIsActive'
		,fieldLabel : '�Ƿ���Ч'
		,disabled : true
		,width : 100
		,anchor : '98%'
	});
	obj.txtStartDate = new Ext.form.TextField({
		id : 'txtStartDate'
		,fieldLabel : '��ʼ����'
		,disabled : true
		,width : 100
		,anchor : '98%'
	});
	obj.txtToDate = new Ext.form.TextField({
		id : 'txtToDate'
		,fieldLabel : '��������'
		,disabled : true
		,width : 100
		,anchor : '98%'
	});
	
	obj.txtCost = new Ext.form.TextField({
		id : 'txtCost'
		,fieldLabel : '�ο�����'
		,width : 100
		,anchor : '98%'
	});
	obj.txtDays = new Ext.form.TextField({
		id : 'txtDays'
		,fieldLabel : '�ο�����'
		,width : 100
		,anchor : '98%'
	});
	obj.txtICD = new Ext.form.TextField({
		id : 'txtICD'
		,fieldLabel : '׼�����ICD'
		,width : 100
		,anchor : '98%'
	});
	obj.txtKeys = new Ext.form.TextField({
		id : 'txtKeys'
		,fieldLabel : '׼����Ϲؼ���'
		,width : 100
		,anchor : '98%'
	});
	obj.txtOperICD = new Ext.form.TextField({
		id : 'txtOperICD'
		,fieldLabel : '׼������ICD'
		,width : 100
		,anchor : '98%'
	});
	obj.txtOperKeys = new Ext.form.TextField({
		id : 'txtOperKeys'
		,fieldLabel : '׼�������ؼ���'
		,width : 100
		,anchor : '98%'
	});
	obj.txtLabel = new Ext.form.TextArea({
		id : 'txtLabel'
		,fieldLabel : '׼����ʾ'
		,width : 100
		,height : 60
		,anchor : '98%'
	});
	obj.txtVarReason = new Ext.form.TextArea({
		id : 'txtVarReason'
		,fieldLabel : '���켰ԭ�����'
		,width : 100
		,height : 60
		,anchor : '98%'
	});
	obj.txtVersion = new Ext.form.NumberField({
		id : 'txtVersion'
		,readOnly : true
		,fieldLabel : '�汾'
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
		,fieldLabel : '�ٴ�·���ֵ�'
		,valueField : 'Rowid'
		,editable : false
		,triggerAction : 'all'
	});
	
	obj.chkIsOffShoot = new Ext.form.Checkbox({
		id : 'chkIsOffShoot'
		,boxLabel : '<b>��֧��·��</b> ��֧��·����ҪΪÿ���뾶�Ļ���ѡ������в���,�ƶ�����·��'
	});
	
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '����'
	});
	obj.btnHelp = new Ext.Button({
		id : 'btnHelp'
		,iconCls : 'icon-edit'
		,text : '�ĵ�'
	});
	obj.btnEvaluateList = new Ext.Button({
		id : 'btnEvaluateList'
		,iconCls : 'icon-Evaluate'
		,text : '������Ŀ'
	});
	obj.pnControl = new Ext.form.FormPanel(
		{
			layout : "form"
			,frame : true
			,buttonAlign : "center"
			//,title : "�ٴ�·���汾ά��"
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
		,title : '�ٴ�·���汾����'
		,layout : 'fit'
		,modal : true
		,items:[
			obj.pnControl
		]

	});
	
	obj.btnHelp.on("click", function(){var winHelp=new InitWinHelpEdit(verID);winHelp.winScreen.show();});
	
	//add by wuqk 2011-09-19 ·���������ֵ�
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
		,text : '����'
	});
	
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 500
		,buttonAlign : 'center'
		,width : 680
		,layout : 'fit'
		,modal : true
		,title : '������Ϣ'
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
			ExtTool.alert("��ʾ", "����ʧ��,errCode="+ret);
		}
		else{
				obj.winScreen.close();
		}
	}
	obj.btnSaveHelp.on("click", saveHelp);
	return obj;
}


// add by wuqk 2011-09-19 for ·�������ֵ�
function InitWinbtnEvaluateList(verID){
	var obj = new Object();
	
	var objcpw = ExtTool.StaticServerObject("web.DHCCPW.MRC.ClinPathWaysSrv");
	var verEvaluateList=objcpw.GetEvaluateListById(verID);
	obj.btnSaveEva = new Ext.Button({
		id : 'btnSaveEva'
		,iconCls : 'icon-save'
		,text : '����'
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
	obj.MainGridPanelCheckCol = new Ext.grid.CheckColumn({header:'ѡ��', dataIndex: 'checked', sortable: false});
	obj.MainGridPanelUnique = new Ext.grid.CheckColumn({header:'������', dataIndex: 'unique', sortable: false});
	obj.MainGridPanel = new Ext.grid.GridPanel({
		id : 'MainGridPanel'
		,store : obj.MainGridPanelStore
		,region : 'center'
		,viewConfig: {forceFit: true}
		,buttonAlign : 'center'
		,plugins : [obj.MainGridPanelCheckCol,obj.MainGridPanelUnique]
		,columns: [
			//{header: '����',  dataIndex: 'CategDesc', sortable: true}
			obj.MainGridPanelCheckCol
			,obj.MainGridPanelUnique
			//,{header: '����',  dataIndex: 'Code', sortable: false}
			,{header: '������Ŀ',  dataIndex: 'Desc', sortable: false}
			,{header: '����',  dataIndex: 'Type', sortable: false,
				renderer:function(value, metaData, record, rowIndex, colIndex, store){
					//data: [['DIC', '�ֵ�'], ['B', '�Ƿ�'], ['T', '�ı�'], ['D', '����'], ['I', '����'], ['N', '��ֵ']]
					switch(value)
					{
						case "DIC":
							strRet="�ֵ�";
							break;
						case "B":
							strRet="�Ƿ�";
							break;
						case "T":
							strRet="�ı�";
							break;
						case "D":
							strRet="����";
							break;
						case "I":
							strRet="����";
							break;
						case "N":
							strRet="��ֵ";
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
		,title : '������Ŀ'
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
			ExtTool.alert("��ʾ", "����ʧ��,errCode="+ret);
		}
		else{
				obj.winScreen.close();
		}
	}
	obj.btnSaveEva.on("click", saveEvaluate);
	return obj;
}
