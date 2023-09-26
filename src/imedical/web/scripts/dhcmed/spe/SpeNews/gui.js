var objScreen = new Object();
function SPN_InitSpeNewsWin(objInput){
	var obj = objScreen;
	obj.SPN_Input = new Object();
	obj.SPN_Input.SpeID     = objInput.SpeID;
	obj.SPN_Input.OperTpCode  = objInput.OperTpCode;
	
	obj.SPN_txtOpinion = Common_TextField("SPN_txtOpinion","��Ϣ");
	
	obj.SPN_btnSend = new Ext.Button({
		id : 'SPN_btnSend'
		,iconCls : 'icon-save'
		,text : '������Ϣ'
		,width : 60
	});
	obj.SPN_btnRead = new Ext.Button({
		id : 'SPN_btnRead'
		,iconCls : 'icon-save'
		,text : '�Ķ���Ϣ'
		,width : 60
	});
	obj.SPN_btnCancel = new Ext.Button({
		id : 'SPN_btnCancel'
		,iconCls : 'icon-exit'
		,text : '�˳�'
		,width : 60
	});
	
	//��Ϣ�б�
	obj.SPN_gridSpeNewsListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.SPN_gridSpeNewsListStore = new Ext.data.Store({
		proxy: obj.SPN_gridSpeNewsListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'SpeLogID'
		}, 
		[
			{name: 'SpeLogID', mapping : 'SpeLogID'}
			,{name: 'NewsType', mapping : 'NewsType'}
			,{name: 'NewsTypeDesc', mapping : 'NewsTypeDesc'}
			,{name: 'Opinion', mapping : 'Opinion'}
			,{name: 'ActDate', mapping : 'ActDate'}
			,{name: 'ActTime', mapping : 'ActTime'}
			,{name: 'ActUserID', mapping : 'ActUserID'}
			,{name: 'ActUserDesc', mapping : 'ActUserDesc'}
			,{name: 'IsRead', mapping : 'IsRead'}
			,{name: 'ReadStatus', mapping : 'ReadStatus'}
			,{name: 'ReadDate', mapping : 'ReadDate'}
			,{name: 'ReadTime', mapping : 'ReadTime'}
			,{name: 'ReadUserID', mapping : 'ReadUserID'}
			,{name: 'ReadUserDesc', mapping : 'ReadUserDesc'}
		])
	});
	obj.SPN_gridSpeNewsList = new Ext.grid.GridPanel({
		id : 'SPN_gridSpeNewsList'
		,store : obj.SPN_gridSpeNewsListStore
		,region : 'center'
		,buttonAlign : 'center'
		,loadMask : { msg : '���ڶ�ȡ����,���Ժ�...'}
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '����', width: 60, dataIndex: 'NewsTypeDesc', sortable: true, align: 'center'
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '��Ϣ', width: 200, dataIndex: 'Opinion', sortable: true, align: 'left'
				,renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					return v;
				}
			}
			,{header: '��������', width: 80, dataIndex: 'ActDate', sortable: true, align: 'center'}
			,{header: '������', width: 70, dataIndex: 'ActUserDesc', sortable: true, align: 'center'}
			,{header: '״̬', width: 50, dataIndex: 'ReadStatus', sortable: true, align: 'center'}
			,{header: '�Ķ�����', width: 80, dataIndex: 'ReadDate', sortable: true, align: 'center'}
			,{header: '�Ķ���', width: 70, dataIndex: 'ReadUserDesc', sortable: true, align: 'center'}
			,{header: '����', width: 80, dataIndex: 'SpeLogID', sortable: true, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var SpeLogID = rd.get("SpeLogID");
					var IsRead =rd.get("IsRead");
					if (IsRead==0){
						return " <a href='#' onclick='objScreen.btnDeleteNews_Click(\"" + SpeLogID + "\");'>ɾ��</a>";
					}else{
						return " <a href='#' style='color:gray;'>ɾ��</a>";
		
					}
						
					
				}
			}
		]
		,iconCls: 'icon-grid'
		,viewConfig : {
			forceFit : true
		}
	});
	
	obj.SPN_WinSpeNews = new Ext.Window({
		id : 'SPN_WinSpeNews'
		,height : 450
		,width : 700
		,title : '���⻼����Ϣ'
		,layout : 'border'
		,modal : true
		,items:[
			{
				layout : 'fit'
				,region : 'center'
				,frame : true
				,items:[obj.SPN_gridSpeNewsList]
			},{
				layout : 'form'
				,region : 'south'
				,height : 40
				,frame : true
				,items :[
					{
						layout : 'column'
						,items : [
							{
								width: 400
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 40
								,items: [obj.SPN_txtOpinion]
							},{
								width:80
								,layout : 'form'
								,items: [obj.SPN_btnSend]
							},{
								width:10
							},{
								width:80
								,layout : 'form'
								,items: [obj.SPN_btnRead]
							},{
								width:10
							},{
								width:70
								,layout : 'form'
								,items: [obj.SPN_btnCancel]
							}
						]
					}
				]
			}
		]
		,listeners: {
			"close":function(){
				obj.SPN_WinSpeNews_close();
			}
		}
	});
	
	obj.SPN_gridSpeNewsListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCMed.SPEService.PatientsQry"
		param.QueryName = "QryNewsBySpeID"
		param.Arg1 = obj.SPN_Input.SpeID;
		param.ArgCnt = 1;
	});
	
	SPN_InitSpeNewsWinEvent(obj);
	obj.SPN_LoadEvent();
	return obj;
}
