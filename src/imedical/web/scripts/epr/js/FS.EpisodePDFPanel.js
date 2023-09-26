
Ext.QuickTips.init();

function getPdfTabPanel()
{
    var pdftabpanel = new Ext.ux.TabPanel({ 
        id:'pdfTabPanel',
        tabPosition:'right',    //choose 'left' or 'right' for vertical tabs; 'top' or 'bottom' for horizontal tabs 
        textAlign:'left',
        renderTo:'pdfpanelDiv',  //id of an existing DOM element 
        width:1070, 
        height:575, 
        tabWidth:95,
        enableTabScroll:true,
        defaults:{autoScroll: true, iconcss:'nav'},
        items:[{
			id:'RT0',
            layout:'fit',
            title: '全部',
            tabTip:'全部',  
            closable:false,
            html:'<iframe id="frmBrowserPdf_RT0" style="width:100%; height:100%" src=""></iframe>'
        }]
    }); 
    
	CreatePdfTabPanel();
	
    return pdftabpanel;
}
function CreatePdfTabPanel()
{
	var categoryChapterInfo = "";
	var pdftab = Ext.getCmp("pdfTabPanel");
	var flag = "";
	if(Ext.getCmp("pdfTabPanel"))
	{
		Ext.Ajax.request({			
			url: '../DHCEPRFS.web.eprajax.CategoryChapterInfo.cls',
			timeout : 5000,
			params: {},
			success: function(response, opts) {
				categoryChapterInfo = response.responseText;
				if(categoryChapterInfo == "")
				{
					return;
				}
				var categoryChapterList = categoryChapterInfo.split("@");
				for (var i = 0; i < categoryChapterList.length-1; i++)
				{
				    //debugger;
					var info = categoryChapterList[i].split('*');
					var titleStr = "";
					
					//add by loo on 2010-8-18
					//当病历CategoryChapter名称过长，大于6个字，进行名称处理，显示前6个字+“..”
					if(info[1].length>6)
					{
					    titleStr = info[1].substring(0,6);
					    titleStr += "..";
					}
					else
					{
					    titleStr = info[1];
					}
					debugger;
					if(admType=='I')
	                {
	                    //就诊类型为住院，默认病历浏览加载除去“全部”后的第一个选项卡
					    if(i==0)
					    {
					        pdftab.add({
						        'id':categoryChapterList[i],
						        'title':titleStr,
						        tabTip:info[1], //add by loo on 2010-8-18 给tab页签新增一个浮动的提示框
						        //iconCls:'icon-by-category',
						        layout:'fit',
						        closable:false,
						        html:'<iframe id="frmBrowserPdf_' + categoryChapterList[i] + '" style="width:100%; height:100%" src=""></iframe>'
					        }).show();
					    }
					    else
					    {
					        pdftab.add({
						        'id':categoryChapterList[i],
						        'title':titleStr,
						        tabTip:info[1], //add by loo on 2010-8-18 给tab页签新增一个浮动的提示框
						        //iconCls:'icon-by-category',
						        layout:'fit',
						        closable:false,
						        html:'<iframe id="frmBrowserPdf_' + categoryChapterList[i] + '" style="width:100%; height:100%" src=""></iframe>'
					        });
					    }
					}
					else
					{
					    //若为急诊或者门诊，则默认加载“全部”选项卡  
					    pdftab.add({
					        'id':categoryChapterList[i],
					        'title':titleStr,
					        tabTip:info[1], //add by loo on 2010-8-18 给tab页签新增一个浮动的提示框
					        //iconCls:'icon-by-category',
					        layout:'fit',
					        closable:false,
					        html:'<iframe id="frmBrowserPdf_' + categoryChapterList[i] + '" style="width:100%; height:100%" src=""></iframe>'
					    });
					    
					    pdftab.setActiveTab('RT0');
	                    var panel = uxtab.getActiveTab();
	                    getInfoFromTab(uxtab, panel);
					}
				}
			},
			failure: function(response, opts) {
				alert(response.responseText);
			}
		});            
	   
	}
	
	//创建完毕，取消蒙版效果
	if ((parent.Ext != null)&&(parent.Ext.getCmp('mainCenterPanel') != null))
	{
		parent.Ext.getCmp('mainCenterPanel').getEl().unmask();
	}
}

var PdfTabPanel = getPdfTabPanel();

var tabPort = new Ext.Viewport({
    layout:'border',
    items:[{
        region:'center',
        layout:'fit',
        items:PdfTabPanel
    }]
});

PdfTabPanel.on('tabchange',function(tabpanel, panel){
	getInfoFromTab(tabpanel, panel);
});

function getInfoFromTab(tabpanel, panel)
{
    if(panel.id == 'RT0')
	{
		var allImageList = '';
		var count = 0;
		//循环遍历所有tab页签,取出id，然后拼接出全部的imageList字符串
		tabpanel.items.each(function(item){
			if(item != panel)
			{
				var list = item.id.split('*');
				if(allImageList == '')
				{
					allImageList = list[3];
				}
				else
				{
					allImageList = allImageList + '@' + list[3];
				}
			}
		});
		
		imageList = allImageList;
		Ext.getDom('frmBrowserPdf_RT0').src = 'dhc.epr.pdfarchive.browserecord.csp?PDFPath=c:\\2.pdf&PatientID='+ patientID +'&EpisodeID='+ episodeID;
	}
	else
	{
		var list = panel.id.split('*');
		var parentId = list[0];
		var categoryChapterId = list[2];
		imageList = list[3];
		Ext.getDom('frmBrowserPdf_'+panel.id).src = 'dhc.epr.pdfarchive.browserecord.csp?PDFPath=c:\\3.pdf&PatientID='+ patientID +'&EpisodeID='+ episodeID;  
    }
}