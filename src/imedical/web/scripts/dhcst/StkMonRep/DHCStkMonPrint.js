// /名称: 月报打印
// /描述: 月报打印界面-润乾
// /编写者：yunhaibao
// /编写日期: 2015.12.16
Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var HospId=session['LOGON.HOSPID'];
	var gIncid=""	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var Url='dhcst.stkmonaction.csp?';
	var today=new Date();
	var growid=""
	var activeTabtmp=""

	var PhaLoc = new Ext.ux.LocComboBox({
		id : 'PhaLoc',
		name : 'PhaLoc',
		fieldLabel : $g('科室'),
		anchor : '',
		width:200,
		groupId:gGroupId
	});


	var StYear=new Ext.form.TextField({
		fieldLabel:$g('开始月份'),
		id:'StYear',
		name:'StYear',
		anchor:'90%',
		width:80,
		value:today.getFullYear()
	});
	var StMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'StMonth',
		name:'StMonth',
		anchor:'90%',
		width:80,
		value:((today.getMonth()-10)<=0?1:(today.getMonth()-10))
	});
	
	var EdYear=new Ext.form.TextField({
		fieldLabel:$g('结束月份'),
		id:'EdYear',
		name:'EdYear',
		anchor:'90%',
		width:80,
		value:today.getFullYear()
	});
	
	var EdMonth=new Ext.form.TextField({
		fieldLabel:'',
		id:'EdMonth',
		name:'EdMonth',
		anchor:'90%',
		width:80,
		value:(today.getMonth()+1)
	});
	var priceflag = new Ext.form.Checkbox({
	       boxLabel : $g('按售价'),
	          id : 'priceflag',
	          name : 'priceflag',
	          anchor : '90%',
	       checked : false
	        });
	//根据类组,库存分类,药品名称的变化,  过滤月报明细
	function MonRepFilter(){
		var record=MainGrid.getSelectionModel().getSelected();
		if(record){
			var rowid=record.get("smRowid");
			var locdesc=record.get("locDesc");
			var month=record.get("mon");
			var sd=record.get("frDate");
			var ed=record.get("toDate");
			var priceflag=Ext.getCmp('priceflag').getValue();
			var sign=""
			var MonthType=""
			if (HospId==1)
			{
				MonthType=$g("单位:元")
				sign=$g("科室主任:                           分管主任:                           部门负责人:                 "	)
			}  
			else
			{
				sign=$g("科室负责人:                          采购人:                          保管人:                          复核人:                          ")	
				if (priceflag==true) {MonthType=$g("价格类别:售价")}
				else {MonthType=$g("价格类别:进价")}
			}
			growid=rowid
			var reportFrame=document.getElementById("frameReport");
			var p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_StkMonReportPrint.raq&monid='+growid+'&locdesc='+locdesc+'&month='+month+'&cacuflag='+priceflag+'&startdate='+sd+'&enddate='+ed+'&sign='+sign+'&HospName='+App_LogonHospDesc+'&MonthType='+MonthType;
			//alert(p_URL)
			reportFrame.src=p_URL;
		}
	}
		// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : $g('查询'),
				tooltip : $g('点击查询'),
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {  
					Query();
				}
			});	
//查询月报
function Query(){
	var stYear=Ext.getCmp('StYear').getValue();
	var stMonth=Ext.getCmp('StMonth').getValue();
	var stDate=stYear+'-'+stMonth+'-'+'01';
	var edYear=Ext.getCmp('EdYear').getValue();
	var edMonth=Ext.getCmp('EdMonth').getValue();
	var edDate=edYear+'-'+edMonth+'-'+'01';
	var Loc=Ext.getCmp('PhaLoc').getValue();
	MainStore.removeAll();
	MainStore.load({params:{LocId:Loc,StartDate:stDate,EndDate:edDate}});
}

var MainStore=new Ext.data.JsonStore({
	auroDestroy:true,
	url:Url+"actiontype=Query",
	sotreId:'MainStore',
	root:'rows',
	totalProperty:'results',
	idProperty:'smRowid',
	fields:['smRowid','locDesc','mon','frDate','frTime','toDate','toTime']
});
var MonthCoverGridPagingToolbar = new Ext.PagingToolbar({
	store:MainStore,
	pageSize:1000,
	displayInfo:true,
	displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
	emptyMsg:$g("没有记录")
	});
var MainGrid=new Ext.grid.GridPanel({
	id:'MainGrid',
	title:$g('月报'),
	store:MainStore,
	cm:new Ext.grid.ColumnModel([{
		header:'Rowid',
		dataIndex:'smRowid',
		width:100,
		align:'left',
		hidden:true
	},{
		header:$g('科室'),
		dataIndex:'locDesc',
		width:150,
		align:'left',
		sortable:true
	},{
		header:$g('月份'),
		dataIndex:'mon',
		width:65,
		align:'left',
		sortable:true
	},{
		header:$g('月报起始日期'),
		dataIndex:'frDate',
		width:130,
		align:'left',
		sortable:true,
		renderer:function(value,metaData,record,rowIndex,colIndex,store){
			var StDateTime=value+" "+record.get('frTime');
			return StDateTime;
		}
	},{
		header:$g('月报截止日期'),
		dataIndex:'toDate',
		width:130,
		align:'left',
		sortable:true,
		renderer:function(value,metaData,record,rowIndex,colIndex,store){
			var EdDateTime=value+" "+record.get('toTime');
			return EdDateTime;
		}
	}]),
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	autoScroll:true,
	bbar:MonthCoverGridPagingToolbar
})

MainGrid.addListener('rowclick',function(grid,rowindex,e){
	MonRepFilter();

});



	var reportPanel=new Ext.Panel({
		//autoScroll:true,
		layout:'fit',
		html:'<iframe id="frameReport" height="100%" width="100%" style="border:none" src='+DHCSTBlankBackGround+'>'
	})
     var form = new Ext.form.FormPanel({
        labelwidth : 30,
        width : 400,
        labelAlign : 'right',
        frame : true,
        autoScroll : true,
		tbar : [SearchBT],
        bodyStyle : 'padding:10px 0px 0px 0px;',                                
        items : [PhaLoc,
        {
	        		xtype: 'compositefield',
    				items : [
					StYear,
					{ xtype: 'displayfield', value: $g('年')},
					StMonth,
					{ xtype: 'displayfield', value: $g('月')}]
	        
	        },
        {
	        		xtype: 'compositefield',
    				items : [
					EdYear,
					{ xtype: 'displayfield', value: $g('年')},
					EdMonth,
					{ xtype: 'displayfield', value: $g('月')}]
	        
	        },	priceflag
	        ]           
    });
	var myPanel = new Ext.Viewport({
		layout : 'border',
		items : [ {
			region:'west',
			width:350,
			title:$g('月报查询打印'),
			collapsible:true,
			autoScroll : true,
			layout:'border',
			split: true,
			minSize:50,
			maxSize:600, 
			items: [{
	                region: 'north',
	                split: false,
        			height: 175,                			
	                layout: 'fit', // specify layout manager for items
	                items: form 				               
	            },{
		            //autoScroll : true,
                	region:'center',
                	layout:'fit',
                	items:MainGrid 
                }]   
			
		},{ 
			region:'center',
			layout:'fit',
			items:reportPanel 
		}]
	}); 
	
   
}) 