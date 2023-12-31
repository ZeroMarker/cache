﻿


//创建树形菜单
function getBorwserTree(episodeID)
{
    var Tree = Ext.tree;
    var treeLoader = new Tree.TreeLoader( {dataUrl : "../web.eprajax.browserTree.cls?EpisodeID=" + episodeID});
    //抛出异常时的处理				
	treeLoader.on("loadexception", function(tree, node, response) {
		var obj = response.responseText;
		alert(obj);
	});
    var tree = new Tree.TreePanel({
		rootVisible: true,
		autoScroll:true,
		animate:false,
		//enableDD:true,
		containerScroll:true,
		lines:true, 
		checkModel:'cascade',
		autoHeight:true,
		border:false,
		loader : treeLoader,
		id:"browserTree"
    });
      
    var root = new Tree.AsyncTreeNode( {
		text : '电子病历',
		nodeType: 'async',
		draggable : false,
		id : "RT0"
    });	


    tree.on('click',function(node,event){
		selectNode = node;
    }); 

    tree.setRootNode(root);
    root.expand(); 
    return tree;
}

//创建界面
function createToolBar()
{
	new Ext.Toolbar({renderTo: 'pagetoolbar', items:['-',
		{ id : 'cboEprRecord',listWidth: 170, resizable: false, xtype :'combo', width: 120, readOnly: true, mode: 'local',store: new Ext.data.SimpleStore({ fields:[], data:[[]]}),
			tpl: '<tpl for="."><div id="divTree" style="height: 200px;"><div id="divBrowserTree"></div></div></tpl>',
			valueField: "retrunValue", displayField: "displayText",blankText: '请选择查询条件', 
			emptyText: '请选择查询条件',editable : false, triggerAction : 'all', allowBlank : false},
		{id:'btnConfirm',text:'确定',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/btnConfirm.gif',pressed:false, handler: confirm},	
		'-',	
		{id:'btnSltDate',text:'选择日期......',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/Calendar.png',pressed:false, listeners:{'click': function(){sltDT();}}},
		'-',
		{id:'btnBrower',text:'浏览',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/browser.gif',pressed:false,handler:browser},
		'->',		
		'-',
		' 每次 ',
		{ id : 'cboBrowerCount',xtype:'combo', width : 50, readOnly : true,mode: 'local',
				valueField: 'retrunValue', displayField: 'displayText',editable : false, 
				triggerAction : 'all', allowBlank : false,value: '10',
				store: new Ext.data.SimpleStore
					({
						fields: ['retrunValue', 'displayText'],
						data: [['1', '1'],['3', '3'],['5', '5'],['10', '10'],['30', '30'],['50', '50']]
					})},
		' 条 ',
		'-',		
		{id:'btnPreview',text:'上一页',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/pageupbrowser.gif',pressed:false,handler:prev},
		{id:'btnNext',text:'下一页',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/pagedownbrowser.gif',pressed:false,handler:next},
		'-'
	]});

		

	new Ext.Toolbar({renderTo: 'divDateTimeSelect', items:['-',
		'->',
		{ xtype : 'datefield', id : 'startDate', width : 90, readOnly : false, format : 'Y-m-d', minValue: '1980-01-01' },
		{ xtype : 'timefield', id : 'startTime', width : 55, readOnly : false, format : 'H:00', increment: 60, editable: false, value: '00:00' },	
		' 至 ',
		{ xtype : 'datefield', id : 'endDate', width : 90, readOnly : false, format : 'Y-m-d' },
		{ xtype : 'timefield', id : 'endTime', width : 55, readOnly : false, format : 'H:00', increment: 60, editable: false, value: '23:00' },	
		'-'		
	]});

	//设置日期控件的时间
	if (dateInBed == '1840-12-31')
	{			
		Ext.getCmp('startDate').setValue('1980-01-01');	
	}
	else
	{
		Ext.getCmp('startDate').setValue(dateInBed);	
	}

	if (disBed == '1840-12-31')
	{
		var date = new Date();
		Ext.getCmp('endDate').setValue(date);	
	}
	else
	{
		Ext.getCmp('endDate').setValue(disBed);	
	}

	Ext.getCmp('btnPreview').disable();
	Ext.getCmp('btnNext').disable();		

	Ext.getCmp('cboBrowerCount').on('select', function(combo, record, number){
		Ext.getCmp('btnPreview').disable();
		Ext.getCmp('btnNext').disable();
	});

	Ext.getCmp('cboEprRecord').on('Expand', function(){
		if(!Ext.getCmp('browserTree'))
		{
			getBorwserTree(episodeID).render('divBrowserTree');
			//document.getElementById('divTree').parentElement.parentElement.style.width="170px";
			//document.getElementById('divTree').parentElement.style.width="170px";
		}
		
	});
}

createToolBar();		//创建界面