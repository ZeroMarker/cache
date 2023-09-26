/*!
 * Ext JS Library 3.2.1
 * Copyright(c) 2006-2010 Ext JS, Inc.
 * licensing@extjs.com
 * http://www.extjs.com/license
 Œ‚»∫ø∆ 15:37:57
  html : '<iframe id="dhcmed_crf_form" src= '+ obj.link + ' width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>',
	var ifrmCRFForm = document.getElementById("dhcmed_crf_form");
obj.link = "dhcmed.crf.directrun.csp?formid=" + obj.formid + "&keyid=" + obj.keyid; // + "&printed=" + printed;
		//var html = '<iframe id="dhcmed_crf_form" src= '+ obj.link + ' width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>',
		ifrmCRFForm.src = obj.link;

 */
Ext.ux.Portlet = Ext.extend(Ext.Panel, {
    anchor : '100%',
    frame : true,
    collapsible : true,
    draggable : true,
   // autoScroll :true,
    cls : 'x-portlet',
    //html : '<iframe id="frm_Content" src= "" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>',
	tools : [{
        id:'refresh',
        handler: function(e, target, panel){
            panel.reload();
        }
    },{
    	id:'maximize',
    	handler: function(e, target, panel){
    		panel.ownerCt.ownerCt.maximizeConfig(panel);
      }
    }
   /* ,{
        id:'close',
        handler: function(e, target, panel){
          //  panel.ownerCt.remove(panel, true);
           panel.ownerCt.ownerCt.proviteConfig(panel);
        }
    }*/
    ],
    listeners:{
    	"afterrender":function(){
    		this.reload();
    	}
    },
    reload : function(){
	    //var html = '<iframe id="frm_Content_';
	    //html+=this.id;
	    //html+='" src= "'
	    //html+='dhcmed.portletdefalut.csp?id=';
	    //html+=this.id
	    //html+='" height="100%" frameborder="0" scrolling="auto"></iframe>';
	    //alert(html);
	    //this.html=html;
	    //this.doLayout(true,true);
	    
	    
	    
	    // html : '<iframe id="frm_Content" src= "" width="100%" height="100%" frameborder="0" scrolling="auto"></iframe>',
	    var ifrm = document.getElementById("frm_Content_"+this.id);
	    //alert(ifrm);
	    if (ifrm) {
	    	var link = 'dhcmed.portletdefalut.csp?id=' + this.id;
	    	ifrm.src = link;
	    }
	    /*
    	this.load({
    			url: 'dhcmed.portletdefalut.csp',
			    params: {id: this.id}, 
			    //discardUrl: false,
			    //nocache: false,
			    text: 'Loading...',
			    timeout: 300
    		})*/
    } 
});

Ext.reg('portlet', Ext.ux.Portlet);
