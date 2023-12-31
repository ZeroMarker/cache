var operRoomList;
var operArrangedList;
$(function() {
    $("#AppDate").datebox({});
    $("#AppDate").datebox("setValue", (new Date()).addDays(1).format("yyyy-MM-dd"));
    operRoomList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindOperRoom",
        Arg1: session.DeptID,
        Arg2:"R",
        ArgCnt: 2
    }, "json");
    if(operRoomList && operRoomList){
        operRoomList.push({
            RowId:"All",
            Code:"连台手术间",
            Description:"连台手术间"
        });
    }
    loadArrangedData();
    var roomMenuItems=[];
        for(var i=0;i<operRoomList.length;i++){
            var operRoom=operRoomList[i];
            roomMenuItems.push({
                id:operRoom.RowId,
                text:operRoom.Description,
                iconCls:"",
                onClick:function(operCards){
                    var id=$(this.target).data("options").id;
                    arrangeOperCards(operCards,id,patientCardBoard);
                }
            });
        }
    var patientCardBoard = operScheduleCardboard.init($('#oper-cardboard'), {
        filterForm: {
            items: [{
                    id: 'filter_appdept',
                    valueField: 'AppDeptID',
                    textField: 'AppDeptDesc',
                    value: 'All',
                    label: '',
                    desc: '申请科室',
                    type: 'combobox',
                    prompt: ''
                },
                [{
                    id: 'filter_emergency',
                    valueField: 'SourceType',
                    textField: 'SourceTypeDesc',
                    value: 'E',
                    label: '急诊',
                    desc: '',
                    type: 'checkbox',
                    checked: true,
                    prompt: ''
                }, {
                    id: 'filter_elective',
                    valueField: 'SourceType',
                    textField: 'SourceTypeDesc',
                    value: 'B',
                    label: '择期',
                    desc: '',
                    type: 'checkbox',
                    checked: true,
                    prompt: ''
                }]
            ]
        },
        operCard: {

        },
        menu: {
            items: [{
                text: '安排手术间',
                iconCls: '',
                items: roomMenuItems
            },{
                text: '安排护士',
                iconCls: ''
            }]
        }
    })

    
    //加载手术间及页码
    loadOperRoom(patientCardBoard)

    //加载待排手术
    loadOperData(patientCardBoard);

        //加载手术室护士
    loadOperNurse();

    operCardDrag();

    operNurseDrag();

    //手术室
    $("#OperDeptID").combobox({
        valueField: "RowId",
        textField: "Code",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = CLCLS.BLL.Admission,
                param.QueryName = "FindLocation",
                param.Arg1 = "",
                param.Arg2 = "OP^EMOP^OUTOP",
                param.ArgCnt = 2
        }
    });

    //查询非当前日期的手术
    $("#btnQuery").linkbutton({
        onClick: function() {
            loadArrangedData();
           
            //加载手术间及页码
            loadOperRoom(patientCardBoard);

             //加载待排手术
             loadOperData(patientCardBoard);
                //加载手术室护士
            loadOperNurse();

            operCardDrag();

            operNurseDrag();
        }
    })

    //已排班手术打印
    $("#btnPrintArrange").linkbutton({
        onClick: function() {
            // var arrangeOperList = getOperArrangeData("");
            loadArrangedData();
            var arrangeOperList = operArrangedList;
            if (arrangeOperList && arrangeOperList.length > 0) {
                printListNew(arrangeOperList, "arrange");
            } else {
                $.messager.alert("提示", "无数据可打印", "warning");
            }
        }
    })

    function operCardDrag() {
        $('.oper-room-item-panel').each(function(i, panel) {
            var el = $('.oper-room-item-panel')[i];
            var sortable = new Sortable(el, {
                group: {
                    name: "words",
                    pull: true,
                    put: true
                },
                draggable: '.oper-card',
                dataIdAttr: 'data-seq',
                onAdd: function(evt) {
                    var toDataRoomId = $(evt.to).attr('data-rowId');
                    var fromDataRoomId = $(evt.from).attr('data-rowId');

                    //跨手术间调整手术后修改总台次
                    var toRoomOperCount = $(evt.to).find('.oper-card').length;
                    $('.oper-room-item[data-rowId="' + toDataRoomId + '"]').find('.oper-room-item-header').find("strong").html(toRoomOperCount);
                    var fromRoomOperCount = $(evt.from).find('.oper-card').length;
                    $('.oper-room-item[data-rowId="' + fromDataRoomId + '"]').find('.oper-room-item-header').find("strong").html(fromRoomOperCount);

                    //跨手术间调整手术后重新修改两个手术间的台次
                    updateOperSeq('.oper-room-item[data-rowId="' + toDataRoomId + '"]');
                    updateOperSeq('.oper-room-item[data-rowId="' + fromDataRoomId + '"]');

                    //保存修改后的数据
                    saveOperArrange('.oper-room-item[data-rowId="' + toDataRoomId + '"]');
                    saveOperArrange('.oper-room-item[data-rowId="' + fromDataRoomId + '"]');
                },
                onUpdate: function(evt) {
                    //同手术间调整台次后修改手术台次
                    var dataRoomId = $(evt.to).attr('data-rowId');
                    updateOperSeq('.oper-room-item[data-rowId="' + dataRoomId + '"]');
                    saveOperArrange('.oper-room-item[data-rowId="' + dataRoomId + '"]');
                }

            });
        });

        $('.oper-room-item-panel').each(function(i, panel) {
            var $_this = $(this)
            $_this.droppable({
                accept: '.oper-card',
                onDragEnter: function() {
                    $(this).css('background', '#FFF8D7');
                },
                onDragLeave: function() {
                    $(this).css('background', '');
                },
                onDrop: function(e, source) {
                    var preOperRoomId = $(source).parent().parent().attr('data-rowId')
                    curOperRoomId = $_this.parent().attr("data-rowId");
                    if (!$(source).hasClass('oper-card')) {
                        return false;
                    }
                    if (curOperRoomId != preOperRoomId) {
                        //不同容器顺序排台次
                        var curoperseq = $(this).children().not('.oper-room-item-nurse').length;
                        var operseq = ++curoperseq;
                        var oddroomoperseq = $(source).parent().prev().find('strong').html()
                        if (oddroomoperseq) {
                            var oddroomnewoperseq = parseInt(oddroomoperseq);
                            oddroomnewoperseq--;
                            $(source).parent().prev().find('strong').html(oddroomnewoperseq);
                        }
                        $(this).prev().find('strong').html(curoperseq);
                        var p = $('<div class="oper-card" data-seq="' + operseq + '"></div>');
                        var opsId = $(source).attr('data-opsid');
                        p.attr('data-opsid', opsId);
                        if ($(source).attr('data-seq')) {
                            $(source).find('.oper-card-header').html('第' + operseq + '台')
                        } else {
                            p.append('<div class="oper-card-header">第' + operseq + '台</div>');
                        }
                        p.append($(source).html());
                        $(this).append(p);
                        $(this).css('background', '');

                        var menu = $('<div style="display:none"></div>');
                        $('body').append(menu);
                        generateMenu(menu, patientCardBoard._options.menu);
                        menu.menu({
                            onClick: function(item) {
                                var operCards = [];
                                operCards.push($(this).data("opercard"));
                                var opt = $(item.target).data('options');
                                if (opt.onClick) {
                                    opt.onClick.call(item, operCards);
                                }
                                $(this).menu('destroy');
                            }
                        });
                        menu.data('opercard', p);
                        p.find(".oper-card-menubutton").mouseenter(function() {
                            menu.menu('show', $(this).offset());
                        });

                        $(source).remove();
                        $_this.scrollTop($_this.prop('scrollHeight'));
                        saveOperArrange('.oper-room-item[data-rowId="' + curOperRoomId + '"]');
                    }
                }
            })
        })
    }

    function operNurseDrag() {
        $(".oper-nurse").draggable({
            revert: true,
            proxy: function(source) {
                var p = $('<span style="z-index:99999" class="oper-nurse"></span>');
                p.attr('data-nurseId', $(source).attr('data-nurseId'));
                p.html($(source).html()).appendTo('body');
                return p;
            },
            onStartDrag: function() {
                $(".oper-room-item-scrubnurse,.oper-room-item-circualnurse").css('z-index', '99999');
            },
            onStopDrag: function() {
                $(".oper-room-item-scrubnurse,.oper-room-item-circualnurse").css('z-index', '');
            }
        });
        $(".oper-room-item-scrubnurse,.oper-room-item-circualnurse").droppable({
            accept: '.oper-nurse',
            onDragEnter: function() {
                $(this).css('background', '#FFF8D7');
            },
            onDragLeave: function() {
                $(this).css('background', '');
            },
            onDrop: function(e, source) {
                if (!$(source).hasClass('oper-nurse')) {
                    return false;
                }
                var p = $('<span class="oper-nurse oper-nurse-inroom" data-nurseId="' + $(source).attr('data-nurseId') + '"></span>');
                p.html($(source).html());
                p.append('<span class="close">&times</span>');
                $(this).append(p);
                $(this).css('background', '');
                $(this).parents().css('background', '');
                $(source).addClass('oper-nurse-arranged');

                var curOperRoomId = $(this).parents('.oper-room-item').attr('data-rowId');
                var scrubNurses = getArrangeNurses('.oper-room-item[data-rowId="' + curOperRoomId + '"]', ".oper-room-item-scrubnurse"),
                    circualNurses = getArrangeNurses('.oper-room-item[data-rowId="' + curOperRoomId + '"]', ".oper-room-item-circualnurse"),
                    operRoomNurseList = [];

                var operRoomNurse = dhccl.getDatas(ANCSP.DataQuery, {
                    ClassName: ANCLS.BLL.DataQueries,
                    QueryName: "FindOperNurse",
                    Arg1: $("#AppDate").datebox("getValue"),
                    Arg2: curOperRoomId,
                    ArgCnt: 2
                }, "json");
                if (operRoomNurse && operRoomNurse.length > 0) {
                    operRoomNurseList.push({
                        ClassName: ANCLS.Model.OperRoomNurse,
                        RowId: operRoomNurse[0].RowId,
                        OperDate: $("#AppDate").datebox("getValue"),
                        OperRoomId: curOperRoomId,
                        ScrubNurse: scrubNurses,
                        CircualNurse: circualNurses
                    });
                } else {
                    operRoomNurseList.push({
                        ClassName: ANCLS.Model.OperRoomNurse,
                        RowId: "",
                        OperDate: $("#AppDate").datebox("getValue"),
                        OperRoomId: curOperRoomId,
                        ScrubNurse: scrubNurses,
                        CircualNurse: circualNurses
                    });
                }
                var jsonData = dhccl.formatObjects(operRoomNurseList)
                $.ajax({
                    url: dhccl.csp.dataListService,
                    data: {
                        jsonData: jsonData
                    },
                    async: false,
                    type: "post",
                    success: function(data) {
                        if (data.indexOf("S^") == -1) {
                            dhccl.showMessage(data, "保存", null, null, function() {});
                        }
                    }
                })

                p.find('.close').click(function() {
                    $(this).parent().remove();
                    var datarowid = $(this).parent().attr('data-nurseId');
                    $(source).removeClass('oper-nurse-arranged');
                })

                saveOperArrange('.oper-room-item[data-rowId="' + curOperRoomId + '"]');

            }
        })
    }


});

function loadArrangedData(){
    var appDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperSchedule,
        QueryName: "FindOperScheduleList",
        Arg1: $("#AppDate").datebox("getValue"),
        Arg2: $("#AppDate").datebox("getValue"),
        Arg3: session.DeptID,
        Arg4: "",
        Arg5: "",
        Arg6: "",
        Arg7: "Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut",
        Arg8: "",
        Arg9: "",
        Arg10: "",
        Arg11: "N",
        Arg12: "N",
        Arg13: "N",
        ArgCnt: 13
    }, "json");
    if (appDatas){
        operArrangedList=appDatas.sort(function(obj1,obj2){
            var room1=obj1.RoomDesc;
            var room2=obj2.RoomDesc;
            if (room1===""){
                room1="第99间"
            }
            if (room2===""){
                room2="第99间"
            }
            var seq1=obj1.OperSeqInfo;
            var seq2=obj1.OperSeqInfo;
            
            if (room1<room2){
                return -1;
            }else if(room1>room2){
                return 1;
            }else{
                if (seq1<seq2){
                    return -1;
                }else if(seq2>seq1){
                    return 1;
                }else{
                    return 0;
                }
                return 0;
            }
        });
    }
}

//加载未排班手术信息
function loadOperData(patientCardBoard) {
    var appDatas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperSchedule,
        QueryName: "FindOperScheduleList",
        Arg1: $("#AppDate").datebox("getValue"),
        Arg2: $("#AppDate").datebox("getValue"),
        Arg3: session.DeptID,
        Arg4: "",
        Arg5: "",
        Arg6: "",
        Arg7: "",
        Arg8: "",
        Arg9: "",
        Arg10: "",
        Arg11: "N",
        Arg12: "N",
        Arg13: "Y",
        ArgCnt: 13
    }, "json");
    if(!appDatas) return;
    var arrangeConfig=getArrangeConfig();
    if(!arrangeConfig) return;
    var appDeptSeqArr=arrangeConfig.AppDeptSeq.split(splitchar.comma);
    var ignoreAppDeptArr=arrangeConfig.IgnoreAppDept.split(splitchar.comma);
    var filterAppDatas=[];
    for(var i=0;i<appDatas.length;i++){
        var appData=appDatas[i];
        if(ignoreAppDeptArr.indexOf(appData.AppDeptDesc)>=0) continue;
        filterAppDatas.push(appData);
    }
    var sortedAppDatas=filterAppDatas.sort(function(obj1,obj2){
        var appDept1=obj1.AppDeptDesc;
        var appDept2=obj2.AppDeptDesc;
        var appDeptAlias1=obj1.AppDeptAlias;
        var appDeptAlias2=obj2.AppDeptAlias;
        var surgeonAlias1=obj1.SurgeonShortDesc;
        var surgeonAlias2=obj2.SurgeonShortDesc;
        var operDT1=obj1.OperDateTime;
        var operDT2=obj2.OperDateTime;
        var appDeptInd1=appDeptSeqArr.indexOf(appDept1);
        var appDeptInd2=appDeptSeqArr.indexOf(appDept2);
        if(appDeptInd1<0 && appDeptInd2>=0){
            return 1;
        }
        if (appDeptInd1>=0 && appDeptInd2<0){
            return -1;
        }
        if(appDeptInd1<appDeptInd2){
            return -1;
        }else if(appDeptInd1>appDeptInd2){
            return 1;
        }else{
            if(appDeptAlias1<appDeptAlias2){
                return -1;
            }else if(appDeptAlias1>appDeptAlias2){
                return 1;
            }else{
                if(surgeonAlias1<surgeonAlias2){
                    return -1;
                }else if(surgeonAlias1>surgeonAlias2){
                    return 1;
                }else{
                    if(operDT1<operDT2){
                        return -1;
                    }else if(operDT1>operDT2){
                        return 1;
                    }else{
                        return 0;
                    }
                    return 0;
                }
                return 0;
            }
            return 0;
        }
    });
    patientCardBoard.loadData(sortedAppDatas);
}
//加载已排班手术信息,返回按台次排序的列表
function getOperArrangeData(operRoomId) {
    var roomOperList=[];
    if(operArrangedList && operArrangedList.length>0){
        for(var i=0;i<operArrangedList.length;i++){
            var appData=operArrangedList[i];
            if((appData.OperRoom===operRoomId) || (operRoomId==="All" && (!appData.OperRoom || appData.OperRoom===""))){
                roomOperList.push(appData)
            }
        }
    }
    var ret;
    if(roomOperList && roomOperList.length>0){
        ret=roomOperList.sort(sortOperSeq);
    }else{
        ret=roomOperList;
    }
    return ret;
}

function sortOperSeq(a, b) {
    return a.OperSeq - b.OperSeq;
}

//加载手术间及页码
function loadOperRoom(patientCardBoard) {
    var pageOperRoom = 3; //设置每页显示手术间个数
    
    $(".oper-room").empty();
    if (operRoomList && operRoomList.length > 0) {
        

        var pagecount = parseInt(operRoomList.length / pageOperRoom);
        if (operRoomList.length % pageOperRoom > 0) {
            pagecount++;
        }
        $.each(operRoomList, function(i, operRoom) {
            var p = $("<div class='oper-room-item oper-cardboard' data-rowId='" + operRoom.RowId + "'></div>");
            p.append('<div class="oper-room-item-header">' + operRoom.Description + '<span><strong>0</strong>台</span></div>')
            p.append('<div class="oper-room-item-panel" data-rowId="' + operRoom.RowId + '"></div>');
            p.find(".oper-room-item-panel").append('<div class="oper-room-item-nurse"><div><label>器械护士:</label><div class="oper-room-item-scrubnurse"></div></div><div><label>巡回护士:</label><div class="oper-room-item-circualnurse"></div></div></div>');
            //p.css({width:($(".oper-room").width()/pageOperRoom-10)+"px"});
            if (i >= pageOperRoom) {
                p.css({ display: 'none' });
            }
            var datalist = getOperArrangeData(operRoom.RowId);
            if (datalist && datalist.length > 0) {
                $.each(datalist, function(i, data) {
                    var opercard = new ArrangedOperCard(data, {});
                    p.find(".oper-room-item-panel").append(opercard._init());
                    var menu = $('<div style="display:none"></div>');
                    $('body').append(menu);
                    generateMenu(menu, patientCardBoard._options.menu);
                    menu.data('opercard', opercard);
                    menu.menu({
                        hideOnUnhover: true,
                        onClick: function(item) {
                            var operCards = [];
                            operCards.push($(this).data('opercard'));
                            var opt = $(item.target).data('options');
                            if (opt.onClick) {
                                opt.onClick.call(item, operCards);
                            }
                            $(this).menu('destroy');
                        }
                    });
                    //menu.menu('disableItem',$('[data-id="'+operRoom.RowId+'"]'));
                    opercard._menubutton.mouseenter(function() {
                        menu.menu('show', $(this).offset());
                    })
                });
                p.find(".oper-room-item-header").find("strong").html(datalist.length);
            }
            var operNurses = dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: ANCLS.BLL.DataQueries,
                QueryName: "FindOperNurse",
                Arg1: $("#AppDate").datebox("getValue"),
                Arg2: operRoom.RowId,
                ArgCnt: 2
            }, "json");
            if (operNurses && operNurses.length > 0) {
                var scrubnursesId = operNurses[0].ScrubNurse;
                var scrubnursesDesc = operNurses[0].ScrubNurseDesc;
                var circualnurseId = operNurses[0].CircualNurse;
                var circualnurseDesc = operNurses[0].CircualNurseDesc;
                if (scrubnursesId && scrubnursesDesc) {

                    var IdList = scrubnursesId.split(splitchar.comma);
                    var DescList = scrubnursesDesc.split(splitchar.comma);
                    for (var i = 0; i < IdList.length; i++) {
                        var s = $('<span class="oper-nurse oper-nurse-inroom" data-nurseId="' + IdList[i] + '"></span>');
                        s.html(DescList[i]);
                        s.append('<span class="close">&times</span>');
                        p.find(".oper-room-item-scrubnurse").append(s);
                    }
                }
                if (circualnurseId && circualnurseDesc) {
                    var IdList = circualnurseId.split(splitchar.comma);
                    var DescList = circualnurseDesc.split(splitchar.comma);
                    for (var i = 0; i < IdList.length; i++) {
                        var s = $('<span class="oper-nurse oper-nurse-inroom" data-nurseId="' + IdList[i] + '"></span>');
                        s.html(DescList[i]);
                        s.append('<span class="close">&times</span>');
                        p.find(".oper-room-item-circualnurse").append(s);
                    }
                }
            }
            p.appendTo(".oper-room");
        });

        $("#pagination").pagination({
            totalData: operRoomList.length,
            pageCount: pagecount,
            coping: true,
            homePage: '',
            endPage: '',
            prevContent: '上一页',
            nextContent: '下一页',
            jump: true,
            keepShowPN: true,
            mode: 'unfixed',
            count: 2,
            callback: function(api) {
                var selectpage = api.getCurrent();
                $(".oper-room-item").css('display', 'none');
                $.each(operRoomList, function(i, operRoom) {
                    if ((i >= (selectpage - 1) * pageOperRoom) && (i < selectpage * pageOperRoom)) {
                        $("[data-rowId='" + operRoom.RowId + "']").css('display', 'block');
                    }
                });
            }
        });

        
    }
    
}

//加载手术室护士
function loadOperNurse() {
    $("#oper-nurse-list").empty();
    var operNurseList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: CLCLS.BLL.Admission,
        QueryName: "FindCareProvByLoc",
        Arg1: "",
        Arg2: session.DeptID,
        ArgCnt: 2
    }, "json")
    if (operNurseList && operNurseList.length > 0) {
        $.each(operNurseList, function(i, operNurse) {
            var html = "<span class='oper-nurse' data-nurseId='" + operNurse.RowId + "'>" + operNurse.Description + "</span>"
            $("#oper-nurse-list").append(html);
        })
    }
}

//保存手术安排信息
function saveOperArrange(container) //container
{
    var operRoomId = $(container).attr('data-rowId'),
        scrubNurses = getArrangeNurses(container, ".oper-room-item-scrubnurse"),
        circualnurseS = getArrangeNurses(container, ".oper-room-item-circualnurse"),
        operScheduleList = [];
    $(container).find('.oper-card').each(function(i, item) {
        operScheduleList.push({
            ClassName: ANCLS.Model.OperSchedule,
            RowId: $(this).attr('data-opsid'),
            OperRoom: operRoomId,
            OperSeq: $(this).attr('data-seq'),
            Status: "",
            ScrubNurse: scrubNurses,
            CircualNurse: circualnurseS,
            StatusCode: "Arrange"
        });
        // operScheduleList.push({
        //     ClassName: "DHCAN.SurgicalProcedure",
        //     RowId: "",
        //     OperSchedule: $(this).attr('data-opsid'),
        //     Status: "",
        //     UpdateUserID: session.UserID,
        //     StatusCode: "Arrange",
        //     DataStatus: "N"
        // });
        var jsonData = dhccl.formatObjects(operScheduleList);
        $.ajax({
            url: dhccl.csp.dataListService,
            data: {
                jsonData: jsonData,
                MethodName: "SaveOperArrange",
                ClassName: ANCLS.BLL.OperArrange
            },
            async: false,
            type: "post",
            success: function(data) {
                if (data.indexOf("S^") == -1) {
                    dhccl.showMessage(data, "保存", null, null, function() {});
                }
            }
        });
    })
}
//获取手术间安排的器械护士或巡回护士
function getArrangeNurses(container, selector) {
    var result = "";
    $(container).find(selector).find(".oper-nurse").each(function() {
        var nurseId = $(this).attr('data-nurseid');
        if (result != "") {
            result += ",";
        }
        result += nurseId;
    })
    return result;
}
//调整手术台次
function updateOperSeq(container) {
    $(container).find('.oper-card').each(function(i, item) {
        var seq = i + 1;
        $(this).attr('data-seq', seq)
        $(this).find('.oper-card-header').html('第' + seq + '台')
    });
}

//菜单安排手术间
function arrangeOperCards(operCards,id, patientCardBoard) {
    
    $.each(operCards, function(index, card) {
        var _dom = (card._dom) ? card._dom : card;
        arrangeOperByMenuItem('.oper-room-item-panel[data-rowid="' + id + '"]', _dom, card.dataSource, patientCardBoard._options.menu);
        if ($(_dom).parents(".oper-room-item").length > 0) {
            var operRoomId = $(_dom).parents(".oper-room-item").attr('data-rowid');
            var OperCount = $(_dom).parents(".oper-room-item").find(".oper-card").length;
            $('.oper-room-item[data-rowId="' + operRoomId + '"]').find('.oper-room-item-header').find("strong").html((OperCount - 1));
            
            updateOperSeq('.oper-room-item[data-rowId="' + operRoomId + '"]');
            saveOperArrange('.oper-room-item[data-rowId="' + operRoomId + '"]');
        }
        updateOperSeq('.oper-room-item[data-rowId="' + id + '"]');
        saveOperArrange('.oper-room-item[data-rowId="' + id + '"]');
        updateOperSeq('.oper-room-item[data-rowId="' + card.dataSource.OperRoom + '"]');
        saveOperArrange('.oper-room-item[data-rowId="' + card.dataSource.OperRoom + '"]');
    })
}

function arrangeOperByMenuItem(containerSelector, dom, operschedule, menus) {
    var curOperSeqCount = $(containerSelector).find(".oper-card").length;
    var newOperSeq = curOperSeqCount + 1;
    $(containerSelector).prev().find('strong').html(newOperSeq);
    var operRowId = (operschedule) ? operschedule.RowId : $(dom).attr('data-opsid');
    var p = $('<div class="oper-card" data-opsId="' + operRowId + '" data-Seq="' + newOperSeq + '"></div>');
    if ($(dom).find(".oper-card-header").length > 0) {
        p.append($(dom).html());
        p.find(".oper-card-header").html('第' + newOperSeq + '台');

    } else {
        p.append('<div class="oper-card-header">第' + newOperSeq + '台</div>');
        p.append($(dom).html());
    }
    $(dom).remove();
    $(containerSelector).append(p);

    var menu = $('<div style="display:none"></div>');
    $('body').append(menu);
    generateMenu(menu, menus);
    menu.menu({
        onClick: function(item) {
            var operCards = [];
            operCards.push($(this).data("opercard"));
            var opt = $(item.target).data('options');
            if (opt.onClick) {
                opt.onClick.call(item, operCards);
            }
            $(this).menu('destroy');
        }
    });
    menu.data('opercard', p);
    //menu.menu('disableItem',$('[data-id="'+$(containerSelector).attr('data-rowid')+'"]'));
    p.mouseenter(function() {
        $(this).find(".oper-card-menubutton").show();
    });
    p.mouseleave(function() {
        $(this).find(".oper-card-menubutton").hide();
    })
    p.find(".oper-card-menubutton").mouseenter(function() {
        menu.menu('show', $(this).offset());
    })

}


function getArrangeConfig() {
    var result = null;
    $.ajaxSettings.async = false;
    $.getJSON("../service/dhcanop/data/operarrange.json?random=" + Math.random(), function(data) {
        result = data;
    }).error(function(message) {
        alert(message);
    });
    $.ajaxSettings.async = true;
    return result;
}

function printListNew(printDatas, configCode) {
    var arrangeConfig = getArrangeConfig();
    if (!arrangeConfig) {
        $.messager.alert("提示", "排班配置不存在，请联系系统管理员！", "warning");
        return;
    }
    var printConfig = getPrintConfig(arrangeConfig, configCode);
    if (!printConfig) {
        $.messager.alert("提示", "打印配置不存在，请联系系统管理员！", "warning");
        return;
    }
    // 标题信息(手术日期、手术室)
    var titleInfo = {
        OperationDate: $("#AppDate").datebox("getValue"),
        OperDeptDesc: session.DeptDesc
    };

    var LODOP = getLodop();
    LODOP.PRINT_INIT("山西省肿瘤医院手术排班表");
    LODOP.SET_PRINT_PAGESIZE(2, 0, 0, "A4");
    LODOP.ADD_PRINT_TEXT(15, 250, 200, 70, "山西省肿瘤医院\r\n手术排班表");
    LODOP.SET_PRINT_STYLEA(0, "FontName", "黑体");
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 18);
    LODOP.SET_PRINT_STYLEA(0, "Alignment", 2);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "Horient", 2);
    LODOP.ADD_PRINT_TEXT(85, 20, "100%", 28, "科室：" + titleInfo.OperDeptDesc);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_TEXT(85, 400, "100%", 28, "日期：" + titleInfo.OperationDate);
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    LODOP.SET_PRINT_STYLEA(0, "FontSize", 12);
    LODOP.ADD_PRINT_HTM(85, 700, "100%", 28, "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    LODOP.SET_PRINT_STYLEA(0, "ItemType", 1);
    var html = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:16px;} table{table-layout:fixed;}</style><table><thead><tr>";
    for (var i = 0; i < printConfig.columns.length; i++) {
        var column = printConfig.columns[i];
        html += "<th style='width:" + column.width + "px'>" + column.title + "</th>";
    }
    html += "</tr></thead><tbody>";
    for (var i = 0; i < printDatas.length; i++) {
        var printData = printDatas[i];
        html += "<tr>";
        for (var j = 0; j < printConfig.columns.length; j++) {
            var column = printConfig.columns[j];
            html += "<td style='" + (column.style ? column.style : "") + "'>" + printData[column.field] + "</td>";
        }
        html += "</tr>";
    }
    html += "</tbody></table>";
    LODOP.ADD_PRINT_TABLE(115, 0, "100%", "100%", html);
    LODOP.PREVIEW();
}

function getPrintConfig(arrangeConfig, configCode) {
    var result = null;
    if (arrangeConfig && arrangeConfig.print && arrangeConfig.print.length > 0) {
        for (var i = 0; i < arrangeConfig.print.length; i++) {
            var element = arrangeConfig.print[i];
            if (element.code == configCode) {
                result = element;
            }
        }
    }
    return result;
}