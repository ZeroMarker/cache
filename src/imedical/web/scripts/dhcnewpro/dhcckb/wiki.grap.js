$(function(){ 
	igraph.i18n.setLanguage("chs");
	
	var app = new igraph.GraphNavigator(document.getElementById('graphArea'));
	app.loadGson("web.DHCCKBWiki.cls?IncId="+$("#IncId").val());
	/* 
	var app = new igraph.GraphExplorer(document.getElementById('graphArea'));
	app.connect("web.DHCCKBWiki.cls?IncId="+$("#IncId").val()+"&",function () {
            app.pickup([{
                label: "°¢ÄªÎ÷ÁÖ"
            }]);
    });
    */
})


       
        
/*
app.showNodesOfCategory();
app.toggleEdges();
app.toggleFaces();       
app.toggleNavigationButtons();
app.toggleNodeBorder();
app.toggleShadow();
app.toggleShowEdgeLabelAlways();
app.toggleWeights();
app.toggleEdgeColor();
*/