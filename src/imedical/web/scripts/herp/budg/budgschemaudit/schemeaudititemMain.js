//rowid^BonusSchemeID^BonusSchemeCode^BonusSchemeName^BonusUnitID^BonusUnitCode^BonusUnitName^BonusUnitTypeID^BonusUnitTypeName

//DeptName_"^"_userName_"^"_objDeptName_"^"_state
var URL='herp.budg.budgschemauditexe.csp';

var schemeItemValue = new Array(
	{header:'ID',dataIndex:'rowid'},						//0
	{header:'方案主键',dataIndex:'SchemDr'}, 				//1
	{header:'预算编制科室',dataIndex:'DeptName'},    		//2
	{header:'预算编制责任人',dataIndex:'userName'},    		//3
	{header:'方案适用科室',dataIndex:'objDeptName'},        		//4
	{header:'审批状态',dataIndex:'state'},      //5
	{header:'审核步骤',dataIndex:'ChkStep'},    	//6
	{header:'审批状态描述',dataIndex:'ChkDesc'},      	//7
	{header:'审批状态y',dataIndex:'stateuse'}      	//8
);

//获取科室名称

var deptDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


deptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgschemauditexe.csp'+'?action=descNamelist&flag=1&str='+encodeURIComponent(Ext.getCmp('deptField').getRawValue()),method:'POST'});
});

var deptField = new Ext.form.ComboBox({
	id: 'deptField',
	fieldLabel: '科室名称',
	width:150,
	listWidth : 300,
	//allowBlank: false,
	store: deptDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室名称...',
	name: 'deptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//预算编制科室 预算编制责任人 方案适用科室 预算编制审批状态
//DeptName userName objDeptName state
var schemItemUrl = 'herp.budg.budgschemauditexe.csp';
//var scheme02Proxy = new Ext.data.HttpProxy({url: schemItemUrl + '?action=ListItemlist'});

var schemItemDs = new Ext.data.Store({
	proxy: '',
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	},[
		schemeItemValue[0].dataIndex,
		schemeItemValue[1].dataIndex,
		schemeItemValue[2].dataIndex,
		schemeItemValue[3].dataIndex,
		schemeItemValue[4].dataIndex,
		schemeItemValue[5].dataIndex,
		schemeItemValue[6].dataIndex,
	    schemeItemValue[7].dataIndex,
	    schemeItemValue[8].dataIndex
	]),
	remoteSort: true
});
schemItemDs.setDefaultSort('rowid', 'Desc');

var unitDs1 = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

unitDs1.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgschemauditexe.csp'+'?action=descNamelist&flag=1&str='+encodeURIComponent(Ext.getCmp('unitFielddesc').getRawValue()),method:'POST'});
});
var unitFielddesc = new Ext.form.ComboBox({
	id:'unitFielddesc',
	fieldLabel: '预算编制科室',
	width:165,
	listWidth : 245,
	allowBlank: false,
	store:unitDs1,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择科室名称...',
	name: 'unitFielddesc',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


//获取审查人名称

var unituserDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});
unituserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgschemauditexe.csp'+'?action=userNamelist&flag=1&str='+encodeURIComponent(Ext.getCmp('unituserField').getRawValue()),method:'POST'});
});
var unituserField = new Ext.form.ComboBox({
	id: 'unituserField',
	fieldLabel: '人员名称',
	width:200,
	listWidth :300,
	allowBlank: false,
	store: unituserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择人员姓名...',
	name: 'unituserField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

//**************************************************
var DnameField = new Ext.form.Field({
	id: 'DnameField',
	fieldLabel: '科室名称',
	width:110,
	listWidth : 245,
	//allowBlank: false,
	//valueField: 'rowid',
	//displayField: 'name',
	triggerAction: 'all',
	emptyText:'请填写方案名称',
	name: 'DnameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

	var searchNbotton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	      var Dname=Ext.getCmp('DnameField').getValue();	     
					if (tmpSelectedScheme == ""){
							message = '请先选择对应方案的行！';
					}else{		
			schemeaudititemMain.load({params:{start:0,limit:12,schemeDr:tmpSelectedScheme,Dname:Dname}})
			}
	
	}

});


var checkSbotton = new Ext.Toolbar.Button({
	text: '审核',
	tooltip: '批量审核',
	iconCls: 'option',
	handler: function(){
	
		var rowObj = budgschemauditmain.getSelectionModel().getSelections();
		if(rowObj.length==0){
		
				Ext.Msg.show({title:'注意',msg:'请先选择需要审核的方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			}
			checkFlowMainDr = rowObj[0].get("CHKFlowdr");	
			schemDr = rowObj[0].get("rowid");		
		var rowObj = schemeaudititemMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var schemAuditDr = "",dataid="";
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的科室!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		else{
			 for(var i = 0; i < len; i++)
			 {
				 var rowid = rowObj[i].get("rowid");
				 if(dataid==""){var dataid=rowid}
				 else{var dataid=dataid+"^"+rowid;}
			 }
			Ext.MessageBox.confirm(
				'提示', 
				'确定要审核选定的行?', 
				function(btn){
					if(btn == 'yes'){
						Ext.Ajax.request({
							url: schemItemUrl + '?action=auditcheckS&checkFlowMainDr='+checkFlowMainDr+'&schemDr='+schemDr+'&dataid='+dataid+'&len='+len,
							waitMsg:'审核中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									schemeaudititemMain.load({params:{start:0,limit:12,schemeDr:tmpSelectedScheme}});
								}else{
									Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					}
				} 
			)	
		}
	
	
	}
	
});

var uncheckSbotton = new Ext.Toolbar.Button({
	text: '取消审核',
	tooltip: '批量取消审核',
	iconCls: 'option',
	handler: function(){
	
		var rowObj = budgschemauditmain.getSelectionModel().getSelections();
		if(rowObj.length==0){
		
				Ext.Msg.show({title:'注意',msg:'请先选择需要取消审核的方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			}
			checkFlowMainDr = rowObj[0].get("CHKFlowdr");	
			schemDr = rowObj[0].get("rowid");		
		var rowObj = schemeaudititemMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var schemAuditDr = "",dataid="";
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要取消审核的科室!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		else{
			 for(var i = 0; i < len; i++)
			 {
				 var rowid = rowObj[i].get("rowid");
				 if(dataid==""){var dataid=rowid}
				 else{var dataid=dataid+"^"+rowid;}
			 }
			Ext.MessageBox.confirm(
				'提示', 
				'确定要取消审核选定的行?', 
				function(btn){
					if(btn == 'yes'){
						Ext.Ajax.request({
							url: schemItemUrl + '?action=unauditcheckS&checkFlowMainDr='+checkFlowMainDr+'&schemDr='+schemDr+'&dataid='+dataid+'&len='+len,
							waitMsg:'审核中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									schemeaudititemMain.load({params:{start:0,limit:12,schemeDr:tmpSelectedScheme}});
								}else{
									Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					}
				} 
			)	
		}
	
	
	}
	
});

var checkbotton = new Ext.Toolbar.Button({
	text: '审核',
	tooltip: '审核',
	iconCls: 'option',
	handler: function(){
	  
		var rowObj = budgschemauditmain.getSelectionModel().getSelections();
		if(rowObj.length==0){
		
				Ext.Msg.show({title:'注意',msg:'请先选择需要审核的方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			}
		checkFlowMainDr = rowObj[0].get("CHKFlowdr");		
		schemDr = rowObj[0].get("rowid");	
		
		var rowObj = schemeaudititemMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var schemAuditDr = "";
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的科室!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		else{
			schemAuditDR= rowObj[0].get("rowid");
			Ext.MessageBox.confirm(
				'提示', 
				'确定要审核选定的行?', 
				function(btn){
					if(btn == 'yes'){
						Ext.Ajax.request({
							url: schemItemUrl + '?action=auditcheck&checkFlowMainDr='+checkFlowMainDr+'&schemDr='+schemDr+'&schemAuditDR='+schemAuditDR,
							waitMsg:'审核中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									schemeaudititemMain.load({params:{start:0,limit:12,schemeDr:tmpSelectedScheme}});
								}else{
									Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					}
				} 
			)	
		}
	
	
	}
	
});

//批量添加
var editrrButton = new Ext.Toolbar.Button({
	text: '批量添加',
	tooltip: '批量添加方案适用科室等',
	iconCls: 'add',
	handler: function(){
		var rowObj = budgschemauditmain.getSelectionModel().getSelections();
		if(rowObj.length==0){
			Ext.Msg.show({title:'注意',msg:'请先选择对应的方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			}
		var	schid = rowObj[0].get("rowid");
		editrFun(schemeaudititemMain,schid);
		}
});


/*var schemItemCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		id: schemeItemValue[2].dataIndex,
		header: schemeItemValue[2].header,
		dataIndex: schemeItemValue[2].dataIndex,
		width: 100,
		descNamelist:true,
		allowBlank: false,
		type:unitFielddesc,
		sortable: true
	},
	{
		id:schemeItemValue[3].dataIndex,
		header: schemeItemValue[3].header,
		dataIndex:schemeItemValue[3].dataIndex,
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		id: schemeItemValue[4].dataIndex,
		header: schemeItemValue[4].header,
		dataIndex: schemeItemValue[4].dataIndex,
		width: 100,
		descNamelist:true,
		allowBlank: false,
		align: 'left',
		type:unitFielddesc,
		sortable: true
	},
	{	id: schemeItemValue[5].dataIndex,
		header: schemeItemValue[5].header,
		dataIndex: schemeItemValue[5].dataIndex,
		width: 100,
		align: 'left',
		sortable: true
	}
]);*/


var scheme02PagingToolbar = new Ext.PagingToolbar({
	pageSize: 25,
	store: schemItemDs,
	displayInfo: true,
	displayMsg: '当前显示{0} - {1}，共计{2}',
	emptyMsg: "没有数据"//,
});

var delButton = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'remove',
	handler: function(){
		var rowObj = schemeaudititemMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		if(len < 1)
		{
			Ext.Msg.show({title:'注意',msg:'请选择删除的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		if(rowObj[0].get("stateuse")==1)
		{
			Ext.Msg.show({title:'注意',msg:'已审核,不能删除!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		
			var rowids=""
			for(var i = 0; i < len; i++){
				tmpRowid = rowObj[i].get("rowid");	
				if(rowids==""){
					rowids=tmpRowid;
					}
				else {
					rowids=rowids+"|"+tmpRowid
					}
				}
			
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',function(btn){
			if(btn == 'yes'){
						Ext.each(rowObj, function(record) {
						if (Ext.isEmpty(record.get("rowid"))) {
									schemeaudititemMain.getStore().remove(record);
									return;
						}
							});  
						Ext.Ajax.request({
							url: schemItemUrl + '?action=delete&rowid='+rowids,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									schemeaudititemMain.load({params:{start:0,limit:12,schemeDr:tmpSelectedScheme}});
								}else{
									Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
				
					}
				} 
			)	
		}
	});

var schemeaudititemMain = new dhc.herp.Grid({
	//title:'item',
	region:'east',
	width:510,
	layout:"fit",
	url: 'herp.budg.budgschemauditexe.csp',
	
	listeners : {
		    'cellclick' : function(grid, rowIndex, columnIndex, e) {
		                var record = grid.getStore().getAt(rowIndex);
		                  // 根据条件设置单元格点击编辑是否可用 
		                 if (record.get('stateuse') =="1") {
		                      return false;
		                  } else {return true;}
		               },
		    'celldblclick' : function(grid, rowIndex, columnIndex, e) {
						var record = grid.getStore().getAt(rowIndex);
						// 预算项目公式编辑
					if (record.get('stateuse') =="1") {						
							return false;
					} else {
							return true;
					}
				}
        },
	fields: [
	new Ext.grid.CheckboxSelectionModel({editable:false}),
         
         {
            id: schemeItemValue[0].dataIndex,
            header: schemeItemValue[0].header,
            dataIndex: schemeItemValue[0].dataIndex,
            edit:false,
            hidden: true
         }, 
         {  id: schemeItemValue[2].dataIndex,
            header: schemeItemValue[2].header,
			width:165,
			allowBlank: false,
            dataIndex: schemeItemValue[2].dataIndex,
            descNamelist:true,
			type:unitFielddesc
		
        },
        {
            id: schemeItemValue[3].dataIndex,
            header: schemeItemValue[3].header,
            width:165,
			allowBlank: false,
			//userNamelist:true,
            dataIndex: schemeItemValue[3].dataIndex,
            type: unituserField
        }, 
        {
            id: schemeItemValue[4].dataIndex,
            header: schemeItemValue[4].header,
			//descNamelist:true,
			allowBlank: false,
			width:165,
            dataIndex: schemeItemValue[4].dataIndex,
			type:deptField
        },
        {
            id:schemeItemValue[5].dataIndex,
            header: schemeItemValue[5].header,
			width:100,
			editable:false,
            dataIndex: schemeItemValue[5].dataIndex,
            hidden: false
        },
        {
            id:schemeItemValue[8].dataIndex,
            header: schemeItemValue[8].header,
			width:100,
			editable:false,
            dataIndex: schemeItemValue[8].dataIndex,
            hidden: true
        }
        ],
        split : true,
        collapsible : true,
        containerScroll : true,
        trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig : {forceFit : true},
		tbar:['科室名称:',DnameField,'-',searchNbotton,'-',checkSbotton,'-',uncheckSbotton,'-',editrrButton],
		bbar: scheme02PagingToolbar
	    	
	
	
});

	schemeaudititemMain.addButton('-');
	schemeaudititemMain.addButton(delButton);
    //schemeaudititemMain.btnAddHide();  //隐藏增加按钮
    //schemeaudititemMain.btnSaveHide();  //隐藏保存按钮
    schemeaudititemMain.btnResetHide();  //隐藏重置按钮
    schemeaudititemMain.btnDeleteHide(); //隐藏删除按钮
    schemeaudititemMain.btnPrintHide();  //隐藏打印按钮
