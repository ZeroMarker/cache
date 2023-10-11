var hospid=session['LOGON.HOSPID'];
DetailFun = function(RowId)
{
	var $detailwin;
    $detailwin = $('#DetailWin').window({
        title: '分解比例系数维护',
        width: 500,
        height: 480,
        top: ($(window).height() - 480) * 0.5,
        left: ($(window).width() - 500) * 0.5,
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
                {field:'bssdspltmaindr',title:'分解主表ID',width:150,hidden: true},
                {field:'bmcode',title:'月份',width:100},
                {field:'bssdrate',title:'调节比例',width:150,
                	editor:{type:'validatebox',options:{validType:'OneToHundredNum'}}}
            ]];
    var DetailGrid = $HUI.datagrid("#DetailGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemSplitYearMonth",
            MethodName:"ListDetail",
            hospid    : hospid,
            RowId 	  : RowId   
        },
        fitColumns: true,
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        rownumbers:true,//行号
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:DetailColumns, 
        onClickCell: function(index,field,value){   //在用户点击一个单元格的时候触发
            if (field=="bssdrate") {
               $("#DetailGrid").datagrid("beginEdit", index); 
            }
        },
        toolbar: '#Detailtb'         
    });  
    /***********************保存函数*************************/
    //保存按钮
    $("#DetailSaveBn").unbind('click').click(function(){
        EndEditFun();
        //取到发生变化的记录对象
        var rows = $("#DetailGrid").datagrid("getChanges");
        var row="",data="";
        if(!rows.length){
        	$.messager.popover({
                msg: '没有内容需要保存！',
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
        }else{
            $.messager.confirm('确定','确定要保存数据吗？',
                function(t){
                    if(t){
                        for(var i=0; i<rows.length; i++){
                            row=rows[i];
                            var rowid = row.rowid;
                            var bssdrate=""
                            bssdrate = row.bssdrate;
                            var bmcode = row.bmcode;
                            $.m({
                                ClassName:'herp.budg.udata.uBudgSchemSplitYearMonth',MethodName:'UpdateRecDetail',rowid:rowid,hospid:hospid,RowId:RowId, bmcode:bmcode,bssdrate:bssdrate},
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
                        $("#DetailGrid").datagrid("reload");
                    }    
                }
            )
        }
    });
	
	/***********************批量处理函数*************************/
    //批量处理按钮
    $("#DetailBtchBn").click(function(){
    	var rows = $("#DetailGrid").datagrid("getSelections");
    	if(!rows.length){
        	$.messager.popover({
                msg: '请选择需要修改的数据！',
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
        }else{
        	detaileditFun(rows);
        }
    })
	//明细维护-批量处理--调节比例
	detaileditFun = function(rows) {
	    var $Detailbatchwin;
	    $Detailbatchwin = $('#DetailBatWin').window({
	        title: '修改调节比例',
	        width: 360,
	        height: 260,
	        top: ($(window).height() - 260) * 0.5,
	        left: ($(window).width() - 360) * 0.5,
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
	    $Detailbatchwin.window('open');
	    // 表单的垂直居中
	    xycenter($("#Detailbatch"),$("#Detailff"));

	    //保存 
	    $("#DetailBSave").unbind('click').click(function(){
	        var Ratio 	 = $("#DetailBRatio").val();
	        if((Ratio>=100)||(Ratio=="")||(Ratio<0))
	        {
	            var message="调节比例应该大于0小于100！"
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
	        var row="",data="";
            $.messager.confirm('确定','确定要修改比例吗？',
                function(t){
                    if(t){
                        for(var i=0; i<rows.length; i++){
                            row=rows[i];
                            var rowid = row.rowid;
                            var bssdrate=""
                            var bmcode = row.bmcode;
                            $.m({
                                ClassName:'herp.budg.udata.uBudgSchemSplitYearMonth',MethodName:'UpdateRecDetail',rowid:rowid,hospid:hospid,RowId:RowId, bmcode:bmcode,bssdrate:Ratio},
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
                        $("#DetailGrid").datagrid("reload");
                    }    
                }
            )	        
	        $Detailbatchwin.window('close');
	    });
	    //取消 
	    $("#DetailBClose").unbind('click').click(function(){
	        $Detailbatchwin.window('close');
	    });

	};
  
};