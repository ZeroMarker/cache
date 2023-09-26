jQuery(document).ready(function ()
{
	initComboGridPanel();
	jQuery('#FileNo').validatebox({width: 160});
	jQuery('#No').validatebox({width: 160});
	jQuery('#Name').validatebox({width: 160});
	jQuery("#BFind").on("click", FindGridData);
	jQuery("#BReload").on("click", EmptyInput);
	//Mozy0200	2017-10-11	增加默认登陆人设置
	jQuery("#Userdr").val(SessionObj.GUSERID);
	jQuery("#User").textbox('setValue',SessionObj.GUSERNAME);
    var selectedEquipDR = 0;
   	function StateInfoDataGrid_OnClickRow()
	{
		var selected=jQuery('#stateinfodatagrid').datagrid('getSelected');
     	if (selected)
     	{
        	if(selected.EquipDR==selectedEquipDR)
        	{
             	EmptyInput();
             	selectedEquipDR=0;
             	/// 重新加载背景色-清除底色
             	jQuery('#stateinfodatagrid').datagrid('unselectAll');  //add by wy 2018-2-3
             	jQuery('#runningrecorddatagrid').datagrid({   
				    rowStyler:function(index,row){
						if (row.TotalTime<0)
						{
							//return 'background-color:pink;color:blue;font-weight:bold;';
							//return 'background-color:rgb(34,177,76);font-weight:bold;';
							return 'color:red;font-weight:bold;';
						}
					} 
				});
         	}
         	else
        	{
	        	/*jQuery('#RowID').val(selected.RowID);
	        	jQuery('#EquipDR').val(selected.EquipDR);
		        jQuery('#FileNo').val(selected.FileNo);
		        jQuery('#No').val(selected.No);
		        jQuery('#Name').val(selected.Name);
		        if (selected.RecordDate=="")
		        {
			        jQuery('#RecordDate').datebox('setValue', formatterDate(new Date()));
		        }
		        else
		        {
			    	jQuery('#RecordDate').datebox('setValue', selected.RecordDate);
		        }*/
		        if (selected.StartDate=="")
		        {
			        jQuery('#StartDate').datetimebox('setValue', formatterDateTime(new Date()));
		        }
		        else
		        {
			        jQuery('#StartDate').datetimebox('setValue', selected.StartDate+" "+selected.StartTime);
		        }
			    //jQuery('#StartTime').val(selected.StartTime);
			    if (selected.EndDate=="")
		        {
			        jQuery('#EndDate').datetimebox('setValue', formatterDateTime(new Date()));
		        }
		        else
		        {
			    	jQuery('#EndDate').datetimebox('setValue', selected.EndDate+" "+selected.EndTime);
		        }
			    //jQuery('#EndTime').val(selected.EndTime);
			    
			    jQuery('#UseContent').val(selected.UseContent);
			    jQuery('#EndStateInfo').val(selected.EndStateInfo);
			    jQuery("#Userdr").val(selected.UserDR);
				jQuery("#User").textbox('setValue',selected.User);
				
		        selectedEquipDR=selected.EquipDR;
         	}
     	}
	} 
	jQuery('#stateinfodatagrid').datagrid(
	{
    	url:'dhceq.jquery.csp',
    	queryParams:{
	        ClassName:"web.DHCEQStateInfo",
	        QueryName:"GetStateInfo",
	        ArgCnt:0
    	},
    	rowStyler:function(index,rowObj)
		{
			/*if (rowObj.Status=="新增")
			{
				//return 'background-color:pink;color:blue;font-weight:bold;';
				//return 'background-color:rgb(34,177,76);font-weight:bold;';
				return 'color:rgb(34,177,76);font-weight:bold;';
			}*/
			if ((rowObj.EndStateInfo!="")&&(rowObj.EndStateInfo!="正常"))
			{
				return 'color:rgb(255,0,0);font-weight:bold;';
			}
		},
		striped:'true',	//行条纹化
    	border:'true',
    	singleSelect: false,
		selectOnCheck: false,
		checkOnSelect: false,
    	//multiSort:'true',
    	//sortName:'Name',
    	//sortName:'No',
		//remoteSort:false,	//页面排序
		//sortOrder : 'desc', //升序
		//sortOrder : 'asc', //降序
    	//rownumbers:'true',
    	toolbar:[{  
                iconCls: 'icon-add',
                text:'新增',
                handler: function(){
                     AddGridData();
                }
                },'----------------',{
                iconCls: 'icon-save',
                text:'修改',
                handler: function(){
                     UpdateGridData();
                }   
                },'----------------',{
                iconCls: 'icon-remove',
                text:'删除',
                 handler: function(){
                     DeleteGridData();
                     }
                /*},'----------------',{
	            iconCls: 'icon-ok',
                text:'确认',
                 handler: function(){
                     AuditGridData();
                     }
                },'----------------',{
                iconCls: 'icon-reload',
                text:'清除',
                 handler: function(){
                     EmptyInput();
                     }
				},'----------------',{
                iconCls: 'icon-search',
                text:'查询',
                 handler: function(){
                     FindGridData();
                     }*/
                 }] ,
	    columns:[[
	    	{field:'Chk', title: '选中', width: 100, checkbox: true },
	        {field:'Row',title:'序号',width:40,align:'center'},
	        {field:'RowID',title:'RowID',width:50,hidden:true},
	        {field:'EquipDR',title:'EquipDR',width:50,hidden:true},
	        //{field:'Name',title:'设备名称',width:120,sortable:true},
	        {field:'Name',title:'设备名称',width:120},
	        {field:'FileNo',title:'档案号',width:60,align:'center'},
	        {field:'No',title:'设备编号',width:100},
	        {field:'Model',title:'规格型号',width:120},
	        //{field:'LeaveFactoryNo',title:'出厂编号',width:150},
	        {field:'StoreLoc',title:'所属科室',width:110},
	        {field:'EquipType',title:'类组',width:100,align:'center',hidden:true},
	        {field:'RecordDate',title:'登记日期',width:100,align:'center',editor:'datebox',hidden:true},
	        {field:'StartDate',title:'开机日期',width:70,align:'center',editor:'datebox'},
	        {field:'StartTime',title:'开机时间',width:70,align:'center',editor:'text'},
	        {field:'EndDate',title:'关机日期',width:70,align:'center',editor:'datebox'},
	        {field:'EndTime',title:'关机时间',width:70,align:'center',editor:'text'},
	        {field:'TotalTime',title:'使用时间(小时)',width:100,align:'center'},
	        {field:'UseContent',title:'使用内容',width:100,editor:'text'},
	        /*{
                field: 'StartState', title: '<input id=\"StartState\" type=\"checkbox\">正常开机', width: 75,
                    formatter: function (value, rec, rowIndex) {
                        return "<input type=\"checkbox\"  name=\"StartState\">";
                    }
                }, 
	        {field:'StartStateInfo',title:'开机备注',width:100,editor:'text'},
			{
                field: 'EndState', title: '<input id=\"EndState\" type=\"checkbox\">正常关机', width: 75,
                    formatter: function (value, rec, rowIndex) {
                        return "<input type=\"checkbox\"  name=\"EndState\">";
                    }
                }, */
	        {field:'EndStateInfo',title:'设备状况',width:100,editor:'text'},
	        {field:'UserDR',title:'UserDR',width:100,align:'center',hidden:true},
			{field:'User',title:'使用人',width:70},
			//{field:'Status',title:'记录状态',width:60,align:'center'},
	        //{field:'UpdateUser',title:'更新人',width:60,align:'center'},
	    ]],
	    
    	onClickRow : function (rowIndex, rowData)
    	{
        	StateInfoDataGrid_OnClickRow();
    	},
    	/*onLoadSuccess:function(data)
    	{
			if(data)
			{
				jQuery.each(data.rows, function(index, item)
					{
						if(item.checked)
						{
							jQuery('#stateinfodatagrid').datagrid('checkRow', index);
						}
				});
			}
		},
		onLoadSuccess: function ()
		{
            jQuery("#StartState").unbind();
            jQuery("#EndState").unbind();
            jQuery("input[name='StartState']").unbind().bind("click", function () {
                //总记录数
                var totolrows = jQuery("input[name='StartState']").length;
                //选中的记录数
                var checkrows = jQuery("input[name='StartState']:checked").length;
                //全选
                if (checkrows == totolrows) {
                    jQuery("#StartState").prop("checked",true);
                }
                else {
                    jQuery("#StartState").prop("checked",false);
                }
            });
            jQuery("input[name='EndState']").unbind().bind("click", function () {
                //总记录数
                var totolrows = jQuery("input[name='EndState']").length;
                //选中的记录数
                var checkrows = jQuery("input[name='EndState']:checked").length;
                if (checkrows == totolrows) {
                    jQuery("#EndState").prop("checked",true);
                }
                else {
                    jQuery("#EndState").prop("checked",false);
                }
            });

            //全选
            jQuery("#StartState").click(function () {
                if (jQuery(this).is(":checked"))
				{
                    jQuery("input[name='StartState']").prop("checked",true);
                } else {
					jQuery("input[name='StartState']").prop("checked",false);
                    
                }
            });
            jQuery("#EndState").click(function () {
                if (jQuery(this).is(":checked"))
				{
                    jQuery("input[name='EndState']").prop("checked",true);
                } else {
                    jQuery("input[name='EndState']").prop("checked",false);
                }
            });
        },*/
    	pagination:true,
   		pageSize:25,
    	pageNumber:1,
    	pageList:[25,50,75,100]
	});
	//得到当前日期
	formatterDate = function(date)
	{
		var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
		var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0"	+ (date.getMonth() + 1);
		return date.getFullYear() + '-' + month + '-' + day;
	}
	//得到当前日期时间
	formatterDateTime = function(date)
	{
		var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
		var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0" + (date.getMonth() + 1);
		return date.getFullYear() + '-' + month + '-' + day + " " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
	}
	
	
	//查询
	function FindGridData()
	{
		//20171011 Mozy0200	????????
		jQuery('#stateinfodatagrid').datagrid({    
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQStateInfo",
	        QueryName:"GetStateInfo",
	        Arg1:jQuery('#FileNo').val(),
	        Arg2:jQuery('#No').val(),
	        Arg3:jQuery('#Name').val(),
	        Arg4:"",
	        Arg5:"",
	        Arg6:SessionObj.GLOCID,
	        ArgCnt:6	//20171011 Mozy0200	增加登陆科室参数
	    },
	    border:'true',
	    singleSelect:true});
	}
	/// 新增AddGridData方法
	function AddGridData()
	{
		/*if (jQuery('#EquipDR').val()==""){
	           jQuery.messager.alert("错误", "未选择设备！", 'error')
	           return false;
	    }*/
	    /*if (jQuery('#RecordDate').combogrid('getValue')==""){
	            jQuery.messager.alert("错误", "登记日期不能为空！", 'error')
	            return false;
	    }
	    /*if (jQuery('#User').combogrid('getValue')==""){
	            jQuery.messager.alert("错误", "使用人不能为空！", 'error')
	            return false;
		}*/
		var EquipDRStr="";
		var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
		for(var i=0;i<checkedItems.length;i++)
		{
			//获取每一行的数据
			//messageShow("","","",checkedItems[i].EquipDR)
			if (EquipDRStr!="") EquipDRStr=EquipDRStr+",";
			EquipDRStr=EquipDRStr+checkedItems[i].EquipDR;
		}
		if (EquipDRStr=="")
		{
	        jQuery.messager.alert("错误", "未选择设备!", 'error');
	        return false;
	    }
	    var Info=EquipDRStr+"&^"+jQuery('#Type').val()+"^^^"+jQuery('#StartDate').combogrid('getValue')+"^"+jQuery('#StartTime').val()+"^"+jQuery('#EndDate').combogrid('getValue')+"^"+jQuery('#EndTime').val()+"^"+jQuery('#UseContent').val()+"^^^^"+jQuery('#EndStateInfo').val()+"^"+jQuery('#Userdr').val()	//jQuery('#User').combogrid('getValue');
	    jQuery.ajax({
	        url :"dhceq.jquery.method.csp",
	        type:"POST",
	        data:{
	            ClassName:"web.DHCEQStateInfo",
	            MethodName:"SaveStateInfo",
	            Arg1:Info,
	            Arg2:0,
	            ArgCnt:2
	        },
	        beforeSend: function ()
			{
	            jQuery.messager.progress({
	                text: '正在保存中...'
	            });
	        },
	        error:function(XMLHttpRequest, textStatus, errorThrown)
			{
	            /*begin modify by jyp 2018-03-23 566030
	            messageShow("","","",XMLHttpRequest.status);
	            messageShow("","","",XMLHttpRequest.readyState);
	            messageShow("","","",textStatus);
	            */
	            jQuery.messager.progress('close');
	            ErrorMessages(XMLHttpRequest,textStatus,errorThrown);
	            //end modify by jyp 2018-03-23 566030
	        },
			success:function (data, response, status)
			{
	            jQuery.messager.progress('close');
	            var list=data.split("^");
	            if (list[0] ==0)
				{
					jQuery('#stateinfodatagrid').datagrid('reload'); 
	            	jQuery.messager.show({title: '提示',msg:'保存成功'});
	            }   
	            else
	            {
	               	jQuery.messager.alert('保存失败！',list[0], 'warning')
	               	return;
	            }
	        }
	    })
	}
	///修改
	function UpdateGridData()
	{
		/*if (jQuery('#EquipDR').val()==""){
	           jQuery.messager.alert("错误", "未选择设备！", 'error')
	           return false;
	    }
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
		var RowIDStr="";
		var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
		for(var i=0;i<checkedItems.length;i++)
		{
			//获取每一行的数据
			//messageShow("","","",checkedItems[i].RowID)
			if (checkedItems[i].RowID!="")
			{
				if (RowIDStr!="") RowIDStr=RowIDStr+",";
				RowIDStr=RowIDStr+checkedItems[i].RowID;
			}
		}
		if (RowIDStr=="")
		{
	        jQuery.messager.alert("错误", "未选择设备!", 'error');
	        return false;
	    }
	    var Info=RowIDStr+"&^"+jQuery('#Type').val()+"^^^"+jQuery('#StartDate').combogrid('getValue')+"^"+jQuery('#StartTime').val()+"^"+jQuery('#EndDate').combogrid('getValue')+"^"+jQuery('#EndTime').val()+"^"+jQuery('#UseContent').val()+"^^^^"+jQuery('#EndStateInfo').val()+"^"+jQuery('#Userdr').val();
		jQuery.ajax({
	        url :"dhceq.jquery.method.csp",
	        type:"POST",
	        data:{
	            ClassName:"web.DHCEQStateInfo",
	            MethodName:"SaveStateInfo",
	            Arg1:Info,
	            Arg2:1,
	            ArgCnt:2
	        },
	        beforeSend: function ()
			{
	            jQuery.messager.progress({
	                text: '正在保存中...'
	            });
	        },
	        error:function(XMLHttpRequest, textStatus, errorThrown)
			{
	            /*begin modify by jyp 2018-03-23 566030
	            messageShow("","","",XMLHttpRequest.status);
	            messageShow("","","",XMLHttpRequest.readyState);
	            messageShow("","","",textStatus);
	            */
	            jQuery.messager.progress('close');
	            ErrorMessages(XMLHttpRequest,textStatus,errorThrown);
	            //end modify by jyp 2018-03-23 566030
	        },
	        success:function (data, response, status)
			{
	            jQuery.messager.progress('close');
	            var list=data.split("^");
	            if (list[0] ==0)
				{
					jQuery('#stateinfodatagrid').datagrid('reload'); 
	            	jQuery.messager.show({title: '提示',msg:'保存成功'});
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
	    /*if (jQuery('#RowID').val()=="")
	    {
		    jQuery.messager.alert("错误", "请选中一行！", 'error')
	        return;
	    }*/
		var RowIDStr="";
		var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
		for(var i=0;i<checkedItems.length;i++)
		{
			//获取每一行的数据
			//messageShow("","","",checkedItems[i].RowID)
			if (checkedItems[i].RowID!="")
			{
				if (RowIDStr!="") RowIDStr=RowIDStr+",";
				RowIDStr=RowIDStr+checkedItems[i].RowID;
			}
		}
		if (RowIDStr=="")
		{
	        jQuery.messager.alert("错误", "未选择设备!", 'error');
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
			        jQuery.ajax({
			            url :"dhceq.jquery.method.csp",
			            type:"POST",
			            data:{
			                ClassName:"web.DHCEQStateInfo",
			                MethodName:"DeleteStateInfo",
			                Arg1:RowIDStr,
			                ArgCnt:1
			            },
			            success:function (data, response, status)
			            {
				            jQuery.messager.progress('close');
				            var list=data.split("^");
				            if (list[0] ==0)
				            {
					            jQuery('#stateinfodatagrid').datagrid('reload');
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
	function AuditGridData()
	{
	    if (jQuery('#RowID').val()=="")
	    {
		    jQuery.messager.alert("错误", "请选中一行！", 'error')
	        return;
	    }
        jQuery.messager.confirm('请确认', '您确定要审核所选的行？',
	        function (b)
	        { 
		        if (b==false)
		        {
		             return;
		        }
		        else
		        {
			        jQuery.ajax({
			            url :"dhceq.jquery.method.csp",
			            type:"POST",
			            data:{
			                ClassName:"web.DHCEQStateInfo",
			                MethodName:"AuditStateInfo",
			                Arg1:jQuery('#RowID').val(),
			                ArgCnt:1
			            },
			            success:function (data, response, status)
			            {
				            jQuery.messager.progress('close');
				            var list=data.split("^");
				            if (list[0] ==0)
				            {
					            jQuery('#stateinfodatagrid').datagrid('reload');
					            jQuery.messager.show({title: '提示',msg: '审核成功'});
					            EmptyInput();
			            	}   
			            	else
			            	{
			               		jQuery.messager.alert('审核失败！',list[0], 'warning')
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
		jQuery('#RowID').val("");
        jQuery('#EquipDR').val("");
		//20171011 Mozy0200
        /*jQuery('#FileNo').val("");
        jQuery('#No').val("");
        jQuery('#Name').val("");*/
        jQuery('#RecordDate').combo('setText','');
        jQuery('#StartDate').combo('setText','');
	    jQuery('#StartTime').val("");
	    jQuery('#EndDate').combo('setText','');
	    jQuery('#EndTime').val("");
	    jQuery('#UseContent').val("");
	    jQuery('#EndStateInfo').val("正常");
	    //Mozy0200	2017-10-11	增加默认登陆人设置
		jQuery("#Userdr").val(SessionObj.GUSERID);
		jQuery("#User").textbox('setValue',SessionObj.GUSERNAME);
	}
});
function initComboGridPanel()
{
	jQuery("input[name='combogrid']").each(function() { 
		var options=eval('(' + jQuery(this).attr("data-options") + ')');
		jQuery(this).initComboGrid(options);
	});
}