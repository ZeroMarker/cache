/**
 * ģ��:     �Ƽ�ͳ��
 * ��д����: 2018-08-24
 * ��д��:   zhaozhiduan
 */
var SessionLoc = session['LOGON.CTLOCID'];
$(function() {
	InitDict();
   
    $("#btnFind").on('click', Query)
    $("iframe").attr("src", DHCST.RunQianBG);
    /*
    $('#tabsWardBat').tabs({
        onSelect: function(title) {
            // IE�л�Tab��Ҫ������
            $("#tabWardBatGrp").width("1000px");
            $("#tabWardBatTbl").width("1000px");
            $("#tabWardBatIncTbl").width("1000px");
        }
    });*/
})
function InitDict()
{
	DHCST.ComboBox.Init({ Id: 'cmbLoc', Type: 'Loc' }, {placeholder: "�Ƽ�����...",
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
		$.messager.alert('��ʾ', '��ѡ���Ƽ����ң�', 'warning');
		return;
	}
    var tabTitle = $('#tabsInManu').tabs('getSelected').panel('options').title;
    if (tabTitle == "�Ƽ�ͳ��") {
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
    }else if (tabTitle == "�Ƽ���ϸͳ��") {
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