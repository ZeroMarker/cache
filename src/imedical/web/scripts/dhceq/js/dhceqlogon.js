/*
** add by zx  2017-06-01
** �豸����ϵͳ������¼��ȡuserid
*/
function checkPassword()
{
	var username=jQuery("#username").val();
	var password=jQuery("#password").val();
	if (username=="")
	{
		jQuery("#font").html("�û�������Ϊ�գ�");
		return;
	}
	if (password=="")
	{
		jQuery("#font").html("���벻��Ϊ�գ�");
		return;
	}
	jQuery.ajax({
    	async: false, //true,
        url :"dhceq.jquery.method.logon.csp",
        type:"POST",
            data:{
            ClassName:"web.DHCEQCommon",
            MethodName:"Logon",
            Arg1:username,
        	Arg2:password,
	        ArgCnt:2
        },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                    messageShow("","","",XMLHttpRequest.status);
                    messageShow("","","",XMLHttpRequest.readyState);
                    messageShow("","","",textStatus);
        },
        success:function (data, response, status) {
        	jQuery.messager.progress('close');
			data=data.replace(/\ +/g,"");	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"");	//ȥ���س�����
			if(data=="-3")
			{
				jQuery("#font").html("�û����������������룡");
			}
			else if(data=="-4")
			{
				jQuery("#font").html("����������������룡");
			}
			else
			{
				
				/*
				jQuery("#font").html("");
				*/
				jQuery("#UserID").val(data.split("^")[0]);
				jQuery("#font").html("");
				loadUserInfo();
			}
       }
    })
}
/*
** add by zx  2017-06-02
** �豸����ϵͳ������¼��ȫ���б�
*/
function loadUserInfo()
{
	jQuery('#groupdatagrid').datagrid({   
	    url:'dhceq.jquery.csp', 
	    queryParams:{
	        ClassName:"web.DHCEQCommon",
	        QueryName:"LogonLocGrp",
	        Arg1:jQuery("#UserID").val(),
	        ArgCnt:1
	    },
	    border:'true',
	    singleSelect:true,
	    columns:[[
	    	{field:'GrpID',title:'GrpID',width:50,hidden:true},    
	        {field:'LocID',title:'LocID',width:50,align:'center',hidden:true},
	        {field:'LocDesc',title:'����',width:200,align:'center'},
	        {field:'GrpDesc',title:'��ȫ��',width:200,align:'center'}
	    ]],
	    onClickRow : function (rowIndex, rowData) {
	        groupdatagrid_OnClickRow();
	    }, 
	    pagination:true,
	    pageSize:10,
	    pageNumber:1,
	    pageList:[10,20,30,40,50]
	});
	jQuery('#dlg').dialog('open');
}
/*
** add by zx  2017-06-02
** ѡ��ȫ��
*/
function groupdatagrid_OnClickRow()
{
     var selected=$('#groupdatagrid').datagrid('getSelected');
     if (selected)
     {
     	jQuery("#group").val(selected.LocDesc);
     	jQuery("#GroupID").val(selected.GrpID);
     	jQuery("#LocID").val(selected.LocID);
     	jQuery('#dlg').dialog('close');
     }
}
/*
** add by zx  2017-06-02
** Ȩ����֤
*/ 
function checkFunction()
{
	jQuery.ajax({
    	async: false, //true,
    	cache: false,
        url: "dhceq.jquery.method.logon.csp",
        timeout: 50000,
        type:"POST",
            data:{
            ClassName:"web.DHCEQ.Process.DHCEQVisualization",
            MethodName:"CheckFunction",
            Arg1:jQuery("#UserID").val(),
        	Arg2:jQuery("#LocID").val(),
        	Arg3:jQuery("#GroupID").val(),
	        ArgCnt:3
        },
       	error:function(XMLHttpRequest, textStatus, errorThrown){
                    messageShow("","","",XMLHttpRequest.status);
                    messageShow("","","",XMLHttpRequest.readyState);
                    messageShow("","","",textStatus);
        },
        success:function (data, response, status) {
        	jQuery.messager.progress('close');
			data=data.replace(/\ +/g,"");	//ȥ���ո�
			data=data.replace(/[\r\n]/g,"");	//ȥ���س�����
			if(data=="0")
			{
				var url="dhceq.process.visualization.csp";
				var height=document.body.clientHeight;
				var widht=document.body.clientWidth;
				//var height=window.screen.availHeight;
				//var widht=window.screen.availWidth;
				window.opener=null;
    			window.open("","_self");
    			window.close();
    			window.open(url,'_blank','fullscreen=1');
				//window.open(url,'_blank',',toolbar=no,titlebar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=yes,copyhistory=yes,width='+widht+',height='+height+',left=0,top=0');
			}
			else
			{
				jQuery("#font").html("����Ȩ�ޣ�");
			}
       }
    })
}
// add by zx 2017-10-19 ������ȡ
function GetQueryString(name) { 
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i"); 
	var r = window.location.search.substr(1).match(reg); 
	
	if (r != null) return unescape(r[2]); 
	return null; 
} 