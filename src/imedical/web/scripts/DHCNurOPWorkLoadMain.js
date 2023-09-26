/**
 * *DHCNurOPWorkLoadMain.js
 * *Creator:liulei
 * *CreatDate:2010-07-15
 * *Description:门诊输液查询
 */
Ext.onReady(function(){
	new Ext.Viewport({
		layout:'border',
		items:[
		{
			region:'west',
			xtype:'treepanel',
			title:'功能菜单',
			collapsible:true,
			width:'120',
			split:true,
			loader: new Ext.tree.TreeLoader(),  
			root:new Ext.tree.AsyncTreeNode({
				id:'InfusionTree',
				expanded:true,
				children:[
				{
					id:'NurOPEexec',
					text:'护士执行',
					hidden:true,
					leaf:true
				},
				{
					id:'SeatMap',
					text:'门诊座位图',
					hidden:true,
					leaf:true
				},
				{
					id:'WorkLoad',
					text:'工作量统计',
					leaf:true
				},
				{
					id:'Infusion',
					text:'病人输液查询',
					//hidden:true,
					leaf:true
				},
				{
					id:'Drug',
					text:'监测药物维护',
					hidden:true,
					leaf:true
				}
				]
			}),
			lines:true,
			rootVisible:false,
			listeners:{
				click:function(node,event){
					if (node.id=="NurOPEexec")
					{
						Ext.getCmp('InfusionTab').setActiveTab("NurOPEexec");
					}else if(node.id=="SeatMap"){
						var objSeatMap=Ext.getCmp('InfusionTab').findById('SeatMap');
						if (objSeatMap!=null){
							Ext.getCmp('InfusionTab').setActiveTab('SeatMap');
						}else{
							addTab('门诊座位图','SeatMap','dhcnursyroomseatmap.csp');
						}
					}else if(node.id=="WorkLoad"){
						var objWorkLoad=Ext.getCmp('InfusionTab').findById('WorkLoad');
						if (objWorkLoad!=null){
							Ext.getCmp('InfusionTab').setActiveTab('WorkLoad');
						}else{
							addTab('工作量统计','WorkLoad','dhcifworkload.csp');
						}
					}else if(node.id=="Infusion"){
						var objInfusion=Ext.getCmp('InfusionTab').findById('Infusion');
						if (objInfusion!=null){
							Ext.getCmp('InfusionTab').setActiveTab('Infusion');
						}else{
							addTab('病人输液查询','Infusion','dhcnuroppatinfudetails.csp');
						}
					}else{
						var objDrug=Ext.getCmp('InfusionTab').findById('Drug');
						if (objDrug!=null){
							Ext.getCmp('InfusionTab').setActiveTab("Drug");
						}else{
							addTab('监测药物维护','Drug','http://www.sina.com');
						}
					}
				}
			}
        },
		{
			region:'center',
			xtype:'tabpanel',
			activeTab:0,
			enableTabScroll:true,
			resizeTabs:true,
			minTabWidth:75,
			border:false,
			id:'InfusionTab',
			items:[{
				//title:'护士执行',
				//id:'NurOPEexec',
				//html: '<iframe scrolling="auto" frameborder="0"  src="dhcnuropexec.csp" width="100%" height="100%"></iframe>'  
				title: '病人输液查询',
				id: 'Infusion',
				html: '<iframe scrolling="auto" frameborder="0"  src="dhcnuroppatinfudetails.csp" width="100%" height="100%"></iframe>'
			}]
		}
		],
		renderTo : Ext.getBody()   
	});
	
	function addTab(title,id,targeurl)
	{
		Ext.getCmp('InfusionTab').add({
			title:title,
			id:id,
			html:'<iframe src="'+ targeurl+ '" width="100%" height="100%"/>',
			closable : true
			}).show();
	}
});