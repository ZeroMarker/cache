var userdr = session['LOGON.USERID'];   
 
var projUrl = 'herp.srm.auditcheckprojectsinfoexe.csp';

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
		           //anchor : '95%',			
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
// 定义起始时间控件
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
		//allowBlank : false,
		emptyText : ''
	});
	
////////////////科室名称
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});	
		
deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList'+'&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()), 
                        method:'POST'
					});
		});
		
var deptCombo = new Ext.form.ComboBox({
            id:'deptCombo',
			fieldLabel : '科室名称',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

 /////////////////课题来源
var SubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});
		
SubSourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=sourceList'+'&str='+encodeURIComponent(Ext.getCmp('SubSourceCombo').getRawValue()),  
                        method:'POST'
					});
		});

var SubSourceCombo = new Ext.form.ComboBox({
            id:'SubSourceCombo',
			fieldLabel : '课题来源',
			store : SubSourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

/////////////科研审批结果
var ChkResultStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['0', '等待审批'], ['1', '通过'], ['2', '不通过']]
		});
var ChkResultField = new Ext.form.ComboBox({
			fieldLabel : '科研审批结果',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : false,
			store : ChkResultStore,
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

//////课题负责人
var userDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=applyerList'+'&str='+encodeURIComponent(Ext.getCmp('userCombo').getRawValue()), 
						method : 'POST'
					});
		});

var userCombo = new Ext.form.ComboBox({
            id:'userCombo',
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 225,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
// ////////////课题名称
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});
		

/////////////////// 查询按钮 
/////////////////// 查询按钮 
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'find',
	handler: function(){
		var startdate= PSField.getValue();
	    if (startdate!=="")
	    {
	       //startdate=startdate.format ('Y-m-d');
	    }
	    var enddate= PEField.getValue();
	    if (enddate!=="")
	    {
	       //enddate=enddate.format ('Y-m-d');
	    }
	    var dept  = deptCombo.getValue();
	    var SubSource= SubSourceCombo.getValue();
	    //var ResAudit  = ChkResultField.getValue();
	    var ResAudit  = "";
	    var HeadDr= userCombo.getValue();
	    var PName = titleText.getValue();     
		var Type = TypeCombox.getValue();
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,   
		    ApplyStart: startdate,
		    Applyend: enddate,
		    deptdr: dept,
		    SubSource: SubSource,
		    ResAudit: ResAudit,
		    HeadDr: HeadDr,
		    PName: PName,
			Type:Type
		   }
	  });
  }
});
var AuditButton  = new Ext.Toolbar.Button({
		text: '通过',  
        iconCls:'option',
        handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		var checker = session['LOGON.USERID'];
		//alert(checker);
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("ProjStatus")=="结题" && (rowObj[j].get("ChkResult")=="1"||rowObj[j].get("ChkResult")=="2"))
		 {
			      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:'herp.srm.srmhorizontalprjcheckapplyexe.csp?action=audit&&rowid='+rowObj[i].get("rowid")+'&checker='+checker,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'审核成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:12,userdr:userdr}});
								
							}else{
								Ext.Msg.show({title:'错误',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}
			}else{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确实要审核该条记录吗?',handler);
    }
});
  var NoAuditButton = new Ext.Toolbar.Button({
					text : '不通过',
					iconCls : 'option',
					handler : function() {
						var rowObj=itemGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						for(var j= 0; j < len; j++){
							 if(rowObj[j].get("ProjStatus")=="结题" && (rowObj[j].get("ChkResult")=="1"||rowObj[j].get("ChkResult")=="2"))
							 {
								      Ext.Msg.show({title:'注意',msg:'数据已审核',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }
						}
						noauditfun();
				   }
  });
var tbuttonbar = new Ext.Toolbar({   
        items: ['课题名称:',titleText,'-',findButton,AuditButton,NoAuditButton]   
    });   

var itemGrid = new dhc.herp.Gridhss({
		    title: '纵向课题验收审核',
		    region : 'center',
		    viewConfig : {forceFit : false},
		    autoScroll:true,
		    url: 'herp.srm.auditprojectscheckinfoexe.csp',
		    atLoad : true, // 是否自动刷新
			fields : [
			      //new Ext.grid.CheckboxSelectionModel({editable:false}),
			      {
						header : '课题ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'Type',
						header : '类型',
						width : 80,
						editable:false,
						dataIndex : 'Type'

					},{
						id : 'YearCode',
						header : '年度',
						width : 80,
						editable:false,
						dataIndex : 'YearCode'

					},{
						id : 'Dept',
						header : '科室',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'Dept'

					},{
						id : 'Name',
						header : '课题名称',
						editable:false,
						width : 180,
						align: 'left',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						},
						dataIndex : 'Name'
					},{
						id : 'Head',
						header : '项目负责人',
						editable:false,
						width : 120,
						hidden:true,
//						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
//						           return '<span style="color:blue;cursor:hand">'+value+'</span>';
//						},
						dataIndex : 'Head'

					},
					{
						id : 'CompleteUnit',
						header : '我院单位位次',
						editable:false,
						width : 120,
						hidden:true,
						dataIndex : 'CompleteUnit'
					}, {
						id : 'ParticipantsName',
						header : '课题参与人员',
						width : 130,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['rowid']
						if (sf != "") {
							return '<span style="color:blue;cursor:hand"><u>课题参与人员</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand"></span>';
						}},
						dataIndex : 'ParticipantsName'
					},
					 {
						id : 'Participants',
						header : '课题参加人员',
						width : 180,
						editable:false,
						hidden:true,
//						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
//						           return '<span style="color:blue;cursor:hand">'+value+'</span>';
//						},
						dataIndex : 'Participants'

					},{
						id : 'PTName',
						header : '课题来源',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'PTName'

					},{
						id : 'Department',
						header : '立项部门',
						width : 120,
						editable:false,
						dataIndex : 'Department'

					},
//					{
//						id : 'ConDate',
//						header : '结题时间',
//						width : 120,
//						//editable:false,
//						dataIndex : 'ConDate'
//
//					},
                    {
						id : 'SubNo',
						header : '课题编号',
						width : 120,
						editable:false,
						dataIndex : 'SubNo'

					},{
						id : 'RelyUnit',
						header : '课题依托单位',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'RelyUnit'

					},{
						id : 'PrjCN',
						header : '合同号',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'PrjCN'

					},{
						id : 'SEndDate',
						header : '起止年月',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'SEndDate'

					},{
						id : 'IsGovBuy',
						header : '是否政府项目',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'IsGovBuy'

					},{
						id : 'AppFund',
						header : '申请经费（万元）',
						width : 120,
						editable:false,
						dataIndex : 'AppFund'

					},{
						id : 'GraFund',
						header : '批准经费（万元）',
						width : 120,
						editable:false,
						align:'right',
						dataIndex : 'GraFund'

					},{
						id : 'FundGov',
						header : '上级拨款（万元）',
						width : 120,
						align:'right',
						editable:false,
						dataIndex : 'FundGov'

					},{
						id : 'FundOwn',
						header : '医院匹配（万元）',
						width : 120,
						editable:false,
						align:'right',
						dataIndex : 'FundOwn'

					},{
						id : 'FundMatched',
						header : '已匹配（万元）',
						width :120,
						editable:false,
						align:'right',
						dataIndex : 'FundMatched'
					},{
						id : 'IsEthicalApproval',
						header : '是否伦理审批',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'IsEthicalApproval'
					},{
						id : 'SubUser',
						header : '申请人',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'SubUser'

					},{
						id : 'SubDate',
						header : '申请时间',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'SubDate'

					},{
						id : 'ProjStatus',
						header : '项目状态',
						width : 120,
						editable: false,
						hidden:true,
						dataIndex : 'ProjStatus'
					},{
						id : 'DataStatuslist',
						header : '状态',
						width : 120,
						editable: false,
						hidden:true,
						dataIndex : 'DataStatuslist'
					},{
						id : 'ChkResult',
						header : '审核结果',
						editable:false,
						width : 120,			
						hidden:true,
						dataIndex : 'ChkResult'
					},{
						id : 'ChkResultlist',
						header : '科研处审核状态',
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['ChkResult']
						if (sf == "0") {return '<span style="color:blue;cursor:hand">'+value+'</span>';} 
						if (sf == "1") {return '<span style="color:red;cursor:hand">'+value+'</span>';} 
						if (sf == "2"){return '<span style="color:gray;cursor:hand">'+value+'</span>';}
						},
						width : 120,
						dataIndex : 'ChkResultlist'
					},{
						id : 'Desc',
						header : '科研处审批意见',
						width : 120,
						editable:false,
						dataIndex : 'Desc'
					},{
						id : 'HeadDr',
						header : '负责人ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'HeadDr'
					},{
						id : 'ParticipantsIDs',
						header : '参加人员ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'ParticipantsIDs'
					},{
						id : 'RelyUnitIDs',
						header : '参加人员ID',
						width : 60,
						editable:false,
						hidden: true,
						dataIndex : 'RelyUnitIDs'
					},{
							id:'download',
							header: '下载',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
						

					} }],
					split : true,
					collapsible : true,
					//containerScroll : true,
					xtype : 'grid',
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					loadMask : true,
					//viewConfig : {forceFit : true},
					tbar :['类型:',TypeCombox,'-','开始时间:', PSField,'-','结束时间:',PEField,'-','科室名称:', deptCombo, '-', '课题来源:',SubSourceCombo,'课题负责人:',userCombo],
					listeners : { 'render': function(){ 
                      tbuttonbar.render(this.tbar); 
                      } 
                    },
					//height:260,
					trackMouseOver: true,
					stripeRows: true	
		});

    itemGrid.btnAddHide();  //隐藏增加按钮
    itemGrid.btnSaveHide();  //隐藏保存按钮
    //itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
   // itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({	params:{start:0, limit:25,userdr:userdr}});

 downloadMainFun(itemGrid,'rowid','P007',33);


itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var rowid= '';
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	rowid=selectedRow[0].data['rowid'];      
	
	//xm--20160524删除项目科目维护
	//PrjItemInfoGrid.load({params:{start:0, limit:12,PrjDR:rowid}});	
});


// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	 //alert(columnIndex)
//		if (columnIndex == 3){
//			var records = itemGrid.getSelectionModel().getSelections();
//			var projectrowid = records[0].get("rowid");
//			CompInfoList(projectrowid);
//			}
//		if (columnIndex == 4) {
//			var records = itemGrid.getSelectionModel().getSelections();
//			var headdr = records[0].get("HeadDr");
//			HeadInfoList(headdr);
//		}
//		if(columnIndex==5){
//			var records = itemGrid.getSelectionModel().getSelections();
//			var participantsdrs = records[0].get("ParticipantsIDs");
//			ParticipantsInfoList(participantsdrs);
//		}

	
		var records = itemGrid.getSelectionModel().getSelections();
	    if (columnIndex == 5) {
	    
				var ProjectDR   = records[0].get("rowid");
				var RelyUnitsIDs = records[0].get("RelyUnitIDs");
				titleFun(ProjectDR,RelyUnitsIDs);
		}

		if(columnIndex == 8){
		
		var Name = records[0].get("Name");
		var ParticipantsIDs = records[0].get("ParticipantsIDs");
		//alert(ParticipantsIDs);
		ParticipantsInfoFun(Name,ParticipantsIDs);
		}
	
});