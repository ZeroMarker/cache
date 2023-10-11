﻿/*
 * @Author: songchao
 * @Date: 2020-11-11 19:42:58
 * @LastEditTime: 2020-11-11 19:46:31
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: \labor\svgUtils.js
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
 * 画文字
 */
function drawText(draw,content,family,size,anchor,x,y,leading,weight,color){
	if(!content) return;
   var rowLeading= leading || '1.0em';
   var fontWeight = weight || 'normal';
    var fontColor = color || "black";
   var text = draw.text(content).fill(fontColor);
   //获取或设置font
   text.font({
       family: family,
       size: size,
       anchor: anchor, //设置位置的相对定位点
       leading: rowLeading,
       weight: fontWeight
   });
   text.move(x,y);
}

/**
 * 画文字并旋转90度
 */
function drawTextRotate90(draw,content,family,size,anchor,x,y,leading,weight,color){
	if(!content) return;
   var rowLeading= leading || '1.0em';
   var fontWeight = weight || 'normal';
    var fontColor = color || "black";
   var text = draw.text(content).fill(fontColor);
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


 /**
 * 画换行文字
 */
function drawTextWrap(draw,content,width,family,size,alignment,color,x,y,leading,weight,id,maxRows,printed){
    if (!!!content)
    {
        return
    }
     var wrapContentArray=[]
     var specialCharSum = 0  //ascall码字符数量
     if (content.match(/[\x00-\xff]/g) != null)
     {
        var specialCharSum=content.match(/[\x00-\xff]/g).length	
     }
     var chineseCharSum=content.length-specialCharSum //中文字符数量
     var oneLineWidth = chineseCharSum * size + specialCharSum * ( size / 2 )
     if (oneLineWidth>width){
         if (!!maxRows && oneLineWidth/width > maxRows)  //如果超过最大行数,字体大小减1
         {
             size=size-1
         }
         wrapContentArray=textWrap(content,size,width)
     }else{
         wrapContentArray=[content]
     }
     
    var content=wrapContentArray.join("\n")
    var rowLeading= leading || '1.0em';
    var fontWeight = weight || 'normal';
    if(String(content).indexOf("<red>")>-1){
     content=content.replace("<red>","");
     color="red";
    }
    if (!!printed)
    {
            var text = draw.text(content+"").attr('class','printed').attr('id','text_row_'+id);
    }else{
        if (content!="")
        {
                var text = draw.text(content+"").fill(color).attr('class','unPrinted').attr('id','text_row_'+id);
        }else{
                var text = draw.text(content+"").fill(color).attr('id','text_row_'+id)
        }
    }
     
    var anchor="start"
    if (alignment=="Center"){
         x=x+width/2
         anchor="middle";
    }   
    //获取或设置font
    text.font({
         family: family,
         size: size,
         anchor: anchor, //设置位置的相对定位点
         leading: rowLeading,
         weight: fontWeight
     });
    if(weight=="Underline"){    
     //text.attr("text-decoration","underline");
     // debugger;
     draw.line(x,y+size, x+span.length(), y+size).stroke({ width: 0.25 }); 
    }
    
    text.move(x, wrapContentArray.length == 1 ? y+2 : y+1);
    //text.clear();
 }
 
  /**
  * 分行
  */
 function textWrap(str,fontSize, width)
 {
     var strs = []; ///换行规则数组、防止单词拆分换行、防止例如 2.8g 拆分换行
     while(str.length > 1)
     {
         if ((/[\x00-\xff]/g).test(str.charAt(0)))
         {
             //var pos = str.search(/[^\x00-\xff]|(^\s+)|(\s+$)|\s+/g)
             var pos = str.search("[^\x00-\xff]|[\\)\\] ]")
             pos = pos == -1 ? str.length-1 : pos
             pos = (str.charAt(pos) == "]" ||  str.charAt(pos) == ")") ? pos + 1 : pos
             pos = pos == 0 ? 1 : pos
             strs.push(str.substring(0, pos))
         }else{
             strs.push(str.charAt(0))
             var pos=1
         }
         str = str.substring(pos)
     }
     if (str != "")
     {
         strs.push(str);
     }
     
     /*分行*/
     var multRows=[],singleStr="",singleWidth=0
     for(var index in strs){
         var str = strs[index]
         var flag = (/[\x00-\xff]/g).test(str)
         var curWidth = flag ? str.length * ( fontSize / 2 ) : str.length * fontSize
         if ( singleWidth + curWidth < width )
         {
             singleStr = singleStr + str
             singleWidth = singleWidth + curWidth
             if (index == strs.length-1 )
             {
                 multRows.push(singleStr)
                 singleStr = ""
                 singleWidth = 0
             }
             continue
         }
         multRows.push(singleStr)
         singleStr = str
         singleWidth = 0
     }
     if (singleStr != "")
     {
         multRows.push(singleStr)
     }
     return multRows
 }
 