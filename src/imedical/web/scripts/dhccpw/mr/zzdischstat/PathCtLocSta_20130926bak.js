PathCtLocSta=function(StartDate,EndDate,CtRowid,winTitle){
		this.StartDate=StartDate; //开始日期
		this.EndDate=EndDate;     //结束日期
		this.CtRowid=CtRowid;     //科室Id
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
						{header:'病人姓名',width:50,dataIndex:'PAPMIName',sortable:true},
						{header:'性别',width:50,dataIndex:'sex',sortable:true},
						{header:'年龄',width:50,dataIndex:'PAPMIAge',sortable:true},
						{header:'医生',dataIndex:'PAAdmDocCodeDR',sortable:true},
						{header:'住院日期',dataIndex:'admDate',sortable:true},
						{header:'出院日期',dataIndex:'DischgDate',sortable:true},
						{header:'入径日期',dataIndex:'cpwInDate',sortable:true},
						{header:'出径日期',dataIndex:'cpwOutDate',sortable:true},
						{header:'住院日',dataIndex:'days',sortable:true},
						{header:'住院费用',dataIndex:'const1',sortable:true},
						{header:'药费比例',dataIndex:'DrugRatio',sortable:true},
						{header:'已执行项目比例',dataIndex:'ImplItemRatio',sortable:true},
						{header:'是否变异',dataIndex:'CheckVar',sortable:true},
						{header:'临床路径',dataIndex:'pathRowid',sortable:true,hidden:true},
						{header:'基本信息',dataIndex:'pathStr',sortable:true,hidden:true}
				],
				view:new Ext.grid.GroupingView({
						forceFit:true,
						groupTextTpl:'{[values.rs[0].get("pathStr")]}',
						groupByText:'依本列分组'
				})
		});
		this.rightMenu=new Ext.menu.Menu({
				id:'rigthtMenu',
				items:[
						{
							id:'VarMenu',
							text:'查看变异记录',
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
				return '<a href="#" onclick="this.CheckVarClick1('+checkVar+')">删除</a>';
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
				//var cpwRowid=record.get('cpwRowid');   //modify by wuqk 2011-07-26 应该取临床路径入径记录id
				var cpwRowid=record.get('pathRowid');
				var patientName=record.get('PAPMIName');
				var str="<font color='Royal Blue'>病人姓名：</font>"+patientName+"&nbsp&nbsp&nbsp&nbsp变异记录列表"
				this.PathWayVarWin=new PathWayVar(cpwRowid,str);
				this.PathWayVarWin.show();
		}
		
})
