var commonboxURL='herp.budg.budgcommoncomboxexe.csp';
var projUrl = 'herp.budg.budgadjustdeptyearauditexe.csp';
var budgDataInitUrl = 'herp.budg.budgschemaselfexe.csp';
var calcueURL='herp.budg.budgadjustcalcuexe.csp';
var UserID = session['LOGON.USERID'];

////////////// 调整序号 //////////////////////
var strInfo="请选择..."
var AdjustNoStore = new Ext.data.Store({
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['AdjustNo','AdjustNo'])
});


AdjustNoStore.on('beforeload', function(ds, o){
	var year=yearField.getValue();	
	if(!year)
	{
		Ext.Msg.show({title:'注意',msg:'请先选择会计年度',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
	
});

var AdjustNo = new Ext.form.ComboBox({
	id: 'AdjustNo',
	fieldLabel: '调整序号',
	width:120,
	listWidth : 225,
	store: AdjustNoStore,
	valueField: 'AdjustNo',
	displayField: 'AdjustNo',
	triggerAction: 'all',
	emptyText:'请选择...',
	name: 'AdjustNo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
		         
});


///////////// 会计年度 ///////////////////
var yearDs  = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['year','year'])
});

yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:commonboxURL+'?action=year',method:'POST'})
});

var yearField  = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '会计年度',
	width:120,
	listWidth : 225,
	store: yearDs,
	valueField: 'year',
	displayField: 'year',
	triggerAction: 'all',
	emptyText:'请选择年度...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true,
	listeners:{
            "select":function(combo,record,index){
	            AdjustNoStore.removeAll();     
				AdjustNo.setValue('');
				AdjustNoStore.proxy = new Ext.data.HttpProxy({url:commonboxURL+'?action=adjustno&flag=0&year='+combo.value,method:'POST'})  
				AdjustNoStore.load({params:{start:0,limit:10}});
				ScenarioNameDs.removeAll();     
				ScenarioName.setValue('');
				ScenarioNameDs.proxy = new Ext.data.HttpProxy({url:projUrl+'?action=scenarioname&year='+combo.value,method:'POST'})  
				ScenarioNameDs.load({params:{start:0,limit:10}});            					
				}
}	
});


////////////// 方案名称 //////////////////////
var ScenarioNameDs= new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

ScenarioNameDs.on('beforeload', function(ds, o){
	var year=yearField.getValue();	
	if(!year)
	{
		Ext.Msg.show({title:'注意',msg:'请先选择会计年度',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return ;
	}
		});

var ScenarioName = new Ext.form.ComboBox({
	id: 'ScenarioName',
	fieldLabel: '方案名称',
	width:120,
	listWidth : 225,
	store: ScenarioNameDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择...',
	name: 'ScenarioName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	columnWidth:.15,
	forceSelection:'true',
	editable:true
});


///////////////////// 查询  ////////////////////////
var searchButton = new Ext.Toolbar.Button({
	text: '查询',
    tooltip:'查询',        
    iconCls:'find',
	handler:function(){
	
	var year=yearField.getValue();
	var adjustno=AdjustNo.getValue();
	var scenarioname=ScenarioName.getValue();
		
	itemMain.load(({params:{start:0, limit:25,UserID:UserID,year:year,AdjustNo:adjustno,scenarioname:scenarioname}}));
	
	}
});

var calculateButton = new Ext.Toolbar.Button({
			text : '计算',
			tooltip : '计算',
			iconCls:'add',
			width : 70,
			handler : function() {
			
			var myMask = new Ext.LoadMask(Ext.getBody(), {
		        msg: '数据计算中…',
		        removeMask: true //完成后移除
		    });
			
			var syear= yearField.getValue();
			if(syear==""){
				Ext.Msg.show({title:'错误',msg:'年度不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			};
			var Schemname= ScenarioName.getValue();
			if(Schemname==""){
				Ext.Msg.show({title:'错误',msg:'方案名称不能为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			};
			var selectedRow = itemMain.getSelectionModel().getSelections();
    		var len = selectedRow.length;
    		if(len <=0){
		    Ext.Msg.show({title:'注意',msg:'请先选择科室！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		    return;
	        }
    		var objdeptdr = selectedRow[0].get("objdeptdr");
    		
			function handler(id) {
				if (id == 'yes') {
					myMask.show();
					Ext.Ajax.request({
					url : budgDataInitUrl + '?action=calulate&year='+ syear+'&SchemDR='+Schemname+'&objdeptdr='+objdeptdr+'&ChangeFlag=2',
						failure : function(result, request) {
						myMask.hide();
							Ext.Msg.show({title : '错误',msg : '请检查网络连接!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
						},
						success : function(result, request) {
						myMask.hide();
							var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.show({title : '注意',msg : '计算成功!',buttons : Ext.Msg.OK,icon : Ext.MessageBox.INFO});
								}else{
									Ext.Msg.show({title : '错误',msg : jsonData.info,buttons : Ext.Msg.OK,icon : Ext.MessageBox.ERROR});
								}
						},
						scope : this
					})
				}
			}
			Ext.MessageBox.confirm('提示','确实要计算吗?',handler);			
			}
		});

var itemMain = new dhc.herp.Grid({
    title: '科室年度预算调整计算',
    region : 'north',
    url: calcueURL,

	tbar:['会计年度:',yearField,'-','调整序号:',AdjustNo,'-','方案名称:',ScenarioName,'-',searchButton,calculateButton],
	
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: '预算方案ID',
        editable:false,
        dataIndex: 'rowid',
        hidden: true
    },{ 
        id:'CompName',
        header: '医疗单位',
        dataIndex: 'CompName',
        width:100,
        allowBlank: true,
		editable:false,
		hidden: false
    },{
    	id:'year',
        header: '会计年度',
        width:100,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'year'
    },{ 
        id:'dcode',
        header: '科室编码',
        dataIndex: 'dcode',
        width:150,
        allowBlank: true,
		editable:false,
		hidden: true
    },{ 
        id:'dname',
        header: '科室名称',
        dataIndex: 'dname',
        width:150,
        allowBlank: true,
		editable:false,
		hidden: false
    }, {
        id:'bsmcontent',
        header: '预算内容',
        width:100,
        editable:false,
        allowBlank: true,
        dataIndex: 'bsmcontent'
		
    },{
        id:'bsmorderby',
        header: '编制顺序',
        width:100,
		allowBlank: false,
		editable:false,
        dataIndex: 'bsmorderby'	
		
    },{
        id:'bidname',
        header: '结果对应预算项',
        width:150,
		allowBlank: false,
		editable:false,
        dataIndex: 'bidname'	
		
    }, {
        id:'bmsuupschemdr',
        header: '前置方案',
        width:100,
		allowBlank: true,
		editable:false,
        dataIndex: 'bmsuupschemdr',
        renderer : function(v, p, r) {
		return '<span style="color:blue;cursor:hand"><u>查询</u></span>';									
        }
	// BSA_Rowid,BSA_EditDeptDR->BDEPT_Name dname,BSM_OrderBy,BID_Name,BSA_ChkState,
	// BSA_ChkStep,BCFM_ChkFlowName,BSM_File
	
    }, {
        id:'bsachkstate',
        header: '编制状态',
        width:100,
		allowBlank: true,
		editable:false,
        dataIndex: 'bsachkstate'
		
    },{
    	id:'bsachkstep',
        header: '编制步骤',
        width:150,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsachkstep'
    },{
    	id:'bcfmchkflowname',
        header: '审批流',
        width:120,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bcfmchkflowname'
    },{
    	id:'bsmfile',
        header: '说明文件',
        width:100,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'bsmfile'
    },{
    	id:'name',
        header: '方案名称',
        width:150,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'name'
    },{
    	id:'objdeptdr',
        header: '方案适用科室ID',
        width:150,
	    allowBlank: true,
	    editable:false,
	    update:true,
        dataIndex: 'objdeptdr',
        hidden: true
    },{
        id:'bsarowid',
        header: '预算编制方案归口ID',
        width:150,
        editable:false,
        dataIndex: 'bsarowid',
        hidden: true
    },{
        id:'AdjustNo',
        header: '调整号',
        width:150,
        editable:false,
        dataIndex: 'AdjustNo'
    }],
	
	split : true,
	collapsible : true,
	containerScroll : true,
	xtype : 'grid',
	trackMouseOver : true,
	stripeRows : true,
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	loadMask : true,
	height:230,
	trackMouseOver: true,
	stripeRows: true

});

itemMain.btnAddHide();    //隐藏增加按钮
itemMain.btnSaveHide();   //隐藏保存按钮
itemMain.btnResetHide();  //隐藏重置按钮
itemMain.btnDeleteHide(); //隐藏删除按钮
itemMain.btnPrintHide();  //隐藏打印按钮

itemMain.load({params:{start:0, limit:12,UserID:UserID}});

itemMain.on('rowclick', function() {

	var selectedRow = itemMain.getSelectionModel().getSelections();
	
	var bsachkstep=selectedRow[0].data['bsachkstep'];
	var bsarstepno=selectedRow[0].data['bsarStepNO'];
	var bcfdstepno=selectedRow[0].data['bcfdStepNO'];
	var iscurstep =selectedRow[0].data['IsCurStep'];
	

	if(bsachkstep==99)
	{
		 auditButton.disable(),
		 cancleauditButton.enable();

	}
	else if((bsarstepno==bcfdstepno)&&((iscurstep==1)||(iscurstep==""))) 
	{
		auditButton.enable(),
		cancleauditButton.disable()
	}
	else 
	{
		 auditButton.disable(),
		 cancleauditButton.disable()
	}
})



itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	var selectedRow = itemMain.getSelectionModel().getSelections();
	var SchemDr=selectedRow[0].data['rowid'];
	var objdeptdr=selectedRow[0].data['objdeptdr'];
	var bsmyear=selectedRow[0].data['year'];
	var adjustno=selectedRow[0].data['AdjustNo'];
	itemDetail.load({params:{start:0, limit:12,SchemDr:SchemDr,objdeptdr:objdeptdr,bsmyear:bsmyear,adjustno:adjustno}});
				
});


//单击gird的单元格事件
itemMain.on('cellclick', function(g, rowIndex, columnIndex, e) {
	
	var records = itemMain.getSelectionModel().getSelections();
	var mainID = records[0].get("rowid");
	
	////  单击前置方案事件 ////
	if (columnIndex == 8) 
	{
		
		ChildFun(mainID);
		
	}
});



