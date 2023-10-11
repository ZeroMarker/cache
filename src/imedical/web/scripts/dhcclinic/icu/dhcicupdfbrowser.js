var EpisodeID,
    PatientID,
    mradm;
$(function(){
    getEpisodeID();
    initOperationGrid();
    initDelegates();
    var DefaultDate = new Date().format("dd/MM/yyyy");
	$("#dateFrm").datebox("setValue",DefaultDate)
})

//��ȡѡ��Ĳ��˾����
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
//��ʼ��������Ϣ�б�
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
            ClassName:"web.DHCICUPdfBrowser",
            QueryName:"GetPatInfo",
            EpisodeID:EpisodeID
            //EpisodeID:361
        },
        columns:[[
			{ field: "tStartDateTime", title: "��ʼ����", width: 100, sortable: true},
            { field: "tEndDateTime", title: "ת������", width: 100, sortable: true },
            { field: "tBedCode", title: "��λ", width: 80, sortable: true },
            { field: "tWardDesc", title: "����", width: 150, sortable: true },
			{ field: "tPatName", title: "��������", width: 80, sortable: true },
            { field: "tRegNo", title: "�ǼǺ�", width: 100, sortable: true },
            { field: "tEpisodeID", title: "�����", width: 80, sortable: true },
            { field: "tMedCareNo", title: "������", width: 80, sortable: true },
			{ field: "tStatus", title: "����״̬", width: 80, 
				styler: function(value,row,index){
				if (value=="����"){
		        return 'background-color:#47CE27;color:#ffffff';}
		        if (value=="�໤"){
			    return 'background-color:#F17AE9;color:#ffffff';}
			    if (value=="ֹͣ"){
				return 'background-color:#00CAF3;color:#ffffff';} // palegreen  magenta lightblue
				}
			},
            { field: "tDiagDesc", title: "���", width: 150, sortable: true },
            { field: "sex", title: "�Ա�", width: 60, sortable: true },
            { field: "age", title: "����", width: 60, sortable: true },
			{ field: "tPatHeight", title: "���", width: 60, sortable: true },
			{ field: "tPatWeight", title: "����", width: 60, sortable: true },
			{ field: "icuaId", title: "icuaId", width: 60, sortable: true },
            { field: "icuBedId", title: "��λID", width: 60, sortable: true, hidden:true },
            { field: "curWardId", title: "����ID", width: 60, sortable: true, hidden:true }
			]],
        onSelect:function(rowIndex,rowData){
            selectRowIndex=rowIndex;
            if(selectRowIndex!=preRowIndex)
            {
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
                var CheckDate=$("#dateFrm").datebox("getValue");
                var icuaId=selectRow.icuaId;
                var EpisodeID = selectRow.tEpisodeID;
                var existsFlag=$.m({
                    ClassName:"web.DHCICUPdfBrowser",
                    MethodName:"CheckPDFIfExist",
                    EpisodeID:EpisodeID,
                    icuaId:icuaId,
                    date:CheckDate
                },false);
                if(existsFlag==1)
                {
                    var PDFUrl=$.m({
                        ClassName:"web.DHCICUPdfBrowser",
                        MethodName:"GetPDFUrl",
                        EpisodeID:EpisodeID,
                        icuaId:icuaId,
                        date:CheckDate
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
                $.messager.alert("��ʾ","��ѡ��һ�м�¼��","info");
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
