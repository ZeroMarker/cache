//显示颜色对话框
function colordialog(name){
 var top=$(name).offset().top+$(name).height();
 var left=$(name).offset().left;
 $("#Div_colorDialog").css("top",top+"px").css("left",left+"px");
 var currentColor=$(name).css("background-color");
 var colorlist=new Array(40);
    colorlist[0]="#000000"; colorlist[1]="#993300"; colorlist[2]="#333300";colorlist[3]="#003300";
    colorlist[4]="#003366"; colorlist[5]="#000080"; colorlist[6]="#333399";colorlist[7]="#333333";

    colorlist[8]="#800000"; colorlist[9]="#FF6600";  colorlist[10]="#808000";colorlist[11]="#008000";
    colorlist[12]="#008080";colorlist[13]="#0000FF";colorlist[14]="#666699";colorlist[15]="#808080";

    colorlist[16]="#FF0000";colorlist[17]="#FF9900";colorlist[18]="#99CC00";colorlist[19]="#339966";
    colorlist[20]="#33CCCC";colorlist[21]="#3366FF";colorlist[22]="#800080";colorlist[23]="#999999";

    colorlist[24]="#FF00FF";colorlist[25]="#FFCC00";colorlist[26]="#FFFF00";colorlist[27]="#00FF00";
    colorlist[28]="#00FFFF";colorlist[29]="#00CCFF";colorlist[30]="#993366";colorlist[31]="#CCCCCC";

    colorlist[32]="#FF99CC";colorlist[33]="#FFCC99";colorlist[34]="#FFFF99";colorlist[35]="#CCFFCC";
    colorlist[36]="#CCFFFF";colorlist[37]="#99CCFF";colorlist[38]="#CC99FF";colorlist[39]="#FFFFFF";

    var ocbody = "";
    ocbody += "<table CELLPADDING=0 CELLSPACING=3>";
    ocbody += "<tr height='20' width='20'><td align='center'><table style='border:1px solid #808080;background-color:"+currentColor+"' width='12' height='12'><tr><td></td></tr></table></td><td bgcolor='' colspan='7' style='font-size:12px;' align='center'>当前颜色</td></tr>";
    for(var i=0;i<colorlist.length;i++){
        if(i%8==0)
            ocbody += "<tr>";
        ocbody += "<td width='14' height='16' style='border:1px solid #ccc;' onMouseOut='colordialogmouseout(this)' onMouseOver='colordialogmouseover(this)' onMouseDown=\"colordialogmousedown('"+colorlist[i]+"','"+name+"')\" align='center' valign='middle'><table style='border:1px solid #808080;' width='12' height='12' bgcolor='"+colorlist[i]+"'><tr><td></td></tr></table></td>";
        if(i%8==7)
            ocbody += "</tr>";
    }
    ocbody += "<tr><td align='center' height='22' colspan='8' onMouseOut='colordialogmouseout(this)' onMouseOver='colordialogmouseover(this)' style='border:1px solid;font-size:12px;cursor:default;' onMouseDown='CloseColorDialog()'>关闭</td></tr>";
    ocbody += "</table>";
 $("#Div_colorDialog").html(ocbody).show();
}

//鼠标经过特效  
function colordialogmouseout(obj){
    obj.style.borderColor="";
    obj.bgColor="";
}

function colordialogmouseover(obj){
    obj.style.borderColor="#0A66EE";
    obj.bgColor="#EEEEEE";
}
//选择颜色
function colordialogmousedown(color,name){
 $(name).css("background-color",color);
 CloseColorDialog();
}

//关闭颜色对话框
function CloseColorDialog(){
   $("#Div_colorDialog").hide();
}