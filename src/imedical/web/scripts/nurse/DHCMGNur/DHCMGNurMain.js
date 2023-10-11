/**
 * @author Qse
 */
Ext.onReady(function(){ 

new Ext.Viewport({

layout:"border",

items:[{region:"north",
collapsible: true,
split: true,
height:50,

title:"顶部面板"},

{region:"south",
split: true,
height:50,
layout:"fit",
html:'<iframe id="eprbrowertestframe" style="width:100%; height:100%" src="DHCNurSyRoomSeatMap.csp" ></iframe>',

collapsible: true,
split: true,
title:"底部面板"},

{region:"center",
collapsible: true,
split: true,
title:"中央面板"},

{region:"west",

width:100,
collapsible: true,
split: true,
title:"左边面板"},

{region:"east",
collapsible: true,
split: true,
width:100,

title:"右边面板"}

]

}); 

});
