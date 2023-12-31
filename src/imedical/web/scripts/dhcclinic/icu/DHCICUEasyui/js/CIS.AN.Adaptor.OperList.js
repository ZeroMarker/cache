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
            ClassName:"CIS.AN.BL.AnaesthesiaStatistic",
            QueryName:"FindOperScheduleByAdm",
            EpisodeID:EpisodeID
        },
        columns:[
            [
                { field: "RoomDesc", title: "术间", width: 100, sortable: true },
                { field: "PatDeptDesc", title: "科室", width: 120 },
                { field: "RegNo", title: "登记号", width: 100 },
                { field: "PatName", title: "姓名", width:90 },
                { field: "PatGender", title: "性别", width: 50 },
                { field: "PatAge", title: "年龄", width: 50 },
				{ field: "OperDesc",
                  title: "手术名称", 
                  width: 200,
                  formatter: function(value, row, index){
	                  var result = "",
	                  title = row.OperDesc;
	                  result = "<a href='#' onclick='ShowOrderView(\"" + row.AppOrderItem + "\",\"" + index + "\")'>" + title + "</a>";
                      return result;
                  }
                },
                { field: "AnaMethodDesc", title: "麻醉方法", width: 140 },
                { field: "SurgeonDesc", title: "手术医生", width: 100 },
                { field: "AnesthesiologistDesc", title: "麻醉医生", width: 100 },
                { field: "StatusDesc", title: "状态", width: 50 },
                { field: "SourceTypeDesc", title: "类型", width: 50 },
                { field: "OPAID", title: "opaId", width: 50, hidden:true},
                { field: "RowId", title: "手术ID", width: 50 },
                { field: "EpisodeID", title: "就诊号", width: 60 },
                { field: "MedcareNo", title: "病案号", width: 80 },
                { field: "OperDate", title: "手术日期", width: 200 },
                { field: "PatientID", title: "PatientID", width: 100 ,hidden:true},
                { field: "MRAdmID", title: "PAADMMainMRADMDR", width: 100 ,hidden:true},
                { field: "ExtAnaestID", title: "AnaesthesiaID", width: 100 ,hidden:true}
            ]
        ],
        onSelect:function(rowIndex,rowData){
            selectRowIndex=rowIndex;
            if(selectRowIndex!=preRowIndex)
            {   
                $("#MedCareNo").val(rowData.MedcareNo);
                $("#RegNo").val(rowData.RegNo);
                $("#EpisodeID").val(rowData.EpisodeID);
                $("#opaId").val(rowData.OPAID);
                var adm = rowData.EpisodeID;
                var PatientID=rowData.PatientID;
		        var mradm=rowData.MRAdmID;
		        var AnaesthesiaID = rowData.ExtAnaestID;
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
                var opsId=selectRow.RowId;
                var iLeft = (window.screen.width-10-1060)/2; 
      			var iTop=(window.screen.availHeight-40-660)/2;
      			var FTPType=$('#FTPType').combobox('getValue');
                var nwin='width='+1060+',height='+660+ ',top='+iTop+',left='+iLeft+',resizable=no,menubar=no,scrollbars=yes';
                var url="";
                switch(FTPType){
	                case "PA":
	                	url = "CIS.AN.PACUMonRecordDetail.csp?moduleCode=PACURecord&readonly=true&opsId=";
                	break;
	                case "PR":
	                	url = "CIS.AN.PrevANVisit.csp?moduleCode=AN_ANS_004&readonly=true&opsId=";
                	break;
	                case "PO":
	                	url = "CIS.AN.PostANVisit.csp?moduleCode=AN_ANS_012&readonly=true&opsId=";
                	break;
	                case "A":
	                deafult:
                		url = "CIS.AN.AnaestRecordDetail.csp?moduleCode=AnaestRecord&readonly=true&opsId=";
                	break;
                }
                url = url+opsId;
                window.open(url,'_blank',nwin);
            }else{
                $.messager.alert("提示","请选择一行手术！","info");
                return;
            }
    });
}
function ShowOrderView(ord,rowIndex){
	lnk="dhc.orderview.csp?"+"&ord="+ord;
    //var nwin="dialogWidth:860px;dialogHeight:760px;status:no;menubar:no;resizable:no;"
	var iTop = (window.screen.height-30-760)/2; //获得窗口的垂直位置;
	var iLeft = (window.screen.width-10-1060)/2; //获得窗口的水平位置;
	var nwin='width='+1060+',height='+760+ ',top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,scrollbars=auto,resizeable=no,location=no,status=no';
	
    window.open(lnk,'_blank',nwin);
	$("#OperationBox").datagrid('reload');
}