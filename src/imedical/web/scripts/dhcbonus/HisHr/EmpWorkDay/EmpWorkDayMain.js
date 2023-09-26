
var EmpDeptUrl="dhc.bonus.hishr.empworkdayexe.csp"

var DeptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});

DeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:EmpDeptUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptField').getRawValue()),method:'POST'})
		});

var DeptField = new Ext.form.ComboBox({
	id: 'DeptField',
	store : DeptDs,
	displayField : 'name',
	valueField : 'code',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 200,
	listWidth : 220,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});

var sDeptDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['code','name'])
});

sDeptDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
	
		url:EmpDeptUrl+'?action=GetDept&str='+encodeURIComponent(Ext.getCmp('DeptComb').getRawValue()),method:'POST'})
		});

var DeptComb = new Ext.form.ComboBox({
	id: 'DeptComb',
	store : sDeptDs,
	displayField : 'name',
	valueField : 'code',
	typeAhead : true,
	forceSelection : true,
	triggerAction : 'all',
	emptyText : '',
	width : 200,
	listWidth : 220,
	pageSize : 10,
	minChars : 1,
	columnWidth : .1,
	selectOnFocus : true
});
// 人员编码、人员姓名
var EmpNameField = new Ext.form.TextField({
	id: 'EmpNameField',
	fieldLabel: '人员姓名',
	width:100,
	//listWidth : 245,	
	triggerAction: 'all',
	emptyText:'编码或名称',
	name: 'EmpNameField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	columnWidth:.085,
	editable:true
});

// 享受系数
var BonusRateField = new Ext.form.NumberField({
	id: 'BonusRateField',
	fieldLabel: '享受系数',
	width:100,
	//listWidth : 245,	
	triggerAction: 'all',
	emptyText:'',
	name: 'BonusRateField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	columnWidth:.12,
	editable:true
});


/////////////////////////////////////// 采集年度 ////////////////////////////////////////
var cycleDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'BonusYear'])
		});

cycleDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : EmpDeptUrl+'?action=yearlist&topCount=5&orderby=Desc',
						method : 'POST'
					});
		});		
var YearComb =new Ext.form.ComboBox({
			id:'YearComb',
			store : cycleDs,
			displayField : 'BonusYear',
			valueField : 'BonusYear',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '年度',
			width : 100,
			listWidth : 100,
			//pageSize : 10,
			minChars : 1,
			columnWidth : .12,
			selectOnFocus : true
		});

//////////////////////////////////////// 采集月份 //////////////////////////////////////
var MonthComb = new Ext.form.ComboBox({	
			id:'MonthComb',											
			width:100,
			listWidth : 100,
			store : new Ext.data.ArrayStore({
					fields : ['month', 'vmonth'],
					data : [['01','1月'],['02','2月'],['03','3月'],['04','4月'],['05','5月'],['06','6月'],['07','7月'],['08','8月'],['09','9月'],['10','10月'],['11','11月'],['12','12月']]
				}),
			displayField : 'vmonth',
			valueField : 'month',
			typeAhead : true,
			mode : 'local',
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '月份',
			minChars : 1,
			columnWidth : .1,
			selectOnFocus:'true'
});


//新增导出功能
/*var _Excel = new Herp.Excel(
    {
	 url:ServletURL,
     sql:'SELECT UnitDepts_code,UnitDepts_name,UnitDepts_remark,UnitDepts_start,UnitDepts_stop,UnitDepts_active,UnitDepts_unitDr->Units_name FROM dhc_ca_cache_data.UnitDepts WHERE UnitDepts_unitDr=? ORDER BY UnitDepts_code ',
     fileName:"弋矶山医院人员考勤信息"     
    });*/

var exportButton = new Ext.Toolbar.Button({
	id:'exportButton',
    text: '考勤导出',
    tooltip: '导出数据',
    iconCls: 'option',
    handler: function() { 
    
        function handler(id){
			if(id=="yes"){
		var year=YearComb.getValue();
		var month=MonthComb.getValue();	
		if((year!="") && (month!="")){
		var yearmonth = year+month;
		_Excel.download(yearmonth); 
		}else{
			Ext.Msg.show({title : '注意',
						  msg : '请选择导出考勤的年份,月份',
						  buttons : Ext.Msg.OK,
						  icon : Ext.MessageBox.WARNING
				});
			return;
		}
			}
			else{
				return;
				}
        }
        Ext.MessageBox.confirm('提示','确实要导出该月记录吗?',handler);
	}
});

var InsertTargetButton = new Ext.Toolbar.Button({
	id:'InsertTargetButton',
	text: '考勤审核',
	tooltip: '考勤审核',
	iconCls: 'option',
	handler: function(){
		
	    var year=YearComb.getValue();
		var month=MonthComb.getValue();
		if(year==""||month=="")
		{
			Ext.Msg.show({title : '注意',
					  msg : '请选择采集期间年份,月份',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
			});
		
			return;
		}
		var mon=month-0;
		var month="M"+month;
		
		
		
		function handler(id){
			if(id=="yes")
			{
		
	    Ext.Ajax.request({
				url :EmpDeptUrl+'?action=Submmit&year='+year+'&month='+month,
				waitMsg : '审核中...',
				failure : function(result, request) {
							Ext.Msg.show({
									title : '错误',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
									Ext.MessageBox.alert('提示','审核完成');
									
							} 
							else if(jsonData.success == 'Error')
							{					
								Ext.Msg.show({title : '注意',
					            msg : year+"年"+mon+'月'+'数据未采集,请先采集',
					            buttons : Ext.Msg.OK,
					            icon : Ext.MessageBox.WARNING
			});
						    }
							else {
									var message = "SQLErr: "+ jsonData.info;
									Ext.Msg.show({
											title : '错误',
											msg : message,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
				},
				scope : this
				
		});
			}
			else
			{
			   return;	
			}
		}
	    Ext.MessageBox.confirm('提示','确定要审核该月记录吗?',handler);
	}
});

var _Excel = new Herp.Excel(
    {
	
	 url:'http://172.16.100.52:8081',
     sql:'SELECT BonusYear as 年份,BonusPeriod as 月份,FlexStrField2 as 杭创代码,FlexStrField4 as 老代码,DeptCode as 东华代码,DeptName as 科室名称,EmpCardID as 员工编码,EmpName as 员工姓名,WorkDays as 在班天数,SharyRate as 享奖系数,UpdateDate as 更新日期 FROM dhc_bonus_extend_yjs.EmpWorkDay   WHERE BonusYear||right(BonusPeriod,2)=? ORDER BY DeptCode',
     fileName:"弋矶山医院人员考勤信息"
    });
	
var findButton = new Ext.Toolbar.Button({
	id:'findbutton',
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
		var year=YearComb.getValue();
		var month=MonthComb.getValue();
		var Dept=DeptComb.getValue();
		var person=EmpNameField.getValue();
		var bonusRate=BonusRateField.getValue();
		itemGrid.load({params:{start:0,limit:25,year:year,month:month,Dept:Dept,person:person,bonusRate:bonusRate}});
	}
});

var collectButton = new Ext.Toolbar.Button({
	id:'collectButton',
	text: '考勤采集',
	tooltip: '考勤采集',
	iconCls: 'add',
	handler: function(){

		var year=YearComb.getValue();
		var month=MonthComb.getValue();
		//alert(year+"^"+month);
		
		if(year==""||month=="")
		{
			Ext.Msg.show({title : '注意',
					  msg : '请选择采集期间年份,月份',
					  buttons : Ext.Msg.OK,
					  icon : Ext.MessageBox.WARNING
			});
		
			return;
		}
		
		function handler(id){
			if(id=="yes")
			{
	    Ext.Ajax.request({
				url : EmpDeptUrl+'?action=gather&year='+year+'&month='+month,
				waitMsg : '采集中...',
				failure : function(result, request) {
							Ext.Msg.show({
									title : '错误',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
							});
				},
				success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
									Ext.MessageBox.alert('提示','数据采集完成');
									itemGrid.load({params:{start:0,limit:25,year:year,month:month}});
							} else {
									var message = "SQLErr: "+ jsonData.info;
									Ext.Msg.show({
											title : '错误',
											msg : message,
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							}
				},
				scope : this
				
		});
			}
			else
			{
				return;
			}
		}
		Ext.MessageBox.confirm('提示','确定要采集该月记录吗?',handler);
	    
	}
});


var queryPanel = new Ext.FormPanel({
	height : 80,
	region : 'north',
	frame : true,

	defaults : {
		bodyStyle : 'padding:5px'
	},
	items : [ {
		columnWidth : 1,
		xtype : 'panel',
		layout : "column",
		items : [

		{   	xtype : 'displayfield',
					value : '所属年度:',
					columnWidth : .067
				}
				, YearComb
				, {
					xtype : 'displayfield',
					value : ' 所属月份:',
					columnWidth : .067
				}
				, MonthComb
				, {
					xtype : 'displayfield',
					//value : '人员学历:',
					columnWidth : .03
				}
				,collectButton, {
					xtype : 'displayfield',
					//value : '人员学历:',
					columnWidth : .03
				},InsertTargetButton,{
					xtype : 'displayfield',
					//value : '人员学历:',
					columnWidth : .03
				},exportButton]
	},
	{
		xtype: 'panel',
		columnWidth : 1,
		layout:"column",
		items: [
				{
					xtype : 'displayfield',
					value : '科室名称:',
					columnWidth : .056
				}
				,DeptComb
				,{
					xtype : 'displayfield',
					value : '人员姓名:',
					columnWidth : .056
				}
				, EmpNameField
				,{
					xtype : 'displayfield',
					columnWidth : .023
				},{
					xtype : 'displayfield',
					value : '享奖系数:',
					columnWidth : .05
				},
				BonusRateField
				,{
					xtype : 'displayfield',
					columnWidth : .023
				}
				, findButton]
	}
		]
		
	});
var itemGrid = new dhc.herp.Grid({
        width: 400,
        //edit:false,                   //是否可编辑
        readerModel:'remote',
        region: 'center',
        url: 'dhc.bonus.hishr.empworkdayexe.csp',
		atLoad : true, // 是否自动刷新
		loadmask:true,
		//tbar:['年度:',YearComb,'-','月份:',MonthComb,'-',collectButton,'-',findButton],
		//tbar:[exportButton,'','-',''],
        fields: [{
	        editable:false,
            header: 'ID',
            dataIndex: 'rowid',
			sortable:true,	
			edit:false,
            hidden: true
        },{
	        editable:false,
            id:'BonusYear',
            header: '年度',
			allowBlank: true,
			sortable:true,	
			width:70,
            dataIndex: 'BonusYear'
        },{
	        editable:false,
            id:'BonusPeriod',
            header: '月份',
			allowBlank: true,
			sortable:true,	
			width:70,
            dataIndex: 'BonusPeriod'
        },{
	        editable:false,
            id:'DeptCode',
            header: '科室编码',
			allowBlank: true,
			sortable:true,
			hidden:true,	
			width:120,
            dataIndex: 'DeptCode'	
        },{
            id:'DeptName',
            header: '科室名称',
			allowBlank: true,
			editable:true,
			sortable:true,	
			width:135,
            dataIndex: 'DeptName',
			type:DeptField
        },{
	        editable:false,
            id:'EmpCardID',
            header: '人员编码',
			sortable:true,	
			allowBlank: true,
			width:100,
            dataIndex: 'EmpCardID'
        },{
	        editable:false,
            id:'EmpName',
            header: '人员名称',
			allowBlank: true,
			sortable:true,	
			width:100,
            dataIndex: 'EmpName'
        },{
			editable:false,
            id:'WorkDays',
            header: '在班天数',
			allowBlank: true,
			sortable:true,	
			width:120,
			align:'right',
            dataIndex: 'WorkDays'
        },{
	        editable:false,
            id:'SharyRate',
            header: '享奖系数',
			allowBlank: true,
			sortable:true,	
			width:90,
			align:'right',
            dataIndex: 'SharyRate'
        },{
	        editable:false,
            id:'UpdateDate',
            header: '更新日期',
			allowBlank: true,
			sortable:true,	
			width:150,
			align:'right',
            dataIndex: 'UpdateDate'
        },{
		     id:'IsCheck',
		     header: '审核状态',
		     allowBlank: true,
		     align:'left',
		     width:60,
		     editable:false,
		     dataIndex: 'IsCheck'
		}] 
});

    
	itemGrid.btnAddHide() 	//隐藏增加按钮
	//itemGrid.btnSaveHide() 	//隐藏保存按钮
	itemGrid.btnResetHide() 	//隐藏重置按钮
	itemGrid.btnDeleteHide() //隐藏删除按钮
	itemGrid.btnPrintHide() 	//隐藏打印按钮
		