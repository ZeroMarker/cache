

function GetData(s){	
	var flag=parseInt(s);
	
	if (isNaN(flag)) {
		alert("error");
		return;
		}
	if (flag<0) {
		alert("error");
		return;
		}
	if (flag==0) {
		alert("error");
		return;
		}
	var Temp1= new Array()
	Temp1=s.split(CHR_1)
	if (parseInt(Temp1.length)==0) return;
	
	//var iLines=Temp1[0];
	var total = new Array()
	
	var arrTime=Temp1[1].split(CHR_3);
	total[0]=arrTime;
	var i=0
	/*
	var arrTemp =Temp1[2].split(CHR_3);
	total[1]=arrTemp;
	*/
	var iLines=Temp1.length-2;
	
	for (i=2;i<(Temp1.length);i++){
		var arrTemp =Temp1[i].split(CHR_3);
		total[i-1]=arrTemp;
		}
	var sdata=table2(total,10,120,680,440,iLines,10);
    var obj=document.getElementById("Draw");
    obj.innerHTML=sdata;
	}
	


/*********************************************************
/ demo
**********************************************************/
function table2(total,table_x,table_y,all_width,all_height,line_no,num_y)
{
//参数含义(传递的数组?横坐标?纵坐标?图表的宽度?图表的高度,折线条数)
//纯ASP代码生成图表函数2??折线图
//***************************************************************************************
var line_color = "#69f";
var left_width = 70;
var total_no = total[1].length
var temp1,temp2,temp3
var s;
s="";
temp1 = 0;
for(var i=1;i<total_no;i++)
{
 for(var j=1;j<=line_no;j++)
 {
  if(temp1<parseInt(total[j][i]))
   temp1 = parseInt(total[j][i]);
 }
}

temp3=BuildMax(temp1);
temp4 = temp3;

//Background
s+="<v:rect id='_x0000_s1027' alt='' style='position:absolute;left:" + (table_x + left_width) + "px;top:" + table_y + "px;width:" + all_width + "px;height:" + all_height + "px;z-index:-1' fillcolor='#9cf' stroked='f'><v:fill rotate='t' angle='-45' focus='100%' type='gradient'/></v:rect>";
//Y-grid

for(var i=0;i<all_height;i += all_height/num_y)
{
 //Y data
 s+="<v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x + left_width + length) + "px," + (table_y + all_height - length - i) + "px' to='" + (table_x + all_width + left_width) + "px," + (table_y + all_height - length - i) + "px' strokecolor='" + line_color + "'/>";
 s+="<v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x + (left_width - 15)) + "px," + (table_y + i) + "px' to='" + (table_x + left_width) + "px," + (table_y + i) + "px'/>";
 s+="<v:shape id='_x0000_s1025' type='#_x0000_t202' alt='' style='position:absolute;left:" + table_x + "px;top:" + (table_y + i) + "px;width:" + left_width + "px;height:18px;z-index:1'>";
 s+="<v:textbox inset='0px,0px,0px,0px'><table cellspacing='3' cellpadding='0' width='100%' height='100%'><tr><td align='right'>" + temp4 + "</td></tr></table></v:textbox></v:shape>";
 temp4 = temp4 - temp3/num_y;
}
//X-Y 0 line
s+="<v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x + left_width) + "px," + (table_y + all_height) + "px' to='" + (table_x + all_width + left_width) + "px," + (table_y + all_height) + "px'/>";
s+="<v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x + left_width) + "px," + table_y + "px' to='" + (table_x + left_width) + "px," + (table_y + all_height) + "px'/>";

var tmpStr = ""
for(i=1;i<=line_no;i++)
{
 var re  = /,/g;
 tmpStr += ",[\"" + total[i][0].replace(re,"\",\"") + "\"]"
 //var re  = /^/g;
 //tmpStr += ",[\"" + total[i][0].replace(re,"\",\"") + "\"]"
}
tmpStr = tmpStr.substr(1,tmpStr.length-1)
var line_code = eval("new Array(" + tmpStr + ")")

//Draw every line
for(var j=1;j<=line_no;j++)
{
	//Point to point
 for(var i=1;i<total_no-1;i++)
 {
  var x1 = table_x + left_width + all_width * (i - 1)/(total_no-1)
  var y1 = table_y + (temp3 - total[j][i]) * (all_height/temp3)
  var x2 = table_x + left_width + all_width * i/(total_no-1)
  var y2 = table_y + (temp3 - total[j][i+1]) * (all_height/temp3)
  //线条的颜色,线条的宽度
  s+="<v:line id='_x0000_s1025' alt='' style='position:absolute;left:0;text-align:left;top:0;z-index:1' from='" + x1 + "px," + y1 + "px' to='" + x2 + "px," + y2 + "px' coordsize='21600,21600' strokecolor='" + line_code[j-1][0] + "' strokeweight='" + line_code[j-1][1] + "'>";
  
  //线条的类型
  var temps;
  temps=BuildLineType(parseInt(line_code[j-1][2]));
  if (temps!=""){
	  s+="<v:stroke dashstyle="+temps+"/>";
	  }  
  s+="</v:line>"
  
  
  //Point 转折点的类型
  switch (parseInt(line_code[j-1][3]))
  {
   case 1:
    break;
   case 2:
    s+="<v:rect id='_x0000_s1027' style='position:absolute;left:" + (x1 - 2) + "px;top:" + (y1 - 2) + "px;width:4px;height:4px;z-index:2' fillcolor='" + line_code[j-1][0] + "' strokecolor='" + line_code[j-1][0] + "'/>";
   case 3:
    s+="<v:oval id='_x0000_s1026' style='position:absolute;left:" + (x1 - 2) + "px;top:" + (y1 - 2) + "px;width:4px;height:4px;z-index:1' fillcolor='" + line_code[j-1][0] + "' strokecolor='" + line_code[j-1][0] + "'/>";
    break;
  } 
  
 }
  //Last point
  switch (parseInt(line_code[j-1][3]))
  {
   case 1:
    break;
   case 2:
    s+="<v:rect id='_x0000_s1027' style='position:absolute;left:" + (x2 - 2) + "px;top:" + (y2 - 2) + "px;width:4px;height:4px; z-index:2' fillcolor='" + line_code[j-1][0] + "' strokecolor='" + line_code[j-1][0] + "'/>";
    break;
   case 3:
    s+="<v:oval id='_x0000_s1026' style='position:absolute;left:" + (x2 - 2) + "px;top:" + (y2 - 2) + "px;width:4px;height:4px;z-index:1' fillcolor='" + line_code[j-1][0] + "' strokecolor='" + line_code[j-1][0] + "'/>";
    break;
  }
  
}

//获得需要显示的x轴数组
var Xtitle=GetXTitle(total[0]);
var xLen=Xtitle.length;
/*
for (var i=0;i<xLen;i++)
{
	s+="<v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x + left_width + all_width * (i)/(xLen)) + "px," + (table_y + all_height) + "px' to='" + (table_x + left_width + all_width * (i)/(xLen)) + "px," + (table_y + all_height + 15) + "px'/>";
    s+="<v:shape id='_x0000_s1025' type='#_x0000_t202' alt='' style='position:absolute;left:" + (table_x + left_width + all_width * (i)/(xLen)) + "px;top:" + (table_y + all_height) + "px;width:" + (all_width/(xLen)) + "px;height:20px;z-index:1'>";
    s+="<v:textbox inset='0px,0px,0px,0px'><table cellspacing='3' cellpadding='0' width='100%' height='100%'><tr><td align='left'>" + Xtitle[i] + "</td></tr></table></v:textbox></v:shape>";
}
*/
var j=0;
//X description
for (var i=0;i<total_no-1;i++)
{
	var shapeWidth=all_width/xLen;
	if (total[0][i]==Xtitle[j]){
	  /*
      s+="<v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x + left_width + all_width * (i)/(total_no-1)) + "px," + (table_y + all_height) + "px' to='" + (table_x + left_width + all_width * (i)/(total_no-1)) + "px," + (table_y + all_height + 15) + "px'/>";
      s+="<v:shape id='_x0000_s1025' type='#_x0000_t202' alt='' style='position:absolute;left:" + (table_x + left_width + all_width * (i)/(total_no-1)) + "px;top:" + (table_y + all_height) + "px;width:" + (all_width/(total_no-1)) + "px;height:20px;z-index:1'>";
      s+="<v:textbox inset='0px,0px,0px,0px'><table cellspacing='3' cellpadding='0' width='100%' height='100%'><tr><td align='left'>" + total[0][i] + "</td></tr></table></v:textbox></v:shape>";
      */
      s+="<v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x + left_width + all_width * (i)/(total_no-1)) + "px," + (table_y + all_height) + "px' to='" + (table_x + left_width + all_width * (i)/(total_no-1)) + "px," + (table_y + all_height + 15) + "px'/>";
      s+="<v:shape id='_x0000_s1025' type='#_x0000_t202' alt='' style='position:absolute;left:" + (table_x + left_width + all_width * (i)/(total_no-1)-(shapeWidth/2)) + "px;top:" + (table_y + all_height+15) + "px;width:" + (all_width/xLen) + "px;height:20px;z-index:1'>";
      s+="<v:textbox inset='0px,0px,0px,0px'><table cellspacing='3' cellpadding='0' width='100%' height='100%'><tr><td align='center'>" + total[0][i] + "</td></tr></table></v:textbox></v:shape>";
      
      j++;
    }
}


//line description
var tb_height = 30
s+="<v:rect id='_x0000_s1025' style='position:absolute;left:" + (table_x + all_width + 80) + "px;top:" + table_y + "px;width:100px;height:" + (line_no * tb_height + 10) + "px;z-index:1'/>";
for(var i=0;i<line_no;i++)
{
 /*
 s+="<v:shape id='_x0000_s1025' type='#_x0000_t202' alt='' style='position:absolute;left:" + (table_x + all_width + 25) + "px;top:" + (table_y + 10+(i) * tb_height) + "px;width:60px;height:" + tb_height + "px;z-index:1'>";
 s+="<v:textbox inset='0px,0px,0px,0px'><table cellspacing='3' cellpadding='0' width='100%' height='100%'><tr><td align='left'>" + line_code[i][4] + "</td></tr></table></v:textbox></v:shape>";
 s+="<v:rect id='_x0000_s1040' alt='' style='position:absolute;left:" + (table_x + all_width + 80) + "px;top:" + (table_y + 10+(i) * tb_height + 4) + "px;width:30px;height:20px;z-index:1' fillcolor='" + line_code[i][0] + "'><v:fill color2='" + line_code[i][0] + "' rotate='t' focus='100%' type='gradient'/></v:rect>";
 */
 s+="<v:shape id='_x0000_s1025' type='#_x0000_t202' alt='' style='position:absolute;left:" + (table_x + all_width + 85) + "px;top:" + (table_y+ 5 +(i) * tb_height) + "px;width:80px;height:" + tb_height + "px;z-index:1'>";
 s+="<v:textbox inset='0px,0px,0px,0px'><table cellspacing='3' cellpadding='0' width='100%' height='100%'><tr><td align='left'>" + line_code[i][4] + "</td></tr></table></v:textbox></v:shape>";
 s+="<v:rect id='_x0000_s1040' alt='' style='position:absolute;left:" + (table_x + all_width + 160) + "px;top:" + (table_y + 5+(i) * tb_height + 4) + "px;width:10px;height:20px;z-index:1' fillcolor='" + line_code[i][0] + "'><v:fill color2='" + line_code[i][0] + "' rotate='t' focus='100%' type='gradient'/></v:rect>";
 
}
return s;
}


function table1(total,table_x,table_y,thickness,table_width,all_width,all_height,table_type){
//参数含义(传递的数组?横坐标?纵坐标?柱子的厚度?柱子的宽度?图表的宽度?图表的高度,图表的类型)

var tmdColor1 = new Array();
tmdColor1[0] = "#d1ffd1";
tmdColor1[1] = "#ffbbbb";
tmdColor1[2] = "#ffe3bb";
tmdColor1[3] = "#cff4f3";
tmdColor1[4] = "#d9d9e5";
tmdColor1[5] = "#ffc7ab";
tmdColor1[6] = "#ecffb7";
var tmdColor2 = new Array();
tmdColor2[0] = "#00ff00";
tmdColor2[1] = "#ff0000";
tmdColor2[2] = "#ff9900";
tmdColor2[3] = "#33cccc";
tmdColor2[4] = "#666699";
tmdColor2[5] = "#993300";
tmdColor2[6] = "#99cc00";
var tb_color = new Array(tmdColor1,tmdColor2);
var line_color = "#69f";
var left_width = 70;
var length = thickness/2;
var total_no = total[0].length;
var temp1 = 0;
var temp2,temp4,temp4;
var s;
s="";

for(var i = 0;i<total_no;i++)
{
 if(temp1<total[0][i])
 {
  temp1 = total[0][i];
 }
}

temp3=BuildMax(temp1);
temp4 = temp3;

s+="<!--[if gte vml 1]><v:rect id='_x0000_s1027' alt='' style='position:absolute;left:" + (table_x+left_width) + "px;top:" + table_y + "px;width:" + all_width + "px;height:" + all_height + "px;z-index:-1' fillcolor='#9cf' stroked='f'><v:fill rotate='t' angle='-45' focus='100%' type='gradient'/></v:rect><![endif]-->";

s+="<!--[if gte vml 1]><v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x+left_width) + "px," + (table_y+all_height) + "px' to='" + (table_x+all_width+left_width) + "px," + (table_y+all_height) + "px'/><![endif]-->";

s+="<!--[if gte vml 1]><v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x+left_width) + "px," + table_y + "px' to='" + (table_x+left_width) + "px," + (table_y+all_height) + "px'/><![endif]-->";

switch (table_type)
{
 case "A": 

 var table_space = (all_width-table_width*total_no)/total_no;
 s+="<!--[if gte vml 1]><v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x+left_width+length) + "px,"+ table_y + "px' to='" + (table_x+left_width+length) + "px," + (table_y+all_height-length) + "px' strokecolor='" + line_color + "'/><![endif]-->";

 for(var i=0;i<=all_height-1;i+= all_height/5)
 {
 
  s+="<!--[if gte vml 1]><v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x+left_width)+ "px," + (table_y+all_height-length-i) + "px' to='" + (table_x+left_width+length) + "px," + (table_y+all_height-i) +"px' strokecolor='" + line_color + "'/><![endif]-->";
  s+="<!--[if gte vml 1]><v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x+left_width+length) + "px," + (table_y+all_height-length-i) + "px' to='" + (table_x+all_width+left_width) + "px," + (table_y+all_height-length-i) + "px' strokecolor='" + line_color + "'/><![endif]-->";
  s+="<!--[if gte vml 1]><v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x+(left_width-15)) + "px," + (table_y+i) + "px' to='" + (table_x+left_width) + "px," + (table_y+i) + "px'/><![endif]-->";
  s+="<!--[if gte vml 1]>";
  s+="<v:shape id='_x0000_s1025' type='#_x0000_t202' alt='' style='position:absolute;left:" + table_x + "px;top:" + (table_y+i) + "px;width:" + left_width + "px;height:18px;z-index:1'>";
  s+="<v:textbox inset='0px,0px,0px,0px'><table cellspacing='3' cellpadding='0' width='100%' height='100%'><tr><td align='right'>" + temp4 + "</td></tr></table></v:textbox></v:shape><![endif]-->";
  temp4 = temp4-temp3/5;
 }
 for(var i=0;i<total_no;i++)
 {
  
  var temp_space = table_x + left_width + table_space / 2 + table_space * i + table_width * i;  
  s+="<v:rect id='_x0000_s1025' alt='' style='position:absolute;left:";
  s+=temp_space;
  s+="px;top:";
  s+=table_y + all_height * (1 - (total[0][i] / temp3));
  s+="px;width:" + table_width + "px;height:" + all_height * (total[0][i] / temp3) + "px;z-index:1' fillcolor='" + tb_color[1][i] + "'>";
  s+="<v:fill color2='" + tb_color[0][i] + "' rotate='t' type='gradient'/>";
  s+="<o:extrusion v:ext='view' backdepth='" + thickness + "pt' color='" + tb_color[1][i] + "' on='t'/>";
  s+="</v:rect>";
  s+="<v:shape id='_x0000_s1025' type='#_x0000_t202' alt='' style='position:absolute;left:" + temp_space + "px;top:" + (table_y+all_height*(1-(total[0][i]/temp3))-table_width) + "px;width:" + (table_space+15) + "px;height:18px;z-index:1'>";
  s+="<v:textbox inset='0px,0px,0px,0px'><table cellspacing='3' cellpadding='0' width='100%' height='100%'><tr><td align='center'>" + total[0][i] + "</td></tr></table></v:textbox></v:shape>";
  s+="<v:shape id='_x0000_s1025' type='#_x0000_t202' alt='' style='position:absolute;left:" + (temp_space-table_space/2) + "px;top:" + (table_y+all_height+1) + "px;width:" + (table_space+table_width) + "px;height:18px;z-index:1'>";
  s+="<v:textbox inset='0px,0px,0px,0px'><table cellspacing='3' cellpadding='0' width='100%' height='100%'><tr><td align='center'>" + total[1][i] + "</td></tr></table></v:textbox></v:shape>";
 }
 
 break;
case "B":
 temp4=temp3 / 5;
 var table_space = (all_height - table_width * total_no) / total_no;
 s+="<!--[if gte vml 1]><v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x+left_width+length) + "px," + (table_y+all_height-length) + "px' to='" + (table_x+left_width+all_width) + "px," + (table_y+all_height-length) + "px' strokecolor='" + line_color + "'/><![endif]-->";
 for(var i=0;i<=all_width-1;i +=all_width/5)
 {
  s+="<!--[if gte vml 1]><v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x+left_width+i) + "px," + (table_y+all_height-length) + "px' to='" + (table_x+left_width+length+i) + "px," + (table_y+all_height) + "px' strokecolor='" + line_color + "'/><![endif]-->";
  s+="<!--[if gte vml 1]><v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x+left_width+length+i) + "px," + (table_y+all_height-length) + "px' to='" + (table_x+left_width+length+i) + "px," + table_y + "px' strokecolor='" + line_color + "'/><![endif]-->";
  s+="<!--[if gte vml 1]><v:line id='_x0000_s1027' alt='' style='position:absolute;left:0;text-align:left;top:0;flip:y;z-index:-1' from='" + (table_x+left_width+i+all_width/5) + "px," + (table_y+all_height) + "px' to='" + (table_x+left_width+i+all_width/5) + "px," + (table_y+all_height+15) + "px'/><![endif]-->";
  s+="<!--[if gte vml 1]>";
  s+="<v:shape id='_x0000_s1025' type='#_x0000_t202' alt='' style='position:absolute;left:" + (table_x+left_width+i+all_width/5-left_width) + "px;top:" + (table_y+all_height) + "px;width:" + left_width + "px;height:18px;z-index:1'>";
  s+="<v:textbox inset='0px,0px,0px,0px'><table cellspacing='3' cellpadding='0' width='100%' height='100%'><tr><td align='right'>" + temp4 + "</td></tr></table></v:textbox></v:shape><![endif]-->";
  temp4=temp4 + temp3 / 5;
  //temp4 = temp4 - temp3 / 5;
 }
 
 for(var i=0;i<total_no;i++)
 {
  var temp_space = table_space/2 + table_space * i + table_width * i;
  s+="<v:rect id='_x0000_s1025' alt='' style='position:absolute;left:";
  s+=table_x + left_width;
  s+="px;top:";
  s+=table_y + temp_space;
  s+="px;width:" + all_width * (total[0][i] / temp3) + "px;height:" + table_width + "px;z-index:1' fillcolor='" + tb_color[1][i] + "'>";
  s+="<v:fill color2='" + tb_color[0][i] + "' rotate='t' angle='-90' focus='100%' type='gradient'/>";
  s+="<o:extrusion v:ext='view' backdepth='" + thickness + "pt' color='" + tb_color[1][i] + "' on='t'/>";
  s+="</v:rect>";
  s+="<v:shape id='_x0000_s1025' type='#_x0000_t202' alt='' style='position:absolute;left:" + (table_x + left_width + all_width * (total[0][i] / temp3) + thickness / 2) + "px;top:" + (table_y + temp_space) + "px;width:" + (table_space + 15) + "px;height:18px;z-index:1'>";
  s+="<v:textbox inset='0px,0px,0px,0px'><table cellspacing='3' cellpadding='0' width='100%' height='100%'><tr><td align='center'>" + total[0][i] + "</td></tr></table></v:textbox></v:shape>";
 
  s+="<v:shape id='_x0000_s1025' type='#_x0000_t202' alt='' style='position:absolute;left:" + table_x + "px;top:" + (table_y + temp_space) + "px;width:" + left_width + "px;height:18px;z-index:1'>";
  s+="<v:textbox inset='0px,0px,0px,0px'><table cellspacing='3' cellpadding='0' width='100%' height='100%'><tr><td align='right'>" + total[1][i] + "</td></tr></table></v:textbox></v:shape>";
 }
 
 }
}



















//**********************公共函数

//根据最大值取Y轴上限
function BuildMax(temp1){
var temp2,temp3
temp1 = parseInt(temp1);
if(temp1>9)
{
 temp2 = temp1.toString().substr(1,1);
 if(temp2>4)
 {
  temp3 = (parseInt(temp1/(Math.pow(10,(temp1.toString().length-1))))+1)*Math.pow(10,(temp1.toString().length-1));
 }
 else
 {
  temp3 = (parseInt(temp1/(Math.pow(10,(temp1.toString().length-1))))+0.5)*Math.pow(10,(temp1.toString().length-1));
 }
}
else
{
 if(temp1>4)
 {
  temp3 = 10; 
 }
 else
 {
  temp3 = 5;
 }
}
 return temp3;
}

function  BuildLineType(val){
  var iValue=parseInt(val)
  var temps=""
  //线条的宽度
  switch (iValue)
  {
   case 1:
    break;
   case 2:
    temps='1 1'
    break;
   case 3:
    temps='dash';
    break;
   case 4:
    temps='dashDot';
    break;
   case 5:
    temps='longDash';
    break;
   case 6:
    temps='longDashDot';
    break;
   case 7:
    temps='longDashDotDot';
    break;
  }
  return temps;
}

//按照条件把需要显示的x轴描述整理到新数组中
function GetXTitle(arrTitle){
var XTitle=new Array();
var arrLen=arrTitle.length;
var j=0;
for (var i=0;i<arrLen;i++){
	var flag=0;
	if ((arrLen)<20){ flag=1;}
	else{
	  var time=arrTitle[i];
	  var displaytime1=":00";
	  var displaytime2=":30";
	  var index1=time.indexOf(displaytime1);
	  //var index2=0;
	  //var index2=time.indexOf(displaytime2);||
	  //    (index2>=0)
	  //    
	  if ((i==0)||
	      (i==(arrLen-1))||
	      (index1>=0)
	      ){
		  flag=1;
		  }
	}
	//如果最后一条数据不符合条件?只画线?不显示描述
	if ((i==(arrLen-1))&&(index1<0)) arrTitle[i]="";
	if (flag==1){
		XTitle[j]=arrTitle[i];
		j++;
		}
}
return XTitle;
}