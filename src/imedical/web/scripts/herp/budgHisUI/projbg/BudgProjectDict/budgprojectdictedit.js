var userid = session['LOGON.USERID'];
var username=session['LOGON.USERNAME'];
var hospid=session['LOGON.HOSPID'];
projEditFun = function (row) {

	var tmphospital 	= row.CompName;
	var rowid 			= row.rowid;
	var tmpyear 		= row.year;
	var tmpdeptdr 		= row.deptdr; // 责任科室
	var tmpuserdr 		= row.userdr; // 负责人
	var tmpproperty 	= row.property; // 项目性质
	var tmpisgovbuy 	= row.isgovbuy; // 政府采购
	var tmpstate 		= row.state; // 项目状态
	var tmppretype 		= row.pretype; // 编制方式
	var tmpbudgvalue 	= row.budgvalue; // 总预算
	var tmpblancetype 	= row.blancetype; // 预算结余计算方式
	var tmpspellcode 	= row.spellcode; // 拼音码
	var tmpbdeptdr 		= row.budgDeptDR; // 预算科室
	var tmpdesc			= row.goal;	//项目说明
	var tmpname			= row.name;  //项目名称
	var tmpcode 		= row.code;  //项目编号
	var tmpplansdate	=row.plansdate; //计划开始时间
	var tmpplanedate	=row.planedate; //计划结束时间
	var tmprealsdate	=row.realsdate; //实际开始时间
	var tmrealedate		=row.realedate; //实际结束时间

    // 年度的下拉框
    var EditYMObj = $HUI.combobox("#EditYM",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        value: tmpyear,
        onBeforeLoad:function(param){
            param.str = param.q;
        }
    });
    // 编制方式的下拉框
    var EditModelObj = $HUI.combobox("#EditModel",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: tmppretype,
        data: [{
                    'rowid': 1,
                    'name': "自上而下"
                },{
                    'rowid': 2,
                    'name': "自下而上"
        }],
        onSelect: function(rec){
            if(rec.rowid==1){
                $("#EditBgTotal").attr("disabled",true);
            }else{
                $("#EditBgTotal").attr("disabled",false);
            }              
        }
     });
    // 结余计算方式的下拉框
    var EditBanTyObj = $HUI.combobox("#EditBanTy",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: tmpblancetype,
        data: [{
                    'rowid': 1,
                    'name': "按总预算计算"
                },{
                    'rowid': 2,
                    'name': "按明细项计算"
        }]
     });
    // 责任科室的下拉框
    var EditDutyDRObj = $HUI.combobox("#EditDutyDR",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        value:tmpdeptdr,
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 3;
            param.str = param.q;
        }
    });
    // 预算科室的下拉框
    var EditDeptObj = $HUI.combobox("#EditDept",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        value:tmpbdeptdr,
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 1;
            param.str = param.q;
        }
    });
    // 负责人的下拉框
    var EditUserObj = $HUI.combobox("#EditUser",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        value:tmpuserdr,
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.str    = param.q;
        }
    });
    // 项目性质的下拉框
    var EditProjTyObj = $HUI.combobox("#EditProjTy",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value:tmpproperty,
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
    var EditGovBuyObj = $HUI.combobox("#EditGovBuy",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value:tmpisgovbuy,
        data: [{
                    'rowid': 1,
                    'name': "是"
                },{
                    'rowid': 2,
                    'name': "否"
        }]
     });
    // 项目状态的下拉框
    var EditStateObj = $HUI.combobox("#EditState",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value:tmpstate,
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
    // 文本框赋值或表单事件
	if(tmppretype==1){
        $("#EditBgTotal").attr("disabled",true);
    }else{
        $("#EditBgTotal").attr("disabled",false);
    }
    var tmpdesc			= row.goal;	//项目说明
	var tmpname			= row.name;  //项目名称
	var tmpcode 		= row.code;  //项目编号
	var tmpplansdate	=row.plansdate; //计划开始时间
	var tmpplanedate	=row.planedate; //计划结束时间
	var tmprealsdate	=row.realsdate; //实际开始时间
	var tmrealedate		=row.realedate; //实际结束时间
	$("#EditcoTxtA").val(tmpcode);
	$("#EditnaTxtA").val(tmpname);
	$("#EditspellA").val(tmpspellcode);
	$("#EditDesc").val(tmpdesc);
	$("#EditBgTotal").val(tmpbudgvalue);
	$("#EditPSDate").datebox('setValue',tmpplansdate);
    $("#EditPEDate").datebox('setValue',tmpplanedate);
    $("#EditRSDate").datebox('setValue',tmprealsdate);
    $("#EditREDate").datebox('setValue',tmrealedate);

    $('#EditnaTxtA').keyup(function(event){
        $('#EditspellA').val(makePy($('#EditnaTxtA').val().trim()));
    })
    var $win;
    $win = $('#EditWin').window({
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
            $('#EditcoTxtA').val("");  //项目编号
            $('#EditnaTxtA').val("");  //项目名称
            $('#EditspellA').val("");  //拼音码
            $('#EditDesc').val("");    //项目说明
            $('#EditBgTotal').val(""); //项目总预算
            $("#EditBgTotal").attr("disabled",false);
            $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
    });
    $win.window('open');

    //保存设置 
    $("#EditSave").unbind('click').click(function(){
        var BStdate="",BEddate=""
        var code = $('#EditcoTxtA').val();
        var name = $('#EditnaTxtA').val();
        var year = $('#EditYM').combobox('getValue');
        var deptdr = $('#EditDutyDR').combobox('getValue'); //责任科室
        var budgdeptdr = $('#EditDept').combobox('getValue'); //预算科室
        var userdr = $('#EditUser').combobox('getValue'); //直接默认当前登录人id //userCmbA.getValue();
        var spellcode = $('#EditspellA').val();
        var goal = $('#EditDesc').val();
        var property = $('#EditProjTy').combobox('getValue');
        var isgovbuy = $('#EditGovBuy').combobox('getValue');
        var state = $('#EditState').combobox('getValue');

        var plansdate = $('#EditPSDate').datebox('getValue');
        var planedate = $('#EditPEDate').datebox('getValue');
        var realsdate = $('#EditRSDate').datebox('getValue');
        var realedate = $('#EditREDate').datebox('getValue');
        var pretype = $('#EditModel').combobox('getValue');
        var budgvalue = $('#EditBgTotal').val(); 
        var blancetype = $('#EditBanTy').combobox('getValue');
        if ((plansdate > planedate) || (realsdate > realedate)) {
            var message = "开始时间不能大于结束时间!";
            $.messager.alert('提示',message,'info');
            return false;
        }
        $.m({
            ClassName:'herp.budg.udata.uBudgProjectDict',MethodName:'UpdateRec',rowId:rowid,hospid:hospid,code:code,name:name, 
            	year:year, bdeptdr:budgdeptdr, deptdr:deptdr,plansdate:plansdate,planedate:planedate,realsdate:realsdate,
            	realedate:realedate, userdr:userdr, goal:goal, property:property, isgovbuy:isgovbuy,state:state, 
            	loginuser:userid,hospital1:hospid,budgvalue:budgvalue,pretype:pretype,blancetype:blancetype,spellcode:spellcode},
            function(Data){
                if(Data==0){
                    $.messager.alert('提示','修改成功！','info');
                }else{
                    $.messager.alert('提示','错误信息:' +Data,'error');
                }
            }
        );
        $win.window('close');
    });

    $("#EditClose").unbind('click').click(function(){
        $win.window('close');
    });
}