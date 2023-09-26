PathWayVar=function(cpwRowid,WinTitle){
		this.CpwRowid=cpwRowid
		if(WinTitle==""){
				this.WinTitle="�����¼�б�"
		}
		this.WinTitle=WinTitle
		this.PathWayVarStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
				url : ExtToolSetting.RunQueryPageURL,
				timeout:300000           //add by wuqk 2011-08-10
		}));
		this.PathWayVarStore = new Ext.data.Store({
				proxy: this.PathWayVarStoreProxy,
				reader: new Ext.data.JsonReader({
					root: 'record',
					totalProperty: 'total',
					idProperty: 'VID'
				}, 
				[
					{name: 'checked', mapping : 'checked'}
					,{name: 'VID', mapping: 'VID'}
					,{name: 'VEpisodeDR', mapping: 'VEpisodeDR'}
					,{name: 'VEpisodeDesc', mapping: 'VEpisodeDesc'}
					,{name: 'VCategoryDR', mapping: 'VCategoryDR'}
					,{name: 'VCategoryDesc', mapping: 'VCategoryDesc'}
					,{name: 'VReasonDR', mapping: 'VReasonDR'}
					,{name: 'VReasonDesc', mapping: 'VReasonDesc'}
					,{name: 'VUserDR', mapping: 'VUserDR'}
					,{name: 'VUserDesc', mapping: 'VUserDesc'}
					,{name: 'VDate', mapping: 'VDate'}
					,{name: 'VTime', mapping: 'VTime'}
					,{name: 'VNote', mapping: 'VNote'}
					,{name: 'VDoctorDR', mapping: 'VDoctorDR'}
					,{name: 'VDoctorDesc', mapping: 'VDoctorDesc'}
				])
		});
		this.PathWayVarGrid = new Ext.grid.GridPanel({
		id : 'PathWayVarGrid'
		,store : this.PathWayVarStore
		,region : 'center'
		,buttonAlign : 'center'
		,viewConfig : {forceFit:true}
		,columns: [
			{header: '�׶�', width: 100, dataIndex: 'VEpisodeDesc', sortable: false}
			,{header: 'ȷ��ҽ��', width: 100, dataIndex: 'VDoctorDesc', sortable: false}
			,{header: '��������', width: 100, dataIndex: 'VCategoryDesc', sortable: false}
			,{header: '����ԭ��', width: 100, dataIndex: 'VReasonDesc', sortable: false}
			,{header: '������', width: 100, dataIndex: 'VUserDesc', sortable: false}
			,{header: '��������', width: 100, dataIndex: 'VDate', sortable: true}
			,{header: '����ʱ��', width: 100, dataIndex: 'VTime', sortable: false}
			,{header: '��ע', width: 200, dataIndex: 'VNote', sortable: false}
		]
	});
	
		PathWayVar.superclass.constructor.call(this,{
				id:'PathWayVarWin',
				height:500,
				width:900,
				title : this.WinTitle,
				modal:true,
				layout:'border',
				closeAction:'close',
				resizable:false,
				closable:true,
				items:[
						this.PathWayVarGrid		
				]
		});	
		this.PathWayVarStoreProxy.on('beforeload', function(objProxy, param){
				param.ClassName = 'web.DHCCPW.MR.ClinPathWaysVariance';
				param.QueryName = 'QryVarianceByCPW';
				if (this.CpwRowid){
					param.Arg1 = this.CpwRowid;
				}else{
					param.Arg1 = "";
				}
				param.ArgCnt = 1;
		},this);
		this.PathWayVarStore.load({});
};
Ext.extend(PathWayVar,Ext.Window,{
		afterRender : function(){
        PathCtLocSta.superclass.afterRender.call(this);
    },
    show:function(){
				PathCtLocSta.superclass.show.apply(this,arguments);
		}	
});