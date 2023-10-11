//rowid^BonusSchemeID^BonusSchemeCode^BonusSchemeName^BonusUnitID^BonusUnitCode^BonusUnitName^BonusUnitTypeID^BonusUnitTypeName

//DeptName_"^"_userName_"^"_objDeptName_"^"_state
var schemeItemValue = new Array(
	{header:'ID',dataIndex:'rowid'},						//0
	{header:'方案主键',dataIndex:'schemeDr'}, 				//1
	{header:'预算编制科室',dataIndex:'DeptName'},    		//2
	{header:'预算编制责任人',dataIndex:'userName'},    		//3
	{header:'方案适用科室',dataIndex:'objDeptName'},        		//4
	{header:'预算编制审批状态',dataIndex:'state'},      //5
	{header:'审核步骤',dataIndex:'ChkStep'},    	//6
	{header:'审批状态描述',dataIndex:'ChkDesc'},      	//7
	{header:'审批状态y',dataIndex:'stateuse'}      	//8
);
//预算编制科室 预算编制责任人 方案适用科室 预算编制审批状态
//DeptName userName objDeptName state
var schemItemUrl = 'herp.budg.budgschemauditdeptexe.csp';

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
	    schemeItemValue[7].dataIndex
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
	url:'herp.budg.budgschemauditdeptexe.csp'+'?action=descNamelist&str='+encodeURIComponent(Ext.getCmp('unitFielddesc').getRawValue()),method:'POST'})
});
var unitFielddesc = new Ext.form.ComboBox({
	id:'unitFielddesc',
	fieldLabel: '预算编制科室',
	width:100,
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


var unitUserDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

unitUserDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:'herp.budg.budgschemauditdeptexe.csp'+'?action=userNamelist&str='+encodeURIComponent(Ext.getCmp('unitFieldUserName').getRawValue()),method:'POST'})
});
var unitFieldUserName = new Ext.form.ComboBox({
	id:'unitFieldUserName',
	fieldLabel: '审查人',
	width:100,
	listWidth : 245,
	allowBlank: false,
	store:unitUserDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'请选择审查人名称...',
	name: 'unitFieldUserName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
/////////////////科室名称/////////////////////////////////
var SchNameDDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','name'])
	});

	SchNameDDs.on('beforeload', function(ds, o){
		
		ds.proxy=new Ext.data.HttpProxy({url:'herp.budg.budgschemauditdeptexe.csp?action=descNamelist',method:'POST'});
		
	});
		
	var schemeNameDCombo = new Ext.form.ComboBox({
		fieldLabel:'科室名称',
		store: SchNameDDs,
		displayField:'name',
		valueField:'rowid',
		typeAhead: true,
		forceSelection: true,
		triggerAction: 'all',
		emptyText:'选择...',
		width: 150,
		listWidth : 245,
		pageSize: 10,
		minChars: 1,
		columnWidth:.2,
		selectOnFocus:true,
		columnWidth:.15
	});	
	
//**************************************************
var DnameField = new Ext.form.Field({
	id: 'DnameField',
	fieldLabel: '科室名称',
	width:110,
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
			schemeaudititemMainDept.load({params:{start:0, limit:12,schemeDr:tmpSelectedScheme,Dname:Dname}})
			}
	
	}

});

var checkbotton = new Ext.Toolbar.Button({
	text: '审核',
	tooltip: '审核',
	iconCls: 'option',
	handler: function(){
	
		var rowObj = budgschemauditmainDept.getSelectionModel().getSelections();
		checkFlowMainDr = rowObj[0].get("CHKFlowdr");	
	    schemDr = rowObj[0].get("rowid");
	    //alert(checkFlowMainDr+'-'+schemDr);	
		var schemAuditDR= ""
		if(rowObj.length==0){
			
				Ext.Msg.show({title:'注意',msg:'请先选择需要审核的方案!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		}
		else{	
		    //var rowObjItem = schemeaudititemMainDept.getSelectionModel().getSelections();
			//schemAuditDR= rowObjItem[0].get("rowid");
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
									schemeaudititemMainDept.load({params:{start:0,limit:12,schemeDr:tmpSelectedScheme}});
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
		var rowObj = schemeaudititemMainDept.getSelectionModel().getSelections();
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
		else{
			tmpRowid = rowObj[0].get("rowid");
			Ext.MessageBox.confirm('提示','确定要删除选定的行?',function(btn){
			if(btn == 'yes'){
					Ext.each(rowObj, function(record) {
					if (Ext.isEmpty(record.get("rowid"))) {
								schemeaudititemMainDept.getStore().remove(record);
								return;
							}
						Ext.Ajax.request({
							url: schemItemUrl + '?action=delete&rowid='+tmpRowid,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									schemeaudititemMainDept.load({params:{start:0,limit:12,schemeDr:tmpSelectedScheme}});
								}else{
									Ext.Msg.show({title:'错误',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});   	
					});  
					}
				} 
			)	
		}
	}
});

var schemeaudititemMainDept = new dhc.herp.Grid({
	region:'center',
	url: 'herp.budg.budgschemauditdeptexe.csp',

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
         
         {
            id: schemeItemValue[0].dataIndex,
            header: schemeItemValue[0].header,
            dataIndex: schemeItemValue[0].dataIndex,
            edit:false,
            hidden: true
         },{
            id: schemeItemValue[1].dataIndex,
            header: schemeItemValue[1].header,
            dataIndex: schemeItemValue[1].dataIndex,
            edit:false,
            hidden: true
         },{  id: schemeItemValue[2].dataIndex,
            header: schemeItemValue[2].header,
			width:200,
			allowBlank: false,
            dataIndex: schemeItemValue[2].dataIndex,
            descNamelist:true,
			type:unitFielddesc
		
        },{
            id: schemeItemValue[3].dataIndex,
            header: schemeItemValue[3].header,
            width:200,
			allowBlank: false,
			userNamelist:true,
			type:unitFieldUserName,
            dataIndex: schemeItemValue[3].dataIndex
        },{
            id: schemeItemValue[5].dataIndex,
            header: schemeItemValue[5].header,
			width:100,
			editable:false,
            dataIndex: schemeItemValue[5].dataIndex,
            hidden: true
        },{
            id:schemeItemValue[8].dataIndex,
            header: schemeItemValue[5].header,
			width:100,
            dataIndex: schemeItemValue[8].dataIndex,
            hidden: true
        }
        ],
        trackMouseOver: true,
		stripeRows: true,
		sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask: true,
		viewConfig : {forceFit : true},
		tbar:['科室名称:',DnameField,'-',searchNbotton,'-',checkbotton],
		bbar: scheme02PagingToolbar
	
});

	schemeaudititemMainDept.addButton('-');
	schemeaudititemMainDept.addButton(delButton);
    //schemeaudititemMainDept.btnAddHide();  //隐藏增加按钮
    //schemeaudititemMainDept.btnSaveHide();  //隐藏保存按钮
    schemeaudititemMainDept.btnResetHide();  //隐藏重置按钮
    schemeaudititemMainDept.btnDeleteHide(); //隐藏删除按钮
    schemeaudititemMainDept.btnPrintHide();  //隐藏打印按钮



