///creator:dws
///2016-10-26  资源区-用药建议引用
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;font-size:10pt;font-family:华文楷体;color:red;">[单击]</span>'
var EpisodeID=episodeID;

$(function(){
	LoadPerPharSerDetail(EpisodeID); //加载日期
	///引用
	$("#btnUser").on("click",function(){
		UserAdvices(); //引用建议
	});
	///全选/反选
	$("input[id='right']").on("click",function(){
		if(this.checked==true){
			$("input[type='checkbox']").each(function(){
				this.checked=true;
			});
		}
		else{
			$("input[type='checkbox']").each(function(){
				this.checked=false;
			});
		}
		CheckAll();
	});
	///查询
	$("#searchInfo").keyup(function(){
		var searchInfo=$("#searchInfo").val().trim(); //搜索内容
		FindInfo(EpisodeID,searchInfo); //查询方法
	});
})



/// 加载建议日期列表
function LoadPerPharSerDetail(EpisodeID){
	runClassMethod("web.DHCCM.DrugAdvice","jsonMedAdvice",{"EpisodeID":EpisodeID,"SearchInfo":""},function(jsonObj){
		//alert(jsonObj.total)
		if(jsonObj.total==0){
		      var noJsonObj=[{"text":"暂无建议!"}]
		      treeDataBind(noJsonObj);
	      }
	      else{
	       	  treeDataBind(jsonObj);
	      }
	});
};
///给树绑定数据
function treeDataBind(jsonObj){
	var json=[{"text":"用药建议","children":jsonObj}] //拼接json串
	$("#dv").tree({
		data:json,
		state:open,
		animate:true,
		onClick:function(rowData){
			var datetime=rowData.text; 
		    FunTimeFind(datetime,EpisodeID);
	    }
	});
}

///查询方法
function FindInfo(EpisodeID,SearchInfo){
	runClassMethod("web.DHCCM.DrugAdvice","jsonMedAdvice",{"EpisodeID":EpisodeID,"SearchInfo":SearchInfo},function(jsonObj){
		//查询之后清空建议内容
	    $("#mcontent").html("");
		$("#div_01").css("display","none");
	    if(jsonObj==""){
		    var noJsonObj=[{"text":"暂无建议!"}]
		    treeDataBind(noJsonObj);
	    }
	    else{
	       	treeDataBind(jsonObj);
	    }
	});
};

///加载建议内容
function FunTimeFind(DateTime,EpisodeID){
	runClassMethod("web.DHCCM.DrugAdvice","getPHMedAdvDrgItm",{"date":DateTime,"EpisodeID":EpisodeID},function(jsonObj){
		var rowNums=jsonObj.total; //数据行数
	    if(rowNums>0){
		   $("#div_01").css("display","block");
	    }
	    else{
		   $.messager.show({
				title:'提示信息',
				msg:'当天没有建议内容!!'
			});
	    }
	    $("#mcontent").html("");
	    
	    for(i=0;i<rowNums;i++){
		    $('<tr><td><input type="checkbox" id="chb" class="ace" onchange="CheckBox(this)" style="cursor:pointer"/>'
		    +'<span onclick="drugChe(this)" style="cursor:pointer;">'+jsonObj.rows[i].inciDesc+'</span>'
		    +'</td></tr>'
		    +'<tr><td><textarea class="form-control" placeholder="用药建议:" style="width:265px;height:100px;" readonly="readonly" onclick="CheckAllTa(this)">'+jsonObj.rows[i].phadAdvice+'</textarea></td></tr>').appendTo("#mcontent")
	    }
	});
};

///引用建议
function UserAdvices(){
	var allData="";
	var num=""
	var ale=$("input[type='checkbox']");
	for(var i=0;i<ale.length;i++)
	{
		if(ale.eq(i).is(":Checked")==true){
			allData+=ale.eq(i).parent().parent().next().children().children().text()+','; //建议内容
			num=num*1+1;
		}
	}
	var adviceData=allData.substring(0,allData.length-1) //引用的建议内容
	if(num==""){
		$.messager.show({
			title:'提示信息',
			msg:'请至少选择一项建议引用到病历!'
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
			msg:'用药建议引用成功!'
		});
	}
};

///多选
function CheckAll(){
	//控制选中的textarea背景色
	var ale=$("input[type='checkbox']")
	for(var i=0;i<ale.length;i++){
		var textareas=ale.eq(i).parent().parent().next().children().children();
		var drugname=ale.eq(i).next();
		if(ale.eq(i).is(":checked")==true)
		{
			textareas.css("background","lightgreen");
			drugname.css("font-weight","bold");
		}
		else{
			textareas.css("background","#EEEEEE");
			drugname.css("font-weight","normal");
		}
	}
};

///点击textarea选中
function CheckAllTa(temps){
	var che=$(temps).parent().parent().prev().children().children().eq(0)
	var drugname=$(temps).parent().parent().prev().children().children().eq(1)
	if(che.is(":checked")==true){
		$(temps).css("background","#EEEEEE");
		drugname.css("font-weight","normal");
		che.attr("checked",false);
	}
	else{
		$(temps).css("background-color","lightgreen");
		drugname.css("font-weight","bold");
		che.attr("checked",true);
	}
}

///单选
function CheckBox(temp){
	var textarea=$(temp).parent().parent().next().children().children();
	var drugname=$(temp).next();
	if($(temp).is(":Checked")==false){
		textarea.css("background","#EEEEEE");
		drugname.css("font-weight","normal");
	}
	else{
		textarea.css("background","lightgreen");
		drugname.css("font-weight","bold");
	}
};

///点药品名称选中
function drugChe(drugtemp){
	 if($(drugtemp).prev().is(":checked")==true){
		$(drugtemp).parent().parent().next().children().children().css("background","#EEEEEE");
		$(drugtemp).css("font-weight","normal");
		$(drugtemp).prev().attr("checked",false);
	}
	else{
		$(drugtemp).parent().parent().next().children().children().css("background-color","lightgreen");
		$(drugtemp).css("font-weight","bold");
		$(drugtemp).prev().attr("checked",true);
	}
}

