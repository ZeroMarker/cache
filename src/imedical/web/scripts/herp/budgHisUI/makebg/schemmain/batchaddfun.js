batchadd = function (year,schemdr1) {
	var $win;
    $win = $('#batchadd').window({
        title: '�������',
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
	    onClose:function(){ //�رչرմ��ں󴥷�
           $("#DetailGrid").datagrid("reload"); //�رմ��ڣ����¼��������
        }
        
    });
    
    $win.window('open');
	$("#BaAddClose").click(function(){
        $win.window('close');
    });
    
	 // ��ȵ��ı���Ĭ��ֵ 
	$("#Year3Box").val(year);
	
	// Ԥ��������������
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
	        $('#SupercodeBox').combobox('clear'); //���ԭ��������
	        var url = $URL+"?ClassName=herp.budg.hisui.common.ComboMethod&MethodName=GetItemLevDisplay&hospid="+hospid+"&userdr="+userid+"&flag=0&year="+year+"&type="+value;
	        $('#SupercodeBox').combobox('reload', url);//���������б�����
	        
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
	         $("#BaDetailGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
	         }
	 });
     
	//�ϼ���Ŀcombox
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
	        $("#BaDetailGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���  
	   }})

    //������
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
        fitColumns: false,//�й̶�
        loadMsg:"���ڼ��أ����Եȡ�",
        autoRowHeight: true,
        autoSizeColumn:true, //�����еĿ������Ӧ����
        rownumbers:true,//�к�
        singleSelect: false, 
        checkOnSelect : true,//�������Ϊ true�����û����ĳһ��ʱ�����ѡ��/ȡ��ѡ�и�ѡ���������Ϊ false ʱ��ֻ�е��û�����˸�ѡ��ʱ���Ż�ѡ��/ȡ��ѡ�и�ѡ��
        selectOnCheck : true,//�������Ϊ true�������ѡ�򽫻�ѡ�и��С��������Ϊ false��ѡ�и��н�����ѡ�и�ѡ��
        nowap : true,//��ֹ��Ԫ���е������Զ�����
        pageSize:20,
        pageList:[10,20,30,50,100], //ҳ���Сѡ���б�
        pagination:true,//��ҳ
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
	                title:'���',
	                width:80,
	                disable: true,
	                hidden: true,
	                allowBlank:false
				},{
	                field:'code',
	                title:'Ԥ�������',
	                width:150,
	                disable: true,
	                allowBlank:false
				},{
	                field:'name',
	                title:'Ԥ��������',
	                width:300,
	                disable: true,
	                allowBlank:false
				},{
	                field:'Level',
	                title:'Ԥ�����',
	                width:150,
	                disable: true,
	                allowBlank:false
				}
			]]
	})
		 
    
    //��ѯ����
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
           $("#BaDetailGrid").datagrid("unselectAll")  //ȡ��ѡ�����е�ǰҳ�����е���
    })
    //////////////////////////ȷ�ϡ��ر�/////////////////////////////// 
	$("#BaAddSave").unbind('click').click(function(){
		var rows = $('#BaDetailGrid').datagrid('getSelections');
		var len = rows.length;
		if (len < 1) {
			$.messager.popover({
		    msg:'������ѡ��һ��Ԥ���',
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
			 title: '��ʾ',
			 msg: '���ݱ�����...'
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
		                msg: '����ɹ���',
		                type:'success',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2}});
	                $('#DetailGrid').datagrid("reload");
	              
                }else{
	               var message=""
	               if (SQLCODE=="RepName"){
		               $.messager.popover({
		                msg: '�����ظ�',
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2}})}
	               else{
		               $.messager.popover({
		                msg: '����ʧ��'+SQLCODE,
		                type:'error',
		                style:{"position":"absolute","z-index":"9999",
		                       left:-document.body.scrollTop - document.documentElement.scrollTop/2}})}}
	            
                $.messager.progress('close');
              }
			)}};
		$("#BaDetailGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���	
        $win.window('close');  
	});
	  $("BaAddClose").unbind('click').click(function(){
		  $("#BaDetailGrid").datagrid("unselectAll"); //ȡ��ѡ�����е�ǰҳ�����е���
      $win.window('close');
     })
    }
	
	
											
