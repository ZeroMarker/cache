var selHospID = "";
var defaultParam = JSON.stringify({IsDefaultLoad:1});

$(function(){
    initBTN(); 
    initModelList();
 	resetCondition();
    document.onkeydown = documentOnKeyDown;
    
    if (sysOption.IsOnMulityHospMgr == "1")
    {
        var hospComp = GenHospComp("SS_User",logonInfo.UserID+'^'+logonInfo.GroupID+'^'+logonInfo.CTLocID+'^');  
        hospComp.options().onSelect = function(){
            selHospID = hospComp.getValue()
            initSignLogGrid(selHospID);
        }
        hospComp.options().onLoadSuccess = function(){
            selHospID = hospComp.getValue()
            initSignLogGrid(selHospID);
        }
    }
    else
    {
        $("#hospDiv").hide();
        $('#hospDiv').panel('resize', {height: 0});
        $('body').layout('resize');
        selHospID = logonInfo.HospID;
        initSignLogGrid(selHospID);
    }
})

function initBTN(){
    $("#btnQuery").click(function(){querySignLog();});
    $("#btnReset").click(function(){resetCondition();});
}

//根据结束日期，设置开始日期
function setStartData() {
    var startDate = $('#StartDate').datebox('getText');
    var endDate = $('#EndDate').datebox('getText');

    var days = getDateGap(startDate,endDate);
	if ((days < 3)&&(days >= 0))
		return;
	
    var n = 2;  //开始结束相差几天在这里设置
    var setStartDate = getStartDate(endDate,n);
    $("#StartDate").datebox('setValue',setStartDate);
}

//Desc:初始化产品组
function initModelList()
{
    $('#ModelList').combobox({
        url:"../CA.Ajax.Cfg.cls?OutputType=String&Class=CA.BL.Config&Method=GetModelList",
        valueField:'ID',  
        textField:'Text',
        width:155,
        panelHeight:350,
        filter: function(q, row){
            return (row["Text"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
        }
    }); 
}

function initSignLogGrid(selHospID) {
    var param = {p1:defaultParam};
    $('#dgLog').datagrid({
        fit:true,
        border:false,
        fitColumns:false,
        url: "../CA.Ajax.Cfg.cls?OutputType=Stream&Class=CA.BL.Config&Method=GetSignLog",
        queryParams: param,
        idField:'ID',
        singleSelect:true,
        pagination:true,
        rownumbers:true,
        pageSize:50,
        pageList:[2,10,30,50],
        beforePageText:'第',
        afterPageText:'页, 共{pages}页',
        displayMsg:'显示 {from} 到 {to} ,共 {total} 条记录',
        columns:[[
            {field:'ID',title:'签名ID',align:'center'},
            {field:'Model',title:'产品组',align:'center',align:'center',width:150},
            {field:'SignDateTime',title:'签名日期时间',align:'center'},
            {field:'UserCode',title:'用户工号',align:'center',width:100},
            {field:'UserName',title:'用户姓名',align:'center',width:100},
            {field:'SignType',title:'签名方式',align:'center'},
            {field:'SignVender',title:'厂商',align:'center'},
            {field:'CertName',title:'CA证书名',align:'center',align:'center',width:100},
            {field:'CertUserCode',title:'CA用户唯一标识',align:'center',align:'center',width:200},
            {field:'CertNo',title:'CA证书唯一标识',align:'center',align:'center',width:200}
        ]],
        onLoadError:function() {
            $.messager.alert("提示","证书数据加载失败");
        },
        onSelect:function(rowIndex,row){
        },
        onLoadSuccess:function(data){
            $("#dgLog").datagrid("clearSelections");
        }
    });
}

function querySignLog() {
    //增加限制条件，比如开始日期\结束日期与签名ID室不能同时为空
    //控制查询天数
    var signID = $("#SignID").val();
    var userCode = $("#UserCode").val();
    var userName = $("#UserName").val();
    
    var endDate = $('#EndDate').datebox('getText');
    var startDate = $('#StartDate').datebox('getText');
    
    var model = $("#ModelList").combobox('getValue');
    if (model == "undefined")
    {
        model = "";
    }
    
    if ((signID =="")&&((endDate == "")||(startDate == "")))
    {
        $.messager.alert('提示','开始日期\结束日期与签名ID不能为空');
        $('#dgLog').datagrid('load',{
            p1:defaultParam
        });
        return;
    }
    
    var days = getDateGap(startDate,endDate);
    if (signID =="")
    {
        if ((days >= 3))
        {
            $.messager.alert('提示','查询时间范围要在3天之内');
        }
        else if ((days < 0))
        {
	    	$.messager.alert('提示','结束日期不能早于开始日期');
	    }
        else if ((userCode == "")&&(userName == ""))
        {
            $.messager.alert('提示','通过时间段查询时，工号、姓名不能同时为空');
        }
        else
        {
            var para = "";
            var obj = {SignID:signID,UserCode:userCode,UserName:userName,Model:model,StartDate:dateFormat(startDate),EndDate:dateFormat(endDate),HospID:selHospID};
            para = JSON.stringify(obj);
            
            $('#dgLog').datagrid('load',{
                p1:para
            });
            return;
        }
        $('#dgLog').datagrid('load',{
            p1:defaultParam
        });   
    }
    else 
    {
        $.messager.popover({msg: '请注意：用户输入了签名ID，此次查询将直接通过签名ID进行查询，不考虑其他条件！',type: 'info',timeout: 3000,showType: 'show',style: {top: 200,left:(window.screen.width/2)-220}});
        var para = "";
        var obj = {SignID:signID,HospID:selHospID};
        para = JSON.stringify(obj);
        
        $('#dgLog').datagrid('load',{
            p1:para
        });
    }
}

function resetCondition() {
    $("#UserCode").val('');
    $("#UserName").val('');
    $("#SignID").val('');
    $('#ModelList').combobox('setValue','');
    $("#EndDate").datebox('setValue','Today');
    setStartData();
}

function documentOnKeyDown(e) {
    if (window.event){
        var keyCode=window.event.keyCode;
    }else{
        var keyCode=e.which;
    }
    
    if (keyCode==13) {
        querySignLog();
    }
    
}