var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;font-size:10pt;font-family:���Ŀ���;color:red;">[����]</span>'
var EpisodeID=episodeID;
$(function(){
	LoadPerPharSerDetail(EpisodeID); //��������
	///����
	$("#btnUser").on("click",function(){
		recommend(); //���ò鷿��Ϣ
	});
	
	selectall();		  // ѡ��ҳ���ϵ�����checkbox
	
	///��ѯ
	$("#searchInfo").keyup(function(){
		var searchInfo=$("#searchInfo").val().trim(); //��������
		FindInfo(EpisodeID,searchInfo); //��ѯ����
	});
})



/// ����ҽѧ�鷿�����б�
function LoadPerPharSerDetail(EpisodeID){
	runClassMethod("web.DHCCM.DrugAdvice","jsonMedMedicalWard",{"EpisodeID":EpisodeID,"SearchInfo":""},function(jsonObj){
		if(jsonObj.total==0){
		      var noJsonObj=[{"text":"���޲鷿��Ϣ!"}]
		      treeDataBind(noJsonObj);
	      }
	      else{
	       	  treeDataBind(jsonObj);
	      }
	});
};
///����������
function treeDataBind(jsonObj){
	var json=[{"text":"ҽѧ�鷿","children":jsonObj}] //ƴ��json��
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

///��ѯ����
function FindInfo(EpisodeID,SearchInfo){
	runClassMethod("web.DHCCM.DrugAdvice","jsonMedMedicalWard",{"EpisodeID":EpisodeID,"SearchInfo":SearchInfo},function(jsonObj){
		//��ѯ֮����ղ鷿����
	    $("#mcontent").html("");
		$("#div_01").css("display","none");
	    if(jsonObj==""){
		    var noJsonObj=[{"text":"���޲鷿��Ϣ!"}]
		    treeDataBind(noJsonObj);
	    }
	    else{
	       	treeDataBind(jsonObj);
	    }
	});
};

///���ز鷿����
function FunTimeFind(DateTime,EpisodeID){
	runClassMethod("web.DHCCM.DrugAdvice","getMedicalWardItm",{"date":DateTime,"EpisodeID":EpisodeID},function(jsonObj){
		var rowNums=jsonObj.total; //��������
	    if(rowNums>0){
		   $("#div_01").css("display","block");
	    }
	    else{
		   $.messager.show({
				title:'��ʾ��Ϣ',
				msg:'����û�в鷿����!!'
			});
	    }
	    $("#mcontent").html("");
	    for(i=0;i<rowNums;i++){
		    if(jsonObj.rows[i].phcpDouLunBrePho==""||jsonObj.rows[i].phcpRale==""||jsonObj.rows[i].phcpArrhythmia==""||jsonObj.rows[i].phcpPathMurmur==""||jsonObj.rows[i].phcpBelly==""||jsonObj.rows[i].phcpOedema==""||jsonObj.rows[i].phcpPerPain==""||jsonObj.rows[i].phcpRale==""){
			    $('<tr>'
			    +	'<td><input type="checkbox" onchange="changestatue(this)" id="medcheck" style="cursor:pointer"/>&nbsp;<font style="color:#FF0000;"><b>ѡ��</b></font></td>'
			    +'</tr>'
		    	+'<tr>'
		    	+	'<td style="display: block;margin-top:8px;">1�������������</td>'
		    	+'</tr>'
				+'<tr>'
				+	'<td>'
				+		'<div id="divText" style="margin: 5px 0px 5px 0px;width:280px;height:auto;px;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;"></p>'
				+		'</div>'
				+	'</td>'
				+'</tr>'
				+'<tr><td style="display: block;margin-top:8px;">2����Ҫ����仯</td></tr>'
				+'<tr><td><div style="margin: 5px 0px 5px 0px;width:280px;height:auto;px;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'+jsonObj.rows[i].phcpChaOfDisDesc+'</p></div></td></tr>'
				+'<tr><td style="display: block;margin-top:8px;">3�����Ʒ���</td></tr>'
				+'<tr><td><div style="margin: 5px 0px 5px 0px;width:280px;height:auto;px;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'+jsonObj.rows[i].phcpGuidance+'</p></div></td></tr>').appendTo("#mcontent")
		    }
		    else{
			    $('<tr>'
			    +	'<td><input type="checkbox" onchange="changestatue(this)" id="medcheck" style="cursor:pointer"/>&nbsp;<font style="color:#FF0000;"><b>ѡ��</b></font></td>'
		    	+'</tr>'
		    	+'<tr>'
		    	+	'<td style="display: block;margin-top:8px;">1�������������</td>'
		    	+'</tr>'
				+'<tr>'
				+	'<td>'
				+		'<div id="divText" style="margin: 5px 0px 5px 0px;width:280px;height:auto;px;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'
				+			'<span>1.˫�κ�����:</span>'+jsonObj.rows[i].phcpDouLunBrePho+'<br/>'
				+			'<span>2.����:</span>'+jsonObj.rows[i].phcpRale+'<br/>'
				+			'<span>3.����:</span>'+jsonObj.rows[i].phcpArrhythmia+'<br/>'
				+			'<span>4.����Ĥ������������������:</span>'+jsonObj.rows[i].phcpPathMurmur+'<br/>'
				+			'<span>5.����:</span>'+jsonObj.rows[i].phcpBelly+'<br/>'
				+			'<span>6.��Ƣ����:</span>'+jsonObj.rows[i].phcpOedema+'<br/>'
				+			'<span>7.˫����ߵ��ʹ:</span>'+jsonObj.rows[i].phcpPerPain+'<br/>'
				+			'<span>8.˫��֫ˮ��:</span>'+jsonObj.rows[i].phcpRale
				+		'</p></div>'
				+	'</td>'
				+'</tr>'
				+'<tr><td style="display: block;margin-top:8px;">2����Ҫ����仯</td></tr>'
				+'<tr><td><div style="margin: 5px 0px 5px 0px;width:280px;height:auto;px;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'+jsonObj.rows[i].phcpChaOfDisDesc+'</p></div></td></tr>'
				+'<tr><td style="display: block;margin-top:8px;">3�����Ʒ���</td></tr>'
				+'<tr><td><div style="margin: 5px 0px 5px 0px;width:280px;height:auto;px;border:1px solid #87CEEB;border-radius:5px;">'+'<p style="font-Size:12px;padding-left:5px;">'+jsonObj.rows[i].phcpGuidance+'</p></div></td></tr>').appendTo("#mcontent")
		    }
	    }

	});
};

///���ò鷿����
function UserAdvices(){
	var allData="";
	var num=""
	var ale=$("input[type='checkbox']");
	for(var i=0;i<ale.length;i++)
	{
		if(ale.eq(i).is(":Checked")==true){
			allData+=ale.eq(i).parent().parent().next().children().children().text()+','; //�鷿����
			num=num*1+1;
		}
	}
	var adviceData=allData.substring(0,allData.length-1) //���õĽ�������
	if(num==""){
		$.messager.show({
			title:'��ʾ��Ϣ',
			msg:'������ѡ��һ��鷿��Ϣ���õ�ҩ��!'
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
			msg:'�鷿��Ϣ���óɹ�!'
		});
	}
};


// ѡ��ȫѡʱ,ȷ��checkbox��ѡ��״̬����������ɫ
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

// ͨ���ж�checkbox��״̬����,ȷ���Ƿ�ѡ��ȫѡ��checkbox
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

// ����
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

