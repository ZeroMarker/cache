var userid = session['LOGON.USERID'];
var uname = session['LOGON.USERNAME'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
}); 

function Init(){
	// 年度的下拉框
	var YMboxObj = $HUI.combobox("#YMbox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=YearOrYearMon",
        mode:'remote',
        delay:200,
        valueField:'year',    
        textField:'year',
        onBeforeLoad:function(param){
            param.str = param.q;
        },
        onChange:function(n,o){
        	if(n!=o){
        		$('#Itembox').combobox('clear');
        		$('#Itembox').combobox('reload'); 
        		$('#Projbox').combobox('clear');
        		$('#Projbox').combobox('reload');
        	}
        }
    });
    // 预算科目的下拉框
    var ItemboxObj = $HUI.combobox("#Itembox",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=ItemName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.year 	 = $('#YMbox').combobox('getValue');
            param.deptdr = $('#DutyDeptbox').combobox('getValue');
            param.str 	 = param.q;
        },
        onShowPanel:function(){
        	if($('#YMbox').combobox('getValue')==""){
        		$(this).combobox('hidePanel');
        		$.messager.alert('提示','请先选择年度!','info');
        		return false;
        	}
        }
    });
    // 项目名称的下拉框
    var ProjboxObj = $HUI.combobox("#Projbox",{
        url:$URL+"?ClassName=herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj&MethodName=projName",
        mode:'remote',
        delay:200,
        valueField:'rowid',    
        textField:'name',
        onBeforeLoad:function(param){
            param.hospid = hospid;
            param.year 	 = $('#YMbox').combobox('getValue');
            param.userdr = userid;
            param.str 	 = param.q;
        },
        onShowPanel:function(){
        	if($('#YMbox').combobox('getValue')==""){
        		$(this).combobox('hidePanel');  //隐藏下拉面板
        		$.messager.alert('提示','请先选择年度!','info');
        		return false;
        	}
        }
    });
    // 资金类型的下拉框
    var FundTyboxObj = $HUI.combobox("#FundTybox",{
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
    // 责任科室的下拉框
    var DutyDeptObj = $HUI.combobox("#DutyDeptbox",{
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
        },
        onChange:function(n,o){
        	if(n!=o){
        		$('#Itembox').combobox('clear');
        		$('#Itembox').combobox('reload'); 
        		$('#Projbox').combobox('clear');
        		$('#Projbox').combobox('reload');
        	}
        }
    });
    // 预算科室的下拉框
    var ApplyDboxObj = $HUI.combobox("#ApplyDbox",{
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
    //增加按钮
    var AddBtn= {
        id: 'Add',
        iconCls: 'icon-add',
        text: '增加',
        handler: function(){
            addFun();
        }
    }
    // 修改按钮
    var EditBtn= {
        id: 'Edit',
        iconCls: 'icon-edit',
        text: '修改',
        handler: function(){
            if (ChkBefEdit() == true) {
                editFun();
            } else {
                return;
            }
        }
    }
    // 删除按钮
    var DelBtn= {
        id: 'Del',
        iconCls: 'icon-del-diag',
        text: '删除',
        handler: function(){
            if (ChkBef("del") == true) {
                del()
            } else {
                return;
            }
        }
    }
    //提交
    var SubmitBtn = {
        id: 'Sub',
        text: '提交',
        iconCls: 'icon-ok',
        handler: function () {
            if (ChkBef("submit") == true) {
                submit();
            } else {
                return;
            }
        }
    };
    //把选中的项目明细汇总成一个项目
    var SumBtn = {
        text: '汇总',
        iconCls: 'icon-sum',
        handler: function () {
            if (ChkBef("sum") == true) {
                sum();
            }else {
                return;
            }
        }
    };
    MainColumns=[[  
                {field:'ck',checkbox:true},//复选框
                {field:'rowid',title:'明细ID',width:80,hidden: true},
                {field:'projadjdr',title:'主表ID',width:80,hidden: true},
                {field:'fundtypedr',title:'资金类别ID',width:80,hidden: true},
                {field:'fundtype',title:'资金类别',width:120},
                {field:'projName',title:'项目名称',width:200},
                {field:'itemcode',title:'科目编码',width:80,hidden: true},
                {field:'bidlevel',title:'预算级别',width:80,hidden: true},
                {field:'itemname',title:'科目名称',width:120},
                {field:'deptDR',title:'预算科室',width:80,hidden: true},
                {field:'deptName',title:'预算科室',width:120},
                {field:'bidislast',title:'是否末级',width:80,hidden: true},
                {field:'budgprice',title:'预算单价',align:'left',width:80,
		    	    formatter:function(value,row,index){
		                 if(value>0){
		                 	value=parseFloat(value).toFixed(2);//格式化,保留两位小数
		                 	return '<span>' + value + '</span>';
		                 }
		            }
		    	},
                {field:'budgnum',title:'预算数量',align:'left',width:100},
                {field:'budgpro',title:'总预算占比(%)',align:'left',width:150},
                {field:'budgvalue',title:'预算金额',align:'left',width:100,
		    	    formatter:function(value,row,index){
		                 if(value>0){
		                 	value=parseFloat(value).toFixed(2);//格式化,保留两位小数
		                 	return '<span>' + value + '</span>';
		                 }
		            }
		    	},
                {field:'isaddedit',title:'新增/更新',width:120},
                {field:'dutydeptDR',title:'责任科室ID',width:100,hidden: true},
                {field:'dutydeptName',title:'责任科室',width:120},
                {field:'State',title:'状态',width:60},
                {field:'SSUSRName',title:'申请人',width:80,hidden: true},
                {field:'isaudit',title:'有否汇总权限',width:150,hidden: true},
                {field:'projState',title:'项目状态',width:120,hidden: true},
                {field:'budgdesc',title:'设备名称备注',width:120},
                {field:'PerOrigin',title:'人员资质-原有设备',width:150},
                {field:'FeeScale',title:'收费标准',width:120},
                {field:'AnnBenefit',title:'年效益预测',width:120},
                {field:'MatCharge',title:'耗材费',width:80},
                {field:'SupCondit',title:'配套条件',width:120},
                {field:'Remarks',title:'备注',width:120},
                {field:'brand1',title:'推荐品牌1',width:120},
                {field:'spec1',title:'规格型号1',width:120},
                {field:'brand2',title:'推荐品牌2',width:120},
                {field:'spec2',title:'规格型号2',width:120},
                {field:'brand3',title:'推荐品牌3',width:120},
                {field:'spec3',title:'规格型号3',width:120}
            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj",
            MethodName:"List",
            hospid :    hospid, 
            userid :    userid,
            year   : 	"",
            dutydeptdr :"",
            projdr: 	"",
            fundtype : 	"",
            itemcode: 	"",
            deptdr: 	""
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        singleSelect: false, //多选
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        rowStyler: rowStyler,
        toolbar: [AddBtn,EditBtn,DelBtn,SubmitBtn,SumBtn]       
    });
    // 自定义行样式函数
    function rowStyler(index,row){  //自定义行样式函数
        if (row.State == "已汇总"){
            return 'background-color:#FFCCFF;';
        }else if(row.State == "提交"){
            return 'background-color:#E7F7FE;';
        }else if(index%2==1){
                return 'background-color:#FAFAFA;';
        }else{
            return '';
        }
    }
    //查询函数
    var FindBtn= function()
    {
        var Year = $('#YMbox').combobox('getValue'); // 年度
        var Item      = $('#Itembox').combobox('getValue'); // 预算科目
        var Proj 	  = $('#Projbox').combobox('getValue');  // 项目名称
        var FundTy    = $('#FundTybox').combobox('getValue');  // 资金类型
        var DutyDept  = $('#DutyDeptbox').combobox('getValue'); // 责任科室
        var ApplyD    = $('#ApplyDbox').combobox('getValue'); // 预算科室
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgProjEstablishDetailToPrj",
	            MethodName:"List",
	            hospid :    hospid, 
	            userid :    userid,
	            year   : 	Year,
	            dutydeptdr :DutyDept,
	            projdr: 	Proj,
	            fundtype : 	FundTy,
	            itemcode: 	Item,
	            deptdr: 	ApplyD
            })
    }
    //点击查询按钮 
    $("#FindBn").click(FindBtn);
    //修改前检查函数
    function ChkBefEdit() {
        //是否选中记录
        var rows = $('#MainGrid').datagrid('getSelections');
        var length=rows.length;        
        if(length!=1){
            $.messager.alert('提示','请选择一条数据!','info');
            return false;
        }
        //数据状态是否满足条件
        if (rows[0].isaudit!= "1" && rows[0].State!= "新建") {
            $.messager.alert('警告','无权限修改非"新建"状态单据!','warning');
            return false;
        }
        return true;       
    }  
    //检查函数:删除、提交、汇总
    function ChkBef(info) {
        //是否选中记录
        var message = "";
        var rows = $('#MainGrid').datagrid('getSelections');
        var len=rows.length; 
        if (len < 1) {
            if(info=="del"){
                message="请选择需要删除的数据!";
            }
            if(info=="submit"){
                message="请选择需要提交的数据!";
            }
            if(info=="sum"){
                message="请选择需要汇总的项目明细数据!";
            }
            $.messager.alert('提示',message,'info');
            return false;
        }
        //数据状态是否满足条件
        var flag = 1;
        var rowID = "",dutyDept="";
        for (var i = 0; i < len; i++) {
            if ((rows[i].State == "新建"&&(info=="del"||info=="submit"))||(rows[i].State == "提交"&&info=="sum"))
                continue;
            rowID = rows[i].rowid;
            //1，明细单据是新建状态可删除
            //2，明细单据是非新建状态，关联项目是新建状态，拥有汇总权限的人可删除。
            if (rows[i].projState != "1"&&info=="del") {
                flag = -1;
                message = '错误位置：rowID=' + rowID + '；错误原因：关联项目非"新建"状态，禁止删除！';
                break;
            }
            if (rows[i].isaudit != "1"&&info=="del") {
                flag = -2;
                message = '错误位置：rowID=' + rowID + '；错误原因：无汇总权限，禁止删除！';
                break;
            }
            if (rows[i].State != "新建"&&info=="submit") {
                flag = -3;
                message = '错误位置：rowID=' + rowID + '；错误原因：已提交,不能再次提交！';
                break;
            }
            if (rows[i].State != "提交"&&info=="sum") {
                flag = -4;
                message = '错误位置：rowID=' + rowID + '；错误原因：只允许汇总"提交"状态的单据！';
                break;
            }
            if (i == 0) {
                dutyDept = rows[i].dutydeptName;
            }
            if (dutyDept != rows[i].dutydeptName&&info=="sum") {
                flag = -5;
                message = '错误位置：rowID=' + rowID + '；错误原因：请汇总同一责任科室的明细项！';
                break;
            }
        }
        if (flag != 1) {
            $.messager.alert('警告',message,'warning');
            return false;
        }
        return true;
    }  
    //删除项目信息
    function del() {
        $.messager.confirm('确定','确定要删除选定的数据吗？',function(t){
           if(t){
            var rows = $('#MainGrid').datagrid('getSelections');
            var len = rows.length;
            var data = "";
            for (var i = 0; i < len; i++) {
                if (data == "") {
                    data = rows[i].rowid;
                } else {
                    data = data + "^" + rows[i].rowid;
                }
            }
            $.m({
                ClassName:'herp.budg.udata.uBudgProjEstablishDetailToPrj',MethodName:'Delete',CompDR:hospid,userdr:userid,rowids:data},
                function(Data){
                    if(Data==0){
                        $.messager.alert('提示','删除成功！','info',function(){$('#MainGrid').datagrid("reload")});
                    }else{
                        $.messager.alert('提示','错误信息:' +Data,'error',function(){$('#MainGrid').datagrid("reload")});
                    }
                }
            );
           } 
        })  
    }  
    //提交项目信息
    function submit() {
        $.messager.confirm('确定','确定要提交吗？',function(t){
           if(t){
            var rows = $('#MainGrid').datagrid('getSelections');
            var len = rows.length;
            var data = "";
            for (var i = 0; i < len; i++) {
                if ((rows[i].State == "新建")
                     || (rows[i].State == '')) {
                    if (data == "") {
                        data = rows[i].rowid;
                    } else {
                        data = data + "^" + rows[i].rowid;
                    }
                }
            }
            $.m({
                ClassName:'herp.budg.udata.uBudgProjEstablishDetailToPrj',MethodName:'Submit',rowids:data},
                function(Data){
                    if(Data==0){
                        $.messager.alert('提示','提交成功！','info',function(){$('#MainGrid').datagrid("reload")});
                    }else{
                        $.messager.alert('提示','错误信息!' ,'error',function(){$('#MainGrid').datagrid("reload")});
                    }
                }
            );
           } 
        })  
    } 
    

}