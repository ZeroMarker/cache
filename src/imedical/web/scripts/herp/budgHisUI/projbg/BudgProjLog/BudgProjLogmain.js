var userid = session['LOGON.USERID'];
var hospid=session['LOGON.HOSPID'];
$(function(){//初始化
    Init();
}); 

function Init(){

    MainColumns=[[  
    		    {field:'ckbox',checkbox:true},//复选框
                {field:'rowid',title:'rowid',width:80,hidden: true},
                {field:'CompName',title:'医疗单位',width:80,hidden: true},
                {field:'TableName',title:'表名称',width:180},
                {field:'ClassName',title:'类名称',width:180},
                {field:'ClassNameDesc',title:'类描述',width:150},
                {field:'ObjectReference',title:'对象ID',width:220},
                {field:'ObjectDesc',title:'对象描述',width:250},
                {field:'UpdateUserDR',title:'用户',width:60},
                {field:'UpdateUserName',title:'安全组',width:80},
                {field:'UpdateDate',title:'更新日期',width:100},
                {field:'UpdateTime',title:'更新时间',width:100},
                {field:'OperateType',title:'操作类型',width:80,
                    formatter:function(value){
                        if (value == 'R') {
							return "" + "   读取";
						}
						if (value == 'U') {
							return "" + "   修改";
						}
						if (value == 'D') {
							return "" + "   删除";
						}
						if (value == 'A') {
							return "" + "   新增";
						} 
                    }
            	},
                {field:'NewValue',title:'修正的数据',width:250}

            ]];
    var MainGridObj = $HUI.datagrid("#MainGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgProjLog",
            MethodName:"List",
            hospid:    hospid, 
            cname :    "", //类名
            Odesc   :   "", //对象描述
            updUname:   "", //安全组
            upddate:    "", //更新日期
            name   :   ""   //用户名
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        ctrlSelec:true, //在启用多行选择的时候允许使用Ctrl键+鼠标点击的方式进行多选操作
        // singleSelect: true, //只允许选中一行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        toolbar: '#tb'   
    });    

    //查询函数
    var FindBtn= function(){
    	var date=$('#UDate').datebox('getValue');
    	//console.log(date);
    	var datetmp=date//date.split("/")[2]+"-"+date.split("/")[1]+"-"+date.split("/")[0]
        MainGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgProjLog",
                MethodName:"List",
                hospid:    hospid, 
	            cname :    $('#CName').val(), //类名
	            Odesc :    $('#ObDesc').val(), //对象描述
	            updUname:  $('#UNmae').val(), //安全组
	            upddate:   datetmp, //更新日期
	            name   :   $('#UserName').val()   //用户名
            })
    }
    
    //点击查询按钮 
    $("#FindBn").click(FindBtn);
    var DelBtn= function(){
    	var rows = $('#MainGrid').datagrid("getSelections");
    	var length=rows.length;
    	var str=""
        if(length<1){
            $.messager.alert('提示','请先选中至少一行数据!','info');
            return false;
        }else{
        	$.messager.confirm('提示', '是否删除？', function(r){
				if (r){
					for(var i=0; i<length; i++){
						var row = rows[i];
						if(str==""){
							str=row.rowid;
						}else{
							str=str+"^"+row.rowid;
						}
					}
					
				    $.m({
		                ClassName:'herp.budg.hisui.udata.uBudgProjLog',MethodName:'Delete',str:str},
		                function(Data){
		                    if(Data==0){
		                        $.messager.alert('提示','删除成功！','info');
		                    }else{
		                        $.messager.alert('提示','删除失败' ,'error');
		                    }
		                }
		            );
		            $('#MainGrid').datagrid("reload");
				}
			});
        }
    	
    }
    //点击查询按钮 
    $("#DelBn").click(DelBtn);

   //  //删除功能
   //  del=function (index) {
   //      onClickRow(index);
   //      var selectedRow = $('#MainGrid').datagrid("getSelected");
   //      var rowid = selectedRow.rowid;
   //      var BillState = selectedRow.BillState;
   //      sig = 1; //  标记是否级联删除明细表
   //      if (BillState !== "新建") {
   //          var message="申请单已提交或审核，不允许删除!"
   //          $.messager.alert('注意',message,'warning');
   //          return
   //      }else {
   //      	
            
   //      }
   //  }; 

}