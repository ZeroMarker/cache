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

//获取选择的病人就诊号
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
//初始化病人信息列表
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
			{ field: "tStartDateTime", title: "开始日期", width: 100, sortable: true},
            { field: "tEndDateTime", title: "转归日期", width: 100, sortable: true },
            { field: "tBedCode", title: "床位", width: 80, sortable: true },
            { field: "tWardDesc", title: "病区", width: 150, sortable: true },
			{ field: "tPatName", title: "病人姓名", width: 80, sortable: true },
            { field: "tRegNo", title: "登记号", width: 100, sortable: true },
            { field: "tEpisodeID", title: "就诊号", width: 80, sortable: true },
            { field: "tMedCareNo", title: "病案号", width: 80, sortable: true },
			{ field: "tStatus", title: "病人状态", width: 80, 
				styler: function(value,row,index){
				if (value=="安排"){
		        return 'background-color:#47CE27;color:#ffffff';}
		        if (value=="监护"){
			    return 'background-color:#F17AE9;color:#ffffff';}
			    if (value=="停止"){
				return 'background-color:#00CAF3;color:#ffffff';} // palegreen  magenta lightblue
				}
			},
            { field: "tDiagDesc", title: "诊断", width: 150, sortable: true },
            { field: "sex", title: "性别", width: 60, sortable: true },
            { field: "age", title: "年龄", width: 60, sortable: true },
			{ field: "tPatHeight", title: "身高", width: 60, sortable: true },
			{ field: "tPatWeight", title: "体重", width: 60, sortable: true },
			{ field: "icuaId", title: "icuaId", width: 60, sortable: true },
            { field: "icuBedId", title: "床位ID", width: 60, sortable: true, hidden:true },
            { field: "curWardId", title: "病区ID", width: 60, sortable: true, hidden:true }
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
//初始化事件信息
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
                        $.messager.alert("提示","FTP服务器信息未维护！","info");
                        return;
                    }
                    else
                    {
                        var nwin='width='+1060+',height='+660+ ',top='+30+',left='+30+',toolbar=no, menubar=no, scrollbars=yes, resizable=no,location=no, status=no';
 			window.open(PDFUrl,'_blank',nwin);
                        //window.open(PDFUrl); //不兼容医为浏览器49
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
                $.messager.alert("提示","请选择一行记录！","info");
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
