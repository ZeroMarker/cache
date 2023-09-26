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
		striped:'true',	//�����ƻ�
    	border:false,   //modify by lmm 2020-04-26 1289831
    	singleSelect: true,
		selectOnCheck: true,
		checkOnSelect: true,
    	//multiSort:'true',
    	fit:true,  //modify by lmm 2020-06-05
    	//sortName:'Name',
    	//sortName:'No',
		//remoteSort:false,	//ҳ������
		//sortOrder : 'desc', //����
		//sortOrder : 'asc', //����
    	//rownumbers:'true',
        toolbar:[
	    	{
				iconCls: 'icon-add',
	            text:'����',
	            id:'btnsave',       
	            handler: function(){
	                 UpdateGridData();
	            }
	        },
	        {
	            iconCls: 'icon-cancel',
	            text:'ɾ��',
	            id:'btnremove',
	            handler: function(){
	                 DeleteGridData();
	            }
	        }
	    ],
	    columns:[[
	        {field:'Row',title:'���',width:40,align:'center'},
	        {field:'RowID',title:'RowID',width:50,hidden:true},
	        {field:'Index',title:'Index',width:50,hidden:true},
	        //{field:'Name',title:'�豸����',width:120,sortable:true},
	        {field:'Item',title:'��Ŀ',width:240},
	        {field:'Fee',title:'����',width:150,align:'right'},
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
	
	///�޸�
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
			jQuery.messager.alert("����", "��ά����¼.", 'error')
	        return false;
	    }
		if (checkMustItemNull()) return;	//add by lmm 2020-04-26 1289831

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
	                text: '���ڱ�����...'
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
	            	jQuery.messager.show({title: '��ʾ',msg:'����ɹ�'});
	            	EmptyInput();
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
			jQuery.messager.alert("����", "��ά����¼.", 'error')
	        return false;
	    }
	    if (jQuery('#Index').val()=="")
		{
			jQuery.messager.alert("����", "δѡ����Ŀ��¼.", 'error')
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
	/// ����:��պ���
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