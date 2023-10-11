/*
* @Author: 基础数据平台-丁亚男
* @Date:   2021-02-02
* @描述: 个人通讯录HIS科室维护及与HIS科室关联
*/
var init=function()
{
	//多院区下拉框
	var hospComp = GenHospComp("CT_HCCSLocLinkLoc");
	hospComp.jdata.options.onSelect = function(e){
		var HospID=$HUI.combogrid('#_HospList').getValue();
		listlocRefresh(); //个人通讯录HIS科室重置
	}
	
	//禁用、启用右侧按钮
	ableHISButton=function(type){
		if (type==true){
			$("#hislocmybar [name='FilterCK']").radio('enable');
			$('#saveButton').linkbutton('enable');
		}else{
			$("#hislocmybar [name='FilterCK']").radio('disable');
			$('#saveButton').linkbutton('disable');   //禁用个人通讯录保存按钮
		}
	}
	
	//个人通讯录HIS科室
    var listloccolumns =[[
	  {field:'HCCSCLRowId',title:'HCCSCLRowId',width:150,sortable:true,hidden:true},
	  {field:'HCCSCLLocCode',title:'科室代码',width:120,sortable:true},
	  {field:'HCCSCLLocDesc',title:'科室名称',width:200,sortable:true}

    ]];
    var listlocgrid = $HUI.datagrid("#listlocgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.CTHCCSContactList",
            QueryName:"GetLocList",
			'hospid':hospComp.getValue()    ///多院区医院
        },
        columns: listloccolumns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:20,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        remoteSort:false,
        idField:'HCCSCLRowId',
        singleSelect:true,
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(rowIndex,rowData){
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
    $('#listlocSearch').click(function(e){
        listlocSearch();
    });
    //搜索回车事件
    $('#listlocDesc').keyup(function(event){
        if(event.keyCode == 13) {
			listlocSearch();
        }
    });    
    //搜索方法
    listlocSearch=function()
    {
        var listlocDesc=$('#listlocDesc').val();
		var HospID=hospComp.getValue();
        $('#listlocgrid').datagrid('reload',  {
				ClassName:"web.DHCBL.CT.CTHCCSContactList",
            	QueryName:"GetLocList",
                desc:listlocDesc,
				'hospid':HospID
        });
        $('#listlocgrid').datagrid('unselectAll');
		ableHISButton(false); //禁用右侧按钮
		HISLocRefreshFun(); //右侧重置
    }    
    //重置
    $('#listlocRefresh').click(function(e){
    	listlocRefresh();
    });
	//重置事件
    $('#listlocDesc').keyup(function(event){
        if(event.keyCode == 27) {
			listlocRefresh();
        }
    });    
    //重置方法
    listlocRefresh=function()
    {
        $('#listlocDesc').val("");
		var HospID=hospComp.getValue();
    	$('#listlocgrid').datagrid('reload',  {
				ClassName:"web.DHCBL.CT.CTHCCSContactList",
				QueryName:"GetLocList",
				'hospid':HospID
    	});
    	$('#listlocgrid').datagrid('unselectAll');
		$('#hislocgrid').datagrid('unselectAll');
		ableHISButton(false); //禁用右侧按钮
		HISLocRefreshFun(); //右侧重置
    }   
	
	/********HIS科室授权开始 *********************************************************************************************************/
	var CheckFlag="全部"
	var Saveflag=1  //保存HIS科室授权标志 搜索、重置、切换个人通讯录HIS科室不保存，其他情况保存 
	//HIS科室授权列表
    var hisloccolumns =[[
		{field:'checked',title:'sel',checkbox:true},
		{field:'LLLRowId',title:'关联ID',width:100,hidden:true},
        {field:'HCCSCLRowId',title:'个人通讯录HIS科室ID',width:100,hidden:true,sortable:true},
        {field:'HCCSCLLocCode',title:'科室代码',width:100,sortable:true},
        {field:'HCCSCLLocDesc',title:'科室名称',width:100,sortable:true}
    ]];
    var hislocgrid = $HUI.datagrid("#hislocgrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.CT.HCCSLocLinkLoc",
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
        idField:'HCCSCLRowId',
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
		var record = $("#listlocgrid").datagrid("getSelected");
		var LLLHISCode="";
		if (record)
		{
			LLLHISCode=record.HCCSCLLocCode;
		}
		
		var hislocDesc=$('#hislocDesc').val();
		var HospID=hospComp.getValue();
		Saveflag=0  //保存HIS科室授权标志 搜索、重置、切换个人通讯录HIS科室不保存，其他情况保存 
        $('#hislocgrid').datagrid('reload',  {
                ClassName:"web.DHCBL.CT.HCCSLocLinkLoc",
                QueryName:"GetDataForCmb1",
				'desc':hislocDesc,
				'hospid':HospID,
				'LLLHISCode':LLLHISCode,
				CheckFlag:CheckFlag
        });
		$('#hislocgrid').datagrid('unselectAll');
		Saveflag=1  //保存HIS科室授权标志 搜索、重置、切换个人通讯录HIS科室不保存，其他情况保存   
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
		var record = $("#listlocgrid").datagrid("getSelected");
		var LLLHISCode="";
		if (record)
		{
			LLLHISCode=record.HCCSCLLocCode;
		}
		var HospID=hospComp.getValue();
		$('#hislocDesc').val("");
		Saveflag=0  //保存HIS科室授权标志 搜索、重置、切换个人通讯录HIS科室不保存，其他情况保存 
    	$('#hislocgrid').datagrid('reload',  {
            	ClassName:"web.DHCBL.CT.HCCSLocLinkLoc",
            	QueryName:"GetDataForCmb1",
				'hospid':HospID,
				'LLLHISCode':LLLHISCode,
				CheckFlag:CheckFlag
    	});
		$('#hislocgrid').datagrid('unselectAll');  
		Saveflag=1  //保存HIS科室授权标志 搜索、重置、切换个人通讯录HIS科室不保存，其他情况保存 
    }   
	
	//点击保存按钮(个人通讯录HIS科室人员)
    $('#saveButton').click(function(e)
    {
        SaveData();
	});
	
	//保存方法（个人通讯录HIS科室人员）
	SaveData=function() {	
		var record = $("#listlocgrid").datagrid("getSelected");
		if(!(record))
		{
			$.messager.alert('提示',"未选中要保存的数据!","info");						
			return false;
		}
		var LLLHISCode=record.HCCSCLLocCode;
		var LLLHISDesc=record.HCCSCLLocDesc;
		var HISStr=LLLHISCode+"^"+LLLHISDesc
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
						ChangeIDstr=ChangeIDstr+Allrows[i].HCCSCLRowId
					}
					
				}
				
				if(ChangeIDstr!=="")
				{
					var rs=tkMakeServerCall("web.DHCBL.CT.HCCSLocLinkLoc","SaveLocLink",HISStr,ChangeIDstr);	
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
		var record = $("#listlocgrid").datagrid("getSelected");
		if(!(record))
		{
			//$.messager.alert('提示',"未选中要保存的数据!","info");						
			return false;
		}
		var LLLHISCode=record.HCCSCLLocCode;
		var LLLHISDesc=record.HCCSCLLocDesc;
		var HISStr=LLLHISCode+"^"+LLLHISDesc

		var Allrows=$('#hislocgrid').datagrid('getRows');
		var ChangeIDstr="";
		for(var i=0; i<Allrows.length; i++) {   //循环获取变化的数据

			if (((Allrows[i].checked==true) && (Allrows[i].LLLRowId==""))||((Allrows[i].checked!==true) && (Allrows[i].LLLRowId!=="")))
			{
				if(ChangeIDstr!=="")
				{
					ChangeIDstr=ChangeIDstr+"^"
				}
				ChangeIDstr=ChangeIDstr+Allrows[i].HCCSCLRowId
			}
			
		}
		var rs=tkMakeServerCall("web.DHCBL.CT.HCCSLocLinkLoc","SaveLocLink",HISStr,ChangeIDstr);	
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