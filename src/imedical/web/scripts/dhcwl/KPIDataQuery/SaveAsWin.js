(function(){
	Ext.ns("dhcwl.KDQ.SaveAs");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.KDQ.SaveAsWin=function(pObj){
	var serviceUrl="dhcwl/kpidataquery/saverptcfg.csp";
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
                fieldLabel: '编码',
				id:'newCfgCode',
                name: 'newCfgCode'
            },{
                fieldLabel: '标题',
				//fieldLabel: '描述',
                id: 'newCfgDescript'
            },{
				xtype:'combo',
                fieldLabel: '业务类型',
                id: 'newCfgBusinessType',
				name:'newCfgBusinessType',
				//anchor: '98%',
				mode:'local',
				triggerAction:  'all',
				editable: true,
				displayField:   'description',
				valueField:     'name',
				store:          new Ext.data.JsonStore({
					fields : ['description', 'name'],
					data   : [
						{description : '收入',name: '收入'},
						{description : '挂号',name: '挂号'},
						{description : '出入转',name: '出入转'},
						{description : '病案',name: '病案'},
						{description : '手术',name: '手术'},
						{description : '院长查询',name: '院长查询'},
						{description : '阳光用药',name: '阳光用药'}
					]
				})				
            }
        ]				
    });	
	
	var columnModel = new Ext.grid.ColumnModel({
            defaults: {
                width: 100,
                sortable: false
            },
			columns: [
				{header:'编码',dataIndex:'Code', width: 100},
				//{header:'描述',id:'Descript',dataIndex:'Descript', width: 100},
				{header:'标题',id:'Descript',dataIndex:'Descript', width: 100},
				{header:'报表类型',dataIndex:'RtpType', width: 100},
				{header:'业务类型',dataIndex:'BusinessType', width: 100},
				{header:'创建人',dataIndex:'UserName', width: 100},
				{header:'创建日期',dataIndex:'CreatDate', width: 70}
			]
    });
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getRtpCfg&start=0&limit=50'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
				{name: 'RptID'},
            	{name: 'Code'},
				{name: 'Descript'},
				{name: 'RtpType'},
				{name: 'BusinessType'},
            	{name: 'UserName'},
				{name: 'CreatDate'}
			]
    	})
    });

    var rptGrid = new Ext.grid.GridPanel({
        height:480,
		title:'已保存报表',
		//layout:'fit',
        store: store,
        cm: columnModel,
		autoExpandColumn: 'Descript',
		listeners:{
			'cellclick':function(grid, rowIndex, columnIndex,  e ){
				var Code=grid.getStore().getAt(rowIndex).get("Code");


				var RptID=grid.getStore().getAt(rowIndex).get("RptID");
				
				LoadRptDetail(Code,RptID);
				if(outThis.onSaveAsCallback)
				{
					//LoadRptDetail(name,rptID);
					Ext.getCmp("newCfgCode").setValue(Code);
					var Descript=grid.getStore().getAt(rowIndex).get("Descript");
					Ext.getCmp("newCfgDescript").setValue(Descript);
					var BusinessType=grid.getStore().getAt(rowIndex).get("BusinessType");
					Ext.getCmp("newCfgBusinessType").setValue(BusinessType);
					
					return;
				}				
				
			}
		}
    });
	
   var reader = new Ext.data.ArrayReader({}, [
           {name: 'name'},
           {name: 'descript'},
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
			flex:3,
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
			if(Ext.getCmp("newCfgCode").getValue()=="") {
				Ext.Msg.alert("提示","请填写编码！");
				return;
			};
			callbackargs=new Object();
			//输入的文件名和当前正在编辑的名称相同
			if(initAttrib.curRptName==Ext.getCmp("newCfgCode").getValue()) {
				callbackargs.rptCode=Ext.getCmp("newCfgCode").getValue();
				callbackargs.descript=Ext.getCmp("newCfgDescript").getValue();
				callbackargs.businessType=Ext.getCmp("newCfgBusinessType").getValue();				
				outThis.onSaveAsCallback(callbackargs);
				saveAsWin.close();
				return;				
			}else{
					//1、判断名称是否已存在
				dhcwl.mkpi.Util.ajaxExc(serviceUrl,
				{
					action:"isRptExist",
					rptCode:Ext.getCmp("newCfgCode").getValue()
				},function(jsonData){
					if(jsonData.success==true && jsonData.tip=="ok"){
						if (jsonData.exist==1 && jsonData.isRptUser==0) {
							Ext.Msg.alert("提示","该名称已被其他用户使用！");
							return;
						}
						callbackargs.rptCode=Ext.getCmp("newCfgCode").getValue();
						callbackargs.descript=Ext.getCmp("newCfgDescript").getValue();
						callbackargs.businessType=Ext.getCmp("newCfgBusinessType").getValue();
						
						if (jsonData.exist==1) {
							Ext.MessageBox.confirm('确认', '保存的配置已存在，要替换它吗？', function(id){
								if (id=="no") {
									return;               	
								}						
								outThis.onSaveAsCallback(callbackargs);
								saveAsWin.close();
								return;	
							});
							
						}else{
							outThis.onSaveAsCallback(callbackargs);
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
			var Code=selRec.get("Code");
			var RptID=selRec.get("RptID");
			outThis.onLoadCallback(Code,RptID);
			saveAsWin.close();
			return;
		}
				
	}
	function CloseWins() {
			saveAsWin.close();
	}
 
	function LoadRptDetail(outRptCode,outRptID) {
		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:"getRptDetailCfgData",
			rptCode:outRptCode
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
			var descript=aryRptsub[i].descript;
			var insData = {
				descript: descript
			};			
			
			if(aryRptsub[i].type=="row") {
				insData.itemCls="行显示";
				var p = new cfgStore.recordType(insData); // create new record
				cfgStore.add(p);
			}
			if(aryRptsub[i].type=="col") {
				insData.itemCls="列显示";
				var p = new cfgStore.recordType(insData); // create new record
				cfgStore.add(p);
			}			

			if(aryRptsub[i].type=="measure") {
				insData.itemCls="度量";				
				var p = new cfgStore.recordType(insData); // create new record
				cfgStore.add(p);	
			}
			
			if(aryRptsub[i].type=="filter") {
				insData.itemCls="过滤条件";	
				var p = new cfgStore.recordType(insData); 
				cfgStore.add(p); 	
			}
			if(aryRptsub[i].type=="searchitem") {
				insData.itemCls="查询项";	
				var p = new cfgStore.recordType(insData); 
				cfgStore.add(p); 	
			}			
		}

	}
	
	this.getSaveAsWin=function() {
		return saveAsWin;
	}
	
	this.show=function() {
		saveAsWin.show();
		rptGrid.getStore().setBaseParam("rptType",initAttrib.rptType);//加载时使用，加载指定类型的报表配置
		rptGrid.getStore().setBaseParam("usedFor",initAttrib.usedFor);
		store.load();
	}

	//保存数据时调用
	this.initForSave=function() {
		Ext.getCmp('btnLoad').hide();
	}
	
	
	//加载配置时调用
	this.initForLoad=function() {
		saveAsWin.get(0).hide();
		Ext.getCmp('btnSave').hide();
		saveAsWin.setTitle("加载配置");
	}
	
	this.initAttrib=function(inParam) {
		initAttrib=inParam;
	}
}

