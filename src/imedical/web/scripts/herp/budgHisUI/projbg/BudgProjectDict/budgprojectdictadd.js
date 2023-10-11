var userid = session['LOGON.USERID'];
var username=session['LOGON.USERNAME'];
var hospid=session['LOGON.HOSPID'];
projAddFun = function () {
    // 年度的下拉框
    var AddYMObj = $HUI.combobox("#AddYM",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        value: new Date().getFullYear(),
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
    // 编制方式的下拉框
    var AddModelObj = $HUI.combobox("#AddModel",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 2,
        data: [{
                    'rowid': 1,
                    'name': "自上而下"
                },{
                    'rowid': 2,
                    'name': "自下而上"
        }],
        onSelect: function(rec){
            if(rec.rowid==1){
                $("#AddBgTotal").attr("disabled",true);
            }else{
                $("#AddBgTotal").attr("disabled",false);
            }              
        }
     });
    // 结余计算方式的下拉框
    var AddBanTyObj = $HUI.combobox("#AddBanTy",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        data: [{
                    'rowid': 1,
                    'name': "按总预算计算"
                },{
                    'rowid': 2,
                    'name': "按明细项计算"
        }]
     });
    // 责任科室的下拉框
    var AddDutyDRObj = $HUI.combobox("#AddDutyDR",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 3;
            param.str = param.q;
        }
    });
    // 预算科室的下拉框
    var AddDeptObj = $HUI.combobox("#AddDept",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 1;
            param.str = param.q;
        }
    });
    // 负责人的下拉框
    var AddUserObj = $HUI.combobox("#AddUser",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        value:userid,
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.str    = param.q;
        }
    });
    // 项目性质的下拉框
    var AddProjTyObj = $HUI.combobox("#AddProjTy",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        data: [{
                    'rowid': 1,
                    'name': "一般性项目"
                },{
                    'rowid': 2,
                    'name': "基建项目"
                },{
                    'rowid': 3,
                    'name': "科研项目"
        }]
    });
    // 政府采购的下拉框
    var AddGovBuyObj = $HUI.combobox("#AddGovBuy",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        data: [{
                    'rowid': 1,
                    'name': "是"
                },{
                    'rowid': 2,
                    'name': "否"
        }]
     });
    // 项目状态的下拉框
    var AddStateObj = $HUI.combobox("#AddState",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value:1,
        data: [{
                    'rowid': 1,
                    'name': "新建"
                },{
                    'rowid': 2,
                    'name': "执行"
                },{
                    'rowid': 3,
                    'name': "完成"
                },{
                    'rowid': 4,
                    'name': "取消"
        }]
    });
    $('#naTxtAbox').keyup(function(event){
        $('#spellAbox').val(makePy($('#naTxtAbox').val().trim()));
    })
    var $win;
    $win = $('#AddWin').window({
        title: '添加项目信息',
        width: 650,
        height: 420,
        top: ($(window).height() - 420) * 0.5,
        left: ($(window).width() - 650) * 0.5,
        shadow: true,
        modal: true,
        iconCls: 'icon-save',
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        onClose:function(){ //关闭关闭窗口后触发
            $('#coTxtAbox').val("");  //项目编号
            $('#naTxtAbox').val("");  //项目名称
            $('#spellAbox').val("");  //拼音码
            $('#AddDesc').val("");    //项目说明
            $('#AddBgTotal').val(""); //项目总预算
            $("#AddBgTotal").attr("disabled",false);
            $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
    });
    $win.window('open');

    //保存设置 
    $("#AddSave").unbind('click').click(function(){
        var BStdate="",BEddate=""
        var code = $('#coTxtAbox').val();
        var name = $('#naTxtAbox').val();
        var year = $('#AddYM').combobox('getValue');
        var deptdr = $('#AddDutyDR').combobox('getValue'); //责任科室
        var budgdeptdr = $('#AddDept').combobox('getValue'); //预算科室
        var userdr = $('#AddUser').combobox('getValue'); //直接默认当前登录人id //userCmbA.getValue();
        var spellcode = $('#spellAbox').val();
        var goal = $('#AddDesc').val();
        var property = $('#AddProjTy').combobox('getValue');
        var isgovbuy = $('#AddGovBuy').combobox('getValue');
        var state = $('#AddState').combobox('getValue');

        var plansdate = $('#AddPSDate').datebox('getValue');
        var planedate = $('#AddPEDate').datebox('getValue');
        var realsdate = $('#AddRSDate').datebox('getValue');
        var realedate = $('#AddREDate').datebox('getValue');
        var pretype = $('#AddModel').combobox('getValue');
        var budgvalue = $('#AddBgTotal').val(); 
        var blancetype = $('#AddBanTy').combobox('getValue');
        var data = code + "^" + name + "^" + year + "^" + budgdeptdr + "^" + 
                 deptdr + "^" + userdr + "^" + goal + "^" + property + "^" + 
                 isgovbuy + "^" + state + "^" + plansdate + "^" + planedate + 
                 "^" + realsdate + "^" + realedate + "^" + userid + "^" + 
                 hospid + "^" + budgvalue + "^" + pretype + "^" + blancetype + "^" + spellcode;
        if ((plansdate > planedate) || (realsdate > realedate)) {
            var message = "开始时间不能大于结束时间!";
            $.messager.alert('提示',message,'info');
           return false;
        }
        $.m({
            ClassName:'herp.budg.udata.uBudgProjectDict',MethodName:'InsertRec',data:data},
            function(Data){
                if(Data==0){
                    $.messager.alert('提示','保存成功！','info');
                }else{
                    $.messager.alert('提示','错误信息:' +Data,'error');
                }
            }
        );
        $win.window('close');
    });

    $("#AddClose").unbind('click').click(function(){
        $win.window('close');
    });
}