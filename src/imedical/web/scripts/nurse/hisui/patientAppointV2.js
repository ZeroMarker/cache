if (websys_isIE==true) {
	 var script = document.createElement('script');
	 script.type = 'text/javaScript';
	 script.src = '../scripts/dhcdoc/tools/bluebird.min.js';  // bluebird �ļ���ַ
	 document.getElementsByTagName('head')[0].appendChild(script);
}
var GV = {
    PfBarInfo: "",
    SelectOffDay: 0,
    StartOffDay: 0,
    EndOffDay: 6,
    DateSumList: [],
    BedDetailJson: []
}
$(function(){
	initwardGrid();
	initSelectBookPat();
	initBookAssess("Y");
	initEvent();
})
function initEvent(){
	$('.change-date-btn').click(ChangeDateClick);
}
function initwardGrid(){
	var Columns=[[ 
		{ field: 'WardID', checkbox: 'true'},
		{ field: 'WardDesc', title: '����',width:140,
			styler: function(value,row,index){
				if (row["EmptyNum"] == "0"){
					return 'color:red;'
				}else if(row["EmptyNum"] < 10){
					return 'color:orange;'
				}else  if(row["EmptyNum"] >= 10){
					return 'color:green;'
				}
			}
		},
		{ field: 'TotalNum', title: '�ܴ�',width:70},
		{ field: 'EmptyNum', title: '�մ���',width:70},
		{ field: 'OtherNum', title: '����',width:50},
		{ field: 'MaleNum', title: '�д�',width:50},
		{ field: 'FeMaleNum', title: 'Ů��',width:50},
		{ field: 'LockNum', title: '����',width:50},
		{ field: 'AvailNum', title: '����',width:50},
		{ field: 'UnavailNum', title: '������',width:70},		
		{ field: 'InHosNum', title: '��Ժ����',width:80},
		{ field: 'AppointNum', title: 'ԤԼ����',width:80},
		{ field: 'BedRate', title: '��λʹ����',width:90},
		{ field: 'leavePatients', title: '���/����',width:90},
		{ field: 'CTLBDesc', title: 'λ��',width:150}
    ]];
	$('#wardGrid').datagrid({  
		fit : true,
		width : 'auto',
		border : false,
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : $g('������..'),  
		pagination : false, 
		rownumbers : false,
		idField:"WardID",
		columns :Columns,
		titleNoWrap:false,
		onBeforeLoad:function(param){
			$('#AppWardListTab').datagrid("unselectAll");
		},
		onSelect:function(rowIndex, rowData){
			 IfWardCanAppoint(rowData.WardID);
		}
	})
}
function initSelectBookPat() {
    $cm({
        ClassName: "Nur.InService.AppointManage",
        MethodName: "GetPatBookingList",
        RegNo: "",
        BookNo: BookNo
    }, function(data) {
        if (data.total == 0) {
            $.messager.popover({ msg: 'δ�ܲ�ѯ����Ч��סԺ֤��Ϣ', type: 'success', timeout: 1000 });
        } else {
            GV.PfBarInfo = data.bookList[0];
            setPfBar();
            setBookInfo();
            findWardBedSummery();
            if (!GV.PfBarInfo.IPStatus) {
                //$("#cancelAppBtn,#editAppointBtn").linkbutton('disable');
                $("#cancelAppBtn,#editAppointBtn").hide();
                if (needRegist =="Y"){
	                //$("#allotBtn").linkbutton('disable');
	                $("#allotBtn").hide();
	            }
            } else {
                //$("#appointBtn").linkbutton('disable');
                $("#appointBtn").hide();
            }
            if (''==GV.PfBarInfo.IPAppID) {
                //$("#editAppointBtn").linkbutton('disable');
                $("#editAppointBtn").hide();
            }
            if (!GV.PfBarInfo.AppBedCode){
	            //$("#cancelAllotBtn").linkbutton('disable');	
	            $("#cancelAllotBtn").hide();            
	        }else{
		        //$("#cancelAppBtn,#allotBtn").linkbutton('disable');
		        $("#cancelAppBtn,#allotBtn").hide();
		    }
        }
    });
}
//�����б�
function findWardBedSummery() {
	var AppDate = GV.PfBarInfo.AppDate ? GV.PfBarInfo.AppDate : GV.PfBarInfo.BookingDate;
    var appStatusSwitch = websys_showModal('options').GetAppState(); //$("input[name='patState']:checked").val();
    if (appStatusSwitch !=0){ //δ����״̬��,������������������������ڴ��ڵ��ڵ���,Ĭ��ѡ����������
    	AppDate=GV.PfBarInfo.OperDate;
    }
    $cm({
        ClassName: "Nur.InService.AppointManageV2",
        QueryName: "findWardBedSummery",
        ResultSetType: "array",
        LocID: GV.PfBarInfo.LocID,
        WardFlag: GV.PfBarInfo.WardType,
        AppDate: AppDate,
        WardCode: "",
        IPAppID: GV.PfBarInfo.IPAppID,
        BookID: GV.PfBarInfo.IPBookID,
        hospitalId:session['LOGON.HOSPID']
    }, function(jsonData) {
        $('#wardGrid').datagrid({ data: jsonData });
        if (jsonData.length > 0) {
            $('#wardGrid').datagrid("selectRow", 0)
        } else {
            resetSelectWard();
        }
    });
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
    var appStatusSwitch = websys_showModal('options').GetAppState(); //$("input[name='patState']:checked").val();
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
}
function DateClick() {
    $(this).addClass("change-date-li-select").siblings().removeClass("change-date-li-select");
    GV.SelectOffDay = $(this).attr("Index")
    UpdateWardDetail();
}
function UpdateWardDetail(){
	var WardIDArr=[];
	var rows=$('#wardGrid').datagrid("getRows");
	for (var i=0;i<rows.length;i++){
		WardIDArr.push(rows[i].WardID);
	}
	$cm({
        ClassName: "Nur.InService.AppointManageV2",
        MethodName: "GetWardBedSummery",
        WardIDStr: WardIDArr.join("^"),
        AppDate:$("#changeDateUL .change-date-li-select").attr("HtmlDate")
    }, function(jsonData) {
	    for (var i=0;i<jsonData.length;i++){
		    var wardID=jsonData[i].wardID;
		    var wardBedSummeryData=eval("(" + jsonData[i].wardBedSummeryData + ")");
		    var index=$('#wardGrid').datagrid("getRowIndex",wardID);
		    if (index >=0 ){
			    var rowData=rows[index];
			    $.extend(rowData, wardBedSummeryData);
			    $('#wardGrid').datagrid('updateRow',{
					index: index,
					row:wardBedSummeryData
				});
			}
		}
	})
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
function appointBtnClick(){
	var sel=$('#wardGrid').datagrid("getSelected");
	if (!sel){
		$.messager.popover({msg: '��ѡ��ԤԼ������',type: 'error'});
         return false;
	}
	var wardLocID = sel.WardLocID;
    var appDate = $('#BookingDate').val();
    var AppointName = $('#AppointNameBookI').val();
    var AppointPhone = $('#AppointPhoneBookI').val();
    var Remark = $('#RemarkBookI').val();
    if (AppointName.toString().length>50) return $.messager.popover({msg:'ԤԼ���������Ȳ�����50�֣�',type:'alert'});
    if((''!==AppointPhone)&&(!(/^1\d{10}$/.test(AppointPhone)))) return $.messager.popover({msg:'����д��ȷ��ԤԼ�˵绰��',type:'alert'});
    if (Remark.toString().length>50) return $.messager.popover({msg:'��ע���Ȳ�����50�֣�',type:'alert'});
    var UserDep=session['LOGON.CTLOCID'];
    var userID = session['LOGON.USERID'];
    if (BookNo !=""&&appDate!= "") {
        $cm({
            ClassName: "Nur.InService.AppPatRegister",
            MethodName: "saveIPAppointmentInfo",
            BookNO: BookNo,
            WardLocID: wardLocID,
            AppDate: appDate,
            UserID: userID
        }, function (jsonData) {
            if ((!jsonData.msg) && String(jsonData.success) === '0') {
	            var SaveLogId = tkMakeServerCall("Nur.InService.AppPatRegister", "SaveLog", BookNo,"A",userID,UserDep,ClientIPAddress);
                $.messager.popover({msg: '���ųɹ�!',type: 'success'});
                //$("#appointBtn").linkbutton('disable');
                $("#appointBtn").hide();
                //$("#cancelAppBtn,#voidAppBtn").linkbutton('enable');
                $("#cancelAppBtn,#voidAppBtn").show();
                editAppBtnClick(1);
                websys_showModal('options').CallBackFunc("B");
            } else {
                $.messager.show({
                    title: '����ʧ��',
                    msg: jsonData.msg ? jsonData.msg : jsonData.errInfo,
                    timeout: 5000,
                    showType: 'slide'
                });
            }
        });
    }else{
        $.messager.popover({msg:'��ѡ�������Ҫ�Ǽǻ��ߵ���Ϣ!',type:'alert'});
    }
}
function cancelAppBtnClick(){
	var bookID=GV.PfBarInfo.IPBookID;
	var UserDep=session['LOGON.CTLOCID'];
    var userID=session['LOGON.USERID'];
    $m({
        ClassName: "Nur.InService.AppPatRegister",
        MethodName: "cancelApp",
        IPBookID:bookID,
        UserID:userID
    },function(txtData){
        if(txtData=="0"){
            $.messager.popover({msg:"ȡ�����ųɹ�",type:"success"});
            var SaveLogId = tkMakeServerCall("Nur.InService.AppPatRegister", "SaveLog", BookNo,"CA",userID,UserDep,ClientIPAddress);
            websys_showModal('options').CallBackFunc("CancelB");
        }
        else{
            $.messager.popover({msg:"ȡ������ʧ��:"+txtData,type:"error"});
        }
    })
}
//���䴲λ
function allotBtnClick(){
	if (("Y" == needRegist) && !GV.PfBarInfo.RegDate) {
        $.messager.popover({ msg: '���Ȱ����ٵǼǣ�', type: 'error' });
        return false;
    }
    var wardSel = $('#wardGrid').datagrid("getSelected")
    if (!wardSel){
	    $.messager.popover({ msg: '��ѡ������', type: 'error' });
	    return false;
	}
	var appDate = $("#changeDateUL .change-date-li-select").attr("HtmlDate");
    new Promise(function(resolve,rejected){
	   var ipAppId = GV.PfBarInfo.IPAppID;
	   var checkResult=$cm({
	        ClassName: "Nur.InService.AppointManageV2",
	        MethodName: "checkPatIsCanAllotBed",
	        IPAppID: ipAppId,
	        BookNo:BookNo,
	    }, false);
	    if (checkResult.errInfo){
		    $.messager.popover({ msg: checkResult.errInfo, type: 'error' });
	   	 	return false;
		}
		resolve();
	}).then(function(){
		return new Promise(function(resolve,rejected){
		   var AssessResult=$cm({
		        ClassName: "Nur.InService.AppointManageV2",
		        MethodName: "GetIPBookAssessResult",
		        BookNo: BookNo,
		        dataType:"text"
		    }, false);
		    if (AssessResult ==""){
			    $.messager.popover({ msg: '��סԺ֤��¼δ������', type: 'error' });
		   	 	return false;
			}else if(AssessResult =="NotP"){
				$.messager.popover({ msg: '��סԺ֤��¼����δͨ����', type: 'error' });
		    	return false;
			}
			resolve();
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
			var DepositMsg = $cm({
		        ClassName: "Nur.InService.AppointManageV2",
		        MethodName: "judPatIsDeposit",
		        BookNO: BookNo,
		        dataType:"text"
		    }, false);
		    if (DepositMsg =="-404"){
			    $.messager.popover({ msg: '��סԺ֤û�ж�Ӧ��ԤסԺ��¼��', type: 'error' });
			    return false;
			}else if(DepositMsg !=""){
				(function(callBackFunExec){
					new Promise(function(resolve,rejected){
						$.messager.alert("��ʾ",DepositMsg,"info",function(){
							callBackFunExec();
						});
					})
				})(resolve);
			}else{
				resolve();
			}
		})
	}).then(function(){
		return new Promise(function(resolve,rejected){
		    var WardID = wardSel.WardID;
		    var bedID = $cm({
		        ClassName: "Nur.InService.AppointManageV2",
		        MethodName: "GetAvailBed",
		        WardId: WardID,
		        AppDate: appDate,
		        PatSex:GV.PfBarInfo.Sex,
		        dataType:"text"
		    }, false);
		    if (bedID ==""){
			    $.messager.popover({ msg: wardSel.WardDesc+$g('δ�ҵ��ʺϸû��ߵĴ�λ��'), type: 'alert' });
			    return false;
			}
			resolve(bedID);
		})
	}).then(function(bedID){
		return new Promise(function(resolve,rejected){
		    var OperDate=GV.PfBarInfo.OperDate;
		    if (OperDate) {
			    var CheckOperDateFlag = $cm({
			        ClassName: "Nur.InService.AppointManage",
			        MethodName: "CheckOperDate",
			        appDate: appDate,
			        OperDate: OperDate
			    }, false);
			    if (CheckOperDateFlag ==1) {
				    (function(callBackFunExec){
						new Promise(function(resolve,rejected){
							$.messager.alert("��ʾ","��λԤԼ���ڣ�"+appDate+"���������ڣ�"+OperDate+"��һ�£��Ƿ����?","info",function(){
								callBackFunExec(bedID);
							});
						})
					})(resolve);
				}else{
					resolve(bedID);
				}
			}else{
				resolve(bedID);
			}
		})
	}).then(function(bedID){
		var ipAppId = GV.PfBarInfo.IPAppID;
		var UserDep=session['LOGON.CTLOCID'];
		var userID = session['LOGON.USERID'];
		var wardLocID = wardSel.WardLocID;
		$cm({
	        ClassName: "Nur.InService.AppointManage",
	        MethodName: "allotAppoitmentBed",
	        IPAppID: ipAppId,
	        BedID: bedID,
	        AppDate: appDate,
	        AppTime: '23:59:59',
	        UserID: userID,
	        BookingtNo: BookNo,
	        WardLocID: wardLocID
	    }, function(jsonData) {
	        if ((!jsonData.msg) && (String(jsonData.success) === '0')) {
		        if (ipAppId ==""){
			        var SaveLogId = tkMakeServerCall("Nur.InService.AppPatRegister", "SaveLog", BookNo,"A",userID,UserDep,ClientIPAddress);
			    }
		        var SaveLogId = tkMakeServerCall("Nur.InService.AppPatRegister", "SaveLog", BookNo,"R",userID,UserDep,ClientIPAddress);
	            $.messager.popover({
	                msg: "�Ǽǳɹ�!",
	                timeout: 5000,
	                type: 'success'
	            });
	            websys_showModal('options').CallBackFunc("Al");
	        } else {
	            var errInfo = jsonData.errInfo;
	            if (!errInfo) errInfo = jsonData.msg;
	            if (!errInfo) errInfo = "";
	            $.messager.popover({
	                msg: '�Ǽ�ʧ��:' + errInfo, //: jsonData.errInfo,
	                timeout: 5000
	            });
	        }
	    });
	})
}
//ȡ������
function cancelAllotBtnClick(){
	var UserDep=session['LOGON.CTLOCID'];
	var userID = session['LOGON.USERID'];
    $cm({
        ClassName: "Nur.InService.AppointManage",
        MethodName: "cancleAllotBed",
        IPAppID: GV.PfBarInfo.IPAppID,
        UserID: userID
    }, function(jsonData) {
        if ((!jsonData.msg) && (String(jsonData.success) === '0')) {
	        var SaveLogId = tkMakeServerCall("Nur.InService.AppPatRegister", "SaveLog", BookNo,"C",userID,UserDep,ClientIPAddress);
            $.messager.popover({
                msg: "ȡ���Ǽǳɹ�!",
                timeout: 5000,
                type: 'success'
            });
            websys_showModal('options').CallBackFunc("CancelAl");
        } else {
            $.messager.popover({
                msg: 'ȡ���Ǽ�ʧ��: ' + jsonData.msg ? jsonData.msg : jsonData.errInfo,
                timeout: 5000
            });
        }
    });
}
function voidAppBtnClick(){
	if(GV.PfBarInfo.IPBookID){
		if (GV.PfBarInfo.IPStatus){
	        $('#voidAppDlg').dialog('open');
	        $('#voidReasonBox').combobox({ 
	            valueField: 'id',
	            textField: 'desc',
	            url: $URL + '?ClassName=Nur.InService.AppPatRegister&MethodName=findCancelReason&HospID='+session['LOGON.HOSPID']});
	        $('#confirmVoidBtn').bind('click',confirmVoidBtnClick);   
	        $('#closeDlgBtn').bind('click',function(){$('#voidAppDlg').dialog('close');}); 
        }else{
	        confirmVoidBtnClick();
	    } 
    }else{
        $.messager.popover({msg:"δѡ����Ч��Ϣ!",type:"alert"});
    }
}
function confirmVoidBtnClick(){
    var bookID=GV.PfBarInfo.IPBookID;
    var UserDep=session['LOGON.CTLOCID'];
    var userID=session['LOGON.USERID'];
    var cancleID="";
    if (GV.PfBarInfo.IPStatus){
	    var cancleID= $('#voidReasonBox').combobox('getValue');
	    //���õ���
	    if(cancleID =='') {
	        $.messager.popover({msg:"����ԭ����Ϊ��:��ѡ������ԭ��!",type:"error"});
	        return;
	    }
    }
    $m({
        ClassName: "Nur.InService.AppPatRegister",
        MethodName: "voidApp",
        IPBookID:bookID,
        CancleID:cancleID,
        UserID:userID
    },function(txtData){
        if(txtData=="0"){
	        var SaveLogId = tkMakeServerCall("Nur.InService.AppPatRegister", "SaveLog", BookNo,"D",userID,UserDep,ClientIPAddress);
            $('#voidAppDlg').dialog('close');
            $.messager.popover({msg:"���ϳɹ�",type:"success"});
            websys_showModal('options').CallBackFunc("U");
        }
        else{
            $('#voidAppDlg').dialog('close');
            $.messager.popover({msg:"����ʧ��:"+txtData,type:"error"});
        }
    })
}
function editAppBtnClick(flag){
    var AppointName = $('#AppointNameBookI').val();
    var AppointPhone = $('#AppointPhoneBookI').val();
    var Remark = $('#RemarkBookI').val();
    if (AppointName.toString().length>50) return $.messager.popover({msg:'ԤԼ���������Ȳ�����50�֣�',type:'alert'});
    if((''!==AppointPhone)&&(!(/^1\d{10}$/.test(AppointPhone)))) return $.messager.popover({msg:'����д��ȷ��ԤԼ�˵绰��',type:'alert'});
    if (Remark.toString().length>50) return $.messager.popover({msg:'��ע���Ȳ�����50�֣�',type:'alert'});
    var userID = session['LOGON.USERID'];
    $cm({
        ClassName: "Nur.InService.AppointManageV2",
        MethodName: "editIPAppointmentInfo",
        BookNO: BookNo,
        AppointName: AppointName,
        AppointPhone: AppointPhone,
        Remark: Remark,
        UserID: userID
    }, function (jsonData) {
        if (jsonData == 0) {
            if (1!=flag) {
                $.messager.popover({
                    msg: '��Ϣ�޸ĳɹ���',
                    type: 'success'
                });
            }
            //$("#editAppointBtn").linkbutton('enable');
            $("#editAppointBtn").show();
        } else {
            var title='��Ϣ�޸�ʧ��';
            if (jsonData == 100) {
                title='��Ϣ�޸���ʾ';
                jsonData="δ����Ϣ���Ķ���";
            }
            $.messager.show({
                title: title,
                msg: jsonData,
                timeout: 5000,
                showType: 'slide'
            });
        }
    });
}
function initBookNotesListGrid(data){
	var Columns=[[ 
		{ field: 'Notes', title: '��ע��¼����',width:120},
		{ field: 'date', title: '��ע����',width:155},
		{ field: 'Operator', title: '��¼��',width:80}
		
    ]];
	$('#BookNotesList').datagrid({ 
		//title:'��ע��¼�б�',
		headerCls:'panel-header-gray', 
		fit : true,
		border:false,
		width : 'auto',
		striped : true,
		singleSelect : true,
		fitColumns : false,
		autoRowHeight : false,
		loadMsg : $g('������..'),  
		pagination : false, 
		rownumbers : false,
		idField:"id",
		columns :Columns,
		titleNoWrap:false,
		nowrap:false,  /*�˴�Ϊfalse*/
		data:data,
		onLoadSuccess:function(data){
			$('#BookNotesList').datagrid("unselectAll");
		}
	})
}
function initBookAssess(refreshAssessChkItem){
	$cm({
        ClassName: "Nur.InService.AppointManageV2",
        MethodName: "GetIPBookAssessData",
        BookNo: BookNo
    }, function(data) {
	    if (refreshAssessChkItem =="Y"){
		    var ItemData=data.ItemData;
		    if (ItemData){
		    	var AssessCheckedItems=ItemData.AssessCheckedItems;
		    	if (AssessCheckedItems){
			    	for (var i=0;i<AssessCheckedItems.split("^").length;i++){
				    	$("#"+AssessCheckedItems.split("^")[i]).checkbox("check");
				    }
			    }
			    var chk=$("input[type='checkbox']");
			    var checkedchk=$("input[type='checkbox']:checked");
				if (checkedchk.length == (chk.length-1)){
					$("#ckAll").checkbox("check");
				}
		    }
		}
		initBookNotesListGrid(data.GridData);
    });
}