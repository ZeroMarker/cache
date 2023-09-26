
var unitsUrl = 'dhcst.mbccolldrugaction.csp';
var gParentId=""
var NumberI='70' //门诊发放
Ext.onReady(function() {
       var gUserId = session['LOGON.USERID'];
	Ext.QuickTips.init();// 浮动信息提示
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

var BarCode = new Ext.form.TextField({
		fieldLabel : '条码',
		id : 'BarCode',
		name : 'BarCode',
		anchor : '90%',
		width : 140,
		listeners : {
			specialkey : function(field, e) {
			var keyCode=e.getKey();
			if ( keyCode== Ext.EventObject.ENTER) {
			   MainGridDs.removeAll();
			   var outphaed=Ext.getCmp('OutPhaEd').getValue();
			   if (outphaed==false) {
			    DecSaveCom();}
			    else 
			    {    
			         var prescno=Ext.getCmp("BarCode").getValue();
			         MainGridDs.setBaseParam("Prescno",prescno)
                     MainGridDs.setBaseParam("User",gUserId)
                     MainGridDs.load();}
			}
		    }
		}
		});	

   //已发放
   var OutPhaEdChkbox=new Ext.form.Checkbox({
        
		boxLabel : '已发放',
		id : 'OutPhaEd',
		inputValue : '1',
		checked : false,
		listeners:{
					'check': function(){
	
					}
		}
    })

//扫描保存
function DecSaveCom(){

              var prescno=Ext.getCmp("BarCode").getValue();
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		 Ext.Ajax.request({
			 url: unitsUrl+'?action=OutPhaSave',
			 params: {Prescno:prescno,User:gUserId},
			 failure: function(result, request) {
			     mask.hide();
			     Msg.info("error", "请检查网络连接!");
			    },
			  success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					 
					if (jsonData.success=='true') {
						Msg.info("success", "保存成功!");
                                           MainGridDs.removeAll();
                                           MainGridDs.setBaseParam("Prescno",prescno)
                                           MainGridDs.setBaseParam("User",gUserId)
                                           MainGridDs.load();
					}else if (jsonData.info=="-10"){
					     Msg.info("error", "处方号为空!");
					}
					 else if (jsonData.info=="-20"){
					     Msg.info("error", "非代煎处方!");
				       }
					 else if (jsonData.info=="-30"){
					      Msg.info("error", "该处方未收药!")
					}
					else if (jsonData.info.indexOf("-40")>=0){
						  var nextstatestr=jsonData.info.split("^")
						  var nextstate=nextstatestr[1]
					      Msg.info("warning", "该处方的下一状态不是门诊发放状态!"+"状态应为:"+nextstate+"!")
					}
					else if (jsonData.info=="-50"){
					      Msg.info("warning", "处方号不存在!")
					}
					else if (jsonData.info=="-60"){
					      Msg.info("warning", "该处方号尚未发药!")
					}					
					
					else{
					      Msg.info("error", "保存失败!");
						
					}
				},
				scope: this
			});
 	 Ext.getCmp("BarCode").setValue("");
        Ext.getCmp("BarCode").focus();
	}
	
   function addNewRow() {
	var record = Ext.data.Record.create([
                    
                    {
			  name : 'MBCId',
			  type : 'string'
			},
                    {
			  name : 'PatLoc',
			  type : 'string'
			}, {
			  name : 'PatNo',
			  type : 'string'
			}, {
			  name : 'PatName',
			  type : 'string'
		       }, {
			  name : 'Prescno',
			  type : 'string'
			}, {
			  name : 'State',
			  type : 'string'
		       }
	]);
					
   }
    
    var MainGridProxy= new Ext.data.HttpProxy({url:unitsUrl+'?action=GetOutPhaPresc',method:'GET'});
    var MainGridDs = new Ext.data.Store({
	proxy:MainGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [      {name:'MBCId'},
		{name:'PatLoc'},
		{name:'PatNo'},
		{name:'PatName'},
		{name:'Prescno'},
		{name:'State'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
    });
    //模型
    var MainGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"rowid",
        dataIndex:'MBCId',
        width:100,
        align:'left',
        sortable:true,
        hidden:true
	 }, {
        header:"科室",
        dataIndex:'PatLoc',
        width:100,
        align:'left',
        sortable:true
	 },{
        header:"登记号",
        dataIndex:'PatNo',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"患者姓名",
        dataIndex:'PatName',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"处方号",
        dataIndex:'Prescno',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"状态",
        dataIndex:'State',
        width:200,
        align:'left',
        sortable:true
	 }
	 
	 ])
    MainGrid = new Ext.grid.EditorGridPanel({
	store:MainGridDs,
	cm:MainGridCm,
	trackMouseOver:true,
	stripeRows:true,
	//sm:new Ext.grid.CellSelectionModel({}),
	sm : new Ext.grid.RowSelectionModel({
		 singleSelect : true
		 }),
	loadMask:true,
    tbar:[BarCode,"条码",'-',OutPhaEdChkbox],
	clicksToEdit:1
    });

      var ChildGridProxy= new Ext.data.HttpProxy({url:unitsUrl+'?action=GetOutPhaPrescDetail',method:'GET'});
    var ChildGridDs = new Ext.data.Store({
	proxy:ChildGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [{name:'DrugCode'},
		{name:'DrugDesc'},
		{name:'DrugQty'},
		{name:'DrugUom'}
	]),
	pruneModifiedRecords:true,
    remoteSort:false
    });
    //模型
    var ChildGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"药品代码",
        dataIndex:'DrugCode',
        width:100,
        align:'left',
        sortable:true
	 }, {
        header:"药品名称",
        dataIndex:'DrugDesc',
        width:100,
        align:'left',
        sortable:true
	 },{
        header:"药品数量",
        dataIndex:'DrugQty',
        width:200,
        align:'left',
        sortable:true
	 },{
        header:"单位",
        dataIndex:'DrugUom',
        width:200,
        align:'left',
        sortable:true
	 }
	 
	 ])
    ChildGrid = new Ext.grid.EditorGridPanel({
	store:ChildGridDs,
	cm:ChildGridCm,
	trackMouseOver:true,
	stripeRows:true,
	//sm:new Ext.grid.CellSelectionModel({}),
	sm : new Ext.grid.RowSelectionModel({
		 singleSelect : true
		 }),
	loadMask:true
    });    
 	// 添加表格单击行事件
	MainGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var Prescno = MainGridDs.getAt(rowIndex).get("Prescno");
			ChildGridDs.setBaseParam('Prescno',Prescno)
			ChildGridDs.load();
		});
		
 	// 添加表格load事件
	MainGridDs.on('load', function() {
                       MainGrid.getSelectionModel().selectFirstRow();
		});		
		
        
    var MainPanel = new Ext.Panel({
		title:'门诊发放数据',
		activeTab: 0,
		region:'center',
		layout:'fit',
		items:[MainGrid]                                 
	});        	  
        
    var ChildPanel = new Ext.Panel({
		title:'门诊发放数据明细',
		activeTab: 0,
		region:'south',
		height: 450,
		layout:'fit',
		items:[ChildGrid]                                 
	});  
	var por = new Ext.Viewport({

				layout : 'border', // 使用border布局

				items : [MainPanel,ChildPanel]

			});

	 Ext.getCmp("BarCode").setValue("");
        Ext.getCmp("BarCode").focus();
});
