batchadd = function (year,schemdr1) {
	var $win;
    $win = $('#batchadd').window({
        title: '批量添加',
        width: 700,
        height: 500,
        top: ($(window).height() - 500) * 0.5,
        left: ($(window).width() - 700) * 0.5,
        shadow: true,
        modal: true,
        closed: true,
        minimizable: false,
        maximizable: false,
        collapsible: false,
        resizable: true,
	    onClose:function(){ //关闭关闭窗口后触发
           $("#DetailGrid").datagrid("reload"); //关闭窗口，重新加载主表格
        }
        
    });
    
    $win.window('open');
	$("#BaAddClose").click(function(){
        $win.window('close');
    });
    
	 // 年度的文本框赋默认值 
	$("#Year3Box").val(year);
	
	// 预算项类别的下拉框
    var TypeObj = $HUI.combobox("#TypeBox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=ItemType",
        mode:'remote',
        valueField:'code',    
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.flag = 1;
        },
        onSelect:function(data){
	        var value = $('#TypeBox').combobox('getValue');
	        $('#SupercodeBox').combobox('clear'); //清除原来的数据
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItemLevDisplay&hospid="+hospid+"&userdr="+userid+"&flag=0&year="+year+"&type="+value;
	        $('#SupercodeBox').combobox('reload', url);//联动下拉列表重载
	        
	        var Year = $('#Year3Box').val();
	        var Type = $('#TypeBox').combobox('getValue'); 
            BaDetailGridObj.load({
	            ClassName:"herp.budg.hisui.udata.uBudgSchemMain",
	            MethodName:"itemList",
	            hospid : hospid,
	            Year : Year,
	            Type : Type,
	            supercode : ""
	            })
	         $("#BaDetailGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
	         }
	 });
     
	//上级科目combox
    var SupCodeObj = $HUI.combobox("#SupercodeBox",{
        url:$URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItemLevDisplay",
        mode:'remote',
        delay:200,
        valueField:'code',   
        textField:'name',
        onBeforeLoad:function(param){
            param.str = param.q;
            param.hospid = hospid;
            param.userdr = userid;
            param.flag=0;
            param.year=year;
            param.type=$('#TypeBox').combobox('getValue')  
        },
        onSelect:function(data){
	        $("#SupercodeBox").combobox('setValue',data.name.replace(/&nbsp;/g, "")+" "+data.code);
	        
	        var Year = $('#Year3Box').val();
	        var Type = $('#TypeBox').combobox('getValue');
	        var supercode   = $('#SupercodeBox').combobox('getValue').split(" ")[1]; 
            BaDetailGridObj.load({
	            ClassName:"herp.budg.hisui.udata.uBudgSchemMain",
	            MethodName:"itemList",
	            hospid : hospid,
	            Year : Year,
	            Type : Type,
	            supercode : supercode
	            }) 
	        $("#BaDetailGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行  
	   }})

    //定义表格
    var Year = $('#Year3Box').val();
	var Type = $('#TypeBox').combobox('getValue');
	var supercode = $('#SupercodeBox').combobox('getValue').split(" ")[1]; 
    var BaDetailGridObj = $HUI.datagrid("#BaDetailGrid",{
        url:$URL,
        queryParams:{
            ClassName:"herp.budg.hisui.udata.uBudgSchemMain",
            MethodName:"itemList",
             hospid : hospid,
	         Year : Year,
	         Type : Type,
	         supercode : supercode   
        },
        fitColumns: false,//列固定
        loadMsg:"正在加载，请稍等…",
        autoRowHeight: true,
        autoSizeColumn:true, //调整列的宽度以适应内容
        rownumbers:true,//行号
        singleSelect: false, 
        checkOnSelect : true,//如果设置为 true，当用户点击某一行时，则会选中/取消选中复选框。如果设置为 false 时，只有当用户点击了复选框时，才会选中/取消选中复选框。
        selectOnCheck : true,//如果设置为 true，点击复选框将会选中该行。如果设置为 false，选中该行将不会选中复选框
        nowap : true,//禁止单元格中的文字自动换行
        pageSize:20,
        pageList:[10,20,30,50,100], //页面大小选择列表
        pagination:true,//分页
        fit:true,
        columns:[[
                {
	                field:'ck',
	                checkbox:true
	            },{
	                field:'rowid',
	                title:'ID',
	                width:80,
	                hidden: true
	            },{
	                field:'Year',
	                title:'年度',
	                width:80,
	                disable: true,
	                hidden: true,
	                allowBlank:false
				},{
	                field:'code',
	                title:'预算项编码',
	                width:150,
	                disable: true,
	                allowBlank:false
				},{
	                field:'name',
	                title:'预算项名称',
	                width:300,
	                disable: true,
	                allowBlank:false
				},{
	                field:'Level',
	                title:'预算项级别',
	                width:150,
	                disable: true,
	                allowBlank:false
				}
			]]
	})
		 
    
    //查询函数
    $("#FindBtn").unbind('click').click(function(){           
        var Year	    = $('#Year3Box').val();
        var Type	    = $('#TypeBox').combobox('getValue'); 
        var supercode   = $('#SupercodeBox').combobox('getValue').split(" ")[1];
        BaDetailGridObj.load({
	        ClassName:"herp.budg.hisui.udata.uBudgSchemMain",
	        MethodName:"itemList",
	        hospid : hospid,
	        Year : Year,
	        Type : Type,
	        supercode : supercode   
           });
           $("#BaDetailGrid").datagrid("unselectAll")  //取消选择所有当前页中所有的行
    })
    //////////////////////////确认、关闭/////////////////////////////// 
	$("#BaAddSave").unbind('click').click(function(){
		var rows = $('#BaDetailGrid').datagrid('getSelections');
		var len = rows.length;
		if (len < 1) {
			$.messager.popover({
		    msg:'请至少选择一个预算项！',
		    timeout: 2000,type:'alert',
		    showType: 'show',
		    style:{"position":"absolute","z-index":"9999",
		              left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
           return;
		} else {
			for (var i = 0; i < len; i++) {
				//console.log(i);
				var Code = rows[i].code.split("_")[0];
				var Level = rows[i].Level;
	     $.messager.progress({
			 title: '提示',
			 msg: '数据保存中...'
	                  }),
		 $.m({
            ClassName:"herp.budg.udata.uBudgSchemDetail",
            MethodName:"Insert", 
            SchemDR : schemdr1,
            Code : Code,
            Level : Level,
            CalFlag : "",
            IsCal : "",
            Formula : "",
            CalNo : "",
            CalDesc : "",
            IsSplit : "",
            SplitMeth : ""
            },
          
            function(SQLCODE){
                if(SQLCODE==0){
	                $.messager.popover({
		                msg: '保存成功！',
		                type:'success',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
	                $('#DetailGrid').datagrid("reload");
	              
                }else{
	               var message=""
	               if (SQLCODE=="RepName"){
		               $.messager.popover({
		                msg: '数据重复',
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2}})}
	               else{
		               $.messager.popover({
		                msg: '保存失败'+SQLCODE,
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2}})}}
	            
                $.messager.progress('close');
              }
			)}};
		$("#BaDetailGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行	
        $win.window('close');  
	});
	  $("BaAddClose").unbind('click').click(function(){
		  $("#BaDetailGrid").datagrid("unselectAll"); //取消选择所有当前页中所有的行
      $win.window('close');
     })
    }
	
	
											
