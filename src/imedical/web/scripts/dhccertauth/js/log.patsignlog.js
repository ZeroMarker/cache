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
            initPatSignLogGrid(selHospID);
        }
        hospComp.options().onLoadSuccess = function(){
            selHospID = hospComp.getValue()
            initPatSignLogGrid(selHospID);
        }
    }
    else
    {
        $("#hospDiv").hide();
        $('#hospDiv').panel('resize', {height: 0});
        $('body').layout('resize');
        selHospID = logonInfo.HospID;
        initPatSignLogGrid(selHospID);
    }
})

function initBTN(){
    $("#btnQuery").click(function(){queryPatSignLog();});
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

function initPatSignLogGrid(selHospID) {
    var param = {p1:defaultParam};
    $('#dgLog').datagrid({
        fit:true,
        border:false,
        fitColumns:false,
        url: "../CA.Ajax.Cfg.cls?OutputType=Stream&Class=CA.BL.Config&Method=GetPatSignLog",
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
            {field:'ID',title:'签名表ID',align:'center'},
            {field:'EpisodeID',title:'就诊号',align:'center',align:'center'},
            {field:'Name',title:'患者姓名',align:'center',align:'center'},
            {field:'Gender',title:'性别',align:'center',align:'center'},
            {field:'Age',title:'年龄',align:'center',align:'center'},
            {field:'RegNo',title:'登记号',align:'center',align:'center'},
            {field:'AdmDateTime',title:'就诊日期时间',align:'center',align:'center'},
            //{field:'PatInfo',title:'患者信息(姓名|性别|年龄|登记号|就诊日期)',align:'center',align:'center'},
            {field:'Model',title:'产品组',align:'center',align:'center',width:100},
            {field:'SignDateTime',title:'发起签名日期时间',align:'center'},
            //{field:'UserCode',title:'发起签名用户工号',align:'center'},
            //{field:'UserName',title:'发起签名用户姓名',align:'center'},
            {field:'UserCodeName',title:'发起签名用户工号/姓名',align:'center'},
            {field:'UpdateDateTime',title:'最后一次修改日期时间',align:'center'},
            //{field:'UpdateUserCode',title:'最后一次修改用户工号',align:'center'},
            //{field:'UpdateUserName',title:'最后一次修改用户姓名',align:'center'},
            {field:'UpdateUserCodeName',title:'最后一次修改用户工号/姓名',align:'center'},
            {field:'Status',title:'当前状态',align:'center'},
            {
                field: 'ViewPDF',
                title: '查看PDF内容',
                align: 'center',
                width: 200,
                formatter: function(value,row,index) {
		            var str = '<a class="hisui-linkbutton l-btn l-btn-small l-btn-plain" style="width: 150px;" href="#" onclick="viewPDF('+row.ID+')" group=""><span class="l-btn-left l-btn-icon-left"><span class="l-btn-text">点击查看PDF内容</span><span class="l-btn-icon icon-green-line-eye">&nbsp;</span></span></a>'
		            return str;  
                }
            },
            {field:'SignDataType',title:'签名方式',align:'center'},
            {field:'SignVender',title:'厂商',align:'center'},
            {field:'BusinessIndex',title:'HIS签名业务ID',align:'center',align:'center',width:100},
            {field:'BusinessDesc',title:'HIS签名业务描述',align:'center',align:'center',width:150},
            //{field:'BusinessGUID',title:'发起签名业务流水号',align:'center',align:'center',width:350},
            //{field:'CABusinessGUID',title:'CA签名业务流水号',align:'center',align:'center',width:350},
            //{field:'CAFileGUID',title:'CA签署文件编号',align:'center',align:'center',width:350}
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

function queryPatSignLog() {
    //增加限制条件，比如开始日期\结束日期与签名ID室不能同时为空
    //控制查询天数
    var signID = $("#SignID").val();
    var userCode = $("#UserCode").val();
    var userName = $("#UserName").val();
    var episodeID = $("#EpisodeID").val();
    
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
        else if ((userCode == "")&&(userName == "")&&(episodeID == ""))
        {
            $.messager.alert('提示','通过时间段查询时，工号、姓名、就诊号不能同时为空');
        }
        else
        {
            var para = "";
            var obj = {SignID:signID,EpisodeID:episodeID,UserCode:userCode,UserName:userName,Model:model,StartDate:dateFormat(startDate),EndDate:dateFormat(endDate),HospID:selHospID};
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
    $("#EpisodeID").val('');
    $('#ModelList').combobox('setValue','');
    $("#EndDate").datebox('setValue','Today');
    setStartData();
}

function viewPDF(patSignID) {
    var content = '<iframe id="viewPDFFrame" scrolling="auto" frameborder="0" src="dhc.certauth.log.viewpdf.csp?PatSignID='+patSignID+'&MWToken='+getMWToken()+'" style="width:100%; height:100%;"></iframe>';
	createModalDialog("viewPDF","查看PDF内容",window.screen.width-500,window.screen.height-300,'viewPDFFrame',content,'','','true');
}

function documentOnKeyDown(e) {
    if (window.event){
        var keyCode=window.event.keyCode;
    }else{
        var keyCode=e.which;
    }
    
    if (keyCode==13) {
        queryPatSignLog();
    }
    
}
