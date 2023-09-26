
var unitsUrl = 'dhcst.mbccolldrugaction.csp';
var gParentId=""
var Gnode
var NumberI='10' //收药
Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var gUserName=session['LOGON.USERNAME']
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
			    RecSave();
			}
		    }
		}
		});	

  		// 打印按钮
		var PrintBT = new Ext.Toolbar.Button({
					id:'PrintBT',
					text : '打印',
					tooltip : '点击打印',
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
	                                 var DDateTime=GetDate();
	                                  var DateStr=DDateTime.split("^")
	                                  var Ddate=DateStr[0]
	                                  var Dtime=DateStr[1]
	                                   //PrintRec(DhcIngr,gParam[13]);
	                                   PrintUpdate(Ddate,Dtime)	                                   
					}
				});
function GetDate()
{
 var myDate = new Date(); 
 var year=myDate.getFullYear(); //获取完整的年份(4位,1970-????)
 var month=myDate.getMonth(); //获取当前月份(0-11,0代表1月)
 var date=myDate.getDate();   //获取当前日(1-31)
 var hours=myDate.getHours();  //获取当前小时数(0-23)
 var minutes=myDate.getMinutes(); //获取当前分钟数(0-59)
 var seconds=myDate.getSeconds(); //获取当前秒数(0-59)
 var month=month+1
 var ymd=year+"-"+month+"-"+date
 var hms=hours+":"+minutes+":"+seconds
 return  ymd+"^"+hms
}
	// 创建一个简写

	var Tree = Ext.tree;

	// 定义根节点的Loader

	var treeloader = new Tree.TreeLoader({

				dataUrl : unitsUrl + '?action=ListTreeData'

			});
	// 添加一个树形面板

	var treepanel = new Tree.TreePanel({

				//el : 'tree-panel',// 
				region : 'west',
				title : '科室视图',
				width : 300,
				//minSize : 180,
				//maxSize : 250,
				split : true,
				//autoHeight : true,
				height : 300,
				frame : true,
				autoScroll : true,
				enableDD : false,
				containerScroll : true,
				border : true,
				animate : true,  
                            collapsible: true,           //是否可以折叠 
                             
				//rootVisible:false,
				loader : treeloader//,
				//tbar:[AddRootBT, '-', AddBT, '-', UpdBT]

			});

	// 异步加载根节点
	var rootnode = new Tree.AsyncTreeNode({

				text : '科室',

				id : 'id',

				value : '0',

				level : '0',

				draggable : false , // 根节点不容许拖动

				expanded : true

			});

	// 为tree设置根节点

	treepanel.setRootNode(rootnode);

	// 响应加载前事件，传递node参数

	treeloader.on('beforeload', function(treeloader, node) {
                            
				if (node == rootnode) {
					node.attributes.id = '0';
				}
				Gnode=node.attributes.id
				treeloader.baseParams = {
					id : node.attributes.id,
					level : node.attributes.level,
					Number:NumberI,
					UserI:gUserId,
					actiontype : 'load'
				}

			}, this);;


	// 增加鼠标单击事件

	//treepanel.on('dblclick', treeClick);
//扫描保存
function RecSave(){

        var prescno=Ext.getCmp("BarCode").getValue();
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		 Ext.Ajax.request({
			 url: unitsUrl+'?action=RecSave',
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
						
                        ChildGridDs.removeAll();
                        ChildGridDs.setBaseParam("locId",'0')
                        ChildGridDs.setBaseParam("Number",NumberI)
                        ChildGridDs.setBaseParam("User",gUserId)
                        ChildGridDs.load();
					}else if (jsonData.info=="-10"){
					     Msg.info("warning", "处方号为空!");
					}
					 else if (jsonData.info=="-20"){
					     Msg.info("warning", "非代煎处方!");
				       }
					 else if (jsonData.info=="-30"){
					      Msg.info("warning", "该处方已扫描!")
					}
					else if (jsonData.info=="-40"){
					      Msg.info("warning", "处方号不存在!")
					}
					else if (jsonData.info=="-50"){
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
	treepanel.getRootNode().reload();
	}
function PrintUpdate(Ddate,Dtime){
    if (ChildGrid.getStore().getCount()==0)
    {  Msg.info("warning", "请选择要打印的数据!");
	   return;}
	var locid=Gnode
    if (locid=="") {	
          Msg.info("warning", "请选择要打印的数据!");
	   return;} 	
    var loadMask=ShowLoadMask(document.body,"更新中...");
     Ext.Ajax.request({
			 url: unitsUrl+'?action=PrintUpdate',
			 params: {locid:locid,User:gUserId,Number:NumberI,Ddate:Ddate,Dtime:Dtime},
			 success : function(result, request) {
			 		 var jsonData = Ext.util.JSON.decode(result.responseText);
					 loadMask.hide();
					 if (jsonData.success == 'true') {
						 Msg.info("success", "更新成功!");
						 PrintJYReg(locid,gUserId,Ddate,Dtime,Ddate,Dtime,"","20",gUserName)
						 ChildGridDs.removeAll();
						 ChildGridDs.setBaseParam("locId",'0')
						 ChildGridDs.setBaseParam("Number",NumberI)
						 ChildGridDs.setBaseParam("User",gUserId)
						 ChildGridDs.load();
					  }
			          else {Msg.info("success", "更新失败!");}
    	
	                 },
	           scope: this
     })
	treepanel.getRootNode().reload();
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
    
    var ChildGridProxy= new Ext.data.HttpProxy({url:unitsUrl+'?action=GetChild',method:'GET'});
    var ChildGridDs = new Ext.data.Store({
	proxy:ChildGridProxy,
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
    var ChildGridCm = new Ext.grid.ColumnModel([
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
    ChildGrid = new Ext.grid.EditorGridPanel({
	store:ChildGridDs,
	cm:ChildGridCm,
	trackMouseOver:true,
	stripeRows:true,
	//sm:new Ext.grid.CellSelectionModel({}),
	sm : new Ext.grid.RowSelectionModel({
		 singleSelect : true
		 }),
	loadMask:true,
    tbar:[BarCode,"条码",'-',PrintBT],
	clicksToEdit:1
    });  
    var ChildPanel = new Ext.Panel({
		title:'收药数据',
		activeTab: 0,
		region:'center',
		layout:'fit',
		items:[ChildGrid]                                 
	});        	  
        
    treepanel.on('click',function(node,e){
	ChildGridDs.proxy = new Ext.data.HttpProxy({url:unitsUrl+'?action=GetChild&locId='+node.attributes.id+'&Number='+NumberI+'&UserI='+gUserId,method:'GET'});
	ChildGridDs.load();
   });  
	var por = new Ext.Viewport({

				layout : 'border', // 使用border布局

				items : [treepanel,ChildPanel]

			});



});
