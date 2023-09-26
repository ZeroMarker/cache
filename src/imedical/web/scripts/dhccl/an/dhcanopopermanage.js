var EpisodeID=dhccl.getUrlParam("EpisodeID");
var opaId=dhccl.getUrlParam("opaId"); 
var appType=dhccl.getUrlParam("appType"); 
$(function(){
    initPrevDiagnosGrid();
    initOperationGrid();
    initDataFormControls();
    initOperDelegates();
    DayInRequired(appType);
   //
    /*
    if(checkIfOutTime())
    {
        $.messager.alert("��ʾ","��������ʱ�����ƣ�������������������","error");
        $("#btnSave").linkbutton('disable');
    }
    */
    if((opaId!=null)&&(opaId!=""))
    {
        if(appType=="anaes")
        {
	        $('#tt').tabs('select', 1);
	        $("#btnSave").linkbutton('disable');
	         $("#btnOpSave").linkbutton('disable');
    	}
    	else if(appType=="op")
        {
	        $('#tt').tabs('select', 2);
	        $("#btnSave").linkbutton('disable');
	        $("#btnAnSave").linkbutton('disable');
    	}
    	else if(appType=="RegOp")
        {
	        $('#tt').tabs('select', 2);
	        //$("#btnSave").linkbutton('disable');
	        //$("#btnAnSave").linkbutton('disable');
    	}
        loadDatas();
        loadAnData();
        loadOpData();
    }
    if ((EpisodeID != "")&&((opaId=="")||(opaId==null))) {
                loadDatas();
            }
});

/// ��ʼ����ǰ����б����
function initPrevDiagnosGrid() {
    var preopDiagBox=$HUI.datagrid("#preopDiagBox",{
        height:80,
        fit:true,
        singleSelect:true,
        showHeader:false,
        rownumbers:true,
        toolbar:"#preopDiagTool",
        columns: [
            [
                { field: "DiagID", title: "ID", width: 80, hidden: true },
                { field: "DiagDesc", title: "����", width: 500 }
            ]
        ]
    })
}
var selectOperIndex=""
///��ʼ�������б����
function initOperationGrid(){
    var operationBox=$HUI.datagrid("#operationBox",{
        fit:true,
        singleSelect: true,
        rownumbers: true,
        toolbar: "#operationTool",
        columns: [
            [
                { field: "Operation", title: "��������Id", width: 240, hidden: true },
                { field: "OperationDesc", title: "��������", width: 240 },
                { field: "OperClass", title: "�����ּ�Id", width: 60 ,hidden:true },
                { field: "OperClassDesc", title: "�����ּ�", width: 60 },
                { field: "BladeType", title: "�����ּ�Id", width: 60 ,hidden:true },
                { field: "BladeTypeDesc", title: "�п�����", width: 60 },
                { field: "SurgeonLoc", title: "�����ּ�Id", width: 60 ,hidden:true },
                { field: "SurgeonLocDesc", title: "���߿���", width: 80 },
                { field: "Surgeon", title: "����id", width: 60 ,hidden:true },
                { field: "SurgeonDesc", title: "����", width: 50 },
                { field: "SurgeonNoteDesc", title: "��ע", width: 50 ,hidden:true },
                { field: "SurgonAss1", title: "һ��", width: 50 ,hidden:true },
                { field: "SurgonAss1Desc", title: "һ��", width: 50 },
                { field: "SurgonAss2", title: "����", width: 50 ,hidden:true },
                { field: "SurgonAss2Desc", title: "����", width: 50 },
                { field: "SurgonAss3", title: "����", width: 50 ,hidden:true },
                { field: "SurgonAss3Desc", title: "����", width: 50 },
                { field: "SurgonAsso", title: "����", width: 50 ,hidden:true },
                { field: "SurgonAssoDesc", title: "����", width: 50 },
                { field: "OperNote", title: "���Ʊ�ע", width: 60 },
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
    var OperLocation=$HUI.combobox("#OperLocation",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param){
            param.desc=param.q;
            param.locListCodeStr="OP^OUTOP^EMOP";
            param.EpisodeID=EpisodeID;
        }
    });

    var PrevAnaMethod=$HUI.combobox("#PrevAnaMethod",{
        valueField: "ID",
        textField: "Des",
        required: $("#IsAnaest").combobox("getValue") === "Y" ? true : false,
        multiple: true,
        rowStyle:'checkbox',
        editable:false,
        data:getAnaestMethods()
        /*onShowPanel:function(){
            var datas=$(this).combobox('getData');
            if(!datas||datas.length<=0)
            {
                datas=getAnaestMethods();
                $(this).combobox('loadData',datas);
            }
        }*/
    });

    var diagnosis=$HUI.combobox("#diagnosis",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=LookUpMrcDiagnosis&ResultSetType=array",
        valueField:"rowid0",
        textField:"DiagDes",
        onBeforeLoad:function(param){
            param.mrcidAlias=param.q;
        },
        mode: "remote"
    });
    //start
    var surgeonLoc=$HUI.combobox("#SurgeonLoc",{
        url:$URL+"?ClassName=web.DHCClinicCom&QueryName=FindSurgeonLocList&ResultSetType=array",
        valueField:"ctlocId",
        textField:"ctlocDesc",
        onBeforeLoad:function(param)
        {
	        //20180727+dyl+1
	        var surgeonId="";
	        var surgeonttt=$("#Surgeon").combobox("getText");
	        if(surgeonttt=="") {surgeonId="";}
	        else{surgeonId=$("#Surgeon").combobox("getValue");}
	        //1
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(operttt=="") {surgeonoperId="";}
	        else{ surgeonoperId=$("#Operation").combobox("getValue");}
            param.desc=param.q;
            param.locListCodeStr="INOPDEPT^OUTOPDEPT^EMOPDEPT";
            param.EpisodeID=EpisodeID;
            param.operId="";	//surgeonoperId;
            param.surgeonId=surgeonId;
        },
        onSelect:function(record){
	        //$("#Operation").combobox("reload");
	        $("#Surgeon").combobox("reload");
	        $('#SurgonAss1').combobox("reload");
			$('#SurgonAss2').combobox("reload");
			$('#SurgonAss3').combobox("reload");
			$('#SurgonAsso').combobox("reload");
	        $("#OpDocGroup").combobox("reload");
        },
        mode:"remote"
    })
    //$("#SurgeonLoc").combobox('setValue',session['LOGON.CTLOCID']);

    var surgeon=$HUI.combobox("#Surgeon",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        onBeforeLoad:function(param)
        {
	        //2
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(surgeontloc=="") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(operttt=="") {surgeonoperId="";}
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
        onChange:function(record)
        {
	       //20180727+dyl+2
	        var lastloc=$("#SurgeonLoc").combobox("getValue");
	        if(lastloc=="")
	        {
	        $('#SurgeonLoc').combobox("reload");
	        }
	        var lastoper=$("#Operation").combobox("getValue");
	        if(lastoper=="")
	        {
	        	$('#Operation').combobox("reload");
	        }

        },
        
        mode:"remote"
    })
    var surgeonass1=$HUI.combobox("#SurgonAss1",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        onBeforeLoad:function(param)
        {
	        //3
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(surgeontloc=="") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(operttt=="") {surgeonoperId="";}
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
        mode:"remote"
    })
        var surgeonass2=$HUI.combobox("#SurgonAss2",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        onBeforeLoad:function(param)
        {
	        //3
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(surgeontloc=="") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(operttt=="") {surgeonoperId="";}
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
        mode:"remote"
    })

    var surgeonass3=$HUI.combobox("#SurgonAss3",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        onBeforeLoad:function(param)
        {
	        //3
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(surgeontloc=="") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(operttt=="") {surgeonoperId="";}
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
        mode:"remote"
    })
    var surgeonasso=$HUI.combobox("#SurgonAsso",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        multiple: true,
        rowStyle:'checkbox',
        editable:false,
        onBeforeLoad:function(param)
        {
	        //3
	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(surgeontloc=="") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
	        var surgeonoperId="";
	        var operttt=$("#Operation").combobox("getText");
	        if(operttt=="") {surgeonoperId="";}
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
        mode:"remote"
    })

    var operclass=$HUI.combobox("#OperClass",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetOPLevel&ResultSetType=array",
        valueField:"ANCOPLRowId",
        textField:"ANCPLDesc",
        allowNull:true,
        editable:false
    });
    var bladetype=$HUI.combobox("#BladeType",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetBladeType&ResultSetType=array",
        valueField:"BLDTPRowId",
        textField:"BLDTPDesc",
        allowNull:true,
        editable:false
    });

    var operation=$HUI.combobox("#Operation",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindOrcOperation&ResultSetType=array",
        valueField:"rowid",
        textField:"OPTypeDes",
        onBeforeLoad:function(param)
        {
	        //4
            var surgeonId="";
	         var surgeonId=$("#Surgeon").combobox("getValue");
	        if (typeof surgeonId=="undefined") surgeonId="";

	        var surgeonlocId="";
	        var surgeontloc=$("#SurgeonLoc").combobox("getText");
	        if(surgeontloc=="") {surgeonlocId="";}
	        else{ surgeonlocId=$("#SurgeonLoc").combobox("getValue");}
            
            param.operDescAlias=param.q;
            param.OpDocId=surgeonId;
            param.ifDayOper="";
            param.surgeonLocId="";  //20180727+dyl+3:��������������й���	surgeonlocId;
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
	          var lastsur=$("#Surgeon").combobox("getValue");
	        if(lastsur=="")
	        {
	         $('#Surgeon').combobox("reload");
	        }
	        //$('#SurgeonLoc').combobox("reload");
        },
        mode:"remote"
    })
    var bodysite=$HUI.combobox("#BodySite",{
        valueField: "BODS_RowId",
        textField: "BODS_Desc",
        multiple: true,
        rowStyle:'checkbox',
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
            //����ҽʦ��
        var OpDocGroup=$HUI.combobox("#OpDocGroup",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindODGroupNew&ResultSetType=array",
        valueField:"groupID",
        textField:"groupID",
        panelWidth:300,
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

    var operpos=$HUI.combobox("#OperPos",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetOperPosition&ResultSetType=array",
        valueField:"OPPOS_RowId",
        textField:"OPPOS_Desc",
        editable:false,
        allowNull:true,
         panelHeight:'auto'
    })
    var bloodtype=$HUI.combobox("#BloodType",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetBlood&ResultSetType=array",
        valueField:"BLDTRowId",
        textField:"BLDTDesc",
        editable:false,
         panelHeight:'auto',
         allowNull:true,
        data:getBloodTypeItems()
    });
    var rhbloodtype=$HUI.combobox("#RHBloodType",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=RHBlood&ResultSetType=array",
        valueField:"RHId",
        textField:"RHDesc",
        editable:false,
        allowNull:true,
        data:getRHBloodTypeItems()
    });
    var HbsAg=$HUI.combobox("#HbsAg,#HcvAb,#HivAb,#Syphilis",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"ord",
        textField:"typ",
        editable:false,
        allowNull:true,
         panelHeight:'auto',
        data:getLabTestItems()
    })
        var OperType=$HUI.combobox("#OperType",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
         panelHeight:'auto',
        data:[{'typedesc':"����",'typecode':"B"},{'typedesc':"����",'typecode':"E"}]
    })
    var yesno=$HUI.combobox("#ReentryOperation,#IsAnaest",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        allowNull:true,
         panelHeight:'auto',
        data:[{'typedesc':"��",'typecode':"Y"},{'typedesc':"��",'typecode':"N"}]
    }) 
    var yesno2=$HUI.combobox("#chkIfShift",{
        //url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=checkqu&ResultSetType=array",
        valueField:"typecode",
        textField:"typedesc",
        editable:false,
        allowNull:true,
         panelHeight:'auto',
        data:[{'typedesc':"��",'typecode':"1"},{'typedesc':"��",'typecode':"0"}]
    }) 
    var timeinit=$HUI.timespinner("#OperTime,#timeArrOper,#timeOpStt,#timeOpEnd",{ 
    }) 
     var numinit=$HUI.numberspinner("#OperDuration,#PlanSeq",{ 
     min: 1,    
    max: 30,    
    editable: false 
    }) 

    //---��������
        var AnMainDoc=$HUI.combobox("#AnMainDoc",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        editable:false,
        allowNull:true,
        onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="AN^OUTAN^EMAN";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
            
        }
    });
    //$("#AnMainDoc").combobox("initClear");
	var AnSuperDoc=$HUI.combobox("#AnSuperDoc",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        editable:false,
        allowNull:true,
        onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="AN^OUTAN^EMAN";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
            
        }
    });
    //$("#AnSuperDoc").combobox("initClear");
    var AnAss=$HUI.combobox("#AnAss",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        editable:false,
        allowNull:true,
        onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="AN^OUTAN^EMAN";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
            
        }
    });
    var ShiftANDoc=$HUI.combobox("#ShiftANDoc",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        editable:false,
        allowNull:true,
        onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="AN^OUTAN^EMAN";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="Y";
            param.ifSurgeon="";
            
        }
    });
    var AnNurse=$HUI.combobox("#AnNurse",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        allowNull:true,
        panelHeight:'auto',
        editable:false,
        onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="AN^OUTAN^EMAN";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="N";
            param.ifSurgeon="";
            
        }
    });
    var AnaLevel=$HUI.combobox("#AnaLevel",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetAnaLevel&ResultSetType=array",
        valueField:"anaLevelId",
        textField:"levelDesc",
        editable:false,
        allowNull:true,
        panelHeight:'auto'
    });
    var AnaMethod=$HUI.combobox("#AnaMethod",{
        valueField: "ID",
        textField: "Des",
        rowStyle:'checkbox',
        editable:false,
        
        required: $("#IsAnaest").combobox("getValue") === "Y" ? true : false,
        multiple: true,
        data:getAnaestMethods()
      
    });  
    //���������
    var comOperRoom=$HUI.combobox("#comOperRoom",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindAncOperRoom&ResultSetType=array",
        valueField:"oprId",
        textField:"oprDesc",
         editable:false,
         allowNull:true,
        panelHeight:'auto',
         onBeforeLoad:function(param){
            param.oprDesc=$HUI.combobox("#comOperRoom").getText();
            param.locDescOrId=$("#OperLocation").combobox("getValue");
            param.locListCodeStr="OP";
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
    		 $("#comScrubNurse").combobox('setValues',scrNurId);
    		 $("#comCirculNurse").combobox('setValues',cirNurId);
        },
      mode:'remote'  
    });
    var comOrdNo=$HUI.combobox("#comOrdNo",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=GetOrdNo&ResultSetType=array",
        valueField:"Id",
        textField:"Desc"
        
    });
        var comScrubNurse=$HUI.combobox("#comScrubNurse",{
	     url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        rowStyle:'checkbox',
        editable:false,
        multiple: true,
         onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="OP";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="N";
            param.ifSurgeon="N";
            
        }
    });
    var comShiftScrubNurse=$HUI.combobox("#comShiftScrubNurse",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        rowStyle:'checkbox',
        editable:false,
        multiple: true,
        onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="OP";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="N";
            param.ifSurgeon="N";
            
        }
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
            param.locListCodeStr="OP";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="N";
            param.ifSurgeon="N";
            
        }
    });
    var comShiftCirculNurse=$HUI.combobox("#comShiftCirculNurse",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindCtcp&ResultSetType=array",
        valueField:"ctcpId",
        textField:"ctcpDesc",
        multiple: true,
        rowStyle:'checkbox',
        editable:false,
        onBeforeLoad:function(param){
            param.needCtcpDesc=param.q;
            param.locListCodeStr="OP";
            param.locDescOrId="";
            param.EpisodeID="";
            param.opaId="";
            param.ifDoctor="N";
            param.ifSurgeon="N";
            
        }
    });
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
    $("#btnAnSave").linkbutton({
        onClick: saveAnRecord
    });

    $("#btnAnCancel").linkbutton({
        onClick: closeWindow
    });
    $("#btnOpSave").linkbutton({
        onClick: saveOpRecord
    });

    $("#btnOpCancel").linkbutton({
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
//��������������Ϣ
function loadOpData()
{
	var patInfo=getPatInfo();
    var appList=patInfo.split("@");
     var opDateTime=appList[4];
	var opDateTimeList=opDateTime.split("^")
    var opTheatreInfo=appList[3];
	var opTheatreInfoList=opTheatreInfo.split("^");
	var opRoom=opTheatreInfoList[0];   //������
    loadCombobox("#comOperRoom",opRoom);
    var ordNo=opTheatreInfoList[1];
	loadCombobox("#comOrdNo",ordNo+"!"+ordNo);    //̨��
    var opArrTime=opDateTimeList[3];
	$("#timeArrOper").timespinner('setValue',opArrTime)
	   
	   
	 var scNurStr=opTheatreInfoList[2];  //��е��ʿ
	 var scNurIdStr=getIdStr(scNurStr);
	 if(scNurIdStr!="")
	 {
    $("#comScrubNurse").combobox('setValues',scNurIdStr);
	 }
	 var scSNurStr=opTheatreInfoList[3];  //j��е��ʿ
	 var scSNurIdStr=getIdStr(scSNurStr);
	  if(scSNurIdStr!="")
	 {
    	$("#comShiftScrubNurse").combobox('setValues',scSNurIdStr);
	 }
	 var cirNurStr=opTheatreInfoList[4];  //��е��ʿ
	 var cirNurIdStr=getIdStr(cirNurStr);
	if(cirNurIdStr!="")
	{
    $("#comCirculNurse").combobox('setValues',cirNurIdStr);
	}
	 var cirSNurStr=opTheatreInfoList[5];  //j��е��ʿ
	 var cirSNurIdStr=getIdStr(cirSNurStr);
	 if(cirSNurIdStr!="")
	 {
    	$("#comShiftCirculNurse").combobox('setValues',cirSNurIdStr);
	 }

	   var scNurNote=opTheatreInfoList[6];
	   $("#txtScrubNurseNote").val(scNurNote);
	  // alert(opTheatreInfoList)
	   var cirNurNote=opTheatreInfoList[7];
	  $("#txtCirculNurseNote").val(cirNurNote);
	   if (appType=="RegOp")
	   {
		    $("#dateOpStt").datebox('setValue',opDateTimeList[8]);		//���ռ����ڲ�����
    		$("#timeOpStt").timespinner('setValue',opDateTimeList[9]);
		     $("#dateOpEnd").datebox('setValue',opDateTimeList[10]);
		     $("#timeOpEnd").timespinner('setValue',opDateTimeList[11]);
		    //obj.dateOpStt.setRawValue(opDateTimeList[8]);
			//obj.timeOpStt.setRawValue(opDateTimeList[9]);
			//obj.dateOpEnd.setRawValue(opDateTimeList[10]);
			//obj.timeOpEnd.setRawValue(opDateTimeList[11]);
	   }
	   else if (appType=="op")
	   {
		   $("#dateOpStt").datebox("disable");
		   $("#timeOpStt").timespinner("disable");
		   $("#dateOpEnd").datebox("disable");
		   $("#timeOpEnd").timespinner("disable");
	   }
	      var operQTData=$.m({
            ClassName:"web.DHCANOPArrangeHISUI",
            MethodName:"GetQTData",
            opaId:opaId
        },false);
   var appOtherList=operQTData.split("$");
	var opReq=appOtherList[2];
	  $("#txtOpReq").val(opReq);
	  var isshift=appOtherList[5];
	  $("#chkIfShift").combobox('setValue',isshift);
}

//������������Ϣ
function loadAnData()
{
	var patInfo=getPatInfo();
    var appList=patInfo.split("@");
    var anaInfo=appList[2];
	var anaInfoList=anaInfo.split("^");
	var anDoc=anaInfoList[0];
    loadCombobox("#AnMainDoc",anDoc);
    var anSupDoc=anaInfoList[1];
    loadCombobox("#AnSuperDoc",anSupDoc);
    var anNurse=anaInfoList[2];
    loadCombobox("#AnNurse",anNurse);
    var anAssStr=anaInfoList[3];
    loadCombobox("#AnAss",anAssStr);
    var shiftAnAssStr=anaInfoList[4];
    loadCombobox("#ShiftANDoc",shiftAnAssStr);
    var anMethodStr=anaInfoList[5];
    var anMethodIdStr=getIdStr(anMethodStr)
    if(anMethodIdStr!="")
    {
    	$("#AnaMethod").combobox('setValues',anMethodIdStr);
    }
    var anaLevel=anaInfoList[6]	//�����ģ	//20160908+dyl
     loadCombobox("#AnaLevel",anaLevel) 
    var anDocNote=anaInfoList[7]	//����ע
    $("#ANDocMem").val(anDocNote)	
}
//��������
function loadDatas(){
	if(appType=="op")
	{
		$("#paneltitle").prop("innerText","��������");
	}
	else if(appType=="RegOp")
	{
		$("#paneltitle").prop("innerText","�����Ǽ�");
	}
	else
	{
		$("#paneltitle").prop("innerText","������");
	}
    var patInfo=getPatInfo();
    var appList=patInfo.split("@");
    loadOperData(appList);
    if((opaId==null)||(opaId==""))
    {
        var checkinbedflag=$.m({
            ClassName:"web.DHCANOPArrange",
            MethodName:"CheckInBedFlag",
            adm:EpisodeID
        },false);
        if(checkinbedflag=="N")
		 {
			// $.messager.alert("��ʾ","������δ���Ŵ�λ","error");
            // $("#btnSave").linkbutton('disable');
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
    }else{
         
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
    //$("#AppLocation").combobox("setValue",appLoc.split("!")[0]);
    //$("#AppLocation").combobox("setText",appLoc.split("!")[1]);
    $("#AppLocation").prop("innerText",appLoc.split("!")[1]);
    var appDoc=wardInfoList[2]
    //loadCombobox("#AppDoctor",appDoc);
    //$("#AppDoctor").combobox("setValue",appDoc.split("!")[0]);
    //$("#AppDoctor").combobox("setText",appDoc.split("!")[1]);
    $("#AppDoctor").prop("innerText",appDoc.split("!")[1]);
    var operDate=opDateTimeList[0];
    $("#OperDate").datebox('setValue',operDate);		//���ռ����ڲ�����
    var operTime=opDateTimeList[1];
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
    var bodsList=wardInfoList[9];
    var bodsIdList=getIdStr(bodsList);
    $("#BodySite").combobox('setValues',bodsIdList);
    var operPosition=wardInfoList[10];
    loadCombobox("#OperPos",operPosition);
    var bloodType=wardInfoList[11]
    loadCombobox("#BloodType",bloodType);
    var opSeq=wardInfoList[12]
    $("#PlanSeq").numberspinner('setValue',opSeq);

    var anaesInfo=appList[2]
    var anaesInfoList=anaesInfo.split("^");
    var anDocMethodStr=anaesInfoList[8];
    var anDocMethodIdStr=getIdStr(anDocMethodStr)
    if(anDocMethodIdStr!="")
    {
    $("#PrevAnaMethod").combobox('setValues',anDocMethodIdStr);
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
                SurgeonNoteDesc:"",
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
    if (newValue === "Y") {
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

function DayInRequired(appType)
{
	/*
	 $("#OperDate").datebox({
                required: false
            });
     $("#OperTime").timespinner({
                required: false
            });
     $("#OperDuration").numberspinner({
                required: false
            });
      $("#BloodType").combobox({
                required: false
            });
      $("#RHBloodType").combobox({
                required: false
            });
      $("#HbsAg").combobox({
                required: false
            });
      $("#HcvAb").combobox({
                required: false
            });
      $("#HivAb").combobox({
                required: false
            });
       $("#Syphilis").combobox({
                required: false
            });
            */
       if(appType=="anaes")
       {
	       $("#AnMainDoc").combobox({
                required: true
            });
           $("#AnaMethod").combobox({
                required: true
            });
       }
       $("#BodySite").combobox({
                required: false
            });
       $("#OperPos").combobox({
                required: false
            });
            
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
            for(var i=0;i<preDiagList.length;i++)
            {
                var item=preDiagList[i].split("!");
                if(item[0]==""&&item[1]=="") continue;
                var data={DiagID:item[0],DiagDesc:item[1]};
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
	}
}
function loadComboboxByDesc(container,desc)
{   
    var datas=$(container).combobox('getData');
    if(datas&&datas.length>0)
    {
        $.each(datas,function(i,data){
           if(data.RHDesc&&(data.RHDesc==desc)){
                $(container).combobox('setValue',data.RHId);
            }
            else if(data.typ&&(data.typ==desc))
            {
                 $(container).combobox('setValue',data.ord);
            }
            else if(data.BLDTDesc&&(data.BLDTDesc==desc))
            {
	             $(container).combobox('setValue',data.BLDTRowId);
            }

        })
    }
}

//���һ�����
function addPrevDiagnos(){
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
      var exsitflag2=0
    if (rows && rows.length > 0) {
        $.each(rows, function(index, row) {
	        if(diagID==row.DiagID)
	        {
		        $.messager.alert("��ʾ","������Ѵ���!","error");
                    exsitflag2=1;
                    return;
	        }
        });
    }
    if(exsitflag2==1)return;
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
        $.messager.alert("��ʾ","��ѡ��Ҫɾ�������","error");
        return;
    }
}
function InitOperDiag()
{
	$('#OpDocGroup').combobox("enable");
	$("#SurgeonLoc").combobox("reload");
    $("#SurgeonLoc").combobox('setValue',session['LOGON.CTLOCID']);
    var lastloc=$("#SurgeonLoc").combobox("getValue");
	if(lastloc!="")
	{
	$('#Surgeon').combobox("reload");
	$('#SurgonAss1').combobox("reload");
	$('#SurgonAss2').combobox("reload");
	$('#SurgonAss3').combobox("reload");
	$('#SurgonAsso').combobox("reload");
	$('#OpDocGroup').combobox("reload");
	        }
	$('#Operation').combobox("reload");
	//$("#Operation").combobox("setValue","");
}
/// ���һ�������������б�
function addAnaestOperation() {
    $("#operDialog").dialog({
        title: "��������",
        iconCls: "icon-w-add"
    });
    InitOperDiag();
    $("#operDialog").dialog("open");
    $("#OpSubDr").val("")	//20190118+dyl+7
    //setOperFormDefaultValue();
}
//�޸�������Ϣ
function editAnaestOperation(){
    var selectRow=$("#operationBox").datagrid("getSelected");
    if(selectRow)
    {
        $("#operDialog").dialog({
            title: "�޸�����",
            iconCls: "icon-w-edit"
        });
        
        //$("#operationForm").form('load',selectRow);
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
        $("#Operation").combobox('setValue',soperId)
         $("#OperClass").combobox('setValue',soperClassId)
        $("#BladeType").combobox('setValue',sbladeTypeId)
        $("#Surgeon").combobox('setValue',ssurgeonId)
         $("#Surgeon").combobox('setText',ssurgeonDesc)
        $("#SurgonAss1").combobox('setValue',ssurgonAss1Id)
         $("#SurgonAss1").combobox('setText',ssurgonAss1Desc)
        $("#SurgonAss2").combobox('setValue',ssurgonAss2Id)
         $("#SurgonAss2").combobox('setText',ssurgonAss2Desc)
        $("#SurgonAss3").combobox('setValue',ssurgonAss3Id)
         $("#SurgonAss3").combobox('setText',ssurgonAss3Desc)
        if(sSurgonAssoStr!="")
        {
	        var newsurother=getIdStr(sSurgonAssoStr)
        	$("#SurgonAsso").combobox('setValues',newsurother)
        }
        $("#OperNote").val(soperNote);
        var ssubOpSub=selectRow.OpSub;
        $("#OpSubDr").val(ssubOpSub)	////20190118+dyl+4
        //$("#SurgonAsso").combobox('setText',sSurgonAssoDesc)
        $("#operDialog").window("open");
        $("#EditOperation").val("Y");

    }else{
        $.messager.alert("��ʾ", "����ѡ��Ҫ�޸ĵ�������", 'info');
        return;
    }
}
function removeAnaestOperation(){
    var selectRow=$HUI.datagrid("#operationBox").getSelected();
    var rowIndex=$HUI.datagrid("#operationBox").getRowIndex(selectRow);
    if(selectRow)
    {
	     $("#OpSubDr").val("")	//20190118+dyl+9
        $HUI.datagrid("#operationBox").deleteRow(rowIndex);
    }else{
        $.messager.alert("��ʾ", "����ѡ��Ҫɾ����������", 'info');
        return;
    }
}
function disablePatientsList(){
	$("#patientNo").searchbox("disable");
	$("#patientLoc").combobox("disable");
	$("#patientWard").combobox("disable");
	$("#btnSearch").linkbutton("disable");
	//$('#patientsList').datagrid('unselectAll');
}
//����������Ϣ��ǰ̨datagrid��
function saveOperation()
{
    var operId=$HUI.combobox("#Operation").getValue();
    var operDesc=$HUI.combobox("#Operation").getText();
    var operNote=$("#OperNote").val();
    if(operId=="")
    {
        $.messager.alert("��ʾ","�������Ʋ���Ϊ�գ�","error");
        return;
    }
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
    if(surgeonId=="")
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
    
    var surgonAss2Id=$HUI.combobox("#SurgonAss2").getValue();
    var surgonAss2Desc=$HUI.combobox("#SurgonAss2").getText();
    if(surgonAss2Desc=="")
    {
	    surgonAss2Id="";
    }
    
    var surgonAss3Id=$HUI.combobox("#SurgonAss3").getValue();
    var surgonAss3Desc=$HUI.combobox("#SurgonAss3").getText();
    if(surgonAss3Desc=="")
    {
	    surgonAss3Id="";
    }
    
    var SurgonAssoId=$HUI.combobox("#SurgonAsso").getValue();
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
        //SurgeonNoteDesc:surgeonNote,
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
        //var rowIndex=$HUI.datagrid("#operationBox").getRowIndex();
		$HUI.datagrid("#operationBox").updateRow({index:selectOperIndex,row:rowdata});    
		}
    else
    {
	    var exsitflag=0;
        var data=$HUI.datagrid("#operationBox").getData();
       // alert(data)
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
        subOperStr=subOperStr+subOperId+"|"+subOperClassId+"|"+subOperNote+"|"+subBladeTypeId+"|"+subOpSub+"|"+doctorStr+"#";
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
//
function GetComScrubNurses() {
    var result=$.cm({
        ClassName:"web.DHCANOPArrangeHISUI",
        QueryName:"FindCtcp",
        needCtcpDesc:$("#comScrubNurse").combobox("getValues"),
        locListCodeStr:"OP",
        locDescOrId:"",
        EpisodeID:"",
        opaId:"",
        ifDoctor:"",
        ifSurgeon:"",
        ResultSetType:"array"
    },false)
    return result;
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
function saveOpRecord()
{
	//var ret=_DHCANOPArrange.UpdateOpRecord(opaId,str1,scrNurse,cirNurse,strOp,appType);
	//
     var scrNurIdStr="";
	var sNurArray = $("#comScrubNurse").combobox("getValues");
    if(sNurArray&&sNurArray.length>0)
    {
        scrNurIdStr= sNurArray.join(",");
    }
    //
     var sScrNurIdStr="";
    var sScrNurArray = $("#comShiftScrubNurse").combobox("getValues");
    if(sScrNurArray&&sScrNurArray.length>0)
    {
        sScrNurIdStr= sScrNurArray.join(",");
    }
    //
	  var scrNurNote=$("#txtScrubNurseNote").val();
	  var scrNurse=scrNurIdStr+"#"+sScrNurIdStr+"#"+scrNurNote;

     var cirNurIdStr="";
	var CirNurArray = $("#comCirculNurse").combobox("getValues");
    if(CirNurArray&&CirNurArray.length>0)
    {
        cirNurIdStr= CirNurArray.join(",");
    }
    //
     var sCirNurIdStr="";
    var sCirNurArray = $("#comShiftCirculNurse").combobox("getValues");
    if(sCirNurArray&&sCirNurArray.length>0)
    {
        sCirNurIdStr= sCirNurArray.join(",");
    }
    //
	  var cirNurNote=$("#txtCirculNurseNote").val();
	  var cirNurse=cirNurIdStr+"#"+sCirNurIdStr+"#"+cirNurNote;



    var arrTime=$("#timeArrOper").timespinner('getValue');
    var oproom=$("#comOperRoom").combobox('getValue');
    if (typeof oproom=="undefined") ordNo="";
    if(oproom=="")
    {
	     $.messager.alert("��ʾ","��ѡ��������","error");
	     return;
    }
    var ordNo=$("#comOrdNo").combobox('getValue');
    if (typeof ordNo=="undefined") ordNo="";
    if(ordNo=="")
    {
	     $.messager.alert("��ʾ","��ѡ��̨��","error");
	     return;
    }
    var ifShift=$("#chkIfShift").combobox('getValue');
    var opReq=$("#txtOpReq").val();
   var opDateTime="";
    if (appType=="RegOp"){
	    var opDateTime= $("#dateOpStt").datebox('getValue')+"|"+$("#timeOpStt").timespinner('getValue')+"|"+$("#dateOpEnd").datebox('getValue')+"|"+$("#timeOpEnd").timespinner('getValue');
       }

    var str1=oproom+"^"+arrTime;
   //alert(str1)
    var strOp=session['LOGON.USERID']+"^"+opReq+"^"+""+"^"+ifShift+"^"+ordNo+"^"+""+"^"+opDateTime;
		if((opaId==null)||(opaId=="")) return;
     else{
        var result=$.m({
             ClassName:"web.DHCANOPArrange",
             MethodName:"UpdateOpRecordNew",
             opaId:opaId,
             str1:str1,
             scr:scrNurse,
             cir:cirNurse,
             strOp:strOp,
             appType:appType,
             AppLocType:"I"
         },false)
		if(result!=0)
		{
			alert(result);
			window.returnValue=0;	//20181207
			return;
     	}
     	else
     	{
	     	$.messager.confirm("ȷ��","��������Ϣ�޸ĳɹ����Ƿ�����޸�������Ϣ��",function(r){
                if(!r)
                {
	                window.returnValue=1;	//20181207
                    window.close();
                }
             })
	     	
     	}
     }


}
//������
function saveAnRecord()
{
	 var anDocId=$("#AnMainDoc").combobox('getValue');
	 if (typeof anDocId=="undefined") anDocId="";
    if(anDocId=="")
    {
	     $.messager.alert("��ʾ","��ѡ������ҽʦ","error");
	     return;
    }
	  var anSupDocId=$("#AnSuperDoc").combobox('getValue'); 
	  var anNurseId=$("#AnNurse").combobox('getValue');
	  var anAssIdStr=$("#AnAss").combobox('getValue');
	  var shiftAnAssIdStr=$("#ShiftANDoc").combobox('getValue');
	 var anaLevel=$("#AnaLevel").combobox('getValue');
	var anaMethodArray = $("#AnaMethod").combobox("getValues");
	if(anaMethodArray.length==0)
	{
		$.messager.alert("��ʾ","��ѡ��������","error");
	     return;
	}
     var anaMethodIdStr="";
     
    if(anaMethodArray&&anaMethodArray.length>0)
    {
        anaMethodIdStr= anaMethodArray.join(",");
    }
	var andocmen=$("#ANDocMem").val();
	//opaId,anMethodIdStr,anDocId,anNurseId,anAssIdStr,shiftAnAssIdStr,anSupDocId,anDocNote,anaLevelId,ASAId);
	if((opaId==null)||(opaId=="")) return;
     else{
        var result=$.m({
             ClassName:"web.DHCANOPArrange",
             MethodName:"UpdateAnRecord",
             opaId:opaId,
             anmthIdStr:anaMethodIdStr,
             anDocId:anDocId,
             anNurseId:anNurseId,
             anAssIdStr:anAssIdStr,
             shiftAnAssIdStr:shiftAnAssIdStr,
             anSupDocId:anSupDocId,
             anDocNote:andocmen,
             anaLevelId:anaLevel,
             ASAId:""
         },false)
		if(result!=0)
		{
			
			alert(result);
			window.returnValue=0;	//20181207
			return;
     	}
     	else
     	{
	     	$.messager.confirm("ȷ��","������Ϣ�޸ĳɹ����Ƿ�����޸�������Ϣ��",function(r){
                if(!r)
                {
	                window.returnValue=1;	//20181207
                    window.close();
                }
             })
	     	
     	}
     }
}
//������������
function saveOperApplication(){
     var checkResult=CheckData();
     if(checkResult==false) return;
     var appLocId=""
     //var appLocId=$("#AppLocation").combobox('getValue');
     var appDocId=""
     //var appDocId=$("#AppDoctor").combobox('getValue');
     var operLocationId=$("#OperLocation").combobox('getValue');
     var operType=$("#OperType").combobox('getValue');
     var operDate=$("#OperDate").datebox('getValue');
     var operTime=$("#OperTime").timespinner('getValue');
     var operDuration=$("#OperDuration").numberspinner('getValue');
     var isAnaest=$("#IsAnaest").combobox('getValue');
     var anaMethod=getPrevAnaMethods();
     var reentryOperation=$("#ReentryOperation").combobox('getValue');
     var prevDiagnosisId=$("#PrevDiagnosis").val();
     var operPreDiagMem=$("#OperPreDiagMem").val();
     var preDiagStr=prevDiagnosisId+"|"+operPreDiagMem;
     var mainOperStr=getMainOperStr();
     if(mainOperStr=="")
     {
	     $.messager.alert("��ʾ","��������Ϊ��","error");
	     return;
     }
     var subOperStr=getSubOperStr();
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
     var opDocNote="";
     var str1=appLocId+"^"+appDocId+"^"+operDate+"^"+operTime+"^"+session['LOGON.USERID']+"^"+EpisodeID+"^^"+operMem+"^"+bloodTypeId+"^^^^^^"+operDuration+"^"+opDocNote+"^"+planSeq+"^^^^";
     var appOperInfo=mainOperStr+"^"+preDiagStr+"^"+""+"^"+""+"^"+operLocationId+"^"+bodySiteId+"^"+operPosId+"^"+subOperStr;
     var assDocIdStr="";
     var strCheck=HbsAgDesc+"^"+HcvAbDesc+"^"+HivAbDesc+"^"+SyphilisDesc+"^"+operType+"^"+labTestNote+"^"+RHBloodTypeDesc+"^"+isoOperation+"^"+isPrepareBlood+"^"+isTransAutoblood+"^"+isECC
                  +"^"+isAnaest+"^^^^^"+reentryOperation;
     
     if((opaId==null)||(opaId=="")) return;
     else{
        var result=$.m({
             ClassName:"web.DHCANOPArrangeHISUI",
             MethodName:"updatewardRecord",
             itmjs:"InsertAddOnOperation",
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
             $.messager.alert("����","�޸������������"+result,"warning");
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
        //$.messager.alert("��ʾ","��������ʼʱ��!","error");
		//return false;
    }
    if($HUI.combobox("#BloodType").getValue()=="")
    {
        //$.messager.alert("��ʾ","��ѡ����Ѫ��!","error");
		//return false;
    }
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
