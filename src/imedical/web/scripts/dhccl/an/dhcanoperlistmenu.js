/*
��ť���÷���
*/
//���������
function btnClearRoom_click(){
    var idStr="",
        tmp=[],
        colNum=[];
         var userId = session["LOGON.USERID"];
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows&&selectRows.length>0)
    {
        for(var i=0;i<selectRows.length;i++)
        {
            var rowData=selectRows[i];
            var rowIndex=$("#OperListBox").datagrid("getRowIndex",rowData);
            var status=rowData.status,
                opaId=rowData.opaId;
            status=status.replace(" ","");
            if ((status != '����') && (status != '����')) {
				$("#OperListBox").datagrid("uncheckRow",rowIndex);
				continue;
			}
            tmp[tmp.length] = rowIndex;
			colNum[colNum.length] = rowIndex + 1;
            if (idStr == ""){
                idStr = opaId;
            }else{
				idStr = idStr + "^" + opaId;
            }
        }
        if (idStr == "") {
			$.messager.alert("��ʾ","�빴ѡ״̬Ϊ������ŵ�����! ","warning");
			return;
		}else{
            var ifClear=$.messager.confirm("ȷ��","�Ƿ���յ�"+colNum+"����¼�������䣡",function(r){
                if(r){
                    var result=$.m({
                        ClassName:"web.DHCANOPArrange",
                        MethodName:"ClearOpRoom",
                         opaIdStr:idStr,
                        userId:userId
                    },false);
                    if(result!='0')
                    {
                        $.messager.alert("��ʾ",result,"info");
                        $("#OperListBox").datagrid("reload");
                    }else{
                        for (var j = 0; j <= tmp.length; j++) {
							var index = tmp[j];
							record = $("#OperListBox").datagrid("selectRow",index);
                            record.oproom="��";
                            record.opordno="δ��";
                            record.status="����";
							$("#OperListBox").datagrid("uncheckRow",index);
                            $("#OperListBox").datagrid("reload");
						}
                    }
                }else{
                    $("#OperListBox").datagrid("uncheckAll");
                }
            })
        }

    }else{
        $.messager.alert("��ʾ","��ѡ��Ҫ����������������","warning");
        return;
    }
}

//�������������ƣ��й�ҽ���ã����ܲ�ͨ��
function btnOpRoomLimit_click(btn){
    var result=$.m({
        ClassName:"web.DHCANOPArrange",
        MethodName:"UpDateOpDirAuditStatus"
    },false)
    if(result=="N"||result=="")
    {
        btn.text="�����俪��";
    }
    if(result=="Y")
    {
        btn.text="����������";
    }
}
//ȡ�����������ƣ��й�ҽ���ã����ܲ�ͨ��
function btnOpRoomOpen_click(){
    var result=$.m({
        ClassName:"web.DHCANOPArrangeHISUI",
        MethodName:"UPDataOpDirAuditStatus"
    },false);
    if(result!=0)
    {
        $.messager.alert("����",result,"error");
    }
}
function btnDirAudit_click(){
    var idStr="",
        tmp=[],
        colNum=[];
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows&&selectRows.length>0)
    {
        for(var i=0;i<selectRows.length;i++)
        {
            var rowData=selectRows[i];
            var rowIndex=$("#OperListBox").datagrid("getRowIndex",rowData);
            var status=rowData.status,
                opaId=rowData.opaId;
            status=status.replace(" ","");
            if (status!='') {
                $("#OperListBox").datagrid("uncheckRow",rowIndex);
                continue;
            }
            tmp[tmp.length] = rowIndex;
            colNum[colNum.length] = rowIndex + 1;
            if (idStr == ""){
                idStr = opaId;
            }else{
                idStr = idStr + "^" + opaId;
            }
        }
        if(idStr==""){
            $.messager.alert("��ʾ","�빴ѡ����״̬Ϊ�յ�������","warning");
            return;
        }else{
            var result=$.m({
                ClassName:"web.DHCANOPArrange",
                MethodName:"SetAnOpDirAudit",
                opaIdStr:idStr,
                groupId:logGroupId
            },false);
            if(result!=0){
                $.messager.alert("����",result,"error");
                return;
            }else{
                $.messager.alert("��ʾ","��"+colNum+"��������˳ɹ�","info");
                $("#OperListBox").datagrid("reload");
            }
        }
    }
}
//��������
function AppNewOper(appType,lnk,nwin,appCat){
    var opaId="";
    var lnk="";
	 var selectRows=$("#OperListBox").datagrid("getChecked");
	 if(selectRows.length==1)
    {
	  EpisodeID= selectRows[0].adm;
   	}
	    
    if(appCat=="In"){
	    //
        lnk="dhcanoperapplication.csp?"+"&opaId="+""+"&appType="+"ward"+"&EpisodeID="+EpisodeID;
        //var nwin="channelmode:yes;fullscreen:yes;status:no;menubar:no;";
       var iLeft = (window.screen.width-10-1280)/2; 
      	var iTop=(window.screen.availHeight-40-660)/2;
      	
        //var nwin='width='+1280+',height='+660+ ',top='+iTop+',left='+iLeft+',resizable=no,menubar=no,scrollbars=yes'
        //window.open(lnk,'_blank',nwin);
        var nwin="dialogWidth:1280px;dialogHeight:660px;status:no;menubar:no;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;";
     	var returnVal=window.showModalDialog(lnk,'_blank',nwin);
    	if(returnVal==1)
    	{
        	$("#OperListBox").datagrid("reload");
   		}
   		
    }
    else{
        if(EpisodeID&&EpisodeID!="")
        {
            if(appCat=="Inter"){
                lnk="dhcclinic.anop.appintervent.csp?";
            }
            if(appCat=="Out"){
                lnk="dhcclinic.anop.appClinics.csp?";
            }
             if(appCat=="Day"){
                lnk="dhcanopdayoperapply.csp?";
            }
            lnk+="&opaId="+opaId+"&appType="+appType+"&EpisodeID="+EpisodeID+"&random="+Math.random();
            var nwin="dialogWidth:860px;dialogHeight:760px;status:no;menubar:no;"
            window.open(lnk,'_blank',nwin)
            
        }else{
            $.messager.alert("��ʾ","��ѡ��һ������","warning");
            return;
        }
    }
}
//��������UI,�����Ǽ�
function HISUIManageOper(appType,lnk,nwin,cat)
{
	 var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId,
        status=selectRows[0].status;
        if((appType=='ward')&&(status!='����')&&(status!=''))
    {
        $.messager.alert("��ʾ","�ܲ���������״̬Ϊ: ����,δ���","error");
        return;
    }      
    if((appType=='op')&&(status!='����')&&(status!='����'))
    {	     
        $.messager.alert("��ʾ","�ܲ���������״̬Ϊ: ����,����","error");
        return;
    }
    if((appType=='anaes')&&(status!='����'))
    {
        $.messager.alert("��ʾ","�ܲ���������״̬Ϊ: ����","error");
        return;
    }
    if((appType=='RegOp')&&(status!='����')&&(status!='����')&&(status!='�ָ���')&&(status!='���'))
    {
        $.messager.alert("��ʾ","�ܲ���������״̬Ϊ: ����,����,�ָ���,���","error");
        return;
    }

	var EpisodeID = selectRows[0].adm;
	var userId = session["LOGON.USERID"];
	var lnk = "dhcanopopermanage.csp?opaId=" + opaId + "&userId=" + userId+"&EpisodeID="+EpisodeID+"&appType="+appType;
   	var iTop=(window.screen.availHeight-40-650)/2;
   	var iLeft = (window.screen.width-10-1120)/2; 
	var nwin="dialogWidth:1120px;dialogHeight:650px;status:no;menubar:no;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;";
    
     var returnVal=window.showModalDialog(lnk,'_blank',nwin);
    if(returnVal==1)
    {
        	$("#OperListBox").datagrid("reload");
   			 }
   			 
   	//var nwin='width='+1120+',height='+650+ ',top='+iTop+',left='+iLeft+',resizable=no,toolbar=no,menubar=no,scrollbars=yes'
	//window.open(lnk, "������Ϣ", nwin);
	
}

//�޸���������
function ManageOper(appType,lnk,nwin,cat){
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var EpisodeID=selectRows[0].adm;
    var opaId=selectRows[0].opaId;
	var status=selectRows[0].status;
    if((appType=='ward')&&(status!='����')&&(status!=''))
    {
        $.messager.alert("��ʾ","�ܲ���������״̬Ϊ: ����,δ���","error");
        return;
    }      
    if((appType=='op')&&(status!='����')&&(status!='����'))
    {	     
        $.messager.alert("��ʾ","�ܲ���������״̬Ϊ: ����,����","error");
        return;
    }
    if((appType=='anaes')&&(status!='����'))
    {
        $.messager.alert("��ʾ","�ܲ���������״̬Ϊ: ����","error");
        return;
    }
    if((appType=='RegOp')&&(status!='����')&&(status!='����')&&(status!='�ָ���')&&(status!='���'))
    {
         $.messager.alert("��ʾ","�ܲ���������״̬Ϊ: ����,����,�ָ���,���","error");
        return;
    }
    var lnk,nwin;
   // nwin="dialogWidth:1120px;dialogHeight:680px;status:no;menubar:no;"
	    var iTop=(window.screen.availHeight-40-660)/2;
        lnk="dhcanoperapplication.csp?";
        var iLeft = (window.screen.width-10-1280)/2; 
        //nwin='width='+1280+',height='+655+ ',top='+iTop+',left='+iLeft+',resizable=yes,menubar=no,scrollbars=yes'
    lnk+="&opaId="+opaId+"&appType="+appType+"&EpisodeID="+EpisodeID+"&random="+Math.random();
    //window.open(lnk,'_blank',nwin);
	
	var nwin="dialogWidth:1280px;dialogHeight:660px;status:no;menubar:no;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;";
     var returnVal=window.showModalDialog(lnk,'_blank',nwin);
    if(returnVal==1)
    {
      $("#OperListBox").datagrid("reload");
   	}
	
}
//�ܾ�����
function RefuseOper() {
    var idStr="",
        tmp=[],
        colNum=[];
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows&&selectRows.length>0)
    {
        for(var i=0;i<selectRows.length;i++)
        {
            var rowData=selectRows[i];
            var rowIndex=$("#OperListBox").datagrid("getRowIndex",rowData);
            var status=rowData.status,
                opaId=rowData.opaId;
            if ((status != '����') && (status != '����')) {
				$("#OperListBox").datagrid("uncheckRow",rowIndex);
				continue;
			}
            tmp[tmp.length] = rowIndex;
			colNum[colNum.length] = rowIndex + 1;
            if (idStr == ""){
                idStr = opaId;
            }else{
				idStr = idStr + "^" + opaId;
            }
        }
        if (idStr == "") {
			$.messager.alert("��ʾ","�빴ѡ״̬Ϊ������ŵ�����! ","warning");
			return;
		}else{
            $.messager.confirm("ȷ��","�Ƿ�ܾ���"+ colNum + "����¼������?",function(r){
                if(r)
                {
                    var ifInsertLog=$.m({
                        ClassName:"web.DHCANOPCancelOper",
                        MethodName:"IfInsertLog"
                    },false);
                    if(ifInsertLog=="Y")
                    {
                        var clclogId="",logRecordId="",preValue="",preAddNote="",postValue="",postAddNote=""
                        clclogId="RefuseOper";
                        preAddNote="Pre����״̬";
                        userId=session['LOGON.USERID'];
                        logRecordId=opaId;
                        postValue="D";
                        postAddNote="�ܾ��ɹ�";
                        var wshNetwork = new ActiveXObject("WScript.Network");  
                        var userd=wshNetwork.UserDomain;  
                        var userc=wshNetwork.ComputerName;  
                        var useru=wshNetwork.UserName;  
                        var ipconfig=userd+":"+userc+":"+useru;
                        var retCllog=$.m({
                            ClassName:"web.DHCANOPCancelOper",
                            MethodName:"InsertCLLog",
                            clclogcode:clclogId,
                            logRecordId:logRecordId,
                            preValue:preValue,
                            preAddNote:preAddNote,
                            postValue:postValue,
                            postAddNote:postAddNote,
                            userId:userId,
                            ipAdress:ipconfig
                        },false)
                    } 
                    var result=$.m({
                        ClassName:"web.DHCANOPArrange",
                        MethodName:"ChangeAnopStat",
                        status:"D",
                        opaIdStr:idStr
                    },false);
                    if(result!=0)
                    {
                        $.messager.alert("����",result,"error");
                        return;
                    }else{
                        for (var j = 0; j <= tmp.length; j++) {
							var index = tmp[j];
							record = $("#OperListBox").datagrid("selectRow",index);
                            record.oproom="��";
                            record.opordno="δ��";
                            record.status="�ܾ�";
							$("#OperListBox").datagrid("uncheckRow",index);
							$('#OperListBox').datagrid('reload');
						}
                    }
                }else{
                    $("#OperListBox").datagrid("uncheckAll");
                }
            })
        }
    }
}
//�����ܾ�
function CancelRefusedOper(){
    var idStr="",
        tmp=[],
        colNum=[];
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows&&selectRows.length>0)
    {
        for(var i=0;i<selectRows.length;i++)
        {
            var rowData=selectRows[i];
            var rowIndex=$("#OperListBox").datagrid("getRowIndex",rowData);
            var status=rowData.status,
                opaId=rowData.opaId;
            if ((status != '�ܾ�') ) {
				$("#OperListBox").datagrid("uncheckRow",rowIndex);
				continue;
			}
            tmp[tmp.length] = rowIndex;
			colNum[colNum.length] = rowIndex + 1;
            if (idStr == ""){
                idStr = opaId;
            }else{
				idStr = idStr + "^" + opaId;
            }
        }
        if (idStr == "") {
			$.messager.alert("��ʾ","�빴ѡ״̬Ϊ�ܾ�������! ","warning");
			return;
		}else{
            var result=$.m({
                ClassName:"web.DHCANOPArrange",
                MethodName:"ChangeAnopStat",
                status:"A",
                opaIdStr:idStr
            },false)
            if (result != 0) {
			   $.messager.alert("����",result,"error");
			} else {
			  $.messager.alert("��ʾ","�ɹ�ȡ������ֹͣ��","info");
				for (var j = 0; j <= tmp.length; j++) {
					var index = tmp[j];
					//record = $("#OperListBox").datagrid("selectRow",index);
                    //record.status="����";
					$("#OperListBox").datagrid("uncheckRow",index);
					$('#OperListBox').datagrid('reload');
				}	
			}
        }
    }
}
//�������

function AnAtOperation(type){
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var EpisodeID=selectRows[0].adm;
    var opaId=selectRows[0].opaId;
	var status=selectRows[0].status;
    if ((status!='����')&&(status!='����')&&(status!='����')&&(status!='�ָ���')&&(status!='���'))
    {
        $.messager.alert("��ʾ","�ܲ���������״̬Ϊ:"+"����"+","+"����"+","+"����"+","+"�ָ���"+","+"���","error");
        return;
    }
    var connectStr=$.m({
        ClassName:"web.DHCClinicCom",
        MethodName:"GetConnectStr",
    },false);
    var lnk="../service/dhcclinic/app/an/anmain.application?opaId="+opaId+"&userId="+logUserId+"&groupId="+logGroupId+"&locId="+logLocId+"&connString="+connectStr+"&documentType="+type;
    window.open(lnk);
}

function AnPdfDisplay(){
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var EpisodeID=selectRows[0].adm;
    var opaId=selectRows[0].opaId;
	var status=selectRows[0].status;
    if ((status!='����')&&(status!='���')&&(status!='�ָ���'))
    {
        $.messager.alert("��ʾ","�ܲ���������״̬Ϊ:"+"����"+","+"�ָ���"+","+"���","error");
        return;
    }
    var opStartDate=selectRows[0].opdatestr.split(" ")[0];
    var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCANPdfDisplay&opaId="+opaId+"&opStartDate="+opStartDate;
    window.open(lnk,"DHCANPdfDisplay","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=Yes,resizable=no,height=1024,width=1280,top=10,left=0");
}
function ANOPCount(){
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId;
	var status=selectRows[0].status;
    if((status!='����')&&(status!='����')&&(status!='����')&&(status!='�ָ���')&&(status!='���'))
    {
        $.messager.alert("��ʾ","�ܲ���������״̬Ϊ: ���ţ����У����ϣ��ָ��ң����","error");
        return;
    }
    var lnk="dhcanopcountrecord.csp?opaId="+opaId+"&userId="+logUserId;
    var iLeft = (window.screen.width-10-1150)/2; 
     var iTop=(window.screen.availHeight-60-650)/2;
    var nwin='width='+1150+',height='+650+ ',top='+iTop+',left='+iLeft+',resizable=yes,status=yes,menubar=no,scrollbars=yes'
    window.open(lnk,"�������",nwin);
}
function CancelOper(){
    var idStr="",
        tmp=[],
        colNum=[];
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows&&selectRows.length>0)
    {
        for(var i=0;i<selectRows.length;i++)
        {
            var rowData=selectRows[i];
            var rowIndex=$("#OperListBox").datagrid("getRowIndex",rowData);
            var status=rowData.status,
                opaId=rowData.opaId;
            status=static.replace(" ","");
            if ((status != '����') && (status != '')) {
				$("#OperListBox").datagrid("uncheckRow",rowIndex);
				continue;
			}
            tmp[tmp.length] = rowIndex;
			colNum[colNum.length] = rowIndex + 1;
            if (idStr == ""){
                idStr = opaId;
            }else{
				idStr = idStr + "^" + opaId;
            }
        }
        if (idStr == "") {
			$.messager.alert("��ʾ","�빴ѡ״̬Ϊ�ջ����������! ","warning");
			return;
		}else{
            var ifClear=$.messager.confirm("ȷ��","�Ƿ�����"+colNum+"��������",function(r){
                if(r){
                    //var lnk= "websys.default.csp?WEBSYS.TCOMPONENT=CancelOper&opaId="+idStr;
                    var lnk="canceloper.hisui.csp?"+"&opaId="+idStr;
                    var iLeft = (window.screen.width-10-700)/2; 
     				var iTop=(window.screen.availHeight-60-200)/2;
                    //var nwin="toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no"+"height="+200+",width=700,top="+iTop+",left="+iLeft;
                    //window.open(lnk,"CancelOper",nwin);
                    var nwin="dialogWidth:700px;dialogHeight:200px;status:no;menubar:no;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;";
     				var returnVal=window.showModalDialog(lnk,'_blank',nwin);
    				if(returnVal==1)
    				{
        				$("#OperListBox").datagrid("reload");
   			 			}

                	}else{
                    $("#OperListBox").datagrid("uncheckAll");
                	}
            })
        }

    }else{
        $.messager.alert("��ʾ","��ѡ��Ҫ������������","warning");
        return;
    }
}
function DHCCLMSAN(){
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var EpisodeID=selectRows[0].adm;
    var opaId=selectRows[0].opaId;
	var status=selectRows[0].status;
    var lnk= "dhcclinic.an.medicalSafety.csp?../scripts/dhcclinic/an/medicalSafety/gui.js";
    var nwin="toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,height=700,width=960,top=10,left=0"
    lnk+="&opaId="+opaId+"&EpisodeID="+EpisodeID;
    window.open(lnk,'_blank',nwin);
}
function OperTransfer(){
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var EpisodeID=selectRows[0].adm;
    var opaId=selectRows[0].opaId;
	var status=selectRows[0].status;
    if((status=='�ܾ�')||(status=='����'))
    {
        $.messager.alert("��ʾ","�ܾ�����״̬���������ɽ��л���ת�����룡","error");
        return;
    }
    var lnk="dhcoptransfer.app.hisui.csp?opaId="+opaId+"&EpisodeID="+EpisodeID;
    //var lnk = "dayoperpostacessui.csp?opaId=" + opaId + "&userId=" + userId+"&EpisodeID="+EpisodeID;
	var iLeft = (window.screen.width-10-760)/2;
	var iTop=(window.screen.availHeight-40-190)/2;
	var nwin='left='+iLeft+",top="+iTop+",height=190,width=760,toolbar=no,menubar=no,resizable=no,scrollbars=yes"
	window.open(lnk, "����ת�����뵥",nwin );
	/*
	var lnk="dhcanopertransferapp.view.csp?opaId="+opaId+"&EpisodeID="+EpisodeID;
	var iTop=(window.screen.availHeight - 40 - 760) / 2;  
    var iLeft=(window.screen.availWidth  - 10 - 1150) / 2; 
	var nwin="dialogWidth:1150px;dialogHeight:760px;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;status:no;menubar:no;scrollbars:no;"
	var returnVal=window.showModalDialog(lnk,'_blank',nwin)
	*/

}
function ManageAduitAccredit(){
    lnk = "dhcanaduitaccredit.csp?"
    var iLeft = (window.screen.width-10-1230)/2;
    var nwin= 'height=600'+',width=1230'+'toolbar=no'+',top='+10+',left='+iLeft+',menubar=no,resizable=no,scrollbars=yes'
	window.open(lnk, "��������Ȩ",nwin );
}
//
	///��������ԤԼ����ӡ
	///LYN ADD 20160414
	function PrintMZSSYYD(prnType,exportFlag)
	{
		if (prnType=="") return;
		var records=$("#OperListBox").datagrid("getChecked");
		count=records.length;
		if(records.length!=1) {
			$.messager.alert("��ʾ","�빴ѡһ����ӡ�ļ�¼","warning");
			return;}
		
		//var printInfo=_DHCANOPArrangeClinics.GetMZSSMZYYD(records[0].get("opaId")); //��ȡ��ӡ��Ϣ
		
		printInfo=$.m({
        	ClassName:"web.DHCANOPArrangeClinics",
        	MethodName:"GetMZSSMZYYD",
        	opaId:records[0].opaId
    		},false);
		if(printInfo=="") return ;
    		
		var name,fileName,path,operStat,printTitle,operNum;
		var xlsExcel,xlsBook,xlsSheet;
		var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
		var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
		path=GetFilePath();
		
		fileName=path+prnType+".xls";
		try{
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Open(fileName);
		}
		catch(e){
			alert(e.name+"^"+e.message+"^"+e.description+"^"+e.number)
			}
		xlsSheet = xlsBook.ActiveSheet;
		
		
		//var loc=window.status.split(':')[3].split(' ')[1];
		//alert(loc)
		//var hospital=window.status.split(':')[3].split(' ')[2]
		//var hospitalDesc="�׶�ҽ�ƴ�ѧ����"+hospital;
		///***************��ӡ��ͷ**************
		//var hospital=_DHCClinicCom.GetHospital();
		var hospital=$.m({
        	ClassName:"web.DHCClinicCom",
        	MethodName:"GetHospital"
    		},false);
		

		xlsSheet.cells(1,1)=hospital;
			var position=""
		position=printInfo.split('^')[14];
		//alert(position)
		xlsSheet.cells(1,8)=position;	//������λ
		var appointnum=""	//ԤԼ��
		appointnum=printInfo.split('^')[19]+"";
		xlsSheet.cells(2,8)=appointnum;	
		var appdept=""	//ԤԼ����
		appdept=printInfo.split('^')[13];
		xlsSheet.cells(2,1)="    "+appdept+"����ԤԼ��";
		var patname=""	//��������
		patname=printInfo.split('^')[0];
		xlsSheet.cells(3,2)=patname; 
		var patgender=""	//�Ա�
		patgender=printInfo.split('^')[1];
		xlsSheet.cells(3,4)=patgender;	
		//DZY^Ů^25��^^370***********641X^
		//13649500432^^^^^
		//ͷ��Ѫ�������Գ���^^ҽ��01^������^�ڷ�������^
		//��ǰ��^27/09/2017^27/09/2017 09:00^27/09/2017 ^����ģ��hkdhfkhfkdhfiehie^
		//^kkdkfdsfkd
		var patage=""	//����
		patage=printInfo.split('^')[2];
		xlsSheet.cells(3,6)=patage;	
		var patmed=""  //������
		patmed=printInfo.split('^')[3];
		xlsSheet.cells(3,8)=patmed;	
		var patidnum=""	//���֤��
		patidnum=printInfo.split('^')[4];
		xlsSheet.cells(4,2)=patidnum;
		var patworkplace=""	//������λ
		patworkplace=printInfo.split('^')[6];
		xlsSheet.cells(4,5)=patworkplace;
		var patphone=""		//�绰
		patphone=printInfo.split('^')[5];		
		xlsSheet.cells(5,2)="'"+patphone; 
		var pataddress=""
		pataddress=printInfo.split('^')[7];
		xlsSheet.cells(5,5)=pataddress; //��ͥסַ
		var patmedinfo=""
		patmedinfo=printInfo.split('^')[20];
		xlsSheet.cells(6,2)=patmedinfo;	//����ժҪ
		var patdiag=""
		patdiag=printInfo.split('^')[8];	//���
		xlsSheet.cells(7,2)=patdiag;
		var opname="" //��������
		opname=printInfo.split('^')[9];
		xlsSheet.cells(8,2)=opname;
		var opsurgeon=""
		opsurgeon=printInfo.split('^')[10];
		xlsSheet.cells(9,2)=opsurgeon; //����ҽ��
			 
		var oploc=""	//��������
		oploc=printInfo.split('^')[12];
		xlsSheet.cells(9,4)=oploc;
		var appointtime="" //ԤԼ����
		appointtime=printInfo.split('^')[16];
		xlsSheet.cells(9,7)=appointtime;
		var appdoc=""	//����ҽ��
		appdoc=printInfo.split('^')[11]
		xlsSheet.cells(10,2)=appdoc;	
		var apploc=""	//�������
		apploc=printInfo.split('^')[13];
		xlsSheet.cells(10,4)=apploc;
		var apptime=""	//����ʱ��
		apptime=printInfo.split('^')[15];
		xlsSheet.cells(10,7)=apptime;
		
		var patnotice=""	//������֪
		patnotice=printInfo.split('^')[18];
		xlsSheet.cells(12,1)=patnotice;
		var cometime=""	//��Ժʱ��
		cometime=printInfo.split('^')[17];
		xlsSheet.cells(12,7)=cometime;
		
		
		if (exportFlag=="Y")
		{
			var savefileName="C:\\Documents and Settings\\";
			var savefileName=_UDHCANOPSET.GetExportParth()
			var d = new Date();
			savefileName+=d.getYear()+"-"+(d.getMonth()+ 1)+"-"+d.getDate();
			savefileName+=" "+d.getHours()+","+d.getMinutes()+","+d.getSeconds();
			savefileName+=".xls"
			xlsSheet.SaveAs(savefileName);	
		}
		else
		{
		xlsExcel.Visible = true;
			xlsSheet.PrintPreview();
		}
		xlsSheet = null;
		xlsBook.Close(savechanges=false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;
		
	}
    

//print
	function PrintAnOpList(prnType, exportFlag) 
	{
    	if (prnType == "")return;
		var name,fileName,path,operStat,printTitle,operNum;
		var xlsExcel,xlsBook,xlsSheet;
		var row = 3;
		var titleRows,titleCols,LeftHeader,CenterHeader,RightHeader;
		var LeftFooter,CenterFooter,RightFooter,frow,fCol,tRow,tCol;
		path = GetFilePath();
		//���ز���
		//path="D:\\DtHealth\\app\\dthis\\med\\Results\\Template\\"
		//printTitle = _UDHCANOPSET.GetPrintTitle(prnType);
		printTitle=$.m({
        	ClassName:"web.UDHCANOPSET",
        	MethodName:"GetPrintTitle",
        	queryTypeCode:prnType
    		},false);
		
		var printStr = printTitle.split("!");
		if (printTitle.length < 4)return;
		name = printStr[0];
		fileName = printStr[1];
		fileName = path + fileName;
		//alert(fileName)
		xlsExcel = new ActiveXObject("Excel.Application");
		xlsBook = xlsExcel.Workbooks.Add(fileName);
		xlsSheet = xlsBook.ActiveSheet;
		operStat = printStr[2];
		var strList = printStr[3].split("^")
		var printLen = strList.length;
		for (var i = 0; i < printLen; i++) {
			xlsSheet.cells(row, i + 1) = strList[i].split("|")[0];
		}
		var row = 3;
		operNum = 0;
		var preLoc = "";
		var preRoom = "";
		var count ="";
		var allRows=$("#OperListBox").datagrid("getData");
		var selectRows=$("#OperListBox").datagrid("getChecked");
		count=selectRows.length;
		if(count==0)
		{
			count=allRows.total;
			selectRows=allRows.rows;
		}
		//var selPrintTp = $("#chkSelPrint").checkbox('getValue')? 'S' : 'A';
		for (var i = 0; i < count; i++) {
			var chk = ""
			var record = selectRows[i];
			var stat = record.status;
			if ((stat == operStat) || (operStat == "")) {
			row = row + 1;
				operNum = operNum + 1;
				//Sort by loc, insert empty row between different loc
				var loc = record.loc;
				var locarr = loc.split("/");
				if (locarr.length > 1)
					loc = locarr[0];
				var room = record.oproom; //�й�ҽ���ã���ͬ�������䣬����һ�����У���ͷ������
				/*if ((preRoom != "") && (preRoom != room)) {
					row = row + 1;
					for (var n = 0; n < printLen; n++) {
						xlsSheet.cells(row, n + 1) = strList[n].split("|")[0];
					}
					row = row + 1;
				}*/
				for (var j = 0; j < printLen; j++) {
					var colName = strList[j].split("|")[1];
					var colVal = record[colName];
						if (colVal) {
							if ((colName == "oproom") || (colName == "opordno")) {
							if ((colVal == '��') || (colVal == 'δ��'))
									xlsSheet.cells(row, j + 1) = "";
								else
									xlsSheet.cells(row, j + 1) = colVal
							} else if (colName == "opname") {
								var opName = colVal.split(';');
								var colValLen = colVal.length;
								var firstOpNameLen = opName[0].length;
								xlsSheet.cells(row, j + 1).FormulaR1C1 = colVal;
								xlsSheet.cells(row, j + 1).Characters(1, firstOpNameLen).Font.Name = "����";
								xlsSheet.cells(row, j + 1).Characters(firstOpNameLen + 2, colValLen - firstOpNameLen).Font.Italic = true;
							} else {
								xlsSheet.cells(row, j + 1) = colVal;
							}
						} else
							xlsSheet.cells(row, j + 1) = "";
				}
				preLoc = loc;
				preRoom = room;
			}
		}
		PrintTitle(xlsSheet, prnType, printStr, operNum);
		titleRows = 3;
		titleCols = 1;
		LeftHeader = " ",
		CenterHeader = " ",
		RightHeader = " ";
		LeftFooter = "";
		CenterFooter = "";
		RightFooter = " &N - &P ";
		ExcelSet(xlsSheet, titleRows, titleCols, LeftHeader, CenterHeader, RightHeader, LeftFooter, CenterFooter, RightFooter);
		AddGrid(xlsSheet, 3, 0, row, printLen - 1, 3, 1);
		FrameGrid(xlsSheet, 3, 0, row, printLen - 1, 3, 1);
		if (exportFlag == "N") {
			xlsExcel.Visible = true;
			xlsSheet.PrintPreview();
			//xlsSheet.PrintOut();
		} else {
			if (exportFlag == "Y") {
				var savefileName = "D:\\";
				//var savefileName = _UDHCANOPSET.GetExportParth()
					var d = new Date();
				savefileName += d.getYear() + "-" + (d.getMonth() + 1) + "-" + d.getDate();
				savefileName += " " + d.getHours() + "," + d.getMinutes() + "," + d.getSeconds();
				savefileName += ".xls"
				xlsSheet.SaveAs(savefileName);
			}
		}
		xlsSheet = null;
		xlsBook.Close(savechanges = false)
		xlsBook = null;
		xlsExcel.Quit();
		xlsExcel = null;
	}

	function PrintTitle(objSheet,prnType,printStr,operNum)
	{
		var sheetName=printStr[0];	
		var setList=printStr[3].split("^");
		var colnum=setList.length;
		//var hospitalDesc=_DHCClinicCom.GetHospital();
		var hospitalDesc=$.m({
        	ClassName:"web.DHCClinicCom",
        	MethodName:"GetHospital"
    		},false);
		
		mergcell(objSheet,1,1,colnum);
		xlcenter(objSheet,1,1,colnum);
		fontcell(objSheet,1,1,colnum,16);
		objSheet.cells(1,1)=hospitalDesc+sheetName;
		var operStartDate=$("#DateFrom").datebox('getValue');
		//var operStartDate="2018-07-13";
		var tmpOperStartDate=operStartDate.split("/");
		if (tmpOperStartDate.length>2) operStartDate=tmpOperStartDate[2]+" �� "+tmpOperStartDate[1]+" �� "+tmpOperStartDate[0]+" ��";
		mergcell(objSheet,2,1,colnum);
		fontcell(objSheet,2,1,colnum,10);
		objSheet.cells(2,1)=operStartDate;
		var operEndDate=$("#DateTo").datebox('getValue');
		//var operEndDate="2018-07-14";
		var tmpOperEndDate=operEndDate.split("/");
		if (tmpOperEndDate.length>2) operEndDate=tmpOperEndDate[2]+" �� "+tmpOperEndDate[1]+" �� "+tmpOperEndDate[0]+" ��";
		
		if (prnType=="SSD") 
		{
			if(operEndDate!=operStartDate)
			{
				objSheet.cells(2,1)=operStartDate+"  ��  "+operEndDate+"             "+'����̨��:'+" "+operNum;
			}
			else
			{
				objSheet.cells(2,1)=operStartDate+"                "+'����̨��:'+" "+operNum;
			}
		}
		if (prnType=="MZD") objSheet.cells(2,1)=operStartDate;
       var apploc=$("#AppLoc").combobox('getText');
        //var apploc="zash";
        var applen=apploc.split("-");
        var applocDesc=""
        if(applen.length>1) 
        {
	        applocDesc=applen[1];
        }
        else
        {
	        applocDesc=applen;
        }
        if (prnType=="SQD") objSheet.cells(2,1)=operStartDate+"    "+'�������:'+" "+applocDesc;
		if (prnType=="SSYYDBNZ"||prnType=="SSYYDTY") objSheet.cells(2,1)=operStartDate+"             "+operNum+" ��     "+session['LOGON.USERNAME'];
	}
	function GetFilePath()
	{
		var path=$.m({
        ClassName:"web.DHCClinicCom",
        MethodName:"GetPath"
    },false);
    return path;
	}
//------------------��ӡend
function OPControlledCost(){
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId;
    var lnk = "dhcclinic.anop.controlledcost.csp?opaId=" + opaId + "&userId=" + logUserId;
    //var nwin="dialogWidth:1160px;dialogHeight:590px;status:no;menubar:no;"
    var iLeft = (window.screen.width-10-1160)/2;
     var iTop=(window.screen.availHeight-40-580)/2;
    var nwin='top='+iTop+',left='+iLeft+',height=580,width=1160,toolbar=no,menubar=no,resizable=no,scrollbars=yes'
    window.open(lnk, "�ɿسɱ�����", nwin);
}
function ANEquip(){
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId;
    var lnk = "dhcclinic.anop.anequip.csp?opaId=" + opaId + "&userId=" + logUserId;
        var iLeft = (window.screen.width-10-1230)/2;

    var nwin="height=600,width=1230,toolbar=no,menubar=no,resizable=no,scrollbars=yes"+',top=20'+',left='+iLeft;
    window.open(lnk, "�����豸����",nwin);
}
/*
�˵����÷���
*/
//
function MZSSApply(appType,lnk,nwin,appCat)
{
	var opaId="";
    var lnk="";
	var selectRows=$("#OperListBox").datagrid("getChecked");
	 if(selectRows.length==1)
    {
	 EpisodeID= selectRows[0].adm;
   	}
    if(EpisodeID&&EpisodeID!="")
    {
        lnk="dhcanopoutoper.csp?";
        lnk+="&opaId="+opaId+"&appType="+appType+"&EpisodeID="+EpisodeID+"&random="+Math.random();
        //var nwin="dialogWidth:1105px;dialogHeight:700px;status:no;menubar:no;"
        var iLeft = (window.screen.width-10-1105)/2;
       var iTop=(window.screen.availHeight-40-650)/2;
        var nwin='left='+iLeft+",top="+iTop+",height=650,width=1105,toolbar=no,menubar=no,resizable=no,scrollbars=yes"
        window.open(lnk, "������������",nwin );
       /*
       var nwin="dialogWidth:1105px;dialogHeight:650px;status:no;menubar:no;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;";
       var returnVal=window.showModalDialog(lnk,'_blank',nwin);
       if(returnVal==1)
    	{
        	$("#OperListBox").datagrid("reload");
   		}
   		*/
     }else{
            $.messager.alert("��ʾ","û��ѡ���ߣ��޷���������","info");
            return;
        }
}
function MZSSAlter(appType,lnk,nwin,appCat)
{
	  var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
	    var opaId=selectRows[0].opaId;
	    var EpisodeID=selectRows[0].adm;
	    var dayOperFlag=selectRows[0].dayOperFlag;
	    var status=selectRows[0].status;
	    if((status!='����')&&(appType=="ward"))
    	{
        	$.messager.alert("��ʾ","�ܲ���������״̬Ϊ:"+"����","info");
        	return;
    	}
    	else if((status!='����')&&(appType=="RegOp"))
    	{
	    	$.messager.alert("��ʾ","�ܲ���������״̬Ϊ:"+"����","info");
        	return;
    	}
    	else if((status!='����')&&(status!='����')&&(appType=="op"))
    	{
	    	$.messager.alert("��ʾ","�ܲ���������״̬Ϊ:"+"���ż�����","info");
        	return;
    	}
		if(dayOperFlag=="Y"){
			$.messager.alert("��ʾ","���ɶ��ռ���������","info");
			return;
			}
    var lnk="dhcanopoutoper.csp?";
            
         lnk+="&opaId="+opaId+"&appType="+appType+"&EpisodeID="+EpisodeID+"&random="+Math.random();
         var iLeft = (window.screen.width-10-1105)/2;
         var iTop=(window.screen.availHeight-40-650)/2;
        //var nwin='left='+iLeft+",top="+iTop+",height=650,width=1105,toolbar=no,menubar=no,resizable=no,scrollbars=yes"
             //window.open(lnk, "���������޸�", nwin);
            var nwin="dialogWidth:1105px;dialogHeight:650px;status:no;menubar:no;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;";
            var returnVal=window.showModalDialog(lnk,'_blank',nwin);
            if(returnVal==1)
    		{
        	$("#OperListBox").datagrid("reload");
   			 }
}

function btnLeave_click(){

}
function btnCancelOper_click(){
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var status=selectRows[0].status;
    var opaId=selectRows[0].opaId;
    if((status!='����')&&(status!='')&&(status!='���ռ�'))
    {
        $.messager.alert("��ʾ","�ܲ���������״̬Ϊ:"+"����","error");
        return;
    }
    if(opaId=="")
    {
        $.messager.alert("��ʾ","��ѡ��һ��״̬Ϊ�����������","error");
        return;
    }else{
        $.messager.confirm("ȷ��","�Ƿ�ȡ����̨������",function(r){
            if(r){
	            var iLeft = (window.screen.width-10-360)/2;
	            var iTop=(window.screen.availHeight-40-160)/2;
                var lnk="canceloper.hisui.csp?"+"&opaId=" + opaId ;
                 //var nwin='left='+iLeft+",top="+iTop+",height=160,width=360,toolbar=no,menubar=no,resizable=no,scrollbars=yes"
				//window.open(lnk,'_blank',nwin);
                //var lnk="canceloper.hisui.csp?"+"&opaId="+idStr;
                    //var nwin="toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no"+"height="+200+",width=700,top="+iTop+",left="+iLeft;
                    //window.open(lnk,"CancelOper",nwin);
                    var nwin="dialogWidth:360px;dialogHeight:160px;status:no;menubar:no;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;";
     				var returnVal=window.showModalDialog(lnk,'_blank',nwin);
    				if(returnVal==1)
    				{
        				$("#OperListBox").datagrid("reload");
   			 			}
            }else{
                $("#OperListBox").datagrid("clearChecked");
            }
        })
    }  	
}
//������������
function CheckRiskAssessment(){
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var EpisodeID=selectRows[0].adm;
	var status=selectRows[0].status;
	var opaId=selectRows[0].opaId;
    var lnk="dhcanoperriskassessment.view.csp?&opaId="+opaId;
	var iTop=(window.screen.availHeight - 40 - 640) / 2;  
	if(iTop<10) iTop=10;
    var iLeft=(window.screen.availWidth  - 10 - 1280) / 2;  
    var nwin="dialogWidth:1280px;dialogHeight:640px;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;center:true;status:no;menubar:no;"
    //var nwin="dialogWidth:1280px;dialogHeight:640px;center:true;status:no;menubar:no;top:10px;"
	var returnVal=window.showModalDialog(lnk,'_blank',nwin);
    //window.open(lnk,'_blank',nwin);
}
//������ȫ�˲�
function CheckSafetyInfo(){
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId;
    var lnk="dhcanopersafetycheck.view.csp?opaId="+opaId+"&userId="+logUserId;
	var iTop=(window.screen.availHeight - 10 - 680) / 2;	
    var iLeft=(window.screen.availWidth  - 10 - 1200) / 2;  
    var nwin="dialogWidth:1200px;dialogHeight:680px;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;center:true;status:no;menubar:no;"
    //var nwin="dialogWidth:1200px;dialogHeight:836px;center:true;status:no;menubar:no;top:10px;"
    //var nwin=
    //window.open(lnk,"������ȫ�˲�",nwin);
    var returnVal=window.showModalDialog(lnk,"������ȫ�˲�",nwin);
    if(returnVal==1)
    {
        $("#OperListBox").datagrid("reload");
    }
}
//��������
function OperAssess(){
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId;
    var lnk="dhcanopassess.index.csp?opaId="+opaId+"&userId="+logUserId;
	var iTop=(window.screen.availHeight - 10 - 680) / 2;	
    var iLeft=(window.screen.availWidth  - 10 - 1200) / 2;  
    var nwin="dialogWidth:1200px;dialogHeight:480px;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;center:true;status:no;menubar:no;";
    var returnVal=window.open(lnk,"��������",nwin);
    if(returnVal==1)
    {
        $("#OperListBox").datagrid("reload");
    }
}
function btnOPNurseOrdered_click(){
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId,
        status=selectRows[0].status;
    if((status=="����")||(status=='�ܾ�')||(status=='���ռ�'))
    {
        $.messager.alert("��ʾ","���Դ�״̬����������!","error");
        return false;
    }
    var ret=$.m({
        ClassName:"web.DHCANOPArrangeHISUI",
        MethodName:"UpdateOPNurseOrdered",
        opaId:opaId,
        isOrdered:'Y'
    },false)
    if((ret!="Y")&&(ret!="N"))
    {
        $.messager.alert("����",result,"error");
        return;
    }else{
        $.messager.alert("��ʾ","�����ɹ���","info");
       	$("#OperListBox").datagrid("reload");
        //selectRows[0].opNurseOrd=result;
    }
}
function btnInRoom_click(){
    var idStr="",
        tmp=[];
    var selectRows=$("#OperListBox").datagrid("getChecked");
    for(var i=0;i<selectRows.length;i++)
    {
        var rowData=selectRows[i];
        var rowIndex=$("#OperListBox").datagrid("getRowIndex",rowData);
        var status=rowData.status;
        status=status.replace(" ","");
        var opRoom=rowData.oproom;

    }
}
function btnAnDocOrdered_click(){
    var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId,
        status=selectRows[0].status;
    if((status=="����")||(status=='�ܾ�')||(status=='���ռ�'))
    {
        $.messager.alert("��ʾ","���Դ�״̬����������!","error");
        return false;
    }
    var result=$.m({
        ClassName:"web.DHCANOPArrangeHISUI",
        MethodName:"UpdateAnaDoctorOrdered",
        opaId:opaId,
        isOrdered:'Y'
    },false)
    if(result!=0)
    {
        $.messager.alert("����",result,"error");
        return;
    }else{
        $.messager.alert("��ʾ","�����ɹ���","info");
        //selectRows[0].anaDoctorOrd="Y";
        $("#OperListBox").datagrid("reload");	//20181207+dyl
    }
}
//20181213+dyl+ͬ������ҽʦ
function btnArrAnDocAuto_click()
{
	var idStr="";
	var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId;
    //20190725
     var statusa=selectRows[0].status;
    if((statusa!="����"))
    {
        $.messager.alert("��ʾ","���Դ�״̬����������!","error");
        return false;
    }
    var ordNo=selectRows[0].opordno;
   if(ordNo!=1)
    {
	     $.messager.alert("��ʾ","ֻ��ѡ����̨����ͬ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var result=$.m({
        ClassName:"web.DHCANOPArrange",
        MethodName:"AnDocAutoArr",
        firstOpaId:opaId
    },false)
    if(result!=0)
    {
        $.messager.alert("����",result,"error");
        return;
    }else{
        $.messager.alert("��ʾ","�����ɹ���","info");
        $("#OperListBox").datagrid("reload");	//20181207+dyl
    }
}
//20190125+dyl+ͬ����еѲ��
function btnArrNurseAuto_click()
{
	var idStr="";
	var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId;
    //20190725
    var statuss=selectRows[0].status;
    if((statuss!="����"))
    {
        $.messager.alert("��ʾ","���Դ�״̬����������!","error");
        return false;
    }
    var ordNo=selectRows[0].opordno;
    if(ordNo!=1)
    {
	     $.messager.alert("��ʾ","ֻ��ѡ����̨����ͬ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var result=$.m({
        ClassName:"web.DHCANOPArrange",
        MethodName:"NurseAutoArr",
        firstOpaId:opaId
    },false)
    if(result!=0)
    {
        $.messager.alert("����",result,"error");
        return;
    }else{
        $("#OperListBox").datagrid("reload");	//20181207+dyl
        $.messager.alert("��ʾ","�����ɹ���","info");
    }
    

}


//
function DHCANOPNurseRecord()
{
	
}
//--------**�ռ俪ʼ------������������
//-------------------
	//������ǰ����
function btnANAuditOper()
{
	var selectRows=$("#OperListBox").datagrid("getChecked");
	if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    if(selectRows&&selectRows.length>0)
    {
			var dayOperFlag=selectRows[0].dayOperFlag;
			if(dayOperFlag!="Y")
			{
				$.messager.alert("��ʾ","���ռ�����,������ѡ��","error");
				return;
			}
			//var status = selectObj.get('status');
				var opaId = selectRows[0].opaId,
					EpisodeID = selectRows[0].adm,
					userId = session["LOGON.USERID"],
					lnk = "dayoperpreacessui.csp?opaId=" + opaId + "&userId=" + userId+"&EpisodeID="+EpisodeID;
			//var nwin="dialogWidth:610px;dialogHeight:590px;status:no;menubar:no;"
			//var returnVal=window.showModalDialog(lnk,'_blank',nwin)
			var iLeft = (window.screen.width-10-1120)/2;
			var iTop=(window.screen.availHeight-40-660)/2;
			var nwin='left='+iLeft+",top="+iTop+",height=660,width=1120,toolbar=no,menubar=no,resizable=no,scrollbars=yes"
			window.open(lnk, "���ռ�������ǰ����", nwin);
		 /*
		 var nwin="dialogWidth:1120px;dialogHeight:670px;status:no;menubar:no;top:10px;left:140px;"
            var returnVal=window.showModalDialog(lnk,'���ռ�������ǰ����',nwin);
            if(returnVal==1)
    		{
        	//$("#OperListBox").datagrid("reload");
   			 }
   			 */
		}
		else {
			$.messager.alert("��ʾ","��ѡ��һ��������¼��","warning");
    }
}

function btnANPostAcess()
{
		 var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId,
        status=selectRows[0].status;
			var dayOperFlag=selectRows[0].dayOperFlag;
			if(dayOperFlag!="Y")
			{
				$.messager.alert("��ʾ","���ռ�����,������ѡ��","error");
				return;
			}
			
			var EpisodeID = selectRows[0].adm;
			var userId = session["LOGON.USERID"];
			
			var lnk = "dayoperpostacessui.csp?opaId=" + opaId + "&userId=" + userId+"&EpisodeID="+EpisodeID;
			//var nwin="dialogWidth:610px;dialogHeight:590px;status:no;menubar:no;"
			//var returnVal=window.showModalDialog(lnk,'_blank',nwin)
			var iLeft = (window.screen.width-10-720)/2;
			var iTop=(window.screen.availHeight-40-600)/2;
			var nwin='left='+iLeft+",top="+iTop+",height=600,width=720,toolbar=no,menubar=no,resizable=no,scrollbars=yes"

			window.open(lnk, "���ռ�������������",nwin );
			/*var nwin="dialogWidth:1120px;dialogHeight:640px;status:no;menubar:no;top:10px;left:140px;"
            var returnVal=window.showModalDialog(lnk,'���ռ�������������',nwin);
            if(returnVal==1)
    		{
        	//$("#OperListBox").datagrid("reload");
   			 }
   			 */
}
//��Ժ����
function btnANDayOutAcess()
{
	 var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId,
        status=selectRows[0].status;
	var dayOperFlag=selectRows[0].dayOperFlag;
			
			var EpisodeID = selectRows[0].adm;
			var userId = session["LOGON.USERID"];
			if(dayOperFlag!="Y")
			{
				$.messager.alert("��ʾ","���ռ�����,������ѡ��","error");
				return;
			}
			if(status!="���")
			{
				$.messager.alert("��ʾ","�����״̬,������ѡ��","error");
				return;
			} 
			var lnk = "dayoperoutaccess.csp?opaId=" + opaId + "&userId=" + userId+"&EpisodeID="+EpisodeID;
			//var nwin="dialogWidth:610px;dialogHeight:590px;status:no;menubar:no;"
			//var returnVal=window.showModalDialog(lnk,'_blank',nwin)
			var iLeft = (window.screen.width-10-720)/2;
			var iTop=(window.screen.availHeight-40-600)/2;
			var nwin='left='+iLeft+",top="+iTop+",height=600,width=720,toolbar=no,menubar=no,resizable=no,scrollbars=yes"

			window.open(lnk, "���ռ��Ժ����", nwin);
			/*
			var nwin="dialogWidth:1120px;dialogHeight:640px;status:no;menubar:no;top:10px;left:140px;"
            var returnVal=window.showModalDialog(lnk,'���ռ��Ժ����',nwin);
            if(returnVal==1)
    		{
        	//$("#OperListBox").datagrid("reload");
   			 }
   			 */
}


//�޸��ռ�����
function AlterDayOper()
{
	 var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId,
        status=selectRows[0].status;
			var dayOperFlag=selectRows[0].dayOperFlag;
			if(dayOperFlag!="Y")
			{
				$.messager.alert("��ʾ","���ռ�����,������ѡ��","error");
				return;
			}
			
			var EpisodeID = selectRows[0].adm;
			var userId = session["LOGON.USERID"];
			if(status!="���ռ�")
			{
				$.messager.alert("��ʾ","�����ռ�״̬,������ѡ��","error");
				return;
			} 
			var	lnk = "dhcanopdayoperapply.csp?opaId=" + opaId + "&userId=" + userId+"&EpisodeID="+EpisodeID;
			var iLeft = (window.screen.width-10-1260)/2;
			var iTop=(window.screen.availHeight-40-650)/2;
			//var nwin="left="+iLeft+",top="+iTop+",height=650,width=1260,toolbar=no,menubar=no,resizable=no,scrollbars=yes"
			//window.open(lnk, "���ռ������޸�",nwin) ;
		
			var nwin="dialogWidth:1260px;dialogHeight:650px;status:no;menubar:no;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;";
            var returnVal=window.showModalDialog(lnk,'���ռ������޸�',nwin);
            if(returnVal==1)
    		{
        	$("#OperListBox").datagrid("reload");
   			 }	
   			
   			 
	
}
//�ռ�����ȷ��
function ConfirmDayOper()
{
	 var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId,
        status=selectRows[0].status;
			var dayOperFlag=selectRows[0].dayOperFlag;
			if(dayOperFlag!="Y")
			{
				$.messager.alert("��ʾ","���ռ�����,������ѡ��","error");
				return;
			}
			
			var EpisodeID = selectRows[0].adm;
			var userId = session["LOGON.USERID"];
			var lnk = "dhcanopdayoperalter.csp?opaId=" + opaId + "&userId=" + userId+"&EpisodeID="+EpisodeID;
			var iLeft = (window.screen.width-10-1260)/2;
			var iTop=(window.screen.availHeight-40-650)/2;
			var nwin="left="+iLeft+",top="+iTop+",height=650,width=1260,toolbar=no,menubar=no,resizable=no,scrollbars=yes"
			window.open(lnk, "���ռ�����ȷ��", nwin);
		/*
		var nwin="dialogWidth:1260px;dialogHeight:680px;status:no;menubar:no;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;";
            var returnVal=window.showModalDialog(lnk,'���ռ�����ȷ��',nwin);
            if(returnVal==1)
    		{
        	$("#OperListBox").datagrid("reload");
   			 }
   			 */
}
//���ռ�����
function DayOrOut(event,value)
{
	
	if(value=true)
	{
		$("#IsOutOper").checkbox('setValue',false);
	}
}
//�����������
function OutOrDay(event,value)
{
	if(value=true)
	{
		$("#chkIsDayOper").checkbox('setValue',false);
	}
}

//---------------�ռ����--------------

ReceivePat=function(type)
{
	var iTop=10;  
    var iLeft=10;  
    var width=window.screen.availWidth-10*2;
    var height=window.screen.availHeight-10*2-40;
    var nwin="dialogWidth:"+width+"px;dialogHeight:"+height+"px;dialogTop:"+iTop+"px;dialogLeft:"+iLeft+"px;center:true;status:no;menubar:no;"
	var lnk="dhcanopreceivepat.view.csp?&type="+type;
	var returnVal=window.showModalDialog(lnk,'_blank',nwin)
}
//20191030+dyl+���ϵǼ�
function RegMaterialList()
{
	var selectRows=$("#OperListBox").datagrid("getChecked");
    if(selectRows.length==0)
    {
         $.messager.alert("��ʾ","��ѡ��һ������","warning");
         return;
    }
    if(selectRows.length>1)
    {
        $.messager.alert("��ʾ","ֻ�ܲ���һ������","error");
        $("#OperListBox").datagrid("clearChecked");
        return;
    }
    var opaId=selectRows[0].opaId,
     status=selectRows[0].status;
     var EpisodeID=selectRows[0].PAADMMainMRADMDR;
	var lnk = "dhcanopmaterialreg.csp?opaId=" + opaId +"&EpisodeID="+EpisodeID;
	var iLeft = (window.screen.width-10-860)/2;
	var iTop=(window.screen.availHeight-40-700)/2;
	var nwin="left="+iLeft+",top="+iTop+",height=700,width=860,toolbar=no,menubar=no,resizable=no,scrollbars=yes"
	window.open(lnk, "���������嵥", nwin);
}
//20191030+dyl+����ͳ��
function MaterialListTotal()
{
	var lnk = "dhcanopmateriallist.csp?";
	var iLeft = (window.screen.width-10-860)/2;
	var iTop=(window.screen.availHeight-40-700)/2;
	var nwin="left="+iLeft+",top="+iTop+",height=700,width=800,toolbar=no,menubar=no,resizable=no,scrollbars=yes"
	window.open(lnk, "���������嵥ͳ��", nwin);

}