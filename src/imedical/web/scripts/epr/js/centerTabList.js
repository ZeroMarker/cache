function getCenterListTbar()
{
    //adit by loo on 2010-7-12 修改历次模板的工具栏，与唯一模板保持风格一致
	if (_ShowSubsequentFlag > 0) {
		var tbar = new Ext.Toolbar({ border: false,
			items: [
		'-',
		{ id: 'chkSelectAll', boxLabel: '只显示< ' + _PageTitle + ' >', xtype: 'checkbox', checked: true, listeners: { 'check': function(checkbox, isChecked) { _IsShowAll = isChecked ? 'N' : 'Y'; ajaxAction(); } } },
		'-',
		{ id: 'chkSubsequent', boxLabel: '显示本疗程内病历', xtype: 'checkbox', checked:(_IsShowSubsequent == "Y"), listeners: { 'check': function(checkbox, isChecked) { _IsShowSubsequent = isChecked ? 'Y' : 'N'; ajaxAction(); } } },
		'->', '-',
		{ id: 'btnNew', text: '新建', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/new.gif', pressed: false, handler: newList },
		'-',
		{ id: 'btnPreview', text: '预览', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/preview.gif', pressed: false, handler: preview },
		'-',
		{ id: 'btnPrint', text: '打印', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/print.gif', pressed: false, handler: print },
		'-',
		{ id: 'btnRefresh', text: '刷新', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/upda.gif', pressed: false, handler: refresh },
		'-',
		{ id: 'btnSlttemplate', text: '选择病历', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/template.gif', pressed: false, handler: sltTemplate },
	    '-',
	    { id: 'btnChiefCheck', text: '主任医师审核', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/chief.gif', pressed: false, handler: chiefCheck },
		{ id: 'btnAttendingCheck', text: '主治医师审核', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/attending.gif', pressed: false, handler: attendingCheck },
		'-',
		{ id: 'btnExport', text: '导出', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/export.gif', pressed: false, handler: exportRecord },
		'-'
		]
		});
		return tbar;
	} else {
		var tbar = new Ext.Toolbar({ border: false,
		items: [
		'-',
		{ id: 'chkSelectAll', boxLabel: '只显示< ' + _PageTitle + ' >', xtype: 'checkbox', checked: true, listeners: { 'check': function(checkbox, isChecked) { _IsShowAll = isChecked ? 'N' : 'Y'; ajaxAction(); } } },
		'->', '-',
		{ id: 'btnNew', text: '新建', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/new.gif', pressed: false, handler: newList },
		'-',
		{ id: 'btnPreview', text: '预览', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/preview.gif', pressed: false, handler: preview },
		'-',
		{ id: 'btnPrint', text: '打印', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/print.gif', pressed: false, handler: print },
		'-',
		{ id: 'btnRefresh', text: '刷新', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/upda.gif', pressed: false, handler: refresh },
		'-',
		{ id: 'btnSlttemplate', text: '选择病历', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/template.gif', pressed: false, handler: sltTemplate },
	    '-',
	    { id: 'btnChiefCheck', text: '主任医师审核', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/chief.gif', pressed: false, handler: chiefCheck },
		{ id: 'btnAttendingCheck', text: '主治医师审核', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/attending.gif', pressed: false, handler: attendingCheck },
		'-',
		{ id: 'btnExport', text: '导出', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/export.gif', pressed: false, handler: exportRecord },
		'-'
		]
		});
		return tbar;
	}
}

//add by yang on 2012-3-27 增加底bar，页面操作工具栏
function getButtonListbbar() 
{
Ext.QuickTips.init();
var bbar = new Ext.Toolbar({border: false,
	items:[ 
		'-',
		{
			xtype:'label',
			text:'共'
		},
		{
			id:'lblTotalRows',
			pressed:false,
			handleMouseEvents:false,
			enable:false,
			text:''
		},
		{
			xtype:'label',
			text:'条记录'
		},
		'-',
		{
			xtype:'label',
			text:'第'
		},
		{
			id:'lblCurrentPage',
			pressed:false,
			handleMouseEvents:false,
			enable:false,
			text:''
		},
		{
			xtype:'label',
			text:'页/共'
		},
		{
			id:'lblTotalPages',
			pressed:false,
			handleMouseEvents:false,
			enable:false,
			text:''
		},
		{
			xtype:'label',
			text:'页 '
		},
		'-',
		{
			xtype:'label',
			text:'每页显示 '
		},
		{
            id: 'cbxPageSize',
            xtype: 'combo',
            store: new Ext.data.SimpleStore({
                    fields: ['id', 'name'],
					data:[['10','10'],['20','20'],['25','25'],['50','50'],['100','100'],['200','200'],['300','300']]
                }),
            displayField: 'name',
            valueField: 'id',
            selectOnFocus: true,
            //emptyText: '20',
			width: 50,
			listWidth: 50,
			triggerAction: 'all',
			editable:false,
			selectOnFocus:true,
			mode: 'local',
			value:defaultPageSize,
			listeners:{
				'select':function(){
						Ext.getCmp('inputPage').setValue(1);
						this.setValue(this.value);
						Ext.getCmp('btnFirstPage').disable();
						Ext.getCmp('btnPreviousPage').disable();
						Ext.getCmp('btnNextPage').enable();
						Ext.getCmp('btnLastPage').enable();
						ajaxAction();
				}
			}
		},
		{
			xtype:'label',
			text:' 条记录'
		},
		'-',
		{
			xtype:'tbfill'
		},
		'-',
		{
			id:'btnFirstPage',
			handleMouseEvents: false,
			cls: 'x-btn-text-icon',
			icon: '../scripts/epr/Pics/pageOp/page-first.gif',
			pressed: false,
			tooltip:'首页',
			handler:firstPage
		},
		{
			id:'btnPreviousPage',
			handleMouseEvents: false, 
			cls: 'x-btn-text-icon', 
			icon: '../scripts/epr/Pics/pageOp/page-prev.gif', 
			pressed: false,
			tooltip:'上一页',
			handler:previousPage
		},
		'-',
		{
			xtype:'label',
			text:'跳转到 '
		},
		{
			id:'inputPage',
			xtype:'numberfield',
			width:30,
			emptyText:1,
			allowNegative:false,
			allowDecimals:false,
			minValue:1,
			handleMouseEvents: false,
			pressed: false
		},
		{
			xtype:'label',
			text:' 页 '
		},
		{
			id:'btnRedirectPage',
			handleMouseEvents: false,
			cls: 'x-btn-text-icon',
			icon: '../scripts/epr/Pics/pageOp/page-fresh.gif', 
			pressed: false,
			tooltip:'跳转',
			handler:redirectPage
		},
		'-',
		{
			id:'btnNextPage',
			handleMouseEvents: false,
			cls: 'x-btn-text-icon',
			icon: '../scripts/epr/Pics/pageOp/page-next.gif', 
			pressed: false,
			tooltip:'下一页',
			handler:nextPage
		},
		{
			id:'btnLastPage',
			handleMouseEvents: false,
			cls: 'x-btn-text-icon',
			icon: '../scripts/epr/Pics/pageOp/page-last.gif', 
			pressed: false,
			tooltip:'末页',
			handler:lastPage
		},
		'-'
	]});
	return bbar;	
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
				
                   },
                   { //add by yang 2012-3-21
						border: false,
                        region: 'south', 
						margins: {left:0, top: 3, right:0, bottom: 0},	    
						split: true,
						height: 27,
						layout: 'fit',
						border: false,                        
						split: false, 
						collapsible: false,
						items: getButtonListbbar()                        
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


