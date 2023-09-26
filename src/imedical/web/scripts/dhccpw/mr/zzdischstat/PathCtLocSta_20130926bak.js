PathCtLocSta=function(StartDate,EndDate,CtRowid,winTitle){
		this.StartDate=StartDate; //��ʼ����
		this.EndDate=EndDate;     //��������
		this.CtRowid=CtRowid;     //����Id
		this.PathStaStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
				url:ExtToolSetting.RunQueryPageURL	
		}));
		this.PathStaStore=new Ext.data.GroupingStore({
				proxy:this.PathStaStoreProxy,
				reader:new Ext.data.JsonReader({
						root:'record',
						totalProperty:'total',
						idProperty:'admId'
				},
				[
						{name:'CtRowid',mapping:'CtRowid'},
						{name:'admId',mapping:'admId'},
						{name:'cpwRowid',mapping:'cpwRowid'},
						{name:'pathRowid',mapping:'pathRowid'},
						{name:'PatientId',mapping:'PatientId'},
						{name:'PAPMIName',mapping:'PAPMIName'},
						{name:'sex',mapping:'sex'},
						{name:'PAPMIAge',mapping:'PAPMIAge'},
						{name:'PAAdmDocCodeDR',mapping:'PAAdmDocCodeDR'},
						{name:'admDate',mapping:'admDate'},
						{name:'DischgDate',mapping:'DischgDate'},
						{name:'cpwInDate',mapping:'cpwInDate'},
						{name:'cpwOutDate',mapping:'cpwOutDate'},
						{name:'days',mapping:'days'},
						{name:'const1',mapping:'const1'},
						{name:'ImplItemRatio',mapping:'ImplItemRatio'},
						{name:'CheckVar',mapping:'CheckVar'},
						{name:'pathStr',mapping:'pathStr'},
						{name:'DrugRatio',mapping:'DrugRatio'}
				]),
				sortInfo:{field:'pathRowid',direction:'ASC'},
				groupField:'pathStr'
		});
		this.PathStaGrid=new Ext.grid.GridPanel({
				id:'PathStaGrid',
				store:this.PathStaStore,
				region:"center",
				buttonAlign : 'center',
				columns:[
						{header:'��������',width:50,dataIndex:'PAPMIName',sortable:true},
						{header:'�Ա�',width:50,dataIndex:'sex',sortable:true},
						{header:'����',width:50,dataIndex:'PAPMIAge',sortable:true},
						{header:'ҽ��',dataIndex:'PAAdmDocCodeDR',sortable:true},
						{header:'סԺ����',dataIndex:'admDate',sortable:true},
						{header:'��Ժ����',dataIndex:'DischgDate',sortable:true},
						{header:'�뾶����',dataIndex:'cpwInDate',sortable:true},
						{header:'��������',dataIndex:'cpwOutDate',sortable:true},
						{header:'סԺ��',dataIndex:'days',sortable:true},
						{header:'סԺ����',dataIndex:'const1',sortable:true},
						{header:'ҩ�ѱ���',dataIndex:'DrugRatio',sortable:true},
						{header:'��ִ����Ŀ����',dataIndex:'ImplItemRatio',sortable:true},
						{header:'�Ƿ����',dataIndex:'CheckVar',sortable:true},
						{header:'�ٴ�·��',dataIndex:'pathRowid',sortable:true,hidden:true},
						{header:'������Ϣ',dataIndex:'pathStr',sortable:true,hidden:true}
				],
				view:new Ext.grid.GroupingView({
						forceFit:true,
						groupTextTpl:'{[values.rs[0].get("pathStr")]}',
						groupByText:'�����з���'
				})
		});
		this.rightMenu=new Ext.menu.Menu({
				id:'rigthtMenu',
				items:[
						{
							id:'VarMenu',
							text:'�鿴�����¼',
							handler:this.LookVar,
							scope:this
						}
				]
		});
		PathCtLocSta.superclass.constructor.call(this,{
				id:'PathCtLocStaWin',
				//height:600,
				//width:900,
				title:winTitle,
				maximized: true,
				modal:true,
				layout:'border',
				closeAction:'close',
				resizable:false,
				closable:true,
				items:[
						this.PathStaGrid		
				]
		});
		this.PathStaGrid.on('rowcontextmenu',this.rightClick,this);
		this.PathStaStoreProxy.on('beforeload',function(objProxy,param){
				param.ClassName='web.DHCCPW.MR.ClinPathWaysStat';
				param.QueryName='QryDischStatDetail';
				param.Arg1=this.StartDate;
				param.Arg2=this.EndDate;
				param.Arg3=this.CtRowid;
				param.ArgCnt=3;
		},this);
		this.PathStaStore.load({});
		
}
Ext.extend(PathCtLocSta,Ext.Window,{
		afterRender : function(){
        PathCtLocSta.superclass.afterRender.call(this);
    },
    show:function(){
				PathCtLocSta.superclass.show.apply(this,arguments);
		},
		CheckVarClick:function(checkVar){
				return '<a href="#" onclick="this.CheckVarClick1('+checkVar+')">ɾ��</a>';
		},
		rightClick:function(client, rowIndex, e){
				e.preventDefault();
				this.PathStaGrid.getSelectionModel().selectRow(rowIndex);
				this.rowIndex=rowIndex
				var record=this.PathStaStore.getAt(rowIndex);
				var checkVar=record.get('CheckVar');
				this.rightMenu.items.get('VarMenu').setDisabled(false);
				if(checkVar==""){
						this.rightMenu.items.get('VarMenu').setDisabled(true);
				}
        this.rightMenu.showAt(e.getXY());	
		},
		LookVar:function(){
				var record=this.PathStaStore.getAt(this.rowIndex);
				//var cpwRowid=record.get('cpwRowid');   //modify by wuqk 2011-07-26 Ӧ��ȡ�ٴ�·���뾶��¼id
				var cpwRowid=record.get('pathRowid');
				var patientName=record.get('PAPMIName');
				var str="<font color='Royal Blue'>����������</font>"+patientName+"&nbsp&nbsp&nbsp&nbsp�����¼�б�"
				this.PathWayVarWin=new PathWayVar(cpwRowid,str);
				this.PathWayVarWin.show();
		}
		
})
