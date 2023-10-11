/**
 * @author Qse
 */

 Ext.onReady(function(){ 
var win = new Ext.Window({ 
width:272, 
height:233, 
title:"窗口标题", 
plain:true,   
items:{ 
xtype:"textfield", 

inputType:"image" 
}, 

listeners:{ 
"show":function(_window){ 
_window.findByType("textfield")[0].getEl().dom.src = "haitang.gif" ; 
} 
} 

}); 

win.setPagePosition(730,370); 
win.show(); 

}) 
