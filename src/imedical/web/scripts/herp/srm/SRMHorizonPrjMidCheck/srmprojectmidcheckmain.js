///////////////////////////////////////////////////

var tmpData="";

var itemGridUrl = '../csp/herp.srm.horizonprjmidcheckexe.csp';
//配件数据源
var itemGridProxy= new Ext.data.HttpProxy({url:itemGridUrl + '?action=list'});
var itemGridDs = new Ext.data.Store({
		proxy: itemGridProxy,
	    reader: new Ext.data.JsonReader({
	        root: 'rows',
	        totalProperty: 'results'
	    }, [
	        'rowid','Name','DeptDr','DeptName','Head','HeadName','Participants','SubSource','SubSourceName','SubNo','AppFunds','GraFunds','StartDate','EndDate','ConDate','RelyUnit','SubUser','SubUserName','SubDate','DataStatus','ResAudit','ResDesc','AuditUser','AuditUserName','AuditDate','ProjStatus','Remark','SysNo','SysNoCode'

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

//

var PrjSrcDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['prjtyperowid','prjtypename'])
});
PrjSrcDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:itemGridUrl+'?action=GetPrjType&str='+encodeURIComponent(Ext.getCmp('PrjSrcField').getRawValue()),method:'POST'});
});
var PrjSrcField = new Ext.form.ComboBox({
	id: 'PrjSrcField',
	fieldLabel: '课题来源',
	width:150,
	listWidth :225,
//	allowBlank: false,
	store: PrjSrcDs,
	valueField: 'prjtyperowid',
	displayField: 'prjtypename',
	triggerAction: 'all',
	emptyText:'请选择课题来源...',
	name: 'PrjSrcField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

///课题负责人////////////////////////////////
var PrjHeaderDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['headerrowid','headername'])
});
PrjHeaderDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:itemGridUrl+'?action=GetPrjHeader&str='+encodeURIComponent(Ext.getCmp('PrjHeaderField').getRawValue()),method:'POST'});
});
var PrjHeaderField = new Ext.form.ComboBox({
	id: 'PrjHeaderField',
	fieldLabel: '课题负责人',
	width:150,
	listWidth :225,
//	allowBlank: false,
	store: PrjHeaderDs,
	valueField: 'headerrowid',
	displayField: 'headername',
	triggerAction: 'all',
	emptyText:'请选择课题负责人...',
	name: 'PrjHeaderField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
// ////////////科室////////////////////////
var CalDeptDs = new Ext.data.Store({
	    autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['deptrowid', 'deptname'])
		});

CalDeptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
		  url:itemGridUrl+'?action=GetDepts&str='+encodeURIComponent(Ext.getCmp('CalDeptField').getRawValue()),method:'POST'});
		});
var CalDeptField = new Ext.form.ComboBox({
	id: 'CalDeptField',
	fieldLabel: '科室',
	width:100,
	listWidth : 225,
	//allowBlank: false,
	store: CalDeptDs,
	valueField: 'deptrowid',
	displayField: 'deptname',
	triggerAction: 'all',
	emptyText:'请选择科室...',
	name: 'CalDeptField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
//
var PrjNameField = new Ext.form.TextField({
	id:'PrjName',
	fieldLabel: '课题名称',
	//allowBlank: false,
	width:150,
	listWidth : 150,
	emptyText:'请填写课题名称...',
	anchor: '90%',
	selectOnFocus:'true'
});
//定义起始时间控件
var PSField = new Ext.form.DateField({
	id : 'PSField',
	//format : 'Y-m-d',
	width : 120,
	//allowBlank : false,
	emptyText : ''
});
var PEField = new Ext.form.DateField({
	id : 'PEField',
	//format : 'Y-m-d',
	width : 120,
	emptyText : ''
	
});


/////////////////////ISBN号
var ISBNText = new Ext.form.TextField({
width :100,
selectOnFocus : true
});

/////作者
var userDs = new Ext.data.Store({
		proxy : "",
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['rowid', 'name'])
	});

userDs.on('beforeload', function(ds, o) {

		ds.proxy = new Ext.data.HttpProxy({
					url : itemGridUrl+'?action=userList',
					method : 'POST'
				});
	});

var userCombo = new Ext.form.ComboBox({
		fieldLabel : '作者 ',
		store : userDs,
		displayField : 'name',
		valueField : 'rowid',
		typeAhead : true,
		forceSelection : true,
		triggerAction : 'all',
		emptyText : '',
		width : 110,
		listWidth : 225,
		pageSize : 10,
		minChars : 1,
		selectOnFocus : true
	});
	

///////////////////审批结果
var MonTraStore = new Ext.data.SimpleStore({
		fields : ['key', 'keyValue'],
		data : [['1', '专著'], ['2', '译著']]
	});
var MonTraField = new Ext.form.ComboBox({
		fieldLabel : '著作类别',
		width : 100,
		listWidth : 80,
		selectOnFocus : true,
		allowBlank : false,
		store : MonTraStore,
		anchor : '90%',
		// value:'key', //默认值
		valueNotFoundText : '',
		displayField : 'keyValue',
		valueField : 'key',
		triggerAction : 'all',
		emptyText : '',
		mode : 'local', // 本地模式
		editable : false,
		pageSize : 10,
		minChars : 1,
		selectOnFocus : true,
		forceSelection : true
	});

function srmFundSearch(){
    var starttime= PSField.getValue();
    if (starttime!=="")
    {
       //starttime=starttime.format ('Y-m-d');
    }
    //alert(starttime);
    var endtime = PEField.getValue();
    if (endtime!=="")
    {
       //endtime=endtime.format ('Y-m-d');
    }
    //alert(endtime);
    var deptdr  = CalDeptField.getValue();
    var source = PrjSrcField.getValue(); 
    var headdr = PrjHeaderField.getValue();
    var name = PrjNameField.getValue();
  	itemGridDs.load({
	    params:{
	    start:0,
	    limit:25,
	    starttime:starttime,
	   // editor, isbn, montra, starttime, endtime
	    endtime:endtime,
	    deptdr:deptdr,
	    source:source,
	    headdr:headdr,
	    name:name,
	    user:session['LOGON.USERCODE']
	   }
  });
}


var queryPanel = new Ext.FormPanel({
		height:150,
		region:'north',
		frame:true,
		defaults: {bodyStyle:'padding:5px'},
			items:[{
			xtype: 'panel',
			layout:"column",
			items: [
				{   
					xtype:'displayfield',
					value:'<center><p style="font-weight:bold;font-size:150%">项目中检材料上报</p></center>',
					columnWidth:1,
					height:'50'
				}]
		    },{
		    columnWidth:1,
		    xtype: 'panel',
			layout:"column",
			items: [
				{
					xtype:'displayfield',
					value:'项目起止时间:',
					columnWidth:.14
				},
				PSField,
				{
					xtype:'displayfield',
					value:'',
					columnWidth:.01
				},
				{
					xtype:'displayfield',
					value:' 至',
					columnWidth:.03
				},
				PEField,
				{
					xtype:'displayfield',
					value:'',
					columnWidth:.1
				},{
					xtype:'displayfield',
					value:'科室:',
					columnWidth:.06
				},
				CalDeptField,
				{
					xtype:'displayfield',
					value:'',
					columnWidth:.1
				},{
					xtype:'displayfield',
					value:'课题来源:',
					columnWidth:.10
				},PrjSrcField
				]
		    },{
			xtype: 'panel',
			layout:"column",
			items: [
				
				{
					xtype:'displayfield',
					value:'课题负责人:',
					columnWidth:.09
				},
				PrjHeaderField,
				{
					xtype:'displayfield',
					value:'',
					columnWidth:.06
				},
				{
					xtype:'displayfield',
					value:'课题名称:',
					columnWidth:.07
				},
				PrjNameField,
				{
					xtype:'displayfield',
					value:'',
					columnWidth:.15
				},
				{
					columnWidth:0.05,
					xtype:'button',
					text: '查询',
					handler:function(b){
						srmFundSearch();
					
				
					},
					iconCls: 'option'
				}		
			]
		}
		]
	});
var itemGridCm = new Ext.grid.ColumnModel([

        {

            id:'rowid',
            header: 'ID',
            allowBlank: false,
            width:100,
            editable:false,
            hidden:true,
            dataIndex: 'rowid'
       }, {
            id:'Name',
            header: '课题名称',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Name'
       }, {
            id:'DeptDr',
            header: '科室ID',
            allowBlank: false,
            width:100,
            hidden:true,
            editable:false,
            dataIndex: 'DeptDr'
       }, {
            id:'DeptName',
            header: '科室名称',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'DeptName'
       }, {
            id:'Head',
            header: '负责人Dr',
            allowBlank: false,
            width:100,
            hidden:true,
            editable:false,
            dataIndex: 'Head'
       }, {
            id:'HeadName',
            header: '负责人',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'HeadName'
       }, {
            id:'Participants',
            header: '参加人员',
            allowBlank: false,
            width:200,
            editable:false,
            dataIndex: 'Participants'
       }, {
            id:'SubSource',
            header: '课题来源ID',
            allowBlank: false,
            hidden:true,
            width:100,
            editable:false,
            dataIndex: 'SubSource'
       }, {
            id:'SubSourceName',
            header: '课题来源',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'SubSourceName'
       }, {
            id:'SubNo',
            header: '课题编号',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'SubNo'
       }, {
            id:'AppFunds',
            header: '申请经费',
            allowBlank: false,
            width:100,
            align:'right',
            xtype:'numbercolumn',
            editable:false,
            dataIndex: 'AppFunds'
       }, {
            id:'GraFunds',
            header: '批准经费',
            xtype:'numbercolumn',
            allowBlank: false,
            align:'right',
            width:100,
            editable:false,
            dataIndex: 'GraFunds'
       }, {
            id:'StartDate',
            header: '课题起始时间',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'StartDate'
       }, {
            id:'EndDate',
            header: '课题终止时间',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'EndDate'
       }, {
            id:'ConDate',
            header: '课题结题时间',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'ConDate'
       }, {
            id:'RelyUnit',
            header: '依托单位',
            allowBlank: false,
            width:200,
            editable:false,
            dataIndex: 'RelyUnit'
       }, {
            id:'SubUser',
            header: '申请人ID',
            allowBlank: false,
            hidden:true,
            width:100,
            editable:false,
            dataIndex: 'SubUser'
       }, {
            id:'SubUserName',
            header: '申请人',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'SubUserName'
       }, {
            id:'SubDate',
            header: '申请日期',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'SubDate'
       }, {
            id:'DataStatus',
            header: '数据状态',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'DataStatus'
       }, {
            id:'ResAudit',
            header: '科研科审核状态',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'ResAudit'
       }, {
            id:'ResDesc',
            header: '审核意见',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'ResDesc'
       }, {
            id:'AuditUser',
            header: '审核人ID',
            allowBlank: false,
            hidden:true,
            width:100,
            editable:false,
            dataIndex: 'AuditUser'
       }, {
            id:'AuditUserName',
            header: '审核人',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'AuditUserName'
       }, {
            id:'AuditDate',
            header: '审核时间',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'AuditDate'
       }, {
            id:'ProjStatus',
            header: '项目状态',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'ProjStatus'
       }, {
            id:'Remark',
            header: '备注',
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'Remark'
       }, {
            id:'SysNo',
            header: '系统模块号ID',
            allowBlank: false,
            width:100,
            hidden:true,
            editable:false,
            dataIndex: 'SysNo'
       }, {
            id:'SysNoCode',
            header: '系统模块号',
            hidden:true,
            allowBlank: false,
            width:100,
            editable:false,
            dataIndex: 'SysNoCode'
       }
			    
]);

var addButton = new Ext.Toolbar.Button({
					text : '添加',
					tooltip : '添加',
					iconCls : 'add',
					handler : function() {
						srmmonographAddFun();
					}
				});

var editButton = new Ext.Toolbar.Button({
					text : '修改',
					tooltip : '修改',
					iconCls : 'option',
					handler : function() {
						srmMonographEditFun();
					}
				});
var submitButton = new Ext.Toolbar.Button({
	text : '提交',
	tooltip : '提交',
	iconCls : 'option',
	handler : function() {
		srmMonographSubmitFun();
	}
});
var delButton = new Ext.Toolbar.Button({
			text : '删除',
			tooltip : '删除',
			iconCls : 'remove',
			handler : function() {
				var rowObj = itemGrid.getSelectionModel().getSelections();
				 if(rowObj[0].get("DataStatus")=="提交")
				 {
					      Ext.Msg.show({title:'注意',msg:'已提交记录无法删除！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					       return;
				 }
				var len = rowObj.length;
				var tmpRowid = "";
		
				if (len < 1) {
					Ext.Msg.show({
								title : '注意',
								msg : '请选择需要删除的数据!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.WARNING
							});
					return;
				} else {
					tmpRowid = rowObj[0].get("rowid");
					Ext.MessageBox.confirm('提示', '确定要删除选定的行?', function(btn) {
						if (btn == 'yes') {
							Ext.Ajax.request({
								url : itemGridUrl + '?action=del&rowid=' + tmpRowid,
								waitMsg : '删除中...',
								failure : function(result, request) {
									Ext.Msg.show({
												title : '错误',
												msg : '请检查网络连接!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								},
								success : function(result, request) {
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if (jsonData.success == 'true') {
										Ext.Msg.show({
													title : '注意',
													msg : '操作成功!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.INFO
												});
										itemGridDs.load({
													params : {
														start : 0,
														limit : itemGridPagingToolbar.pageSize
													}
												});
									} else {
										Ext.Msg.show({
													title : '错误',
													msg : '错误',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
									}
								},
								scope : this
							});
						}
					});
				}
			}
});

var itemGrid = new Ext.grid.GridPanel({
			//title: '专著成果申请',
		    region: 'center',
		    layout:'fit',
		    width:400,
		    readerModel:'local',
		    url: 'herp.srm.horizonprjmidcheckexe.csp',
		    atLoad : true, // 是否自动刷新
			store: itemGridDs,
			cm: itemGridCm,
			trackMouseOver: true,
			stripeRows: true,
			sm: new Ext.grid.RowSelectionModel({singleSelect:true}),
			loadMask: true,
			//tbar:[addButton,'-',editButton,'-',delButton,'-',submitButton],
			bbar:itemGridPagingToolbar
});


  itemGridDs.load({	
			params:{start:0, limit:itemGridPagingToolbar.pageSize,user:session['LOGON.USERCODE']},
		    callback:function(record,options,success ){
			itemGrid.fireEvent('rowclick',this,0);
			}
});
  var srmdeptuserDs=function(){	
		var type=Ext.getCmp('uTypeGridField').value;
		if (type==undefined){type="";}
	    itemGridDs.proxy = new Ext.data.HttpProxy({
	    	
								url : 'herp.srm.horizonprjmidcheckexe.csp?action=list&code='+ encodeURIComponent(uCodeField.getValue())+ 
								'&name='+encodeURIComponent(Ext.getCmp('uNameField').getRawValue())+
								'&type='+ encodeURIComponent(type),
								
								method : 'GET'
								//'&type='+ userTypeField.getValue()
							});
					itemGridDs.load({
								params : {
									start : 0,
									limit : itemGridPagingToolbar.pageSize
								}
							});
	};
	/**
	 * 此处应设计成用户只能提交自己的作品*/
	srmMonographSubmitFun=function(){

	//定义并初始化行对象
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	 for(var j= 0; j < len; j++){
		 if(rowObj[j].get("DataStatus")=="提交")
		 {
			      Ext.Msg.show({title:'注意',msg:'已提交记录无法再次提交！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
//		此段代码用于判断用户只能提交自己的代码
//		 if(rowObj[j].get("EditorName")!=session['LOGON.USERNAME'])
//		 {
//			      Ext.Msg.show({title:'注意',msg:'用户只能提交自己的著作！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
//			       return;
//		 }
		}

	
    
	function handler(id){
		if(id=="yes"){
			
			for(var i = 0; i < len; i++){
				    Ext.Ajax.request({
					url:'herp.srm.horizonprjmidcheckexe.csp?action=monographAsk&&rowid='+rowObj[i].get("rowid")+'&sysno='+rowObj[i].get("SysNo")+'&editor='+rowObj[i].get("EditorDr")+'&deptdr='+rowObj[i].get("DeptDr"),
					waitMsg:'审核中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},

					success: function(result, request){					
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){
							Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
							itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});	
							
						}else{
							var message='审核失败!';
							if(jsonData.info=="RepName") message="名称重复";
							Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						}
					},
					scope: this
				});
			}
		}else{
			return;
		}
	}
	Ext.MessageBox.confirm('提示','确实要提交所选记录吗?',handler);

	}
