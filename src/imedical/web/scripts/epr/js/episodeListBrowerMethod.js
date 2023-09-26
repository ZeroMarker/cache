

//就诊类型的转换（I：住院，O：门诊，E：急诊）
function gettype(val)
{
    if(val == "I")
    {
		return '<span style="color:green;">住院</span>';
    }
    else if(val == "O"){
        return '<span style="color:red;">门诊</span>';
    }
    else if(val == "E")
    {
		return '<span style="color:blue;">急诊</span>';
    }
    
    return val;
}

//点击浏览,根据episodeID把iframe整个进行刷新
function browser()
{
	//episodeID = Ext.getCmp('episodeGrid')
	//createTabs();
	//admType = 
	//alert(document.getElementById("frmTabPanel").src);
	var selModel = Ext.getCmp('episodeGrid').getSelectionModel();
	var selects = selModel.getSelections();
	if(selects.length == 0)
	{
		alert('请选择一条就诊记录再进行就诊浏览,请重新操作');
		return;
	}
	else if(selects.length > 1)
	{
		alert('历次就诊浏览只能进行单条记录的浏览，您已经选中了'+selects.length+'条就诊记录,请重新操作');
		return;
	}
	var frame = document.getElementById("frmTabPanel");
	frame.src='about:blank';
	frame.src='epr.newfw.epsodeListTabPanel.csp?patientID=' + patientID + '&episodeID=' + episodeID;	
}


//选择筛选条件后，点击确定调用事件
function confirm()
{
	//debugger;
	admType = Ext.getCmp('cboAdmType').getValue();
	argDiagnosDesc = Ext.getCmp('txtArgDiagnosDesc').getValue();
	
	Ext.getCmp('episodeGrid').getEl().mask('数据重新加载中，请稍等');
	var s = Ext.getCmp('episodeGrid').getStore();
	var url = '../web.eprajax.epsodeListGrid.cls?patientID='+ patientID + '&admType=' + admType + '&argDiagnosDesc=' + argDiagnosDesc;
	s.proxy.conn.url = url;
	s.load();
	
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
	Ext.getCmp('compareWin').getEl().mask('数据重新加载中，请稍等');
	//var episodeIDList = '';
	var selModel = Ext.getCmp('episodeGrid').getSelectionModel();
	var selects = selModel.getSelections();
	
	if(selects.length == 0)
	{
		alert('请选择一条就诊记录再进行就诊浏览,请重新操作');
		return;
	}
	
	//imageList格式为"3$1$34^8^S^1^0#34^6^S^1^0#35^7^S^1^0/..",var episodeIDList格式为"49/.."
	var imageList = '';
	var episodeIDList= '';
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
		url: '../web.eprajax.getCategoryChapterInfo.cls',
		timeout : 5000,
		params: { EpisodeIDList: episodeIDList},
		//waitMsg : '数据处理中...',//遮罩
		success: function(response, opts) {
			categoryChapterInfo = response.responseText;
			//debugger;
			
			if(categoryChapterInfo == "")
			{
				return;
			}
			var tdList = categoryChapterInfo.split("/");
			for(var i = 0; i < tdList.length; i++)
			{
				var categoryChapterList = tdList[i].split("@");
				var image = '';
				var count = 0;
				for (var j = 0; j < categoryChapterList.length; j++)
				{
					var info = categoryChapterList[j].split('#');
					
					if(image == '')
					{
						var iList = info[3].split('$');
						image = iList[1];
						count = count + parseInt(iList[0]);
					}
					else
					{
						var iList = info[3].split('$');
						image = image + '#' + iList[1];
						count = count + parseInt(iList[0]);
					}
				}
				imageList = imageList + count + '$' + image + '/';
				
			}
			imageList = imageList.substring(0,imageList.length-1);
			//alert(imageList);
			Ext.getDom('frmCompare').src = 'epr.newfw.epsodeListComparePhoto.csp?PatientID='+ patientID +'&EpisodeIDList='+ escape(episodeIDList) +'&ImageList='+ escape(imageList);
		},
		failure: function(response, opts) {
			alert(response.responseText);
		}
	});
		//alert(categoryChapterInfo);
		
	
	
	//alert(episodeIDList);
	//alert(imageList);
	;
}




