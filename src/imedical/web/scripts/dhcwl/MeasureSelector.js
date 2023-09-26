/**
 * @Title:指标度量选择界面
 * @Author: 汪凯-DHCWL
 * @Description:该界面用于指标度量的选择
 * @Created on 2017-09-12
 */
(function(){
	Ext.ns("dhcwl.mkpi.MeasureSelector");
})();
dhcwl.mkpi.MeasureSelector=function(){
	var outThis=this;
	var choicegrpId="";
	var strPara="";
	var useddebug=0;
	var parentWin=null;
	var serviceUrl="dhcwl/measuredimrole/measure.csp";
	var columnModel = new Ext.grid.ColumnModel([
        {header:'ID',dataIndex:'meaID',sortable:true, width: 30, sortable: true,menuDisabled : true,hidden:true},
        {header:'编码',dataIndex:'meaCode', width: 60, sortable: true,menuDisabled : false},
        {header:'描述',dataIndex:'meaDesc', width: 60, sortable: true,menuDisabled : false},
        {header:'数据源',dataIndex:'meaDSource',width: 90, sortable: true,menuDisabled : false},
        {header:'计算数据项',dataIndex:'meaCalItem',sortable:true, width: 90, sortable: false,menuDisabled : true},
        {header:'统计口径',dataIndex:'meastaCal',sortable:true, width: 90, sortable: false,menuDisabled : true},
        {header:'维护时间',dataIndex:'meaDate',id:'meadataSource',sortable:true, width: 30, sortable: false,menuDisabled : true,hidden:true},
		{header:'创建人',dataIndex:'meaCreator',sortable:true, width: 30, sortable: false,menuDisabled : true,hidden:true}
    ]);
	
	var store = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getMeasureInfor'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'meaID'},
            	{name: 'meaCode'},
            	{name: 'meaDesc'},
            	{name: 'meaDSource'},
            	{name: 'meaCalItem'},
            	{name: 'meastaCal'},
            	//{name: 'meaCreator'},
            	{name: 'meaDate'},
				{name: 'meaCreator'}
       		]
    	})
    });
	/*--------打开界面直接刷新数据---------*/
    store.proxy.setUrl(encodeURI("dhcwl/measuredimrole/measure.csp?action=getMeasureInfor&onePage=1&start=0&limit=16"));
	store.load();
	
	var pageTool=new Ext.PagingToolbar({
        pageSize: 16,
        store: store,
        displayInfo: true,
        displayMsg: '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
        emptyMsg: "没有记录"
    });
	
	//度量grid
    var meaGrid = new Ext.grid.GridPanel({
        stripeRows:true,
        loadMask:true,
        height:450,        
        store: store,
		autoExpandColumn: 'meadataSource',
        cm: columnModel,
		bbar:pageTool,
        sm: new Ext.grid.RowSelectionModel({
        	singleSelect: true,
            listeners: {
            }
        }),
		viewConfig: {
			forceFit: true             //--强制充满
		},
		tbar: new Ext.Toolbar([{
			xtype:'label',
			text:'统计口径: '
		},'-',{
			xtype:'treecombo',
			id:'meastaCalTreePath',
			name:'meastaCalTreePath',
			url:serviceUrl+'?action=getMeasureTree',
			listWidth : 350,
			rootVisible:true,
			rootText:'度量树',//--根节点名称
			//rootVisible:false,//是否显示根节点
			allowUnLeafClick:false//false表示不允许非子叶点击选中。
		},'-',{
			xtype    :'textfield',
			name     :'MeaSearchShow',
			id     :'MeaSearchShow',
			enableKeyEvents: true,
			listeners :{
				'keypress':function(ele,event){     //----回车可以根据填写内容刷新表单
					if ((event.getKey() == event.ENTER)){
						refresh();
					}
				}
			}
		},{
			text: '<span style="line-Height:1">查找</span>',
		    icon   : '../images/uiimages/search.png',
			handler:function(){
				refresh();
    	   }
		}]),
        listeners :{
        	'dblclick':function(ele,event){    //双击选中对象，将选中的度量设置为指标度量
        		var meaObj=meaGrid.getSelectionModel().getSelections();
				var mealen = meaObj.length;
				if((mealen < 1)){
					//Ext.Msg.show({title:'注意',msg:'维度和维度角色需要选中后才能点击保存！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					meaCode=meaObj[0].get("meaCode");
					meaDesc=meaObj[0].get("meaDesc");
					meaDSource=meaObj[0].get("meaDSource");
					meaCalItem=meaObj[0].get("meaCalItem");
					meastaCal=meaObj[0].get("meastaCal");
					parentWin.getKpiMeasureInfor(meaCode,meaDesc,meaDSource,meaCalItem,meastaCal);
					exeCodeWin.close();
				}
        	 }
         }

    });
	//------------------------------------以上维度与维度角色--------------------------------------
    var exeCodeWin= new Ext.Window({
		title  :'度量选择',
    	layout :'fit',
	    modal:true,
    	width  :1050,
    	height :500,
		buttonAlign:'center',
    	items  :[meaGrid],
		id : 'dhcwl_mkpi_measureselector'/*,
		buttons:new Ext.Toolbar([{
			text: '<span style="line-Height:1">保存</span>',
        	icon: '../images/uiimages/filesave.png',
            handler:function(){
				var store=parentWin.getStore();
				var dimRecord=parentWin.getRecord();
				var selRecs=dimRoleGrid.getStore().getCount();
				if (selRecs<=0) {
					Ext.Msg.alert("提示","请维护指标维度之后点击保存");
					return;
				}
				store.removeAll();
				for(var i=0;i<=selRecs-1;i++){
					var value=i+1;
					rec=dimRoleGrid.getStore().getAt(i);
					var moveLeftRec = new dimRecord({
						MKPIDimCode:rec.get('dimRoleCode'),
						MKPIDimDes:rec.get('dimRoleName'),
						MKPIDimDimDr:rec.get('dimCode'),
						KDT_Name:rec.get('dimName'),
						MKPIDimOrder:value,
						MKPIDimDeli:','
					});
					store.add(moveLeftRec);
				}
				exeCodeWin.close();
			}
		},{
			text: '<span style="line-Height:1">关闭</span>',
        	icon: '../images/uiimages/undo.png',
            handler:function(){
				exeCodeWin.close();
				//getTree();
			}
		}
		])*/
	});
	
	
	function refresh(){
		var nodeID=Ext.getCmp('meastaCalTreePath').getHiddenValue();
		if (!nodeID){
			nodeID="";
		}
		//store.proxy.setUrl(encodeURI("dhcwl/measuredimrole/measure.csp?action=getMeasureInfor&start=0&limit=16&onePage=1&nodeID="+nodeID));
		//store.load();
		var measureSearch=Ext.get('MeaSearchShow').getValue();
		store.proxy.setUrl(encodeURI("dhcwl/measuredimrole/measure.csp?action=getMeasureInfor&start=0&limit=16&onePage=1&measureSearch="+measureSearch+"&nodeID="+nodeID));
		store.load();
    }
	
    this.setParentWin=function(parent){
    	parentWin=parent;
    }
    this.getSelectValue=function(){
    	return selectedValue;
    }
    this.showWin=function(kpiId){
    	exeCodeWin.show();
		kpiId=parentWin.getKpiId();
    }
}