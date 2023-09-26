//if(admType=='I')
//{
    //alert('住院');
//}
//else if(admType=='O')
//{
    //alert('门诊');
//}
//else
//{
    //alert('急诊');
//}

//add by loo on 2010-8-18
//右侧页签的浮动提示功能
Ext.QuickTips.init();

function getUxTabPanel()
{
    //debugger;
    var Uxtabpanel = new Ext.ux.TabPanel({ 
        id:'uxTabPanel',
        tabPosition:'right',    //choose 'left' or 'right' for vertical tabs; 'top' or 'bottom' for horizontal tabs 
        textAlign:'left',
        renderTo:'uxpanelDiv',  //id of an existing DOM element 
        width:1070, 
        height:575, 
        tabWidth:95,
        enableTabScroll:true,
        defaults:{autoScroll: true, iconcss:'nav'},
        items:[{
			id:'RT0',
            layout:'fit',
            title: '全部',
            tabTip:'全部',  //add by loo on 2010-8-18 给tab页签新增一个浮动的提示框
            //iconCls:'icon-by-category',
            height:10,
            closable:false,
            html:'<iframe id="frmBrowserPhoto_RT0" style="width:100%; height:100%" src=""></iframe>'
            //autoLoad : { url : 'epr.newfw.episodelistbrowserphoto.csp', scripts : true, scope : this }
        }]
    }); 
    
    //Uxtabpanel.on( 'render' , function (){
            //panel.el.dom.oncontextmenu= function (e){
                                            //debugger;
                                            //window.event?window.event.returnValue= false :e.preventDefault();
                                        //};
    //});
    
	CreateUxTabPanel();
	
    return Uxtabpanel;
}
function CreateUxTabPanel()
{
	var categoryChapterInfo = "";
	var uxtab = Ext.getCmp("uxTabPanel");
	var flag = "";
	//debugger;
	if(Ext.getCmp("uxTabPanel"))
	{
		Ext.Ajax.request({			
			url: '../web.eprajax.CategoryChapterInfo.cls',
			timeout : 5000,
			params: { EpisodeIDList: episodeID,PatientID:patientID,ActionType:"1"},
			success: function(response, opts) {
				categoryChapterInfo = response.responseText;
				//debugger;
				if(categoryChapterInfo == "")
				{
					return;
				}
				var categoryChapterList = categoryChapterInfo.split("@");
				for (var i = 0; i < categoryChapterList.length; i++)
				{
				    //debugger;
					var info = categoryChapterList[i].split('*');
					var titleStr = "";
					
					//add by loo on 2010-8-18
					//当病历CategoryChapter名称过长，大于6个字，进行名称处理，显示前6个字+“..”
					if(info[1].length>6)
					{
					    //alert(info[1].length);
					    titleStr = info[1].substring(0,6);
					    titleStr += "..";
					}
					else
					{
					    titleStr = info[1];
					}
					//end add
					
					uxtab.add({
					        'id':categoryChapterList[i],
					        'title':titleStr,
					        tabTip:info[1], //add by loo on 2010-8-18 给tab页签新增一个浮动的提示框
					        //iconCls:'icon-by-category',
					        layout:'fit',
					        closable:false,
					        html:'<iframe id="frmBrowserPhoto_' + categoryChapterList[i] + '" style="width:100%; height:100%" src=""></iframe>'
					});
					
					if (defaultSelectChapterID == "")
					{						
						if(admType=='I')
		                {
			                //住院患者显示“全部”病历下方的第一个病历内容
			                if (i == "0")
			                {
				                uxtab.setActiveTab(categoryChapterList[i]);
	                    		var panel = uxtab.getActiveTab();
	                    		getInfoFromTab(uxtab, panel);
			                }
		                }
		                else
		                {
			                //门急诊患者显示“全部”病历,并且在初始化完所有项目后再显示“全部”病历
			                if (i == (categoryChapterList.length - 1))
			                {
			                	uxtab.setActiveTab('RT0');
	                    		var panel = uxtab.getActiveTab();
	                    		getInfoFromTab(uxtab, panel);
			                }
		                }
					}
					else
					{
						var tmpIdList = categoryChapterList[i].split('*');
						if (tmpIdList[2] == defaultSelectChapterID)
						{
							uxtab.setActiveTab(categoryChapterList[i]);
	                    	var panel = uxtab.getActiveTab();
	                    	getInfoFromTab(uxtab, panel);
						}
					}
	                
					/*
					if(admType=='I')
	                {
	                    //就诊类型为住院，默认病历浏览加载除去“全部”后的第一个选项卡
					    if(i==0)
					    {
					        uxtab.add({
						        'id':categoryChapterList[i],
						        'title':titleStr,
						        tabTip:info[1], //add by loo on 2010-8-18 给tab页签新增一个浮动的提示框
						        //iconCls:'icon-by-category',
						        layout:'fit',
						        closable:false,
						        html:'<iframe id="frmBrowserPhoto_' + categoryChapterList[i] + '" style="width:100%; height:100%" src=""></iframe>'
					        }).show();
					    }
					    else
					    {
					        uxtab.add({
						        'id':categoryChapterList[i],
						        'title':titleStr,
						        tabTip:info[1], //add by loo on 2010-8-18 给tab页签新增一个浮动的提示框
						        //iconCls:'icon-by-category',
						        layout:'fit',
						        closable:false,
						        html:'<iframe id="frmBrowserPhoto_' + categoryChapterList[i] + '" style="width:100%; height:100%" src=""></iframe>'
					        });
					    }
					}
					else
					{
					    //若为急诊或者门诊，则默认加载“全部”选项卡
					    
					    uxtab.add({
					        'id':categoryChapterList[i],
					        'title':titleStr,
					        tabTip:info[1], //add by loo on 2010-8-18 给tab页签新增一个浮动的提示框
					        //iconCls:'icon-by-category',
					        layout:'fit',
					        closable:false,
					        html:'<iframe id="frmBrowserPhoto_' + categoryChapterList[i] + '" style="width:100%; height:100%" src=""></iframe>'
					    });
					    
					    uxtab.setActiveTab('RT0');
	                    var panel = uxtab.getActiveTab();
	                    getInfoFromTab(uxtab, panel);
					}
					*/
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

var UxTabPanel = getUxTabPanel();

var tabPort = new Ext.Viewport({
    layout:'border',
    items:[{
        region:'center',
        layout:'fit',
        items:UxTabPanel
    }]
});

UxTabPanel.on('tabchange',function(tabpanel, panel){
	getInfoFromTab(tabpanel, panel);
});

function getInfoFromTab(tabpanel, panel)
{
	
    if(panel.id == 'RT0')
	{
		//alert(panel.id);
		//debugger;
		var allImageList = '';
		var count = 0;
		//循环遍历所有tab页签,取出id，然后拼接出全部的imageList字符串
		tabpanel.items.each(function(item){
			if(item != panel)
			{
			    //debugger;
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
		//var str = 'PatientID='+ patientID +'&EpisodeID='+ episodeID +'&ImageList='+ escape(imageList);
		//Ext.getDom('frmBrowserPhoto_RT0').src = 'epr.newfw.episodelistbrowserphoto.csp?'+str;
		Ext.getDom('frmBrowserPhoto_RT0').src = 'epr.newfw.episodelistbrphbypage.csp?PatientID='+ patientID +'&EpisodeID='+ episodeID;
	}
	else
	{
		//debugger;
		var list = panel.id.split('*');
		var parentId = list[0];
		var categoryChapterId = list[2];
		imageList = list[3];
		//Ext.getDom('frmBrowserPhoto_'+panel.id).src = 'epr.newfw.episodelistbrowserphoto.csp?PatientID='+ patientID +'&EpisodeID='+ episodeID +'&ImageList='+ escape(imageList);
		//alert("A+"+imageList);
		//避免了传递的参数超出GET的最大值而导致的数据丢失  2012-10-17 by niucaicai
		Ext.getDom('frmBrowserPhoto_'+panel.id).src = 'epr.newfw.episodelistbrphbypage.csp?PatientID='+ patientID +'&EpisodeID='+ episodeID;// +'&ImageList='+ escape(imageList);  
    }
}