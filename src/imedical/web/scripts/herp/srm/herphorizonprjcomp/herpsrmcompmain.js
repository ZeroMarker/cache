var PrjCompletionUrl= 'herp.srm.horizonprjcompletionexe.csp';


///课题来源
var PrjSrcDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['prjtyperowid','prjtypename'])
});
PrjSrcDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:PrjCompletionUrl+'?action=GetPrjType&str='+encodeURIComponent(Ext.getCmp('PrjSrcField').getRawValue()),method:'POST'});
});
var PrjSrcField = new Ext.form.ComboBox({
	id: 'PrjSrcField',
	fieldLabel: '课题来源',
	width:150,
	listWidth :225,
	allowBlank: false,
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
	url:PrjCompletionUrl+'?action=GetPrjHeader&str='+encodeURIComponent(Ext.getCmp('PrjHeaderField').getRawValue()),method:'POST'});
});
var PrjHeaderField = new Ext.form.ComboBox({
	id: 'PrjHeaderField',
	fieldLabel: '课题负责人',
	width:150,
	listWidth :225,
	allowBlank: false,
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
		  url:PrjCompletionUrl+'?action=GetDepts&str='+encodeURIComponent(Ext.getCmp('CalDeptField').getRawValue()),method:'POST'});
		});
var CalDeptField = new Ext.form.ComboBox({
	id: 'CalDeptField',
	fieldLabel: '科室',
	width:100,
	listWidth : 225,
	allowBlank: false,
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
///开始日期
var StartDateField = new Ext.form.DateField({
			id:'startdate',
			//format:'Y-m-d',
			fieldLabel:'开始日期',
			width:150,
			//disabled:false,
			editable:true,
			emptyText: '请选择开始日期...'
		});
		
var EndDateField = new Ext.form.DateField({
			id:'enddate',
			//format:'Y-m-d',
			fieldLabel:'结束日期',
			width:150,
			//disabled:false,
			editable:true,
			emptyText: '请选择结束日期...'
		});
		
var PrjNameField = new Ext.form.TextField({
			id:'PrjName',
			fieldLabel: '课题名称',
			allowBlank: false,
			width:150,
			listWidth : 150,
			//emptyText:'请填写课题名称...',
			anchor: '90%'
			//selectOnFocus:'true'
		});
		
		
///查询按钮		itemGrid.load(({params:{start:0, limit:25,Year:Year,Name:Name,DeptNM:DeptNM,Code:Code}}));
var QueryButton = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls:'find',
			
			handler : function() {
			var prjstartdate= StartDateField.getRawValue();
      var prjenddate= EndDateField.getRawValue();
			var deptname= CalDeptField.getValue();
			var prjsrc=PrjSrcField.getValue();
			var prjheader=PrjHeaderField.getValue();
			var prjname=PrjNameField.getValue();

		
			PrjCompletionGrid.load(({params:{PrjStDate:prjstartdate,PrjEndDate:prjenddate,SrmDeptDR:deptname,PrjTypeDR:prjsrc,PrjHeadDR:prjheader,PrjName:prjname,start:0,limit:25}}));
			}
		})
	///结题按钮	
var CheckButton = new Ext.Toolbar.Button({
	text: '结题',
	tooltip: '项目结题',
	iconCls: 'add',
	handler: function(){
		//定义并初始化行对象
		var rowObj=PrjCompletionGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		//判断是否选择了要修改的数据
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要结题的项目记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}else{
			checkfun=function(id){
				if(id=="yes")
				{
					for(var i=0;i<len;i++){
						var rowid = rowObj[i].get("rowid");
						
						Ext.Ajax.request({
							url:PrjCompletionUrl+'?action=Check&RowID='+rowid,
							waitMsg:'结算中...',
							failure: function(result, request){
									Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request){
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true'){
									Ext.Msg.show({title:'注意',msg:'已结题!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								}else{
									Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
								PrjCompletionGrid.load("","","","","","",0,25);
							}//,scope: this						
						});
					}
				}
				else{return;}
			};
			Ext.MessageBox.confirm('提示','确定对选中的项目记录结题吗？',checkfun);
		}				
	}
});


///查询条件Panel
var PrjCompletionPanel = new Ext.FormPanel({
	height : 150,
	region : 'north',
	frame : true,
	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [{
		xtype : 'panel',
		layout : "column",
		items : [{
			xtype : 'displayfield',
			value : '<center><p style="font-weight:bold;font-size:150%">项目结题</p></center>',
			columnWidth : 1,
			height : '50'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [
		    {
					xtype : 'displayfield',
					value : '项目起止时间:',
					columnWidth : 0.15
				}, StartDateField,
				{	xtype:'displayfield',
					value:'',
					columnWidth:0.01
				},
				{
					xtype : 'displayfield',
					value : ' 至 ',
					columnWidth : 0.03
				}, EndDateField,{
					xtype : 'displayfield',
					value : '',
					columnWidth : 0.08
				},{
					xtype : 'displayfield',
					value : '科室:',
					columnWidth : 0.07
				}, CalDeptField, {
					xtype : 'displayfield',
					value : '',
					columnWidth : 0.08
				}, {
					xtype : 'displayfield',
					value : '课题来源:',
					columnWidth : 0.12
				},PrjSrcField
			]
	},
	{
		xtype: 'panel',
		layout:"column",
		items: [
				{
					xtype : 'displayfield',
					value : '课题负责人:',
					columnWidth : .11
				}, PrjHeaderField, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .06
				},{
					xtype : 'displayfield',
					value : '课题名称:',
					columnWidth : .09
				}, PrjNameField, {
					xtype : 'displayfield',
					value : '',
					columnWidth : .08
				},QueryButton,{
					xtype : 'displayfield',
					value : '',
					columnWidth : .07
				},CheckButton
				]
		}	
	]	
	});
	

///PrjCompletionGrid
///rowid^deptname^prjname^prjheader^prjparticipant^prjsource^prjrelyunit^prjapplyfund^prjgrafund^prjno^prjauditdate^prjstartdate^prjenddate^prjremark
var PrjCompletionGrid = new dhc.herp.Grid({
    //title: '项目结题',
    //width:400,
    // edit:false, //是否可编辑
    //readerModel:'local',
    region: 'center',
    xtype:'grid',
    atLoad : true, // 是否自动刷新
   // autoScroll : true,
    loadMask: true,
    url: PrjCompletionUrl,
    fields: [
    new Ext.grid.CheckboxSelectionModel({editable:false}),
    {
        id:'rowid',
        header: 'ID',
        hidden: true,
        dataIndex: 'rowid'
        
    },{
        id:'deptname',
        header: '科室',
        dataIndex: 'deptname',
        width:100,
        update:true,
		    editable:false,
		    hidden: false
    },{ 
        id:'prjname',
        header: '课题名称',
        dataIndex: 'prjname',
        width:100,
        update:true,
		    editable:false,
		    hidden: false
    }, {
        id:'prjheader',
        header: '项目负责人',
		    width:100,
		    editable:false,
        dataIndex: 'prjheader'
    }, {
        id:'prjparticipant',
        header: '课题参加人员',
        width:150,
        editable:true,
        dataIndex: 'prjparticipant',
        allowBlank: true,
        hidden: false
    }, {
        id:'prjsource',
        header: '课题来源',
        width:120,
		    allowBlank: true,
		    editable:false,
        dataIndex: 'prjsource',
        hidden: false
    }, {
        id:'prjrelyunit',
        header: '课题依托单位',
        width:180,
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjrelyunit',
        hidden: false
    },{
        id:'prjapplyfund',
        header: '申请经费（万元）',
        width:120,
        align:'right',
        xtype:'numbercolumn',
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjapplyfund',
        hidden: false
    },{
        id:'prjgrafund',
        header: '批准经费（万元）',
        width:120,
        align:'right',
        xtype:'numbercolumn',
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjgrafund',
        hidden: false
    },{
        id:'prjno',
        header: '课题编号',
        width:100,
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjno',
        hidden: false
    },{
        id:'prjauditdate',
        header: '批件下达时间',
        width:100,
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjauditdate',
        hidden: false
    },{
        id:'prjstartdate',
        header: '开始时间',
        width:100,
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjstartdate',
        hidden: false
    },{
        id:'prjenddate',
        header: '截止时间',
        width:100,
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjenddate',
        hidden: false
    },{
        id:'prjremark',
        header: '备注',
        width:100,
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjremark',
        hidden: false
    },{
        id:'prjcompreport',
        header: '结题报告',
        width:500,
		    // tip:true,
		    allowBlank: true,
		    editable:false,
		    update:true,
        dataIndex: 'prjcompreport',
        renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 					
							return '<span style="color:purple;cursor:hand;backgroundColor:red"><u>'+value+'</u></span>';
						},
        hidden: false
    }
	]
//, viewConfig : {forceFit : true}
});
/**
//单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	 
	var records = itemGrid.getSelectionModel().getSelections();
	var detailID = records[0].get("rowid")
	
	// 维护数据
	if(detailID!=""){
	if (columnIndex == 7) {
//		var records = itemGrid.getSelectionModel().getSelections();
//		var detailID = records[0].get("rowid")

		// 维护数据页面
		DetailFun(detailID);
	}
}
})
**/
PrjCompletionGrid.btnAddHide();  //隐藏增加按钮
PrjCompletionGrid.btnSaveHide();  //隐藏保存按钮
PrjCompletionGrid.btnResetHide();  //隐藏重置按钮
PrjCompletionGrid.btnDeleteHide(); //隐藏删除按钮
PrjCompletionGrid.btnPrintHide();  //隐藏打印按钮


PrjCompletionGrid.on('cellclick', function(g, rowIndex, columnIndex, e){
	  
	    if (columnIndex == 16) {
			var records = PrjCompletionGrid.getSelectionModel().getSelections();
			var PrjInfoRowID   = records[0].get("rowid");
			alert(PrjInfoRowID)
	}
});
