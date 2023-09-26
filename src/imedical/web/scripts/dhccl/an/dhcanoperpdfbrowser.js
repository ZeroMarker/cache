var EpisodeID,
    PatientID,
    mradm;
$(function(){
    getEpisodeID();
    initOperationGrid();
    initDelegates();
})

//获取选择的手术病人就诊号
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
//初始化手术病人信息列表
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
                { field: "oproom", title: "术间", width: 100, sortable: true },
                { field: "loc", title: "科室", width: 120 },
                { field: "regno", title: "登记号", width: 100 },
                { field: "patname", title: "姓名", width:90 },
                { field: "sex", title: "性别", width: 50 },
                { field: "age", title: "年龄", width: 50 },
                { field: "opname", title: "手术名称", width: 200 },
                { field: "anmethod", title: "麻醉方法", width: 140 },
                { field: "opdoc", title: "手术医生", width: 100 },
                { field: "andoc", title: "麻醉医生", width: 100 },
                { field: "status", title: "状态", width: 50 },
                { field: "jzstat", title: "类型", width: 50 },
                { field: "opaId", title: "opaId", width: 50 },
                { field: "adm", title: "就诊号", width: 60 },
                { field: "medCareNo", title: "病案号", width: 80 },
                { field: "opdatestr", title: "手术时间", width: 200 },
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

//初始化事件信息
function initDelegates(){
    $("#btnView").click(function(){
            var selectRow=$("#OperationBox").datagrid('getSelected');
            if(selectRow)
            {
                var FTPType=$("#FTPType").combobox('getValue');
                if(FTPType=="")
                {
                    $.messager.alert("提示","请选择查看文件类型","info");
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
                        $.messager.alert("提示","FTP服务器信息未维护！","info");
                        return;
                    }
                    else
                    {
                        window.open(PDFUrl);
                    }
                }
                else if(existsFlag==0)
                {
                    $.messager.alert("提示","服务器不存在此文件,请重新选择","info");
                    return;
                }
                else
                {
                   $.messager.alert("提示",existsFlag,"info");
                    return;
                }
            }else{
                $.messager.alert("提示","请选择一行手术！","info");
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