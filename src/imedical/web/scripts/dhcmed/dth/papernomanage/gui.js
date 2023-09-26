function InitDMPaperNo()
{
    var DMPaperNo=new Object();
	DMPaperNo.CobStatus = Common_ComboToDic("CobStatusId","状态","DTHCurrencyState");
    
	DMPaperNo.BtnQuery=new Ext.Button({
        id:'BtnQueryId'
        ,text:'查询'
        ,iconCls:'icon-find'
    });
	DMPaperNo.BtnStorage=new Ext.Button({
        id:'BtnStorageId'
        ,text:'入库'
        ,iconCls:'icon-exit'
    });
	DMPaperNo.BtnDistri=new Ext.Button({
        id:'BtnDistriId'
        ,text:'分配'
        ,iconCls:'icon-exit'
    });
	DMPaperNo.BtnDistriRepeat=new Ext.Button({
        id:'BtnDistriRepeatId'
        ,text:'重新分配'
        ,iconCls:'icon-exit'
    });
	DMPaperNo.cboSSHosp = Common_ComboToSSHosp("cboSSHosp","医院",SSHospCode,"DTH");
	DMPaperNo.CobLoc = Common_ComboToLoc("CobLocId","使用科室","","","","cboSSHosp");
	DMPaperNo.FirstPanel=new Ext.Panel({
        id:'FirstPanelId'
        ,layout:'column'
        ,title:''
        ,items:[
            {
				items:DMPaperNo.CobStatus
				,layout:'form'
				,width : 200
				,labelWidth:55
            }
			,{
				items:DMPaperNo.cboSSHosp
				,layout:'form'
				,width : 210
				,labelWidth:60
				,labelAlign : 'right'
			}
			,{
				items:DMPaperNo.CobLoc
				,layout:'form'
				,width : 250
				,labelWidth:60
				,labelAlign : 'right'
			}
			,{
				width : 10
			}
			,{
				//items:DMPaperNo.BtnDistri,
				layout:'form'
				,width : 65
				,labelWidth:55
			}
			,{
				items:DMPaperNo.BtnQuery
				,layout:'form'
				,width : 65
				,labelWidth:55
			}
            ,{
				items:DMPaperNo.BtnStorage
				,layout:'form'
				,width : 65
				,labelWidth:55
			}
			,{
				//items:DMPaperNo.BtnDistriRepeat,
				layout:'form'
				,width : 75
				,labelWidth:65
			}
        ]
    });
	
	
	DMPaperNo.gridPaperNoStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	DMPaperNo.gridPaperNoStore = new Ext.data.Store({
		proxy: DMPaperNo.gridPaperNoStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PaperNo'
		},
		[
			{name: 'PaperNoID', mapping : 'PaperNoID'},
			{name: 'PaperNo', mapping : 'PaperNo'},
			{name: 'StLoc', mapping : 'StLoc'},
			{name: 'StDoctor', mapping : 'StDoctor'},
			{name: 'StDate', mapping : 'StDate'},
			{name: 'StTime', mapping : 'StTime'},
			{name: 'AllocLoc', mapping : 'AllocLoc'},
			{name: 'Status', mapping : 'Status'},
			{name: 'OneFlag', mapping : 'OneFlag'},
			{name: 'ThreeFlag', mapping : 'ThreeFlag'}

		])
	});
	DMPaperNo.sm = new Ext.grid.CheckboxSelectionModel({width:25});
	DMPaperNo.gridPaperNo = new Ext.grid.GridPanel({
		id : 'gridPaperNo'
		,store : DMPaperNo.gridPaperNoStore
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,sm :DMPaperNo.sm
		,columns: [
			new Ext.grid.RowNumberer(),
			DMPaperNo.sm,
			{header: '纸单号', width: 60, dataIndex: 'PaperNo', sortable: false, menuDisabled:true, align: 'center'},
			{header: '状态', width: 80, dataIndex: 'Status', sortable: false, menuDisabled:true, align: 'center'},
			{header: '入库科室', width: 120, dataIndex: 'StLoc', sortable: false, menuDisabled:true, align: 'center'},
			{header: '入库人', width: 80, dataIndex: 'StDoctor', sortable: false, menuDisabled:true, align: 'center'},
			{header: '操作日期', width: 60, dataIndex: 'StDate', sortable: false, menuDisabled:true, align: 'center'},
			{header: '操作时间', width: 60, dataIndex: 'StTime', sortable: false, menuDisabled:true, align: 'center'},
			{header: '使用科室', width: 120, dataIndex: 'AllocLoc', sortable: false, menuDisabled:true, align: 'center'},
			{header: '首联', width: 60, dataIndex: 'OneFlag', sortable: false, menuDisabled:true, align: 'center'},
			{header: '三联', width: 60, dataIndex: 'ThreeFlag', sortable: false, menuDisabled:true, align: 'center'}
			
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
    DMPaperNo.LeftPanel=new Ext.Panel({
        id:'LeftPanelId'
        ,title:''
        ,region:'west'
        ,frame:true
        ,autoScroll:false
		,layout: 'border'
        ,items:[
			{
				items:DMPaperNo.FirstPanel,
				region: 'north',
				height: 35,
				layout : 'fit'
			}
			,{
				items:DMPaperNo.gridPaperNo,
				region: 'center',
				layout : 'fit'
			}
			
        ]
    });

    DMPaperNo.VpDMRNoList=new Ext.Viewport({
        id:'VpDMRNoListId'
       ,layout:'fit'
       ,items:[
             DMPaperNo.LeftPanel
       ]
    });
    DMPaperNo.gridPaperNoStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.DTHService.PaperNoSrv';
		param.QueryName = 'QryPaperNo';
		param.Arg1 = Common_GetValue('CobStatusId');
		param.Arg2 = Common_GetValue('CobLocId');
		param.ArgCnt = 2;
	});
    InitDMPaperNoEvent(DMPaperNo);
	DMPaperNo.LoadEvent(DMPaperNo);
	return DMPaperNo;
}
	
//入库
function InitPopStorage(DMPaperNo)
{
	var dmPaperNoStatusObj = new Object();
	dmPaperNoStatusObj.ParentForm=DMPaperNo;
	
	dmPaperNoStatusObj.resumeText = new Ext.form.TextArea
	({
		id:'resumeTextId'
		,height:115
		,width:275
	});
	dmPaperNoStatusObj.TxtStartNo=new Ext.form.TextField({
	     id:'TxtStartNoId'
	    ,fieldLabel:'开始编号'
	    ,anchor : '80%'
	    ,width:90
	    ,allowDecimals:false
	});
	dmPaperNoStatusObj.TxtEndNo=new Ext.form.TextField({
	     id:'TxtEndNoId'
	    ,fieldLabel:'结束编号'
	    ,anchor : '80%'
	    ,width:90
	    ,allowDecimals:false
	});
	
	dmPaperNoStatusObj.BtnSure = new Ext.Button
	({
		id : 'BtnSureId'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '确定'
	});
	dmPaperNoStatusObj.Btnexit = new Ext.Button
	({
		id : 'BtnexitId'
		,iconCls : 'icon-exit'
		,anchor : '95%'
		,text : '退出'
	});
	dmPaperNoStatusObj.mainWindow = new Ext.Window
	({
		id : 'mainWindow'
		,height : 160
		,buttonAlign :'center'
		,labelAlign:'right'
		,width : 300
		,title : '死亡证明书入库'
		,padding:5
		,layout:'form'
		,modal:true
		,items : [
			 dmPaperNoStatusObj.TxtStartNo
			,dmPaperNoStatusObj.TxtEndNo
		]
		,buttons : [
			dmPaperNoStatusObj.BtnSure
		   ,dmPaperNoStatusObj.Btnexit
		]
	});
	dmPaperNoStatusObj.mainReultWindow = new Ext.Window
	({
		id : 'mainReultWindowId'
		,height : 160
		,buttonAlign :'center'
		,labelAlign:'right'
		,width : 300
		,title : '死亡证明书入库'
		,modal:true
		,padding:5
		,items : [
			dmPaperNoStatusObj.resumeText
		]
		
	});
	InitPopStorageEvent(dmPaperNoStatusObj);
	dmPaperNoStatusObj.LoadEvent();
	return dmPaperNoStatusObj;
}
	
	