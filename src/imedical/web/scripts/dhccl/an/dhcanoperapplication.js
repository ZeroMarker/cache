var dhccl={
	/*
	��ȡurl���ݵĲ���ֵ
	*/
	getUrlParam:function(name)
	{
		var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
        var r = window.location.search.substr(1).match(reg);
        if (r != null) return unescape(r[2]);
        return null;
	}	
}
var EpisodeID=dhccl.getUrlParam("EpisodeID"),
    opaId=dhccl.getUrlParam("opaId");
    var appType="ward";
    var reg=/^[0-9]+.?[0-9]*$/;
    var logUserId=session['LOGON.USERID'],
    logGroupId=session['LOGON.GROUPID'],
    logLocId=session['LOGON.CTLOCID'];
var curLogLoc="";
var operloadflag=0;
var applocid="";
var applocdesc="";
//var starttime=new Date(); 
$(function(){
	//alert("���ؿ�ʼ"+(starttime2-starttime)) 
    initPatientsList();
    initPrevDiagnosGrid();
    initOperationGrid();
    initDataFormControls();	//��������ҳ��Ԫ�س�ʼ��
    initOperDelegates();
    var curLogLocStr=$.m({
            ClassName:"web.DHCANOPArrangeDayOper",
            MethodName:"GetCtlocDescById",
            ctlocId:logLocId
        },false);
     curLogLoc=curLogLocStr.split("!")[1];
    if((EpisodeID!="")&&(opaId==""))
    {
	    loadDatas();
	 //�û�û������Ȩ�ޣ���������
    var ifCanAppOper=$.m({
            ClassName:"web.DHCClinicCom",
            MethodName:"CheckIfAppLoc",
            ctlocId:session['LOGON.CTLOCID']
        },false);
     if(ifCanAppOper==0)
     {
	     $.messager.alert("��ʾ","�ÿ���û����������Ȩ��,����ϵ��Ϣ�������Ȩ��","error");
	     $("#btnSave").linkbutton('disable');
     }

    if(checkIfOutTime())
    {
        $.messager.alert("��ʾ","��������ʱ�����ƣ�������������������","error");
        $("#btnSave").linkbutton('disable');
    }

    }
    else if((opaId!=null)&&(opaId!="")&&(EpisodeID!=""))
    {
        disablePatientsList();
        loadDatas();
    }
   //var finishtime=new Date(); 
	//$.messager.alert("��ʾ","end:"+(finishtime-starttime),"info")
});
//��ʼ�������б�
function initPatientsList(){
	
    //$("#SearchLoc").next(".combo").find(".combo-text").prop("placeholder", "����");
    //$("#SearchWard").next(".combo").find(".combo-text").prop("placeholder", "����");
    //����Ĭ�ϵ�¼����
    $HUI.combobox("#SearchLoc",{});
    var patientLoc=$HUI.combobox("#SearchLoc",{
        //url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param)
        {
            param.desc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.EpisodeID="";
        }  
        ,  onSelect:function()
        {
	        $("#SearchWard").combobox('setValue',"");
        } ,
        onChange:function()
        {
	        patientsList.load();
        }
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		}
    });   
     $HUI.combobox("#SearchWard",{});
    //����
    var patientWard=$HUI.combobox("#SearchWard",{
        //url:$URL+"?ClassName=web.DHCClinicCom&QueryName=GetWard&ResultSetType=array",
        valueField:"rw",
        textField:"desc",
        onBeforeLoad:function(param)
        {
            param.code=param.q;
        },
         onSelect:function()
        {
	        $("#SearchLoc").combobox('setValue',"");
        },
        onChange:function()
        {
	        patientsList.load();
        }
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCClinicCom&QueryName=GetWard&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        mode:'remote'
        
    });
      //�����б�
    var patientsList=$HUI.datagrid("#patientsList",{
        border:true,
        fit:true,
        singleSelect: true,
        showHeader:false,
        headerCls:'panel-header-gray',
        pagination: true,
        url:$URL,
        displayMsg:'',
        howRefresh: false,
        showPageList: false,
        border:false,
        queryParams:{
            ClassName: "web.DHCDocInPatientList",
            QueryName: "FindLocDocCurrentAdm"
        },
        onBeforeLoad: function(param) {
            var patientNo = $("#patientNo").val();
            //$("#patientNo").searchbox('getValue');
            param.LocID =$("#SearchLoc").combobox('getValue');
            param.UserID = session['LOGON.USERID'];
            param.IPAddress = "";
            param.AllPatient = "on";
            param.PatientNo = patientNo;
            param.SurName = "";
            param.StartDate = "";
            param.EndDate = "";
            param.ArrivedQue = "on";
            param.RegQue = "";
            param.MedUnit = "on";
            param.PACWard = $("#SearchWard").combobox('getValue');
            param.BedId = "";
        },
        columns: [
            [{
                    field: 'PAPMINO',
                    title: '�����б�',
                    width: 268,
                    formatter: function(value, row, index) {
                        var retArray = [];
                        retArray.push("<div class='patlist-item'><span>" + row.PAPMIName + "</span>");
                        retArray.push("<span>" +"ID:"+ value + "</span></div>");
                        retArray.push("<div class='patlist-item'><span>" + row.PAPMISex + "/" + row.Age + "</span>");
                        retArray.push("<span>" + row.PAAdmWard + "</span></div>");
                        return retArray.join("");
                    }
                },
                { field: 'PatientID', title: 'PatientID', width: 55, hidden: true },
                { field: 'EpisodeID', title: 'EpisodeID', width: 80, hidden: true },
                { field: 'PAAdmBed', title: '��λ', width: 60, hidden: true },
                { field: 'PAPMIName', title: '����', width: 80, hidden: true },
                { field: 'PAPMISex', title: '�Ա�', width: 40, hidden: true },
                { field: 'Age', title: '����', width: 60, hidden: true },
                { field: 'PAAdmDepCodeDR', title: '����', width: 110, hidden: true },
                { field: 'PAAdmWard', title: '����', width: 130, hidden: true }

            ]
        ],
         onSelect: function(rowIndex, rowData) {
	        if((opaId!=null)&&(opaId!="")){
                $('#patientsList').datagrid('unselectRow',rowIndex);
		    	$.messager.alert("��ʾ","�޸���������ʱ�������л����ߣ�","error");
		    	return;    
		    }
            EpisodeID = rowData.EpisodeID;
            if (EpisodeID && (EpisodeID != "")) {
                loadDatas();
                 if(checkIfOutTime())
    			{
        			$.messager.alert("��ʾ","��������ʱ�����ƣ�������������������","error");
        			$("#btnSave").linkbutton('disable');
    			}
            }
        },
        onLoadSuccess: function(data) {
            $(".searchlist").find(".searchlisttitle").find("span").html(data.total);
            var panel = $(this).datagrid('getPanel');
                    var tr = panel.find('div.datagrid-body tr');
                    tr.each(function () {
                        var td = $(this).children('td');
                        td.css({
                            "border-width": "0 0 1px 0"
                        });
                        });
        }
    }); 
       var curLogLocStr=$.m({
            ClassName:"web.DHCANOPArrangeDayOper",
            MethodName:"GetCtlocDescById",
            ctlocId:logLocId
        },false);
     curLogLoc=curLogLocStr.split("!")[1];
 
	$("#SearchLoc").combobox("setValue",logLocId);
     $("#SearchLoc").combobox("setText",curLogLoc);


}

/// ��ʼ����ǰ����б����
function initPrevDiagnosGrid() {
    var preopDiagBox=$HUI.datagrid("#preopDiagBox",{
        height:80,
        fit:true,
        singleSelect:true,
        rownumbers:true,
        showHeader:false,
        headerCls:'panel-header-gray',
        toolbar:"#preopDiagTool",
        columns: [
            [
                { field: "DiagID", title: "ID",  hidden: true },
                { field: "DiagDesc", title: "����", width: 600 }
            ]
        ]
    })
}

///��ʼ�������б����
function initOperationGrid(){
    var operationBox=$HUI.datagrid("#operationBox",{
        fit:true,
        singleSelect: true,
        rownumbers: true,
         headerCls:'panel-header-gray',
        toolbar: "#operationTool",
        columns: [
            [
                { field: "OperationDesc", title: "��������", width: 200 },
                { field: "OperClassDesc", title: "�����ּ�", width: 60 },
                { field: "BladeTypeDesc", title: "�п�����", width: 60 },
                { field: "SurgeonLocDesc", title: "���߿���", width: 80 },
                { field: "SurgeonDesc", title: "����", width: 50 },
                { field: "SurgonAss1Desc", title: "һ��", width: 50 },
                { field: "SurgonAss2Desc", title: "����", width: 50 },
                { field: "SurgonAss3Desc", title: "����", width: 50 },
                { field: "SurgonAssoDesc", title: "����", width: 50 },
                { field: "OperNote", title: "���Ʊ�ע", width: 80 },
                { field: "SurgeonLoc", title: "���߿���Id", width: 1 ,hidden:true },
                { field: "Surgeon", title: "����id", width: 1 ,hidden:true },
                { field: "SurgonAss1", title: "һ��id", width: 1 ,hidden:true },
                 { field: "SurgonAss3", title: "����id", width: 1 ,hidden:true },
                 { field: "SurgonAsso", title: "����id", width: 1 ,hidden:true },
               { field: "SurgonAss2", title: "����id", width: 1 ,hidden:true },
              	{ field: "BladeType", title: "�����ּ�Id", width: 1 ,hidden:true },
                 { field: "OperClass", title: "�����ּ�Id", width: 1 ,hidden:true },
                 { field: "Operation", title: "��������Id", width: 1, hidden: true },
                  { field: "OpSub", title: "OpSub", width: 1, hidden: true }	//20190118+dyl+8
         ]
        ],
        onSelect:function(rowIndex, rowData){
	        selectOperIndex=rowIndex;
        }
    });
}

//��ʼ�����ؼ�
function initDataFormControls() 
{
	$HUI.datebox("#OperDate",{});
	//$HUI.combobox("#AppLocation",{});
     var appLocobj=$HUI.combobox("#AppLocation",{
        //url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param)
        {
            param.desc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.EpisodeID="";
        } 
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		}   
    });
	//$HUI.combobox("#AppDoctor",{});
    var AppDoctor=$HUI.combobox("#AppDoctor",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.locDescOrId="";
            param.EpisodeID=EpisodeID;
            param.opaId=opaId;
            param.ifDoctor="Y";
            param.ifSurgeon="";
        }
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
    });
    //$HUI.combobox("#OperLocation",{});
    var OperLocation=$HUI.combobox("#OperLocation",{
        //url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        editable:false,
        onBeforeLoad:function(param){
            param.desc=param.q;
            param.locListCodeStr="OP^OUTOP^EMOP";
            param.EpisodeID=EpisodeID;
        }
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		}
    });
	//$HUI.combobox("#PrevAnaMethod",{});
    var PrevAnaMethod=$HUI.combobox("#PrevAnaMethod",{
        valueField: "ID",
        textField: "Des",
        rowStyle:'checkbox',
        editable:false,
        panelWidth:300,
        //required: $("#IsAnaest").combobox("getValue") === "Y" ? true : false,
        multiple: true
        //data:getAnaestMethods()
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindAnaestMethod&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
        
    });
	//$HUI.combobox("#diagnosis",{});
    var diagnosis=$HUI.combobox("#diagnosis",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=LookUpMrcDiagnosis&ResultSetType=array",
        valueField:"rowid0",
        textField:"DiagDes",
        onBeforeLoad:function(param){
            param.mrcidAlias=param.q;
        }
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=LookUpMrcDiagnosis&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        mode: "remote"
    });
	//$HUI.combobox("#OperPos",{});
    var operpos=$HUI.combobox("#OperPos",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetOperPosition&ResultSetType=array",
        valueField:"OPPOS_RowId",
        textField:"OPPOS_Desc",
        onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetOperPosition&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        editable:false
    });
    //$HUI.combobox("#BodySite",{});
    var bodysite=$HUI.combobox("#BodySite",{
        valueField: "BODS_RowId",
        textField: "BODS_Desc",
        multiple: true,
        rowStyle:'checkbox',
        selectOnNavigation:false,
        editable:false
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindBodySite&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
        //data:getBodySites()
        /*onShowPanel:function(){
            var datas=$(this).combobox('getData');
            if(!datas||datas.length<=0)
            {
                datas=getBodySites();
                $(this).combobox('loadData',datas);
            }
        }*/
    });

    //$HUI.combobox("#BloodType",{});
        var bloodtype=$HUI.combobox("#BloodType",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetBlood&ResultSetType=array",
        valueField:"BLDTRowId",
        textField:"BLDTDesc",
        editable:false,
         panelHeight:'auto',
         allowNull:true,
        data:getBloodTypeItems()
        ,onShowPanel : function(){
	        /*
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetBlood&ResultSetType=array";
       		$(this).combobox('reload');
    		}
    	*/	
  		}
         
    });
 	//$HUI.combobox("#RHBloodType",{});
    var rhbloodtype=$HUI.combobox("#RHBloodType",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=RHBlood&ResultSetType=array",
        valueField:"RHId",
        textField:"RHDesc",
        editable:false,
        allowNull:true,
        //data:getRHBloodTypeItems()
       data:[{'RHDesc':"����",'RHId':"1"}
       ,{'RHDesc':"����(-)",'RHId':"2"}
       ,{'RHDesc':"����(+)",'RHId':"3"}
       ]
    });
    //$HUI.combobox("#HbsAg,#HcvAb,#HivAb,#Syphilis",{});
    $HUI.combobox("#HbsAg,#HcvAb,#HivAb,#Syphilis",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"ord",
        textField:"typ",
        panelHeight:'auto',
        editable:false,
        rowStyle:'checkbox',
        //data:getLabTestItems()
        data:[{'typ':"����",'ord':"1"},{'typ':"����(-)",'ord':"2"}
        ,{'typ':"����(+)",'ord':"3"},{'typ':"������",'ord':"4"}
        ]
    });
    //$HUI.combobox("#OperType",{});
        var OperType=$HUI.combobox("#OperType",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"����",'typecode':"B"},{'typedesc':"����",'typecode':"E"}]
    });
    //$HUI.combobox("#ReentryOperation,#IsAnaest",{ });
    
    var yesno=$HUI.combobox("#ReentryOperation",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        data:[{'typedesc':"��",'typecode':"Y"},{'typedesc':"��",'typecode':"N"}]
    }); 
    var yesno=$HUI.combobox("#IsAnaest",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        panelHeight:'auto',
        onSelect:function(record){
	          setPrevAnaMethodIsRequired();
	                        },
        data:[{'typedesc':"��",'typecode':"Y"},{'typedesc':"��",'typecode':"N"}]
    }) 
    var timeinit=$HUI.timespinner("#OperTime",{ 
    });
    //$HUI.numberspinner("#PlanSeq",{});
    var numinit=$HUI.numberspinner("#PlanSeq",{ 
      min: 1,    
    max: 30,    
    editable: true  
    }); 

     var numinit2=$HUI.numberspinner("#OperDuration",{ 
      min: 0.1,    
    max: 30, 
    precision:1,   
    editable: true  
    }); 
	//20191024+dyl
	/*
	    var material=$HUI.combobox("#MaterialMem",{
        valueField: "CssdId",
        textField: "CssdPack",
        multiple: true,
        rowStyle:'checkbox',
        selectOnNavigation:false,
        editable:false
        ,onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       		$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCSSDPack&ResultSetType=array";
       		$(this).combobox('reload');
    		}
  		}
        
    });
    */


}

/// ��ʼ�������¼�
function initOperDelegates() {
    $("#btnAddDiag").linkbutton({
        onClick: addPrevDiagnos
    });

    $("#btnDelDiag").linkbutton({
        onClick: removePrevDiagnos
    });

    $("#btnAddOperation").linkbutton({
        onClick: addAnaestOperation
    });

    $("#btnEditOperation").linkbutton({
        onClick: editAnaestOperation
    });

    $("#btnDelOperation").linkbutton({
        onClick: removeAnaestOperation
    });

    $("#btnSave").linkbutton({
        onClick: saveOperApplication
    });

     $("#btnCancel").linkbutton({
        onClick: closeWindow
    });
}

//����Ƿ�����������ʱ��
function checkIfOutTime(){
    var result=false;
    var admType=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetAdmType",
        admId:EpisodeID
    },false);
    var ifDisbled=$.m({
        ClassName:"web.DHCANOPArrangeHISUI",
        MethodName:"GetIfOutTime"
    },false)
    if((ifDisbled==1)&&((opaId=="")||(opaId==null))&&(admType!="E"))
    {
        result=true
    }
    return result;
}

//��������
function loadDatas(){
	$("#btnSave").linkbutton('enable');
    var patInfo=getPatInfo();
    var appList=patInfo.split("@");
    	
    if((opaId==null)||(opaId==""))
    {
	    initAppForm();
	    var tmpLocId=session['LOGON.CTLOCID'];
        var checkinbedflag=$.m({
            ClassName:"web.DHCANOPArrange",
            MethodName:"CheckInBedFlag",
            adm:EpisodeID
        },false);
        if(checkinbedflag=="N")
		 {
			 $.messager.alert("��ʾ","������δ���Ŵ�λ","error");
             $("#btnSave").linkbutton('disable');
		 }
        var checkDisflag=$.m({
            ClassName:"web.DHCANOPArrange",
            MethodName:"CheckDISFlag",
            Adm:EpisodeID
        },false);
        if(checkDisflag=="Y")
		 {
		 	 $.messager.alert("��ʾ","�û������г�Ժ���,������������","error");
             $("#btnSave").linkbutton('disable');
		 }
		 //���տ���
		 var checkAppData=$.m({
            ClassName:"web.DHCANOPArrangeHISUI",
            MethodName:"CheckAppData",
            EpisodeID:EpisodeID
        },false);
	  var n=checkAppData.split("!").length
	  var itmStr=checkAppData.split("!")
	  for(i=0;i<n;i++)
	  { 
	    var itm=itmStr[i].split("^")[0];
	    var itmCtr=itmStr[i].split("^")[1];
	    if((itmCtr==1)&(appType=="ward")&(opaId==""))
	    {
				 $.messager.alert("��ʾ",itm+"δ���!","error");
	            $("#btnSave").linkbutton('disable');

	    }
			if((itmCtr==2)&(appType=="ward")&(opaId=="")) 
			{
			$.messager.alert("��ʾ",itm+"δ���!","warning");
			}
			if((itmCtr==3)&(appType=="ward")&(opaId=="")) 
			{
				$.messager.alert("��ʾ",itm+"Σ��ֵ","warning");
			}
      }	  

		 //
         var opSetInfoStr=$.m({
            ClassName:"web.DHCANOPCom",
            MethodName:"GetOpSetInfo"
        },false);
        var opSetInfo=opSetInfoStr.split("^");
        var IfInsertLabInfo=opSetInfo[1];
        if(IfInsertLabInfo=="Y")
        {
            getLabInfo();
        }
       
    }
    else{
        loadQTData(opaId);
        loadOperList(opaId);
    }
    loadOperData(appList);
}
//�л��ߺ��ʼ��������Ϣ
function initAppForm()
{
	$("#BloodType").combobox("setValue","");
   $("#RHBloodType").combobox("setValue","");
   $("#HbsAg").combobox("setValue","");
   $("#HcvAb").combobox("setValue","");
   $("#HivAb").combobox("setValue","");
   $("#Syphilis").combobox("setValue","");
   $("#HbsAg").combobox("setValue","");
   $("#HbsAg").combobox("setValue","");
   $("#OperType").combobox('setValue',"B");
   $("#IsAnaest").combobox('setValue',"");
   $("#ReentryOperation").combobox('setValue',"");
   $("#IsoOperation").checkbox('setValue',false);
   $("#PrepareBlood").checkbox('setValue',false);
   $("#TransAutoblood").checkbox('setValue',false);
   $("#ECC").checkbox('setValue',false);
   $("#LabTest").val("");
   $("#PrevAnaMethod").combobox('setValues','')
   $("#OperPos").combobox("setValue","");
	initOperationGrid();
	var ndatas=[];
	 $("#operationBox").datagrid('loadData',ndatas);
	initPrevDiagnosGrid();
}
//���ػ��߻�����Ϣ
function loadOperData(appList)
{
    var opDateTime=appList[4];
    var opDateTimeList=opDateTime.split("^");
    //���߻�����Ϣ
	var patBaseInfo=appList[0];
	var baseInfoList=patBaseInfo.split("^");
    //$("#PatName").val(baseInfoList[1]);
    $("#PatName").prop("innerText",baseInfoList[1]);
    //$("#RegNo").val(baseInfoList[2]);
    $("#RegNo").prop("innerText",baseInfoList[2]);
    //$("#PatGender").val(baseInfoList[3]);
    var PatGender=baseInfoList[3]
    $("#PatGender").prop("innerText",baseInfoList[3]);
    //$("#PatAge").val(baseInfoList[4]);
    $("#PatAge").prop("innerText",baseInfoList[4]);
    
    $("#PatLoc").prop("innerText",baseInfoList[5]);
    $("#AdmReason").prop("innerText",baseInfoList[8]);
    $("#PatSecret").prop("innerText",baseInfoList[9]+baseInfoList[10]);
    $("#PatWard").prop("innerText",baseInfoList[6]);
    //$("#PatBedNo").val(baseInfoList[7]);
    $("#PatBedNo").prop("innerText",baseInfoList[7]);
    $("#patSeximg").prop("innerText","");
    if(PatGender=="��"){
			var imghtml="<img src='../images/man.png' alt='' style='margin-top:-5px;'/>"
			$("#patSeximg").append(imghtml)
		}else if(PatGender=="Ů"){
			var imghtml="<img src='../images/woman.png' alt='' style='margin-top:-5px;'/>";
			$("#patSeximg").append(imghtml)
		}
		   

    var admDisChargeFlag=baseInfoList[11];
	if(admDisChargeFlag=="Y") 
	{
        $.messager.alert("��ʾ","�û�����ҽ�ƽ���,�޷�����������","error");
        $("#btnSave").linkbutton('disable');
    }
    
	var patWardInfo=appList[1];
	var wardInfoList=patWardInfo.split("^");
	var operLoc=wardInfoList[0];
    loadCombobox("#OperLocation",operLoc);
    var appLoc=wardInfoList[1];
    //loadCombobox("#AppLocation",appLoc);
    applocid=appLoc.split("!")[0];
    applocdesc=appLoc.split("!")[1];
    $("#AppLocation").combobox("setValue",applocid);
    $("#AppLocation").combobox("setText",applocdesc);
    
   // $HUI.combobox("#AppLocation").setValue(applocid);
    
    var appDoc=wardInfoList[2];
    //loadCombobox("#AppDoctor",appDoc);
    $("#AppDoctor").combobox("setValue",appDoc.split("!")[0]);
    $("#AppDoctor").combobox("setText",appDoc.split("!")[1]);
    var operDate=opDateTimeList[0];
    //alert(operDate)
    $("#OperDate").datebox('setValue',operDate);
    var operTime=opDateTimeList[1];
    if(operTime!="")
    {
	    $("#OperTime").timespinner({
                required: false
            });
    }
    $("#OperTime").timespinner('setValue',operTime);
    var operDuration=opDateTimeList[7];
    $("#OperDuration").numberspinner('setValue',operDuration);
    var preDiagAndNotes=wardInfoList[3];
    var preDiag=preDiagAndNotes.split("#")[0];
    setDefaultPrevDiagnos(preDiag);
    var preDiagMen=preDiagAndNotes.split("#")[1];
    $("#OperPreDiagMem").val(preDiagMen);
    var opmen=wardInfoList[8];
    $("#AreaOperMem").val(opmen);
    var opdocmem=wardInfoList[7];
    $("#SurgeonNote").val(opdocmem);
    var bodsList=wardInfoList[9];
    var bodsIdList=getIdStr(bodsList);
    if(bodsIdList!="") {
	    var bodsDescList=getDescStr(bodsList);
	    $("#BodySite").combobox('setValues',bodsIdList);
	    $("#BodySite").combobox('setText',bodsDescList);
	    }
    else{
	    $("#BodySite").combobox('setValues',"")
    }
    var operPosition=wardInfoList[10];
    loadCombobox("#OperPos",operPosition);
    var bloodType=wardInfoList[11]
    //alert(bloodType)
    if(bloodType!="")
    {
	    loadCombobox("#BloodType",bloodType);
    }
    var opSeq=wardInfoList[12]
    $("#PlanSeq").numberspinner('setValue',opSeq);

    var anaesInfo=appList[2]
    var anaesInfoList=anaesInfo.split("^");
    var anDocMethodStr=anaesInfoList[8];
    
     var anDocMethodIdStr=getIdStr(anDocMethodStr)
    var anDocMethodDescStr=getDescStr(anDocMethodStr)
    if(anDocMethodIdStr!="")
    {
    $("#PrevAnaMethod").combobox('setValues',anDocMethodIdStr);
    $("#PrevAnaMethod").combobox('setText',anDocMethodDescStr);
    }
}

function loadQTData(opaId){
   var operQTData=$.m({
            ClassName:"web.DHCANOPArrangeHISUI",
            MethodName:"GetQTData",
            opaId:opaId
        },false);
   var appOtherList=operQTData.split("$");
   var checkList=appOtherList[0].split("^");
   var RHBloodTypeDesc=checkList[6];
   loadComboboxByDesc("#RHBloodType",RHBloodTypeDesc);
   var HbsAgDesc=checkList[0];
   loadComboboxByDesc("#HbsAg",HbsAgDesc);
   var HcvAbDesc=checkList[1];
   loadComboboxByDesc("#HcvAb",HcvAbDesc);
   var HivAbDesc=checkList[2];
   loadComboboxByDesc("#HivAb",HivAbDesc);
   var RPRDesc=checkList[3];
   loadComboboxByDesc("#Syphilis",RPRDesc);
   var opType=checkList[4];
   if(opType==1) opType="E";
   else {
       opType="B";
   }
   $("#OperType").combobox('setValue',opType);
   var needAnaesthetist=checkList[11];
   $("#IsAnaest").combobox('setValue',needAnaesthetist);
   //alert(needAnaesthetist)
   if(needAnaesthetist=="N")
   {
	   $("#PrevAnaMethod").combobox({
                required: false
            });
            $("#PrevAnaMethod").combobox("disable");
   }
   var unPlanedOperFlag=checkList[15];
   $("#ReentryOperation").combobox('setValue',unPlanedOperFlag);
   var isolated=checkList[7];
   $("#IsoOperation").checkbox('setValue',isolated=="Y"?true:false);
   var isPrepareBlood=checkList[8];
   $("#PrepareBlood").checkbox('setValue',isPrepareBlood=="Y"?true:false);
   var isUseSelfBlood=checkList[9];
   $("#TransAutoblood").checkbox('setValue',isUseSelfBlood=="Y"?true:false);
   var isExCirculation=checkList[10];
   $("#ECC").checkbox('setValue',isExCirculation=="Y"?true:false);
   //var MaterialMem=checkList[17];	
   //20191024+dyl+���������嵥
  // $("#MaterialMem").val(MaterialMem);
  /*
       var MaterialMemStr=checkList[17];
    
     var materialIdStr=getIdStr(MaterialMemStr)
    var materialDescStr=getDescStr(MaterialMemStr)
    if(materialIdStr!="")
    {
    	$("#MaterialMem").combobox('setValues',materialIdStr);
    	$("#MaterialMem").combobox('setText',materialDescStr);
    }
*/
   
   
   var otherTest=checkList[5];
   $("#LabTest").val(otherTest);
}
function loadOperList(opaId)
{
    var operList=$.cm({
        ClassName:"web.DHCANOPArrange",
        QueryName:"GetOpList",
        opaId:opaId,
        ResultSetType:"array"
    },false);
    var datas=[];
    if(operList&&operList.length>0){
        for(var i=0;i<operList.length;i++)
        {
            var data={
                Operation:operList[i].operId,
                OperationDesc:operList[i].operDesc,
                OperClass:operList[i].opLevelId,
                OperClassDesc:operList[i].opLevelDesc,
                BladeType:operList[i].bldTpId,
                BladeTypeDesc:operList[i].bldTypeDesc,
                SurgeonLoc:operList[i].opdocLocId,
                SurgeonLocDesc:operList[i].opdocLoc,
                Surgeon:operList[i].surgeonId,
                SurgeonDesc:operList[i].surgeon,
                SurgonAss1:operList[i].Ass1Id,
                SurgonAss1Desc:operList[i].Ass1,
                SurgonAss2:operList[i].Ass2Id,
                SurgonAss2Desc:operList[i].Ass2,
                SurgonAss3:operList[i].Ass3Id,
                SurgonAss3Desc:operList[i].Ass3,
                SurgonAsso:operList[i].AssoId,
                SurgonAssoDesc:operList[i].Asso,
                OperNote:operList[i].operNotes,
                OpSub:operList[i].opSub	////20190118+dyl+3
            }
            datas.push(data);
        }
    }
    $("#operationBox").datagrid('loadData',datas);
}

//ѡ��������Ĭ���������ںͱ��水ť�Ƿ����
function setOperDateAndBtn(){
	var curOptype=$("#OperType").combobox("getValue");
    if(curOptype==="E")
    {
        var curDate=$.m({
            ClassName:"web.DHCANOPCom",
            MethodName:"GetCurentDate",
            ifDisbled:"1"
        },false);
        $HUI.datebox("#OperDate").setValue(curDate);
        $("#btnSave").linkbutton('enable');
    }else{
        var operDate=$.m({
            ClassName:"web.DHCANOPCom",
            MethodName:"GetInitialDateOld",
            userId:session['LOGON.USERID'],
            userGroupId:session['LOGON.GROUPID'],
            ctlocId:session['LOGON.CTLOCID']
        },false);
        $HUI.datebox("#OperDate").setValue(operDate);
        if(checkIfOutTime())
        {
            $("#btnSave").linkbutton('disable');
        }
    }
}
//������ʩ�����Ƿ����
function setPrevAnaMethodIsRequired()
{
	var newValue=$("#IsAnaest").combobox("getValue");
    if (newValue == "Y") {
            $("#PrevAnaMethod").combobox({
                required: true,
                 disabled:false
            });
        } else {
            $("#PrevAnaMethod").combobox({
                required: false
            });
            $("#PrevAnaMethod").combobox("disable");
        }
}
//����Ĭ����ǰ���
function setDefaultPrevDiagnos(preDiag)
{
    var datas=[];
    if(preDiag!="")
    {
        var preDiagList=preDiag.split(",");
        if(preDiagList.length>0)
        {
            for(var idiag=0;idiag<preDiagList.length;idiag++)
            {
                var itemdiag=preDiagList[idiag].split("!");
                if(itemdiag[0]==""&&itemdiag[1]=="") continue;
                var data={
	                DiagID:itemdiag[0],
                	DiagDesc:itemdiag[1]
                };
                datas.push(data);
            }
        }
    }
    $("#preopDiagBox").datagrid('loadData',datas);
    setPrevDiagnos();
}

//combobox����id!desc��ʽ��������
function loadCombobox(container,item)
{
    
	if("undefined" == typeof item) return;
	var itemList=item.split("!")
	if(itemList.length>1)
	{
		$(container).combobox('setValue',itemList[0]);
		$(container).combobox('setText',itemList[1]);
	}
}
function loadComboboxByDesc(container,desc)
{   
    var datas=$(container).combobox('getData');
    if(datas&&datas.length>0)
    {
	    for(var i=0;i<datas.length;i++)
	    {
		    var data=datas[i];
		     if((data.RHDesc)&&(data.RHDesc==desc)){
                $(container).combobox('setValue',data.RHId);
                $(container).combobox('setText',data.RHDesc);
            }
            else if((data.typ)&&(data.typ==desc))
            {
                 $(container).combobox('setValue',data.ord);
                  $(container).combobox('setText',data.typ);
            }
            else if((data.BLDTDesc)&&(data.BLDTDesc==desc))
            {
	             $(container).combobox('setValue',data.BLDTRowId);
	             $(container).combobox('setText',data.BLDTDesc);
            }

	    }
	    
    }
}

//���һ�����
function addPrevDiagnos(){
    //var diagID = $HUI.combobox("#diagnosis").getValue();
    var diagID = $("#diagnosis").combobox("getValue");
    
    var diagDesc = $HUI.combobox("#diagnosis").getText();
    if(diagID==diagDesc)
    {
	    $.messager.alert("��ʾ","��������������ѡ�����!","error");
		  return; 
    }
      //20180828+dyl
     var rows = $("#preopDiagBox").datagrid("getRows"),
      result = "";
      var exsitflag=0
    if (rows && rows.length > 0) {
        $.each(rows, function(index, row) {
	        if(diagID==row.DiagID)
	        {
		        $.messager.alert("��ʾ","������Ѵ���!","error");
                    exsitflag=1;
                    return;
	        }
        });
    }
    if(exsitflag==1)return;
    if (diagDesc && diagDesc != "") {
        $HUI.datagrid("#preopDiagBox").appendRow({
            DiagID: diagID,
            DiagDesc: diagDesc
        });
        $HUI.combobox("#diagnosis").clear();
        setPrevDiagnos();
        
    }
   
}
//ɾ��һ�����
function removePrevDiagnos(){
    var selectRow=$HUI.datagrid("#preopDiagBox").getSelected(),
        selectRowIndex=$HUI.datagrid("#preopDiagBox").getRowIndex(selectRow);
    if(selectRow)
    {
        $HUI.datagrid("#preopDiagBox").deleteRow(selectRowIndex);
        setPrevDiagnos();
    }else{
        $.messager.alert("��ʾ","��ѡ��Ҫɾ�������","warning");
        return;
    }
}
function InitOperDiag()
{
			$HUI.combobox("#Surgeon",{});
			$HUI.combobox("#Operation",{});
			$HUI.combobox("#OperClass",{});
			$HUI.combobox("#BladeType",{});
			$HUI.combobox("#SurgeonLoc",{});
			$HUI.combobox("#OpDocGroup",{});
			$HUI.combobox("#SurgonAss1",{});
			$HUI.combobox("#SurgonAss2",{});
			$HUI.combobox("#SurgonAss3",{});
			$HUI.combobox("#SurgonAsso",{});
    var surgeon=$HUI.combobox("#Surgeon",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array";
       	
       	$(this).combobox('reload');
    		}
  		},
        onBeforeLoad:function(param)
        {
	        //2
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	       if( typeof surgeontloc =="undefined") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(typeof operttt =="undefined") {surgeonoperId="";}
	        else{ surgeonoperId=$("#Operation").combobox("getValue");}

            param.needCtcpDesc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.locDescOrId=surgeonlocId;
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="Y";
            param.ifDayOper="";
            param.operId=surgeonoperId;
        },
       
        onChange:function(newValue, oldValue)
        {
	        //�����䣬�������¼���
	        var lastloc="";
	         var lastlocdes=$("#SurgeonLoc").combobox("getText");
	       if( typeof lastlocdes =="undefined") {lastloc="";}
	        else{ lastloc=$("#SurgeonLoc").combobox("getValue");}
	        if(lastloc=="")
	        {
	        	$('#SurgeonLoc').combobox("reload");
	        }
	        var lastoper="";
	        //$("#Operation").combobox("getValue");
	        var lastoperdesc=$("#Operation").combobox("getText");
	        if(typeof lastoperdesc =="undefined") {lastoper="";}
	        else{ lastoper=$("#Operation").combobox("getValue");}
	        if(lastoper=="")
	        {
	        	$('#Operation').combobox("reload");
	        }
        },
        onHidePanel: function () {
               OnHidePanel("#Surgeon");
            },
        mode:"remote"
    });

	
    var operation=$HUI.combobox("#Operation",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindOrcOperation&ResultSetType=array",
        valueField:"rowid",
        textField:"OPTypeDes",
         onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindOrcOperation&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        onBeforeLoad:function(param)
        {
	        //4
	        var surgeonId="";
	        var surgeonttt=$("#Surgeon").combobox("getText");
	        if( typeof surgeonttt =="undefined") {surgeonId="";}
	        else{surgeonId=$("#Surgeon").combobox("getValue");}
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(typeof surgeontloc =="undefined") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        
            param.operDescAlias=param.q;
            param.OpDocId=surgeonId;
            param.ifDayOper="";
            param.surgeonLocId="";	//20180727+dyl+3:��������������й���
        },
        onSelect:function(record)
        {
	        //5
			var operId=record.rowid;
			 if(operId!="")
	        {
		        $('#OpDocGroup').combobox("disable");
	        }
	        var retStr=$.m({
        	ClassName:"web.DHCANOPArrangeHISUI",
        	MethodName:"GetOperRelated",
        	operId:operId
    		},false);
      		if (retStr=="") return;
	  		var operRelatedList=retStr.split("^");
	  		if (operRelatedList.length<8) return;
	  		loadCombobox("#OperClass",operRelatedList[0]+"!"+operRelatedList[1]);
	  		loadCombobox("#BladeType",operRelatedList[2]+"!"+operRelatedList[3]);
	        var lastsur="";
	        //var lastsur=$("#Surgeon").combobox("getValue");
	        var surgeonscr=$("#Surgeon").combobox("getText");
	        if( typeof surgeonscr =="undefined") {lastsur="";}
	        else{lastsur=$("#Surgeon").combobox("getValue");}
	        if(lastsur=="")
	        {
	        	$("#Surgeon").combobox("reload");
	        }
	         //20180727+dyl+4:��������������й���
	       
	        //alert(record.rowid)
        },
        onHidePanel: function () {
               OnHidePanel("#Operation");
            },
        mode:"remote"
    });
	
    var operclass=$HUI.combobox("#OperClass",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetOPLevel&ResultSetType=array",
        valueField:"ANCOPLRowId",
        textField:"ANCPLDesc",
       onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetOPLevel&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        editable:false
    });
    
    var bladetype=$HUI.combobox("#BladeType",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetBladeType&ResultSetType=array",
        valueField:"BLDTPRowId",
        textField:"BLDTPDesc",
       onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetBladeType&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        editable:false
    });

	
    var surgeonLoc=$HUI.combobox("#SurgeonLoc",{
        //url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindSurgeonLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param)
        {
	        //20180727+dyl+1
	        var surgeonId="";
	        var surgeon1=$("#Surgeon").combobox("getText");
	        if (typeof surgeon1=="undefined") {surgeonId="";}
	       else{surgeonId=$("#Surgeon").combobox("getValue");}
	        
	        var surgeonoperId="";
	        var oper1=$("#Operation").combobox("getText");
	         if (typeof (oper1)=="undefined") {surgeonoperId="";}
	        else{ surgeonoperId=$("#Operation").combobox("getValue");}
            
            param.desc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.EpisodeID=EpisodeID;
            param.operId="";	//surgeonoperId
            param.surgeonId=surgeonId;
        },
        onSelect:function(record){
	        //$("#Operation").combobox("reload");
	        $("#Surgeon").combobox("reload");
	        $("SurgeonAss1").combobox("reload");
	        $("SurgeonAss2").combobox("reload");
	        $("SurgeonAss3").combobox("reload");
	        $("#SurgonAsso").combobox("reload");
	        $("#OpDocGroup").combobox("reload");
        },
        onHidePanel: function () {
               OnHidePanel("#SurgeonLoc");
            },
             onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCClinicCom&QueryName=FindSurgeonLocList&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        mode:"remote"
    });
    $("#SurgeonLoc").combobox("setValue",logLocId);
    $("#SurgeonLoc").combobox("setText",curLogLoc);
	    
        //����ҽʦ��
        var OpDocGroup=$HUI.combobox("#OpDocGroup",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindODGroupNew&ResultSetType=array",
        valueField:"groupID",
        textField:"groupID",
        editable:false,
        panelWidth:300,
        onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindODGroupNew&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
		onBeforeLoad:function(param)
        {
            param.OpDeptId=$("#SurgeonLoc").combobox("getValue");
        },
         onSelect:function(record)
        {
	        //5
	       var doc1=record.surgeon;
	       var doc1Id=record.surgeonID;
			var ass1=record.frtAss;
			var ass1Id=record.frtAssID;
			var ass2=record.secAss;
			var ass2Id=record.secAssID;
			var ass3=record.trdAss;
			var ass3Id=record.trdAssID;
			//alert(doc1+"|"+doc1Id+"+"+ass1)
			$("#Surgeon").combobox("setValue",doc1Id)
			$("#Surgeon").combobox("setText",doc1)
			$("#SurgonAss1").combobox("setValue",ass1Id)
			$("#SurgonAss1").combobox("setText",ass1)
			$("#SurgonAss2").combobox("setValue",ass2Id)
			$("#SurgonAss2").combobox("setText",ass2)
			$("#SurgonAss3").combobox("setValue",ass3Id)
			$("#SurgonAss3").combobox("setText",ass3)
	  		//loadCombobox("#Surgeon",doc1Id+"!"+doc1);
	  		//loadCombobox("#SurgonAss1",ass1Id+"!"+ass1);
			//loadCombobox("#SurgonAss2",ass2Id+"!"+ass2);
			//loadCombobox("#SurgonAss3",ass3Id+"!"+ass3);
			$('#Operation').combobox("reload");
	       
        },
         mode:"remote"
    });

    
    //����1
    var surgeonass1=$HUI.combobox("#SurgonAss1",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
         onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        onBeforeLoad:function(param)
        {
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(typeof surgeontloc=="undefined") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(typeof operttt =="undefined") {surgeonoperId="";}
	        else{ surgeonoperId=$("#Operation").combobox("getValue");}
            param.needCtcpDesc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.locDescOrId=surgeonlocId;
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
            param.operId="";
        },
         onSelect:function(record)
        {
	        var curvalue=record.ctcpId;
	        var sdocId=$("#Surgeon").combobox("getValue");
	        
	        var ss2Id=$("#SurgonAss2").combobox("getValue");
	        var ss3Id=$("#SurgonAss3").combobox("getValue");
	        var ssoId=$("#SurgonAsso").combobox("getValues");
	        if((sdocId==curvalue)||(ss2Id==curvalue)||(ss3Id==curvalue)||(((ssoId+",").indexOf((curvalue+","))!=-1)&&(ssoId!="")))
	        {
		        $.messager.alert("��ʾ", "��ҽ���Ѿ�ѡ����ѡ������ҽ����Ա", 'info');
		        $("#SurgonAss1").combobox("setValue","");
	        }
        },
        onHidePanel: function () {
               OnHidePanel("#SurgonAss1");
            },
        mode:"remote"
    });
    //����2
        var surgeonass2=$HUI.combobox("#SurgonAss2",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        
        valueField:"ctcpId",
        textField:"ctcpDesc",
        onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        onBeforeLoad:function(param)
        {
	        //3
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(typeof surgeontloc =="undefined") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(typeof operttt =="undefined") {surgeonoperId="";}
	        else{ surgeonoperId=$("#Operation").combobox("getValue");}
            param.needCtcpDesc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.locDescOrId=surgeonlocId;
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
            param.operId="";
        },
         onSelect:function(record)
        {
	        var curvalue=record.ctcpId;
	        var sdocId=$("#Surgeon").combobox("getValue");
	        var ss1Id=$("#SurgonAss1").combobox("getValue");
	        var ss3Id=$("#SurgonAss3").combobox("getValue");
	        var ssoId=$("#SurgonAsso").combobox("getValues");
	        //ss1Id.indexOf(curvalue)!=-1)
	        if((sdocId==curvalue)||(ss1Id==curvalue)||(ss3Id==curvalue)||(((ssoId+",").indexOf((curvalue+","))!=-1)&&(ssoId!="")))
	        {
		        $.messager.alert("��ʾ", "��ҽ���Ѿ�ѡ����ѡ������ҽ����Ա", 'info');
		        $("#SurgonAss2").combobox("setValue","");
	        }
        },
        onHidePanel: function () {
               OnHidePanel("#SurgonAss2");
            },
        mode:"remote"
    });
	//����3
    var surgeonass3=$HUI.combobox("#SurgonAss3",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        onBeforeLoad:function(param)
        {
	        //3
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(typeof surgeontloc =="undefined") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(typeof operttt =="undefined") {surgeonoperId="";}
	        else{ surgeonoperId=$("#Operation").combobox("getValue");}
            param.needCtcpDesc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.locDescOrId=surgeonlocId;
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
            param.operId="";
        },
         onSelect:function(record)
        {
	        var curvalue=record.ctcpId;
	        var sdocId=$("#Surgeon").combobox("getValue");
	        var ss2Id=$("#SurgonAss2").combobox("getValue");
	        var ss1Id=$("#SurgonAss1").combobox("getValue");
	        var ssoId=$("#SurgonAsso").combobox("getValues");
	        if((sdocId==curvalue)||(ss1Id==curvalue)||(ss2Id==curvalue)||(((ssoId+",").indexOf((curvalue+","))!=-1)&&(ssoId!="")))
	        {
		        $.messager.alert("��ʾ", "��ҽ���Ѿ�ѡ����ѡ������ҽ����Ա", 'info');
		        $("#SurgonAss3").combobox("setValue","");
	        }
        },
        onHidePanel: function () {
               OnHidePanel("#SurgonAss3");
            },
        mode:"remote"
    });
    
    var surgeonasso=$HUI.combobox("#SurgonAsso",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        multiple: true,
        rowStyle:'checkbox',
        editable:false,
        onShowPanel : function(){
    		var s=$(this).combobox('getData')
    		if(s.length==0){  
       	$(this).combobox('options').url= $URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array";
       	$(this).combobox('reload');
    		}
  		},
        onBeforeLoad:function(param)
        {
	        //3
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(typeof surgeontloc=="undefined") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(typeof operttt=="undefined") {surgeonoperId="";}
	        else{ surgeonoperId=$("#Operation").combobox("getValue");}
            param.needCtcpDesc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.locDescOrId=surgeonlocId;
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
            param.operId="";
        },
         onSelect:function(record)
        {
        var curvalue=record.ctcpId;
        //alert(curvalue)
        },
        mode:"remote"
    })


	//$("#Operation").combobox("setValue","");
}


/// ���һ�������������б�
var ssubOpSub=""
function addAnaestOperation() {
    $("#operDialog").dialog({
        title: "��������",
        iconCls: "icon-w-add"
    });
    InitOperDiag();
    operloadflag=1;
    $("#operDialog").dialog("open");
    $("#OpSubDr").val("")	//20190118+dyl+7
}
//�޸�������Ϣ
var selectOperIndex=""
function editAnaestOperation(){
    var selectRow=$("#operationBox").datagrid("getSelected");
    if(selectRow)
    {
        $("#operDialog").dialog({
            title: "�޸�����",
            iconCls: "icon-w-edit"
        });
        InitOperDiag();
        var soperId=selectRow.Operation;
        var soperDesc=selectRow.OperationDesc;
        var soperClassId=selectRow.OperClass;
        var soperClassDesc=selectRow.OperClassDesc;
        var sbladeTypeId=selectRow.BladeType;
        var sbladeTypeDesc=selectRow.BladeTypeDesc;
        var ssurgeonLocId=selectRow.SurgeonLoc;
        var ssurgeonLocDesc=selectRow.SurgeonLocDesc;
        var ssurgeonId=selectRow.Surgeon;
        var ssurgeonDesc=selectRow.SurgeonDesc;
        var ssurgonAss1Id=selectRow.SurgonAss1;
        var ssurgonAss1Desc=selectRow.SurgonAss1Desc;
        var ssurgonAss2Id=selectRow.SurgonAss2;
        var ssurgonAss2Desc=selectRow.SurgonAss2Desc;
        var ssurgonAss3Id=selectRow.SurgonAss3;
        var ssurgonAss3Desc=selectRow.SurgonAss3Desc;
        var sSurgonAssoStr=selectRow.SurgonAsso;
        var sSurgonAssoDesc=selectRow.SurgonAssoDesc;
        var soperNote=selectRow.OperNote;
        var ssubOpSub=selectRow.OpSub;
        $("#OpSubDr").val(ssubOpSub)	////20190118+dyl+4
        $("#SurgeonLoc").combobox('setValue',ssurgeonLocId);
		$("#SurgeonLoc").combobox('setText',ssurgeonLocDesc);
        if(ssurgeonLocId!="")
        {
       	//$('#OpDocGroup').combobox("reload");
		//$('#Surgeon').combobox("reload");
		//$('#SurgonAss1').combobox("reload");
		//$('#SurgonAss2').combobox("reload");
		//$('#SurgonAss3').combobox("reload");
		//$('#SurgonAsso').combobox("reload");
        }
		//alert(ssurgeonId+"/"+ssurgeonLocId)
        $("#Operation").combobox('setValue',soperId);
        $("#Operation").combobox('setText',soperDesc);
         $("#OperClass").combobox('setValue',soperClassId);
         $("#OperClass").combobox('setText',soperClassDesc);
        $("#BladeType").combobox('setValue',sbladeTypeId);
        $("#BladeType").combobox('setText',sbladeTypeDesc);
        $("#Surgeon").combobox('setValue',ssurgeonId);
         $("#Surgeon").combobox('setText',ssurgeonDesc);
        $("#SurgonAss1").combobox('setValue',ssurgonAss1Id);
         $("#SurgonAss1").combobox('setText',ssurgonAss1Desc);
        $("#SurgonAss2").combobox('setValue',ssurgonAss2Id);
         $("#SurgonAss2").combobox('setText',ssurgonAss2Desc);
        $("#SurgonAss3").combobox('setValue',ssurgonAss3Id);
         $("#SurgonAss3").combobox('setText',ssurgonAss3Desc);
        if(sSurgonAssoStr!="")
        {
	        var newsurotherId=getIdStr(sSurgonAssoStr);
	        var newsurother=getDescStr(sSurgonAssoStr);
        	$("#SurgonAsso").combobox('setValues',newsurotherId);
        	$("#SurgonAsso").combobox('setText',newsurother);
        }
        $("#OperNote").val(soperNote);
        //$("#SurgonAsso").combobox('setText',sSurgonAssoDesc)
        operloadflag=1;
        $("#operDialog").window("open");
        $("#EditOperation").val("Y");
        
    }else{
        $.messager.alert("��ʾ", "����ѡ��Ҫ�޸ĵ�������", 'warning');
        return;
    }
}
function removeAnaestOperation(){
    var selectRow=$HUI.datagrid("#operationBox").getSelected();
    var rowIndex=$HUI.datagrid("#operationBox").getRowIndex(selectRow);
    //alert(rowIndex)
    if(selectRow)
    {
	    $("#OpSubDr").val("")	//20190118+dyl+9
        $HUI.datagrid("#operationBox").deleteRow(rowIndex);
    }else{
        $.messager.alert("��ʾ", "����ѡ��Ҫɾ����������", 'warning');
        return;
    }
}
function disablePatientsList(){
	//$('#patientNo').textbox('textbox').attr('readOnly',true);
	//$("#patientNo").searchbox("disabled",true);
	//$("#patientNo").attr("disabled",true);
	$("#patientNo").attr("disabled",true);
	//$("#patientNo").textbox({disabled:true});
	$("#SearchLoc").combobox("disable");
	$("#SearchWard").combobox("disable");
	//$("#btnSearch").linkbutton("disable");
	$('#patientsList').datagrid('unselectAll');
}
//����������Ϣ��ǰ̨datagrid��
function saveOperation()
{
    var operId=$("#Operation").combobox('getValue');
    if(!reg.test(operId))
    {
	    $.messager.alert("��ʾ","�������Ʋ����Զ����Ҳ���Ϊ��","error");
        return;
    }
    var operDesc=$HUI.combobox("#Operation").getText();
    var operNote=$("#OperNote").val();
    
    var operClassId=$HUI.combobox("#OperClass").getValue();
    var operClassDesc=$HUI.combobox("#OperClass").getText();
    if(operClassId=="")
    {
        $.messager.alert("��ʾ","�����ּ�����Ϊ�գ�","error");
        return;
    }
    var bladeTypeId=$HUI.combobox("#BladeType").getValue();
    var bladeTypeDesc=$HUI.combobox("#BladeType").getText();
    if(bladeTypeId=="")
    {
        $.messager.alert("��ʾ","�п����Ͳ���Ϊ�գ�","error");
        return;
    }
    var surgeonLocId=$HUI.combobox("#SurgeonLoc").getValue();
    var surgeonLocDesc=$HUI.combobox("#SurgeonLoc").getText();
    var surgeonId=$HUI.combobox("#Surgeon").getValue();
    var surgeonDesc=$HUI.combobox("#Surgeon").getText();
    if(!reg.test(surgeonId))
    {
        $.messager.alert("��ʾ","����ҽ������Ϊ�գ�","error");
        return;
    }
    //var surgeonNote=$("#SurgeonNote").val();
    var surgonAss1Id=$HUI.combobox("#SurgonAss1").getValue();
    var surgonAss1Desc=$HUI.combobox("#SurgonAss1").getText();
    if(surgonAss1Desc=="")
    {
	    surgonAss1Id="";
    }
    else if((surgonAss1Desc!="")&&(!reg.test(surgonAss1Id)))
    {
        $.messager.alert("��ʾ","ҽʦ�����Զ���","error");
        return;
    }
    var surgonAss2Id=$HUI.combobox("#SurgonAss2").getValue();
    var surgonAss2Desc=$HUI.combobox("#SurgonAss2").getText();
    if(surgonAss2Desc=="")
    {
	    surgonAss2Id="";
    }
    else if((surgonAss2Desc!="")&&(!reg.test(surgonAss2Id)))
    {
        $.messager.alert("��ʾ","ҽʦ�����Զ���","error");
        return;
    }
    var surgonAss3Id=$HUI.combobox("#SurgonAss3").getValue();
    var surgonAss3Desc=$HUI.combobox("#SurgonAss3").getText();
    if(surgonAss3Desc=="")
    {
	    surgonAss3Id="";
    }
    else if((surgonAss3Desc!="")&&(!reg.test(surgonAss3Id)))
    {
        $.messager.alert("��ʾ","ҽʦ�����Զ���","error");
        return;
    }
    //
    var SurgonAssoId=getSurgonAsso();
    var SurgonAssoDesc=$HUI.combobox("#SurgonAsso").getText();
    if(SurgonAssoDesc=="")
    {
	    SurgonAssoId="";
    }
    var opsub=$("#OpSubDr").val()	////20190118+dyl+5
    var rowdata={
        Operation:operId,
        OperationDesc:operDesc,
        OperClass:operClassId,
        OperClassDesc:operClassDesc,
        BladeType:bladeTypeId,
        BladeTypeDesc:bladeTypeDesc,
        SurgeonLoc:surgeonLocId,
        SurgeonLocDesc:surgeonLocDesc,
        Surgeon:surgeonId,
        SurgeonDesc:surgeonDesc,
        SurgonAss1:surgonAss1Id,
        SurgonAss1Desc:surgonAss1Desc,
        SurgonAss2:surgonAss2Id,
        SurgonAss2Desc:surgonAss2Desc,
        SurgonAss3:surgonAss3Id,
        SurgonAss3Desc:surgonAss3Desc,
        SurgonAsso:SurgonAssoId,
        SurgonAssoDesc:SurgonAssoDesc,
        OperNote:operNote,
        OpSub:opsub	//20190118+dyl+6
    }
    if( $("#EditOperation").val()=="Y")
    {
       $HUI.datagrid("#operationBox").updateRow({index:selectOperIndex,row:rowdata});
    }
    else
    {
        var data=$HUI.datagrid("#operationBox").getData();
       var exsitflag=0
        if(data.rows.length>0)
        {
            $.each(data.rows,function(i,row){
                if((row.Operation==rowdata.Operation)||(row.OperationDesc==rowdata.OperationDesc))
                {
                    $.messager.alert("��ʾ","�������Ѵ���!","error");
                    exsitflag=1;
                    return;
                }		
            });
        }
        if(exsitflag==1) return;
       $HUI.datagrid("#operationBox").appendRow(rowdata);
    
    }
    $HUI.dialog("#operDialog").close();
}

// ������ǰ����б���Ϣ��������ǰ��ϣ������ǰ����ԡ�,��ƴ��
function setPrevDiagnos() {
    var rows = $("#preopDiagBox").datagrid("getRows"),
        result = "";
    if (rows && rows.length > 0) {
        $.each(rows, function(index, row) {
            if (result != "") {
                result += ",";
            }
            var diagID = row.DiagID ? row.DiagID : "";
            result += diagID;
        });
        $("#PrevDiagnosis").val(result);
    }
}

//��ȡ���߻�����Ϣ
function getPatInfo(){
    var datas=$.m({
        ClassName:"web.DHCANOPArrange",
        MethodName:"GetAnSingle",
        opaId:opaId,
        EpisodeID:EpisodeID,
        userId:session['LOGON.USERID'],
        type:"In"
    },false);
    return datas;
}
//��ȡѡ�����ʩ������
function getPrevAnaMethods(){
    var anaMethodArray = $("#PrevAnaMethod").combobox("getValues"),
        anaMethod="";
    if(anaMethodArray&&anaMethodArray.length>0)
    {
        anaMethod= anaMethodArray.join(",");
    }
    return anaMethod;
}
//��ȡѡ�����ʩ������
function getSurgonAsso(){
    var soArray = $("#SurgonAsso").combobox("getValues"),
        so="";
    if(soArray&&soArray.length>0)
    {
        so= soArray.join(",");
    }
    return so;
}
//��ȡ��������Ϣ
function getMainOperStr(){
    var datas=$("#operationBox").datagrid('getData')
        mainOperStr="";
    if(datas&&datas.total>0)
    {
        var mainOperId=datas.rows[0].Operation;
        var mainOperClassId=datas.rows[0].OperClass;
        var mainBladeTypeId=datas.rows[0].BladeType;
        var mainOperNote=datas.rows[0].OperNote;
        var mainSurgeonLocId=datas.rows[0].SurgeonLoc;
        var mainSurgeonId=datas.rows[0].Surgeon;
        var mainSurgonAss1Id=datas.rows[0].SurgonAss1;
        var mainSurgonAss2Id=datas.rows[0].SurgonAss2;
        var mainSurgonAss3Id=datas.rows[0].SurgonAss3;
        var mainSurgonAssoId=datas.rows[0].SurgonAsso;
        var mainOpSub=datas.rows[0].OpSub;	//20190118+dyl+1
        var doctorStr=mainSurgeonLocId+"|"+mainSurgeonId+"|"+mainSurgonAss1Id+"|"+mainSurgonAss2Id+"|"+mainSurgonAss3Id+"|"+mainSurgonAssoId;
        mainOperStr=mainOperId+"|"+mainOperClassId+"|"+mainOperNote+"|"+mainBladeTypeId+"||"+doctorStr;
    }
    return mainOperStr;
}
//��ȡ����������Ϣ
function getSubOperStr()
{
    var datas=$("#operationBox").datagrid('getData'),
        subOperStr="";
    if(datas.total==0) return;
    for(var i=1;i<datas.total;i++)
    {
        var subOperId=datas.rows[i].Operation;
        var subOperClassId=datas.rows[i].OperClass;
        var subBladeTypeId=datas.rows[i].BladeType;
        var subOperNote=datas.rows[i].OperNote;
        var subSurgeonLocId=datas.rows[i].SurgeonLoc;
        var subSurgeonId=datas.rows[i].Surgeon;
        var subSurgonAss1Id=datas.rows[i].SurgonAss1;
        var subSurgonAss2Id=datas.rows[i].SurgonAss2;
        var subSurgonAss3Id=datas.rows[i].SurgonAss3;
        var subSurgonAssoId=datas.rows[i].SurgonAsso;
        var subOpSub=datas.rows[i].OpSub;	//20190118+dyl+2
        var doctorStr=subSurgeonLocId+"|"+subSurgeonId+"|"+subSurgonAss1Id+"|"+subSurgonAss2Id+"|"+subSurgonAss3Id+"|"+subSurgonAssoId;
        if(subOperStr=="")
        {
	        subOperStr=subOperId+"|"+subOperClassId+"|"+subOperNote+"|"+subBladeTypeId+"|"+subOpSub+"|"+doctorStr;
        }
        else
        {
	        subOperStr=subOperStr+"#"+subOperId+"|"+subOperClassId+"|"+subOperNote+"|"+subBladeTypeId+"|"+subOpSub+"|"+doctorStr;
        }
    }
    return subOperStr;
}
//��ȡ������
function getAnaestMethods() {
    var result=$.cm({
        ClassName:"web.DHCANOPArrangeHISUI",
        QueryName:"FindAnaestMethod",
        anmethod:"",
        ResultSetType:"array"
    },false)
    return result;
}
//��ȡ���岿λ
function getBodySites(){
    var result=$.cm({
        ClassName:"web.DHCANOPArrangeHISUI",
        QueryName:"FindBodySite",
        desc:'',
        ResultSetType:"array"
    },false);
    return result;
}
function getBloodTypeItems()
{
	var result=$.cm({
        ClassName:"web.DHCANOPArrangeHISUI",
        QueryName:"GetBlood",
        ResultSetType:"array"
    },false)
    return result;
}
//��ȡRHѪ��������
function getRHBloodTypeItems(){
    var result=$.cm({
        ClassName:"web.DHCANOPArrangeHISUI",
        QueryName:"RHBlood",
        ResultSetType:"array"
    },false)
    return result;
}
//��ȡ������Ŀ������
function getLabInfo(){
    var LabInfoStr=$.m({
        ClassName:"web.DHCANOPCom",
        MethodName:"GetLabInfo",
        admId:"^"+EpisodeID
    },false);
    var LabInfo=LabInfoStr.split("^");
    if(LabInfo[0].length>0){
        loadComboboxByDesc("#BloodType",LabInfo[0]);
    }
    if(LabInfo[1].length>0){
        loadComboboxByDesc("#RHBloodType",LabInfo[1]);
    }
    if(LabInfo[3].length>0){
        loadComboboxByDesc("#HbsAg",LabInfo[3]);
    }
    if(LabInfo[4].length>0){
        loadComboboxByDesc("#HcvAb",LabInfo[4]);
    }
    if(LabInfo[5].length>0){
        loadComboboxByDesc("#HivAb",LabInfo[5]);
    }
    if(LabInfo[6].length>0){
        loadComboboxByDesc("#Syphilis",LabInfo[6]);
    }
}
function getIdStr(str)
{
    var idStr=[];
    var strList=str.split(",");
    if(strList.length>0)
    {
        for(var i=0;i<strList.length;i++)
        {
            var id=strList[i].split("!")[0];
            idStr.push(id);
        }
    }
    return idStr;
}
function getDescStr(str)
{
    var descStr=[];
    var strList=str.split(",");
    if(strList.length>0)
    {
        for(var i=0;i<strList.length;i++)
        {
            var desc=strList[i].split("!")[1];
            descStr.push(desc);
        }
    }
    return descStr;
}

function getNewIdStr(str)
{
    var idStr=[];
    var strList=str.split(",");
    if(strList.length>0)
    {
        for(var i=0;i<strList.length;i++)
        {
            var id=strList[i];
            idStr.push(id);
        }
    }
    return idStr;
}

//������������
function saveOperApplication(){
     var checkResult=CheckData();
     if(checkResult==false) return;
     var appLocId=$("#AppLocation").combobox('getValue');
     var appDocId=$("#AppDoctor").combobox('getValue');
     var operLocationId=$("#OperLocation").combobox('getValue');
     var operType=$("#OperType").combobox('getValue');
     var operDate=$("#OperDate").datebox('getValue');
     var operTime=$("#OperTime").timespinner('getValue');
     var operDuration=$("#OperDuration").numberspinner('getValue');
     var isAnaest=$("#IsAnaest").combobox('getValue');
     var anaMethod=getPrevAnaMethods();
     var reentryOperation=$("#ReentryOperation").combobox('getValue');
     var prevDiagnosisId=$("#PrevDiagnosis").val();
     if(prevDiagnosisId=="")
     {
	     $.messager.alert("����","����������Ϣ","warning");
             return;
     }
     var operPreDiagMem=$("#OperPreDiagMem").val();
     var preDiagStr=prevDiagnosisId+"|"+operPreDiagMem;
     var mainOperStr=getMainOperStr();
     var subOperStr=getSubOperStr();
     if(mainOperStr=="")
     {
	     $.messager.alert("����","�����������Ϣ","warning");
             return;
     }
     var bodySiteId=$("#BodySite").combobox('getValues');
     bodySiteId=String(bodySiteId).replace(/,/g, "|");
     var operPosId=$("#OperPos").combobox('getValue');
     var operMem=$("#AreaOperMem").val();
     var isoOperation=$("#IsoOperation").checkbox('getValue')?"Y":"N";
     var isECC=$("#ECC").checkbox('getValue')?"Y":"N";
     var isTransAutoblood=$("#TransAutoblood").checkbox('getValue')?"Y":"N";
     var isPrepareBlood=$("#PrepareBlood").checkbox('getValue')?"Y":"N";
     var planSeq=$("#PlanSeq").numberspinner('getValue');
     var bloodTypeId=$("#BloodType").combobox('getValue');
     var RHBloodTypeDesc=$("#RHBloodType").combobox('getText');
     var HbsAgDesc=$("#HbsAg").combobox('getText');
     var HcvAbDesc=$("#HcvAb").combobox('getText');
     var HivAbDesc=$("#HivAb").combobox('getText');
     var SyphilisDesc=$("#Syphilis").combobox('getText');
     var labTestNote=$("#LabTest").val();
     var opDocNote=$("#SurgeonNote").val();
     //20191024+dyl
     var materialMem="";
     //$("#MaterialMem").combobox('getValues');
     var str1=appLocId+"^"+appDocId+"^"+operDate+"^"+operTime+"^"+session['LOGON.USERID']+"^"+EpisodeID+"^^"+operMem+"^"+bloodTypeId+"^^^^^^"+operDuration+"^"+opDocNote+"^"+planSeq+"^^^^";
     var appOperInfo=mainOperStr+"^"+preDiagStr+"^"+""+"^"+""+"^"+operLocationId+"^"+bodySiteId+"^"+operPosId+"^"+subOperStr;
     var assDocIdStr="";
     var strCheck=HbsAgDesc+"^"+HcvAbDesc+"^"+HivAbDesc+"^"+SyphilisDesc+"^"+operType+"^"+labTestNote+"^"+RHBloodTypeDesc+"^"+isoOperation+"^"+isPrepareBlood+"^"+isTransAutoblood+"^"+isECC
                  +"^"+isAnaest+"^^^^^"+reentryOperation+"^"+materialMem;
     var retSameOper=$.m({
             ClassName:"web.DHCANOPArrangeHISUI",
             MethodName:"GetOperByEpisodeID",
             opaId:opaId,
             EpisodeID:EpisodeID,
             OperDesc:"",
             operDate:operDate
         },false)
              if(retSameOper=="1")
              {
	            var hh=confirm("�û��ߵ���������һ̨����,ȷ������������?")
				if(hh){}
				else{return;}
          		}		

     if((opaId==null)||(opaId==""))
     {
         var result=$.m({
             ClassName:"web.DHCANOPArrangeHISUI",
             MethodName:"insertAnRecord",
             itmjs:"",
             itmjsex:"",
             str1:str1,
             op:appOperInfo,
             ass:assDocIdStr,
             strcheck:strCheck,
             anmetId:anaMethod,
             ifBLApp:"",
             appType:"ward"
         },false)
         //console.log(result);
         if(result.split("^")[0]>0)
        {
             $.messager.confirm("ȷ��","��������ɹ����Ƿ��������������",function(r){
                if(r)
                {
	                window.returnValue=0;	//20181207
                    $("#btnSave").linkbutton('disable');
                }else{
	                window.returnValue=1;	//20181207
                    window.close();
                }
             })
         }else
         {
	         window.returnValue=0;	//20181207
	          $.messager.alert("����","�����������"+result,"error");
             return;
	     }
     }else{
         var result=$.m({
             ClassName:"web.DHCANOPArrangeHISUI",
             MethodName:"updatewardRecord",
             itmjs:"",
             itmjsex:"",
             opaId:opaId,
             str1:str1,
             op:appOperInfo,
             ass:assDocIdStr,
             strcheck:strCheck,
             anmetId:anaMethod,
             apptype:"ward"
         },false)
         if(result!=0)
         {
	         window.returnValue=0;	//20181207
             $.messager.alert("����","�޸������������"+result,"error");
             return;
         }else{
             $.messager.confirm("ȷ��","�޸���������ɹ����Ƿ�����޸�������Ϣ��",function(r){
                if(!r)
                {
	                window.returnValue=1;	//20181207
                    window.close();
                }
             })
         }
     }
}
//�رմ���
function closeWindow(){
	window.returnValue=0;	//20181207
    window.close();
}
function CheckData(){
    if ((!EpisodeID)||(EpisodeID=="")){
		$.messager.alert("��ʾ","��ѡ����!","error");
		return false;
    }
    if($HUI.timespinner("#OperTime").getValue()=="") 
    {
        $.messager.alert("��ʾ","��ѡ��������ʼʱ��!","error");
		return false;
    }
    if($HUI.combobox("#BloodType").getValue()=="")
    {
        $.messager.alert("��ʾ","��ѡ����Ѫ��!","error");
		return false;
    }
 
    if($HUI.combobox("#RHBloodType").getValue()=="")
    {
        $.messager.alert("��ʾ","��ѡ��RHѪ��!","error");
		return false;
    }
    if($HUI.combobox("#HbsAg").getValue()=="")
    {
        $.messager.alert("��ʾ","��ѡ��HbsAg��Ŀ!","error");
		return false;
    }
    if($HUI.combobox("#HcvAb").getValue()=="")
    {
        $.messager.alert("��ʾ","��ѡ��HcvAb��Ŀ!","error");
		return false;
    }
    if($HUI.combobox("#HivAb").getValue()=="")
    {
        $.messager.alert("��ʾ","��ѡ��HivAb��Ŀ!","error");
		return false;
    }
     if($HUI.combobox("#Syphilis").getValue()=="")
    {
        $.messager.alert("��ʾ","��ѡ��÷����Ŀ!","error");
		return false;
    }
}

function RegSearch()
{
	var value=$("#patientNo").val();
	if(window.event.keyCode==13)
	{
		var newregno=$.m({
        ClassName:"web.DHCDTHealthCommon",
        MethodName:"FormatPatientNo",
        PatientNo:value
    	},false);
	//alert(newregno)
		//$("#patientNo").searchbox('setValue',newregno);
		$("#patientNo").val(newregno);
		$HUI.datagrid("#patientsList").load();
	}
}
//20190102+mfc
function OnHidePanel(item)
{
	var valueField = $(item).combobox("options").valueField;
	var val = $(item).combobox("getValue");  //��ǰcombobox��ֵ
	var txt = $(item).combobox("getText");
	var allData = $(item).combobox("getData");   //��ȡcombobox��������
	var result = true;      //Ϊtrue˵�������ֵ�������������в�����
	if (val=="") result=false;
	for (var i = 0; i < allData.length; i++) {
		if (val == allData[i][valueField]) {
	    	result = false;
	    	break;
	    }
	}
	if (result) {
	    if (txt!="")
	    {
	    	$.messager.alert("��ʾ","���������ѡ��","error"); 
	    	$(item).combobox('setValue',"");
	    	$(item).combobox("setText","");
	    	$(item).combobox("reload");
	    	return;
	    }
	}
}

