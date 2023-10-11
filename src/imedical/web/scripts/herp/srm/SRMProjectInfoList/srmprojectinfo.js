var userdr = session['LOGON.USERCODE'];  
var projUrl = 'herp.srm.srmprojectinfoexe.csp';
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
	var ProSField = new Ext.form.DateField({
		id : 'ProSField',
		//format : 'Y-m-d',
		width : 120,
		//allowBlank : false,
		emptyText : ''
	});
	var ProEField = new Ext.form.DateField({
		id : 'ProEField',
		//format : 'Y-m-d',
		width : 120,
		emptyText : ''
		
	});
////////////////科室名称/////////////////
var deptDs = new Ext.data.Store({
			autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});

deptDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=deptList&str='+encodeURIComponent(Ext.getCmp('DeptCombo').getRawValue()), 
                        method:'POST'
					});
		});

var DeptCombo = new Ext.form.ComboBox({
			id: 'DeptCombo',
			fieldLabel : '科室名称',
			store : deptDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			name: 'DeptCombo',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});


//////////////////课题来源//////////////////////  
var sourceDs = new Ext.data.Store({
			autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});

sourceDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=sourceList&str='+encodeURIComponent(Ext.getCmp('SourceCombo').getRawValue()),
						method : 'POST'
					});
		});

var SourceCombo = new Ext.form.ComboBox({
			id: 'SourceCombo',
			fieldLabel : '课题来源 ',
			store : sourceDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			name: 'SourceCombo',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 110,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
	
		
/////////////////课题负责人/////////////////		
var userDs = new Ext.data.Store({
			autoLoad:true,
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'Name'])
		});

userDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : projUrl+'?action=userList&str='+encodeURIComponent(Ext.getCmp('SourceCombo').getRawValue()),
						method : 'POST'
					});
		});
var HeadCombo = new Ext.form.ComboBox({
			id: 'HeadCombo',
			fieldLabel : '课题负责人 ',
			store : userDs,
			displayField : 'Name',
			valueField : 'rowid',
			typeAhead : true,
			name: 'HeadCombo',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 220,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
///////////////////课题名称/////////////
var NameText = new Ext.form.TextField({
			id: 'NameField',
			fieldLabel: '课题名称',
			emptyText: '',
			name: 'NameField',
			anchor:'95%'
			
		});

/////////////////// 查询按钮//////////// 
function srmProjectInfoList(){
	    var StartDate= ProSField.getValue();
	    if (StartDate!=="")
	    {
	       //StartDate=StartDate.format ('Y-m-d');
	    }
	    //alert(startdate);
	    var EndDate = ProEField.getValue();
	    if (EndDate!=="")
	    {
	       //EndDate=EndDate.format ('Y-m-d');
	    }
	    //alert(enddate);
	    var DeptDr  = DeptCombo.getValue();
	    var SubSource = SourceCombo.getValue(); 
	    var Head = HeadCombo.getValue();
	    var Name = NameText.getValue();
		itemGrid.load({
		    params:{
		    start:0,
		    limit:25,
		    StartDate:StartDate,
		    EndDate:EndDate,
		    DeptDr:DeptDr,
		    SubSource:SubSource,
		    Head:Head,
		    Name:Name,
		    userdr:userdr
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
						value:'<center><p style="font-weight:bold;font-size:150%">项目中检材料查询</p></center>',
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
						columnWidth:.08
					},
					ProSField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.01
					},
					{
						xtype:'displayfield',
						value:' 至',
						columnWidth:.04
					},
					ProEField,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.1
					},{
						xtype:'displayfield',
						value:'科室:',
						columnWidth:.053
					},
					DeptCombo,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.08
					},{
						xtype:'displayfield',
						value:'课题来源:',
						columnWidth:.08
					},
					SourceCombo
					]
			    },{
				xtype: 'panel',
				layout:"column",
				items: [
					{
						xtype:'displayfield',
						value:'课题负责人:',
						columnWidth:.08
					},
					HeadCombo,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.08
					},
					{
						xtype:'displayfield',
						value:'课题名称:',
						columnWidth:.08
					},
					NameText,
					{
						xtype:'displayfield',
						value:'',
						columnWidth:.2
					},{
						columnWidth:0.05,
						xtype:'button',
						text: '查询',
						handler:function(b){
							srmProjectInfoList();
						},
						iconCls: 'find'
					}		
				]
			}
			]
		});

var itemGrid = new dhc.herp.Grid({
		    region : 'center',
		    url: projUrl,
		    atLoad : true, // 是否自动刷新
			fields : [{
						header : '课题信息表ID',
						dataIndex : 'rowid',
						hidden : true
					}, {
						id : 'Dept',
						header : '科室',
						editable:false,
						align:'center',
						width : 80,
						dataIndex : 'Dept'
					},{
						id : 'Name',
						header : '课题名称',
						align:'center',
						width : 120,
						editable:false,
						dataIndex : 'Name'

					},{
						id : 'Head',
						header : '项目负责人',
						align:'center',
						editable:false,
						width : 120,
						dataIndex : 'Head'

					}, {
						id : 'Participants',
						header : '课题参加人员',
						align:'center',
						editable:false,
						width : 120,
						dataIndex : 'Participants'
					}, {
						id : 'SubSource',
						header : '课题来源',
						align:'center',
						editable:false,
						width : 120,
						dataIndex : 'SubSource'
					},{
						id : 'RelyUnit',
						header : '课题依托单位',
						align:'center',
						width : 220,
						editable:false,
						dataIndex : 'RelyUnit'
					}, {
						id : 'AppFunds',
						header : '申请经费(万元)',
						align:'center',
						width : 120,
						editable : false,
						dataIndex : 'AppFunds'
						
					},{
						id : 'GraFunds',
						header : '批准经费',
						align:'center',
						width : 120,
						editable:false,
						dataIndex : 'GraFunds'

					},{
						id : 'SubNo',
						header : '课题编号',
						align:'center',
						width : 120,
						editable:false,
						dataIndex : 'SubNo'

					},{
						id : 'IssuedDate',
						header : '批件下达时间',
						align:'center',
						width : 120,
						editable:false,
						dataIndex : 'IssuedDate'

					},{
						id : 'StartDate',
						header : '开始时间',
						align:'center',
						width : 120,
						editable:false,
						dataIndex : 'StartDate'

					},{
						id : 'EndDate',
						header : '截止时间',
						align:'center',
						width : 120,
						editable:false,
						dataIndex : 'EndDate'

					},{
						id : 'Remark',
						header : '备注',
						align:'center',
						width : 150,
						editable:false,
						dataIndex : 'Remark'

					}]					
		});

  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏重置按钮
  itemGrid.btnSaveHide(); 	//隐藏重置按钮
  itemGrid.load({params:{start:0, limit:12, userdr:userdr}});

