//�������
jQuery(document).ready
(    
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	initPanel();
}
function initPanel()
{ 

	initTopPanel();
}
//��ʼ����ѯͷ���
function initTopPanel()
{
	initButton(); //��ť��ʼ��
    initButtonWidth();
    setEnabled(); //��ť����
	defindTitleStyle(); 
	initMessage("");   
	setRequiredElements("AppendFileType^ADocName^FileName")
	initDHCEQFileFindData();
	initAppendFileTypeData()
	jQuery('#BAdd').on("click", BAdd_Clicked);
	if (getElementValue("Status")>0)
	{
		$('#tDHCEQFileFind').datagrid('hideColumn', 'Delete');
		$('#tDHCEQFileFind').datagrid('hideColumn', 'Update');
	}
	if (getElementValue("ReadOnly")!="")
	{
		$('#tDHCEQFileFind').datagrid('hideColumn', 'Delete');
		$('#tDHCEQFileFind').datagrid('hideColumn', 'Update');
	}
}
function initDHCEQFileFindData(){
	$HUI.datagrid("#tDHCEQFileFind",{   
	    url:$URL, 
    	queryParams:{
        ClassName:"web.DHCEQ.Plat.CTAppendFile",
        QueryName:"GetAppendFile",
        CurrentSourceType:getElementValue("CurrentSourceType"),
        CurrentSourceID:getElementValue("CurrentSourceID"),
        DocName:getElementValue("DocName")
    	},
  		singleSelect:true,
   		fitColumns:true,    
    columns:[[
    	{field:'TRowID',title:'TRowID',width:50,hidden:'ture'},    
        {field:'TSourceType',title:'TSourceType',width:60,align:'center',hidden:'ture'},
        {field:'TSourceTypeDesc',title:'ҵ����Դ����',width:100,align:'center'},  
		{field:'TSourceID',title:'TSourceID',width:50,hidden:'ture'},
		{field:'TAppendFileTypeDR',title:'TAppendFileTypeDR',width:50,hidden:'ture'},
		{field:'TAppendFileTypeDesc',title:'������Դ����',width:100,align:'center'},
		{field:'TDocName',title:'��������',width:100,align:'center'},
		{field:'TFileName',title:'�ļ�����',width:100,align:'center',hidden:'ture'},
		{field:'TFilePath',title:'TFilePath',width:100,align:'center',hidden:'ture'},
		{field:'TFileType',title:'�ļ�����',width:100,align:'center'},
		{field:'TRemark',title:'��ע',width:100,align:'center'},
		{field:'TToSwfFlag',title:'����',width:100,align:'center',hidden:'ture'},
		{field:'TFtpStreamSrc',title:'����',width:100,align:'center',hidden:'ture'},  
		{field:'View',title:'���',width:100,align:'center',formatter: ViewOperation},
		{field:'Update',title:'����',width:100,align:'center',formatter: UpdateOperation},
		{field:'DownLoad',title:'����',width:100,align:'center',formatter: DownLoadOperation},
		{field:'Delete',title:'ɾ��',width:100,align:'center',formatter: DeleteOperation},                 
    ]],
    pagination:true,
    pageSize:15,
    pageNumber:1,
    pageList:[15,30,45,60,75]   
});
}
function ViewOperation(value,row,index)
{
	if ((row.TToSwfFlag!="Y")&&(row.TFileType!="pdf"))
	{
		var ftpappendfilename=row.TRowID+"."+row.TFileType;
		var btn ='<a href="#" onclick="AppendFileSwitchAndView(&quot;'+ftpappendfilename+'&quot;)"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png"/></a>'; 
	}
	else
	{
		//Modify by zx 2020-05-07 �ļ�Ԥ����������޸� BUG ZX0086
		//var btn ="<a  onclick='window.open(&quot;dhceq.process.appendfileview.csp?RowID="+row.TRowID+"&ToSwfFlag=Y&quot;,&quot_blank&quot,&quot;toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes&quot;)'><img border=0 complete='complete' src='../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png' /></a>";
		var btn ='<A onclick="showWindow(&quot;dhceq.process.appendfileview.csp?RowID='+row.TRowID+'&ToSwfFlag=Y&quot;,&quot;�ļ�Ԥ��&quot;,&quot;&quot;,&quot;&quot;,&quot;icon-w-paper&quot;,&quot;modal&quot;,&quot;&quot;,&quot;&quot;,&quot;large&quot;)" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/eye.png"/></A>';
	}
	return btn;
}
//Modify by zx 2020-05-07 �ļ�Ԥ����������޸� BUG ZX0086
function AppendFileSwitchAndView(ftpappendfilename){
	var DHCEQTomcatServer=getElementValue("DHCEQTomcatServer")
	var url=DHCEQTomcatServer+"DHCEQOfficeView/uploadfile.jsp?ftpappendfilename="+ftpappendfilename;
	showWindow(url,"�ļ�Ԥ��","","","icon-w-paper","modal","","","large"); 
	//window.open(DHCEQTomcatServer+"DHCEQOfficeView/uploadfile.jsp?ftpappendfilename="+ftpappendfilename,'_blank',"toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes"); //add by zx 2017-08-09 BUG ZX0038
}
function DownLoadOperation(value,row,index)
{
	//Modify by zx 2020-05-07 �ļ�Ԥ����������޸� BUG ZX0086
	var ftpappendfilename=tkMakeServerCall("web.DHCEQ.Process.DHCEQAppendFile","GetFtpStreamSrcByAFRowID",row.TRowID);
	//var btn="<a onclick='window.open(&quot;"+ftpappendfilename+"&quot;)'><img border=0 complete='complete' src='../scripts_lib/hisui-0.1.0/dist/css/icons/download.png' /></a>";
	var btn="<a onclick='showWindow(&quot;"+ftpappendfilename+"&quot;,&quot;�ļ�����&quot;,&quot;&quot;,&quot;&quot;,&quot;icon-w-paper&quot;,&quot;modal&quot;,&quot;&quot;,&quot;&quot;,&quot;middle&quot;)'><img border=0 complete='complete' src='../scripts_lib/hisui-0.1.0/dist/css/icons/download.png'/></a>";
	return btn;
}
function DeleteOperation(value,row,index)
{
	var btn='<A onclick="Delete('+row.TRowID+')" href="#"><img border=0 complete="complete" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel.png" /></A>'   ////Modefied by zc0063 20200407  ��ɾ��ͼ���滻
	return btn;
}
function UpdateOperation(value,row,index)
{
	var str=row.TAppendFileTypeDR+","+row.TDocName+","+row.TRemark
	var btn="<a onclick='UpDate(&quot;"+str+"&quot;)'><img border=0 complete='complete' src='../scripts_lib/hisui-0.1.0/dist/css/icons/update.png' /></a>";
	return btn;
}
function Delete(RowID)
{
	$.post("dhceq.process.appendfileaction.csp?&actiontype=DeleteAppendFile&RowID="+RowID, "", function(text, status) {
                            if(status=="success"){
                                $.messager.alert("��ʾ", "ɾ���ɹ�");
                                $('#tDHCEQFileFind').datagrid('reload');
                            }
                        }, "text").error(function() { 
                            $.messager.alert("��ʾ", "ɾ��ʧ�ܣ�");
                            $('#tDHCEQFileFind').datagrid('reload');
                        })
}	
function BFind_Clicked(){
	$HUI.datagrid("#tDHCEQFileFind",{   
	    url:$URL, 
    	queryParams:{
        ClassName:"web.DHCEQ.Plat.CTAppendFile",
        QueryName:"GetAppendFile",
        CurrentSourceType:getElementValue("CurrentSourceType"),
        CurrentSourceID:getElementValue("CurrentSourceID"),
        DocName:getElementValue("DocName")
    	},
});
}
function BAdd_Clicked(){
	setElement("ADocName","")
	setElement("Remark","")
	setElement("AppendFileType","")
	setElement("FileName","")
	$HUI.dialog('#UpLoadFile').open();
	$('#tDHCEQFileFind').datagrid('unselectAll')
}
function initAppendFileTypeData()
{
	var PicTypesJson=tkMakeServerCall("web.DHCEQ.Process.DHCEQCPicSourceType","GetPicTypeMenu",getElementValue("CurrentSourceType"),"","1")
	var vdata=eval(PicTypesJson)
	var AppendFileType = $HUI.combobox('#AppendFileType',
					{
		valueField:'id', 
		textField:'text',
		selectOnNavigation:false,
		panelHeight:"auto",
		data:vdata,
		
});
}
function UpDate(list)
{
	$HUI.dialog('#UpLoadFile').open();
	var Info=list.split(",")
	setElement("ADocName",Info[1])
	setElement("Remark",Info[2])
	setElement("AppendFileType",Info[0])
}
function BSave_Clicked()
{
	var RowID="";
	var selected=$('#tDHCEQFileFind').datagrid('getSelected');
    if (selected)
    {     
       	RowID=selected.TRowID;
    }
    if (checkMustItemNull()) return;
	//Moidefied by zc0064 2020-4-8  �������Ƶȴ����̨�������⴦�� begin
    //var str="&SourceType="+getElementValue("CurrentSourceType")+"&SourceID="+getElementValue("CurrentSourceID")+"&AppendFileTypeDR="+$('#AppendFileType').combobox('getValue')+"&DocName="+getElementValue("ADocName")+"&Remark="+getElementValue("Remark")
	var str="&SourceType="+getElementValue("CurrentSourceType")+"&SourceID="+getElementValue("CurrentSourceID")+"&AppendFileTypeDR="+$('#AppendFileType').combobox('getValue')+"&DocName="+encodeURIComponent(getElementValue("ADocName"))+"&Remark="+encodeURIComponent(getElementValue("Remark"))
	//Moidefied by zc0064 2020-4-8  �������Ƶȴ����̨�������⴦�� begin
	var formData = new FormData();
    formData.append('FileStream', $('#FileName')[0].files[0]);
    document.getElementById("BSave").style.display = 'none'
	$.ajax({
                url : 'dhceq.process.appendfileaction.csp?&actiontype=UploadByFtpStream&RowID='+RowID+str,
                type : 'POST',
                cache : false,
                data : formData,
                processData : false,
                contentType : false,
                success:function(data,status){
	                var datajson=eval('(' + data + ')')
	                if(datajson.success!=true) 
                	{
	                	$.messager.alert("��ʾ", datajson.result);
	                	document.getElementById("BSave").style.display = ''
                    	$('#tDHCEQFileFind').datagrid('reload');
                	}
                	else
                	{
	                	$HUI.dialog('#UpLoadFile').close();
	                	$.messager.alert("��ʾ",datajson.result);
                    	$('#tDHCEQFileFind').datagrid('reload');
                    	document.getElementById("BSave").style.display = ''
	            	}
	                
                	}
            })
}

function setEnabled()
{
	var Status=getElementValue("Status");
	if (Status>0)
	{
		document.getElementById("BAdd").style.display = 'none'
		document.getElementById("BSave").style.display = 'none'
	}
	if (getElementValue("ReadOnly")!="")
	{
		document.getElementById("BAdd").style.display = 'none'
		document.getElementById("BSave").style.display = 'none'
	}
}


