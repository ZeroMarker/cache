var userid = session['LOGON.USERID'];
var username = session['LOGON.USERNAME'];
var hospid=session['LOGON.HOSPID'];
var DetailGrid = $("#DetailGrid");
function Detail(){
    MainColumns=[[  
                {field:'ckbox',checkbox:true},//复选框
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'DeptName',title:'预算编制科室',width:80,allowBlank:false,
                formatter:function(value,row,index){
	                return row.EditDeptName},
                    editor:{
                        type:'combobox',
                        options:{
                            valueField:'rowid',
                            textField:'name',
                            mode:'remote',
                            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
                            onBeforeLoad:function(param){
                                param.hospid = hospid;
                                param.userdr = userid;
                                param.flag   = 1;
                                param.str    = param.q;
                            },
                            onSelect: function(rec){    
                                var rowIndex=getRowIndex(this)
                                $('#DetailGrid').datagrid('getRows')[rowIndex]['EditDeptDR'] = rec.rowid;
                            },                             
                            required:true
                        }
                    }
                },
                {field:'UserDR',title:'预算编制责任人',width:80,allowBlank:false,

                    formatter:function(value,row,index){
                            return row.userName
                    },
                    editor:{
                        type:'combobox',
                        options:{
                            valueField:'rowid',
                            textField:'name',
                            mode:'remote',
                            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
                            onBeforeLoad:function(param){
                                param.hospid = hospid;
                                param.userdr = userid;
                                param.str    = param.q;
                            },
                            onLoadSuccess:function(){
                                // $(this).combobox('setValue', userid);
                                // $(this).combobox('setText', username);
                            },
                            onSelect: function(rec){    
                                // var rowIndex=getRowIndex(this)
                                // $('#DetailGrid').datagrid('getRows')[rowIndex]['UserDR'] = rec.rowid;
                            }, 
                            required:true                            
                        }
                    }
                },
                {field:'objDeptName',title:'方案适用科室',width:80,allowBlank:true,hidden: true,
                formatter:function(value,row,index){
	                 return row.objectDeptName},
                    editor:{
                        type:'combobox',
                        options:{
                            valueField:'rowid',
                            textField:'name',
                            mode:'remote',
                            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=Dept",
                            delay:200,
                            onBeforeLoad:function(param){
                                param.hospid = hospid;
                                param.userdr = userid;
                                param.flag   = 1;
                                param.str    = param.q;
                            },
                            onSelect: function(rec){    
                                var rowIndex=getRowIndex(this)
                                $('#DetailGrid').datagrid('getRows')[rowIndex]['ObjDeptDR'] = rec.rowid; 
                            },                             
                            required:false
                        }
                    }
                },
                {field:'state',title:'审批状态描述',width:110,hidden: true},
                {field:'stateuse',title:'审批状态',width:80,hidden: true}
            ]];
   /* var EndEditFun = function() {
        var indexs=DetailGrid.datagrid('getEditingRowIndexs')
        if(indexs.length>0){
            for(i=0;i<indexs.length;i++){
                DetailGrid.datagrid("endEdit", indexs[i]);
            }
        }
    }*/
    var DetailGridObj = $HUI.datagrid("#DetailGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemAudit",
            MethodName:"ListItem",
            hospid :    hospid, 
            userdr:     userid,
            schemeDr :      "",
            DeptName:       ""           
        },
        fitColumns: true,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:MainColumns,
        onClickRow:onClickRow,
        toolbar: '#rtb',
    });   
    
    ///行点击事件函数    
        var editIndex = undefined;
        function endEditing(){
			if (editIndex == undefined){
				return true
				}
			if ($('#DetailGrid').datagrid('validateRow', editIndex)){
				$('#DetailGrid').datagrid('endEdit', editIndex);
				editIndex = undefined;
				return true;
			} else {
				return false;
			}
		}
        function onClickRow(index){
	        endEditConditions(editIndex);
	        var row = $('#DetailGrid').datagrid('getSelected');     
			if (editIndex != index){
				if (endEditing()){
					$('#DetailGrid').datagrid('selectRow', index)
					$('#DetailGrid').datagrid('beginEdit', index);
					editIndex = index;
				} else {
					$('#DetailGrid').datagrid('selectRow', editIndex)}
			}}
    
 ///结束编辑时下拉框显示值与所选项保持一致
 function endEditConditions(editIndex){
	      var ed = $('#DetailGrid').datagrid('getEditor', {
		          index: editIndex,
		          field: 'DeptName'
		 });
		 if (ed) {
			 var EditDeptName = $(ed.target).combobox('getText');
			 $('#DetailGrid').datagrid('getRows')[editIndex]['EditDeptName'] = EditDeptName;
			 }
	     var ed = $('#DetailGrid').datagrid('getEditor', {
				 index: editIndex,
				 field: 'objDeptName'
				 });
		if (ed) {
		    var objectDeptName = $(ed.target).combobox('getText');
			$('#DetailGrid').datagrid('getRows')[editIndex]['objectDeptName'] = objectDeptName;
			 }
	    var ed = $('#DetailGrid').datagrid('getEditor', {
		     	  index: editIndex,
				  field: 'UserDR'
				  });
		if (ed) {
			var userName = $(ed.target).combobox('getText');
			$('#DetailGrid').datagrid('getRows')[editIndex]['userName'] = userName;
						 }
	    $('#DetailGrid').datagrid('endEdit', editIndex);
			     
 }
     
    // 查询函数
    var RFindBn= function()
    {
        var row = $('#MainGrid').datagrid('getSelected'); 
        var schemeDr="";
        if(row!=null){
            var schemeDr=row.rowid;
        }       
        var deptstr    =$('#DeptBox').val();//科室
        DetailGridObj.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchemAudit",
                MethodName:"ListItem",
                hospid :    hospid, 
                userdr:     userid,
                schemeDr :  schemeDr,
                DeptName:   deptstr     
            })
    }

    // 点击查询按钮 
    $("#RFindBn").click(RFindBn);
    /*增加前数据检查*/
    function checkBeforeAdd(){
        var row = $('#MainGrid').datagrid('getSelected'); 
        if (row==null) {
            var message = "请先选择对应的方案行!";
            $.messager.popover({msg: message,type:'info',
            style:{"position":"absolute","z-index":"9999",
            left:-document.body.scrollTop - document.documentElement.scrollTop/2,
            top:1}});
           return false;
        }
        return true;
    }
    //增加
    function AddRow(){       
        $("#DetailGrid").datagrid("insertRow", {
            index: 0, 
            row: {
                rowid:'',
                DeptName:'',
                UserDR:'',
                objDeptName:'',
                state:'',
                stateuse:''
            }
        });
        $("#DetailGrid").datagrid('selectRow', 0);
        $("#DetailGrid").datagrid("beginEdit", 0);
    }
    // 点击增加按钮 
    $("#AddBn").click(function(){
        if (checkBeforeAdd()&&endEditing()) {
            AddRow(); 
        }else {
            return;
        }
    }); 
    /***********************保存函数*************************/
    //保存按钮
    $("#SaveBn").click(function(){
	    var indexs = $('#DetailGrid').datagrid('getEditingRowIndexs');
	    if (indexs.length > 0) {
		  for (i = 0; i < indexs.length; i++) {
			  endEditConditions(indexs[i]);
			 }}
        var selectedrow = $('#MainGrid').datagrid('getSelected'); 
        var schemeDr=selectedrow.rowid;
        //取到发生变化的记录对象
        var rows = DetailGrid.datagrid("getChanges");
        var row="",data="";
        if(!rows.length){
            $.messager.popover({msg: '没有内容需要保存！',type:'info'});
            return false;
        }else{
            $.messager.confirm('确定','确定要保存数据吗？',
                function(t){
                    if(t){
                        for(var i=0; i<rows.length; i++){
                            row=rows[i];
                            if (CheckDataBeforeSave(row) == true) {
                                var rowid = row.rowid;
                                if (rowid == "") {
                                    $.m({
                                        ClassName:'herp.budg.udata.uBudgSchemAudit',MethodName:'InsertRec',schemeDr:schemeDr,editDeptDR:row.EditDeptDR,userDR:row.UserDR,deptDR:row.EditDeptDR},
                                            function(Data){
                                                if(Data==0){
                                                    $.messager.popover({msg: '插入成功！',type:'success',
                                                    style:{"position":"absolute","z-index":"9999",
                                                    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                                                    top:1}});
                                                }else{
                                                    $.messager.popover({msg: "错误信息:"+Data,type:'error',style:{"position":"absolute","z-index":"9999",
                                                    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                                                    top:1}});
                                                }                                                                                                   
                                            }
                                    ); 
                                } else {
                                    $.m({
                                        ClassName:'herp.budg.udata.uBudgSchemAudit',MethodName:'UpdateRec',rowid:rowid,schemeDr:schemeDr,editDeptDR:row.EditDeptDR,userDR:row.UserDR,deptDR:row.EditDeptDR},
                                            function(Data){
                                                if(Data==0){
                                                    $.messager.popover({msg: '修改成功！',type:'success',style:{"position":"absolute","z-index":"9999",
                                                    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                                                    top:1}});
                                                }else{
                                                    $.messager.popover({msg: "错误信息:"+Data,type:'error',style:{"position":"absolute","z-index":"9999",
                                                    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                                                    top:1}});
                                                }                                                    
                                            }
                                    );
                                }
                            }else {
                                continue;
                            }
                        }
                        DetailGrid.datagrid("reload");
                    }    
                }
            )
        }
    }); 
    function CheckDataBeforeSave(row) { 
        var fields=DetailGrid.datagrid('getColumnFields') 
        for (var j = 0; j < fields.length; j++) {
            var field=fields[j];
            var tmobj=DetailGrid.datagrid('getColumnOption',field);  
            if (tmobj != null) {
                var reValue="";
                reValue=row[field];
                if(reValue == undefined){
                    reValue = "";
                }
                if (tmobj.allowBlank == false) {
                    var title = tmobj.title;
                    if ((reValue== "")||(reValue == undefined)||(parseInt(reValue) == 0)) {
                        var info =title + "列为必填项，不能为空或零！";
                        $.messager.popover({msg: info,type:'error',style:{"position":"absolute","z-index":"9999",
                                                    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                                                    top:1}});
                        return false;
                    }
                }
            }
        }
        return true;     
    }
    //删除前检查
    function ChkBefDel() {
        var row = $("#DetailGrid").datagrid("getSelected");
        if(row==null){
            $.messager.popover({msg: '请选中一行数据!',type:'info'});
            return false;
        }
        return true;
    };
    //删除函数
    function Del() {
        $.messager.confirm('确定','确定要删除选定的数据吗？',function(t){
            if(t){
                var data="",rowid=""
                var row = $("#DetailGrid").datagrid("getSelected");
                rowid=row.rowid;
                if(rowid==""){
                    var rowindex=$("#DetailGrid").datagrid("getRowIndex",row);
                    $("#DetailGrid").datagrid("deleteRow",rowindex);
                }else{
                    data=rowid;
                }                   
                if(data!=""){
                    $.m({
                        ClassName:'herp.budg.udata.uBudgSchemAudit',MethodName:'ItemDelete',rowid:data},
                        function(Data){
                            if(Data==0){
                                $.messager.popover({msg: '删除成功！',type:'success',style:{"position":"absolute","z-index":"9999",
                                                    left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                                                    top:1}});
                                $("#DetailGrid").datagrid("reload");
                            }else{
                                var message = "错误!"
                                if(Data=="-1"){
                                    message = "预算已下达,禁止操作!"
                                }
                                $.messager.popover({msg: message,type:'error'});
                                $("#DetailGrid").datagrid("reload");
                            }
                        }
                    );   
                }                              
            } 
        })  
    } 
    // 点击删除按钮 
    $("#DelBn").click(function(){
        if (ChkBefDel() == true) {
            Del(); 
        }else {
            return;
        }
    }); 

}
