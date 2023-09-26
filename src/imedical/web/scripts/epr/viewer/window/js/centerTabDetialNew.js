function getBBar()
{
	var  bbar = new Ext.Toolbar({ border: false, items:['->','-',
		{id:'btnSave',text:'保存',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/save.gif',pressed:false,listeners:{'click': function(){save();}}},
		'-',
		//{id:'btnPreview',text:'上一页',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/pageup.gif',pressed:false,handler:prev},
		//{id:'btnNext',text:'下一页',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/pagedown.gif',pressed:false,handler:next},'-',		
		{id:'btnUpdateData',text:'更新数据',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/upda.gif',pressed:false,handler:update},
		'-',
		{id:'btnUpdateTemplate',text:'更新模板',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/updaTemplate.gif',pressed:false,handler:updateTemplate},
		'-']});
	return bbar;
}

function getTBar()
{
	var tbar = new Ext.Toolbar({ disabledClass:'x-item-disabled', border: false, items:['->','-',			
			{id:'btnPrint',text:'打印',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/print.gif',pressed:false,handler:print},
			'-',
			{id:'btnCommit',text:'提交',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/submission.gif',pressed:false,handler:commit},
			'-',			
			{id:'btnSltTemplate',text:'选择模板',hidden: true, handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/template.gif',pressed:false,handler:sltTemplate},
			//'-',
			{id:'btnChiefCheck',text:'主任医师审核',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/chief.gif',pressed:false,handler:chiefCheck},
			{id:'btnAttendingCheck',text:'主治医师审核',handleMouseEvents: false, cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/attending.gif',pressed:false,handler:attendingCheck}]});
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
                    border: false,region: 'center', layout: 'border',
                        items: [
							{ 
								border: false,region: 'north',height: 54, layout: 'column',border:false,
								items: [
                            				{ border: false,columnWidth:1, height: 27, html: '<div id="divInfoParent"><div id="divInfo"></div></div>'},
											{ border: false,columnWidth:1, height: 27, items: getTBar()}
                    	    			]
							},
							{ 
                                border: false,region: 'center', layout: 'fit', html: '<iframe id="epreditordll" scrolling="no" frameborder="0"  style="width:100%; height:100%;" src="epr.newfw.epreditordll.csp?PatientID=' + pateintID + '&EpisodeID=' + episodeID + '&ChartItemID=' + templateDocId + '&printTemplateDocId=' + printTemplateDocId + '"></iframe>'
							},
							{ 
                                border: false,region: 'south', layout: 'column', height: 46, items:
									[
										{ border: false,columnWidth:1, height: 27, items: getBBar()},
	                                    { border: false,columnWidth:1, height: 24, html: '<div class="divStateParent"><div id="divState" ></div></div>'}
                    	    		]
							}]
                }]
        });
}
getCenterTabVPort();