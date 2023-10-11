var A4W=210; // A4��
var A4H=297; //  A4�� 
var FONTRATE=3;  //����ת������
var POINTRATE=3 //2;  //����ת������
var KLINE=-1; //���б�ߵ�б��
var BGAP=1.1; //���б�ߵĽؾ��

function darwTable(tabStyle){
    if (tabStyle.lines!=null&&tabStyle.lines.length > 0)
    {
        drawLines(tabStyle.lines,table);
    }
    if (tabStyle.texts != null&&tabStyle.texts.length > 0)
    {
        drawTexts(tabStyle.texts,table);
    }    
    if (tabStyle.images != null && tabStyle.images.length > 0)
    {
        drawImages(tabStyle.images,table);
    }
}

function darwContent(tabContent,elem){
    if (tabContent.lines!=null&&tabContent.lines.length > 0)
    {
        drawLines(tabContent.lines,elem);
    }
    if (tabContent.texts != null&&tabContent.texts.length > 0)
    {
        drawTexts(tabContent.texts,elem);
    }
    return;
}
function darwCurve(tabCurve,elem){
    if (tabCurve.lines!=null&&tabCurve.lines.length > 0)
    {
        drawLines(tabCurve.lines,elem);
    }
    if (tabCurve.texts != null&&tabCurve.texts.length > 0)
    {
        drawTexts(tabCurve.texts,elem);
    }
    if (tabCurve.points != null&&tabCurve.points.length > 0)
    {
        drawPoints(tabCurve.points,elem);
    }
    if (tabCurve.paths != null&&tabCurve.paths[0] != null&&tabCurve.paths[0].length > 0){
        fillPath(tabCurve.paths,elem);
    }
    return;
}
function drawLines(lines,elem){
    var i=0;
    lines.forEach(function(line){
        if(line.breakLineFlag=="N"){
            var currentLine=elem.line(line.x1, line.y1, line.x2, line.y2).stroke({ width: line.width,color:line.color }).attr('id','chartline'+i);
            if(line.lineStyle=="Dash"){
	        	currentLine.stroke({dasharray:'1,1'})    
	        }
            i++;
        }
            
    });
}

function drawTexts(texts,elem){
    var i=0;
    texts.forEach(function(text){
        drawText(elem,text.content+"",text.width,text.fontFamily,text.fontSize/FONTRATE,text.alignment,text.fontColor,parseFloat(text.x),parseFloat(text.y),"",text.fontStyle,text.underline,"text"+i,text.direction);
        i++;    
    });
}

function drawImages(images,elem){
    var i=0;
    images.forEach(function(image){
        var imageSVG=elem.image(image.image, image.width, image.height);
        imageSVG.move(image.x,image.y);
        // drawText(draw,text.content+"",text.width,text.fontFamily,text.fontSize/FONTRATE,text.alignment,text.fontColor,text.x,text.y,"",text.fontStyle,"text"+i);
        i++;
    });
}
/*
* ����ͼ���
*/
function drawPoints(points,elem){
	var obj={};
	points.forEach(function(point){
		var key=point.x+"_"+point.y;
		var desc=point.obsName!="" && point.obsValue!="" ? point.obsName+"��"+point.obsValue : "";
		var name=point.userName;
		var dtime=point.date+" "+point.time;
		if(obj[key]){
			if(desc!=""){
				if(obj[key].obs.indexOf(desc)==-1){
					obj[key].obs.push(desc);	
				}
				if(obj[key].user.indexOf(name)==-1){
					obj[key].user.push(name);	
				}
			}				
		}else{
			obj[key]={
				obs:desc!="" ? [desc] : [],
				user:[name],
				dtime:dtime		
			}	
		}	
	})
    var i=0;
    points.forEach(function(point){
	    if(point.breakLineFlag!="Y"){
		    var key=point.x+"_"+point.y;
		    drawPoint(elem,point.icon,point.size/POINTRATE,point.x,point.y,point.color,"point_"+point.x+"_"+point.y,obj[key],point.iconStyle);
	        i++;    
	    }
    });
}

/*
* ���ƶ��б��(б�����)
*/
function fillPath(paths,elem){
    //���б�ߵĹ�ʽʹ�� y=kx+b
    for (var i=0;i<paths.length;i++)
    {
       if(paths[0]&&paths[0].length>0&&paths[0][0].hatchStyle&&paths[0][0].hatchStyle=='BackwardDiagonal'){
        	calcIntersection(paths[i],elem);
       }
       if(paths[0]&&paths[0].length>0&&paths[0][0].hatchStyle&&paths[0][0].hatchStyle=='Vertical'){
        	calcIntersectionVertical(paths[i],elem);
       }
    }
}
/**
 * ��������ߺ��ϱ��߽���(б�ߣ�
 */
 function calcIntersection(paths,elem){
    //draw.line(70, 123.75, 80, 113.75).stroke({ width: 0.15,color:"green" }).attr('id','slantline');
    //���б�ߵĹ�ʽʹ�� y=kx+b
    var stArray=[];
    var bSpace=getMaxMinB(paths);
    var b0=bSpace.min; //��ʼб�ߵĽؾ�
    //if(paths.length%2==0){
        var bEnd=bSpace.max; //paths[Math.ceil(paths.length/2)].y-KLINE*paths[Math.ceil(paths.length/2)].x;  //��ֹ�߽ؾ�
        for(var bDr=b0+BGAP;bDr<bEnd+50;bDr=bDr+BGAP){
            var xMax=0;
            var j=1;
            var x1=-1,y1=-1,x2=-1,y2=-1;
            for (var i=0;i<paths.length;i++)
            {
                var pSt=paths[i];   //ֱ�����
                var pEnd=paths[0];  //ֱ���յ�  
                if(i<(paths.length-1)){
                    var pEnd=paths[i+1];  //ֱ���յ�   
                }
                var point=calcCrossPoint(pSt,pEnd,bDr);
                if(point){
                    stArray.push(point);
                }
            }
            sortArrayByX(stArray);
            drawSlantLine(stArray,elem);
            stArray=[];
        } 
}

/**
 * ��������ߺ��ϱ��߽��㣨ֱ�ߣ�
 */
 function calcIntersectionVertical(paths,elem){
    //draw.line(70, 123.75, 80, 113.75).stroke({ width: 0.15,color:"green" }).attr('id','slantline');
    //���ֱ�ߵĹ�ʽʹ�� x=b
    var stArray=[];
    var bSpace=getMaxMinBV(paths);
    //if(paths.length%2==0){
	var eachTopLength=0; // ��¼����һ���ߵ��Ѿ������ĳ���
	var eachBottomLength=0; // ��¼�ȱ����������ߵĳ���
	var BGAP=1;
    var xEnd=0;//bSpace.max; //paths[Math.ceil(paths.length/2)].y-KLINE*paths[Math.ceil(paths.length/2)].x;  //��ֹ�߽ؾ�
        var x1=-1,y1=-1,x2=-1,y2=-1;
        for (var i=0;i<paths.length;i++)
        {
            var pSt=paths[i];   //ֱ�����
            var pEnd=paths[0];  //ֱ���յ�  
            if(i<(paths.length-1)){
                var pEnd=paths[i+1];  //ֱ���յ�   
            }
            if(0==(pEnd.x-pSt.x)) continue;
            var k=(pEnd.y-pSt.y)/(pEnd.x-pSt.x);
	        var b=pSt.y-k*pSt.x;
            var x0=pSt.x; //��ʼֱ��   
            if(x0==bSpace.max) BGAP=-BGAP;
            if(BGAP>0){
	            for(var xDr=x0+BGAP;xDr<=pEnd.x;xDr=xDr+BGAP){	            
		        	var x=xDr;
		        	var y=k*x+b;
		        	var point={"x":x,"y":y,"bDr":xDr,"st":pSt,"end":pEnd};
		            if(point){
		                stArray.push(point);
		                eachBottomLength=eachBottomLength+1;
		            }
	    		} 
            }
            else{
	            var l=eachBottomLength-eachTopLength;
	            for(var j=(l-1);j>=0;j=j-1){	            
		        	var x=stArray[j].x;
		        	if(x<pEnd.x){
			        	break;
			        }else{
			        	eachTopLength=eachTopLength+1;
			        }
		        	var y=k*x+b;
		        	var point={"x":x,"y":y,"bDr":x,"st":pSt,"end":pEnd};
		            if(point){
		                stArray.push(point);
		            }
	    		} 
            }
        }
        sortArrayByX(stArray);
        drawSlantLine(stArray,elem);
        stArray=[];
}
/**
 * ���������С�ؾ�
 */
function getMaxMinB(paths)
{
    var minB=paths[0].y-KLINE*paths[0].x;
    var maxB=paths[Math.ceil(paths.length/2)].y-KLINE*paths[Math.ceil(paths.length/2)].x;  //��ֹ�߽ؾ�
    for(var i=1;i<paths.length;i++){
        var b=paths[i].y-KLINE*paths[i].x
        if(b<minB){
            minB=b;
        }
        if(b>maxB){
            maxB=b;
        }
    }
    return {"min":minB,"max":maxB}
}
/**
 * ���������С�ؾ�(ֱ��������
 */
function getMaxMinBV(paths)
{
    var minB=paths[0].x;
    var maxB=paths[Math.ceil(paths.length/2)].x
    for(var i=1;i<paths.length;i++){
        var b=paths[i].x
        if(b<minB){
            minB=b;
        }
        if(b>maxB){
            maxB=b;
        }
    }
    return {"min":minB,"max":maxB}
}
/**
 * ����x�����������н���
 */
function sortArrayByX(arr){
    for(var i = 1; i < arr.length; i++) {
        for (var j=0; j < arr.length-i; j++) {
            if (arr[j].x > arr[j+1].x) {
                var temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
}
function drawSlantLine(stArray,elem){
    for(var i=0;i<stArray.length;i=i+2)
    {
        var pSt=stArray[i];   //ֱ�����
        // var pEnd=stArray[0];  //ֱ���յ�  
        if(i<(stArray.length-1)){
            var pEnd=stArray[i+1];  //ֱ���յ� 
            elem.line(pSt.x, pSt.y, pEnd.x, pEnd.y).stroke({ width: 0.15,color:missBeatColor }).attr('id','slantline'+i);
            // drawText(draw,pSt.x,30,"����",4,"Center","Red",pSt.x, pSt.y,"","","aaaa"+i);
        }           
    }
}
function calcCrossPoint(pSt,pEnd,bDr){
    if (pEnd.x!=pSt.x){
        var k=(pEnd.y-pSt.y)/(pEnd.x-pSt.x);
        var b=pSt.y-k*pSt.x;
        var x=(bDr-b)/(k-KLINE);
        var y=KLINE*x+bDr;
        if ((pEnd.x>pSt.x&&x>=pSt.x&&x<=pEnd.x)||(pEnd.x<pSt.x&&x<=pSt.x&&x>=pEnd.x)) {
            return {"x":x,"y":y,"bDr":bDr,"st":pSt,"end":pEnd};//x1=x;y1=y;
        }        
    }
    else{
        if(pSt.y!=pEnd.y){
            var x=pSt.x
            var y=KLINE*x+bDr;
            if ((pEnd.y>pSt.y&&y>=pSt.y&&y<=pEnd.y)||(pEnd.y<pSt.y&&y<=pSt.y&&y>=pEnd.y)){
                return {"x":x,"y":y,"bDr":bDr,"st":pSt,"end":pEnd};
            }            
        }        
    }
}

