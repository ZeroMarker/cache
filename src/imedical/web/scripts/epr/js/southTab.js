function getSouthTabPanel()
	{
    	var tab = new Ext.TabPanel
    	({   
            id : "southTabPanel",           
            //deferredRender: false,
            activeTab:0,
            region : "west",
            minTabWidth: 100,
            //resizeTabs: true,
            border: false,	
	      	enableTabScroll: false,
	      	//defaults: {autoScroll:false},
	      	//autoDestroy: false,
	      	tabPosition:'bottom',
            items:[/*
                  {
						border: false,
	              		title: '本次医嘱',
	              		id: 'tabeprorder',
	              		layout: 'fit',
	              		closable: false,
						//html:'<iframe id="tabeprorderFrame" style="width:100%; height:100%" src=""></iframe>',
						//autoLoad : { url : './epr.chart.csp?PatientID=' + patientID + '&EpisodeID=' + episodeID + '&EpisodeIDs=&mradm=' + episodeID + '&ChartID=22&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=0&ConsultID=&ConsultEpisodeID='},
						autoLoad : { url : 'epr.newfw.dhcoeordsch.csp?EpisodeID=' + episodeID},
	              		autoScroll: true	              				
	              },
	              {
						border: false,
	              		title: '检查结果',
	              		id: 'tabeprexam',
	              		layout: 'fit',
	              		closable: false,
						html:'<iframe id="taeprexamFrame" style="width:100%; height:100%" src="" ></iframe>',
	              		autoScroll: false	              				
	              },*/
	              {
						border: false,
	              		title: '化验结果',
	              		id: 'tabeprtest',
	              		layout: 'fit',
	              		closable: false,
						//html:'<iframe id="tabeprtestFrame" style="width:100%; height:100%" src="" ></iframe>',
	              		autoScroll: false	              				
	              }
	              /*
	              {
						border: false,
	              		title: '病历浏览',
	              		id: 'tabeprbrower',
	              		layout: 'fit',
	              		closable: false,
	              		autoScroll: false,
	              		autoLoad : { url : "epr.newfw.browser.csp?patientID=" + patientID + "&episodeID=" + episodeID, callback : function() { }, scripts : true, scope : this }	              				
	              }*/
                  ]
        });     
     	return tab;
	}
	
	function getSouthVPort()
	{
		var southTabPanel = getSouthTabPanel();
		var frmMainContent = new Ext.Viewport(
        	{
            		id: 'southviewport',
            		shim: false,
            		animCollapse: false,
            		constrainHeader: true, 
            		margins:'0 0 0 0',           
            		layout: "border",  
					border: false,                   
            		items: [{ 
                        	border: false,region: "center", layout: "border",
                            	items: [{ 
                                    	border: false,region: "center", layout: "fit", items:southTabPanel
                                   	}]
                    	}]
         	});

		/*
		southTabPanel.on('tabchange', function(tab, activetabItem){
			//frmMainContent.getComponent('southviewport').setTitle(activetabItem.title);
	
				if (activetabItem.id=='tabeprexam'){if (Ext.getDom("taeprexamFrame").src==''){Ext.getDom("taeprexamFrame").src='./epr.chart.csp?PatientID=' + patientID + '&EpisodeID=' + episodeID + '&EpisodeIDs=&mradm=' + episodeID + '&ChartID=24&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=0&ConsultID=&ConsultEpisodeID=';}}
				else if (activetabItem.id=='tabeprtest'){if (Ext.getDom("tabeprtestFrame").src==''){Ext.getDom("tabeprtestFrame").src='./epr.chart.csp?PatientID=' + patientID + '&EpisodeID=' + episodeID + '&EpisodeIDs=&mradm=' + episodeID + '&ChartID=24&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=0&ConsultID=&ConsultEpisodeID=';}}
		});
		*/
	}


	getSouthVPort();


	function createSouthTabs()
	{
		var titleList = "  ";
		var tab = Ext.getCmp("southTabPanel");
		if(Ext.getCmp("southTabPanel"))
		{
			var pageUrlList = pageUrl.split("^^");
			for (var i = 0; i < pageUrlList.length -1; i++)
			{
				var urlDetial = pageUrlList[i].split('#');
				var url = urlDetial[0];
				var title = urlDetial[1];
				var paras = urlDetial[2];
				
				//替换形参为实际参数值
				var parasFinal = paras.replace(/\[patientID\]/g, patientID);
				parasFinal = parasFinal.replace(/\[episodeID\]/g, episodeID);
				parasFinal = parasFinal.replace(/\[mradm\]/g, mradm);
				parasFinal = parasFinal.replace(/\[regNo\]/g, regNo);
				parasFinal = parasFinal.replace(/\[medicare\]/g, medicare);
				parasFinal = parasFinal.replace(/\[userID\]/g, userID);
				parasFinal = parasFinal.replace(/\[userCode\]/g, userCode);
				parasFinal = parasFinal.replace(/\[ctLocID\]/g, ctLocID);
				parasFinal = parasFinal.replace(/\[ctLocCode\]/g, ctLocCode);
				parasFinal = parasFinal.replace(/\[ssGroupID\]/g, ssGroupID);
				
				titleList += title;
				titleList += "/";
				if (i == 0)
				{
					tab.add(
							{
								'title' : title,
								layout : 'fit',
								autoLoad : { url : url + '?' + parasFinal, scripts : true, scope : this },                        
								closable : false,
								autoScroll: true
							}
						);
				}
				else
				{
					tab.add(
							{
								'title' : title,
								layout : 'fit',
								//autoLoad : { url : url + '?' + parasFinal, scripts : true, scope : this },                        
								html:'<iframe style="width:100%; height:100%" src=' + url + '?' + parasFinal + '></iframe>',
								closable : false,
								autoScroll: true
							}
						);
				}
			}
			
			if (isShowBrowserTest == "Y")
			{
				tab.add({
						border: false,
						title: '浏览测试',
						id: 'tabeprbrowertest',
						layout: 'fit',
						closable: false,
						autoScroll: true,
						html:'<iframe id="eprbrowertestframe" style="width:100%; height:100%" src="epr.newfw.browsertest.csp?PatientID=' + patientID + '&EpisodeID=' + episodeID + '" ></iframe>'
				});
				titleList += "浏览测试/"
			}
			
			tab.add({
					border: false,
					title: '病历浏览',
					id: 'tabeprbrower',
					layout: 'fit',
					closable: false,
					autoScroll: true,
					autoLoad : { url : "epr.newfw.browser.csp?patientID=" + patientID + "&episodeID=" + episodeID, callback : function() { }, scripts : true, scope : this }
			})		
			tab.hideTabStripItem('tabeprtest');
			tab.setActiveTab(1);
			
			
			titleList += "病历浏览"
			parent.document.getElementById('southTitleInfo').innerHTML = titleList;
			parent.Ext.getCmp('mainSouth').setTitle(titleList);
		
		}		
	}
	createSouthTabs();
	//document.getElementById("tabeprorderFrame").src='./epr.chart.csp?PatientID=' + patientID + '&EpisodeID=' + episodeID + '&EpisodeIDs=&mradm=' + episodeID + '&ChartID=8&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=0&ConsultID=&ConsultEpisodeID=';
	//Ext.getCmp('southTabPanel').setActiveTab.defer(3000, Ext.getCmp('southTabPanel'), ['tabeprbrower']);