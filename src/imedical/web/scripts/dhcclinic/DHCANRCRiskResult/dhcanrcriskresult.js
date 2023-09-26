function myRender(p){     
   Ext.Msg.alert("��ʾ",p.title+"��Ⱦ�ɹ�") ;     
 }
///Tab1ҳ����grid����Դ(����)
var retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
var retGridPanelStore = new Ext.data.Store({
		proxy: retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'OEOrdItemID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
		    ,{name: 'OEOrdItemID', mapping: 'OEOrdItemID'}
			,{name: 'OrdItemName', mapping: 'OrdItemName'}
			,{name: 'OrdItemDate', mapping: 'OrdItemDate'}
			,{name: 'OrdItemTime', mapping: 'OrdItemTime'}
			,{name: 'ResultStatus', mapping: 'ResultStatus'}
			,{name: 'LabEpisode', mapping: 'LabEpisode'}			
			,{name: 'LabTestSetRow', mapping: 'LabTestSetRow'}
			,{name: 'OrdSpecimen', mapping: 'OrdSpecimen'}
			,{name: 'SpecDate', mapping: 'SpecDate'}
			,{name: 'SpecTime', mapping: 'SpecTime'}
			,{name: 'RecDate', mapping: 'RecDate'}
			,{name: 'RecTime', mapping: 'RecTime'}
			,{name: 'AuthDate', mapping: 'AuthDate'}
			,{name: 'AuthTime', mapping: 'AuthTime'}
			,{name: 'PreReport', mapping: 'PreReport'}
			,{name: 'WarnComm', mapping: 'WarnComm'}
			,{name: 'ResultFlagDesc', mapping: 'ResultFlagDesc'}
			,{name: 'Note', mapping: 'Note'}
		])
});
var retGridPanelCheckCol = new Ext.grid.CheckColumn({
		header:'ѡ��', 
		dataIndex: 'checked', 
		width: 40
});
var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,retGridPanelCheckCol
			,{header: 'ҽ������', width: 140, dataIndex: 'OrdItemName', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'OrdItemDate', sortable: true}
			,{header: '����ʱ��', width: 70, dataIndex: 'OrdItemTime', sortable: true}
			,{header: '����״̬', width: 40, dataIndex: 'ResultStatus', sortable: true}			
			,{header: '�걾', width: 40, dataIndex: 'OrdSpecimen', sortable: true}
			,{header: '�ɼ�����', width: 100, dataIndex: 'SpecDate', sortable: true}
			,{header: '�ɼ�ʱ��', width: 70, dataIndex: 'SpecTime', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'RecDate', sortable: true}
			,{header: '����ʱ��', width: 70, dataIndex: 'RecTime', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'AuthDate', sortable: true}
			,{header: '����ʱ��', width: 70, dataIndex: 'AuthTime', sortable: true}
			,{header: '�걾״̬', width: 50, dataIndex: 'ResultFlagDesc', sortable: true}
			,{header: '�Ƿ���Ԥ����', width: 50, dataIndex: 'PreReport', sortable: true}
			,{header: 'Σ����ʾ', width: 50, dataIndex: 'WarnComm', sortable: true}			
			,{header: '��ע', width: 100, dataIndex: 'Note', sortable: true}
			,{header: 'ҽ��ID', width: 50, dataIndex: 'OEOrdItemID', sortable: true}
			,{header: '�����', width: 50, dataIndex: 'LabEpisode', sortable: true}
			,{header: '����ID', width: 50, dataIndex: 'LabTestSetRow', sortable: true}			
		]
});
var retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,height:650
		//,frame:true
		,cm:cm
		,autoScroll :true
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : retGridPanelStore,
			displayMsg: '��ʾ��¼: {0} - {1} �ϼ�: {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,plugins :retGridPanelCheckCol
});
var LabPanel = new Ext.Panel({
		id : 'LabPanel'
		,buttonAlign : 'center'
		,frame:true
		,region : 'center'
		//,height : 700	
		,items:[
			retGridPanel	
		]
});	
/*obj laboratoryPanel = new Ext.Panel({
		id : 'laboratoryPanel'		
		,items:[
			LabPanel
			,resultPanel			
		]
	});*/
///Tab2ҳ����grid����Դ(���)
var TestGPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
var TestGPanelStore = new Ext.data.Store({
		proxy: TestGPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'anrrDr'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
		    ,{name: 'TRegNo', mapping: 'TRegNo'}
			,{name: 'TStudyNo', mapping: 'TStudyNo'}
			,{name: 'TItemName', mapping: 'TItemName'}
			,{name: 'TItemDate', mapping: 'TItemDate'}
			,{name: 'TItemStatus', mapping: 'TItemStatus'}
			,{name: 'TOEOrderDr', mapping: 'TOEOrderDr'}			
			,{name: 'TIsIll', mapping: 'TIsIll'}
			,{name: 'TLocName', mapping: 'TLocName'}
			,{name: 'TreplocDr', mapping: 'TreplocDr'}
			,{name: 'TIshasImg', mapping: 'TIshasImg'}
			,{name: 'TMediumName', mapping: 'TMediumName'}
			,{name: 'TImgBrowse', mapping: 'TImgBrowse'}
			,{name: 'TImgShut', mapping: 'TImgShut'}
			,{name: 'TOpenRpt', mapping: 'TOpenRpt'}
			,{name: 'Memo', mapping: 'Memo'}
			,{name: 'AppTime', mapping: 'AppTime'}
			,{name: 'TMBrowse', mapping: 'TMBrowse'}			
		])
});
var TestGPanelCheckCol = new Ext.grid.CheckColumn({
		header:'ѡ��', 
		dataIndex: 'checked', 
		width: 40
});
var cmTest = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,TestGPanelCheckCol			
			,{header: '�ǼǺ�', width: 140, dataIndex: 'TRegNo', sortable: true}
			,{header: '����', width: 70, dataIndex: 'TStudyNo', sortable: true}
			,{header: 'ҽ������', width: 50, dataIndex: 'TItemName', sortable: true}
			,{header: 'ҽ������', width: 50, dataIndex: 'TItemDate', sortable: true}
			,{header: '�Ƿ񷢲�', width: 100, dataIndex: 'TItemStatus', sortable: true}
			,{header: 'TOEOrderDr', width: 100, dataIndex: 'TOEOrderDr', sortable: true}
			,{header: '�Ƿ�����', width: 80, dataIndex: 'TIsIll', sortable: true}
			,{header: '������', width: 140, dataIndex: 'TLocName', sortable: true}
			,{header: '�򿪱���', width: 100, dataIndex: 'TOpenRpt', sortable: true}
			,{header: '����DR', width: 140, dataIndex: 'TreplocDr', sortable: true}
			,{header: '�Ƿ���ͼ��', width: 80, dataIndex: 'TIshasImg', sortable: true}
			,{header: '����', width: 100, dataIndex: 'TMediumName', sortable: true}
			,{header: '���ͼ��', width: 100, dataIndex: 'TImgBrowse', sortable: true}
			,{header: '�ر�ͼ��', width: 100, dataIndex: 'TImgShut', sortable: true}			
			,{header: '��ע', width: 100, dataIndex: 'Memo', sortable: true}
			,{header: 'ԤԼʱ��', width: 100, dataIndex: 'AppTime', sortable: true}
			,{header: 'ע������', width: 100, dataIndex: 'TMBrowse', sortable: true}					
		]
});
var TestGPanel = new Ext.grid.EditorGridPanel({
		id : 'TestGPanel'
		,store : TestGPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		//,region : 'north'
		,buttonAlign : 'center'	
		,height:450
		,cm:cmTest		
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : TestGPanelStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,plugins : TestGPanelCheckCol
});
var txtTestResult = new Ext.form.TextArea({
		id : 'txtTestResult'
		//,height:100
		,width:1000
		,height:200
		//,region : 'center'
		//,wordWrap:true
		//,blankText:'�޼����'
		//,preventScrollbars:true
	});
var resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,title : '�鿴�����'
		,region : 'center'			
		,frame : true
		//,tbar:obj.tb
		,items:[
			txtTestResult		
		]
	});
var TestResutlPanel = new Ext.Panel({
		id : 'TestResutlPanel'
		//,height:600		
		,items:[
			TestGPanel
			,resultPanel			
		]
	});	
///Tab3ҳ����grid����Դ(����)
var ConstGPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
var ConstGPanelStore = new Ext.data.Store({
		proxy: ConstGPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ConTime'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
		    ,{name: 'ConDep', mapping: 'ConDep'}
			,{name: 'ConDoc', mapping: 'ConDoc'}
			,{name: 'Status', mapping: 'Status'}
			,{name: 'BedCode', mapping: 'BedCode'}
			,{name: 'PatDep', mapping: 'PatDep'}
			,{name: 'InOut', mapping: 'InOut'}			
			,{name: 'Diag', mapping: 'Diag'}
			,{name: 'Destination', mapping: 'Destination'}
			,{name: 'PatName', mapping: 'PatName'}
			,{name: 'AppTime', mapping: 'AppTime'}
			,{name: 'AppDate', mapping: 'AppDate'}
			,{name: 'ConDate', mapping: 'ConDate'}
			,{name: 'ConTime', mapping: 'ConTime'}
			,{name: 'Contyp', mapping: 'Contyp'}
			,{name: 'RequestConDoc', mapping: 'RequestConDoc'}
			,{name: 'RegNo', mapping: 'RegNo'}
			,{name: 'Bah', mapping: 'Bah'}
			,{name: 'RequireDateTime', mapping: 'RequireDateTime'}			
		])
});
var ConstGPanelCheckCol = new Ext.grid.CheckColumn({
		header:'ѡ��', 
		dataIndex: 'checked', 
		width: 40
});
var cmConst = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,ConstGPanelCheckCol			
			,{header: '�������', width: 100, dataIndex: 'ConDep', sortable: true}
			,{header: '����ҽ��', width: 70, dataIndex: 'ConDoc', sortable: true}
			,{header: '״̬', width: 50, dataIndex: 'Status', sortable: true}
			,{header: '��λ', width: 50, dataIndex: 'BedCode', sortable: true}
			,{header: '���˿���', width: 100, dataIndex: 'PatDep', sortable: true}
			,{header: 'Ժ��Ժ��', width: 70, dataIndex: 'InOut', sortable: true}
			,{header: '���', width: 80, dataIndex: 'Diag', sortable: true}
			,{header: '�������������Ŀ��', width: 140, dataIndex: 'Destination', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'PatName', sortable: true}
			,{header: '��������', width: 100, dataIndex: 'AppDate', sortable: true}
			,{header: '����ʱ��', width: 80, dataIndex: 'AppTime', sortable: true}			
			,{header: '�������', width: 100, dataIndex: 'ConDate', sortable: true}
			,{header: '���ʱ��', width: 80, dataIndex: 'ConTime', sortable: true}
			,{header: '����', width: 80, dataIndex: 'Contyp', sortable: true}			
			,{header: '����ҽ��', width: 80, dataIndex: 'RequestConDoc', sortable: true}
			,{header: '�ǼǺ�', width: 100, dataIndex: 'RegNo', sortable: true}
			,{header: '�����', width: 100, dataIndex: 'Bah', sortable: true}
			,{header: 'Ҫ���������ʱ��', width: 120, dataIndex: 'RequireDateTime', sortable: true}				
		]
});
var ConstGPanel = new Ext.grid.EditorGridPanel({
		id : 'TestGPanel'
		,store : ConstGPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		//,region : 'north'
		,buttonAlign : 'center'	
		 ,height:450
		,cm:cmConst		
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : TestGPanelStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,plugins : ConstGPanelCheckCol
});
var txtConstResult = new Ext.form.TextArea({
		id : 'txtConstResult'
		//,height:100
		,width:1000
		,height:200
		//,region : 'center'
		//,wordWrap:true
		//,blankText:'�޼����'
		//,preventScrollbars:true
	});
var ConstResPanel = new Ext.Panel({
		id : 'ConstResPanel'
		,buttonAlign : 'center'
		,title : '�鿴������'
		,region : 'center'			
		,frame : true
		//,tbar:obj.tb
		,items:[
			txtConstResult		
		]
	});
var ConstResutlPanel = new Ext.Panel({
		id : 'TestResutlPanel'
		//,height:600		
		,items:[
			ConstGPanel
			,ConstResPanel			
		]
	});	
var retGridPanel_rowclick=function() //����б���ȡ��������
{
		var selectObj = retGridPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {
			var LabEpisode=selectObj.get('LabEpisode');
			var OEOrdItemID=selectObj.get('OEOrdItemID');
			var LabTestSetRow=selectObj.get('LabTestSetRow');
			var OrdItemDate=selectObj.get('OrdItemDate');
			var OrdItemTime=selectObj.get('OrdItemTime');			
			var SpecDate=selectObj.get('SpecDate');			
			var SpecTime=selectObj.get('SpecTime');	
			//obj lnk= "dhclabviewoldresult.csp?"			
			var lnk= "dhclabreportforlis.csp?"
			var nwin="toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,height=700,width=960,top=0,left=0"
	   		//lnk+="OrderID="+OEOrdItemID+"&LabEpisode="+LabEpisode;
	   		lnk+="PatientBanner=1&PatientID=&TestSetRow="+LabTestSetRow+"&OrdItemDate="+OrdItemDate+"&OrderID="+OEOrdItemID+"&OrdItemTime="+OrdItemTime+"&OrdSpecimen="+"&SpecDate="+SpecDate+"&SpecTime="+SpecTime+"&OrdName="+"&OrderID="+OEOrdItemID
	   		window.open(lnk,"_blank","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,height=800,width=1100,top=10,left=30");
		    
		}
}
var TestGPanel_rowclick=function() //����б���ȡ�������
{
	txtTestResult.setValue("");
		var selectObj = TestGPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {
			var TStudyNo=selectObj.get('TStudyNo');
			var TOEOrderDr=selectObj.get('TOEOrderDr');
			if (TStudyNo==""){return;}			
			var retStr=tkMakeServerCall("web.DHCANRRisk","GetRptContent",TStudyNo);	
	    	if (retStr!="")
	    	{
				txtTestResult.setValue(retStr);
	    	} 		
		}
}
var ConstGPanel_rowclick=function() //����б���ȡ��������
{
	txtConstResult.setValue("");
		var selectObj = ConstGPanel.getSelectionModel().getSelected();
		if (selectObj)
	    {
			var ConDep=selectObj.get('ConDep');
			//obj TOEOrderDr=selectObj.get('TOEOrderDr');
			if (ConDep==""){return;}			
			var retStr=tkMakeServerCall("web.DHCANRRisk","GetConsultInfo","5061486^^^"+ConDep);	
	    	if (retStr!="")
	    	{
				txtConstResult.setValue(retStr);
	    	} 		
		}
}
retGridPanel.on("rowclick", retGridPanel_rowclick, "");
TestGPanel.on("rowclick", TestGPanel_rowclick, "");
ConstGPanel.on("rowclick", ConstGPanel_rowclick, "");
//alert(document.getElementById('EpisodeID').value );
//alert("EpisodeID");
//alert(Ext.getCmp('EpisodeID').getValue() );
Ext.onReady(function(){        
   var i = 4 ;
   Ext.QuickTips.init();   
   var obj = new Object();   
   //EpisodeID=document.getElementById('EpisodeID').value;  
   //alert(Ext.getCmp('EpisodeID').getValue() ); 
   //ע��:ÿ��Tab��ǩֻ��Ⱦһ��     
   var tabs = new Ext.TabPanel({     
       renderTo: Ext.getBody(),//����body��ǩ��     
       activeTab: 0,//��ʼ��ʾ�ڼ���Tabҳ     
       deferredRender: true,//�Ƿ�����ʾÿ����ǩ��ʱ������Ⱦ��ǩ�е�����.Ĭ��true     
       tabPosition: 'top',//��ʾTabPanelͷ��ʾ��λ��,ֻ������ֵtop��bottom.Ĭ����top
       enableTabScroll: false,//��Tab��ǩ����ʱ,���ֹ�����
       //autoScroll:true,
       scrollIncrement:100,
       //tabWidth:600,       
       //frame:true,
       //layout: 'fit',
       //renderTo: bd,     
       items: [{//Tab�ĸ���     
           title: '����',
           autoScroll:true,
           region:'center',    
           //html: 'A simple tab',              
           //listeners: {render:myRender}, //Ϊÿ��Tab��ǩ��Ӽ�����.����ǩ��Ⱦʱ����        
           items:[LabPanel]  //���GridPanel             
       },{     
           title: '���',
           autoScroll:true,   
           //html: 'Another one',     
           //listeners: {render: myRender},
           items:[TestResutlPanel]  //���GridPanel     
       },{     
           title: '����',
           autoScroll:true,    
           //autoLoad: 'test.html',    
           //closable: true,     
           //listeners: {render: myRender}
           items:[ConstResutlPanel]  //���GridPanel      
       }] 
   });     
        
   //��TabPanel�����������body����
   new Ext.Viewport({     
       layout: 'fit',     
       items: tabs     
   });
retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCLabOrder';
			param.QueryName = 'QueryOrderList';
			param.Arg1 = EpisodeID;
			param.Arg2 ="";
			param.Arg3 ="";						
			param.ArgCnt = 3;
});		
retGridPanelStore.load({
			
			params : {
				start:0
				,limit:50
			}
});   
TestGPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCRisclinicQueryOEItemDo';
			param.QueryName = 'QueryALLStudyByPaadmDR';
			param.Arg1 = EpisodeID;
			param.Arg2 = "";
			param.Arg3 = "";
			param.Arg4 = "";							
			param.ArgCnt = 4;
});		
TestGPanelStore.load({
			
			params : {
				start:0
				,limit:200
			}
});
ConstGPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCConsult';
			param.QueryName = 'GetConsultCheckPrn';
			param.Arg1 = EpisodeID;									
			param.ArgCnt = 1;
});		
ConstGPanelStore.load({
			
			params : {
				start:0
				,limit:200
			}
});     
});



