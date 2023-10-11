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
	init("myDiagramDiv",json);
	$("#PrintBut").on("click",function(){
		generateImages();// 调用打印
	}) 
	$("#ExpBut").on("click",function(){
		DownloadImg();// 调用导出
	}) 
});
function init(Divid,json) {
	// if (window.goSamples) goSamples();  // init for these samples -- you don't need to call this
	var $=go.GraphObject.make;  // for conciseness in defining templates

	myDiagram =$(go.Diagram, Divid,  // refers to its DIV HTML element by id
		{ isReadOnly: true,padding:15 }
	);  // do not allow the user to modify the diagram

	// define the normal node template, just some text
	myDiagram.nodeTemplate =$(go.Node, 
		$(go.TextBlock,
			new go.Binding("text"),
			new go.Binding("font", "", convertFont))
	);

	function convertFont(data) {
		var size=data.size;
		if (size === undefined) size=13;
		var weight=data.weight;
		if (weight === undefined) weight="";
		return weight + " " + size + "px sans-serif";
	}

	// This demo switches the Diagram.linkTemplate between the "normal" and the "fishbone" templates.
	// If you are only doing a FishboneLayout, you could just set Diagram.linkTemplate
	// to the template named "fishbone" here, and not switch templates dynamically.

	// define the non-fishbone link template
	myDiagram.linkTemplateMap.add("normal",
	$(go.Link,
		{ routing: go.Link.Orthogonal, corner: 4 },
		$(go.Shape, // the link shape
          {strokeWidth: 4, stroke: 'blue'})/* ,
        $(go.Shape, // the arrowhead
          {toArrow: 'Standard',
            fill: null, stroke: 'blue'}) */
	));

	// use this link template for fishbone layouts
	myDiagram.linkTemplateMap.add("fishbone",
	$(FishboneLink,  // defined above
		//{ curve: go.Link.Bezier },
		$(go.Shape, // 线条
          {strokeWidth: 2, stroke: 'blue'})
        /* $(go.Shape, // 箭头
          {toArrow: 'Standard',  //BackwardBoomerang Boomerang  Standard 箭头形状，  scale 箭头大小 ， fill填充颜色 ，stroke 箭头线条颜色
            scale: 1,fill: "red", stroke: 'red'}) */
	));

	function walkJson(obj, arr) {
		var key=arr.length;
		obj.key=key;
		arr.push(obj);

		var children=obj.causes;
		if (children) {
			for (var i=0; i < children.length; i++) {
				var o=children[i];
				o.parent=key;  // reference to parent node data
				walkJson(o, arr);
			}
		}
	}

	// build the tree model
	var nodeDataArray=[];
	walkJson(json, nodeDataArray);
	myDiagram.model=new go.TreeModel(nodeDataArray);

	layoutFishbone();
}

// use FishboneLayout and FishboneLink
function layoutFishbone() {
	myDiagram.startTransaction("fishbone layout");
	myDiagram.linkTemplate=myDiagram.linkTemplateMap.getValue("fishbone");
	
	myDiagram.layout=go.GraphObject.make(FishboneLayout, {  // defined above
		angle: 180,
		layerSpacing: 20,
		nodeSpacing: 20,
		rowSpacing: 10
	});
	myDiagram.commitTransaction("fishbone layout");
}

// make the layout a branching tree layout and use a normal link template
function layoutBranching() {
	myDiagram.startTransaction("branching layout");
	myDiagram.linkTemplate=myDiagram.linkTemplateMap.getValue("normal");
	myDiagram.layout=go.GraphObject.make(go.TreeLayout, {
		angle: 180,
		layerSpacing: 20,
		alignment: go.TreeLayout.AlignmentBusBranching
	});
	myDiagram.commitTransaction("branching layout");
}

// make the layout a basic tree layout and use a normal link template
function layoutNormal() {
	myDiagram.startTransaction("normal layout");
	myDiagram.linkTemplate=myDiagram.linkTemplateMap.getValue("normal");
	myDiagram.layout=go.GraphObject.make(go.TreeLayout, {
		angle: 180,
		breadthLimit: 1000,
		alignment: go.TreeLayout.AlignmentStart
	});
	myDiagram.commitTransaction("normal layout");
}
// 图片下载导出
function DownloadImg(){
	var db=myDiagram.documentBounds;
	var boundswidth=db.width;
	var Ratio=1;
	if(boundswidth>2000){
		Ratio=2000/boundswidth;  //修改尺寸
	}
	var blob=myDiagram.makeImage({ scale: Ratio, returnType: "blob", callback: myCallback,padding:15 });
}
function myCallback(blob) {
	var url=window.URL.createObjectURL(blob);
	var filename="myfish.png";
	var a=document.createElement("a");
	a.style="display: none";
	a.href=url;
	a.download=filename;
	if (window.navigator.msSaveBlob !== undefined) {
		window.navigator.msSaveBlob(blob, filename);
		return;
	}
	document.body.appendChild(a);
	requestAnimationFrame(function() {
		a.click();
		window.URL.revokeObjectURL(url);
		document.body.removeChild(a);
	});
}
// 将鱼骨图以图片形式显示，图片打印
function generateImages() 
{
	var imgDiv=document.createElement("printdiv");
	//imgDiv.style="display: none";  // 2021-06-07 cy 隐藏后谷歌浏览器不好用，故取消隐藏
	var db=myDiagram.documentBounds;
	var boundswidth=db.width;
	var boundsheight=db.height;
	/*var imgWidth=boundswidth;
	var imgHeight=boundswidth;
	var p=db.position;*/
	var Ratio=1;
	if(boundswidth>2000){
		Ratio=2000/boundswidth; //修改尺寸
	}
	document.body.appendChild(imgDiv);
	var img=myDiagram.makeImage({
		scale: Ratio,
		padding:15
	});
	// Append the new HTMLImageElement to the #myImages div
	img.classNam='images';
	imgDiv.appendChild(img);
	imgDiv.appendChild(document.createElement('br')); 
	AutoResizeImage(620,600,img);//图片缩放
	if(!!window.ActiveXObject||"ActiveXObject"in window){ //判断是否是IE浏览器
		document.getElementById('WebBrowser').ExecWB(6,2)		
	}else{
		 window.print();
	}
	document.body.removeChild(imgDiv);
}
// 图片缩放
function  AutoResizeImage(maxWidth,maxHeight,objImg){
	var img=new Image();
	img.src=objImg.src;
	var hRatio;
	var wRatio;
	var Ratio=1;
	var w=img.width;
	var h=img.height;
	wRatio=maxWidth/w;
	hRatio=maxHeight/h;
	if((maxWidth==0)&&(maxHeight==0)){
		Ratio=1 ;
	}else if(maxWidth==0){ //
		if(hRatio<1) Ratio=hRatio;
	}else if(maxHeight==0){
		if(wRatio<1) Ratio=wRatio;
	}else if((wRatio<1)||(hRatio<1)){
		Ratio=(wRatio<=hRatio?wRatio:hRatio);
	}
	if(Ratio<1){
		w=w*Ratio;
		h=h*Ratio;
	}
	objImg.height=h;
	objImg.width=w;
}
