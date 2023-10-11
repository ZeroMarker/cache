var hospid=session['LOGON.HOSPID'];
BudgDetailFun = function(SpltMainDR)
{
	var $detailwin;
    $detailwin = $('#DetailWin').window({
        title: '分解比例系数维护',
        width: 860,
        height: 540,
        top: ($(window).height() - 540) * 0.5,
        left: ($(window).width() - 860) * 0.5,
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
    $detailwin.window('open');
    //取消 
    $("#DetailClose").unbind('click').click(function(){
        $detailwin.window('close');
    });
    // 科室类别的下拉框
    var DetailDTypeObj = $HUI.combobox("#DetailDType",{
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
    var EndEditFun = function() {
        var indexs=$("#DetailGrid").datagrid('getEditingRowIndexs')
        if(indexs.length>0){
            for(i=0;i<indexs.length;i++){
                $("#DetailGrid").datagrid("endEdit", indexs[i]);
            }
        }
    }
    DetailColumns=[[
    			{field:'ck',checkbox:true},  
                {field:'rowid',title:'ID',width:80,hidden: true},
                {field:'code',title:'编码科室',width:150,hidden: true},
                {field:'dname',title:'科室名称',width:100},
                {field:'SpltMainDR',title:'主表id',width:150,hidden: true},
                {field:'isAlComp',title:'是否独立核算',width:100,formatter:comboboxFormatter,
                    editor:{
                        type:'combobox',
                        options:{
                            valueField:'rowid',
                            textField:'name',
                            data: [
                                {'rowid': 0,'name': "否"},  
                                {'rowid': 1,'name': "是"}
                            ]
                        }
                    }
                },
                {field:'rate',title:'调节比例',width:150,
                	editor:{type:'validatebox',options:{validType:'OneToHundredNum'}}}
            ]];
    var DetailGrid = $HUI.datagrid("#DetailGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchSplitAccDept",
            MethodName:"ListItem",
            hospid    : hospid,
            rowid 	  : SpltMainDR,
            DeptType  : "",
            DeptCode  : "",
            DeptName  : ""   
        },
        fitColumns: true,
        striped : true,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:DetailColumns, 
        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发
            if ((field=="rate")||(field=="isAlComp")) {
               $("#DetailGrid").datagrid("beginEdit", index); 
            }
        },
        toolbar: '#Detailtb'         
    }); 
    //查询函数
    var DetailFindBtn= function()
    {
        var DType    = $('#DetailDType').combobox('getValue'); 
        var DCode    = $('#DetailDCode').val();  
        var DName    = $('#DetailDName').val();
        DetailGrid.load({
                ClassName:"herp.budg.hisui.udata.uBudgSchSplitAccDept",
	            MethodName:"ListItem",
	            hospid    : hospid,
	            rowid 	  : SpltMainDR,
	            DeptType  : DType,
	            DeptCode  : DCode,
	            DeptName  : DName 
            })
    } 
    // 点击查询按钮 
    $("#DetailFind").click(DetailFindBtn);
     //保存按钮
    $("#DetailSaveBn").click(function(){
    	EndEditFun();
        var grid = $('#DetailGrid');
        var rows = grid.datagrid("getChanges");
        var rowIndex="",row="";
        if(rows.length>0){
            $.messager.confirm('确定','确定要保存修改的数据吗？',function(t){
                if(t){
                    for(var i=0; i<rows.length; i++){
                        row=rows[i];
                        saveOrder(row); //保存方法
                    }
                    grid.datagrid("reload");
                }
            })
        }
    })
    var saveOrder=function(row) {       
        $.m({
            ClassName:'herp.budg.udata.uBudgSchSplitAccDept',MethodName:'UpdateRate',rowid:row.rowid,
                Rate:row.rate,isAlComp:row.isAlComp},
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
                    }else{
                    	$.messager.popover({
	                        msg: "错误:"+Data,
	                        type:'error',
	                        showType:'show',
	                        style:{
	                            "position":"absolute", 
	                            "z-index":"9999",
	                            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
	                            top:10
	                        }               
	                    });
                    }
                }
        );            
    }
	/***********************批量处理函数*************************/
	// 批量修改
	$("#DetailBtchEdit").click(function(){
		var rows = $("#DetailGrid").datagrid('getSelections');
    	if(rows.length<1){
    		var message="请至少选择一个科室！"
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
            return;
    	}
		BatchEditFun(rows)
	})
	// 批量增加科室
	$("#DetailBtchAdd").click(function(){BatchAddFun()})
	//明细维护-批量修改调节比例
	BatchEditFun =function(rows){
		var $BatchEditwin;
	    $BatchEditwin = $('#BatchEditWin').window({
	        title: '调节比例设置',
	        width: 480,
	        height: 320,
	        top: ($(window).height() - 320) * 0.5,
	        left: ($(window).width() - 480) * 0.5,
	        shadow: true,
	        modal: true,
	        iconCls: 'icon-w-edit',
	        closed: true,
	        minimizable: false,
	        maximizable: false,
	        collapsible: false,
	        resizable: true,
	        onClose:function(){ //关闭关闭窗口后触发
	            $("#editff").form("reset");
	            $("#DetailGrid").datagrid("reload"); //关闭窗口，重新加载主表格
	        }
	    });
	    $BatchEditwin.window('open');
	    // 表单的垂直居中
	    xycenter($("#editcenter"),$("#editff"));

	    // 是否独立核算
	    var EditisAlCompObj = $HUI.combobox("#EditisAlComp",{
	        mode:'local', 
	        valueField:'rowid',    
	        textField:'name',
	        value:0,
	        data: [{
	                    'rowid': 1,
	                    'name': "是"
	                },{
	                    'rowid': 0,
	                    'name': "否"                
	        }]
	    });

	    //保存 
	    $("#BatchEditSave").unbind('click').click(function(){
	        var Ratio 	 = $("#BatchEditRatio").val();
	        var isAlComp = $("#EditisAlComp").combobox("getValue");

	        if(!((Ratio<100)&&(Ratio>0)))
	        {
	            $.messager.popover({
	                msg: "调节比例应该大于0小于100!",
	                type:'info',
	                showType:'show',
	                style:{
	                    "position":"absolute", 
	                    "z-index":"9999",
	                    left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
	                    top:10
	                }               
	            });
	            return;
	        } 

	        $.messager.confirm('确定','确定要修改这些科室吗？',
                function(t){
                    if(t){
                        for(var i=0; i<rows.length; i++){
                            row=rows[i];
                            $.m({
                                ClassName:'herp.budg.udata.uBudgSchSplitAccDept',MethodName:'UpdateRate',rowid:row.rowid,Rate:Ratio,isAlComp:isAlComp},
                                    function(Data){
                                        if(Data==0){
                                        	$.messager.popover({
						                        msg: '修改成功！',
						                        type:'success',
						                        showType:'show',
						                        style:{
						                            "position":"absolute", 
						                            "z-index":"9999",
						                            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
						                            top:10
						                        }               
						                    });
                                        }else{
                                            $.messager.popover({
						                        msg: "错误:"+Data,
						                        type:'error',
						                        showType:'show',
						                        style:{
						                            "position":"absolute", 
						                            "z-index":"9999",
						                            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
						                            top:10
						                        }               
						                    });
                                        }                                                    
                                    }
                            );
                        }
                        $("#DetailGrid").datagrid("reload");
                    }    
                }
            )
	        $BatchEditwin.window('close');
	    });
	    //取消 
	    $("#BatchEditClose").unbind('click').click(function(){
	        $BatchEditwin.window('close');
	    });

	}
    
	//明细维护-批量增加科室
	BatchAddFun = function() {
	    var $BatchAddWin;
	    $BatchAddWin = $('#BatchAddWin').window({
	        title: '科室选择',
	        width: 800,
	        height: 460,
	        top: ($(window).height() - 460) * 0.5,
	        left: ($(window).width() - 800) * 0.5,
	        shadow: true,
	        modal: true,
	        iconCls: 'icon-w-batch-add',
	        closed: true,
	        minimizable: false,
	        maximizable: false,
	        collapsible: false,
	        resizable: true,
	        onClose:function(){ //关闭关闭窗口后触发
	        	$('#BatchDCode').val("");
	        	$('#BatchDName').val("");
	            // $("#DetailGrid").datagrid("reload"); //关闭窗口，重新加载主表格
	        }
	    });
	    $BatchAddWin.window('open');
	    // 科室类别的下拉框
	    var BatchDTypeObj = $HUI.combobox("#BatchDType",{
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
	    BatchAddColumns=[[
			{field:'ck',checkbox:true},  
            {field:'rowid',title:'ID',width:80,hidden: true},
            {field:'Dcode',title:'科室代码',width:150},
            {field:'Dname',title:'科室名称',width:100},
            {field:'Dtype',title:'科室类别',width:150}
        ]];
        var BatchAddGrid = $HUI.datagrid("#BatchAddGrid",{
	        url:$URL,
	        queryParams:{
	            ClassName:"herp.budg.hisui.udata.uBudgSchSplitAccDept",
	            MethodName:"DeptList",
	            hospid    : hospid,
	            DeptType  : "",
	            DeptCode  : "",
	            DeptName  : ""   
	        },
	        fitColumns: true,
	        loadMsg:"正在加载，请稍等…",
	        autoRowHeight: true,
	        rownumbers:true,//行号
	        pageSize:20,
	        pageList:[10,20,30,50,100], //页面大小选择列表
	        pagination:true,//分页
	        fit:true,
	        columns:BatchAddColumns, 
	        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发
	            // if (field=="bssdrate") {
	            //    $("#DetailGrid").datagrid("beginEdit", index); 
	            // }
	        },
	        toolbar: '#BatchAddtb'         
	    }); 
	    //查询函数
	    var BatchFindBtn= function()
	    {
	        var BatchDType    = $('#BatchDType').combobox('getValue'); 
	        var BatchDCode    = $('#BatchDCode').val();  
	        var BatchDName    = $('#BatchDName').val();
	        BatchAddGrid.load({
	                ClassName:"herp.budg.hisui.udata.uBudgSchSplitAccDept",
		            MethodName:"DeptList",
		            hospid    : hospid,
		            DeptType  : BatchDType,
		            DeptCode  : BatchDCode,
		            DeptName  : BatchDName 
	            })
	    } 
	    // 点击查询按钮 
	    $("#BatchFind").click(BatchFindBtn);
	    //确定按钮 
	    $("#BatchAddSave").unbind('click').click(function(){
	    	var rows = $("#BatchAddGrid").datagrid('getSelections');
	    	if(rows.length<1){
	    		{
		            var message="请至少选择一个科室！"
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
		            return;
		        }
	    	}else{
	    		$.messager.confirm('确定','确定要添加这些科室吗？',
	                function(t){
	                    if(t){
	                        for(var i=0; i<rows.length; i++){
	                            row=rows[i];
	                            $.m({
	                                ClassName:'herp.budg.udata.uBudgSchSplitAccDept',MethodName:'InsertRec',SpltMainDR:SpltMainDR,hospid:hospid,DeptMonthCode:row.Dcode},
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
	                                        }else if(Data=="RepName"){
	                                        	var message="编码为"+row.Dcode+"的"+row.Dname+"已存在";
	                                            $.messager.popover({
							                        msg: message,
							                        type:'error',
							                        showType:'show',
							                        style:{
							                            "position":"absolute", 
							                            "z-index":"9999",
							                            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
							                            top:10
							                        }               
							                    });
	                                        }else{
	                                            $.messager.popover({
							                        msg: "错误:"+Data,
							                        type:'error',
							                        showType:'show',
							                        style:{
							                            "position":"absolute", 
							                            "z-index":"9999",
							                            left:document.body.scrollLeft/2 +document.documentElement.scrollLeft/2,
							                            top:10
							                        }               
							                    });
	                                        }                                                    
	                                    }
	                            );
	                        }
	                        $("#DetailGrid").datagrid("reload");
	                    }    
	                }
	            )	        

	    	}
	        $BatchAddWin.window('close');
	    });
	    //取消 
	    $("#BatchAddClose").unbind('click').click(function(){
	        $BatchAddWin.window('close');
	    });

	};
  
};