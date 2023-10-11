var userdr = session['LOGON.USERID']; 
//开始时间控件
var startTime = new Ext.form.DateField({
		id : 'startTime',
		format : 'Y-m-d',
		width : 120,
		emptyText : ''
	});
	//结束时间控件
var endTime = new Ext.form.DateField({
		id : 'endTime',
		format : 'Y-m-d',
		width : 120,
		emptyText : ''
	});
//获取科室名称
	var deptnameDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});
    deptnameDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
		url:'herp.srm.srmprojectsinfoexe.csp'+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('deptnameField').getRawValue()),method:'POST'});
	});
var deptnameField = new Ext.form.ComboBox({
		id: 'deptnameField',
		fieldLabel: '科室',
		width:100,
		listWidth : 100,
		store: deptnameDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择科室...',
		name: 'deptnameField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
/////////////课题来源
var sourceDs= new Ext.data.Store({
	proxy:'',
	reader: new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	},['rowid','Name'])
});
sourceDs.on('beforeload',function(ds,o){
	ds.proxy= new Ext.data.HttpProxy({
		url:'herp.srm.srmprojectsinfoexe.csp'+'?action=sourceList&str='+encodeURIComponent(Ext.getCmp('sourceField').getRawValue()),
		method:'POST'
	});
});
var sourceField = new Ext.form.ComboBox({
		id: 'sourceField',
		fieldLabel: '课题来源',
		width:200,
		listWidth : 200,
		store: sourceDs,
		valueField: 'rowid',
		displayField: 'Name',
		triggerAction: 'all',
		emptyText:'请选择课题来源...',
		name: 'sourceField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
var projStatus= new Ext.data.SimpleStore({
	fields : ['key', 'keyValue'],
	data : [ ['1', '申请'],['2','执行']]
});
var projStatusField = new Ext.form.ComboBox({
				fieldLabel : '项目状态',
				width : 120,
				listWidth : 120,
				selectOnFocus : true,
				allowBlank : false,
				store : projStatus,
				anchor : '90%',
				value:'1', //默认值
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
/////////////课题负责人
var headerDs= new Ext.data.Store({
	proxy:'',
	reader: new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	},['rowid','name'])
});
headerDs.on('beforeload',function(ds,o){
	ds.proxy= new Ext.data.HttpProxy({
		url:'herp.srm.srmprojectsinfoexe.csp'+'?action=applyerList&str='+encodeURIComponent(Ext.getCmp('headerField').getRawValue()),
		method:'POST'
	});
});
var headerField = new Ext.form.ComboBox({
		id: 'headerField',
		fieldLabel: '课题负责人',
		width:120,
		listWidth : 120,
		store: headerDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'请选择课题负责人...',
		name: 'headerField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
// ///////////////////课题名称
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});	
function srmFundApply(){
	
		var startdate= startTime.getValue();

	    if (startdate!=="")
	    {
	       startdate=startdate.format ('Y-m-d');
	    }
	    
		var enddate=endTime.getValue();
		if(enddate!=="")
			{
			enddate=enddate.format('Y-m-d');
			}
		var deptDr= deptnameField.getValue();
	    var sourceDr= sourceField.getValue();
		var projStatus =projStatusField.getValue();
		var header= headerField.getValue();
	    var name = titleText.getValue(); 
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,  
			sortField:'', 
			sortDir:'' ,
		    startDate:startdate,
		    endDate:enddate,
		    deptDr:deptDr,
		    source:sourceDr,
			projStatus:projStatus,
			header:header,
		    name:name
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
						value:'<center><p style="font-weight:bold;font-size:150%">项目立项</p></center>',
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
						value:'申请时间:',
						columnWidth:.12
					},
					startTime,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.06
					},{
						xtype:'displayfield',
						value:'至:',
						columnWidth:.08
					},
					endTime,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.1
					},{
						xtype:'displayfield',
						value:'科室:',
						columnWidth:.1
					},
					deptnameField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.1
					},
					{
						xtype:'displayfield',
						value:'课题来源:',
						columnWidth:.1
					},
					sourceField
					]
			    },{
				xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'项目状态:',
						columnWidth:.092
					},
					projStatusField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.04
					},
					{
						xtype:'displayfield',
						value:'课题负责人:',
						columnWidth:.1
					},
					headerField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.04
					},
					{
						xtype:'displayfield',
						value:'课题名称:',
						columnWidth:.08
					},
					titleText,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.04
					},
					{
						columnWidth:0.05,
						xtype:'button',
						text: '查询',
						handler:function(b){
							srmFundApply();
						},
						iconCls: 'add'
					}		
				]
			}
			]
		});
		//定义批准经费只能输入数字
var grafundsField = new Ext.form.NumberField({
	id: 'grafundsField',
	fieldLabel: '批准金额',
	width:90,
	allowBlank: false,
	emptyText:'',
	name: 'grafundsField',
	editable:true
});

var itemGrid = new dhc.herp.Grid({
		    region : 'center',
		    url: 'herp.srm.srmprojectsinfoexe.csp',
		    atLoad : true, // 是否自动刷新
		   
			fields : [
			      new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
						header : '课题ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'deptname',
						header : '科室',
						editable:false,
						align:'center',
						width : 80,
						dataIndex : 'deptname'
					},{
						id : 'pname',
						header : '课题名称',
						width : 120,
						align:'center',
						editable:false,
						dataIndex : 'pname'

					},{
						id : 'headname',
						header : '课题负责人',
						editable:false,
						align:'center',
						width : 120,
						dataIndex : 'headname'

					}, {
						id : 'sex',
						header : '性别',
						editable:false,
						align:'center',
						width : 50,
						dataIndex : 'sex'
					},{
						id : 'birth',
						header : '出生年月',
						width : 80,
						editable:false,
						align:'center',
						dataIndex : 'birth'
					}, {
						id : 'tname',
						header : '技术职称',
						width : 100,
						align:'center',
						editable : false,
						dataIndex : 'tname'
						
					},{
						id : 'phone',
						header : '联系电话',
						width : 90,
						align:'center',
						editable:false,
						dataIndex : 'phone'

					},{
						id : 'email',
						header : '邮箱地址',
						width : 120,
						editable:false,
						align:'center',
						dataIndex : 'email'

					},{
						id : 'participants',
						header : '参加人员',
						width : 150,
						editable:false,
						align:'center',
						dataIndex : 'participants'
					},{
						id : 'source',
						header : '课题来源',
						width : 120,
						editable:false,
						align:'center',
						dataIndex : 'source'
					},{
						id : 'relyunit',
						header : '课题依托单位',
						width : 150,
						editable:false,
						align:'center',
						dataIndex : 'relyunit'

					},{
						id : 'appfunds',
						header : '申请经费(万元)',
						width : 90,
						editable:false,
						align:'center',
						dataIndex : 'appfunds'
					},{
						id : 'grafunds',
						header : '批准经费(万元)',
						width : 90,
						//editable:true,
						allowBlank:false,
						align:'center',
						dataIndex : 'grafunds',
						type:grafundsField,//引用定义的数值文本框
					   renderer: function(value, cellmeta, record, rowIndex,
								columnIndex, store){
								 if(record.data["projstatus"]!='申请'){
								 this.editable=false;
								 return '<span>'+value+'</span>';
								 }else{
								 this.editable=true;
								 return '<span>'+value+'</span>';
								 }
								}
					},{
						id : 'subno',
						header : '课题编号',
						width : 100,
						//editable:true,
						allowBlank:false,
						align:'center',
						dataIndex : 'subno',
						renderer: function(value, cellmeta, record, rowIndex,
								columnIndex, store){
								 if(record.data["projstatus"]!='申请'){
								 
								 this.editable=false;
								 //console.log(this.editable+"<-edit"+this.value+"<-value");
								 return '<span>'+value+'</span>';
								 }else{
								 this.editable=true;
								 return '<span>'+value+'</span>';
								 }
								}
					}
					,{
						id : 'issuedDate',
						header : '批件下达时间',
						width : 100,
						//editable:true,
						allowBlank:false,
						align:'center',
						emptyText : '',
						dataIndex : 'issuedDate',
						type: "dateField",
						dateFormat: 'Y-m-d',
						renderer: function(value, cellmeta, record, rowIndex,
								columnIndex, store){
								 if(record.data["projstatus"]!='申请'){
								 this.editable=false;
								 return '<span>'+value+'</span>';
								 }else{
								 this.editable=true;
								 return '<span>'+value+'</span>';
								 }
								}
					},{
						id : 'subDate',
						header : '申请时间',
						width : 100,
						editable:false,
						align:'center',
						dataIndex : 'subDate'
					},
					{
						id : 'startDate',
						header : '开始时间',
						width : 100,
						editable:false,
						align:'center',
						dataIndex : 'startDate'
					}
					,{
						id : 'endDate',
						header : '截止时间',
						width : 100,
						editable:false,
						align:'center',
						dataIndex : 'endDate'
					},{
						id : 'remark',
						header : '备注',
						width : 100,
						editable:false,
						align:'center',
						dataIndex : 'remark'
					},{
						id : 'projstatus',
						header : '项目状态',
						width : 100,
						editable:false,
						align:'center',
						dataIndex : 'projstatus'
					}]					
		});
		itemGrid.btnResetHide(); 	//隐藏重置按钮
        itemGrid.btnDeleteHide(); //隐藏删除按钮
        itemGrid.btnPrintHide(); 	//隐藏打印按钮
        itemGrid.btnAddHide(); 	//隐藏重置按钮
        itemGrid.btnSaveHide(); 	//隐藏重置按钮

var setup = new Ext.Toolbar.Button({
	    text: '立项',  
        iconCls:'option',
        handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要立项的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("projstatus")=="执行")
		 {
			      Ext.Msg.show({title:'注意',msg:rowObj[j].get("pname")+'已立项',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		//没有复选框的情况下 可以不用for循环
		for(var i= 0; i < len; i++){
		   var rowid=rowObj[i].get("rowid");
		   var subno=rowObj[i].get("subno");
		   var issuedDate=rowObj[i].get("issuedDate");
		   if (issuedDate!=""&&issuedDate!=null){
				issuedDate=issuedDate.format('Y-m-d');
			}
		   var grafunds=rowObj[i].get("grafunds");
		    if(subno==""||subno==null||issuedDate==""||issuedDate==null||grafunds==""||grafunds==null){
				Ext.Msg.show({title:'错误',msg:'课题编号、批准经费、批件下达时间必须填写!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			    return;
		    }
		   /* if(isNaN(grafunds)){
		     Ext.Msg.show({title:'错误',msg:'批准经费只能填数字',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		     return;
		    }*/
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    var rowid=rowObj[i].get("rowid");
						var subno=rowObj[i].get("subno");
						var issuedDate=rowObj[i].get("issuedDate");
					    if (issuedDate!=""&&issuedDate!=null){
							issuedDate=issuedDate.format('Y-m-d');
						}
						var grafunds=rowObj[i].get("grafunds");
					    Ext.Ajax.request({
						url:'herp.srm.srmprojectsinfoexe.csp?action=setup&rowid='+rowid+'&subno='+subno+'&issuedDate='+issuedDate+'&grafunds='+grafunds,
						waitMsg:'提交中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'提交成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});	
								itemGrid.load({params:{start:0, limit:12}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'提交失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要立项吗?',handler);
    }
});
var refuse = new Ext.Toolbar.Button({
	    text: '不通过',  
        iconCls:'option',
        handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择不通过的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("projstatus")=="执行")
		 {
			      Ext.Msg.show({title:'注意',msg:rowObj[j].get("pname")+'已通过立项',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    var rowid=rowObj[i].get("rowid");
					    Ext.Ajax.request({
						url:'herp.srm.srmprojectsinfoexe.csp?action=refuse&rowid='+rowid,
						waitMsg:'提交中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'提交成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:12}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:'提交失败!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确认不通过吗?',handler);
    }
});
		itemGrid.addButton(setup);
		itemGrid.addButton(refuse);