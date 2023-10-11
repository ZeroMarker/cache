$(function () {
    addQuest();
    QuestMsg();
});

function addQuest(){
    if ((EpisodeID=="")||(TypeCode=="")) return;
    var PatInfo ="";
    var FeedStr = "";
    $("#divNorth").empty();
    $("#divCenter").empty();    
    
    var FeedInfo = $cm({
        ClassName:"DHCHAI.IRS.CCFeedbackSrv",
        QueryName:"QryFeedbackSrv",     
        aEpisodeID: EpisodeID,
        aTypeCode:TypeCode,
        aDateFrom:Common_GetDate(new Date()), 
        aDateTo:Common_GetDate(new Date())
    },false);
    
    if (FeedInfo.total>0) {     
        for(var indFeed = 0; indFeed < FeedInfo.total; indFeed++){
            var objFeedback = FeedInfo.rows[indFeed];
            if (!objFeedback) continue;
            
            var IsOpinion = (objFeedback["IsOpinion"] == 1) ? $g("已处置") : $g("未处置");
            var QuestClass = (objFeedback["IsOpinion"] == 0) ? "red" : "";
            FeedStr += '<div style="background-color:#F2F2F2; padding:10px;margin-bottom:5px;">'
                    +   '<div style="color:#808080;">'
                    //+     '<span style="margin-right:10px;">'+objFeedback.RegUserLoc+'</span>'+   
                    + ' <span style="margin-right:10px;">'+objFeedback.RegUser+'</span><span style="margin-right:10px;">'+objFeedback.RegDate+'&nbsp'+objFeedback.RegTime+'</span>'

                    +   '</div>'
                    +   '<div style="line-height:35px;color:'+QuestClass+'">'+objFeedback.QuestNote+'</div>'
                    +   '<div><span style="color:#808080;margin-right:15px;" >'+IsOpinion+'</span><span style="color:#808080;">'+objFeedback.TypeCode+'</span></div>'
                    +   '<div style="height:35px"><div id="Opinion'+objFeedback.ID+'" data-id="'+objFeedback.ID+'" >';
              if (objFeedback["IsOpinion"] == 1) { //已处置
                    FeedStr += '<div style="overflow: hidden;float: left;color: green;">---'+objFeedback.Opinion+'</div>'+'<div style="float:right;">'+objFeedback.ActUser+'('+objFeedback.ActUserLoc+')&nbsp;&nbsp;&nbsp;'+objFeedback.ActDate+'&nbsp'+objFeedback.ActTime+'</div>';
                } else {
                    FeedStr += '<button id="OpinionBtn'+objFeedback.ID+'"  class="hisui-linkbutton"  style="float: right;width:80px;height:30px;background-color:#339EFF;color:#FFFFFF;border:none;cursor:pointer;">'+$g("处置")+'</button>';
                }
                FeedStr    += '</div>'  + '</div>' +'</div>';
        }
        PatInfo = '<ul class="list-inline"><li>'+FeedInfo.rows[0].PatName+'</li><li class="middle-line">|</li><li>'+FeedInfo.rows[0].Sex+'</li><li class="middle-line">|</li><li>'+FeedInfo.rows[0].Age+'</li><li class="middle-line">|</li><li>'+$g(FeedInfo.rows[0].VisitStatus)+'</li><li class="middle-line">|</li><li>'+FeedInfo.rows[0].AdmDate+$g("入院")+'('+FeedInfo.rows[0].AdmWard+')</li></ul>';
    }else {
        FeedStr = '<div style="background-color:#F2F2F2;color:#808080;padding:10px;">'+$g("该病人今日无反馈问题")+'</div>';
        var AdmInfo = $cm({
            ClassName:"DHCHAI.DPS.PAAdmSrv",
            QueryName:"QryAdmInfo",     
            aEpisodeID: EpisodeID
        },false);
        if (AdmInfo.total>0) {
            var admInfo = AdmInfo.rows[0];
            switch(admInfo.VisitStatus){
                case "P":
                    admInfo.VisitStatus = $g("预住院");break;
                case "A":
                    admInfo.VisitStatus = $g("在院");break;
                case "D":
                    admInfo.VisitStatus = $g("出院");break;
                case "C":
                    admInfo.VisitStatus = $g("退院");break;
                default:
                    admInfo.VisitStatus = $g("作废");break;
            }
            PatInfo = '<ul class="list-inline"><li>'+admInfo.PatName+'</li><li class="middle-line">|</li><li>'+admInfo.Sex+'</li><li class="middle-line">|</li><li>'+admInfo.Age+'</li><li class="middle-line">|</li><li>'+admInfo.VisitStatus+'</li><li class="middle-line">|</li><li>'+admInfo.AdmDate+$g("入院")+'('+admInfo.AdmWardDesc+')</li></ul>';
        }
    }
    $("#divNorth").append(PatInfo);
    $("#divCenter").append(FeedStr);
      for(var indFeed = 0; indFeed < FeedInfo.total; indFeed++){
            var objFeedback = FeedInfo.rows[indFeed];
            if (!objFeedback) continue;
            (function(indFeed){
                var objFbk = FeedInfo.rows[indFeed];
                $("#OpinionBtn"+objFbk.ID).on('click',function(){
                    console.log("123")
                    btn(objFbk);
                });
            })(indFeed)
      }

}

function QuestMsg(){
    
    var TypeDesc = $m({
        ClassName:"DHCHAI.IRS.CCFeedbackSrv",
        MethodName:"GetDescByCode",     
        aCode: TypeCode
    },false);
    if (TypeDesc == "0") {
        $.messager.alert("提示","请先维护问题类型下代码为'+TypeCode+'的字典！'", "info"); 
        return;
    }
    
    var htmlStr = '<div id="divSendMess" style="display: block; border-top: 1px solid #ccc;padding:10px;">'     
                + '     <textarea class="textbox"  id="txtQuestion" style="width:99%;height:80px;outline:none;background-color:#fff;" placeholder="'+$g("新增问题...")+'"></textarea> '         
                + '     <div style="padding-top:5px;">'
                + '         <span style="color:#808080;">'+$g("问题类型")+'：'+TypeDesc+'</span>'
                + '         <div style="padding-top:5px;text-align:center">'




                + '             <a id="btnSave">保存</a>'
                + '             <a id="btnClose">关闭</a>'    
                + '         </div>'             
                + '     </div>'
                + '</div>'
    $("#divSouth").append(htmlStr);
    $('#btnSave').linkbutton();
    $('#btnClose').linkbutton();
    //保存按钮
    $('#btnSave').on('click', function(){
        btnSave_click();
    });
    //关闭按钮
    $('#btnClose').on('click', function(){
        websys_showModal('close');
    });
}
btnSave_click =function(){  
    var txtQuestion = $.trim($("#txtQuestion").val());
    if (txtQuestion == ""){
        $.messager.alert("提示","问题内容不允许为空！", "info");
        return;
    }
    var InputStr = "^"+EpisodeID+"^"+TypeCode+"^"+txtQuestion+"^^^"+$.LOGON.USERID+"^^^^^"+$.LOGON.LOCID;
    var retval = $m({
        ClassName:"DHCHAI.IR.CCFeedback",
        MethodName:"Update",
        aInputStr:InputStr,
        aSeparete:'^'
    },false);

    if (parseInt(retval)>0){
        addQuest(); //刷新
        $('#txtQuestion').val('');
        $.messager.popover({msg: '保存成功！',type:'success',timeout: 2000});
    } else {
        $.messager.alert("提示", "保存失败！", "info");
    }
}

function btn(objFeedback){
    $('#txtCode').text(objFeedback.QuestNote);
    $('#txtTypeDesc').text(objFeedback.TypeCode);
    $('#txtRegTime').text(objFeedback.RegUser+'('+objFeedback.RegUserLoc+')'+' '+' '+objFeedback.RegDate+' '+' '+objFeedback.RegTime);
    $('#Edit').show();
    $('#txtOpinion').val("");
    $('#Edit').dialog({
        iconCls:'icon-w-paper',
        title:objFeedback.PatName+' | '+objFeedback.Sex+' | '+objFeedback.Age+' | '+$g(objFeedback.VisitStatus)+' | '+objFeedback.AdmDate+$g("入院")+'('+objFeedback.AdmWard+')' ,
        modal: true,
        isTopZindex:false,//true,
        buttons:[{
            text:'保存',
            handler:function(){
               var errinfo = "";
                var Opinion = $('#txtOpinion').val();
                if (!Opinion) {
                    errinfo = errinfo + $g("处置意见不能为空!")+"<br>";
                }

                if (errinfo) {
                    $.messager.alert("错误提示", errinfo, 'info');
                    return "-100";
                }
                var flg = $m({
                    ClassName:"DHCHAI.IRS.CCFeedbackSrv",
                    MethodName:"UpdateOpinion",
                    aFeedbackID:objFeedback.ID,
                    aOpinion:Opinion,
                    aUserDr:$.LOGON.USERID,
                    aLocDr:$.LOGON.LOCID
                },false);

                if (parseInt(flg)> 0) {
                   
                    $HUI.dialog('#Edit').close();
                    addQuest();

                    $.messager.popover({msg: '保存成功！',type:'success',timeout: 1000});
                }else if(flg == '-100'){
                    $.messager.alert("错误提示", "保存失败!", 'info');
                }else{
                    $.messager.alert("错误提示", "保存失败!", 'info');
                }
            }
        },{
            text:'关闭',
            handler:function(){
                $HUI.dialog('#Edit').close();
            }
        }]
    });
}   
 
