$(function () {

    /*/**
         * @Author 范文凯
         * @desc 封装跨域调用CDSS后台M方法类
         * @Last Modified by:   范文凯
         * @Last Modified time: 
         */
    /*function CDSSMakeServerCall(DataInfo) {
        var flag = false;
        var returnInfo = "";
        $.ajax({
            url: "http://192.178.102.24/imedical/web/csp/dhc.bdp.cdss.postservice.csp?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p",
            //url:"..[表情]p/dhc.bdp.cdss.postservice.csp?CacheNoRedirect=1&CacheUserName=dhsyslogin&CachePassword=1q2w3e4r%T6y7u8i9o0p",//腾讯云用
            type: "post",
            data: {
                "jsonInfo": DataInfo
            },
            async: false,
            success: function (data) {
                console.log(typeof (data));
                returnInfo = data;
                flag = true
            },
            error: function () {
                //alert(2);
                returnInfo = "false"
            }
        });
        if (flag) {
            return returnInfo.replace(/[\r\n]/g, "");
        }
    }*/
    function CDSSMakeServerCall(DataInfo) {
        var flag = false;
        var returnInfo = "";
        var str = DataInfo.replace(/\"/g, '""')
        returnInfo = tkMakeServerCall("web.CDSS.Public.MethodForWebservice", "CallMethod", str)

        //if(returnInfo)
        //{
        return returnInfo
        //}
    }

    //获得总分
    getTheCheckBoxValue = function () {
        var checkBoxValue = 0;
        var checkbox = $("#layoutcenter input:checked");
        var selectbox = $(".allcontent .combo-value");
        selectbox.each(function () {
            if (!isNaN($(this).val())) {
                checkBoxValue = (checkBoxValue - 0) + ($(this).val().split("_")[1] - 0) * 10; //乘以10后面再除以10  解决js计算小数时丢失精度
            }
        })
        checkbox.each(function () {
            checkBoxValue = (checkBoxValue - 0) + ($(this).val().split("_")[1] - 0) * 10; //减0 转换成number类型
        })
        $("#allscore").text(checkBoxValue / 10);

        //测试把tk改为CDSSMakeServerCall
        //DataInfo = "web.DHCBL.MKB.MKBAssessment[A]GetDescByIdScore[A]" + id + "[A]" + checkBoxValue / 10;
        //var rankHtml = CDSSMakeServerCall(DataInfo);

        var rankHtml = $.m({
            ClassName: 'web.DHCBL.MKB.MKBAssessment',
            MethodName: 'GetDescByIdScore',
            id: id,
            score: checkBoxValue / 10
        }, false);
        $("#grade").text(rankHtml.split("[DANDS]")[1]);
        $("#result").text(rankHtml.split("[DANDS]")[0]);
        /*fwkadd 计算结果之后 去执行保存评估表的方法
        var result= rankHtml.split("[DANDS]")[0];
        var score = checkBoxValue/10;*/
    }
    //省立 患者入住ICU的主要疾病分值(单选框) 只能有一个选项
    ClearOtherOption = function(e,value) {
        if (value==true)
        {
            var checkbox = $("#layoutcenter input:checked");
            checkbox.each(function() {
                if (e.target.id!==$(this).attr("id"))
                {
                    $(this).radio("setValue", false);
                }  
            })
            
        }
        var checkBoxValue = 0;
        var checkbox1 = $("#layoutcenter input:checked");
        checkbox1.each(function() {
            checkBoxValue = (checkBoxValue - 0) + ($(this).val().split("_")[1] - 0) * 10; //减0 转换成number类型
        })
        $("#allscore").text(checkBoxValue / 10);
        //DataInfo = "web.DHCBL.MKB.MKBAssessment[A]GetDescByIdScore[A]" + id + "[A]" + checkBoxValue / 10;
        //var rankHtml = CDSSMakeServerCall(DataInfo);
		var rankHtml = $.m({
		    ClassName: 'web.DHCBL.MKB.MKBAssessment',
		    MethodName: 'GetDescByIdScore',
		    id: id,
		    score: checkBoxValue / 10
		}, false);
        $("#grade").text(rankHtml.split("[DANDS]")[1]);
        $("#result").text(rankHtml.split("[DANDS]")[0]);   
    }
	//Oswestry功能障碍指数问卷表（ODI） 单独计算方式
    OswestryScore = function() {
        //Oswestry功能障碍指数问卷表（ODI）只有单选框
        var checkBoxValue = 0;
        var checkbox = $("#layoutcenter input:checked");
        var checkboxnum=0
        checkbox.each(function() {
            checkBoxValue = (checkBoxValue - 0) + ($(this).val().split("_")[1] - 0) ; //减0 转换成number类型
            checkboxnum=checkboxnum+1
        })
        //获得它一共有几个评估项
        //var RatingNum = document.getElementById( "layoutcenter" ).getElementsByTagName( "h3" ).length
        if (checkboxnum!==0)
        {
            var value = Number((checkBoxValue / 5)/checkboxnum* 100 ).toFixed(1);
            value+="%";
            $("#allscore").text(value);

        }
        else
        {
            $("#allscore").text(0)  
        }
        //DataInfo = "web.DHCBL.MKB.MKBAssessment[A]GetDescByIdScore[A]" + id + "[A]" + checkBoxValue / 10;
        //var rankHtml = CDSSMakeServerCall(DataInfo);
		var rankHtml = $.m({
		    ClassName: 'web.DHCBL.MKB.MKBAssessment',
		    MethodName: 'GetDescByIdScore',
		    id: id,
		    score: checkBoxValue / 10
		}, false);
        $("#grade").text(rankHtml.split("[DANDS]")[1]);
        $("#result").text(rankHtml.split("[DANDS]")[0]);
       // PatientMortality(checkBoxValue);
    }
    var sdflag = GetURLParams("sdflag"); //区分是否是由结构化诊断进入此页面
    var id = GetURLParams("id");
    var editflag = GetURLParams("editflag");
    var PatientUserInfo = GetURLParams("PatientUserInfo");
    if (sdflag == null) sdflag = "";
    if (sdflag == "") { //不是结构化诊断进入 则动态添加左侧列表和检索框
        $("#layoutcenter").html('<div id="div-img" style="width:100%;height:300px;text-align:center;vertical-align: middle;"><img src="../scripts/bdp/Framework/icons/mkb/noselect-warn.png" alt="没有数据哦，选条数据看看吧" style="margin:100px 0" /></div>');
        $(".assessfoot").css("left", "300px");
        $("#hisuilayout").layout('add', {
            id: "layoutwest",
            region: 'west',
            split: true,
            border: false,
            width: 350
        })
        var tablehtml = '<table data-options="fit:true,iconCls:' + "'icon-w-paper'" + '"  id="leftgrid" border="true" title="评估表"></table>'
        //alert(tablehtml)
        $("#layoutwest").append(tablehtml);
        var basecolumns = [
            [{
                field: 'MKBABRowId',
                title: 'RowId',
                width: 100,
                hidden: true,
                sortable: true
            }, {
                field: 'MKBABCode',
                title: '代码',
                width: 100,
                sortable: true,
                hidden: true
            }, {
                field: 'MKBABDesc',
                title: '标题',
                width: 100,
                sortable: true
            }, {
                field: 'MKBABNote',
                title: '备注',
                width: 100,
                sortable: true,
                hidden: true
            }]
        ];
        // 左侧列表
        $('#leftgrid').datagrid({
            url: $URL,
            queryParams: {
                ClassName: "web.DHCBL.MKB.MKBAssessmentBase",
                QueryName: "GetList"
            },
            autoRowHeight: true,
            columns: basecolumns, //列信息
            pagination: true, //pagination   boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
            pageSize: 15,
            pageList: [5, 10, 15, 20, 25, 30, 50, 75, 100, 200, 300, 500, 1000],
            singleSelect: true,
            remoteSort: false,
            idField: 'MKBABRowId',
            ClassTableName: 'User.MKBAssessmentBase',
            SQLTableName: 'MKB_AssessmentBase',
            // rownumbers:true,    //设置为 true，则显示带有行号的列。
            fitColumns: true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
            scrollbarSize: 0,
            onSelect: function (index, row) {
                id = row.MKBABRowId;
                //动态生成右侧评分控件界面
                var centerHtml = $.m({
                    ClassName: 'web.DHCBL.MKB.MKBAssessment',
                    MethodName: 'CreateAssessmentHtml',
                    id: id,
                    PatientUserInfo: PatientUserInfo
                }, false);
                $("#layoutcenter").html("<div class='allcontent'>" + centerHtml + "</div>");
                $.parser.parse(); //渲染hisui 样式
                $("#grade").text("");
                $("#result").text("");
                $("#allscore").text("");
                RefreshSearchData("User.MKBAssessmentBase2", id, "A", row.MKBABDesc);
            },
            onLoadSuccess: function (data) {
                $(this).datagrid('columnMoving');
            }
        });
        $("#leftgrid").datagrid({
            toolbar: "#leftTools"
        })
        ShowUserHabit('leftgrid');
        //左侧检索
        $("#TextDesc").searchcombobox({
            url: $URL + "?ClassName=web.DHCBL.BDP.BDPDataHistory&QueryName=GetDataForCmb1&ResultSetType=array&tablename=User.MKBAssessmentBase2",
            onSelect: function () {
                $(this).combobox('textbox').focus();
                SearchFunLib()
            }
        })
        $('#TextDesc').combobox('textbox').bind('keyup', function (e) {
            if (e.keyCode == 13) {
                SearchFunLib()
            }
        });
        $("#btnSearch").click(function (e) {
            SearchFunLib();
        });
        SearchFunLib = function () {
            var desc = $("#TextDesc").combobox('getText')
            $('#leftgrid').datagrid('load', {
                ClassName: "web.DHCBL.MKB.MKBAssessmentBase",
                QueryName: "GetList",
                'desc': desc
            });
            $('#mygrid').datagrid('unselectAll');
        }
        //左侧重置
        $("#btnLeftRefresh").click(function (e) {
            $("#TextDesc").combobox('setValue', '');
            $('#leftgrid').datagrid('load', {
                ClassName: "web.DHCBL.MKB.MKBAssessmentBase",
                QueryName: "GetList"
            });
            $('#leftgrid').datagrid('unselectAll');
            $("#layoutcenter").html('<div id="div-img" style="width:100%;height:90%;text-align:center;vertical-align: middle;"><img src="../scripts/bdp/Framework/icons/mkb/noselect-warn.png" alt="没有数据哦，选条数据看看吧" style="margin:100px 0" /></div>');
        })
    } else {
        //测试把tk改为CDSSMakeServerCall
        //DataInfo = "web.DHCBL.MKB.MKBAssessment[A]CreateAssessmentHtml[A]" + id + "[A]" + PatientUserInfo;
        //var centerHtml = CDSSMakeServerCall(DataInfo);

        var centerHtml = $.m({
            ClassName: 'web.DHCBL.MKB.MKBAssessment',
            MethodName: 'CreateAssessmentHtml',
            id: id,
            PatientUserInfo:PatientUserInfo
        }, false);
        $("#layoutcenter").append("<div id='allcontent' class='allcontent'>" + centerHtml + "</div>");
        if (sdflag == "cdss") {
            $("#Savebtn").append("<a href='#'' style='position:absolute;right:30px' class='hisui-linkbutton' iconCls='icon-submit' data-options='plain:true' id='btnSave2'>保存结果</a>")
        } else if (sdflag.indexOf("cdssreuse") != -1) {
            if (editflag == "editable") {
                $("#Savebtn").append("<a style='position:absolute;right:150px' href='#'' class='hisui-linkbutton' iconCls='icon-submit' data-options='plain:true' onclick='EditRatingData(\"" + sdflag + "\")' id='btnSave1'>修改结果</a><a href='#'' style='position:absolute;right:30px' class='hisui-linkbutton' iconCls='icon-submit'  data-options='plain:true' id='btnSave2'>另存结果</a>")
            } else {
                $("#Savebtn").append("<a href='#'' style='position:absolute;right:30px' class='hisui-linkbutton' iconCls='icon-submit' data-options='plain:true' id='btnSave2'>保存结果</a>")
            }

        }
        $.parser.parse(); //渲染hisui 样式 
        if ((sdflag == "sd") || (sdflag == "cdss") || (sdflag.indexOf("cdssreuse") != -1)) {
            //GetURLParams("allvalue")
            var str = GetURLParams("allvalue");
            var remarks = GetURLParams("remarks");
            if (!!str) {
                allvalue = str.split("[%AND]");
            } else {
                allvalue = [];
            }
            $.each(allvalue, function (index, value) {
                if (value != "") {
                    var $thisid = value.split("[iAndv]")[0];
                    var $thisval = value.split("[iAndv]")[1];
                    var $thistype = $thisid.split("_")[0];
                    if ($thistype == "C") {
                        $("#" + $thisid).find("select").combobox('setValue', $thisval);
                    }
                    if ($thistype == "R") {
                        $("#" + $thisid).find("input[value='" + $thisval + "']").radio("setValue", true);
                    }
                    if ($thistype == "CB") {
                        if ($thisval != "") {
                            var $thisvalnew1 = $thisval.split("[CBVa]");
                        }
                        $("#" + $thisid).find("input").each(function (index) {
                            var $thisvalnew2 = $thisvalnew1[index + 1];
                            $("#" + $thisid).find("input[value='" + $thisvalnew2 + "']").checkbox("setValue", true);
                        })
                    }
                    if (($thistype == "TX")) {
                        $("#" + $thisid).find("input").val($thisval);
                    }
                    if ($thistype == "TA") {
                        $("#" + $thisid).find("textarea").val($thisval);
                    }
                }
            })
            if (remarks != null) {
                $("#desc").val(remarks);
            } else {
                $("#desc").val("");
            }

        }
        //$(".hisui-checkbox").removeAttr('id');
    }
    $("#btnSave").click(function (e) {
        var allvalue = GetAllValue();
        $("#allvalue").val(allvalue);
        if (CheckAll() == "true") {
            getTheCheckBoxValue();
        };
        /*if (sdflag = "cdss") {
            var score = $("#allscore").text();
            var result = $("#result").text();
            var grade = $("#grade").text();
            $.m({
                ClassName: "web.CDSS.TreatDecision.RatingScale",
                MethodName: "SaveRatingData",
                PatientID: "1",
                Score: score,
                Result: result,
                Allvalue: allvalue,
                Grade: grade,
                MKBAssid: id,
            }, function(Data) {
                var Data = eval('(' + Data + ')');
                //setTimeout(parent.showtable("急性阑尾炎"),5000);
                parent.showtable("timeline");
                parent.popover.close();
                //parent.$HUI.popover('#grid_view0').hide()
                //$('#webuiPopover1', window.parent.document).hide();
                //parent.window.close();
            });
        }*/
    })
    /*$('#btnSave1').click(function(e){
        alert(1);
    })*/
    // 修改原有评分别结构  edito：范文凯
    EditRatingData = function (Str) {
        var allvalue = GetAllValue();
        var score = $("#allscore").text();
        var result = $("#result").text();
        var grade = $("#grade").text();
        var desc = $("#desc").val();
        if (score == "") {
            $.messager.alert("提示信息", "还未计算总分,无法保存结果", "info");
            return
        }

        //测试把tk改为CDSSMakeServerCall
        DataInfo = "web.CDSS.TreatDecision.RatingScale[A]EditRatingData[A]" + PatientUserInfo + "[A]" + score + "[A]" + result + "[A]" + allvalue + "[A]" + grade + "[A]" + id + "[A]" + desc + "[A]" + Str;
        var Data = CDSSMakeServerCall(DataInfo);
        //var idname = parent.$('#Assessment').parent().parent().parent().attr('id');
        //$('#' + idname, window.parent.document).hide();
        /*$.m({
                ClassName: "web.CDSS.TreatDecision.RatingScale",
                MethodName: "EditRatingData",
                PatientUserInfo: PatientUserInfo,
                Score: score,
                Result: result,
                Allvalue: allvalue,
                Grade: grade,
                MKBAssid: id,
                Remarks:desc,
                TableID:Str
            }, function(Data) {
                var Data = eval('(' + Data + ')');
                /*if (Data[0].success == "true")
                {
                   $.messager.popover({
                        msg: '评估记录已成功保存!',
                        type: 'success',
                        timeout: 1000
                   });
                }
                //setTimeout(parent.showtable("急性阑尾炎"),5000);
                parent.RequestRatingScale("","","","")
                //parent.showtable("timeline");
                var idname = parent.$('#Assessment').parent().parent().parent().attr('id');
                $('#'+idname, window.parent.document).hide();
            });*/
    }
    $("#btnSave2").click(function (e) {
        var allvalue = GetAllValue();
        var score = $("#allscore").text();
        var result = $("#result").text();
        var grade = $("#grade").text();
        var desc = $("#desc").val();
        if (score == "") {
            $.messager.alert("提示信息", "还未计算总分,无法保存结果", "info");
            return
        }
        if (sdflag = "cdss") {
            //测试把tk改为CDSSMakeServerCall
            DataInfo = "web.CDSS.TreatDecision.RatingScale[A]SaveRatingData[A]" + PatientUserInfo + "[A]" + score + "[A]" + result + "[A]" + allvalue + "[A]" + grade + "[A]" + id + "[A]" + desc;
            var Data = CDSSMakeServerCall(DataInfo);
            //var idname = parent.$('#Assessment').parent().parent().parent().attr('id');
            //$('#'+idname, window.parent.document).hide();
            
            /*$.m({
                ClassName: "web.CDSS.TreatDecision.RatingScale",
                MethodName: "SaveRatingData",
                PatientUserInfo: PatientUserInfo,
                Score: score,
                Result: result,
                Allvalue: allvalue,
                Grade: grade,
                MKBAssid: id,
                Remarks:desc
            }, function(Data) {
                var Data = eval('(' + Data + ')');
                /*if (Data[0].success == "true")
                {
                   $.messager.popover({
                        msg: '评估记录已成功保存!',
                        type: 'success',
                        timeout: 1000
                   });
                }
                //setTimeout(parent.showtable("急性阑尾炎"),5000);
                parent.RequestRatingScale("","","","")
                //parent.showtable("timeline");
                var idname = parent.$('#Assessment').parent().parent().parent().attr('id');
                $('#'+idname, window.parent.document).hide();
            });*/
        }
    })
    //获得所有选择的值
    GetAllValue = function () {
        var allvalueid = [];
        $(".contentul").each(function () {
            var $thisid = $(this).attr("id");
            var $thistype = $thisid.split("_")[0];
            var $thisval = ""
            if ($thistype == "C") {
                $thisval = $("#" + $thisid).find(".combo-value").val();
            }
            if ($thistype == "R") {
                $thisval = $("#" + $thisid).find("input:checked").val();
            }
            if ($thistype == "CB") {
                $("#" + $thisid).find("input:checked").each(function (index) {
                    $thisval = $thisval + "[CBVa]" + $("#" + $thisid).find("input:checked").eq(index).val();
                })
            }
            if (($thistype == "TX")) {
                $thisval = $("#" + $thisid).find("input").val();
            }
            if ($thistype == "TA") {
                $thisval = $("#" + $thisid).find("textarea").val();
            }
            allvalueid.push($thisid + "[iAndv]" + $thisval)
        })
        return allvalueid.join("[%AND]");
    }
    //勾选时触发方法
    /* $HUI.radio("[name='CDSS']",{
            onCheckChange:function(e,value){
                getTheCheckBoxValue();
            }
        });
    */
    // $HUI.radio.bind("change", alert(1));
    //判断是否选完
    CheckAll = function () {
        var rt = "true"
        //判断复选框是否选一个
        var boxradio = [];
        $(".contentul").each(function () {
            //筛选出单选和复选的id
            var $thisid = $(this).attr("id")
            if (($thisid.indexOf("R") != -1) || ($thisid.indexOf("CB") != -1)) {
                boxradio.push($thisid)
            }
        })
        var flagradioarrey = [];
        $.each(boxradio, function (index, value) {
            flagradioarrey[index] = "false";
            $("#" + value).find(".radio").each(function () {
                if ($(this).hasClass("checked")) {
                    flagradioarrey[index] = "true";
                }
            })
            $("#" + value).find(".checkbox").each(function () {
                if ($(this).hasClass("checked")) {
                    flagradioarrey[index] = "true";
                }
            })
        })
        if (flagradioarrey.indexOf("false") != -1) {
            $.messager.alert("提示信息", "还有未填写题目,请选完后计算总分", "info");
            rt = "false";
            $("#grade").text("");
            $("#result").text("");
            $("#allscore").text("");
        }
        return rt
    }
    window.CDSSMakeServerCall = CDSSMakeServerCall;

})