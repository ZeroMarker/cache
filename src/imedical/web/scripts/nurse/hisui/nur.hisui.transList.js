var GV = {
    _CALSSNAME: "Nur.DHCNurTransList",
    episodeID: "",
};
//var frm=dhcsys_getmenuform();

var init = function () {
	if (HISUIStyleCode!="lite") $("body").css("background-color","#fff");
    initPageDom();
    initBindEvent();
}
$(init)
function initPageDom() {
    initCondition();
    initTransPatGrid();
}
function initBindEvent() {
    $('#medTxt').bind('keydown', function (e) {
        var medNo = $('#medTxt').val();
        if (e.keyCode == 13 && medNo != "") {            
            initTransPatGrid();
        }
    });
    $('#dfugridSch').bind('click', TransPatGridReload);
}
/*----------------------------------------------------------------------------------*/
/**
 * @description 初始
 */
function initTransPatGrid() {
     var StDate = $('#stDate').datebox('getValue');
    var EndDate = $('#endDate').datebox('getValue');
    var Loc = $('#LocCom').combobox('getValue');
    var FromLoc = $('#FromLocCom').combobox('getValue');
    var ToLoc = $('#ToLocCom').combobox('getValue');
    var medNo = $('#medTxt').val();
                 
    $('#TransPatGrid').datagrid({
        url: $URL,
        queryParams: {
            ClassName: GV._CALSSNAME,
            QueryName: "QueryTransPatGrid",
            ResultSetType: 'array',
            StDate: StDate,
            EndDate: EndDate,
            Loc: Loc,
            FromLoc: FromLoc,
            ToLoc: ToLoc,
            MedNo: medNo
        },
        columns: [[
            { field: 'medCareNo', title: '病案号', width: 80 },
			{ field: 'regNo', title: '登记号', width: 120 },
            { field: 'patName', title: '姓名', width: 120 },
            { field: 'sex', title: '性别', width: 150 },
            { field: 'inHosDate', title: '住院日期', width: 180 },
            { field: 'fromLoc', title: '原科室名称', width: 220 },
            { field: 'toLoc', title: '转入科室名称', width: 220 },
            { field: 'transDateTime', title: '转移时间', width: 220 }
        ]],
        idField: 'OeoriId',
        selectOnCheck:false, 
		checkOnSelect:false,
		singleSelect:true, 
		fit:true,
		border:false
    });
}

/**
 * @description 初始化查询条件区
 */
function initCondition() {
    var hospId = session['LOGON.HOSPID'];
    $("#stDate,#endDate").datebox({});
    $('#stDate').datebox('setValue', formatDate(new Date()));
    $('#endDate').datebox('setValue', formatDate(new Date()));
    $('#LocCom').combobox({
        url: $URL + '?1=1&ClassName='+ GV._CALSSNAME + '&QueryName=FindLocs&hospId=' + hospId + '&ResultSetType=array',
        valueField: 'locID',
        textField: 'locDesc',
        defaultFilter:4,
        onLoadSuccess: function () { $('#LocCom').combobox('setValue', "")} //session['LOGON.CTLOCID']) }
    })
    $('#FromLocCom').combobox({
        url: $URL + '?1=1&ClassName=' + GV._CALSSNAME + '&QueryName=FindLocs&hospId=' + hospId + '&ResultSetType=array',
        valueField: 'locID',
        textField: 'locDesc',
        defaultFilter:4,
        onLoadSuccess: function () { $('#FromLocCom').combobox('setValue', "")} //session['LOGON.CTLOCID']) }
    })
    $('#ToLocCom').combobox({
        url: $URL + '?1=1&ClassName='+ GV._CALSSNAME +'&QueryName=FindLocs&hospId=' + hospId + '&ResultSetType=array',
        valueField: 'locID',
        textField: 'locDesc',
        defaultFilter:4,
        onLoadSuccess: function () { $('#ToLocCom').combobox('setValue', "")} //session['LOGON.CTLOCID']) }
    })
   
}
/**
 * @description 列表刷新
 */
function TransPatGridReload() {
    var StDate = $('#stDate').datebox('getValue');
    var EndDate = $('#endDate').datebox('getValue');
    var Loc = $('#LocCom').combobox('getValue');
    var FromLoc = $('#FromLocCom').combobox('getValue');
    var ToLoc = $('#ToLocCom').combobox('getValue');
    var medNo = $('#medTxt').val();
   
    $('#TransPatGrid').datagrid('reload',
        {
            ClassName: "Nur.DHCNurTransList",
            QueryName: "QueryTransPatGrid",
            ResultSetType: 'array',
            StDate: StDate,
            EndDate: EndDate,
            Loc: Loc,
            FromLoc: FromLoc,
            ToLoc: ToLoc,
            MedNo: medNo

        });
}
