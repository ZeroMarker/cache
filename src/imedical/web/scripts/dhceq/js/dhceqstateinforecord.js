jQuery(document).ready(function ()
{
	initComboGridPanel();
	jQuery('#FileNo').validatebox({width: 160});
	jQuery('#No').validatebox({width: 160});
	jQuery('#Name').validatebox({width: 160});
	jQuery("#BFind").on("click", FindGridData);
	jQuery("#BReload").on("click", EmptyInput);
	//Mozy0200	2017-10-11	����Ĭ�ϵ�½������
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
             	/// ���¼��ر���ɫ-�����ɫ
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
			/*if (rowObj.Status=="����")
			{
				//return 'background-color:pink;color:blue;font-weight:bold;';
				//return 'background-color:rgb(34,177,76);font-weight:bold;';
				return 'color:rgb(34,177,76);font-weight:bold;';
			}*/
			if ((rowObj.EndStateInfo!="")&&(rowObj.EndStateInfo!="����"))
			{
				return 'color:rgb(255,0,0);font-weight:bold;';
			}
		},
		striped:'true',	//�����ƻ�
    	border:'true',
    	singleSelect: false,
		selectOnCheck: false,
		checkOnSelect: false,
    	//multiSort:'true',
    	//sortName:'Name',
    	//sortName:'No',
		//remoteSort:false,	//ҳ������
		//sortOrder : 'desc', //����
		//sortOrder : 'asc', //����
    	//rownumbers:'true',
    	toolbar:[{  
                iconCls: 'icon-add',
                text:'����',
                handler: function(){
                     AddGridData();
                }
                },'----------------',{
                iconCls: 'icon-save',
                text:'�޸�',
                handler: function(){
                     UpdateGridData();
                }   
                },'----------------',{
                iconCls: 'icon-remove',
                text:'ɾ��',
                 handler: function(){
                     DeleteGridData();
                     }
                /*},'----------------',{
	            iconCls: 'icon-ok',
                text:'ȷ��',
                 handler: function(){
                     AuditGridData();
                     }
                },'----------------',{
                iconCls: 'icon-reload',
                text:'���',
                 handler: function(){
                     EmptyInput();
                     }
				},'----------------',{
                iconCls: 'icon-search',
                text:'��ѯ',
                 handler: function(){
                     FindGridData();
                     }*/
                 }] ,
	    columns:[[
	    	{field:'Chk', title: 'ѡ��', width: 100, checkbox: true },
	        {field:'Row',title:'���',width:40,align:'center'},
	        {field:'RowID',title:'RowID',width:50,hidden:true},
	        {field:'EquipDR',title:'EquipDR',width:50,hidden:true},
	        //{field:'Name',title:'�豸����',width:120,sortable:true},
	        {field:'Name',title:'�豸����',width:120},
	        {field:'FileNo',title:'������',width:60,align:'center'},
	        {field:'No',title:'�豸���',width:100},
	        {field:'Model',title:'����ͺ�',width:120},
	        //{field:'LeaveFactoryNo',title:'�������',width:150},
	        {field:'StoreLoc',title:'��������',width:110},
	        {field:'EquipType',title:'����',width:100,align:'center',hidden:true},
	        {field:'RecordDate',title:'�Ǽ�����',width:100,align:'center',editor:'datebox',hidden:true},
	        {field:'StartDate',title:'��������',width:70,align:'center',editor:'datebox'},
	        {field:'StartTime',title:'����ʱ��',width:70,align:'center',editor:'text'},
	        {field:'EndDate',title:'�ػ�����',width:70,align:'center',editor:'datebox'},
	        {field:'EndTime',title:'�ػ�ʱ��',width:70,align:'center',editor:'text'},
	        {field:'TotalTime',title:'ʹ��ʱ��(Сʱ)',width:100,align:'center'},
	        {field:'UseContent',title:'ʹ������',width:100,editor:'text'},
	        /*{
                field: 'StartState', title: '<input id=\"StartState\" type=\"checkbox\">��������', width: 75,
                    formatter: function (value, rec, rowIndex) {
                        return "<input type=\"checkbox\"  name=\"StartState\">";
                    }
                }, 
	        {field:'StartStateInfo',title:'������ע',width:100,editor:'text'},
			{
                field: 'EndState', title: '<input id=\"EndState\" type=\"checkbox\">�����ػ�', width: 75,
                    formatter: function (value, rec, rowIndex) {
                        return "<input type=\"checkbox\"  name=\"EndState\">";
                    }
                }, */
	        {field:'EndStateInfo',title:'�豸״��',width:100,editor:'text'},
	        {field:'UserDR',title:'UserDR',width:100,align:'center',hidden:true},
			{field:'User',title:'ʹ����',width:70},
			//{field:'Status',title:'��¼״̬',width:60,align:'center'},
	        //{field:'UpdateUser',title:'������',width:60,align:'center'},
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
                //�ܼ�¼��
                var totolrows = jQuery("input[name='StartState']").length;
                //ѡ�еļ�¼��
                var checkrows = jQuery("input[name='StartState']:checked").length;
                //ȫѡ
                if (checkrows == totolrows) {
                    jQuery("#StartState").prop("checked",true);
                }
                else {
                    jQuery("#StartState").prop("checked",false);
                }
            });
            jQuery("input[name='EndState']").unbind().bind("click", function () {
                //�ܼ�¼��
                var totolrows = jQuery("input[name='EndState']").length;
                //ѡ�еļ�¼��
                var checkrows = jQuery("input[name='EndState']:checked").length;
                if (checkrows == totolrows) {
                    jQuery("#EndState").prop("checked",true);
                }
                else {
                    jQuery("#EndState").prop("checked",false);
                }
            });

            //ȫѡ
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
	//�õ���ǰ����
	formatterDate = function(date)
	{
		var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
		var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0"	+ (date.getMonth() + 1);
		return date.getFullYear() + '-' + month + '-' + day;
	}
	//�õ���ǰ����ʱ��
	formatterDateTime = function(date)
	{
		var day = date.getDate() > 9 ? date.getDate() : "0" + date.getDate();
		var month = (date.getMonth() + 1) > 9 ? (date.getMonth() + 1) : "0" + (date.getMonth() + 1);
		return date.getFullYear() + '-' + month + '-' + day + " " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
	}
	
	
	//��ѯ
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
	        ArgCnt:6	//20171011 Mozy0200	���ӵ�½���Ҳ���
	    },
	    border:'true',
	    singleSelect:true});
	}
	/// ����AddGridData����
	function AddGridData()
	{
		/*if (jQuery('#EquipDR').val()==""){
	           jQuery.messager.alert("����", "δѡ���豸��", 'error')
	           return false;
	    }*/
	    /*if (jQuery('#RecordDate').combogrid('getValue')==""){
	            jQuery.messager.alert("����", "�Ǽ����ڲ���Ϊ�գ�", 'error')
	            return false;
	    }
	    /*if (jQuery('#User').combogrid('getValue')==""){
	            jQuery.messager.alert("����", "ʹ���˲���Ϊ�գ�", 'error')
	            return false;
		}*/
		var EquipDRStr="";
		var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
		for(var i=0;i<checkedItems.length;i++)
		{
			//��ȡÿһ�е�����
			//messageShow("","","",checkedItems[i].EquipDR)
			if (EquipDRStr!="") EquipDRStr=EquipDRStr+",";
			EquipDRStr=EquipDRStr+checkedItems[i].EquipDR;
		}
		if (EquipDRStr=="")
		{
	        jQuery.messager.alert("����", "δѡ���豸!", 'error');
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
	                text: '���ڱ�����...'
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
	            	jQuery.messager.show({title: '��ʾ',msg:'����ɹ�'});
	            }   
	            else
	            {
	               	jQuery.messager.alert('����ʧ�ܣ�',list[0], 'warning')
	               	return;
	            }
	        }
	    })
	}
	///�޸�
	function UpdateGridData()
	{
		/*if (jQuery('#EquipDR').val()==""){
	           jQuery.messager.alert("����", "δѡ���豸��", 'error')
	           return false;
	    }
	    /*if (jQuery('#RecordDate').combogrid('getValue')==""){
	            jQuery.messager.alert("����", "�Ǽ����ڲ���Ϊ�գ�", 'error')
	            return false;
	    }
	    /*if (jQuery('#User').combogrid('getValue')==""){
	            jQuery.messager.alert("����", "ʹ���˲���Ϊ�գ�", 'error')
	            return false;
		}*/
		//IsValidDate(jQuery('#StartDate').combogrid('getValue'))
		//return
		var RowIDStr="";
		var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
		for(var i=0;i<checkedItems.length;i++)
		{
			//��ȡÿһ�е�����
			//messageShow("","","",checkedItems[i].RowID)
			if (checkedItems[i].RowID!="")
			{
				if (RowIDStr!="") RowIDStr=RowIDStr+",";
				RowIDStr=RowIDStr+checkedItems[i].RowID;
			}
		}
		if (RowIDStr=="")
		{
	        jQuery.messager.alert("����", "δѡ���豸!", 'error');
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
	                text: '���ڱ�����...'
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
	            	jQuery.messager.show({title: '��ʾ',msg:'����ɹ�'});
	            }   
	            else
	            {
	               	jQuery.messager.alert('����ʧ�ܣ�',list[0], 'warning')
	               	return;
	            }
	        }
	    })
	}
	function DeleteGridData()
	{
	    /*if (jQuery('#RowID').val()=="")
	    {
		    jQuery.messager.alert("����", "��ѡ��һ�У�", 'error')
	        return;
	    }*/
		var RowIDStr="";
		var checkedItems = $('#stateinfodatagrid').datagrid('getChecked');
		for(var i=0;i<checkedItems.length;i++)
		{
			//��ȡÿһ�е�����
			//messageShow("","","",checkedItems[i].RowID)
			if (checkedItems[i].RowID!="")
			{
				if (RowIDStr!="") RowIDStr=RowIDStr+",";
				RowIDStr=RowIDStr+checkedItems[i].RowID;
			}
		}
		if (RowIDStr=="")
		{
	        jQuery.messager.alert("����", "δѡ���豸!", 'error');
	        return false;
	    }
        jQuery.messager.confirm('��ȷ��', '��ȷ��Ҫɾ����ѡ���У�',
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
					            jQuery.messager.show({title: '��ʾ',msg: 'ɾ���ɹ�'});
					            EmptyInput();
			            	}   
			            	else
			            	{
			               		jQuery.messager.alert('ɾ��ʧ�ܣ�',list[0], 'warning')
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
		    jQuery.messager.alert("����", "��ѡ��һ�У�", 'error')
	        return;
	    }
        jQuery.messager.confirm('��ȷ��', '��ȷ��Ҫ�����ѡ���У�',
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
					            jQuery.messager.show({title: '��ʾ',msg: '��˳ɹ�'});
					            EmptyInput();
			            	}   
			            	else
			            	{
			               		jQuery.messager.alert('���ʧ�ܣ�',list[0], 'warning')
			               		return;
			               	}
			           	}
			        })
		        }
	    	}
	    )
	}
	/// ����:��պ���
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
	    jQuery('#EndStateInfo').val("����");
	    //Mozy0200	2017-10-11	����Ĭ�ϵ�½������
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