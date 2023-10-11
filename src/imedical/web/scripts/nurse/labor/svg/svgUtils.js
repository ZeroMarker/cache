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
    if(weight.toLowerCase()=="underline"){    
    	draw.line(x-size/2,y+size/2, x-size/2+span.length(), y+size/2).stroke({ width: 0.25 }); 
   	}
   	if(weight.toLowerCase()=="strikeout"){
	   	draw.line(x-size/2,y, x-size/2+span.length(), y).stroke({ width: 0.25 }); 
	}
    text.move(x-size/2,y-size/2);
    text.on("mouseover",function(){
	    if(point.obs.length==0) return;
	    $("#tooltip p:eq(0)").html(point.obs.join("，"));
	    $("#tooltip p:eq(1)").html("录入人："+point.user.join("，"));
	    $("#tooltip p:eq(2)").html("时间："+point.dtime);
		$("#tooltip").css({"top":(y+1)/A4H*100+"%","left":(x+1)/A4W*100+"%"}).show();    
	})
	text.on("mouseout",function(){
		$("#tooltip").hide();    
	})
 }

/**
 * 画文字
 */
function drawText(draw,content,width,family,size,alignment,color,x,y,leading,weight,underline,id){
   var rowLeading= leading || '1.0em';
   var fontWeight = weight || 'normal';
   if(String(content).indexOf("<red>")>-1){
    content=content.replace("<red>","");
    color="red";
   }
   var text = draw.text(content+"");
    
   var anchor= alignment
   if (alignment=="Center"){
        x=x+width/2
        anchor="middle";
   } 
   if (alignment == "end") {
		x = x + width;
	}
   var anchor= anchor || "start"
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
    var span = text.tspan(content+"").fill(color).attr('id',"tspan"+id);
    var colorFlag="",skinTestFlag="";
   	if (content.indexOf("(+)")>-1 || content.indexOf("(阳性)")>-1 || content.indexOf("(-)")>-1 || content.indexOf("(阳性)")>-1){
		colorFlag=content.indexOf("(+)")>-1 || content.indexOf("(阳性)")>-1 ? skinTestY : skinTestN;
		skinTestFlag="Y";		 	
	}
    var dy=0,dx=span.length(),tspan="",yAxis=y;   
    if(Math.floor(span.length()-width)>0){
	    text.remove();
        var wordNums=Math.floor(width/size)
	    var conArr=[],count=0;	    
	    for(var i=0;i<content.length;i=i+wordNums){
		    var con=content.substr(i,wordNums);
		    count++;
		    /*if(skinTestFlag=="Y" && con.indexOf("(")>-1){
				var arr=con.split("(");	
				if(tspan){
					if(arr[0]){
						tspan=tspan.tspan(arr[0]+"").fill(color).x(x).dy(dy);
						tspan.tspan("("+arr[1]+"").fill(colorFlag)
					}else{
						tspan=tspan.tspan("("+arr[1]+"").fill(colorFlag).x(x).dy(dy);
					}			  
				}else{
					if(arr[0]){
						tspan=text.tspan(arr[0]+"").fill(color).x(x).dy(dy).attr("id","tspan"+id);
						tspan.tspan("("+arr[1]+"").fill(colorFlag)
					}else{
						tspan=text.tspan("("+arr[1]+"").fill(colorFlag).x(x).dy(dy).attr("id","tspan"+id);
					}
					dx=tspan.length();
				}				
			}else{
				if(tspan){
					tspan=tspan.tspan(con+"").fill(color).x(x).dy(dy);
				}else{
					tspan=text.tspan(con+"").fill(color).x(x).dy(dy).attr("id","tspan"+id)
					dx=tspan.length();
				}	
				
			}
			dy=size;*/
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
					var tspan=textEle.tspan(con+"").fill(colorFlag).attr("id","tspan"+id+"-"+count);	
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
 
