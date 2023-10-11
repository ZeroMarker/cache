
    document.write('<script type="text/javascript" src="../scripts/bdp/CDSS/Public/DHCBDPTriggerCDSS.js"></script>');
    if(1)
    {
        document.write('<link rel="stylesheet" type="text/css" href="../scripts/bdp/CDSS/style/css/cdssStyle.css"/>');
        //插入医为百科的浏览弹框
        $('body').append('<div id="encyclopedia_win"><div id="encyclopedia_lay"></div><img id="FeedBackImg" onclick="openFeedBack()" style="position:absolute;top:24px;left:100px;width:60px;height:60px" src="../scripts/bdp/framework/imgs/feedback.png"></div>');
        $HUI.window("#encyclopedia_win", {
            //iconCls:'icon-w-add',
            resizable: true,
            minimizable: false,
            title: 'iMedical-CDSS 东华医为临床辅助决策支持',
            width: $(window).width() * 9.5 / 10,
            height: $(window).height() * 9.5 / 10,
            modal: false,
        });
        $('#encyclopedia_lay').layout({
            border: false,
            fit: true
        });
        $('#encyclopedia_lay').layout('add', {
            region: 'center',
            collapsible: true,
            split: false,
            border: true,
            title: '医为百科',//../csp/dhc.bdp.cdss.literature.csp?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p&fileName='盆腔炎症性疾病诊治规范(2019修订版).pdf'
            content: '<div id="div-img-s" style="width:100%;height:8%;text-align:center"><img src="../scripts/bdp/Framework/icons/mkb/noselect-warn.png" alt="没有数据哦，重新输入试试吧" style=""/></div><iframe id="encyclopedia_iframe" frameborder="0" src="" width="100%" height="99%" ></iframe>',
            bodyCls: 'panel-header-gray',
            headerCls: 'panel-header-gray',
            id: 'encyclopedia_center'
        });
        $("#encyclopedia_win").window('close');
        openFeedBack = function(){
            /*$("#encyclopedia_win").window('close');
            $("#feedback_win").css('display','block')*/
            $HUI.window("#encyclopedia_win", {
            //iconCls:'icon-w-add',
            resizable: true,
            /*minimizable: false,
            title: 'iMedical-CDSS 东华医为临床辅助决策支持',*/
            width: 1000,
            left: ($(window).width()-1000)/2
            //height: $(window).height() * 9.5 / 10,
            //modal: false,
        });
            var url = '../csp/dhc.bdp.cdss.feedback.csp?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p'
            var temp = $('#encyclopedia_lay').layout('panel','center');
            temp.panel('setTitle','意见反馈') 
            $('#div-img-s').hide();
            $("#encyclopedia_win").window('open');
            $('#encyclopedia_iframe').css({ 'display': 'block' }) 
            $('#encyclopedia_iframe').attr("src", url);
        }
        goBaiKe =function (url) {
            $HUI.window("#encyclopedia_win", {
                resizable: true,
                width: $(window).width() * 9.5 / 10,  
                left: $(window).width() * 0.5 / 10 / 2
            })
            var temp = $('#encyclopedia_lay').layout('panel','center');
            temp.panel('setTitle','医为百科')
            $('#div-img-s').hide();
            $("#encyclopedia_win").window('open');
            $('#encyclopedia_iframe').css({ 'display': 'block' }) 
            $('#encyclopedia_iframe').attr("src", url);   
        }
        goLite= function (url) {
            $HUI.window("#encyclopedia_win", {
                resizable: true,
                width: $(window).width() * 9.5 / 10,  
                left: $(window).width() * 0.5 / 10 / 2
            })
            var temp = $('#encyclopedia_lay').layout('panel','center');
            temp.panel('setTitle','医为文献')
            $('#div-img-s').hide();
            $("#encyclopedia_win").window('open');
            $('#encyclopedia_iframe').css({ 'display': 'block' }) 
            $('#encyclopedia_iframe').attr("src", url); 
        }
        goRatingScale= function (url) {
            $HUI.window("#encyclopedia_win", {
                resizable: true,
                width: $(window).width() * 9.5 / 10,  
                left: $(window).width() * 0.5 / 10 / 2
            })
            var temp = $('#encyclopedia_lay').layout('panel','center');
            temp.panel('setTitle','医为评估表')
            $('#div-img-s').hide();
            $("#encyclopedia_win").window('open');
            $('#encyclopedia_iframe').css({ 'display': 'block' }) 
            $('#encyclopedia_iframe').attr("src", url); 
        }
        
        //$('body').append('<div id="cdssContainer" draggable="true"> <iframe ref="iframe" align="center" id="htmlContainer" src="http://192.178.102.24:9090"  frameborder="no" border="0" marginwidth="0" marginheight="0" scrolling="no"></iframe></div>')
        $('body').append('<div id="cdssContainer"> <iframe ref="iframe" align="center" id="htmlContainer" src="../scripts/bdp/CDSSVue/dist/index.html"  frameborder="no" border="0" marginwidth="0" marginheight="0" scrolling="no"></iframe></div>')
        $('#cdssContainer').css({
            position:'absolute',
            bottom:'30px',
            right:'10px',
            height:'50px',
            width:'50px',
            'z-index':'9002',
             'background-color':'rgba(255,255,255,0)'
        });
         $('#htmlContainer').css({
            width: '100%',
            height:'100%',
            'background-color':'rgba(255,255,255,0)'
        })
        /*$('#cdssContainer').draggable({
            handle:'#htmlContainer'    
        })*/
        //$('#cdssContainer').draggable()
        window.addEventListener('message',function(event){
            if (event.data == "openParentWindow")
            {
                $("#cdssContainer").css('width','1450px')
                return
            } else if (event.data == "closeParentWindow")
            {
                $("#cdssContainer").css('width','360px')
                return
            } else if (event.data == "hiddenCDSS")
            {
               $("#cdssContainer").css('width','50px')
               $("#cdssContainer").css('height','50px')
                return
            } else if (event.data == "showCDSS")
            {
                $("#cdssContainer").css('width','360px')
                $("#cdssContainer").css('height','700px')
                return
            }else if (event.data == "enlargeMenu")
            {
                $("#cdssContainer").css('width','420px')
                $("#cdssContainer").css('height','700px')
                return
            }else if (event.data == "shrinkMenu")
            {
                $("#cdssContainer").css('width','360px')
                $("#cdssContainer").css('height','700px')
                return
            }else if (event.data == "enlargeImg")
            {
                $("#cdssContainer").css('width','50px')
                $("#cdssContainer").css('height','50px')  
            }else if (event.data == "shrinkImg")
            {
                if ($("#cdssContainer").height() == 50)
                {
                    $("#cdssContainer").css('width','25px')
                    $("#cdssContainer").css('height','50px')
                }
            }else if (event.data.action == "WriteToEmr")
            {
                //写回方法
                var hos = window.document.getElementById('idhc_side_emr_cate3');//住院入院记录病历iframe
                var out = window.document.getElementById('iemr.opdoc.main.csp?PatientID=@patientID');//门诊病历iframe
                var hos2 = window.document.getElementById('idhc_side_emr_cate4')//住院病程
                if (hos||hos2) {
                    hos.contentWindow.receive(event.data.data);//调用病例组前台方法
                } else if (out) {
                    var selectClass = document.getElementsByClassName('sel-li-a')
                    var selectText = $(selectClass[0]).text();
                    if (selectText == '门诊病历') {//判断是否选中了门诊病历页签
                        out.contentWindow.receive(event.data.data);
                    } else { 
                        parent.$.messager.alert('操作提示', "请手动切换到病历界面再进行写回操作", "error");
                    }
                    
                } else { 
                    parent.$.messager.alert('操作提示', "请手动切换到病历界面再进行写回操作", "error");
                }
            } else if (event.data.action == "OpenOrderToHis")
            { 
                //开立医嘱
                var DataInfo = "web.CDSS.IMP.InterDictMapping[A]GetMatchCode[A]"+event.data.data; //获取对照的his编码
                var str = CDSSMakeServerCall(DataInfo);
               CopyDataForCDSS('ORDER', [str+"!!"+String.fromCharCode(1)+String.fromCharCode(1)+"^"+String.fromCharCode(1)+String.fromCharCode(1)+String.fromCharCode(1)+"^"+String.fromCharCode(1)+"^"+String.fromCharCode(1)+String.fromCharCode(1)+"^"+String.fromCharCode(1)+String.fromCharCode(1)+"^"+"临时医嘱"+String.fromCharCode(1)+"^^^^^^^^^^"+String.fromCharCode(1)+"^^^^^!!!Order"])
            } else if (event.data.action == "OpenDiagToHis")
            {
                //开立诊断
                var DataInfo = "web.CDSS.IMP.InterDictMapping[A]GetMatchCode[A]" + event.data.data;//获取对照的his编码
                var str = CDSSMakeServerCall(DataInfo);
                CopyDataForCDSS('DIAG', [{ 'ICDCode':str,'ICDRowid': '', 'Note': '', 'CMFlag': 'N' }])//调用医生站开立前台方法
            } else if (event.data.action == "showBaiKe")
            {
                goBaiKe(event.data.data)
            } else if (event.data.action == "showLite")
            {
                goLite(event.data.data)
            } else if (event.data.action == "showRatingScale")
            {
                goRatingScale(event.data.data)
            } else if (event.data.action == "showContextSearch")
            {
                SearchFunLibNew(event.data.data)
            }        
        })
        DriverCDSS = function(PatientInfo){
            var Info ={'action':'INITIALIZE_PATIENT_INFORMATION','data':PatientInfo}
            //document.getElementById("htmlContainer").contentWindow.postMessage(Info, 'http://192.178.102.24:9090/#/')
            document.getElementById("htmlContainer").contentWindow.postMessage(Info,'http://192.144.152.252/imedical/web/scripts/bdp/CDSSVue/dist/index.html')
        }
        /*closeRatingScale = function () {
            document.getElementById("htmlContainer").contentWindow.postMessage(Info,'http://192.178.102.24/imedical/web/scripts/bdp/CDSSVue/dist/index.html')
        }*/
        
          /***************************************全文检索*************************************************** */
     /***************************************全文检索*************************************************** */
    var num = ""
    var totalPage = ""

     goPage = function(current) {
        if (!isNaN(current)) {
            $('body #ency_lay_center').animate({ scrollTop: 0 }, 'fast');
            $('#pagenation').remove();
            var pagestr = "<ul id='pagenation'>";
            pagestr += "<li><a style='width:50px' id='pre'>上一页</a></li>";
            var total = num;
            var psize = 5;
            current = parseInt(current);

            var start = current * 5 - 4
            var end = current * 5
            if (current * 5 > total) {
                end = total
            }

            //var result = tkMakeServerCall("web.DHCBL.MKB.MKBContextSearch","SearchContext",start,end)
            var DataInfo = "web.DHCBL.MKB.MKBContextSearch[A]SearchContext[A]" + start + "[A]" + end + "[A]" + session['LOGON.USERID'];
            var result = CDSSMakeServerCall(DataInfo);
            $("#ency_lay_center").empty()
            $("#ency_lay_center").append(result)
            for (var k = start; k <= end; k++) {
                if ($("#tip" + k).height() < 169) {
                    $("#btn" + k).hide();
                }
            }
            if (totalPage < 7) {
                for (var i = 1; i <= totalPage; i++) {
                    pagestr += "<li><a style='width:20px' id=a" + i + ">" + i + "</a></li>";
                }
                pagestr += "<li><a style='width:50px' id='next'>下一页</a></li>";
            }
            else {
                if (current <= 4) {
                    for (var i = 1; i <= 7; i++) {
                        pagestr += "<li><a style='width:20px' id=a" + i + ">" + i + "</a></li>";
                    }
                    pagestr += "<li><a style='width:50px' id='next'>下一页</a></li>";
                }
                else {
                    start = current - 3;
                    if (start <= 0) {
                        start = 1
                    }
                    if (current + 4 <= totalPage) {
                        end = current + 4;
                        for (var i = start; i < end; i++) {
                            pagestr += "<li><a style='width:20px' id=a" + i + ">" + i + "</a></li>";
                        }
                    }
                    else {
                        end = totalPage;
                        for (var i = start; i <= end; i++) {
                            pagestr += "<li><a style='width:20px' id=a" + i + ">" + i + "</a></li>";
                        }
                    }
                    pagestr += "<li><a style='width:50px' id='next'>下一页</a></li>";
                }
            }


            pagestr += "</ul>";
            if (totalPage != 0) {
                $('#footer').append(pagestr);
            }

            $("#a" + current).css({ "background-color": "#6699CC", "color": "#fdfdfd", "border": "solid 1px #1d1f20" });
            $("li a").click(function () {
                if ($(this).attr("id").indexOf("a") != -1) {
                    goPage($(this).attr("id").substring(1));
                }
                else if ($(this).attr("id") == "pre") {
                    if (current == 1) {
                        //$("#pre").attr("href","javascript:return false;");
                        $(this).onclick = function () { return false; }
                    }
                    else {
                        // $("#pre").attr("onclick","goPage("+(current-1)+")")
                        $(this).onclick = goPage(current - 1)
                    }
                }
                else if ($(this).attr("id") == "next") {
                    if (current == totalPage) {
                        $(this).onclick = function () { return false; }
                    }
                    else {
                        $(this).onclick = goPage(current + 1)
                    }
                }
            })

        }
    };
    goTerm = function(MKBTBCode, MKBTBDesc, TermID, ProId, DetId) {
        $('#div-img-ss').hide();
        $('#encyclopedia_iframe').css({ 'display': 'block' })

        var url = "../csp/dhc.bdp.cdss.cdssencyclopedia.csp?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p&base=&id=" + TermID + "&proid=" + ProId;
        $('#encyclopedia_newiframe').attr("src", url);
    }

    //搜索功能
    SearchFunLibNew = function (searchText) {
        $("#encyDesc_win").val(searchText);
        $("#encyclopedia_newwin").window('open');
        var ids = '';
        $('.choosed').each(function () {
            if ($(this).attr('id') == 'diag') {
                id = 120;
            } else if ($(this).attr('id') == 'syms') {
                id = 121
            } else if ($(this).attr('id') == 'check') {
                id = 122
            } else if ($(this).attr('id') == 'oper') {
                id = 123
            } else if ($(this).attr('id') == 'exam') {
                id = 126
            }

            if (ids == '') {
                ids = id
            } else {
                ids = ids + ',' + id;
            }

        });
        //num =tkMakeServerCall("web.DHCBL.MKB.MKBContextSearch", "ContextData",$('#search_td .searchbox-text').val(),ids);
        var DataInfo = "web.DHCBL.MKB.MKBContextSearch[A]ContextData[A]" + searchText + "[A]" + ids + "[A]" + session['LOGON.USERID'];
        num = CDSSMakeServerCall(DataInfo);
        loadSearchNum(num);
        showFirst(searchText);
    }
    //搜索功能
    SearchFunLib = function () {
        $('#encyclopedia_west .searchbox-text').val($("#cdss_iframe").contents().find('#search_td .searchbox-text').val())
        $("#encyclopedia_newwin").window('open');
        var ids = '';
        $('.choosed').each(function () {
            if ($(this).attr('id') == 'diag') {
                id = 120;
            } else if ($(this).attr('id') == 'syms') {
                id = 121
            } else if ($(this).attr('id') == 'check') {
                id = 122
            } else if ($(this).attr('id') == 'oper') {
                id = 123
            } else if ($(this).attr('id') == 'exam') {
                id = 126
            }

            if (ids == '') {
                ids = id
            } else {
                ids = ids + ',' + id;
            }

        });
        //num =tkMakeServerCall("web.DHCBL.MKB.MKBContextSearch", "ContextData",$('#search_td .searchbox-text').val(),ids);
        var DataInfo = "web.DHCBL.MKB.MKBContextSearch[A]ContextData[A]" + $("#cdss_iframe").contents().find('#search_td .searchbox-text').val() + "[A]" + ids + "[A]" + session['LOGON.USERID'];
        num = CDSSMakeServerCall(DataInfo);
        loadSearchNum(num);
        showFirst($("#cdss_iframe").contents().find('#search_td .searchbox-text').val());
    }
    loadSearchNum = function (data) {
        $('#div-img-ss').show();
        $('#encyclopedia_newiframe').css({ 'display': 'none' })

        num = data;
        if (data == "error" || data == 0) {
            $("#ency_lay_center").empty()
            $('#search_num').empty()

            $("#ency_lay_center").html('<div id="div-img" style="width:100%;height:8%;text-align:center"><img src="../scripts/bdp/Framework/icons/mkb/contextnodatatip.png" alt="没有数据哦，重新输入试试吧" style=""/></div>');
            $('#footer').empty()
            return;
        }
        var data = parseInt(data)
        if (data / 5 > parseInt(data / 5)) {
            totalPage = parseInt(data / 5) + 1;
        }
        else {
            totalPage = parseInt(data / 5);
        }
        $("#search_num").empty()
        $("#search_num").append("<span style='color:gray'>为您找到相关结果" + data + "个,共" + totalPage + "页。</span>")
        goPage(1);
        $('#ency_lay').layout('resize')

    }
    //插入医为百科的浏览弹框
    $('body').append('<div id="encyclopedia_newwin"><div id="encyclopedia_newlay"></div></div>');
    $HUI.window("#encyclopedia_newwin", {
        //iconCls:'icon-w-add',
        resizable: true,
        minimizable: false,
        title: '知识库浏览',
        width: $(window).width() * 9.9 / 10,
        height: $(window).height() * 9.9 / 10,
        modal: false
    });
    $('#encyclopedia_newlay').layout({
        border: false,
        fit: true
    });
    $('#encyclopedia_newlay').layout('add', {
        region: 'center',
        collapsible: true,
        split: false,
        border: true,
        title: '医为百科',
        content: '<div id="div-img-ss" style="width:100%;height:8%;text-align:center"><img src="../scripts/bdp/Framework/icons/mkb/noselect-warn.png" alt="没有数据哦，重新输入试试吧" style=""/></div><iframe id="encyclopedia_newiframe" frameborder="0" src="" width="100%" height="99%" ></iframe>',
        bodyCls: 'panel-header-gray',
        headerCls: 'panel-header-gray',
        id: 'encyclopedia_center'
    });


    $('#encyclopedia_newlay').layout('add', {
        region: 'west',
        split: false,
        collapsible: false,
        border: true,
        width: 400,
        title: '查询结果',
        bodyCls: 'panel-header-gray',
        headerCls: 'panel-header-gray',
        id: 'encyclopedia_west'
    });
    $('#encyclopedia_west').append(
        '<div id="ency_lay"></div>'
    );
    //左侧再插入布局样式
    $('#ency_lay').layout({
        border: false,
        fit: true
    });
    $('#ency_lay').layout('add', {
        region: 'center',
        collapsible: true,
        split: false,
        border: false,
        bodyCls: 'panel-header-gray',
        headerCls: 'panel-header-gray',
        id: 'ency_lay_center'
    });
    $('#ency_lay_center').css({
        'margin-left': '10px'
    })
    $('#ency_lay').layout('add', {
        region: 'north',
        split: false,
        border: false,
        height: 110,
        bodyCls: 'panel-header-gray',
        headerCls: 'panel-header-gray',
        id: 'ency_lay_north'
    });
    $('#ency_lay_north').append(
        '<div id="encyDesc_div" style="width:99%;height:30px;text-align:center;margin-top:5px;">' +
        '<input style="width:365px" placeholder="百科" id="encyDesc_win" />' +
        '</div>' +
        '<div style="width:365px;height:20px;text-align:center;margin-top:5px;">' +
        '<table  style="width:80%;margin-left:40px;" >' +
        '<tr >' +
        '<td id="diag" class="choosed" style="cursor:pointer;"><div style="float:left;margin-left:5px"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/virus.png"></div><div style="float:left;margin-left:15px"><font>疾病</font></div></td>' +
        '<td id="syms" class="choosed" style="cursor:pointer;"><div style="float:left;margin-left:5px"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/face_red.png"></div><div style="float:left;margin-left:10px"><font>症状</font></div></td>' +
        '<td id="check" class="choosed" style="cursor:pointer;"><div style="float:left;margin-left:5px"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/stethoscope.png"></div><div style="float:left;margin-left:10px"><font>检查</font></div></td>' +
        '<td id="oper" class="choosed" style="cursor:pointer;"><div style="float:left;margin-left:5px"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/paper_opr_record.png"></div><div style="float:left;margin-left:10px"><font>手术</font></div></td>' +
        '<td id="exam" class="choosed" style="cursor:pointer;"><div style="float:left;margin-left:5px"><img src="../scripts_lib/hisui-0.1.0/dist/css/icons/stethoscope.png"></div><div style="float:left;margin-left:10px"><font>检验</font></div></td>' +
        '</tr>' +
        /*'<tr>' +
            '<td id="diag_num" style="text-align:left;margin-right:10px"><font style="font-size:1px;" color=#ff8519>1223222</font></td>' +
            '<td id="syms_num" style="text-align:left"><font style="font-size:1px"  color=#ff8519>12232222</font></td>' +
            '<td id="check_num" style="text-align:left"><font style="font-size:1px"  color=#ff8519>12232222</font></td>' +
            '<td id="oper_num" style="text-align:left"><font style="font-size:1px"  color=#ff8519>12232222</font></td>'+
        '</tr>' +*/
        '<tr><td id="search_num" colspan=4></td></tr>' +
        '</table>' +
        '</div>'
    );
    $('#ency_lay').layout('add', {
        region: 'south',
        split: false,
        border: false,
        height: 35,
        content: '<div id="footer" style="text-align:center"></div>',
        id: 'ency_lay_south'
    });

    $('#diag,#syms,#check,#oper,#exam').click(function () {
        if ($(this).attr('class') == 'unchoose') {
            $(this).css({
                'background-color': '#cccccc',
                'border-radius': '5px'
            });


            $(this).attr('class', 'choosed');
        } else {
            $(this).css({
                'background-color': 'white'
            });
            $(this).attr('class', 'unchoose');
        }
    });
    $('#encyDesc_win').searchbox({
    });
    $('#encyDesc_div .searchbox-text').attr('placeholder', '百科')
    $('#encyDesc_div .searchbox-button').click(function () {
        var ids = '';
        $('.choosed').each(function () {
            if ($(this).attr('id') == 'diag') {
                id = 120;
            } else if ($(this).attr('id') == 'syms') {
                id = 121
            } else if ($(this).attr('id') == 'check') {
                id = 122
            } else if ($(this).attr('id') == 'oper') {
                id = 123
            } else if ($(this).attr('id') == 'exam') {
                id = 126
            }

            if (ids == '') {
                ids = id
            } else {
                ids = ids + ',' + id;
            }

        });

        //num =tkMakeServerCall("web.DHCBL.MKB.MKBContextSearch", "ContextData",$('#encyDesc_div .searchbox-text').val(),ids);
        var DataInfo = "web.DHCBL.MKB.MKBContextSearch[A]ContextData[A]" + $('#encyDesc_div .searchbox-text').val() + "[A]" + ids + "[A]" + session['LOGON.USERID'];
        var num = CDSSMakeServerCall(DataInfo);

        loadSearchNum(num);
        showFirst($('#encyDesc_div .searchbox-text').val());
    })


    //搜索回车事件
    $('#encyDesc_div .searchbox-text').keyup(function (event) {
        if (event.keyCode == 13) {
            var ids = '';
            $('.choosed').each(function () {
                if ($(this).attr('id') == 'diag') {
                    id = 120;
                } else if ($(this).attr('id') == 'syms') {
                    id = 121
                } else if ($(this).attr('id') == 'check') {
                    id = 122
                } else if ($(this).attr('id') == 'oper') {
                    id = 123
                } else if ($(this).attr('id') == 'exam') {
                    id = 126
                }

                if (ids == '') {
                    ids = id
                } else {
                    ids = ids + ',' + id;
                }

            });

            //num =tkMakeServerCall("web.DHCBL.MKB.MKBContextSearch", "ContextData",$('#encyDesc_div .searchbox-text').val(),ids);
            var DataInfo = "web.DHCBL.MKB.MKBContextSearch[A]ContextData[A]" + $('#encyDesc_div .searchbox-text').val() + "[A]" + ids + "[A]" + session['LOGON.USERID'];
            var num = CDSSMakeServerCall(DataInfo);
            loadSearchNum(num);
            showFirst($('#encyDesc_div .searchbox-text').val());
        }
    });

    $("#encyclopedia_newwin").window('close');//关闭window


    //一开始就默认选中，在左下角默认查询所有
    $('#diag,#syms,#check,#oper,#exam').css({
        'background-color': '#cccccc',
        'border-radius': '5px',
        'text-align': 'center'
    })
    /*$('#diag_num,#syms_num,#check_num,#oper_num').css({
        'background-color': '#cccccc',
        'border-radius': '0 0 5px 5px'      
    })*/

    /**
     * 搜索完毕，默认展示匹配项
     */
    showFirst = function(diseasename) {

        var DescInfo = "web.CDSS.CMKB.WikiCMKBContrast[A]getWikiName[A]" + diseasename;
        var desc = CDSSMakeServerCall(DescInfo);
        if (desc.indexOf("\r\n") > -1) {
            desc = desc.replace(/\s+/g, "").replace(/<\/?.+?>/g, "").replace(/[\r\n]/g, "");
        }
        var termdr = ""
        if (desc != "") {
            diseasename = desc;
        }

        var DataInfo = "web.DHCBL.MKB.MKBTerm[A]getTermIDByDesc[A]疾病[A]" + diseasename;
        termdr = CDSSMakeServerCall(DataInfo);
        if (termdr == "") {
            var DataInfo = "web.DHCBL.MKB.MKBTerm[A]getTermIDByDesc[A]检查[A]" + diseasename;
            termdr = CDSSMakeServerCall(DataInfo);
            if (termdr == "") {
                var DataInfo = "web.DHCBL.MKB.MKBTerm[A]getTermIDByDesc[A]检验[A]" + diseasename;
                termdr = CDSSMakeServerCall(DataInfo);
            }
        }


        if (termdr) {
            $('#div-img-ss').hide();
            $('#encyclopedia_newiframe').css({ 'display': 'block' })

            var url = "../csp/dhc.bdp.cdss.cdssencyclopedia.csp?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p&base=&id=" + termdr + "&proid=";
            $('#encyclopedia_newiframe').attr("src", url);
        }

    }


        
              
        window.DriverCDSS = DriverCDSS
        
 
    }
