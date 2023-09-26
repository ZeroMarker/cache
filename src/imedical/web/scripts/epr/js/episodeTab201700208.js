function getTabPanel()
{
	var tab = new Ext.TabPanel
	({   
        id : "mainCenterPanel",
        activeTab:0,
        renderTo:'tabpanelDiv',
        //minTabWidth: 100,
        //resizeTabs: true,
        border: false,
      	enableTabScroll: false,
      	renderTo:'tabpanelDiv',
      	tabPosition:'top',
      	//tabWidth:100,
        items:[{
			border: false,
      		title: '就诊浏览',
      		id: 'tabeprtest',
      		layout: 'fit',
      		//closable: false,
      		//autoScroll: false,
      		html:'<div id="photo"><table style="width:100%;height:100%"><tr><td style="text-align:center;"><img src="../scripts/epr/Pics/episodeBrowser.jpg"/></td></tr></table></div>'              				
        }]
    });     
 	return tab;
}


var tab = getTabPanel();

tab.on('tabchange',function(tabpanel, panel){
	if(panel.title =="病历浏览")
	{
		//第一次加载需要刷新iframe，等待时间出现蒙版效果
		if(frames['frmeprbrowser'].document.getElementById('UxTabPanel') == null)
			Ext.getCmp('mainCenterPanel').getEl().mask('数据重新加载中，请稍等');
		//Ext.getCmp("mainCenterPanel").getEl().mask(); 
		//Ext.get("tabpanelDiv").mask();
	}
});

//tab.on('load', function(){
	//Ext.getCmp('mainCenterPanel').getEl().unmask();
	//debugger;
	//Ext.getCmp('mainCenterPanel').getEl().unmask();
//});

//tab.on('loadexception', function(){
	//Ext.getCmp('mainCenterPanel').getEl().unmask();
	
//});

var vPort = new Ext.Viewport({
	id:'vPort',
	layout:'border',
	border:false,
	items:[{
	    border:false,
	    id:'patientInfo',
	    region:'north',
	    height:20,
		autoScroll: true,   //add by niucaicai 2012-06-29  解决“患者信息超出页面后不显示”问题
	    html:'<div id="pInfoDivParent"><div id="pInfoDiv"></div></div>'
	},{
			region:'center',
			layout:'fit',
			border:false,
			items:tab
		}]
});

//alert(episodeID);
//alert(patientID);
if(episodeID != "" && patientID != "")
{
	//debugger;
	createTabs();
}

//根据就诊列表的选择项，重新加载右侧tabPanel（id为mainCenterPanel）
function createTabs()
{
	var tab = Ext.getCmp("mainCenterPanel");
	if(Ext.getCmp("mainCenterPanel"))
	{
		var pageUrlList = pageUrl.split("^^");
		
		//修改时间：2010-7-15
		//修改原因：移动“病历浏览”页签至最前一个，同时在自动加载其内容
		tab.add({
				border: false,
				title: '病历浏览',
				id: 'tabeprbrowser',
				layout: 'fit',
				closable: false,
				autoScroll: true,
				//autoLoad : { url : "epr.newfw.episodelistuvpanel.csp?patientID=" + patientID + "&episodeID" + episodeID, callback : function() { }, scripts : true, scope : this }
				html : '<iframe id="frmeprbrowser" name="frmeprbrowser" style="width:100%; height:100%" src="epr.newfw.episodelistuvpanel.csp?patientID=' + patientID + '&episodeID='+ episodeID + '&admType='+ admType + '"></frame>'
		}).show();
		
		for (var i = 0; i < pageUrlList.length -1; i++)
		{
			var urlDetial = pageUrlList[i].split('#');
			var url = urlDetial[0];
			var title = urlDetial[1];
			var paras = urlDetial[2];
			var parasPID = paras.replace(/\[patientID\]/g, patientID);
			var parasTmpAdm = parasPID.replace(/\[mradm\]/g, mradm);
			var parasFinal = parasTmpAdm.replace(/\[episodeID\]/g, episodeID);
			parasFinal = parasFinal.replace(/\[regNo\]/g, regNo);
			parasFinal = parasFinal.replace(/\[medicare\]/g, medicare);
			parasFinal = parasFinal.replace(/\[userID\]/g, userID);
			parasFinal = parasFinal.replace(/\[userCode\]/g, userCode);
			parasFinal = parasFinal.replace(/\[ctLocID\]/g, ctLocID);
			parasFinal = parasFinal.replace(/\[ctLocCode\]/g, ctLocCode);
			parasFinal = parasFinal.replace(/\[ssGroupID\]/g, ssGroupID);

			//alert(parasFinal);
			if (i == 0)
			{
				tab.add({
					'title' : title,
					layout : 'fit',
					autoLoad : { url : url + '?' + parasFinal, scripts : true, scope : this },
					closable : false,
					autoScroll: true
			    });
			}
			else
			{
				tab.add({
					'title':title,
					layout : 'fit',                     
					html:'<iframe style="width:100%; height:100%" src=' + url + '?' + parasFinal + '></iframe>',
					closable : false,
					autoScroll: true
				});
			}
		}
		
		tab.hideTabStripItem('tabeprtest');
		//tab.setActiveTab(1);
		
		//病案归档浏览
		if ((isPaperless != null) && (isPaperless == "Y"))
		{
			Ext.Ajax.request({
				url: '../DHCEPRFS.web.eprajax.CheckEpisodeStatus.cls',
				timeout: 5000,
				params: {
					Action: "checkcreated",
					EpisodeID:episodeID
				},
				success: function(response, opts){
					if (response.responseText != "-1") {
						//成功
						var ret = parseInt(response.responseText);	
						if (ret == "1")
						{
							tab.add({
								border: false,
								title: '病历浏览PDF',
								id: 'tabeprbrowserpdf',
								layout: 'fit',
								closable: false,
								autoScroll: true,
								html : '<iframe id="frmeprbrowserpdf" name="frmeprbrowserpdf" style="width:100%; height:100%" src="dhc.epr.fs.viewrecord4eprbrowser.csp?EpisodeID='+ episodeID + '"></frame>'
							});
						}
					}	
				},
				failure: function(response, opts){
					Ext.MessageBox.alert("提示", response.responseText);
				}
			});	
		}
	}
}

//病人信息
function setPatientInfo()
{
	var splitor =  '&nbsp&nbsp|&nbsp&nbsp';
	var htmlStr = '&nbsp<span class="spanColorLeft">登记号:</span> <span class="spanColor">' + pInfo[0].papmiNo + '</span>';
	htmlStr += splitor + '<span class="spanColorLeft">床号:</span><span class="spanColor">' + pInfo[0].disBed  + '</span>';
	htmlStr += splitor + '<span class="spanColorLeft">姓名:</span> <span class="spanColor">' + pInfo[0].name + '</span>';
	htmlStr += splitor + '<span class="spanColorLeft">性别:</span> <span class="spanColor">' + pInfo[0].gender + '</span>';
	htmlStr += splitor + '<span class="spanColorLeft">年龄:</span> <span class="spanColor">' + pInfo[0].age + '</span>';	
	htmlStr += splitor + '<span class="spanColorLeft">付费方式:</span><span class="spanColor">' + pInfo[0].payType + '</span>';
	htmlStr += splitor + '<span class="spanColorLeft">入院日期:</span> <span class="spanColor">' + pInfo[0].admDate +'</span>';
 	htmlStr += splitor + '<span class="spanColorLeft">诊断:</span> <span class="spanColor">' + pInfo[0].mainDiagnos + '</span>';

 	var pInfoDiv = document.getElementById('pInfoDiv'); 	
 	pInfoDiv.innerHTML = htmlStr;
	if (fontSize == "pt")
 	{ 
 		fontSize = "9pt"
 	}
 	$(".spanColorLeft").css("fontSize", fontSize);
 	$(".spanColor").css("fontSize", fontSize);
}
