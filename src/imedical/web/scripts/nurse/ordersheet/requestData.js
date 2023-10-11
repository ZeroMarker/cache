/*
 * @Date: 2021-05-13 14:17:48
 * @LastEditors: SongChao
 * @LastEditTime: 2021-05-14 10:10:56
 * @FilePath: /mediway/imedical/web/scripts/nurse/temperature/svg/requestData.js
 */
 var sheetObj=null;
if (SVG.supported) {
    var draw = SVG('drawing').style({height:'100%',width:'100%',overflow:'visible'});//fill('#f03');
    draw.viewbox({ x: 0, y: 0, width: A4W, height: A4H });    
    //var tabStyle=JSON.parse(json);
    //getOrders("L");
    //getContent();
    //getCurve();    
} else {
    alert('SVG not supported')
}

function getOrders(type){
    $cm({
        ClassName:"Nur.IP.OrderSheet",
        MethodName:"getOrders",
        Type:type, 
        EpisodeID:episodeID,
        UserID:userID,  
        LocID:locID,
        ResultSetType:"array"
    },function(sheet){
	    sheetObj=sheet;
        darwLongTable(sheet);
    });
}
function getTable(){
    $cm({
        ClassName:"Nur.NIS.Service.Chart.API.TemperatureChart",
        MethodName:"getTable",
        ChartTpye:CHARTYPE, 
        EpisodeID:episodeID, 
        Page:page, 
        UserID:userID,  
        LocID:locID,  // ø∆ “ID
        ChartID:chartID
    },function(tabStyle){
        darwTable(tabStyle);
    });
}

function getContent(){
    $cm({
        ClassName:"Nur.NIS.Service.Chart.API.TemperatureChart",
        MethodName:"getContent",
        ChartTpye:CHARTYPE, 
        EpisodeID:episodeID, 
        Page:page, 
        UserID:userID,  
        LocID:locID,  // ø∆ “ID
        ChartID:chartID
    },function(tabContent){
        darwContent(tabContent);
        // console.log(tabContent);
    });
}

function getCurve(){
    $cm({
        ClassName:"Nur.NIS.Service.Chart.API.TemperatureChart",
        MethodName:"getCurve",
        ChartTpye:CHARTYPE, 
        EpisodeID:episodeID, 
        Page:page, 
        UserID:userID,  
        LocID:locID,  // ø∆ “ID
        ChartID:chartID
    },function(tabCurve){
        darwCurve(tabCurve);
        // console.log(tabCurve);
    });
}
