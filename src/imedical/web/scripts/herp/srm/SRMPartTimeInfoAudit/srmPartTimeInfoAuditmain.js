///////////////////////////////////////////////////

var tmpData="";

var itemGridUrl = '../csp/herp.srm.srmPartTimeInfoAuditexe.csp';

var usercode = session['LOGON.USERCODE'];





//配件数据源
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list&usercode='+usercode});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
			'rowid',
			'Type',
			'UserName',
			'DeptName',
			'CommitteeName',
			'PositionName',
			'Year',
			'StartDate',
			'EndDate',
			'SubUserName',
			'SubDate',
			'DataStatus',
			'Branch',
			'Auditor',
			'AuditDate',
			'ResAudit',
			'ResDesc',
			'CommitteeType'
		]),
	    remoteSort: true
});


var itemGridPagingToolbar = new Ext.PagingToolbar({
		pageSize: 15,
		store: itemGridDs,
		atLoad : true,
		displayInfo: true,
		displayMsg: '当前显示{0} - {1}，共计{2}',
		emptyMsg: "没有数据"//,

});
//设置默认排序字段和排序方向
itemGridDs.setDefaultSort('rowid', 'name');

//查询科室名称
var uCodeField = new Ext.form.TextField({
	id: 'uCodeField',
	fieldLabel: '用户编码',
	width:100,
	listWidth : 220,
	triggerAction: 'all',
	emptyText:'',
	name: 'uCodeField',
	minChars: 1,
	pageSize: 10,
	editable:true
});
var uNameField = new Ext.form.TextField({
	id: 'uNameField',
	fieldLabel: '用户名称',
	width:120,
	listWidth : 220,
	triggerAction: 'all',
	emptyText:'',
	name: 'uNameField',
	minChars: 1,
	pageSize: 10,
	editable:true
});

///组织名称
var CommitteeInfoDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
CommitteeInfoDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : itemGridUrl+'?action=CalCommitteeInfo', 
                        method:'POST'
					});
		});

var CommitteeInfoCombo = new Ext.form.ComboBox({
	id: 'CommitteeInfoCombo',
			fieldLabel : '组织名称',
			store : CommitteeInfoDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
///职务名称
var PartTimeJobsDs = new Ext.data.Store({
			proxy : "",
			
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
PartTimeJobsDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : itemGridUrl+'?action=CalPartTimeJobs', 
                        method:'POST'
					});
		});

var PartTimeJobsCombo = new Ext.form.ComboBox({
	id: 'PartTimeJobsCombo',
			fieldLabel : '职位名称',
			store : PartTimeJobsDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 260,
			
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
		
		///兼职级别
var CommitteeTypeDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});
		
CommitteeTypeDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : itemGridUrl+'?action=listCommitteeType&str='+encodeURIComponent(Ext.getCmp('CommitteeTypeCombo').getRawValue()), 
                        method:'POST'
					});
		});

var CommitteeTypeCombo = new Ext.form.ComboBox({
	id: 'CommitteeTypeCombo',
			fieldLabel : '级别',
			store : CommitteeTypeDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 100,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
			//editable:true
		});
///////////////////类型/////////////////////////////  
var TypeDs = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '科研'],['2', '教学']]
	});		
		
var TypeCombox = new Ext.form.ComboBox({
	                   id : 'TypeCombox',
		           fieldLabel : '类型',
	                   width : 120,
		           selectOnFocus : true,
		           allowBlank : true,
		           store : TypeDs,
		           anchor : '95%',			
		           displayField : 'keyValue',
		           valueField : 'key',
		           triggerAction : 'all',
		           //emptyText : '选择...',
		           mode : 'local', // 本地模式
		           editable : true,
		           // value:1,
		           selectOnFocus : true,
		           forceSelection : true
						  });			
		
		
		

var tmpTitle='学会兼职管理信息';	
var combos = new Ext.FormPanel({
			autoHeight : true,
			title : '社会兼职审核信息查询',
			iconCls : 'search',
			region:'north',
			frame:true,
			defaults: {bodyStyle:'padding:5px'},
				items:[{
			    columnWidth:1,
			    xtype: 'panel',
				layout:"column",
				items: [
				   	{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">类型</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					TypeCombox,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},					
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">组织信息</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					CommitteeInfoCombo,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">姓名</p>',
						width : 40			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					uNameField,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">职务名称</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					PartTimeJobsCombo,
					{
						xtype : 'displayfield',
						value : '',
						width : 30
					},
					{
						xtype : 'button',
						text : '查询',
						handler : function(b){srmdeptuserDs();},
						iconCls : 'search',
						width : 30
					}	
		     	]
			}]
});	
//数据库数据模型
var itemGridCm = new Ext.grid.ColumnModel([
       
        new Ext.grid.RowNumberer(), 
        // new Ext.grid.CheckboxSelectionModel({editable:false}),
        {

            id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       }, {
    	     id:'Type',
    	     header: '类型',
    	     allowBlank: false,
    	     width:40,
    	     editable:false,
    	     dataIndex: 'Type'
    	}, {
    	     id:'Year',
    	     header: '年度',
    	     allowBlank: false,
    	     width:60,
    	     editable:false,
    	     dataIndex: 'Year'
    	}, {
            id:'UserName',
            header: '兼职人员姓名',
            allowBlank: false,
            width:80,
            editable:false,
            dataIndex: 'UserName'
       }, {
            id:'DeptName',
            header: '科室名称',
            allowBlank: false,
            width:180,
            editable:false,
            dataIndex: 'DeptName',
			renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       }, {
            id:'CommitteeName',
            header: '学会名称',
            allowBlank: false,
            width:180,
            editable:false,
            dataIndex: 'CommitteeName',
			renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       }, {
            id:'Branch',
            header: '分会或学组名称',
            allowBlank: false,
            width:180,
            editable:false,
            dataIndex: 'Branch',
			renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
       }, {
    	     id:'PositionName',
    	     header: '职位名称',
    	     allowBlank: false,
    	     width:100,
    	     editable:false,
    	     dataIndex: 'PositionName'
    	},{
			 id:'CommitteeType',
    	     header: '级别',
    	     allowBlank: false,
    	     width:100,
    	     //editable:false,
    	     dataIndex: 'CommitteeType',
		    editor:CommitteeTypeCombo,
		    renderer : function(v, p, r){
							var index=CommitteeTypeDs.find('rowid',v);
							
							if (index!=-1)
							
							{
								return CommitteeTypeDs.getAt(index).data.Name;
							
								}
								return v
								//return r.get('Name');
					    }

		},{
    	     id:'StartDate',
    	     header: '任职开始时间',
    	     allowBlank: false,
    	     width:80,
    	     editable:false,
    	     dataIndex: 'StartDate'
    	}, {
    	     id:'EndDate',
    	     header: '任职截止时间',
    	     allowBlank: false,
    	     width:80,
    	     editable:false,
    	     dataIndex: 'EndDate'
    	}, {
    	     id:'SubUserName',
    	     header: '申请人 ',
    	     allowBlank: false,
    	     width:60,
    	     editable:false,
    	     dataIndex: 'SubUserName'
    	}, {
    	     id:'SubDate',
    	     header: '申请时间',
    	     allowBlank: false,
    	     width:80,
    	     editable:false,
    	     dataIndex: 'SubDate'
    	}, {
    	     id:'DataStatus',
    	     header: '数据状态',
    	     allowBlank: false,
    	     width:60,
    	     editable:false,
    	     dataIndex: 'DataStatus'
    	},{
						id:'Auditor',
						header:'审核人',
						width:60,
						editable:false,
						align:'left',
						dataIndex:'Auditor'

					},{
						id:'AuditDate',
						header:'审核时间',
						width:80,
						editable:false,
						align:'left',
						hidden:false,
						dataIndex:'AuditDate'

					},{
						id:'ResAudit',
						header:'审核状态',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'ResAudit'

					},{
						id:'ResDesc',
						header:'审核说明',
						width:180,
						editable:false,
						align:'left',
						dataIndex:'ResDesc'

					},{
							id:'upload',
							header: '附件',
							allowBlank: false,
							width:40,
							hidden:true,
							editable:false,
							dataIndex: 'upload',
							renderer : function(v, p, r){			
							return '<span style="color:blue"><u>上传</u></span>';
							}
					},{
							id:'download',
							header: '下载',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
					    } }
			    
]);


var AuditButton = new Ext.Toolbar.Button({
	text: '通过',  
    iconCls: 'pencil',
    handler:function(){
	//定义并初始化行对象
	var checker = session['LOGON.USERCODE'];
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	for(var j= 0; j< len; j++){
	    
	
	   if(rowObj[j].get("ResAudit")!='等待审批')
	 {
		      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
	
	     if(rowObj[j].get("CommitteeType") == "")
	 {
		      Ext.Msg.show({title:'注意',msg:'请填写级别',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
	 //alert(rowObj[j].get("CommitteeType"));
	 //alert(CommitteeTypeCombo.getValue());
	 
	}
	function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:'herp.srm.srmPartTimeInfoAuditexe.csp?action=audit&&rowid='+rowObj[i].get("rowid")+'&usercode='+usercode+'&CommitteeType='+CommitteeTypeCombo.getValue(),
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},   
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGridDs.load({params:{start:0, limit:12,usercode:checker}});								
							}else{
							Ext.Msg.show({title:'错误',msg:'审核失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						    }
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要审核所选记录吗?审核后不能修改',handler);
    }
});

var NoAuditButton = new Ext.Toolbar.Button({
				text : '不通过',
				iconCls: 'pencil',
				handler : function() {
					var rowObj=itemGrid.getSelectionModel().getSelections();
					var len = rowObj.length;
					if(len < 1){
						Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
						return;
					}
					for(var j= 0; j < len; j++){
						 if(rowObj[j].get("ResAudit")!='等待审批')
	       {
		      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	       }else
						{
							noauditfun();
						}
					}
					
					
			   }
});




var itemGrid = new Ext.grid.EditorGridPanel({
			title: '社会兼职审核信息查询列表',
			iconCls: 'list',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.srmPartTimeInfoAuditexe.csp',
		    atLoad : true, // 是否自动刷新
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			//tbar:[addButton,'-',editButton,'-',delButton,'-',subButton],
			tbar:[AuditButton,'-',NoAuditButton],
			
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});
  var srmdeptuserDs=function(){	
		
	    itemGridDs.proxy = new Ext.data.HttpProxy({
	    	
								url : 'herp.srm.srmPartTimeInfoAuditexe.csp?action=list&User='+encodeURIComponent(uNameField.getValue())+ 
								'&CommitteeDr='+CommitteeInfoCombo.getValue()+
								'&PositionDr='+ PartTimeJobsCombo.getValue()+'&usercode='+usercode+'&Type='+TypeCombox.getValue(),
								
								method : 'GET'
							});
					itemGridDs.load({
								params : {
									start : 0,
									limit : itemGridPagingToolbar.pageSize
								}
							});
	};


//uploadMainFun(itemGrid,'rowid','T001',17);
downloadMainFun(itemGrid,'rowid','T001',20);