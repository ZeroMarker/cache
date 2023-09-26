function getCenterListTbar()
{
    //adit by loo on 2010-7-12 修改历次模板的工具栏，与唯一模板保持风格一致
	var tbar = new Ext.Toolbar({border: false,
	items:[ 
		'-',
		{id:'chkSelectAll', boxLabel:'只显示< ' + _PageTitle + ' >', xtype: 'checkbox',checked: true, listeners: {'check': function(checkbox, isChecked){_IsShowAll = isChecked?'N':'Y'; ajaxAction();}}}, 
		'->','-', 
		{id:'btnNew',text:'新建',handleMouseEvents: false, cls: 'x-btn-text-icon', icon:'../scripts/epr/Pics/new.gif',pressed:false,handler:newList},
		'-',
		{ id: 'btnPreview', text: '预览', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/preview.gif', pressed: false, handler: preview },
		'-',
		{id:'btnPrint',text:'打印',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/print.gif',pressed:false,handler:print},
		'-',
		{id:'btnRefresh',text:'刷新',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/upda.gif',pressed:false,handler:refresh},
		'-',
		{id:'btnSlttemplate',text:'选择模板',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/template.gif',pressed:false,handler:sltTemplate},	
	    '-',
	    {id:'btnChiefCheck',text:'主任医师审核',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/chief.gif',pressed:false,handler:chiefCheck},
		{id:'btnAttendingCheck',text:'主治医师审核',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/attending.gif',pressed:false,handler:attendingCheck},
		'-',
		{id:'btnExport',text:'导出',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/export.gif',pressed:false,handler:exportRecord},
		'-'
	]});
	return tbar;
}

/*  //adit by loo on 2010-7-12 修改历次模板的工具栏，与唯一模板保持风格一致
function getCenterListBbar()
{
	var bbar = new Ext.Toolbar({border: false,
	items:[
		'->','-',	
		{id:'btnPrint',text:'打印',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/print.gif',pressed:false,handler:print},
		'-',
		{id:'btnRefresh',text:'刷新',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/upda.gif',pressed:false,handler:refresh},
		'-',
		{id:'btnChiefCheck',text:'主任医师审核',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/chief.gif',pressed:false,handler:chiefCheck},
		{id:'btnAttendingCheck',text:'主治医师审核',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/attending.gif',pressed:false,handler:attendingCheck}, 			
	'-']});
	return bbar;
}
*/

var VPCenterList = new Ext.Viewport(
        {
            id: 'VPCenterList',
            shim: false,
	    	hideBorders: true,
            animCollapse: false,
            constrainHeader: true, 
            margins:'0 0 0 0',           
            layout: 'border',                     	    
            items: [{ 
						border: false,
                        region: 'north', 
						margins: {left:0, top: 0, right:0, bottom: 3},	    
						split: true,
						height: 27,
						layout: 'fit',
						border: false,                        
						split: false, 
						collapsible: false,
						items: getCenterListTbar()                        
                   },
                   { 
						id: 'centerListTab',
						border: false,
						region: 'center',
						layout: 'form',
						html: '<div style="width:100%;height:100%;OVERFLOW-y:auto;" id= "EPRList"></div><div id = "statusbar"></div>'
				
                   }
                   /*,{ 
						border: false,
						region: 'south',
						layout: 'fit',
						height: 27,
						margins: {left:0, top: 3, right:0, bottom: 0},
						border: false,                        
						split: false, 
						collapsible: false, 
						items: getCenterListBbar()
                   }*/ //adit by loo on 2010-7-12 修改历次模板的工具栏，与唯一模板保持风格一致
               ]
		});
		
//add by loo on 2010-7-27
//历次模板新建(F2)、打印(F8)操作添加快捷键
var map = new Ext.KeyMap(Ext.getDoc(), {
	key: 113,	// F2
	fn: function()
	{
		//Ext.Msg.alert('KEY MAP', 'tree页面You just hit F7');
		newList();
	},
	scope: this
}); 

map.addBinding({
	key: 120,	//F9
	fn: function()
		{
			print();
		},
	scope: this
});


