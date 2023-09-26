var EpisodeID,
    PatientID,
    mradm;
$(function(){
	$HUI.combobox("#FTPType",{
		panelHeight:'auto'
	})
    getEpisodeID();
    //alert(EpisodeID);
    initOperationGrid();
    initDelegates();
})

//��ȡѡ���͸�����˾����
function getEpisodeID(){
	EpisodeID=dhccl.getUrlParam("EpisodeID");
    /*
    var isSet=false
    var win=top.frames['eprmenu'];
    if (win)
    {
        var frm = win.document.forms['fEPRMENU'];
        if (frm)
        {
            EpisodeID=frm.EpisodeID.value; 
            PatientID=frm.PatientID.value; 
            mradm=frm.mradm.value; 

            isSet=true
        }
    }
    if (isSet==false)
    {
        var frm =dhcsys_getmenuform();
        if (frm)
        { 				
            EpisodeID=frm.EpisodeID.value; 
            PatientID=frm.PatientID.value; 
            mradm=frm.mradm.value; 
        }
    }
    */
}
//��ʼ��͸��������Ϣ�б�
function initOperationGrid(){
    var selectRowIndex=-1,preRowIndex=-1;
    var bpArrangeBox=$HUI.datagrid("#BPArrangeBox",{
        url:$URL,
        fit: true,
        singleSelect: true,
        nowrap: true,
        rownumbers: true,
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 200],        
		//fitColumns:true,
		headerCls:"panel-header-gray",
        iconCls:'icon-paper',        
        queryParams:{
            ClassName:"web.DHCBPPdfBrowser",
            QueryName:"GetPatInfo",
            EpisodeID:EpisodeID
        },
        columns:[
            [                
                { field: "bpaDate", title: "͸������", width: 100, sortable: true  },
                { field: "bpaBPCBPModeDesc", title: "͸����ʽ", width: 120 },
                { field: "bpaBPCBedDesc", title: "��λ", width: 100},
                { field: "bpaDaySeqNo", title: "���", width: 80},
                { field: "admDept", title: "����", width: 120 },
                { field: "patName", title: "����", width: 100 },
                { field: "patSex", title: "�Ա�", width: 80 },
                { field: "patAge", title: "����", width: 80 },
                { field: "bpPatType", title: "����", width: 80 },
                { field: "bpaStatus", title: "״̬", width: 80 },                
				{ field: "regNo", title: "�ǼǺ�", width: 80 },
                { field: "EpisodeID", title: "�����", width: 80 },
                { field: "medCareNo", title: "������", width: 80 },
                { field: "bpaEquipDesc", title: "�豸", width: 80 ,hidden:true},
                { field: "bpaId", title: "bpaId", width: 50 ,hidden:true },
                { field: "PatientID", title: "PatientID", width: 100 ,hidden:true},
                { field: "PAADMMainMRADMDR", title: "PAADMMainMRADMDR", width: 100 ,hidden:true},

            ]
        ],
        onSelect:function(rowIndex,rowData){
            selectRowIndex=rowIndex;
            if(selectRowIndex!=preRowIndex)
            {   
                $("#MedCareNo").val(rowData.medCareNo);
                $("#RegNo").val(rowData.regNo);
                $("#EpisodeID").val(rowData.EpisodeID);
                $("#bpaId").val(rowData.bpaId);
                var adm = rowData.EpisodeID;
                var PatientID=rowData.PatientID;
		        var mradm=rowData.PAADMMainMRADMDR;
		        var bpaId=rowData.bpaId;
		        //var AnaesthesiaID = rowData.AnaesthesiaID;
                var win = top.frames['eprmenu'];
		        var isSet = false;
		        if (win)
		        {
			        var frm = win.document.forms['fEPRMENU'];
			        if (frm)
			        {
				        frm.PatientID.value = PatientID;
				        frm.EpisodeID.value =adm;
				        frm.mradm.value=mradm;
				        if (frm.bpaId)
				            frm.bpaId.value = bpaId;
					        isSet = true;
					}
				}
				if (isSet == false)
				{
					var frm = dhcsys_getmenuform();
					if (frm)
					{
						frm.PatientID.value = PatientID;
						frm.EpisodeID.value =adm;
						frm.mradm.value=mradm;
						if (frm.bpaId)
						    frm.bpaId.value = bpaId;
				    }
				}
                preRowIndex=selectRowIndex;
            }else{
                $("#patientForm").form('clear');
                selectRowIndex=-1;
                preRowIndex=-1;
                bpArrangeBox.unselectRow(rowIndex);
            }
        }
    })
}

//��ʼ���¼���Ϣ
function initDelegates(){
    $("#btnView").click(function(){
            var selectRow=$("#BPArrangeBox").datagrid('getSelected');
            if(selectRow)
            {
                var FTPType=$("#FTPType").combobox('getValue');

                if(FTPType=="")
                {
                    $.messager.alert("��ʾ","��ѡ��鿴�ļ�����","info");
                    return;
                }
                var bpaId=selectRow.bpaId;
                var adm = selectRow.EpisodeID;
                var existsFlag=$.m({
                    ClassName:"web.DHCBPPdfBrowser",
                    MethodName:"CheckPDFIfExist",
                    FTPType:FTPType,
                    EpisodeID:adm,
                    bpaId:bpaId
                },false);
    
                if(existsFlag==1)
                {
                    var PDFUrl=$.m({
                        ClassName:"web.DHCBPPdfBrowser",
                        MethodName:"GetPDFUrl",
                        FTPType:FTPType,
                        EpisodeID:adm,
                        bpaId:bpaId
                    },false);
                    if(PDFUrl=="")
                    {
                        $.messager.alert("��ʾ","FTP��������Ϣδά����","info");
                        return;
                    }
                    else
                    {
                        var nwin='width='+1060+',height='+660+ ',top='+30+',left='+30+',toolbar=no, menubar=no, scrollbars=yes, resizable=no,location=no, status=no';
 						window.open(PDFUrl,'_blank',nwin);
 						//window.open(PDFUrl); //������ҽΪ�����49
                    }
                }
                else if(existsFlag==0)
                {
                    $.messager.alert("��ʾ","�����������ڴ��ļ�,������ѡ��","info");
                    return;
                }
                else
                {
                   $.messager.alert("��ʾ",existsFlag,"info");
                    return;
                }
            }else{
                $.messager.alert("��ʾ","��ѡ��һ��͸����","info");
                return;
            }
    });
}