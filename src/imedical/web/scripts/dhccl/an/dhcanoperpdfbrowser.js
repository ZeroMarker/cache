var EpisodeID,
    PatientID,
    mradm;
$(function(){
    getEpisodeID();
    initOperationGrid();
    initDelegates();
})

//��ȡѡ����������˾����
function getEpisodeID(){
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
    if(EpisodeID=="")
    {
	    EpisodeID=getUrlParam("EpisodeID");
    }
}
//��ʼ������������Ϣ�б�
function initOperationGrid(){
    var selectRowIndex=-1,preRowIndex=-1;
    var operationBox=$HUI.datagrid("#OperationBox",{
        fit: true,
        //fitColumns:true,
        singleSelect: true,
        nowrap: true,
        rownumbers: true,
        pagination: true,
        pageSize: 200,
        pageList: [50, 100, 200],
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANOPPdfBrowser",
            QueryName:"GetPatInfo",
            EpisodeID:EpisodeID
        },
        columns:[
            [
                { field: "oproom", title: "����", width: 100, sortable: true },
                { field: "loc", title: "����", width: 120 },
                { field: "regno", title: "�ǼǺ�", width: 100 },
                { field: "patname", title: "����", width:90 },
                { field: "sex", title: "�Ա�", width: 50 },
                { field: "age", title: "����", width: 50 },
                { field: "opname", title: "��������", width: 200 },
                { field: "anmethod", title: "������", width: 140 },
                { field: "opdoc", title: "����ҽ��", width: 100 },
                { field: "andoc", title: "����ҽ��", width: 100 },
                { field: "status", title: "״̬", width: 50 },
                { field: "jzstat", title: "����", width: 50 },
                { field: "opaId", title: "opaId", width: 50 },
                { field: "adm", title: "�����", width: 60 },
                { field: "medCareNo", title: "������", width: 80 },
                { field: "opdatestr", title: "����ʱ��", width: 200 },
                { field: "PatientID", title: "PatientID", width: 100 ,hidden:true},
                { field: "PAADMMainMRADMDR", title: "PAADMMainMRADMDR", width: 100 ,hidden:true},
                { field: "AnaesthesiaID", title: "AnaesthesiaID", width: 100 ,hidden:true}
            ]
        ],
        onSelect:function(rowIndex,rowData){
            selectRowIndex=rowIndex;
            if(selectRowIndex!=preRowIndex)
            {   
                $("#MedCareNo").val(rowData.medCareNo);
                $("#RegNo").val(rowData.regno);
                $("#EpisodeID").val(rowData.adm);
                $("#opaId").val(rowData.opaId);
                var adm = rowData.adm;
                var PatientID=rowData.PatientID;
		        var mradm=rowData.PAADMMainMRADMDR;
		        var AnaesthesiaID = rowData.AnaesthesiaID;
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
				        if (frm.AnaesthesiaID)
				            frm.AnaesthesiaID.value = AnaesthesiaID;
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
						if (frm.AnaesthesiaID)
						    frm.AnaesthesiaID.value = AnaesthesiaID;
				    }
				}
                preRowIndex=selectRowIndex;
            }else{
                $("#patientForm").form('clear');
                selectRowIndex=-1;
                preRowIndex=-1;
                operationBox.unselectRow(rowIndex);
            }
        }
    })
}

//��ʼ���¼���Ϣ
function initDelegates(){
    $("#btnView").click(function(){
            var selectRow=$("#OperationBox").datagrid('getSelected');
            if(selectRow)
            {
                var FTPType=$("#FTPType").combobox('getValue');
                if(FTPType=="")
                {
                    $.messager.alert("��ʾ","��ѡ��鿴�ļ�����","info");
                    return;
                }
                var opaId=selectRow.opaId;
                var EpisodeID = selectRow.adm;
                var existsFlag=$.m({
                    ClassName:"web.DHCANOPPdfBrowser",
                    MethodName:"CheckPDFIfExist",
                    FTPType:FTPType,
                    EpisodeID:EpisodeID,
                    opaId:opaId
                },false);
    
                if(existsFlag==1)
                {
                    var PDFUrl=$.m({
                        ClassName:"web.DHCANOPPdfBrowser",
                        MethodName:"GetPDFUrl",
                        FTPType:FTPType,
                        EpisodeID:EpisodeID,
                        opaId:opaId
                    },false);
                    if(PDFUrl=="")
                    {
                        $.messager.alert("��ʾ","FTP��������Ϣδά����","info");
                        return;
                    }
                    else
                    {
                        window.open(PDFUrl);
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
                $.messager.alert("��ʾ","��ѡ��һ��������","info");
                return;
            }
    });
}
function getUrlParam(name)
{
	var reg=new RegExp("(^|&)"+name+"=([^&]*)(&|$)");
	var r=window.location.search.substr(1).match(reg);
	if(r!=null)
	return unescape(r[2]);
	return "";
}