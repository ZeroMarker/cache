/// creator:dws
/// 2017-02-12
/// Descript:评价相关

var praiseNum="";
//var repType=""; //陪送&配送
$(function(){
	//getNowDateTime(); //获取评价当前日期时间
	btnFun(); //评价保存与取消
	//getAllSignPraise(); //获取所有评价模块描述名称
	orNotAppraise();
});

///获取当前日期时间
function getNowDateTime(){
	//获取当前日期时间
	function p(s) {
    	return s < 10 ? '0' + s: s;
	}
	var nowDate = new Date();
	//获取当前年
	var year=nowDate.getFullYear();
	//获取当前月
	var month=nowDate.getMonth()+1;
	//获取当前日
	var date=nowDate.getDate(); 
	var h=nowDate.getHours();       //获取当前小时数(0-23)
	var m=nowDate.getMinutes();     //获取当前分钟数(0-59)
	var s=nowDate.getSeconds();     //获取当前秒数(0-59)

	var nowDateTime=year+'-'+p(month)+"-"+p(date)+" "+p(h)+':'+p(m)+":"+p(s);
	return nowDateTime;
}

///获取陪送或配送编号
/*
function getRepType(){
	if(parent.ReqType=="affirmstatus"){
		repType="0"; //陪送
	}
	else if(parent.ReqType=="accompstatus"){
		repType="1"; //配送
	}
}
*/
//评价保存与取消,查看
function btnFun(){
	//保存评价时存储所选的评价模块id、评价内容
	$("#btnCommit").on('click',function(){
		if ($.trim($("#signremark").text())!= "我想说:")
		{
		   var dataNum="";
		   for(var j=0;j<praiseNum;j++){
			   var haveSelectColor=$("#tag").children().eq(j).css('background-color'); //被选中的评价模块
			   
			   if((haveSelectColor=="rgb(173, 216, 230)")||(haveSelectColor=="lightblue")){
				   dataNum=dataNum+($("#tag").children().eq(j).attr("tempVal"))+"-";
			   }
		   }
		   //getRepType(); //获取陪送或配送编号
		   var RaItemDr=dataNum.substring(0,dataNum.length-1); //评价项目模块id
		   var RaRemarks=$("#signremark").text(); //评价内容
		   //var RaReqType=type; //pei送类型
		   var RaNubmer=$("#lb_Num").text(); //评价得分
		   var appDateTime=getNowDateTime(); 
		   var appDate=(appDateTime.split(" "))[0]; //评价日期
		   var appTime=(appDateTime.split(" "))[1]; //评价时间
		   //alert(appDateTime)
		   if(RaNubmer==""){$.messager.alert("提示","评价得分不能为空!");return;}
		   a
		   var dataNum=mainRowID+"&"+RaItemDr+"||"+RaRemarks+"||"+type+"||"+RaNubmer+"&"+appDate+"-"+appTime+"&"+createUser;
		   //保存评价
		   runClassMethod("web.DHCDISAppraise","saveDisappraise",{RaReqType:type,mainRowID:mainRowID,RaNubmer:RaNubmer,RaRemarks:RaRemarks,appDate:appDate,appTime:appTime,createUser:createUser,RaItemDr:RaItemDr},function(jsonObj){
				if(jsonObj==0){
					$.messager.alert("提示","评价保存失败!");
				}
				else{
							runClassMethod("web.DHCDISRequestCom","updateStatus",{"pointer":mainRowID,"type":type,"statuscode":17,"lgUser":createUser,"EmFlag":"Y","reason":""},
									function(data){
										if(data!=0){
											$.messager.alert("提示",data);	
										}
										else{
											
											$.messager.alert("提示","操作成功！");
										}
										
									},'text',false)
					$.messager.alert("提示","评价成功!");
					$('#cspAffirmStatusTb').datagrid('reload');
					window.location.reload();
				}
		   });
		}
		else{
			$.messager.alert("提示","评价内容不能为空!");
		}
	});	
	
	//取消评价
	$("#btnCancel").on('click',function(){
		window.location.reload();
	});	
	
}


//获取所有评价模块描述名称
function getAllSignPraise(){
	runClassMethod("web.DHCDISAppraise","getSignModuleDesc",{},function(jsonObj){
		praiseNum=jsonObj.total;
		for(var i=0;i<praiseNum;i++){
			$("#tag").append('<span class="tag" tempVal='+jsonObj.rows[i].AIRowId+' onclick="changePraiseStatus(this);">'+jsonObj.rows[i].AIDesc+'</span>');
		}
	});
}

//选中评价模块样式发生变化
function changePraiseStatus(obj){   //rgb(173, 216, 230)
	var backGround=$(obj).css('background-color'); //点击的模块背景色
	var noStatusColor1="rgb(205, 230, 156)"; //未选中的颜色(IE11)
	var noStatusColor2="#cde69c"  ////未选中的颜色(IE8)
	var haveStatusColor1="rgb(173, 216, 230)";  //选中的颜色(IE11)
	var haveStatusColor2="lightblue";  //选中的颜色(IE8)
	
	if((backGround==haveStatusColor1)||(backGround==haveStatusColor2)){
		$(obj).css('background-color','#cde69c')
	}
	if((backGround==noStatusColor1)||(backGround==noStatusColor2)){
		$(obj).css('background-color','lightblue')
	}
}

//判断该用户是否已经评价过该申请单
function orNotAppraise(){
	//getRepType(); //获取陪送或配送编号
	//alert(mainRowID+","+createUser+","+type)
	runClassMethod("web.DHCDISAppraise","orNotAppraise",{mainRowID:mainRowID,LgUserID:createUser,repType:type},function(data){
		//已经评价过该申请单，直接点开就可以查看评价详情
		//alert(data)
		if(data>0){
			getPraiseInfo();
			$("#btnCommit").linkbutton("disable");
			$("#btnCommit").unbind();
			$("#btnCancel").linkbutton("disable");
			$("#btnCancel").unbind();
		}	
		//申请单未评价过，可以评价
		else{
			getAllSignPraise();
		}		
	});
}

//获取已经评价过的申请单相关信息
function getPraiseInfo(){
	//getRepType(); //获取陪送或配送编号
	runClassMethod("web.DHCDISAppraise","getPraiseInfo",{mainRowID:mainRowID,repType:type},function(data){
		$("#rate-comm-1").html("");
		//alert(data.rows[0].RaNubmer);
		if(data.rows[0].RaNubmer==1){
			$("#rate-comm-1").append('<span><img src="../images/1.png"></span>');
			$("#signpraise").text("非常差,有待提高！");
		}else if(data.rows[0].RaNubmer==2){
			$("#rate-comm-1").append('<span><img src="../images/2.png"></span>');
			$("#signpraise").text("很差,还需改进！");
		}else if(data.rows[0].RaNubmer==3){
			$("#rate-comm-1").append('<span><img src="../images/3.png"></span>');
			$("#signpraise").text("一般,希望服务完善！");
		}else if(data.rows[0].RaNubmer==4){
			$("#rate-comm-1").append('<span><img src="../images/4.png"></span>');
			$("#signpraise").text("很好,继续努力！");
		}else if(data.rows[0].RaNubmer==5){
			$("#rate-comm-1").append('<span><img src="../images/5.png"></span>');
			$("#signpraise").text("非常好,无可挑剔！");
		}
			
		$("#tag").html("");
		//加载评价标签
		for(var j=0;j<data.rows[0].RaItemDr.length;j++){
			$("#tag").append('<span class="tagApp">'+data.rows[0].RaItemDr[j].signName+'</span>');
		}
			
		$("#signremark").val(data.rows[0].RaRemarks); //加载备注
		$("#signremark").attr("disabled",true);
	});
}