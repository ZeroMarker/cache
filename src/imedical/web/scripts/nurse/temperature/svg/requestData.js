/*
 * @Date: 2021-05-13 14:17:48
 * @LastEditors: SongChao
 * @LastEditTime: 2021-05-14 10:10:56
 * @FilePath: /mediway/imedical/web/scripts/nurse/temperature/svg/requestData.js
 */
if (SVG.supported) {
    var draw = SVG('drawing').style({height:'100%',width:'100%',overflow:'visible'});//fill('#f03');
    draw.viewbox({ x: 0, y: 0, width: A4W, height: A4H }); 
    var table=draw.group().attr("id","table");    
    //var tabStyle=JSON.parse(json);
    getTable();
    getCurData(page);
    //getContent();
    //getCurve();    
} else {
    alert('SVG not supported')
}
var tableObj={},conObj={},curveObj={};
function getTable(){
    $cm({
        ClassName:"Nur.NIS.Service.Chart.API.TemperatureChart",
        MethodName:"getTable",
        ChartTpye:CHARTYPE, 
        EpisodeID:episodeID, 
        Page:page, 
        UserID:userID,  
        LocID:locID,  // 科室ID
        ChartID:chartID
    },function(tabStyle){
	    tableObj=tabStyle;
        darwTable(tabStyle);
    });
}

function getCurData(page){
	$(".content").css("visibility",'hidden');
	var contentElem=$("#content-"+page);
	if(contentElem.length>0){
		contentElem.remove();
	}
	contentElem=draw.group().attr("id","content-"+page).attr("class","content");	
	getContentCurve(page,contentElem);	
}

function getContent(page,contentElem){
	var tabContent=$cm({
        ClassName:"Nur.NIS.Service.Chart.API.TemperatureChart",
        MethodName:"getContent",
        ChartTpye:CHARTYPE, 
        EpisodeID:episodeID, 
        Page:page, 
        UserID:userID,  
        LocID:locID,  // 科室ID
        ChartID:chartID
    },false);
    darwContent(tabContent,contentElem);
    /*$cm({
        ClassName:"Nur.NIS.Service.Chart.API.TemperatureChart",
        MethodName:"getContent",
        ChartTpye:CHARTYPE, 
        EpisodeID:episodeID, 
        Page:page, 
        UserID:userID,  
        LocID:locID,  // 科室ID
        ChartID:chartID
    },function(tabContent){
        darwContent(tabContent,contentElem);
        // console.log(tabContent);
    });*/
}

function getCurve(page,contentElem){
	var tabCurve=$cm({
        ClassName:"Nur.NIS.Service.Chart.API.TemperatureChart",
        MethodName:"getCurve",
        ChartTpye:CHARTYPE, 
        EpisodeID:episodeID, 
        Page:page, 
        UserID:userID,  
        LocID:locID,  // 科室ID
        ChartID:chartID
    },false);
    darwCurve(tabCurve,contentElem);
    /*$cm({
        ClassName:"Nur.NIS.Service.Chart.API.TemperatureChart",
        MethodName:"getCurve",
        ChartTpye:CHARTYPE, 
        EpisodeID:episodeID, 
        Page:page, 
        UserID:userID,  
        LocID:locID,  // 科室ID
        ChartID:chartID
    },function(tabCurve){
        darwCurve(tabCurve,contentElem);
        // console.log(tabCurve);
    });*/
}

function getContentCurve(page,contentElem){
    $cm({
        ClassName:"Nur.NIS.Service.Chart.API.TemperatureChart",
        MethodName:"getContentCurve",
        ChartTpye:CHARTYPE, 
        EpisodeID:episodeID, 
        Page:page, 
        UserID:userID,  
        LocID:locID,  // 科室ID
        ChartID:chartID,
        langID:langID
    },function(ret){
	    conObj[page]=ret.content;
	    curveObj[page]=ret.curve;
	    darwContent(ret.content,contentElem);
        darwCurve(ret.curve,contentElem);   
        window.parent.disLoad();     
    });
}

var loadSuccess=false;
function multiRequest(total,maxNum,ifPreview,printRange,rangeFrom,rangeTo,parity) {
	//var myDate=new Date();
	//var start=myDate.getTime();
	// 请求总数量
	var len = total;
	if(total<maxNum) maxNum=total;
	// 根据请求数量创建一个数组来保存请求的结果
	var result = [];
	for(var i=0;i<len;i++){
		result.push(false);	
	}
	// 当前完成的数量
	var count = 0;
	return new Promise(function(resolve, reject){
		// 请求maxNum个
		while (count < maxNum) {
			next(); 
		}
		function next() {
			var current = count++;
			// 处理边界条件
			if (current >= len) {	
				//var myDate2=new Date();
				//var end=myDate2.getTime();
				//console.log("diff: "+(end-start)/1000);		
				// 请求全部完成就将promise置为成功状态, 然后将result作为promise值返回 
				!result.includes(false) && resolve(result);
				//return; 
				if(!result.includes(false)){
					loadSuccess=true;
					window.parent.printAll(ifPreview,printRange,rangeFrom,rangeTo,parity,loadSuccess);
					return;			
				}								
			}			
			var pagenum=current+1;
			if(pagenum>total) return;		
			if((pagenum<rangeFrom || pagenum>rangeTo) || (parity=="O" && (pagenum%2)!=1) || ((parity=="E" && (pagenum%2)!=0)) || ($("#content-"+pagenum).length>0)){
				result[current] = true;
				if (current < len) {
					next(); 
				} 
				return;	
			}	
			//if(pagenum<rangeFrom || pagenum>rangeTo) return; // 过滤掉不在所选的页码范围内的
			//if(parity=="O" && (pagenum%2)!=1) return; // 过滤掉不是奇数页的
			//if(parity=="E" && (pagenum%2)!=0) return; // 过滤掉不是偶数页的
			//if($("#content-"+pagenum).length>0) return; // 过滤掉已存在的页面
			var contentElem=draw.group().attr("id","content-"+pagenum).attr("class","content");	
			$("#content-"+pagenum).css("visibility",'hidden');
			$cm({
		        ClassName:"Nur.NIS.Service.Chart.API.TemperatureChart",
		        MethodName:"getContentCurve",
		        ChartTpye:CHARTYPE, 
		        EpisodeID:episodeID, 
		        Page:pagenum, 
		        UserID:userID,  
		        LocID:locID,  // 科室ID
		        ChartID:chartID,
		        langID:langID
		    },function(ret){
			    darwContent(ret.content,contentElem);
		        darwCurve(ret.curve,contentElem);
		        // 保存请求结果 
				result[current] = true;				
				// 请求没有全部完成, 就递归
				if (current < len) {
					next(); 
				} 
		    });
		} 
	});
}

/// 打印数据请求
function multiRequestNew(total,maxNum,ifPreview,printRange,rangeFrom,rangeTo,parity) {
	//var myDate=new Date();
	//var start=myDate.getTime();
	// 请求总数量
	var len = total;
	if(total<maxNum) maxNum=total;
	// 根据请求数量创建一个数组来保存请求的结果
	var result = [];
	for(var i=0;i<len;i++){
		result.push(false);	
	}
	// 当前完成的数量
	var count = 0;
	return new Promise(function(resolve, reject){
		// 请求maxNum个
		while (count < maxNum) {
			next(); 
		}
		function next() {
			var current = count++;
			// 处理边界条件
			if (current >= len) {	
				//var myDate2=new Date();
				//var end=myDate2.getTime();
				//console.log("diff: "+(end-start)/1000);		
				// 请求全部完成就将promise置为成功状态, 然后将result作为promise值返回 
				!result.includes(false) && resolve(result);
				//return; 
				if(!result.includes(false)){
					loadSuccess=true;
					console.log(conObj)
					console.log(curveObj);
					/// window.parent.printAll(ifPreview,printRange,rangeFrom,rangeTo,parity,loadSuccess);
					window.parent.printAllNew(ifPreview,printRange,rangeFrom,rangeTo,parity,loadSuccess);
					return;			
				}								
			}			
			var pagenum=current+1;
			if(pagenum>total) return;		
			if((pagenum<rangeFrom || pagenum>rangeTo) || (parity=="O" && (pagenum%2)!=1) || ((parity=="E" && (pagenum%2)!=0)) || ($("#content-"+pagenum).length>0)){
				result[current] = true;
				if (current < len) {
					next(); 
				} 
				return;	
			}	
			$cm({
		        ClassName:"Nur.NIS.Service.Chart.API.TemperatureChart",
		        MethodName:"getContentCurve",
		        ChartTpye:CHARTYPE, 
		        EpisodeID:episodeID, 
		        Page:pagenum, 
		        UserID:userID,  
		        LocID:locID,  // 科室ID
		        ChartID:chartID,
		        langID:langID
		    },function(ret){
			    conObj[pagenum]=ret.content;
	    		curveObj[pagenum]=ret.curve;
		        // 保存请求结果 
				result[current] = true;				
				// 请求没有全部完成, 就递归
				if (current < len) {
					next(); 
				} 
		    });
		} 
	});
} 

