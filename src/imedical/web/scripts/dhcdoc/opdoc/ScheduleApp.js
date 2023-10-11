$(function(){
    ShowSeqNoInfo();
    InitAppList();
    InitDefautPat();
    InitEvent();
});
function InitEvent(){
    $('#CardNo,#PatientNo').keyup(function(e){
		if(e.keyCode==13){
            var CardNo=$(this).val();
            if(CardNo.length==0){
                InitPatInfo();
                return;
            }
            if($(this).attr("id")=="CardNo"){
                InitPatInfo();
                DHCACC_GetAccInfo("",CardNo,"","",CardNoCallBack);
            }else{
                while(CardNo.length<10){CardNo='0'+CardNo;}
                InitPatInfo();
                $(this).val(CardNo);
                SetPatientInfo();
            }
        }
    });
    $('input').focus(function(){
        $(this).select();
    });
    $('#BReadCard').click(function(){
        DHCACC_GetAccInfo7(CardNoCallBack);
    });
    $('#BFindPatApp').click(function(){
        var PatientID=$('#PatientID').val();
        if(PatientID==''){
            $.messager.popover({msg: '请先通过卡号确定病人',type:'alert'});
            return;
        }
        $('#tabAppList').datagrid('load',{
            ClassName:'DHCDoc.OPAdm.Appoint',
            QueryName:'QueryAppInfo',
            ASRowid:'',PatientID:PatientID    
        });
    });
    $('.seqno-list').on('click','.seqno',function(){
        var SeqNo=$(this).text();
        if(isNaN(SeqNo)&&((SeqNo.charAt(0))!='+')) return;
        Appoint(SeqNo);
    });
    $('#BAppoint').click(function(){
        Appoint('');
	});
}
function InitDefautPat()
{
    //默认取头菜单病人
    var PatientID=ServerObj.PatientID;
    if(!PatientID){
        var frm = dhcsys_getmenuform();
        PatientID = frm.PatientID.value;
    }
    if(PatientID){
        $('#PatientID').val(PatientID);
        SetPatientInfo();
    }
}
function CardNoCallBack(myrtn,errMsg)
{
    var myary=myrtn.split("^");
    var rtn=myary[0];
    if((rtn=='0')||(rtn=='-201')){
        var PatientNo=myary[5];
        var CardNo=myary[1];
        $('#CardNo').val(CardNo);
        $("#CardTypeRowID").val(myary[8]);
        SetPatientInfo();
    }else{
        if (typeof errMsg == "undefined") errMsg="卡无效";
        $.messager.confirm("提示", errMsg);
    }
}
function SetPatientInfo()
{
    var PatientID=$('#PatientID').val();
    var PatientNo=$('#PatientNo').val();
    var CardTypeRowId=$('#CardTypeRowID').val();
    var CardNo=$('#CardNo').val();
    var retJson=$.cm({
        ClassName:'DHCDoc.OPAdm.Appoint',
        MethodName:'GetPatDetail',
        PatientID:PatientID,PatientNo:PatientNo, CardTypeRowid:CardTypeRowId, CardNo:CardNo
    },false);
    if(!retJson.PatientID){
        $.messager.popover({msg: '系统无该患者信息',type:'error'});
        $('#CardNo').focus();
        return;
    }
    $('#PatientID').val(retJson.PatientID);
    $('#Name').val(retJson.Name);
    if($('#CardNo').val()==""){
        $('#CardTypeRowID').val(retJson.DefCardTypeRowid);
        $('#CardTypeNew').val(retJson.DefCardType);
        $('#CardNo').val(retJson.DefCardNo);
    }
    $('#PatientNo').val(retJson.PatientNo);
    ServerObj.warning=retJson.warning;
    if(ServerObj.warning){
        $.messager.alert('提示',ServerObj.warning);
    }
}
function InitPatInfo()
{
    $('#Name,#Sex,#Age,#TelH,#PatientNo,#CardNo,#PatYBCode,#PatientID,#CardTypeRowID,#CardTypeNew').val('');
    $('#CardNo').focus();
}
function ShowSeqNoInfo(){
    $('.seqno-list').empty();
    $.cm({ 
		ClassName:"DHCDoc.OPAdm.Appoint",
        MethodName:"GetASTimeRangeJSON",
        ASRowid:ServerObj.ASRowid,MethodID:ServerObj.AppMethodID
	},function(Data){
        $.each(Data.TRInfos,function(index,TRInfo){
            var $tr=$('<tr></tr>');
            $tr.append("<td class='seqno-time'>"+TRInfo.SttTime+"-"+ TRInfo.EndTime+"</td>");
            var $td=$('<td></td>');
            var AvailAppSeqNoArr=TRInfo.AvailAppSeqNoStr.toString().split(",");
            $.each(AvailAppSeqNoArr,function(){
                if(this=='') return true;
                $td.append('<div class="seqno">'+this+'</div>');
            });
            $tr.append($td).appendTo('.seqno-list');
        });
    });
}
function Appoint(SeqNo)
{
    if(ServerObj.warning){
        $.messager.popover({msg: ServerObj.warning,type:'error'});
        return;
    }
    var ASStatusCode=ServerObj.ASStatusCode;
    if((ASStatusCode=='S')||(ASStatusCode=='TR')){
        $.messager.popover({msg: '停诊排班不能'+ServerObj.AppTypeName,type:'error'});
        return;
    }
    if(ServerObj.OverDateFlag){
        $.messager.popover({msg: '不能预约当前日期以前的排班',type:'error'});
        return;
    }
    if(!$('.seqno-list').find('.seqno').size()){
        $.messager.popover({msg: '没有可用号源',type:'error'});
        return;
    }
    var PatientID=$('#PatientID').val();
    if(PatientID==''){
        $.messager.popover({msg: '请先通过卡号确定病人或者其他界面选择病人',type:'info'});
        return false;
    }
    if(!SeqNo) SeqNo="";
    $.messager.confirm('提示','确定'+ServerObj.AppTypeName+'此排班吗?',function(r){
        if(r){
            var ret=$.cm({
                ClassName:'web.DHCOPAdmReg',
                MethodName:'OPAppDocBroker',
                PatientID:PatientID,
                ASRowId:ServerObj.ASRowid,
                QueueNo:SeqNo,
                UserRowId:session['LOGON.USERID'], 
                MethCode:ServerObj.AppMethodCode,
                RegType:"",
                AppPatInfo: "",
                ExpStr:"",
                dataType:'text'
            },false);
            var retArr=ret.split("^");
            if(retArr[0]=='0'){
                $.messager.popover({msg: ServerObj.AppTypeName+'成功!',type:'success'});
                var AppRowid=retArr[1];
                //AppPrintOut(AppRowid);
                ShowSeqNoInfo();
                $('#tabAppList').datagrid('reload');
            }else{
                var rettip=retArr[0];
                var code=Number(retArr[0]);
                switch(code){
                    case -201:rettip="没有预约资源。";break;
                    case -203:rettip="停诊或替诊的班次则不能预约。";break;
                    case -223:rettip="该预约患者已进黑名单,暂时无法预约！";break;
                    case -301:rettip="超过每天预约限额。";break;
                    case -302:rettip="超过每天预约相同医生号限额。";break;
                    case -303:rettip="此病人超过每人每天挂相同科室限额！";break;
                    case -304:rettip="超过每人每天同时段同科室同医生限额！";break;
                    case -402:rettip="还未到预约时间!";break;
                    default:rettip=retArr[1]?retArr[1]:ret;break;
                }
                $.messager.alert("预约失败",rettip);
            }
        }
    });
}
function InitAppList()
{
    var ListColumns=[[
        {field:'AppRowid',hidden:true},
        {field:'AppUserID',hidden:true},
        {field:'CancelApp',title:'取消预约',align:'center',
            formatter: function(value,row,index){
                if((row.AppUserID==session['LOGON.USERID'])&&(row.AppStatus=="未取号")){
                    return "<a href='#' onclick=\"CancelAppHandle('"+row.AppRowid+"','"+row.PatName+"')\" >取消预约</a>";
                }
            }
        },
        {field:'PrintAppData',title:'打印凭条',align:'center',
            formatter: function(value,row,index){
                if(row.AppStatus=="未取号"){
                    return "<a href='#' onclick=\"AppPrintOut('"+row.AppRowid+"')\" >打印凭条</a>";
                }
            }
        },
        {field:'PatNo',title:'登记号',align:'center',width:110,resizable:true},
        {field:'PatName',title:'姓名',align:'center',width:100,resizable:true},
        {field:'PatAge',title:'年龄',align:'center',width:60,resizable:true},
        {field:'Phone',title:'联系电话',align:'center',width:120,resizable:true},
        {field:'ASDate',title:'就诊日期',align:'center',width:100,resizable:true},
        {field:'AdmTimeRange',title:'就诊时间段',align:'center',width:100,resizable:true},
        {field:'AppStatus',title:'取号状态',align:'center',width:80,resizable:true},
        {field:'QueueNo',title:'诊号',align:'center',width:50,resizable:true},
        {field:'AppMethod',title:'预约方式',align:'center',width:90,resizable:true},
        {field:'AppUser',title:'预约人',align:'center',width:70,resizable:true},
        {field:'AppDate',title:'预约日期',align:'center',width:110,resizable:true},
        {field:'AppTime',title:'预约时间',align:'center',width:80,resizable:true}
    ]];
    $('#tabAppList').datagrid({
		idField:"AppRowid",
        border:false,
        columns :ListColumns,
        fitColumns:false,
        onBeforeLoad:function(param){
	        param.ClassName='DHCDoc.OPAdm.Appoint';
	        param.QueryName='QueryAppInfo';
            if(param.PatientID) return true;
	        param.ASRowid=ServerObj.ASRowid;
	        param.PatientID="";
	    }
    });
}
function CancelAppHandle(AppRowid,Name)
{
    $.messager.confirm("提示", "确定要取消 "+Name+" 的预约吗?", 
        function (data) {
            if(data){
                var ret=tkMakeServerCall("web.DHCRBAppointment","CancelAppointment",AppRowid,session['LOGON.USERID']);
                if(ret=='0'){
                    $.messager.show({
                        title:'提示',
                        msg:'取消预约成功!'
                    });
                    var AppArr=AppRowid.split("||");
                    var ASRowid=AppArr[0]+"||"+AppArr[1];
                    ShowSeqNoInfo(ASRowid);
                    $('#tabAppList').datagrid('reload');
                }else{
                    $.messager.alert("提示","取消预约失败:"+ret);
                }
            }
        });
}
function AppPrintOut(AppRowid)
{
    try{
		var AppPrintData=tkMakeServerCall('DHCDoc.Common.pa','GetAppPrintData',AppRowid)
		DHCP_GetXMLConfig("InvPrintEncrypt","DHCOPAppointPrint");
		var PrintDataArySum=eval(AppPrintData)
		var PrintDataAry=PrintDataArySum[0]
		var MyPara = "" + String.fromCharCode(2);
		for (Element in PrintDataAry){
			MyPara=MyPara +"^"+ Element + String.fromCharCode(2) + PrintDataAry[Element];
		}
		DHC_PrintByLodop(getLodop(),MyPara,"","","");	
	}catch(e){alert(e.message);}
}