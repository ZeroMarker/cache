/**
 * @author Qse
 */
var frmMainContent = new Ext.Viewport(
        {
            id: 'mainViewPort',
            shim: false,
            animCollapse: false,
            constrainHeader: true, 
            margins:'0 0 0 0',           
            layout: 'border',        
			border: false,             
            items: [{ 
			
                        region: 'west', 
                        layout: 'accordion',
                        title: '病历列表',
                        width: treeWidth, 
                        split: true, 
                        collapsible: true, 
                        bbar: treeBbar,
                        //titleCollapse: true,
                        //html: '<iframe marginheight="0" marginwidth="0" height="100%" width="100%"></iframe>'
                       items: [{
                    		//contentEl:'currentDocs',
                    		autoLoad: { scripts: true, scope: this, url:"epr.newfw.tree.csp",callback: function(){}},
                        	title:'本次病历',
                        	border:false,
                        	iconCls:'nav'
                    		}
							//,{
                    		//contentEl:'pastDocs',
                        	//title:'既往病历',
                        	//border:false,
                        	//iconCls:'settings'
                    		//}
						]},
                        { region: 'center', layout: "border", id: "mainCenter",
                            items: [
                                    { border: false,tools: tools, id: 'mainSouth', region: 'south', title: ' ', split: true, collapsible: true, collapsed: true, titleCollapse: false, layout: 'fit', height: 280,
                                        html: '<iframe id ="southTab" style="width:100%; height:100%" src="epr.newfw.southTab.csp?episodeID=' + episodeID + '&patientID=' + patientID + '&templateDocId=' + templateDocId + '&printTemplateDocId=' + printTemplateDocId + '" ></iframe>'
                                    },
                                    { border: false,region: 'center', layout: 'fit', 
                                    	html: '<iframe id ="centerTab" style="width:100%; height:100%;" src="epr.newfw.centerTab.csp?episodeID=' + episodeID + '&patientID=' + patientID + '&templateDocId=' + templateDocId + '&printTemplateDocId=' + printTemplateDocId + '" ></iframe>'
                                    	//autoLoad: { scripts: true, scope: this, url:"epr.newfw.epreditordll.csp",callback: function(){}} 
                                    }
								]
                        }
                    ]
        });