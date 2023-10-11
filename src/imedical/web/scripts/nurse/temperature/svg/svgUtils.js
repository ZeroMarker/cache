/*
 * @Author: songchao
 * @Date: 2020-11-11 19:42:58
 * @LastEditTime: 2021-05-13 21:46:59
 * @LastEditors: SongChao
 * @Description: In User Settings Edit
 * @FilePath: /mediway/imedical/web/scripts/nurse/temperature/svg/svgUtils.js
 */
/**
 * 组合绘制娩出标志
 * @param {*} draw 
 */
function drawOutFlag(draw,fontSize,x,y){
    drawVText(draw,"○","SimSun",fontSize,"start",x,y,fontSize,"1.0","normal","red");
    drawVText(draw,"↓","SimSun",fontSize,"start",x,y+fontSize/2,fontSize,"1.0","normal","red");
}

/**
 * 画斜线(血压/宫缩)
 */
function drawSlantLine(draw,yVal){
    for(i=0;i<=25;i++){  //折线图纵线
        draw.line(i*cellW+tableOX+leftRulerW,yVal+2, i*cellW+cellW+tableOX+leftRulerW, yVal-2).stroke({ width: borderWidth }).attr('id','pageBotVline'+i); 
    }
}

/**
 * 画图标
 */
 function drawPoint(draw,icon,size,x,y,color,id,point,weight){
    var rowLeading=  '1.0em';
    var fontWeight = weight || 'normal'; 
    var text = draw.text(icon+"");       
    var anchor="start"
     
    /*var decoration="none";
   	if(weight=="Strikeout") decoration="line-through";
   	if(weight=="Underline") decoration="underline";*/
    //获取或设置font
    text.font({
	     family:"宋体",
         size: size,         
         anchor: anchor, //设置位置的相对定位点
         leading: rowLeading,
         weight: fontWeight.toLowerCase(),
         style:fontWeight.toLowerCase()
     });
    var span = text.tspan(icon+"").fill(color).attr('id',"tspan"+id); 
    if(fontWeight.toLowerCase()=="underline"){    
    	draw.line(x-size/2,y+size/2, x-size/2+span.length(), y+size/2).stroke({ width: 0.25 }); 
   	}
   	if(fontWeight.toLowerCase()=="strikeout"){
	   	draw.line(x-size/2,y, x-size/2+span.length(), y).stroke({ width: 0.25 }); 
	}
    text.move(x-size/2,y-size/2);
    text.on("mouseover",function(){
	    if(point.obs.length==0) return;
	    $("#tooltip p:eq(0)").html(point.obs.join("，"));
	    $("#tooltip p:eq(1)").html(window.parent.enteredBy+"："+point.user.join("，"));
	    $("#tooltip p:eq(2)").html(window.parent.enteredTime+"："+point.dtime);
		$("#tooltip").css({"top":(y+1)/A4H*100+"%","left":(x+1)/A4W*100+"%"}).show();    
	})
	text.on("mouseout",function(){
		$("#tooltip").hide();    
	})
	
	text.on("click",function(){
		if(point.obs.length==0) return;
	    var pointDateTime=point.dtime;
	    var pointDate=pointDateTime.split(" ")[0];
	    var pointTime=pointDateTime.split(" ")[1];   
	    parent.$("#logDate").datebox("setValue",pointDate);
	    parent.$("#logTime").timespinner("setValue",pointTime);
	    //findTempDataByDay();
	})
 }

/**
 * 画文字
 */
function drawText(draw,content,width,family,size,alignment,color,x,y,leading,weight,underline,id,direction){
   var rowLeading= leading || '1.0em';
   var fontWeight = weight || 'normal';
   if(String(content).indexOf("<red>")>-1){
    content=content.replace("<red>","");
    color="red";
   }
   /// 床号/科室扩展方向(向上扩展/向下扩展)
   if(content!="↑" && content!="↓" && (content.indexOf("↑")>-1 || content.indexOf("↓")>-1)) {
	    if(content.indexOf("↑")>-1) var connector="↑";
	    if(content.indexOf("↓")>-1) var connector="↓";
		var array=content.split(connector);
		var textY=y;
		for(var i=0;i<array.length;i++){
			if (i>0) var underline="",direction="";
			drawBedLoc(draw,array[i],width,family,size,alignment,color,x,textY,leading,weight,underline,id,direction)
			if(i<array.length-1){
				textY=textY-size;
				drawBedLoc(draw,connector,width,family,size,"Center",color,x,textY,leading,weight,"",id,"")	
				textY=textY-size;
			}
		}
		return;
   }
  
   var text = draw.text(content+"");
    
   var anchor="start"
   if (alignment=="Center"){
        x=x+width/2
        anchor="middle";
   } 
   // 下划线、中间线
   /*var decoration="none";
   if(weight=="Strikeout") decoration="line-through";
   if(weight=="Underline" || underline=="Underline") decoration="underline";*/
   //获取或设置font
   text.font({
        family: family,
        size: size,
        anchor: anchor, //设置位置的相对定位点
        leading: rowLeading,
        weight: fontWeight.toLowerCase(),        
        style:fontWeight.toLowerCase()
    }); 
    if (direction=="DirectionVertical")	{
		text.attr({"writing-mode":"tb"});
	}
    var span = text.tspan(content+"").fill(color).attr('id',"tspan"+id);
    var colorFlag="",skinTestFlag="";    
   	if (content.indexOf("("+skinTestYText+")")>-1 || content.indexOf("("+skinTestNText+")")>-1){
		colorFlag=content.indexOf("("+skinTestYText+")")>-1 ? skinTestYColor : skinTestNColor;
		skinTestFlag="Y";		 	
	}
    var dy=0,dx=span.length(),tspan="",yAxis=y;   
    if(Math.floor(span.length()-width)>0){
	    var chartsize=span.length()/content.length;
	    text.remove();
        //var wordNums=Math.floor(width/size)
        var wordNums=Math.floor(width/chartsize)
        wordNums=wordNums==0 ? 1 : wordNums;
	    var conArr=[],count=0;	    
	    for(var i=0;i<content.length;i=i+wordNums){
		    var con=content.substr(i,wordNums);
		    count++;
			var textEle = draw.text(con+"");
			textEle.font({
		        family: family,
		        size: size,
		        anchor: anchor, //设置位置的相对定位点
		        leading: rowLeading,
		        weight: fontWeight,
		        style:fontWeight
		    });				
			if(skinTestFlag=="Y"){
				if(con.indexOf("(")>-1 && con.indexOf(")")>-1){
					var arr=con.split("(");
					var arr2=arr[1].split(")")
					var tspan=textEle.tspan(arr[0]+"").fill(color).attr("id","tspan"+id+"-"+count);	
					var tspan2=tspan.tspan("("+arr2[0]+")").fill(colorFlag);
					tspan2.tspan(arr2[1]+"").fill(color);
				}else if(con.indexOf("(")>-1){
					var arr=con.split("(");
					var tspan=textEle.tspan(arr[0]+"").fill(color).attr("id","tspan"+id+"-"+count);	
					tspan.tspan("("+arr[1]+"").fill(colorFlag);
				}else if(con.indexOf(")")>-1){
					var arr=con.split(")")
					var tspan=textEle.tspan(arr[0]+")").fill(colorFlag).attr("id","tspan"+id+"-"+count);
					tspan.tspan(arr[1]+"").fill(color);	
				}else{
					var tspan=textEle.tspan(con+"").fill(color).attr("id","tspan"+id+"-"+count);	
				}					
			}else{
				var tspan=textEle.tspan(con+"").fill(color).attr("id","tspan"+id+"-"+count);
			}
			if(count==1) dx=tspan.length();
			textEle.move(x,yAxis)	
			yAxis+=size;
	    }
    }else{	    
		if(skinTestFlag=="Y"){
			var con=content;
			var textEle = draw.text(con+"");
			textEle.font({
		        family: family,
		        size: size,
		        anchor: anchor, //设置位置的相对定位点
		        leading: rowLeading,
		        weight: fontWeight,
		        style:fontWeight
		    });					
			if(con.indexOf("(")>-1 && con.indexOf(")")>-1){
				var arr=con.split("(");
				var arr2=arr[1].split(")")
				var tspan=textEle.tspan(arr[0]+"").fill(color).attr("id","tspan"+id);	
				var tspan2=tspan.tspan("("+arr2[0]+")").fill(colorFlag);
				tspan2.tspan(arr2[1]+"").fill(color);
			}else if(con.indexOf("(")>-1){
				var arr=con.split("(");
				var tspan=textEle.tspan(arr[0]+"").fill(color).attr("id","tspan"+id);	
				tspan.tspan("("+arr[1]+"").fill(colorFlag);
			}else if(con.indexOf(")")>-1){
				var tspan=textEle.tspan(con+"").fill(colorFlag).attr("id","tspan"+id);	
			}else{
				var tspan=textEle.tspan(con+"").fill(color).attr("id","tspan"+id);	
			}	
			textEle.move(x,yAxis);						
		}   
	}
    
    var xAxis=x;
    if(anchor=="middle") xAxis= xAxis=x-dx/2
   	if(weight.toLowerCase()=="underline" || underline=="Underline"){    
    //text.attr("text-decoration","underline");
    // debugger;    	
    	draw.line(xAxis,yAxis+size, xAxis+dx, yAxis+size).stroke({ width: 0.25 });    	}
   	if(weight.toLowerCase()=="strikeout"){
	   	draw.line(xAxis,yAxis+size/2, xAxis+dx, yAxis+size/2).stroke({ width: 0.25 }); 
	}
   
   	if(text) text.move(x,y);   	
}
/**
 * 画文字(床号/科室)
 */
var bedLocTextLen="";
function drawBedLoc(draw,content,width,family,size,alignment,color,x,y,leading,weight,underline,id,direction){
   var rowLeading= leading || '1.0em';
   var fontWeight = weight || 'normal';
   var text = draw.text(content+"");
    
   var anchor="start"
   if (alignment=="Center"){
        anchor="middle";
   } 
   text.font({
        family: family,
        size: size,
        anchor: anchor, //设置位置的相对定位点
        leading: rowLeading,
        weight: fontWeight.toLowerCase(),        
        style:fontWeight.toLowerCase()
    });
    var span = text.tspan(content+"").fill(color).attr('id',"tspan"+id);    
    bedLocTextLen=bedLocTextLen=="" ? span.length() : bedLocTextLen,tspan="",yAxis=y;
    
    var xAxis=x;
    if(anchor=="middle") xAxis= xAxis=x+bedLocTextLen/2;
   	if(weight.toLowerCase()=="underline" || underline=="Underline"){        	
    	draw.line(xAxis,yAxis+size, xAxis+bedLocTextLen, yAxis+size).stroke({ width: 0.25 });    	
    }
   	if(weight.toLowerCase()=="strikeout"){
	   	draw.line(xAxis,yAxis+size/2, xAxis+bedLocTextLen, yAxis+size/2).stroke({ width: 0.25 }); 
	}
   
   	if(text) text.move(xAxis,y);   	
}
/**
 * 画文字并旋转90度
 */
function drawTextRotate90(draw,content,family,size,anchor,x,y,leading,weight){
   var rowLeading= leading || '1.0em';
   var fontWeight = weight || 'normal';
   var text = draw.text(content);
   //获取或设置font
   text.font({
       family: family,
       size: size,
       anchor: anchor, //设置位置的相对定位点
       leading: rowLeading,
       weight: fontWeight
   });
   text.rotate(90,x,y);
   text.move(x,y-size);	//y-size：旋转90度后保持xy不变
}
/**
 * 画竖排文字
 */
function drawVText(draw,content,family,size,anchor,x,y,fontHeight,leading,weight,color){
    var rowLeading= leading || '1.0em';
    var fontWeight = weight || 'normal';
    var fontColor = color || "black";
    var yHeight = fontHeight || 5;
    for(i=0;i<content.length;i++){
        var text = draw.text(content[i]).fill(fontColor);
        //获取或设置font
        text.font({
            family: family,
            size: size,
            anchor: anchor, //设置位置的相对定位点
            leading: rowLeading,
            weight: fontWeight
        });
        text.move(x,y+i*yHeight);
    }
    
 }
 
