var projUrl = 'herp.srm.srmhorizonprjsetupauditexe.csp';

var userdr = session['LOGON.USERID'];
//var username = session['LOGON.USERCODE'];

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
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

 ///项目来源
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
			fieldLabel : '项目来源',
			store : SubSourceDs,
			displayField : 'Name',
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

///////////////////项目状态
var PrjStateStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['1', '申请'], ['2', '执行'],['3','结题'],['4','取消']]
		});
var PrjStateField = new Ext.form.ComboBox({
			fieldLabel : '项目状态',
			width : 120,
			listWidth : 120,
			selectOnFocus : true,
			allowBlank : true,
			store : PrjStateStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : true,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});

//////项目负责人
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
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		
// ////////////项目名称
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
});

//申请经费
var grafundsField = new Ext.form.NumberField({
	id: 'grafundsField',
	fieldLabel: '批准金额',
	width:90,
	allowBlank: false,
	emptyText:'',
	name: 'grafundsField',
	editable:true
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
			allowBlank : true,
			store : ChkResultStore,
			anchor : '90%',
			// value:'key', //默认值
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			triggerAction : 'all',
			emptyText : '',
			mode : 'local', // 本地模式
			editable : true,
			//pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			forceSelection : true
		});	
/////////////////// 查询按钮 

	function SearchFun(){
	    
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
	    var projStatus  = PrjStateField.getValue();
	    var HeadDr= userCombo.getValue();
	    var PName = titleText.getValue();   
	    //var ResAudit = ChkResultField.getValue();
		var Type = TypeCombox.getValue();
	    var ResAudit = "";
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
		    ResAudit:ResAudit,
			Type:Type
		   }
	  })
  }


////立项审核按钮
var SetUpAuditButton = new Ext.Toolbar.Button({
	    text: '通过',  
      iconCls: 'pencil',
      handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		/**
        for(var j= 0; j < len; j++){
		 if(rowObj[j].get("ProjStatus")=="执行")
		 {
			      Ext.Msg.show({title:'注意',msg:rowObj[j].get("Name")+'已立项',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			       return;
		 }
		 else{
		 	     Ext.Msg.show({title:'注意',msg:'请先添加项目分工信息！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		 	} 	
		}
		**/
		//没有复选框的情况下 可以不用for循环
		for(var i= 0; i < len; i++){
		   var auditstate=rowObj[i].get("ChkResult");
		   var ProjStatusDR = rowObj[i].get("ProjStatusDR");
		   if ((((auditstate=="1")||(auditstate=="2"))&&(ProjStatusDR=2))||(ProjStatusDR>2)){
				Ext.Msg.show({title:'错误',msg:'该立项申请已审核！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			    return;
			}
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					 var rowid = rowObj[i].get("rowid");
					  Ext.Ajax.request({
						url:projUrl+'?action=audit&rowid='+rowid+'&userdr='+userdr,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'已审核!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});	
								itemGrid.load({params:{start:0, limit:12}});
								
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
		Ext.MessageBox.confirm('提示','确实要审核该记录吗?',handler);
    }
});

var NoAuditButton = new Ext.Toolbar.Button({
	    text: '不通过',  
        iconCls: 'pencil',
        handler:function(){
		//定义并初始化行对象
		var rowObj=itemGrid.getSelectionModel().getSelections();
		//定义并初始化行对象长度变量
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的记录!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return;
		}
		for(var i= 0; i < len; i++){
		   var auditstate=rowObj[i].get("ChkResult");
		   var ProjStatusDR = rowObj[i].get("ProjStatusDR");
		   if ((((auditstate=="1")||(auditstate=="2"))&&(ProjStatusDR=2))||(ProjStatusDR>2)){
				Ext.Msg.show({title:'错误',msg:'该立项申请已审核！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			    return;
			}
		}
		function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    var rowid=rowObj[i].get("rowid");
					    Ext.Ajax.request({
						url:projUrl+'?action=noaudit&rowid='+rowid,
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},

						success: function(result, request){					
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'已审核!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:12}});
								
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
		Ext.MessageBox.confirm('提示','确认不通过吗?',handler);
    }
});
/*
var tbuttonbar = new Ext.Toolbar({   
        items: [findButton,SetUpAuditButton,NoAuditButton]   
    });   
*/
var tbar2=new Ext.Toolbar
(
	{   
		//labelAlign: "right",
		//labelWidth: 370, 
		items:['','项目来源','',SubSourceCombo,'','项目名称','',titleText,'','项目负责人','',userCombo]
	}
); 

var queryPanel = new Ext.FormPanel
({
	autoHeight : true,
	region : 'north',
	frame : true,
	//title : '项目征集申请信息查询',
	//iconCls : 'search',	
	defaults : 
	{
		bodyStyle : 'padding:5px'
	},
	
	items : 
	[
		{
			columnWidth : 1,
			xtype : 'panel',
			layout : "column",
			items : 
			[
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">开始时间</p>',
					width : 60			
				},	
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PSField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">结束时间</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				PEField,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">科室名称</p>',
					width : 70			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				deptCombo,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">类型</p>',
					width : 40			
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
					width : 30
				},		
				{
					xtype : 'button',
					text : '查询',
					handler : function(b){SearchFun();},
					iconCls : 'search',
					width : 30
				}
			]
		}, 
		{
			columnWidth : 1,
			xtype : 'panel',
			layout : "column",
			items : 
			[
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">项目来源</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},	
				SubSourceCombo,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">项目名称</p>',
					width : 60			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				titleText,
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				{
					xtype : 'displayfield',
					value : '<p style="text-align:right;">项目负责人</p>',
					width : 70			
				},
				{
					xtype : 'displayfield',
					value : '',
					width : 10
				},
				userCombo
			]
		}	
	]	

});
    
var itemGrid = new dhc.herp.Gridhss({
		    //title: '项目立项审核信息列表',
			//iconCls: 'list',
		    region : 'center',
		    url: projUrl,
		    autoScroll:true,
			  fields : [
			      //new Ext.grid.CheckboxSelectionModel({editable:false}),
			        {
						header : '项目ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'Type',
						header : '类型',
						width : 40,
						editable:false,
						dataIndex : 'Type'

					},{
						id : 'YearCode',
						header : '年度',
						width : 60,
						editable:false,
						dataIndex : 'YearCode'

					},{
						id : 'Dept',
						header : '科室',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'Dept'

					},{
						id : 'Name',
						header : '项目名称',
						editable:false,
						width : 180,
						align: 'left',
						/*
  					    renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						},
						*/
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return '<span style="color:blue;cursor:hand"><u>'+data+'</u></span>';;
						},
						dataIndex : 'Name'
					},{
						id : 'SubNo',
						header : '项目编号',
						width : 100,
						editable:false,
						dataIndex : 'SubNo'
//						renderer: function(value, cellmeta, record, rowIndex,
//								columnIndex, store){
//								 if(record.data["ProjStatus"]!='申请'){			 
//								 this.editable=false;
//								 //console.log(this.editable+"<-edit"+this.value+"<-value");
//								 return '<span>'+value+'</span>';
//								 }else{
//								 this.editable=true;
//								 return '<span>'+value+'</span>';
//								 }
//								}

					},{
						id : 'GraFund',
						header : '批准经费(万元)',
						width : 100,
						editable:false,						
						align:'right',
						dataIndex : 'GraFund',
                        type:grafundsField,//引用定义的数值文本框
                        renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},{
						id : 'IssuedDate',
						header : '项目立项时间',
						width : 80,
						editable:false,
						dataIndex : 'IssuedDate',
						type: "dateField",
						//dateFormat: 'Y-m-d',
						renderer: function(value, cellmeta, record, rowIndex,
								columnIndex, store){
								 if(record.data["ProjStatus"]!='申请'){
								 this.editable=false;
								 return '<span>'+value+'</span>';
								 }else{
								 this.editable=true;
								 return '<span>'+value+'</span>';
								 }
								}

					},{
						id : 'Head',
						header : '项目负责人',
						editable:false,
						width : 80,
						hidden : false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						           return '<span style="color:blue;cursor:hand"><u>'+value+'</u></span>';
						},
						dataIndex : 'Head'

					},{
						id : 'PrjLife',
						header : '项目年限',
						editable:false,
						width : 80,
						align:'right',
						hidden : false,
						dataIndex : 'PrjLife'

					}, 
					{
						id : 'CompleteUnit',
						header : '我院完成单位',
						editable:false,
						width : 120,
						hidden : true,
						dataIndex : 'CompleteUnit'
					}, {
						id : 'ParticipantsName',
						header : '项目参与人员',
						width : 80,
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['rowid']
						if (sf != "") {
							return '<span style="color:blue;cursor:hand"><u>项目参与人员</u></span>';
						} else {
							return '<span style="color:gray;cursor:hand"></span>';
						}},
						dataIndex : 'ParticipantsName'
					},
					{
						id : 'Participants',
						header : '项目参加人员',
						width : 180,
						editable:false,
						hidden:true,
						dataIndex : 'Participants'

					},{
						id : 'PTName',
						header : '项目来源',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PTName'

					},{
						id : 'Department',
						header : '立项部门',
						width : 180,
						editable:false,
						dataIndex : 'Department',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id : 'FundOwn',
						header : '医院匹配（万元）',
						width : 120,
						//editable:false,
						align:'right',
						hidden : true,
						dataIndex : 'FundOwn'

					},{
						id : 'FundMatched',
						header : '到位经费（万元）',
						width :120,
						editable:false,
						align:'right',
						dataIndex : 'FundMatched',
						renderer: function(val)
         {
	         val=val.replace(/(^\s*)|(\s*$)/g, "");
	         val=Ext.util.Format.number(val,'0.00');
	         val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         return val?val:'';
		 }
					},
					{
						id : 'RelyUnit',
						header : '项目依托单位',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'RelyUnit'

					},{
						id : 'PrjCN',
						header : '合同号',
						width : 120,
						editable:false,
						hidden : true,
						dataIndex : 'PrjCN'

					},{
						id : 'StartDate',
						header : '开始日期',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'StartDate',
                        hidden:true
					},{
						id : 'EndDate',
						header : '结束日期',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'EndDate',
                        hidden:true
					},{
						id : 'SEndDate',
						header : '起止年月',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'SEndDate'

					},{
						id : 'IsGovBuy',
						header : '是否政府项目',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'IsGovBuy'

					},{
						id : 'AppFund',
						header : '申请经费（万元）',
						width :120,
						editable:false,
						align:'right',
						dataIndex : 'AppFund',
						renderer: function(val)
						{
							val=val.replace(/(^\s*)|(\s*$)/g, "");
							val=Ext.util.Format.number(val,'0.00');
							val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
							return val?val:'';
						}
					},{
						id : 'MonographNum',
						header : '出版专著',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'MonographNum'
					},{
						id : 'PaperNum',
						header : '发表论文',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'PaperNum'
					},{
						id : 'PatentNum',
						header : '专利',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'PatentNum'
					},{
						id : 'InvInCustomStanNum',
						header : '参与制定技术标准',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'InvInCustomStanNum'
					},{
						id : 'TrainNum',
						header : '培养人才',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'TrainNum'
					},{
						id : 'HoldTrainNum',
						header : '举办培训班',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'HoldTrainNum'
					},{
						id : 'InTrainingNum',
						header : '参与培训班',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'InTrainingNum'
					},{
						id : 'IsEthicalApproval',
						header : '是否伦理审批',
						width :120,
						editable:false,
						hidden : true,
						dataIndex : 'IsEthicalApproval'
					},{
						id : 'SubUser',
						header : '项目申请人',
						width : 80,
						editable:false,
						dataIndex : 'SubUser'

					},{
						id : 'SubDate',
						header : '项目申请时间',
						width : 80,
						editable:false,
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
					},{
							id:'download',
							header: '下载',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
						

					} },{
						id : 'DataStatuslist',
						header : '数据状态',
						width : 60,
						editable:false,
						//hidden:true,
						dataIndex : 'DataStatuslist'
					},{
						id : 'ChkResult',
						header : '审核结果',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'ChkResult'
					},{
						id : 'ChkResultlist',
						header : '科研处审核状态',
						editable:false,
						renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) { 
						var sf = record.data['ChkResult']
						var ProjStatusDR = record.data['ProjStatusDR']
						if ((sf == "0")&&(ProjStatusDR==2)) {return '<span style="color:blue;cursor:hand">'+value+'</span>';}  //立项等待审核
						if ((ProjStatusDR>2)||((sf == "1")&&(ProjStatusDR==2))) {return '<span style="color:red;cursor:hand">'+value+'</span>';}   //已立项审核通过
						if ((sf == "2")&&(ProjStatusDR==2)){return '<span style="color:gray;cursor:hand">'+value+'</span>';}  //立项审核不通过
						},
						width : 100,
						dataIndex : 'ChkResultlist'
					},{
						id : 'ProjStatus',
						header : '项目状态',
						width : 80,
						editable:false,
						dataIndex : 'ProjStatus'
					},{
						id : 'ProjStatusDR',
						header : '项目状态',
						width : 80,
						editable:false,
						hidden:true,
						dataIndex : 'ProjStatusDR'
					}],
					//split : true,
					//collapsible : true,
					containerScroll : true,
					xtype : 'grid',
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					loadMask : true,
					//viewConfig : {forceFit : true},
					//tbar :['类型:',TypeCombox,'-','开始时间:', PSField,'-','结束时间:',PEField,'-','科室名称:', deptCombo, '-', '项目来源:',SubSourceCombo,'-','项目负责人:',userCombo],
					tbar :[SetUpAuditButton,NoAuditButton],
				
					
     
					//height:230,
					trackMouseOver: true,
					stripeRows: true	
		});

    itemGrid.btnAddHide();  //隐藏增加按钮
    itemGrid.btnSaveHide();  //隐藏保存按钮
    //itemGrid.btnResetHide();  //隐藏重置按钮
    itemGrid.btnDeleteHide(); //隐藏删除按钮
    // itemGrid.btnPrintHide();  //隐藏打印按钮


itemGrid.load({	params:{start:0, limit:25,userdr:userdr}});

    downloadMainFun(itemGrid,'rowid','P007',38);

itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	var rowid=selectedRow[0].data['rowid'];
  var participantsdrs = selectedRow[0].get("ParticipantsIDs");
  var header = selectedRow[0].get("HeadDr");
  //var allparticipants = header+','+participantsdrs;
  var participantsdrarray=participantsdrs.split(",",-1);
    var length=participantsdrarray.length;
    var allparticipants="";
    var allparticipantsarray=participantsdrarray[0].split("-",-1);
    allparticipants=allparticipantsarray[0];
    for(var i=1;i<length;i++)
    {
    	var temparray=participantsdrarray[i].split("-",-1);
    	allparticipants=allparticipants+","+temparray[0];
    }
	DetailGrid.load({params:{start:0, limit:25,rowid:rowid}});	
	ParticipantsInfoGrid.load({params:{start:0,limit:25,participantsdrs:participantsdrs}});
	//xm--20160525删除项目科目维护
	//PrjItemInfoGrid.load({params:{start:0,limit:25,PrjDR:rowid}});
	ProjCompGrid.load({params:{start:0,limit:25,prjrowid:rowid}});
});

//itemGrid.btnAddHide();  //隐藏增加按钮
//itemGrid.btnSaveHide();  //隐藏保存按钮
//itemGrid.btnResetHide();  //隐藏重置按钮
//itemGrid.btnDeleteHide(); //隐藏删除按钮
// itemGrid.btnPrintHide();  //隐藏打印按钮
   

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
        if (columnIndex == 9) {
		var Name = records[0].get("Name");
		var HeadDR   = records[0].get("HeadDr");
		//alert(HeadDR);
		responsepeopleInfoFun(Name,HeadDR);
        }
		if(columnIndex == 12){
		var Name = records[0].get("Name");
		var ParticipantsIDs = records[0].get("ParticipantsIDs");
		//alert(ParticipantsIDs);
		ParticipantsInfoFun(Name,ParticipantsIDs);
		}
	
});
