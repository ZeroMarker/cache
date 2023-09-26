///creator:dws
///2016-10-26  ��Դ��-��ҩ��������
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;font-size:10pt;font-family:���Ŀ���;color:red;">[����]</span>'
var EpisodeID=episodeID;

$(function(){
	LoadPerPharSerDetail(EpisodeID); //��������
	///����
	$("#btnUser").on("click",function(){
		UserAdvices(); //���ý���
	});
	///ȫѡ/��ѡ
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
	///��ѯ
	$("#searchInfo").keyup(function(){
		var searchInfo=$("#searchInfo").val().trim(); //��������
		FindInfo(EpisodeID,searchInfo); //��ѯ����
	});
})



/// ���ؽ��������б�
function LoadPerPharSerDetail(EpisodeID){
	runClassMethod("web.DHCCM.DrugAdvice","jsonMedAdvice",{"EpisodeID":EpisodeID,"SearchInfo":""},function(jsonObj){
		//alert(jsonObj.total)
		if(jsonObj.total==0){
		      var noJsonObj=[{"text":"���޽���!"}]
		      treeDataBind(noJsonObj);
	      }
	      else{
	       	  treeDataBind(jsonObj);
	      }
	});
};
///����������
function treeDataBind(jsonObj){
	var json=[{"text":"��ҩ����","children":jsonObj}] //ƴ��json��
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

///��ѯ����
function FindInfo(EpisodeID,SearchInfo){
	runClassMethod("web.DHCCM.DrugAdvice","jsonMedAdvice",{"EpisodeID":EpisodeID,"SearchInfo":SearchInfo},function(jsonObj){
		//��ѯ֮����ս�������
	    $("#mcontent").html("");
		$("#div_01").css("display","none");
	    if(jsonObj==""){
		    var noJsonObj=[{"text":"���޽���!"}]
		    treeDataBind(noJsonObj);
	    }
	    else{
	       	treeDataBind(jsonObj);
	    }
	});
};

///���ؽ�������
function FunTimeFind(DateTime,EpisodeID){
	runClassMethod("web.DHCCM.DrugAdvice","getPHMedAdvDrgItm",{"date":DateTime,"EpisodeID":EpisodeID},function(jsonObj){
		var rowNums=jsonObj.total; //��������
	    if(rowNums>0){
		   $("#div_01").css("display","block");
	    }
	    else{
		   $.messager.show({
				title:'��ʾ��Ϣ',
				msg:'����û�н�������!!'
			});
	    }
	    $("#mcontent").html("");
	    
	    for(i=0;i<rowNums;i++){
		    $('<tr><td><input type="checkbox" id="chb" class="ace" onchange="CheckBox(this)" style="cursor:pointer"/>'
		    +'<span onclick="drugChe(this)" style="cursor:pointer;">'+jsonObj.rows[i].inciDesc+'</span>'
		    +'</td></tr>'
		    +'<tr><td><textarea class="form-control" placeholder="��ҩ����:" style="width:265px;height:100px;" readonly="readonly" onclick="CheckAllTa(this)">'+jsonObj.rows[i].phadAdvice+'</textarea></td></tr>').appendTo("#mcontent")
	    }
	});
};

///���ý���
function UserAdvices(){
	var allData="";
	var num=""
	var ale=$("input[type='checkbox']");
	for(var i=0;i<ale.length;i++)
	{
		if(ale.eq(i).is(":Checked")==true){
			allData+=ale.eq(i).parent().parent().next().children().children().text()+','; //��������
			num=num*1+1;
		}
	}
	var adviceData=allData.substring(0,allData.length-1) //���õĽ�������
	if(num==""){
		$.messager.show({
			title:'��ʾ��Ϣ',
			msg:'������ѡ��һ������õ�����!'
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
			title:'��ʾ��Ϣ',
			msg:'��ҩ�������óɹ�!'
		});
	}
};

///��ѡ
function CheckAll(){
	//����ѡ�е�textarea����ɫ
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

///���textareaѡ��
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

///��ѡ
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

///��ҩƷ����ѡ��
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

