

//点击浏览,根据episodeID把iframe整个进行刷新
function browser()
{
	//episodeID = Ext.getCmp('episodeGrid')
	//createTabs();
	//admType = 
	//alert(document.getElementById("frmTabPanel").src);
	var selModel = Ext.getCmp('episodeGrid').getSelectionModel();
	var selects = selModel.getSelections();
	
	//已经无需判断，目前采用双击进行浏览，只可能是一行
	if(selects.length == 0)
	{
		Ext.MessageBox.alert('操作提示','请选择一条就诊记录再进行就诊浏览,请重新操作');
		return;
	}
	else if(selects.length > 1)
	{
		Ext.MessageBox.alert('操作提示','历次就诊浏览只能进行单条记录的浏览，您已经选中了'+selects.length+'条就诊记录,请重新操作');
		return;
	}
	var frame = document.getElementById("frmTabPanel");
	frame.src='about:blank';
	//alert(episodeID);
	frame.src='epr.newfw.episodelisttabpanel.csp?patientID=' + patientID + '&episodeID=' + episodeID + '&admType=' + type;	
}


//选择筛选条件后，点击确定调用事件
function confirm()
{
	//debugger;
	admType = Ext.getCmp('cboAdmType').getValue();
	argDiagnosDesc = Ext.getCmp('txtArgDiagnosDesc').getValue();
	
	//alert(escape(argDiagnosDesc));
	//alert(unescape(argDiagnosDesc));
	Ext.getCmp('episodeGrid').getEl().mask('数据重新加载中，请稍等');
	var s = Ext.getCmp('episodeGrid').getStore();
	var url = '../web.eprajax.episodeListGrid.cls?patientID='+ patientID + '&admType=' + admType + '&argDiagnosDesc=' + escape(argDiagnosDesc);
	s.proxy.conn.url = url;
	//s.load();
	s.load({ params: { start: 0, limit: 20} });
	s.on('load', function(store,record){
		//debugger;
		Ext.get('episodeGrid').unmask();
	});
	
	s.on('loadexception', function(){
		//alert(1);
		Ext.get('episodeGrid').unmask();
	});
}

//病历对比
function compare()
{
	//Ext.getCmp('compareWin').getEl().mask('数据重新加载中，请稍等');
	//var episodeIDList = '';
	
	//imageList格式为"3$34^8^S^1^0#34^6^S^1^0#35^7^S^1^0%..",var episodeIDList格式为"49/.."
	var imageList = '';
	var episodeIDList= '';
	var selModel = Ext.getCmp('episodeGrid').getSelectionModel();
	var selects = selModel.getSelections();
	//debugger;
	//alert(selects[0]);
	for(var i=0; i<selects.length; i++)
	{
		episodeID = selects[i].get('EpisodeID');
		episodeIDList += episodeID+'/';
	} 
	episodeIDList = episodeIDList.substring(0,episodeIDList.length-1);	//去掉尾部的‘/’
	var categoryChapterInfo = '';
	
	Ext.Ajax.request({			
		url: '../web.eprajax.CategoryChapterInfo.cls',
		timeout : 5000,
		params: { EpisodeIDList: episodeIDList,PatientID:patientID,ActionType:"1"},
		//waitMsg : '数据处理中...',//遮罩
		success: function(response, opts) {
			categoryChapterInfo = response.responseText;
			//debugger;
			
			if(categoryChapterInfo == "")
			{
				return;
			}
			var tdList = categoryChapterInfo.split("!");
			var eList = episodeIDList.split("/");
			for(var i = 0; i < tdList.length; i++)
			{
		        if(tdList[i] != '')
		        {
			        var categoryChapterList = tdList[i].split("@");
			        var image = '';
			        var count = 0;
			        for (var j = 0; j < categoryChapterList.length; j++)
			        {
				        var info = categoryChapterList[j].split('*');
    					
				        if(image == '')
				        {
					        image = info[3];
				        }
				        else
				        {
					        image = image + '@' + info[3];
				        }
			        }
			        imageList = imageList + image + '!';
		        }
		        else
		        {
		            for(var k=0; k<selects.length; k++)
                    {
	                    if(selects[k].get('EpisodeID') == eList[i])
	                    {
	                        //如果没有图片，拼字符串。格式为“NoImage$AdmDate^AdmType^CurDept%”
	                        var type;
	                        if(selects[k].get('AdmType') == "I")
	                        {
	                            type='住院';
	                        }
	                        else if(selects[k].get('AdmType') == "O")
	                        {
	                            type='门诊';
	                        }
	                        else
	                        {
	                            type='急诊';
	                        }
	                        imageList =  imageList + 'NoImage$' + selects[i].get('AdmDate') + '^' + type + '^' + selects[i].get('CurDept') + '!';
	                    }
                    }  
			        
			    }
				
			}
			imageList = imageList.substring(0,imageList.length-1);
			//alert(imageList);
			imageListStr = imageList;
			Ext.getDom('frmCompare').src = 'epr.newfw.episodelistcomparephoto.csp?PatientID='+ patientID +'&EpisodeIDList='+ escape(episodeIDList); //+'&ImageList='+ escape(imageList);
		},
		failure: function(response, opts) {
			alert(response.responseText);
		}
	});
		//alert(categoryChapterInfo);
		
	
	
	//alert(episodeIDList);
	//alert(imageList);
	
}




