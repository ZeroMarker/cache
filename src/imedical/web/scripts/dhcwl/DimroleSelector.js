(function(){
	Ext.ns("dhcwl.mkpi.DimroleSelector");
})();
dhcwl.mkpi.DimroleSelector=function(){
	//-------------------------------------------------------------以下是指标维度的维护-------------------------------------------------------
	var serviceUrl="dhcwl/measuredimrole/dimrole.csp";
	var outThis=this;
	var choicegrpId="";
	var strPara="";
	var useddebug=0;
	var parentWin=null;
	var kpiRuleStr="";
	var csm = new Ext.grid.CheckboxSelectionModel()     //新建复选框的对象，使用的时候直接写  'csm' 
    var columnModelKpiDim = new Ext.grid.ColumnModel([
		new Ext.grid.RowNumberer(),
        {header:'指标维度编码',dataIndex:'dimRoleCode',width: 150, sortable: false,menuDisabled : true},
        {header:'指标维度名称',dataIndex:'dimRoleName',sortable:false,  width: 180, sortable: true,menuDisabled : true},
        {header:'关联维度编码',dataIndex:'dimCode',sortable:false,  width: 120, sortable: true,menuDisabled : true},
        {header:'关联维度名称',dataIndex:'dimName',sortable:false,  width: 120, sortable: true,menuDisabled : true}
    ]);
	
	var itemRec = Ext.data.Record.create([
		{
			name: 'dimRoleCode',
			type: 'string'
		}, {
			name: 'dimRoleName',
			type: 'string'
		}, {
			name: 'dimCode',
			type: 'string'
		}, {
			name: 'dimName',
			type: 'string'
		}]);
    var storeKpiDim = new Ext.data.Store({
    	proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getDimRole'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'dimRoleCode'},
            	{name: 'dimRoleName'},
            	{name: 'dimCode'},
            	{name: 'dimName'}
       		]
    	})
    });
    

    var kpiDimGrid = new Ext.grid.GridPanel({
        id:'configKpiDimGrid',
        stripeRows:true,
        loadMask:true,
        height:450, 
        store: storeKpiDim,
        resizeAble:true,
        enableColumnResize :true,
        cm: columnModelKpiDim,
        sm:csm,   //new Ext.grid.RowSelectionModel(),
        enableDragDrop: true,   //拖动排序用的属性
        dropConfig: {           //拖动排序用的属性
            appendOnly:true  
        },
		ddGroup: 'GridDD',
		listeners :{
        	'dblclick':function(ele,event){
        		var dimObj=dimGrid.getSelectionModel().getSelections();
				var dimlen = dimObj.length;
				var dimroleObj=kpiDimGrid.getSelectionModel().getSelections();
				var dimrolelen = dimroleObj.length;
				if((dimlen < 1)||(dimrolelen<1)){
					Ext.Msg.show({title:'注意',msg:'维度和维度角色需要选中后才能点击保存！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					return;
				}else{
					dimCode=dimObj[0].get("dimCode");
					dimName=dimObj[0].get("dimName");
					dimroleCode=dimroleObj[0].get("DimRoleCode");
					dimroleName=dimroleObj[0].get("DimRoleName");
					//alert(dimCode+" "+dimName+" "+dimroleCode+" "+dimroleName);
					parentWin.getKpiDimInfor(dimCode,dimName,dimroleCode,dimroleName);
					exeCodeWin.close();
				}
        	 }
         }
    });
	
	
	
	var dimCsm = new Ext.grid.CheckboxSelectionModel({
		singleSelect: true 
	});     //新建复选框的对象，使用的时候直接写  'csm' 
    var dimRoleColumn= new Ext.grid.ColumnModel([
        {header:'维度角色编码',dataIndex:'code',width: 150, sortable: false,menuDisabled : true},
        {header:'维度角色名称',dataIndex:'name',sortable:false,  width: 180, sortable: true,menuDisabled : true},
        {header:'维度编码',dataIndex:'allDimCode',sortable:false,  width: 120, sortable: true,menuDisabled : true},
        {header:'维度名称',dataIndex:'allDimName',sortable:false,  width: 120, sortable: true,menuDisabled : true}
    ]);
	
    var allItemRec = Ext.data.Record.create([
		{
			name: 'code',
			type: 'string'
		}, {
			name: 'name',
			type: 'string'
		}, {
			name: 'allDimCode',
			type: 'string'
		}, {
			name: 'allDimCode',
			type: 'string'
		}]);
		
    var dimRolestore = new Ext.data.Store({
    	proxy: new Ext.data.HttpProxy({url:serviceUrl+'?action=getAllDimRole'}),
        reader: new Ext.data.JsonReader({
            totalProperty: 'totalNum',
            root: 'root',
        	fields:[
        		{name: 'code'},
            	{name: 'name'},
            	{name: 'allDimCode'},
            	{name: 'allDimName'}
       		]
    	})
    });
    

    var allDimgrid = new Ext.grid.GridPanel({
        id:'allDimGrid',
        loadMask:true,
        height:450, 
        store: dimRolestore,
        resizeAble:true,
        enableColumnResize :true,
        cm: dimRoleColumn,
        sm:dimCsm,
		tbar: new Ext.Toolbar([{
			xtype:'label',
			text:'查找: '
        },{
			xtype:'textfield',
			name: 'searchShow',
			id	: 'searchShow',
			enableKeyEvents: true,
			listeners :{
				'keypress':function(ele,event){
					searcheValue=Ext.get("searchShow").getValue();//获取搜索值
					if ((event.getKey() == event.ENTER)){
						//alert(searcheValue);
						var para='searcheValue='+searcheValue;
						refresh(para);
					}
				}
			}
		}])
    });
	
	
	var actform = new Ext.FormPanel({
     	width:70,
     	height:500,
		layout: {
		    type:'vbox',
		    padding:'5',
		    pack:'center',
		    align:'center'
		},
		defaults:{margins:'0 0 5 0'},
		items:[{
		    xtype:'button',
		  	text: '>添加',
			//text: '<span style="line-Height:1">>添加</span>',
		  	width:50,
		  	handler:onBtnClick
		},{
		    xtype:'button',
		    text: '<移出',
			//text: '<span style="line-Height:1"><移出</span>',
		  	width:50,
		  	handler:onBtnClick
		}]

    });
    
	
    var dimRolePanel =new Ext.Panel ({ 
    	title:'指标维度选择',
		layout: {
			type: 'vbox',
			pack: 'start',
			align: 'stretch'
		},
		boarder:false,
		closable:true,
    	defaults: { border :false},
        items: [{
			border :false,
			flex:3,
			layout:"fit",
            items:[{
				border :false,
				layout: {

					type: 'hbox',
					pack: 'start',
					align: 'stretch'
				},				
				items:[{
					flex:0.5,
					layout:"fit",
					items:allDimgrid
				},{
					flex:0.16,
					layout:"fit",
					items:actform
				},{
					flex:0.93,
					layout:"fit",
					items:kpiDimGrid					
				}]
			}]
        }]
    });
    

	
	//----------------------------------------------------------------------以上维度与维度角色---------------------------------------------------------------
    var exeCodeWin= new Ext.Window({
		layout : 'fit',
		modal : true,
		width : 1060,
		height : 500,
		autoScroll:true,
		plain : true,
		boarder:false,
		id : 'dhcwl_mkpi_executeCodeWin',
		closable : true,
		buttonAlign:'center',
		items : dimRolePanel,
		buttons:new Ext.Toolbar([{
			text: '<span style="line-Height:1">保存</span>',
        	icon: '../images/uiimages/filesave.png',
            handler:function(){
				var store=parentWin.getStore();
				var dimRecord=parentWin.getRecord();
				var selRecs=kpiDimGrid.getStore().getCount();
				if (selRecs<=0) {
					Ext.Msg.alert("提示","请维护指标维度之后点击保存");
					return;
				}
				store.removeAll();
				for(var i=0;i<=selRecs-1;i++){
					var value=i+1;
					rec=kpiDimGrid.getStore().getAt(i);
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
			}
		}
		]),
		listeners:{
			'close':function(){
				exeCodeWin.destroy();
				exeCodeWin.close();
				if(dhcwl_mkpi_executeCodeWin){
					dhcwl_mkpi_executeCodeWin=null;
				}
			}
		}
	});
	
	
	kpiDimGrid.on("afterrender",function(component){
		var ddrow = new Ext.dd.DropTarget(kpiDimGrid.getView().scroller.dom, {
			ddGroup : 'GridDD',
			copy    : false,//拖动是否带复制属性
			notifyDrop : function(dd, e, data) { //对应的函数处理拖放事件
				// 选中了多少行
				var rows = data.selections;
				// 拖动到第几行
				var index = dd.getDragData(e).rowIndex;
				if (typeof(index) == "undefined") {
					return;
				}
				// 修改store
				for(i = 0; i < rows.length; i++) {
					var rowData = rows[i];
					if(!this.copy) storeKpiDim.remove(rowData);
					storeKpiDim.insert(index, rowData);
				}
			kpiDimGrid.getView().refresh();//刷新序号
			}

		});
	});
	function refresh(para){
		dimRolestore.proxy.setUrl(encodeURI(serviceUrl+'?action=getAllDimRole&'+para));
	    dimRolestore.load();
	}
	
	function onBtnClick(btn){
   		
		partCalExp=btn.getText();

		if(partCalExp==">添加"){
			
			var obj=allDimgrid.getSelectionModel().getSelections();
			var len=obj.length;
			if (len<1) {
				Ext.Msg.alert("提示","请先选择维度角色后操作");
				return;
			}
			
			var code=obj[0].get("code");
			if(!code||code==""||code==" ") return;
			var selRecs=kpiDimGrid.getStore().getCount();
			if (selRecs>0) {
				for(var i=0;i<=selRecs-1;i++){
					rec=kpiDimGrid.getStore().getAt(i);
					if(rec.get('dimRoleCode')==code){
						Ext.Msg.alert("提示","已经维护过啦！");
						return;	
					}
				}					
			}
			var dimRoleCode=obj[0].get("code");
			var dimRoleName=obj[0].get("name");
			var dimCode=obj[0].get("allDimCode");
			var dimName=obj[0].get("allDimName");
			
			var addedRec = new itemRec({
				dimRoleCode: dimRoleCode,
				dimRoleName:dimRoleName,
				dimCode:dimCode,
				dimName: dimName
			})
			kpiDimGrid.getStore().add(addedRec);
			allDimgrid.getStore().remove(obj);
		}else if(partCalExp=="<移出"){
			var selRecs=kpiDimGrid.getSelectionModel().getSelections();
			if (!selRecs||selRecs<1) {
				Ext.Msg.alert("提示","请选择一条记录");
				return;
			} 
			
			var rec=selRecs[0];
			kpiDimGrid.getStore().remove(rec);
			var dimroleCode=selRecs[0].get("dimRoleCode");
			var dimroleName=selRecs[0].get("dimRoleName");
			var dimCode=selRecs[0].get("dimCode");
			var dimName=selRecs[0].get("dimName");
			var addAllItemRec=new allItemRec({
				code:dimroleCode,
				name:dimroleName,
				allDimCode:dimCode,
				allDimName:dimName
			})
			allDimgrid.getStore().add(addAllItemRec);
		}
    }
	
    this.setParentWin=function(parent){
    	parentWin=parent;
    }
    this.getSelectValue=function(){
    	return selectedValue;
    }
    this.showWin=function(kpiId){
		dimRolestore.load();
		allDimgrid.show();
    	exeCodeWin.show();
		kpiId=parentWin.getKpiId();
		var store=parentWin.getStore();
		var selRecs=store.getCount();
		if (selRecs>0) {
			for(var i=0;i<=selRecs-1;i++){
				rec=store.getAt(i);
				var kpiDimCode=rec.get('MKPIDimCode');
				var kpiDimName=rec.get('MKPIDimDes');
				var dimCode=rec.get('MKPIDimDimDr');
				var dimName=rec.get('KDT_Name');
				var addedRec = new itemRec({
				dimRoleCode: kpiDimCode,
				dimRoleName:kpiDimName,
				dimCode:dimCode,
				dimName:dimName
				})
				kpiDimGrid.getStore().add(addedRec);
			}					
		}
    }
}