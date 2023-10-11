var KLINE=-1; //���б�ߵ�б��
var BGAP=1.1; //���б�ߵĽؾ��
var fillColor=""; //�����ɫ

/// ��ӡ��ǰҳ
function printCurrPage(ifPreview){
    var LODOP=getLodop();
    LODOP.PRINT_INIT("���µ�");    
    LODOP.SET_PRINT_PAGESIZE(1, 2100,2970,"A4");            
    printChart(page,LODOP);
    /// LODOP.SET_PRINT_MODE("PRINT_PAGE_PERCENT", "Full-Width");
    if(ifPreview){
        LODOP.PREVIEW();
    }
    else{
        LODOP.PRINT();        
        //LODOP.PRINTA();
        setPrintMark(page);
    }	
}
/// ��ӡȫ��
function printAllNew(ifPreview,printRange,rangeFrom,rangeTo,parity,loadSuccess){	
	loading("���ڻ������µ�");	
    var loadFlag=loadSuccess ? loadSuccess : document.getElementById("iframePicture").contentWindow.loadSuccess;
    if(!loadFlag){
    	document.getElementById("iframePicture").contentWindow.multiRequestNew(totalPage-1,3,ifPreview,printRange,rangeFrom,rangeTo,parity);		
    }else{        
        var LODOP=getLodop();
		LODOP.PRINT_INIT("���µ�");
		LODOP.SET_PRINT_PAGESIZE(1, 2100,2970,"A4");  		          
		for(var i=rangeFrom;i<=rangeTo;i++){
			if((parity=="E" && (i%2)===0) || (parity=="O" && (i%2)==1) || (parity=="A") || (parity=="")){
				if(document.getElementById("iframePicture").contentWindow.conObj[i]){
					printChart(i,LODOP);	
					LODOP.NewPage();
				}
			}						
	    }
	    if(ifPreview){
	        LODOP.PREVIEW();
	    }
	    else{
	        LODOP.PRINT();
	        //LODOP.PRINTA();
	        setPrintMark(rangeFrom,rangeTo);
	    }					
    }
    document.getElementById("iframePicture").contentWindow.loadSuccess=false;
    disLoad();
}

/// ��ӡ���µ�
function printChart(pageNum,LODOP){
	console.log(pageNum);
	var tableData=document.getElementById("iframePicture").contentWindow.tableObj;
    var conData=document.getElementById("iframePicture").contentWindow.conObj[pageNum];
    var curveData=document.getElementById("iframePicture").contentWindow.curveObj[pageNum];
    printTable(LODOP,tableData);
    printContent(LODOP,conData);
    printCurve(LODOP,curveData);
}

/// ��ӡ�������
function printTable(LODOP,tableData){
	// ��ӡͼƬ
	if (tableData.images != null && tableData.images.length > 0)
    {
        printImages(LODOP,tableData.images);
    }
    // ��ӡ��
	if (tableData.lines!=null && tableData.lines.length > 0)
    {
        printLines(LODOP,tableData.lines);
    }
    // ��ӡ�ı�
    if (tableData.texts != null && tableData.texts.length > 0)
    {
        printTexts(LODOP,tableData.texts);
    }    
}

/// ��ӡ���µ��ı�����
function printContent(LODOP,conData){
	console.log(conData);
    if (conData.lines!=null && conData.lines.length > 0)
    {
        printLines(LODOP,conData.lines);
    }
    if (conData.texts != null && conData.texts.length > 0)
    {
        printTexts(LODOP,conData.texts);
    }
    return;
}

/// ��ӡ���µ�����
function printCurve(LODOP,curveData){
	if (curveData.lines!=null && curveData.lines.length > 0)
    {
        printLines(LODOP,curveData.lines);
    }
    if (curveData.texts != null && curveData.texts.length > 0)
    {
        printTexts(LODOP,curveData.texts);
    }
    if (curveData.points != null && curveData.points.length > 0)
    {
	    printPoints(LODOP,curveData.points);
    }
    if (curveData.paths != null && curveData.paths[0] != null && curveData.paths[0].length > 0){
        printPaths(LODOP,curveData.paths);
    }
}

/// ��ӡͼƬ
function printImages(LODOP,images){
	if (images && images.length>0){
		for (var i=0;i<images.length;i++){
			var item = images[i]
			var pleft = item.x;	
			var ptop = item.y;	
			var pheight = parseFloat(item.height)*3;
			var pwidth = parseFloat(item.width)*3;
			var pval = item.image;
			LODOP.ADD_PRINT_IMAGE(ptop+"mm",pleft+"mm", pwidth+"mm", pheight+"mm","<img src='"+ pval +"' width="+ pwidth +" height=" + pheight + " x="+ pleft +" y=" + ptop + "/>");
		}
	}
}

/// ��ӡ��
function printLines(LODOP,lines){
	if (lines && lines.length>0){
		for (var i=0;i<lines.length;i++){
			var item = lines[i];
			if(item.breakLineFlag=="Y") continue;
			var pleft1 = item.x1;	
			var ptop1 = item.y1;	
			var pleft2 = item.x2;	
			var ptop2 = item.y2;
			var plstyle = item.lineStyle == "Dash" ? 1 : 0;
			var pwidth = item.desc == "����" ?  2 : (item.lineStyle ? (item.lineStyle=="�Ӵ�" ? 2 : 1) : 1);
			var pcolor = item.color;
			if(ifColorPrint=="false") pcolor="#000000"; 
			LODOP.ADD_PRINT_LINE(ptop1+"mm",pleft1+"mm",ptop2+"mm",pleft2+"mm",plstyle,pwidth);	
			LODOP.SET_PRINT_STYLEA(0,"FontColor",pcolor);
		}
	}
}

/// ��ӡ�ı�
function printTexts(LODOP,texts){
	if (texts && texts.length>0){
		for (var i=0;i<texts.length;i++){
			var pwidth  = 2100
			var pheight = 2970
			var item = texts[i];
			var pleft = item.x;	
			var ptop = item.y;		
			var pfstyle = item.fontStyle;
			var pfname = item.fontFamily;
			var pfsize = parseFloat(item.fontSize)-0.7;
			var pcolor = item.fontColor;
			if(ifColorPrint=="false") pcolor="#000000"; 
			var underline=item.underline;
			var anchor="start";
			if (item.alignment=="Center"){
				anchor="middle";			
			} 
			var pwidth = parseFloat(item.width)+1;
			var ptext=item.content;
			if(String(ptext).indexOf("<red>")>-1){
				ptext=ptext.replace("<red>","");
				if(ifColorPrint=="true") pcolor="red";
			}
			if(ptext!="��" && ptext!="��" && (String(ptext).indexOf("��")>-1 || String(ptext).indexOf("��")>-1)) {
				/// ����/������չ����(������չ/������չ)
				if(ptext.indexOf("��")>-1) var connector="��";
				if(ptext.indexOf("��")>-1) var connector="��";
				var array=ptext.split(connector);
				var textY=ptop;
				var mixSize=parseFloat(pfsize)/4;
				for(var j=0;j<array.length;j++){
					if (j>0) var underline="",direction="";
					LODOP.ADD_PRINT_TEXT(textY +"mm",pleft+"mm",pwidth+"mm",pheight+"mm",array[j]);
					setTextStyle(LODOP,pfsize,pfname,pcolor,anchor,pfstyle,underline);
					if(j<array.length-1){
						textY=textY-mixSize;
						LODOP.ADD_PRINT_TEXT(textY +"mm",pleft+(mixSize*(array[0].length/2))+"mm",pwidth+"mm",pheight+"mm",connector);
						setTextStyle(LODOP,pfsize,pfname,pcolor,anchor,pfstyle,"");
						textY=textY-mixSize;
					}
				}
			}else{
				LODOP.ADD_PRINT_TEXT(ptop +"mm",pleft+"mm",pwidth+"mm",pheight+"mm",ptext);
				setTextStyle(LODOP,pfsize,pfname,pcolor,anchor,pfstyle,underline);	
			}		
		}
	}
}

/// �����ı���ʽ
function setTextStyle(LODOP,pfsize,pfname,pcolor,anchor,pfstyle,underline){
	LODOP.SET_PRINT_STYLEA(0,"FontSize",pfsize);
	LODOP.SET_PRINT_STYLEA(0,"FontName",pfname);
	LODOP.SET_PRINT_STYLEA(0,"FontColor",pcolor);
	var AlignmentNum = 1
	if (anchor=="middle")
	{
		AlignmentNum = 2
	}else if(anchor=="end")
	{
		AlignmentNum = 3
	}
	LODOP.SET_PRINT_STYLEA(0,"Alignment",AlignmentNum);
	LODOP.SET_PRINT_STYLEA(0,"TextNeatRow","1")
	if (pfstyle.toLowerCase() == "bold" || pfstyle.toLowerCase() == "blod")
	{
		LODOP.SET_PRINT_STYLEA(0,"Bold","1")
	}	
	if (pfstyle.toLowerCase() == "italic")
	{
		LODOP.SET_PRINT_STYLEA(0,"Italic","1")
	}			
	if(pfstyle.toLowerCase()=="underline" || underline=="Underline"){  
		LODOP.SET_PRINT_STYLEA(0,"Underline",1)
	}
}

/// ��ӡ��
function printPoints(LODOP,points){
	if (points && points.length>0){
		for (var i=0;i<points.length;i++){			
			var pwidth  = 2100
			var pheight = 2970
			var item = points[i];
			if(item.breakLineFlag=="Y") continue;
			var pleft = parseFloat(item.x)-1;	
			var ptop = parseFloat(item.y)-1;		
			var pfstyle = item.iconStyle;
			var pfsize = parseFloat(item.size);
			var pcolor = item.color;
			if(ifColorPrint=="false") pcolor="#000000"; 
			var ptext=item.icon;
			LODOP.ADD_PRINT_TEXT(ptop +"mm",pleft+"mm",pwidth+"mm",pheight+"mm",ptext);
			LODOP.SET_PRINT_STYLEA(0,"FontSize",pfsize);
			LODOP.SET_PRINT_STYLEA(0,"FontName","����");
			LODOP.SET_PRINT_STYLEA(0,"FontColor",pcolor);			
			LODOP.SET_PRINT_STYLEA(0,"TextNeatRow","1")
			if(pfstyle){
				if (pfstyle.toLowerCase() == "bold" || pfstyle.toLowerCase() == "blod")
				{
					LODOP.SET_PRINT_STYLEA(0,"Bold","1")
				}	
				if (pfstyle.toLowerCase() == "italic")
				{
					LODOP.SET_PRINT_STYLEA(0,"Italic","1")
				}			
				if(pfstyle.toLowerCase()=="underline"){  
					LODOP.SET_PRINT_STYLEA(0,"Underline",1)
	    		}
			}			
		}
	}
}

/*
* ���ƶ��б��(б�����)
*/
function printPaths(LODOP,paths){
	fillColor=document.getElementById("iframePicture").contentWindow.missBeatColor;
    //���б�ߵĹ�ʽʹ�� y=kx+b
    for (var i=0;i<paths.length;i++)
    {
       if(paths[0] && paths[0].length>0 && paths[0][0].hatchStyle && paths[0][0].hatchStyle=='BackwardDiagonal'){
        	calcIntersection(LODOP,paths[i]);
       }
       if(paths[0] && paths[0].length>0 && paths[0][0].hatchStyle && paths[0][0].hatchStyle=='Vertical'){
        	calcIntersectionVertical(LODOP,paths[i]);
       }
    }
}
/**
 * ��������ߺ��ϱ��߽���(б�ߣ�
 */
 function calcIntersection(LODOP,paths){
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
            drawSlantLine(LODOP,stArray);
            stArray=[];
        } 
}

/**
 * ��������ߺ��ϱ��߽��㣨ֱ�ߣ�
 */
 function calcIntersectionVertical(LODOP,paths){
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
        drawSlantLine(LODOP,stArray);
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
function drawSlantLine(LODOP,stArray){
    for(var i=0;i<stArray.length;i=i+2)
    {
        var pSt=stArray[i];   //ֱ�����
        // var pEnd=stArray[0];  //ֱ���յ�  
        if(i<(stArray.length-1)){
            var pEnd=stArray[i+1];  //ֱ���յ� 
            LODOP.ADD_PRINT_LINE(pSt.y+"mm",pSt.x+"mm",pEnd.y+"mm",pEnd.x+"mm",0,1);
            LODOP.SET_PRINT_STYLEA(0,"FontColor",fillColor);
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

/// �ô�ӡ���
function setPrintMark(pageFrom,pageTo){
	var pageStr="";
	if(!pageTo) {
		pageStr=pageFrom;
	}else{
		for(var i=pageFrom;i<=pageTo;i++){
			if(pageStr==""){
				pageStr=i
			}else{
				pageStr=pageStr+"^"+i;		
			}	
		}	
	}
	var ret = tkMakeServerCall('Nur.NIS.Service.Chart.DAO.Chart', 'SavePrintLog', episodeID,pageStr);
	if(ret!=0){
		$.messager.popover({ msg: '�ô�ӡ���ʧ�ܣ�', type:'error' });	
	}			
}