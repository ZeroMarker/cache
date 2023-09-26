Ext.QuickTips.init();

function getBBar() 
{
    var bbar = new Ext.Toolbar({
        border: false,
        items: [
	        { id: 'btnReference', text: '病历引用', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/btnReference.gif', pressed: false, handler: reference },
	        '->', '-',
		    { id: 'btnSave', text: '保存', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/save.gif', pressed: false, listeners: { 'click': function() { save(); } } },
		    '-',
		    { id: 'btnPrev', text: '上一页', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/pageup.gif', pressed: false, listeners: { 'click': function(button, e) { prev(e); } } },
		    { id: 'btnNext', text: '下一页', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/pagedown.gif', pressed: false, listeners: { 'click': function(button, e) { next(e); } } }, '-',
		    { id: 'btnUpdateData', text: '更新数据', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/upda.gif', pressed: false, handler: update },
		    '-',
		    { id: 'btnUpdateTemplate', text: '更新模板', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/updaTemplate.gif', pressed: false, handler: updateTemplate },
		    '-'
		]
    });
    return bbar;
}

function getTBar() {
    var tbar = new Ext.Toolbar({
        disabledClass: 'x-item-disabled',
        border: false,
        items: [
	        '->',
	        '-',
			{ id: 'btnPreview', text: '预览', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/preview.gif', pressed: false, handler: preview },
			'-',
			{ id: 'btnPrint', text: '打印', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/print.gif', pressed: false, handler: print },
			'-',
			{ id: 'btnCommit', text: '提交', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/submission.gif', pressed: false, handler: commit },
			'-',
			{ id: 'btnSltTemplate', text: '选择模板', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/template.gif', pressed: false, handler: sltTemplate },
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

function getCenterTabVPort()
{
	var frmMainContent = new Ext.Viewport(
    {
        id: 'centerTabViewPort',
        shim: false,
        animCollapse: false,
        constrainHeader: true,
        margins:'0 0 0 0', 
        layout: 'border',
        items: [{
            border: false,
            region: 'center', 
            layout: 'border',
            items: [{
                border: false,
                region: 'north',
                height: 27, 
                layout: 'column',
                items: [
				//alter by loo on 2010-4-16
   				//{ border: false,columnWidth:1, height: 27, html: '<div id="divInfoParent"><div id="divInfo"></div></div>'},
                {
			        border: false,
			        columnWidth: 1,
			        height: 27, 
			        items: getTBar()
                }]
		    },
			{
			    border: false,
			    region: 'center',
			    layout: 'fit', 
                html: '<iframe id="epreditordll" scrolling="no" frameborder="0"  style="width:100%; height:100%;" src="epr.newfw.epreditordll.csp?PatientID=' + pateintID + '&EpisodeID=' + episodeID + '&ChartItemID=' + templateDocId + '&printTemplateDocId=' + printTemplateDocId + '"></iframe>'
			},
			{
			    border: false,
			    region: 'south',
			    layout: 'column',
			    height: 46, 
                items:
				[
					{
					    border: false,
					    columnWidth: 1,
					    height: 27,
					    items: getBBar()
					},
                    //{ border: false,columnWidth:1, height: 24, html: '<div id="divStateParent" class="divStateParent"><div id="divState" style= "float:left "></div><div id="divDetail" style= "float:right;width:60px"><font style="font-size:9pt"><a id="detail" style="cursor:pointer;line-height:21px" onclick="showDetail()" >〖明细〗</a></font></div></div>'}
                    {
                        border: false,
                        columnWidth: 1,
                        height: 24,
                        html: '<div id="divStateParent" class="divStateParent"><div id="divState" style= "float:left;line-height:15px;"></div><div id="divDetail" style= "float:right;width:32px"><img alt="" style="cursor:pointer;margin-top:2px;" src="../scripts/epr/Pics/browser.gif" onClick="showLog()" /></div></div>'
                    }
	    		]
            }]
        }]
    });
}

getCenterTabVPort();