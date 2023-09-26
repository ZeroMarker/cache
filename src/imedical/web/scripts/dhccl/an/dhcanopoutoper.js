var EpisodeID=dhccl.getUrlParam("EpisodeID");
var opaId=dhccl.getUrlParam("opaId"); 
var appType=dhccl.getUrlParam("appType"); 
var reg=/^[0-9]+.?[0-9]*$/; 
$(function(){
    initOperationGrid();
    initDataFormControls();
    initOperDelegates();
    DayInRequired();
    
    if((opaId!=null)&&(opaId!=""))
    {
        loadDatas();
        if(appType=="op")
        { 
	        $('#tt').tabs('select', 1);
	        disableItem();
	        $("#btnSave").linkbutton('disable');
    	}
    	if(appType=="ward")
        {
	        $('#tt').tabs('select', 0);
	        $("#btnOpSave").linkbutton('disable');
    	}
    	else if(appType=="RegOp")
        {
	       $('#tt').tabs('select', 1);
    	}
    }
    if ((EpisodeID != "")&&((opaId=="")||(opaId==null))) {
                loadDatas();
                if(appType=="ward")
        		{
	        		$('#tt').tabs('select', 0);
	        		$("#btnOpSave").linkbutton('disable');
    			}
            }
});

///��ʼ�������б����
//operId,operDesc,opLevelId,opLevelDesc,bldTpId,bldTypeDesc,operNotes,opSub,opdocLoc,opdocLocId,surgeon,surgeonId,Ass1,Ass1Id,Ass2,Ass2Id,Ass3,Ass3Id,Asso,AssoId
var selectOperIndex=""
function initOperationGrid(){
    var operationBox=$HUI.datagrid("#operationBox",{
        fit:true,
         headerCls:'panel-header-gray',
        singleSelect: true,
        rownumbers: true,
        columns: [
            [
                { field: "Operation", title: "��������Id", hidden: true },
                { field: "OperationDesc", title: "��������", width: 400 },
                { field: "OperClass", title: "�����ּ�Id" ,hidden:true },
                { field: "OperClassDesc", title: "�����ּ�", width: 100 },
                { field: "BladeType", title: "�����ּ�Id",hidden:true },
                { field: "BladeTypeDesc", title: "�п�����", width: 100 },
                { field: "OperNote", title: "������ע", width: 250 },
                { field: "OpSub", title: "OpSub", width: 1, hidden: true }	//20190118+dyl+8
            ]
        ],
        onSelect:function(rowIndex, rowData){
	        selectOperIndex=rowIndex;
	       	$HUI.combobox("#Operation").setValue(rowData.Operation);
      		$HUI.combobox("#OperClass").setValue(rowData.OperClass);
      		$HUI.combobox("#BladeType").setValue(rowData.BladeType);
      		$("#OperNote").val(rowData.OperNote);
        }
    });
}

//��ʼ�����ؼ�
function initDataFormControls() 
{
	    //����Ĭ�ϵ�¼����
    var patientLoc=$HUI.combobox("#patientLoc,#AppLocation",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param)
        {
            param.desc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.EpisodeID="";
        }    
    })
    //$("#patientLoc").combobox('setValue',session['LOGON.CTLOCID']);
	//$("#AppLocation").combobox('setValue',session['LOGON.CTLOCID']);
    var AppDoctor=$HUI.combobox("#AppDoctor",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
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
    });
    var OperLocation=$HUI.combobox("#OperLocation",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param){
            param.desc=param.q;
            param.locListCodeStr="OUTOP";
            param.EpisodeID="";
        },
        onHidePanel: function () {
               OnHidePanel("#OperLocation");
            }
    });

    var operation=$HUI.combobox("#Operation",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindOrcOperation&ResultSetType=array",
        valueField:"rowid",
        textField:"OPTypeDes",
        onBeforeLoad:function(param)
        {
            param.operDescAlias=param.q;
            param.OpDocId="";
            param.ifDayOper="";
        },
        onSelect:function(record)
        {
	        //$("#Surgeon").combobox('reload');
        },
        onHidePanel: function () {
               OnHidePanel("#Operation");
            },
        mode:"remote"
    })

    var operclass=$HUI.combobox("#OperClass",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetOPLevel&ResultSetType=array",
        valueField:"ANCOPLRowId",
        textField:"ANCPLDesc",
        editable:false
    });
    var bladetype=$HUI.combobox("#BladeType",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetBladeType&ResultSetType=array",
        valueField:"BLDTPRowId",
        textField:"BLDTPDesc",
        editable:false
    });
    var bodysite=$HUI.combobox("#BodySite",{
        valueField: "BODS_RowId",
        textField: "BODS_Desc",
        multiple: true,
        editable:false,
        data:getBodySites()
        /*onShowPanel:function(){
            var datas=$(this).combobox('getData');
            if(!datas||datas.length<=0)
            {
                datas=getBodySites();
                $(this).combobox('loadData',datas);
            }
        }*/
    });
    var bloodtype=$HUI.combobox("#BloodType",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetBlood&ResultSetType=array",
        valueField:"BLDTRowId",
        textField:"BLDTDesc",
        panelHeight:'auto',
        editable:false,
        rowStyle:'checkbox',
        data:getBloodTypeItems()
    });
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
    var OpConsumable=$HUI.combobox("#comOpConsumable",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"incitrRowId",
        textField:"ancDesc",
        url:$URL+"?ClassName=web.DHCANOPStock&QueryName=FindANCStock&ResultSetType=array",
        onBeforeLoad:function(param)
        {
            param.Desc=param.q;
             var comAppLocId=$("#AppLocation").combobox("getValue");
            if(appType=="ward")
            {
	            comAppLocId=session['LOGON.CTLOCID'];
            }
            param.LocId=comAppLocId;
        },
        onHidePanel: function () {
               OnHidePanel("#comOpConsumable");
            },
        mode:"remote"
    })
        //���������
    var comOperRoom=$HUI.combobox("#comOperRoom",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindAncOperRoom&ResultSetType=array",
        valueField:"oprId",
        textField:"oprDesc",
         editable:false,
        panelHeight:'auto',
         onBeforeLoad:function(param){
            param.oprDesc=$HUI.combobox("#comOperRoom").getText();
            param.locDescOrId=$("#OperLocation").combobox("getValue");
            param.locListCodeStr="OUTOP";
            param.EpisodeID="";
            param.opaId="";
            param.oprBedType="T";
            param.appLocDescOrId="";
            
        },
        onSelect:function(record)
        {
	        //20181213+dyl
	        var retStr=$.m({
        	ClassName:"web.DHCANOPArrange",
        	MethodName:"GetRoomFirstOrd",
        	opaId:opaId,
        	roomId:record.oprId
    		},false);
    		var cirNurIdStr=retStr.split("^")[0];
    		var cirNurId=getNewIdStr(cirNurIdStr);
    		var scrNurIdStr=retStr.split("^")[1];
    		var scrNurId=getNewIdStr(scrNurIdStr);
    		 //$("#comScrubNurse").combobox('setValues',scrNurId);
    		 $("#comCirculNurse").combobox('setValues',cirNurId);
        },
      mode:'remote'  
    });
    var comOrdNo=$HUI.combobox("#comOrdNo",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetOrdNo&ResultSetType=array",
        valueField:"Id",
        textField:"Desc",
        editable:false
    });

        var comSurgeon=$HUI.combobox("#comSurgeon",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.locDescOrId=$("#AppLocation").combobox("getValue");
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
        },
        onHidePanel: function () {
               OnHidePanel("#comSurgeon");
            }
    });
    var AnaMethod=$HUI.combobox("#comAnaMethod",{
        valueField: "ID",
        textField: "Des",
        multiple: true,
        rowStyle:'checkbox',
        editable:false,
        data:getAnaestMethods()
      
    });  
        var comCirculNurse=$HUI.combobox("#comCirculNurse",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        multiple: true,
        rowStyle:'checkbox',
        editable:false,
        onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="OUTOP";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="N";
            param.ifSurgeon="N";
            
        }
    });
    
    
var timeinit=$HUI.timespinner("#OperTime,#comeHosTime,#timeOpStt,#timeOpEnd",{ 
    }) 
   var yesno=$HUI.combobox("#IsAnaest",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        data:[{'typedesc':"��",'typecode':"Y"},{'typedesc':"��",'typecode':"N"}]
    }) 

   
}
function GetComCirNurses() {
    var result=$.cm({
        ClassName:"web.DHCANOPArrangeHISUI",
        QueryName:"FindCtcp",
        needCtcpDesc:$("#comCirculNurse").combobox("getValues"),
        locListCodeStr:"OUTOP",
        locDescOrId:"",
        EpisodeID:"",
        opaId:"",
        ifDoctor:"",
        ifSurgeon:"",
        ResultSetType:"array"
    },false)
    return result;
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
/// ��ʼ�������¼�
function initOperDelegates() {
    $("#btnAddOperation").linkbutton({
        onClick:addAnaestOperation
    });

    $("#btnEditOperation").linkbutton({
        onClick: editAnaestOperation
    });

    $("#btnDelOperation").linkbutton({
        onClick: removeAnaestOperation
    });
     $("#btnSaveTempleteDoc").linkbutton({
        onClick: saveTempleteDoc_click
    });
/*
    $("#btnSave").linkbutton({
        onClick: saveOperApplication
    });
	$("#btnOpSave").linkbutton({
        onClick: saveOperApplication
    });
*/
    $("#btnOpCancel").linkbutton({
        onClick: closeWindow
    });
    $("#btnCancel").linkbutton({
        onClick: closeWindow
    });
}


//��������
function loadDatas(){
	if(appType=="ward")
	{
		$("#paneltitle").prop("innerText","��������");
	}
	else if(appType=="op")
	{
		$("#paneltitle").prop("innerText","������������");
	}
	else
	{
		$("#paneltitle").prop("innerText","���������Ǽ�");
	}
    var patInfo=getPatInfo();
    var appList=patInfo.split("@");
    loadOperData(appList);
    if((opaId==null)||(opaId==""))
    {
	    var tmpLocId=session['LOGON.CTLOCID'];
    	var apptmpLoc=$.m({
            ClassName:"web.DHCANOPArrangeDayOper",
            MethodName:"GetCtlocDescById",
            ctlocId:tmpLocId
        },false);
        $("#AppLocation").combobox("setValue",tmpLocId);
 	     $("#AppLocation").combobox("setText",apptmpLoc);
        //�ж��Ƿ��������
        var checkDiagflag=$.m({
            ClassName:"web.DHCANOPArrangeClinics",
            MethodName:"IfHaveDiag",
            Adm:EpisodeID,
            groupId:session['LOGON.GROUPID']
        },false);
        if(checkDiagflag=="")
        {
	        $.messager.alert("��ʾ","�û�����û�����,������������","error");
             $("#btnSave").linkbutton('disable');
        }
        //�ж��Ƿ񳬹��Һ�����7��
        var checkValidflag=$.m({
            ClassName:"web.DHCANOPArrangeClinics",
            MethodName:"CheckAdmValid",
            Adm:EpisodeID,
            groupId:session['LOGON.GROUPID']
        },false);
        if(checkValidflag!="")
        {
	        $.messager.alert("��ʾ",checkValidflag,"error");
             $("#btnSave").linkbutton('disable');
        }
        //
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
}
//���ػ��߻�����Ϣ
function loadOperData(appList)
{
    var opDateTime=appList[4];
    var opDateTimeList=opDateTime.split("^");
       //----���߻�����Ϣ
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
    $("#PatBedNo").val(baseInfoList[7]);
    $("#patSeximg").prop("innerText","");
    if(PatGender=="��"){
			var imghtml="<img src='../images/man.png' alt='' style='margin-top:-5px;'/>"
			$("#patSeximg").append(imghtml)
		}else if(PatGender=="Ů"){
			var imghtml="<img src='../images/woman.png' alt='' style='margin-top:-5px;'/>";
			$("#patSeximg").append(imghtml)
		}
	//------

      $("#txtPatTele").val(baseInfoList[12]);
    
    var admDisChargeFlag=baseInfoList[11];
	if(admDisChargeFlag=="Y") 
	{
        alert("�û�����ҽ�ƽ���,�޷�����������");
        $("#btnSave").linkbutton('disable');
    }
    
	var patWardInfo=appList[1];
	var wardInfoList=patWardInfo.split("^");
	var operLoc=wardInfoList[0];
    loadCombobox("#OperLocation",operLoc);
    
    
   var appLoc=wardInfoList[1];
    //loadCombobox("#AppLocation",appLoc);
    $("#AppLocation").combobox("setValue",appLoc.split("!")[0]);
    $("#AppLocation").combobox("setText",appLoc.split("!")[1]);
    
    
    var appDoc=wardInfoList[2]
    loadCombobox("#AppDoctor",appDoc);
    
     var appDoc=wardInfoList[2];
    //loadCombobox("#AppDoctor",appDoc);
    $("#AppDoctor").combobox("setValue",appDoc.split("!")[0]);
    $("#AppDoctor").combobox("setText",appDoc.split("!")[1]);
    
    
    var operDate=opDateTimeList[0];
    $("#OperDate").datebox('setValue',operDate);		//���ռ����ڲ�����
    var operTime=opDateTimeList[1];
    if(operTime!="")
    {
     $("#OperTime").timespinner({
                required: false
            });
    }
    $("#OperTime").timespinner('setValue',operTime);
    //var operDuration=opDateTimeList[7];
    //$("#OperDuration").numberspinner('setValue',operDuration);
    //var preDiagAndNotes=wardInfoList[3];
    //var preDiag=preDiagAndNotes.split("#")[0];
    //setDefaultPrevDiagnos(preDiag);
    //var preDiagMen=preDiagAndNotes.split("#")[1];
    //$("#OperPreDiagMem").val(preDiagMen);
    var surgeonId=wardInfoList[5] ;
    loadCombobox("#comSurgeon",surgeonId)
    //var bodsList=wardInfoList[9];
    //var bodsIdList=getIdStr(bodsList);
    //$("#BodySite").combobox('setValues',bodsIdList);
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
    var selfReport=wardInfoList[14];
	   var patNotice=wardInfoList[17]
	   $("#txtPatSelfReport").val(selfReport);
	   $("#txtPatKnow").val(patNotice);
	  var opMem=wardInfoList[8]     //����˵��������Ҫ��
	$("#AreaOperMem").val(opMem);
    //var operPosition=wardInfoList[10];
    //loadCombobox("#OperPos",operPosition);
    var bloodType=wardInfoList[11]
    loadCombobox("#BloodType",bloodType);
    var operStock=wardInfoList[18];
     //loadCombobox("#comOpConsumable",operStock);
    $("#comOpConsumable").combobox("setValue",operStock.split("!")[0]);
    $("#comOpConsumable").combobox("setText",operStock.split("!")[1]);
    
	var operStockNote=wardInfoList[19];
	$("#txtstockItemNote").val(operStockNote);
	var comeHDTime=wardInfoList[20];
	if(comeHDTime!="")
	{$("#comeHosTime").timespinner({
                required: false
            });}
	$("#comeHosTime").timespinner('setValue',comeHDTime);
	//obj.comeHosTime.setRawValue(comeHDTime) //��Ժʱ��
	var anaesInfo=appList[2]
       var anaesInfoList=anaesInfo.split("^")
       var anMethodStr=anaesInfoList[5]	  //������
       var anaStrId=getIdStr(anMethodStr)
	   //if(anMethodStr=="") anMethodStr=_DHCANOPArrangeClinics.GetANAMethod("�ֲ�����");
		//$("#comAnaMethod").combobox('setValues',anaStrId);
		    
     var anDocMethodIdStr=getIdStr(anMethodStr)
    var anDocMethodDescStr=getDescStr(anMethodStr)
    if(anDocMethodIdStr!="")
    {
    $("#comAnaMethod").combobox('setValues',anDocMethodIdStr);
    $("#comAnaMethod").combobox('setText',anDocMethodDescStr);
    }


	 var opTheatreInfo=appList[3]	   
	   var opTheatreInfoList=opTheatreInfo.split("^")
	   	   var cirNurStr=opTheatreInfoList[4];
	   	   var cirNurIdStr=getIdStr(cirNurStr);
	  if(cirNurIdStr!="")
	  { 
	       var cdescid=getIdStr(cirNurStr)
		    var cdesc=getDescStr(cirNurStr)
		    if(cdescid!="")
		    {
		    $("#comCirculNurse").combobox('setValues',cdescid);
		    $("#comCirculNurse").combobox('setText',cdesc);
		    }

	  	//$("#comCirculNurse").combobox('setValues',cirNurIdStr);
	  }
	var opRoom=opTheatreInfoList[0];   //������
    loadCombobox("#comOperRoom",opRoom);
    var ordNo=opTheatreInfoList[1];
	loadCombobox("#comOrdNo",ordNo+"!"+ordNo);    //̨��
	if (appType=="RegOp"){
	    $("#dateOpStt").datebox('setValue',opDateTimeList[8]);
	    $("#timeOpStt").timespinner('setValue',opDateTimeList[9]);
	    $("#dateOpEnd").datebox('setValue',opDateTimeList[10]);
	    $("#timeOpEnd").timespinner('setValue',opDateTimeList[11]);

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
   //$("#OperType").combobox('setValue',opType);
   var needAnaesthetist=checkList[11];
   $("#IsAnaest").combobox('setValue',needAnaesthetist);
   var unPlanedOperFlag=checkList[15];
   //$("#ReentryOperation").combobox('setValue',unPlanedOperFlag);
   var isolated=checkList[7];
   $("#IsoOperation").checkbox('setValue',isolated=="Y"?true:false);
   var isPrepareBlood=checkList[8];
   $("#PrepareBlood").checkbox('setValue',isPrepareBlood=="Y"?true:false);
   var isUseSelfBlood=checkList[9];
   $("#TransAutoblood").checkbox('setValue',isUseSelfBlood=="Y"?true:false);
   var isExCirculation=checkList[10];
   $("#ECC").checkbox('setValue',isExCirculation=="Y"?true:false);
   var otherTest=checkList[5];
   //$("#LabTest").val(otherTest);
   
   var opReq=appOtherList[2];
	  $("#txtOpReq").val(opReq);
	  var note=appOtherList[1];
	  $("#txtNote").val(note);
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
                OperNote:operList[i].operNotes,
                OpSub:operList[i].opSub	////20190118+dyl+3
            }
            datas.push(data);
        }
    }
    if(datas!="")
    {
    $("#operationBox").datagrid('loadData',datas);
    }
}

function DayInRequired()
{
	
	 $("#OperDate").datebox({
                required: true
            });
     $("#OperTime").timespinner({
                required: true
            });
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

//��ȡ���߻�����Ϣ
function getPatInfo(){
    var datas=$.m({
        ClassName:"web.DHCANOPArrange",
        MethodName:"GetAnSingle",
        opaId:opaId,
        EpisodeID:EpisodeID,
        userId:session['LOGON.USERID'],
        type:"Out"
    },false);
    return datas;
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
        var mainOpSub=datas.rows[0].OpSub;	//20190118+dyl+1
        var mainSurgeonLocId="";
        var mainSurgeonId="";
        var mainSurgonAss1Id="";
        var mainSurgonAss2Id="";
        var mainSurgonAss3Id="";
        var mainSurgonAssoId="";
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
        var subOpSub=datas.rows[i].OpSub;	//20190118+dyl+2 
        var subSurgeonLocId="";
        var subSurgeonId="";
        var subSurgonAss1Id="";
        var subSurgonAss2Id="";
        var subSurgonAss3Id="";
        var subSurgonAssoId="";
        
        var doctorStr=subSurgeonLocId+"|"+subSurgeonId+"|"+subSurgonAss1Id+"|"+subSurgonAss2Id+"|"+subSurgonAss3Id+"|"+subSurgonAssoId;
        subOperStr=subOperStr+subOperId+"|"+subOperClassId+"|"+subOperNote+"|"+subBladeTypeId+"|"+subOpSub+"|"+doctorStr+"^";
    }
    return subOperStr;
}
//��ȡ���岿λ
function getBodySites(){
    var result=$.cm({
        ClassName:"web.DHCANOPArrangeHISUI",
        QueryName:"FindBodySite",
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
function getLabTestItems(){
    var result=$.cm({
        ClassName:"web.DHCANOPArrangeHISUI",
        QueryName:"checkqu",
        ResultSetType:"array"
    },false);
    return result;
}
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

function disableItem()
{
	$("#dateOpStt").datebox("disable");
	$("#timeOpStt").timespinner('disable');
	$("#dateOpEnd").datebox("disable");
	$("#timeOpEnd").timespinner('disable');
}
function getPrevAnaMethods(){
    var anaMethodArray = $("#comAnaMethod").combobox("getValues"),
        anaMethod="";
    if(anaMethodArray&&anaMethodArray.length>0)
    {
        anaMethod= anaMethodArray.join(",");
    }
    return anaMethod;
}
