var url="dhcpha.clinical.action.csp";
var PcntItmID="";var EpisodeID="";
$(function(){
	EpisodeID=getParam("EpisodeID");
	PcntItmID=getParam("PcntItmID");
	$('input[name=type]').bind('click',function(){
		
		///����ҽ����Ϣ
		$('#drggrid').datagrid({url:url+'?action=GetPatOrdItmDetail',	
			queryParams:{
				EpisodeID:EpisodeID,
				Type:this.value}
		})
	})
	
	/// ������
	$('input[name=res]').bind('click',function(){
		SetElementEnable(this.value);
	})
	
	InitPageDataGrid();
	InitPagePatAdmInfo();
	LoadPCommentRes();
	
	$('a:contains("�������")').bind('click',SaveCommentRet);
	$('a:contains("���µ���")').bind('click',reSaveCommentRet);
	$('a:contains("��һ��")').bind('click',LastSample);
	$('a:contains("��һ��")').bind('click',NextSample);
	$('a:contains("��Ӳ�������������")').bind('click',creUnCommentReason);
	
	$('#resdesc').bind("focus",function(){
		if(this.value=="�������������..."){
			$('#resdesc').val("");
		}
	});
	
	$('#resdesc').bind("blur",function(){
		if(this.value==""){
			$('#resdesc').val("�������������...");
		}
	});
})

///��ʼ��ҳ��dagagrid
function InitPageDataGrid()
{
	//����columns
	var columns=[[
	    {field:'basflag',title:'��',width:40,align:'center',formatter:SetCellColor},
	    {field:'antflag',title:'��',width:40,align:'center',formatter:SetCellColor},
	    {field:'arcitmdesc',title:'ҩƷ����',width:180,align:'left'},
	    {field:'form',title:'����',width:80,align:'left'},
	    {field:'spec',title:'���',width:80,align:'left'},
	    {field:'instru',title:'��ҩ;��',width:80,align:'left'},
	    {field:'dosage',title:'����',width:60,align:'left'},
	    {field:'uomdesc',title:'��ҩ��λ',width:60,align:'left'},
	    {field:'qty',title:'��������',width:60,align:'left'},
	    {field:'freq',title:'Ƶ��',width:40,align:'left'},
	    {field:'doctor',title:'ҽ��',width:60,align:'left'},
	    {field:'spamt',title:'ҽ������[Ԫ]',width:80,align:'left'},
	    {field:'ordtime',title:'ҽ��ʱ��',width:130,align:'left'},
	    {field:'purpose',title:'��ҩĿ��',width:90,align:'left',formatter:SetCellColor},
	    {field:'prescno',title:'������',width:90,align:'left'},
	    {field:'pyuser',title:'����ҩʦ',width:70,align:'left'},
	    {field:'fyuser',title:'��ҩҩʦ',width:70,align:'left'}
	]];
	
	//����datagrid
	$('#drggrid').datagrid({
		title:'ҽ���б�',    
		url:'',
		border:false,
		rownumbers:true,
		columns:columns,
	    singleSelect:true,
	    pageSize:8,
		pageList:[8,16],
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
	    onDblClickRow: rowhandleClick
	});
	
	InitdatagridRow();
}

//��ʼ���б�ʹ��
function InitdatagridRow()
{
	for(var k=0;k<10;k++)
	{
		$('#drggrid').datagrid('insertRow',{
			index: 0, // ������
			row: {
				orditm:'', phcdf:'', incidesc:'', genenic:''
			}
		});
	}
}

///dagagrid ˫���¼�
function rowhandleClick()
{
	
}

///����ҳ�没�˾�����Ϣ
function InitPagePatAdmInfo()
{
 	//��������
	$.post(url,{ action:"GetPatEssInfo", "EpisodeID":EpisodeID},function(data){
		var data=eval('('+data+')');
		$('.btn-ui-span input').each(function(){
			$(this).val(data[this.id]);
		})
		///����ҽ����Ϣ
		$('#drggrid').datagrid({
			url:url+'?action=GetPatOrdItmDetail',	
			queryParams:{
				EpisodeID:EpisodeID}
		})
	});
	SetElementEnable("Y");
}

/// ����������
function SaveCommentRet(){
	if(PcntItmID == ""){
		$.messager.alert("��ʾ:","��������ϸID����Ϊ�գ�");
		return false;
	}
	if(!$("input[type='radio'][name='res']:checked").length){
		$.messager.alert("��ʾ:","ҩ��������ʹ���Ƿ����������Ϊ�գ�");
		return false;
	}
	var resflag = $("input[type='radio'][name='res']:checked").val();  /// ҩ��������ʹ�����۽��
	
	if((resflag == "N")&($('#resdesc').val()=="�������������...")){
		$.messager.alert("��ʾ:","����д�������������");
		return false;
	}
	var resdesc = "";
	if(resflag == "N"){
		resdesc = $('#resdesc').val();					 /// ҩ��������ʹ�����۽������
	}
	var otherparam = PcntItmID;
	//��������
	$.post(url+'?action=SaveCommentRet',{"userid":LgUserID,"resflag":resflag,"resdesc":resdesc,"otherparam":otherparam},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode != "0"){
			$.messager.alert("��ʾ:","����ԭ��:"+resobj.ErrMsg);
			return false;
		}
		$.messager.alert("��ʾ:","�����ɹ�!");
	});
}

/// ���������������µ����� ʵ��Ϊ�����������
function reSaveCommentRet(){
	if(PcntItmID == ""){
		$.messager.alert("��ʾ:","��������ϸID����Ϊ�գ�");
		return false;
	}

	//��������
	$.post(url+'?action=reSaveCommentRet',{"PcntItmID":PcntItmID},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode != "0"){
			$.messager.alert("��ʾ:","����ԭ��:"+resobj.ErrMsg);
			return false;
		}
		$.messager.alert("��ʾ:","������������ɹ�!");
	});

	ClrUIComponent(); ///��ս������
	SetElementEnable("Y");
}

/// �����л�����һ����
function NextSample(){
	$.post(url+'?action=getCommentItm',{"PcntItmID":PcntItmID,"SortDir":"1"},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode != "0"){
			$.messager.alert("��ʾ:","��ȡ������ϸ����:"+resobj.ErrMsg);
			return false;
		}
		if(resobj.ErrCode == "0"){
			ClrUIComponent(); ///��ս������
			EpisodeID=resobj.EpisodeID;
			PcntItmID=resobj.PcntItmID;
			window.parent.refreshTabs(resobj.EpisodeID,"Out",resobj.PcntItmID,resobj.PatName);
			InitPagePatAdmInfo();
			LoadPCommentRes(); ///���ص������
		}
	});
}

/// �����л�����һ����
function LastSample(){
	$.post(url+'?action=getCommentItm',{"PcntItmID":PcntItmID,"SortDir":"-1"},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode != "0"){
			$.messager.alert("��ʾ:","��ȡ������ϸ����:"+resobj.ErrMsg);
			return false;
		}
		if(resobj.ErrCode == "0"){
			ClrUIComponent(); ///��ս������
			EpisodeID=resobj.EpisodeID;
			PcntItmID=resobj.PcntItmID;
			window.parent.refreshTabs(resobj.EpisodeID,"Out",resobj.PcntItmID,resobj.PatName);
			InitPagePatAdmInfo();
			LoadPCommentRes(); ///���ص������
		}
	});
}

/// ����ѡ�е�ԭ�����������
function setSelectedUnCmtRea(UnReasonDesc){
	$('#resdesc').val(UnReasonDesc);
}

/// ����������ԭ�򴰿�
function creUnCommentReason(){
	
	if($('#unrwin').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="unrwin"></div>');
	$('#unrwin').append('<div id="unrcmtdg"></div>');
	
	$('#unrwin').window({
		title:'���ҵ�����',
		collapsible:true,
		border:true,
		closed:"true",
		width:1100,
		height:450
	});
        
	// ����columns
	var columns=[[
		{field:"id",title:'id',width:120,hidden:true},
		{field:"text",title:'����',width:980},
		{field:"_parentId",title:'_parentId',width:70,hidden:true}
	]];

	$('#unrcmtdg').treegrid({    
	    url: url+'?action=jsonQueryUnCmtReason',  
	    idField:'id', 
	    treeField:'text',
	    rownumbers:true,
	    fit:true,
	    queryParams:{WayCode:"P"},
	    columns:columns,
	    onDblClickRow:function(rowData){
		    var UnReasonDesc=rowData.text;
		    setSelectedUnCmtRea(UnReasonDesc)
			$('#unrwin').window('close');
	    }   
	});

	$('#unrwin').window('open');
}

/// ����ָ��Ԫ�صĿ���״̬
function SetElementEnable(EnableFlag){
	if(EnableFlag == "N"){
		$("a:contains('��Ӳ�������������')").attr("disabled",false);
		$("#resdesc").attr("disabled",false);
	}else{
		$("a:contains('��Ӳ�������������')").attr("disabled",true);
		$("#resdesc").attr("disabled",true);
	}
}

/// ���ص������
function LoadPCommentRes(){
	$.post(url+'?action=LoadPCommentRes',{"PcntItmID":PcntItmID},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode != "0"){
			$.messager.alert("��ʾ:","��ȡ���������ϸ����:"+resobj.ErrMsg);
			return false;
		}
		if(resobj.ErrCode == "0"){
			if(resobj.PcntCntRes == "Y"){
				$("input[type='radio'][name='res'][value='Y']").attr("checked",true); ///ȡ����ѡ��
			}
			if(resobj.PcntCntRes == "N"){
				SetElementEnable("N");
				$("input[type='radio'][name='res'][value='N']").attr("checked",true); ///ȡ����ѡ��
				$("#resdesc").val(resobj.PcntResDesc);
			}
		}
	});
}

/// ��ս���Ԫ��
function ClrUIComponent(){
	$("input[type='radio'][name='res']:checked").attr("checked",false); ///ȡ����ѡ��
	$("#resdesc").val("�������������...");
}

/// ��������ɫ
function SetCellColor(value,rowData,rowIndex){
	return '<span style="color:red;font-weight:bold;">'+value+'</span>';
}