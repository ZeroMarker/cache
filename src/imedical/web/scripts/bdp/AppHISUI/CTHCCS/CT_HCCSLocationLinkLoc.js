/*
* @Author: 基础数据平台-丁亚男
* @Date:   2021-02-02
* @描述: 医呼通科室维护及与HIS科室关联
*/
//医呼通科室保存、删除
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.CT.HCCSLocation&pClassMethod=SaveEntity&pEntityName=web.Entity.CT.HCCSLocation";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.CT.HCCSLocation&pClassMethod=DeleteData";

var init=function()
{
	//多院区下拉框
	var hospComp = GenHospComp("CT_HCCSLocation");
	hospComp.jdata.options.onSelect = function(e){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		var url=$URL+"?ClassName=web.DHCBL.CT.RBCDepartmentGroup&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+HospID;
		$('#hislocDepDRDesc').combobox('reload',url);
		locationRefresh(); //医呼通科室重置
	}
	
	//禁用、启用右侧按钮
	ableHISButton=function(type){
		if (type==true){
			/* $('#hislocSearch').linkbutton('enable');
			$('#hislocRefresh').linkbutton('enable'); */
			$("#hislocmybar [name='FilterCK']").radio('enable');
			$('#saveButton').linkbutton('enable');
		}else{
			/* $('#hislocSearch').linkbutton('disable');   //禁用个人通讯录查询按钮
			$('#hislocRefresh').linkbutton('disable');   //禁用个人通讯录重置按钮 */
			$("#hislocmybar [name='FilterCK']").radio('disable');
			$('#saveButton').linkbutton('disable');   //禁用个人通讯录保存按钮
		}
	}
	
	//医呼通科室
    var locationcolumns =[[
	  {field:'LOCRowId',title:'LOCRowId',width:150,sortable:true,hidden:true},
	  {field:'LOCCode',title:'科室代码',width:120,sortable:true},
	  {field:'LOCDesc',title:'科室名称',width:200,sortable:true},
	  {field:'LOCDateFrom',title:'开始日期',width:150,sortable:true},
	  {field:'LOCDateTo',title:'结束日期',width:150,sortable:true},

    ]];
    var locationgrid = $HUI.datagrid("#locationgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.HCCSLocation",
            QueryName:"GetList",
			'hospid':hospComp.getValue()    ///多院区医院
        },
        columns: locationcolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        idField:'LOCRowId',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(rowIndex,rowData){
        	UpdateData();
        },
		onClickRow:function(rowIndex,rowData){

			ableHISButton(true) //启用右侧按钮
			//获取右侧 全选、已选、未选的选中label
			CheckFlag= $("#hislocmybar [name='FilterCK']").attr("label");
			if ((CheckFlag=="")||(CheckFlag=="全部"))
			{
				$HUI.radio("#CheckALL").setValue(true);  //给全部赋值
			}
			HISLocRefreshFun(); //右侧重置
        },
        onLoadSuccess:function(data){
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
        }	
    });
    //搜索
    $('#locationSearch').click(function(e){
        locationSearch();
    });
    //搜索回车事件
    $('#locationDesc').keyup(function(event){
        if(event.keyCode == 13) {
			locationSearch();
        }
    });    
    //搜索方法
    locationSearch=function()
    {
        var locationDesc=$('#locationDesc').val();
		var HospID=hospComp.getValue();
        $('#locationgrid').datagrid('reload',  {
                ClassName:"web.DHCBL.CT.HCCSLocation",
                QueryName:"GetList",
                desc:locationDesc,
				'hospid':HospID
        });
        $('#locationgrid').datagrid('unselectAll');
		ableHISButton(false); //禁用右侧按钮
		HISLocRefreshFun(); //右侧重置
    }    
    //重置
    $('#locationRefresh').click(function(e){
    	locationRefresh();
    });
	//重置事件
    $('#locationDesc').keyup(function(event){
        if(event.keyCode == 27) {
			locationRefresh();
        }
    });    
    //重置方法
    locationRefresh=function()
    {
        $('#locationDesc').val("");
		var HospID=hospComp.getValue();
    	$('#locationgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.CT.HCCSLocation",
            	QueryName:"GetList",
				'hospid':HospID
    	});
    	$('#locationgrid').datagrid('unselectAll');
		$('#hislocgrid').datagrid('unselectAll');
		ableHISButton(false); //禁用右侧按钮
		HISLocRefreshFun(); //右侧重置
    }   
	
	//点击添加按钮(医呼通科室)
    $('#add_btn').click(function(e)
    {
        AddData();
	});

    //点击修改按钮（医呼通科室）
	$('#update_btn').click(function(e)
	{
    	UpdateData();
	});
    //点击删除按钮（医呼通科室）
	$('#del_btn').click(function(e)
	{
    	DelData();
	});
	//添加方法（医呼通科室）
    AddData=function()
    {
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:
			[{
				text:'保存',
				id:'save_btn',
				handler:function()
				{
					SaveFunLib("");		
				}
			},{
				text:'关闭',
				handler:function()
				{
					myWin.close();
				}
			}],
			
		});
		$("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");
		$('#form-save').form("clear");
		var date=$.fn.datebox.defaults.formatter(new Date())
		$('#LOCDateFrom').datebox('setValue',date);
	}
	//保存方法（医呼通科室）
    SaveFunLib=function(id)
	{
		if ($.trim($("#LOCCode").val())=="")
		{
			$.messager.alert('错误提示','科室代码不能为空!',"info");
			return;
		}
		if ($.trim($("#LOCDesc").val())=="")
		{
			$.messager.alert('错误提示','科室名称不能为空!',"info");
			return;
		}
		var flag= tkMakeServerCall("web.DHCBL.CT.HCCSLocation","FormValidate",$.trim($("#LOCRowId").val()),$.trim($("#LOCCode").val()),$.trim($("#LOCDesc").val()),hospComp.getValue());
		if (flag==1)
		{
			$.messager.alert('错误提示','该科室已存在!',"info");
			return;
		}
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				$('#form-save').form('submit', { 
					url: SAVE_ACTION_URL,
					onSubmit: function(param){
							param.LinkHospId = hospComp.getValue()
						},
					success: function (data) { 
						  var data=eval('('+data+')'); 
						  if (data.success == 'true') {
								$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
								if (id!="")
								{
									$('#locationgrid').datagrid('reload');  // 重新载入当前页面数据
									$('#locationgrid').datagrid('unselectAll');									
								}
								else
								{
									 $.cm({
										ClassName:"web.DHCBL.CT.HCCSLocation",
										QueryName:"GetList",
										rowid: data.id   
									},function(jsonData){
										$('#locationgrid').datagrid('insertRow',{
											index:0,
											row:jsonData.rows[0]
										})
									})
									$('#locationgrid').datagrid('unselectAll');
								}
								$('#myWin').dialog('close'); //关闭窗口
								ableHISButton(false)   //禁用右侧按钮
								HISLocRefreshFun();  //重置右侧
						  } 
						  else { 
								var errorMsg ="提交失败！"
								if (data.errorinfo) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
								}
								$.messager.alert('操作提示',errorMsg,"error");
				
						}
		
					} 
				});
			}
		})

	}
	//修改数据方法（医呼通科室）
    UpdateData=function() {
		var record = $("#locationgrid").datagrid("getSelected");
		if (!(record))
		{	
			$.messager.alert('错误提示','请先选择一条记录!',"info");
			return;
		}
		var id=record.LOCRowId
		$.cm({
			ClassName:"web.DHCBL.CT.HCCSLocation",
			MethodName:"OpenData",
			id:id
		},function(jsonData){
			$('#form-save').form("load",jsonData);	
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
			$("#save_btn").removeClass("l-btn l-btn-small").addClass("l-btn l-btn-small green");		
		});
	}
	//删除方法（医呼通科室）
    DelData=function()
    {
		var record = $("#locationgrid").datagrid('getSelected'); 
		if (!(record))
		{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=record.LOCRowId;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				$.ajax({
						url:DELETE_ACTION_URL,  
						data:{"id":rowid},  
						type:"POST",     
						success: function(data)
						{
							var data=eval('('+data+')');
							if (data.success == 'true') 
							{
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								$('#locationgrid').datagrid('reload');  // 重新载入当前页面数据 
								$('#locationgrid').datagrid('unselectAll');  // 清空列表选中数据
								ableHISButton(false)   //禁用右侧按钮
								HISLocRefreshFun();  //重置右侧
							} 
							else 
							{
								var errorMsg ="删除失败！"
								if (data.info) 
								{
									errorMsg =errorMsg+ '<br/>错误信息:' + data.info
								}
								$.messager.alert('操作提示',errorMsg,"error");
							}			
						}  
					});
			}
		});    	
	} 
	/********个人通讯录开始 *********************************************************************************************************/
	var CheckFlag="全部"
	var Saveflag=1  //保存医呼通科室标志 搜索、重置、切换医呼通科室不保存，其他情况保存 
	//个人通讯录部分
    var hisloccolumns =[[
		{field:'checked',title:'sel',checkbox:true},
		{field:'LLLRowId',title:'关联ID',width:100,hidden:true},
        {field:'CTLOCRowID',title:'HIS科室ID',width:100,hidden:true,sortable:true},
        {field:'CTLOCCode',title:'科室代码',width:100,sortable:true},
        {field:'CTLOCDesc',title:'科室名称',width:100,sortable:true},
        {field:'LacationDesc',title:'所属医呼通科室',width:100,sortable:true},
        {field:'DEPDesc',title:'科室组',width:100,sortable:true}
    ]];
    var hislocgrid = $HUI.datagrid("#hislocgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.HCCSLocationLinkLoc",
            QueryName:"GetDataForCmb1",
			'hospid':hospComp.getValue(),    ///多院区医院
			CheckFlag:CheckFlag
        },
        columns: hisloccolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,     //定义从服务器对数据进行排序
        singleSelect:false,
        idField:'CTLOCRowID',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
		fixRowNumber:true,
		fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
		onCheck:function(index, row){  //选中数据时，checked的内容没有变化
			$('#hislocgrid').datagrid('updateRow',{
				index: index,
				row: {
					checked:true
				}
			});
			var record = $("#locationgrid").datagrid("getSelected");
			if ((record))
			{
				if((row.LacationDesc!="")&&(row.LacationDesc!=record.LOCDesc)) //如果选中的HIS科室已经关联其他医呼通科室，勾选的时候给与提示
				{
					$.messager.alert('操作提示',"HIS科室已经归属于其他医呼通科室，如需关联，请在原医呼通科室取消与此科室的关联！","error");
				}
			}
		},
		onUncheck:function(index, row){ //取消选中数据时，checked的内容没有变化
			$('#hislocgrid').datagrid('updateRow',{
				index: index,
				row: {
					checked:false
				}
			});
			
		},
		onCheckAll:function(rows){  //选中数据时，checked的内容没有变化
			$.each(rows, function(index, item){
				$('#hislocgrid').datagrid('updateRow',{
					index: index,
					row: {
						checked:true
					}
				});
			});	
			
		},
		onUncheckAll:function(rows){  //选中数据时，checked的内容没有变化
			$.each(rows, function(index, item){
				$('#hislocgrid').datagrid('updateRow',{
					index: index,
					row: {
						checked:false
					}
				});
			});	
		},
		onBeforeLoad:function()
		{
			var Allrows=$('#hislocgrid').datagrid('getRows');
			var ChangeFlag=0  //判断翻页时，数据是否有变化
			for(var i=0; i<Allrows.length; i++) {   //循环获取变化的数据
				if (((Allrows[i].checked==true) && (Allrows[i].LLLRowId==""))||((Allrows[i].checked!==true) && (Allrows[i].LLLRowId!=="")))
				{
					ChangeFlag=1;	
					break
				}	
			}
			if ((ChangeFlag==1)&&(Saveflag==1)) //有变化并且是翻页 保存数据
			{
				SavePrePageData();
			}
		}, 
        onLoadSuccess:function(data){
			var CheckALLFlag=0  //加载数据是否全部选中标志
			if (data) {
				 CheckALLFlag=1
                $.each(data.rows, function (index, item) {
                    if (item.checked == false) {
						CheckALLFlag=0;
                    }
                });
			}
			
			if (CheckALLFlag==1)  //加载数据全部选中标志
			{
				$("#hislocgrid").datagrid('checkAll')
			}
			else
			{
				$("#hislocgrid").parent().find("div.datagrid-header-check").children("input[type='checkbox']").eq(0).attr("checked", false);
			}
			
	        $(this).prev().find('div.datagrid-body').prop('scrollTop',0);  //如果有滚动条，滚动到最上面
        	$(this).datagrid('columnMoving'); //列可以拖拽改变顺序
		}		
	});
	
	//搜索
    $('#hislocSearch').click(function(e){
        hislocSearch();
    });
    //搜索回车事件
    $('#hislocDesc').keyup(function(event){
        if(event.keyCode == 13) {
			hislocSearch();
        }
	}); 
	//科室组检索框
	$("#hislocDepDRDesc").combobox({
		url:$URL+"?ClassName=web.DHCBL.CT.RBCDepartmentGroup&QueryName=GetDataForCmb1&ResultSetType=array&hospid="+hospComp.getValue(),
		valueField: 'DEPRowId',
		textField: 'DEPDesc',
		onSelect:function(){
			hislocSearch();
		}
	})
     ///全部、已选、未选
	$HUI.radio("#hislocmybar [name='FilterCK']",{
        onChecked:function(e,value){
			CheckFlag=$(e.target).attr("label")
			hislocSearch();//检索
       }
    });
    //搜索方法
    hislocSearch=function()
    {
		var record = $("#locationgrid").datagrid("getSelected");
		var LLLParRef="";
		if (record)
		{
			LLLParRef=record.LOCRowId;
		}
		
		var hislocDesc=$('#hislocDesc').val();
		var CTLOCDepDR=$('#hislocDepDRDesc').combobox("getValue");
		var HospID=hospComp.getValue();
		Saveflag=0  //保存医呼通科室标志 搜索、重置、切换医呼通科室不保存，其他情况保存
        $('#hislocgrid').datagrid('reload',  {
                ClassName:"web.DHCBL.CT.HCCSLocationLinkLoc",
                QueryName:"GetDataForCmb1",
				'desc':hislocDesc,
				'CTLOCDepDR':CTLOCDepDR,
				'hospid':HospID,
				'parref':LLLParRef,
				CheckFlag:CheckFlag
        });
		$('#hislocgrid').datagrid('unselectAll');
		Saveflag=1  //保存医呼通科室标志 搜索、重置、切换医呼通科室不保存，其他情况保存    
    }    
    //重置
    $('#hislocRefresh').click(function(e){
		HISLocRefreshFun();
    });
	//重置事件
    $('#hislocDesc').keyup(function(event){
        if(event.keyCode == 27) {
			HISLocRefreshFun();
        }
    });    
    //重置方法
    HISLocRefreshFun=function()
    {
		var record = $("#locationgrid").datagrid("getSelected");
		var LLLParRef="";
		if (record)
		{
			LLLParRef=record.LOCRowId;
		}
		var HospID=hospComp.getValue();
		$('#hislocDesc').val("");
		$('#hislocDepDRDesc').combobox("setValue","");
		Saveflag=0  //保存医呼通科室标志 搜索、重置、切换医呼通科室不保存，其他情况保存
    	$('#hislocgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.CT.HCCSLocationLinkLoc",
            	QueryName:"GetDataForCmb1",
				'hospid':HospID,
				'parref':LLLParRef,
				CheckFlag:CheckFlag
    	});
		$('#hislocgrid').datagrid('unselectAll');  
		Saveflag=1  //保存医呼通科室标志 搜索、重置、切换医呼通科室不保存，其他情况保存 
    }   
	
	//点击保存按钮(医呼通科室关联his科室)
    $('#saveButton').click(function(e)
    {
        SaveData();
	});
	
	//保存方法（医呼通科室关联his科室）
	SaveData=function() {	
		var record = $("#locationgrid").datagrid("getSelected");
		if(!(record))
		{
			$.messager.alert('提示',"未选中要保存的数据!","info");						
			return false;
		}
		var LOCRowId=record.LOCRowId;
		var Allrows=$('#hislocgrid').datagrid('getRows');
		$.messager.confirm('提示', "确认要保存数据吗?", function(r){
			if (r){
				var ChangeIDstr="";
				for(var i=0; i<Allrows.length; i++) {   //循环获取变化的数据

					if (((Allrows[i].checked==true) && (Allrows[i].LLLRowId==""))||((Allrows[i].checked!==true) && (Allrows[i].LLLRowId!=="")))
					{
						if(ChangeIDstr!=="")
						{
							ChangeIDstr=ChangeIDstr+"^"
						}
						ChangeIDstr=ChangeIDstr+Allrows[i].CTLOCRowID
					}
					
				}
				
				if(ChangeIDstr!=="")
				{
					var rs=tkMakeServerCall("web.DHCBL.CT.HCCSLocationLinkLoc","SaveLocationLink",LOCRowId,ChangeIDstr);	
					rs=eval('(' + rs + ')');
					if (rs.success== 'true') 
					{
						$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
					}
					else
					{
						$.messager.alert('操作提示',"保存失败！","error");
					}
					Saveflag=0
					$('#hislocgrid').datagrid('reload');  // 重新载入当前页面数据	
					Saveflag=1
				}
				else
				{
					$.messager.popover({msg: '提交成功！',type:'success',timeout: 1000});
				}
									  
				
			}
		})
	}
	
	//翻页时保存上页数据的方法
	SavePrePageData=function() {	
		var record = $("#locationgrid").datagrid("getSelected");
		if(!(record))
		{
			//$.messager.alert('提示',"未选中要保存的数据!","info");						
			return false;
		}
		var LOCRowId=record.LOCRowId;
		var Allrows=$('#hislocgrid').datagrid('getRows');
		var ChangeIDstr="";
		for(var i=0; i<Allrows.length; i++) {   //循环获取变化的数据

			if (((Allrows[i].checked==true) && (Allrows[i].LLLRowId==""))||((Allrows[i].checked!==true) && (Allrows[i].LLLRowId!=="")))
			{
				if(ChangeIDstr!=="")
				{
					ChangeIDstr=ChangeIDstr+"^"
				}
				ChangeIDstr=ChangeIDstr+Allrows[i].CTLOCRowID
			}
			
		}
		var rs=tkMakeServerCall("web.DHCBL.CT.HCCSLocationLinkLoc","SaveLocationLink",LOCRowId,ChangeIDstr);	
		rs=eval('(' + rs + ')');
		if (rs.success== 'true') 
		{
			$.messager.popover({msg: '上页数据保存成功！',type:'success',timeout: 1000});
		}
		else
		{
			$.messager.alert('操作提示',"上页数据保存失败！","error");
		}			
			
	}
	
	ableHISButton(false)   //禁用右侧按钮
}
$(init);