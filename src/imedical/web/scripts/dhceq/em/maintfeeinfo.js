jQuery(document).ready(function ()
{
	//add by lmm 2020-04-26 1289831
	setRequiredElements("Item^Fee")	
	defindTitleStyle();
	initMessage();
	//add by lmm 2020-04-26 1289831
	initComboGridPanel();
    var selectedIndex = 0;
   	function StateInfoDataGrid_OnClickRow()
	{
		var selected=jQuery('#maintfeeinfodatagrid').datagrid('getSelected');
     	if (selected)
     	{
        	if(selected.Index==selectedIndex)
        	{
             	EmptyInput();
             	selectedIndex=0;
         	}
         	else
        	{
			    jQuery('#Index').val(selected.Index);
			    jQuery('#Item').val(selected.Item);
			    jQuery('#Fee').val(selected.Fee);
			    
		        selectedIndex=selected.Index;
         	}
     	}
	} 
	jQuery('#maintfeeinfodatagrid').datagrid(
	{
    	url:'dhceq.jquery.csp',
    	queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSMaint",
	        QueryName:"GetFeeInfo",
	        Arg1:jQuery('#RowID').val(),
	        ArgCnt:1
    	},
		striped:'true',	//行条纹化
    	border:false,   //modify by lmm 2020-04-26 1289831
    	singleSelect: true,
		selectOnCheck: true,
		checkOnSelect: true,
    	//multiSort:'true',
    	fit:true,  //modify by lmm 2020-06-05
    	//sortName:'Name',
    	//sortName:'No',
		//remoteSort:false,	//页面排序
		//sortOrder : 'desc', //升序
		//sortOrder : 'asc', //降序
    	//rownumbers:'true',
        toolbar:[
	    	{
				iconCls: 'icon-add',
	            text:'保存',
	            id:'btnsave',       
	            handler: function(){
	                 UpdateGridData();
	            }
	        },
	        {
	            iconCls: 'icon-cancel',
	            text:'删除',
	            id:'btnremove',
	            handler: function(){
	                 DeleteGridData();
	            }
	        }
	    ],
	    columns:[[
	        {field:'Row',title:'序号',width:40,align:'center'},
	        {field:'RowID',title:'RowID',width:50,hidden:true},
	        {field:'Index',title:'Index',width:50,hidden:true},
	        //{field:'Name',title:'设备名称',width:120,sortable:true},
	        {field:'Item',title:'项目',width:240},
	        {field:'Fee',title:'费用',width:150,align:'right'},
	    ]],
		onLoadSuccess:function(){
			if (jQuery('#Status').val()>0)
			{
				$('#btnsave').hide();
				$('#btnremove').hide();
			}
		},
    	onClickRow : function (rowIndex, rowData)
    	{
        	StateInfoDataGrid_OnClickRow();
    	},
    	pagination:true,
   		pageSize:25,
    	pageNumber:1,
    	pageList:[25,50,75,100]
	});
	
	///修改
	function UpdateGridData()
	{
		if (jQuery('#Status').val()>0)
	    {
		    //alertShow(jQuery('#Status').val())
		    //$('div.datagrid-toolbar').eq(0).hide();
		    //$('div.datagrid-toolbar').eq(0).show();
		    //$('div.datagrid-toolbar a').eq(0).show();
		    //$('div.datagrid-toolbar a').eq(0).hide();
		    //$('#btnpichuli').linkbutton('disable');
		    return false;
	    }
		if (jQuery('#RowID').val()=="")
		{
			jQuery.messager.alert("错误", "无维护记录.", 'error')
	        return false;
	    }
		if (checkMustItemNull()) return;	//add by lmm 2020-04-26 1289831

	    /*if (jQuery('#RecordDate').combogrid('getValue')==""){
	            jQuery.messager.alert("错误", "登记日期不能为空！", 'error')
	            return false;
	    }
	    /*if (jQuery('#User').combogrid('getValue')==""){
	            jQuery.messager.alert("错误", "使用人不能为空！", 'error')
	            return false;
		}*/
		//IsValidDate(jQuery('#StartDate').combogrid('getValue'))
		//return
	    var Info=jQuery('#RowID').val()+"^"+jQuery('#Index').val()+"^"+jQuery('#Item').val()+"^"+jQuery('#Fee').val();
	    //alertShow(Info)
		jQuery.ajax({
	        url :"dhceq.jquery.method.csp",
	        type:"POST",
	        data:{
	            ClassName:"web.DHCEQ.EM.BUSMaint",
	            MethodName:"SaveFeeInfo",
	            Arg1:Info,
	            ArgCnt:1
	        },
	        beforeSend: function ()
			{
	            jQuery.messager.progress({
	                text: '正在保存中...'
	            });
	        },
	        error:function(XMLHttpRequest, textStatus, errorThrown)
			{
	            alertShow(XMLHttpRequest.status);
	            alertShow(XMLHttpRequest.readyState);
	            alertShow(textStatus);
	        },
	        success:function (data, response, status)
			{
	            jQuery.messager.progress('close');
	            var list=data.split("^");
	            if (list[0] ==0)
				{
					jQuery('#maintfeeinfodatagrid').datagrid('reload'); 
	            	jQuery.messager.show({title: '提示',msg:'保存成功'});
	            	EmptyInput();
	            }   
	            else
	            {
	               	jQuery.messager.alert('保存失败！',list[0], 'warning')
	               	return;
	            }
	        }
	    })
	}
	function DeleteGridData()
	{
		if (jQuery('#Status').val()>0)
	    {
		    alertShow(jQuery('#Status').val())
		    //$('div.datagrid-toolbar').eq(0).hide();
		    //$('div.datagrid-toolbar a').eq(0).show();
		    //$('div.datagrid-toolbar a').eq(0).hide();
		    //$('#btnpichuli').linkbutton('disable');
		    return false;
	    }
	    if (jQuery('#RowID').val()=="")
		{
			jQuery.messager.alert("错误", "无维护记录.", 'error')
	        return false;
	    }
	    if (jQuery('#Index').val()=="")
		{
			jQuery.messager.alert("错误", "未选择项目记录.", 'error')
	        return false;
	    }
        jQuery.messager.confirm('请确认', '您确定要删除所选的行？',
	        function (b)
	        { 
		        if (b==false)
		        {
		             return;
		        }
		        else
		        {
			        var Info=jQuery('#RowID').val()+"^"+jQuery('#Index').val();
			        jQuery.ajax({
			            url :"dhceq.jquery.method.csp",
			            type:"POST",
			            data:{
			                ClassName:"web.DHCEQ.EM.BUSMaint",
			                MethodName:"DeleteFeeInfo",
			                Arg1:Info,
			                ArgCnt:1
			            },
			            success:function (data, response, status)
			            {
				            jQuery.messager.progress('close');
				            var list=data.split("^");
				            if (list[0]==0)
				            {
					            jQuery('#maintfeeinfodatagrid').datagrid('reload');
					            jQuery.messager.show({title: '提示',msg: '删除成功'});
					            EmptyInput();
			            	}   
			            	else
			            	{
			               		jQuery.messager.alert('删除失败！',list[0], 'warning')
			               		return;
			               	}
			           	}
			        })
		        }
	    	}
	    )
	}
	/// 描述:清空函数
	function EmptyInput()
	{
		jQuery('#Index').val("");
        jQuery('#Item').val("");
        jQuery('#Fee').val("");
	}
});

function initComboGridPanel()
{
	jQuery("input[name='combogrid']").each(function() { 
		var options=eval('(' + jQuery(this).attr("data-options") + ')');
		jQuery(this).initComboGrid(options);
	});
}