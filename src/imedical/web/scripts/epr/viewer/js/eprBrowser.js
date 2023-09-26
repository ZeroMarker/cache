/*
//病历浏览的窗体
MyDesktop.BrowserWindow = Ext.extend(Ext.app.Module, {
    id:'browser-win',
    init : function(){
        this.launcher = {
            text: '病历浏览',
            iconCls: 'accordion',
            handler: this.createWindow,
            scope: this
        }
    },

    createWindow : function(episodeID, printTemplateDocID, templateDocID){
        var desktop = this.app.getDesktop();
        var win = desktop.getWindow('viewBrowser');
        if(!win){
            win = desktop.createWindow({
                id: 'viewBrowser',
                title: '病历浏览',
                width: 640,
                height: 480,
                iconCls: 'accordion',
                shim: false,
                animCollapse: false,
                constrainHeader: true,
                layout: 'fit',
                border: false,
                layoutConfig: {
                    animate: false
                },
                html: '<iframe id="frameBrowser" style="z-index: -1; border-style: none; border-width: 0px; padding: 0px; margin: 0px; width:100%; height:100%"></iframe>'
            });
            win.setPosition(290, 50);
        }
        
        Ext.getDom('frameBrowser').src = 'epr.newfw.viewerSingle.csp?EpisodeID=' + episodeID + '&PrintTemplateDocID=' + printTemplateDocID + '&TemplateDocID=' + templateDocID;
        win.show();
    }
});
*/


//创建一个浏览窗口
function createBorwserWin(num)
{
	var windowsID = 'browser_' + num;
	var desktopWinID = 'desktop_' + windowsID;
	var frameID = 'frame_' + windowsID;
	
	//病历浏览的窗体
	MyDesktop.BrowserWindow = Ext.extend(Ext.app.Module, {
		id: desktopWinID,
		init : function(){
			this.launcher = {
				text: '病历浏览',
				iconCls: 'accordion',
				handler: this.createWindow,
				scope: this
			}
		},

		createWindow : function(episodeID, printTemplateDocID, templateDocID){
			var desktop = this.app.getDesktop();
			var win = desktop.getWindow(windowsID);
			if(!win){
				win = desktop.createWindow({
					id: windowsID,
					title: '病历浏览',
					width: 640,
					height: 480,
					iconCls: 'accordion',
					shim: false,
					animCollapse: false,
					constrainHeader: true,
					layout: 'fit',
					border: false,
					layoutConfig: {
						animate: false
					},
					html: '<iframe id="' + frameID + '" style="z-index: -1; border-style: none; border-width: 0px; padding: 0px; margin: 0px; width:100%; height:100%"></iframe>'
				});				
			}
			Ext.getDom(frameID).src = 'epr.newfw.viewerSingle.csp?EpisodeID=' + episodeID + '&PrintTemplateDocID=' + printTemplateDocID + '&TemplateDocID=' + templateDocID;
			win.show();
		}
	});
	return new MyDesktop.BrowserWindow();
}

//创建一个窗体集合
function createBorwserWinList(count)
{
	var arrWin = new Array();
	arrWin[0] = new MyDesktop.AccordionWindow();
	for (var i = 1; i <= count; i++)
	{
		arrWin[i] = createBorwserWin(i);
	}
	return arrWin;
}


