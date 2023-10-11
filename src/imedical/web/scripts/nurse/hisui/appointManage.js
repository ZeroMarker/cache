
var GV = {
    PfBarInfo: "",
    SelectOffDay: 0,
    StartOffDay: 0,
    EndOffDay: 6,
    DateSumList: [],
    BedDetailJson: []
}
$(init);
//初始化
function init() {
    initUI();
    initEvent();
    if (singlePat) { ///传了住院证号--查询单人
	    $('#CardNo').attr('disabled', true);
	    $('#regNO').attr('disabled', true);
	    $('#appStartDate').datebox('disable');
	    $('#appEndDate').datebox('disable');
	    $('#appLocBox').combobox('disable');
	    $('#appWardBox').combobox('disable');
	    $('#bookDocBox').combobox('disable');
	    $('#patName').attr('disabled', true);
	    $('#admInitStateBox').combobox('disable');
	    $('#inSorceBox').combobox('disable');
	    $('#dayOpPatCheck').checkbox('disable');
		$("#clearSchCondition").linkbutton('disable');
		$cm({
	        ClassName: "Nur.InService.AppointManage",
	        MethodName: "GetBookingAppStatus",
	        BookNo: bookingNum
	    }, function(jsonData) {
		    var IPStatus=jsonData.IPStatus;
		    if (IPStatus =="B") { //登记
		    	$("input[name='patState'][value='1']").radio("check");
			}else if((IPStatus =="Al")||(IPStatus =="Ar")){ //已分配/入院
				$("input[name='patState'][value='0']").radio("check");
			}else{
				findAppPatList();
			}
		})
    } else {
        resizePatGrid();
        initPatSchCondition();
    }
    initBedSchCondition();
    initBedGrid();
    if (HISUIStyleCode=="lite"){
	    $(".layout-panel-west").css("border-right-color","#f5f5f5");
	    $(".layout-panel-north").css("border-bottom-color","#f5f5f5");
	    $("#patInfoBar").css("background","#f5f5f5");
	}
}


/**
 *@description 初始化bedGrid按钮操作及事件监听等
 *
 */
function initBedGrid() {
    var Columns = [
        [{
                field: 'Operate',
                title: '操作',
                width: 50,
                formatter: function(value, row, index) {
                    return bedGridRowOper(value, row, index);
                }
            },
            { field: 'BedCode', title: '床号', width: 60 },
            { field: 'BedStatus', title: '床位状态', width: 75,
            	formatter: function(value, row, index) {
                    return $g(value);
                }
            },
            { field: 'BedSexDesc', title: '床位性别', width: 70,
            	formatter: function(value, row, index) {
                    return $g(value);
                }
           	},
            { field: 'EmptyDate', title: '预空日期', width: 90 },
            { field: 'bedType', title: '床位类型', width: 100},
            { field: 'BedBill', title: '床位费', width: 60, align: 'right' },
            { field: 'PatName', title: '当前患者', width: 100 },
            { field: 'RegNo', title: '当前登记号', width: 100 },
            { field: 'InHospDateTime', title: '入院时间', width: 140 },
            { field: 'AppPatName', title: '预约患者', width: 100 },
            { field: 'AppRegNo', title: '预约登记号', width: 100 },
            { field: 'AppDate', title: '预约日期', width: 100 },
            {
                field: 'OperName',
                title: '手术名称',
                width: 150,
                formatter: function(value, row, index) {
                    return formatCellTooltip(value);
                }
            },
            { field: 'OperDate', title: '手术日期', width: 100 },
            { field: 'SpeceilFlag', title: '可预约天数', width: 290 }
        ]
    ];
    $('#bedGrid').datagrid({
        fit: true,
        width: 'auto',
        border: false,
        striped: false,
        singleSelect: true,
        fitColumns: false,
        autoRowHeight: false,
        loadMsg: '加载中..',
        pagination: false,
        rownumbers: false,
        idField: "BedId",
        columns: Columns,
        //url : $URL+"?ClassName=Nur.NIS.Service.NursingPlan.QuestionRecord&QueryName=GetPatientQuestionList",
        onLoadSuccess: function(data) {
            $('.allotBtn').linkbutton({ plain: true, iconCls: 'icon-bed' });
            $('.cancleBtn').linkbutton({ plain: true, iconCls: 'icon-remove' });
        },
        rowStyler: function(index, row) {
            if (row.SelAppPatFlag == 1) {
                return 'background-color:#FFFBE6;';
            } else if (row.BedStatus == "预约") {
                return 'color:red;';
            }
        }
    })
}
//调整UI
function initUI() {
    $(".setradius").siblings().filter(".panel-header").css("border-radius", "4px 4px 0 0")
    if (singlePat) { ///传了住院证号--查询单人
        $("#schPanel").parent().hide().siblings().resize(); ///传了住院证号--查询单人
        $(".sigle-hide").css("display", "none").siblings().filter(".pf-key").css("padding-left", "4"); //隐藏部分患者基本信息
    } else {
        $(".sigle-hide").css("display", "inline-block");
        if (needRegist == "N") {
            $("#appRegisterBtn").hide();
        }
        $('#appStartDate').siblings().children().first().css("width", 153)
        $('#appEndDate').siblings().children().first().css("width", 153)
    }
}

//初始化事件
function initEvent() {
    $("#schPanel").resize(function() {
        if (!singlePat) { ///没传住院证号--可查询多人
            resizePatGrid();
        }
    });
    $("#patInfoBar").resize(function() {
        setPfBar();
    });
    $("#dateSumPanel").resize(function() {
        loadDateSummery(GV.SelectOffDay);
    });
    $(".setradius").panel({
        onCollapse: function() {
            setTimeout(function() {
                $("#bedGrid").datagrid("resize");
            }, 500)
        },
        onExpand: function() {
            setTimeout(function() {
                $("#bedGrid").datagrid("resize");
            }, 500)
        }
    })
    if (!singlePat) { ///没传住院证号--可查询多人
        document.onkeydown = DocumentOnKeyDown;
        $("#clearSchCondition").click(initPatSchCondition);
    }else{
	    $('#main').layout('collapse','west');  
	}
    $("#registerBtn").click(openRegisterModal);
    $("#findAppPatListBtn").click(findAppPatList);
    $('#wardSearchbox').searchbox({ searcher: wardSearcher });
    $('#wardGrid').datagrid({ onClickRow: wardGridClickRow });
    $('.change-date-btn').click(ChangeDateClick);
    $("#toggleBedMapType").click(ToggleBedMapClick);
    $("#sexGroup input[name='bedSexRadio']").radio({ onChecked: GetWardBedDetail })
    $HUI.radio("[name='patState']", {
        onChecked: function(e, value) {
            findAppPatList();
        }
    });
    $('#readCardBtn').click(readCardBtnClick); 
}
function readCardBtnClick() {
    function setCardNo(cardNo, papmiId, patientNo) {
        $('#regNO').val(patientNo);
        findAppPatList();
    }
    execReadCard(setCardNo);
}
//打开登记模态框
function openRegisterModal() {
    var width = 765;
    var height = 517;
    var left = (window.innerWidth - width) / 2;
    var top = (window.innerHeight - height) / 2;
    $('#registerModal').dialog({
        // 模态框关闭后事件
        onClose: function() {
            findAppPatList();
        },
        width: width,
        height: height,
        left: left,
        top: top
    }).dialog("open");
    // $HUI.dialog('#registerModal').setTitle('开立医嘱');
    $(".ctcAEPatBar").show();
    var url = 'nur.hisui.patientappoint.csp?BookNo=' + (bookingtNo||bookingNum);
    if ("undefined" !== typeof websys_getMWToken) {
       url += "&MWToken=" + websys_getMWToken();
    }
    $("#registerModal iframe").css('height', 'calc(100%)').attr('src', url);
}
//切换床位图或列表
function ToggleBedMapClick() {
    //$("#bedGridBox").css("z-index",$("#bedGridBox").css("z-index")==1?0:1);
    //$("#bedMapBox").css("z-index",$("#bedMapBox").css("z-index")==1?0:1);
    $("#bedMapBox").toggle();
    $("#toggleBedMapType .l-btn-text").text($("#toggleBedMapType .l-btn-text").text() == $g("列表") ? $g("床位图") : $g("列表"))
}
/**
 * @description 病区列表单击事件
 * @param {*} rowIndex 
 * @param {*} rowData 
 */
function wardGridClickRow(rowIndex, rowData) {
    IfWardCanAppoint(rowData.WardID);
}
///病区是否开放床位预约
function IfWardCanAppoint(wardID) {
    $cm({
        ClassName: "Nur.InService.AppointManage",
        MethodName: "ifUncontrollableWardLocJson",
        WardID: wardID
    }, function(jsonData) {
        resetSelectWard();
        if (String(jsonData.success) === '0') {
            GV.SelectOffDay = 0;
            GV.StartOffDay = 0;
            GV.EndOffDay = 6;
            GetDateAvaiBedSummery(wardID, GV.PfBarInfo.AppDate ? GV.PfBarInfo.AppDate : GV.PfBarInfo.BookingDate, 0, 29, "")
        } else {
            $.messager.show({
                title: '病区不受控制',
                msg: jsonData.errInfo ? jsonData.errInfo : jsonData.msg, //: jsonData.errInfo,
                timeout: 5000,
                showType: 'slide'
            });
        }
    });
}
///获取一段时间内该病区是否有床
///WardId：病区id,AppDate：默认预约日期,StartDay：查询开始日期与今天的差0,EndDay：默认29，查30天数据,SelectDay：选中日期的索引-当传空时，默认选中预约日期，预约日期小于当前日期，选中当前日期,
function GetDateAvaiBedSummery(WardId, AppDate, StartDay, EndDay, SelectDay) {
    var OperDate="";
    var appStatusSwitch = $("input[name='patState']:checked").val();
    if (appStatusSwitch !=0){ //未分配状态下,如果存在手术日期且手术日期大于等于当天,默认选中手术日期
    	OperDate=GV.PfBarInfo.OperDate;
    }
    $cm({
        ClassName: "Nur.InService.AppointManage",
        MethodName: "GetDateAvaiBedSummery",
        WardId: WardId,
        AppDate: AppDate,
        StartDay: StartDay,
        EndDay: EndDay,
        SelectDay: SelectDay,
        OperDate: OperDate
    }, function(jsonData) {
        GV.SelectOffDay = jsonData.SelectDay;
        var dateList = jsonData.DateList;
        GV.DateSumList.push.apply(GV.DateSumList, dateList);
        loadDateSummery(SelectDay);

    });
}
//界面加载日期
function loadDateSummery(SelectDay) {
    if (!SelectDay) SelectDay = "";
    if (GV.DateSumList.length < 1) { return; }
    $("#changeDateUL").parent().css("width", "84%")
    var panelWidth = $("#changeDateUL").parent().width();
    var itemWidth = Math.floor(panelWidth / 7);
    $("#changeDateUL").parent().width(itemWidth * 7); //
    $("#changeDateUL").width(itemWidth * GV.DateSumList.length);
    var html = ""
    for (var i = 0; i < GV.DateSumList.length; i++) {
        var dateObj = GV.DateSumList[i];
        html = html + "<li HtmlDate='" + dateObj.HtmlDate + "' Index='" + dateObj.Index + "' class='change-date-li";
		if (GV.SelectOffDay == i) { html = html + " change-date-li-select"; } 
        html = html + "' style='width:" + (itemWidth) + "px'><span class='change-date-top";
        html = html + " change-date-top-sel"
        html = html + "'>" + dateObj.ShowDate.split("(")[0] + "(" + $g(dateObj.ShowDate.split("(")[1].split(")")[0]) + ")" + "</span>";
        html = html + "<span class='change-date-bottom";
        if (dateObj.AvailBedFlag == 0) { html = html + " change-date-bottom-nobed'>"+$g("无床")+"</span>" } else { html = html + "'>"+$g("有床")+"</span>" }
        html = html + "</li>"
    }
    $("#changeDateUL").html(html);
    $("#nextDay").removeClass("change-date-btn-dis")
    $("#nextWeek").removeClass("change-date-btn-dis")
    $(".change-date-li").click(DateClick);
    if (GV.SelectOffDay > GV.EndOffDay) {
        var offIndex = (GV.SelectOffDay - GV.EndOffDay);
        GV.EndOffDay = GV.SelectOffDay;
        GV.StartOffDay = GV.StartOffDay + offIndex;
        scrollDateBar(offIndex);
    }
    if (SelectDay == "") { //第一次选中病区列表加载日期，
        if (GV.BedDetailJson.length == 0) {
            GetWardBedDetail();
        } else {

        }

    }
}

function GetWardBedDetail() {
    if (!$('#wardGrid').datagrid('getSelected') || bookingtNo == "") return;
    $.messager.progress({ title: "提示", msg: '正在加载数据', text: '加载中....' });
    var selWardID = $('#wardGrid').datagrid('getSelected').WardID;
    var selAppDate = $("#changeDateUL .change-date-li-select").attr("HtmlDate")
    var selBookNo = bookingtNo;
    var selBedStat = $('#bedStatusBox').combobox("getValue")
    var selBedSex = $("#sexGroup input:radio:checked").val();
    $cm({
        ClassName: "Nur.InService.AppointManage",
        MethodName: "GetWardBedDetail",
        WardId: selWardID,
        AppDate: selAppDate,
        BookingNo: selBookNo,
        BedStatFlag: selBedStat,
        BedSexFlag: selBedSex
    }, function(jsonData) {
        GV.BedDetailJson = jsonData;
        $('#bedGrid').datagrid({ data: jsonData });
        LoadBedMap(jsonData)
        $.messager.progress("close");
    })
}

function F(value) {
    return typeof value == "undefined" ? "" : value;
}

function LoadBedMap(jsonData) {
    var html = '<div class="box">';

    for (var i = 0; i < jsonData.length; i++) {
        var bedObj = jsonData[i];
        var bedSexClass = F(bedObj.BedSexCode) == "" ? "" : (" bed" + F(bedObj.BedSexCode));
        if (bedSexClass == " bedM") {
            bedSexClass = bedSexClass + " fa fa-male fa-lg";
        } else if (bedSexClass == " bedF") {
            bedSexClass = bedSexClass + " fa fa-female fa-lg";
        }
        var selClass = F(bedObj.SelAppPatFlag) == 1 ? " selpat" : ""
        var title = $g("床&nbsp;位&nbsp;费：") + F(bedObj.BedBill) + "\n" + $g("性&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;别：") + F(bedObj.BedSexDesc)+ "\n" + $g("床位类型：") + F(bedObj.bedType)
        html = html + '<div class="bedcard' + selClass + '"> \
						<div class="bedhead" title="' + title + '"> \
							<span class="ward">' + F(bedObj.RoomDesc) + '</span> \
							<span class="bed' + bedSexClass + '">' + F(bedObj.BedCode) + '</span> \
						</div>'
        if (F(bedObj.Available) == 0) {
            if ((!F(bedObj.RegNo)) && (!F(bedObj.AppRegNo))) {
                html = html + '<span class="unabbletips">' + F(bedObj.BedStatus) + '</span>'
            } else {
                var ifDaySurg = (F(bedObj.TreatedPrinciple) == "DaySurg")
                var ifAppPat = (F(bedObj.BedStatus) == "预约")
                var inDays = ""
                if (parseInt(bedObj.PatInDays) > 0) {
                    if (ifDaySurg) inDays = $g("日间 第") + F(bedObj.PatInDays) + $g("天")
                    else { inDays = (ifAppPat ? $g("预约") : $g("在院")) + $g(" 第") + F(bedObj.PatInDays) + $g("天") }
                }
                html = html + '<div class="bedcenter"> \
			 					<img src="' + (F(bedObj.PatSex) == "女" ? "../images/woman_big.png" : ((F(bedObj.PatSex) == "男") ? "../images/man_big.png" : "../images/unman.png")) + '"/> \
			 					<div> \
			 						<span class="patname">' + (F(bedObj.PatName) ? F(bedObj.PatName) : F(bedObj.AppPatName)) + (F(bedObj.BedStatus) == "包床" ? $g("(包床)") : "") + "&nbsp;&nbsp" + bedObj.PatAge.split("岁")[0] + $g("岁") + '</span> \
			 						<span class="appdays" >' + inDays + '</span> \
			 					</div> \
			 				</div>'
                html = html + '<div class="bedcontent"> \
			 					<div class="inforow"> \
			 						<span class="infoT">'+$g("诊断：")+'</span> \
			 						<span class="infoV">' + F(bedObj.PatDiag) + '</span> \
			 					</div> \
			 					<div class="inforow"> \
			 						<span class="infoT">' + (ifDaySurg ? $g("手术：") : $g("病情：")) + '</span> \
			 						<span class="infoV">' + (ifDaySurg ? F(bedObj.OperName) : F(bedObj.illState)) + '</span> \
			 					</div> \
			 					<div class="inforow"> \
			 						<span class="infoT">' + (ifDaySurg ? $g("麻醉：") : (ifAppPat ? $g("途径：" ): $g("费别："))) + '</span> \
			 						<span class="infoV">' + (ifDaySurg ? F(bedObj.OperAnmethod) : (ifAppPat ? F(bedObj.InSourceDesc) : F(bedObj.admReason))) + '</span> \
			 					</div> \
			 					<div class="inforow"> \
			 						<span class="infoT">' + $g("医生：") + '</span> \
			 						<span class="infoV">' + (ifDaySurg ? F(bedObj.OperDoc) : (ifAppPat ? F(bedObj.AppDocName) : F(bedObj.PatDoctor))) + '</span> \
			 					</div> \
			 					<div class="inforow"> \
			 						<span class="infoT4">' + (ifDaySurg ? $g("手术时间：") : (ifAppPat ? $g("预约日期：") : $g("入院时间："))) + '</span> \
			 						<span class="infoV">' + (ifDaySurg ? F(bedObj.OperDate) + " " + F(bedObj.OperTime) : (ifAppPat ? F(bedObj.AppDate) : F(bedObj.InHospDateTime))) + '</span> \
			 					</div> \
			 				</div>'

                if (bedObj.SelAppPatFlag == 1) {
                    html = html + '<a class="cancelBtn" href="javascript:void(0);" onclick="cancleBtnClick(\'' + F(bedObj.IPAppID) + '\')">'+$g("取消预约")+'</a>'
                }
            }
        } else {
            if (GV.PfBarInfo.IPStatus != "Al") {
                html = html + '<img class="unappbed" src="../images/nur_app_emptybed.png" width="100"/> \
							<a class="appBtn" href="javascript:void(0);" onclick="allotBtnClick(\'' + bedObj.BedId + '\')">'+$g("预约")+'</a>'
                if (bedObj.AvailDays) {
                    html = html + '<span title="' + (F(bedObj.SpeceilFlag) ? F(bedObj.SpeceilFlag) : "") + '" class="abbletips">' + $g('当前可连续预约') +F(bedObj.AvailDays) + $g('天')+'</span>'
                }
            } else {
                html = html + '<img class="unappbed" src="../images/nur_app_emptybed.png" width="100"/> \
							<a class="appBtnDis" href="javascript:void(0);" >'+$g('预约')+'</a>'

            }
        }

        html = html + '</div>'
    }
    html = html + '</div>'
    $("#bedMapBox").html(html);
}

function allotBtnClick(bedID) {
    if (("Y" == needRegist) && !GV.PfBarInfo.RegDate) {
        $.messager.popover({ msg: '请先登记再预约！', type: 'alert' });
        return;
    }
    var appDate = $("#changeDateUL .change-date-li-select").attr("HtmlDate");
    var bedStatus = $cm({
        ClassName: "Nur.InService.AppointManage",
        MethodName: "GetBedAppointStatus",
        BedId: bedID,
        AppDate: appDate
    }, false);
    if (!bedStatus.Available) {
        $.messager.popover({ msg: '床位非空置状态，无法预约！', type: 'alert' });
        setTimeout(GetWardBedDetail, 2000);
        return;
    }
    var userID = session['LOGON.USERID'];
    var ipAppId = F(GV.PfBarInfo.IPAppID);
    var wardLocID = $('#wardGrid').datagrid("getSelected").WardLocID;
    var checkResult=$cm({
        ClassName: "Nur.InService.AppointManageV2",
        MethodName: "checkPatIsCanAllotBed",
        IPAppID: ipAppId,
        BookNo:bookingtNo,
    }, false);
    if (checkResult.errInfo){
	    $.messager.popover({ msg: checkResult.errInfo, type: 'error' });
   	 	return false;
	}
    var OperDate=GV.PfBarInfo.OperDate;
    if (OperDate) {
	    var CheckOperDateFlag = $cm({
	        ClassName: "Nur.InService.AppointManage",
	        MethodName: "CheckOperDate",
	        appDate: appDate,
	        OperDate: OperDate
	    }, false);
	    if (CheckOperDateFlag ==1) {
		    $.messager.confirm('确认对话框', "床位预约日期："+appDate+"与手术日期："+OperDate+"不一致，是否继续?", function(r){
				if (r){
				   allotAppoitmentBed();
				}
			});
			return;
		}
	}
	allotAppoitmentBed();
    function allotAppoitmentBed(){
	    $cm({
	        ClassName: "Nur.InService.AppointManage",
	        MethodName: "allotAppoitmentBed",
	        IPAppID: ipAppId,
	        BedID: bedID,
	        AppDate: appDate,
	        AppTime: '23:59:59',
	        UserID: userID,
	        BookingtNo: bookingtNo,
	        WardLocID: wardLocID
	    }, function(jsonData) {
	        if ((!jsonData.msg) && (String(jsonData.success) === '0')) {
	            $.messager.popover({
	                msg: "分配成功!",
	                timeout: 5000,
	                type: 'success'
	            });
	            if (singlePat) { ///传了住院证号--查询单人
	            	$("input[name='patState'][value='0']").radio("check");
	            }else{
	            	findAppPatList();
	            }
	            initSelectBookPat();
	        } else {
	            var errInfo = jsonData.errInfo;
	            if (!errInfo) errInfo = jsonData.msg;
	            if (!errInfo) errInfo = "";
	            $.messager.popover({
	                msg: '分配失败:' + errInfo, //: jsonData.errInfo,
	                timeout: 5000
	            });
	        }
	    });
	}
}

function cancleBtnClick(IPAppID) {
    var userID = session['LOGON.USERID'];
    $cm({
        ClassName: "Nur.InService.AppointManage",
        MethodName: "cancleAllotBed",
        IPAppID: IPAppID,
        UserID: userID
    }, function(jsonData) {
        if ((!jsonData.msg) && (String(jsonData.success) === '0')) {
            $.messager.popover({
                msg: "取消分配成功!",
                timeout: 5000,
                type: 'success'
            });
            if (singlePat) { ///传了住院证号--查询单人
            	$("input[name='patState'][value='1']").radio("check");
            }else{
            	findAppPatList();
            }
        } else {
            $.messager.popover({
                msg: '取消分配失败: ' + jsonData.msg ? jsonData.msg : jsonData.errInfo,
                timeout: 5000
            });
        }
        initSelectBookPat();
    });
}
/**
 * @description 床位列表行操作按钮(分配,取消分配)
 * @param {} val 
 * @param {*} row 
 * @param {*} index 
 */
function bedGridRowOper(val, row, index) {
    if (row.Available == 1) {
        if (GV.PfBarInfo.IPStatus == "Al") {
            btns = '<a href="#" class="allotBtn" style="opacity:0.4;"></a>';
        } else {
            btns = '<a href="#" class="allotBtn" onclick="allotBtnClick(\'' + String(row.BedId) + '\')"></a>';
        }
    } else {
        if (row.SelAppPatFlag == 1) {
            btns = '<a href="#" class="cancleBtn" onclick="cancleBtnClick(\'' + String(row.IPAppID) + '\')"></a>';
        } else {
            btns = '<a href="#" class="allotBtn" style="opacity:0.4;"></a>';
        }
    }
    return btns;
}
//选择日期
function DateClick() {
    $(this).addClass("change-date-li-select").siblings().removeClass("change-date-li-select");
    GV.SelectOffDay = $(this).attr("Index")
    GetWardBedDetail();
}

function ChangeDateClick() {
    if ($(this).hasClass("change-date-btn-dis")) return; //包含类change-date-btn-dis的不可点击
    //点击后不可重复点击，知道动画完成
    $(".change-date-btn").addClass("change-date-btn-dis");

    var offIndex = parseInt($(this).attr("offsetday"));

    var temStart = GV.StartOffDay + offIndex
    var temEnd = GV.EndOffDay + offIndex
    if (temStart < 0) {
        offIndex = -GV.StartOffDay
        GV.StartOffDay = 0;
        GV.EndOffDay = 6;
    } else if (temEnd > (GV.DateSumList.length - 1)) {
        offIndex = (GV.DateSumList.length - 1) - GV.EndOffDay
        GV.StartOffDay = (GV.DateSumList.length - 7);
        GV.EndOffDay = (GV.DateSumList.length - 1);
    } else {
        GV.StartOffDay = temStart;
        GV.EndOffDay = temEnd;
    }
    if (offIndex != 0) scrollDateBar(offIndex)
}

function scrollDateBar(offIndex) {
    var itemWidth = parseInt($("#changeDateUL li:first").css("width"));
    var offSet = offIndex * itemWidth;
    var oriLeft = parseInt($("#changeDateUL").css("left"))
    var animDur = Math.abs(offIndex) * 100;
    $("#changeDateUL").animate({ left: (oriLeft - offSet) + "px" }, (animDur > 300 ? 300 : (animDur < 100 ? 100 : animDur)), //
        function() {
            if (GV.StartOffDay <= 0) {
                $("#preDay").addClass("change-date-btn-dis")
                $("#preWeek").addClass("change-date-btn-dis")
            } else {
                $("#preDay").removeClass("change-date-btn-dis")
                $("#preWeek").removeClass("change-date-btn-dis")
            }
            if (GV.EndOffDay >= (GV.DateSumList.length - 1)) {
                $("#nextDay").addClass("change-date-btn-dis")
                $("#nextWeek").addClass("change-date-btn-dis")
            } else {
                $("#nextDay").removeClass("change-date-btn-dis")
                $("#nextWeek").removeClass("change-date-btn-dis")
            }

        }
    );

}
//调整预约患者列表的高度
function resizePatGrid() {
    var appGridHeight = 150;
    var gridPagerHeight = 30;
    var gridHeadHeight = 35;
    $("#schCondition").siblings().height(appGridHeight).children().height(appGridHeight).children().height(appGridHeight).children().children().filter(".datagrid-body").height(appGridHeight - gridHeadHeight)

    appGridHeight = parseInt($("#schCondition").parent().height()) - parseInt($("#schCondition").height()) - 6;
    if (appGridHeight <= 150) { appGridHeight = 150 }
    if ($("#appPatGrid").datagrid('getPager')[0]) {
        $("#schCondition").siblings().height(appGridHeight).children().height(appGridHeight).children().filter(".datagrid-view").height(appGridHeight - gridPagerHeight).children().children().filter(".datagrid-body").height(appGridHeight - gridHeadHeight - gridPagerHeight)
        $("#schCondition").siblings().children().children().filter(".datagrid-pager").height(gridPagerHeight);
    } else {
        $("#schCondition").siblings().height(appGridHeight).children().height(appGridHeight).children().filter(".datagrid-view").height(appGridHeight).children().children().filter(".datagrid-body").height(appGridHeight - gridHeadHeight)
    }
}

function initBedSchCondition() {
    $('#bedStatusBox').combobox({
        valueField: 'code',
        textField: 'desc',
        data: [{ code: "99", desc: $g("全部") }, { code: "1", desc: $g("可分配") }, { code: "0", desc: $g("不可分配") }],
        onSelect: function(record) {
            GetWardBedDetail();
        }
    }).combobox('select', "99");
}
//初始化住院证患者查询条件
function initPatSchCondition() {
    $("#appRegisterBtn").addClass("l-btn-disabled").removeClass("green").attr("disabled", true);
    $("#CardNo").val("")
    $("#CardTypeNew").val("")
    $("#regNO").val("")
    $("#bookNO").val("")
    $("#patName").val("")
    $("#admInitStateBox").combobox('select', "")
    $("#inSorceBox").combobox('select', "")
    $("#dayOpPatCheck").checkbox("setValue", false);
    $("#appLocBox").combobox('select', "");
    $("#bookDocBox").combobox('select', "")
    $("#appWardBox").combobox('select', "");
    $("#appStatusSwitch").switchbox("setValue", true, true)
    $('#bookAppDate').datebox('setValue', "");
    $('#appStartDate').datebox('setValue', dateCalculate(new Date(), -10));
    $('#appEndDate').datebox('setValue', formatDate(new Date()));

    $('#bookDocBox').combobox({
        valueField: 'ID',
        textField: 'name'
    }).combobox('clear');
    $('#appLocBox').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getLocs&locType=E&HospID=' + session['LOGON.HOSPID'],
        onSelect: function(record) {
            $('#bookDocBox').combobox('clear');
            $('#bookDocBox').combobox('options').url = $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getMainDoctors&locID=' + $(this).combobox("getValue");
            $('#bookDocBox').combobox('reload');
        },
        onChange: function(desc, val) {
            if (!desc && val == "") {
                $('#bookDocBox').combobox('clear');
                $('#bookDocBox').combobox('loadData', {}); //清空option选项   

            }
        },
        filter: function(q, row) {
            var opts = $(this).combobox('options');
            var text = row[opts.textField]; //下拉的对应选项的汉字
            var pyjp = getPinyin(text).toLowerCase(); //根据选项名字转换对应的拼音首字母并转换为小写
            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
                return true;
            }
            return false;
        },
        onLoadSuccess:function(){
	        if ((WARDBeforehand=="N")&&(WardLinkLocId)){
		        $('#appLocBox').combobox("select",WardLinkLocId).combobox('disable');
		    }
	    }
    });
    $('#appWardBox').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getLocs&locType=W&HospID=' + session['LOGON.HOSPID'],
        filter: function(q, row) {
            var opts = $(this).combobox('options');
            var text = row[opts.textField]; //下拉的对应选项的汉字
            var pyjp = getPinyin(text).toLowerCase(); //根据选项名字转换对应的拼音首字母并转换为小写
            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
                return true;
            }
            return false;
        },
        onLoadSuccess:function(){
	        if (WARDBeforehand=="N"){
		        $('#appWardBox').combobox("select",session['LOGON.CTLOCID']).combobox('disable');
		    }
	    }
    })
    $('#admInitStateBox').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getAdmInitStates',
        filter: function(q, row) {
            var opts = $(this).combobox('options');
            var text = row[opts.textField]; //下拉的对应选项的汉字
            var pyjp = getPinyin(text).toLowerCase(); //根据选项名字转换对应的拼音首字母并转换为小写
            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
                return true;
            }
            return false;
        }
    })
    $('#inSorceBox').combobox({
        valueField: 'ID',
        textField: 'desc',
        url: $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getInSorces',
        filter: function(q, row) {
            var opts = $(this).combobox('options');
            var text = row[opts.textField]; //下拉的对应选项的汉字
            var pyjp = getPinyin(text).toLowerCase(); //根据选项名字转换对应的拼音首字母并转换为小写
            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
                return true;
            }
            return false;
        }
    })
    findAppPatList();
}
//查询预约患者列表
function findAppPatList() {
    resetSelectBookPat();
    // var bookNO = $('#bookNO').val();
    var regNO = $('#regNO').val();
    var startDate = $('#appStartDate').datebox('getValue');
    var endDate = $('#appEndDate').datebox('getValue');
    var appLoc = $('#appLocBox').combobox('getValue');
    var appWard = $('#appWardBox').combobox('getValue');
    if (WARDBeforehand=="N"){
	    appLoc=WardLinkLocId;
	    appWard=session['LOGON.CTLOCID'];
	}
    var appDoctor = $('#bookDocBox').combobox('getValue');
    var patName = $('#patName').val();
    // var appStatusSwitch = $('#appStatusSwitch').switchbox('getValue');
    var appStatusSwitch = $("input[name='patState']:checked").val();
    var illStatus = $('#admInitStateBox').combobox('getValue');
    var inSource = $('#inSorceBox').combobox('getValue');
    var dayOper = $('#dayOpPatCheck').checkbox('getValue');
    $('#appPatGrid').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'Nur.InService.AppointManage',
            QueryName: 'FindAppPat',
            BookNO: bookingNum,
            RegNO: regNO,
            StartDate: startDate,
            EndDate: endDate,
            AppLoc: appLoc,
            AppWard: appWard,
            AppDoc: appDoctor,
            PatName: patName,
            AppState: appStatusSwitch,
            IllStatus: illStatus,
            InSource: inSource,
            DayOper: dayOper,
            SortType: 0,
            HospID: session['LOGON.HOSPID'],
            NeedRegist: "N" //needRegist 不管传入的参数是否需要登记，患者列表都需要显示为登记的患者，因为该页面可登记
        },
        nowrap: true,
        dataType: 'array',
        pagination: false,
        pageSize: 10,
        pageList: [10, 20, 30, 40, 50],
        onLoadSuccess: function(data) {
            if (data.total < 1) {
                $.messager.popover({ msg: '未查询到符合条件的患者信息!', type: 'alert' });
                return;
            }
            if (bookingNum) {
            	$('#appPatGrid').datagrid("selectRow", 0);
            	bookingtNo=bookingNum;
		        initSelectBookPat();
            } else {
	            $("#registerBtn").linkbutton('disable');
            }
        },
        onLoadError: function() {
            $.messager.popover({ msg: '查询出错，请联系工程师!', type: 'alert' });
        },
        onBeforeLoad: function() {
            resizePatGrid();
        },
        onClickRow: appPatGridClickRow,
        rowStyler: function(index, row) {
            if (row.TreatedPrinciple == "DaySurg") {
                return 'color:red;';
            }
        }
    });
}
//预约患者列表单击查询
function appPatGridClickRow(rowIndex, rowData) {
    bookingtNo = rowData.BookNO;
    $("#registerBtn").linkbutton('enable');
    initSelectBookPat();
}
//清空右侧选中患者的信息
function resetSelectBookPat() {
    bookingtNo = "";
    GV.PfBarInfo = "";
    $(".pf-bar").hide();
    $('#wardGrid').datagrid({ data: [] });
    $('#wardSearchbox').searchbox("setValue", "");
    $('.reservInfo input').val('');
    resetSelectWard()
}
//清空选中的病区信息
function resetSelectWard() {
    $("#changeDateUL").html("").css("left", 0);
    $(".change-date-btn").addClass("change-date-btn-dis")
    GV.SelectOffDay = 0;
    GV.StartOffDay = 0;
    GV.EndOffDay = 6;
    GV.DateSumList = [];
    GV.BedDetailJson = [];
    $('#bedGrid').datagrid({ data: [] });
    $('#bedMapBox').html("");
}
//初始化界面上选中的预约患者信息
function initSelectBookPat() {
    if (bookingtNo == "") return;
    $(".pf-bar").show();
    $cm({
        ClassName: "Nur.InService.AppointManage",
        MethodName: "GetPatBookingList",
        RegNo: "",
        BookNo: bookingtNo
    }, function(data) {
        if (data.total == 0) {
            $.messager.popover({ msg: '未能查询到有效的住院证信息', type: 'success', timeout: 1000 });
        } else {
            GV.PfBarInfo = data.bookList[0];
            setPfBar();
            setBookInfo();
            findWardBedSummery();
        }
    });
}
//病区列表
function findWardBedSummery() {
    var wardCode = $('#wardSearchbox').searchbox("getValue")
    $cm({
        ClassName: "Nur.InService.AppointManage",
        QueryName: "findWardBedSummery",
        ResultSetType: "array",
        LocID: GV.PfBarInfo.LocID,
        WardFlag: GV.PfBarInfo.WardType,
        AppDate: GV.PfBarInfo.AppDate ? GV.PfBarInfo.AppDate : GV.PfBarInfo.BookingDate,
        WardCode: wardCode,
        IPAppID: GV.PfBarInfo.IPAppID,
        BookID: GV.PfBarInfo.IPBookID
    }, function(jsonData) {

        $('#wardGrid').datagrid({ data: jsonData });
        if (jsonData.length > 0) {
            $('#wardGrid').datagrid("selectRow", 0)
            IfWardCanAppoint(jsonData[0].WardID)
        } else {
            resetSelectWard();
        }
    });
}
//病区搜索框
function wardSearcher(value, name) {
    findWardBedSummery();
}
//设置信息栏数据
function setPfBar() {
    if (GV.PfBarInfo == "") return;
    var patName = GV.PfBarInfo.PatName;
    $("#pbarPatName").text(patName);
    var sex = GV.PfBarInfo.Sex;
    $("#pbarSex").text(sex);
    if (sex == "男") {
        $("#PatPhoto").attr("src", HISUIStyleCode=="blue"?"../images/man.png":"../images/man_lite.png");
    } else if (sex == "女") {
        $("#PatPhoto").attr("src", HISUIStyleCode=="blue"?"../images/woman.png":"../images/woman_lite.png");
    } else {
        $("#PatPhoto").attr("src", HISUIStyleCode=="blue"?"../images/unman.png":"../images/unman_lite.png");
    }
    var ipStatus = GV.PfBarInfo.IPStatus;
    $("#pbarAppStatus").css("display", ipStatus == "Al" ? "inline-block" : "none").attr("title", ipStatus == "Al" ? "已签床位：" + GV.PfBarInfo.WardDesc + "--" + GV.PfBarInfo.AppBedCode : "");
    var treatedPrinciple = GV.PfBarInfo.TreatedPrinciple;
    $("#pbarDayOper").css("display", treatedPrinciple == "DaySurg" ? "inline-block" : "none").attr("title", treatedPrinciple == "DaySurg" ? "日间手术患者" : "");
    var age = GV.PfBarInfo.Age;
    $("#pbarAge").text(age);
    var regNo = GV.PfBarInfo.RegNO;
    $("#pbarRegNO").text(regNo);
    var deposit = GV.PfBarInfo.IPDeposit ? GV.PfBarInfo.IPDeposit : "";
    $("#pbarIPDeposit").text(deposit);
    var locDesc = GV.PfBarInfo.LocDesc;
    $("#pbarIPLocDesc").text(locDesc);
    var linkManPhone = GV.PfBarInfo.LinkManPhone ? GV.PfBarInfo.LinkManPhone : "";
    $("#pbarLinkManPhone").text(linkManPhone);
    var operDate = GV.PfBarInfo.OperDate ? GV.PfBarInfo.OperDate : "";
    $("#pbarOperDate").text(operDate);
    var operName = GV.PfBarInfo.OperName ? GV.PfBarInfo.OperName : "";
    //根据屏幕宽度设置手术名称的宽度
    $("#pbarOperName").css("width", "")
    $("#pbarOperName").text("")
    var pfBars = $("#appPanel .pf-bar").children()
    var barWidth = parseInt($("#appPanel .pf-bar").css("width"));
    for (var i = 0; i < pfBars.length; i++) {
        var tag = $(pfBars[i]);
        if (tag.css("display") != "none") barWidth = barWidth - (parseInt(tag.css("width")) + parseInt(tag.css("margin-left")) + parseInt(tag.css("margin-right")))
    }
    $("#pbarOperName").text(operName).attr("title", operName);
    // $("#pbarOperName").text(operName+operName+operName+operName+operName+operName+operName).attr("title",operName);
    barWidth = barWidth - parseInt($("#pbarOperName").css("font-size")) - 10;
    if (barWidth < 50) { barWidth = 50; }
    var opNameWidth = parseInt($("#pbarOperName").css("width"));
    if (opNameWidth > barWidth) {
        $("#pbarOperName").css({ width: barWidth + "px", overflow: "hidden", whiteSpace: "nowrap", display: "inline-block", "textOverflow": "ellipsis" });
    }
}
//设置预约信息
function setBookInfo() {
    if (GV.PfBarInfo == "") return;
    // 预约科室
    $("#LocDesc").val(GV.PfBarInfo.LocDesc || GV.PfBarInfo.AppLocDesc || '');
    // 预约病区
    $("#WardDesc").val(GV.PfBarInfo.WardDesc || "");
    // 预约医生
    $("#AppDocName").val(GV.PfBarInfo.AppDocName || "");
    // 预约日期
    $("#BookingDate").val(GV.PfBarInfo.AppDate || GV.PfBarInfo.BookingDate);
    // 状态
    $("#BookStatus").val(GV.PfBarInfo.BookStatus || "");
    // 登记日期
    $("#CreateDate").val(GV.PfBarInfo.CreateDate || GV.PfBarInfo.RegDate || "");
    // 登记人
    $("#CreateUser").val(GV.PfBarInfo.CreateUser || "");
    // 联系电话
    $("#LinkManPhone").val(GV.PfBarInfo.LinkManPhone || "");
    // 联系人
    $("#LinkMan").val(GV.PfBarInfo.LinkMan || "");
    // 预约人电话
    $("#AppointPhone").val(GV.PfBarInfo.AppointPhone || "");
    // 开证医生
    $("#BookCreateDoc").val(GV.PfBarInfo.BookCreateDoc || "");
    // 开证科室
    $("#BookLoc").val(GV.PfBarInfo.BookLoc || "");
    // 手术日期
    $("#OperDate").val(GV.PfBarInfo.OperDate || "");
    // 手术
    $("#OperName").val(GV.PfBarInfo.OperName || "");
    // 预缴押金
    $("#IPDeposit").val(GV.PfBarInfo.IPDeposit || "");
    $("#Diagnosis").val(GV.PfBarInfo.Diagnosis || "");
}
//更新联系数据
function updateLinkData(type) {
    if (!bookingtNo) return;
    var data;
    if (1 == type) {
        data = $("#LinkManPhone").val();
        if (('' !== data) && (!(/^1\d{10}$/.test(data)))) {
            $.messager.popover({ msg: '请填写正确的联系电话!', type: 'alert' });
            return false;
        }
        if (data == GV.PfBarInfo.LinkManPhone) return;
    } else if (2 == type) {
        data = $("#LinkMan").val();
        if (data == GV.PfBarInfo.LinkMan) return;
    } else {
        data = $("#AppointPhone").val();
        if (('' !== data) && (!(/^1\d{10}$/.test(data)))) {
            $.messager.popover({ msg: '请填写正确的联系电话!', type: 'alert' });
            return false;
        }
        if (data == GV.PfBarInfo.AppointPhone) return;
    }
    $cm({
        ClassName: "Nur.InService.AppointManage",
        MethodName: "UpdateBookAppInfo",
        dataType: "text",
        type: type,
        data: data,
        BookNo: bookingtNo
    }, function(res) {
        if (1 == res) {
            if (1 == type) {
                GV.PfBarInfo.LinkManPhone = data;
            } else if (2 == type) {
                GV.PfBarInfo.LinkMan = data;
            } else {
                GV.PfBarInfo.AppointPhone = data;
            }
            $.messager.popover({ msg: "保存成功！", type: 'success' });
        } else {
            $.messager.popover({ msg: res, type: 'error' });
        }
    });
}
//预约登记
function appRegister() {
    if ($("#appRegisterBtn").attr("disabled")) { return; }
    var wardLocID = $('#appWardBox').combobox('getValue');
    var bookNO = $('#bookNO').val();
    var appDate = $('#bookAppDate').datebox('getValue');
    var userID = session['LOGON.USERID'];
    if (bookNO != "" && appDate != "") {
        $cm({
            ClassName: "Nur.InService.AppointManage",
            MethodName: "saveIPAppointmentInfo",
            BookNO: bookNO,
            WardLocID: wardLocID,
            AppDate: appDate,
            UserID: userID
        }, function(jsonData) {
            if ((!jsonData.msg) && String(jsonData.success) === '0') {
                $.messager.popover({
                    msg: '预约登记成功!',
                    type: 'success'
                });
                FindPatBookings();
            } else {
                $.messager.popover({
                    msg: '登记失败:' + (jsonData.msg ? jsonData.msg : jsonData.errInfo),
                    type: 'error'
                });
            }
        });
    } else {
        $.messager.popover({ msg: '请选择或输入要登记患者的信息!', type: 'alert' });
    }


}
//卡号，登记号，住院证号回车事件调用的方法
function DocumentOnKeyDown(e) {
    if (window.event) {
        var keyCode = window.event.keyCode;
        var type = window.event.type;
        var SrcObj = window.event.srcElement;
    } else {
        var keyCode = e.which;
        var type = e.type;
        var SrcObj = e.target;
    }
    if (keyCode == 13) {
        if (SrcObj && (SrcObj.id.indexOf("CardNo") >= 0)) {
            var CardNo = $('#CardNo').val();
            if (CardNo == "") return;
            var myrtn = DHCACC_GetAccInfo("", CardNo, "", "", "CardNoKeyDownCallBack");
            return false;
        } else if (SrcObj && (SrcObj.id.indexOf("regNO") >= 0)) {
            if ($("#regNO").val().length < 10) {
                var temReg = $("#regNO").val();
                for (var k = 0; k < 10 - $("#regNO").val().length; k++) {
                    temReg = "0" + temReg;
                }
                $("#regNO").val(temReg);
            }
            $("#bookNO").val("")
            $('#CardNo').val("");
            FindPatBookings();
        } else if (SrcObj && SrcObj.id.indexOf("bookNO") >= 0) {
            FindPatBookings();
            $('#CardNo').val("");
        }
        return true;
    }
}
//卡号查询信息回调函数
function CardNoKeyDownCallBack(myrtn) {
    var myary = myrtn.split("^");
    var rtn = myary[0];
    switch (rtn) {
        case "0":
            var PatientID = myary[4];
            var PatientNo = myary[5];
            var CardNo = myary[1];
            $("#CardNo").val(CardNo);
            $("#regNO").val(PatientNo);
            FindPatBookings();
            break;
        case "-200":
            $.messager.alert("提示", "卡无效!", "info", function() {
                $("#CardTypeNew,#PatNo").val("");
                $("#CardNo").focus();
            });
            break;
        case "-201":
            var PatientID = myary[4];
            var PatientNo = myary[5];
            var CardNo = myary[1];
            $("#CardNo").val(CardNo);
            $("#regNO").val(PatientNo);
            FindPatBookings();
            break;
        default:
            break;
    }
}
//根据登记号或住院证号查询住院证信息
function FindPatBookings() {
    var regNo = $("#regNO").val();
    var bookNo = $("#bookNO").val();
    if (regNo == "" && bookNo == "") {
        $.messager.popover({ msg: '请输入正确的卡号，登记号或住院号！', type: 'success', timeout: 1000 });
        return;
    }
    $cm({
        ClassName: "Nur.InService.AppointManage",
        MethodName: "GetPatBookingList",
        RegNo: regNo,
        BookNo: bookNo
    }, function(data) {
        if (data.total == 0) {
            $.messager.popover({ msg: '未能查询到有效的住院证信息', type: 'success', timeout: 1000 });
        } else {
            $('#patBookGrid').datagrid({
                data: data.bookList,
                onClickRow: function(index, row) {
                    SetBookAppInfo(data.bookList[index])
                    $('#patBookGrid').datagrid('loadData', { total: 0, rows: [] });
                    $('#appointment').dialog("close");
                }
            });
            if (data.total == 1) {
                SetBookAppInfo(data.bookList[0])
            } else {
                $('#appointment').dialog({ width: window.innerWidth - 240, height: window.innerHeight - 200 }).dialog('open').window('center');;
            }

        }
    });
}
//住院证信息回填到界面元素
function SetBookAppInfo(data) {
    // $('#appStatusSwitch').switchbox("setValue",true ,true)	
    if (data.BookStatus == "申请" || data.BookStatus == "预住院") { //未登记
        $("#appRegisterBtn").removeClass("l-btn-disabled").addClass("green").removeAttr("disabled");
        $('#appLocBox').combobox("reload", $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getLocs&locType=E&HospID=' + session['LOGON.HOSPID'] + "&LocId=" + data.LocID);
        $('#appWardBox').combobox('reload', $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getLocLinkWardLoc&cLoc=' + data.LocID + '&WardFlag=' + data.WardType + "&BookID=" + data.IPBookID);
    } else {
        $("#appRegisterBtn").addClass("l-btn-disabled").removeClass("green").attr("disabled", true);
        $('#appLocBox').combobox("reload", $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getLocs&locType=E&HospID=' + session['LOGON.HOSPID']);
        $("#appWardBox").combobox("reload", $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getLocs&locType=W&HospID=' + session['LOGON.HOSPID']);
        // if(data.BookStatus=="签床"){
        // 	$('#appStatusSwitch').switchbox("setValue",false,true)	
        // }
    }
    $("#regNO").val(data.RegNO)
    $("#bookNO").val(data.IPBookNo)
    $("#patName").val(data.PatName)
    $("#admInitStateBox").combobox('select', data.AdmInitState)
    $("#inSorceBox").combobox('select', data.InSource)
    if (data.TreatedPrinciple == "DaySurg") {
        $("#dayOpPatCheck").checkbox("setValue", true);
    } else {
        $("#dayOpPatCheck").checkbox("setValue", false);
    }
    $("#appLocBox").combobox('select', data.LocID);
    $("#bookDocBox").combobox('select', data.PatInDoc)
    $("#appWardBox").combobox('select', data.WardLocID);
    $('#bookAppDate').datebox('setValue', data.BookingDate);
    findAppPatList();
}
//预约患者列表鼠标移入悬浮显示信息
function formatCellTooltip(value) {
    return "<span title='" + (value ? value : "") + "'>" + (value ? value : "") + "</span>";
}
window.addEventListener("resize",function() {
	setTimeout(function() {
		findAppPatList();
	},500);
});