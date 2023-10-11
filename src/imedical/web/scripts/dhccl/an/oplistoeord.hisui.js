var isSet=false
var AnaestId="";
var opaId="",status="";
var win=top.frames['eprmenu'];
if (win)
{
	var frm = win.document.forms['fEPRMENU'];
	if (frm)
	{
		var EpisodeID=frm.EpisodeID.value; 
		var PatientID=frm.PatientID.value; 
		var mradm=frm.mradm.value;
		if (frm.AnaesthesiaID)
		{			
		var AnaestId=frm.AnaesthesiaID.value;
		}
		isSet=true;
		}
	}
	if (isSet==false)
	{
		var frm =dhcsys_getmenuform();
		if (frm) { 		
			var EpisodeID=frm.EpisodeID.value; 
				var PatientID=frm.PatientID.value; 
				var mradm=frm.mradm.value; 
				if (frm.AnaesthesiaID)
				{			
					var AnaestId=frm.AnaesthesiaID.value;
					}
					}
		}
var logLocId=session['LOGON.CTLOCID'];
$(function(){
	var logLocType=getLogLocType();
	InitPatList();
	InitPatOper();
	var operRoom=$HUI.combobox("#OperRoom",{
        url:$URL+"?ClassName=web.DHCANOPArrangeHISUI&QueryName=FindAncOperRoom&ResultSetType=array",
        valueField:"oprId",
        textField:"oprDesc",
        onBeforeLoad:function(param)
        {
            param.oprDesc=param.q;
            param.locDescOrId="";
            param.locListCodeStr="OP^OUTOP^EMOP";
            param.EpisodeID="";
            param.opaId="";
            param.oprBedType="T";
            param.appLocDescOrId="";
        }
    });
});
function InitPatList()
{
	
		var operList=$HUI.datagrid("#OpPatientList",{
        fit:true,
        rownumbers: true,
        singleSelect: true,
        pagination: true,
        displayMsg:'',
        headerCls:'panel-header-gray',
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANOPArrangeHISUI",
            QueryName:"GetOpListForOeOrd"
        },
        onBeforeLoad:function(param)
        {
	        var paytype=$("#chkPaidOp").checkbox('getValue')?"Y":"N";
	        var patientNo = $("#patientNo").searchbox('getValue');
	        var medNo= $("#medcareNo").searchbox('getValue');
            param.stdate=$("#DateFrom").datebox('getValue');
            param.enddate=$("#DateTo").datebox('getValue');
            param.oproom=($("#OperRoom").combobox('getText')=="")?"":$("#OperRoom").combobox('getValue');
            param.AnaId=AnaestId;
            param.patRegNo=patientNo;
            param.patMedNo=medNo;
            param.orderStr=logLocType+"^"+paytype;
            param.OperLocId=logLocId;
        },
        onClickRow: function(rowIndex, rowData) {
			opaId = rowData["opaId"];
			$('#operationBox').datagrid({	
				queryParams:{
            ClassName:"web.DHCANOPArrangeHISUI",
            QueryName:"GetOpList"
	        },
	        onBeforeLoad:function(param)
	        {
	            param.opaId=opaId;
	        }})

			var EpisodeID = rowData["adm"];
			var PatientID=rowData["PatientID"];
			var mradm=rowData["adm"];
			var AnaesthesiaID=rowData["AnaesthesiaID"];
		var win=top.frames['eprmenu'];
		if (win)
		{
			var frm = win.document.forms['fEPRMENU'];
			if (frm)
			{
				frm.EpisodeID.value=EpisodeID; 
				frm.PatientID.value=PatientID; 
				frm.mradm.value=mradm; 
 				if (frm.AnaesthesiaID)
						frm.AnaesthesiaID.value = AnaesthesiaID;
				isSet=true;
			}
		}
		else
		{
			var frm =dhcsys_getmenuform();
			if (frm) { 				
				frm.EpisodeID.value=EpisodeID; 
				frm.PatientID.value=PatientID; 
				frm.mradm.value=mradm; 
				if (frm.AnaesthesiaID)
						frm.AnaesthesiaID.value = AnaesthesiaID;
					}
		}
		switchPatient(PatientID,EpisodeID,mradm);
		},
 	columns: [
            [
            //opaId,opordno,anaId,adm,patName,gender,age,opdes,opd,opaStatus,appLocDesc,PatientID
                { field: "oproomdes", title: "����", width: 50 },
                { field: "ordno", title: "̨��", width: 40 } ,
                { field: "patName", title: "����", width: 60 },
                { field: "opdes", title: "��������", width: 120 },
                { field: "opd", title: "����", width: 80 },
                 { field: "gender", title: "�Ա�", width: 40 },
                { field: "age", title: "����", width: 40 },
                { field: "opNurseOrd", title: "�����շ�", width: 60 },
                { field: "anaDoctorOrd", title: "�����շ�", width: 60 },

                { field: "opaStatus", title: "״̬", width: 50 },
               //{ field: "oproomdes", title: "����", width: 80 },
                { field: "PatientID", title: "PatientID", hidden: true },
                { field: "opaId", title: "opaid", hidden: true },
                { field: "adm", title: "adm", hidden: true },
                { field: "AnaesthesiaID", title: "anaid", hidden: true } 
                ]                
        ],
        onSelect:function(index,data){
            //$("#patient-toolbar").find(".content").html(data.patname+" / "+data.sex+" / "+data.age+" / "+data.regno);
        },
        toolbar:[
            {
                iconCls: 'icon-write-order',
			    text:'�Ʒ�ȷ��',
			    handler: function(){
                    ConfirmOrdered();
				}
            }
            ],
        onLoadSuccess:function(data){
	       	if(AnaestId!="")
			{
				$("#OpPatientList").datagrid('selectRow',0);
				var selectRow=$("#OpPatientList").datagrid("getSelected");
		    	if(selectRow)
		    	{
					opaId=selectRow.opaId;
					status=selectRow.opaStatus
					
		    	}
				if(opaId!="")$('#operationBox').datagrid('reload');
			}
        }
    });
}
function getLogLocType(){
    var locFlag=$.m({
        ClassName:"web.UDHCANOPSET",
        MethodName:"ifloc",
        Loc:logLocId
    },false);
    if(locFlag==1) logLocType="OP";
	if(locFlag==2) logLocType="AN";
    return logLocType;
}

function ConfirmOrdered()
{
	var selectRow=$("#OpPatientList").datagrid("getSelected");
	if(selectRow)
		{
			status=selectRow.opaStatus;					
		 }
	if((status=="����")||(status=='�ܾ�')||(status=='���ռ�'))
    {
        $.messager.alert("��ʾ","���Դ�״̬����������!","error");
        return false;
    }
	var ret=$.m({
        ClassName:"web.DHCANOPArrangeHISUI",
        MethodName:"UpdateOPOrdered",
        opaId:opaId,
        isOrdered:'Y',
        userId:session['LOGON.USERID']
    },false)
    if((ret!="Y")&&(ret!="N"))
    {
        $.messager.alert("����",result,"error");
        return;
    }else{
        $.messager.alert("��ʾ","�����ɹ���","info");
       	//$("#OperListBox").datagrid("reload");
        //selectRows[0].opNurseOrd=result;
    }
}
var operSubIndex=0,lastoperSubIndex=0;
function InitPatOper()
{
	    var operationBox=$HUI.datagrid("#operationBox",{
        fit:true,
        fitColumns:true,
        singleSelect: true,
        rownumbers: true,
        headerCls:'panel-header-gray',
        showHeader:false,
        url:$URL,
        queryParams:{
            ClassName:"web.DHCANOPArrangeHISUI",
            QueryName:"GetOpList"
        },
        onBeforeLoad:function(param)
        {
            param.opaId=opaId;
        },
        onClickRow: function(rowIndex, rowData) {
	        
	        $('#OperListBox').datagrid('clearSelections');
	        lastoperSubIndex=rowData["opSub"];
	        if((operSubIndex!=lastoperSubIndex))
	        {
		        var frm =dhcsys_getmenuform();
				if (frm) { 				
				if (frm.AnaestOperationID)
						{frm.AnaestOperationID.value = rowData["opSub"];}
					}
					operSubIndex=lastoperSubIndex;
					$('#OperListBox').datagrid('selectRow',rowIndex);
	        }
	        else
	        {
		        $('#operationBox').datagrid({	
				queryParams:{
            	ClassName:"web.DHCANOPArrangeHISUI",
            	QueryName:"GetOpList"
        		},
        		onBeforeLoad:function(param)
        		{
            		param.opaId=opaId;
        		}})
		       var frm =dhcsys_getmenuform();
				if (frm) { 				
				if (frm.AnaestOperationID)
						{frm.AnaestOperationID.value = "";}
						
					} 
					operSubIndex=0;
					lastoperSubIndex=0;
	        }
        },
        columns: [
            [
                { field: "operDesc", title: "��������", width: 240 },
                { field: "surgeon", title: "����", width: 80 },
                { field: "operId", title: "��������Id", width: 1, hidden: true },
                { field: "surgeonId", title: "surgeonId", width: 1, hidden: true },
                { field: "opSub", title: "opSub", width: 1, hidden: true }
         ]
        ],
        onLoadSuccess:function(data){
	       	if(data.total>0)
			{
				$("#operationBox").datagrid('selectRow',0);
				var selectRow=$("#operationBox").datagrid("getSelected");
		    	if(selectRow)
		    	{
					$('#OperListBox').datagrid('clearSelections');
					lastoperSubIndex=selectRow.opSub;
					if((operSubIndex!=lastoperSubIndex))
					{
						var frm =dhcsys_getmenuform();
						if (frm) { 				
						if (frm.AnaestOperationID)
								{frm.AnaestOperationID.value = selectRow.opSub;}
							}
							operSubIndex=lastoperSubIndex;
							$('#OperListBox').datagrid('selectRow',0);
					}
					else
					{
						$('#operationBox').datagrid({	
						queryParams:{
						ClassName:"web.DHCANOPArrangeHISUI",
						QueryName:"GetOpList"
						},
						onBeforeLoad:function(param)
						{
							param.opaId=opaId;
						}})
					   var frm =dhcsys_getmenuform();
						if (frm) { 				
						if (frm.AnaestOperationID)
							{frm.AnaestOperationID.value = "";}
						} 
						operSubIndex=0;
						lastoperSubIndex=0;
					}
			
		    	}
			}
        }
    });

}
var newregno=""
function findPatientList(){
	AnaestId="";
	var patientNo = "";
	newregno=$("#patientNo").searchbox('getValue');
	if(newregno!="")
	{
		patientNo=$.m({
        ClassName:"web.DHCDTHealthCommon",
        MethodName:"FormatPatientNo",
        PatientNo:newregno
    	},false);
	}
	
	$('#OpPatientList').datagrid('clearSelections');
	$('#OpPatientList').datagrid({
					 queryParams:{
            ClassName:"web.DHCANOPArrangeHISUI",
            QueryName:"GetOpListForOeOrd"
        },
        onBeforeLoad:function(param)
        {
	        var paytype=$("#chkPaidOp").checkbox('getValue')?"Y":"N";
	        var medNo= $("#medcareNo").searchbox('getValue');
            param.stdate=$("#DateFrom").datebox('getValue');
            param.enddate=$("#DateTo").datebox('getValue');
            param.oproom=$("#OperRoom").combobox('getValue');
            param.AnaId=AnaestId;
            param.patRegNo=patientNo;
            param.patMedNo=medNo;
            param.orderStr=logLocType+"^"+paytype;
             param.OperLocId=logLocId;
        }
				})	
		$('#operationBox').datagrid('clearSelections');
			$('#operationBox').datagrid({	
				queryParams:{
            ClassName:"web.DHCANOPArrangeHISUI",
            QueryName:"GetOpList"
        },
        onBeforeLoad:function(param)
        {
            param.opaId="";
        }})
		$("#patientNo").searchbox('setValue',"");
		//$("#patientNo").searchbox("textbox").val("");
		$("#medcareNo").searchbox('setValue',"");
		//$("#medcareNo").searchbox("textbox").val("");
		var frm =dhcsys_getmenuform();
			if (frm) { 				
				frm.EpisodeID.value=""; 
				frm.PatientID.value=""; 
				frm.mradm.value=""; 
				if (frm.AnaesthesiaID)
						{frm.AnaesthesiaID.value = "";}
				if (frm.AnaestOperationID){
						frm.AnaestOperationID.value = "";}
					}
}
function RegSearch(value)
{
	if(window.event.keyCode==13)
	{
		newregno=$.m({
        ClassName:"web.DHCDTHealthCommon",
        MethodName:"FormatPatientNo",
        PatientNo:value
    	},false);
	findPatientList();
	}
	else
	{
		newregno=value;
		findPatientList();
	}
}

