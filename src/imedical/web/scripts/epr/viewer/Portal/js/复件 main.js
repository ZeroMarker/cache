/*
 * Ext JS Library 2.0
 * Copyright(c) 2006-2007, Ext JS, LLC.
 * licensing@extjs.com
 * 
 * http://extjs.com/license
 */

Ext.onReady(function(){
	var protalItems = [{
            		id: 'left',
					columnWidth: .33,
					style: 'padding:5px 0 0px 5px',
					items:
						[{
                			id:'left_up',
							title: '左1',
							layout:'fit',
							height: 300,
							html: '<iframe id = "frameLeftUp" width'
							
						},{
                			id:'left_down',
							title: '左2',	
							layout:'fit',
							height: 300,
							html: ''
						}]
					},{
            		id: 'middle',
					columnWidth: .33,
					style: 'padding:5px 0 0px 5px',
					items:
						[{
                			id:'middle_up',
							title: '中1',
							height: 300,
							layout:'fit',
							html: ''
							
						},{
                			id:'middle_down',
							title: '中2',	
							height: 300,
							layout:'fit',					
							html: ''
						}]
					},{
            		id: 'right',
					columnWidth: .33,
					style: 'padding:5px 0 0px 5px',
					items:
						[{
                			id:'right_up',
							title: '右1',
							height: 300,
							layout:'fit',
							html: ''
							
						},{
                			id:'right_down',
							title: '右2',
							height: 300,
							layout:'fit',					
							html: ''
						}]
				}]
				


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
                        width: 230, 
                        split: true, 
                        collapsible: true,
                        html: 'left'                     
					},
                    { 
						region: 'center', 
						layout: "border", 
						id: "mainCenter",
                        items: [
									{ 
										 border: false, id: 'mainSouth', region: 'south', title: ' ', split: true, collapsible: true, collapsed: true, titleCollapse: false, layout: 'fit', height: 280,
										 html: ''
									},
									{
										 xtype: 'portal',border: false, region: 'center', items: protalItems
									}
								]
                    }]
        });

});

