var userid = session['LOGON.USERID'];
var username=session['LOGON.USERNAME'];
var hospid=session['LOGON.HOSPID'];
editFun = function () {
    var rowObj = $('#MainGrid').datagrid('getSelected');

    var rowid = rowObj.rowid;
    var tmpitemcode = rowObj.itemcode;
    var tmpbudgprice = rowObj.budgprice.replace(/,/g, '');
    var tmpbudgnum = rowObj.budgnum;
    var tmpbudgdesc = rowObj.budgdesc;
    var tmpFeeScale = rowObj.FeeScale;
    var tmpAnnBenefit = rowObj.AnnBenefit;
    var tmpMatCharge = rowObj.MatCharge;
    var tmpSupCondit = rowObj.SupCondit;
    var tmpRemarks = rowObj.Remarks;
    var tmpbrand1 = rowObj.brand1;
    var tmpspec1 = rowObj.spec1;
    var tmpbrand2 = rowObj.brand2;
    var tmpspec2 = rowObj.spec2;
    var tmpbrand3 = rowObj.brand3;
    var tmpspec3 = rowObj.spec3;
    var tmpisaddedit = rowObj.isaddedit;
    if (tmpisaddedit == "新增") {
        tmpisaddedit = 1;
    }
    if (tmpisaddedit == "更新") {
        tmpisaddedit = 2;
    }
    var tmpPerOrigin = rowObj.PerOrigin;
    var tmpfundtype = rowObj.fundtypedr;
    var tmpbudgpro = rowObj.budgpro;
    var tmpbudgvalue = rowObj.budgvalue;
    var tmpdeptdr = rowObj.deptDR;
    // 年度的下拉框
    var EditYearObj = $HUI.combobox("#EditYear",{
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
    var EditDeptObj = $HUI.combobox("#EditDept",{
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
    var EditBgDeptObj = $HUI.combobox("#EditBgDept",{
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
    var EditItemObj = $HUI.combobox("#EditItem",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.year 	 = $('#EditYear').combobox('getValue');
            param.deptdr = $('#EditDept').combobox('getValue');
            param.str 	 = param.q;
        },
        onShowPanel:function(){
        	if($('#EditYear').combobox('getValue')==""){
        		$(this).combobox('hidePanel');
        		$.messager.alert('提示','请先选择年度!','info');
        		return false;
        	}
        }
    });
    // 资金类型的下拉框
    var EditFundTyObj = $HUI.combobox("#EditFundTy",{
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
    var EditAEObj = $HUI.combobox("#EditAE",{ 
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
    $('#EditPrice').keyup(function(event){
    	Calcu();
    })
    //预算数量变化，计算预算金额
    $('#EditNum').numberspinner({
    	onChange:function(n,o){
    		if(n!=o){
    			Calcu();
    		}
    	}   	
    }) 
    //计算预算金额 = 单价*数量 
    function Calcu(){
    	var EditPrice = parseFloat($('#EditPrice').val());  //预算单价
    	if (EditPrice ==""||isNaN(EditPrice)){EditPrice = 0};
    	var EditNum = parseFloat($('#EditNum').val()); //预算数量
    	if (EditNum ==""||isNaN(EditNum)){EditNum = 0};
    	$('#EditBgSum').val(EditPrice.toFixed(2)*EditNum.toFixed(0));
    }
    var $Editwin;
    $Editwin = $('#EditWin').window({
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
            $('#EditForm').form("reset");
            $("#MainGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
    });
    $Editwin.window('open');
    // 表单赋值
    $('#EditItem').combobox('setValue',rowObj.itemcode);
    $('#EditPrice').val(tmpbudgprice);
    $('#EditNum').val(tmpbudgnum);
    $('#EditEquRemark').val(tmpbudgdesc);
    $('#EditFeeSca').val(tmpFeeScale);
    $('#EditAnnBen').val(tmpAnnBenefit);
    $('#EditMatChar').val(tmpMatCharge);
    $('#EditSupCon').val(tmpSupCondit);
    $('#EditRemark').val(tmpRemarks);
    $('#EditBrand1').val(tmpbrand1);
    $('#EditSpec1').val(tmpspec1);
    $('#EditBrand2').val(tmpbrand2);
    $('#EditSpec2').val(tmpspec2);
    $('#EditBrand3').val(tmpbrand3);
    $('#EditSpec3').val(tmpspec3);
    $('#EditAE').combobox('setValue',tmpisaddedit);
    $('#EditPerOri').val(tmpPerOrigin);
    $('#EditFundTy').combobox('setValue',rowObj.fundtypedr);
    $('#EditBgSum').val(tmpbudgvalue);
    $('#EditPerce').val(tmpbudgpro);
    $('#EditBgDept').combobox('setValue',rowObj.deptDR);
    //添加方法 
    $("#EditSave").unbind('click').click(function(){
        var itemcode = $('#EditItem').combobox('getValue');
		var budgprice = $('#EditPrice').val();
		var budgnum = $('#EditNum').val();
		var budgdesc = $('#EditEquRemark').val();  //设备名称
		var FeeScale = $('#EditFeeSca').val();     //收费标准
		var AnnBenefit = $('#EditAnnBen').val();   //年效益预测
		var MatCharge = $('#EditMatChar').val();   //耗材费
		var SupCondit = $('#EditSupCon').val();    //配套条件
		var Remarks = $('#EditRemark').val();      //说明
		var brand1 = $('#EditBrand1').val();		  //推荐品牌1
		var spec1 = $('#EditSpec1').val();		  //规格型号1
		var brand2 = $('#EditBrand2').val();		  //推荐品牌2
		var spec2 = $('#EditSpec2').val();		  //规格型号2
		var brand3 = $('#EditBrand3').val();		  //推荐品牌3
		var spec3 = $('#EditSpec3').val();		  //规格型号3
		var isaddedit = $('#EditAE').combobox('getValue');  //新增-更新
		var PerOrigin = $('#EditPerOri').val();  //人员资质-原有设备
		var fundtype = $('#EditFundTy').combobox('getValue');  //资金类型
		var budgpro = $('#EditPerce').val();   //总预算占比
		var deptdr = $('#EditBgDept').combobox('getValue');   //预算科室

		var datad = itemcode + '|' + budgprice + '|' + budgnum + '|' + budgdesc
			 + '|' + FeeScale + '|' + AnnBenefit + '|' + MatCharge + '|' + SupCondit + '|' + Remarks + '|'
			+brand1 + '|' + spec1 + '|' + brand2 + '|' + spec2 + '|' + brand3 + '|' + spec3 + '|' + isaddedit + "|" + PerOrigin
			 + "|" + fundtype + '|' + budgpro + '|' + userid + '|' + deptdr + '|' + hospid;
        $.m({
            ClassName:'herp.budg.udata.uBudgProjEstablishDetailToPrj',MethodName:'Update',rowid:rowid,data:datad},
            function(Data){
                if(Data==0){
                    $.messager.alert('提示','保存成功！','info');
                }else{
                    $.messager.alert('提示','错误信息:' +Data,'error');
                }
            }
        );
        $Editwin.window('close');
    });

    $("#EditClose").unbind('click').click(function(){
        $Editwin.window('close');
    });
}