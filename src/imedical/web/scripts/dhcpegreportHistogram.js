///dhcpegreportHistogram.js

var tmdColor1 = new Array();
tmdColor1[0] = "#d1ffd1";
tmdColor1[1] = "#ffbbbb";
tmdColor1[2] = "#ffe3bb";
tmdColor1[3] = "#cff4f3";
tmdColor1[4] = "#d9d9e5";
tmdColor1[5] = "#ffc7ab";
tmdColor1[6] = "#ecffb7";
tmdColor1[7] = "#00ff00";
tmdColor1[8] = "#ff0000";
tmdColor1[9] = "#ff9900";
tmdColor1[10] = "#33cccc";
tmdColor1[11] = "#666699";
tmdColor1[12] = "#993300";
tmdColor1[13] = "#99cc00";

function GetMaxListValue(vList){
	var MaxValue=0;
	var total_no=vList.length;
	for(var i = 0;i<total_no;i++)
	{
 		if (MaxValue<(parseFloat(vList[i]))) { MaxValue = vList[i]; }
	}
	MaxValue = parseInt(MaxValue.toString());
	return MaxValue;
}
function GetColor() {
	var aColor=0;
	var RColor=0,GColor=0,BColor=0;
	//for (var iLLoop=0;iLLoop<3;iLLoop++) {
	RColor=Math.random()*255;
	GColor=Math.random()*255;
	BColor=Math.random()*255;
	RColor=parseInt(RColor.toString());
	GColor=parseInt(GColor.toString());
	BColor=parseInt(BColor.toString());

	//if ((Math.abs(RColor-GColor)<10)&&((Math.abs(RColor-BColor)<10))) {
	//BColor=10;
	//}

	aColor=RColor*Math.pow(256,2)+GColor*Math.pow(255,1)+BColor;

	//}
	//alert(aColor);
	return aColor;
}
function GetMaxImageHeight(value) {
	var temp=0;
	var MaxImage=0;
	if(value>9)
	{  
 		temp = value.toString().substr(1,1)
 		if(temp>4)
 		{
  			MaxImage = (parseInt((value/(Math.pow(10,(value.toString().length-1)))).toString())+1)*Math.pow(10,(value.toString().length-1));
 		}
 			else
 		{
  			MaxImage = (parseInt((value/(Math.pow(10,(value.toString().length-1)))).toString())+0.5)*Math.pow(10,(value.toString().length-1));
 		}

	} 
	else
	{
		if(value>4)
			MaxImage = 10; 
		else 
			MaxImage = 5;
	}
	return MaxImage;
}
function DrawRect(oImage,aleft,atop,awidth,aheight,acolor,azIndex) {
	var strImage="<!--[if gte vml 1]>"
			+"<v:rect id='_x0000_s1027' alt='' style='position:absolute;"
			+"left:"+aleft+"px;"
			+"top:"+atop+"px;"
			+"width:"+awidth+"px;"
			+"height:"+aheight+"px;"
			+"z-index:"+azIndex+"' "
			+"fillcolor='"+acolor+"' "
			+"stroked='f'>"
			+"<v:fill rotate='t' angle='-45' focus='100%' type='gradient'/>"
			+"<o:extrusion v:ext='view' backdepth='" + 20 + "pt' color='" + "red" + "' on='t'/>"
			+"</v:rect>"
			+"<![endif]-->"
			;
	oImage.innerHTML=oImage.innerHTML+strImage;

}
function DrawText(oImage,aText, afontsize, ax, ay, awidth, aheight, aDirection,  acolor, azIndex) {
	
	var strImage="<!--[if gte vml 1]>"
			+"<v:shape id='_x0000_s1025' type='#_x0000_t202' alt='' style='position:absolute;" 
			+"left:"+ax+"px; "
			+"top:"+ay+"px; "
			+"width:"+awidth+"px; "
			+"height:"+aheight+"px;"
			+"z-index:"+azIndex+"'"
			+">"
			+"<v:textbox inset='0px,0px,0px,0px' style='layout-flow:vertical-ideographic'>"
			//+"<table cellspacing='3' cellpadding='0' width='100%' height='100%'>"
			//+"<tr>"
			//+"<td style='font-size:"+afontsize+"px'>" 
			//+aText
			//+ "</td>"
			//+"</tr>"
			//+"</table>"			
			/*
			+"<label style='font-size:"+afontsize+"px'>" 
			+ aText
			+"</label>"
			*/
			
			+"<div style='display:block; width:9px; height:40px; font-size:12px; "
			+"left:"+ax+"px; "
			+"top: "+ay+"px;'>"
			+aText
			+"</div>"
			+"</v:textbox>"
			+"</v:shape>"
			+"<![endif]-->"
			
			;
	//alert(strImage)
	oImage.innerHTML=oImage.innerHTML+strImage;
}
function DrawLine(oImage, axfrom, ayfrom, axto, ayto, acolor, azIndex) {
	//alert("axfrom  "+axfrom+"ayfrom  "+ayfrom+"axto  "+axto+"ayto  "+ayto);
	var strImage="<!--[if gte vml 1]>"
			+"<v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;top:0;"
			+"z-index:"+azIndex+"' "
			+"from='" + axfrom + "px," + ayfrom + "px' "
			+"to='" + axto + "px," + ayto + "px' "
			+"text-align:left;flip:y;/>"
			+"</v:line>"
			+"<![endif]-->"
			;
	//alert(strImage);
	oImage.innerHTML=oImage.innerHTML+strImage;

}
function DrawHistogram(oHistogram,iLabels,iList,Width,Heigth){	

	var x_star=0,x_end=0,y_star=0,y_end=0;
	var x_left=0,x_width=0, y_top=0, y_height=0;
	var x_from=0, y_from=0, x_to=0, y_to=0;
	var all_width=0,all_heigth=0;
	var x_unit=0,y_unit=0;
	var top_border=0,right_border=0,left_border=0,bottom_border=0;
	var canvas_x=0,canvas_y=0,canvas_width=0,canvas_height=0;
	var image_left=0,image_top=0,image_height=0,image_width=0;
	var image_x=0,image_y=0;
	var rect_x=0,rect_y=0,rect_width=0,rect_height=0;
	var rect_top=0,rect_left=0;
	var MaxListValue=0;
	var List_no=0;
	var fillcolor=0;
	var strText="";
	List_no=iList.length;
	oHistogram.innerHTML="";
	

	all_width=oHistogram.clientWidth;
	all_heigth=oHistogram.clientHeight;
	
	top_border=parseInt(all_heigth/100);
	right_border=parseInt(all_width*1.3/10);
	bottom_border=parseInt(all_heigth*3.5/10);
	left_border=parseInt(all_width/84);
	
	canvas_width=all_width-right_border-left_border;
	canvas_height=all_heigth-top_border-bottom_border;
	
	canvas_x=right_border;
	canvas_y=top_border;
	
	x_star=canvas_x;
	y_star=canvas_y;
	x_end=canvas_x+canvas_width;
	y_end=canvas_y+canvas_height;
	
	MaxListValue=GetMaxListValue(iList);
	
	image_height=GetMaxImageHeight(MaxListValue);
	image_width=List_no*2+1;
	
	x_unit=canvas_width/image_width;
	y_unit=canvas_height/image_height;
	//alert("canvas_width "+canvas_width+"  x_unit "+x_unit+"  canvas_height "+canvas_height+"  y_unit "+y_unit)
	// 背景
	DrawRect(oHistogram, x_star, y_star, canvas_width, canvas_height, '#9cf',-1);
	// 竖坐标
	DrawLine(oHistogram, x_star, y_star, x_star, y_end, "red", -1);
	// 横坐标
	DrawLine(oHistogram, x_star, y_end, x_end, y_end, "red",-1);
	
	//alert(image_height+"  "+(image_height/5))
	// 等高线
	for (var iLLoop=0;iLLoop<5;iLLoop++) {
		x_from=x_star;
		y_from=y_star+((image_height/5)*iLLoop*y_unit);
		x_to=x_end;
		y_to=y_star+((image_height/5)*iLLoop*y_unit);
		DrawLine(oHistogram, x_from, y_from, x_to, y_to, "blue",0);
		
		
		x_from=x_star;
		y_from=y_star+((image_height/5)*iLLoop*y_unit);
		strText=image_height/5*(5-iLLoop);
		DrawText(oHistogram, strText+"%", 15, x_from-40, y_from, 40, 25, 'v' ,"blue", 0)

	}

	for (var iLLoop=1;iLLoop<=iList.length;iLLoop++) {
		
		//fillcolor="#"+(parseInt(Math.random()*100)%255);
		//alert(fillcolor);
		
		fillcolor=tmdColor1[iLLoop%13]; //   GetColor(); 
		rect_x=x_star+(2*iLLoop-1)*x_unit;
		rect_y=y_star+canvas_height-(iList[(iLLoop-1)]*y_unit);
		rect_width=x_unit;
		rect_height=(iList[(iLLoop-1)]*y_unit);
		DrawRect(oHistogram, rect_x, rect_y, rect_width, rect_height, fillcolor,iLLoop);
		strText=iLabels[(iLLoop-1)];
		DrawText(oHistogram, strText, 15, rect_x, canvas_height+5, 80, 180, 'v', "blue", 0);	// 柱底文字
		strText=iList[(iLLoop-1)];
		DrawText(oHistogram, strText, 15, rect_x, rect_y-20, 50, 40, 'v', "blue", 0);			// 柱顶文字
	
	}

	//var DImage="<v:rect style='position:absolute; left:26px; top:27px; width:30px; height:150px'/>"
	//alert(obj)
	//obj.innerHTML=obj.innerHTML+DImage;


}
/*
			function drawD() {
	var values = new Array();
	var Acount=parseInt(Math.random()*20);
	if (Acount<5) { Acount=5; }
	for (var iLLoop=0;iLLoop<Acount;iLLoop++) {
		values[iLLoop]=Math.round(Math.random()*100;)

	}
	
	//values[0] = "149";
	//values[1] = "50";
	//values[2] = "45";
	//values[3] = "79";
	//values[4] = "101";
	//values[5] = "120";
	//values[6] = "79";
	//values[7] = "101";
	//values[8] = "120";
	//DHistogram.style.left=Math.random()*100;
	//DHistogram.style.top=Math.random()*100;
	
	//DHistogram.style.width=Math.random()*700;
	//v.style.height=Math.random()*500;
	//for (var iLLoop=0;iLLoop<iList.length;iLLoop++) {
		//iList[iLLoop] = Math.random()*1000;
	//}


	DrawHistogram(DHistogram,values,400,300);
*/