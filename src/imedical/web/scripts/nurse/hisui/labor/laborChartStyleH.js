var rate=4; //默认像素比率2
var borderWidth=0.5 ;// 边框线宽度
var borderWidth2=0.25;
var A4W=210; //默认A4宽
var A4H=297; //默认A4高
var tableTop=40;	//上方内容高度
var tableBottom=20;	//下方内容高度
var tableLeft=20;	//左侧边距
var tableRight=20;	//右侧边距
var tableH=A4H-tableTop-tableBottom;  //表格高度
var tableW=A4W-tableLeft-tableRight;  //表格宽度
var tableBottomY=tableTop+tableH;

var topRuler=20,topRuler1=12,leftRuler=10,rightRuler=5; //折线图标尺
var chartWidth=tableW/2-leftRuler-rightRuler,chartHeight=tableH-topRuler; //折线图大小
var originX=tableLeft+leftRuler,originY=tableTop+topRuler;;	//折线图原点
var cellH=chartHeight/24/4; //折线图小格高度   (表格高度-上标尺)/10行
var cellW=chartWidth/11; //折线图小格宽度   (表格宽度/2-左侧标尺-右侧标尺)/11
var UnitTime=900,charLineWidth=0.25; //一格的秒数 线宽
var txRulerArr=["90","100","110","120","130","140","150","160","170","180","190"];
var txBaseVal=80,txUnitVal=10,txColor="red",txSymbol="●",txLineColor="red"; //胎心 起始值、一格的值、符号颜色、符号、线颜色
var gkRulerArr=["0","1","2","3","4","5","6","7","8","9","10"];
var gkBaseVal=-1,gkUnitVal=1,gkColor="red",gkSymbol="○",gkLineColor="red"; //宫口 起始值、一格的值、符号颜色、符号、线颜色
var xlRulerArr=["+5","+4","+3","+2","+1","0","-1","-2","-3","-4","-5"];
var xlBaseVal=6,xlUnitVal=1,xlColor="blue",xlSymbol="×",xlLineColor="blue"; //先露 起始值、一格的值、符号颜色、符号、线颜色

/////右半部分各个列宽
var gridOX=originX+chartWidth+rightRuler,gridOY=originY; //表格原点
var gridWidth=tableW/2,gridHeight=chartHeight;
var columnX2=10,columnX3=20,columnX4=30,columnX5=gridWidth-10; //表格列宽
var rowH=cellH*4;

if (SVG.supported) {
    var draw = SVG('drawing')//.size(A4W*rate, A4H*rate);//fill('#f03');
    var box = draw.viewbox({ x: 0, y: 10, width: A4W, height: A4H });
    drawCommonLine(draw);  //固定框线
    drawCommonText(draw);  //固定文字
    drawPatData();
} else {
    alert('SVG not supported')
}

function printSVG(){
	var LODOP=getLodop();
	LODOP.PRINT_INIT("产程图");
	var printData = document.getElementById("drawing").innerHTML;	
	LODOP.ADD_PRINT_HTM(0,0,"40%", "100%",printData);
	LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT", "Full-Page");
	LODOP.PREVIEW();
}

function drawPatData(){
	$cm({
        ClassName: "Nur.DHCNurCurve",
        MethodName: 'getPrintData',
        EpisodeID:EpisodeID,
        page:page
    }, function (printData) {
	    drawPatInfo(printData.patient);
	    drawDateRuler(printData.dateRuler);
	    drawTimeRuler(printData.timeRuler);
	    drawChartData(printData.chartData);
	    drawGridData(printData.gridData);
	    drawStageTime(printData.stageTime);
    });
}

function drawPatInfo(patient){
	drawText(draw,patient.name,"SimSun",4,"start",tableLeft+12,tableTop-6,'1em',"normal");
    drawText(draw,patient.medicareNo,"SimSun",4,"start",tableLeft+140,tableTop-6,'1em',"normal");
}

function drawDateRuler(dateRuler){
	if(!dateRuler) return;
	drawTextRotate90(draw,dateRuler,"SimSun",4,"start",originX-4,tableTop+1,'1em',"normal");
}

function drawTimeRuler(timeRuler){
	if(!timeRuler) return;
	for(i=0;i<timeRuler.length;i++){
	    drawTextRotate90(draw,timeRuler[i],"SimSun",4,"middle",originX-5,originY+i*rowH*2,'1em',"normal");
    }
}

function drawChartData(chartData){
	if(!chartData) return;
	drawTxChart(chartData.txData);
	drawGkChart(chartData.gkData);
	drawXlChart(chartData.xlData);
}

function drawGridData(gridData){
	if(!gridData) return;
	for(i=0;i<gridData.length;i++){
		var x=gridOX;
		var y=gridOY+gridData[i].rowNum*rowH;
		drawText(draw,gridData[i].PregFrequency,"SimSun",4,"start",x+1,y+4,'1em',"normal");
		drawText(draw,gridData[i].PregBlood,"SimSun",4,"start",x+columnX2+1,y+4,'1em',"normal");
		drawText(draw,gridData[i].PregMembrane,"SimSun",3,"start",x+columnX3+1,y+4,'1em',"normal");
		if(!!gridData[i].PregHandle){
			var tPregHandle1=GetSubString(gridData[i].PregHandle,0,30);
			var tPregHandle2=GetSubString(gridData[i].PregHandle,31,60);
			if(tPregHandle2!=""){
				drawText(draw,tPregHandle1,"SimSun",3,"start",x+columnX4+1,y+1,'1em',"normal");
				drawText(draw,tPregHandle2,"SimSun",3,"start",x+columnX4+1,y+5,'1em',"normal");
			}
			else{
				drawText(draw,tPregHandle1,"SimSun",3,"start",x+columnX4+1,y+4,'1em',"normal");
			}
		}
		drawText(draw,gridData[i].PregUserID,"SimSun",3,"start",x+columnX5+3,y+4,'1em',"normal");
	}
}

function GetSubString(str,start,end) {
	var realLength = 0, len = str.length, charCode = -1,result="";
	for(var i=0;i<len;i++){
		charCode = str.charCodeAt(i);
		if (charCode >= 0 && charCode <= 128) realLength += 1;
        else realLength += 2;
        if((realLength>=start)&&(realLength<=end)) result+=str[i];
	}
	return result;
}

function drawStageTime(stageTime){
	if(!stageTime) return;
	drawText(draw,stageTime.firstStage,"SimSun",4,"middle",tableLeft+28,tableBottomY+9,'1em',"normal");
	drawText(draw,stageTime.secondStage,"SimSun",4,"middle",tableLeft+73,tableBottomY+9,'1em',"normal");
	drawText(draw,stageTime.thirdStage,"SimSun",4,"middle",tableLeft+118,tableBottomY+9,'1em',"normal");
	drawText(draw,stageTime.totalStage,"SimSun",4,"middle",tableLeft+159,tableBottomY+9,'1em',"normal");
}

function drawTxChart(txData){
	// txBaseVal txUnitVal txColor txSymbol txLineColor
	if(!txData) return;
	var preX=0,preY=0;
	for(i=0;i<txData.length;i++){
		var VAL=(txData[i].iValue-txBaseVal)/txUnitVal;
		var TIME=txData[i].timeVal/UnitTime;
		var x=originX+VAL*cellW;
		var y=originY+TIME*cellH;
	    drawText(draw,txSymbol,"SimSun",2.5,"start",x-1.25,y-1.25,'1em',"normal",txColor); //减去字体大小的一半，保证坐标点在符号的中心
	    if(i!=0){
		    draw.line(preX, preY, x, y).stroke({ width: charLineWidth,color:txLineColor }).attr('id','txChar');
	    }
	    preX=x,preY=y;
    }
}

function drawGkChart(gkData){
	// gkBaseVal gkUnitVal gkColor gkSymbol gkLineColor
	if(!gkData) return;
	var preX=originX+cellW,preY=originY;
	for(i=0;i<gkData.length;i++){
		var VAL=(gkData[i].iValue-gkBaseVal)/gkUnitVal;
		var TIME=gkData[i].timeVal/UnitTime;
		var x=originX+VAL*cellW;
		var y=originY+TIME*cellH;
	    if(gkData[i].noSymbol!="Y"){
		    drawText(draw,gkSymbol,"SimSun",2.5,"start",x-1.25,y-1.25,'1em',"normal",gkColor); //减去字体大小的一半，保证坐标点在符号的中心
	    }
	    draw.line(preX, preY, x, y).stroke({ width: charLineWidth,color:gkLineColor }).attr('id','gkChar');
	    if(gkData[i].outFlag=="Y"){
		    //draw.line(x, y, x, y+cellH*2).stroke({ width: charLineWidth,color:gkLineColor }).attr('id','gkChar');
		    draw.line(x-3*cellW, y, x, y).stroke({ width: charLineWidth,color:gkLineColor }).attr('id','gkChar');
		    draw.line(x-3*cellW, y, x-3*cellW+2, y-1).stroke({ width: charLineWidth,color:gkLineColor }).attr('id','gkChar');
		    draw.line(x-3*cellW, y, x-3*cellW+2, y+1).stroke({ width: charLineWidth,color:gkLineColor }).attr('id','gkChar');
	    }
	    preX=x,preY=y;
    }
}

function drawXlChart(xlData){
	// xlBaseVal xlUnitVal xlColor xlSymbol xlLineColor
	if(!xlData) return;
	var preX=originX+11*cellW,preY=originY;
	for(i=0;i<xlData.length;i++){
		var VAL=-(xlData[i].iValue-xlBaseVal)/xlUnitVal; //坐标反着来加个负号
		var TIME=xlData[i].timeVal/UnitTime;
		var x=originX+VAL*cellW;
		var y=originY+TIME*cellH;
	    drawText(draw,xlSymbol,"SimSun",2.5,"start",x-1.25,y-1.25,'1em',"normal",xlColor); //减去字体大小的一半，保证坐标点在符号的中心
	    draw.line(preX, preY, x, y).stroke({ width: charLineWidth,color:xlLineColor }).attr('id','txChar');
	    preX=x,preY=y;
    }
}

function drawCommonLine(draw){
	// 上边框
    draw.line(tableLeft, tableTop, tableLeft+tableW, tableTop).stroke({ width: borderWidth }).attr('id','topBoder');
    
	//折线图横线
    for(i=0;i<=24;i++){
        draw.line(originX, originY+i*rowH, originX + 11*cellW, originY+i*rowH).stroke({ width: borderWidth }).attr('id','chartHline'+i); 
        if (i<24){
            for(j=1;j<=4;j++){
	            draw.line(originX, originY+i*rowH+j*cellH, originX + 11*cellW, originY+i*rowH+j*cellH).stroke({ width: borderWidth2 }).attr('id','chartHline'+i); 
            }
        }
    }
    draw.line(originX, tableTop+topRuler1, originX + 11*cellW+rightRuler,tableTop+topRuler1).stroke({ width: borderWidth2 }).attr('id','gridHline1');
    //折线图纵线
    for(i=0;i<=11;i++){
        if(i==1||i==6){
            draw.line(originX+i*cellW, originY, originX+i*cellW, originY+chartHeight).stroke({ width: borderWidth2,color:'red' }).attr('id','chartVline'+i); 
        }else if(i==4||i==8){
            draw.line(originX+i*cellW, originY, originX+i*cellW, originY+chartHeight).stroke({ width: borderWidth2,color:'blue' }).attr('id','chartVline'+i); 
        }else if(i==0||i==11){
            draw.line(originX+i*cellW, originY, originX+i*cellW, originY+chartHeight).stroke({ width: borderWidth,color:'black' }).attr('id','chartVline'+i); 
        }else{
            draw.line(originX+i*cellW, originY, originX+i*cellW, originY+chartHeight).stroke({ width: borderWidth2,color:'black' }).attr('id','chartVline'+i); 
        }
    }
    //记录表格
    for(i=0;i<=24;i++){
        draw.line(gridOX, gridOY+i*rowH, gridOX + gridWidth, gridOY+i*rowH).stroke({ width: borderWidth }).attr('id','gridHline'+i); 
    }
    draw.line(gridOX, tableTop, gridOX, tableTop+tableH).stroke({ width: borderWidth }).attr('id','gridVline1');
    draw.line(gridOX+columnX2, tableTop, gridOX+columnX2, tableTop+tableH).stroke({ width: borderWidth }).attr('id','gridVline2');
    draw.line(gridOX+columnX3, tableTop, gridOX+columnX3, tableTop+tableH).stroke({ width: borderWidth }).attr('id','gridVline3');
    draw.line(gridOX+columnX4, tableTop, gridOX+columnX4, tableTop+tableH).stroke({ width: borderWidth }).attr('id','gridVline4');
    draw.line(gridOX+gridWidth, tableTop, gridOX+gridWidth, tableTop+tableH).stroke({ width: borderWidth }).attr('id','gridVline5');
}

function drawCommonText(draw){
    drawText(draw,"北京积水潭医院","SimSun",10,"start",70,10);
    drawText(draw,"产  程  图","SimSun",10,"start",83,20,'1em',"bold");
    drawText(draw,"姓名:","SimSun",4,"start",tableLeft,tableTop-6,'1em',"normal");
    drawText(draw,"住院号:","SimSun",4,"start",tableLeft+125,tableTop-6,'1em',"normal");
    for(i=0;i<txRulerArr.length;i++){
	    drawTextRotate90(draw,txRulerArr[i],"SimSun",4,"middle",tableLeft+leftRuler+(i+1)*cellW-2,tableTop+6,'1em',"normal");
    }
    for(i=0;i<gkRulerArr.length;i++){
	    drawTextRotate90(draw,gkRulerArr[i],"SimSun",4,"middle",tableLeft+leftRuler+(i+1)*cellW-2,tableTop+topRuler1+4,'1em',"normal");
    }
    for(i=0;i<xlRulerArr.length;i++){
	    drawTextRotate90(draw,xlRulerArr[i],"SimSun",4,"middle",tableLeft+leftRuler+(i+1)*cellW-2,tableTop+tableH+3,'1em',"normal");
    }
    drawText(draw,"宫缩","SimSun",4,"start",gridOX+1,tableTop+5,'1em',"normal");
    drawText(draw,"持续","SimSun",4,"start",gridOX+1,tableTop+9,'1em',"normal");
    drawText(draw,"(秒)","SimSun",4,"start",gridOX+1,tableTop+13,'1em',"normal");
    drawText(draw,"宫缩","SimSun",4,"start",gridOX+columnX2+1,tableTop+5,'1em',"normal");
    drawText(draw,"间隔","SimSun",4,"start",gridOX+columnX2+1,tableTop+9,'1em',"normal");
    drawText(draw,"(分)","SimSun",4,"start",gridOX+columnX2+1,tableTop+13,'1em',"normal");
    drawText(draw,"胎膜","SimSun",4,"start",gridOX+columnX3+1,tableTop+7,'1em',"normal");
    drawText(draw,"处  理  及  附  注","SimSun",4,"start",gridOX+columnX4+4,tableTop+7,'1em',"normal");
    drawText(draw,"签名","SimSun",4,"start",gridOX+columnX5+1,tableTop+7,'1em',"normal");
    
    drawText(draw,"第一产程____________","SimSun",4,"start",tableLeft,tableBottomY+9,'1em',"normal");
    drawText(draw,"第二产程____________","SimSun",4,"start",tableLeft+45,tableBottomY+9,'1em',"normal");
    drawText(draw,"第三产程____________","SimSun",4,"start",tableLeft+90,tableBottomY+9,'1em',"normal");
    drawText(draw,"总产程____________","SimSun",4,"start",tableLeft+135,tableBottomY+9,'1em',"normal");
    
	drawTextRotate90(draw,"宫口开大cm……红○","SimSun",4,"start",tableLeft,tableTop+50,'1em',"normal");
	drawTextRotate90(draw,"抬头下降……兰×","SimSun",4,"start",tableLeft,tableTop+100,'1em',"normal");
	drawTextRotate90(draw,"胎心……红●","SimSun",4,"start",tableLeft,tableTop+150,'1em',"normal");
}