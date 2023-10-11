function ComboxDiagInput(inputid)
{
    var width = $('#'+inputid).width();
    var height = $('#'+inputid).height();

    document.write("<style>")
    document.write("#myllllldiv li{list-style:none;}")
    document.write("#myllllldiv li a{width:"+width+"px; height:"+height+"px;display:block}")
    document.write("#myllllldiv li a:hover{background:#d3d4cc}")
    document.write("</style>")
    document.write("<EXTHEALTH:HEAD></EXTHEALTH:HEAD>")
    var ClassName = "web.DHCBL.MKB.MKBDaigCombox";

    var termid="";
    var catid="";
    var detid="";
    var cursor=0;
    String.prototype.replaceAll = function (findText, repText){
        var newRegExp = new RegExp(findText, 'gm');
        return this.replace(newRegExp, repText);
    };

    var Y = $('#'+inputid).offset().top;
    var X = $('#'+inputid).offset().left;
    var myllllldivstyle="width:"+width+"px;background-color:white;height:"+(height*6)+"px;overflow:auto;"
    $('#'+inputid).after("<div id='myllllldiv' style="+myllllldivstyle+"></div>");
    $('#myllllldiv').css({"position":"absolute","left":X,"margin-top":"50px"});
    $("#myllllldiv").hide();
    $('#'+inputid).bind('keyup',function(e) {
        //alert(e.keyCode)
        //空格:32;等号:187;分号:186;顿号：229;回车：13；上：38；下：40
         if ((e.keyCode==13)&&($('#myllllldiv').text()==""))
         {
             // alert($('#'+inputid).val())
        //     //var result = tkMakeServerCall(ClassName,"DealStr",$('#'+inputid).val())
        //     //alert(result)
         }
        if (e.keyCode==38)
        {
            e.preventDefault();
            if (cursor==0)
            {
                return;
            }
            else
            {
                $("#myllllldiv li a:eq("+cursor+")").css("background","white")
                cursor=cursor-1;
                $("#myllllldiv li a:eq("+cursor+")").css("background","#d3d4cc")
            }
            if(cursor>=1)
            {
                $("#myllllldiv").scrollTop($("#myllllldiv").scrollTop()-height)
            }

        }
        if (e.keyCode==40)
        {
            e.preventDefault();
            if (cursor>=2)
            {
                $("#myllllldiv").scrollTop($("#myllllldiv").scrollTop()+height)

            }
            if (cursor==$("#myllllldiv li a").length-1)
            {
                return;
            }
            else
            {
                $("#myllllldiv li a:eq("+cursor+")").css("background","white");
                cursor=cursor+1;
                $("#myllllldiv li a:eq("+cursor+")").css("background","#d3d4cc");
            }
        }
        var index = $(this).val().split(";").length-1
        if (index==0)
        {
            if (e.keyCode==32)
            {
                if ($(this).val()==" ")
                {
                    $(this).val("诊断=")
                }
                else if (($(this).val().indexOf("诊断=")!=-1)&&($(this).val().indexOf("属性=") == -1)&&(termid!=""))
                {
                    var text =$(this).val();
                    if(text.substring(text.indexOf("诊断=")+3).trim()=="")
                    {
                        return;
                    }
                    $(this).val(text+",属性=");
                }
                else if(($(this).val().indexOf("诊断=")!=-1)&&($(this).val().indexOf("属性=") != -1)&&($(this).val().indexOf("内容=") == -1)&&(catid!=""))
                {
                    var text =$(this).val()
                    if(text.substring(text.indexOf("属性=")+3).trim()=="")
                    {
                        return;
                    }
                    $(this).val(text+",内容=")
                }
                else if(($(this).val().indexOf("诊断=")!=-1)&&($(this).val().indexOf("属性=") != -1)&&($(this).val().indexOf("内容=") != -1))
                {
                    return;
                }
            }
            if ((e.keyCode!=38)&&(e.keyCode!=40))
            {

                var input = $(this).val();
                if (input.indexOf("诊断=")==-1)
                {
                    $("#myllllldiv").empty();
                    $("#myllllldiv").hide();
                }
                if (input.indexOf("诊断=")!=-1&&input.indexOf("属性=")==-1)
                {
                    if (input.length-input.replace("=","").length>1)
                    {
                        $("#myllllldiv").empty();
                        $("#myllllldiv").hide();
                    }
                    else
                    {
                        var start=input.indexOf("诊断=")+3
                        var sub=input.substring(start).trim().replaceAll("'","")
                        var data=tkMakeServerCall(ClassName,"GetTerm",sub)

                        $('#myllllldiv').empty();

                        $("#myllllldiv").append(data);
                        $('#myllllldiv').show();

                        $("#myllllldiv li a").first().css("background","#d3d4cc")
                        $("#myllllldiv li a").click(function(){
                            var text =  $('#'+inputid).val().replace(sub,"").trim();
                            var sel = $(this).parent().text();
                            $('#'+inputid).val(text+sel);
                            $(this).parent().parent().parent().hide();
                            $('#'+inputid).focus();
                            $('#myllllldiv').empty();
                            termid = $(this).parent().attr("id");
                            cursor=0
                        });
                        if (e.keyCode=="13")
                        {
                            var text =  $('#'+inputid).val().replace(sub,"").trim();
                            var sel = $("#myllllldiv li a:eq("+cursor+")").parent().text();
                            $('#'+inputid).val(text+sel);
                            $("#myllllldiv li a:eq("+cursor+")").parent().parent().parent().hide();
                            $('#'+inputid).focus();
                            termid = $("#myllllldiv li a:eq("+cursor+")").parent().attr("id");
                            $('#myllllldiv').empty();
                            cursor=0
                        }
                    }
                }
                else if(($(this).val().indexOf("诊断=")!=-1)&&($(this).val().indexOf("属性=") != -1)&&($(this).val().indexOf("内容=") == -1))
                {
                    var input=input.substring(input.indexOf(",")).trim()
                    if (input.length-input.replace("=","").length>1)
                    {
                        $("#myllllldiv").empty();
                        $("#myllllldiv").hide();
                    }
                    else
                    {
                        var start = input.indexOf("属性=") + 3;
                        var sub = input.substring(start).trim().replaceAll("'","");
                        if (termid == ""){
                            return;
                        }
                        var data=tkMakeServerCall(ClassName,"GetPro",termid ,sub)
                        $('#myllllldiv').empty();
                        $("#myllllldiv").append(data)
                        $('#myllllldiv').show();
                        $("#myllllldiv li a").first().css("background","#d3d4cc")
                        $("#myllllldiv li a").click(function(){
                            var text =  $('#'+inputid).val().replace(sub,"").trim();
                            var sel = $(this).parent().text();
                            $('#'+inputid).val(text+sel);
                            $(this).parent().parent().parent().hide();
                            $('#'+inputid).focus();
                            $('#myllllldiv').empty();
                            catid = $(this).parent().attr("id");
                        });
                        if (e.keyCode=="13")
                        {
                            var text =  $('#'+inputid).val().replace(sub,"").trim();
                            var sel = $("#myllllldiv li a:eq("+cursor+")").parent().text();
                            $('#'+inputid).val(text+sel);
                            $("#myllllldiv li a:eq("+cursor+")").parent().parent().parent().hide();
                            $('#'+inputid).focus();
                            catid = $("#myllllldiv li a:eq("+cursor+")").parent().attr("id");
                            $('#myllllldiv').empty();
                            cursor=0
                        }
                    }
                }
                else if(($(this).val().indexOf("诊断=")!=-1)&&($(this).val().indexOf("属性=") != -1)&&($(this).val().indexOf("内容=") != -1))
                {

                    var input=input.substring(input.lastIndexOf(",")).trim()
                    if (input.length-input.replace("=","").length>1)
                    {
                        $("#myllllldiv").empty();
                        $("#myllllldiv").hide();
                    }
                    else
                    {
                        if (e.keyCode==229) {
                            var start = input.indexOf("内容=") + 3;
                            var sub = input.substring(start).trim();
                            if ((sub == "") || (detid == "")) {
                                return;
                            }
                        }
                        var sub="";
                        var start="";
                        if (input.indexOf("、")!=-1)
                        {
                            start = input.lastIndexOf("、")+1;
                        }
                        else
                        {
                            start=input.indexOf("内容=")+3;
                        }
                        sub = input.substring(start).trim().replaceAll("'","");
                        var data=tkMakeServerCall(ClassName,"GetDetail",catid ,sub);
                        $('#myllllldiv').empty();
                        $("#myllllldiv").append(data);
                        $('#myllllldiv').show();
                        $("#myllllldiv li a").first().css("background","#d3d4cc");
                        $("#myllllldiv li a").click(function(){
                            var text =  $('#'+inputid).val().replace(sub,"").trim();
                            var sel = $(this).parent().text();
                            $('#'+inputid).val(text+sel);
                            $(this).parent().parent().parent().hide();
                            $('#'+inputid).focus();
                            $('#myllllldiv').empty();
                            detid=$(this).parent().attr("id");
                        });
                        if (e.keyCode=="13")
                        {
                            var text =  $('#'+inputid).val().replaceAll(sub,"").trim();
                            var sel = $("#myllllldiv li a:eq("+cursor+")").parent().text();
                            $('#'+inputid).val(text+sel);
                            $("#myllllldiv li a:eq("+cursor+")").parent().parent().parent().hide();
                            $('#'+inputid).focus();
                            detid=$("#myllllldiv li a:eq("+cursor+")").parent().attr("id");
                            $('#myllllldiv').empty();
                            cursor=0
                        }
                    }
                }
            }
        }
        else
        {
            if ((termid=="")||(catid=="")||(detid==""))
            {
                return;
            }
            var pre = "";
            for (var i=0;i<index;i++)
            {
                pre += $(this).val().split(";")[i]+";"
            }
            var val=$(this).val().split(";")[index]



            if (e.keyCode==32)
            {
                if ($(this).val().split(";")[index]==" ")
                {
                    $(this).val(pre+"属性=")
                }
                else if (($(this).val().split(";")[index].indexOf("属性=")!=-1)&&($(this).val().split(";")[index].indexOf("内容=") == -1))
                {
                    if($(this).val().split(";")[index].substring($(this).val().split(";")[index].indexOf("属性=")+3).trim()=="")
                    {
                        return;
                    }
                    $(this).val($(this).val()+",内容=");
                }
            }
            if ((e.keyCode!=38)&&(e.keyCode!=40))
            {
                var input = $(this).val().split(";")[index];
                if (input.indexOf("属性=")==-1)
                {
                    $("#myllllldiv").empty();
                    $("#myllllldiv").hide();
                }
                if (input.indexOf("属性=")!=-1&&input.indexOf("内容=")==-1)
                {

                    if (input.length-input.replace("=","").length>1)
                    {
                        $("#myllllldiv").empty();
                        $("#myllllldiv").hide();
                    }
                    else
                    {

                        var start=input.indexOf("属性=")+3
                        var sub=input.substring(start).trim().replaceAll("'","")
                        var data=tkMakeServerCall(ClassName,"GetPro",termid,sub)

//                        alert(data)
                        $('#myllllldiv').empty();
                        $("#myllllldiv").append(data)
                        $('#myllllldiv').show();
                        $("#myllllldiv li a").first().css("background","#d3d4cc")
                        $("#myllllldiv li a").click(function(){
                            var text =  $('#'+inputid).val().split(";")[index].replace(sub,"").trim();
                            var sel = $(this).parent().text();
                            $('#'+inputid).val(pre+text+sel);
                            $(this).parent().parent().parent().hide();
                            $('#'+inputid).focus();
                            $('#myllllldiv').empty();
                            catid = $(this).parent().attr("id");
                        });
                        if (e.keyCode=="13")
                        {
                            var text =  $('#'+inputid).val().split(";")[index].replace(sub,"").trim();
                            var sel = $("#myllllldiv li a:eq("+cursor+")").parent().text();
                            $('#'+inputid).val(pre+text+sel);
                            $("#myllllldiv li a:eq("+cursor+")").parent().parent().parent().hide();
                            $('#'+inputid).focus();
                            catid =$("#myllllldiv li a:eq("+cursor+")").parent().attr("id");
                            $('#myllllldiv').empty();
                            cursor=0
                        }
                    }
                }
                else if(input.indexOf("属性=")!=-1&&input.indexOf("内容")!=-1)
                {
                    var input=input.substring(input.lastIndexOf(",")).trim()
                    if (input.length-input.replace("=","").length>1)
                    {
                        $("#myllllldiv").empty();
                        $("#myllllldiv").hide();
                    }
                    else
                    {
                        if (e.keyCode==229) {
                            var start = input.indexOf("内容=") + 3;
                            var sub = input.substring(start).trim();
                            if ((sub == "") || (detid == "")) {
                                return;
                            }
                        }
                        var sub="";
                        var start="";
                        if (input.indexOf("、")!=-1)
                        {
                            start = input.lastIndexOf("、")+1;
                        }
                        else
                        {
                            start=input.indexOf("内容=")+3;
                        }
                        sub = input.substring(start).trim().replaceAll("'","");
                        var data=tkMakeServerCall(ClassName,"GetDetail",catid ,sub);
                        $('#myllllldiv').empty();
                        $("#myllllldiv").append(data);
                        $('#myllllldiv').show();
                        $("#myllllldiv li a").first().css("background","#d3d4cc");
                        $("#myllllldiv li a").click(function(){
                            var text =  $('#'+inputid).val().replace(sub,"").trim();
                            var sel = $(this).parent().text();
                            $('#'+inputid).val(text+sel);
                            $(this).parent().parent().parent().hide();
                            $('#'+inputid).focus();
                            $('#myllllldiv').empty();
                            detid=$(this).parent().attr("id");
                        });
                        if (e.keyCode=="13")
                        {
                            var text =  $('#'+inputid).val().replace(sub,"").trim();
                            var sel = $("#myllllldiv li a:eq("+cursor+")").parent().text();
                            $('#'+inputid).val(text+sel);
                            $("#myllllldiv li a:eq("+cursor+")").parent().parent().parent().hide();
                            $('#'+inputid).focus();
                            detid=$("#myllllldiv li a:eq("+cursor+")").parent().attr("id");
                            $('#myllllldiv').empty();
                            cursor=0
                        }
                    }
                }
            }
        }
    });
}
//function licss()
//{
//    console.log($(".mylllllli a"));
//    //$(".mylllllli").css("list-style:none");
//    $(".mylllllli a").css("width:500px;height:45px;display:block;background:'red'");
//    $(".mylllllli a:hover").css("background:#d3d4cc");
//
//}