Ext.onReady(function(){

        Ext.state.Manager.setProvider(new Ext.state.CookieProvider());

//-----------------------------------
        
       var viewport = new Ext.Viewport({
            layout:'border',
            items:[
		    {
                    region:'west',
                    id:'west-panel',
                    title:'病历列表',
                    split:true,
                    width: 175,
                    minSize: 50,
                    maxSize: 175,
                    collapsible: true,
                    margins:'0 0 0 5',
                    layout:'accordion',
                    layoutConfig:{
                        animate:true
                    },
                    items: [{
                    	contentEl:'currentDocs',
                        title:'本次病历',
                        border:false,
                        iconCls:'nav'
                    },{
                    	contentEl:'pastDocs',
                        title:'既往病历',
                        border:false,
                        iconCls:'settings'
                    }]
                },
                new Ext.BoxComponent({
		 id: 'centerbox',
		 region:'center',
		 el: 'framecenter',
                 autoScroll: false
                })
             ]
        });

	Ext.getDom("framecenter").src='./epr.newfw.frameworkcenter.csp?EpisodeID=' + EpisodeID + '&PatientID=' + PatientID;
    });