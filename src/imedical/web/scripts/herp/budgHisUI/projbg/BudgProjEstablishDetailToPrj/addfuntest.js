var userid = session['LOGON.USERID'];
var username=session['LOGON.USERNAME'];
var hospid=session['LOGON.HOSPID'];
addFun = function () {
    // 年度的下拉框
    var AddYearObj = $HUI.combobox("#AddYear",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        value: new Date().getFullYear(),
        onBeforeLoad:function(param){
            param.str = param.q;
        },
        onSelect:function(rec){

        }
    });
    // 责任科室的下拉框
    var AddDeptObj = $HUI.combobox("#AddDept",{
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
    var AddBgDeptObj = $HUI.combobox("#AddBgDept",{
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
    // 预算科目的下拉框
    var AddItemObj = $HUI.combobox("#AddItem",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.year 	 = $('#AddYear').combobox('getValue');
            param.deptdr = $('#AddDept').combobox('getValue');
            param.str 	 = param.q;
        },
        onShowPanel:function(){
        	if($('#AddYear').combobox('getValue')==""){
        		$(this).combobox('hidePanel');
        		$.messager.alert('提示','请先选择年度!','info');
        		return false;
        	}
        }
    });
    // 资金类型的下拉框
    var AddFundTyObj = $HUI.combobox("#AddFundTy",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ListFundType",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.str = param.q;
        }
    });
    // 新增-更新的下拉框
    var AddAEObj = $HUI.combobox("#AddAE",{ 
        mode:'local', 
        valueField:'rowid',    
        textField:'name',
        value: 1,
        data: [{
                    'rowid': 1,
                    'name': "新增"
                },{
                    'rowid': 2,
                    'name': "更新"
        }]
     });
    //预算单价变化，计算预算金额
    $('#AddPrice').keyup(function(event){
    	Calcu();
    })
    //预算数量变化，计算预算金额
    $('#AddNum').numberspinner({
    	onChange:function(n,o){
    		if(n!=o){
    			Calcu();
    		}
    	}   	
    }) 
    //计算预算金额 = 单价*数量 
    function Calcu(){
    	var AddPrice = parseFloat($('#AddPrice').val());  //预算单价
    	if (AddPrice ==""||isNaN(AddPrice)){AddPrice = 0};
    	var AddNum = parseFloat($('#AddNum').val()); //预算数量
    	if (AddNum ==""||isNaN(AddNum)){AddNum = 0};
    	$('#AddBgSum').val(AddPrice.toFixed(2)*AddNum.toFixed(0));
    }
    var $win;
    $win = $('#AddWin').window({
        title: '添加项目信息',
        width: 660,
        height: 520,
        top: ($(window).height() - 520) * 0.5,
        left: ($(window).width() - 660) * 0.5,
        shadow: true,
        modal: true,
        iconCls: 'icon-save',
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
        onClose:function(){ //关闭关闭窗口后触发
            $('#AddForm').form("reset");
            $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
    });
    $win.window('open');

    //添加方法 
    $("#AddSave").unbind('click').click(function(){
        var itemcode = $('#AddItem').combobox('getValue');
		var budgprice = $('#AddPrice').val();
		var budgnum = $('#AddNum').val();
		var budgdesc = $('#AddEquRemark').val();  //设备名称
		var FeeScale = $('#AddFeeSca').val();     //收费标准
		var AnnBenefit = $('#AddAnnBen').val();   //年效益预测
		var MatCharge = $('#AddMatChar').val();   //耗材费
		var SupCondit = $('#AddSupCon').val();    //配套条件
		var Remarks = $('#AddRemark').val();      //说明
		var brand1 = $('#AddBrand1').val();		  //推荐品牌1
		var spec1 = $('#AddSpec1').val();		  //规格型号1
		var brand2 = $('#AddBrand2').val();		  //推荐品牌2
		var spec2 = $('#AddSpec2').val();		  //规格型号2
		var brand3 = $('#AddBrand3').val();		  //推荐品牌3
		var spec3 = $('#AddSpec3').val();		  //规格型号3
		var isaddedit = $('#AddAE').combobox('getValue');  //新增-更新
		var PerOrigin = $('#AddPerOri').val();  //人员资质-原有设备
		var fundtype = $('#AddFundTy').combobox('getValue');  //新增-更新 
		var budgpro = $('#AddPerce').val();   //总预算占比
		var deptdr = $('#AddBgDept').combobox('getValue');   //预算科室

		var datad = itemcode + '|' + budgprice + '|' + budgnum + '|' + budgdesc
			 + '|' + FeeScale + '|' + AnnBenefit + '|' + MatCharge + '|' + SupCondit + '|' + Remarks + '|'
			+brand1 + '|' + spec1 + '|' + brand2 + '|' + spec2 + '|' + brand3 + '|' + spec3 + '|' + isaddedit + "|" + PerOrigin
			 + "|" + fundtype + '|' + budgpro + '|' + userid + '|' + deptdr + '|' + hospid;
        $.m({
            ClassName:'herp.budg.udata.uBudgProjEstablishDetailToPrj',MethodName:'Insert',data:datad},
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