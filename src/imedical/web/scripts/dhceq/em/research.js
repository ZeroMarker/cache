
var editFlag="undefined";
var Selectindex="";	//modified by zy ZY0223 2020-04-17
var Columns=getCurColumnsInfo('EM.G.Research','','','')

$(function(){
	initDocument();
	$(function(){$("#Loading").fadeOut("fast");});
});

//modify by wl 2020-1-21  ����BussType,RFunProFlag
function initDocument()
{
	initUserInfo();
    initMessage("BuyRequest"); //��ȡ����ҵ����Ϣ
    //initLookUp();
	defindTitleStyle(); 
    //initButton();
    //initButtonWidth();
	$HUI.datagrid("#tDHCEQResearch",{   
	    url:$URL, 
	    queryParams:{
	        ClassName:"web.DHCEQ.EM.BUSResearch",
	        QueryName:"ResearchList",
	        BussType:getElementValue("BussType"), 		        
	        SourceType:getElementValue("SourceType"),
	        SourceID:getElementValue("SourceID"),
	        RFunProFlag:getElementValue("RFunProFlag")
			},
			fit:true,
			//border:false,	//modified zy ZY0215 2020-04-01
			fitColumns : true,    //add by lmm 2020-06-04
			rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
			singleSelect:true,
			toolbar:[{
				iconCls:'icon-add',
				text:'����',
				id:"add",
				handler:function(){insertRow();}
			},
			{
				iconCls:'icon-save',
				text:'����',
				id:"save",
				handler:function(){SaveData();}
			},
			{
                iconCls: 'icon-cancel',
				text:'ɾ��',
				id:"delete",
				handler:function(){DeleteData();}
			}],
			columns:Columns,
			pageSize:20,  // ÿҳ��ʾ�ļ�¼����
			pageList:[20],   // ��������ÿҳ��¼�������б�
	        singleSelect:true,
			loadMsg: '���ڼ�����Ϣ...',
			pagination:true,
		    onClickRow: function (rowIndex, rowData) {//˫��ѡ���б༭
		    	if (editFlag!="undefined")
		    	{
	                $('#tDHCEQResearch').datagrid('endEdit', editFlag);
	                editFlag="undefined"
	            }
	            else
	            {
		            $('#tDHCEQResearch').datagrid('beginEdit', rowIndex);
		            editFlag =rowIndex;
		        }
	        },
			onSelect:function(index,row){ 
				//modified by zy ZY0223 2020-04-17
				if (Selectindex!=index)
				{
					Selectindex=index
				}
				else
				{
					Selectindex=""
				}
			}
	});
	if (getElementValue("ReadOnly")==1)
	{
		$("#add").linkbutton("disable");
		$("#save").linkbutton("disable");
		$("#delete").linkbutton("disable");
	}
	if(getElementValue("RFunProFlag")=="1")
	{//RUsedFlag,RInvalidFlag RUserDR_UName
		$("#tDHCEQResearch").datagrid('hideColumn','RTypeDesc');
		$("#tDHCEQResearch").datagrid('hideColumn','RLevel');
		$("#tDHCEQResearch").datagrid('hideColumn','RUsedFlag');
		$("#tDHCEQResearch").datagrid('hideColumn','RInvalidFlag');
		$("#tDHCEQResearch").datagrid('hideColumn','RUserDR_UName');
		$("#tDHCEQResearch").datagrid('hideColumn','RParticipant');
		$("#tDHCEQResearch").datagrid('hideColumn','RBeginDate');
		$("#tDHCEQResearch").datagrid('hideColumn','REndDate');
	}
	else
	{
		//RDevelopStatusDesc
		$("#tDHCEQResearch").datagrid('hideColumn','RDevelopStatusDesc');
		//add by zy ZY0224 2020-04-26
		$("#tDHCEQResearch").datagrid('hideColumn','RUsedFlag');
	}
	
}

// ��������
//modify by wl 2020-1-21 �޸��ֶ����� ����BussType
function insertRow()
{
	if(editFlag>="0"){
		$("#tDHCEQResearch").datagrid('endEdit', editFlag);//�����༭������֮ǰ�༭����
	}
    var rows = $("#tDHCEQResearch").datagrid('getRows');
    var lastIndex=rows.length-1
    var newIndex=rows.length
    var RDesc = (typeof rows[lastIndex].RDesc == 'undefined') ? "" : rows[lastIndex].RDesc;
    var RLevel = (typeof rows[lastIndex].RLevel == 'undefined') ? "" : rows[lastIndex].RLevel;
    
    if ((RDesc=="")&&(RLevel==""))
    {
	    messageShow('alert','error','������ʾ','��'+newIndex+'������Ϊ��!������д����.');
	}
	else
	{
		$("#tDHCEQResearch").datagrid('insertRow', {index:newIndex,row:{}});
		editFlag=0;
	}
}
// ����༭��
//modify by wl 2020-1-21 �޸��ֶ����� ����BussType
function SaveData()
{
	if(editFlag>="0"){
		$('#tDHCEQResearch').datagrid('endEdit', editFlag);
	}
	var rows = $('#tDHCEQResearch').datagrid('getRows');
	if(rows.length<=0){
		jQuery.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList=""
	for (var i = 0; i < rows.length; i++) 
	{
		//add by zy ZY0224 2020-04-26
		var RFunProFlag=getElementValue("RFunProFlag")
		rows[i].RBussType=getElementValue("BussType");
		rows[i].RSourceType=getElementValue("SourceType")
		rows[i].RSourceID=getElementValue("SourceID")
		rows[i].RFunProFlag=RFunProFlag
		//var RFunProFlag=(typeof rows[i].RFunProFlag == 'undefined') ? "" : rows[i].RFunProFlag
		var RDesc=(typeof rows[i].RDesc == 'undefined') ? "" : rows[i].RDesc
		var RTypeDesc=(typeof rows[i].RTypeDesc == 'undefined') ? "" : rows[i].RTypeDesc
		var RDevelopStatus=(typeof rows[i].RDevelopStatus == 'undefined') ? "" : rows[i].RDevelopStatus
		
		var oneRow=rows[i]

		if(RFunProFlag=="1")
		{ 
			oneRow.RType="2";
			if (RDevelopStatus=="")
			{
				alertShow("��"+(i+1)+"���¿������ܱ�ǲ���Ϊ��!")
				return "-1"
			}
		}
		else
		{
			if (RTypeDesc=="")
			{
				alertShow("��"+(i+1)+"�й������ͱ�ǲ���Ϊ��!")
				return "-1"
			}
		}
		if (RDesc=="")
		{
			alertShow("��"+(i+1)+"�����Ʋ���Ϊ��!")
			return "-1"
		}
		var RowData=JSON.stringify(rows[i])
		if (dataList=="")
		{
			dataList=RowData
		}
		else
		{
			dataList=dataList+"&"+RowData
		}
	}
	if (dataList=="")
	{
		alertShow("��ϸ����Ϊ��!");
		//return;
	}
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSResearch","SaveData",dataList);
	jsonData=JSON.parse(jsonData)
	if (jsonData.SQLCODE==0)
	{
		var BussType=getElementValue("BussType")
		var SourceType=getElementValue("SourceType");
		var SourceID=getElementValue("SourceID"); 
		//add by zy ZY0224 2020-04-26
		var RFunProFlag=getElementValue("RFunProFlag")
		//modify by wl 2020-2-12
		var val="BussType="+BussType+"&SourceType="+SourceType+"&SourceID="+SourceID+"&RFunProFlag="+RFunProFlag;
		url="dhceq.em.research.csp?"+val
	    window.location.href= url;
	    //modified by ZY0222 2020-04-16
	    websys_showModal("options").mth(RFunProFlag);
	}
	else
    {
		alertShow("������Ϣ:"+jsonData.Data);
		return
    }
}

//modified by ZY0223 2020-04-17 ɾ���߼�bug
//******************************************/
// ɾ��ѡ����
// �޸��ˣ�JYP
// �޸�ʱ�䣺2016-9-1
// �޸�������������жϣ�ʹ�����ɾ������
//******************************************/
//modify by wl 2020-1-21 ����BussType
function DeleteData()
{
	var rows = $('#tDHCEQResearch').datagrid('getSelected'); //ѡ��Ҫɾ������
	if(rows.length<=0){
		alertShow("��ѡ��Ҫɾ������.");
		return;
	}
	var RowID=(typeof rows.RRowID == 'undefined') ? "" : rows.RRowID
	if (RowID=="")
	{
		if(Selectindex>="0"){
			$("#tDHCEQResearch").datagrid('endEdit', Selectindex);//�����༭������֮ǰ�༭����
			if(Selectindex>="1")$("#tDHCEQResearch").datagrid('deleteRow',Selectindex)
		}
		return
	}
	else
	{
		Selectindex=RowID
		messageShow("confirm","","",t[-9203],"",confirmFun,"")
	}
	
}
//modified by ZY0222 2020-04-16
function confirmFun()
{
	var jsonData=tkMakeServerCall("web.DHCEQ.EM.BUSResearch","SaveDataList",Selectindex,"1");
	//jsonData=JSON.parse(jsonData)
	//if (jsonData.SQLCODE==0)
	if (jsonData==0)
	{
		var BussType=getElementValue("BussType")
		var SourceType=getElementValue("SourceType");
		var SourceID=getElementValue("SourceID"); 
		//add by zy ZY0224 2020-04-26
		var RFunProFlag=getElementValue("RFunProFlag")
		//modified by ZY0219 2020-04-13
		var val="BussType="+BussType+"&SourceType="+SourceType+"&SourceID="+SourceID+"&RFunProFlag="+RFunProFlag;
		url="dhceq.em.research.csp?"+val
	    window.location.href= url;
	    //modified by ZY0222 2020-04-16
	    websys_showModal("options").mth(RFunProFlag);
	}
	else
    {
		alertShow("������Ϣ:"+jsonData);
		return
    }
}
//add by wl 2020-1-21 
function GetResearchType(index,data)
{ 
	var rowData = $('#tDHCEQResearch').datagrid('getSelected');
	rowData.RType=data.TRowID;
	var RTypeEdt = $("#tDHCEQResearch").datagrid('getEditor', {index:editFlag,field:'RTypeDesc'});
	$(RTypeEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQResearch').datagrid('endEdit',editFlag);
}
//add by wl 2020-1-21 
function EQUser(index,data)
{ 
	var rowData = $('#tDHCEQResearch').datagrid('getSelected');
	rowData.RUserDR=data.TRowID;
	var RUserEdt = $("#tDHCEQResearch").datagrid('getEditor', {index:editFlag,field:'RUserDR_UName'});
	$(RUserEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQResearch').datagrid('endEdit',editFlag);
}
//add by wl 2020-2-12 
//modify by wl 2020-03-10 ɾ��alert
function GetFuncProjType(index,data)
{ 
	var rowData = $('#tDHCEQResearch').datagrid('getSelected');
	rowData.RDevelopStatus=data.TRowID;
	var RDevelopStatusEdt = $("#tDHCEQResearch").datagrid('getEditor', {index:editFlag,field:'RDevelopStatusDesc'});
	$(RDevelopStatusEdt.target).combogrid("setValue",data.TName);
	$('#tDHCEQResearch').datagrid('endEdit',editFlag);
}
