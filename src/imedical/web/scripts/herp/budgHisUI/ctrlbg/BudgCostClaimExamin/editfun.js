/**
 *按钮权限说明
 *新建状态：增加、保存、删除均可用
 *其他：均不可用
 *
 **/
var yearmonth = "", deptId = "", auDeptId = "", userId = "", checkId = "",billstate=""
	var RowDelim = String.fromCharCode(1); //行数据间的分隔符
EditFun = function (itemGrid) {
	// console.info(itemGrid);
	var rowidm = itemGrid.rowid;
	var billcode = itemGrid.billcode;
	var yearmonth = itemGrid.checkyearmonth;
	var auDeptId = itemGrid.audeprdr;
	var deptId = itemGrid.deprdr;
	var userId = itemGrid.applyerdr;
	// var checkId = itemGrid.ChekFlowId;
	var payMeth = itemGrid.PayMeth;
	var applycode = itemGrid.applycode;
	var billstate=itemGrid.billstate;
    var IsCurStep=itemGrid.IsCurStep;
    var checkId = itemGrid.CheckDR;
    var BKCardNo = itemGrid.BKCardNo;
	// console.info(rowidm+"^"+billcode+"^"+yearmonth+"^"+auDeptId+"^"+deptId+"^"+userId+"^"+checkId+"^"+applycode+"^"+IsCurStep+"^"+BKCardNo)
	//初始化报销单窗口
	var $editwin;
	$editwin = $('#EditWin').window({
	    title: '查看/修改/打印报销单',
	    width: 1000,
	    height: 500,
	    top: ($(window).height() - 500) * 0.5,
	    left: ($(window).width() - 1000) * 0.5,
	    shadow: true,
	    modal: true,
	    iconCls: 'icon-w-edit',
	    closed: true,
	    minimizable: false,
	    maximizable: false,
	    collapsible: false,
	    resizable: true,
	    onClose:function(){ //关闭关闭窗口后触发
           $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
	});
	$editwin.window('open');
    // 表单的垂直居中
    //xycenter($("#Editnorth"),$("#Editform"));
	// $("#EditApplyC").attr("disabled",true);//申请单号不可编辑  $("#EditApplyC").attr({ readonly: 'true' });//将申请单号设置为readonly   //
	// $("#EditBank").attr("disabled",true);//银行不可编辑  
 //    $("#EditNumber").attr("disabled",true);//银行卡号不可编辑
    $("#EditChargeAgst").checkbox({
        onCheckChange:function(event,value){
            if(!value){
                $("#EditFundApply").attr("disabled",true);
            }else{
                $("#EditFundApply").attr("disabled",false);
            }
        }
    })
    $("#EditFundApply").focus(function(){
        //检查主表信息
        var OwnDR= $('#EditOwn').combobox('getValue'); 
        var UserDR= $('#EditUser').combobox('getValue');
        var DeptDR= $('#EditDept').combobox('getValue');
        if (!OwnDR) {
            var message = "请选择归口科室!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!UserDR) {
            var message = "请选择申请人!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!DeptDR) {
            var message = "请选择报销科室!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if(OwnDR&&UserDR&&DeptDR){
            //弹出待冲抵借款单
            var data = OwnDR+ "^" + UserDR+ "^" + DeptDR;
            var fundApplyNo =$("#EditFundApply");
            AddReqFun(fundApplyNo, data);
        }
        
    });       
    // 申请人的下拉框
    var EditUserObj = $HUI.combobox("#EditUser",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.str = param.q;
        },
        onSelect: function(rec){    
            $("#EditBank").val("");  //清空银行
            $("#EditNumber").val("");  //清空银行卡号          
            $("#EditFundApply").val("");  //清空借款单号
            if($('#EditPay').combobox('getValue')==2){
            	$.m({
	             	ClassName:'herp.budg.hisui.udata.uBudgCtrlFundBillMng',MethodName:'GetBankInfo',userID:rec.rowid},
	            	function(Data){
	    				$("#EditBank").val(Data.split("^")[0]);
	    				$("#EditNumber").val(Data.split("^")[1]);
					}
				);
            }            
        }        
    });
    // 申请科室的下拉框
    var EditDeptObj = $HUI.combobox("#EditDept",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 1;
            param.str    = param.q;
        },
        onSelect: function(rec){    
            $("#EditFundApply").val(""); //清空借款单号
        }
    });
    // 审批流的下拉框
    var EditCkFlowObj = $HUI.combobox("#EditCheckFlow",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgCtrlFundBillMng&MethodName=CheckList",
        mode:'remote',
        delay:200,
        // value:chekFlowInfo[1],
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.str    = param.q;
        }
    });
    // 申请年月的下拉框
    var EditYMObj = $HUI.combobox("#EditYM",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.flag = 1;
            param.str = param.q;
        },
        onSelect: function(rec){    
            //远程数据访问，返回非json格式
            $.m({
             	ClassName:'herp.budg.hisui.udata.uExpenseAccountDetail',MethodName:'GetClaimCode',yearmonth:rec.year},
            	function(Data){
            		var array=Data.split("^");
            		if(array[0]!=""){            			
            			$("#EditApplyC").val(array[0]);
                        EditMainGrid.load({
                            ClassName:"herp.budg.hisui.udata.uExpenseAccountDetail",
                            MethodName:"List",
                            hospid :    hospid, 
                            userdr :    userid,
                            billcode :  array[0]
                        })
            		}										
				}
			);
        }
    });
    // 支付方式的下拉框
    var EditPayObj = $HUI.combobox("#EditPay",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        data: [{
                    'rowid': 1,
                    'name': "现金"
                },{
                    'rowid': 2,
                    'name': "银行"
        }],
        onSelect: function(rec){    
            $("#EditBank").val("");  //清空银行
            $("#EditNumber").val("");  //清空银行卡号          
            if(rec.rowid==2){
            	$.cm({
	             	ClassName:'herp.budg.hisui.udata.uBudgCtrlFundBillMng',MethodName:'GetBankInfo',userID:$('#EditUser').combobox('getValue')},
	            	function(Data){
	    				$("#EditBank").val(Data.atnumber);
	    				$("#EditNumber").val(Data.openbank);
					}
				);
            }            
        }   
     });
    // 归口科室的下拉框
    var EditOwnObj = $HUI.combobox("#EditOwn",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.userdr = userid;
            param.flag   = 1;
            param.str    = param.q;
        },
        onSelect: function(rec){    
            // alert(rec.name);
            $("#EditFundApply").val(""); //清空借款单号
            $("#EditMainGrid").datagrid("reload");
        }
    });
    $("#EditApplyC").val(billcode);
    $("#EditYM").combobox('setValue',yearmonth);
    $("#EditDept").combobox('setValue',deptId);
    $("#EditOwn").combobox('setValue',auDeptId);
    $("#EditCheckFlow").combobox('setValue',checkId);
    $("#EditPay").combobox('setValue',payMeth);
    $("#EditUser").combobox('setValue',userId);
    $("#EditBank").val(itemGrid.BKName);
    $("#EditNumber").val(BKCardNo);
    $("#EditFundApply").val(applycode);
    $("#EditDesc").val(itemGrid.applydecl);
    var tmpapply=false;
    if (itemGrid.applydr){
        tmpapply=true;       
    }
    $("#EditChargeAgst").checkbox('setValue',tmpapply);
    //增加按钮
    $("#EditAddDetail").click(function(){
        AddRow()  //增加一行函数
    });    
    //保存按钮
    $("#EditSave").click(function(){
        if (checkBeforeSave() == true) {
            saveOrder(); //保存方法
        }else {
            return;
        }
    })
    //删除按钮
    $("#EditDelBt").click(function(){
        if (ChkBefDel() == true) {
                Del();
            } else {
                return;
            }
    });
    //列配置对象
    EditColumns=[[ 
        {field:'ckbox',checkbox:true},//复选框 
        {field:'rowid',title:'ID',width:30,hidden: true},
        {field:'billdr',title:'报销主表ID',width:80,hidden: true},
        {field:'itemcode',title:'预算项编码',align:'left',width:120,hidden: true},
        {field:'itemname',title:'预算项',align:'left',width:120,
			editor:{
				type:'combobox',
				options:{
					valueField:'rowid',
					textField:'name',
					url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgCtrlFundBillMng&MethodName=Getitemcode",
					delay:200,
                    onBeforeLoad:function(param){
                        param.year = $('#EditYM').combobox('getValue').substr(0, 4);   //预算期
                        param.userdr = userid;
                        param.hospid = hospid;
                        param.str    = param.q;
                        param.bgdeptdr = $('#EditOwn').combobox('getValue'); //归口科室
                    },
                    onSelect: function(rec){ 
                        var rowIndex=getRowIndex(this)
                        ItemSelect(rec.rowid,rec.name,rowIndex); /*预算项选择后，给当前预算结余和预算项编码赋值*/
                    },                             
                    required:true
				}
			}
        },
        {field:'balance',title:'目前预算结余',align:'right',width:120},
        {field:'reqpay',title:'本次报销申请',align:'right',width:120 },
        {field:'actpay',title:'审批支付',align:'right',width:120,
            editor: { type: 'numberbox', 
                options: { 
                    required: true,
                    precision:2,
                    onChange: function(){
                        var index=getRowIndex(this);
                        $('#EditMainGrid').datagrid('selectRow', index);
                    }
                }
            }
        },
        {field:'balance1',title:'审批后预算结余',align:'right',width:130},
        {field:'budgcotrol',title:'预算控制',align:'left',width:100,
            formatter:function(value,row,index){
                var sf = row.budgcotrol;
                    if (sf == "超预算") {
                        return '<span style="color:red;cursor:hand;">' + value + '</span>';
                    } else {
                        return '<span style="color:black;cursor:hand">' + value + '</span>';
                    }                            
           }
        },
        {field:'State',title:'状态',align:'left',width:80},
        {field:'reqpaydetinfo',title:'报销详情',align:'left',width:80,
                    formatter:function(value,row,index){
                        return '<span style="color:blue;cursor:hand;backgroundColor:red"><u>' + value + '</u></span>';
                    }}               
    ]];
    var editRow = undefined; //定义全局变量：当前编辑的行
    //定义表格
    var EditMainGrid = $HUI.datagrid("#EditMainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uExpenseAccountDetail",
            MethodName:"List",
            hospid :    hospid, 
            userid :    userid,
            billcode   : $('#EditApplyC').val() 
        },
        checkOnSelect: true, //选中行复选框勾选
        selectOnCheck: true, //选中行复选框勾选        
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        singleSelect: true, //多选，为true时只允许选中一行   若注释掉，默认单选
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:EditColumns,
        onCheck: function(index){ //在用户勾选一行的时候触发
            onCheckfun(index)
        },  
        striped : true,
        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发
            if ((field=="itemname")||(field=="actpay")) {
               onClickCell(index,field,1); 
            }else{
               onClickCell(index,field,""); 
            };
            var row = $('#EditMainGrid').datagrid('getSelected');
            var itemname="",reqtarget="",td="",div="";
            itemname=row.itemname;
            var str = new RegExp("差旅费");
            if((field=="reqpaydetinfo")&&(str.test(itemname))){
                // var reqtarget = $('#EditMainGrid').datagrid('getEditor', {'index':index,'field':'reqpay'}).target;
                var reqtd=$('.datagrid-body td[field="reqpay"]')[index];
                var reqdiv = $(reqtd).find('div')[0];                
                var td=$('.datagrid-body td[field="reqpaydetinfo"]')[index];
                var div = $(td).find('div')[0];
                $("#EditMainGrid").datagrid("endEdit", index);
                CostTravelPage(row.rowid,reqdiv,div,row,checkBeforeSave,saveOrder,itemGrid);
            }
        //     // $(this).datagrid('selectRow', index);
        //     // $(this).datagrid('beginEdit', index);
        //     // var ed = $(this).datagrid('getEditor', {index:index,field:reqpay});
        //     // $(ed.target).focus();
        },
        onBeforeEdit:function(rowIndex, rowData){
            if (checkBefEdit() == false) {
                return false;
            } else {
                return true;
            }            
        },
        toolbar: '#Editnorth'        
    });
    if((IsCurStep== 1)&&(billstate=="提交")){
        $("#EditYM").combobox("enable");
        $("#EditUser").combobox("enable");
        $("#EditDept").combobox("enable");
        $("#EditOwn").combobox("enable");
        $("#EditPay").combobox("enable");
        $("#EditCheckFlow").combobox("enable");
        $("#EditChargeAgst").checkbox("setDisable",false);//冲抵借款
        $("#EditFundApply").attr("disabled",false);//借款单号
        if (!tmpapply){
            $("#EditFundApply").attr("disabled",true);//借款单号            
        }
        $("#EditDesc").attr("disabled",false);
        $('#AddDetail').linkbutton("enable");
        $('#AddSave').linkbutton("enable");
        $('#DelBt').linkbutton("enable");
    }else{
        $("#EditYM").combobox("disable");
        $("#EditUser").combobox("disable");
        $("#EditDept").combobox("disable");
        $("#EditOwn").combobox("disable");
        $("#EditPay").combobox("disable");
        $("#EditCheckFlow").combobox("disable");
        $("#EditChargeAgst").checkbox("setDisable",true);//冲抵借款
        $("#EditFundApply").attr("disabled",true);//借款单号
        $("#EditDesc").attr("disabled",true);
		$('#AddDetail').linkbutton("disable");
		$('#AddSave').linkbutton("disable");
		$('#DelBt').linkbutton("disable");
	}
    /*函数区*/
    /*预算项选择后，给当前预算结余和预算项编码赋值*/
    function ItemSelect(itemcode,item,rowIndex){
        $('#EditMainGrid').datagrid('selectRow', rowIndex);
        var row = $('#EditMainGrid').datagrid('getSelected'); 
        if(row==null){
            $.messager.popover({
                msg: '请先勾选复选框!',
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
        }else{
           // var rowIndex = $('#EditMainGrid').datagrid('getRowIndex',row);//获取行号 
           var itemtd=$('.datagrid-body td[field="itemcode"]')[rowIndex];
           var itemtarget = $(itemtd).find('div')[0]
            $(itemtarget).text(itemcode);
            row['itemcode'] = itemcode; 
           var state = row.State;  //单据状态
           if(state==undefined){state="";}
           var rowid = row.rowid;  //rowid
           if(rowid==undefined){rowid="";}
           var billdr = row.billdr;  //单据状态
           if(billdr==undefined){billdr="";}
           var data =$('#EditOwn').combobox('getValue')+ "^" +$('#EditYM').combobox('getValue')
                    + "^" +itemcode+ "^" +state+ "^" + rowid + "^" + "Act" + "^" + billdr
                    + "^" + $('#EditChargeAgst').checkbox('getValue') + "^" +$("#EditFundApply").val()
            $.m({
                ClassName:'herp.budg.hisui.udata.uBudgCtrlFundBillMng',MethodName:'GetCurBalance',data:data},
                function(Data){
                    var array=Data.split("^");                    
                    var balancetd=$('.datagrid-body td[field="balance"]')[rowIndex];
                    var target = $(balancetd).find('div')[0];
                    $(target).text(array[1]);
                    row['balance'] = array[1];
                }
            );            
            var str = new RegExp("差旅费");
            // var reqtarget = $('#EditMainGrid').datagrid('getEditor', {'index':rowIndex,'field':'reqpay'}).target;
            var reqtd=$('.datagrid-body td[field="actpay"]')[rowIndex];
            var reqdiv = $(reqtd).find('div')[0];                            
            var td=$('.datagrid-body td[field="reqpaydetinfo"]')[rowIndex];
            var div = $(td).find('div')[0];
            if (str.test(item)) {
            	$("#EditMainGrid").datagrid("endEdit", rowIndex);
                CostTravelPage(rowid,reqdiv,div,row,checkBeforeSave,saveOrder,itemGrid);
            } else {
                $(div).text("");
                row['reqpaydetinfo'] = "";
                var ed2 = $('#EditMainGrid').datagrid('getEditor', { 'index': rowIndex, field: 'actpay' });
                $(ed2.target).attr("disabled", false);

            }
        }
    }
    /*编辑前检查主表信息是否完整*/
    function checkBefEdit(){
        //检查主表信息
        if (!$("#EditApplyC").val()) {
            var message = "请选择预算期生成报销单号!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#EditYM').combobox('getValue')) {
            var message = "请选择预算期!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#EditOwn').combobox('getValue')) {
            var message = "请选择归口科室!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#EditUser').combobox('getValue')) {
            var message = "请选择申请人!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#EditDept').combobox('getValue')) {
            var message = "请选择报销科室!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#EditCheckFlow').combobox('getValue')) {
            var message = "请选择审批流!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#EditPay').combobox('getValue')) {
            var message = "请选择支付方式!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#EditDesc').val()) {
            var message = "请填写报销说明!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
    }
    /*增加前检查主表信息是否完整*/
    function checkBefAdd(){
        //检查主表信息
        if (!$("#EditApplyC").val()) {
           return false;
        }
        if (!$('#EditYM').combobox('getValue')) {
            return false;
        }
        if (!$('#EditOwn').combobox('getValue')) {
           return false;
        }
        if (!$('#EditUser').combobox('getValue')) {
           return false;
        }
        if (!$('#EditDept').combobox('getValue')) {
           return false;
        }
        if (!$('#EditCheckFlow').combobox('getValue')) {
          return false;
        }
        if (!$('#EditPay').combobox('getValue')) {
           return false;
        }
        if (!$('#EditDesc').val()) {
           return false;
        }
    } 
    /*保存前数据检查*/
    function checkBeforeSave(){
        //检查主表信息
        if (!$("#EditApplyC").val()) {
            var message = "请选择预算期生成报销单号!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#EditYM').combobox('getValue')) {
            var message = "请选择预算期!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#EditOwn').combobox('getValue')) {
            var message = "请选择归口科室!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#EditUser').combobox('getValue')) {
            var message = "请选择申请人!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#EditDept').combobox('getValue')) {
            var message = "请选择报销科室!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#EditCheckFlow').combobox('getValue')) {
            var message = "请选择审批流!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#EditPay').combobox('getValue')) {
            var message = "请选择支付方式!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (!$('#EditDesc').val()) {
            var message = "请填写报销说明!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        if (($('#EditChargeAgst').checkbox('getValue')==true)&&(!$("#EditFundApply").val())) {
            var message = "请选择对应冲抵借款单!";
            $.messager.popover({
                msg: message,
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
           return false;
        }
        //检查明细信息
        // 1.判断明细信息是否为空
        return true;
    }
    //点击一行时，如果为合计行，则不可编辑；否则可编辑。
    function onClickCell(index,field,flag){
        // console.log(2)
    	$('#EditMainGrid').datagrid("clearSelections");
    	var indexs=$('#EditMainGrid').datagrid('getEditingRowIndexs')
    	if(indexs.length>0){
	    	for(i=0;i<indexs.length;i++){
	    		$("#EditMainGrid").datagrid("endEdit", indexs[i]);
	    	}
    	}
        $('#EditMainGrid').datagrid('selectRow', index);
        var row = $('#EditMainGrid').datagrid("getSelected");
        if(row!=null){
            if(row.itemname=="合计"){
               $('#EditMainGrid').datagrid('unselectRow', index);  //取消选择一行。合计行不可选
            }else{
                if((flag==1)&&(IsCurStep== 1)&&(billstate=="提交")){
                    // $('#EditMainGrid').datagrid('beginEdit', index); //当前行开启编辑
                    itemname=row.itemname;
                    var str = new RegExp("差旅费");
                    var strtest=str.test(itemname);
                    if(!strtest){
                       $('#EditMainGrid').datagrid('beginEdit', index); //当前行开启编辑 
                    }
                    if(strtest&&(field=="itemname")){
                       $('#EditMainGrid').datagrid('beginEdit', index); //当前行开启编辑
                       var ed2 = $('#EditMainGrid').datagrid('getEditor', { 'index': index, field: 'actpay' });
                       $(ed2.target).attr("disabled", true); 
                    }
                    
                }                
            }
        }                
    }    
    //用户勾选一行的时候触发，如果为合计行，则不可编辑；否则可编辑。
    var onCheckfun = function(rowIndex){ //在用户勾选一行的时候触发
        var rowsData = $('#EditMainGrid').datagrid('getRows');
            if(rowsData[rowIndex].itemname=="合计"){
               $('#EditMainGrid').datagrid('unselectRow', rowIndex);  //取消选择一行。合计行不可选
            }
    }             
    //增加一行方法
    function AddRow(){
        // 添加时先判断是否有开启编辑的行，如果有则把开户编辑的那行结束编辑
        if ((editRow != undefined)||(checkBefAdd() == false)) {
            $("#EditMainGrid").datagrid("endEdit", editRow);
            if(checkBefEdit() == false){editRow = undefined;}
        }
        //添加时如果没有正在编辑的行，则在datagrid的第一行插入一行
        else{
            $("#EditMainGrid").datagrid("insertRow", {
                index: 0, // index start with 0
                row: {
                    rowid:'',
                    billdr:'',
                    itemcode:'',
                    itemname:'',
                    balance:'',
                    reqpay:'',
                    actpay:'',
                    balance1:'',
                    budgcotrol:'',
                    State:'',
                    reqpaydetinfo:''
                }
            });
            $("#EditMainGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
            $("#EditMainGrid").datagrid('selectRow', 0);
            //将新插入的那一行开户编辑状态
            $("#EditMainGrid").datagrid("beginEdit", 0);
            //给当前编辑的行赋值
            editRow = 0;
        }
    }
    $("#EditClose").click(function(){
        $editwin.window('close');
    });
    //保存报销单 
    function saveOrder(){
        var row = $('#EditMainGrid').datagrid("getSelected"); 
        if(row==null){
            $.messager.popover({
                msg: '请先选中一行数据!',
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
        }else{
            var rowIndex = $('#EditMainGrid').datagrid('getRowIndex',row);//获取行号 
            $('#EditMainGrid').datagrid('endEdit',rowIndex);  //结束行编辑
            /////////////报销主表信息////////////////
            var datam = $("#EditApplyC").val() //报销单号
                 + "|" + $('#EditYM').combobox('getValue') //预算期
                 + "|" + $('#EditDept').combobox('getValue') //报销科室
                 + "|" + $('#EditUser').combobox('getValue') //申请人
                 + "|" + $('#EditDesc').val().replace(/(^\s*)|(\s*$)/g, "") //报销说明
                 + "|" + $("#EditFundApply").val() //借款单号
                 + "|" + checkId
                 + "|" + $('#EditOwn').combobox('getValue')  //归口科室
                 + "|" + userid
                 + "|" + $('#EditPay').combobox('getValue') //支付方式
                 + "|" + $("#EditBank").val() //银行
                 + "|" + $("#EditNumber").val() //银行卡号
                 + "|" + hospid; //医院id
            var rowsData = $('#EditMainGrid').datagrid('getRows');
            var data=rowsData[rowIndex];
            // console.log(data)
            /////////////报销明细表信息////////////////
            var rowInfo = data.billdr
                 + "|" + data.itemcode
                 + "|" + data.reqpay
                 + "|" + data.actpay
                 + "|" + data.balance
                 + "|" + data.State
                 + "|" + data.rowid
                 + "|" + data.reqpaydetinfo
            $.m({
                ClassName:'herp.budg.hisui.udata.uExpenseAccountDetail',MethodName:'Save',rowidm:rowidm,datam:datam,datad:rowInfo},
                function(Data){
                    if(Data==0){
                        $.messager.popover({
                            msg: '保存成功！',
                            type:'success',
                            showType:'show',
                            style:{
                                "position":"absolute", 
                                "z-index":"9999",
                                left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                                top:10
                            }               
                        });
                        $("#EditYM").combobox("disable");
                        $("#EditUser").combobox("disable");
                        $("#EditDept").combobox("disable");
                        $("#EditOwn").combobox("disable");
                        $("#EditPay").combobox("disable");
                        $("#EditCheckFlow").combobox("disable");
                        $("#EditDesc").attr("disabled",true);
                        $('#EditMainGrid').datagrid("reload");
                    }else{
                        $.messager.popover({
                            msg: '错误信息:' +Data,
                            type:'error',
                            showType:'show',
                            style:{
                                "position":"absolute", 
                                "z-index":"9999",
                                left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                                top:10
                            }               
                        });
                        $('#EditMainGrid').datagrid("reload");
                    }
                }
            );
            editRow = undefined;
        }        
    }
    function ChkBefDel() {
        var row = $('#EditMainGrid').datagrid("getSelected");
        if(row==null){
            $.messager.popover({
                msg: '请先选中一行数据!',
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
            return false;
        }else if(!(row.rowid>0)){
            $.messager.popover({
                msg: '请选择保存后的数据!',
                type:'info',
                showType:'show',
                style:{
                    "position":"absolute", 
                    "z-index":"9999",
                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                    top:10
                }               
            });
            return false;
        }
        return true;
    };
    function Del() {
        $.messager.confirm('确定','确定要删除选定的数据吗？',function(t){
           if(t){
            var data = "";
            var row = $('#EditMainGrid').datagrid("getSelected");
            data=row.rowid;
            $.m({
                ClassName:'herp.budg.hisui.udata.uExpenseAccountDetail',MethodName:'Delete',data:data},
                function(Data){
                    if(Data==0){
                        $.messager.popover({
                            msg: '删除成功！',
                            type:'success',
                            showType:'show',
                            style:{
                                "position":"absolute", 
                                "z-index":"9999",
                                left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                                top:10
                            }               
                        });
                        $('#EditMainGrid').datagrid("reload")
                    }else{
                        $.messager.popover({
                            msg: '错误信息:' +Data,
                            type:'error',
                            showType:'show',
                            style:{
                                "position":"absolute", 
                                "z-index":"9999",
                                left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
                                top:10
                            }               
                        });
                        $('#EditMainGrid').datagrid("reload");
                    }
                }
            );
           } 
        })  
    }

}