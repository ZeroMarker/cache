/**
 * 模块:     制剂统计
 * 编写日期: 2018-08-24
 * 编写人:   zhaozhiduan
 */
var SessionLoc = session['LOGON.CTLOCID'];
$(function() {
	InitDict();
   
    $("#btnFind").on('click', Query)
    $("iframe").attr("src", DHCST.RunQianBG);
    /*
    $('#tabsWardBat').tabs({
        onSelect: function(title) {
            // IE切换Tab需要重设宽度
            $("#tabWardBatGrp").width("1000px");
            $("#tabWardBatTbl").width("1000px");
            $("#tabWardBatIncTbl").width("1000px");
        }
    });*/
})
function InitDict()
{
	DHCST.ComboBox.Init({ Id: 'cmbLoc', Type: 'Loc' }, {placeholder: "制剂科室...",
	    editable: true,
	    onLoadSuccess: function() {
	        var datas = $("#cmbLoc").combobox("getData");
	        for (var i = 0; i < datas.length; i++) {
	            if (datas[i].RowId == SessionLoc) {
	                $("#cmbLoc").combobox("setValue", datas[i].RowId);
	                LocFlag=1
	                break;
	            }
	        }
	    },
	    onSelect: function(data) {
	       
	    }
	});
	$("#txtStartDate").datebox("setValue",GetDate(-3));
    $("#txtEndDate").datebox("setValue", GetDate(0));
}
function GetDate(val){
	return tkMakeServerCall("web.DHCST.ManuOrder","DateChange",val);
}

function Query() {
    var startDate = $("#txtStartDate").datebox("getValue");
    var endDate = $("#txtEndDate").datebox("getValue");
    var LocId = $("#cmbLoc").combobox("getValue");
    if((LocId=="")||(LocId==undefined)){
		$.messager.alert('提示', '请选择制剂科室！', 'warning');
		return;
	}
    var tabTitle = $('#tabsInManu').tabs('getSelected').panel('options').title;
    if (tabTitle == "制剂统计") {
	    var raqObj = {
            raqName: "DHCST_InManu_ManuStat_Common.raq",
            raqParams: {
                startDate: startDate,        	
                endDate:endDate,       	 	
                Loc:LocId
            },
            isPreview: 1,
            isPath: 1
        };
        var raqSrc = DHCST.RaqPrint(raqObj)
        $("#tabInManuStat iframe").attr("src", raqSrc);
    }else if (tabTitle == "制剂明细统计") {
	    var raqObj = {
            raqName: "DHCST_InManu_ManuBatStat_Common.raq",
            raqParams: {
                startDate: startDate,        	
                endDate:endDate,       	 	
                Loc:LocId
              
            },
            isPreview: 1,
            isPath: 1
        };
        var raqSrc = DHCST.RaqPrint(raqObj)
        $("#tabInManuBatStat iframe").attr("src", raqSrc);
    }
    
    
    
    
}