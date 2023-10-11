var PrescNo='';
var prescNoStr=''
$(function () {
    //InitGridPrescList(); 
    //SetButAutty();
    PrescNo=ViewDMParamStr.split("!!")[0];
    prescNoStr=ViewDMParamStr
    QueryPrescDetail()
    ResizeHMPrescDispQuery();
})

function InitGridPrescList() {
    var columns = [{
            name: "TPatNo",
            index: "TPatNo",
            header: '登记号',
            width: 100,
            hidden: true
        },
        {
            name: "TPatName",
            index: "TPatName",
            header: '病人姓名',
            width: 80,
            align: 'left'
        },
        {
            name: "TPrescNo",
            index: "TPrescNo",
            header: '处方号',
            width: 120
        },
        {
            name: "TPatSex",
            index: "TPatSex",
            header: '性别',
            width: 60
        },
        {
            name: "TPatAge",
            index: "TPatAge",
            header: '年龄',
            width: 80
        },
        {
            name: "TDateDosing",
            index: "TDateDosing",
            header: '用药日期',
            width: 120
        },
        {
            name: "TDate",
            index: "TDate",
            header: '日期',
            width: 120,
            hidden:true
        }
    ];
    var jqOptions = {
        colModel: columns, 
        url: ChangeCspPathToAll(LINK_CSP) + '?ClassName=PHA.IP.Query.Disp&MethodName=GetINViewDMPrescList',	
        height: DhcphaJqGridHeight(1, 1),
        fit: true,
        multiselect: true,
        shrinkToFit: false,
        rownumbers: true,
        datatype: "local",
        pager: "#jqGridPager", 
        onSelectRow: function (id, status) {
            QueryGridDispSub()
        },
        loadComplete: function () {
            var grid_records = $(this).getGridParam('records');
            if (grid_records == 0) {
                $("#ifrm-presc").attr("src", "");
            } else {
                $(this).jqGrid('setSelection', 1);
            }
        }
    };
    $('#grid-presclist').dhcphaJqGrid(jqOptions);
}

function QueryGridDispSub() {
    var prescno = GetSelPrescNo();
    QueryPrescDetail(PrescNo);
}

function QueryPrescDetail() {
    $("#ifrm-presc").empty();
    var htmlstr = GetPrescHtml();
    $("#ifrm-presc").append(htmlstr);
}

function GetPrescHtml() {
    var prescno=prescNoStr.split("!!")[0];
    var DateDosing=prescNoStr.split("!!")[1];
    var phacId=prescNoStr.split("!!")[2];
    var cyflag = "";
    var phartype = "DHCINPHA";
    var useflag=3
    var paramsstr = phartype + "^" + prescno + "^" + cyflag+"^"+useflag+"^"+DateDosing+"^"+phacId;
    $("#ifrm-presc").attr("src", ChangeCspPathToAll("dhcpha/dhcpha.common.prescpreview.csp") + "?paramsstr=" + paramsstr + "&PrtType=DISPPREVIEW" + "&MWToken="+websys_getMWToken());
}


function GetSelPrescNo() {
    var selectid = $("#grid-presclist").jqGrid('getGridParam', 'selrow');
    var selrowdata = $("#grid-presclist").jqGrid('getRowData', selectid);
    var prescno = selrowdata.TPrescNo;
    return prescno;
}
function splitFormatter(cellvalue, options, rowObject) {
    if (cellvalue.indexOf("-") >= 0) {
        cellvalue = cellvalue.split("-")[1];
    }
    return cellvalue;
};
window.onresize = ResizeHMPrescDispQuery;
function ResizeHMPrescDispQuery(){
    var wardtitleheight = $("#gview_grid-presclist .ui-jqgrid-hbox").height();
    var wardheight = DhcphaJqGridHeight(1, 1) - wardtitleheight - 32;
    var prescheight = DhcphaJqGridHeight(1, 0) - 17;
    var admpressheight = DhcphaJqGridHeight(2, 1)*0.5 -47 ; ;
        //alert("admpressheight:"+admpressheight)
    $("#grid-presclist").setGridHeight(wardheight).setGridWidth("");
    $("#ifrm-presc").height(prescheight);
    $("#grid-admlist").setGridHeight(admpressheight).setGridWidth("");
    $("#grid-admpresclist").setGridHeight(admpressheight).setGridWidth("");
    
}

function QueryPrescList(Input){
	$("#grid-presclist").setGridParam({
        datatype: 'json',
        page: 1,
        postData: {
            'InputStr': Input
        }
    }).trigger("reloadGrid");
}

function BPrinttPresc(){
    PrintPresc(prescNoStr)    
}

function PrintPresc(prescnodatStr){
	var prescNo=prescnodatStr.split("!!")[0];
	var oeDateDosing=prescnodatStr.split("!!")[1];
	var phacId=prescnodatStr.split("!!")[2];
	var zfFlag = "底方"
	var prtData=tkMakeServerCall("web.DHCINPHA.Common.Print","PrescPrintData",prescNo,zfFlag,"","",oeDateDosing,phacId);
	if (prtData=="{}"){
		return;
	}
	var prtJson=JSON.parse(prtData);
	var xmlTrmplate = prtJson.Templet;
	if(!xmlTrmplate){ return; }
	PRINTCOM.XML({
		printBy: 'lodop',
		XMLTemplate: xmlTrmplate,
		data: prtJson
	});
}
