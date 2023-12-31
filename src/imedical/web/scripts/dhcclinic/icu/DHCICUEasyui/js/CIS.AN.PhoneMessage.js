function initPage(){
      var operList=getOperList();
      generateMessageForm(operList);
    }

    function generateMessageForm(operList){
      if(operList && operList.length>0){
        var htmlArr=[];
        for(var i=0;i<operList.length;i++){
          var operSchedule=operList[i];
          
          htmlArr.push("<div class='form-row-group'>");
		  htmlArr.push("<form class='message-form'>");
          htmlArr.push("<input type='hidden' name='OPSID' value='"+operSchedule.OPSID+"'>");
          htmlArr.push("<input type='hidden' name='PhoneNumber' value='"+operSchedule.PatPhoneNumber+"'>");
          
          htmlArr.push("<div><div class='form-row'><div class='form-title-right4 item-title'>患者姓名</div><div class='form-item-normal'>"+operSchedule.PatName+"</div>");
          htmlArr.push("<div class='form-title-right2 item-title'>性别</div><div class='form-item-normal'>"+operSchedule.PatGender+"</div>");
          htmlArr.push("<div class='form-title-right3 item-title'>登记号</div><div class='form-item-normal'>"+operSchedule.RegNo+"</div>");
          htmlArr.push("<div class='form-title-right3 item-title'>手机号</div><div class='form-item-normal'>"+operSchedule.PatPhoneNumber+"</div>");
          htmlArr.push("<div class='form-title-right4 item-title'>手术日期</div><div class='form-item-normal'>"+operSchedule.OperDate+"</div>");
          htmlArr.push("</div></div>");
          
          htmlArr.push("<div><div class='form-row'><div class='form-title-right4 item-title'>手术名称</div><div class='form-item-normal'>"+operSchedule.OperDesc+"</div>");
          htmlArr.push("</div></div>");

          htmlArr.push("<div><div class='form-row'><div class='form-title-right4 item-title'>短信内容</div><div class='form-item-normal'><textarea name='Content' class='message-text'>"+operSchedule.MessageText+"</textarea></div>");
          htmlArr.push("</div></div>");
		  htmlArr.push("</form>");
          htmlArr.push("</div>");
          
        }
        
        htmlArr.push("<div class='form-row-group'>");
        htmlArr.push("<div style='text-align:center;padding:10px;'><span class='form-btn'><a href='#' id='btnSend'>发送</a></span><span class='form-btn'><a href='#' id='btnCancel'>取消</a></span></div>")
        htmlArr.push("</div>");
        

        $(htmlArr.join("")).appendTo(".message-container");

        $("#message-text").validatebox({
          validType:"length[0,200]",
          required:true
        });

        $("#btnSend").linkbutton({
          onClick:function(){
            var messageList=[];
            $(".message-form").each(function(index,element){
              var jsonData=$(this).serializeJson();
              jsonData.BusinessCode="PatPhoneMessage";
              jsonData.CreateUser=session.UserID;
              jsonData.MessageId="";
              jsonData.OPSID=opsIdStr;
              messageList.push(jsonData);
            });

            var messageStr=JSON.stringify(messageList);
           // alert(messageStr)
            //var ret=dhccl.runServerMethod(ANCLS.BLL.PhoneMessage,"SendMessageList",messageStr);
            var ret = AIS.Action({action:"AN/SendMessageList",messageList:messageStr});
            if(ret.indexOf("S^")===0){
             $.messager.popover({
               msg:"发送短信成功",
               type:"success",
               timeout:2000
             }); 
            }else{
              $.messager.alert("提示","发送短信失败，原因："+ret,"error");
            }
          }
        });

        $("#btnCancel").linkbutton({
          onClick:function(){
            websys_showModal("close");
          }
        });
      }
    }
var opsIdStr=""
    function getOperList(){
      opsIdStr=dhccl.getQueryString("opsIdStr");
      var operList=dhccl.getDatas(ANCSP.MethodService,{
        ClassName:ANCLS.BLL.PhoneMessage,
        MethodName:"GetPatMessageList",
        Arg1:opsIdStr,
        ArgCnt:1
      },"json");
      return operList;
    }

    $(document).ready(initPage);