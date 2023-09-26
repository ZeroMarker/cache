
var DHCRunClassMethod,paramStr;
Ext.BLANK_IMAGE_URL = '../images/default/s.gif';
Ext.onReady(function(){
    var tabs = new Ext.TabPanel({
        renderTo:'tabs',
        resizeTabs:true, // turn on tab resizing
        listeners: {tabchange : handleRemove},
        minTabWidth: 110,
        tabWidth:120,
        enableTabScroll:true,
        width:380, 
        height:250,
        defaults: {autoScroll:true},
        autoShow: false
        //plugins: new Ext.ux.TabCloseMenu()
    }); 
	var actionStr="##Class(web.DHCMessage).GetMessageCatTabs";
	var userId=document.getElementById('userId').value;
	var groupId=document.getElementById('groupId').value;
	var ctlocId=document.getElementById('ctlocId').value;
	//DHCRunClassMethod=document.getElementById('DHCRunClassMethod').value;
	//paramStr='"'+userId+"^"+groupId+"^"+ctlocId+'"';
	//var retStr=cspRunServerMethod(DHCRunClassMethod,actionStr,"");
	var retStr=tkMakeServerCall("web.DHCMessage","GetMessageCatTabs","");
	//var retStr="1^EPR^µç×Ó²¡Àú";

	if((retStr!=null)&&(retStr!=""))
	{
		var tabsList=retStr.split("!");
		for (var i=0;i<tabsList.length;i++)
		{
			var tabItem=tabsList[i].split("^");
			var itemId=tabItem[0];
			var itemName=tabItem[1];
			var itemTitle=tabItem[2];
			var paramStr="userId="+userId+"&groupId="+groupId+"&ctlocId="+ctlocId+"&tabId="+itemId  //+'&DHCRunClassMethod="'+DHCRunClassMethod+'"'
			if (itemName == "EPR")
			{
			    
			    addEPRTab();
			}
			else
			{
				addTab();
			}
		}
	}
	function addEPRTab(){
        tabs.add({
            id: itemId,
            name: itemName,
            title: itemTitle,
            listeners: {activate: handleActivate},
            iconCls: 'tabs',
            html: '<iframe id="eprtab" src="dhc.epr.messagetab.csp?' + paramStr + ' width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>', 
            closable:true
        }).show();
	}	
    function addTab(){
        tabs.add({
	        id: itemId,
	        name: itemName,
            title: itemTitle,
            listeners: {activate: handleActivate},
            iconCls: 'tabs',
            //html: ssss,   ///'Tab Body ' + (itemId) + '<br/><br/>'+'<SCRIPT language=javascript> alert(1)</SCRIPT>',
                    //+ bogusMarkup,
                    //
            //html: "'tabs'<SCRIPT language=javascript> alert(1)</SCRIPT>"
            //"<iframe id='"+id+"' src="+dhcmessagetab.csp+"?"+paramStr+" frameborder=0 scrolling=no width='100%' height='100%' style='height:100%'></iframe>",
            autoLoad: {url: 'dhcmessagetab.csp', params: paramStr},
            closable:true
        });
        
        ///if(index==1) this.show();
    }

    /*new Ext.Button({
        text: 'Add Tab',
        handler: addTab,
        iconCls:'new-tab'
    }).render(document.body, 'tabs');*/
    function handleActivate(tab){
    }
    function handleRemove(tab,b)
    {
	    //alert(tab)
    }
});

Ext.ux.TabCloseMenu = function(){
    var tabs, menu, ctxItem;
    this.init = function(tp){
        tabs = tp;
	    try{ tabs.on('contextmenu', onContextMenu); }
	    catch(e){}
    }
    function onContextMenu(ts, item, e){
        if(!menu){ // create context menu on first right click
            menu = new Ext.menu.Menu([{
                id: tabs.id + '-close',
                text: 'Close Tab',
                handler : function(){
                    tabs.remove(ctxItem);
                }
            },{
                id: tabs.id + '-close-others',
                text: 'Close Other Tabs',
                handler : function(){
                    tabs.items.each(function(item){
                        if(item.closable && item != ctxItem){
                            tabs.remove(item);
                        }
                    });
                }
            }]);
        }
        ctxItem = item;
        var items = menu.items;
        items.get(tabs.id + '-close').setDisabled(!item.closable);
        var disableOthers = true;
        tabs.items.each(function(){
            if(this != item && this.closable){
                disableOthers = false;
                return false;
            }
        });
        items.get(tabs.id + '-close-others').setDisabled(disableOthers);
        menu.showAt(e.getPoint());
    }
};


//Sleep(this,200000);
function Sleep(obj,iMinSecond)
{
   if (window.eventList==null) 
   window.eventList=new Array(); 
   var ind=-1;
   for (var i=0;i<window.eventList.length;i++)
   {  
    if (window.eventList[i]==null) 
    { 
     window.eventList[i]=obj;   
     ind=i;  
     break;  
    } 
   } 
   if (ind==-1)
   {  
    ind=window.eventList.length;  
    window.eventList[ind]=obj;
   } 
   setTimeout("GoOn(" + ind + ")",iMinSecond);
}
function GoOn(ind)
{ 
   var obj=window.eventList[ind];
   window.eventList[ind]=null;
   if (obj.NextStep) obj.NextStep();
   else obj();
}