/// 名称: ICD诊断代码
/// 描述: ICD诊断代码，包含增删改查合并功能
/// 编写者: 基础数据平台组-谢海睿
/// 编写日期: 2019-6-27

///ofy1 兰大一院   自动生成最大代码  ,且ICD10 和ICD9 Map 互换fieldlabel  2016-12-23
///ofy2 南通中医院 添加导入按钮
///ofy3 兰大一院  如果勾选了肿瘤形态学编码或损伤中毒外部原因，则不校验描述
	//被合并项只隐藏掉，不删除。
	var MERGE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=MergeData&pEntityName=web.Entity.CT.MRCICDDx";
	var SEX_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.CTSex&pClassQuery=GetDataForCmb1";
	
	var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=GetList";
	//var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassQuery=GetList";
	var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.MRCICDDx";
	var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=OpenData";
	var COPY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=CopyData";
	
	//var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=DeleteData";
	
	var ICDALIAS_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.CT.MRCICDAlias&pClassQuery=GetList";
	var ICDALIAS_SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.MRCICDAlias&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.MRCICDAlias";
	var ICDALIAS_DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDAlias&pClassMethod=DeleteData";
	
var init = function(){
	var columns=[[
		{field:'DelFormId',title:'DelFormId',sortable:true,width:100,hidden:true},
		{field:'MRCIDRowId',title:'MRCIDRowId',sortable:true,width:100,hidden:true},
		{field:'MRCIDCode',title:'代码',sortable:true,width:100},
		{field:'MRCIDDesc',title:'描述',sortable:true,width:350},
		{field:'MRCIDICD9CMCode',title:'ICD10代码',sortable:true,width:100},
		{field:'MRCID2ndCodeInPair',title:'副编码',sortable:true,width:100},
		{field:'MRCIDICD9Map',title:'ICD9 Code',sortable:true,width:100},
		{field:'MRCIDDateActiveFrom',title:'开始日期',sortable:true,width:100},
		{field:'MRCIDDateActiveTo',title:'结束日期',sortable:true,width:100},
		{field:'MRCIDAgeFrom',title:'从年龄',sortable:true,width:100},
		{field:'MRCIDAgeTo',title:'到年龄',sortable:true,width:100},
		{field:'MRCIDSexDR',title:'限制性别',sortable:true,width:100},
		{field:'MRCIDLongDescription',title:'注释',sortable:true,width:100},
		{field:'MRCIDMetastaticSite',title:'肿瘤形态学编码',sortable:true,width:120,align:'center',formatter:ReturnFlagIcon},
		{field:'MRCIDInjuryPoisoningCode',title:'损伤中毒外部原因',sortable:true,width:120,align:'center',formatter:ReturnFlagIcon},
		{field:'MRCIDBillFlag1',title:'中医证型',sortable:true,width:100,align:'center',formatter:ReturnFlagIcon},
		{field:'MRCIDBillFlag3',title:'中医诊断',sortable:true,width:100,align:'center',formatter:ReturnFlagIcon},
	]];
    
	var mygrid = $HUI.datagrid("#mygrid",{
		url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=NewGetList",
		columns: columns,//列信息
		pagination:true,//pagination boolean 设置为true，则在数据网格（datagrid）底部显示分页工具栏。
		pageSize:20,
		pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
		singleSelect:false,//允许多行选择
		remoteSort:false,
		//ClassTableName:'User.MRCICDDx',
		//SQLTableName:'MRC_ICDDx',
		idField:'MRCIDRowId',
		rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		onDblClickRow:function(index,row)
		{
			updateData();
		},
	    onLoadSuccess:function(data)
		{
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
		}	
	});
	//限制性别下拉框
	$('#MRCIDSexDRF,#MRCIDSexDRkeep').combobox(
		{
			url:$URL+"?ClassName=web.DHCBL.CT.CTSex&QueryName=GetDataForCmb1&ResultSetType=array",
			valueField:'CTSEXRowId',
			textField:'CTSEXDesc',
			panelWidth:300 
	    }
	);
	//点击检索配置
	$('#btnconfig').click(function(e)
	{
		findway();
	});

	//点击搜索按钮
	$('#btnSearch').click(function(e)
	{
    	SearchFunLib();
	});

	//搜索回车事件
	$('#TextDesc,#TextCode,#Texticd10').keyup(function(event)
	{
		if(event.keyCode == 13) 
		{
		    SearchFunLib();
		}
	});

	//点击重置按钮
	$('#btnRefresh').click(function(e)
	{
		$("#TextDesc").val('');//清空检索框
		$("#TextCode").val('');
		$('#Texticd10').val('');
		$('#mygrid').datagrid('load',{
			ClassName: "web.DHCBL.CT.MRCICDDx",
            ClassMethod:"NewGetList"
		});
		$('#mygrid').datagrid('unselectAll');
	});

	//点击添加按钮
	$('#add_btn').click(function(e)
	{
		addData();
	});
	$('#copy_btn').click(function(e)
	{
		Copyfalse();
	});
	//点击修改按钮
	$('#update_btn').click(function(e)
	{
		updateData();
	});
	//点击合并按钮
	$('#btnMerge_btn').click(function(e)
	{
		MergeData();
	});
 /*******************************************配置开始**************************************************/
    //点击配置按钮
    $("#btn_Config").click(function(e){
        openConfigure();
    }); 
    //配置多选框的触发事件
    $HUI.checkbox('#AutoCode',{
        onChecked:function(e,value)
        {
			//alert("选中啦")
			$('#OriginCode').attr("disabled",false);
            $('#TotalLength').attr("disabled",false);
        },
        onUnchecked:function(e,value)
        {
            //alert("去掉啦")
			$('#OriginCode').attr("disabled",true);
            $('#TotalLength').attr("disabled",true);
        }
    });
    openConfigure=function()
    {
		$.cm(
			{
				ClassName:"web.DHCBL.CT.MRCICDDx",
				MethodName:"NewGetConfigValue"
			},
			function(jsondata)
			{
				$('#form-save1').form("load",jsondata);
				if(jsondata.AutoCode=="true"){
					$HUI.checkbox("#AutoCode").setValue(true);
					$('#OriginCode').attr("disabled",false);
					$('#TotalLength').attr("disabled",false);
				
				}
				else{
					$HUI.checkbox("#AutoCode").setValue(false);
					$('#OriginCode').attr("disabled",true);
					$('#TotalLength').attr("disabled",true);
					
				}
				if(jsondata.ValidDesc=="true"){
					$HUI.checkbox("#ValidDesc").setValue(true);
				}
				else{
					$HUI.checkbox("#ValidDesc").setValue(false);
				}
				if(jsondata.ValidCode=="true"){
					$HUI.checkbox("#ValidCode").setValue(true);
				}
				else{
					$HUI.checkbox("#ValidCode").setValue(false);
				}
			}
		); 
              
        $("#myWin1").show();
        var myWin1 = $HUI.dialog("#myWin1",{
            resizable:true,
            title:'配置',
            iconCls:'icon-w-batch-cfg',
            modal:true,
            buttonAlign : 'center',
            buttons:[{
                text:'保存',
                id:'saveCon_btn',
                handler:function(){
                    saveConfigure();
                }
            },{
                text:'关闭',
                handler:function(){
                    myWin1.close();
                }
            }]
        });   
    } 
    saveConfigure=function()
    {
		var AutoCode=$('#AutoCode').checkbox('getValue');
		console.log(AutoCode);
		var ValidDesc=$('#ValidDesc').checkbox('getValue');
		var ValidCode=$('#ValidCode').checkbox('getValue');
        if(AutoCode==false)
        {
            var OriginCode="";
            var TotalLength="";
			var AutoCode="false"
			$('#OriginCode').val('');
			$('#TotalLength').val('');
        }
        else
        {
            //选中
           var OriginCode=$('#OriginCode').val();
           var TotalLength=$('#TotalLength').val();
           var AutoCode="true";
           if(OriginCode=="")
           {
                $.messager.alert('错误提示','代码起始字符不能为空!',"error");
                return;            
           }
           if(TotalLength=="")
           {
                $.messager.alert('错误提示','代码长度不能为空!',"error");
                return;            
           }           
		}
		var ConfigStr= ValidCode+"^"+ValidDesc+"^"+AutoCode+"^"+OriginCode+"^"+TotalLength;
		console.log(ConfigStr);
		$.ajax({
			url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=SaveConfigValue",
			data:{"ConfigStr":ConfigStr},
			type:"POST",
			success:function(data)
			{
				var data = eval('('+data+')');
				if(data.success=='true')
				{
					$.messager.popover({msg:'保存成功',type:'success',timeout:1000});
					$('#OriginCode').val('');
					$('#TotalLength').val('');            
					$('#myWin1').dialog('close');
				}
				else
				{
					$.messager.popover({msg: '保存失败！',type:'success',timeout: 1000});
                    $('#myWin1').dialog('close');
				}

			}
		})
    }  
/*******************************************配置结束**************************************************/
	//快速复制方法
	Copyfalse=function(){
		var record = mygrid.getSelected();
		if(record){
			var id=record.MRCIDRowId;
			//同步别名
			$('#AliasGrid').datagrid('load',
			{
				ClassName:"web.DHCBL.CT.MRCICDAlias",
				QueryName:"GetList",
				aliasparref: id,
			}); 
			$.cm(
				{
					ClassName:"web.DHCBL.CT.MRCICDDx",
					MethodName:"NewCopyData",
					id:id
			    },
				function(jsonData)
				{
					if (jsonData.MRCIDMetastaticSite=="Y"){
						$HUI.checkbox("#MRCIDMetastaticSiteF").setValue(true);		
					}else{
						$HUI.checkbox("#MRCIDMetastaticSiteF").setValue(false);
					}
					if (jsonData.MRCIDInjuryPoisoningCode=="Y"){
						$HUI.checkbox("MRCIDInjuryPoisoningCodeF").setValue(true);		
					}else{
						$HUI.checkbox("#MRCIDInjuryPoisoningCodeF").setValue(false);
					}
					if (jsonData.MRCIDBillFlag1=="Y"){
						$HUI.checkbox("#MRCIDBillFlag1F").setValue(true);		
					}else{
						$HUI.checkbox("#MRCIDBillFlag1F").setValue(false);
					}
					if (jsonData.MRCIDBillFlag3=="Y"){
						$HUI.checkbox("#MRCIDBillFlag3F").setValue(true);		
					}else{
						$HUI.checkbox("#MRCIDBillFlag3F").setValue(false);
					}
					$('#form-save').form("load",jsonData);
			    }
			); 
			$("#myWin").show();
			var myWin = $HUI.dialog("#myWin",
			{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'快速复制',
				modal:true,
				buttons:[
					{
						text:'保存',
						id:'save_btn',
						handler:function()
						{
							saveFunLib("");
						}
					},
					{
						text:'关闭',
						handler:function()
						{
							 myWin.close();
							 editIndex = undefined;
						}
					}
			    ],
				onClose:function()
				{
					editIndex = undefined;
				} 
			});
		}
		else{
			$.messager.alert('错误提示','请选择需要复制的行!',"error");
		}
	}
	
	//修改数据方法
    updateData = function()
	{
		var record = mygrid.getSelected();
		if(record)
		{
			var id=record.MRCIDRowId; 
			//同步别名
			$('#AliasGrid').datagrid('load',
			{
				ClassName:"web.DHCBL.CT.MRCICDAlias",
				QueryName:"GetList",
				aliasparref: id,
			}); 
			$.cm(
				{
					ClassName:"web.DHCBL.CT.MRCICDDx",
					MethodName:"OpenDataJSON",
					id:id
			    },
				function(jsonData)
				{   $('#form-save').form("load",jsonData);
					console.log(jsonData.MRCIDBillFlag1);
					if (jsonData.MRCIDMetastaticSite=="Y")
				    {  
						$HUI.checkbox("#MRCIDMetastaticSiteF").setValue(true);		
					}else{
						$HUI.checkbox("#MRCIDMetastaticSiteF").setValue(false);
					}
					if (jsonData.MRCIDInjuryPoisoningCode=="Y"){
						$HUI.checkbox("#MRCIDInjuryPoisoningCodeF").setValue(true);		
					}else{
						$HUI.checkbox("#MRCIDInjuryPoisoningCodeF").setValue(false);
					}
					if (jsonData.MRCIDBillFlag1=="Y"){
						console.log(jsonData.MRCIDBillFlag1);
						$HUI.checkbox("#MRCIDBillFlag1F").setValue(true);		
					}else{
						$HUI.checkbox("#MRCIDBillFlag1F").setValue(false);
					}
					if (jsonData.MRCIDBillFlag3=="Y"){
						$HUI.checkbox("#MRCIDBillFlag3F").setValue(true);		
					}else{
						$HUI.checkbox("#MRCIDBillFlag3F").setValue(false);
					}
					$('#form-save').form("load",jsonData);
			    }
			); 
			$("#myWin").show();
			var myWin = $HUI.dialog("#myWin",
			{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'修改',
				modal:true,
				buttons:[
					{
						text:'保存',
						id:'save_btn',
						handler:function()
						{
							saveFunLib(id);
						}
					},
					{
						text:'关闭',
						handler:function()
						{
							 myWin.close();
							 editIndex = undefined;
						}
					}
				],
				onClose:function()
				{
					editIndex = undefined;
				}
			});	
		}
		else
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
		}
	}

	//检索方式
	findway=function()
	{
		$("#btnconfig").click(function()
		{
			$("#lookupwin").show();
			var lookupwin=$HUI.dialog("#lookupwin",
			{
				iconCls:'icon-w-config',
				resizable:true,
				title : '【描述/别名】检索配置',
				modal:true,
				buttonAlign:'center',
				SortTableName:'User.MRCICDDx',
				TableName:'MRC_ICDDx',
				onClose:function()
				{
					var TypeVal="";
				if( $HUI.radio("#LookUpA").getValue()==true)
				{
					TypeVal="A";
				}     
				if($HUI.radio("#LookUpL").getValue()==true)
				{
					TypeVal="L";
				}  
				if($HUI.radio("#LookUpF").getValue()==true)
				{
					TypeVal="F";
				}    	
					var flag=tkMakeServerCall("web.DHCBL.BDP.BDPAlias","SaveLookUpConfig",'MRC_ICDDx',TypeVal);
				}
			});
			var ConfigVal=tkMakeServerCall("web.DHCBL.BDP.BDPAlias","GetConfig",'MRC_ICDDx');
			if (ConfigVal!="")
			{
				$HUI.radio('#LookUp'+ConfigVal).setValue(true);
			}
		});
	}
	
	//搜索方法
	SearchFunLib=function()
	{
		var code=$("#TextCode").val();
		var desc=$("#TextDesc").val();
		var icd10=$("#Texticd10").val();
		$('#mygrid').datagrid('load',{
			ClassName:"web.DHCBL.CT.MRCICDDx",
			ClassMethod:"NewGetList",
			desc:desc,
			code:code,
			icd10:icd10
		});
		$('#mygrid').datagrid('unselectAll');
	}

	//添加方法
    addData=function()
    {
	$.cm(
			{
				ClassName:"web.DHCBL.CT.MRCICDDx",
				MethodName:"NewGetConfigValue"
			},
			function(jsondata)
			{
				$('#form-save1').form("load",jsondata);
				if(jsondata.AutoCode=="true"){
					$HUI.checkbox("#AutoCode").setValue(true);
				}
				else{
					$HUI.checkbox("#AutoCode").setValue(false);
				}
				if(jsondata.ValidDesc=="true"){
					$HUI.checkbox("#ValidDesc").setValue(true);
				}
				else{
					$HUI.checkbox("#ValidDesc").setValue(false);
				}
				if(jsondata.ValidCode=="true"){
					$HUI.checkbox("#ValidCode").setValue(true);
				}
				else{
					$HUI.checkbox("#ValidCode").setValue(false);
				}
				var AutoCode=$('#AutoCode').checkbox('getValue');	
				if(AutoCode==true)
				{
			     var MaxCode = tkMakeServerCall("web.DHCBL.CT.MRCICDDx","AutoCreateCode");
			     $('#MRCIDCode').val(MaxCode);
				}
				$('#form-save').form("load",jsonData); 
			}
		);
		$("#myWin").show();
	
		var myWin = $HUI.dialog("#myWin",
		{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:
			[
				{
					text:'保存',
					id:'save_btn',
					handler:function()
					{
						saveFunLib("");
					}
				},
			    {
					text:'关闭',
					handler:function()
					{
						myWin.close();
						editIndex = undefined;
					}
			    }
			],
			onClose:function(){
				//防止弹窗
		    	$('#AliasGrid').datagrid('load',  { 
		            ClassName:"web.DHCBL.CT.MRCICDAlias",
		            QueryName:"GetList"
		        });		
		        editIndex = undefined;			
			}
		});
		$('#form-save').form("clear");
		$('#form-save2').form("clear");
	}

	//保存
    saveFunLib=function(id)
    {
		//判断别名是否为空
		var rows = $('#AliasGrid').datagrid('getRows');//获取当前页的数据行   
	    for (var i = 0; i < rows.length; i++) {  
	        if (rows[i]['ALIASText'] == undefined)
	        {
	        	$.messager.alert('错误提示','别名不能为空！','error');
				return 				        	
	        }
		} 
    	var code=$.trim($("#MRCIDCode").val());
		var desc=$.trim($("#MRCIDDesc").val());
		var ICD10=$.trim($("#MRCIDICD9CMCodeF").val()); 		
		///判空	
		if (code=="")
		{
			$.messager.alert('错误提示','代码不能为空!',"error");
			return;
		}
		if (desc=="")
		{
			$.messager.alert('错误提示','描述不能为空!',"error");
			return;
		}
		if(ICD10=="")
		{
			$.messager.alert('错误提示','ICD10代码不能为空!',"error");
			return;
		}
		$('#form-save').form('submit', 
		{
			url:SAVE_ACTION_URL,
			onSubmit: function(param)
			{
				param.MRCIDRowId=id;
			},
			success: function (data) 
			{
				var data=eval('('+data+')');
				if (data.success == 'true') 
				{
				    var ALIASParRef = data.id;
					var otherdata=$('#AliasGrid').datagrid('getData');
					var dataforSave="";
					for(i=0;i<otherdata.rows.length;i++)
					{
						var dataRow=otherdata.rows[i].ALIASRowId+"^"+otherdata.rows[i].ALIASText+"^"+ALIASParRef;
						if(dataforSave=="")
						{
							dataforSave=dataRow;
						}
						else
						{
							dataforSave += "#"+dataRow;
						}
					} 
					if(dataforSave=="")
					{
						return false;
					}
					else
					{ 
					var listData = dataforSave;
						$.ajax({
							url:"../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.MRCICDAlias&pClassMethod=SaveAll",
							data:{"listData":listData}, 
							type:"POST",
							success: function(data)
								{
									var data=eval('('+data+')'); 
									if (data.success == 'true') 
									{
										$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
										$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据 
									} 
									else 
									{ 
										var errorMsg ="保存失败！"
										if (data.info) 
										{
											errorMsg =errorMsg+ '<br/>错误信息:' + data.info
										}
										$.messager.alert('操作提示',errorMsg,"error");
							
									}			
								}   
						});  
					}	
				}
				else 
				{ 
					var errorMsg ="更新失败！"
					if (data.errorinfo)
					{
						errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
					}
					$.messager.alert('操作提示',errorMsg,"error");
				}
				
			}
			 
		});
		$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
		$('#myWin').dialog('close'); // 关闭窗口 			    	
	}
	//合并
	MergeData=function(){

		var get = $("#mygrid").datagrid("getSelections");
		if(get.length==2&&get[0].MRCIDICD9CMCode==get[1].MRCIDICD9CMCode)
		{
			
			var DelID=get[0].MRCIDRowId;
			var keepID=get[1].MRCIDRowId;
			
			$.cm(
			{
				ClassName:"web.DHCBL.CT.MRCICDDx",
				MethodName:"OpenDataJSON",
				id:DelID
			},
			function(jsonData)
			{
				if (jsonData.MRCIDMetastaticSite=="Y"){
					$HUI.checkbox("#MRCIDMetastaticSiteF").setValue(true);		
				}else{
					$HUI.checkbox("#MRCIDMetastaticSiteF").setValue(false);
				}
				if (jsonData.MRCIDInjuryPoisoningCode=="Y"){
					$HUI.checkbox("MRCIDInjuryPoisoningCodeF").setValue(true);		
				}else{
					$HUI.checkbox("#MRCIDInjuryPoisoningCodeF").setValue(false);
				}
				if (jsonData.MRCIDBillFlag1=="Y"){
					$HUI.checkbox("#MRCIDBillFlag1F").setValue(true);		
				}else{
					$HUI.checkbox("#MRCIDBillFlag1F").setValue(false);
				}
				if (jsonData.MRCIDBillFlag3=="Y"){
					$HUI.checkbox("#MRCIDBillFlag3F").setValue(true);		
				}else{
					$HUI.checkbox("#MRCIDBillFlag3F").setValue(false);
				}
				$('#DelForm').form("load",jsonData);	
			}
			);
			$.cm(
				{
					ClassName:"web.DHCBL.CT.MRCICDDx",
					MethodName:"OpenDataJSON",
					id:keepID
				},
				function(jsonData)
				{
					if (jsonData.MRCIDMetastaticSite=="Y"){
						$HUI.checkbox("#MRCIDMetastaticSitekeep").setValue(true);		
					}else{
						$HUI.checkbox("#MRCIDMetastaticSitekeep").setValue(false);
					}
					if (jsonData.MRCIDInjuryPoisoningCode=="Y"){
						$HUI.checkbox("MRCIDInjuryPoisoningCodekeep").setValue(true);		
					}else{
						$HUI.checkbox("#MRCIDInjuryPoisoningCodekeep").setValue(false);
					}
					if (jsonData.MRCIDBillFlag1=="Y"){
						$HUI.checkbox("#MRCIDBillFlag1keep").setValue(true);		
					}else{
						$HUI.checkbox("#MRCIDBillFlag1keep").setValue(false);
					}
					if (jsonData.MRCIDBillFlag3=="Y"){
						$HUI.checkbox("#MRCIDBillFlag3keep").setValue(true);		
					}else{
						$HUI.checkbox("#MRCIDBillFlag3keep").setValue(false);
					}
					$('#KeepForm').form("load",jsonData);

				}
				);
			$("#myWin2").show();
			var myWin2 = $HUI.dialog("#myWin2",
			{
				iconCls:'icon-w-edit',
				resizable:true,
				title:'合并',
				modal:true,
				buttons:[
					{
						text:'合并',
						id:'btnMerge_btn',
						handler:function()
						{
							var code=$.trim($("#MRCIDCodekeep").val());
							var desc=$.trim($("#MRCIDDesckeep").val());
							var ICD10=$.trim($("#MRCIDICD9CMCodekeep").val()); 		
							///判空	
							if (code=="")
							{
								$.messager.alert('错误提示','代码不能为空!',"error");
								return;
							}
							if (desc=="")
							{
								$.messager.alert('错误提示','描述不能为空!',"error");
								return;
							}
							if(ICD10=="")
							{
								$.messager.alert('错误提示','ICD10代码不能为空!',"error");
								return;
							}
							$('#DelFormId').val(DelID);
							$('#KeepForm').form('submit', 
							{

								url:"../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.MRCICDDx&pClassMethod=MergeData&pEntityName=web.Entity.CT.MRCICDDx",
								onSubmit: function(param)
								{
									param.MRCIDRowId=keepID;
								},
								success: function (data) 
								{
									var data=eval('('+data+')');
									if (data.success == 'true') 
									{
										$.messager.popover({msg: '合并成功！',type:'success',timeout: 1000});
										$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
										$('#mygrid').datagrid('unselectAll');  // 清空列表选中数据 
										$('#myWin2').dialog('close');
									}
									else 
									{ 
										var errorMsg ="合并失败！"
										if (data.errorinfo)
										{
											errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
										}
										$.messager.alert('操作提示',errorMsg,"error");
									}	
								}
								
								
							});
						}
						
					},
					{
						text:'关闭',
						handler:function()
						{
								myWin2.close();
								editIndex = undefined;
						}
					}
				],
				onClose:function()
				{
					editIndex = undefined;
				}
			});
		}	
		else
		{
			$.messager.alert('错误提示','请选择两行ICD10代码相同的行!',"error");
		}
		
	}
	//遍历列表
	var order=""
	var rows = $('#mygrid').datagrid('getRows');	
	for(var i=0; i<rows.length; i++)
	{	
		var id =rows[i].MRCIDRowId; //频率id
		if (order!="")
		{
			order = order+"^"+id
		}
		else
		{
			order = id
		}	
	}	
}
$(init);


