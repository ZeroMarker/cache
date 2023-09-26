(function(){
	Ext.ns("dhcwl.BDQ.ModifyQueryObj");
})();
///描述: 		查询对象
///编写者：		WZ
///编写日期: 		2016-11
dhcwl.BDQ.ModifyQueryObj=function(ObjName){
	var BaseObjName=ObjName;
	var serviceUrl="dhcwl/basedataquery/createqueryobj.csp";
	var outThis=this;

	function CloseWins() {
		ModifyItemWin.close();	
	}
	
	function OnUpdate() {
		var modifiedRecs=BDQItemGrid.getStore().getModifiedRecords();
		var recCnt=modifiedRecs.length;
		if (recCnt<=0) {
			//Ext.Msg.alert("提示","先将源字段映射成数据项再点击完成");
			return;
		} 
				
		var aryItemID=[];
		var aryItemDesc=[];
		var aryItemType=[];
		var aryDimType=[];
		var aryDimCode=[];
		
		for(var i=0;i<=recCnt-1;i++){
			rec=modifiedRecs[i];
			aryItemID.push(rec.get("ID"));
			aryItemDesc.push(rec.get("Descript"));
			aryItemType.push(rec.get("ItemType"));
			aryDimType.push(rec.get("DimType"));
			aryDimCode.push(rec.get("DimCode"));	
		}
		var strItemID=aryItemID.toString();
		var strItemDesc=aryItemDesc.toString();
		var strItemType=aryItemType.toString();
		var strDimType=aryDimType.toString();
		var strDimCode=aryDimCode.toString();

		var strAction="";
		strAction="updateBDQItems";

		dhcwl.mkpi.Util.ajaxExc(serviceUrl,
		{
			action:strAction,
			strItemID:strItemID,
			strItemDesc:strItemDesc,
			strItemType:strItemType,
			strDimType:strDimType,
			strDimCode:strDimCode
		},
		function(jsonData){
			if(jsonData.success==true && jsonData.tip=="ok"){
				Ext.Msg.alert("提示","操作成功！");
				//CloseWins();
				
				
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
				editable:       false,				
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
                listClass: 'x-combo-list-small'
            })
		
		
        },{header:'关联维度类型',dataIndex:'DimType',sortable:true, width: 80, sortable: true
		    /*
			,
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
			*/
        },{header:'关联维度编码',dataIndex:'DimCode', width: 160, sortable: true,
		    editor: comboDimCode	
		
        }
    ]);
    var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getBDQObjItems&start=0&limit=50'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'ID'},
            	{name: 'Name'},
            	{name: 'Descript'},
        		{name: 'ItemType'},
            	{name: 'DimType'},
            	{name: 'DimCode'},
			]
    	})
    });

var impformpanel = new Ext.FormPanel({    
	    title: '选择要导入的文件',
	    frame: true,
	    labelWidth: 110,
	    bodyStyle: 'padding-left:5px;',
        layout: 'column',
        border: false,
 		fileUpload:true,           	    
	    items: [
	        {
				xtype:'textfield',
				allowBlank:true,
				name:'importModuleFile',
				fieldLabel:'安装文件',
				inputType:'file',
				id:'selectImportFile'
	        },{
				xtype:'button',
				text: '导入',
				width:50,
				handler:onImpFromEXL
			}
	    ]
        });
	
    var BDQItemGrid = new Ext.grid.EditorGridPanel({
        //height:480,
		//layout:'fit',
        store: store,
        cm: columnModel,
		autoExpandColumn: 'Name',
		clicksToEdit: 1,
		
		bbar: new Ext.PagingToolbar({
		pageSize:50,
		store:store,
		displayInfo:true,
		displayMsg:'{0}~{1}条,共 {2} 条',
		emptyMsg:'sorry,data not found!'
		})
	
	
    });

	var ModifyItemWin = new Ext.Window({
		title:'修改',
		id:'ModifyItemWin',
        width:800,
		height:500,
		resizable:false,
		closable : false,
		//closeAction:'close',			//不提供窗口右上角的“关闭”按钮
		layout:'border',
		modal:true,
		items:[{
			region:'north',
			height:100,
			items:impformpanel,
			layout:'fit'
		},{
			region:'center',
			items:BDQItemGrid,
			layout:'fit'
			
		}],
        buttons: [
			{
				text: '关闭',
				handler: CloseWins
			},{
				text: '更新',
				handler: OnUpdate
			}
		]
	});
	
	store.setBaseParam("BaseObjName",BaseObjName)
	//store.load({params:{DBQObjID:DBQObjID}});
	store.load();

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
		BDQItemGrid.getStore().reload({params:{DBQObjID:DBQObjID}});
    }
	
	function onImpFromEXL() {
    	var filePath=Ext.get('selectImportFile').getValue();
    	if(!filePath||filePath==""){
    		alert("请选择要导入的EXCEL文件！");
    		return;
    	}

		//1、从后台读取excel文件
		var oXL = new ActiveXObject("Excel.application");  
        //打开指定路径的excel文件   
		var oWB = oXL.Workbooks.open(filePath); 

		if (!oWB) {
			Ext.Msg.alert("提示","打开文件错误！请确认是否是正确的excel文件！");
			return;
		}
		var strImpData="";
		//操作第一个sheet(从一开始，而非零)   
		try {

			var recCnt=BDQItemGrid.getStore().getCount();
			
			var sheetInx=1;
			oWB.worksheets(sheetInx).select();  
			var oSheet = oWB.ActiveSheet;  
			//使用的行数   
			var rowsCnt =oSheet.usedrange.rows.count; 
			var dataRowBegin=1;

			var dataColBegin=2;
			var colCnt=6;
			for (var i = dataRowBegin; i <= rowsCnt; i++) {
				var exlItemName=oSheet.Cells(i, 2).value;
				for(var recInx=0;recInx<=recCnt-1;recInx++) {
					var rec=BDQItemGrid.getStore().getAt(recInx);
					var fieldname=rec.fields.items[1].name;
					
					if (rec.get(fieldname)==exlItemName) { 
						for (var j=dataColBegin;j<=colCnt;j++) {
							var cellData=oSheet.Cells(i, j+1).value;
							if (!cellData) continue;
							var fieldname=rec.fields.items[j].name;
							rec.set(fieldname,cellData);
						}
						break;
					}
					

				}
			} 
			oXL.Application.Quit();  
			CollectGarbage();	
		}catch(e) {  
					//退出操作excel的实例对象   
					oXL.Application.Quit();  
					CollectGarbage();
			      //Ext.Msg.alert("提示",e);
				Ext.Msg.alert("提示","打开文件错误！请确认是否是正确的excel文件！");
				return;
		}  		
		
	}
	
	
	this.showWin=function(){
		ModifyItemWin.show();
	}
    
}

