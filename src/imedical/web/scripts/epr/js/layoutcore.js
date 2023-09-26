var tabpannel;    

Ext.onReady(function(){

        //Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
//--------------------------------------------------
	tabpannel = new Ext.TabPanel({
              region:'center',
              deferredRender: false,
              activeTab:0,
              minTabWidth: 100,
              resizeTabs: true,
              border: false,	
	      enableTabScroll: false,
	      defaults: {autoScroll:false},
	      autoDestroy: false,
	      listeners:{
                remove: function(tp, c) {c.hide();},

			
		tabchange: function(tabpanel, panel) 
		{			
		    if (panel.id == 'eprlist')
                    {					
			if (document.frames["frameeprlist"].ajaxAction)
			{
			    document.frames["frameeprlist"].ajaxAction();
			}
		    }
		}
	      },
              items:[
		new Ext.BoxComponent({
		 id: 'eprquality',
		 el: 'frameeprquality',
	         title: '质控提示',
                 autoScroll: false
                }),
		new Ext.BoxComponent({
		 id: 'epredit',
		 el: 'frameepredit',
	         title: '病历书写',
                 autoScroll: false
                }),
		new Ext.BoxComponent({
		 id: 'eprlist',
		 el: 'frameeprlist',
	         title: '病程列表',
                 autoScroll: false
                }),
		new Ext.BoxComponent({
		 id: 'eprbrowser',
		 el: 'frameeprbrowser',
	         title: '病历浏览',
                 autoScroll: false
                })
		]
       });

       var southTab = new Ext.TabPanel({
                            border:false,
                            activeTab:0,
                            tabPosition:'bottom',
                            deferredRender: false,
              items:[
		new Ext.BoxComponent({
		 id: 'eprorder',
		 el: 'frameorder',
	         title: '本次医嘱',
                 autoScroll: false
                }),
		new Ext.BoxComponent({
		 id: 'eprexam',
		 el: 'frameexam',
	         title: '检查结果',
                 autoScroll: false
                }),
		new Ext.BoxComponent({
		 id: 'eprtest',
		 el: 'frametest',
	         title: '化验结果',
                 autoScroll: false
                }),
        new Ext.BoxComponent({
		 id: 'eprtbrower',
		 el: 'frameeprbrowsersouth',
	         title: '病历浏览',
                 autoScroll: false
                }) 
                
		]
                        })
        
       var viewport = new Ext.Viewport({
            layout:'border',
            items:[
                {
		    id:'southregion',
                    region:'south',
		    contentEl: 'south',
                    split:true,
                    height: 280,
                    minSize: 100,
                    maxSize: 430,
                    collapsible: true,
		    collapsed: true,
                    title:'本次医嘱',
                    layout:'fit',
                    autoScroll:true,
		    items:[southTab]
                },tabpannel
             ]
        });

//---------------------------------------------------------------------
	tabpannel.remove('eprlist');
	tabpannel.remove('epredit');

	

	southTab.on('tabchange', function(tab, activetabItem){
		viewport.getComponent('southregion').setTitle(activetabItem.title);
	
		if (activetabItem.id=='eprorder'){}
		else if (activetabItem.id=='eprexam'){if (Ext.getDom("frameexam").src==''){Ext.getDom("frameexam").src='./epr.chart.csp?PatientID=' + PatientID + '&EpisodeID=' + EpisodeID + '&EpisodeIDs=&mradm=' + EpisodeID + '&ChartID=23&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=0&ConsultID=&ConsultEpisodeID=';}}
		else if (activetabItem.id=='eprtest'){if (Ext.getDom("frametest").src==''){Ext.getDom("frametest").src='./epr.chart.csp?PatientID=' + PatientID + '&EpisodeID=' + EpisodeID + '&EpisodeIDs=&mradm=' + EpisodeID + '&ChartID=24&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=0&ConsultID=&ConsultEpisodeID=';}}
		else if (activetabItem.id=='eprtbrower'){if (Ext.getDom("frameeprbrowsersouth").src==''){Ext.getDom("frameeprbrowsersouth").src='./epr.newfw.eprbrowser.csp?EpisodeID=' + EpisodeID;}}
	});

	Ext.getDom("frameeprquality").src='./epr.newfw.qualityreport.csp?EpisodeID=' + EpisodeID;
	Ext.getDom("frameeprbrowser").src='./epr.newfw.eprbrowser.csp?EpisodeID=' + EpisodeID;
	//Ext.getDom("frameorder").src='./websys.csp?a=a&TMENU=50789&TPAGID=109751519&TWKFLJ=websys.csp^27153688&PatientID=' + PatientID + '&EpisodeID=' + EpisodeID + '&mradm=' + EpisodeID + '&WardID=';
	Ext.getDom("frameorder").src='./epr.chart.csp?PatientID=' + PatientID + '&EpisodeID=' + EpisodeID + '&EpisodeIDs=&mradm=' + EpisodeID + '&ChartID=22&PAAdmTransactionID=&OperRoomID=&DischID=&CurrDischID=&DischEpisodes=&doctype=&TWKFL=&TWKFLI=&TimeLine=0&ConsultID=&ConsultEpisodeID='
 
    });