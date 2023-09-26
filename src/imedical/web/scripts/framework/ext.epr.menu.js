/*
 * Ext JS Library 3.1.0
 * Copyright(c) 2009-2010 DHCC
 */

Ext.onReady(function(){

    Ext.QuickTips.init();
    var groupId = "1";  // session['LOGON.GROUPID'];
    var centerpanel = new Ext.Toolbar({
    	id:'centerpanel',
    	autoScroll : true ,
    	//region:"center",
    	items:[]
    });
   
   //##class(ext.websys.Menu).ShowToolBarJosn(1073)
   var menusJson = tkMakeServerCall("ext.websys.Menu","GetMainMenuJosn");
   if (menusJson=="") return;
   window.eval("var menuArray = " + menusJson);
   
   for(var intRow = 0; intRow < menuArray.length; intRow ++)
	{
		var menuObj = menuArray[intRow];		
		var menuItem = new Ext.menu.Item({
			id: menuObj.id,
			text: menuObj.text,
    		href: menuObj.href,
    		hrefTarget: menuObj.hrefTarget,
    		icon: menuObj.icon,
			listeners:{	"click":onItemClick	}
		});
		centerpanel.add(menuItem);
		/*
		var mi = new Ext.menu.Item({
			id:'mi-'+intRow,
			text:'mi-'+intRow,
    		//href:"http://www.google.com",\
    		href:"javascript:SetKeepOpen('websys.csp?a=a&TMENU=2&TPAGID=110211229', '');",
    		hrefTarget:"TRAK_main",
    		icon:
			listeners:{	"click":onItemClick	}
			});
		centerpanel.add(mi);
		*/
	}
	centerpanel.setHeight(35);
    centerpanel.render(document.body);    
    
  	function onItemClick(item,event){
  		//alert(item.href);
  		//window.location=item.href;
  		//this.DOM.Script.window.open(item.href,item.hrefTarget);
  		//var strobj = '[{"id":"1","text":"传染病报告","iconCls":"icon-menu","leaf":true,"cls":"forum","href":"http://www.google.com"},{"id":"2","text":"监控","iconCls":"","expanded":true,"leaf":false,"children":[{"id":"3","text":"日常监控","iconCls":"icon-menu","leaf":true,"cls":"forum","href":"http://www.google.com"},{"id":"4","text":"监控结论","iconCls":"icon-menu","leaf":true,"cls":"forum","href":"http://www.google.com"}]}]';
  		//window.eval("var objResult = " + strobj);
  		//alert(objResult);
  		
  		//window.open(item.href,item.hrefTarget);
  		//window.eval(item.href);
  		
  		var s = item.href;
		if (s.indexOf("javascript")>-1){
			window.eval(item.href);
		}
		else{
			window.open(item.href,item.hrefTarget);
		}
  		
  	}
});