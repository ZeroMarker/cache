

//打开某条记录
function OpenRecordClickHandler(episodeid, categoryid, profileid, instanceid, eprNum, chartID,  patientID, logRowID, prtDocID)
{
	var btnRefresh = Ext.getCmp('btnRefresh');
	var frameUrl = 'epr.newfw.centerTabListDetial.csp?EpisodeID=' + episodeid + '&CategoryID=' + categoryid + '&ProfileID=' + profileid + '&InstanceDataID=' + instanceid + '&State=old&EPRNum=' + eprNum + '&ChartItemID=' + chartID  + '&PatientID=' + patientID + '&LogRowID=' + logRowID + '&prtDocID=' + prtDocID;
	var iframeScript = '<iframe style="width:100%; height:100%" src="' + frameUrl + '" ></iframe>';
	parent.createMultiple(frameUrl, btnRefresh);
}

//创建EprListEdit
function createEprListEdit(patientid, episodeid, categoryid, categorytype, chartitemid, profileid, templateID, templatename, templateDocID)
{
	var btnRefresh = Ext.getCmp('btnRefresh');
	var frameUrl = 'epr.newfw.centerTabListDetial.csp?PatientID=' + patientid + '&EpisodeID=' + episodeid + '&TemplateID=' + templateID + '&CategoryID=' + categoryid + '&CategoryType=' + categorytype + '&ChartItemID=' + chartitemid + '&ProfileID=' + profileid + '&TemplateName=' + templatename + '&TemplateDocID=' + templateDocID;
	var iframeScript = '<iframe id="centerTabListDetial" style="width:100%; height:100%" src="' + frameUrl + '" ></iframe>';
	parent.createMultiple(frameUrl, btnRefresh);
}
/*
function createMultiple(iframeScript)
{
	var multipleEditWindowID = 'multipleWindow';
	var frameMultipleEditWindowID = 'frameMultipleEditWindow';
	var frameUrl = iframeScript;
	var win = Ext.getCmp(multipleEditWindowID);
	if(!win)
	{
		win = new Ext.Window({
			id: multipleEditWindowID,
			footer : false,
			width: 640,
			height: 480,
			iconCls: 'accordion',
			collapsed: true,
			collapsible: true,
			shim: false,
			animCollapse: false,
			constrainHeader: true,
			//layout: 'fit',
			border: false,
			maximizable: true,
			//minimizable: true,
			//renderTo: 'divCenter',
			modal: true,
			layoutConfig: {
				animate: false
			},
			listeners: 
			{
				'beforeclose': function(panel){ this.hide(); return false; }
			},
			html: '<iframe id=' + frameMultipleEditWindowID + ' style="width:100%; height:100%;" src=' + frameUrl + '></iframe>'
		});					
	}
	else
	{
		document.getElementById(frameMultipleEditWindowID).src =  frameUrl;
	}
	win.show();
}
*/

//新建
function newList()
{
	createEprListEdit(patientID, episodeID, categoryID, categoryType, profileID, profileID, templateID, templateName, templateDocID);
}

//确定
function open()
{
	var instanceidList = '';
	var chkList = $(':checkbox');
	for (i = 0; i < chkList.length; i++)
	{
		//如果为表头的chk,执行下一次循环
		if(chkList[i].id == 'chkTitle')
		{
			continue;
		}
		if(!chkList[i].checked)
		{
			continue;
		}
		instanceidList += chkList[i].instanceid;
		instanceidList += '^';
	}
	instanceidList = instanceidList.substring(0, instanceidList.length -1);
	//Ext.getDom('divList').innerHTML = '<iframe id="frameListSvg" style="width:100%; height: 100%" src="' + 'EPR1124.CSP?instanceid=' + instanceidList + '&printdocid=' + printTemplateDocID + ' "</iframe>';
	
	Ext.getDom('frameListSvg').src = 'EPR1124.CSP?instanceid=' + instanceidList + '&printdocid=' + printTemplateDocID;
}

//刷新
function refresh(isBrowser)
{
	Ext.Ajax.request({			
		url: '../web.eprajax.viewerListGrid.cls',
		timeout: 10000,
		params: { EpisodeID: episodeID, printTemplateDocID: printTemplateDocID, TemplateDocID: templateDocID, PatientID: patientID, IsShowAll: isShowAll, ProfileID: profileID},
		success: function(response, opts) {
			var obj = response.responseText;
			Ext.getDom('EPRList').innerHTML = obj;
			//若是页面刚打开，刷新右边列表svg
			if(isBrowser)
			{
				firstBorwser();
			}
		},
		failure: function(response, opts) {
			var obj = "写入日志错误,错误代码:" + response.status + "," + "错误信息:" + response.statusText;				
			alert(obj);
		}
	});
}

//tbar
function getCenterListTbar()
{
	var tbar = new Ext.Toolbar({border: false,
	items:[ 
		'-',
		//{id:'chkSelectAll', boxLabel:'只显示< ' + _PageTitle + ' >', xtype: 'checkbox',checked: false, listeners: {'check': function(checkbox, isChecked){_IsShowAll = isChecked?'N':'Y'; ajaxAction();}}}, 
		//'-','->','-',
		'->',
		{id:'btnNew',text:'新建',cls: 'x-btn-text-icon', icon:'../scripts/epr/Pics/new.gif',pressed:false,handler:newList},'-',
		{id:'btnRefresh',text:'刷新',cls: 'x-btn-text-icon', icon:'../scripts/epr/Pics/new.gif',pressed:false,listeners:{'click': function(){ refresh(); }}},'-',
		{id:'btnOpen',text:'确定',cls: 'x-btn-text-icon', icon:'../scripts/epr/Pics/new.gif',pressed:false,handler:open},'-'
		]});
	return tbar;
}

//返回列表的id集合
function getInstanceList()
{
	var chkList = $(':checkbox');		//页面上所有的chk
	var length = chkList.length;
	var arrInstanceID = new Array();	//instanceid集合
	for (i = 0; i < length; i++)
	{
		//如果为表头的chk,执行下一次循环		
		if(chkList[i].id == 'chkTitle')
		{
			continue;
		}
		arrInstanceID = arrInstanceID.concat(chkList[i].instanceid)
	}
	return arrInstanceID;
} 

//上一页
function pageUp()
{
	var instanceidList = '';
	var list = getInstanceList();
	
	
	var start = (currPage - 1) * viewListNum;
	var end = start + viewListNum;
	
	//若当前页小于0，直接退出
	if (start < 0)
	{
		return;
	}
	currPage--;		//当前页减1
	
	for(var i = start; i < end; i++)
	{
		instanceidList += list[i];
		instanceidList += '^';
	}
	
	instanceidList = instanceidList.substring(0, instanceidList.length -1);
	Ext.getDom('frameListSvg').src = 'EPR1124.CSP?instanceid=' + instanceidList + '&printdocid=' + printTemplateDocID;
	
}

//下一页
function pageDown()
{
	var instanceidList = '';
	var list = getInstanceList();
	
	
	var start = (currPage + 1) * viewListNum;
	var end = start + viewListNum;
	
	//若当前页大于list的长度，直接退出
	if (start >= list.length)
	{
		return;
	}
	currPage++;		//当前页加1
	for(var i = start; i < (list.length < end ? list.length : end); i++)
	{
		instanceidList += list[i];
		instanceidList += '^';
	}
	
	instanceidList = instanceidList.substring(0, instanceidList.length -1);
	Ext.getDom('frameListSvg').src = 'EPR1124.CSP?instanceid=' + instanceidList + '&printdocid=' + printTemplateDocID;
}

//刚打开时显示
function firstBorwser()
{
	var instanceidList = '';
	var list = getInstanceList();
	
	var start = currPage * viewListNum;
	var end = start + viewListNum;
	
	//若当前页小于0，直接退出
	if (start > list.length)
	{
		return;
	}
	
	for(var i = start; i < (list.length < end ? list.length : end); i++)
	{
		instanceidList += list[i];
		instanceidList += '^';
	}
	
	instanceidList = instanceidList.substring(0, instanceidList.length -1);
	//Ext.getDom('divList').innerHTML = '<iframe id="frameListSvg" style="width:100%; height: 100%" src="' + 'EPR1124.CSP?instanceid=' + instanceidList + '&printdocid=' + printTemplateDocID + ' "</iframe>';

	
	Ext.getDom('frameListSvg').src = 'EPR1124.CSP?instanceid=' + instanceidList + '&printdocid=' + printTemplateDocID;
}


//上一页和下一页的界面
function getPageUpAndDownTbar()
{
	var tbar = new Ext.Toolbar({border: false,
	items:[ 
			'->',
			{id:'btnNew',text:'上一页',cls: 'x-btn-text-icon', icon:'../scripts/epr/Pics/new.gif',pressed:false,listeners:{'click': function(){ pageUp(); }}},'-',
			{id:'btnRefresh',text:'下一页',cls: 'x-btn-text-icon', icon:'../scripts/epr/Pics/new.gif',pressed:false,listeners:{'click': function(){ pageDown(); }}}
		]});
	return tbar;
}


Ext.onReady(function(){
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
                        region: 'west', 
                        split: true, 
                        collapsible: true,
                        collapsed: true,
						split: true,
						width: 220,
						layout: 'border',
						title: ' ',
						border: true,
						items: [{ 
										border: false, id: 'listWestNorth', region: 'north', title: '', collapsible: false, collapsed: false, titleCollapse: false, layout: 'fit', height: 25,
										items: getCenterListTbar()
								},
								{
										border: false, region: 'center',html: '<div id = "EPRList" style = "width: 100%; height: 100%"></div>'
								}]         
                   },
                   { 
						id: 'centerListTab',
						border: false,
						region: 'center',
						layout: 'form',
						//html: '<div id="divPageUpAndDown" style="width:100%;height:25px;"></div><div style="width:100%; height: expression(document.body.offsetHeight - 25);height:2000px; OVERFLOW-y:auto;" id="divList"></div>'
						html: '<div id="divPageUpAndDown" style="width:100%;height:25px;"></div><iframe style="width:100%;height:expression(document.body.offsetHeight - 25);" id="frameListSvg"></iframe>'
                   }]
		});
		refresh(true);	//刷新列表
		var tbar = getPageUpAndDownTbar();		//设置div的tbar，即上一页和下一页
		tbar.render('divPageUpAndDown');
});

