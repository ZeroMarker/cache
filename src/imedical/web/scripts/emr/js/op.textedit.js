$(function(){
    if($.browser.version == '11.0')
    {
        document.documentElement.className ='ie11';
    }
    setFontData();
    //预留字体大小调整
    //setFontSizeData();
});

//设置字体数据源
function setFontData()
{
    var json = [{"value":"宋体","name":"宋体"},
                {"value":"仿宋","name":"仿宋"},
                {"value":"楷体","name":"楷体"},
                {"value":"黑体","name":"黑体"}
            ]
    for (var i=0;i<json.length;i++)  
    {       
        $('#font').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
    }
    //设置默认显示项
    if ($.browser.version == '6.0')
    {
        setTimeout(function() { 
            $('#font').find('option[value="'+defaultFontStyle.fontFamily+'"]').attr("selected",true);
        }, 1);
    }
    else
    {
        $('#font').find('option[value="'+defaultFontStyle.fontFamily+'"]').attr("selected",true); 
    }        
}
//设置字体大小数据源
function setFontSizeData()
{
    var json = [{"value":"42pt","name":"初号"},
                {"value":"36pt","name":"小初号"},
                {"value":"31.5pt","name":"大一号"},
                {"value":"28pt","name":"一号"},
                {"value":"21pt","name":"二号"},
                {"value":"18pt","name":"小二号"},
                {"value":"16pt","name":"三号"},
                {"value":"14pt","name":"四号"},
                {"value":"12pt","name":"小四号"},
                {"value":"10.5pt","name":"五号"},
                {"value":"9pt","name":"小五号"},
                {"value":"8pt","name":"六号"},
                {"value":"6.875pt","name":"小六号"},
                {"value":"5.25pt","name":"七号"},
                {"value":"4.5pt","name":"八号"},
                {"value":"5pt","name":"5"},
                {"value":"5.5pt","name":"5.5"},
                {"value":"6.5pt","name":"6.5"},
                {"value":"7.5pt","name":"7.5"},
                {"value":"8.5pt","name":"8.5"},
                {"value":"9.5pt","name":"9.5"},
                {"value":"10pt","name":"10"},
                {"value":"11pt","name":"11"}
            ]
    for (var i=0;i<json.length;i++)  
    {       
        $('#fontSize').append("<option value='" + json[i].value + "'>" + json[i].name + "</option>");
    }
    //设置默认显示项
    if ($.browser.version == '6.0')
    {
        setTimeout(function() { 
            $('#fontSize').find('option[value="'+defaultFontStyle.fontSize+'"]').attr("selected",true);    
        }, 1);
    }
    else
    {
        $('#fontSize').find('option[value="'+defaultFontStyle.fontSize+'"]').attr("selected",true);
    }    
    document.getElementById('fontSizeText').value = defaultFontStyle.fontSize.replace('pt','');                     
}

//字号改变
function changeFontSize()
{
    document.getElementById('fontSizeText').value = document.getElementById('fontSize').options[document.getElementById('fontSize').selectedIndex].text;
}

//输入字号
function changeFontSizeText()
{
    if(event.keyCode == 13)
    {
        invoker.iEmrPlugin.FONT_SIZE({
            args:document.getElementById('fontSizeText').value
        });
        document.getElementById('fontSize').value = ""; 
    } 
    
}

//字体
$("#font").change(function(){    
    invoker.iEmrPlugin.FONT_FAMILY({
        args:$("#font").find("option:selected").text()
    });
}); 

//字号
$("#fontSize").change(function(){    
    invoker.iEmrPlugin.FONT_SIZE({
        args:$("#fontSize").find("option:selected").val()
    });
});


//设置字体颜色   start
$("#fontcolor").colorpicker({
});
//打开/关闭颜色选择器
document.getElementById("fontcolor").onclick = function(){
    if (colorpanelshow == "1")
    {
        $("#colorpanel").hide();
        colorpanelshow = "0";
    }
    else if (colorpanelshow == "0")
    {
        $("#colorpanel").show();
        colorpanelshow = "1";
    }
};
//将字体颜色传给编辑器
function setFontColor(color){
    invoker.iEmrPlugin.FONT_COLOR({
        args:color
    });
}
//设置字体颜色   end

//设置粗体
document.getElementById("bold").onclick = function(){    
    invoker.iEmrPlugin.BOLD({
        path:""
    });
};

//设置斜体
document.getElementById("italic").onclick = function(){
    invoker.iEmrPlugin.ITALIC();
};

//设置下划线
document.getElementById("underline").onclick = function(){
    invoker.iEmrPlugin.UNDER_LINE();
};

//删除线
document.getElementById("strike").onclick = function(){    
    invoker.iEmrPlugin.STRIKE();
};

//设置上标
document.getElementById("super").onclick = function(){
    invoker.iEmrPlugin.SUPER();
};

//设置下标
document.getElementById("sub").onclick = function(){    
    invoker.iEmrPlugin.SUB();
};

//设置两端对齐
document.getElementById("alignjustify").onclick = function(){
    invoker.iEmrPlugin.ALIGN_JUSTIFY();
};

//设置左对齐
document.getElementById("alignleft").onclick = function(){
    invoker.iEmrPlugin.ALIGN_LEFT();
};

//设置居中对齐
document.getElementById("aligncenter").onclick = function(){
    invoker.iEmrPlugin.ALIGN_CENTER();
};

//设置右对齐
document.getElementById("alignright").onclick = function(){
    invoker.iEmrPlugin.ALIGN_RIGHT();
};

//设置缩进
document.getElementById("indent").onclick = function(){
    invoker.iEmrPlugin.INDENT();
};

//设置反缩进
document.getElementById("unindent").onclick = function(){
    invoker.iEmrPlugin.UNINDENT();
};

//剪切
document.getElementById("cut").onclick = function(){
    invoker.iEmrPlugin.CUT();
};

//复制
document.getElementById("copy").onclick = function(){
    invoker.iEmrPlugin.COPY();
};

//粘贴
document.getElementById("paste").onclick = function(){
    invoker.iEmrPlugin.PASTE();
};

//撤销
document.getElementById("undo").onclick = function(){
    invoker.iEmrPlugin.UNDO();    
};

//重做
document.getElementById("redo").onclick = function(){
    invoker.iEmrPlugin.REDO();
};

//控制工具栏字体段落格式等按钮的显示和隐藏
/*function setToolBarFontView(disableFont)
{
    var strs = new Array(); //定义一数组
    strs = disableFont.split(","); //字符分割
    for (i=0;i<strs.length;i++ )
    {
        if (document.getElementById(strs[i]) != null)
        {
            if (strs[i] == "font")
            {
                document.getElementById("fontSpan").style.display="none";
            }
            else
            {
                document.getElementById(strs[i]).style.display="none";
            }
        }    
    } 
}*/

