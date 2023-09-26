/**
 * ģ��:     ��Һ����
 * ��д����: 2018-03-26
 * ��д��:   yunhaibao
 */
var SessionLocId = session['LOGON.CTLOCID'];
var TimeRange=10000;
var PageSize=30;
var PageList=[];
PageList[0]=PageSize;
$(function() {
	InitPivasSettings();
    InitScreenContent();
    InitSwitchBat();
    InitGridWardState();
    RefreshTime();
    PIVAS.FullScreen();
 	TimeDisHandler();
});
function TimeDisHandler(){
	$("#timeDis").width("0px")
	$("#timeDis").animate({width:"100%"},TimeRange,"",function(){
		QueryWardState();
		TimeDisHandler();
	});
}
function InitGridWardState() {
    $.cm({
        ClassName: "web.DHCSTPIVAS.ScreenWardState",
        MethodName: "ColumnsWardState",
        locId: SessionLocId,
    }, function(retJson) {
        var columnsArr = [retJson];
        var dataGridOption = {
			url: PIVAS.URL.COMMON + '?action=JsGetScreenWardState',
            fit: true,
            rownumbers: false,
            columns: columnsArr,
            pageNumber:0,
            pageSize: PageSize,
            pageList: PageList,
            pagination: true,
            singleSelect: false,
            onLoadSuccess: function() {}
        };
        DHCPHA_HUI_COM.Grid.Init("gridWardState", dataGridOption);
	 	$("#gridWardState" ).datagrid('getPager').pagination({
			onSelectPage:function(pageNumber, pageSize){
				/*���Ǵ��¼�,����ѡ��ҳʱ�������ݿ�*/
			}
		});
    });
}

function QueryWardState() {
	var pageOptions=$("#gridWardState" ).datagrid('getPager').data("pagination").options;
	var total=pageOptions.total;
	var pageSize=pageOptions.pageSize;
	var pageNumber=pageOptions.pageNumber;
	var pageInt=parseInt(total/pageSize);
	var pageRem=total%pageSize;
	var pages=0;
	if (pageRem>0){
		pages=pageInt+1;
	}else{
		pages=pageInt;
	}
	// û��¼ʱ,���һҳʱ
	if ((pages==0)||(pageNumber==pages)){
		pageNumber=0;
	}else{
		pageNumber++;
	}
    var batNoStr = "";
    $("#swcBatNoList [id*='swcBatNo']").each(function() {
        var isOff = $("#" + this.id + " div").hasClass("switch-off")
        if (isOff != true) {
            var swcVal = $("#" + this.id).attr("value");
            batNoStr = (batNoStr == "") ? swcVal : batNoStr + "," + swcVal;
        }
    });
    $("#gridWardState").datagrid('getPager').pagination('select', pageNumber);
    $('#gridWardState').datagrid("load",{
        params: SessionLocId + "^" + batNoStr
    });
}

function RefreshTime() {
    setInterval(function() {
        var curNow = new Date();
        var week;
        switch (curNow.getDay()) {
            case 1:
                week = "��һ";
                break;
            case 2:
                week = "�ܶ�";
                break;
            case 3:
                week = "����";
                break;
            case 4:
                week = "����";
                break;
            case 5:
                week = "����";
                break;
            case 6:
                week = "����";
                break;
            default:
                week = "����";
        }
        var years = curNow.getFullYear();
        var month = add_zero(curNow.getMonth() + 1);
        var days = add_zero(curNow.getDate());
        var hours = add_zero(curNow.getHours());
        var minutes = add_zero(curNow.getMinutes());
        var seconds = add_zero(curNow.getSeconds());
        //var ndate = years + "-" + month + "-" + days;
        var ndate = $.fn.datebox.defaults.formatter(new Date()) + " " + week;
        $("#clockTime").html(hours + ":" + minutes + ":" + seconds)
        $("#clockDate").html(ndate)
    }, 1000);
}

function add_zero(temp) {
    if (temp < 10) return "0" + temp;
    else return temp;
}

/// ��ʼ��������ʾ
function InitScreenContent() {
    $.cm({
        ClassName: "web.DHCSTPIVAS.Settings",
        MethodName: "LogonData",
        locId: SessionLocId,
    }, function(jsonData) {
        $("#txtHospName").text(jsonData.HOSPDESC);
        $("#txtLocName").text(jsonData.CTLOCDESC);
    });
}

/// ��ʼ������switch
function InitSwitchBat() {
    $.m({
        ClassName: "web.DHCSTPIVAS.Common",
        MethodName: "PivasLocBatList",
        pivasLoc: SessionLocId
    }, function(retData) {
        var retDataArr = retData.split("^");
        for (var i = 1; i <= retDataArr.length; i++) {
            var batNoArr = retDataArr[i - 1].split(",");
            var batId = batNoArr[0];
            var batDesc = batNoArr[1];
            var switchHtml = '<div id="swcBatNo' + batId + '" value=' + batDesc + ' style="margin-left:20px;margin-top:4px;float:left"></div>'
            $("#swcBatNoList").append(switchHtml);
            $HUI.switchbox("#swcBatNo" + batId, {
                onText: batDesc,
                offText: batDesc,
                size: "small",
                animated: true,
                // onClass: "info",
                offClass: "warning",
                checked: true
            });
        }
    })
}

// ��ʼ��Ĭ������
function InitPivasSettings() {
    var retJson=$.cm({
        ClassName: "web.DHCSTPIVAS.Settings",
        MethodName: "GetAppProp",
        userId: session['LOGON.USERID'],
        locId: session['LOGON.CTLOCID'],
        appCode: "ScreenWardState"
    }, false);
    if (retJson){
	    var pageSize=retJson.PageSize;
	    if (pageSize!=""){
			PageSize=pageSize;
			PageList[0]=PageSize;
	    }
	}
}