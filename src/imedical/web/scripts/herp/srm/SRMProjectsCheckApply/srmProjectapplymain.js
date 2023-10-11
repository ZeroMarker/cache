
var projUrl = 'herp.srm.srmprojectscheckapplyexe.csp';
var userdr = session['LOGON.USERCODE'];

    Date.dayNames = ["日", "一", "二", "三", "四", "五", "六"];  
    Date.monthNames=["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"];  
    if (Ext.DatePicker) {  
        Ext.apply(Ext.DatePicker.prototype, {  
            todayText: "今天",  
            minText: "日期在最小日期之前",  
            maxText: "日期在最大日期之后",  
            disabledDaysText: "",  
            disabledDatesText: "",  
            monthNames: Date.monthNames,  
            dayNames: Date.dayNames,  
            nextText: '下月 (Control+Right)',  
            prevText: '上月 (Control+Left)',  
            monthYearText: '选择一个月 (Control+Up/Down 来改变年)',  
            todayTip: "{0} (Spacebar)",  
            okText: "确定",  
            cancelText: "取消" 
        });  
    } 	   
 
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
		emptyText : ''
	});

	var PEField = new Ext.form.DateField({
		id : 'PEField',
		//format : 'Y-m-d',
		width : 120,
		emptyText : ''
	});
	
 ///科室名称
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});
		
deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('deptCombo').getRawValue()), 
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
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

 ///课题来源
var SubSourceDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});
		
SubSourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=sourceList&str='+encodeURIComponent(Ext.getCmp('SubSourceCombo').getRawValue()), 
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
			listWidth : 250,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

///////////////////科研审批结果
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
						url : projUrl+'?action=applyerList',
						method : 'POST'
					});
		});

var userCombo = new Ext.form.ComboBox({
			store : userDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 250,
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
		var Type=TypeCombox.getValue();
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
			userdr:userdr,
			Type:Type
		   }
	  })
  }
});

///////////////提交按钮//////////////////////////
var subPatentInfoButton = new Ext.Toolbar.Button({
		text:'提交',
		tooltip:'提交选定的项目验收申请',
		iconCls:'add',
		handler:function(){
			var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length;
			if(len<1){
				Ext.Msg.show({title:'提示',msg:'请选择需要提交的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}else{
				for(var i = 0; i < len; i++){
				var state = rowObj[i].get("ProjStatus");	
				//alert(state);	
				if(state == "执行" ){
				      subFun();
				}
				else {Ext.Msg.show({title:'警告',msg:'已提交验收申请！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});}}}
			}	
});

var tbuttonbar = new Ext.Toolbar({   
        items: ['课题名称:',titleText,'-',findButton,subPatentInfoButton]   
    });   
    
var itemGrid = new dhc.herp.Gridhss({
		      title: '纵向课题验收申请',
		      region : 'center',
		      viewConfig : {forceFit : false},
		      autoScroll:true,
		      url: projUrl,
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
						width : 120,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['rowid']
						if (sf != "") {
							return '<span style="color:blue;cursor:hand"><u>课题参与人员</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand"></span>';
						}},
						dataIndex : 'ParticipantsName'
					},{
							id:'upload',
							header: '附件',
							allowBlank: false,
							width:40,
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
						

					} },
					{
						id : 'DataStatuslist',
						header : '数据状态',
						width : 120,
						editable: false,
						hidden:false,
						dataIndex : 'DataStatuslist'
					},{
						id : 'ProjStatus',
						header : '项目状态',
						width : 120,
						editable: false,
						hidden:true,
						dataIndex : 'ProjStatus'
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
						hidden:true,
						dataIndex : 'Desc'
					},{
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
						dataIndex : 'SubNo',
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						}

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
						align:'right',
						editable:false,
						dataIndex : 'AppFund'

					},{
						id : 'GraFund',
						header : '批准经费（万元）',
						width : 120,
						align:'right',
						editable:false,
						dataIndex : 'GraFund'

					},{
						id : 'FundGov',
						header : '上级拨款（万元）',
						width : 120,
						editable:false,
						align:'right',
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
						align:'right',
						editable:false,
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
					}],
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


    uploadMainFun(itemGrid,'rowid','P007',9);
    downloadMainFun(itemGrid,'rowid','P007',10);



itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var rowid= '';
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	rowid=selectedRow[0].data['rowid'];      
	//DetailGrid.load({params:{start:0, limit:12,rowid:rowid}});	
	//xm--20160524删除项目科目维护
	//PrjItemInfoGrid.load({params:{start:0,limit:25,PrjDR:rowid}});
});


// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
	// alert(columnIndex)
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
		if(columnIndex == 19){
		var SubNo = records[0].get("SubNo");
		//alert(ParticipantsIDs);
		BudgItemPay(SubNo); //项目报销情况
		}
	
});