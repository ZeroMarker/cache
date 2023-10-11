 /**
 * @Author: 钟荣枫 DHC-BDP
 * @Description: 医嘱项接收科室手工维护。
 * @Created on 2012-6-23

 */
 var init=function(){
 	var windowHight = document.documentElement.clientHeight;		//可获取到高度
 	var windowWidth = document.documentElement.clientWidth;
 	var addurl="dhc.bdp.ct.arcitemmastrecloc.csp"
    var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.ARCItmRecLoc&pClassMethod=AddReceiveLoc";
	window.onload=function(){
    	var data=tkMakeServerCall("web.DHCBL.CT.CTHospital","OpenData",session['LOGON.HOSPID'])
	    var data = eval('(' + data + ')');
	    var defaultHosp=data.list[0].HOSPDefaultHospitalDR  
		$('#MastHosp').combobox("setValue",defaultHosp)
		ReloadOECOrderCategory()
		ReloadMastCat()
		SearchItemMast();
		ReloadPatLoc()	
		$("#RecLocGrid").datagrid("loadData",[])	
	}
    var mastcolumns =[[
        {field:'ARCIMRowId',title:'ID',sortable:true,width:100,hidden:true},
        {field:'ARCIMCode',title:'代码',sortable:true,width:50},
        {field:'ARCIMDesc',title:'描述',sortable:true,width:100}/*,
        {field:'OECOrderCatDR',title:'医嘱大类',sortable:true,width:100},
        {field:'ARCIMItemCatDR',title:'医嘱子类',sortable:true,width:100}*/
        
    ]];
    var ItemMast = $HUI.datagrid("#ItemMast",{
        
        columns: mastcolumns,  //列信息
        pagination: true,   //pagination  boolean 设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        nowrap:false,	//过长自动换行
        remoteSort:false,
        idField:'ARCIMRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
        toolbar: "#mastbar",               
        onLoadSuccess:function(){
            
        },
        onClickRow:function(row,index)
        {
        	ResetRecLoc()
        	SearchRecLoc()
        }       
    });
    	
    /*$('#MastHosp').css({ 
		"width": $(window).width()*0.7/10  	
	})
	$('#MastSub').css({ 
		"width": $(window).width()*0.7/10  	
	})
	$('#MastCat').css({ 
		"width": $(window).width()*0.7/10  	
	})
	$('#MastDesc').css({ 
		"width": $(window).width()*0.69/10  	
	})
	$('#MastCode').css({ 
		"width": $(window).width()*0.69/10  	
	})*/
	//医嘱项内 医院下拉框
	$('#MastHosp').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.BDP.BDPMappingHOSP&QueryName=GetHospDataForCombo&ResultSetType=array&tablename=ARC_ItemMast",
		valueField:'HOSPRowId',
		textField:'HOSPDesc',
		panelMinWidth:150,
		panelWidth:150,
		onSelect:function(record){
			ReloadOECOrderCategory()
			ReloadMastCat()
			SearchItemMast();
			ReloadPatLoc()
		}
	});
	//重载医嘱大类
	ReloadOECOrderCategory=function(){
		$('#MastSub').combobox('setValue','');
		var MastHosp=$('#MastHosp').combobox('getValue');
		var url=$URL+"?ClassName=web.DHCBL.CT.OECOrderCategory&QueryName=GetDataForCmb1&ResultSetType=array&hospid=" +MastHosp;
      	$('#MastSub').combobox('reload',url);
	}
 	//医嘱大类下拉框 
	$('#MastSub').combobox({ 
		valueField:'ORCATRowId',
		textField:'ORCATDesc',
		panelMinWidth:150,
		panelWidth:150,
		onSelect:function(record){
			ReloadMastCat()
			SearchItemMast();
		}
	});
	//重载医嘱子类
	ReloadMastCat=function(){
		$('#MastCat').combobox('setValue','');
		var MastHosp=$('#MastHosp').combobox('getValue');
		var Sub=$('#MastSub').combobox('getValue');
		var url=$URL+"?ClassName=web.DHCBL.CT.ARCItemCat&QueryName=GetDataForCmb1&ResultSetType=array&ordcat=" +Sub+"&hospid=" +MastHosp;
      	$('#MastCat').combobox('reload',url);
	}

	//医嘱项内 医嘱子类下拉框
	$('#MastCat').combobox({ 
		panelMinWidth:150,
		panelWidth:150,
		valueField:'ARCICRowId',
		textField:'ARCICDesc',
		onSelect:function(record){
			SearchItemMast();
		}
	});


	//医嘱项描述查找
	$('#MastDesc,#MastCode').keyup(function(event){
        if(event.keyCode == 13) {
          SearchItemMast();
        }
        if(event.keyCode == 27) {        	
          ClearItemMast();
        }
        
    });

    //点击搜索按钮
	$("#btnMastSearch").click(function (e) { 
		SearchItemMast();
	});	
	 //点击重置按钮
	$("#btnMastReset").click(function (e) { 
		ClearItemMast();
	});	 
	

	//重置医嘱项
	 ClearItemMast=function(){
	 	$('#ItemMast').datagrid("clearSelections"); 
	 	//$('#MastHosp').combobox('reload');		
		$('#MastSub').combobox('setValue','');	
		$('#MastCat').combobox('setValue','');
		$("#MastCode").val("")
		$("#MastDesc").val("")
		SearchItemMast();		
	 } 	
 	//查找医嘱项
 	SearchItemMast=function(){
 		var hosp=$('#MastHosp').combobox('getValue');		
		var sub=$('#MastSub').combobox('getValue');	
		var cat=$('#MastCat').combobox('getValue');
		var code=$("#MastCode").val()
		var desc=$("#MastDesc").val()
 		//$('#ItemMast').datagrid('clearSelections');		//清除选中		
		var options={};
        options.url=$URL;
        options.queryParams={
                ClassName: "web.DHCBL.CT.ARCItmMast",
                QueryName: "GetDataForCmb1",
                'code':code,
                'desc':desc,
				'hospid':hosp,
				'ordercat':sub,
				'subcat':cat
        } 
		$('#ItemMast').datagrid(options);
		$('#ItemMast').datagrid("clearSelections");
		$("#RecLocGrid").datagrid("loadData",[]) 					
 	}
 	//ARCRLRowId,ARCRLOrdLocDR,ARCRLOrdLocDesc,ARCRLRecLocDR,ARCRLRecLocDesc,ARCRLOrderPriorityDR,ARCRLOrderPriorityDesc,ARCRLDefaultFlag,ARCRLDateFrom,ARCRLDateTo,
 	////ARCRLTimeFrom,ARCRLTimeTo,ARCRLCTHospitalDR,ARCRLCTHospitalDesc,ARCRLClinicType
 	var columns=[[
 		{ field: 'ARCRLOrdLocDesc',title: '病人科室', width: 160 },
        { field: 'ARCRLRecLocDesc',title: '接收科室', width: 160 },
        { field: 'ARCRLCTHospitalDesc',title: '医院', width: 160},
        { field: 'ARCRLOrderPriorityDesc',title: '医嘱优先级', width: 80 },
        { field: 'ARCRLDefaultFlag',title: '默认', width: 50,align:'center',formatter:ReturnFlagIcon},
        { field: 'ARCRLDateFrom',title: '开始日期', width: 90 },
        { field: 'ARCRLDateTo',title: '结束日期', width: 90 },
        { field: 'ARCRLTimeFrom',title: '开始时间', width: 80,},
        { field: 'ARCRLTimeTo',title: '结束时间', width: 80 }, 
        { field: 'ARCRLRowId',title: 'ARCRLRowId', width: 30,  hidden:true},
        { field: 'ARCRLOrdLocDR',title: '病人科室Dr', width: 30,  hidden:true},
        { field: 'ARCRLRecLocDR',title: '接收科室Dr', width: 30,  hidden:true},
        { field: 'ARCRLCTHospitalDR',title: '医院Dr', width: 30,  hidden:true},
        { field: 'ARCRLOrderPriorityDR',title: '医嘱优先级Dr', width: 30, hidden:true},
        { field: 'ARCRLClinicType', title: '就诊类型', width: 80}, 
        { field: 'ARCRLFunction', title: '功能', width: 80}
 	]]

	//接收科室
	var RecLocGrid=$HUI.datagrid('#RecLocGrid',{

		columns:columns,	
		idField:'ARCRLRowId',
		loadMsg:'',
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        showRefresh:false,
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],	
		singleSelect:true, //只允许选中一行
		remoteSort:false,    
		nowrap:false,	//过长自动换行
		rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动 
		toolbar: [],
        onLoadSuccess:function(data){
            
        },
        onClickRow:function(index,row){
        	SetValue(row)
        }     
	});		
	
	//新增
    $('#btnAdd').click(function(e) {
    	$.messager.confirm("提示", "确定要新增数据吗?", function (r) {
			if (r) {
				SaveFunLib("")
			} else {
				return ;
			}								
		});
        
    });	
    //修改
    $('#btnUpdate').click(function(e) {
    	var record=$("#RecLocGrid").datagrid("getSelected")
    	if (record){
    		var ID=record.ARCRLRowId
    		$.messager.confirm("提示", "确定要修改数据吗?", function (r) {
				if (r) {
					SaveFunLib(ID)
				} else {
					return ;
				}								
			});	        
    	}
    	else{
    		$.messager.alert('提示',"请选择一条数据！","info");
	        return
    	}	    	
    });	
    //删除
    $('#btnDelete').click(function(e) {
        DeleteFunlib()
    });	
    //查询
    $('#btnSearch').click(function(e) {
        SearchRecLoc()
    });	
    //重置
    $('#btnReset').click(function(e) {
        ResetRecLoc()
    });

    //删除方法
    DeleteFunlib=function(){
    	var record=$("#RecLocGrid").datagrid("getSelected")
    	if (record){
    		var ID=record.ARCRLRowId
    		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
				if (r){
					var datas=tkMakeServerCall("web.DHCBL.CT.ARCItmRecLoc","DeleteData",ID)
					var data = eval('('+datas+')');

				    if (data.success == 'true') {
				        $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
				        ResetRecLoc()
				        //$("#RecLocGrid").datagrid("reload")  // 重新载入当前页面数据 
						$('#RecLocGrid').datagrid('unselectAll');  // 清空列表选中数据 	

				    }
				    else{
				        var errorMsg ="删除失败！"
						if (data.info) {
							errorMsg =errorMsg+ '<br/>错误信息:' + data.info
						}
						$.messager.alert('操作提示',errorMsg,"error");
				    }				
				}
			});    		
    	}
    	else{
    		$.messager.alert('提示',"请选择一条数据！","info");
	        return
    	}	
    }
    //保存方法
    SaveFunLib=function(id){
    	var record=$("#ItemMast").datagrid("getSelected")
    	if (record){ 
    		var ItemMastID=record.ARCIMRowId
    		var PatLoc=$("#PatLoc").combobox("getValue")
			var RecLoc=$("#RecLoc").combobox("getValue")
			var Priority=$("#Priority").combobox("getValue")
			var DateFrom=$('#DateFrom').datebox("getValue")
			var DateTo=$('#DateTo').datebox("getValue")
			var TimeFrom=$('#TimeFrom').timespinner("getValue")
			var TimeTo=$('#TimeTo').timespinner("getValue")
			var Hospital=$("#Hospital").combobox("getValue")
			var ClinicType=$('#ClinicType').combobox("getValue")
			var FunctionValue=$('#Function').combobox("getValue")
			var DefaultFlag=$('#DefaultFlag').checkbox('getValue');
			if(DefaultFlag==true){
				DefaultFlag="Y";
			}
			else{
				DefaultFlag="N";
			}
			var result=""
			if(RecLoc==""){
				$.messager.alert('提示',"请选择接收科室!","info");
		  		return 
			 }
			 if((FunctionValue=="")||(FunctionValue=="undefined")||(FunctionValue==undefined)){
				$.messager.alert('提示',"请选择功能!","info");
		  		return
			}
			if (DateFrom == "") {
				$.messager.alert('提示',"请添加开始日期!","info");			 	
		  		return ;
			}
			if (DateFrom != "" && DateTo != "") {
	    				
				if (DateFrom > DateTo) {
					$.messager.alert('提示',"开始日期不能大于结束日期!","info");					
					 	return;
					}
	   		}
	   		if (((TimeFrom=="")&&(TimeTo != ""))||((TimeFrom!="")&&(TimeTo== ""))) 
	   		{
	   			$.messager.alert('提示',"开始时间和结束时间需同时填写!","info");
	        				
	          	return;
	   		}
	   			 	
		 	if ((TimeFrom!="")&&(TimeTo != "")) {
		 		
		 		if (TimeFrom>=TimeTo) {
		 			$.messager.alert('提示',"结束时间必须大于开始时间!","info");			
				 	return;
				}
		 	}
		 	var flag=0;
		 	var str=Priority+"^"+TimeFrom+"^"+TimeTo+"^"+DateFrom+"^"+DateTo+"^"+Hospital+"^"+ClinicType+"^1"
		 	var parref=ItemMastID.split("||")[0]
			if (DefaultFlag=="Y"){
				flag=tkMakeServerCall("web.DHCBL.CT.ARCItmRecLoc","GetDefRecLoc",parref,id,RecLoc,str);
			}
			if (flag==1){
				$.messager.alert('提示',"已经存在默认规则!","info");
				return				
			}
			else if (flag==2)
			{
				$.messager.alert('提示',"医嘱项与病人科室不在同一个医院组!","info");
	            return
				
			}

	    	if (id=="")		//新增
	    	{
	    		var savestr=ItemMastID+"^"+PatLoc+"^"+RecLoc+"^"+Priority+"^"+DateFrom+"^"+DateTo+"^"+TimeFrom+"^"+TimeTo+"^"+DefaultFlag+"^"+FunctionValue+"^"+Hospital+"^"+ClinicType	      	
		      	result=tkMakeServerCall("web.DHCBL.CT.ARCItmRecLoc","AddReceiveLoc",savestr);
		      	result=eval("("+result+")")
	            if (result.success=="true")
	            {
	            	ResetRecLoc()
	            	//$("#RecLocGrid").datagrid("reload")
	                $.messager.popover({msg: '新增成功！',type: 'success',timeout: 1000});
	            }
	            else
	            {

	            	$.messager.alert('提示',"新增失败!<br/>错误信息:"+ result.info,"info");
	            	return
	            }
	    	}
	    	else	//修改
	    	{	    		 
	    		var savestr=id+"^"+PatLoc+"^"+RecLoc+"^"+Priority+"^"+DateFrom+"^"+DateTo+"^"+TimeFrom+"^"+TimeTo+"^"+DefaultFlag+"^"+FunctionValue+"^"+Hospital+"^"+ClinicType	      	
		      	result=tkMakeServerCall("web.DHCBL.CT.ARCItmRecLoc","UpdateRecLoc",savestr);
		      	result=eval("("+result+")")
	            if (result.success=="true")
	            {
	            	ResetRecLoc()
	            	//$("#RecLocGrid").datagrid("reload")
	                $.messager.popover({msg: '修改成功！',type: 'success',timeout: 1000});
	            }
	            else
	            {
	            	$.messager.alert('提示',"修改失败!<br/>错误信息:"+ result.info,"info");
	            }
	    	}		    			    	
    	}
    	else
    	{
    		$.messager.alert('提示',"请选择医嘱项！","info");
	        return
    	}	    
	    	
    }
    //赋值
    SetValue=function(record){
    	if (record){
    		var PatLoc=record.ARCRLOrdLocDR
    		var RecLoc=record.ARCRLRecLocDR
    		var Priority=record.ARCRLOrderPriorityDR
    		var DateFrom=record.ARCRLDateFrom
    		var DateTo=record.ARCRLDateTo
    		var TimeFrom=record.ARCRLTimeFrom
    		var TimeTo=record.ARCRLTimeTo
    		var Hospital=record.ARCRLCTHospitalDR
    		var ClinicType=record.ARCRLClinicType
    		var FunctionValue=record.ARCRLFunction
    		var DefaultFlag=record.ARCRLDefaultFlag
    		$HUI.checkbox("#DefaultFlag").setValue(false);
    		if (ClinicType=="门诊")
    		{
    			ClinicType="O"
    		}
    		else if (ClinicType=="急诊")
    		{
    			ClinicType="E"
    		}
    		else if (ClinicType=="住院")
    		{
    			ClinicType="I"
    		}
    		else if (ClinicType=="体检")
    		{
    			ClinicType="H"
    		}
    		else if (ClinicType=="新生儿")
    		{
    			ClinicType="N"
    		}
			if ((DefaultFlag=="Y")||(DefaultFlag=="是"))	
			{
				DefaultFlag="true"
				$HUI.checkbox("#DefaultFlag").setValue(true);
				//$("#DefaultFlag").checkbox({checked: DefaultFlag});
			}
			else
			{
				DefaultFlag="false"
			}
    		$("#PatLoc").combobox("setValue",PatLoc)
	    	$("#RecLoc").combobox("setValue",RecLoc)
	    	$('#Priority').combobox('setValue',Priority);	
	    	$('#DateFrom').datebox('setValue', DateFrom);	
			$('#DateTo').datebox('setValue', DateTo);	
			$('#TimeFrom').timespinner('setValue',TimeFrom);			
			$('#TimeTo').timespinner('setValue',TimeTo);
	    	$("#Hospital").combobox("setValue",Hospital)
	    	$('#ClinicType').combobox('setValue',ClinicType);	
			$('#Function').combobox('setValue',FunctionValue);
			//$("#DefaultFlag").checkbox("setValue",DefaultFlag);
			//$HUI.checkbox("#DefaultFlag").setValue(DefaultFlag);
			
	    	
    	}
	    	
    }
    //查询
    SearchRecLoc=function(){
    	var record=$("#ItemMast").datagrid("getSelected")
    	if (record)
    	{
    		var ID=record.ARCIMRowId
    		var patloc=$("#PatLoc").combobox("getValue")
	    	var recloc=$("#RecLoc").combobox("getValue")
	    	var hospital=$("#Hospital").combobox("getValue")
	    	var options={};
	        options.url=$URL;
	        options.queryParams={
	                ClassName: "web.DHCBL.CT.ARCItmRecLoc",
	                QueryName: "GetList",
	                'PatLoc':patloc,
	                'RecLoc':recloc,
					'HospId':hospital,
					'ParRef':ID
	        } 
			$('#RecLocGrid').datagrid(options); 
			$('#RecLocGrid').datagrid("clearSelections")
    	}
	    	
    }
    //重置
    ResetRecLoc=function(){
    	$("#PatLoc").combobox("setValue","")
    	$("#RecLoc").combobox("setValue","")
    	$("#Hospital").combobox("setValue","")
    	$('#Priority').combobox('setValue',"");	//置空医嘱优先级
		$('#Function').combobox('setValue',"Execute");	//置空功能
		$('#ClinicType').combobox('setValue',"");	

    	$('#DateFrom').datebox('setValue', getCurentDateStr());	
		$('#DateTo').datebox('setValue', "");	
		$('#TimeFrom').timespinner('setValue',"");			
		$('#TimeTo').timespinner('setValue',"");	
		$HUI.checkbox("#DefaultFlag").setValue(false);
		SearchRecLoc()
    }	

    //重载医嘱子类
	ReloadPatLoc=function(){
		$('#PatLoc').combobox('setValue','');
		var MastHosp=$('#MastHosp').combobox('getValue');
		var url=$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmbGroup&ResultSetType=array&tablename=ARC_ItmMast&hospid=" +MastHosp;
      	$('#PatLoc').combobox('reload',url);
	}

	//病人科室下拉框
	$('#PatLoc').combobox({ 
		//url:$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTLOCRowID',
		textField:'CTLOCDesc',
		panelMinWidth:150,
		panelWidth:150,
		width:(windowWidth-565)*0.2
	});

	//接收科室下拉框
	$('#RecLoc').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTLoc&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'CTLOCRowID',
		textField:'CTLOCDesc',
		panelMinWidth:150,
		panelWidth:150,
		width:(windowWidth-565)*0.2
	});

	//医院下拉框
	$('#Hospital').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.CTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'HOSPRowId',
		textField:'HOSPDesc',
		panelMinWidth:150,
		panelWidth:150,
		width:(windowWidth-565)*0.2
	});

	//就诊类型   就诊类型(门诊O,急诊E,住院I,体检H,新生儿N)
	$('#ClinicType').combobox({ 
		data:[
			{id:'O',text:'门诊'},{id:'E',text:'急诊'},{id:'I',text:'住院'}
			,{id:'H',text:'体检'},{id:'N',text:'新生儿'}
		],
		valueField:'id',
		textField:'text',
		width:(windowWidth-565)*0.2
		
	});
	
	$('#DateFrom').datebox({ 
		width:(windowWidth-565)*0.2
	})
	$('#DateTo').datebox({ 
		width:(windowWidth-565)*0.2
	})
	/*$("#TimeFrom").timespinner('spinner').attr('width',(windowWidth-565)*0.2);
	$("#TimeTo").timespinner('spinner').attr('width',(windowWidth-565)*0.2);
	$("#TimeFrom").timespinner('textbox').attr('width',(windowWidth-565)*0.2-22);
	$("#TimeTo").timespinner('textbox').attr('width',(windowWidth-565)*0.2-22);*/
	var ele=document.getElementById("TimeFrom")
	var ele2=$('#TimeFrom')
	/*$('#TimeFrom').timespinner({
		width:(windowWidth-565)*0.2
	})
	$('#TimeTo').timespinner({
		width:(windowWidth-565)*0.2
	})*/
	$('#TimeFrom').timespinner('resize',(windowWidth-565)*0.2)
	$('#TimeTo').timespinner('resize',(windowWidth-565)*0.2)
	/*$("#TimeFrom").timespinner('textbox').attr('width',(windowWidth-565)*0.2-22);
	document.getElementById("TimeFrom").setAttribute('width', (windowWidth-565)*0.2-20);
	document.getElementById("TimeTo").setAttribute('width', (windowWidth-565)*0.2-20);
	*/
	//医嘱优先级下拉框 
	$('#Priority').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.CT.OECPriority&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'OECPRRowId',
		textField:'OECPRDesc',
		width:(windowWidth-565)*0.2
	});	
	//功能
	$('#Function').combobox({ 
		data:[{'value':'Execute','text':'Execute'},{'value':'Processing','text':'Processing'}],
		valueField:'value',
		textField:'text',
		width:(windowWidth-565)*0.2,
		onLoadSuccess:function(){
			$(this).combobox("setValue","Execute")
		}		
	});	
	//获取当前日期
	function getCurentDateStr()
	{ 
		var now = new Date();
	    var year = now.getFullYear();       //年
	    var month = now.getMonth() + 1;     //月
	    var day = now.getDate();            //日
	    var clock = year + "-";
	    if(month < 10) clock += "0";       
	    clock += month + "-";
	    if(day < 10) clock += "0"; 
	    clock += day;
	    return clock; 
	}

	$('#DateFrom').datebox('setValue', getCurentDateStr());	//开始日期默认当天	

}
 $(init);