/*
* @Author: 基础数据平台-石萧伟
* @Date:   2018-07-24 15:41:35
* @Last Modified by:   admin
* @Last Modified time: 2018-10-23 14:52:47
* @描述:症状字典表
*/
var SAVE_ACTION_URL = "../csp/dhc.bdp.ext.entitydatatrans.csp?pClassName=web.DHCBL.KB.DHCPHSymptom&pClassMethod=SaveData&pEntityName=web.Entity.KB.DHCPHSymptom";
//var OPEN_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHSymptom&pClassMethod=OpenData";
var DELETE_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.KB.DHCPHSymptom&pClassMethod=DeleteData";
var init=function()
{
    var columns =[[
        {field:'SYMCode',title:'代码',sortable:true,width:100},
        {field:'SYMDesc',title:'描述',sortable:true,width:100},
        {field:'SYMActiveFlag',title:'是否可用',sortable:true,width:100,
              formatter:ReturnFlagIcon
    	},
        {field:'SYMRowId',title:'rowid',sortable:true,width:100,hidden:true}
    ]];
    var mygrid = $HUI.datagrid("#mygrid",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCBL.KB.DHCPHSymptom",
            QueryName:"GetList"
        },
        columns: columns,  //列信息
        pagination: true,   //pagination	boolean	设置为 true，则在数据网格（datagrid）底部显示分页工具栏。
        pageSize:PageSizeMain,
        pageList:[5,10,15,20,25,30,50,75,100,200,300,500,1000],
        singleSelect:true,
        remoteSort:false,
        //ClassTableName:'User.DHCPHExtPart',
		//SQLTableName:'DHC_PHExtPart',
        idField:'SYMRowId',
        rownumbers:true,    //设置为 true，则显示带有行号的列。
        fixRowNumber:true,
        fitColumns:true, //设置为 true，则会自动扩大或缩小列的尺寸以适应网格的宽度并且防止水平滚动
        onDblClickRow:function(index,row)
        {
        	updateData();
        },
        onLoadSuccess:function(data){
			$(this).prev().find('div.datagrid-body').prop('scrollTop',0);
        }	 	
    });
    //点击添加按钮
    $('#add_btn').click(function(e){
    	AddData();
    });
    //点击修改按钮
    $('#update_btn').click(function(){
    	updateData();
    });
    //点击删除按钮
    $('#del_btn').click(function(e){
    	delData();
    });
     //点击搜索按钮
    $('#btnSearch').click(function(e){
    	SearchFunLib();
    });
    //搜索回车事件
	$('#TextDesc,#TextCode').keyup(function(event){
		if(event.keyCode == 13) {
		  SearchFunLib();
		}
	});    
    //搜索方法
    SearchFunLib=function()
    {
    	var code=$("#TextCode").val();
    	var desc=$("#TextDesc").val();
    	$('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHSymptom",
            QueryName:"GetList",
            desc:desc,
            code:code
        });
        $('#mygrid').datagrid('unselectAll');    	
    }    
    //点击重置按钮
    $('#btnRefresh').click(function(e){
		$("#TextDesc").val('');//清空检索框
		$("#TextCode").val('');
        $('#mygrid').datagrid('load',  { 
            ClassName:"web.DHCBL.KB.DHCPHSymptom",
            QueryName:"GetList"
        });
		$('#mygrid').datagrid('unselectAll');
    });
 	//点击添加按钮方法
    AddData=function(){
       // $('#SYMCode').attr("disabled",false);
        //$('#SYMDesc').attr("disabled",false); 
		$('#SYMCode').attr("readonly",false);
        $('#SYMCode')[0].readonly=false;
        $('#SYMCode').css({'background-color':'#ffffff'}); 

		$('#SYMDesc').attr("readonly",false);
        $('#SYMDesc')[0].readonly=false;
        $('#SYMDesc').css({'background-color':'#ffffff'});        
		$("#myWin").show();
		var myWin = $HUI.dialog("#myWin",{
			iconCls:'icon-w-add',
			resizable:true,
			title:'新增',
			modal:true,
			buttonAlign : 'center',
			buttons:[{
				text:'保存',
				id:'save_btn',
				handler:function(){
					SaveFunLib("",1)
				}
			},{
				text:'继续添加',
				id:'save_goon',
				handler:function(){
					//goOnSaveData();
					SaveFunLib("",2)
				}
			},{
				text:'关闭',
				handler:function(){
					myWin.close();
				}
			}]
		});
		$('#form-save').form("clear");
		//默认选中
		$HUI.checkbox("#SYMActiveFlag").setValue(true);	
	}
	SaveFunLib=function(id,flagT)
	{
		//alert(flag)
		var code=$.trim($("#SYMCode").val());
		var desc=$.trim($("#SYMDesc").val());	
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
		if (code.length>50)
		{
			$.messager.alert('错误提示','代码超长，代码长度不能超过50个字符!',"error");
			return;
		}
		if (desc.length>50)
		{
			$.messager.alert('错误提示','描述超长，描述长度不能超过50个字符!',"error");
			return;
		}
		//alert($('#SYMActiveFlag').attr('checked'))	
		$('#form-save').form('submit', {
			url:SAVE_ACTION_URL,
			onSubmit: function(param){
                param.SYMRowId = id;
            },
		success: function (data) { 
		  	var data=eval('('+data+')'); 
		  	if (data.success == 'true') {
				/*$.messager.show({ 
			 	title: '提示消息', 
			  	msg: '提交成功', 
			  	showType: 'show', 
			  	timeout: 1000, 
			  	style: { 
				right: '', 
				bottom: ''
			  	} 
			});*/
			$.messager.popover({msg: '保存成功！',type:'success',timeout: 1000}); 
			$('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
			//alert(flagT)
			if(flagT==1)
			{
				//alert(flagT)
				$('#myWin').dialog('close'); // close a dialog
			}
			else
			{
				$('#form-save').form("clear");
				//默认选中
				$HUI.checkbox("#SYMActiveFlag").setValue(true);				
			}
		  } 
		  else { 
			var errorMsg ="更新失败！"
			if (data.errorinfo) {
				errorMsg =errorMsg+ '<br/>错误信息:' + data.errorinfo
			}
		 $.messager.alert('操作提示',errorMsg,"error");

			}

		} 
		});		
	}
	updateData=function()
	{
		var record = mygrid.getSelected(); 
		if(record)
		{
			var id=record.SYMRowId;
			$.cm({
				ClassName:"web.DHCBL.KB.DHCPHSymptom",
				MethodName:"NewOpenData",
				id:id
			},function(jsonData){
				//给是否可用单独赋值	
				//alert(jsonData.PHLFSysFlag)		
				//alert(jsonData.PHLFActiveFlag)		
				if (jsonData.SYMActiveFlag=="Y"){
					$HUI.checkbox("#SYMActiveFlag").setValue(true);		
				}else{
					$HUI.checkbox("#SYMActiveFlag").setValue(false);
				}
				$('#form-save').form("load",jsonData);	
			});	
            //如果已对照则不能修改
            var contrastFlag=tkMakeServerCall("web.DHCBL.KB.DHCPHSymptom","GetRefFlag",id);
            //alert(contrastFlag)
            if(contrastFlag.indexOf("症状字典对照表")>0)
            {
               // $('#SYMCode').attr("disabled",true);//代码不可修改
                //$('#SYMDesc').attr("disabled",true);//代码不可修改
                //
                $('#SYMCode').attr("readonly",true);
				$('#SYMCode')[0].readonly=true;
				$('#SYMCode').css({'background-color':'#EBEBE4'});

				$('#SYMDesc').attr("readonly",true);
				$('#SYMDesc')[0].readonly=true;
				$('#SYMDesc').css({'background-color':'#EBEBE4'});
            }
            else
            {
                //$('#SYMCode').attr("disabled",false);
                //$('#SYMDesc').attr("disabled",false);
                //
            	$('#SYMCode').attr("readonly",false);
        		$('#SYMCode')[0].readonly=false;
        		$('#SYMCode').css({'background-color':'#ffffff'});

        		$('#SYMDesc').attr("readonly",false);
        		$('#SYMDesc')[0].readonly=false;
        		$('#SYMDesc').css({'background-color':'#ffffff'});
            } 			
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
						SaveFunLib(id,1)
					}
				},{
					text:'关闭',
					handler:function(){
						myWin.close();
					}
				}]
			});							
		}else{
			$.messager.alert('错误提示','请先选择一条记录!',"error");
		}
	}
	delData=function()
	{
		var row = $("#mygrid").datagrid("getSelected"); 
		if (!(row))
		{	$.messager.alert('错误提示','请先选择一条记录!',"error");
			return;
		}
		var rowid=row.SYMRowId;
		$.messager.confirm('提示', '确定要删除所选的数据吗?', function(r){
			if (r){
				$.ajax({
					url:DELETE_ACTION_URL,  
					data:{"id":rowid},  
					type:"POST",   
					//dataType:"TEXT",  
					success: function(data){
							  var data=eval('('+data+')'); 
							  if (data.success == 'true') {
								/*$.messager.show({ 
								  title: '提示消息', 
								  msg: '删除成功', 
								  showType: 'show', 
								  timeout: 1000, 
								  style: { 
									right: '', 
									bottom: ''
								  } 
								}); */
								$.messager.popover({msg: '删除成功！',type:'success',timeout: 1000});
								 $('#mygrid').datagrid('reload');  // 重新载入当前页面数据 
								 $('#mygrid').datagrid('unselectAll');  // 清空列表选中数据 
							  } 
							  else { 
								var errorMsg ="删除失败！"
								if (data.info) {
									errorMsg =errorMsg+ '<br/>错误信息:' + data.info
								}
								 $.messager.alert('操作提示',errorMsg,"error");
					
							}			
					}  
				})
			}
		});
	}	
}
$(init);