
var usercode = session['LOGON.USERCODE'];
var projUrl = 'herp.srm.srmprojectexpertauditexe.csp';
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



/////////////////申请日期///////////////////////
var StartDateField = new Ext.form.DateField({
			fieldLabel: '开始日期',
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
			fieldLabel: '结束日期',
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

//////////////////////年度//////////////////////////////////
var yearDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


yearDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetYear&str='+encodeURIComponent(Ext.getCmp('yearField').getRawValue()),
	method:'POST'});
});

var yearField = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '年度',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:yearDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择年度...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

/////////////////申请人///////////////////
var PatenteeDs = new Ext.data.Store({
	//autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});


PatenteeDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	url:projUrl+'?action=GetPatentee&str='+encodeURIComponent(Ext.getCmp('Patentees').getRawValue()),
	method:'POST'});
});

var PatenteeField = new Ext.form.ComboBox({
	id: 'Patentees',
	fieldLabel: '申请人',
	width:120,
	listWidth : 260,
	allowBlank: true,
	store:PatenteeDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	//emptyText:'请选择申请人...',
	name: 'Patentees',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});


/////////////////项目名称///////////////////
var PatentName = new Ext.form.TextField({
                width: 120,
                allowBlank: true,
                name: 'PatentName',
                fieldLabel: '项目名称',
                blankText: '项目名称'
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
						url : 'herp.srm.projectmidchecknewexe.csp'+'?action=sourceList&str='+encodeURIComponent(Ext.getCmp('SubSourceCombo').getRawValue()), 
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

/////////////////查询按钮响应函数//////////////
function SearchFun()
{			
	    var startdate= StartDateField.getValue()
		if(startdate!=""){
			//startdate.format("Y-m-d");
		};
		var enddate= EndDateField.getValue()
		if(enddate!=""){
			//enddate.format("Y-m-d");
		};
	    
        var Patentee = PatenteeField.getValue();
        var year= yearField.getValue();
        var Name = PatentName.getValue();
        var SubSource = SubSourceCombo.getValue();
		
	itemGrid.load({params:{start:0,limit:25,startdate:startdate,enddate:enddate,YearDr:year,SubUser:Patentee,Title:Name,SubSource:SubSource,usercode:usercode}});
	
}

//////////////////////////////////////////////
var queryPanel = new Ext.FormPanel
(
	{
		autoHeight : true,
		region : 'north',
		frame : true,
		title : '项目征集专家审核查询',
		iconCls : 'search',	

		defaults : 
		{
			bodyStyle : 'padding:5px'
		},
		items : 
		[ 
			{
				columnWidth : 1,
				xtype : 'panel',
				layout : 'column',
				items : 
				[
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">年度</p>',
						width : 60			
					},	
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					yearField,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">申请人</p>',
						width : 60
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					PatenteeField,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:right;">申请日期</p>',
						width : 60	
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					StartDateField,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					{
						xtype : 'displayfield',
						value : '<p style="text-align:center;">至</p>',
						width : 20			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					EndDateField,
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
						value : '<p style="text-align:right;">项目名称</p>',
						width : 60			
					},
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
					PatentName,
					{
						xtype : 'displayfield',
						value : '',
						width : 10
					},
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
					SubSourceCombo
				]
			}
		]
	}
);



var itemGrid = new dhc.herp.Grid({
			region : 'center',
			title: '项目征集专家审核查询列表',
			iconCls: 'list',
			url : projUrl,
		
			fields : [
			 new Ext.grid.CheckboxSelectionModel({editable:false}),
			{			id:'rowid',
						header:'ID',
						dataIndex:'rowid',
						align:'center',
						hidden:true
					},{
						id:'year',
						header:'年度 ',
						width:60,
						editable:false,
						allowBlank:false,
						align:'left',
						dataIndex:'year'

					},{
						id:'Title',
						header:'项目名称',
						width:180,
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
					}, /* {
						id:'SubUser',
						header:'申请人',
						width:60,
						editable:false,
						align:'left',
						dataIndex:'SubUser'

					},{
						id:'DeptDr',
						header:'申请人科室',
						editable:false,
						width:120,
						align:'left',
						dataIndex:'DeptDr',
						renderer: function formatQtip(data,metadata)
						{
							var title = "";
							var tip = data;
							metadata.attr = 'ext:qtitle="' + title + '"' + 'ext:qtip="' + tip + '"';
							return data;
						}
					}, */{
						id:'SubDate',
						header:'申请时间',
						editable:false,
						width:80,
						align:'left',
						dataIndex:'SubDate'
					},{
						id:'DeptDr',
						header:'审核人科室',
						editable:false,
						width:100,
						hidden:true,
						align:'left',
						dataIndex:'DeptDr'
					},{
						id:'DataStatus',
						header:'提交状态',
						width:100,
						editable:false,
						align:'left',
						hidden:true,
						dataIndex:'DataStatus'
					},{
						id:'subStatus',
						header:'是否已提交至科研处',
						width:120,
						editable:false,
						align:'left',
						//hidden:true,
						dataIndex:'DataStatus'
					},{
						id:'IsGraduate',
						header:'是否伦理审核',
						width:80,
						editable:false,
						align:'left',
						hidden:false,
						dataIndex:'IsGraduate'
					},{
						id:'ExpertName',
						header:'专业审核人',
						width:80,
						editable:false,
						align:'left',
						dataIndex:'ExpertName'
					},{
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
						id:'Index1score',
						header:'目的明确性',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index1score'
					},{
						id:'Index2score',
						header:'文献掌握程度',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index2score'
					}
					,{
						id:'Index3score',
						header:'设计科学性',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index3score'
					}
					,{
						id:'Index4score',
						header:'课题创新性',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index4score'
					}
					,{
						id:'Index5score',
						header:'理论可行性',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index5score'
					}
					,{
						id:'Index6score',
						header:'技术可行性',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index6score'
					}
					,{
						id:'Index7score',
						header:'人员可行性',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index7score'
					}
					,{
						id:'Index8score',
						header:'外部条件可行性',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index8score'
					}
					,{
						id:'Index9score',
						header:'预算合理性',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index9score'
					}
					,{
						id:'Index10score',
						header:'课题逻辑清晰度',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index10score'
					}
					,{
						id:'Index11score',
						header:'课题完成预期',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index11score'
					}
					,{
						id:'Index12score',
						header:'前期工作基础',
						width:180,
						editable:false,
						hidden:true,
						align:'left',
						dataIndex:'Index12score'
					},{	id:'prjrowid',
						header:'prjrowid',
						dataIndex:'prjrowid',
						align:'center',
						hidden:true
					}
//					,{
//				header:'专业审核结果',
//					text:"查看",
//					width:130,
//					align:"center",
//					renderer:function(value,cellmeta){
//					var returnStr = "<INPUT type='button' value='查看'>";
//					return returnStr;
//					}
					
					]
		});

var ListButton = new Ext.Toolbar.Button({
	text: '评分',  
    iconCls:'pencil',
    handler:function(){
	var rowObj = itemGrid.getSelectionModel().getSelections();
			var len = rowObj.length; 
			if(len < 1)
			{
				Ext.Msg.show({title:'提示',msg:'请选择需要打分项目的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
				return;
			}
			for(var j= 0; j < len; j++){
			if(rowObj[j].get("DataStatus")!='未提交')
	       {
		      Ext.Msg.show({title:'注意',msg:'数据已提交',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	       }else{
				
				var prjrowid = rowObj[0].get("rowid");	
				editFun(prjrowid);
				}
			}
			}
});
var AuditButton = new Ext.Toolbar.Button({
	text: '提交至科研处',  
    iconCls:'pencil',
    handler:function(){
	//定义并初始化行对象
	var usercode = session['LOGON.USERCODE'];
	var rowObj=itemGrid.getSelectionModel().getSelections();
	//定义并初始化行对象长度变量
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要提交的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	for(var j= 0; j< len; j++){
	     //alert(rowObj[j].get("RewardAmount"))
	   if(rowObj[j].get("DataStatus")!='未提交')
	 {
		      Ext.Msg.show({title:'注意',msg:'数据已提交',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		       return;
	 }
	 
	}
	function handler(id){
			if(id=="yes"){
				for(var i = 0; i < len; i++){
					    Ext.Ajax.request({
						url:projUrl+'?action=sub&rowid='+rowObj[i].get("rowid"),
						waitMsg:'审核中...',
						failure: function(result, request){
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},   
						success: function(result, request){			
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true'){
								Ext.Msg.show({title:'注意',msg:'提交成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								itemGrid.load({params:{start:0, limit:25,usercode:usercode}});								
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
		Ext.MessageBox.confirm('提示','确实要提交所选记录吗?提交后不能修改',handler);
    }
});



	itemGrid.addButton('-');
	itemGrid.addButton(ListButton);
	itemGrid.addButton('-');
	itemGrid.addButton(AuditButton);
	

  itemGrid.btnResetHide(); 	//隐藏重置按钮
  itemGrid.btnDeleteHide(); //隐藏删除按钮
  itemGrid.btnPrintHide(); 	//隐藏打印按钮
  itemGrid.btnAddHide(); 	//隐藏添加按钮
  itemGrid.btnSaveHide(); 	//隐藏保存按钮
  itemGrid.load({params:{start:0, limit:12, usercode:usercode}});
 
  
 // 单击gird的单元格事件
itemGrid.on('cellclick', function(g, rowIndex, columnIndex, e) {
    
	/*
	var records = itemGrid.getSelectionModel().getSelections();
	
	var patenttype = records[0].get("PatentTypeList");
	//alert(patenttype);
	
	 
	if(patenttype!="发明专利")
	{
	 
	  Ext.getCmp("download").disable();//设置为不可用
	  return;
	}
	else{
		
	  Ext.getCmp("download").enable();//设置为可用
	  return;
	}*/
}); 
 


//uploadMainFun(itemGrid,'rowid','P005',24);
downloadMainFun(itemGrid,'prjrowid','P011',12);