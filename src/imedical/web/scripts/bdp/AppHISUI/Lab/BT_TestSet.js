/// 名称: 项目组合套
/// 描述: 包含增删改查、维护项目组合套
/// 编写者: 基础数据平台组-钟荣枫
/// 编写日期: 2019-11-7
var init = function(){
	
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.LAB.BTTestSet&pClassMethod=SaveEntity&pEntityName=web.Entity.LAB.BTTestSet";
	
	$.extend($.fn.validatebox.defaults.rules, {   
	    maxLength: {   
	        validator: function(value, param){   
	            return param[0] >= value.length;   
	        },   
	        message: '请输入最大{0}位字符.'  
	    }   
	}); 
	
	//点击事件
	////点击查询按钮
	$("#btnSearch").click(function(e){
		SearchFunLib();
	});
	//点击重置按钮
	$("#btnRefresh").click(function(e){
		ClearFunLib();
	});

	//点击添加按钮
	$("#btnAdd").click(function(e){
		AddData();
	});
	//点击修改按钮
	$("#btnUpdate").click(function(e){
		UpdateData();
	});
	//点击删除按钮
	$("#btnDel").click(function (e) { 
			DelData();
	});
	//点击复制按钮
	$("#btnCopy").click(function (e) { 
		CopyFunLib();
	});
	
	//likefan 20200917
	//点击关联标本类型按钮
	$('#BtnSpecimen').bind('click', function(){
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var TestSetParref=record.RowID;
		var URLSpecimen="dhc.bdp.lab.bttestsetspecimen.csp?TestSetParref="+TestSetParref;
		if ('undefined'!==typeof websys_getMWToken)
		{
			URLSpecimen += "&MWToken="+websys_getMWToken() //增加token  
		}
		var titleTestSet=record.CName;
		$("#winSpecimen").show();  
		$('#winSpecimen').window({
			iconCls:'icon-paper',
			title:titleTestSet+"-关联标本类型",
			width:1090,
			height:500,
			modal:true,
			resizable:true,
			minimizable:false,
			maximizable:false,
			collapsible:false,
			content:'<iframe frameborder="0" src="'+URLSpecimen+'" width="99%" height="98%" scrolling="auto"></iframe>',
			onBeforeClose:function(){            
		　　　　 $('#mygrid').datagrid('reload');      
		　　}
		});
	});
	//点击关联工作小组按钮
	$('#BtnWorkGroupMachine').bind('click', function(){
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var TestSetParref=record.RowID;
		var URLWorkGroupMachine="dhc.bdp.lab.bttestsetworkgroupmachine.csp?TestSetParref="+TestSetParref;
		if ('undefined'!==typeof websys_getMWToken)
		{
			URLWorkGroupMachine += "&MWToken="+websys_getMWToken() //增加token  
		}
		var titleTestSet=record.CName;
		$("#winWorkGroupMachine").show();  
		$('#winWorkGroupMachine').window({
			iconCls:'icon-paper',
			title:titleTestSet+"-关联工作小组",
			width:1090,
			height:500,
			modal:true,
			resizable:true,
			minimizable:false,
			maximizable:false,
			collapsible:false,
			content:'<iframe frameborder="0" src="'+URLWorkGroupMachine+'" width="99%" height="98%" scrolling="auto"></iframe>',
			onBeforeClose:function(){            
		　　　　 $('#mygrid').datagrid('reload');      
		　　}
		});
	});
	
	/***************************************查询开始****************************************************/		
	$('#TextCode,#TextDesc').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
		if(event.keyCode == 27) {
		  ClearFunLib();
		}
	    
	});
	
	//医院 查询下拉框
	$('#TextHospital').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName',
		onSelect:function(record){
			SearchFunLib();
			
		}
	});
	//激活 查询下拉框
	$('#TextActive').combobox({ 
		 data:[{'value':'1','text':'是'},{'value':'0','text':'否'}],
		 valueField:'value',
		 textField:'text',
		 panelHeight:'auto',
		 onSelect:function(record){
			SearchFunLib();
		 }
	});

	/***************************************查询结束****************************************************/
	//适合性别下拉框
	$('#SpeciesDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTSpecies&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
		
	//医院下拉框
	$('#HospitalDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTHospital&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName',
		onSelect:function(record){			
			
			var HospitalDR=$('#HospitalDR').combobox('getValue');
			//标本类型下拉框
          	$('#SpecimenDR').combobox('setValue','');
          	var SpecimenDRurl=$URL+"?ClassName=web.DHCBL.LAB.BTSpecimen&QueryName=GetDataForCmb1&ResultSetType=array&hospital=" +HospitalDR;
          	$('#SpecimenDR').combobox('reload',SpecimenDRurl);

          	//默认容器下拉框
          	$('#ContainerDR').combobox('setValue','');
          	var ContainerDRurl=$URL+"?ClassName=web.DHCBL.LAB.BTContainer&QueryName=GetDataForCmb1&ResultSetType=array&hospital=" +HospitalDR;
          	$('#ContainerDR').combobox('reload',ContainerDRurl);

          	//工作小组下拉框
          	$('#WorkGroupMachineDR').combobox('setValue','');
          	var WorkGroupMachineDRurl=$URL+"?ClassName=web.DHCBL.LAB.BTWorkGroupMachine&QueryName=GetDataForCmb1&ResultSetType=array&hospital=" +HospitalDR;
          	$('#WorkGroupMachineDR').combobox('reload',WorkGroupMachineDRurl);

          	//采集提示下拉框
          	$('#CollectPromptDR').combobox('setValue','');
          	var CollectPromptDRurl=$URL+"?ClassName=web.DHCBL.LAB.BTCollectPrompt&QueryName=GetDataForCmb1&ResultSetType=array&hospital=" +HospitalDR;
          	$('#CollectPromptDR').combobox('reload',CollectPromptDRurl);

          	//医嘱所属工作组下拉框
          	$('#WorkGroupDR').combobox('setValue','');
          	var WorkGroupDRurl=$URL+"?ClassName=web.DHCBL.LAB.BTWorkGroup&QueryName=GetDataForCmb1&ResultSetType=array&hospital=" +HospitalDR;
          	$('#WorkGroupDR').combobox('reload',WorkGroupDRurl);

          	//取报告提示下拉框
          	$('#ReportPromptDR').combobox('setValue','');
          	var ReportPromptDRurl=$URL+"?ClassName=web.DHCBL.LAB.BTReportPrompt&QueryName=GetDataForCmb1&ResultSetType=array&hospital=" +HospitalDR;
          	$('#ReportPromptDR').combobox('reload',ReportPromptDRurl);

		}
	});
	//标本类型下拉框		
	$('#SpecimenDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTSpecimen&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
	//默认容器下拉框
	$('#ContainerDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTContainer&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
	//工作小组下拉框
	$('#WorkGroupMachineDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTWorkGroupMachine&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
	//默认条码数量下拉框
	
	 $("#MergeType").combobox({
           data:[{'value':'1','text':'1'},{'value':'2','text':'2'},{'value':'3','text':'3'},{'value':'4','text':'4'},{'value':'5','text':'5'}],
           valueField:'value',
           textField:'text',
           panelHeight:'auto'
      });

	//收费项目下拉框 
	$('#CostItemDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTCostItem&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
	//采集提示下拉框
	$('#CollectPromptDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTCollectPrompt&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
	//医嘱所属工作组下拉框
	$('#WorkGroupDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTWorkGroup&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});

	//取报告提示下拉框
	$('#ReportPromptDR').combobox({ 
		url:$URL+"?ClassName=web.DHCBL.LAB.BTReportPrompt&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'RowID',
		textField:'CName'
	});
	//{RowID:"",CName:"正常",Remark:"正常的表格看结果。RepFlag为空"},{RowID:"1",CName:"打印预览",Remark:"给HIS看报告查询接口返回打印预览标记。RepFlag为PrintPreview"},{RowID:"2",CName:"PDF",Remark:"给HIS看报告查询接口返回生成PDF路径，如果有的话。RepFlag为ftp全路径"}

	//报告模式下拉框
	$('#ReportShowType').combobox({ 
		data:[{'value':'','text':'正常'},{'value':'1','text':'打印预览'},{'value':'2','text':'PDF'}],
        valueField:'value',
        textField:'text',
        panelHeight:'auto',
		onChange:function(newValue,oldValue){
			ShowState(newValue);
		}
	});
	//报告模式下拉框
	$('#ReportType').combobox({ 
		data:[{'value':'N','text':'正常'},{'value':'P','text':'模板'}],
        valueField:'value',
        textField:'text',
        panelHeight:'auto'
	});

	//微生物耐药机制
	$("#MICDefDrugRule").combobox({
		url:$URL+"?ClassName=web.DHCBL.CT.BTMCResistanceItem&QueryName=GetDataForCmb1&ResultSetType=array",
		valueField:'Code',
		textField:'CName',
		multiple:true,
		rowStyle:'checkbox', //显示成勾选行形式
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false
	});
	
	ShowState=function(value){
		if(value==""){
			document.getElementById("Remark").innerHTML = "<div >"+ "<font style='color:green;'>正常的表格看结果。RepFlag为空</font></div>";
		}
		if(value==1){
			
			document.getElementById("Remark").innerHTML = "<div >"+ "<font style='color:green;'>给HIS看报告查询接口返回打印预览标记。RepFlag为PrintPreview</font></div>";
		}	
		if(value==2){
			document.getElementById("Remark").innerHTML = "<div >"+ "<font style='color:green;'>给HIS看报告查询接口返回生成PDF路径，如果有的话。RepFlag为ftp全路径</font></div>";
		}
	}
	ReturnReportShowType=function(value){
		if(value==""){
			return "正常"
		}
		else if(value=="1"){
			return "打印预览"
		}
		else if(value=="2"){
			return "PDF"
		}
	}

	ReturnReportType=function(value){
		if(value=="N"){
			return "正常"
		}
		else if(value=="P"){
			return "模板"
		}
		
	}
	//查询
	SearchFunLib=function(){
		var code=$("#TextCode").val()
		var desc=$("#TextDesc").val()
		var hospital=$("#TextHospital").combobox('getValue')
		var active=$("#TextActive").combobox('getValue')
		$('#mygrid').datagrid('load',  { 
			'ClassName':"web.DHCBL.LAB.BTTestSet",
			'QueryName':"GetList",
			'code': code,
			'desc': desc,
			'hospital':hospital,
			'active':active
		});
		$('#mygrid').datagrid('unselectAll');
	}
	//重置
	ClearFunLib=function(){
		$("#TextCode").val("")
		$("#TextDesc").val("")
		$("#TextHospital").combobox('setValue','')
		$("#TextActive").combobox('setValue','')
		$('#mygrid').datagrid('load',  { 
			'ClassName':"web.DHCBL.LAB.BTTestSet",
			'QueryName':"GetList"			
		}); 
		$('#mygrid').datagrid('unselectAll');
	}
	
	///添加、修改
	SaveFunLib=function(id)
	{

		var MICDefDrugRule=$("#MICDefDrugRule").combobox("getValues")
		$("#MICDefDrugRule").combobox("setValues",[])
		console.log(JSON.stringify(MICDefDrugRule))
		var Code=$("#Code").val()
		if ($.trim(Code)=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"info");
			return;
		}
		var CName=$("#CName").val()
		if ($.trim(CName)=="")
		{
			$.messager.alert('错误提示','名称不能为空!',"info");
			return;
		}

		var Hospital=$('#HospitalDR').combobox('getValue')	
		if ((Hospital==undefined)||(Hospital=="undefined") )
		{
			$.messager.alert('错误提示','医院请选择下拉列表里的值!',"info");
			return;
		}
		var Species= $('#SpeciesDR').combobox('getValue')
		if ((Species==undefined)||(Species=="undefined") )
		{
			$.messager.alert('错误提示','适合性别请选择下拉列表里的值!',"info");
			return;
		}	
		var Specimen=$('#SpecimenDR').combobox('getValue')	
		if ((Specimen==undefined)||(Specimen=="undefined") )
		{
			$.messager.alert('错误提示','默认标本类型请选择下拉列表里的值!',"info");
			return;
		}	
		var Container=$('#ContainerDR').combobox('getValue')
		if ((Container==undefined)||(Container=="undefined") )
		{
			$.messager.alert('错误提示','默认容器请选择下拉列表里的值!',"info");
			return;
		}	
		var WorkGroupMachine=$('#WorkGroupMachineDR').combobox('getValue')	
		if ((WorkGroupMachine==undefined)||(WorkGroupMachine=="undefined")||(WorkGroupMachine==""))
		{
			$.messager.alert('错误提示','默认工作小组请选择下拉列表里的值!',"info");
			return;
		}

		var CostItem=$('#CostItemDR').combobox('getValue')	
		if ((CostItem==undefined)||(CostItem=="undefined") )
		{
			$.messager.alert('错误提示','收费项目请选择下拉列表里的值!',"info");
			return;
		}
		var CollectPrompt=$('#CollectPromptDR').combobox('getValue')
		if ((CollectPrompt==undefined)||(CollectPrompt=="undefined") )
		{
			$.messager.alert('错误提示','采集提示请选择下拉列表里的值!',"info");
			return;
		}	
		var WorkGroup=$('#WorkGroupDR').combobox('getValue')
		if ((WorkGroup==undefined)||(WorkGroup=="undefined") )
		{
			$.messager.alert('错误提示','医嘱所属工作组请选择下拉列表里的值!',"info");
			return;
		}	
		var ReportPrompt=$('#ReportPromptDR').combobox('getValue')	
		if ((ReportPrompt==undefined)||(ReportPrompt=="undefined") )
		{
			$.messager.alert('错误提示','取报告提示请选择下拉列表里的值!',"info");
			return;
		}
		var MergeType=$('#MergeType').combobox('getValue')	
		if ((MergeType==undefined)||(MergeType=="undefined") )
		{
			$.messager.alert('错误提示','默认条码数量请选择下拉列表里的值!',"info");
			return;
		}

		//var RowID=$("#RowID").val()
		var result= tkMakeServerCall("web.DHCBL.LAB.BTTestSet","FormValidate",id,Code,Hospital);
		if(result==0){
			$.messager.confirm("提示", "确认要保存数据吗?", function (r) {
				if (r) {
					///保存
					$('#form-save').form('submit', { 
						url: SAVE_ACTION_URL, 
						onSubmit: function(param){
							param.MICDefDrugRule = JSON.stringify(MICDefDrugRule);
						},
						success: function (data) { 
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
									
									$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});							
									if (id!="")
									{
										$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
									}
									else{
										
										 $.cm({
											ClassName:"web.DHCBL.LAB.BTTestSet",
											QueryName:"GetList",
											rowid: data.id   
										},function(jsonData){
											$('#mygrid').datagrid('insertRow',{
												index:0,
												row:jsonData.rows[0]
											})
										})
										 $('#mygrid').datagrid('unselectAll');
									}
									$('#myWin').dialog('close'); // close a dialog
							  } 
							  else { 
									var errorMsg ="保存失败！"
									if (data.errorinfo) {
										errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
									}
									$.messager.alert('操作提示',errorMsg,"error");
							  }
						} 
					});	
				}
			})
		}else{
			$.messager.alert('操作提示',"该记录已经存在！","info");
		}					

	}
	//清空弹出框数据
	ClearWinFun=function(){
		$('#SpeciesDR').combobox('reload');
		$('#HospitalDR').combobox('reload');
		$('#SpecimenDR').combobox('reload');
		$('#ContainerDR').combobox('reload');
		$('#WorkGroupMachineDR').combobox('reload');
		$('#CostItemDR').combobox('reload');
		$('#CollectPromptDR').combobox('reload');
		$('#WorkGroupDR').combobox('reload');
		$('#ReportPromptDR').combobox('reload');
		$('#MICDefDrugRule').combobox('reload');

	}
	//点击添加按钮
	AddData=function () 
	{	
		ClearWinFun();
		$("#myWin").show();
		
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				//iconCls:'icon-save',
				id:'save_btn',
				handler:function(){
					SaveFunLib("")														
				}
			},{
				text:'关闭',
				//iconCls:'icon-cancel',
				handler:function(){
					myWin.close();
				}
			}]
		});	
		$('#form-save').form("clear");
		
		$HUI.checkbox("#Active").setValue(true);
		$HUI.checkbox("#Urgent").setValue(false);
		$('#Urgent').parent().removeClass("checked");
		$HUI.checkbox("#ExtraFlag").setValue(false);
		$('#ExtraFlag').parent().removeClass("checked");
		$HUI.checkbox("#PositiveAlarn").setValue(false);
		$('#PositiveAlarn').parent().removeClass("checked");
	}
	
	//点击修改按钮
	UpdateData=function () 
	{
		ClearWinFun();	
		
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		else{
			var id=record.RowID;
			$.cm({
				ClassName:"web.DHCBL.LAB.BTTestSet",
				MethodName:"OpenData",
				id: id      ///rowid
			},function(jsonData){		
				if (jsonData.Urgent==1)
				{
					$HUI.checkbox("#Urgent").setValue(true);
				}else{
					$HUI.checkbox("#Urgent").setValue(false);
				}
				
				if (jsonData.Active==1)
				{
					$HUI.checkbox("#Active").setValue(true);
				}else{
					$HUI.checkbox("#Active").setValue(false);
				}
				if (jsonData.ExtraFlag==1)
				{
					$HUI.checkbox("#ExtraFlag").setValue(true);	
				}else{
					$HUI.checkbox("#ExtraFlag").setValue(false);
				}
				if (jsonData.PositiveAlarn==1)
				{
					$HUI.checkbox("#PositiveAlarn").setValue(true);	
				}else{
					$HUI.checkbox("#PositiveAlarn").setValue(false);
				}
				ShowState(jsonData.ReportShowType);		//修改时加载报告模式说明
				
				$('#form-save').form("load",jsonData);
				$("#MICDefDrugRule").combobox("setValues",JSON.parse(jsonData.MICDefDrugRule))
			});	
			$("#myWin").show();
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[{
					text:'保存',
					id:'save_btn',
					handler:function(){						
						SaveFunLib(id)									
					}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}]
			});			
		}
		
		
		
	}
	
	//点击删除按钮
	DelData=function()
	{
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var rowid=row.RowID;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				var datas = tkMakeServerCall("web.DHCBL.LAB.BTTestSet","DeleteData",rowid);
				var data = eval('('+datas+')');

			    if (data.success == 'true') {
			        $.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
			        $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
					$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据 							 
			       
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
	//复制
	CopyFunLib=function(){

		ClearWinFun();
		
		var record = $("#mygrid").datagrid("getSelected"); 
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		else{
			var id=record.RowID;
			$.cm({
				ClassName:"web.DHCBL.LAB.BTTestSet",
				MethodName:"OpenData",
				id: id      ///rowid
			},function(jsonData){	
				jsonData.RowID=""
				if (jsonData.Urgent==1)
				{
					$HUI.checkbox("#Urgent").setValue(true);
				}else{
					$HUI.checkbox("#Urgent").setValue(false);
				}
				
				if (jsonData.Active==1)
				{
					$HUI.checkbox("#Active").setValue(true);
				}else{
					$HUI.checkbox("#Active").setValue(false);
				}
				if (jsonData.ExtraFlag==1)
				{
					$HUI.checkbox("#ExtraFlag").setValue(true);	
				}else{
					$HUI.checkbox("#ExtraFlag").setValue(false);
				}
				if (jsonData.PositiveAlarn==1)
				{
					$HUI.checkbox("#PositiveAlarn").setValue(true);	
				}else{
					$HUI.checkbox("#PositiveAlarn").setValue(false);
				}
				ShowState(jsonData.ReportShowType);		//加载报告模式说明
				$('#form-save').form("load",jsonData);
			});	
			$("#myWin").show();
			var myWin = $HUI.dialog("#myWin",{
				iconCls:'icon-w-copy',
				resizable:true,
				title:'复制',
				modal:true,
				buttons:[{
					text:'保存',
					id:'save_btn',
					handler:function(){
						
						SaveFunLib("")
					}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}]
			});			
		}	
	}
	function sort_int(a,b){  
	    if(a.length > b.length) return 1;
	        else if(a.length < b.length) return -1;
	        else if(a > b) return 1;
	        else return -1;
	}  

	var columns =[[  
				  {field:'RowID',title:'RowID',width:60,sortable:true,hidden:true}, //,hidden:true
				  {field:'Sequence',title:'序号',width:50,sortable:true,sorter:sort_int},//,sorter:sort_int
				  {field:'Code',title:'代码',width:80,sortable:true},
				  {field:'CName',title:'名称',width:180,sortable:true},
				  {field:'EName',title:'英语名称',width:150,sortable:true},
				  {field:'Description',title:'详细描述',width:150,sortable:true},
				  {field:'HISCode',title:'HIS对照码',width:100,sortable:true},
				  {field:'HospitalDR',title:'医院',width:200,sortable:true},
				  {field:'Active',title:'激活',align:'center',formatter:ReturnFlagIcon,width:60,sortable:true},
				  {field:'SpeciesDR',title:'适合性别',width:80,sortable:true},
				  {field:'SpecimenDR',title:'默认标本类型',width:100,sortable:true},
				  {field:'ContainerDR',title:'默认容器',width:100,sortable:true},
				  {field:'MergeType',title:'默认条码数量',width:100,sortable:true},
				  {field:'WorkGroupMachineDR',title:'默认工作小组',width:180,sortable:true},
				  {field:'CostItemDR',title:'收费项目',width:200,sortable:true},
				  {field:'WorkGroupDR',title:'所属工作组',width:100,sortable:true},
				  {field:'CollectPromptDR',title:'采集提示',width:180,sortable:true},
				  {field:'ReportPromptDR',title:'取报告提示',width:100,sortable:true},
				  {field:'ReportShowType',title:'报告模式',formatter:ReturnReportShowType,width:80,sortable:true},
				  {field:'ReportType',title:'报告类型',formatter:ReturnReportType,width:80,sortable:true},
				  {field:'WorkRatio',title:'测试数',width:60,sortable:true},
				  {field:'MICDefDrugRule',title:'微生物耐药机制',width:120,sortable:true},
				  {field:'ReportRemark',title:'报告说明',width:200,sortable:true},
				  {field:'Urgent',title:'允许急诊',align:'center',formatter:ReturnFlagIcon,width:80,sortable:true},
				  {field:'ExtraFlag',title:'附加处理',align:'center',formatter:ReturnFlagIcon,width:80,sortable:true},
				  {field:'PositiveAlarn',title:'阳性报警',align:'center',formatter:ReturnFlagIcon,width:80,sortable:true}
	 ]];
	 
	 
	var mygrid = $HUI.datagrid("#mygrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCBL.LAB.BTTestSet",         ///调用Query时
			QueryName:"GetList"
		},
		ClassTableName:'dbo.BTTestSet',
		SQLTableName:'dbo.BT_TestSet',
		idField:'RowID',
		columns: columns,  //列信息
		pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000], 
		singleSelect:true,
		rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:false, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		remoteSort:false,  //定义是否从服务器排序数据。true
		
		onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
        },
        onClickRow:function(rowIndex,rowData){
        
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }/*,onSortColumn:function(sort, order){
        	return false;
        },onSortColumn:function(sort, order){
        	if (order=="asc"){
        		//$('#mygrid').datagrid('reload');
        		$('#mygrid').datagrid('load',  { 
					'ClassName':"web.DHCBL.LAB.BTTestSet",
					'QueryName':"GetList"
				});
        	}else{
        		//"DESC"
        		alert("desc")	
        	}
        }*/
	});
	ShowUserHabit('mygrid');
	HISUI_Funlib_Translation('mygrid');
    HISUI_Funlib_Sort('mygrid');
};
$(init);
