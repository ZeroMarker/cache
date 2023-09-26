InitView = function () {
	this.stDate=new Ext.form.DateField({
				id : 'stDate',
				//format : 'Y-m-d',
				width : 100,
				fieldLabel : '��ʼ����',
				anchor : '99%',
				//altFormats : 'Y-m-d|d/m/Y',
				value : new Date()
			});
	this.Condition1 = new Ext.Panel({
				id : 'Condition1',
				labelAlign : 'right',
				columnWidth : .20,
				layout : 'form',
				labelSeparator:'&nbsp',
				items : [this.stDate]
			});
	this.endDate=new Ext.form.DateField({
				id : 'endDate',
				//format : 'Y-m-d',
				width : 100,
				fieldLabel : '��������',
				anchor : '99%',
				//altFormats : 'Y-m-d|d/m/Y',
				value : new Date()
			});
	this.Condition2 = new Ext.Panel({
				id : 'Condition2',
				buttonAlign : 'center',
				labelAlign : 'right',
				columnWidth : .20,
				layout : 'form',
				labelSeparator:'&nbsp',
				items : [this.endDate]
			});
	this.admTypeStoreProxy =new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
		}))
	this.admTypeStore=new Ext.data.Store({
				proxy: this.admTypeStoreProxy,
				reader: new Ext.data.JsonReader({
				root: 'record',
				totalProperty: 'total',
				idProperty: 'code'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'desc', mapping: 'Desc'}
				,{name: 'code', mapping: 'Code'}
			])
		});
	this.admType=new Ext.form.ComboBox({
				id:"admType",
				minChars : 1,
				width : 100,
				store : this.admTypeStore,
				valueField : 'code',
				fieldLabel : "��������",
				allowBlank:false,
				emptyText:"��������",
				displayField : 'desc',
				anchor : '99%',
				triggerAction : 'all'
		});
	this.admTypeStoreProxy.on('beforeload', function(thisProxy, param){
			param.ClassName = 'web.DHCCVCommon';
			param.QueryName = 'AdmType';
			//param.Arg1 = ?;    
			param.ArgCnt=0;
		},this);
	
	this.Condition3 = new Ext.Panel({
				id : 'Condition3',
				buttonAlign : 'center',
				labelAlign : 'right',
				columnWidth : .20,
				layout : 'form',
				labelSeparator:'&nbsp',
				items : [this.admType]
			});
	
	this.ProcessStatusStoreProxy =new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
		}))
	this.ProcessStatusStore=new Ext.data.Store({
			proxy: this.ProcessStatusStoreProxy,
			reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'code'
			}, 
			[
				{name: 'checked', mapping : 'checked'}
				,{name: 'desc', mapping: 'Desc'}
				,{name: 'code', mapping: 'Code'}
			])
		});
	this.ProcessStatus=new Ext.form.ComboBox({
				id:"ProcessStatus",
				minChars : 1,
				width : 100,
				store : this.ProcessStatusStore,
				valueField : 'code',
				fieldLabel : "����״̬",
				allowBlank:false,
				emptyText:"����״̬",
				displayField : 'desc',
				anchor : '99%',
				triggerAction : 'all'
		});
	this.ProcessStatusStoreProxy.on('beforeload', function(thisProxy, param){
			param.ClassName = 'web.DHCCVCommon';
			param.QueryName = 'ProcessStatus';
			//param.Arg1 = ?;    
			param.ArgCnt=0;
		},this);
	this.Condition4 = new Ext.Panel({
				id : 'Condition4',
				buttonAlign : 'center',
				labelAlign : 'right',
				columnWidth : .20,
				layout : 'form',
				labelSeparator:'&nbsp',
				items : [this.ProcessStatus]
			});
	var Data=[['1','����'],['2','����'],['3','�ĵ�'],['4','����'],['5','�ھ�'],['6','����']]
	var ComboStore=new Ext.data.SimpleStore({
			fields:['id','desc'],
			data:Data
	});
	this.RepStyle=new Ext.form.ComboBox({
			id:'RepStyle',
			store: ComboStore,
			displayField:'desc',
			valueField : 'id',
			//editable:false,
			fieldLabel : "��������",
			allowBlank:false,
			emptyText:"��������",
			mode : 'local',
			anchor : '90%',
			triggerAction : 'all'
	})
	this.Condition5 = new Ext.Panel({
				id : 'Condition5',
				buttonAlign : 'center',
				labelAlign : 'right',
				columnWidth : .20,
				layout : 'form',
				labelSeparator:'&nbsp',
				items : [this.RepStyle]
	});
	this.btnSearch = new Ext.Button({
				id : 'btnSearch',
				width: 100,
				iconCls: 'c-btn-save',
				text : '��ѯ'
		});
	this.btnSearch.on("click", this.btnSearchclick, this)
	this.GridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL
		}));
		
	this.GridStore=new Ext.data.Store({
			proxy:this.GridStoreProxy,
			reader:new Ext.data.JsonReader({
					root:'record',
					totalProperty:'total',
					idProperty:'ReportId'
					},
					[
							{name:'ReportId',mapping:'ReportId'},
							{name:'DebtorNo',mapping:'DebtorNo'},
							{name:'PatName',mapping:'PatName'},
							{name:'Species',mapping:'Species'},
							{name:'DOB',mapping:'DOB'},
							{name:'Age',mapping:'Age'},
							{name:'Doctor',mapping:'Doctor'},
							{name:'LabEpis',mapping:'LabEpis'},
							{name:'TestSet',mapping:'TestSet'},
							{name:'MobPhone',mapping:'MobPhone'},
							{name:'ToPerson',mapping:'ToPerson'},
							{name:'TransMemo',mapping:'TransMemo'},
							{name:'TransDate',mapping:'TransDate'},
							{name:'TransDTime',mapping:'TransDTime'},
							{name:'TransUser',mapping:'TransUser'},
							{name:'ReportType',mapping:'ReportType'}						
					])	
	});
	this.Grid=new Ext.grid.GridPanel({
			id:'Grid',
			region : 'center',
			store:this.GridStore,
			viewConfig: {forceFit: true},
			//autoHeight:true,
			listeners:{    
				rowdblclick :function(o,row,e){
					debugger;
					var a= o.store.getAt(row);
					var ReportId=a.get("ReportId")
					var ReportType=a.get("ReportType")
					var objUrl="criticalvalue.trans.csp"+"?ReportId="+ReportId+"&RepType="+ReportType;
					var ret=window.showModalDialog(objUrl,"","dialogwidth:900px;dialogheight:475px;status:no;center:1;resizable:yes");
					//var ObjCV=new  CVTransMain(ReportId,ReportType)   
					//ObjCV.show();
					o.store.load();
					}
			    }, 
			columns:[
					new Ext.grid.RowNumberer(),
					{header:'����ID',dataIndex:'ReportId',sortable: true},
					{header:'�ǼǺ�',dataIndex:'DebtorNo',sortable: true},
					{header:'��������',dataIndex:'PatName',sortable: true},
					{header:'�Ա�',dataIndex:'Species',sortable: true},
					{header:'��������',dataIndex:'DOB',sortable: true},
					{header:'����',dataIndex:'Age',sortable: true},
					{header:'Doctor',dataIndex:'Doctor',sortable: true},
					{header:'�걾��',dataIndex:'LabEpis',sortable: true},
					{header:'TestSet',dataIndex:'TestSet',sortable: true},
					{header:'��ϵ�˵绰',dataIndex:'MobPhone',sortable: true},
					{header:'��ϵ��',dataIndex:'ToPerson',sortable: true},
					{header:'������',dataIndex:'TransMemo',sortable: true},
					{header:'��������',dataIndex:'TransDate',sortable: true},
					{header:'����ʱ��',dataIndex:'TransDTime',sortable: true},
					{header:'������',dataIndex:'TransUser',sortable: true},
					{header:'��������',dataIndex:'ReportType',sortable:true,hidden:true}
					
			],
			bbar: new Ext.PagingToolbar({
				store: this.GridStore,
				pageSize : 100,
				displayInfo: true,
				displayMsg: '��ʾ��{0}����{1}����¼���� {2} ��',
				emptyMsg: "û�м�¼"
			})
	});
	this.GridStoreProxy.on('beforeload', function(thisProxy, param){
		param.ClassName = 'web.DHCAntCVReportSearch';
		param.QueryName = 'GetCVReport';
		param.Arg1 = this.stDate.getValue();
		param.Arg2 = this.endDate.getValue();
		param.Arg3 = '';     //LOCID
		param.Arg4 =  this.ProcessStatus.getValue();     //TransStatus
		param.Arg5 = this.admType.getValue();    //admType
		param.Arg6 = this.RepStyle.getValue();       //2;      //ReportStatus
		param.ArgCnt=6;
	 },this);  
	this.ConditionPanel=new Ext.Panel({
				id : 'ConditionPanel',
				buttonAlign : 'center',
				title:'Σ��ֵ��ѯ',
				iconCls: 'c-useaim-icon',
				labelAlign : 'right',
				labelWidth : 60,
				//bodyBorder : 'padding:0 0 0 0',
				layout : 'column',
				region : 'north',
				frame : true,
				height : 110,
				items : [
					{
							columnWidth:.20,
							layout:'form',
							items:[
									this.Condition1,
									this.Condition2
							]
					},{
							columnWidth:.20,
							layout:'form',
							items:[
									this.Condition3,
									this.Condition4
							]
					},{
							columnWidth:.20,
							layout:'form',
							items:[
									this.Condition5,
									this.btnSearch
									
							]
					},{
							columnWidth:.20,
							layout:'form',
							items:[
									this.btnSearch
									
							]
					}]   //this.ProcessStatus]
				//buttons:[this.btnSearch]
			});
	this.GridStore.load();
	InitView.superclass.constructor.call(this,{
				//region : 'center',
				//closeAction:'close',
				layout:'border',
				resizable:false,
				//closable:true,
				autoScroll:true,         //������������⡣
				modal:true,
				items:[this.ConditionPanel,this.Grid]
		})
	
}
Ext.extend(InitView,Ext.Panel,{
	btnSearchclick:function(){
		var store = this.GridStore;
		store.load({params : {start:0,limit:100}});
	}
})