var userdr = session['LOGON.USERID'];   
 
var projUrl = 'herp.srm.auditPrjEthicalApprovalexe.csp';

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
			listWidth : 240,
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
			//pageSize : 10,
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
			listWidth : 240,
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
	    var ResAudit  = ChkResultField.getValue();
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
		 if(rowObj[j].get("EthicalAuditState")=="通过"||rowObj[j].get("EthicalAuditState")=="未通过")
		 {
			      Ext.Msg.show({title:'注意',msg:'伦理审批已完成',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:projUrl+'?action=audit&&rowid='+rowObj[i].get("rowid")+'&checker='+checker,
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
						var usercheckdr   = session['LOGON.USERID'];	
						var rowObj=itemGrid.getSelectionModel().getSelections();
						var len = rowObj.length;
						if(len < 1){
							Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
						for(var j= 0; j < len; j++){
							 if(rowObj[j].get("EthicalAuditState")=="通过"||rowObj[j].get("EthicalAuditState")=="未通过")
							 {
								      Ext.Msg.show({title:'注意',msg:'伦理审批已完成',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
								       return;
							 }
						}
						//noauditfun();
						 function handler(id){
						 	if(id=="yes"){
		       for(var i = 0; i < len; i++){
			    Ext.Ajax.request({
					url:projUrl+'?action=noaudit'+'&rowid='+rowObj[i].get("rowid")+'&usercheckdr='+usercheckdr,
					waitMsg:'保存中...',
					failure: function(result, request){
						Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								//var apllycode = jsonData.info;
								Ext.Msg.show({title:'注意',msg:'操作成功!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});												
								itemGrid.load({params:{start:0, limit:12,usercheckdr:usercheckdr}});	
							}
							else
							{
								//var tmpMsg = jsonData.info;
								Ext.Msg.show({title:'错误',msg:jsonData.info,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
					},
					scope: this
			 });
		  }
	   }
	   else  {return;}
			}
		Ext.MessageBox.confirm('提示','确实要审核该条记录吗?',handler);
		}
  });
 var tbuttonbar = new Ext.Toolbar({   
        items: ['课题名称:',titleText,'-',findButton,AuditButton,NoAuditButton]   
 }); 
 
var itemGrid = new dhc.herp.Gridhss({
		    //title: '论文申请审批',
		    region : 'center',
		    viewConfig : {forceFit : false},
		    autoScroll:true,
		    url: projUrl,
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
						width : 120,
						editable:false,
						dataIndex : 'Type'
					},{
						id : 'PrjType',
						header : '课题类型',
						width : 120,
						editable:false,
						dataIndex : 'PrjType'
					},{
						id : 'YearCode',
						header : '年度',
						width : 120,
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
						align: 'center',
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
						header : '我院完成单位',
						editable:false,
						hidden:true,
						width : 120,
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
					},{
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
						id : 'FundOwn',
						header : '医院匹配（万元）',
						width : 120,
						editable:false,
						dataIndex : 'FundOwn'
					},{
						id : 'FundMatched',
						header : '到位经费（万元）',
						width :120,
						editable:false,
						dataIndex : 'FundMatched'
					},{
						id : 'EthicalAuditState',
						header : '伦理审批状态',
						width :120,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['EthicalAuditState']
						if (sf == "等待审核") {return '<span style="color:grey;cursor:hand">'+value+'</span>';} 
						if (sf == "通过") {return '<span style="color:red;cursor:hand">'+value+'</span>';} 
						if (sf == "未通过"){return '<span style="color:blue;cursor:hand">'+value+'</span>';}
						},
						dataIndex : 'EthicalAuditState'
					},{
						id : 'SubUser',
						header : '课题申请人',
						width : 120,
						editable:false,
						dataIndex : 'SubUser'

					},{
						id : 'SubDate',
						header : '课题申请时间',
						width : 120,
						editable:false,
						dataIndex : 'SubDate'

					},{
						id : 'ProjStatus',
						header : '项目状态',
						width : 120,
						editable:false,
						dataIndex : 'ProjStatus'
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
					containerScroll : true,
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
					height:230,
					trackMouseOver: true,
					stripeRows: true	
		});

  itemGrid.btnAddHide();  //隐藏增加按钮
  itemGrid.btnSaveHide();  //隐藏保存按钮
  //itemGrid.btnResetHide();  //隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  // itemGrid.btnPrintHide();  //隐藏打印按钮
   
  itemGrid.load({params:{start:0, limit:12}});

    downloadMainFun(itemGrid,'rowid','P007',27);
/**
 itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var rowid= '';
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	rowid=selectedRow[0].data['rowid'];
        
	DetailGrid.load({params:{start:0, limit:12,rowid:rowid}});	
});
**/

///////////// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
//		if (columnIndex == 4) {
//			var records = itemGrid.getSelectionModel().getSelections();
//			var headdr = records[0].get("HeadDr");
//			HeadInfoList(headdr);
//		}
		var records = itemGrid.getSelectionModel().getSelections();
	    if (columnIndex == 6) {
	    
				var ProjectDR   = records[0].get("rowid");
				var RelyUnitsIDs = records[0].get("RelyUnitIDs");
				titleFun(ProjectDR,RelyUnitsIDs);
		}

		if(columnIndex == 9){

		var Name = records[0].get("Name");
		var ParticipantsIDs = records[0].get("ParticipantsIDs");
		ParticipantsInfoFun(Name,ParticipantsIDs);
		}
	
});

