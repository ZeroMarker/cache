(function(){
	Ext.ns("dhcwl.BDQ.CreateQueryObj");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.BDQ.CreateQueryObj=function(parentObj){
	var frameObj=parentObj;
	var rptDimSelector=null;
	var serviceUrl="dhcwl/basedataquery/createqueryobj.csp";
	var outThis=this;
	var aryWins=new Array();

    var QryNameForm = new Ext.FormPanel({
        labelWidth: 75,
		frame: true,
        height: 350,
        labelAlign: 'left',
        bodyStyle:'padding:5px',
		defaultType: 'textfield',
        items:[
		{       
			fieldLabel: '数据表名称',
			xtype: 'combo',
            name: 'baseDataTableName',	
			allowBlank:false,
			width:150,
			id:'baseDataTableName',
			mode:           'local',
			triggerAction:  'all',
			forceSelection: true,
			editable:       false,
			displayField:   'description',
			valueField:     'name',
			store:          new Ext.data.JsonStore({
				fields : ['description', 'name'],
				data   : [
					{description : '收入',   name: 'dhc_workload'}
				   ,{description : '挂号',   name: 'DHCWorkRegReport'}
				   ,{description : '出入转',   name: 'DHCMRIPDay'}
				   ,{description : '手术',   name: 'DHCWL_AnOperation'}
				   ,{description : '病案V1',   name: 'DHCMRBase'}
				   ,{description : '病案V2',   name: 'dhcmrinfo'}
				   ,{description : '收入V2',   name: 'Data.DHCWorkLoad'}
				]
			})			
		}]
    });
    
	//	表名称和描述选取窗口
	var QryNameCfgWin = new Ext.Window({
		title:"选择基础表",
		id:'QryNameCfgWin',
        width:300,
		height:200,
		resizable:false,
		closable : true,
		//closeAction:'close',			//不提供窗口右上角的“关闭”按钮
		layout:'fit',
		modal:true,
		items:QryNameForm,
        buttons: [
			{
				text: '取消',
				handler: OnCancel
			},{
				text: '下一步',
				handler: OnNextSetp
			}
		]
	});	
	
	function CloseWins() {
		for (var winInx=0;winInx<aryWins.length;winInx++)
		{
			aryWins[winInx].close();
		}			
		
	}
	
	function OnCancel() {
		CloseWins();		
	}
	
	function OnLastSetp() {
		QryNameCfgWin.show();
		QryItemCfgWin.hide();
	}	
	
	function OnNextSetp() {
		//QryNameCfgWin.hide();
		var className=QryNameForm.getForm().findField("baseDataTableName").getValue();
		var classNameDesc=QryNameForm.getForm().findField("baseDataTableName").el.dom.value;
		store.load({params:{className:className,classNameDesc:classNameDesc}});
		QryItemCfgWin.show();
		QryNameCfgWin.hide();
		aryWins.push(QryItemCfgWin);
		
	}	
	
	function OnFinish() {
		var recCnt=BDQItemGrid.getStore().getCount();
		if (recCnt<=0) {
			//Ext.Msg.alert("提示","先将源字段映射成数据项再点击完成");
			return;
		} 
				
		var aryItemName=[];
		var aryItemDesc=[];
		var aryItemType=[];
		var aryDimType=[];
		var aryDimCode=[];
		var aryColType=[];
		
		for(var i=0;i<=recCnt-1;i++){
			rec=BDQItemGrid.getStore().getAt(i);
			aryItemName.push(rec.get("Name"));
			aryItemDesc.push(rec.get("Descript"));
			aryItemType.push(rec.get("ItemType"));
			aryDimType.push(rec.get("DimType"));
			aryDimCode.push(rec.get("DimCode"));	
			aryColType.push(rec.get("ColType"));	
		}
		
		var strItemName=aryItemName.toString();
		var strItemDesc=aryItemDesc.toString();
		var strItemType=aryItemType.toString();
		var strDimType=aryDimType.toString();
		var strDimCode=aryDimCode.toString();
		var strColType=aryColType.toString();

		var sqlTableName=QryNameForm.getForm().findField("baseDataTableName").getValue();
		var sqlTableNameDesc=QryNameForm.getForm().findField("baseDataTableName").el.dom.value;
		var strAction="";
		strAction="createBDQObj";

		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:strAction,
			
			strItemName:strItemName,
			strItemDesc:strItemDesc,
			strItemType:strItemType,
			strDimType:strDimType,
			strDimCode:strDimCode,
			strColType:strColType,
			/**/
			sqlTableName:sqlTableName,
			sqlTableNameDesc:sqlTableNameDesc
		},
		function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				Ext.Msg.alert("提示","操作成功！");
				if (frameObj) {
						frameObj.refresh();
				}
				CloseWins();
				
			}else{
				Ext.Msg.alert("操作失败",jsonData.MSG);
				}
			},this);		
		
	}
	var fm = Ext.form;
	
	var comboDimCode=new fm.ComboBox({
				displayField:   'description',
				valueField:     'value',
				store:new Ext.data.Store({
						proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=searchdimcode'}),
						reader: new Ext.data.JsonReader({
							totalProperty: 'totalNum',
							root: 'root',
							fields:[
								{name: 'description'},
								{name: 'value'}
							]
						})
					}),	
				mode:           'remote',
				triggerAction:  'all',
				//forceSelection: true,
				//editable:       false,				
                typeAhead: true,
                // transform the data already specified in html
                listClass: 'x-combo-list-small'
            })


			
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'ID',sortable:true, width: 30, sortable: true,menuDisabled : true
        },{header:'名称',id:'Name',dataIndex:'Name',sortable:true, width: 180, sortable: true,menuDisabled : true
        },{header:'描述',dataIndex:'Descript', width: 160, sortable: true,editor: new fm.TextField({allowBlank: true})
        },{header:'统计项类型',dataIndex:'ItemType',sortable:true, width: 80, sortable: true,
		    editor: new fm.ComboBox({
				displayField:   'description',
				valueField:     'value',
				store:          new Ext.data.JsonStore({
					fields : ['description', 'value'],
					data   : [
						{description : '维度',   value: '维度'}
					   ,{description : '度量',   value: '度量'}
					]
				}),	
				mode:           'local',
				triggerAction:  'all',
				//forceSelection: true,
				//editable:       true,				
                typeAhead: true,
                // transform the data already specified in html
                listClass: 'x-combo-list-small',
				listeners :{
					'keypress':function(ele,event){
							}
				}
            })
		
		
        },{header:'关联维度类型',dataIndex:'DimType',sortable:true, width: 80, sortable: true,
		    editor: new fm.ComboBox({
				displayField:   'description',
				valueField:     'value',
				store:          new Ext.data.JsonStore({
					fields : ['description', 'value'],
					data   : [
						{description : '标准维度',   value: '标准维度'}
					   ,{description : '对象维度',   value: '对象维度'}
					]
				}),	
				mode:           'local',
				triggerAction:  'all',
				//forceSelection: true,
				//editable:       true,				
                typeAhead: true,
                // transform the data already specified in html
                listClass: 'x-combo-list-small'
            })		

        },{header:'关联维度编码',dataIndex:'DimCode', width: 160, sortable: true,
		    editor: comboDimCode	
		
        }
    ]);
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getBDQObjFields'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
				{name: 'ColType'},
            	{name: 'Name'},
            	{name: 'Descript'},
        		{name: 'ItemType'},
            	{name: 'DimType'},
            	{name: 'DimCode'},
			]
    	})
    });

    var BDQItemGrid = new Ext.grid.EditorGridPanel({
        //height:480,
		layout:'fit',
        store: store,
        cm: columnModel,
		autoExpandColumn: 'Name',
		clicksToEdit: 1
    });

	//	定义指标选取窗口
	var QryItemCfgWin = new Ext.Window({
		title:"选择基础表",
		id:'QryItemCfgWin',
        width:800,
		height:600,
		resizable:false,
		closable : false,
		layout:'fit',
		modal:true,
		
		items:BDQItemGrid,
        buttons: [
			{
				text: '取消',
				handler: OnCancel
			},{
				text: '上一步',
				handler: OnLastSetp
			},{
				text: '完成',
				handler: OnFinish
			}
		]
	});	
    //store.load({params:{start:0,limit:21}});

	BDQItemGrid.on('beforeedit',function(obj){
		if (obj.field=="DimCode") {
			var rec=obj.record;
			var dimType=rec.get("DimType");
			comboDimCode.getStore().reload({params:{dimType:dimType}})
		}
	});
	
	BDQItemGrid.on('afteredit',function(obj){
		if (obj.field=="ItemType") {
			var rec=obj.record;
			if (rec.get("ItemType")=="维度") {
				var Name=rec.get("Name");
				if (Name=="WorkLoad_Rowid" || Name=="WR_rowid" || Name=="MRIP_rowid" || Name=="WLOP_Rowid" || Name=="DHCMRInfo_RowID" || Name=="DHCMRBase_RowID") {
					rec.set("DimType","对象维度");
					rec.set("DimCode","对象属性");
				}else{
					rec.set("DimType","标准维度");
				}
			}else{
					rec.set("DimType","");
					rec.set("DimCode","");				
			}
		}
	});	
	
	
    function refresh(){
		BDQGrid.getStore().reLoad();
	    BDQGrid.show();      	
    }
    this.refresh=function(){
    	refresh();
    }
    

	this.ShowQryNameCfgWin=function(){
		QryNameCfgWin.show();
		aryWins.push(QryNameCfgWin);
	}
    
}

