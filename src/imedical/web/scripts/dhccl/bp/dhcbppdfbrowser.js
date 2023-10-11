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

//获取选择的透析病人就诊号
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
//初始化透析病人信息列表
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
                { field: "bpaDate", title: "透析日期", width: 100, sortable: true  },
                { field: "bpaBPCBPModeDesc", title: "透析方式", width: 120,
                  formatter: function(value, row, index){
	                  var result = "",
	                  title = row.bpaBPCBPModeDesc;
	                  result = "<a href='#' style='color:#339EFF' onclick='ShowOrderView(\"" + row.bpaId + "\",\"" + index + "\")'>" + title + "</a>";
                      return result;
                  }
                },
                { field: "bpaBPCBedDesc", title: "床位", width: 100},
                { field: "bpaDaySeqNo", title: "班次", width: 80},
                { field: "admDept", title: "科室", width: 120 },
                { field: "patName", title: "姓名", width: 100 },
                { field: "patSex", title: "性别", width: 80 },
                { field: "patAge", title: "年龄", width: 80 },
                { field: "bpPatType", title: "类型", width: 80 },
                { field: "bpaStatus", title: "状态", width: 80 },                
				{ field: "regNo", title: "登记号", width: 80 },
                { field: "EpisodeID", title: "就诊号", width: 80 },
                { field: "medCareNo", title: "病案号", width: 80 },
                { field: "bpaEquipDesc", title: "设备", width: 80 ,hidden:true},
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

//初始化事件信息
function initDelegates(){
    $("#btnView").click(function(){
            var selectRow=$("#BPArrangeBox").datagrid('getSelected');
            if(selectRow)
            {
                var FTPType=$("#FTPType").combobox('getValue');

                if(FTPType=="")
                {
                    $.messager.alert("提示","请选择查看文件类型","info");
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
                $.messager.alert("提示","请选择一行透析！","info");
                return;
            }
    });
}
function ShowOrderView(ord,rowIndex){
	lnk="dhc.orderview.csp?"+"&ordViewBizId="+ord+"&ordViewType=BP";
    //var nwin="dialogWidth:860px;dialogHeight:760px;status:no;menubar:no;resizable:no;"
	var iTop = (window.screen.height-30-760)/2; //获得窗口的垂直位置;
	var iLeft = (window.screen.width-10-1060)/2; //获得窗口的水平位置;
	var nwin='width='+1060+',height='+760+ ',top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,scrollbars=auto,resizeable=no,location=no,status=no';
	if ("undefined"!==typeof websys_getMWToken){
        lnk += "&MWToken="+websys_getMWToken()
      }
    window.open(lnk,'_blank',nwin);
	$("#BPArrangeBox").datagrid('reload');
}