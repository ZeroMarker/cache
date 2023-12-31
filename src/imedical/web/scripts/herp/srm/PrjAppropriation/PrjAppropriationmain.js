var projUrl = 'herp.srm.PrjAppropriationexe.csp';

var userdr = session['LOGON.USERCODE'];
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
						url : projUrl+'?action=applyerList&str='+encodeURIComponent(Ext.getCmp('userCombo').getRawValue()),
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
			name:'userCombo',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true,
			editable:true,
			allowblank:true
		});
		
// ////////////项目名称
var titleText = new Ext.form.TextField({
	width : 120,
	selectOnFocus : true
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
						  
/////////////////// 查询按钮 
var findButton = new Ext.Toolbar.Button({
	text: '查询',
	//tooltip: '查询',
	iconCls: 'search',
	handler: function(){
	    
		/*var startdate= PSFieldetVal.getValue();
	    if (startdate!=="")
	    {
	       startdate=startdate.format ('Y-m-d');
	    }
	    var enddate= PEField.getValue();
	    if (enddate!=="")
	    {
	       enddate=enddate.format ('Y-m-d');
	    }*/
	    var startdate = "";
	    var enddate = "";
	    var dept  = deptCombo.getValue();
	    var SubSource= SubSourceCombo.getValue();
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
			//userdr:userdr,
			Type:Type
		 }
	  })
	  DetailGrid.load({params:{start:0, limit:12,rowid:"",applydr:""}});
  }
});
  
var itemGrid = new dhc.herp.Grid({
		    title: '项目到位经费信息列表',
		    iconCls: 'list',
		    region : 'north',
		    viewConfig : {forceFit : false},
		    autoScroll:true,
		    url: projUrl,
			  fields : [
			      //new Ext.grid.CheckboxSelectionModel({editable:false}),
			       {
				        id:'rowid',
						header : '项目ID',
						dataIndex : 'rowid',
						hidden : true
					},{
						id : 'Type',
						header : '类型',
						width : 40,
						editable:false,
						dataIndex : 'Type'
					},
					{
						id : 'YearCode',
						header : '年度',
						width : 60,
						editable:false,
						dataIndex : 'YearCode'
					},{
						id : 'Name',
						header : '项目名称',
						editable:false,
						width : 180,
						align:'left',
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
					},
					{
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
						id : 'SubSourceName',
						header : '项目来源',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'SubSourceName'

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

					},
					{
						id : 'SubNo',
						header : '项目编号',
						width : 100,
						editable:false,
						dataIndex : 'SubNo'
					},
					{
						id : 'GraFunds',
						header : '批准经费(万元)',
						width : 100,
						editable:false,
						align:'right',
						dataIndex : 'GraFunds',
						renderer: function(val)
         				{
	         				val=val.replace(/(^\s*)|(\s*$)/g, "");
	         				val=Ext.util.Format.number(val,'0.00');
	         				val=val.replace(/(\d{1,3})(?=(\d{3})+(?:$|\D))/g,"$1,")
	         				return val?val:'';
		 				}
					},{
						id : 'RelyUnit',
						header : '项目依托单位',
						width : 120,
						editable:false,
						hidden:true,
						hidden:true,
						dataIndex : 'RelyUnit'

					},{
						id : 'SEndDate',
						header : '起止年月',
						width :120,
						editable:false,
						hidden:true,
						dataIndex : 'SEndDate'

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
						id : 'ResAudit',
						header : '审核状态',
						width : 120,
						editable:false,
						hidden:true,
						dataIndex : 'ResAudit'

					},{
						id : 'ChkResultlist',
						header : '项目状态',
						width : 100,
						editable:false,
						dataIndex : 'ChkResultlist'
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
					containerScroll : true,
					xtype : 'grid',
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					loadMask : true,
					//viewConfig : {forceFit : true},
					tbar :['','类型','',TypeCombox,'','科室名称','',deptCombo,'','项目来源','',SubSourceCombo,'','项目负责人','',userCombo,'','项目名称','',titleText,'-',findButton],
					height:300,
					trackMouseOver: true,
					stripeRows: true	
		});


        itemGrid.btnAddHide(); 	
		itemGrid.btnSaveHide();  
		itemGrid.btnDeleteHide();   

itemGrid.load({	params:{start:0, limit:25}});


itemGrid.on('rowclick',function(grid,rowIndex,e){	
	var rowid="";
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	rowid=selectedRow[0].data['rowid'];
    //alert(rowid);
	DetailGrid.load({params:{start:0, limit:12,rowid:rowid,applydr:userdr}});	
});


///////////// 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {

        var records = itemGrid.getSelectionModel().getSelections();
	    if (columnIndex == 4) {
	    
				var ProjectDR   = records[0].get("rowid");
				var RelyUnitsIDs = records[0].get("RelyUnitIDs");
				titleFun(ProjectDR,RelyUnitsIDs);
		}
        
		if(columnIndex == 5){
		var Name = records[0].get("Name");
		var ParticipantsIDs = records[0].get("ParticipantsIDs");
		ParticipantsInfoFun(Name,ParticipantsIDs);
		}
});