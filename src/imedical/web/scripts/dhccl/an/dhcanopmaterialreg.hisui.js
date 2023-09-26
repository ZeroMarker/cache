
var EpisodeID=dhccl.getUrlParam("EpisodeID"),
    opaId=dhccl.getUrlParam("opaId");
var reg=/^[0-9]+.?[0-9]*$/; 
var logUserId=session['LOGON.USERID'];
$(function(){
	InitForm();
	if(EpisodeID!="")
	{
		loadDatas();
	}
});
function loadDatas()
{
	var patInfo=getPatInfo();
    var appList=patInfo.split("@");
    loadOperData(appList);
    LoadMaterialData(opaId);
}
//��ȡ���˻�����Ϣ
function getPatInfo(){
    var datas=$.m({
        ClassName:"web.DHCANOPMaterialList",
        MethodName:"GetPatBaseInfo",
        opaId:opaId,
        EpisodeID:EpisodeID,
        userId:session['LOGON.USERID'],
        type:"In"
    },false);
    return datas;
}

//���ز��˻�����Ϣ
function loadOperData(appList)
{
	//-----------���˻�����Ϣ
	var patBaseInfo=appList[0];
	var baseInfoList=patBaseInfo.split("^");
    $("#PatName").prop("innerText",baseInfoList[1]);
   // $("#RegNo").prop("innerText",baseInfoList[2]);
    var PatGender=baseInfoList[3]
    $("#PatGender").prop("innerText",baseInfoList[3]);
    $("#PatAge").prop("innerText",baseInfoList[4]);
    
    $("#PatLoc").prop("innerText",baseInfoList[5]);
    $("#AdmReason").prop("innerText",baseInfoList[8]);
    $("#patSeximg").prop("innerText","");
    if(PatGender=="��"){
			var imghtml="<img src='../images/man.png' alt='' style='margin-top:-5px;'/>"
			$("#patSeximg").append(imghtml)
		}else if(PatGender=="Ů"){
			var imghtml="<img src='../images/woman.png' alt='' style='margin-top:-5px;'/>";
			$("#patSeximg").append(imghtml)
		}
    
}
var lastselctrowindex="";
function LoadMaterialData(opaId)
{
	var materialobj=$("#MaterialData").datagrid({
        singleSelect: true,
        fitColumns:true,
        fit:true,
        iconCls:'icon-paper',
        bodyCls:'panel-body-gray',
        rownumbers: true,
        pagination: true,
        pageSize: 100,
        pageList: [100, 200, 500],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANOPMaterialList",
            QueryName:"FindMaterialList"
        },
        onBeforeLoad: function(param) {
	        param.opaId=opaId;
        },
        columns:[
            [
               {field: "RowId", title: "RowId", width: 60, sortable: true },
               {field: "tcssdr", title: "tcssdr", hidden: true },
               {field: "cssdpack", title: "���ϰ�", width: 160, sortable: true },
               {field: "tnumber", title: "����", width: 60, sortable: true }
            ]
        ],
        onClickRow: function(rowIndex, rowData) {
	        if(lastselctrowindex===rowIndex)
	        {
		        $('#MaterialData').datagrid('clearSelections');
		        $("#MaterialPack").combobox('setValue','')
				$("#Number").val("");
				lastselctrowindex="";
	        }
	        else
	        {
		     var  cssdr=rowData["tcssdr"];
		     var  number=rowData["tnumber"];
	        $("#MaterialPack").combobox('setValue',cssdr)
			$("#Number").val(number);
			lastselctrowindex=rowIndex;
	        }
 			
       }
        
       
    });

}

function AddData()
	{
		 if($("#Number").val()=="")
 {
	 $.messager.alert("��ʾ","��������Ϊ��","error");
        				return;
 }

						 if(!reg.test($("#MaterialPack").combobox('getValue')))
    					{
	    				$.messager.alert("��ʾ","��������Ҫ��������ѡ��","error");
        				return;
   						 }
							var data=$.m({
								ClassName:"web.DHCANOPMaterialList",
								MethodName:"InsertMaterial",
								opaId:opaId,
								cssdpack:$("#MaterialPack").combobox('getValue'),
								number:$("#Number").val(),
								userId:logUserId
							},function(success){
								if(success==0)
								{
									 $("#MaterialPack").combobox('setValue','')
									 $("#Number").val("");
									$.messager.alert("��ʾ","��ӳɹ���","info");
									 $("#MaterialData").datagrid("reload");
								}else
								{
									$.messager.alert("��ʾ","���ʧ�ܣ�"+success,"error");
								}
							})
						
					
				}
function UpdateData()
{
		
 var row=$("#MaterialData").datagrid("getSelected");
 var cssdid=row.RowId;
 if($("#Number").val()=="")
 {
	 $.messager.alert("��ʾ","��������Ϊ��","error");
        				return;
 }
					if(!reg.test($("#MaterialPack").combobox('getValue')))
    					{
	    				$.messager.alert("��ʾ","������ȫ����Ҫ��������ѡ��","error");
        				return;
   						 }
					var data=$.m({
							ClassName:"web.DHCANOPMaterialList",
							MethodName:"UpdateMaterial",
							rowId:cssdid,
							cssdpack:$("#MaterialPack").combobox('getValue'),
							number:$("#Number").val(),
							userId:logUserId
						},function(success){
							if(success==0)
							{
								$("#MaterialPack").combobox('setValue','')
								$("#Number").val("");
								$("#MaterialData").datagrid("reload");
							}else{
								$.messager.alert("��ʾ","����ʧ�ܣ�"+success,"error");
						}
						
					})
}
function deleteRow()
{
	var row=$("#MaterialData").datagrid("getSelected");
	var rowid=row.RowId;
	    var datas=$.m({
        ClassName:"web.DHCANOPMaterialList",
        MethodName:"DeleteMaterial",
        rowId:rowid
    },false);
    if(datas==0)
    {
	    $("#MaterialPack").combobox('setValue','')
		$("#Number").val("");
	    $.messager.alert("��ʾ", "ɾ���ɹ���", 'info');
	    $("#MaterialData").datagrid("reload");
    }
}


	
//�رմ���
function closeWindow(){
    window.close();
}

function InitForm()
{
		var cssd=$HUI.combobox("#MaterialPack",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCSSDPack&ResultSetType=array",
        valueField:"CssdId",
        textField:"CssdPack",
        editable:false,
        mode:"remote"
    });
    $("#btnAdd").linkbutton({
        onClick:AddData
    });

    $("#btnEdit").linkbutton({
        onClick: UpdateData
    });

    $("#btnDel").linkbutton({
        onClick: deleteRow
    });

}
