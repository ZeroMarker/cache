//20180918 YuanLin
$(function(){
	var SelectedRowID = 0;
	var preRowID=0; //����ȫ�ֱ���,�жϸ����Ƿ�ѡ��
	var myDate = new Date();
    var defaultDate = myDate.format("dd/MM/yyyy");
    $("#StartDateTime").datebox("setValue",defaultDate);
    $("#EndDateTime").datebox("setValue",defaultDate);
    var groupId=session['LOGON.GROUPID']
    var ifAllLoc="N"
    //�������֢���Ҳ鿴��֢�б�(סԺ��ʿ סԺ��ʿ�� סԺҽʦ סԺҽʦ����) YuanLin 20191107
    if((groupId==23)||(groupId==25)||(groupId==29)||(groupId==30)) ifAllLoc="Y"
	var ICUArrangeConfigObj=$HUI.datagrid("#ICUArrangeConfig",{
		singleSelect: true,
        fitColumns:true,
        fit:true,
        rownumbers: true,
        headerCls:'panel-header-gray',
        pagination: true,
        pageSize: 20,
        pageList: [20, 50, 100],
        url:$URL,
		queryParams:{
			ClassName:"web.DHCICUArrange",
			QueryName:"FindICUArrangeNew",
            ArgCnt: 8
		},
		onBeforeLoad:function(param){
			param.fromDate=$("#StartDateTime").datebox("getValue"),
			param.toDate=$("#EndDateTime").datebox("getValue"),
			param.regNo=$("#RegNo").val(),
			param.ctlocId=session['LOGON.CTLOCID'],
			param.icuaStatusCode=$("#Status").combobox("getValue"),
			param.papmiMedicare=$("#MedicalNo").val(),
			param.papmiName=$("#PatName").val(),
			param.WardType=$("input[name='WardType']:checked").val(),
			param.ifAllLoc=ifAllLoc
		},
        columns:[[
			{ field: "tStartDateTime", title: "��ʼ����", width: 120, sortable: true},
            { field: "leaveDateTime", title: "ת������", width: 120, sortable: true },
            { field: "statusDesc", title: "����״̬", width: 120, 
				styler: function(value,row,index){
				if (value=="����"){
		        return 'background-color:palegreen;';}
		        if (value=="�໤"){
			    return 'background-color:magenta;';}
			    if (value=="ֹͣ"){
				return 'background-color:lightblue;';}
				}
			},
            { field: "tRegNo", title: "�ǼǺ�", width: 100, sortable: true },
			{ field: "tPatName", title: "��������", width: 120, sortable: true },
			{ field: "tBedCode", title: "���˴�λ", width: 120, sortable: true },
            { field: "tWardDesc", title: "����", width: 200, sortable: true },
			{ field: "icuaId", title: "��֢��¼ID", width: 120, sortable: true },
            { field: "tEpisodeID", title: "�����", width: 100, sortable: true },
            { field: "tPatHeight", title: "���", width: 80, sortable: true },
			{ field: "tPatWeight", title: "����", width: 80, sortable: true },
            { field: "tMedCareNo", title: "������", width: 100, sortable: true },
			{ field: "tBodySquare", title: "��������", width: 120, sortable: true },
            { field: "tICUAAttendingCtcpDesc", title: "����ҽʦ", width: 120, sortable: true },
            { field: "tICUAResidentCtcpDesc", title: "סԺҽʦ", width: 120, sortable: true },
			{ field: "mainNurse", title: "���ܻ�ʿ", width: 120, sortable: true },
            { field: "mainNurseTwo", title: "���ܻ�ʿ2", width: 120, sortable: true },
            { field: "patLeaveCon", title: "ת��ȥ��", width: 120, sortable: true},
			{ field: "limitedTreatment", title: "��������", width: 120, sortable: true },
            { field: "apacheQty", title: "Apache����", width: 100, sortable: true },
			{ field: "icuBedId", title: "��λID", width: 100, sortable: true },
            { field: "curWardId", title: "����ID", width: 100, sortable: true }
        ]],
		onClickRow:function(){
            var row=ICUArrangeConfigObj.getSelected();
            if(row)
            {  var frm = window.top.document.forms['fEPRMENU'];
        if (frm) {
	            frm.EpisodeID.value=row.tEpisodeID;
        }
		        SelectedRowID=row.Id;
		        if(preRowID!=SelectedRowID)
		        {
			        preRowID=SelectedRowID;
			        $("#PatName").val(row.tPatName);
			        $("#RegNo").val(row.tRegNo);
			        $("#Status").combobox("setText",row.statusDesc);
			        $("#MedicalNo").val(row.tMedCareNo);
			    }
		        else
		        {
			        SelectedRowID = 0;
			        preRowID=0;
			        ICUArrangeConfigObj.clearSelections();
			        $("#PatName").val("");
			        $("#RegNo").val("");
			        $("#Status").combobox("setText","");
			        $("#MedicalNo").val("");
		        }
	        }
        }
	})
    var Status = $HUI.combobox("#Status",{
		valueField:'id',
		textField:'text',
        panelHeight:'auto',
		data:[
		     {id:'R',text:'����'}
			,{id:'M',text:'�໤'}
			,{id:'T',text:'ֹͣ'}
			,{id:'F',text:'���'}	
		]
	})
	var btnSchObj=$HUI.linkbutton("#btnSearch",{
		onClick: function(){
			var param = {
			    ClassName:"web.DHCICUArrange",
			    QueryName:"FindICUArrangeNew",
		        fromDate:$("#StartDateTime").datebox("getValue"),
		        toDate:$("#EndDateTime").datebox("getValue"),
		        regNo:$("#RegNo").val(),
		        ctlocId:session['LOGON.CTLOCID'],
		        icuaStatusCode:$("#Status").combobox("getValue"),
		        papmiMedicare:$("#MedicalNo").val(),
		        papmiName:$("#PatName").val(),
		        WardType:$("input[name='WardType']:checked").val(),
			    ifAllLoc:ifAllLoc
			};
			ICUArrangeConfigObj.load(param);
			//$("#PatName").val("");
			//$("#Status").combobox("setValue","");
			//$("#RegNo").val("");
			//$("#MedicalNo").val("");
        }
	})
	var btnMonitorObj=$HUI.linkbutton("#btnMonitor",{
		onClick: function(){
			var row=ICUArrangeConfigObj.getSelected();
            if(row)
            {
	            var status=row.tStatus;
	            if ((status!="R")&&(status!="M")&&(status!="T")&&(status!="F"))
	            {
		            alert("Setlect record please!");
		            return;
		        }
		        var icuaId=row.icuaId;
		        var EpisodeID=row.tEpisodeID;
		        if ((icuaId=="")&&(EpisodeID=="")) return;
		        var frm = document.forms["fEPRMENU"];
		        var userCtlocId=session['LOGON.CTLOCID']
		        if ((icuaId=="")&&(EpisodeID=="")) return;
		        var curLocation=unescape(window.location);
		        curLocation=curLocation.toLowerCase();
		        var locationId=GetWardCtlocId(icuaId);
		        //�м������
				//var ServerNameSpace="cn_iptcp:114.242.246.243[1972]:DHC-APP" //��ʱ������
			    var filePath = window.location.href.split("csp")[0] + "/service/dhcclinic/";
				var args = [icuaId, EpisodeID, session["LOGON.USERID"], session["LOGON.GROUPID"], locationId,ServerNameSpace,filePath,""]
			    //IntensiveCare.Show(icuaId,EpisodeID,session["LOGON.USERID"],session["LOGON.GROUPID"],userCtlocId,ServerNameSpace,filePath,"");
			    IntensiveCare.clear();
			    IntensiveCare.cmd('Main.exe'+' '+args)
		        //var curLocation=unescape(window.location);
		        //curLocation=curLocation.toLowerCase();
		        //var filePath=curLocation.substr(0,curLocation.indexOf('/csp/'))+"/service/DHCClinic/";
		        //var locationId=GetWardCtlocId(icuaId);
		        //var lnk="../service/dhcclinic/app/icu/Main.application?icuaId="+icuaId+"&userId="+session["LOGON.USERID"]+"&groupId="+session["LOGON.GROUPID"]+"&locId="+locationId+"&connString="+connString+"&filePath="+filePath+"&total=";
		        //window.open(lnk);
            }
            else
            {
	            alert("��ѡ��һ���໤��¼!")
            }
        }
	})
	function GetWardCtlocId(icuaId) {
		var result = null;
		$.ajax({
			url:$URL,
			async: false,
			data: {
				ClassName: "web.DHCICUCom",
				MethodName: "GetWardCtlocId",
				wardId:"",
				icuaId:icuaId,
				ArgCnt:2
			},
			type: "post",
			success: function(data) {
				result = data;
			}
		});
		return result;
    }
    $("input[name='WardType'][value='Into']").checkbox({
	    onCheckChange: function(e, value) {
		    if (value === false) return;
            $("input[name='WardType'][value='In']").checkbox("setValue", false);
            $("input[name='WardType'][value='Out']").checkbox("setValue", false);
		}
	});
	$("input[name='WardType'][value='In']").checkbox({
	    onCheckChange: function(e, value) {
		    if (value === false) return;
            $("input[name='WardType'][value='Into']").checkbox("setValue", false);
            $("input[name='WardType'][value='Out']").checkbox("setValue", false);
		}
	});
	$("input[name='WardType'][value='Out']").checkbox({
	    onCheckChange: function(e, value) {
		    if (value === false) return;
            $("input[name='WardType'][value='Into']").checkbox("setValue", false);
            $("input[name='WardType'][value='In']").checkbox("setValue", false);
		}
	});
});
function RegSearch()
{
	if(window.event.keyCode==13)
	{
		var newregno=$.m({
			ClassName:"web.DHCDTHealthCommon",
			MethodName:"FormatPatientNo",
			PatientNo:$("#RegNo").val()
		},false);
		$("#RegNo").val(newregno);
		$HUI.datagrid("#ICUArrangeConfig").load();
	}
}