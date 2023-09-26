(function(){
	Ext.ns("dhcwl.BDQ.SaveAs");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.BDQ.SaveAsWin=function(pObj){
	var serviceUrl="dhcwl/basedataquery/dataqrycfg.csp";
	var outThis=this;
	var parentObj=pObj;
	var rptName="";
	var initAttrib;
	
	
	
	var saveAsForm= new Ext.FormPanel({
        labelWidth: 75, // label settings here cascade unless overridden
        frame:true,
        bodyStyle:'padding:5px 5px 0',
        //width: 350,
		height:80,
        defaults: {width: 230},
        defaultType: 'textfield',
        items: [
			{
                fieldLabel: '名称',
				id:'newCfgName',
                name: 'newCfgName'
            },{
                fieldLabel: '备注',
                id: 'newCfgRemarks'
            }
        ]				
    });	
	
	
	
	
	
	var columnModel = new Ext.grid.ColumnModel([
        {header:'名称',id:'Name',dataIndex:'Name',sortable:true, width: 150, sortable: true,menuDisabled : true},
		{header:'查询对象',id:'BaseObjName',dataIndex:'BaseObjName',sortable:true, width: 100, sortable: true,menuDisabled : true},
		{header:'日期字段',id:'DateItemName',dataIndex:'DateItemName',sortable:true, width: 150, sortable: true,menuDisabled : true},
		{header:'是否聚合',id:'IsAggregat',dataIndex:'IsAggregat',sortable:true, width: 70, sortable: true,menuDisabled : true},
		 {header:'配置类型',id:'Type',dataIndex:'Type',sortable:true, width: 70, sortable: true,menuDisabled : true},	
		{header:'创建人',id:'userName',dataIndex:'userName',sortable:true, width: 100, sortable: true,menuDisabled : true},
        {header:'创建日期',id:'CreatDate',dataIndex:'CreatDate',sortable:true, width: 70, sortable: true,menuDisabled : true},
       
		{header:'备注',id:'Remarks',dataIndex:'Remarks',sortable:true, width: 180, sortable: true,menuDisabled : true}
		
    ]);
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getRtpCfg&start=0&limit=50'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name:'rptID'},
            	{name: 'Name'},
				{name: 'IsAggregat'},
				{name: 'BaseObjName'},
				{name: 'DateItemName'},
				{name: 'userName'},
            	{name: 'CreatDate'},
				{name: 'Remarks'},
				{name: 'Type'}
			]
    	})
    });

    var rptGrid = new Ext.grid.GridPanel({
        height:480,
		title:'总览',
		//layout:'fit',
        store: store,
        cm: columnModel,
		autoExpandColumn: 'Remarks',
		listeners:{
			'cellclick':function(grid, rowIndex, columnIndex,  e ){
				var name=grid.getStore().getAt(rowIndex).get("Name");


				var rptID=grid.getStore().getAt(rowIndex).get("rptID");
				
				LoadRptDetail(name,rptID);
				if(outThis.onSaveAsCallback)
				{
					//LoadRptDetail(name,rptID);
					Ext.getCmp("newCfgName").setValue(name);
					
					var Remarks=grid.getStore().getAt(rowIndex).get("Remarks");
					Ext.getCmp("newCfgRemarks").setValue(Remarks);					
					
					return;
				}				
				
			}/*,
			'celldblclick':function(grid, rowIndex, columnIndex,  e ){
				
				if(outThis.onLoadCallback)
				{
					var name=grid.getStore().getAt(rowIndex).get("Name");
					var rptID=grid.getStore().getAt(rowIndex).get("rptID");
					outThis.onLoadCallback(name,rptID);
					saveAsWin.close();
					return;
				}
				
			} */
		}
    });
	
   var reader = new Ext.data.ArrayReader({}, [
           {name: 'name'},
           {name: 'descript'},
		   {name:'inPam'},
		   {name:'itemCls'}
    ]);
	
    var cfgStore = new Ext.data.GroupingStore({
		autoDestroy: true,
        reader:reader,
		groupField:'itemCls'
    });	
	
	var cfgCm = new Ext.grid.ColumnModel({
        columns: [{
            header: '描述',
			id:'descript',		//这个ID必须要，用在grid的autoExpandColumn中
            dataIndex: 'descript',
            width: 150
        }, {
            header: '入参',
            dataIndex: 'inPam',
            width: 50
        }, {
            header: '类型',
            dataIndex: 'itemCls',
            width: 80
        }]
	})	

    var cfgGrid = new Ext.grid.GridPanel({
        //height:480,
		//layout:'fit',
		title:'明细',
        store: cfgStore,
        cm: cfgCm,
		autoExpandColumn: 'descript',
        view: new Ext.grid.GroupingView({
            forceFit:true,
            groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
        })
    });	
	
	var saveAsWin = new Ext.Window({
        width:700,
		height:500,
		resizable:false,
		closable : false,
		title:'另存为...',
		modal:true,
		//items:[saveAsForm,rptGrid],
		
		layout: {
			type:'vbox',
			padding:'0',
			align:'stretch'
		},
		items: [
		{
			//title:'选择统计项',
			flex:2,
			layout:'fit',
			items:saveAsForm
		},{
			flex:5,
			layout:'fit',
			items:rptGrid
		},{
			flex:5,
			layout:'fit',
			items:cfgGrid
		}],		
		
		
		buttons: [
		{
			text:"保存",	
			id:'btnSave',
			handler:OnSave			
		},{
			text:"加载",	
			id:'btnLoad',
			handler:OnLoad			
		},{
			text: '关闭',
			handler: CloseWins
		}]
	});	
	
	function OnSave() {
		if(outThis.onSaveAsCallback)
		{
			if (Ext.getCmp("newCfgName").getValue()=="") {
				Ext.Msg.alert("提示","请填写名称！");
				return;
			}
			//输入的文件名和当前正在编辑的名称相同
			if(initAttrib.curRptName==Ext.getCmp("newCfgName").getValue()) {
				//outThis.onSaveAsCallback(initAttrib.curRptName,"","update");
				//saveAsWin.close();
				Ext.Msg.alert("提示","该名称已被使用！");
				return;				
			}else{
					//1、判断名称是否已存在
				dhcwl.mkpi.Util.ajaxExc(serviceUrl,
				{
					action:"isRptExist",
					rptName:Ext.getCmp("newCfgName").getValue(),
					rptType:initAttrib.rptType
				},function(jsonData){
					if(jsonData.success==true && jsonData.tip=="ok"){
						if (jsonData.exist==1 && jsonData.isRptUser==0) {
							Ext.Msg.alert("提示","该名称已被其他用户使用！");
							return;
						}
						if (jsonData.exist==1) {
							Ext.MessageBox.confirm('确认', '保存的配置已存在，要替换它吗？', function(id){
								 if (id=="no") {
									return;               	
								 }						
								//2、调用callback更新
								outThis.onSaveAsCallback(Ext.getCmp("newCfgName").getValue(),Ext.getCmp("newCfgRemarks").getValue(),"update");
								saveAsWin.close();
								return;
							});
							
						}else{
							outThis.onSaveAsCallback(Ext.getCmp("newCfgName").getValue(),Ext.getCmp("newCfgRemarks").getValue(),"insert");
							saveAsWin.close();
							return;
						}
						
					}else{
						Ext.Msg.alert("操作失败",jsonData.MSG);
					}
				},this);	
			}			

		}		
	}
	
	function OnLoad() {
		if(outThis.onLoadCallback)
		{
			var selRec=rptGrid.getSelectionModel().getSelected();
			if (!selRec) {
				Ext.Msg.alert("提示","请选择配置！");
				return;
			}
			var name=selRec.get("Name");
			var rptID=selRec.get("rptID");
			outThis.onLoadCallback(name,rptID);
			saveAsWin.close();
			return;
		}
				
	}
	function CloseWins() {
			saveAsWin.close();
	}
 
	function LoadRptDetail(outRptName,outRptID) {
		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:"getLoadRptCfgData",
			rptName:outRptName,
			rptID:outRptID
		},function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok" && jsonData.MSG=='SUCESS'){
				//rptName=outRptName;
				//rptID=outRptID;				
				updateDetailGrids(jsonData.cfgData);
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
			}
		},this);		
		
	}
	
	function updateDetailGrids(cfgData) {

		cfgStore.removeAll();
		aryRptsub=cfgData.rptsub;
		
		for(var i=0;i<aryRptsub.length;i++)
		{
			var item=aryRptsub[i].item;
			id=item.split("(")[0];
			var len=id.split("->").length;
			var name=id.split("->")[len-1];
			
			var descript=aryRptsub[i].descript;

			var insData = {
				name: name,
				descript: descript
				//inPam:inPam
			};			
			
			if(aryRptsub[i].type=="row") {
				var inPam=item.split("(")[1].split(")")[0];
				insData.inPam=inPam;
				insData.itemCls="行显示";
				var p = new cfgStore.recordType(insData); // create new record
				var pos=cfgStore.getCount();
				cfgStore.insert(pos, p); 
			}
			if(aryRptsub[i].type=="col") {
				var inPam=item.split("(")[1].split(")")[0];
				insData.inPam=inPam;
				insData.itemCls="列显示";
				var p = new cfgStore.recordType(insData); // create new record
				var pos=cfgStore.getCount();
				cfgStore.insert(pos, p); 	
			}			

			if(aryRptsub[i].type=="measure") {
				insData.itemCls="度量";				
				var p = new cfgStore.recordType(insData); // create new record
				var pos=cfgStore.getCount()
				cfgStore.insert(pos, p); 	
			
			}
			
			if(aryRptsub[i].type=="filter") {
				insData.itemCls="过滤条件";	
				var inPam=item.split("(")[1].split(")")[0];
				insData.inPam=inPam;
				insData.descript=descript+" "+item.split("^")[1]+" "+item.split("^")[2];
				var p = new cfgStore.recordType(insData); // create new record
				var pos=cfgStore.getCount()
				cfgStore.insert(pos, p); 	
			}
		}

	}
	
	this.getSaveAsWin=function() {
		return saveAsWin;
	}
	
	this.show=function() {
		saveAsWin.show();
		rptGrid.getStore().setBaseParam("rptType",initAttrib.rptType);
		rptGrid.getStore().setBaseParam("usedFor",initAttrib.usedFor);
		store.load();
	}

	this.initForSave=function() {
		//saveAsWin.get(0).hide();
		//saveAsForm.hide();
		Ext.getCmp('btnLoad').hide();
		//rptGrid.getTopToolbar().hide();
		//saveAsWin.setTitle("加载配置");
	}
	
	this.initForLoad=function() {
		saveAsWin.get(0).hide();
		//saveAsForm.hide();
		Ext.getCmp('btnSave').hide();
		//rptGrid.getTopToolbar().hide();
		saveAsWin.setTitle("加载配置");
	}
	
	this.initAttrib=function(inParam) {
		initAttrib=inParam;
	}
}

