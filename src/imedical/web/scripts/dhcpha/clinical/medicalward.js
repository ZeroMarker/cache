var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;font-size:10pt;font-family:华文楷体;color:red;">[单击]</span>'
var EpisodeID=episodeID;
$(function(){
	LoadPerPharSerDetail(EpisodeID); //加载日期
	///引用
	$("#btnUser").on("click",function(){
		recommend(); //引用查房信息
	});
	
	selectall();		  // 选中页面上的所有checkbox
	
	///查询
	$("#searchInfo").keyup(function(){
		var searchInfo=$("#searchInfo").val().trim(); //搜索内容
		FindInfo(EpisodeID,searchInfo); //查询方法
	});
})



/// 加载医学查房日期列表
function LoadPerPharSerDetail(EpisodeID){
	runClassMethod("web.DHCCM.DrugAdvice","jsonMedMedicalWard",{"EpisodeID":EpisodeID,"SearchInfo":""},function(jsonObj){
		if(jsonObj.total==0){
		      var noJsonObj=[{"text":"暂无查房信息!"}]
		      treeDataBind(noJsonObj);
	      }
	      else{
	       	  treeDataBind(jsonObj);
	      }
	});
};
///给树绑定数据
function treeDataBind(jsonObj){
	var json=[{"text":"医学查房","children":jsonObj}] //拼接json串
	$("#dv").tree({
		data:json,
		state:open,
		animate:true,
		onClick:function(rowData){
			var datetime=rowData.text; 
			$("input[id='check']").attr("checked",false);
		    FunTimeFind(datetime,EpisodeID);
	    }
	});
}

///查询方法
function FindInfo(EpisodeID,SearchInfo){
	runClassMethod("web.DHCCM.DrugAdvice","jsonMedMedicalWard",{"EpisodeID":EpisodeID,"SearchInfo":SearchInfo},function(jsonObj){
		//查询之后清空查房内容
	    $("#mcontent").html("");
		$("#div_01").css("display","none");
	    if(jsonObj==""){
		    var noJsonObj=[{"text":"暂无查房信息!"}]
		    treeDataBind(noJsonObj);
	    }
	    else{
	       	treeDataBind(jsonObj);
	    }
	});
};

///加载查房内容
function FunTimeFind(DateTime,EpisodeID){
	runClassMethod("web.DHCCM.DrugAdvice","getMedicalWardItm",{"date":DateTime,"EpisodeID":EpisodeID},function(jsonObj){
		var rowNums=jsonObj.total; //数据行数
	    if(rowNums>0){
		   $("#div_01").css("display","block");
	    }
	    else{
		   $.messager.show({
				title:'提示信息',
				msg:'当天没有查房内容!!'
			});
	    }
	    $("#mcontent").html("");
	    for(i=0;i<rowNums;i++){
		    if(jsonObj.rows[i].phcpDouLunBrePho==""||jsonObj.rows[i].phcpRale==""||jsonObj.rows[i].phcpArrhythmia==""||jsonObj.rows[i].phcpPathMurmur==""||jsonObj.rows[i].phcpBelly==""||jsonObj.rows[i].phcpOedema==""||jsonObj.rows[i].phcpPerPain==""||jsonObj.rows[i].phcpRale==""){
			    $('<tr>'
			    +	'<td><input type="checkbox" onchange="changestatue(this)" id="medcheck" style="cursor:pointer"/>&nbsp;<font style="color:#FF0000;"><b>选择</b></font></td>'
			    +'</tr>'
		    	+'<tr>'
		    	+	'<td style="display: block;margin-top:8px;">1、生命体征情况</td>'
		    	+'</tr>'
				+'<tr>'
				+	'<td>'
				+		'<div id="divText" style="margin: 5px 0px 5px 0px;width:280px;height:auto;px;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;"></p>'
				+		'</div>'
				+	'</td>'
				+'</tr>'
				+'<tr><td style="display: block;margin-top:8px;">2、主要病情变化</td></tr>'
				+'<tr><td><div style="margin: 5px 0px 5px 0px;width:280px;height:auto;px;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'+jsonObj.rows[i].phcpChaOfDisDesc+'</p></div></td></tr>'
				+'<tr><td style="display: block;margin-top:8px;">3、治疗方案</td></tr>'
				+'<tr><td><div style="margin: 5px 0px 5px 0px;width:280px;height:auto;px;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'+jsonObj.rows[i].phcpGuidance+'</p></div></td></tr>').appendTo("#mcontent")
		    }
		    else{
			    $('<tr>'
			    +	'<td><input type="checkbox" onchange="changestatue(this)" id="medcheck" style="cursor:pointer"/>&nbsp;<font style="color:#FF0000;"><b>选择</b></font></td>'
		    	+'</tr>'
		    	+'<tr>'
		    	+	'<td style="display: block;margin-top:8px;">1、生命体征情况</td>'
		    	+'</tr>'
				+'<tr>'
				+	'<td>'
				+		'<div id="divText" style="margin: 5px 0px 5px 0px;width:280px;height:auto;px;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'
				+			'<span>1.双肺呼吸音:</span>'+jsonObj.rows[i].phcpDouLunBrePho+'<br/>'
				+			'<span>2.啰音:</span>'+jsonObj.rows[i].phcpRale+'<br/>'
				+			'<span>3.心律:</span>'+jsonObj.rows[i].phcpArrhythmia+'<br/>'
				+			'<span>4.各瓣膜听诊区、病理性杂音:</span>'+jsonObj.rows[i].phcpPathMurmur+'<br/>'
				+			'<span>5.腹部:</span>'+jsonObj.rows[i].phcpBelly+'<br/>'
				+			'<span>6.肝脾肋下:</span>'+jsonObj.rows[i].phcpOedema+'<br/>'
				+			'<span>7.双肾区叩击痛:</span>'+jsonObj.rows[i].phcpPerPain+'<br/>'
				+			'<span>8.双下肢水肿:</span>'+jsonObj.rows[i].phcpRale
				+		'</p></div>'
				+	'</td>'
				+'</tr>'
				+'<tr><td style="display: block;margin-top:8px;">2、主要病情变化</td></tr>'
				+'<tr><td><div style="margin: 5px 0px 5px 0px;width:280px;height:auto;px;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'+jsonObj.rows[i].phcpChaOfDisDesc+'</p></div></td></tr>'
				+'<tr><td style="display: block;margin-top:8px;">3、治疗方案</td></tr>'
				+'<tr><td><div style="margin: 5px 0px 5px 0px;width:280px;height:auto;px;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'+jsonObj.rows[i].phcpGuidance+'</p></div></td></tr>').appendTo("#mcontent")
		    }
	    }

	});
};

///引用查房内容
function UserAdvices(){
	var allData="";
	var num=""
	var ale=$("input[type='checkbox']");
	for(var i=0;i<ale.length;i++)
	{
		if(ale.eq(i).is(":Checked")==true){
			allData+=ale.eq(i).parent().parent().next().children().children().text()+','; //查房内容
			num=num*1+1;
		}
	}
	var adviceData=allData.substring(0,allData.length-1) //引用的建议内容
	if(num==""){
		$.messager.show({
			title:'提示信息',
			msg:'请至少选择一项查房信息引用到药历!'
		});
	}
	else{
		var refScheme = getRefScheme("scheme>reference>parent>item");
		var refSubScheme = getRefScheme("scheme>reference>child>item");
		var separate = $(strXml).find("scheme>reference>separate").text();
		separate = separate=="enter"?"\n":separate;
		var advice=adviceData+separate;
		var param = {"action":"insertText","text":advice}
		parent.eventDispatch(param); 
		$.messager.show({
			title:'提示信息',
			msg:'查房信息引用成功!'
		});
	}
};


// 选择全选时,确定checkbox的选中状态和输入框的颜色
function selectall()
{
	$("#check").click(function(){
		var len=$("input[id='medcheck']").length;
		if($("input[id='check']").is(":checked")==true){
			for(var i=0;i<len;i++){
				$("input[id='medcheck']").eq(i).attr("checked",true);
				$("input[id='medcheck']").eq(i).parent().parent().next().next().children().children().css("background","#98FB98");
				$("input[id='medcheck']").eq(i).parent().parent().next().next().next().next().children().children().css("background","#98FB98");
				$("input[id='medcheck']").eq(i).parent().parent().next().next().next().next().next().next().children().children().css("background","#98FB98");
			}
		}
		else{
			for(var j=0;j<len;j++){
				$("input[id='medcheck']").eq(j).attr("checked",false);
				$("input[id='medcheck']").eq(j).parent().parent().next().next().children().children().css("background","white");
				$("input[id='medcheck']").eq(j).parent().parent().next().next().next().next().children().children().css("background","white");
				$("input[id='medcheck']").eq(j).parent().parent().next().next().next().next().next().next().children().children().css("background","white");
			}
		}
	});
}

// 通过判断checkbox的状态个数,确定是否选中全选的checkbox
function changestatue(obj)
{
	var foucs=$(obj).parent().parent().next().next()
	var len=$("input[id='medcheck']").length;
	var num=0;
	for(var i=0;i<len;i++){
		if($("input[id='medcheck']").eq(i).is(":checked")==true){
			num+=1;
		}
	}
	if(num==len){
		$("input[id='check']").attr("checked",true);
	}
	else{
		$("input[id='check']").attr("checked",false);
	}
	if ($(obj).is(":checked")==true)
	{
		foucs.children().children().css("background","#98FB98");
		foucs.next().next().children().children().css("background","#98FB98");
		foucs.next().next().next().next().children().children().css("background","#98FB98");
	
	}
	else
	{
		foucs.children().children().css("background","white");
		foucs.next().next().children().children().css("background","white");
		foucs.next().next().next().next().children().children().css("background","white");
	}
}

// 引用
function recommend()
{
	var len=$("input[id='medcheck']").length;
	var result=""
	for(var i=0;i<len;i++)
	{
		if ($("input[id='medcheck']").eq(i).is(":checked")==true)
		{
			var medobj=$("input[id='medcheck']").eq(i).parent().parent().next().next();
			result=result+medobj.children().children().text();
			result=result+medobj.next().next().children().children().text();
			result=result+medobj.next().next().next().children().children().text();
			result=result+medobj.next().next().next().next().children().children().text();
		}
	}
	
	var param = {"action":"insertText","text":result}
	parent.eventDispatch(param);
	clearcheckbox();
}

