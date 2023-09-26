
//模板选择界面
function templateSelect(node, episodeID) {
    var win = Ext.getCmp("winTemplateSelect");
    if (!win) {
        var win = new Ext.Window(
        {
            id: 'winTemplateSelect',
            title: '模板选择',	  
            broder: false,
            frame : true,  
            footer: true,
            width: 325,
            height: 450,
            layout: 'fit',
            maximizable: false,
            minimizable: false,
            shim: false,	    
            animCollapse: false,
            constrainHeader: true,
            resizable: false,
            modal: true,
	        listeners : 
               {
                   'close' : function()
                   {
                       //窗体关闭时将dll显示
                       setDllVisibility("visible");                     	
                   }
               },
	        bbar: new Ext.Toolbar
            ({
                id : 'bbarTemplateSelect',
                height: 20
            }),
	        items: gridTemplate(node, node.id, episodeID)
	    
            
        });
    }
    win.show();
    //pnlTemplateSelect.setHeight(450);
    //pnlTemplateSelect.setWidth(300);
//    var body = Ext.get("gridTemplate");
//    body.mask('读取中……', 'x-mask-loading');    
}    


function gridTemplate(node, nodeId, episodeID) {
    var sm = new Ext.grid.CheckboxSelectionModel({ singleSelect: true});     //创建checkbox列
    var cm = new Ext.grid.ColumnModel                   //创建grid列
            ([
				sm,
                //{ header : 'ID', dataIndex : 'ID', hidden: true },
                {header: '模板名称', dataIndex: 'templateName', width: 275, sortable: false}
                
            ]);
    //cm.defaultSortable = false;          //允许排序

    var ds = new Ext.data.Store         //创建数据源格式
            ({
                proxy: new Ext.data.HttpProxy({ url: 'web.eprajax.doclistforswitch.cls?DocID=' + nodeId.substring(2, nodeId.length) + '&EpisodeID=' + episodeID }),     
                reader: new Ext.data.JsonReader(
                {                    
                    root: 'root'                               //具体数据
                },
                [
                    { name: 'ID' },
                    { name: 'templateName' },
                    { name: 'BindPrintTplID'}
                ])
                });

    
    ds.load();

    var tbar = new Ext.Toolbar({ border: false, items: [        
        '->', '-',
        { id: 'btnsConfirmTS', text: '确定',  pressed: false, handler: confirm },
        '-',
        { id: 'btnCloseTS', text: '关闭',  pressed: false, handler:cancel }]
    });

    function updatingTemplate() {
        var body = Ext.get("gridTemplate");
        body.mask('读取中……', 'x-mask-loading');
    }


    function updatedTemplate() {
        var body = Ext.get("gridTemplate");
        body.unmask();
    }


    ds.addListener('loadexception', updatedTemplate);
    ds.addListener('load', updatedTemplate);

    
    

    //创建grid
    var grid = new Ext.grid.GridPanel
            ({
                id: 'gridTemplate',
                ds: ds,
                autoScroll: true,
				tbar: tbar,
                cm: cm,
                sm: sm,
                frame: true                
            });

    //单元格双击事件
    var celldbclick = function(grid, rowIndex, e) {
        confirm();
    }

    grid.addListener('rowdblclick', celldbclick);    


	function invokeSinglePrviewInSltTpl(iframeID, newBindPrintTplID, newPrintTplDocID) {
    	if (frames['centerTab'].frames[iframeID])
        {
          	frames['centerTab'].frames[iframeID].invokeSinglePreviewBySltTpl(newBindPrintTplID, newPrintTplDocID);
        }
    }
    //确定按钮事件
    function confirm()
    {
		var grid = Ext.getCmp('gridTemplate');
    	var count = grid.getSelectionModel().getCount();
        if (count == 0) {
            var bbar = Ext.getDom('bbarTemplateSelect');
			bbar.innerHTML = '<div style="font-weight:bold;">请先选择一个模板!</div>';
            return;
        }
        else if (count > 1) {
            var bbar = Ext.getDom('bbarTemplateSelect');
			bbar.innerHTML = '<div style="font-weight:bold;">一次只能选择一个模板!</div>';
            return;
        }

        //add by YHY on 2013-02-22
		//点击确定按钮提示
		Ext.MessageBox.buttonText.yes = "是";
		Ext.MessageBox.buttonText.no = "否";
        Ext.MessageBox.confirm("注意！","本操作将清除当前模板中的所有内容，是否继续？",function(button){ 
        if (button=='yes')
        {
             //得到选中行的record
			for (var i = 0; i < grid.store.getCount(); i++) {
				if (grid.getSelectionModel().isSelected(i)) {
					record = grid.store.getAt(i);
					break;
				}
			}
        
			// lingchen CA
			var tabPanel = frames["centerTab"].Ext.getCmp('centerTabPanel');
			var currentTab = tabPanel.getActiveTab();
			var tabID = currentTab.id;
			var prtIndex = tabID.indexOf("And");
			var templateDocID = tabID.substring(7, prtIndex);
			var prtTemplateDocID = tabID.substring(prtIndex + 3);
			var iframeID = String.format("iframe{0}And{1}", templateDocID, prtTemplateDocID);
			 if (frames['centerTab'].frames[iframeID])
			{
			frames['centerTab'].frames[iframeID].frames['epreditordll'].document.getElementById('eprform').PrnTemplateDocID=printTemplateDocId;
			var ret=frames['centerTab'].frames[iframeID].frames['epreditordll'].document.getElementById('eprform').CheckValidSign();
			if (!ret)  return;
			}        
        
			var newDocID = record.get("ID");
			var newBindPrintTplID = record.get("BindPrintTplID");
			var oldPrtDocID = node.id.substring(2, node.id.length);
        //该请求返回后台处理切换模板是否成功
			Ext.Ajax.request({
				url: 'web.eprajax.switchmanager.cls',
				timeout: timedOut,
				params: { EpisodeID: episodeID, DocID:oldPrtDocID, newDocID: newDocID.substring(2, newDocID.length) },
				success: function(response, opts) {
					var obj = response.responseText;
					if (obj == "success" || obj == "NoLog")
					{
                		//debugger;
                		invokeSinglePrviewInSltTpl(iframeID, newBindPrintTplID, newDocID.substring(2, newDocID.length));
                	
						clearNode();					
						node.id = newDocID;
						treeLoader.load(node, function loaded(){ 
							node.expand(); 
							frames['centerTab'].removeSamePrtDocIDTab(oldPrtDocID); 
							Ext.getCmp('winTemplateSelect').close();
						});		//重新加载树
					}
					else if (obj == "sessionTimedOut")
					{
						alert("登陆超时,会话已经中断,请重新登陆在进行操作!");
					}
					else
					{
						alert("操作失败，失败原因：" + response.responseText);   
					}
				},
				failure: function(response, opts) {                
					var obj = response.statusText;
					alert(obj);
				}
			});
	    
        }
		else if (button=='no')
		{
			cancel();
		}
        }); 
    }

    //取消按钮事件
    function cancel()
    {
		Ext.getCmp('winTemplateSelect').close();
    }

    ///add by zhuj on 2009-7-28
	///模板切换，目前已经不用，日志记录放到了后台
	function switchLog(EPRNum)
	{
		Ext.Ajax.request({
			url: 'web.eprajax.logs.switch.cls',
			timeout : timedOut,
			params: { EpisodeID: episodeID, EPRDocID: printTemplateDocId, templateDocId: templateDocId, EPRNum: EPRNum},
			success: function(response, opts) {
				var obj = response.responseText;
				if (obj == "NoLog")
				{
					return;	
				}
				if (obj == "success")
				{					
					
				}
				else
				{
					alert("写入日志错误!错误原因:" + obj);
				}
			},
			failure: function(response, opts) {				
				var obj = "写入日志错误,错误代码:" + response.status + "," + "错误信息:" + response.statusText;				
				alert(obj);
			}
		});
	}
    
    return grid;
}
