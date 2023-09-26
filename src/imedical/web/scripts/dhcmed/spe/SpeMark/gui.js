function SPM_InitSpeMarkWin(objInput){
	var obj = new Object();
	obj.SPM_Input = new Object();
	obj.SPM_Input.SpeID     = objInput.SpeID;
	obj.SPM_Input.EpisodeID = objInput.EpisodeID;
	obj.SPM_Input.OperTpCode  = objInput.OperTpCode;
	
	obj.SPM_txtPatBaseInfo = Common_TextArea("SPM_txtPatBaseInfo","������Ϣ",55);
	obj.SPM_txtNote = Common_TextArea("SPM_txtNote","���˵��",60);
	obj.SPM_txtMarkDate = Common_TextField("SPM_txtMarkDate","�������");
	obj.SPM_txtCurrStatus = Common_TextField("SPM_txtCurrStatus","��ǰ״̬");
	obj.SPM_txtCheckOpinion = Common_TextArea("SPM_txtCheckOpinion","������",60);
	obj.SPM_txtCheckDate = Common_TextField("SPM_txtCheckDate","�������");
	obj.SPM_cboPrognosis = Common_ComboToDic("SPM_cboPrognosis","ת��","SPEPrognosis");
	obj.SPM_txtFinalDate = Common_TextField("SPM_txtFinalDate","�ر�����");
	
	obj.SPM_cboPatTypeSubStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.SPM_cboPatTypeSubStore = new Ext.data.Store({
		proxy: obj.SPM_cboPatTypeSubStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PTSID'
		}, 
		[
			{name: 'PTSID', mapping: 'PTSID'}
			,{name: 'PTSCode', mapping: 'PTSCode'}
			,{name: 'PTSDesc', mapping: 'PTSDesc'}
			,{name: 'IsActive', mapping: 'PTSIsActiveDesc'}
			,{name: 'PTSIcon', mapping: 'PTSIcon'}
			,{name: 'PTSAutoMarkDesc', mapping: 'PTSAutoMarkDesc'}
			,{name: 'PTSAutoCheckDesc', mapping: 'PTSAutoCheckDesc'}
			,{name: 'PTSAutoCloseDesc', mapping: 'PTSAutoCloseDesc'}
			,{name: 'ResumeText', mapping: 'PTSResume'}
		])
	});
	obj.SPM_cboPatTypeSub = new Ext.form.ComboBox({
		id : 'SPM_cboPatTypeSub'
		,width : 50
		,store : obj.SPM_cboPatTypeSubStore
		,minChars : 0
		,valueField : 'PTSID'
		,displayField : 'PTSDesc'
		,fieldLabel : '�������'
		,labelSeparator :''
		,editable : false
		,triggerAction : 'all'
		,anchor : '100%'
	});
	
	obj.SPM_btnMark = new Ext.Button({
		id : 'SPM_btnMark'
		,iconCls : 'icon-save'
		,text : '���'
		,width : 60
	});
	obj.SPM_btnUpdoMark = new Ext.Button({
		id : 'SPM_btnUpdoMark'
		,iconCls : 'icon-save'
		,text : '����'
		,width : 60
	});
	obj.SPM_btnCheck = new Ext.Button({
		id : 'SPM_btnCheck'
		,iconCls : 'icon-save'
		,text : '���'
		,width : 60
	});
	obj.SPM_btnUpdoCheck = new Ext.Button({
		id : 'SPM_btnUpdoCheck'
		,iconCls : 'icon-save'
		,text : 'ȡ�����'
		,width : 60
	});
	obj.SPM_btnClose = new Ext.Button({
		id : 'SPM_btnClose'
		,iconCls : 'icon-save'
		,text : '�ر�'
		,width : 60
	});
	obj.SPM_btnUpdoClose = new Ext.Button({
		id : 'SPM_btnUpdoClose'
		,iconCls : 'icon-save'
		,text : '�����ر�'
		,width : 60
	});
	obj.SPM_btnCancel = new Ext.Button({
		id : 'SPM_btnCancel'
		,iconCls : 'icon-exit'
		,text : '�˳�'
		,width : 60
	});
	
	obj.SPM_FormPanel = new Ext.form.FormPanel({
		id : 'SPM_FormPanel'
		,layout : 'form'
		,frame : true
		,labelWidth : 60
		,labelAlign : 'right'
		,items:[
			obj.SPM_txtPatBaseInfo
			,obj.SPM_cboPatTypeSub
			,obj.SPM_txtNote
			,obj.SPM_txtMarkDate
			,obj.SPM_txtCurrStatus
			,obj.SPM_txtCheckOpinion
			,obj.SPM_txtCheckDate
			,obj.SPM_cboPrognosis
			,obj.SPM_txtFinalDate
		]
	});
	
	obj.SPM_WinSpeMark = new Ext.Window({
		id : 'SPM_WinSpeMark'
		,height : 440
		,buttonAlign : 'center'
		,width : 350
		,title : '������⻼��'
		,layout : 'fit'
		,modal : true
		,items:[
			obj.SPM_FormPanel
		]
		,buttons:[
			obj.SPM_btnMark
			,obj.SPM_btnUpdoMark
			,obj.SPM_btnCheck
			,obj.SPM_btnUpdoCheck
			,obj.SPM_btnClose
			,obj.SPM_btnUpdoClose
			,obj.SPM_btnCancel
		]
		,listeners: {
			"close":function(){
				obj.SPM_WinSpeMark_close();
			}
		}
	});
	
	obj.SPM_cboPatTypeSubStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.SPEService.PatTypeSub';
		param.QueryName = 'QryPatTypeSubActive';
		param.Arg1 = '';
		param.ArgCnt = 1;
	});
	
	SPM_InitSpeMarkWinEvent(obj);
	obj.SPM_LoadEvent();
	return obj;
}
