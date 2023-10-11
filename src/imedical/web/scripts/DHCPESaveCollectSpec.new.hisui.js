//����	DHCPESaveCollectSpec.new.hisui.js
//����  �걾�ɼ�
//����	2023.03.10
//������  xy

var vRoomRecordID="";
var SessionStr = session['LOGON.USERID'] + "^" + session['LOGON.CTLOCID']; 
//���ݼ����IP��ȡ����ID
function SetRoomInfo()
{
    var Info=GetComputeInfo("IP");  //���������  DHCPECommon.js
    var RoomID=tkMakeServerCall("web.DHCPE.RoomManager","GetRoomIDByCompute",Info);
   
    if (RoomID=="") return false;
    $("#RoomID").val(RoomID.split("$")[0]);
}


$(function() {
    //���ݼ����IP��ȡ����ID
	SetRoomInfo();
	
	if( ConsultingRoom=="N") {
		$("#CallDiv").layout("remove","west")
	}
	else{
		document.getElementById("CallDiv").style.display = "";
	}
	
	//��ʼ���к��б�
	InitCallVoiceGrid();
	
	//��ʼ���ɼ��걾�б�
	InitSaveCollectSpecGrid();
	
	//��ѯ���кţ�
	$("#CallQuery").click(function(){
    	CallQuery();
    });
    
    $("#CallRegNo").change(function(){
            CallRegNoOnChange();
        });
        
    
    $("#CallRegNo").keydown(function(e) {
            if(e.keyCode==13){
                CallRegNoOnChange();
            }   
        });   
    
       
	//��ӡ
	$("#BPrint").click(function() {
		BPrint_Click();
	});
	
	//ȫ������
	$("#BSRRef").click(function() {
		BSRRef_Click();
	});

	//ȫ��ȡ��
	$("#BSARef").click(function() {
		BSARef_Click();
	});

	//����
	$("#BSave").click(function() {
		Save_Click();
	});

	//����Ԥ�ƺ�
	$("#BCancelPlacerNo").click(function() {
		BCancelPlacerNo_Click();
	});
    
    //�걾�Żس�
	$("#SpecNo").keydown(function(e) {
		if (e.keyCode == 13) {
			SpecNo_Click();
		}

	});
	
	//�ǼǺŻس�
	$("#RegNo").keydown(function(e) {
		if (e.keyCode == 13) {
			RegNo_Click();
		}

	});

    //Ԥ�ƺŻس�
	$("#PlacerNo").keydown(function(e) {

		if (e.keyCode == 13) {
			// ��ȡ��һ��ѡ�е���
			var selectrow = $('#SaveCollectSpecGrid').datagrid('getSelected');
			if(selectrow==null)
			{
				$.messager.alert("��ʾ","��ѡ�������Ԥ�ƺŵ�ҽ��",'info');
				return false;
			}
	
			//��ȡѡ���е�index
			var selectindex=$('#SaveCollectSpecGrid').datagrid('getRowIndex',selectrow)
	
			//��ȡ��ǰҳ����
			var rows = $('#SaveCollectSpecGrid').datagrid('getRows');
	
			if(selectrow.TSpecNo==""){
				$.messager.alert("��ʾ","�걾��Ϊ��,���ܱ���Ԥ�ƺ�",'info');
				return false;
			}
			if(selectrow.TOSTATDesc!="��ʵ"){
				$.messager.alert("��ʾ","ҽ�����Ǻ�ʵ״̬,���ܱ���Ԥ�ƺ�",'info');
				return false;
			}
			if (selectrow.TOEORIRowId!=""){
		
				var	Strings=selectrow.TOEORIRowId+";"+$("#PlacerNo").val()+";"+selectrow.TSpecNo;
			
			}
	
			var flag = tkMakeServerCall("web.DHCPE.OEOrdItem","UpdateBarInfo",Strings,"N");
	
			if(flag!=0){
				$.messager.alert("��ʾ",flag+",�����ٴα���Ԥ�ƺ�",'info');
				return false;
			}
			if(flag==0){
		
				//�����޸ĵ�����
				$('#SaveCollectSpecGrid').datagrid("updateRow",{
					index:selectindex ,
					row: {
						TPlacesNo: $("#PlacerNo").val(),
		
					}
			});

			var i=selectindex+1;
			$("#PlacerNo").val("");
			//��������Ӧ����
			$('#SaveCollectSpecGrid').datagrid('scrollTo',i);
		
			//ѡ����Ӧ����
			$('#SaveCollectSpecGrid').datagrid('selectRow',i); 

			}
	
		}

	});

})


//��ʼ���к��б�
function InitCallVoiceGrid() {
	$HUI.datagrid("#CallVoiceList", {
        url:$URL,
        fit : true,
        border:false,
        showHeader:false,
        pagination:true,
        singleSelect:true,
        pageSize:20,
        showRefresh:false,
        displayMsg:"",
        showPageList:false,
        queryParams:{
            ClassName:"web.DHCPE.ResultNew",
            QueryName:"FindCallVoicePatInfo",
            RegNo:"",
            RoomID:$("#RoomID").val(),
            HospID:session['LOGON.HOSPID']

        },
        columns:[[
      		{field:'PaadmID',hidden:true},
            {field:'PaPatID',hidden:true},
            {field:'PatLabel',title:'',width:240,formatter:setCellLabel},
            {field:'PAPMINo',title:'�ǼǺ�',width:90,hidden:true},
            {field:'AdmDate',title:'�������',width:50,hidden:true},
            {field:'Name',title:'����',width:60,hidden:true},
            {field:'Age',title:'����',width:50,hidden:true},
            {field:'Sex',title:'�Ա�',width:50,hidden:true},
            {field:'VIPLevel',title:'VIP',width:50,hidden:true},
            {field:'VIPDesc',title:'VIP�ȼ�',width:50,hidden:true},
            {field:'Status',title:'״̬',width:50,hidden:true},
            {field:'RecordID',width:50,hidden:true},
            {field:'DetailStatus',width:50,hidden:true},
            {field:'RoomDetail',title:'�������',width:100,hidden:true}
        ]],
        onLoadSuccess:function(e){   
       
        	if($("#CallRegNo").val()=="") return false;
            var rows=$('#CallVoiceList').datagrid("getRows");
            if (rows.length > 0) {
            	var row=rows[0];
            	var RoomID=$("#RoomID").val();
                var PAADM=row.PaadmID;
                var ret=tkMakeServerCall("web.DHCPE.RoomManager","CanCheck",RoomID,PAADM);
                if (ret=="1"){
	                $.messager.alert("��ʾ", "���ڱ����ȼ�����Ŀ,����ȥ����ؼ��", "info");
                    return false;
                }
                if (ret=="-1"){
	                $.messager.alert("��ʾ", "�������Ѿ�����,����������", "info");
                    return false;
                }
                var ret=tkMakeServerCall("web.DHCPE.RoomManager","ArriveByPAADM",RoomID,PAADM);
                
                var Arr=ret.split("^");
                var ret=Arr[0];
                if (ret==""){  //���ڵ�ǰ����
                    
                    vRoomRecordID="";
                    return false;
                }else{ //�ڵ�ǰ����
                    var Record=Arr[0];
                    var Status=Arr[1];
                    var DetailStatus=Arr[2];
                    if (Status=="N"){  //�ж��ǲ���ͬһ����
                        if (DetailStatus==""){ //��û�нк�
                            return false;
                        }
                        if (DetailStatus!="E"){  //��������״̬�ģ��������죬����
                            vRoomRecordID=Record;
                            var UserID=session['LOGON.USERID'];
                            var ret=tkMakeServerCall("web.DHCPE.RoomManager","ArriveCurRoom",Record,UserID,RoomID);
                            return false;
                            
                        }
                        if (DetailStatus=="E"){  //��������״̬�ģ��������죬����
                            
                            
                        }
                    }
                    
                    
                }
             
              
            }
        },
        onDblClickRow:function(rowIndex, rowData){

                var HospID=session['LOGON.HOSPID'];
                var RoomID=$("#RoomID").val();
                var PAADM=rowData.PaadmID;
                $("#PAADM").val(PAADM);
                var ret=tkMakeServerCall("web.DHCPE.RoomManager","CanCheck",RoomID,PAADM);
                if (ret=="1"){
	                $.messager.alert("��ʾ", "���ڱ����ȼ�����Ŀ,����ȥ����ؼ��", "info");
                    return false;
                }
                if (ret=="-1"){
	                $.messager.alert("��ʾ", "�������Ѿ�����,����������", "info");
                    return false;
                }
                var ret=tkMakeServerCall("web.DHCPE.RoomManager","ArriveByPAADM",RoomID,PAADM);
                var Arr=ret.split("^");
                var ret=Arr[0];
                if (ret==""){  //���ڵ�ǰ����
                    var TypeFlag=Arr[1];
                    if  (TypeFlag=="2"){
                        if (!confirm("�����δ�Ŷӵ�������,�Ƿ����?")) return false;
                    }else if (TypeFlag=="1"){
                        if (!confirm("����ɱ����Ҽ��,�Ƿ���Ҫ�޸�?")) return false;
                    }
                    vRoomRecordID="";
                }else{ //�ڵ�ǰ����
                    var Record=Arr[0];
                    var Status=Arr[1];
                    var DetailStatus=Arr[2];
                    if (Status=="N"){  //�ж��ǲ���ͬһ����
                        if (DetailStatus==""){ //��û�нк�
                            if (!confirm("�����ߺͽк��߲���ͬһ����,�Ƿ����?")) return false;
                        }
                        if (DetailStatus!="E"){  //��������״̬�ģ��������죬����
                            var UserID=session['LOGON.USERID'];
                            var ret=tkMakeServerCall("web.DHCPE.RoomManager","ArriveCurRoom",Record,UserID,RoomID);
                            
                        }
                    }
                    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 

                    vRoomRecordID=Record;
                }
        }
   
	})

} 
 
function GetNextInfo(IsCall)
{
    if(IsCall==undefined) IsCall="N";
    var RoomID=$("#RoomID").val();
    if (RoomID=="") 
    {
        $.messager.alert("��ʾ","������δ�����Ŷӽкţ�","info");
        return false;
    }
    var Info=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetNextInfo",RoomID,IsCall);
    return Info;
}

//����
function Call()
{
    var Info=GetNextInfo("Y");
    var Arr=Info.split("^");
    var RecordID=Arr[0];
    var CallName=Arr[1];
    if (RecordID==""){
        $.messager.alert("��ʾ","û���ŶӼ�¼��","info");
        return false;
    }
    CallApp(RecordID,CallName);
}

function CallApp(RecordID,CallName)
{
    
    var OldRecord=vRoomRecordID;
    
    if ((OldRecord!=RecordID)&&(OldRecord!=""))
    {
        var Status=tkMakeServerCall("web.DHCPE.RoomManagerEx","GetRecordStatus",OldRecord)
        var StatusArr=Status.split("^");
        var DetailStatus=StatusArr[1];
        var Status=StatusArr[0];
        if (Status=="N"){
            if (!confirm("��ǰ�����,��û�����,�Ƿ�ʼ��һ��?")){
                return false;
            }
        }
    }
    
    
    var rtn=tkMakeServerCall("web.DHCPE.RoomManager","CallCurRoom",RecordID)
    var Arr=rtn.split("^");
    if (Arr[0]!="0"){
	    $.messager.alert("��ʾ",alert(Arr[1]),"info");  
    }
   
    $("#WaitInfo").val("���ں��У�"+CallName);
    vRoomRecordID=RecordID;    
}

//˳��
function Delay()
{
    var HospID=session['LOGON.HOSPID'];
    $.messager.confirm("��ʾ", "ȷ��Ҫ˳����?", function (r) {
    	if (r) {
        
    		var Info=GetNextInfo();
    		var Arr=Info.split("^");
    		var RecordID=Arr[0];
    
    		if (RecordID==""){
        		$.messager.alert("��ʾ","û���ŶӼ�¼��","info");
        		return false;
    		}
    		var CallName=Arr[1];
    		var rtn=tkMakeServerCall("web.DHCPE.RoomManager","DelayCurRoomInfo",RecordID)
    
    		var Arr=rtn.split("^");
    		if (Arr[0]!="0"){
        		 $.messager.alert("��ʾ",alert(Arr[1]),"info");  
    		}
    		$("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 
    	} else {
       	 return false;
    	}
    })  
    
}

//����
function Pass()
{
    var HospID=session['LOGON.HOSPID'];
    $.messager.confirm("��ʾ", "ȷ��Ҫ������?", function (r) {
    if (r) {
    	var Info=GetNextInfo();
    	var Arr=Info.split("^");
   	 	var RecordID=Arr[0];
    	if (RecordID==""){
        	$.messager.alert("��ʾ","û���ŶӼ�¼��","info");
        	return false;
    	}
    
    	var CallName=Arr[1];
    
    	var rtn=tkMakeServerCall("web.DHCPE.RoomManager","PassCurRoomInfo",RecordID)
    	var Arr=rtn.split("^");
    	if (Arr[0]!="0"){
        	$.messager.alert("��ʾ",Arr[1],"info");
    	}
    	vRoomRecordID="";
    	$("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 
    } else {
          return false;
    }
    });

    
}

//����ȷ��
function BComplete()
{

	var HospID=session['LOGON.HOSPID'];
	var HospID=session['LOGON.HOSPID'];
   
	var RecordID="";
    
    var RoomID=$("#RoomID").val();
    if (RoomID=="") 
    {
	    $.messager.alert("��ʾ","������δ�����Ŷӽкţ�","info");
        return false;
    }
    
    var PAADM=$("#PAADM").val();
    if (PAADM==""){
        $.messager.alert("��ʾ","û�о����¼!","info");
        return false;
    }
    
    var ret=tkMakeServerCall("web.DHCPE.RoomManager","CompleteCurRoom",RecordID,PAADM,RoomID)
    var Arr=ret.split("^");
    
    vRoomRecordID="";
    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 

    var WaitInfo=tkMakeServerCall("web.DHCPE.RoomManager","GetWaitInfo",PAADM)
    $("#WaitInfo").value(WaitInfo);
}


//��������
function ReStartPass(RecordID)
{
    var HospID=session['LOGON.HOSPID'];
    if (RecordID==""){
        $.messager.alert("��ʾ","û���ŶӼ�¼��","info");
        return false;
    }
    
    $.messager.confirm("��ʾ", "ȷ��Ҫ����������?", function (r) {
    if (r) {
        
   		var rtn=tkMakeServerCall("web.DHCPE.RoomManager","ReStartCurRoomInfo",RecordID)
    
    	var Arr=rtn.split("^");
    	if (Arr[0]!="0"){
	    	$.messager.alert("��ʾ",alert(Arr[1]),"info");
    	}
    	$("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:"",RoomID:getValueById("RoomID"),HospID:HospID}); 

     } else {
     	return false;
    	 }
    });

    
 }
 
    
/// ������Ϣ�б�  ��Ƭ��ʽ
function setCellLabel(value, rowData, rowIndex){
        var htmlstr =  '<div class="celllabel"><h3 style="float:left;background-color:transparent;">'+ rowData.Name
         +'</h3><h3 style="float:right;background-color:transparent;"><span>'+ rowData.Sex +'/'+ rowData.Age 
         +'</span></h3><br>'+'<h3 style="float:left;background-color:transparent;"><span>'+ rowData.AdmDate
         +'</span></h3>';
         
        
        if((rowData.Status=="NE")||(rowData.Status=="N")){
            
        if(rowData.DetailStatus=="E"){
                    htmlstr = htmlstr + '<h3 style="float:right;background-color:transparent;"><span>'+ '����'
                    +'</span></h3>';
            
                }
                
        if(rowData.DetailStatus=="C"){
                    htmlstr = htmlstr + '<h3 style="float:right;background-color:transparent;"><span>'+ '����'
                    +'</span></h3>';
            
                }       
        if(rowData.DetailStatus==""){
                    htmlstr = htmlstr + '<h3 style="float:right;background-color:transparent;"><span>'+ '�ȴ�'
                    +'</span></h3>';
            
                }   
        }       
                
        if(rowData.Status=="P"){
                    htmlstr = htmlstr + '<h3><a><img style="float:right;background-color:transparent;" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel_order.png"  title="��������" border="0" onclick="ReStartPass('+rowData.RecordID+')"></a></h3>';
            
                }
        
        htmlstr = htmlstr + '<br> <h4 style="float:left;background-color:transparent;">ID:'+ rowData.PAPMINo +'</h4>';
        var classstyle="color: #18bc9c";
        if(rowData.VIPLevel!=""){
            if(rowData.VIPLevel==3) {classstyle="color: #f9bf3b"};
            if(rowData.VIPLevel==1) {classstyle="color: #3c78d8"};
            if(rowData.VIPLevel==2) {classstyle="color: #f22613"};
            htmlstr = htmlstr +'<h4 style="float:right;background-color:transparent;"><span style="'+classstyle+'" style="width:50%;padding-bottom: 0px;padding-top: 0px">'+rowData.VIPDesc+'</span></h4>';
        }
        htmlstr = htmlstr +'</div>';
        return htmlstr;
 }
 
function CallRegNoOnChange()
{
    var CTLocID=session['LOGON.CTLOCID'];
    var HospID=session['LOGON.HOSPID'];
    var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength",CTLocID);
    var iRegNo= $("#CallRegNo").val();
    if (iRegNo.length<RegNoLength && iRegNo.length>0) { 
    	iRegNo=tkMakeServerCall("web.DHCPE.DHCPECommon","RegNoMask",iRegNo,CTLocID);
        $("#CallRegNo").val(iRegNo);
    }
    
    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:$("#CallRegNo").val(),RoomID:$("#RoomID").val(),HospID:HospID}); 
   
}
  
function CallQuery()
{
    var HospID=session['LOGON.HOSPID']
    $("#CallVoiceList").datagrid('load',{ClassName:"web.DHCPE.ResultNew",QueryName:"FindCallVoicePatInfo",RegNo:$("#CallRegNo").val(),RoomID:$("#RoomID").val(),HospID:HospID}); 
}


   
//��������Ź���
function BCancelPlacerNo_Click(){
	
	// ��ȡ��һ��ѡ�е���
	var selectrow = $('#SaveCollectSpecGrid').datagrid('getSelected');
	if(selectrow==null)
	{
		$.messager.alert("��ʾ","��ѡ�������Ԥ�ƺŵ�ҽ��",'info');
		return false;
	}
	if(selectrow.TSpecNo==""){
		$.messager.alert("��ʾ","�걾��Ϊ��,���ܳ���Ԥ�ƺ�",'info');
		return false;
	}
	if(selectrow.TOSTATDesc!="��ʵ"){
		$.messager.alert("��ʾ","ҽ�����Ǻ�ʵ״̬,���ܳ���Ԥ�ƺ�",'info');
		return false;
	}
	if(selectrow.TPlacesNo==""){
		$.messager.alert("��ʾ","Ԥ�ƺ�Ϊ��,���ܳ���Ԥ�ƺ�",'info');
		return false;
	}

	//��ȡѡ���е�index
	var selectindex=$('#SaveCollectSpecGrid').datagrid('getRowIndex',selectrow)
	
	if (selectrow.TOEORIRowId!=""){
			var	Strings=selectrow.TOEORIRowId+";"+selectrow.TPlacesNo+";"+selectrow.TSpecNo; 
		}
	
	var flag = tkMakeServerCall("web.DHCPE.OEOrdItem","UpdateBarInfo",Strings,"Y");
	
	if(flag!=0){
		$.messager.alert("��ʾ",flag,'info');
		return false;
	}else{
		$.messager.alert("��ʾ","����Ԥ�ƺųɹ�",'success');
		$("#PlacerNo").val("");
		$('#SaveCollectSpecGrid').datagrid("updateRow",{
			index:selectindex ,
			row: {
				TPlacesNo:"",
			}
		});
 		
		return false;
	}
		
}

function Save_Click() {
	$('#SaveCollectSpecGrid').datagrid('endEdit', editIndex); //���һ�н����б༭	
	$("#SaveCollectSpecGrid").datagrid('reload');

}


function BSave_Click() {
	var vStatus = "",
		vDetailStatus = "",
		ReturnValue = "";

	var SpecNo = $("#SpecNo").val();
	if (SpecNo == "") {
		$.messager.popover({
			msg: "�걾�Ų���Ϊ��",
			type: "info"
		});
		return false;
	}

	var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDate", SpecNo);
	//alert(Value)
	var Arr = Value.split("^");
	var RegNoFlag = Arr[3];
	if (RegNoFlag == "1") {
		var PIADM = tkMakeServerCall("web.DHCPE.PreIADM", "GetPIADMByRegNo", SpecNo);
		if (PIADM == "") {
			return false
		}
		var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByRegNo", SpecNo);
		if (Status == "REGISTERED") {
			$.messager.confirm("ȷ��", "ȷ��Ҫ������", function(r) {
				if (r) {
					$.m({
						ClassName: "web.DHCPE.DHCPEIAdm",
						MethodName: "UpdateIADMInfo",
						PreIADMID: PIADM,
						Type: 3
					}, function(ReturnValue) {
						if (ReturnValue != '0') {
							var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByRegNo", SpecNo);
							if(Status!="ARRIVED"){
								$.messager.alert("��ʾ", "����ʧ��", "error");
							}
							
						}
					});
				}
			});
		}

		$("#SpecNo").val("");
		$("#RegNo").val(SpecNo);
		$("#PAADM").val(Arr[2]);

	} else {
		$("#RegNo").val("");
		var PAADM = Arr[2];
		$("#PAADM").val(Arr[2]);
		var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByPAADM", PAADM);
		var AdmArr = Status.split("^");
		var PIADM = AdmArr[1];
		//alert(Status)
		if (PIADM == "") {
			return false
		}
		if (AdmArr[0] == "REGISTERED") {
			$.messager.confirm("ȷ��", "ȷ��Ҫ������", function(r) {
				if (r) {
					$.m({
						ClassName: "web.DHCPE.DHCPEIAdm",
						MethodName: "UpdateIADMInfo",
						PreIADMID: PIADM,
						Type: 3
					}, function(ReturnValue) {
						if (ReturnValue != '0') {
							var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByPAADM", PAADM);
							if(Status.split("^")[0]!="ARRIVED"){
								$.messager.alert("��ʾ", "����ʧ��", "error");
							}
						}
					});
				}
			});

		}
	}

	if (Arr[0] == "0") {
		//$.messager.alert('��ʾ', Arr[1], "info");
		$.messager.popover({msg: Arr[1],type: "info"});
		return false;
	} else if (Arr[0] == "1") {

		$.messager.confirm("ȷ��", "�ñ걾����߲��ǵ��쵽��,�Ƿ�����걾�˶�?", function(r) {
			if (r) {
				var RoomID = $("#RoomID").val();
				if (RoomID != "") {

					var CurRoomID = Value.split("^")[1];
					vStatus = Value.split("^")[4];
					vDetailStatus = Value.split("^")[5];
					if ((CurRoomID != vRoomRecordID) && (vRoomRecordID != "")) //
					{
						if (!confirm("�����ߺͽк��߲���ͬһ����,�Ƿ����?")) return false;

					} else if (vRoomRecordID == "") {
						if (!confirm("û�нк�,�Ƿ����?")) return false;
					}
				}
				//parent.vRoomRecordID="";
				vRoomRecordID = CurRoomID;
				if (vStatus == "N") { //�ж��ǲ���ͬһ����
					if (vDetailStatus != "E") { //��������״̬�ģ��������죬����
						var UserID = session['LOGON.USERID'];
						var ret = tkMakeServerCall("web.DHCPE.RoomManager", "ArriveCurRoom", vRoomRecordID, UserID, RoomID);

					}
				}

				Init();
				Find();
				BPrint_Click();

			}
		});

		//if (!(confirm("�ñ걾����߲��ǵ��쵽��,�Ƿ�����걾�˶�?"))) {  return false; }
	} else {


		var RoomID = $("#RoomID").val();
		if (RoomID != "") {

			var CurRoomID = Value.split("^")[1];
			vStatus = Value.split("^")[4];
			vDetailStatus = Value.split("^")[5];
			if ((CurRoomID != vRoomRecordID) && (vRoomRecordID != "")) //
			{
				if (!confirm("�����ߺͽк��߲���ͬһ����,�Ƿ����?")) return false;

			} else if (vRoomRecordID == "") {
				if (!confirm("û�нк�,�Ƿ����?")) return false;
			}
		}
		//parent.vRoomRecordID="";
		vRoomRecordID = CurRoomID;
		if (vStatus == "N") { //�ж��ǲ���ͬһ����
			if (vDetailStatus != "E") { //��������״̬�ģ��������죬����
				var UserID = session['LOGON.USERID'];
				var ret = tkMakeServerCall("web.DHCPE.RoomManager", "ArriveCurRoom", vRoomRecordID, UserID, RoomID);

			}
		}

		Init();
		Find();
		BPrint_Click();
	}
}

function Init() {
	
	var HospID=session['LOGON.HOSPID'];
	var CTLocID=session['LOGON.CTLOCID'];
	
	var SpecNo = $("#SpecNo").val();
	var RegNo = $("#RegNo").val();
	if ((SpecNo == "") && (RegNo == "")) return false;
	var Str = tkMakeServerCall("web.DHCPE.BarPrint", "GetBaseInfo", RegNo, SpecNo,HospID,CTLocID)
	Str = Str.split("^");
	$("#Name").val(Str[0]);
	$("#Sex").val(Str[1]);
	$("#CardID").val(Str[2]);
	$("#RegNo").val(Str[3]);

	var ret = tkMakeServerCall("web.DHCPE.BarPrint", "GetSaveSpecInfo", $("#SpecNo").val(), $("#RoomRecordID").val(), $("#RoomID").val(), $("#PAADM").val(),SpecNoType)
	$("#CheckInfo").val(ret);


}



function Find() {

	var PAADM = $("#PAADM").val();
	var SpecNo = $("#SpecNo").val();
	var RegNo = $("#RegNo").val();
	if ((vRoomRecordID == "") && (SpecNo == "") && (PAADM == "")) {
		$.messager.alert('��ʾ', '��ǰ�����ߺͱ걾�Ų��ܶ�Ϊ��', "info");
		return false;
	}
	var RoomID = $("#RoomID").val();
	if (RoomID == "") {
		vRoomRecordID = "";

	}
   
	$("#SaveCollectSpecGrid").datagrid('load', {
		ClassName: "web.DHCPE.BarPrint",
		QueryName: "FindOItemStatusForSpecNo",
		SpecNo: $.trim($("#SpecNo").val()),
		RoomRecordID: $("#RoomRecordID").val(),
		RoomID: $("#RoomID").val(),
		PAADM: $("#PAADM").val(),
		RegNo: $("#RegNo").val(),
		HospID:session['LOGON.HOSPID'],
		SpecNoType:SpecNoType,
		SessionStr:SessionStr
	})

}


//ȫ��ȡ��
function BSARef_Click() {
	var rrows = $('#SaveCollectSpecGrid').datagrid("getRows");
	for (var i = 0; i < rrows.length; i++) {
		var Refuse = rrows[i].TRefuse;
		var ID = rrows[i].TSpecNo;
		if (Refuse == "����") {
			RefuseApp(ID)
		}
	}

}

//ȫ������
function BSRRef_Click() {
	var rrows = $('#SaveCollectSpecGrid').datagrid("getRows");
	for (var i = 0; i < rrows.length; i++) {
		var Refuse = rrows[i].TRefuse;
		var ID = rrows[i].TSpecNo;
		if (Refuse == "ȡ��") {
			RefuseApp(ID)
		}
	}
}


function RefuseApp(ID) {

	var ret = tkMakeServerCall("web.DHCPE.BarPrint", "RefuseItemBySpecNo",ID,SessionStr);
	if (ret == "0") {
		$("#SaveCollectSpecGrid").datagrid('load', {
			ClassName: "web.DHCPE.BarPrint",
			QueryName: "FindOItemStatusForSpecNo",
			SpecNo: $.trim($("#SpecNo").val()),
			RoomRecordID: $("#RoomRecordID").val(),
			RoomID: $("#RoomID").val(),
			PAADM: $("#PAADM").val(),
			RegNo: $("#RegNo").val(),
			HospID:session['LOGON.HOSPID'],
			SpecNoType:SpecNoType,
			SessionStr:SessionStr
		})
	}
}

//��������
function ShowSoftKey_click() {
	//var shell = new ActiveXObject("wscript.shell")
	//shell.run("osk.exe");
	location.replace("tabkey:");
	return false;
}

//��ӡ
function BPrint_Click() {
	
	if(SpecNoType=="" ){
		SpecNoType="Ѫ";
	}
	
	//BloodFlag:2 Ѫ,1 ��Ѫ,�� ���б걾����
	var BloodFlag="";
	if(SpecNoType.indexOf("Ѫ")>-1){
		var BloodFlag="2"; 
	}else if((SpecNoType.indexOf("��")>-1)||(SpecNoType.indexOf("��")>-1)){
		var BloodFlag="1";
	}else{
		var BloodFlag="";
	}

	//var PAADM = "";
	var PAADM = $("#PAADM").val();
	var PrintBarFlag = 0;
	var PrintBarCode = $("#PrintBarCode").checkbox('getValue');
	if (PrintBarCode) { var PrintBarFlag = 1;}
    if (PrintBarFlag!==1) return ;
    
 	var RegNo = $("#RegNo").val();   
	var SpecNo = $("#SpecNo").val();
	var LocID=session['LOGON.CTLOCID'];
	var SpecOneFlag=tkMakeServerCall("web.DHCPE.HISUICommon","GetSettingByLoc",LocID,"CollectSpecOne");

/*
	if (SpecNo==""){ var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDate", RegNo);}
	else {var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDate", SpecNo);}
	var Arr = Value.split("^");
	var PAADM = Arr[2];
*/
   if (RegNo==""){
		$.messager.alert("��ʾ", "�걾�Ų���Ϊ��", "info");
		return false;
	}else{
		if (SpecNo!==""){
			if (SpecOneFlag=="Y"){
				PrintAllApp(SpecNo, "Spec", "N","",BloodFlag)
			}else{
				PrintAllApp(PAADM, "PAADM", "N","",BloodFlag)
			}
			
		}else{
			PrintAllApp(PAADM, "PAADM", "N","",BloodFlag)
		}
	}
  
}

function InitSaveCollectSpecGrid() {
	$HUI.datagrid("#SaveCollectSpecGrid", {
		url: $URL,
		fit: true,
		striped: true,
		fitColumns: false,
		autoRowHeight: false,
		rownumbers: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		pageList: [20, 100, 200],
		singleSelect: true,
		selectOnCheck: true,
		queryParams: {
			ClassName: "web.DHCPE.BarPrint",
			QueryName: "FindOItemStatusForSpecNo",
			SpecNoType:SpecNoType,
			SessionStr:SessionStr
		},
		onClickRow: onClickRow,
		onAfterEdit: function(index, row, changes) {
			
		//$('#SaveCollectSpecGrid').datagrid('endEdit', editIndex); //���һ�н����б༭ 
			modifyAfterRow = $('#SaveCollectSpecGrid').datagrid('getRows')[index]['TRefuse'] 
			//alert(modifyBeforeRow+"^"+modifyAfterRow)
			if(modifyBeforeRow!=modifyAfterRow){
				$.messager.confirm('ȷ��', 'ȷ��Ҫ����������', function(t) {
				if (t) { 
					var ret=tkMakeServerCall("web.DHCPE.BarPrint","RefuseItemBySpecNo",row.TSpecNo,SessionStr);
					if(ret=="0"){
						$("#SaveCollectSpecGrid").datagrid('load',{
							ClassName:"web.DHCPE.BarPrint",
							QueryName:"FindOItemStatusForSpecNo",
							SpecNo:$.trim($("#SpecNo").val()),
							RoomRecordID:$("#RoomRecordID").val(),
							RoomID:$("#RoomID").val(),
							PAADM:$("#PAADM").val(),
							RegNo:$("#RegNo").val(),
							SpecNoType:SpecNoType,
							SessionStr:SessionStr
						})
					}
				}
			})
		
			}


		},
		onLoadSuccess: function(data) {
			editIndex = undefined;
		},
		columns: [
			[

				{
					field: 'TOEORIRowId',
					title: 'OEORIRowId',
					hidden: true
				}, {
					field: 'TOEORIItmMastDR',
					title: 'ItmMastDR',
					hidden: true
				}, {
					field: 'TAdmId',
					title: 'PAADM',
					hidden: true
				}, {
					field: 'TPlacerColor',
					width: '100',
					title: '������ɫ',
					styler: function(value, row, index) {
						return 'background-color:' + row.TPlacerColor;
					}

				}, {
					field: 'TPlacerCode',
					width: '100',
					title: '��������'
				}, {
					field: 'TItemName',
					width: '200',
					title: 'ҽ��'
					
				}, {
					field: 'TSpecName',
					width: '100',
					title: '�걾����'
				}, {
					field: 'TSpecNo',
					width: '150',
					title: '�걾��'
				}, {
					field: 'TRegNo',
					width: '120',
					title: '�ǼǺ�'
				}, {
					field: 'TName',
					width: '100',
					title: '����'
				}, {
					field: 'TDate',
					width: '100',
					title: '����'
				}, {
					field: 'TTime',
					width: '100',
					title: 'ʱ��'
				}, {
					field: 'TUserName',
					width: '80',
					title: '�ɼ���'
				}, {
					field: 'TOSTATDesc',
					width: '80',
					title: 'ҽ��״̬'
				},{
					field: 'TRefuse',
					width: '80',
					title: '״̬',
					editor: {
						type: 'switchbox',
						options: {
							onClass: 'primary',
							offClass: 'gray',
							onText: '����',
							offText: 'ȡ��'
						}
					}
				}, {
					field: 'TPlacesNo',
					width: '60',
					title: 'Ԥ�ƺ�'
				},{

					field: 'TSex',
					width: '60',
					title: '�Ա�'
				}, {
					field: 'TAge',
					width: '60',
					title: '����'
				}


			]
		],

		rowStyler: function(index, row) {

			if (row.TOSTATDesc == "л�����") {
				return 'background-color:#fff3dd;';
			}



		},
		onSelect: function(rowIndex, rowData) {


		}


	})

}




//�б��༭
var editIndex = undefined;
var modifyBeforeRow = "";
var modifyAfterRow = "";

//�����б༭
function endEditing() {

	if (editIndex == undefined) {
		return true
	}
	if ($('#SaveCollectSpecGrid').datagrid('validateRow', editIndex)) {

		$('#SaveCollectSpecGrid').datagrid('endEdit', editIndex);



		editIndex = undefined;
		return true;
	} else {
		return false;
	}

}

//���ĳ�н��б༭
function onClickRow(index, value) {
	if (editIndex != index) {
		if (endEditing()) {
			$('#SaveCollectSpecGrid').datagrid('selectRow', index)
				.datagrid('beginEdit', index);
			editIndex = index;
			modifyBeforeRow = $('#SaveCollectSpecGrid').datagrid('getRows')[index]['TRefuse']

		} else {
			$('#SaveCollectSpecGrid').datagrid('selectRow', editIndex);
		}


	}

}



function SpecNo_Click() {
	var vStatus = "",
		vDetailStatus = "",
		ReturnValue = "";

	var SpecNo = $("#SpecNo").val();
	if (SpecNo == "") {
		$.messager.popover({
			msg: "�걾�Ų���Ϊ��",
			type: "info"
		});
		return false;
	}
     //�ж�����ı걾���ǲ��ǰ����ڸòɼ�����ά����������
    var Flag=tkMakeServerCall("web.DHCPE.BarPrint", "IsCanSaveSpec",SpecNo,SpecNoType);
    if(Flag=="0"){
	    $.messager.popover({
			msg: "����ı걾�Ų��ڸý���ɼ������ʵ��",
			type: "info"
		});
		return false;
	    
    }else{
	    if (Flag!="1"){
		     $.messager.popover({
				msg: Flag,
				type: "info"
			});
			return false;
		    
	    }
	    
    }


	var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDateBySpecNo", SpecNo);
	//alert(Value)
	var Arr = Value.split("^"); 
		var PAADM = Arr[2];
		$("#PAADM").val(Arr[2]);
		GetSaveCollectByPAADM(PAADM); 
		
}



function RegNo_Click()
{
	var CTLocID=session['LOGON.CTLOCID'];
	var iRegNo=$("#RegNo").val(); 
	if(iRegNo!="") {
	 	var iRegNo=$.m({
			"ClassName":"web.DHCPE.DHCPECommon",
			"MethodName":"RegNoMask",
            "RegNo":iRegNo,
			"CTLocID":CTLocID
		}, false);
		
			$("#RegNo").val(iRegNo)
		} 
		if (iRegNo=="") 
	   {
			$.messager.popover({msg: "������ǼǺ�", type: "info"});
		   return false;
	   }
	   
		var PAADMS=tkMakeServerCall("web.DHCPE.BarPrint","GetSaveCollectRecord",iRegNo);
		//alert(PAADMS)
		if (PAADMS.split("^")[0]!="0"){
			//alert(PADMS.split("^")[1]);
			$.messager.popover({msg: PAADMS.split("^")[1], type: "info"});
			return false;
		}
		var PAADM=PAADMS.split("^")[1];
		if (PAADM==""){
			$.messager.popover({msg: "û��Ҫ�ɼ��걾�ļ�¼", type: "info"});
			return false;
			}
		var PAADMArr=PAADM.split("$");
		
		if (PAADMArr.length>2){
           openPAADMRecord(iRegNo)
   
		}else{
			GetSaveCollectByPAADM(PAADMArr[0]);
			
	}
		
}


var openPAADMRecord= function(RegNo){
    
    $("#PAADMRecordWin").show();
    
    $HUI.window("#PAADMRecordWin",{
        title:'�����б�',
        minimizable:false,
        collapsible:false,
        modal:true,
        width:930,
        height:400
    });
    
    var PAADMLisObj = $HUI.datagrid("#PAADMRecordList",{
        url:$URL,
        queryParams:{
            ClassName:"web.DHCPE.BarPrint",
            QueryName:"FindPAADMInfo",
            RegNo:RegNo, 
			HospID:session['LOGON.HOSPID']
        },
        columns:[[
        	{field:'PAADM',title:'PAADM',hidden:true},
            {field:'Name',width:120,title:'����'},
            {field:'RegNo',width:120,title:'�ǼǺ�'},
            {field:'HPNo',width:120,title:'�����'},
            {field:'AdmDate',width:100,title:'����'},
            {field:'StatusDesc',width:100,title:'״̬'},
            {field:'GName',width:200,title:'��������'},
            {field:'TeamName',width:120,title:'��������'},
        ]],
        pagination:true,
        displayMsg:"",
        pageSize:20,
        fit:true,
        onDblClickRow: function(rowIndex,rowData){
	          $("#SpecNo").val("");
	           GetSaveCollectByPAADM(rowData.PAADM);
	 
  				}
        
        })
    
}


function GetSaveCollectByPAADM(PAADM){
		var vStatus = "",vDetailStatus = "",ReturnValue = "";
		$("#PAADM").val(PAADM);
			var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByPAADM", PAADM);
			var AdmArr = Status.split("^");
			var PIADM = AdmArr[1];
			//alert(Status)
		if (PIADM == "") {
				return false;
			}
		if (AdmArr[0] == "REGISTERED") {
			$.messager.confirm("ȷ��", "ȷ��Ҫ������", function(r) {
				if (r) {
					$.m({
						ClassName: "web.DHCPE.DHCPEIAdm",
						MethodName: "UpdateIADMInfo",
						PreIADMID: PIADM,
						Type: 3
					}, function(ReturnValue) {
						if (ReturnValue != '0') {
							var Status = tkMakeServerCall("web.DHCPE.PreIADM", "GetStatusByPAADM", PAADM);
							if(Status.split("^")[0]!="ARRIVED"){
								$.messager.alert("��ʾ", "����ʧ��", "error");
								return false;
							}
						}else{
							SaveCollectByPAADM(PAADM);		
						}
					});
				}
			});

	}else{
		SaveCollectByPAADM(PAADM);
	}
}


function SaveCollectByPAADM(PAADM)
{	
	var vStatus = "",vDetailStatus = "",ReturnValue = "";
	var Value = tkMakeServerCall("web.DHCPE.BarPrint", "IsCurDateByPAADM", PAADM);
	//alert(Value)
	var Arr = Value.split("^");
	if (Arr[0] == "0") {
		$.messager.popover({msg: Arr[1],type: "info"});
		return false;
	} else if (Arr[0] == "1") {

		$.messager.confirm("ȷ��", "�ñ걾����߲��ǵ��쵽��,�Ƿ�����걾�˶�?", function(r) {
			if (r) {
				var RoomID = $("#RoomID").val();
				if (RoomID != "") {

					var CurRoomID = Value.split("^")[1];
					vStatus = Value.split("^")[4];
					vDetailStatus = Value.split("^")[5];
					if ((CurRoomID != vRoomRecordID) && (vRoomRecordID != "")) //
					{
						if (!confirm("�����ߺͽк��߲���ͬһ����,�Ƿ����?")) return false;

					} else if (vRoomRecordID == "") {
						if (!confirm("û�нк�,�Ƿ����?")) return false;
					}
				}
				//parent.vRoomRecordID="";
				vRoomRecordID = CurRoomID;
				if (vStatus == "N") { //�ж��ǲ���ͬһ����
					if (vDetailStatus != "E") { //��������״̬�ģ��������죬����
						var UserID = session['LOGON.USERID'];
						var ret = tkMakeServerCall("web.DHCPE.RoomManager", "ArriveCurRoom", vRoomRecordID, UserID, RoomID);

					}
				}
                
				Init();
				Find();
				BPrint_Click();

			}
		});

		
	} else {

		var RoomID = $("#RoomID").val();
		if (RoomID != "") {
			var CurRoomID = Value.split("^")[1];
			vStatus = Value.split("^")[4];
			vDetailStatus = Value.split("^")[5];
			if ((CurRoomID != vRoomRecordID) && (vRoomRecordID != "")) //
			{
				if (!confirm("�����ߺͽк��߲���ͬһ����,�Ƿ����?")) return false;

			} else if (vRoomRecordID == "") {
				if (!confirm("û�нк�,�Ƿ����?")) return false;
			}
		}
		//parent.vRoomRecordID="";
		vRoomRecordID = CurRoomID;
		if (vStatus == "N") { //�ж��ǲ���ͬһ����
			if (vDetailStatus != "E") { //��������״̬�ģ��������죬����
				var UserID = session['LOGON.USERID'];
				var ret = tkMakeServerCall("web.DHCPE.RoomManager", "ArriveCurRoom", vRoomRecordID, UserID, RoomID);

			}
		}

		Init();
		Find();
		BPrint_Click();
	}
	
}