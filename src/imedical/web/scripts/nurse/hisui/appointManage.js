
var GV = {
    PfBarInfo: "",
    SelectOffDay: 0,
    StartOffDay: 0,
    EndOffDay: 6,
    DateSumList: [],
    BedDetailJson: []
}
$(init);
//��ʼ��
function init() {
    initUI();
    initEvent();
    if (singlePat) { ///����סԺ֤��--��ѯ����
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
		    if (IPStatus =="B") { //�Ǽ�
		    	$("input[name='patState'][value='1']").radio("check");
			}else if((IPStatus =="Al")||(IPStatus =="Ar")){ //�ѷ���/��Ժ
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
 *@description ��ʼ��bedGrid��ť�������¼�������
 *
 */
function initBedGrid() {
    var Columns = [
        [{
                field: 'Operate',
                title: '����',
                width: 50,
                formatter: function(value, row, index) {
                    return bedGridRowOper(value, row, index);
                }
            },
            { field: 'BedCode', title: '����', width: 60 },
            { field: 'BedStatus', title: '��λ״̬', width: 75,
            	formatter: function(value, row, index) {
                    return $g(value);
                }
            },
            { field: 'BedSexDesc', title: '��λ�Ա�', width: 70,
            	formatter: function(value, row, index) {
                    return $g(value);
                }
           	},
            { field: 'EmptyDate', title: 'Ԥ������', width: 90 },
            { field: 'bedType', title: '��λ����', width: 100},
            { field: 'BedBill', title: '��λ��', width: 60, align: 'right' },
            { field: 'PatName', title: '��ǰ����', width: 100 },
            { field: 'RegNo', title: '��ǰ�ǼǺ�', width: 100 },
            { field: 'InHospDateTime', title: '��Ժʱ��', width: 140 },
            { field: 'AppPatName', title: 'ԤԼ����', width: 100 },
            { field: 'AppRegNo', title: 'ԤԼ�ǼǺ�', width: 100 },
            { field: 'AppDate', title: 'ԤԼ����', width: 100 },
            {
                field: 'OperName',
                title: '��������',
                width: 150,
                formatter: function(value, row, index) {
                    return formatCellTooltip(value);
                }
            },
            { field: 'OperDate', title: '��������', width: 100 },
            { field: 'SpeceilFlag', title: '��ԤԼ����', width: 290 }
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
        loadMsg: '������..',
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
            } else if (row.BedStatus == "ԤԼ") {
                return 'color:red;';
            }
        }
    })
}
//����UI
function initUI() {
    $(".setradius").siblings().filter(".panel-header").css("border-radius", "4px 4px 0 0")
    if (singlePat) { ///����סԺ֤��--��ѯ����
        $("#schPanel").parent().hide().siblings().resize(); ///����סԺ֤��--��ѯ����
        $(".sigle-hide").css("display", "none").siblings().filter(".pf-key").css("padding-left", "4"); //���ز��ֻ��߻�����Ϣ
    } else {
        $(".sigle-hide").css("display", "inline-block");
        if (needRegist == "N") {
            $("#appRegisterBtn").hide();
        }
        $('#appStartDate').siblings().children().first().css("width", 153)
        $('#appEndDate').siblings().children().first().css("width", 153)
    }
}

//��ʼ���¼�
function initEvent() {
    $("#schPanel").resize(function() {
        if (!singlePat) { ///û��סԺ֤��--�ɲ�ѯ����
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
    if (!singlePat) { ///û��סԺ֤��--�ɲ�ѯ����
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
//�򿪵Ǽ�ģ̬��
function openRegisterModal() {
    var width = 765;
    var height = 517;
    var left = (window.innerWidth - width) / 2;
    var top = (window.innerHeight - height) / 2;
    $('#registerModal').dialog({
        // ģ̬��رպ��¼�
        onClose: function() {
            findAppPatList();
        },
        width: width,
        height: height,
        left: left,
        top: top
    }).dialog("open");
    // $HUI.dialog('#registerModal').setTitle('����ҽ��');
    $(".ctcAEPatBar").show();
    var url = 'nur.hisui.patientappoint.csp?BookNo=' + (bookingtNo||bookingNum);
    if ("undefined" !== typeof websys_getMWToken) {
       url += "&MWToken=" + websys_getMWToken();
    }
    $("#registerModal iframe").css('height', 'calc(100%)').attr('src', url);
}
//�л���λͼ���б�
function ToggleBedMapClick() {
    //$("#bedGridBox").css("z-index",$("#bedGridBox").css("z-index")==1?0:1);
    //$("#bedMapBox").css("z-index",$("#bedMapBox").css("z-index")==1?0:1);
    $("#bedMapBox").toggle();
    $("#toggleBedMapType .l-btn-text").text($("#toggleBedMapType .l-btn-text").text() == $g("�б�") ? $g("��λͼ") : $g("�б�"))
}
/**
 * @description �����б����¼�
 * @param {*} rowIndex 
 * @param {*} rowData 
 */
function wardGridClickRow(rowIndex, rowData) {
    IfWardCanAppoint(rowData.WardID);
}
///�����Ƿ񿪷Ŵ�λԤԼ
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
                title: '�������ܿ���',
                msg: jsonData.errInfo ? jsonData.errInfo : jsonData.msg, //: jsonData.errInfo,
                timeout: 5000,
                showType: 'slide'
            });
        }
    });
}
///��ȡһ��ʱ���ڸò����Ƿ��д�
///WardId������id,AppDate��Ĭ��ԤԼ����,StartDay����ѯ��ʼ���������Ĳ�0,EndDay��Ĭ��29����30������,SelectDay��ѡ�����ڵ�����-������ʱ��Ĭ��ѡ��ԤԼ���ڣ�ԤԼ����С�ڵ�ǰ���ڣ�ѡ�е�ǰ����,
function GetDateAvaiBedSummery(WardId, AppDate, StartDay, EndDay, SelectDay) {
    var OperDate="";
    var appStatusSwitch = $("input[name='patState']:checked").val();
    if (appStatusSwitch !=0){ //δ����״̬��,������������������������ڴ��ڵ��ڵ���,Ĭ��ѡ����������
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
//�����������
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
        if (dateObj.AvailBedFlag == 0) { html = html + " change-date-bottom-nobed'>"+$g("�޴�")+"</span>" } else { html = html + "'>"+$g("�д�")+"</span>" }
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
    if (SelectDay == "") { //��һ��ѡ�в����б�������ڣ�
        if (GV.BedDetailJson.length == 0) {
            GetWardBedDetail();
        } else {

        }

    }
}

function GetWardBedDetail() {
    if (!$('#wardGrid').datagrid('getSelected') || bookingtNo == "") return;
    $.messager.progress({ title: "��ʾ", msg: '���ڼ�������', text: '������....' });
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
        var title = $g("��&nbsp;λ&nbsp;�ѣ�") + F(bedObj.BedBill) + "\n" + $g("��&nbsp;&nbsp&nbsp;&nbsp;&nbsp;&nbsp;��") + F(bedObj.BedSexDesc)+ "\n" + $g("��λ���ͣ�") + F(bedObj.bedType)
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
                var ifAppPat = (F(bedObj.BedStatus) == "ԤԼ")
                var inDays = ""
                if (parseInt(bedObj.PatInDays) > 0) {
                    if (ifDaySurg) inDays = $g("�ռ� ��") + F(bedObj.PatInDays) + $g("��")
                    else { inDays = (ifAppPat ? $g("ԤԼ") : $g("��Ժ")) + $g(" ��") + F(bedObj.PatInDays) + $g("��") }
                }
                html = html + '<div class="bedcenter"> \
			 					<img src="' + (F(bedObj.PatSex) == "Ů" ? "../images/woman_big.png" : ((F(bedObj.PatSex) == "��") ? "../images/man_big.png" : "../images/unman.png")) + '"/> \
			 					<div> \
			 						<span class="patname">' + (F(bedObj.PatName) ? F(bedObj.PatName) : F(bedObj.AppPatName)) + (F(bedObj.BedStatus) == "����" ? $g("(����)") : "") + "&nbsp;&nbsp" + bedObj.PatAge.split("��")[0] + $g("��") + '</span> \
			 						<span class="appdays" >' + inDays + '</span> \
			 					</div> \
			 				</div>'
                html = html + '<div class="bedcontent"> \
			 					<div class="inforow"> \
			 						<span class="infoT">'+$g("��ϣ�")+'</span> \
			 						<span class="infoV">' + F(bedObj.PatDiag) + '</span> \
			 					</div> \
			 					<div class="inforow"> \
			 						<span class="infoT">' + (ifDaySurg ? $g("������") : $g("���飺")) + '</span> \
			 						<span class="infoV">' + (ifDaySurg ? F(bedObj.OperName) : F(bedObj.illState)) + '</span> \
			 					</div> \
			 					<div class="inforow"> \
			 						<span class="infoT">' + (ifDaySurg ? $g("����") : (ifAppPat ? $g(";����" ): $g("�ѱ�"))) + '</span> \
			 						<span class="infoV">' + (ifDaySurg ? F(bedObj.OperAnmethod) : (ifAppPat ? F(bedObj.InSourceDesc) : F(bedObj.admReason))) + '</span> \
			 					</div> \
			 					<div class="inforow"> \
			 						<span class="infoT">' + $g("ҽ����") + '</span> \
			 						<span class="infoV">' + (ifDaySurg ? F(bedObj.OperDoc) : (ifAppPat ? F(bedObj.AppDocName) : F(bedObj.PatDoctor))) + '</span> \
			 					</div> \
			 					<div class="inforow"> \
			 						<span class="infoT4">' + (ifDaySurg ? $g("����ʱ�䣺") : (ifAppPat ? $g("ԤԼ���ڣ�") : $g("��Ժʱ�䣺"))) + '</span> \
			 						<span class="infoV">' + (ifDaySurg ? F(bedObj.OperDate) + " " + F(bedObj.OperTime) : (ifAppPat ? F(bedObj.AppDate) : F(bedObj.InHospDateTime))) + '</span> \
			 					</div> \
			 				</div>'

                if (bedObj.SelAppPatFlag == 1) {
                    html = html + '<a class="cancelBtn" href="javascript:void(0);" onclick="cancleBtnClick(\'' + F(bedObj.IPAppID) + '\')">'+$g("ȡ��ԤԼ")+'</a>'
                }
            }
        } else {
            if (GV.PfBarInfo.IPStatus != "Al") {
                html = html + '<img class="unappbed" src="../images/nur_app_emptybed.png" width="100"/> \
							<a class="appBtn" href="javascript:void(0);" onclick="allotBtnClick(\'' + bedObj.BedId + '\')">'+$g("ԤԼ")+'</a>'
                if (bedObj.AvailDays) {
                    html = html + '<span title="' + (F(bedObj.SpeceilFlag) ? F(bedObj.SpeceilFlag) : "") + '" class="abbletips">' + $g('��ǰ������ԤԼ') +F(bedObj.AvailDays) + $g('��')+'</span>'
                }
            } else {
                html = html + '<img class="unappbed" src="../images/nur_app_emptybed.png" width="100"/> \
							<a class="appBtnDis" href="javascript:void(0);" >'+$g('ԤԼ')+'</a>'

            }
        }

        html = html + '</div>'
    }
    html = html + '</div>'
    $("#bedMapBox").html(html);
}

function allotBtnClick(bedID) {
    if (("Y" == needRegist) && !GV.PfBarInfo.RegDate) {
        $.messager.popover({ msg: '���ȵǼ���ԤԼ��', type: 'alert' });
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
        $.messager.popover({ msg: '��λ�ǿ���״̬���޷�ԤԼ��', type: 'alert' });
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
		    $.messager.confirm('ȷ�϶Ի���', "��λԤԼ���ڣ�"+appDate+"���������ڣ�"+OperDate+"��һ�£��Ƿ����?", function(r){
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
	                msg: "����ɹ�!",
	                timeout: 5000,
	                type: 'success'
	            });
	            if (singlePat) { ///����סԺ֤��--��ѯ����
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
	                msg: '����ʧ��:' + errInfo, //: jsonData.errInfo,
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
                msg: "ȡ������ɹ�!",
                timeout: 5000,
                type: 'success'
            });
            if (singlePat) { ///����סԺ֤��--��ѯ����
            	$("input[name='patState'][value='1']").radio("check");
            }else{
            	findAppPatList();
            }
        } else {
            $.messager.popover({
                msg: 'ȡ������ʧ��: ' + jsonData.msg ? jsonData.msg : jsonData.errInfo,
                timeout: 5000
            });
        }
        initSelectBookPat();
    });
}
/**
 * @description ��λ�б��в�����ť(����,ȡ������)
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
//ѡ������
function DateClick() {
    $(this).addClass("change-date-li-select").siblings().removeClass("change-date-li-select");
    GV.SelectOffDay = $(this).attr("Index")
    GetWardBedDetail();
}

function ChangeDateClick() {
    if ($(this).hasClass("change-date-btn-dis")) return; //������change-date-btn-dis�Ĳ��ɵ��
    //����󲻿��ظ������֪���������
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
//����ԤԼ�����б�ĸ߶�
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
        data: [{ code: "99", desc: $g("ȫ��") }, { code: "1", desc: $g("�ɷ���") }, { code: "0", desc: $g("���ɷ���") }],
        onSelect: function(record) {
            GetWardBedDetail();
        }
    }).combobox('select', "99");
}
//��ʼ��סԺ֤���߲�ѯ����
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
                $('#bookDocBox').combobox('loadData', {}); //���optionѡ��   

            }
        },
        filter: function(q, row) {
            var opts = $(this).combobox('options');
            var text = row[opts.textField]; //�����Ķ�Ӧѡ��ĺ���
            var pyjp = getPinyin(text).toLowerCase(); //����ѡ������ת����Ӧ��ƴ������ĸ��ת��ΪСд
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
            var text = row[opts.textField]; //�����Ķ�Ӧѡ��ĺ���
            var pyjp = getPinyin(text).toLowerCase(); //����ѡ������ת����Ӧ��ƴ������ĸ��ת��ΪСд
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
            var text = row[opts.textField]; //�����Ķ�Ӧѡ��ĺ���
            var pyjp = getPinyin(text).toLowerCase(); //����ѡ������ת����Ӧ��ƴ������ĸ��ת��ΪСд
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
            var text = row[opts.textField]; //�����Ķ�Ӧѡ��ĺ���
            var pyjp = getPinyin(text).toLowerCase(); //����ѡ������ת����Ӧ��ƴ������ĸ��ת��ΪСд
            if (row[opts.textField].indexOf(q) > -1 || pyjp.indexOf(q.toLowerCase()) > -1) {
                return true;
            }
            return false;
        }
    })
    findAppPatList();
}
//��ѯԤԼ�����б�
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
            NeedRegist: "N" //needRegist ���ܴ���Ĳ����Ƿ���Ҫ�Ǽǣ������б���Ҫ��ʾΪ�ǼǵĻ��ߣ���Ϊ��ҳ��ɵǼ�
        },
        nowrap: true,
        dataType: 'array',
        pagination: false,
        pageSize: 10,
        pageList: [10, 20, 30, 40, 50],
        onLoadSuccess: function(data) {
            if (data.total < 1) {
                $.messager.popover({ msg: 'δ��ѯ�����������Ļ�����Ϣ!', type: 'alert' });
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
            $.messager.popover({ msg: '��ѯ��������ϵ����ʦ!', type: 'alert' });
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
//ԤԼ�����б�����ѯ
function appPatGridClickRow(rowIndex, rowData) {
    bookingtNo = rowData.BookNO;
    $("#registerBtn").linkbutton('enable');
    initSelectBookPat();
}
//����Ҳ�ѡ�л��ߵ���Ϣ
function resetSelectBookPat() {
    bookingtNo = "";
    GV.PfBarInfo = "";
    $(".pf-bar").hide();
    $('#wardGrid').datagrid({ data: [] });
    $('#wardSearchbox').searchbox("setValue", "");
    $('.reservInfo input').val('');
    resetSelectWard()
}
//���ѡ�еĲ�����Ϣ
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
//��ʼ��������ѡ�е�ԤԼ������Ϣ
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
            $.messager.popover({ msg: 'δ�ܲ�ѯ����Ч��סԺ֤��Ϣ', type: 'success', timeout: 1000 });
        } else {
            GV.PfBarInfo = data.bookList[0];
            setPfBar();
            setBookInfo();
            findWardBedSummery();
        }
    });
}
//�����б�
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
//����������
function wardSearcher(value, name) {
    findWardBedSummery();
}
//������Ϣ������
function setPfBar() {
    if (GV.PfBarInfo == "") return;
    var patName = GV.PfBarInfo.PatName;
    $("#pbarPatName").text(patName);
    var sex = GV.PfBarInfo.Sex;
    $("#pbarSex").text(sex);
    if (sex == "��") {
        $("#PatPhoto").attr("src", HISUIStyleCode=="blue"?"../images/man.png":"../images/man_lite.png");
    } else if (sex == "Ů") {
        $("#PatPhoto").attr("src", HISUIStyleCode=="blue"?"../images/woman.png":"../images/woman_lite.png");
    } else {
        $("#PatPhoto").attr("src", HISUIStyleCode=="blue"?"../images/unman.png":"../images/unman_lite.png");
    }
    var ipStatus = GV.PfBarInfo.IPStatus;
    $("#pbarAppStatus").css("display", ipStatus == "Al" ? "inline-block" : "none").attr("title", ipStatus == "Al" ? "��ǩ��λ��" + GV.PfBarInfo.WardDesc + "--" + GV.PfBarInfo.AppBedCode : "");
    var treatedPrinciple = GV.PfBarInfo.TreatedPrinciple;
    $("#pbarDayOper").css("display", treatedPrinciple == "DaySurg" ? "inline-block" : "none").attr("title", treatedPrinciple == "DaySurg" ? "�ռ���������" : "");
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
    //������Ļ��������������ƵĿ��
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
//����ԤԼ��Ϣ
function setBookInfo() {
    if (GV.PfBarInfo == "") return;
    // ԤԼ����
    $("#LocDesc").val(GV.PfBarInfo.LocDesc || GV.PfBarInfo.AppLocDesc || '');
    // ԤԼ����
    $("#WardDesc").val(GV.PfBarInfo.WardDesc || "");
    // ԤԼҽ��
    $("#AppDocName").val(GV.PfBarInfo.AppDocName || "");
    // ԤԼ����
    $("#BookingDate").val(GV.PfBarInfo.AppDate || GV.PfBarInfo.BookingDate);
    // ״̬
    $("#BookStatus").val(GV.PfBarInfo.BookStatus || "");
    // �Ǽ�����
    $("#CreateDate").val(GV.PfBarInfo.CreateDate || GV.PfBarInfo.RegDate || "");
    // �Ǽ���
    $("#CreateUser").val(GV.PfBarInfo.CreateUser || "");
    // ��ϵ�绰
    $("#LinkManPhone").val(GV.PfBarInfo.LinkManPhone || "");
    // ��ϵ��
    $("#LinkMan").val(GV.PfBarInfo.LinkMan || "");
    // ԤԼ�˵绰
    $("#AppointPhone").val(GV.PfBarInfo.AppointPhone || "");
    // ��֤ҽ��
    $("#BookCreateDoc").val(GV.PfBarInfo.BookCreateDoc || "");
    // ��֤����
    $("#BookLoc").val(GV.PfBarInfo.BookLoc || "");
    // ��������
    $("#OperDate").val(GV.PfBarInfo.OperDate || "");
    // ����
    $("#OperName").val(GV.PfBarInfo.OperName || "");
    // Ԥ��Ѻ��
    $("#IPDeposit").val(GV.PfBarInfo.IPDeposit || "");
    $("#Diagnosis").val(GV.PfBarInfo.Diagnosis || "");
}
//������ϵ����
function updateLinkData(type) {
    if (!bookingtNo) return;
    var data;
    if (1 == type) {
        data = $("#LinkManPhone").val();
        if (('' !== data) && (!(/^1\d{10}$/.test(data)))) {
            $.messager.popover({ msg: '����д��ȷ����ϵ�绰!', type: 'alert' });
            return false;
        }
        if (data == GV.PfBarInfo.LinkManPhone) return;
    } else if (2 == type) {
        data = $("#LinkMan").val();
        if (data == GV.PfBarInfo.LinkMan) return;
    } else {
        data = $("#AppointPhone").val();
        if (('' !== data) && (!(/^1\d{10}$/.test(data)))) {
            $.messager.popover({ msg: '����д��ȷ����ϵ�绰!', type: 'alert' });
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
            $.messager.popover({ msg: "����ɹ���", type: 'success' });
        } else {
            $.messager.popover({ msg: res, type: 'error' });
        }
    });
}
//ԤԼ�Ǽ�
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
                    msg: 'ԤԼ�Ǽǳɹ�!',
                    type: 'success'
                });
                FindPatBookings();
            } else {
                $.messager.popover({
                    msg: '�Ǽ�ʧ��:' + (jsonData.msg ? jsonData.msg : jsonData.errInfo),
                    type: 'error'
                });
            }
        });
    } else {
        $.messager.popover({ msg: '��ѡ�������Ҫ�Ǽǻ��ߵ���Ϣ!', type: 'alert' });
    }


}
//���ţ��ǼǺţ�סԺ֤�Żس��¼����õķ���
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
//���Ų�ѯ��Ϣ�ص�����
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
            $.messager.alert("��ʾ", "����Ч!", "info", function() {
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
//���ݵǼǺŻ�סԺ֤�Ų�ѯסԺ֤��Ϣ
function FindPatBookings() {
    var regNo = $("#regNO").val();
    var bookNo = $("#bookNO").val();
    if (regNo == "" && bookNo == "") {
        $.messager.popover({ msg: '��������ȷ�Ŀ��ţ��ǼǺŻ�סԺ�ţ�', type: 'success', timeout: 1000 });
        return;
    }
    $cm({
        ClassName: "Nur.InService.AppointManage",
        MethodName: "GetPatBookingList",
        RegNo: regNo,
        BookNo: bookNo
    }, function(data) {
        if (data.total == 0) {
            $.messager.popover({ msg: 'δ�ܲ�ѯ����Ч��סԺ֤��Ϣ', type: 'success', timeout: 1000 });
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
//סԺ֤��Ϣ�������Ԫ��
function SetBookAppInfo(data) {
    // $('#appStatusSwitch').switchbox("setValue",true ,true)	
    if (data.BookStatus == "����" || data.BookStatus == "ԤסԺ") { //δ�Ǽ�
        $("#appRegisterBtn").removeClass("l-btn-disabled").addClass("green").removeAttr("disabled");
        $('#appLocBox').combobox("reload", $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getLocs&locType=E&HospID=' + session['LOGON.HOSPID'] + "&LocId=" + data.LocID);
        $('#appWardBox').combobox('reload', $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getLocLinkWardLoc&cLoc=' + data.LocID + '&WardFlag=' + data.WardType + "&BookID=" + data.IPBookID);
    } else {
        $("#appRegisterBtn").addClass("l-btn-disabled").removeClass("green").attr("disabled", true);
        $('#appLocBox').combobox("reload", $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getLocs&locType=E&HospID=' + session['LOGON.HOSPID']);
        $("#appWardBox").combobox("reload", $URL + '?ClassName=Nur.InService.AppointManage&MethodName=getLocs&locType=W&HospID=' + session['LOGON.HOSPID']);
        // if(data.BookStatus=="ǩ��"){
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
//ԤԼ�����б��������������ʾ��Ϣ
function formatCellTooltip(value) {
    return "<span title='" + (value ? value : "") + "'>" + (value ? value : "") + "</span>";
}
window.addEventListener("resize",function() {
	setTimeout(function() {
		findAppPatList();
	},500);
});