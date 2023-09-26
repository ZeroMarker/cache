var ResonList="",json=[];
var RepID="",StrParam="";
$(function(){  
	RepID=getParam("RepID");
	StrParam=getParam("StrParam");
	ResonList=serverCall("web.DHCADVCOMMONPRINT","GetRepEvaluateToJson",{"ReportID":RepID,"StrParam":StrParam});
	if (ResonList==""){
		$.messager.alert("提示:","无原因分析数据");
		return;
	}
	json=eval('(' + ResonList + ')');//json处理
	init();
});
function init() {
	// if (window.goSamples) goSamples();  // init for these samples -- you don't need to call this
	var $ = go.GraphObject.make;  // for conciseness in defining templates

	myDiagram =$(go.Diagram, "myDiagramDiv",  // refers to its DIV HTML element by id
		{ isReadOnly: true }
	);  // do not allow the user to modify the diagram

	// define the normal node template, just some text
	myDiagram.nodeTemplate =$(go.Node, "Auto",
		$(go.TextBlock,
			new go.Binding("text"),
			new go.Binding("font", "", convertFont))
	);

	function convertFont(data) {
		var size = data.size;
		if (size === undefined) size = 13;
		var weight = data.weight;
		if (weight === undefined) weight = "";
		return weight + " " + size + "px sans-serif";
	}

	// This demo switches the Diagram.linkTemplate between the "normal" and the "fishbone" templates.
	// If you are only doing a FishboneLayout, you could just set Diagram.linkTemplate
	// to the template named "fishbone" here, and not switch templates dynamically.

	// define the non-fishbone link template
	myDiagram.linkTemplateMap.add("normal",
	$(go.Link,
		{ routing: go.Link.Orthogonal, corner: 4 },
		$(go.Shape)
	));

	// use this link template for fishbone layouts
	myDiagram.linkTemplateMap.add("fishbone",
	$(FishboneLink,  // defined above
		$(go.Shape)
	));

	function walkJson(obj, arr) {
		var key = arr.length;
		obj.key = key;
		arr.push(obj);

		var children = obj.causes;
		if (children) {
			for (var i = 0; i < children.length; i++) {
				var o = children[i];
				o.parent = key;  // reference to parent node data
				walkJson(o, arr);
			}
		}
	}

	// build the tree model
	var nodeDataArray = [];
	walkJson(json, nodeDataArray);
	myDiagram.model = new go.TreeModel(nodeDataArray);

	layoutFishbone();
}

// use FishboneLayout and FishboneLink
function layoutFishbone() {
	myDiagram.startTransaction("fishbone layout");
	myDiagram.linkTemplate = myDiagram.linkTemplateMap.getValue("fishbone");
	myDiagram.layout = go.GraphObject.make(FishboneLayout, {  // defined above
		angle: 180,
		layerSpacing: 10,
		nodeSpacing: 20,
		rowSpacing: 10
	});
	myDiagram.commitTransaction("fishbone layout");
}

// make the layout a branching tree layout and use a normal link template
function layoutBranching() {
	myDiagram.startTransaction("branching layout");
	myDiagram.linkTemplate = myDiagram.linkTemplateMap.getValue("normal");
	myDiagram.layout = go.GraphObject.make(go.TreeLayout, {
		angle: 180,
		layerSpacing: 20,
		alignment: go.TreeLayout.AlignmentBusBranching
	});
	myDiagram.commitTransaction("branching layout");
}

// make the layout a basic tree layout and use a normal link template
function layoutNormal() {
	myDiagram.startTransaction("normal layout");
	myDiagram.linkTemplate = myDiagram.linkTemplateMap.getValue("normal");
	myDiagram.layout = go.GraphObject.make(go.TreeLayout, {
		angle: 180,
		breadthLimit: 1000,
		alignment: go.TreeLayout.AlignmentStart
	});
	myDiagram.commitTransaction("normal layout");
}
