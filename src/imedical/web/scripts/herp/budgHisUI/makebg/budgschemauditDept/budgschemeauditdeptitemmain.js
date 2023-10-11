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
                             //    var rowIndex=getRowIndex(this)
                             //    $('#DetailGrid').datagrid('getRows')[rowIndex]['UserDR'] = userid;
	                        },
                            onSelect: function(rec){    
                                // var rowIndex=getRowIndex(this)
                                // $('#DetailGrid').datagrid('getRows')[rowIndex]['UserDR'] = rec.rowid;
                                // var UserDRtd=$('.datagrid-body td[field="UserDR"]')[rowIndex];
                                // var target = $(UserDRtd).find('div')[0];
                                // $(target).text(rec.name);
                            }, 
                            required:true                            
                        }
                    }
                },
                {field:'objDeptName',title:'方案适用科室',width:80,allowBlank:false,
                formatter:function(value,row,index){
	                 return row.objectDeptName},
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
                                $('#DetailGrid').datagrid('getRows')[rowIndex]['ObjDeptDR'] = rec.rowid; 
                            },                             
                            required:true
                        }
                    }
                },
                {field:'state',title:'审批状态描述',width:110,hidden: true},
                {field:'stateuse',title:'审批状态',width:80,hidden: true}
            ]];
    /*var EndEditFun = function() {
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
            ClassName:"herp.budg.hisui.udata.uBudgSchemAuditDept",
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
        toolbar: '#rtb'       
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
                ClassName:"herp.budg.hisui.udata.uBudgSchemAuditDept",
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
            $.messager.popover({msg: message,type:'info'});
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
        if (checkBeforeAdd() == true) {
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
                                        ClassName:'herp.budg.udata.uBudgSchemAuditDept',MethodName:'InsertRec',schemeDr:schemeDr,editDeptDR:row.EditDeptDR,userDR:row.UserDR,deptDR:row.ObjDeptDR},
                                            function(Data){
                                                if(Data==0){
                                                    $.messager.popover({msg: '插入成功！',type:'success',
                                                    style:{"position":"absolute","z-index":"9999",
                  									left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                  									top:1}});
                                                }else{
                                                    $.messager.popover({
	                                                msg: "错误信息:"+Data,type:'error', 
	                                                style:{"position":"absolute","z-index":"9999",
                  									left:-document.body.scrollTop - document.documentElement.scrollTop/2,
                  									top:1}});
                                                }                                                                                                   
                                            }
                                    ); 
                                } else {
                                    $.m({
                                        ClassName:'herp.budg.udata.uBudgSchemAuditDept',MethodName:'UpdateRec',rowid:rowid,schemeDr:schemeDr,editDeptDR:row.EditDeptDR,userDR:row.UserDR,deptDR:row.ObjDeptDR},
                                            function(Data){
                                                if(Data==0){
                                                    $.messager.popover({msg: '修改成功！',type:'success'});
                                                }else{
                                                    $.messager.popover({
	                                                msg: "错误信息:"+Data,type:'error', 
	                                                style:{"position":"absolute","z-index":"9999",
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
                        $.messager.popover({msg: info,type:'error'});
                        return false;
                    }
                }
            }
        }
        return true;     
    }
    //删除前检查
    function ChkBefDel() {
        var rows = $("#DetailGrid").datagrid("getSelections");
        var len=rows.length;
        if(len<1){
            $.messager.popover({msg: '请至少选中一行数据！',type:'info'});
            return false;
        }
        return true;
    };
    //删除函数
    function Del() {
        $.messager.confirm('确定','确定要删除选定的数据吗？',function(t){
            if(t){
                var data="",rowid=""
                var rows = $("#DetailGrid").datagrid("getSelections");
                var len=rows.length;
                for(i=0;i<len;i++){
                    rowid=rows[i].rowid;
                    if(rowid==""){
                        var rowindex=$("#DetailGrid").datagrid("getRowIndex",rows[i]);
                        $("#DetailGrid").datagrid("deleteRow",rowindex);
                    }else{
                        if(data==""){
                            data=rowid;
                        }else{
                            data=data+"|"+rowid;
                        }
                    }                   
                } 
                if(data!=""){
                    $.m({
                        ClassName:'herp.budg.udata.uBudgSchemAuditDept',MethodName:'ItemDelete',rowids:data},
                        function(Data){
                            if(Data==0){
                                $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
                            }else{
                                var message = "错误!"
                                if(Data=="-1"){
                                    message = "预算已下达,禁止操作!"
                                }
                                $.messager.popover({msg: message,type:'error'});
                            }
                            $("#DetailGrid").datagrid("reload")
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
    /**批量功能  开始**/
    var BtchFun=function(fromschemdr) {
        var $Btchwin;
        $Btchwin = $('#BtchWin').window({
            title: '批量设置',
            width: 500,
            height: 300,
            top: ($(window).height() - 300) * 0.5,
            left: ($(window).width() - 500) * 0.5,
            shadow: true,
            modal: true,
            iconCls: 'icon-w-batch-add',
            closed: true,
            minimizable: false,
            maximizable: false,
            collapsible: false,
            resizable: true,
            onClose:function(){ //关闭关闭窗口后触发
                $("#Btchfm").form("clear");
                $("#DetailGrid").datagrid("reload"); //关闭窗口，重新加载主表格
            }
        });
        $Btchwin.window('open');
        // 表单的垂直居中
        xycenter($("#btchcenter"),$("#Btchfm"));
        // 设置表单垂直居中
        // 编制责任人的下拉框
        var BtchUserObj = $HUI.combobox("#BtchUser",{
            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=UserName",
            mode:'remote',
            delay:200,
            valueField:'rowid',    
            textField:'name',
            value:userid,
            onBeforeLoad:function(param){
                param.hospid = hospid;
                param.userdr = userid;
                param.str = param.q;
            }
        });
        // 编制科室的下拉框
        var BtchDeptObj = $HUI.combobox("#BtchDept",{
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
             
            }
        });
        // 适用科室类别的下拉框
        var BtchTypeObj = $HUI.combobox("#BtchType",{
            url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=deptType",
            mode:'remote',
            delay:200,
            valueField:'rowid',    
            textField:'name',
            onBeforeLoad:function(param){
                param.hospid = hospid;
                param.userdr = userid;
                param.str    = param.q;
            }
        });

        //批量添加 
        $("#BtchSave").unbind('click').click(function(){
            var User=$("#BtchUser").combobox("getValue");
            var Dept=$("#BtchDept").combobox("getValue");
            var Type=$("#BtchType").combobox("getValue");
            var IsBudg=$("#IsBudg").checkbox("getValue");
            if(IsBudg==true){
                IsBudg=1;
            }else{
                IsBudg=0;
            }
            console.log(IsBudg);
            if(User=="")
            {
                $.messager.popover({msg: '预算编制责任人不能为空！',type:'alert'});
                return;
            }
            if(Dept=="")
            {
                $.messager.popover({msg: '编制科室不能为空！',type:'alert'});
                return;
            }   
            $.m({
                ClassName:'herp.budg.udata.uBudgSchemAuditDept',MethodName:'Insert',schid:fromschemdr,Edit:Dept,UserDR:User,ObjType:Type,hospid:hospid,IsBudg:IsBudg},
                function(Data){
                    if(Data==0){
                        $.messager.popover({msg: '处理成功！',type:'success',timeout: 1000});
                    }else{
                        var message="错误!"
                        if(Data=="-1"){
                            message="预算已下达,禁止操作!"
                        }
                        $.messager.popover({msg: message,type:'error'});
                    }
                }
            );
            $Btchwin.window('close');
        });
        //取消 
        $("#BtchClose").unbind('click').click(function(){           
            $Btchwin.window('close');
        });

    }
    $("#BtchBn").click(function(){
        var row = $('#MainGrid').datagrid('getSelected'); 
        var ID="";
        if(row==null){
            $.messager.popover({msg: '请先选择方案！',type:'info',timeout: 2000,showType: 'show'});
            return
        }
        var ID=row.rowid;
        BtchFun(ID);
    });   
    /**批量功能  结束**/

}
