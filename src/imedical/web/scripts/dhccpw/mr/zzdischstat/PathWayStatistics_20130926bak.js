/*!
 * Ext JS Library 3.1.1
 * Copyright(c) 2006-2010 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
PathWayStatistics=function(){
		this.StaStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
				url:ExtToolSetting.RunQueryPageURL,
				timeout:180000      //Add By Niucaicai 2011-08-10  加载超时限制3分钟
		}));
		
		this.StaStore=new Ext.data.Store({
				proxy:this.StaStoreProxy,
				reader:new Ext.data.JsonReader({
						root:'record',
						totalProperty:'total',
						idProperty:'CtRowid'
				},
				[
						{name:'CtRowid',mapping:'CtRowid'},
						{name:'CtDesc',mapping:'CtDesc'},
						{name:'CTLOCNum',mapping:'CTLOCNum'},
						{name:'pathWayPerson',mapping:'pathWayPerson'},
						{name:'pathWayCtlocPercent',mapping:'pathWayCtlocPercent'},
						{name:'CTLOPercent',mapping:'CTLOPercent'},
						{name:'pathWayPercent',mapping:'pathWayPercent'},
						{name:'pathWayNum',mapping:'pathWayNum'},
						{name:'CTLOCDayAverage',mapping:'CTLOCDayAverage'},
						{name:'CTLOCConstAverage',mapping:'CTLOCConstAverage'},
						{name:'pathDayAverage',mapping:'pathDayAverage'},
						{name:'pathConstAverage',mapping:'pathConstAverage'}
				])
		});
	
		this.StaGrid=new Ext.grid.GridPanel({
				id:	'StaGrid',
				store:this.StaStore,
				region:'center',
				buttonAlign:'center',
				viewConfig: {forceFit:true,
						getRowClass : function(record,rowIndex,rowParams,store){   
                   if(record.get('pathWayPerson')){
                   		if(record.get('pathWayPerson')!=0){
                   				return 'x-grid-record'
                   		}	
                   }      
                }   		
				},
				loadMask:true,
				columns:[
							{header:'科室名称',dataIndex:'CtDesc',sortable:true},
							{header:'出院人数',dataIndex:'CTLOCNum',sortable:true},
							{header:'入径人数',dataIndex:'pathWayPerson',sortable:true},
							{header:'入径率',dataIndex:'pathWayCtlocPercent',sortable:true},
							{header:'出院人数比',dataIndex:'CTLOPercent',sortable:true},
							{header:'入径人数比',dataIndex:'pathWayPercent',sortable:true},
							{header:'路径数',dataIndex:'pathWayNum',sortable:true},
							{header:'平均住院日',dataIndex:'CTLOCDayAverage',sortable:true},
							{header:'平均费用',dataIndex:'CTLOCConstAverage',sortable:true},
							{header:'入径平均住院日',dataIndex:'pathDayAverage',sortable:true},
							{header:'入径平均费用',dataIndex:'pathConstAverage',sortable:true}
				]
		});
		this.panel1=new Ext.Panel({
				id:'panel1',
				region:'north',
				title:'出院患者路径统计',
				frame:true,
				layout:'form',
				height:100,
				items:[
							{
									xtype:'label',
									width:1200,
									height:20
							},
							{		xtype:"panel",
									layout:'column',
									items:[
									{
											xtype:'label',
											html:"&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>开始日期：</font>"
									},
									{
											xtype:'datefield',
											id:'StartDate',
											fieldLabel:'开始日期',
											value:new Date(),
											validateOnBlur:false,
											maxValue:new Date(),
											format:'Y-m-d',
											width:200
									},
									{
											xtype:'label',
											height:40,
											html:"&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>结束日期：</font>"	
									},
									{
											xtype:'datefield',
											id:'EndDate',
											fieldLabel:'结束日期',
											value:new Date(),
											validateOnBlur:false,
											maxValue:new Date(),
											format:'Y-m-d',
											width:200
									},
									{
											xtype:'label',
											width:50	
									},
									{
											xtype:'button',
											id:'StaFind',
											text:' 查 询 ',
											iconCls:'icon-find'
							}]
						}
				]
		});
		PathWayStatistics.superclass.constructor.call(this,{
				id:'StaViewMain',
				layout:'border',
				renderTo:document.body,
				items:[
						this.StaGrid,
						this.panel1
				]
		});
		//添加监听事件
		this.StaStoreProxy.on('beforeload',function(objProxy,param){
				param.ClassName='web.DHCCPW.MR.ClinPathWaysStat';
				param.QueryName='QryDischStat';
				//param.Arg1='2008-07-25';
				//param.Arg2='2010-07-14';
				//param.ArgCnt=2
		})
		//gridpanel里的双击事件。
		this.StaGrid.on('rowdblclick',this.rowDblclick,this);
		
		Ext.getCmp('StaFind').on('click',this.StaFindClick,this)
		
}
Ext.extend(PathWayStatistics,Ext.Viewport,{
		//查询按钮的单击事件
		StaFindClick:function(){
				var startDate=Ext.getCmp('StartDate');
				if(startDate.getValue()==""){
					alert("请输入开始日期")	
					return
				}
				if(!startDate.validate()){
					return
				}
				startDate=startDate.getValue()
				startDate=startDate.format("Y-m-d");   //开始日期字符串
				var endDate=Ext.getCmp('EndDate');
				if(!endDate.validate()){
					return	
				}
				endDate=endDate.getValue();
				if(endDate==""){
					endDate=new Date();	
				}
				endDate=endDate.format("Y-m-d");        //结束日期字符串
				if(endDate<startDate){
					alert("开始日期不能大于结束日期")	
					return;
				}
				this.StartDate=startDate;
				this.EndDate=endDate;
				this.StaStore.load({params:{Arg1:startDate,Arg2:endDate,ArgCnt:2}});
		},
		//gridpanel里的双击事件。
		rowDblclick:function(){
					var record=this.StaGrid.getSelectionModel().getSelected();
					var CtRowid=record.get('CtRowid');
					var ctDesc=record.get('CtDesc');
					var cTLOCNum=record.get('CTLOCNum');
					var pathWayPerson=record.get('pathWayPerson');
					if(pathWayPerson==0 || pathWayPerson==""){
						return;
					}
					var pathWayNum=record.get('pathWayNum');
					var str="<font color='Royal Blue'>科室</font>："+ctDesc;
					str=str+"&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>出院人数</font>："+cTLOCNum;
					str=str+"&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>入径人数</font>："+pathWayPerson;
					str=str+"&nbsp&nbsp&nbsp&nbsp<font color='Royal Blue'>路径数</font>："+pathWayNum
					this.PathCtLocSta=new PathCtLocSta(this.StartDate,this.EndDate,CtRowid,str);
					this.PathCtLocSta.show();
		},
		afterRender : function(){
        PathWayStatistics.superclass.afterRender.call(this);
        this.el.on('contextmenu', function(e){
            //e.preventDefault();   可以不让页面弹出右键菜单
        });
    }
    
});
Ext.reg('pathWayStatistics', PathWayStatistics);