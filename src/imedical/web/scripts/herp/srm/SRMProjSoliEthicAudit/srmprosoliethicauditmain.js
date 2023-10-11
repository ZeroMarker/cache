var userdr = session['LOGON.USERCODE'];
var groupdesc = session['LOGON.GROUPDESC'];

if (groupdesc=="科研管理系统(信息修改)")
{ 
	userdr="";
}
if (groupdesc=="科研管理系统(信息查询)")
{ 
	userdr="";
}

var projUrl='herp.srm.srmprosoliethicauditexe.csp';

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
/////////////////申请时间///////////////////////
var StartDateField = new Ext.form.DateField({
			fieldLabel: '申请日期',
			width:120,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
var EndDateField = new Ext.form.DateField({
			fieldLabel: '申请日期',
			width:120,
			//format:'Y-m-d',
			//columnWidth : .12,
			renderer : function(v, p, r, i) {			
			if (v instanceof Date) {
				return new Date(v).format("Y-m-d");
			} else {return v;}
			},
			selectOnFocus:'true'
		});
/////////////////年度///////////////////////
var YearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

YearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=yearList&str='+encodeURIComponent(Ext.getCmp('YearCombo').getRawValue()),
	method:'POST'});
});

var YearCombo = new Ext.form.ComboBox({
	id: 'YearCombo',
	fieldLabel: '年度',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:YearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择年度...',
	name: 'YearCombo',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

 /////////////项目来源///////////////
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
			emptyText : '请选择项目来源...',
			width : 120,
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});

///////////////项目名称///////////////////
var TitleField = new Ext.form.TextField({
				id: 'TitleField',
                width: 120,
                allowBlank: true,
                name: 'TitleField',
                fieldLabel: '项目名称',
                blankText: '项目名称'
                
            });
            
///////////////申请人/////////////
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
			listWidth : 260,
			pageSize : 10,
			minChars : 1,
			selectOnFocus : true
		});
		

/////////////////查询按钮//////////////

SeachButton
var SeachButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'search',
	handler: function(){
		var Startdate= StartDateField.getValue();
		var Enddate= EndDateField.getValue();
		/* if(Startdate!="")
		{
			Startdate.format("Y-m-d");
		};
		var Enddate= EndDateField.getValue()
		if(Enddate!="")
		{
			Enddate.format("Y-m-d");
		}; */
	
		var Year = YearCombo.getValue();
		var SubSource = SubSourceCombo.getValue();
		var Title = TitleField.getValue();
		var SubUser = userCombo.getValue();

		if ((groupdesc=="科研管理系统(信息修改)")||(groupdesc=="科研管理系统(信息查询)"))
		{ 
			userdr="";
		}
		itemGrid.load({params:{start:0,limit:25,Startdate:Startdate,Enddate:Enddate,Year:Year,SubSource:SubSource,Title:Title,SubUser:SubUser,userdr:userdr}});	

	}
});
/*
//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel({
	height : 130,
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
			value : '<center><p style="font-weight:bold;font-size:100%">项目征集伦理审核</p></center>',
			columnWidth : 1,
			height : '32'
		}]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '年度:',
				columnWidth : .10
				},
				YearCombo,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.05
				},
				{
				xtype:'displayfield',
				value:'申请时间:',
				columnWidth:.085
				},
				StartDateField,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.02
				},
				{
				xtype:'displayfield',
				value:'至',
				columnWidth:.03
				},
				EndDateField,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.05
				},
				{
				xtype : 'displayfield',
				value : '申请人:',
				columnWidth : .07
				},
				userCombo]
	}, {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [{
				xtype : 'displayfield',
				value : '项目名称:',
				columnWidth : .07
				},
				TitleField,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.04
				},
				{
				xtype : 'displayfield',
				value : '项目来源:',
				columnWidth : .06
				},
				SubSourceCombo,
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.04
				},
				{
				xtype:'displayfield',
				value:'',
				columnWidth:.05
				},
				{
				columnWidth:0.06,
				xtype:'button',
				text: '查询',
				handler:function(b){SearchFun();},
				iconCls: 'find'
				}]
	}]
	
});
*/

var itemGrid = new dhc.herp.Grid({
			region : 'north',
			title: '项目征集伦理审核查询列表',
			iconCls: 'list',
			height:300,
			layout:"fit",
			split : true,
			collapsible : true,
			containerScroll : true,
			url : projUrl,					
			fields : [
			 new Ext.grid.CheckboxSelectionModel({
				 //hidden:true,
				 editable:false
				 
				 }),
			{
						header:'ID',
						dataIndex:'prjrowid',
						align:'center',
						hidden:true
					},{
						id:'Year',
						header:'年度 ',
						width:80,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'Year'
					},{
						id:'Title',
						header:'项目名称',
						width:220,
						editable:false,
						align:'left',
						dataIndex:'Title',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}

					},{
						id:'SubSource',
						header:'项目来源',
						width:180,
						editable:false,
						align:'left',
						dataIndex:'SubSource',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id:'IsEthic',
						header:'是否伦理审核',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'IsEthic'
					},{
						id:'PreAuditState',
						header:'预审状态',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'PreAuditState'
					},{
						id:'PreAuditDesc',
						header:'预审意见',
						width:100,
						editable:false,
						align:'left',
						dataIndex:'PreAuditDesc'
					},{   //
							id:'download',
							header: '下载',
							allowBlank: false,
							width:40,
							editable:false,
							dataIndex: 'download',
							renderer : function(v, p, r){
							return '<span style="color:blue"><u>下载</u></span>';
					    } 
					},{
						id:'SubUser',
						header:'申请人',
						editable:false,
						width:120,
						align:'left',
						dataIndex:'SubUser'
					},{
						id:'SubDeptDr',
						header:'申请人科室',
						width:180,
						editable:false,
						align:'left',
						dataIndex:'SubDeptDr',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					},{
						id:'SubDate',
						header:'申请时间',
						width:120,
						editable:false,
						align:'left',
						dataIndex:'SubDate'
					}],
					tbar :['年度',YearCombo,'-','时间', StartDateField,'-','至',EndDateField,'-','申请人', userCombo, '-', '项目名称',TitleField,'-','项目来源',SubSourceCombo,SeachButton]
		});


  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnAddHide(); 	//隐藏添加按钮
  itemGrid.btnSaveHide(); 	//隐藏保存按钮
  itemGrid.load({params:{start:0, limit:12, userdr:userdr}});
 
 
 itemGrid.on('rowclick',function(grid,rowIndex,e){	
	row=rowIndex;
    var prjdr="";
	var selectedRow = itemGrid.getSelectionModel().getSelections();
	prjdr=selectedRow[0].data['prjrowid'];
	//alert(Year);
	EthicResultGrid.load({params:{start:0, limit:25,prjrowid:prjdr}});	//,usercode:usercode
});

 /*
 // 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e)
{
	var records = itemGrid.getSelectionModel().getSelections();
	var IsEthic = records[0].get("IsEthic");
	var EthicChkResult = records[0].get("EthicChkResult");

	if(IsEthic=="是")
	{	
		if((EthicChkResult=='审批通过')||(EthicChkResult=='审批不通过'))
		{
			submitProSoliInfoButton.enable();
			return;
		}
		else
		{
			submitProSoliInfoButton.disable();
			return;
		}		
	}
	else
	{
		return;
	}	
}); 
*/
downloadMainFun(itemGrid,'prjrowid','P011',9);
